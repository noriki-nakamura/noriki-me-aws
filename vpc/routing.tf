# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project_name}-Public-RouteTable" }
}
resource "aws_route" "public_to_v4_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}
resource "aws_route" "public_to_v6_internet" {
  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::0/0"
  gateway_id                  = aws_internet_gateway.main.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project_name}-Private-RouteTable" }
}

resource "aws_route_table" "egress" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project_name}-Egress-RouteTable" }
}
resource "aws_route" "egress_to_v4_internet" {
  route_table_id         = aws_route_table.egress.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.bastion.primary_network_interface_id
}
resource "aws_route" "egress_to_v6_internet" {
  route_table_id              = aws_route_table.egress.id
  destination_ipv6_cidr_block = "::0/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.main.id
}

resource "aws_route_table_association" "public_dhcp" {
  for_each       = local.az_set
  subnet_id      = aws_subnet.public_dhcp[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_static" {
  for_each       = local.az_set
  subnet_id      = aws_subnet.public_static[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "egress_dhcp" {
  for_each       = local.az_set
  subnet_id      = aws_subnet.egress_dhcp[each.key].id
  route_table_id = aws_route_table.egress.id
}

resource "aws_route_table_association" "egress_static" {
  for_each       = local.az_set
  subnet_id      = aws_subnet.egress_static[each.key].id
  route_table_id = aws_route_table.egress.id
}

resource "aws_route_table_association" "private_dhcp" {
  for_each       = local.az_set
  subnet_id      = aws_subnet.private_dhcp[each.key].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_static" {
  for_each       = local.az_set
  subnet_id      = aws_subnet.private_static[each.key].id
  route_table_id = aws_route_table.private.id
}