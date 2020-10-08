#secret  variables
do_token = ""
AWS_ACCESS_KEY_ID = ""
AWS_SECRET_ACCESS_KEY = ""
additional_ssh_key = ""

# DNS
aws_region = "us-west-2"
aws_route53_zone = "devops.rebrain.srwx.net"
dnsrecord = ["do1607"] # syncronise this variable with Jenkinsfile var dnsrecord

# Droplet variables
do_droplet_tag = "example"
do_droplet_user = "root"
do_droplet_size = "s-2vcpu-2gb"
do_droplet_region = "FRA1"
do_droplet_hostname = "do15"
do_droplet_image = "ubuntu-18-04-x64"

# Other variables
postgres_user="user"
postgres_passwd="superpasswd"
postgres_db="database"

