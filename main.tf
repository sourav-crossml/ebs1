module "prod_vpc" {
  source = "./modules/vpc"
  igw    = module.nat.igw

}

module "nat" {
  source      = "./modules/network"
  vpc_id      = module.prod_vpc.vpc_id
  subnet_id-1 = module.prod_vpc.subnet-1
  subnet_id-2 = module.prod_vpc.subnet-2

}

module "route_table" {
  source   = "./modules/route_tables"
  vpc_id   = module.prod_vpc.vpc_id
  igw_id   = module.nat.igw
  nat_id-1 = module.nat.nat1
  nat_id-2 = module.nat.nat1


}

module "route_table_association" {
  source            = "./modules/route_table_association"
  pub-1             = module.prod_vpc.subnet-1
  pub-2             = module.prod_vpc.subnet-2
  pvt-1             = module.prod_vpc.subnet-3
  pvt-2             = module.prod_vpc.subnet-4
  route_table_pub-1 = module.route_table.public1
  route_table_pub-2 = module.route_table.public2
  route_table_pvt-1 = module.route_table.private1
  route_table_pvt-2 = module.route_table.private2

}

module "beanstalk" {
  source           = "./modules/beanstalk"
  vpc_id           = module.prod_vpc.vpc_id
  public_subnet-1  = module.prod_vpc.subnet-1
  public_subnet-2  = module.prod_vpc.subnet-2
  private_subnet-1 = module.prod_vpc.subnet-3
  private_subnet-2 = module.prod_vpc.subnet-4
  s3_bucket_object = module.s3.s3_bucket_object
  s3_bucket        = module.s3.s3_bucket
  igw              = module.nat.igw

}


module "s3" {
  source = "./modules/s3"
}
