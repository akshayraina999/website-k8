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
                sh 'scp /var/lib/jenkins/workspace/${JOB_NAME}/* root@10.154.14.18:/home/ubuntu'
                }
            }
        }
    }
}