pipeline {
    agent any

    environment {
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

        // ✅ FRONTEND BUILD
        stage('Build Frontend Image') {
            steps {
                sh '''
                    docker build --no-cache -t devroy/frontend:latest .
                '''
            }
        }

        stage('Push Frontend Image') {
            steps {
                sh '''
                    docker push devroy/frontend:latest
                '''
            }
        }

        // ✅ PRODUCT CATALOG BUILD
        stage('Build ProductCatalog Image') {
            steps {
                sh '''
                    docker build --no-cache -t devroy/productcatalogservice:latest -f Dockerfile-productcatalog .
                '''
            }
        }

        stage('Push ProductCatalog Image') {
            steps {
                sh '''
                    docker push devroy/productcatalogservice:latest
                '''
            }
        }
    }
}
