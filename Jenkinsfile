pipeline{
    agent any
    stages{
        stage("SCM Checkout"){
            steps{
                echo "========SCM Checkout========"
                git credentialsId: 'github',
                    url: 'https://github.com/akshayraina999/website-k8.git'
            }
        }
        stage('Send files to Ansible'){
            steps{
                echo "========Sending files to Ansible========"
                sshagent(['ansible_server']) {
                sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18'
                sh 'scp /var/lib/jenkins/workspace/${JOB_NAME}/* root@10.154.14.18:/home/ubuntu/'
                }
            }
        }
        stage('Build Docker Image'){
            steps{
                echo "========Building Docker Image========"
                sshagent(['ansible_server']){
                sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18 cd /home/ubuntu/'
                sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18 docker image build -t $JOB_NAME:v1.$BUILD_ID /home/ubuntu/'
                }
            }
        }
        stage('Tag Docker Image'){
            steps{
                echo "========Tagging Docker Image========"
                sshagent(['ansible_server']){
                sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18 cd /home/ubuntu/'
                sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18 docker image tag $JOB_NAME:v1.$BUILD_ID akshayraina/$JOB_NAME:v1.$BUILD_ID'
                sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18 docker image tag $JOB_NAME:v1.$BUILD_ID akshayraina/$JOB_NAME:latest'
                }
            }
        }
        stage('Push Docker Image'){
            steps{
                echo "========Pushing Docker Image========"
                sshagent(['ansible_server']){
                    withCredentials([string(credentialsId: 'docker_pass', variable: 'docker_pass')]){
                        sh '''ssh -o StrictHostKeyChecking=no root@10.154.14.18 docker login -u akshayraina -p ${docker_pass}'''
                        // sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18 cd /home/ubuntu/'
                        sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18 docker image push akshayraina/$JOB_NAME:v1.$BUILD_ID'
                        sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18 docker image push akshayraina/$JOB_NAME:latest'
                    }
                }
            }
        }
    }
}
