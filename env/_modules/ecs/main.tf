#create namespace for ecs cluster
resource "aws_service_discovery_http_namespace" "main" {
  name = "cluster.${var.env}"
}

#create ecs cluster
resource "aws_ecs_cluster" "main" {
  name = var.env
  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.main.arn
  }
}
