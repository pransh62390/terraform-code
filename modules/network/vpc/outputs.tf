output "id" { value = aws_vpc.vpc.id }
output "cidr_block" { value = aws_vpc.vpc.cidr_block }
output "igw" { value = aws_internet_gateway.igw.id }
output "nat-gw" { value = aws_nat_gateway.nat-gw.id }
output "public_ids" { value = aws_subnet.public.*.id }
output "private_ids" { value = aws_subnet.private.*.id }
output "public-route-table-id" { value = aws_route_table.public-routes.id }
output "private-route-table-id" { value = aws_route_table.private-routes.id }
