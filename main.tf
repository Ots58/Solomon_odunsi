provider "aws" {
  region     = var.AWS_REGION
  
}

# Creating our server EC2 instance 
 resource "aws_instance" "web_server_instance" {
    ami = var.AMIS[var.AWS_REGION] 
    instance_type = var.instance_type
    availability_zone = "us-west-2a"
    key_name = "vockey"
    subnet_id = aws_subnet.subnet-1.id
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]
    associate_public_ip_address = true

    user_data = file("user_data.sh")

    provisioner "local-exec"{
        command = "echo Instance Type=${self.instance_type},Instance ID=${self.id},Public DNS=${self.public_dns},AMI ID=${self.ami} >> allec2details"
    }
connection {
        type = "ssh"
        host = aws_instance.web_server_instance.public_ip
        user = "ec2-user"
        private_key=file("${path.module}/vockey.pem")
        
    }
        tags = {
          Name = "Web server"
        }
}
