### BUCKET ###

resource random_id bucket_suffix {
  byte_length = 4
}

resource google_storage_bucket test_bucket {
  name          = "gcs-pull-deploy-test-${random_id.bucket_suffix.hex}"
  storage_class = "REGIONAL"
  location      = "${local.region}"
  force_destroy = "true"
}


### BUCKET FILES ###

resource google_storage_bucket_object gcs_pd_pkg {
  name    = "pkg/gcs_pd.tar.gz"
  source  = "files/gcs-pd.tar.gz"
  bucket  = "${google_storage_bucket.test_bucket.name}"
}

resource google_storage_bucket_object go_hello {
  name    = "go-hello/pkg/go-hello.tar.gz"
  source  = "files/go-hello.tar.gz"
  bucket  = "${google_storage_bucket.test_bucket.name}"
}

resource google_storage_bucket_object deploy_config {
  name    = "go-hello/config/deploy"
  content = "ARTEFACT_URL=${google_storage_bucket_object.go_hello.bucket}/${google_storage_bucket_object.go_hello.name}"
  bucket  = "${google_storage_bucket.test_bucket.name}"
}


### VPC ###

resource google_compute_network gcs_pd_test {
  name = "gcs-pd-test"
  routing_mode = "REGIONAL"
  auto_create_subnetworks = "false"
}

resource google_compute_subnetwork gcs_pd_test_s1 {
  name = "gcs-pd-test-s1"
  region = "${local.region}"
  network = "${google_compute_network.gcs_pd_test.name}"
  ip_cidr_range = "172.16.0.0/24"
}


### INSTANCE ###

data template_file metadata_startup {

  template = "${file("files/metadata_startup.sh.tpl")}"
  vars = {
    bucket = "${google_storage_bucket_object.gcs_pd_pkg.bucket}"
    object = "${google_storage_bucket_object.gcs_pd_pkg.name}"
  }

}

data template_file gcs_deploy_test {
  template = "${file("files/gcs-pd-deploy-test.sh.tpl")}"
  vars = {
    bucket = "${google_storage_bucket_object.gcs_pd_pkg.bucket}"
  }
}

resource google_compute_instance gcs_pd_test {

  name          = "gcs-pd-test"
  machine_type  = "f1-micro"
  zone          = "${local.zone}"

  network_interface = {
    subnetwork    = "${google_compute_subnetwork.gcs_pd_test_s1.self_link}"
    access_config = {}
  }

  boot_disk         = {
    initialize_params = {
      image = "centos-7-v20190213"
    }
  }

  service_account = {
    scopes = ["monitoring-write", "logging-write", "storage-rw]
  }

  metadata_startup_script = "${data.template_file.metadata_startup.rendered}"
  metadata = {
    project_name  = "gcs-pd"
    service_name  = "go-hello"
    environment   = "dev"
    config_url    = "${google_storage_bucket.test_bucket.name}/go-hello/config/deploy"
  }

  provisioner local-exec {
    command     = "${data.template_file.gcs_deploy_test.rendered}"
    on_failure  = "continue"
  }
}
