node {
    def mvnHome = tool 'maven-3.8.5'

    def dockerImage
    
    def dockerRepoUrl = "localhost:8083"
    def dockerImageName = "hello-world-java"
    def dockerImageTag = "${dockerRepoUrl}/${dockerImageName}:${BRANCH_NAME}"

    stage('Clone Repo') { // for display purposes
      git branch: '${BRANCH_NAME}', url: 'https://github.com/haritha195/softility.git'
      mvnHome = tool 'maven-3.8.5'
    }

    stage('Build Project') {
      sh "'${mvnHome}/bin/mvn' -f hello-world-src/pom.xml -Dmaven.test.failure.ignore clean package"
    }

    stage('Build Docker Image') {
      sh "echo $BRANCH_NAME"
      sh "mv ./hello-world-src/target/hello*.jar ./data"

      dockerImage = docker.build("hello-world-java","-f hello-world-src/Dockerfile .")

      sh "docker tag hello-world-java:latest us-east1-docker.pkg.dev/molten-medley-415817/hello-world/${dockerImageName}:${BRANCH_NAME}"
    }

    stage('Sonar Scan'){

      withCredentials([string(credentialsId: 'sonar_token', variable: 'SONAR_TOKEN')]){
       sh '''
        cd hello-world-src
        mvn clean verify sonar:sonar \
          -Dsonar.projectKey=softility-java-app \
          -Dsonar.projectName='softility-java-app' \
          -Dsonar.host.url=http://34.16.191.60:9000 \
          -Dsonar.token=$SONAR_TOKEN
       '''
      }
    }

    stage('Trivy Scan'){
      sh "trivy image us-east1-docker.pkg.dev/molten-medley-415817/hello-world/${dockerImageName}:${BRANCH_NAME}"
    }

    stage('Pushing Docker Image'){

      withCredentials([file(credentialsId: 'gcr-file', variable: 'GC_KEY')]){
        sh "echo \"Docker Image Tag Name: ${dockerImageTag}\""
        sh "cat '$GC_KEY' | docker login -u _json_key --password-stdin https://us-east1-docker.pkg.dev"
        sh "gcloud auth activate-service-account --key-file='$GC_KEY'"
        sh "gcloud auth configure-docker us-east1-docker.pkg.dev"
        GLOUD_AUTH = sh (
              script: 'gcloud auth print-access-token',
              returnStdout: true
          ).trim()
        echo "Pushing image To GCR"
        sh "docker push us-east1-docker.pkg.dev/molten-medley-415817/hello-world/${dockerImageName}:${BRANCH_NAME}"
      }
    }

    stage('Deploying App to GKE'){
      withCredentials([file(credentialsId: 'gcr-file', variable: 'GC_KEY'),string(credentialsId: 'sonar_token', variable: 'SONAR_TOKEN')]){
        sh "gcloud auth activate-service-account --key-file=$GC_KEY"
        sh "gcloud config set project molten-medley-415817"
        sh "gcloud container clusters get-credentials molten-medley-415817-gke --region us-west4 --project molten-medley-415817"
        sh "helm upgrade --install my-java-app helm-chart/java-app --namespace java-app"
        sh '''
        export SERVICE_IP=$(kubectl get svc --namespace java-app my-java-app --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
        echo "Your Application is live on: echo http://$SERVICE_IP:8080"
        '''
      }
    }

    stage("Cleanup") {
      sh "docker image rm hello-world-java:latest"
      sh "docker image rm us-east1-docker.pkg.dev/molten-medley-415817/hello-world/${dockerImageName}:${BRANCH_NAME}"
    }
}
