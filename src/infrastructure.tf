# Configure the DigitalOcean Provider
provider "digitalocean" {
  token   = var.do_token
  version = "~> 2.3.0"
}

resource "digitalocean_ssh_key" "default" {
  name       = "ssh key"
  public_key = file("/home/mbond/.ssh/id_rsa.pub")
}

resource "digitalocean_volume" "volume-tfo-01" {
  region      = var.region
  name        = "tfo-volume-01"
  size        = 10
  description = "Storage for The-Forgotten-01"
}

resource "digitalocean_droplet" "server-tfo-01" {
  name               = "the-forgotten-01"
  size               = "1gb"
  image              = 25045709
  region             = var.region
  ipv6               = false
  private_networking = false
  resize_disk        = false
  volume_ids         = [digitalocean_volume.volume-tfo-01.id]
  ssh_keys           = [digitalocean_ssh_key.default.id]
  backups            = true
}

resource "digitalocean_floating_ip" "ip-tfo-01" {
  droplet_id = digitalocean_droplet.server-tfo-01.id
  region     = digitalocean_droplet.server-tfo-01.region
}
