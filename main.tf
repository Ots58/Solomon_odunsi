provider "aws" {
  region     = ""
  access_key = ""
  secret_key = ""
}

# Creating a Network Interface for interacting with services within the network
resource "aws_network_interface" "test" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

  #  attachment {
  #    instance     = aws_instance.web_server_instance.id
  #    device_index = 1
  # }
}
# Creating Elastic IP for the subnet to access the internet 
resource "aws_eip" "one" {
     
     network_interface = aws_network_interface.test.id 
     associate_with_private_ip = "10.0.1.50"
     depends_on = [ aws_internet_gateway.gw ]

  
 }


# Creating our server EC2 instance 
 resource "aws_instance" "web_server_instance" {
    ami = "ami-0571c1aedb4b8c5fc"
    instance_type = "t2.micro"
    availability_zone = "us-west-2a"
    key_name = "main-key"

 network_interface {
   device_index = 0
   network_interface_id = aws_network_interface.test.id

 }

provisioner "remote-exec"{
        inline = [
            "sudo yum update -y",
            "sudo yum install -y nginx",
            "sudo service nginx start"
        ]
        on_failure = continue
    }
    
    provisioner "local-exec"{
        #ami=data.aws_ami.packeramis.id
        #instance_type="t2.micro"
        #when = "destroy"
        command = "echo Instance Type=${self.instance_type},Instance ID=${self.id},Public DNS=${self.public_dns},AMI ID=${self.ami} >> allec2details"
    }
connection {
        type = "ssh"
        host = aws_instance.web_server_instance.public_ip
        user = "ec2-user"
        private_key=file("${path.module}/main-key.pem")
        
    }
        tags = {
          Name = "Web server"
        }
}
resource "aws_s3_bucket" "web_s3" {
  bucket = "webe-s3-test-bucket"

  tags = {
    Name   = "webe-s3-bucket"
  }
}

   
