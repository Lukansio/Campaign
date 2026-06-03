# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Environment = "dev"
    Name = "milky-way"
  }
}

# Gateway
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
    tags = {
      Name = "Project VPC GW"
    }
}

# Route Table
resource "aws_route_table" "second_rt" {
 vpc_id = aws_vpc.main.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
 
 tags = {
   Name = "2nd Route Table"
 }
}

# Route Table Association

resource "aws_route_table_association" "public_subnet_asso" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.second_rt
}

# Create subnets
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "public-subnet-1"
  }
}

# EC2
resource "aws_instance" "jupiter" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id

  tags = {
    Name = "jupiter"
  }
}