pipeline {
    agent { node { label "terraform-node" } }
    parameters {
        choice(name: 'deploy_choice', choices: ['apply', 'destroy'], description: 'The deployment type')
    }
    environment {
        EMAIL_TO = 'dorisakudo09@gmail.com'
        AWS_REGION = 'eu-west-2'
    }
    stages {
        stage('1. Terraform Init') {
            steps {
                echo 'Terraform init phase'
                sh 'terraform init'
            }
        }
        stage('2. Terraform Plan') {
            steps {
                echo 'Terraform plan phase'
                sh 'terraform plan'
            }
        }
        stage('3. Manual Approval') {
            input {
                message "Should we proceed?"
                ok "Yes, we should."
                parameters {
                    choice(name: 'Manual_Approval', choices: ['Approve', 'Reject'], description: 'Approve or Reject the deployment')
                }
            }
            steps {
                echo "Deployment ${Manual_Approval}"
            }
        }
        stage('4. Terraform Deploy') {
            steps {
                echo "Terraform ${params.deploy_choice} phase"
                // Ensure the use of the correct AWS credentials
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'your-aws-credentials-id']]) {
                    script {
                        if (params.deploy_choice == 'apply') {
                            try {
                                sh "terraform ${params.deploy_choice} --auto-approve"
                                
                                // Update kubeconfig if applying
                                def clusterName = sh(script: 'terraform output -raw cluster_name', returnStdout: true).trim()
                                sh "aws eks --region ${env.AWS_REGION} update-kubeconfig --name ${clusterName}"
                                sh "export KUBECONFIG=~/.kube/config"
                                
                                // Apply Helm release
                                sh "helm repo add eks https://aws.github.io/eks-charts"
                                sh "helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=${clusterName} --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller --set region=${env.AWS_REGION} --set vpcId=$(terraform output -raw vpc_id)"
                            } catch (Exception e) {
                                error "Deployment failed: ${e.message}"
                            }
                        } else {
                            sh "terraform ${params.deploy_choice} --auto-approve"
                        }
                    }
                }
            }
        }
        stage('5. Email Notification') {
            steps {
                mail bcc: 'dorisakudo09@gmail.com', body: '''Terraform deployment is completed.
                Let me know if the changes look okay.
                Thanks,
                DJ Technologies,
                +1 (313) 413-1477''', cc: 'dorisakudo09@gmail.com', from: '', replyTo: '', subject: 'Terraform Infra deployment completed!!!', to: 'dorisakudo09@gmail.com'
            }
        }
    }
}
