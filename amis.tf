data "aws_ami_ids" "amis" {
  owners = ["self"]
  filter {
    name   = "block-device-mapping.encrypted"
    values = ["false"]
  }
}

output "amis" {
  value = data.aws_ami_ids.amis.ids
}

output "aws_amis" {
  #  #value = "aws ec2 export-image --image-id ami-id --disk-image-format VHD --s3-export-location S3Bucket=${aws_s3_bucket.ami_bucket.id},S3Prefix=exports/"
  value = [for image in data.aws_ami_ids.amis.ids : "aws ec2 export-image --image-id ${image} --disk-image-format VHD --s3-export-location S3Bucket=${aws_s3_bucket.ami_bucket.id},S3Prefix=exports/ --region ${local.region}"]
  #  #value = "aws ec2 export-image --image-id ami-id --disk-image-format VHD --s3-export-location S3Bucket=${aws_s3_bucket.ami_bucket_name},S3Prefix=exports/"
}

