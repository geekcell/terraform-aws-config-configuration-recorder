# Context
variable "tags" {
  default     = {}
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
}

# AWS Config Configuration Recorder
variable "name" {
  description = "The name of the AWS Config configuration recorder."
  type        = string
}

variable "subscriptions" {
  description = "A list of email addresses to send notifications to when AWS Config delivers configuration items."
  type        = list(string)
}
