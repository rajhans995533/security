FROM maven:3.5-jdk-8 as builder

ADD https://s3-us-west-2.amazonaws.com/gwos-docker/maven/mvn-env.tgz /root
RUN tar xfvz /root/mvn-env.tgz -C /root; rm -f /root/mvn-env.tgz

WORKDIR /src/groundwork/
COPY . .
RUN mvn  clean install


# Stage 2
FROM java:8-alpine

ENV LANG="en_US.UTF-8"
ENV SERVER_PORT="8080"
ENV SERVER_ADDRESS="0.0.0.0"
ENV MAVEN_OPTS="-server -Xmx512m -Djava.net.preferIPv4Stack=true"
ENV PGDATABASE="gwcollagedb"
ENV POSTGRES_DB="gwcollagedb"

COPY --from=builder /src/groundwork/ /src/groundwork/
COPY --from=builder /root/ /root/
WORKDIR /src/groundwork/gw-server

RUN apk update && apk add curl

HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl -i localhost:8080/index.html || exit 1

ARG BRANCH
ARG COMMIT_HASH
ARG TRAVIS_COMMIT
ARG TRAVIS_COMMIT_MESSAGE
ARG TRAVIS_BUILD_ID
ARG TRAVIS_JOB_ID
ARG TRAVIS_JOB_WEB_URL
ARG TRAVIS_TAG

ENV BRANCH "${BRANCH}"
ENV COMMIT_HASH "${COMMIT_HASH}"
ENV TRAVIS_BUILD_ID "${TRAVIS_BUILD_ID}"
ENV TRAVIS_COMMIT "${TRAVIS_COMMIT}"
ENV TRAVIS_COMMIT_MESSAGE "${TRAVIS_COMMIT_MESSAGE}"
ENV TRAVIS_JOB_ID "${TRAVIS_JOB_ID}"
ENV TRAVIS_JOB_WEB_URL "${TRAVIS_JOB_WEB_URL}"

RUN addgroup -g 1000 groundwork && adduser -u 1000 -G groundwork -D -H groundwork
USER groundwork
CMD java -DGROUNDWORK_CONFIG=/usr/local/groundwork/config -DGROUNDWORK_OUTPUT=/tmp -Djava.net.preferIPv4Stack=true -jar target/gw-server-8.0.0-SNAPSHOT.jar
EXPOSE 8080