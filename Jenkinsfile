pipeline {
  agent any
   stages {

stage('Destroy') {
    agent {label 'awsDeploy'}
    steps {
          withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
              string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                dir('intTerraform') {
                    sh 'terraform destroy -auto-approve -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"'
                  }
          }
    }
}
  }
 }
