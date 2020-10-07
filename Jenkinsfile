pipeline {
    agent {
      label 'docker'
    }

    stages {
        stage ('Run Test') {
            steps {
              sh """
                  docker --version
              """
            }
        }

    }

}