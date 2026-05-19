# Subnet
resource "aws_subnet" "public_dhcp" {
  for_each = local.az_set

  vpc_id                          = aws_vpc.main.id
  availability_zone               = each.key
  map_public_ip_on_launch         = true
  cidr_block                      = cidrsubnet(var.vpc_cidr, var.subnet_newbits, (index(var.availability_zones, each.key) + 0) * 2 + 1)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, var.subnet_newbits_v6, (index(var.availability_zones, each.key) + 0) * 2 + 1)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.project_name}-Public-DHCP-Subnet-${each.key}"
  }
}

resource "aws_subnet" "public_static" {
  for_each = local.az_set

  vpc_id                          = aws_vpc.main.id
  availability_zone               = each.key
  map_public_ip_on_launch         = true
  cidr_block                      = cidrsubnet(var.vpc_cidr, var.subnet_newbits, (index(var.availability_zones, each.key) + 0) * 2 + 0)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, var.subnet_newbits_v6, (index(var.availability_zones, each.key) + 0) * 2 + 0)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.project_name}-Public-Static-Subnet-${each.key}"
  }
}

resource "aws_subnet" "egress_dhcp" {
  for_each = local.az_set

  vpc_id                          = aws_vpc.main.id
  availability_zone               = each.key
  cidr_block                      = cidrsubnet(var.vpc_cidr, var.subnet_newbits, (index(var.availability_zones, each.key) + 10) * 2 + 1)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, var.subnet_newbits_v6, (index(var.availability_zones, each.key) + 10) * 2 + 1)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.project_name}-Egress-DHCP-Subnet-${each.key}"
  }
}

resource "aws_subnet" "egress_static" {
  for_each = local.az_set

  vpc_id                          = aws_vpc.main.id
  availability_zone               = each.key
  cidr_block                      = cidrsubnet(var.vpc_cidr, var.subnet_newbits, (index(var.availability_zones, each.key) + 10) * 2 + 0)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, var.subnet_newbits_v6, (index(var.availability_zones, each.key) + 10) * 2 + 0)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.project_name}-Egress-Static-Subnet-${each.key}"
  }
}

resource "aws_subnet" "private_dhcp" {
  for_each = local.az_set

  vpc_id                          = aws_vpc.main.id
  availability_zone               = each.key
  cidr_block                      = cidrsubnet(var.vpc_cidr, var.subnet_newbits, (index(var.availability_zones, each.key) + 20) * 2 + 1)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, var.subnet_newbits_v6, (index(var.availability_zones, each.key) + 20) * 2 + 1)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.project_name}-Private-DHCP-Subnet-${each.key}"
  }
}

resource "aws_subnet" "private_static" {
  for_each = local.az_set

  vpc_id                          = aws_vpc.main.id
  availability_zone               = each.key
  cidr_block                      = cidrsubnet(var.vpc_cidr, var.subnet_newbits, (index(var.availability_zones, each.key) + 20) * 2 + 0)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, var.subnet_newbits_v6, (index(var.availability_zones, each.key) + 20) * 2 + 0)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.project_name}-Private-Static-Subnet-${each.key}"
  }
}