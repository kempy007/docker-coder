FROM registry.access.redhat.com/ubi8/ubi:8.2

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 /bin/dumb-init

RUN chmod 777 /bin/dumb-init; \
    curl -sSOL https://github.com/cdr/code-server/releases/download/v3.3.1/code-server-3.3.1-amd64.rpm; \
    yum install -y code-server-3.3.1-amd64.rpm golang delve bash; \
    rm -f code-server-3.3.1-amd64.rpm; \
    yum clean all; \
    rm -rf /var/cache/yum; \
    mkdir /coder; \
    chgrp -R 0 /coder; \
    chmod -R g+rwX /coder; \
    mkdir /home/user; \
    chgrp -R 0 /home/user; \
    chmod -R g+rwX /home/user; \
    chmod 777 /runcontainer.sh; \
	chmod g+w /etc/passwd

ADD runcontainer.sh /coder/runcontainer.sh

WORKDIR /coder

EXPOSE 8080 2345
#USER coder
#WORKDIR /home/coder
#ENTRYPOINT ["dumb-init" "fixuid" "-q" "/usr/bin/code-server" "--bind-addr" "0.0.0.0:8080" "."]
#ENTRYPOINT ["/bin/sh", "-c", "/bin/bash"]
#CMD ["dumb-init", "code-server" "--bind-addr" "0.0.0.0:8080" "."]

USER 1001

CMD [ "/bin/bash", "runcontainer.sh" ]