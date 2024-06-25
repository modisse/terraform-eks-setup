pipeline {
    agent { node { label "terraform-node" } } 
    parameters {
                choice(name: 'deploy_choice', choices:['apply','destroy'],description:'The deployment type')
                  }
    environment {
        EMAIL_TO = 'dorisakudo09@gmail.com'
    }
    stages {
        stage('1.Terraform init') {
            steps {
                echo 'terraform init phase'
                sh 'terraform init'
            }
        }
        stage('2.Terraform plan') {
            steps {
                echo 'terraform plan phase'
                sh 'AWS_REGION=eu-west-2 terraform plan'
            }
        }
        stage('3.Manual Approval') {
            input {
                message "Should we proceed?"
                ok "Yes, we should."
                parameters{
                    choice (name: 'Manual_Approval', choices: ['Approve','Reject'], description: 'Approve or Reject the deployment')
                }
            }
             steps {
                echo "Deployment ${Manual_Approval}"
            }          
        }
        stage('4. Terraform Deploy') {
            steps {
                echo "Terraform ${params.deploy_choice} phase"
                sh "AWS_REGION=eu-west-2 terraform ${params.deploy_choice} -target=module.vpc -target=module.eks --auto-approve"
                
                // Retrieve the cluster name dynamically from Terraform output
                script {
                    def clusterName = sh(script: 'terraform output -raw cluster_name', returnStdout: true).trim()
                    sh "aws eks --region eu-west-2 update-kubeconfig --name ${clusterName} && export KUBE_CONFIG_PATH=~/.kube/config"
                }
                
                sh "AWS_REGION=eu-west-2 terraform ${params.deploy_choice} --auto-approve"
            }
       }
        stage ('5. Email Notification') {
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