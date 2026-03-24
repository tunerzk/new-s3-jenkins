pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_IN_AUTOMATION   = 'true'
    }
    stages{
        stage {'set aws credentials'}
        steps {
            withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: 'aws_secret_access_key'
            ]]) {
            sh'''
                echo "AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID"
                aws sts get-caller-identity
            '''
            }
        }
    }

    stages {
        stage('Checkout code') {
            steps {
                git branch: 'main', url: 'https://github.com/tunerzk/new-jenkins-s3-test.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform init
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        
                        terraform apply -auto-approve tfplan
                    '''
                }
            }
        }

        stage('Optional Destroy') {
            steps {
                script {
                    def destroyChoice = input(
                        message: 'Do you want to run terraform destroy?',
                        ok: 'Submit',
                        parameters: [
                            choice(
                                name: 'DESTROY',
                                choices: ['no', 'yes'],
                                description: 'Select yes to destroy resources'
                            )
                        ]
                    )

                    if (destroyChoice == 'yes') {
                        withCredentials([[
                            $class: 'AmazonWebServicesCredentialsBinding',
                            credentialsId: 'aws-iam-user-creds'
                        ]]) {
                            sh 'terraform destroy -auto-approve'
                        }
                    } else {
                        echo "Skipping destroy"
                    }
                }
            }
            post {
                success {
                    echo 'terraform deployment completed successfully'
                }
                failure {
                    echo 'terraform deployment failed'
                }
            }
        }
    }
}