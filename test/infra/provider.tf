provider "google-beta" {
  version     = "~> 1.20.0"
  credentials = "${var.google_credentials}"
  project     = "${var.google_project}"
  region      = "${local.region}"
  zone        = "${local.zone}"
}

provider "google" {
  version     = "~> 1.20.0"
  credentials = "${var.google_credentials}"
  project     = "${var.google_project}"
  region      = "${local.region}"
  zone        = "${local.zone}"
}

