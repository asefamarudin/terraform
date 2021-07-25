

// Create aws_ami filter to pick up the ami available in your region
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

// Configure the EC2 instance in a public subnet
resource "aws_instance" "ec2_public" {
  ami                         = "ami-055147723b7bca09a"
  associate_public_ip_address = true
  instance_type               = "t2.medium"
  key_name                    = var.key_name
  subnet_id                   = var.vpc.public_subnets[0]
  vpc_security_group_ids      = [var.sg_pub_id]

  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.delete_on_termination
  }
  
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = var.volume_size
    volume_type = var.volume_type
  }


  tags = {
    "Name" = "${var.namespace}-EC2-PUBLIC"
  }

  # Copies the ssh key file to home dir
  provisioner "file" {
    source      = "./${var.key_name}.pem"
    destination = "/home/ubuntu/${var.key_name}.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.key_name}.pem")
      host        = self.public_ip
    }
  }
  
  //chmod key 400 on EC2 instance
  provisioner "remote-exec" {
    inline = [
      "chmod 400 ~/${var.key_name}.pem",
      "sudo apt update -y"

    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.key_name}.pem")
      host        = self.public_ip
    }

  }

}

// Configure the EC2 instance in a private subnet
//resource "aws_instance" "ec2_public" {
//  ami                         = data.aws_ami.amazon-linux-2.id
//  associate_public_ip_address = false
//  instance_type               = "t2.micro"
//  key_name                    = var.key_name
//  subnet_id                   = var.vpc.private_subnets[1]
//  vpc_security_group_ids      = [var.sg_priv_id]

//  tags = {
//    "Name" = "${var.namespace}-EC2-PRIVATE"
//  }

// }
