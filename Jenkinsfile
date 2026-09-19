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
    }
}
