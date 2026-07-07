output "account_id" {
    value = data.aws_caller_identity.current.account_id
}

output "region" {
    value = data.aws_region.current.region
}

output "vpc" {
    value = data.aws_vpc.current.id
}

output "subnet" {
    value = data.aws_subnet.current.cidr_block
}