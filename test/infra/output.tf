output test_endpoint {
  value = "${google_compute_instance.gcs_pd_test.network_interface.0.access_config.0.nat_ip}"
}
