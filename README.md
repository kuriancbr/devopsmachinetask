# devopsmachinetask
This script will create 4 amazon instances
1 - Ubuntu instance for hosting wordpress website - web server machine
2 - Ubuntu instance to setup database - DB Server
3 - Ubuntu instance to manager connections between this systems and managing overall networks - VPC Machine
3 - AWS MYSQL RDS instance - aws rds instance to manage database.

run this script using > terraform init
                      > terrafor plan
                      > terraform fmt
                      > terraform validate
                      > terraform apply
                      
  
  
  After the script successfully executed copy the webserver ip and paste in the browser http://ip/index.php
