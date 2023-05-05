output "ipv4_address" {
  value = hcloud_server.node.ipv4_address
}

output "ipv6_address_1" {
  value = hcloud_server.node.ipv6_address
}

#output "ipv6_address_2" {
#  value = hcloud_floating_ip.fip1.ip_address
#}
