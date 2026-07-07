data "aws_caller_identity" "current" {

}
data "aws_region" "current" {
    
}

data "aws_vpc" "current" {

}

data "aws_subnet" "current" {
    
}

resource "aws_vpc" "lab" {
    cidr_block = "10.224.0.0/16"
}