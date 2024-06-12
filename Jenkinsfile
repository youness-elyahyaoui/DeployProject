pipeline {
  agent any
  
  options {
    buildDiscarder(logRotator(numToKeepStr: '5')) // Keep the last 5 builds only
  }

  environment {
    HEROKU_API_KEY = credentials('heroku-api-key') // Heroku API key from Jenkins credentials
    IMAGE_NAME = 'darinpope/jenkins-example-laravel' // Docker image name
    IMAGE_TAG = 'latest' // Docker image tag
    APP_NAME = 'jenkins-example-laravel' // Heroku app name
  }

  stages {
    stage('Build') {
      steps {
        echo 'Building Docker image...'
        script {
          def buildResult = sh(script: 'docker build -t $IMAGE_NAME:$IMAGE_TAG .', returnStatus: true)
          if (buildResult != 0) {
            error 'Docker build failed'
          }
        }
      }
    }

    stage('Login') {
      steps {
        echo 'Logging in to Heroku container registry...'
        script {
          def loginResult = sh(script: 'echo $HEROKU_API_KEY | docker login --username=_ --password-stdin registry.heroku.com', returnStatus: true)
          if (loginResult != 0) {
            error 'Docker login failed'
          }
        }
      }
    }

    stage('Push to Heroku registry') {
      steps {
        echo 'Pushing Docker image to Heroku container registry...'
        script {
          def tagResult = sh(script: 'docker tag $IMAGE_NAME:$IMAGE_TAG registry.heroku.com/$APP_NAME/web', returnStatus: true)
          if (tagResult != 0) {
            error 'Docker tag failed'
          }
          
          def pushResult = sh(script: 'docker push registry.heroku.com/$APP_NAME/web', returnStatus: true)
          if (pushResult != 0) {
            error 'Docker push failed'
          }
        }
      }
    }

    stage('Release the image') {
      steps {
        echo 'Releasing the Docker image on Heroku...'
        script {
          def releaseResult = sh(script: 'heroku container:release web --app=$APP_NAME', returnStatus: true)
          if (releaseResult != 0) {
            error 'Heroku release failed'
          }
        }
      }
    }
  }

  post {
    always {
      echo 'Cleaning up...'
      sh 'docker logout' // Logout from Docker
      sh 'docker image prune -f' // Remove unused Docker images
    }
    failure {
      echo 'Build failed!'
      // Optionally, add notification steps like sending an email or Slack message
      // For example, to send an email:
      // mail to: 'team@example.com',
      //      subject: "Build failed in Jenkins: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
      //      body: "Something is wrong with ${env.JOB_NAME} #${env.BUILD_NUMBER}. Please check the Jenkins console output."
    }
    success {
      echo 'Build succeeded!'
      // Optionally, add notification steps like sending an email or Slack message
      // For example, to send an email:
      // mail to: 'team@example.com',
      //      subject: "Build succeeded in Jenkins: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
      //      body: "${env.JOB_NAME} #${env.BUILD_NUMBER} was successful. Good job!"
    }
  }
}
