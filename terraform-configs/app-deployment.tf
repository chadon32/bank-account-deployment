resource "kubernetes_deployment" "bankapp" {
  metadata {
    name = "bankapp"
    labels = {
      app = "bankapp"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "bankapp"
      }
    }
    template {
      metadata {
        labels = {
          app = "bankapp"
        }
      }
      spec {
        container {
          name  = "bankapp"
          image = "chadon32/bankapp-image"  # Replace with your image in JFrog
          port {
            container_port = 8000
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
          env {
            name  = "POSTGRES_HOST"
            value = "postgres"  # Kubernetes service name for PostgreSQL
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "bankapp_service" {
  metadata {
    name = "bankapp-service"
  }
  spec {
    selector = {
      app = "bankapp"
    }
    port {
      port        = 8000
      target_port = 8000
    }
    type = "NodePort"  # Expose service outside of Kubernetes
  }
}
