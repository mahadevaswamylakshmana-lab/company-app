pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                bat 'mvn test'
            }
        }

        stage('Build') {
            steps {
                bat 'echo Job: %JOB_NAME%'
                bat 'echo Build Number: %BUILD_NUMBER%'
                bat 'echo Workspace: %WORKSPACE%'
                bat 'mvn clean package'
            }
        }

        stage('Credentials Test') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'practice-credential',
                        usernameVariable: 'APP_USER',
                        passwordVariable: 'APP_PASS'
                    )
                ]) {
                    bat 'echo Username: %APP_USER%'
                    bat 'echo Password variable is available to Jenkins'
                }
            }
        }

        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Test EC2 Docker Connection') {
            steps {
                sshagent(['ec2-docker-ssh']) {
                    bat '''
                        ssh -o StrictHostKeyChecking=no ubuntu@3.111.31.216 "docker --version"
                    '''
                }
            }
        }

        stage('Copy Files to EC2') {
            steps {
                sshagent(['ec2-docker-ssh']) {
                    bat '''
                        scp -o StrictHostKeyChecking=no target/company-app-1.0.jar ubuntu@3.111.31.216:/home/ubuntu/
                        scp -o StrictHostKeyChecking=no Dockerfile ubuntu@3.111.31.216:/home/ubuntu/
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sshagent(['ec2-docker-ssh']) {
                    bat '''
                        ssh -o StrictHostKeyChecking=no ubuntu@3.111.31.216 "cd /home/ubuntu && docker build -t company-app:1.0 ."
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sshagent(['ec2-docker-ssh']) {
                    bat '''
                        ssh -o StrictHostKeyChecking=no ubuntu@3.111.31.216 "docker rm -f company-app 2>/dev/null || true"
                        ssh -o StrictHostKeyChecking=no ubuntu@3.111.31.216 "docker run -d --name company-app company-app:1.0"
                    '''
                }
            }
        }

        stage('Verify Container') {
            steps {
                sshagent(['ec2-docker-ssh']) {
                    bat '''
                        ssh -o StrictHostKeyChecking=no ubuntu@3.111.31.216 "docker ps"
                        ssh -o StrictHostKeyChecking=no ubuntu@3.111.31.216 "docker logs company-app"
                    '''
                }
            }
        }
    }
}
