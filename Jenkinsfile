def APP_IP = ""

pipeline{

    agent any     

    options {
        timestamps()
    }

    stages {
        stage ('Set environment') {
            steps {
                script {
                    println "Start"
                    def tfHome = tool name: 'terraform'
                    println tfHome
                    env.PATH = "${tfHome}:${env.PATH}"
                    println env.PATH
                }
                sh '''
                    cd provisioning/terraform
                    terraform init
                    terraform apply -auto-approve
                    
                    echo [db] > ../ansible/inventory.ini
                    terraform output db_public_ip >> ../ansible/inventory.ini
                    echo [app] >> ../ansible/inventory.ini
                    terraform output app_public_ip >> ../ansible/inventory.ini

                    terraform output app_public_ip > ../../ip

                    terraform output db_private_ip > ../ansible/db_host
                '''
           }
        }

        stage ('Deploy') {
            steps {
                sshagent (credentials: ['key']) {
                    script {
                        APP_IP = sh(script: 'cat ip', returnStdout: true)
                    }
                    sh '''
                        cd provisioning/ansible
                        db_host=$(cat db_host)
                        export ANSIBLE_HOST_KEY_CHECKING=False
                        ansible-playbook -i inventory.ini site.yml -e 'ansible_python_interpreter=/usr/bin/python3' --extra-vars "db_host=$db_host"
                    '''
                }
           }
        }
    }

    environment {
            EMAIL_TO = 'YOUREMAIL@gmail.com'
    }
    post {
        success {
            emailext body: "The current ip is ${APP_IP}. \n\n \n\n -------------------------------------------------- \n", 
                    to: EMAIL_TO, 
                    subject: 'Build success in Jenkins: $PROJECT_NAME - #$BUILD_NUMBER'
        }
    }

}