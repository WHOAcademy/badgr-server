pipeline {
    agent {
      label 'jenkins-agent-python38'
    }

    stages {
        stage ('Run Test') {
            steps {
              sh """
                  python -V
              """
            }
        }

    }

}