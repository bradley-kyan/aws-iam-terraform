remote_state {
  backend = "s3"
  config = {
    bucket = "kbradl-prod"
    key    = "website"
    region = "ap-southeast-2"
  }
}

terraform {
  source = "../../codebase"
}