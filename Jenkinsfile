pipeline {
    agent any

    tools {
        // IMPORTANT: Replace 'Maven_3.9.6' with the EXACT name you configured for Maven in Jenkins
        // Go to Manage Jenkins -> Tools -> Maven installations to verify the name.
        maven 'Maven_3.9.6'
        // IMPORTANT: Replace 'JDK_17' with the EXACT name you configured for JDK 17 in Jenkins
        // Go to Manage Jenkins -> Tools -> JDK installations to verify the name.
        jdk 'JDK_17'
    }

    stages {
        stage('Checkout') {
            steps {
                // Ensure this URL is correct for your GitHub repository
                git 'https://github.com/Mortadha-Nefzi/timesheet.git'
            }
        }

        stage('Build') {
            steps {
                // This command builds your project. Removed -DskipTests to allow SonarQube to analyze tests.
                sh 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // This 'script' block is crucial. It allows for variable declarations (like 'def mvnHome')
                // within a declarative pipeline's 'steps' section.
                script {
                    // This line gets the path to your configured Maven installation.
                    // Make sure 'Maven_3.9.6' here matches the name you set in Jenkins' global tool configuration.
                    def mvnHome = tool 'Maven_3.9.6'

                    // This step integrates with your SonarQube server.
                    // 'SonarQubeServer' MUST match the 'Name' you gave your SonarQube instance in
                    // Jenkins -> Manage Jenkins -> Configure System -> SonarQube servers.
                    withSonarQubeEnv('SonarQubeServer') {
                        // This executes the Maven command to run the SonarQube analysis.
                        // Ensure 'Timesheet' for projectKey and projectName matches what you set in SonarQube.
                        sh "${mvnHome}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=Timesheet -Dsonar.projectName='Timesheet'"
                    }
                }
            }
        }
    }
}