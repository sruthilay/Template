provider "aws" {
  region     = "us-west-2"
}

#create security group ,allow ssh and http

resource "aws_security_group" "webserver_access" {
        name = "webserver_access"
        description = "allow ssh and http"

        ingress {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["55.55.55.55/0"]
        }

        ingress {
                from_port = 22
                to_port = 22
                protocol = "tcp"
                cidr_blocks = ["55.55.55.55/0"]
        }

        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["55.55.55.55/0"]
        }


}
#security group end here

#creating aws ec2 instance 

resource "aws_instance" "webserver" {
  ami           = "ami-0b28dfc7adc325ef4"
  availability_zone = "us-west-2"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.webserver_access.name}"]
  key_name = "webserver"
  user_data = <<-EOF
        #!/bin/bash -xe
        sudo yum install httpd -y
        sudo systemctl start httpd
        sudo systemctl enable httpd
        echo "<h1>sample webserver using terraform</h1>" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    Name  = "webserver"
    Stage = "testing"
    Location = "USA"
  }

}
