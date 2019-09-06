# Notes App CI/CD

A basic notes application paired with a declarative Jenkins job for continuous deployment and provisioning configuration.
It contains:
- Raw flask notes app supporting multiple users workspaces deployed as a service on remote server
- Terraform script to launch two tc2.micro EC2 instances in AWS, a custom vpc with one public subnet and all the relevant configurations
- Ansible script to deploy the app in one of the instances and a Mysql database form a Docker container in the secondSet
- Jenkinsfile to automate the release
- Dockerfile fro dockerizing the app in two versions (regular and slim) and a docker-compose yml for local deployment

## Local Deployment

To run the application locally build one of the Dockerfiles running this command in the same directory of the Dockerfile:
```
docker build -t notes .
```
or
```
docker build -t noteslim -f Dockerfile.slim .
```
Then run the command:
```
docker-compose up
```
For persistent storage uncomment the line
```
# - db_data:/var/lib/mysql
```
Application will be accessible from localhost on port 80.

*Required improvement: wait for database to create before running the app*

## Pipeline

Configure Jenkins server and a source control repository, you can use this local development environment

https://github.com/giuliovn/Jenkins-gogs

Install and configure Terraform plugin.

Install ssh-agent plugin and create credentials with the private key that will be used for the servers.

Configure email notifications.

### Requirements

**- AWS account and valid credentials**
**- S3 bucket to store terraform state**
    Or drop the remote.tf file for storing locally terraform state
**- SSH key pair**
    Fill with **public** key name and path relevant fields in variables.auto.tfvars

## NB
Both the instances have port 22 open to all the internet, you may want to restrict it to your IP.