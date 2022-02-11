output "cluster_vpc_id" {
  description = "IDs of the Cluster VPC"
  value = aws_vpc.vpc_dse.id
}

output "cluster_route_table_ids" {
  description = "Route tables of the Cluster environment that must be opened up for communication with the Cloudgate infrastructure"
  value = [aws_route_table.rt_dse.id, aws_route_table.rt_user_app.id]
}