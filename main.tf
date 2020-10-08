### Providers
## AWS

# Configure the AWS  Provider
 provider "aws" {
  region     = var.aws_region
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
 }

# Configure AWS zone
 data "aws_route53_zone" "selected" {
   name = var.aws_route53_zone
   private_zone = false
  }

# Create DNS records 
 resource "aws_route53_record" "lb" {
  count = length(var.dnsrecord)
  zone_id =  data.aws_route53_zone.selected.id 
  name    =  "${element(var.dnsrecord, count.index)}.${var.aws_route53_zone}"
  type    = "A"
  ttl     = "300"
  records = [digitalocean_droplet.webserver[count.index].ipv4_address ,]
 }


## DigitalOcean

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Create a new tag 
resource "digitalocean_tag" "droplet_tag" {
  name = var.do_droplet_tag
}
# Create a new SSH key
resource "digitalocean_ssh_key" "my_default_key" {
  name       = "Terraform Example key mf"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create  a new  Droplet 
resource "digitalocean_droplet" "webserver" {
  count  = length(var.dnsrecord)
  image  = var.do_droplet_image
  name   = var.do_droplet_hostname
  region = var.do_droplet_region
  size   = var.do_droplet_size
  ssh_keys = [digitalocean_ssh_key.my_default_key.fingerprint]
  tags   = [digitalocean_tag.droplet_tag.id]

# Waiting for creating droplet 

 provisioner "remote-exec" {
    inline = [
      "echo ${var.additional_ssh_key} >> ~/.ssh/authorized_keys" ]

    connection {
      type = "ssh"
      user = var.do_droplet_user
      host = digitalocean_droplet.webserver[count.index].ipv4_address
      private_key = file("~/.ssh/id_rsa")
    }
   } 
 }

# Write credentials to file and run ansible
resource "null_resource" "devstxt" {
  count = length(var.dnsrecord)
  provisioner "local-exec" {
    command = "echo [all] > inventory && echo ${digitalocean_droplet.webserver[count.index].ipv4_address} ansible_user=${var.do_droplet_user} >> inventory"
  }

# Installing Python minimal to prepare Droplet for Ansible provisioning
  provisioner "local-exec" {
    command = "ansible-playbook  -i inventory  python/main.yml" 
}
# Installing nginx and take it Let`s Encrypt sertificates
  provisioner "local-exec" {
    command = "ansible-playbook  -i inventory -e \"nginx_site_name=${element(var.dnsrecord, count.index)}.${var.aws_route53_zone}\" nginx.yml" 
}
# Prepare Droplet to use app on php
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory -e \"postgres_db=${var.postgres_db}\" -e \"postgres_user=${var.postgres_user}\" -e \"postgres_passwd=${var.postgres_passwd}\"  webapp.yml" 

  }
}
	
