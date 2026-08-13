terraform {
  backend "s3" {
    bucket       = "bucket-remote-tfstate-simple-blog-app11"
    key          = "blog-app/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}