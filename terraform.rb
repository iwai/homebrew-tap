require 'formula'

# see: https://github.com/Homebrew/homebrew-binary/pull/135
# 待てないから自分用に追加

class Terraform < Formula
  homepage 'http://www.terraform.io'
  version '0.1.1'

  url 'https://dl.bintray.com/mitchellh/terraform/terraform_0.1.1_darwin_amd64.zip'
  sha256 '1387eca09fcad8571f02d2f34b79d7cff5f420da8cc52e9b0841696461c99b38'

  depends_on :arch => :x86_64

  def install
    bin.install Dir['*']
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<-EOS.undent
      variable "aws_region" {
          default = "us-west-2"
      }

      variable "aws_amis" {
          default = {
              "eu-west-1": "ami-b1cf19c6",
              "us-east-1": "ami-de7ab6b6",
              "us-west-1": "ami-3f75767a",
              "us-west-2": "ami-21f78e11"
          }
      }

      # Specify the provider and access details
      provider "aws" {
          access_key = "this_is_a_fake_access"
          secret_key = "this_is_a_fake_secret"
          region = "${var.aws_region}"
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami = "${lookup(var.aws_amis, var.aws_region)}"
        count = 4
      }
    EOS
    system "#{bin}/terraform", "plan", testpath
  end
end
