resource "kubernetes_persistent_volume" "pg_volume" {
  metadata {
    name = "pg-pv-volume"
  }
spec {
  capacity = {
    storage = "5Gi"
  }
  access_modes = ["ReadWriteOnce"]
  persistent_volume_source {
    host_path {
      path = "/mnt/data/postgres"
    }
  }
}




}

resource "kubernetes_persistent_volume_claim" "pg_claim" {
  metadata {
    name = "pg-pv-claim"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}
