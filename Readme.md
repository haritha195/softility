
# Setting Up DevOps End To End CI/CD Pipeline

A brief description of what this project does and who it's for

## Installing Docker
[Link to Install Docker](https://docs.docker.com/engine/install/)

## Running Jenkins

To run jenkins

```bash
  cd jenkins/
  chmod 777 deploy-jenkins.sh
  ./deploy-jenkins.sh
```

Accessing Jenkins:

- Access localhost:8080/
- Get Password from:
    ```bash
    docker exec -it jenkins-blueocean bash
    cat /var/jenkins_home/secrets/initialAdminPassword
    # Copy Password
    ```
- Setup Rest of proccess on browser

Hurray... Jenkins is Up on localhost:8080/