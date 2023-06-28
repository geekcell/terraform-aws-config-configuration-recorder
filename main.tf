resource "aws_config_configuration_recorder" "main" {
  name     = var.name
  role_arn = data.aws_iam_role.main.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_configuration_recorder_status" "main" {
  name       = aws_config_configuration_recorder.main.name
  is_enabled = true
}

resource "aws_config_delivery_channel" "main" {
  name           = var.name
  s3_bucket_name = module.bucket.id
  sns_topic_arn  = module.notification.arn

  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
}

module "bucket" {
  source  = "geekcell/s3/aws"
  version = ">= 1.0.0, < 2.0.0"

  name = "${var.name}-config-configuration-recorder"

  expiration                    = 7
  noncurrent_version_expiration = 60

  policy = data.aws_iam_policy_document.bucket_policy.json

  tags = var.tags
}

module "notification" {
  source  = "geekcell/sns-email-notification/aws"
  version = ">= 1.0.0, < 2.0.0"

  name            = "${var.name}-config"
  email_addresses = var.subscriptions

  tags = var.tags
}
