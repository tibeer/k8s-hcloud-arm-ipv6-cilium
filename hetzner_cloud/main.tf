resource "hcloud_ssh_key" "key" {
  name       = var.name
  public_key = file(pathexpand(var.ssh_pubkey_path))
}

resource "hcloud_server" "node" {
  name        = var.name
  image       = var.image
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.key.name]
  server_type = var.server_type
  public_net {
    ipv4_enabled = var.ipv4_enabled
    ipv6_enabled = var.ipv6_enabled
  }
}

#resource "hcloud_floating_ip" "fip1" {
#  type      = "ipv6"
#  server_id = hcloud_server.node.id
#}
