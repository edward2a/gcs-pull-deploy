resource random_id bucket_suffix {
  byte_length = 4
}

resource google_storage_bucket test_bucket {
  name          = "gcs-pull-deploy-test-${random_id.bucket_suffix.hex}"
  storage_class = "REGIONAL"
  location      = "${local.region}"
}
