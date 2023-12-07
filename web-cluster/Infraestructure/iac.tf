terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_ssh_key" "ansible-lab-sshkey" {
  name = "ansible-lab-sshkey"
  public_key = file("../sshkeys/sshkey.pub")
}

// Creating webserver.#
resource "digitalocean_droplet" "web_server" {
  count      = 3
  image      = "debian-12-x64"
  name       = "webserver.${count.index}"
  region     = "nyc1"
  size       = "s-1vcpu-1gb"
  monitoring = true
  ssh_keys = [
    digitalocean_ssh_key.ansible-lab-sshkey.fingerprint
  ]
}

resource "digitalocean_droplet" "proxy_server" {
  image      = "debian-12-x64"
  name       = "proxy-server"
  region     = "nyc1"
  size       = "s-1vcpu-1gb"
  monitoring = true
  ssh_keys = [
    digitalocean_ssh_key.ansible-lab-sshkey.fingerprint
  ]
}

output "web_server_ip_address" {
  value       = digitalocean_droplet.web_server.*.ipv4_address
  description = "The public IP address of webserver*"
}

output "proxy_server_ip_address" {
  value       = digitalocean_droplet.proxy_server.ipv4_address
  description = "The public IP address of proxy."
}