provider "kubernetes" {
  config_path    = "C:/Users/chado/.kube/config"  # Path to your kubeconfig
  config_context = "microk8s"        # Ensure the context is set to MicroK8s
}
