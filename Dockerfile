FROM alpine:edge
ENV USERNAME="user" \
    PASSWORD="Passw0rd" \
    SUDO_OK="false" \
    AUTOLOGIN="false" \
    TZ="Etc/UTC"

COPY ./entrypoint.sh /
COPY ./skel/ /etc/skel

RUN apk update && \
    apk add --no-cache tini bash ttyd tzdata sudo nano && \
    chmod 700 /entrypoint.sh && \
    touch /etc/.firstrun && \
    ln -s "/usr/share/zoneinfo/$TZ" /etc/localtime && \
    echo $TZ > /etc/timezone 

RUN mkdir /truffle
WORKDIR /truffle

RUN apk update && apk upgrade && apk add --no-cache bash git openssh
RUN apk add --update python3 krb5 krb5-libs gcc make g++ krb5-dev

RUN npm install pm2 -g
RUN npm install truffle -g
RUN npm install ganache-cli -g

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/entrypoint.sh"]

EXPOSE 7681/tcp

