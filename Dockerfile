# Stage 1: Build the Spring Boot application
# Use a Maven base image to build the JAR
FROM maven:3.9.5-amazoncorretto-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven pom.xml and download dependencies
# This step is cached if pom.xml doesn't change, speeding up subsequent builds
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the application source code
COPY src ./src

# Build the Spring Boot application into an executable JAR
RUN mvn clean install -DskipTests

# Stage 2: Create the final production image
# Use a smaller, secure JRE base image for the final application
FROM amazoncorretto:17-alpine-jdk

# Set the working directory
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port your Spring Boot application runs on (default is 8080)
EXPOSE 8080

# Command to run the Spring Boot application when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]
