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
    }
}