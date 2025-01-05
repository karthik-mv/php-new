pipeline {
    agent any
    tools {
        maven "mymaven"  // Specify the Maven tool configuration
    }
    environment {
        DEV_SERVER_IP = 'ec2-user@172.31.23.104'
        DEPLOY_SERVER_IP = 'ec2-user@172.31.29.86'
        IMAGE_NAME = 'karthikmv93/docker'
    }
    
    stages{
        stage('Package & Push the Image to Registry') {
            agent any
            steps {
                script {
                    sshagent(['slave2']) {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                            echo "Package the code "
                            // Install Docker on the deploy server
                            sh "scp -v -o StrictHostKeyChecking=no -r devconfig ${DEV_SERVER_IP}:/home/ec2-user"
                            sh "ssh -v -o StrictHostKeyChecking=no ${DEV_SERVER_IP} 'bash ~/devconfig/docker-script.sh'"
                            sh "ssh ${DEV_SERVER_IP} sudo docker build -t ${IMAGE_NAME} /home/ec2-user/devconfig"  
                            // sh "ssh -v -o StrictHostKeyChecking=no ${DEV_SERVER_IP} 'bash ~/server-script.sh' ${IMAGE_NAME} ${BUILD_NUMBER}"
                            // Login to Docker Hub and push the image
                            sh "ssh ${DEV_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                            sh "ssh ${DEV_SERVER_IP} sudo docker push ${IMAGE_NAME}"
                        }
                    }
                }
            }
        }

        stage('Deploy docker image in to deployserver') {
            agent any  // Ensure the 'Deploy' stage runs on any available agent
            steps {
                script {
                    sshagent(['slave2']) {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                            echo "Deploying the code version"
                            // Install Docker on the deploy server
                            // sh "scp -v -o StrictHostKeyChecking=no server-script.sh ${DEPLOY_SERVER_IP}:/home/ec2-user"
                            sh "scp -v -o StrictHostKeyChecking=no -r testconfig ${DEPLOY_SERVER_IP} /home/ec2-user/testconfig "
                            sh "ssh ${DEPLOY_SERVER_IP} sudo yum install docker -y"
                            sh "ssh ${DEPLOY_SERVER_IP} sudo systemctl start docker"
                            sh "ssh ${DEPLOY_SERVER_IP} 'bash ~/home/ec2-user/testconfig/docker-compose-script.sh ${IMAGE_NAME}:${BUILD_NUMBER}'"
                            // Login to Docker Hub and run the container
                            // sh "ssh ${DEPLOY_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                            // sh "ssh ${DEPLOY_SERVER_IP} sudo docker run -itd -P ${IMAGE_NAME}:${BUILD_NUMBER}"
                        }
                    }
                }
            }
        }
    }
}

