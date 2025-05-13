module "network-skeleton" {
  source                  = "./module"
  project_id              = var.project_id
  vpc_name                = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks
  subnets                 = var.subnets
  aggregation_interval    = var.aggregation_interval
  flow_sampling           = var.flow_sampling
  metadata                = var.metadata
  enable_shared_vpc       = var.enable_shared_vpc
  service_projects        = var.service_projects
  routers                 = var.routers
  nats                    = var.nats
}