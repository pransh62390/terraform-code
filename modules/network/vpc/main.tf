resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = var.vpc_enable_dns_support
    enable_dns_hostnames = var.vpc_enable_dns_hostnames
    tags = merge(var.vpc_tags, tomap({"Name" = var.short_env}))
}

# Internet-gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = merge(var.vpc_tags, tomap({"Name" = var.short_env}))
}

#EIP for Nat attaching
resource "aws_eip" "nat" {
    domain    = "vpc"
    tags = merge(var.vpc_tags, tomap({"Name" = "${var.short_env}-nat"}))
}

#Nat gateway setup
resource "aws_nat_gateway" "nat-gw" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public[0].id
    tags = merge(var.vpc_tags, tomap({"Name" = "${var.short_env}"}))
}

resource "aws_subnet" "public" {
    count = length(var.public_subnets)
    cidr_block = var.public_subnets[count.index].CIDR_BLOCK
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.public_subnets[count.index].AVAILABILITY_ZONE
    map_public_ip_on_launch = true
    tags = merge(var.vpc_tags, tomap({"Name" = var.public_subnets[count.index].NAME}))
}

resource "aws_subnet" "private" {
    count = length(var.private_subnets)
    cidr_block = var.private_subnets[count.index].CIDR_BLOCK
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.private_subnets[count.index].AVAILABILITY_ZONE
    tags = merge(var.vpc_tags, tomap({"Name" = var.private_subnets[count.index].NAME}))
}

resource "aws_security_group" "default" {
    name        = "${var.short_env}-default"
    description = "Default SG to alllow traffic from the VPC"
    vpc_id      = aws_vpc.vpc.id
    depends_on = [
        aws_vpc.vpc
    ]

    ingress {
        from_port = "0"
        to_port   = "0"
        protocol  = "-1"
        self      = true
    }

    egress {
        from_port = "0"
        to_port   = "0"
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(var.vpc_tags, tomap({"Name" = "${var.short_env}-default"}))
}
