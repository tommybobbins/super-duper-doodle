resource "aws_iam_policy" "gcp_amireader_s3" {
  name        = "gcp-s3-amireader"
  path        = "/"
  description = "Allow S3 RW"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "GCPAMIReader",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:GetObjectVersion",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.ami_bucket.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.ami_bucket.id}"
        ]
      }
    ]
  })
}

resource "aws_iam_user" "gcp_amireader_s3" {
  name = "gcp-amireader-s3"
}

resource "aws_iam_access_key" "gcp_amireader_s3" {
  user = aws_iam_user.gcp_amireader_s3.name
}

resource "aws_secretsmanager_secret" "gcp_amireader_s3" {
  count                   = var.store_secret_creds ? 1 : 0
  name                    = "gcp-amireader-s3"
  description             = "AWS Credentials to allow GCP to read the AMIs from ${var.bucket_name}"
  recovery_window_in_days = "0"

}

resource "aws_secretsmanager_secret_version" "gcp_amireader_s3" {
  count         = var.store_secret_creds ? 1 : 0
  secret_id     = aws_secretsmanager_secret.gcp_amireader_s3[0].id
  secret_string = <<EOF
    {
    "AWS_ACCESS_KEY_ID": "${aws_iam_access_key.gcp_amireader_s3.id}",
    "AWS_SECRET_ACCESS_KEY": "${aws_iam_access_key.gcp_amireader_s3.secret}"
    }
EOF
}


resource "aws_iam_user_policy_attachment" "gcp_amireader_s3" {
  user       = aws_iam_user.gcp_amireader_s3.name
  policy_arn = aws_iam_policy.gcp_amireader_s3.arn
}


output "import_to_gcp_creds" {
  description = "Credentials to allow GCP to read AMIs from bucket"
  sensitive   = true
  value       = <<EOF
    {
    "AWS_ACCESS_KEY_ID": "${aws_iam_access_key.gcp_amireader_s3.id}",
    "AWS_SECRET_ACCESS_KEY": "${aws_iam_access_key.gcp_amireader_s3.secret}"
    }
EOF
}
