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

        stage('Deploy to Nexus') { // <-- NEW STAGE ADDED HERE
            steps {
                script {
                    def mvnHome = tool 'Maven_3.9.6'
                    // The 'withMaven' step allows Jenkins to automatically inject Maven settings.xml
                    // with the credentials defined in Jenkins (ID: nexus-admin-credentials)
                    withMaven(maven: 'Maven_3.9.6', jdk: 'JDK_17', credentialsId: 'nexus-admin-credentials') {
                        // Maven deploy command. '-DskipTests' is often used here to skip re-running tests.
                        // Page 20 of 7- Nexus.pdf mentions "skipper les tests" here.
                        sh "${mvnHome}/bin/mvn deploy -DskipTests -X"
                    }
                }
            }
        }
    }
}