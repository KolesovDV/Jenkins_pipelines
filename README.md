# CICD example with Jenkins pipeline
This is an example of how to use Jenkins pipeline to build infrastructe and deploy [Symfony Demo Application](https://github.com/symfony/demo). In following case is used Terraform to create VM, ansible to configure VM, install and configure nginx, postgres and some packages.
#### ***requerments:***
- Terraform using such providers as [DigitalOcean](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs), [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). So you must have the required accounts
- To create and configure VM in stage('Create VM') in Jenkinsfile you are to specify agent on which is already installed "terraform >= 0.13" and ansible >= 2.7"
- Fill in all needed credentials in [Jenkins Credentials](https://www.jenkins.io/doc/book/using/using-credentials) and variables into Jenkinsfile Environment. 
- Fill in Droplet variables into terraform.tfvars
- ***Sincronise variable "dnsrecord" in Jenkinsfile and terraform.tfvars***

#### Security
Do not use secret data in the open form in Jenkinsfiles, ansible playbooks, or direct indication in variables. It's much more better to use [Jenkins Credentials](https://www.jenkins.io/doc/book/using/using-credentials) as a secret store and use them as passed arguments when executing commands.

