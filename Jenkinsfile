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
        sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .' // Build the Docker image
      }
    }

    stage('Login') {
      steps {
        echo 'Logging in to Heroku container registry...'
        sh 'echo $HEROKU_API_KEY | docker login --username=_ --password-stdin registry.heroku.com' // Login to Heroku container registry
      }
    }

    stage('Push to Heroku registry') {
      steps {
        echo 'Pushing Docker image to Heroku container registry...'
        sh '''
          docker tag $IMAGE_NAME:$IMAGE_TAG registry.heroku.com/$APP_NAME/web // Tag the Docker image
          docker push registry.heroku.com/$APP_NAME/web // Push the Docker image to Heroku container registry
        '''
      }
    }

    stage('Release the image') {
      steps {
        echo 'Releasing the Docker image on Heroku...'
        sh 'heroku container:release web --app=$APP_NAME' // Release the Docker image on Heroku
      }
    }
  }

  post {
    always {
      echo 'Cleaning up...'
      sh 'docker logout' // Logout from Docker
      // Optionally, add more cleanup steps if necessary
    }
    failure {
      echo 'Build failed!'
      // Optionally, add notification steps like sending an email or Slack message
    }
  }
}
