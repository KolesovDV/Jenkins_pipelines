#secret  variables.
#Keep it  clear and fill in in Jenkins Credential or other way
do_token = ""
AWS_ACCESS_KEY_ID = ""
AWS_SECRET_ACCESS_KEY = ""
additional_ssh_key = "" # add  ssh keys to grand additional access to the droplets 

# DNS
aws_region = "us-west-2" # exapmle
aws_route53_zone = "some zone" #
dnsrecord = ["somereocrd"] # syncronise this variable with Jenkinsfile var dnsrecord

# Droplet variables examples. you can choose your own
do_droplet_tag = "example"
do_droplet_user = "root"
do_droplet_size = "s-2vcpu-2gb"
do_droplet_region = "FRA1"
do_droplet_hostname = "hostname"
do_droplet_image = "ubuntu-18-04-x64" #  

# Other variables
postgres_user=""
postgres_passwd=""
postgres_db=""

