#build stage
FROM maven as build
WORKDIR /build
COPY . .
RUN mvn install


#deploy stage
FROM openjdk:17-alpine
WORKDIR /app
COPY --from=build /build/target/counterApp.jar  .
EXPOSE 8888
ENTRYPOINT ["java", "-jar", "counterApp.jar"]
