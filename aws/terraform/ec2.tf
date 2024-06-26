#
# EC2 instances for DSE application cluster, DC1
# 
resource "aws_instance" "dse_app_dc1" {
   ami            = var.ami_id
   instance_type  = lookup(var.instance_type, var.dse_app_dc1_type)
   root_block_device {
      volume_type = "gp2"
      volume_size = var.dse_node_root_volume_size_gb
   }
   count          = lookup(var.instance_count, var.dse_app_dc1_type)
   key_name       = aws_key_pair.dse_terra_ssh.key_name
   subnet_id      = aws_subnet.sn_dse_cassapp.id

   vpc_security_group_ids = [
      aws_security_group.sg_internal_only.id,
      aws_security_group.sg_ssh.id,
      aws_security_group.sg_dse_node.id
   ]

   tags = {
      Name         = "${var.tag_identifier}-${var.dse_app_dc1_type}-${count.index}"
      Owner        = var.cluster_owner
      Environment  = var.env 
   }  

}

#
# EC2 instances for user's application client
#
resource "aws_instance" "user_application_client" {
   ami            = var.ami_id
   instance_type  = lookup(var.instance_type, var.user_application_client_type)
   count          = lookup(var.instance_count, var.user_application_client_type)
   key_name       = aws_key_pair.dse_terra_ssh.key_name
   subnet_id      = aws_subnet.sn_user_app.id

   vpc_security_group_ids = [
      aws_security_group.sg_internal_only.id,
      aws_security_group.sg_ssh.id
   ]

   tags = {
      Name         = "${var.tag_identifier}-${var.user_application_client_type}-${count.index}"
      Owner        = "${var.client_app_server_owner}${count.index}"
      Environment  = var.env
   }

}

/*
data "template_file" "user_data" {
   template = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install python-minimal -y
              apt-get install ntp -y
              apt-get install ntpstat -y
              ntpq -pcrv
              EOF
}
*/
