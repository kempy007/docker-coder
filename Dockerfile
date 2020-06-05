FROM registry.access.redhat.com/ubi8/ubi:8.2

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 /bin/dumb-init
ADD runcontainer.sh /coder/runcontainer.sh

RUN chmod +x /bin/dumb-init                                                                                                     ;\
    curl -sSOL https://github.com/cdr/code-server/releases/download/v3.3.1/code-server-3.3.1-amd64.rpm                          ;\
    yum install -y code-server-3.3.1-amd64.rpm golang delve bash git python36 java-11-openjdk java-1.8.0-openjdk.x86_64         \
    maven nodejs make gcc libffi-devel python36-devel openssl-devel ncurses ncurses-devel wget unzip git dotnet                 ;\
    rm -f code-server-3.3.1-amd64.rpm                                                                                           ;\
    echo "yum installs done, Fetching Gradle"                                                                                   && \
    cd /opt && wget https://services.gradle.org/distributions/gradle-6.2.1-bin.zip                                              && \
    unzip gradle-6.2.1-bin.zip && rm -f gradle-6.2.1-bin.zip                                                                    && \
    ln -s /opt/gradle-6.2.1/bin/gradle /usr/local/bin/gradle                                                                    && \
    echo "Fetching Sonarqube ****# todo check if the properties file is really needed"                                          && \
    cd /opt && wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip      && \
    unzip sonar-scanner-cli-4.2.0.1873-linux.zip && rm -f sonar-scanner-cli-4.2.0.1873-linux.zip                                && \
    ln -s /opt/sonar-scanner-4.2.0.1873-linux/bin/sonar-scanner /usr/local/bin/sonar-scanner                                    && \
    echo "Fetching java nexus-iq cli   *****# todo create script and symlink"                                                   && \
    mkdir /opt/nexus-iq && cd /opt/nexus-iq && wget https://download.sonatype.com/clm/scanner/nexus-iq-cli-1.85.0-01.jar        && \
    echo "Fetching community nexus cli"                                                                                         && \
    mkdir /opt/nexus && cd /opt/nexus                                                                                           && \
    wget https://github.com/sonatype-nexus-community/nexus-cli/releases/download/v0.8.0/nexus_0.8.0_Linux_x86_64.tar.gz         && \
    tar -zxvf nexus_0.8.0_Linux_x86_64.tar.gz && rm -f nexus_0.8.0_Linux_x86_64.tar.gz                                          && \
    chown root:root nexus && chmod 777 nexus                                                                                    && \
    ln -s /opt/nexus/nexus /usr/local/bin/nexus                                                                                 && \
    echo "Fetching trivy"                                                                                                       && \
    mkdir /opt/trivy && cd /opt/trivy                                                                                           && \
    wget https://github.com/aquasecurity/trivy/releases/download/v0.4.4/trivy_0.4.4_Linux-64bit.tar.gz                          && \
    tar -zxvf trivy_0.4.4_Linux-64bit.tar.gz && rm -f trivy_0.4.4_Linux-64bit.tar.gz                                            && \
    chown root:root trivy && chmod 777 trivy                                                                                    && \
    ln -s /opt/trivy/trivy /usr/local/bin/trivy                                                                                 && \
    echo "Fetching vault"                                                                                                       && \
    mkdir /opt/vault && cd /opt/vault && wget https://releases.hashicorp.com/vault/1.3.2/vault_1.3.2_linux_amd64.zip            && \
    unzip vault_1.3.2_linux_amd64.zip && rm -f vault_1.3.2_linux_amd64.zip                                                      && \
    ln -s /opt/vault/vault /usr/local/bin/vault                                                                                 ;\ 
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl                          ;\
    chmod +x ./kubectl                                                                                                          ;\
    mv ./kubectl /usr/local/bin/kubectl                                                                                         ;\
    curl -LO https://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.9rel.1.tar.gz                                          ;\
    tar -zxvf lynx2.8.9rel.1.tar.gz && rm -f lynx2.8.9rel.1.tar.gz                                                              ;\
    cd /lynx2.8.9rel.1 && ./configure && make && make install && rm -rf /lynx2.8.9rel.1 && cd /                                 ;\
    yum clean all                                                                                                               ;\
    rm -rf /var/cache/yum                                                                                                       ;\
    mkdir /coder                                                                                                                ;\
    chgrp -R 0 /coder                                                                                                           ;\
    chmod -R g+rwX /coder                                                                                                       ;\
    mkdir /home/user                                                                                                            ;\
    chgrp -R 0 /home/user                                                                                                       ;\
    chmod -R g+rwX /home/user                                                                                                   ;\
    chmod 777 /coder/runcontainer.sh                                                                                            ;\
	chmod g+w /etc/passwd                                                                                                       ;\
    groupmod -g 92 audio                                                                                                        ;\
	groupmod -g 91 video                                                                                                        ;\
	groupadd -r -g 1001 user                                                                                                    ;\
	useradd -m -r -g 1001 -u 1001 user                                                                                          ;\
	usermod -G root,user,wheel user                                                                                             ;\
    pip3 install azure-cli

USER 1001
RUN code-server --install-extension bierner.markdown-preview-github-styles              ;\
    code-server --install-extension DavidAnson.vscode-markdownlint                      ;\
    code-server --install-extension hediet.vscode-drawio                                ;\
    code-server --install-extension marlon407.code-groovy                               ;\
    code-server --install-extension ms-kubernetes-tools.vscode-kubernetes-tools         ;\
    code-server --install-extension ms-vscode.Go                                        ;\
    code-server --install-extension redhat.java                                         ;\
    code-server --install-extension redhat.vscode-yaml                                  ;\
    code-server --install-extension SonarSource.sonarlint-vscode                        ;\
    code-server --install-extension streetsidesoftware.code-spell-checker

WORKDIR /coder

EXPOSE 8080 2345

CMD [ "/bin/bash", "runcontainer.sh" ]