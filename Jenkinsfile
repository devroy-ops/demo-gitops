pipeline {
    agent any

    environment {
        GIT_REPO = "https://github.com/devroy-ops/demo-gitops.git"
        DOCKER_REPO = "devroy"
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
                    credentialsId: 'docker-creds',   // ✅ FIXED
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        // =========================================
        // ✅ BUILD + PUSH FRONTEND
        // =========================================
        stage('Build & Push Frontend') {
            steps {
                sh '''
                docker build -t ${DOCKER_REPO}/frontend:${BUILD_NUMBER} .
                docker push ${DOCKER_REPO}/frontend:${BUILD_NUMBER}
                '''
            }
        }

        // =========================================
        // ✅ BUILD + PUSH PRODUCT CATALOG
        // =========================================
        stage('Build & Push ProductCatalog') {
            steps {
                sh '''
                docker build -t ${DOCKER_REPO}/productcatalogservice:${BUILD_NUMBER} ./productcatalogservice
                docker push ${DOCKER_REPO}/productcatalogservice:${BUILD_NUMBER}
                '''
            }
        }

        // =========================================
        // ✅ BUILD + PUSH CURRENCY SERVICE
        // =========================================
        stage('Build & Push CurrencyService') {
            steps {
                sh '''
                docker build -t ${DOCKER_REPO}/currencyservice:${BUILD_NUMBER} ./currencyservice
                docker push ${DOCKER_REPO}/currencyservice:${BUILD_NUMBER}
                '''
            }
        }

        // =========================================
        // ✅ BUILD + PUSH CART SERVICE
        // =========================================
        stage('Build & Push CartService') {
            steps {
                sh '''
                docker build -t ${DOCKER_REPO}/cartservice:${BUILD_NUMBER} ./cartservice
                docker push ${DOCKER_REPO}/cartservice:${BUILD_NUMBER}
                '''
            }
        }

        // =========================================
        // ✅ UPDATE GITOPS (FIXED ✅)
        // =========================================
        stage('Update GitOps Repo') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'git-creds',
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_PASS'
                )]) {   
                    sh '''
                    echo "Updating Kubernetes manifest..."

                    sed -i "s|image: devroy/frontend:.*|image: devroy/frontend:${BUILD_NUMBER}|" deployment.yaml

                    git config --global user.email "ci@jenkins.com"
                    git config --global user.name "jenkins"

                    git add deployment.yaml
                    git commit -m "Update frontend image to ${BUILD_NUMBER}"
                    echo "Setting authenticated remote..."

                    git remote set-url origin https://${GIT_USER}:${GIT_PASS}@github.com/devroy-ops/demo-gitops.git
                    git remote -v   # ✅ IMPORTANT DEBUG
                    git push origin master
                    '''
                }
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
    // ✅ POST
    // =========================================
    post {
        success {
            echo "✅ Pipeline SUCCESS"
        }
        failure {
            echo "🚨 Pipeline FAILED"
        }
        always {
            echo "Pipeline finished"
        }
    }
}

