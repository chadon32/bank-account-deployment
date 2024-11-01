pipeline {
	agent any
	tools {
		jfrog 'jfrog-cli'
	}
	environment {
		DOCKER_IMAGE_NAME = "chadington.jfrog.io/docker-local/hello-frog:1.0.0"
	}
	stages {
		stage('Clone') {
			steps {
				git branch: 'master', url: "https://github.com/jfrog/project-examples.git"
			}
		}

		stage('Build Docker image') {
			steps {
				script {
					docker.build("$DOCKER_IMAGE_NAME", 'docker-oci-examples/docker-example')
				}
			}
		}

		stage('Scan and push image') {
			steps {
				dir('docker-oci-examples/docker-example/') {
					// Scan Docker image for vulnerabilities
					jf 'docker scan $DOCKER_IMAGE_NAME'

					// Push image to Artifactory
					jf 'docker push $DOCKER_IMAGE_NAME'
				}
			}
		}

		stage('Publish build info') {
			steps {
				jf 'rt build-publish'
			}
		}
	}
}