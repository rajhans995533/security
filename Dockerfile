FROM maven:3.5-jdk-8 as builder

ADD https://s3-us-west-2.amazonaws.com/gwos-docker/maven/mvn-env.tgz /root
RUN tar xfvz /root/mvn-env.tgz -C /root; rm -f /root/mvn-env.tgz

COPY . .
RUN mvn -o clean install


# Stage 2
FROM java:8-alpine


EXPOSE 8080