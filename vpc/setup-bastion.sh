#!/bin/bash
sudo yum install iptables-services -y
sudo systemctl enable iptables
sudo systemctl start iptables

# Enable IP forwarding for both IPv4 and IPv6
echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/99-ip-forward.conf
echo "net.ipv6.conf.all.forwarding=1" | sudo tee -a /etc/sysctl.d/99-ip-forward.conf
sudo sysctl -p /etc/sysctl.d/99-ip-forward.conf

# Get the primary network interface name dynamically
INTERFACE=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)

# Configure iptables for IPv4 NAT
sudo /sbin/iptables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE
sudo /sbin/iptables -F FORWARD

# Configure ip6tables for IPv6 NAT
sudo /sbin/ip6tables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE
sudo /sbin/ip6tables -F FORWARD

# Save the rules to be persistent on reboot
sudo service iptables save
