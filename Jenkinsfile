pipeline {
    agent any

    environment {
        IMAGE_NAME = "chadon32/bankaccount-app"   // Docker Hub repository
        KUBECONFIG = "/path/to/kubeconfig"                     // Path to kubeconfig file for Kubernetes access
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm  // Clones the repository where Jenkinsfile is located
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip install -r src/requirements.txt'  // Install Python dependencies
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${env.BUILD_NUMBER}")  // Builds the Docker image with a unique tag
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                            docker.image("${IMAGE_NAME}:${env.BUILD_NUMBER}").push()  // Push image to Docker Hub
                        }
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withKubeConfig(credentialsId: 'kubeconfig-credential-id') {
                        sh 'kubectl apply -f manifests/pg-storage.yaml'
                        sh 'kubectl apply -f manifests/postgres-deployment.yaml'
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()  // Cleans workspace after the pipeline run
        }
    }
}
