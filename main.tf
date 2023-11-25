############# VPC ##############
resource "aws_vpc" "VPC_LaboratorioITM_Terraform" {
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "VPC_LaboratorioITM_Terraform"
  }
}

############# Subnets #############

resource "aws_subnet" "SUBNET_LaboratorioITM_Public" {
  vpc_id = aws_vpc.VPC_LaboratorioITM_Terraform.id
  cidr_block = "${var.subnet_public_cidr}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "SUBNET_LaboratorioITM_Public"
    "Env" = "LAB"
  }
  depends_on = [
    aws_vpc.VPC_LaboratorioITM_Terraform
  ]
}

resource "aws_subnet" "SUBNET_LaboratorioITM_Public2" {
  vpc_id = aws_vpc.VPC_LaboratorioITM_Terraform.id
  cidr_block = "${var.subnet_public2_cidr}"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "SUBNET_LaboratorioITM_Public2"
    "Env" = "LAB"
  }
  depends_on = [
    aws_vpc.VPC_LaboratorioITM_Terraform
  ]
}

resource "aws_subnet" "SUBNET_LaboratorioITM_Private" {
  vpc_id = aws_vpc.VPC_LaboratorioITM_Terraform.id
  cidr_block = "${var.subnet_private_cidr}"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "SUBNET_LaboratorioITM_Private"
    "Env" = "LAB"
  }
  depends_on = [
    aws_vpc.VPC_LaboratorioITM_Terraform
  ]
}

resource "aws_subnet" "SUBNET_LaboratorioITM_Private2" {
  vpc_id = aws_vpc.VPC_LaboratorioITM_Terraform.id
  cidr_block = "${var.subnet_private2_cidr}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "SUBNET_LaboratorioITM_Private2"
    "Env" = "LAB"
  }
  depends_on = [
    aws_vpc.VPC_LaboratorioITM_Terraform
  ]
}

############# Public Subnet Network ACL #############

resource "aws_network_acl" "NACL_Public_Subnet_Terraform" {
  vpc_id = aws_vpc.VPC_LaboratorioITM_Terraform.id
  subnet_ids = [aws_subnet.SUBNET_LaboratorioITM_Public.id,aws_subnet.SUBNET_LaboratorioITM_Public2.id]

  egress {
    rule_no      = 100
    action       = "allow"
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_block   = "0.0.0.0/0"
  }

  ingress {
    rule_no      = 100
    action       = "allow"
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_block   =  "${var.vpc_cidr}" # IP local de la vpc
  }

    ingress {
    rule_no      = 200
    action       = "allow"
    from_port    = 80
    to_port      = 80
    protocol     = "tcp"
    cidr_block   = "0.0.0.0/0"  # trafico http desde cualquier lugar en puerto 80
  }

  ingress {
    rule_no      = 300
    action       = "allow"
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_block  = "${var.public_ip}" # ip publica para tener acceso a la instancia EC2
  }

  ingress {
    rule_no      = 400
    action       = "allow"
    from_port    = 1025
    to_port      = 65535
    protocol     = "tcp"  # trafico TCP
    cidr_block   = "0.0.0.0/0"
  }

  tags = {
    Name = "NACL_Public_Subnet"
  }
}

############# Private Subnet Network ACL #############
resource "aws_network_acl" "NACL_Private_Subnet_Terraform" {
  vpc_id     = aws_vpc.VPC_LaboratorioITM_Terraform.id
  subnet_ids = [aws_subnet.SUBNET_LaboratorioITM_Private.id,aws_subnet.SUBNET_LaboratorioITM_Private2.id]

  egress {
    rule_no      = 100
    action      = "allow"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_block  = "0.0.0.0/0"
  }

  ingress {
    rule_no      = 100
    action      = "allow"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_block  = "${var.vpc_cidr}" # IP local de la vpc
  }

  ingress {
    rule_no      = 200
    action      = "allow"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_block  = "${var.public_ip}" # ip publica para tener acceso a la RDS
  }

  tags = {
    Name = "NACL_Private_Subnet"
  }
}





############# Webserver Security Group #############

resource "aws_security_group" "SG_WebServer_Terraform" {
  vpc_id = aws_vpc.VPC_LaboratorioITM_Terraform.id

    ingress {
    from_port    = 80
    to_port      = 80
    protocol     = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]  
  }

    ingress {
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["${var.public_ip}"] 
  }
  
ingress {
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks   =  ["${var.vpc_cidr}"] 
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG_Webserver_Terraform"
  }
}

############# RDS Security Group #############

resource "aws_security_group" "SG_RDS_Terraform" {
  vpc_id = aws_vpc.VPC_LaboratorioITM_Terraform.id

    ingress {
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["${var.public_ip}"] 
  }
  
ingress {
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks   =  ["${var.vpc_cidr}"] 
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG_RDS_Terraform"
  }
}


############# Internet Gateway #############

resource "aws_internet_gateway" "IG_ITMLab_Terraform" {
  vpc_id = aws_vpc.VPC_LaboratorioITM_Terraform.id

    tags = {
    Name = "IG_ITMLab_Terraform"
  }
}

############# Route Table #############
resource "aws_route_table" "RT_ITMIaC_VSCode" {
  vpc_id = aws_vpc.VPC_LaboratorioITM_Terraform.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG_ITMLab_Terraform.id
  }
 depends_on = [aws_internet_gateway.IG_ITMLab_Terraform]

     tags = {
    Name = "RT_ITMLab_Terraform"
  }
}

resource "aws_main_route_table_association" "RT_Asociation" {
  route_table_id = aws_route_table.RT_ITMIaC_VSCode.id 
  vpc_id = aws_vpc.VPC_LaboratorioITM_Terraform.id
}


############# RDS Subnet Group #############

resource "aws_db_subnet_group" "SNG_TerraformDB" {
  name       = var.rds_db_subnet_group_name
  subnet_ids = [
    aws_subnet.SUBNET_LaboratorioITM_Private.id, aws_subnet.SUBNET_LaboratorioITM_Private2.id
  ]
    tags = {
    Name = "TerraformDBSubnetGroup"
  }
}


############# RDS MySQL #############

resource "aws_db_instance" "RDS_TerraformDB" {
  identifier           = "${var.rds_identifier}"
  allocated_storage    = "${var.rds_allocated_storage}"
  engine               = "${var.rds_engine}"
  engine_version       = "${var.rds_engine_version}"
  instance_class       = "${var.rds_instance_class}"
  username             = "${var.rds_username}"
  password             = "${var.rds_password}"
  db_subnet_group_name = aws_db_subnet_group.SNG_TerraformDB.name
  vpc_security_group_ids = [aws_security_group.SG_RDS_Terraform.id]
  multi_az             = "${var.rds_multi_az}"
  publicly_accessible  = "${var.rds_publicly_accessible}"
  skip_final_snapshot  = true
}


############# EC2 Joomla Instance #############

resource "aws_instance" "EC2_Terraform_Lab_1_VSCode" {
  ami = "${var.ec2_terraform_ami}"
  instance_type = "${var.ec2_joomla_instance_type}"
  count = "${var.ec2_terraform_instance_quantity}"
  subnet_id = aws_subnet.SUBNET_LaboratorioITM_Public.id
  key_name = "${var.aws_keypair}"
  security_groups = [aws_security_group.SG_WebServer_Terraform.id]
  tags = {
    Name = "${var.ec2_terraform_instance_name}"
  }
  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
amazon-linux-extras enable php8.1
yum clean metadata
yum install -y php php-common php-pear
yum install -y php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip}
mkdir /var/www/html/myapp
cd /var/www/html/myapp
    echo '<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="icon" type="image/png" sizes="32x32" href="./images/favicon-32x32.png">
  <title>Frontend Mentor | QR code component</title>
  <link rel="stylesheet" href="styles/index.css">
  <style>
    @font-face {
        font-family: Outfit;
        src: url("../Outfit/Outfit-VariableFont_wght.ttf") format("truetype");
    }

    .content {
      width: 100vw;
      max-width: 100vw;
      height: 100vh;
      max-height: 100vh;
      background: hsl(212, 45%, 89%);
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .card {
      width: 350px;
      height: max-content;
      border-radius: 5%;
      background: white;
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    .image {
      width: 90%;
      margin: 25px 0 0px 0;
      border-radius: 5%;
    }

    .title {
      font-family: Outfit;
      font-size: 25px;
      text-align: center;
      color: hsl(218, 44%, 22%);
      width: 90%;
      margin-bottom: 0;
    } 

    .subline {
      font-size: 15px;
      color: hsl(220, 15%, 55%);
      text-align: center;
      width: 73%;
    }

    body {
      margin: 0;
    }

    @media screen and (max-width: 375px) {
      .card {
        width: 80%;
        border-radius: 15px;
      }
      .image {
        border-radius: 15px;
        width: 90%;
        margin: 15px 15px 0px 15px;
      }
    }
  </style>
</head>
<body>  
  <div class="content">
    <div class="card">
      <img class="image" src="./images/image-qr-code.png" alt="QR">
      <h2 class="title">Improve your front-end skills by building projects</h2>
      <p class="subline">Scan the QR code to visit Frontend Mentor 
        and take your coding skills to the next level</p>
    </div>
  </div>
</body>
</html>' > /var/www/html/myapp/index.html
      echo 'body {
    width: 80%;
    margin: 0 auto;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #D0D977;
}

.titulo {
    display: flex;
    justify-content: center;
}

h1 {
    position: absolute;
    margin-top: 12px;
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 5px;
    background-color: #FFFFE0;
    box-shadow: 0 2px 2px rgba(0, 0, 0, 0.1);
    text-align: center;
}

img {
    position: relative;
    width: 100px;
    margin-left: 220px;
}

.linea {
    margin-top: -1px;
    border-color: black;
}

h2 {
    text-align: center;
}

h4 {
    font-size: 18px;
    text-decoration: underline;
}

table {
    border-collapse: collapse;
    width: 100%;
    margin: 10px 0;
}

th, td {
    border: 1px solid #ddd;
    padding: 8px; 
    text-align: left;
}

th {
    background-color: darkolivegreen;
    font-weight: bold;
    text-align: center;
    color: white;
}

td {
    background-color: #FFFFE0;
}

input {
    background-color: #FFFFE0;
    padding: 10px 10px;
    font-size: 15px;
    width: 150px;
    border: none;
    border-bottom: solid 1px;
}

button {
    background-color: darkolivegreen;
    color: white;
    height: 35px;
    font-size: 15px;
    width: 170px;
    cursor: pointer;
}

label {
    display: inline-block;
    width: 130px; /* ajusta el ancho según tus necesidades */
    vertical-align: top;
    line-height: 50px;
}

textarea {
    background-color: #f7f7f7;
    border: 1px solid #ccc;
    box-shadow: 1px 1px 2px #ccc;
    cursor: text;
    font-family: inherit;
    font-size: 100%;
    padding: 8px;
    resize: none;
    text-align: left;
    height: 30px;
}
' > /var/www/html/myapp/misEstilos.css
chown -R apache:apache /var/www/html/myapp
chmod -R 755 /var/www/html/myapp
chmod -R 777 /var/www/
systemctl restart httpd
EOF
}