# VPC Creation
resource "google_compute_network" "shared_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks
}

# Subnets
resource "google_compute_subnetwork" "subnet" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                     = each.value.name
  region                   = each.value.region
  network                  = google_compute_network.shared_vpc.id
  ip_cidr_range            = each.value.ip_cidr_range
  private_ip_google_access = each.value.private_ip_google_access

  dynamic "secondary_ip_range" {
    for_each = lookup(each.value, "secondary_ranges", [])

    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  # VPC Flow Log Configuration
  log_config {
    aggregation_interval = var.aggregation_interval
    flow_sampling        = var.flow_sampling
    metadata             = var.metadata
  }
}


# Shared VPC Host Project
resource "google_compute_shared_vpc_host_project" "host" {
  project = var.project_id
}

# Shared VPC Service Projects
resource "google_compute_shared_vpc_service_project" "service" {
  for_each        = toset(var.service_projects)
  host_project    = var.project_id
  service_project = each.value
}

# Cloud Router
resource "google_compute_router" "this" {
  for_each = var.routers

  name    = each.key
  network = google_compute_network.shared_vpc.id
  region  = each.value.region

  bgp {
    asn = each.value.bgp_asn
  }
}

# Cloud NAT
resource "google_compute_router_nat" "cloud_nat" {
  for_each                           = { for nat in var.nats : nat.name => nat }
  name                               = each.value.name
  router                             = google_compute_router.this[each.value.router_name].name
  region                             = each.value.nat_region
  nat_ip_allocate_option             = each.value.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = each.value.source_subnet_ranges

  nat_ips = (
    each.value.nat_ip_allocate_option == "MANUAL_ONLY"
    ? flatten([for ip in each.value.static_ips : google_compute_address.static_nat_ips["${each.value.name}-${ip}"].self_link])
    : []
  )
}

# Reserve Static IPs (Only if needed)
resource "google_compute_address" "static_nat_ips" {
  for_each = { for pair in flatten([
    for nat in var.nats : [
      for ip in nat.static_ips : {
        key   = "${nat.name}-${ip}"
        value = { ip = ip, region = nat.nat_region }
      }
    ]
  ]) : pair.key => pair.value }

  name   = each.value.ip
  region = each.value.region
}
