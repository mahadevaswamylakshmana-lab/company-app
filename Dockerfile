FROM eclipse-temurin:21-jre

WORKDIR /app

COPY company-app-1.0.jar app.jar

CMD ["java", "-jar", "app.jar"]
