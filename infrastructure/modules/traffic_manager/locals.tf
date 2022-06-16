locals {
  traffic_routing_method = "Performance"
  dns_ttl                = 100
  endpoint_weighting     = 100

  interval_in_seconds          = 30
  timeout_in_seconds           = 9
  tolerated_number_of_failures = 3
}