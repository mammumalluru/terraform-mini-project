#### provider block

provider "aws" {

    region = "us-east-1"
  
}

###### vpc creation

resource "aws_vpc" "test_vpc" {

    cidr_block = "10.0.0.0/16"
  


tags = {

    Name = "test_vpc"
}

}

##### IGW creation

resource "aws_internet_gateway" "test_igw" {
    vpc_id = aws_vpc.test_vpc.id

   tags = {

    Name = "test_igw"
    } 
  
}


#### subnet creation public


resource "aws_subnet" "test_subnet" {
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = "10.0.1.0/24"

    tags = {

    Name = "test_igw"
    } 
  
}

##### route table creation

resource "aws_route_table" "test_public_rt" {
    vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }

    tags = {

    Name = "test_public_rt"
    } 
  
  
}

#### subnet association with route table

resource "aws_route_table_association" "test_rt_associate" {

    subnet_id = aws_subnet.test_subnet.id
    route_table_id = aws_route_table.test_public_rt.id
  
}

#### sg group creation

resource "aws_security_group" "test_sg" {
    vpc_id = aws_vpc.test_vpc.id
    ingress {
        from_port = 80
        to_port = 85
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  
}

####ec2-instance creation

resource "aws_instance" "test_instance" {
    ami = "ami-0f3caa1cf4417e51b"
    instance_type = "t2.small"
    key_name = "MC"
    subnet_id = aws_subnet.test_subnet.id
    vpc_security_group_ids = [aws_security_group.test_sg.id]
    associate_public_ip_address = true 

    ######A subnet becomes public only when it has a route to Internet Gateway and 
    ### auto-assign public IP is enabled. Without enabling map_public_ip_on_launch or 
    #### associate_public_ip_address, the instance will not receive a public IP even 
    #### if IGW route exists.
    user_data = file("userdata.sh")

    tags = {
      Name = "test_instance"
    }
  
}



