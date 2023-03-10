pipeline{
    agent any

    environment {
		DOCKERHUB_CREDENTIALS=credentials('dockerpasswd')
	}

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
                    // withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]){
                        // sh "docker login -u akshayraina -p ${dockerhubpwd}"
                        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                        // sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18 cd /home/ubuntu/'
                        sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18 docker image push akshayraina/$JOB_NAME:v1.$BUILD_ID'
                        sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18 docker image push akshayraina/$JOB_NAME:latest'

                        // Removing docker images from local
                        sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18 docker image rm $JOB_NAME:v1.$BUILD_ID akshayraina/$JOB_NAME:v1.$BUILD_ID akshayraina/$JOB_NAME:latest'
                    }
                }
            }
        stage('Transferring files from Jenkins to Kubernetes Server'){
            steps{
                echo "========Transferring files to Kubernetes Server========"
                sshagent(['kubernetes_server']){
                    sh 'ssh -o StrictHostKeyChecking=no akshay@192.168.1.88'
                    sh 'scp /var/lib/jenkins/workspace/${JOB_NAME}/* akshay@192.168.1.88:/home/pc/k8_test/'
                }
            }
        }
        stage('Deployment to Kubernetes'){
            steps{
                echo "========Deploying Containers to Kubernetes Server========"
                sshagent(['ansible_server']){
                    sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18 cd /home/ubuntu/'
                    sh 'ssh -o StrictHostKeyChecking=no root@10.154.14.18 ansible-playbook /home/ubuntu/playbook.yml'
                }
            }
        }
    }
}
