FROM registry.access.redhat.com/ubi8/ubi:8.2

RUN curl -sSOL https://github.com/cdr/code-server/releases/download/v3.3.1/code-server-3.3.1-amd64.rpm; \
    yum install -y code-server-3.3.1-amd64.rpm golang delve; \
    rm -f code-server-3.3.1-amd64.rpm; \
    yum clean all; \
    rm -rf /var/cache/yum

#CMD /usr/bin/code-server
CMD code-server