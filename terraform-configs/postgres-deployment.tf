resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres"
    labels = {
      app = "postgres"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "postgres"
      }
    }
    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }
      spec {
        container {
          name  = "postgres"
          image = "postgres:13"
          port {
            container_port = 5432
          }
          env {
            name  = "POSTGRES_DB"
            value = "bankaccount_db"
          }
          env {
            name  = "POSTGRES_USER"
            value = "postgres"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "your_password"  # Store sensitive data securely
          }
          volume_mount {
            name       = "pg-storage"
            mount_path = "/var/lib/postgresql/data"
          }
        }
        volume {
          name = "pg-storage"
          persistent_volume_claim {
            claim_name = "pg-pv-claim"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres_service" {
  metadata {
    name = "postgres"
  }
  spec {
    selector = {
      app = "postgres"
    }
    port {
      port        = 5432
      target_port = 5432
    }
    type = "ClusterIP"
  }
}
