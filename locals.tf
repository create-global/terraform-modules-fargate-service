locals {
  fqdn = "${var.subdomain}.${var.domain}"
  fqsn = "${var.service_name}-${var.namespace}"


  env = [for k, v in var.env : { name : k, value : v }]
}
