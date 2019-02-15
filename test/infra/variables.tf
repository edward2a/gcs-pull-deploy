### PROVIDER - BEGIN ###
variable google_credentials {}
variable google_project {}
variable google_default_region { default="europe-west2" }
variable google_default_zone { default="europe-west2-b" }
### PROVIDER - END ###

### GENERAL - BEGIN ###
variable region { "default"="" }
variable zone   { "default"="" }

locals {
  region  = "${var.region == "" ? var.google_default_region : var.region}"
  zone    = "${var.zone == "" ? var.google_default_zone : var.zone}"
}
### GENERAL - END ###
