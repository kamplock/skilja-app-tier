resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_network_interface" "this" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]
}

resource "aws_instance" "this" {
  ami           = "ami-c998b6b2"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }

}