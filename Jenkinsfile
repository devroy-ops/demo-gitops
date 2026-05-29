pipeline {
    agent any

    environment {
        GIT_REPO = "https://github.com/devroy-ops/demo-gitops.git"
    }

    stages {

        // =========================================
        // ✅ CHECKOUT CODE
        // =========================================
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: "${GIT_REPO}"
            }
        }

        // =========================================
        // ✅ DOCKER LOGIN
        // =========================================
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

        // =========================================
        // ✅ BUILD FRONTEND IMAGE
        // =========================================
        stage('Build Frontend Image') {
            steps {
                sh '''
                docker build --network=host --no-cache -t devroy/frontend:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Push Frontend Image') {
            steps {
                sh '''
                docker push devroy/frontend:${BUILD_NUMBER}
                '''
            }
        }

        // =========================================
        // ✅ BUILD PRODUCT CATALOG
        // =========================================
        stage('Build ProductCatalog Image') {
            steps {
                sh '''
                docker build --network=host --no-cache -t devroy/productcatalogservice:latest -f Dockerfile-productcatalog .
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

        // =========================================
        // ✅ BUILD CURRENCY SERVICE
        // =========================================
        stage('Build CurrencyService Image') {
            steps {
                sh '''
                docker build --network=host --no-cache -t devroy/currencyservice:latest ./currencyservice
                '''
            }
        }

        stage('Push CurrencyService Image') {
            steps {
                sh '''
                docker push devroy/currencyservice:latest
                '''
            }
        }

        // =========================================
        // ✅ BUILD CART SERVICE
        // =========================================
        stage('Build CartService Image') {
            steps {
                sh '''
                docker build --network=host --no-cache -t devroy/cartservice:latest ./cartservice
                '''
            }
        }

        stage('Push CartService Image') {
            steps {
                sh '''
                docker push devroy/cartservice:latest
                '''
            }
        }

        // =========================================
        // ✅ UPDATE GIT FOR ARGOCD (VERY IMPORTANT)
        // =========================================
        stage('Update GitOps Repo') {
            steps {
                sh '''
                echo "Updating Kubernetes manifest with new image"

                sed -i "s|image: devroy/frontend:.*|image: devroy/frontend:${BUILD_NUMBER}|" deployment.yaml

                git config user.email "jenkins@local"
                git config user.name "jenkins"

                git add deployment.yaml
                git commit -m "Update frontend image to ${BUILD_NUMBER}"
                git push origin master
                '''
            }
        }

        // =========================================
        // ✅ AI LOG ANALYSIS
        // =========================================
        stage('AI Log Analysis') {
            steps {
                sh '''
                echo "Fetching logs from frontend pod..."

                POD=$(docker run --rm \
                -v /root/.kube:/root/.kube \
                bitnami/kubectl:latest \
                get pod -n default -l app=frontend \
                -o jsonpath="{.items[0].metadata.name}")

                echo "Selected Pod: $POD"

                docker run --rm \
                -v /root/.kube:/root/.kube \
                bitnami/kubectl:latest \
                logs -n default $POD > logs.txt

                echo "Running AI log analyzer..."
                python3 log_analyzer.py
                '''
            }
        }
    }

    // =========================================
    // ✅ POST ACTIONS
    // =========================================
    post {
        success {
            echo "✅ Pipeline completed successfully"
        }
        failure {
            echo "🚨 Pipeline failed — check logs"
        }
        always {
            echo "Pipeline execution finished"
        }
    }
}
 
