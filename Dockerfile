
RUN mvn  clean install


# Stage 2
FROM java:8-alpine


EXPOSE 8080