# # aws_route53

# data "aws_route53_zone" "worker" {
#   count = var.zone_name == "" ? 0 : 1

#   name = var.zone_name
# }

# resource "aws_route53_record" "worker" {
#   count = var.zone_name == "" ? 0 : var.desired > 0 ? 1 : 0

#   name    = var.name
#   ttl     = 300
#   type    = "A"
#   zone_id = data.aws_route53_zone.worker.0.zone_id

#   allow_overwrite = true

#   records = [
#     data.aws_instances.worker.0.public_ips.0,
#     # aws_eip.worker.public_ip,
#   ]
# }

# # output

# output "dns_name" {
#   value = try(aws_route53_record.worker.0.fqdn, "")
# }
