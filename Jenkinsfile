pipeline {
    agent any

    environment {
        IMAGE_NAME = "chadon32/bankaccount-app"  // Replace with your DockerHub repository name if different
        KUBECONFIG_CREDENTIAL_ID = 'kubeconfig-credential-id'  // Kubeconfig credential ID stored in Jenkins
        DOCKERHUB_CREDENTIAL_ID = 'dockerhub-token'  // DockerHub token credential ID stored in Jenkins
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip install -r requirements.txt'  // Adjust path if `requirements.txt` is in a subfolder
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: DOCKERHUB_CREDENTIAL_ID, variable: 'DOCKERHUB_TOKEN')]) {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-token') {
                            docker.image("${IMAGE_NAME}:${env.BUILD_NUMBER}").push()
                        }
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withKubeConfig([credentialsId: KUBECONFIG_CREDENTIAL_ID]) {
                        sh 'kubectl apply -f manifests/pg-storage.yaml'
                        sh 'kubectl apply -f manifests/postgres-deployment.yaml'
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
