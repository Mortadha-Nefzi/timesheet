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
                echo "Running Maven clean install..."
                sh 'mvn clean install'
            }
        }

        stage('SONARQUBE') {
            steps {
                script {
                    def mvnHome = tool 'Maven_3.9.6'
                    echo "Running SonarQube analysis..."
                    withSonarQubeEnv('SonarQubeServer') {
                        sh "${mvnHome}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=Timesheet -Dsonar.projectName='Timesheet'"
                    }
                }
            }
        }

        stage('MOCKITO') {
            steps {
                script {
                    def mvnHome = tool 'Maven_3.9.6'
                    echo "Executing Unit Tests (e.g., Mockito)..."
                    // Ensure tests are run and Surefire reports are generated
                    sh "${mvnHome}/bin/mvn test"
                    // Publish JUnit test results for Jenkins UI
                    junit 'target/surefire-reports/*.xml'
                    echo "Unit tests executed and results published."
                }
            }
        }

        stage('DOCKER IMAGE') {
            steps {
                script {
                    echo "Building Docker image for the application..."
                    def appImage = "timesheet-app:${env.BUILD_NUMBER}"
                    // Build the Docker image from the project root
                    sh "docker build -t ${appImage} ."
                    echo "Docker image ${appImage} built successfully."
                }
            }
        }

        stage('DOCKER-COMPOSE') {
            steps {
                script {
                    echo "Deploying application with Docker Compose..."
                    // Stop and remove existing containers defined in docker-compose.yml
                    sh "docker-compose down"
                    // Start services defined in docker-compose.yml in detached mode
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