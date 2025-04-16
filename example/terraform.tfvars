project_id = "nw-opstree-dev-landing-zone"

vpc_name = "network-vpc"

auto_create_subnetworks = false

# Subnets Configuration
subnets = [
  {
    name                     = "subnet-1"
    region                   = "us-central1"
    ip_cidr_range            = "10.0.1.0/24"
    private_ip_google_access = true
    secondary_ranges = [
      {
        range_name    = "secondary-range-1"
        ip_cidr_range = "192.168.1.0/24"
      }
    ]
  },
  {
    name                     = "subnet-2"
    region                   = "us-east1"
    ip_cidr_range            = "10.0.2.0/24"
    private_ip_google_access = false
    secondary_ranges         = []
  }
]

aggregation_interval = "INTERVAL_5_SEC"

flow_sampling = "0.5"

metadata = "INCLUDE_ALL_METADATA"

service_projects = ["service-project-testing", "service-project-testing-2"]

routers = {
  "router-us-central1" = {
    network = "new-vpc"
    region  = "us-central1"
    bgp_asn = 64512
  }

  "router-europe-west1" = {
    network = "test-vpc"
    region  = "europe-west1"
    bgp_asn = 64513
  }
}

nats = [
  {
    name                   = "nat-us-central1"
    router_name            = "router-us-central1"
    nat_region             = "us-central1"
    nat_ip_allocate_option = "AUTO_ONLY"
    source_subnet_ranges   = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    static_ips             = []
  },
  {
    name                   = "nat-europe-west1"
    router_name            = "router-europe-west1"
    nat_region             = "europe-west1"
    nat_ip_allocate_option = "MANUAL_ONLY"
    source_subnet_ranges   = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    static_ips             = ["nat-static-ip-1", "nat-static-ip-2"]
  }
]