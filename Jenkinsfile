pipeline {
    agent any

    environment {
        IMAGE = "devroy/demo-app:${BUILD_NUMBER}"
        GIT_REPO = "https://github.com/devroy-ops/demo-gitops.git"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: "${GIT_REPO}"
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
                }
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                docker build -t $IMAGE .
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

        stage('Update deployment.yaml') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    sh '''
                    sed -i "s|image: .*|image: $IMAGE|" deployment.yaml

                    git config user.email "devops@example.com"
                    git config user.name "jenkins"

                    git remote set-url origin https://$GIT_USER:$GIT_PASS@github.com/devroy-ops/demo-gitops.git

                    git add deployment.yaml
                    git commit -m "Update image to $IMAGE" || true
                    git push origin master
                    '''
                }
            }
        }

    }
}
