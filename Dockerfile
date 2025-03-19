# Use an official JDK image as the base image
FROM eclipse-temurin:21-jdk AS build

# Set working directory inside the container
WORKDIR /app

# Copy Maven Wrapper and project files
COPY . .

# Grant execute permission to mvnw
RUN chmod +x mvnw

# Build the application and package it as a .jar
RUN ./mvnw clean package -DskipTests

# Use a minimal JDK image for the final container
FROM eclipse-temurin:21-jre

# Set working directory
WORKDIR /app

# Copy the built .jar file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
