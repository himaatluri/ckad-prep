provider "google" {
  version = "~> 3.28"

  project = "gcp-kubernetes-278403"
  region  = "us-east1"
  zone    = "us-east1-b"
}

data "google_client_config" "current" {}

resource "google_project_service" "cloudbuild_service" {
  project = "gcp-kubernetes-278403"
  service = "cloudbuild.googleapis.com"

  disable_dependent_services = true
}

resource "google_container_cluster" "mycluster" {
  name                     = "hatluri"
  location                 = "us-east1-b"
  min_master_version       = "1.14.10-gke.36"
  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    identity_namespace = "${data.google_client_config.current.project}.svc.id.goog"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "24.183.83.56/32"
      display_name = "MyHome"
    }
  }

  network    = "projects/gcp-kubernetes-278403/global/networks/gke-vpc"
  subnetwork = "projects/gcp-kubernetes-278403/regions/us-east1/subnetworks/gke-vpc-use1-subnet"
}

resource "google_container_node_pool" "mycluster_nodes" {
  name       = "hatluri-node-pool"
  location   = "us-east1-b"
  cluster    = google_container_cluster.mycluster.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}