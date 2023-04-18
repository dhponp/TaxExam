terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

variable "port" {
  type    = number
  default = 8080
}

variable "namespace" {
  type    = string
  default = "exam"
}

variable "containers_ports" {
  type = object({
    port = number
	node_port = number
    target_port = number
  })
  default = (
    {
      port = 8080
	  node_port = 30201
      target_port = 80
    })
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
resource "kubernetes_namespace" "exam" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "exam" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.exam.metadata.0.name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "taxExam"
      }
    }
    template {
      metadata {
        labels = {
          app = "taxExam"
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "nginx-container"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "exam" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.exam.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.exam.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {	  
        node_port   = var.containers_ports.node_port
        port        = var.containers_ports.port
        target_port = var.containers_ports.target_port
    }
  }
}