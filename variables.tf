# VARIABLES
variable "do_token" {
         description = " (Required) This is the DO API token"
}
variable "AWS_ACCESS_KEY_ID" {
         type = string
         description = "AWS Security Credentials. Managed by the AWS client."
} 
variable "AWS_SECRET_ACCESS_KEY" {
         type = string
         description = "AWS Security Credentials. Managed by the AWS client."
}
variable "aws_route53_zone" {
         type = string
         description = "(Required) This is the name of the hosted zone"
}

variable "aws_region" {
         description = "(Required) The region to start in"
}
variable "postgres_passwd" {
         description = "(Required) Password for postgres user in ansible roles"
}
variable "postgres_user" {
         description = "(Required) Postgres user in ansible roles"
}
variable "postgres_db" {
         description = "(Required) Postgres database name in ansible roles"
}
variable "do_droplet_region" {
         description = "(Required) The region to start in"
}
variable "do_droplet_size" {
         description = "(Required) The unique slug that indentifies the type of Droplet." # https://developers.digitalocean.com/documentation/v2/#list-all-sizes
}
variable "do_droplet_tag" {
         description = "(Optional) A list of the tags to be applied to this Droplet"
}
variable "do_droplet_user"{
         description = "(Optional) DO Droplet user. Is to be added to ansible inventory file"
}
variable "do_droplet_hostname" {
         description = "(Required) The Droplet name."
}
variable "do_droplet_image" {
         description = "(Required) The Droplet image ID or slug"
}
variable "dnsrecord"{
         description = ""
}
variable "additional_ssh_key" {
         description = "(Optional). The ssh key to add additioanly to your`s Droplets"
}
