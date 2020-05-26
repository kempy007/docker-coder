FROM registry.access.redhat.com/ubi8/ubi:8.2

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 /bin/dumb-init
ADD runcontainer.sh /coder/runcontainer.sh

RUN chmod +x /bin/dumb-init; \
    curl -sSOL https://github.com/cdr/code-server/releases/download/v3.3.1/code-server-3.3.1-amd64.rpm; \
    yum install -y code-server-3.3.1-amd64.rpm golang delve bash git python36 java-11-openjdk nodejs make gcc libffi-devel python36u-devel openssl-devel; \
    rm -f code-server-3.3.1-amd64.rpm; \
    curl -L https://aka.ms/InstallAzureCli | bash ;\
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl ;\
    chmod +x ./kubectl ;\
    mv ./kubectl /usr/local/bin/kubectl ;\
    curl -LO https://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.9rel.1.tar.gz && tar -zxvf lynx2.8.9rel.1.tar.gz && rm -f lynx2.8.9rel.1.tar.gz ;\
    yum clean all; \
    rm -rf /var/cache/yum; \
    mkdir /coder; \
    chgrp -R 0 /coder; \
    chmod -R g+rwX /coder; \
    mkdir /home/user; \
    chgrp -R 0 /home/user; \
    chmod -R g+rwX /home/user; \
    chmod 777 /coder/runcontainer.sh; \
	chmod g+w /etc/passwd; \
    groupmod -g 92 audio; \
	groupmod -g 91 video; \
	groupadd -r -g 1001 user; \
	useradd -m -r -g 1001 -u 1001 user; \
	usermod -G root,user,wheel user; \
    code-server --install-extension bierner.markdown-preview-github-styles; \
    code-server --install-extension DavidAnson.vscode-markdownlint; \
    code-server --install-extension hediet.vscode-drawio; \
    code-server --install-extension marlon407.code-groovy; \
    code-server --install-extension ms-kubernetes-tools.vscode-kubernetes-tools; \
    code-server --install-extension ms-vscode.Go; \
    code-server --install-extension redhat.java; \
    code-server --install-extension redhat.vscode-yaml; \
    code-server --install-extension SonarSource.sonarlint-vscode; \
    code-server --install-extension streetsidesoftware.code-spell-checker

WORKDIR /coder

EXPOSE 8080 2345

USER 1001

CMD [ "/bin/bash", "runcontainer.sh" ]