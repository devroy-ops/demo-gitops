pipeline {
    agent any

    environment {
        IMAGE = "devroy/demo-app:${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/devroy-ops/demo-gitops.git'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE .'
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE'
            }
        }

        stage('Update deployment.yaml') {
            steps {
                sh '''
                sed -i "s|image: .*|image: $IMAGE|" deployment.yaml

                git config user.email "devops@example.com"
                git config user.name "jenkins"

                git add deployment.yaml
                git commit -m "Update image to $IMAGE"
                git push --set-upstream origin master
                
            }
        }

    }
}
