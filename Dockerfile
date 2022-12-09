FROM maven as build
WORKDIR /build
COPY . .
RUN mvn install

FROM openjdk:11
WORKDIR /app
COPY --from=build /build/target/Uber.jar  .
EXPOSE 8888
CMD ["java, "-jar", "Uber.jar"]