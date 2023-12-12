### VARIABLES
locals {
  operation_system = "ubuntu"
  aws_region = "us-east-1"
  instance_type = "t3.micro"
  source_ami = "ami-0c963f6bcc1bd3353"
}

variable "aws_access_key" {
  type    = string
}

variable "aws_secret_key" {
  type = string
}

### CODE

source "amazon-ebs" "wordpress" {
  access_key    = "${var.aws_access_key}"
  ami_name      = "demo-{{timestamp}}"
  instance_type = "${local.instance_type}"
  region        = "${local.aws_region}"
  secret_key    = "${var.aws_secret_key}"
  source_ami    = "${local.source_ami}"
  ssh_username  = "${local.operation_system}"
}

build {
  sources = ["source.amazon-ebs.wordpress"]

  provisioner "ansible" {
    playbook_file  = "../ansible/playbook.yml"
    extra_arguments = ["-vvv"]
    user = "${local.operation_system}"
  }

  post-processor "shell-local" {
    type = "shell-local"
    inline = [
      "echo 'packer_image_id={{.ImageID}}' > ami-id.txt"
    ]
  }
}
