pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKER_HUB_CREDENTIALS = credentials('Docker_User_Pass') // Replace 'your-docker-hub-credentials-id' with the ID of your Docker Hub credentials in Jenkins
    IMAGE_NAME = 'younesselyahyaoui1122/jenkins-example-laravel' // Replace 'your-docker-hub-username' with your Docker Hub username
    IMAGE_TAG = 'latest'
  }
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
      }
    }
    stage('Login to Docker Hub') {
      steps {
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'DOCKER_HUB_CREDENTIALS', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
          sh "echo \$DOCKER_HUB_PASSWORD | docker login --username \$DOCKER_HUB_USERNAME --password-stdin"
        }
      }
    }
    stage('Push to Docker Hub') {
      steps {
        sh "docker push $IMAGE_NAME:$IMAGE_TAG"
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}
