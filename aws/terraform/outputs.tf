output "origin_vpc_id" {
  description = "IDs of the Origin VPC"
  value = aws_vpc.vpc_dse.id
}

output "origin_route_table_ids" {
  description = "Route tables of the Origin environment that must be opened up for communication with the Cloudgate infrastructure"
  value = [aws_route_table.rt_dse.id, aws_route_table.rt_user_app.id]
}

output "origin_contact_points" {
  description = "Private IP Addresses of the Origin nodes to be used as contact points"
  value = aws_instance.dse_app_dc1.*.private_ip
}