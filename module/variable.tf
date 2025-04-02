variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "nw-opstree-dev-landing-zone"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "new-vpc"
}

variable "auto_create_subnetworks" {
  description = "whether to create subnet or not"
  type        = bool
  default     = false
}

variable "subnets" {
  type = list(object({
    name                     = string
    region                   = string
    ip_cidr_range            = string
    private_ip_google_access = bool #
    secondary_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
  }))
  description = "List of subnets with optional secondary IP ranges."
}

variable "aggregation_interval" {
  type        = string
  description = "Time interval for aggregating flow logs."
  default     = "INTERVAL_5_SEC"
}

variable "flow_sampling" {
  type        = number
  description = "Sampling rate of VPC Flow Logs (0.0 - 1.0)."
  default     = 0.5
}

variable "metadata" {
  type        = string
  description = "Metadata logging options."
  default     = "INCLUDE_ALL_METADATA"
}

variable "service_projects" {
  description = "List of service projects to attach"
  type        = list(string)
  default     = ["service-project-testing", "service-project-testing-2"]
}

variable "routers" {
  description = "A map of Cloud Routers with region, network, and BGP ASN"
  type = map(object({
    network = string
    region  = string
    bgp_asn = number
  }))
}

variable "nats" {
  description = "List of NAT configurations"
  type = list(object({
    name                   = string
    router_name            = string
    nat_region             = string
    nat_ip_allocate_option = string
    source_subnet_ranges   = string
    static_ips             = list(string)
  }))
}
