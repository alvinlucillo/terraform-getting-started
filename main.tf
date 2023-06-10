terraform {
  backend "s3" {
    region = var.region
    key = "terraform.tfstate"
    state = "terraform-state"
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "s3_test" {
  for_each = var.s3_map

  bucket   = "${each.key}"
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning_test" {
  for_each = aws_s3_bucket.s3_test

  bucket             = each.value.id
  versioning_configuration {
    status = var.s3_map[each.key].versioning ? "Enabled" : "Suspended"
  } 
}

# resource "aws_s3_bucket_public_access_block" "s3_bucket_public_block_test" {
#   for_each = aws_s3_bucket.s3_test

#   bucket                  = each.value.id

#   block_public_acls       = try(var.s3_map[each.key].allow_public_access, false)
#   block_public_policy     = try(var.s3_map[each.key].allow_public_access, false)
#   ignore_public_acls      = try(var.s3_map[each.key].allow_public_access, false)
#   restrict_public_buckets = try(var.s3_map[each.key].allow_public_access, false)
# }

