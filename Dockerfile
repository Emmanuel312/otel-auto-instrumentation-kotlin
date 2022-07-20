FROM openjdk:11-jdk-slim as app-builder
WORKDIR /tmp
COPY . .
RUN ./gradlew assemble

FROM openjdk:11-jre-slim-buster
WORKDIR /srv
COPY --from=app-builder /tmp/build/libs/app.jar .
COPY --from=app-builder /tmp/opentelemetry-javaagent.jar .
CMD java -javaagent:opentelemetry-javaagent.jar -Dotel.metrics.exporter="otlp" -Dotel.exporter.otlp.endpoint="http://collector:4317" -jar app.jar