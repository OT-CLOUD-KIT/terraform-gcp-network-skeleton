# Terraform GCP Network-Skeleton

[![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

This Terraform configuration provisions a Shared VPC setup with configurable subnets, VPC flow logs, Cloud Router, and Cloud NAT. It also supports secondary IP ranges, static NAT IP allocation, and attaches service projects to the shared VPC for centralized network management.


## Architecture

<img width="600" length="800" alt="Terraform" src="https://github.com/user-attachments/assets/22a28392-0bb2-47c9-802e-99ec9a9f7246">

## Providers

| Name                                              | Version  |
|---------------------------------------------------|----------|
| <a name="provider_gcp"></a> [gcp](#provider\_gcp) | 5.0.0   |

## Usage

```hcl
module "network-skeleton" {
  source                  = "./module"
  project_id              = var.project_id
  vpc_name                = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks
  subnets                 = var.subnets
  aggregation_interval    = var.aggregation_interval
  flow_sampling           = var.flow_sampling
  metadata                = var.metadata
  service_projects        = var.service_projects
  routers                 = var.routers
  nats                    = var.nats
}

# Variable values

region = "us-central1"

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

service_projects = ["service-project-1", "service-project-2"]

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
```

## Inputs

| Name | Description | Type | Default | Required | 
|------|-------------|:----:|---------|:--------:|
|**project_id**| GCP Project ID | string | { } | yes| 
|**region**| The Google Cloud region | string | us-central1 | yes | 
|**vpc_name**| Name of the VPC | string | { } |yes| 
|**auto_create_subnetworks**| whether to create subnet or not | bool | false | yes| 
|**subnets** | List of subnets with optional secondary IP ranges | list(object) | 1000 | yes|
|**aggregation_interval**| Time interval for aggregating flow logs | string | "INTERVAL_5_SEC" | yes | 
|**flow_sampling**| Sampling rate of VPC Flow Logs (0.0 - 1.0) | number | "0.5" | yes| 
|**metadata**| Metadata logging options | string | "INCLUDE_ALL_METADATA" | yes| 
|**service_projects** | List of service projects | list(string) | [ ] | yes|
|**nats**| List of NAT configurations| list(object) |  | yes | 
|**routers**| A map of Cloud Routers with region, network, and BGP ASN | map(object) | { } | yes|


## Output
| Name | Description |
|------|-------------|
|**vpc_id**| ID of the created VPC | 
|**subnets**| List of subnet self links |
|**subnet_ids**| List of subnet names and their IDs|
|**host_project** | ID of host project |
|**service_projects**| ID of the service projects | 
|**cloud_routers**| Map of created Cloud Routers |
|**cloud_nat_names**| Names of all Cloud NATs created|
|**nat_ip_allocate_options** | NAT IP Allocation Methods for each NAT |
|**static_nat_ips** | List of allocated static NAT IPs per NAT |

                                                                                                              
