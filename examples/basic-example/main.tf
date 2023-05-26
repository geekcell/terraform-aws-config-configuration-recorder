module "example" {
  source        = "../../"
  name          = "my-recorder"
  subscriptions = ["noreply@example.org"]
}
