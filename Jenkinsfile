pipeline {
    agent any

    environment {
        IMAGE = "devroy/frontend:latest"
        GIT_REPO = "https://github.com/devroy-ops/demo-gitops.git"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'master', url: "${GIT_REPO}"
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
                }
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                        docker build --no-cache -t $IMAGE .
                '''
            }
        }

        stage('Push Image') {
            steps {
                sh '''
                        docker push $IMAGE
                '''
            }
        }

    }
}
