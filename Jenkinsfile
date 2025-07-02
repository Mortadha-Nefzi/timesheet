pipeline {
    agent any

    tools {
        maven 'Maven_3.9.6'
        jdk 'JDK_17'
    }

    stages {
        stage('GIT') {
            steps {
                echo "Cloning repository..."
                git 'https://github.com/Mortadha-Nefzi/timesheet.git'
            }
        }

        stage('MAVEN BUILD') {
            steps {
                echo "Running Maven clean install and skipping tests..."
                // -DskipTests=true tells Maven to skip running tests
                sh 'mvn clean install -DskipTests=true'
            }
        }

        // The SONARQUBE stage remains, as it typically runs analysis AFTER compilation,
        // and doesn't rely on test execution unless configured to analyze test coverage.
        stage('SONARQUBE') {
            steps {
                script {
                    def mvnHome = tool 'Maven_3.9.6'
                    echo "Running SonarQube analysis..."
                    withSonarQubeEnv('SonarQubeServer') {
                        // SonarQube analysis might also run tests or need test compilation.
                        // If SonarQube fails because tests aren't compiled or run,
                        // we might need to adjust this. For now, assuming it's fine.
                        sh "${mvnHome}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=Timesheet -Dsonar.projectName='Timesheet'"
                    }
                }
            }
        }

        // The MOCKITO stage is REMOVED, as requested.

        stage('DOCKER IMAGE') {
            steps {
                script {
                    echo "Building Docker image for the application..."
                    def appImage = "timesheet-app:${env.BUILD_NUMBER}"
                    sh "docker build -t ${appImage} ."
                    echo "Docker image ${appImage} built successfully."
                }
            }
        }

        stage('DOCKER-COMPOSE') {
            steps {
                script {
                    echo "Deploying application with Docker Compose..."
                    sh "docker-compose down"
                    sh "docker-compose up -d"
                    echo "Application deployed with Docker Compose."
                }
            }
        }

        stage('GRAFANA') {
            steps {
                echo "Grafana and Prometheus monitoring for Jenkins configured."
                echo "You can now view metrics:"
                echo "  - Jenkins UI (Prometheus Metrics Plugin): http://192.168.50.4:8080/prometheus"
                echo "  - Prometheus UI (Targets & Querying): http://192.168.50.4:9090"
                echo "  - Grafana UI (Dashboards): http://192.168.50.4:3000 (login admin/admin)"
            }
        }
    }
}
