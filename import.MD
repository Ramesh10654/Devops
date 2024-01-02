1. Create a Terraform Configuration File:
============================================
# main.tf

provider "aws" {
  region     = "your-region"
  access_key = "your-access-key"
  secret_key = "your-secret-key"
}

resource "aws_instance" "example" {
  # Placeholder configuration; will be populated during import
}


2. Run terraform init:
=========================
terraform init

3. Import the Existing EC2 Instance:
==========================================
terraform import aws_instance.example i-xxxxxxxxxxxxxxxxx


4. Update the Terraform Configuration:
======================================
# main.tf

provider "aws" {
  region     = "your-region"
  access_key = "your-access-key"
  secret_key = "your-secret-key"
}

# Use the imported resource in your configuration
resource "aws_instance" "example" {
  ami           = "your-ami-id"
  instance_type = "your-instance-type"
  key_name      = "your-key-name"
  # Add other configuration details based on your existing instance
}


5. Run terraform plan and terraform apply:
===============================================
terraform plan
terraform apply
