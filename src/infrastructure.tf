# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "default" {
  name       = "ssh key"
  public_key = "${file("/home/mrbond/.ssh/id_rsa.pub")}"
}

resource "digitalocean_volume" "volume-tfo-01" {
  region      = "${var.region}"
  name        = "tfo-volume-01"
  size        = 10
  description = "Storage for The-Forgotten-01"
}

resource "digitalocean_droplet" "server-tfo-01" {
  name               = "the-forgotten-01"
  size               = "1gb"
  image              = "centos-7-x64"
  region             = "${var.region}"
  ipv6               = false
  private_networking = false
  resize_disk        = false
  volume_ids         = ["${digitalocean_volume.volume-tfo-01.id}"]
  ssh_keys           = ["${digitalocean_ssh_key.default.id}"]
}

resource "digitalocean_floating_ip" "ip-tfo-01" {
  droplet_id = "${digitalocean_droplet.server-tfo-01.id}"
  region     = "${digitalocean_droplet.server-tfo-01.region}"
}

# morgantown.ninja
resource "digitalocean_domain" "morgantown-ninja" {
  name       = "morgantown.ninja"
  ip_address = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

resource "digitalocean_record" "mn-www" {
  domain = "${digitalocean_domain.morgantown-ninja.name}"
  type   = "CNAME"
  name   = "www"
  value  = "@"
}


# The-Forgotten.Org
resource "digitalocean_domain" "the-forgotten-org" {
  name       = "the-forgotten.org"
  ip_address = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

resource "digitalocean_record" "tfo-www" {
  domain = "${digitalocean_domain.the-forgotten-org.name}"
  type   = "CNAME"
  name   = "www"
  value  = "@"
}

resource "digitalocean_record" "tfo-webmail" {
  domain = "${digitalocean_domain.the-forgotten-org.name}"
  type   = "A"
  name   = "webmail"
  value  = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

# kathnmike.us
resource "digitalocean_domain" "knm-us" {
  name       = "kathnmike.us"
  ip_address = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

resource "digitalocean_record" "knm-www" {
  domain = "${digitalocean_domain.knm-us.name}"
  type   = "CNAME"
  name   = "www"
  value  = "@"
}

resource "digitalocean_record" "knm-cloud" {
  domain = "${digitalocean_domain.knm-us.name}"
  type   = "A"
  name   = "cloud"
  value  = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

# baiyingpai.com
resource "digitalocean_domain" "byp" {
  name       = "baiyingpai.com"
  ip_address = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

resource "digitalocean_record" "byp-www" {
  domain = "${digitalocean_domain.byp.name}"
  type   = "CNAME"
  name   = "www"
  value  = "@"
}

# whiteeaglemartialarts.com
resource "digitalocean_domain" "wema" {
  name       = "whiteeaglemartialarts.com"
  ip_address = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

# fairmontflyers.org
resource "digitalocean_domain" "ff-org" {
  name       = "fairmontflyers.org"
  ip_address = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

resource "digitalocean_record" "ff-www" {
  domain = "${digitalocean_domain.ff-org.name}"
  type   = "CNAME"
  name   = "www"
  value  = "@"
}

resource "digitalocean_domain" "ff-com" {
  name       = "fairmontflyers.com"
  ip_address = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

# trumpocalyp.se
resource "digitalocean_domain" "trumpocalyp-se" {
  name       = "trumpocalyp.se"
  ip_address = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

# MX -- This needs switched to mail.the-forgotten.org when it moves over.
resource "digitalocean_record" "tfo-mx" {
  domain   = "${digitalocean_domain.morgantown-ninja.name}"
  type     = "MX"
  name     = "mail"
  value    = "@"
  priority = "1"
}
