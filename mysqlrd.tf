
resource "aws_db_instance" "mysql_rds_db" {
  availability_zone           = "us-east-1a"
  allocated_storage           = 20
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "db.t2.small"
  name                        = "mydb"
  username                    = "foo"
  password                    = "foobarbaz"
  parameter_group_name        = "default.mysql5.7"

}

output "aws_mysql_rds" {
  value = "mysql rds service successfully created in aws us-east-1"
}