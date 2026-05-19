# Bastion Instance
## Recent AMI
data "aws_ami" "bastion-base-image" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["bastion-base-image-*"]
  }
}

# Security Group
resource "aws_security_group" "bastion" {
  name        = "SG-Bastion"
  description = "SG-Bastion"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Bastion"
  }
}
resource "aws_security_group_rule" "bastion-vpc-ipv6" {
  type              = "ingress"
  security_group_id = aws_security_group.bastion.id
  description       = "From VPC"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  ipv6_cidr_blocks  = [aws_vpc.main.ipv6_cidr_block]
}
resource "aws_security_group_rule" "bastion-vpc-ipv4" {
  type              = "ingress"
  security_group_id = aws_security_group.bastion.id
  description       = "From VPC"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.main.cidr_block]
}
resource "aws_security_group_rule" "bastion-ssh-ipv4" {
  type              = "ingress"
  security_group_id = aws_security_group.bastion.id
  description       = "From Home"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.bastion_ssh_cidr
}
resource "aws_security_group_rule" "bastion-ssh-ipv6" {
  type              = "ingress"
  security_group_id = aws_security_group.bastion.id
  description       = "From Home"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  ipv6_cidr_blocks  = var.bastion_ssh_ipv6_cidr
}

## ElasticIP
resource "aws_eip" "bastion" {
  domain = "vpc"
  tags = {
    Name = "Bastion"
  }
}

## Instance IAM Role
resource "aws_iam_role" "bastion" {
  name = "EC2-Bastion"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "bastion" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "bastion" {
  name = aws_iam_role.bastion.name
  role = aws_iam_role.bastion.name
}

# Instance
resource "aws_instance" "bastion" {
  ami                     = data.aws_ami.bastion-base-image.id
  instance_type           = "t4g.micro"
  subnet_id               = aws_subnet.public_static[var.bastion_az].id
  vpc_security_group_ids  = [aws_security_group.bastion.id]
  source_dest_check       = false
  key_name                = "noriki-me_us-west-2"
  iam_instance_profile    = aws_iam_instance_profile.bastion.name
  user_data               = file("./setup-bastion.sh")
  disable_api_termination = false

  private_ip = cidrhost(aws_subnet.public_static[var.bastion_az].cidr_block, 4)

  ipv6_addresses = [
    cidrhost(aws_subnet.public_static[var.bastion_az].ipv6_cidr_block, 4)
  ]

  tags = {
    Name = "Bastion Instance"
  }
}

resource "aws_eip_association" "bastion" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}