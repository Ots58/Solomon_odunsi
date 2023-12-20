# # Create an S3 bucket
# resource "aws_s3_bucket" "solo_blogs" {
#   bucket = "solo-blogs"

#   tags = {
#     Name        = "solo_prod"
#     Environment = "Dev"
#   }
# }

# resource "aws_s3_bucket_versioning" "versioning_example" {
#   bucket = aws_s3_bucket.solo_blogs.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }