resource "aws_security_group" "public" {
  name        = "SG-Common-Public"
  description = "SG-Common-Public"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Public"
  }
}
resource "aws_security_group_rule" "public-ssh-bastion" {
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  source_security_group_id = aws_security_group.bastion.id
}
resource "aws_security_group_rule" "public-rdp-bastion" {
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3389
  to_port           = 3389
  source_security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group" "egress" {
  name        = "SG-Common-Egress"
  description = "SG-Common-Egress"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Egress"
  }
}
resource "aws_security_group_rule" "egress-ssh-bastion" {
  security_group_id = aws_security_group.egress.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  source_security_group_id = aws_security_group.bastion.id
}
resource "aws_security_group_rule" "egress-rdp-bastion" {
  security_group_id = aws_security_group.egress.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3389
  to_port           = 3389
  source_security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group" "private" {
  name        = "SG-Common-Private"
  description = "SG-Common-Private"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Private"
  }
}
resource "aws_security_group_rule" "private-ssh-bastion" {
  security_group_id = aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  source_security_group_id = aws_security_group.bastion.id
}
resource "aws_security_group_rule" "private-rdp-bastion" {
  security_group_id = aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3389
  to_port           = 3389
  source_security_group_id = aws_security_group.bastion.id
}
