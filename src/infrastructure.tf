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

resource "digitalocean_record" "mn-zoho-verify" {
  domain = "${digitalocean_domain.morgantown-ninja.name}"
  type   = "CNAME"
  name   = "zb15115206"
  value  = "zmverify.zoho.com."
}

resource "digitalocean_record" "mn-mx-1" {
  domain   = "${digitalocean_domain.morgantown-ninja.name}"
  type     = "MX"
  name     = "@"
  value    = "mx.zoho.com."
  priority = "10"
}

resource "digitalocean_record" "mn-mx-2" {
  domain   = "${digitalocean_domain.morgantown-ninja.name}"
  type     = "MX"
  name     = "@"
  value    = "mx2.zoho.com."
  priority = "20"
}

resource "digitalocean_record" "mn-mail" {
  domain   = "${digitalocean_domain.morgantown-ninja.name}"
  type     = "CNAME"
  name     = "mail"
  value    = "business.zoho.com."
}

resource "digitalocean_record" "mn-txt-spf" {
  domain   = "${digitalocean_domain.morgantown-ninja.name}"
  type     = "TXT"
  name     = "@"
  value    = "v=spf1 include:zoho.com ~all"
}

resource "digitalocean_record" "mn-txt-dkim" {
  domain   = "${digitalocean_domain.morgantown-ninja.name}"
  type     = "TXT"
  name     = "default._domainkey"
  value    = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCLoMjPHZMuXaxiW250MpOSobNHaWVBCOz7Eg/5hgl+wIdPWsm6tvXhWU2gYjb7V5r+ELtfAb0SiIeGewh5mTx2R2CjUMC4lyRyekTJ0oSopZwQ0qSA2AZJXzUFAJcwGLUM1ld3jOBks+BwMc1De5+EdvTHE6J4KYAhM0ki0kEW3QIDAQAB"
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

resource "digitalocean_record" "tfo-zoho-verify" {
  domain = "${digitalocean_domain.the-forgotten-org.name}"
  type   = "CNAME"
  name   = "zb15131287"
  value  = "zmverify.zoho.com."
}

resource "digitalocean_record" "tfo-mx-1" {
  domain   = "${digitalocean_domain.the-forgotten-org.name}"
  type     = "MX"
  name     = "@"
  value    = "mx.zoho.com."
  priority = "10"
}

resource "digitalocean_record" "tfo-mx-2" {
  domain   = "${digitalocean_domain.the-forgotten-org.name}"
  type     = "MX"
  name     = "@"
  value    = "mx2.zoho.com."
  priority = "20"
}

resource "digitalocean_record" "tfo-mail" {
  domain   = "${digitalocean_domain.the-forgotten-org.name}"
  type     = "CNAME"
  name     = "mail"
  value    = "business.zoho.com."
}

resource "digitalocean_record" "tfo-txt-spf" {
  domain   = "${digitalocean_domain.the-forgotten-org.name}"
  type     = "TXT"
  name     = "@"
  value    = "v=spf1 include:zoho.com ~all"
}

resource "digitalocean_record" "tfo-txt-dkim" {
  domain   = "${digitalocean_domain.the-forgotten-org.name}"
  type     = "TXT"
  name     = "default._domainkey"
  value    = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDFtkeis2wvQtguE53VaWD9F4JsLalqyQE6qnWYl2uaXZ/RtVQGaMe1/6D92RjH6A+hO3i5RmHIZEuW4LzO40SMONLV4bgjwGCGPeaJxoRu8whGENoFoNsSEbNCMSBSqhwpFaATHUCqzzU9DMy/S3z+n34yozoC3K7QNTMtiPHVxwIDAQAB"
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

resource "digitalocean_record" "knm-readwords" {
  domain = "${digitalocean_domain.knm-us.name}"
  type   = "A"
  name   = "readwords"
  value  = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

resource "digitalocean_record" "knm-zoho-verify" {
  domain = "${digitalocean_domain.knm-us.name}"
  type   = "CNAME"
  name   = "zb15128406"
  value  = "zmverify.zoho.com."
}

resource "digitalocean_record" "knm-mx-1" {
  domain   = "${digitalocean_domain.knm-us.name}"
  type     = "MX"
  name     = "@"
  value    = "mx.zoho.com."
  priority = "10"
}

resource "digitalocean_record" "knm-mx-2" {
  domain   = "${digitalocean_domain.knm-us.name}"
  type     = "MX"
  name     = "@"
  value    = "mx2.zoho.com."
  priority = "20"
}

resource "digitalocean_record" "knm-mail" {
  domain   = "${digitalocean_domain.knm-us.name}"
  type     = "CNAME"
  name     = "mail"
  value    = "business.zoho.com."
}

resource "digitalocean_record" "knm-txt-spf" {
  domain   = "${digitalocean_domain.knm-us.name}"
  type     = "TXT"
  name     = "@"
  value    = "v=spf1 include:zoho.com ~all"
}

resource "digitalocean_record" "knm-txt-dkim" {
  domain   = "${digitalocean_domain.knm-us.name}"
  type     = "TXT"
  name     = "default._domainkey"
  value    = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCZcsasfx+4BqR5OopqdfNrTSMx/lIXXhzzhsqaTIb/lIwLTZso+XViFyZO+ClQ3Rd1Y2s3BQYl38saasp88TL+g9grHGiy88wiRNDdkhWjD1xmZBB1O6xAE6HboL+ZsXripYk3MPIRULK1dmPpNWCvTmcaC4d/MrejDr6XFqqq4wIDAQAB"
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

resource "digitalocean_record" "byp-zoho-verify" {
  domain = "${digitalocean_domain.byp.name}"
  type   = "CNAME"
  name   = "zb15127705"
  value  = "zmverify.zoho.com."
}

resource "digitalocean_record" "byp-mx-1" {
  domain   = "${digitalocean_domain.byp.name}"
  type     = "MX"
  name     = "@"
  value    = "mx.zoho.com."
  priority = "10"
}

resource "digitalocean_record" "byp-mx-2" {
  domain   = "${digitalocean_domain.byp.name}"
  type     = "MX"
  name     = "@"
  value    = "mx2.zoho.com."
  priority = "20"
}

resource "digitalocean_record" "byp-mail" {
  domain   = "${digitalocean_domain.byp.name}"
  type     = "CNAME"
  name     = "mail"
  value    = "business.zoho.com."
}

resource "digitalocean_record" "byp-txt-spf" {
  domain   = "${digitalocean_domain.byp.name}"
  type     = "TXT"
  name     = "@"
  value    = "v=spf1 include:zoho.com ~all"
}

resource "digitalocean_record" "byp-txt-dkim" {
  domain   = "${digitalocean_domain.byp.name}"
  type     = "TXT"
  name     = "default._domainkey"
  value    = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCkd9SMGGSof1/cGYPKARbgsAZaV/1wNLkhRBgndZIGi1cex/PRqigY+umbJXLB+KgQpxpEza06c2+w2FkjjrFbikcVKNQzluKxoYuH8B2VGE0QJzgPuqFfRNUJBOOAwr5lpvKhknrITX+JA06RQhhTFm+baD8T5c/eYGCodmGl8QIDAQAB"
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

resource "digitalocean_record" "ff-forums" {
  domain = "${digitalocean_domain.ff-org.name}"
  type   = "CNAME"
  name   = "forums"
  value  = "@"
}

resource "digitalocean_record" "ff-zoho-verify" {
  domain = "${digitalocean_domain.ff-org.name}"
  type   = "CNAME"
  name   = "zb15129143"
  value  = "zmverify.zoho.com."
}

resource "digitalocean_record" "ff-mx-1" {
  domain   = "${digitalocean_domain.ff-org.name}"
  type     = "MX"
  name     = "@"
  value    = "mx.zoho.com."
  priority = "10"
}

resource "digitalocean_record" "ff-mx-2" {
  domain   = "${digitalocean_domain.ff-org.name}"
  type     = "MX"
  name     = "@"
  value    = "mx2.zoho.com."
  priority = "20"
}

resource "digitalocean_record" "ff-mail" {
  domain   = "${digitalocean_domain.ff-org.name}"
  type     = "CNAME"
  name     = "mail"
  value    = "business.zoho.com."
}

resource "digitalocean_record" "ff-txt-spf" {
  domain   = "${digitalocean_domain.ff-org.name}"
  type     = "TXT"
  name     = "@"
  value    = "v=spf1 include:zoho.com ~all"
}

resource "digitalocean_record" "ff-txt-dkim" {
  domain   = "${digitalocean_domain.ff-org.name}"
  type     = "TXT"
  name     = "default._domainkey"
  value    = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCkhugFc1Aq7Ib7lZUONlgeFGBSxNInogwqyQgbp7MDkiEyWntxFKhdWWNWwN0JiLWwamISDFJCM9DLINqE7yyuODTTfGWvVr1hrsk8eypA2q/aSazs3GnKmDOjQh3Yt5Ax1MBRR5AbtS0541Yfrj6nmcLFnEk+6VviirjZ0Fv0yQIDAQAB"
}

resource "digitalocean_domain" "ff-com" {
  name       = "fairmontflyers.com"
  ip_address = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

resource "digitalocean_domain" "ff-forums" {
  name       = "forums.fairmontflyers.com"
  ip_address = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

# trumpocalyp.se
resource "digitalocean_domain" "trumpocalyp-se" {
  name       = "trumpocalyp.se"
  ip_address = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

# emmasbond.me
resource "digitalocean_domain" "esb" {
  name       = "emmasbond.me"
  ip_address = "${digitalocean_floating_ip.ip-tfo-01.ip_address}"
}

resource "digitalocean_record" "esb-www" {
  domain = "${digitalocean_domain.esb.name}"
  type   = "CNAME"
  name   = "www"
  value  = "@"
}

resource "digitalocean_record" "esb-zoho-verify" {
  domain = "${digitalocean_domain.esb.name}"
  type   = "CNAME"
  name   = "zb15170623"
  value  = "zmverify.zoho.com."
}

resource "digitalocean_record" "esb-mx-1" {
  domain   = "${digitalocean_domain.esb.name}"
  type     = "MX"
  name     = "@"
  value    = "mx.zoho.com."
  priority = "10"
}

resource "digitalocean_record" "esb-mx-2" {
  domain   = "${digitalocean_domain.esb.name}"
  type     = "MX"
  name     = "@"
  value    = "mx2.zoho.com."
  priority = "20"
}

resource "digitalocean_record" "esb-mail" {
  domain   = "${digitalocean_domain.esb.name}"
  type     = "CNAME"
  name     = "mail"
  value    = "business.zoho.com."
}

resource "digitalocean_record" "esb-txt-spf" {
  domain   = "${digitalocean_domain.esb.name}"
  type     = "TXT"
  name     = "@"
  value    = "v=spf1 include:zoho.com ~all"
}

resource "digitalocean_record" "esb-txt-dkim" {
  domain   = "${digitalocean_domain.esb.name}"
  type     = "TXT"
  name     = "default._domainkey"
  value    = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCuImSJY10ciUV029Yzhfbe698F+SWM4F3CLytjfdwsB1+A9MHcJD8hvrG42I60re9e4WRj/rwZmJGrFkNRRZUP6qQZGUL1aNWwXGfLhwS1JjE49YGpUqyOgImORdZB2nknLB0q/wRdJ2U2WkoIGQWzsXa7oJ5NaUJxu/j1GaPZUwIDAQAB"
}
