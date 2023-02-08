data "aws_caller_identity" "current" {}

data "aws_iam_role" "main" {
  name = "AWSServiceRoleForConfig"
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "AllowBucketACLCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [module.bucket.arn]

    condition {
      test     = "StringEquals"
      values   = ["true"]
      variable = "aws:SecureTransport"
    }
  }

  statement {
    sid    = "AllowBucketWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
    resources = [
      format(
        "%s/AWSLogs/%s/Config/*",
        module.bucket.arn, data.aws_caller_identity.current.account_id
      )
    ]

    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }

    condition {
      test     = "StringEquals"
      values   = ["true"]
      variable = "aws:SecureTransport"
    }
  }

  statement {
    sid    = "RequireSSL"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["s3:*"]
    resources = [module.bucket.arn]

    condition {
      test     = "StringEquals"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }
  }
}
