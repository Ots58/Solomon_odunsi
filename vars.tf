variable "vpc_cidr"{
    default = "10.0.0.0/16"
}
variable "AWS_ACCESS_KEY"{
    description="AWS Access Key"
}
variable "AWS_SECRET_KEY"{
    description="AWS Access Key"
}
variable "AWS_REGION"{
    default="us-west-2"
    description="AWS Region"
}
# Network Mask - 255.255.255.0 Addresses Available - 256


variable "public_cidr"{
    default = "10.0.1.0/24"
}
variable "public_cidr2"{
    default = "10.0.4.0/24"
}
variable "private_cidr"{
    default = "10.0.2.0/24"
}
variable "private_cidr2"{
    default = "10.0.3.0/24"
}
variable "cidr_blocks"{
    default = "0.0.0.0/0"
}
variable "instance_type"{
    default = "t3.micro"
}
variable "apac_region"{
    default="us-west-2"
}

variable "AMIS"{
    type = map(string)
    description= "Region specific AWS Machine Images (AMI)"
    default={
        us-east-1 = "ami-0d2017e886fc2c0ab"
        us-west-2 = "ami-00448a337adc93c05"
    }
    }