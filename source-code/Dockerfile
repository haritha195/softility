FROM maven:3.9.6-amazoncorretto-17-al2023 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src

RUN mvn test

FROM openjdk:23-slim-bullseye AS runtime

COPY --from=build /app/target/*.jar /app.jar

CMD ["java", "-jar", "/app.jar"]
