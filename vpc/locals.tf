locals {
  az_set = toset(var.availability_zones)

  subnet_type_offsets = {
    public_static = 0
    public_dhcp   = 1
    egress_static = 2
    egress_dhcp   = 3
    private_static= 4
    private_dhcp  = 5
  }
}
