pipeline {
    agent any

    tools {
        maven 'Maven_3.9.6'
        jdk 'JDK_17'
    }

    environment {
        // This is the confirmed URL for your running Spring application via Docker Compose
        APP_URL = 'http://localhost:8082/timesheet-devops/user/retrieve-all-users'
        ZAP_INSTALL_PATH = '/home/vagrant/ZAP_2.16.1' // Path where you extracted ZAP
        ZAP_REPORT_FILE = 'zap_report.html' // Name of the ZAP report file
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
                echo "Running Maven clean install and OWASP Dependency-Check..."
                // Added org.owasp:dependency-check-maven:check to the mvn command
                sh 'mvn clean install org.owasp:dependency-check-maven:check -DskipTests=true'
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

        // New Stage: OWASP Dependency-Check Report
        stage('OWASP Dependency-Check Report') {
            steps {
                echo 'Publishing OWASP Dependency-Check Report...'
                // Dependency-Check generates reports in target/dependency-check-report.html by default
                publishHTML(target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'target', // Report is in target directory
                    reportFiles: 'dependency-check-report.html',
                    reportName: 'OWASP Dependency-Check Report'
                ])
            }
        }

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
                    sh "docker-compose down" // Ensure clean start
                    sh "docker-compose up -d" // Start services in detached mode
                    echo "Application deployed with Docker Compose."
                    // Give your Spring application time to fully start up and be ready for requests
                    sh 'sleep 30'
                    echo "Spring application should now be running and accessible at ${env.APP_URL}"
                }
            }
        }

        stage('OWASP ZAP DAST Scan') {
            steps {
                echo 'Starting OWASP ZAP scan on the deployed Spring application...'
                // Execute ZAP using the zap.sh from your manual installation
                // -port 8090 is for ZAP's internal proxy, not your app's port.
                // The quickurl points to your Spring app's endpoint.
                sh "${env.ZAP_INSTALL_PATH}/zap.sh -cmd -port 8090 -quickurl ${env.APP_URL} -quickprogress -quickout ${env.WORKSPACE}/${env.ZAP_REPORT_FILE}"
            }
        }

        stage('Publish ZAP Report') {
            steps {
                echo 'Publishing ZAP report...'
                // Ensure Jenkins HTML Publisher Plugin is installed (Manage Jenkins -> Plugins)
                publishHTML(target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: env.WORKSPACE, // ZAP report will be in the workspace root
                    reportFiles: env.ZAP_REPORT_FILE,
                    reportName: 'OWASP ZAP Scan Report'
                ])
            }
        }

        stage('GRAFANA') {
            steps {
                echo "Grafana and Prometheus monitoring for Jenkins configured."
                echo "You can now view metrics:"
                echo "  - Jenkins UI (Prometheus Metrics Plugin): http://192.168.50.4:8080/prometheus"
                echo "  - Prometheus UI (Targets & Querying): http://192.168.50.4:9090"
                echo "  - Grafana UI (Dashboards): http://192.168.50.4:3000 (login admin/admin)"
            }
        }
    }

    // This post section ensures Docker Compose services are stopped and cleaned up
    // regardless of whether the pipeline succeeds or fails.
    post {
        always {
            script {
                echo 'Tearing down Docker Compose services to clean up environment...'
                sh 'docker-compose down'
            }
        }
    }
}