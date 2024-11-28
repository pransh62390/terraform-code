resource "aws_route_table" "public-routes" {
   vpc_id = aws_vpc.vpc.id
   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
   }
   tags = merge(var.vpc_tags, tomap({"Name" = "${var.short_env}-public"}))
}

resource "aws_route_table" "private-routes" {
   vpc_id = aws_vpc.vpc.id
   route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat-gw.id
   }
   tags = merge(var.vpc_tags, tomap({"Name" = "${var.short_env}-private"}))
}

resource "aws_route_table_association" "public-route-assoc" {
   count          = length(aws_subnet.public.*.id)    
   subnet_id      = element(aws_subnet.public.*.id[*], count.index)

   route_table_id = aws_route_table.public-routes.id
}

resource "aws_route_table_association" "private-route-assoc" {
   count          = length(aws_subnet.private.*.id)
   subnet_id      = element(aws_subnet.private.*.id[*], count.index)
   route_table_id = aws_route_table.private-routes.id
}

