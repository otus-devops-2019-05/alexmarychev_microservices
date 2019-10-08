variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default = "europe-west1"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable private_key_path {
  description = "Path to the private key used for provisions"
}

variable zone {
  description = "Zone for google_compute_instance"
  default     = "europe-west1-b"
}

variable "node_count" {
  description = "google compute instance count"
  default     = "1"
}
