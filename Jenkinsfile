pipeline {
    agent any

    tools {
        maven 'Maven_3.9.6'
        jdk 'JDK_17'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Mortadha-Nefzi/timesheet.git'
            }
        }

        stage('Build') {
            steps {
                // Ensure no -X flag or other Nexus-specific arguments here
                sh 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def mvnHome = tool 'Maven_3.9.6'
                    withSonarQubeEnv('SonarQubeServer') {
                        sh "${mvnHome}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=Timesheet -Dsonar.projectName='Timesheet'"
                    }
                }
            }
        }
        // The 'Deploy to Nexus' stage is completely removed from here.
    }
}