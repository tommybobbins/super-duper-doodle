resource "aws_s3_bucket" "ami_bucket" {
  bucket_prefix = var.bucket_name
  #  policy = templatefile("templates/s3-policy.json", { 
  #     BUCKET = var.bucket 
  #     ACCOUNT_ID = local.account_id
  #  region     = data.aws_region.current.name
  #  }
}


resource "aws_s3_bucket_policy" "ami_bucket" {
  bucket = aws_s3_bucket.ami_bucket.id
  policy = data.aws_iam_policy_document.allow_access_to_bucket.json
}

data "aws_iam_policy_document" "allow_access_to_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.arn]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.ami_bucket.arn,
      "${aws_s3_bucket.ami_bucket.arn}/*",
    ]
  }
}


output "aws_s3_bucket" {
  value = "aws ec2 export-image --image-id ami-id --disk-image-format VHD --s3-export-location S3Bucket=${aws_s3_bucket.ami_bucket.id},S3Prefix=exports/"
  #value = "aws ec2 export-image --image-id ami-id --disk-image-format VHD --s3-export-location S3Bucket=${aws_s3_bucket.ami_bucket_name},S3Prefix=exports/"
}
