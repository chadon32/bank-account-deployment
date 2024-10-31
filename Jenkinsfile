pipeline {
    agent any

    environment {
        IMAGE_NAME = "chadon32/bankaccount-app" 
        KUBECONFIG = '/var/lib/jenkins/.kube/config'  // Path to kubeconfig file in Jenkins
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
                // Using Docker Hub credentials as username and password
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', 
                                                 usernameVariable: 'DOCKER_USER', 
                                                 passwordVariable: 'DOCKER_PASS')]) {
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
