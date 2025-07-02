pipeline {
    agent any

    tools {
        // Ensure these names match what you configured in Jenkins -> Manage Jenkins -> Tools
        maven 'Maven_3.9.6' // Replace with your actual Maven tool name if different
        jdk 'JDK_17' // Replace with your actual JDK tool name if different
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Mortadha-Nefzi/timesheet.git'
            }
        }

        stage('Build') {
            steps {
                // We'll remove -DskipTests here so tests can run for SonarQube coverage later
                sh 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // 'withSonarQubeEnv()' is a Jenkins Pipeline step provided by the SonarQube Scanner plugin
                // It automatically configures the environment variables (like sonar.host.url)
                // You need to configure the SonarQube server in Jenkins -> Manage Jenkins -> Configure System
                // (We will do this after updating the Jenkinsfile)

                // The 'tool' directive ensures the correct Maven version is used
                def mvnHome = tool 'Maven_3.9.6' // Use the exact name you configured for Maven
                withSonarQubeEnv('SonarQubeServer') { // 'SonarQubeServer' is the name we'll give the SonarQube server in Jenkins config
                    sh "${mvnHome}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=Timesheet -Dsonar.projectName='Timesheet'"
                }
            }
        }
    }
}