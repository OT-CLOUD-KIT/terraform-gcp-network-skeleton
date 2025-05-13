output "vpc_id" {
  description = "The ID of the created VPC"
  value       = google_compute_network.shared_vpc.id
}

output "subnets" {
  description = "List of subnet self links"
  value       = { for k, v in google_compute_subnetwork.subnet : k => v.self_link }
}

output "subnet_ids" {
  description = "List of subnet names and their IDs"
  value       = { for k, v in google_compute_subnetwork.subnet : k => v.id }
}

output "host_project_id" {
  description = "ID of host project"
  value       = var.enable_shared_vpc ? google_compute_shared_vpc_host_project.host[0].project : null
}

output "attached_service_projects" {
  description = "ID of the service projects"
  value       = var.enable_shared_vpc ? [for p in google_compute_shared_vpc_service_project.service : p.service_project] : []
}

output "cloud_routers" {
  description = "Map of created Cloud Routers"
  value       = { for k, v in google_compute_router.this : k => v.name }
}

output "cloud_nat_names" {
  description = "Names of all Cloud NATs created"
  value       = { for k, v in google_compute_router_nat.cloud_nat : k => v.name }
}

output "nat_ip_allocate_options" {
  description = "NAT IP Allocation Methods"
  value       = { for k, v in google_compute_router_nat.cloud_nat : k => v.nat_ip_allocate_option }
}

output "static_nat_ips" {
  description = "List of allocated static NAT IPs per NAT"
  value       = { for k, v in google_compute_address.static_nat_ips : k => v[*].address }
}