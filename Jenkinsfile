pipeline {
    agent any
    
    stages {
        stage('Verify Branch') {
            steps {                
                echo "$GIT_BRANCH"
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker images -a'
                sh """
                    cd azure-vote/
                    docker images -a
                    docker build -t jenkins-pipeline .
                    docker images -a
                    cd ..
                """
            }
        }   

        stage('Start test app') {
            steps {
                sh """
                docker-compose up -d
                bash ./scripts/test_container.sh
                """
            }
            post {
                success {
                echo "App started successfully :)"
                }
                failure {
                echo "App failed to start :("
                }
            }
      }
      stage('Run Tests') {
            steps {
                sh """
                pytest ./tests/test_sample.py
                """
            }
      }
      stage('Stop test app') {
            steps {
                sh """
                docker-compose down
                """
            }
      }     
      stage('Push Container') {
          steps {
              echo "Workspace is $WORKSPACE"
              dir("$WORKSPACE/azure-vote") {
                  script {
                      docker.withRegistry('https://index.docker.io/v1/', 'DockerHub') {
                          def image = docker.build("cruizji/jenkins-course:latest")
                          image.push()                 
                     }     
                  }
     // stage('Container Scanning') {
     //    parallel {
     //       stage('Run Anchore') {
     //          steps {
               //   pwsh(script: """
                 //    Write-Output "blackdentech/jenkins-course" > anchore_images
                  //""")
                  //anchore bailOnFail: false, bailOnPluginFail: false, name: 'anchore_images'
       
       //      }
       //     }
            stage('Run Trivy') {
               steps {
                  sleep(time: 30, unit: 'SECONDS')
                   sh(script: """
                   trivy cruizji/jenkins-course
                   """)
               }
            }
   
              }    
          }
      }
   }
}
