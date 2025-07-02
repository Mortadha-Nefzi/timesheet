pipeline {
    agent any

    tools {
        // Refer to the name you gave your Maven installation in Jenkins -> Manage Jenkins -> Tools
        maven 'Maven_3.9.6' // Use the exact name you configured for Maven
        // Refer to the name you gave your JDK installation
        jdk 'JDK_17' // Use the exact name you configured for JDK 17
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Mortadha-Nefzi/timesheet.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install -DskipTests' // Builds the Spring Boot application, skips tests for now
            }
        }
    }
}