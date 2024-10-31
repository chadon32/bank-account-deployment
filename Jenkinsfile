pipeline {
    agent any

    environment {
        IMAGE_NAME = "chadon32/bankaccount-app" // Replace with your Docker repository name
        KUBECONFIG = '/var/lib/jenkins/.kube/config'          // Path to your kubeconfig file in Jenkins
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
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
                withCredentials([string(credentialsId: 'dockerhub-credentials', variable: 'DOCKERHUB_TOKEN')]) {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                            docker.image("${IMAGE_NAME}:${env.BUILD_NUMBER}").push()
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
            cleanWs()
        }
    }
}
