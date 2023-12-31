#do we need an ec2 instance? yes, their networking config 
#(dont know yet, be prepared for them to change, variablize them)
#vpc module - mult az's, s3bucket
# Create ALB Security Group
resource "aws_security_group" "alb-sg" {
  name        = "vpc_alb_sg"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id
ingress {
    description      = "all traffic from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

#create Ec2 security group
resource "aws_security_group" "ec2-sg" {
  name        = "ec2-sg"
  description = "Allows ALB to access the EC2 instances"
  vpc_id      = aws_vpc.my_vpc.id
ingress {
    description      = "TLS from ALB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb-sg.id] 
  }
ingress {
    description      = "TLS from ALB"
    from_port        = 8443
    to_port          = 8443
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb-sg.id]
    
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# Create Database Security Group
resource "aws_security_group" "rds-sg" {
  name        = "RDS-SG"
  description = "Allows application to access the RDS instances"
  vpc_id      = aws_vpc.my_vpc.id
ingress {
    description      = "EC2 to MYSQL"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.ec2-sg.id]
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}