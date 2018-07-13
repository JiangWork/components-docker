FROM openjdk:7-jre-alpine

ENV REDIS_HOSTS="10.9.245.191:7000,10.9.245.191:7001,10.9.245.197:7000,10.9.245.197:7001,10.9.245.198:7000,10.9.245.198:7001"
ENV APP=datacrawler.docker
ENV APP_HOME=/usr/share/$APP

# install git
RUN apk --update add git openssh && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

COPY $APP.tar.gz /usr/share/

WORKDIR /usr/share
RUN tar -xzvf $APP.tar.gz \
    && rm $APP.tar.gz \
    && mkdir /root/.ssh \
    && cp $APP/git-keys/* /root/.ssh/ \
    && chmod 600 /root/.ssh/id_rsa

WORKDIR $APP_HOME

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "startup"]
#CMD ["/bin/sh",  "startup"]
