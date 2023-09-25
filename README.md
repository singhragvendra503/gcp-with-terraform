# Terraform Google Cloud Platform Configuration For Create VM Instance

This Terraform configuration is designed to provision and manage resources in Google Cloud Platform (GCP). It creates a custom VPC network, a subnetwork, firewall rules, and a virtual machine instance. The purpose of this configuration is to set up a basic GCP environment for running virtual machines and controlling network access.

## Prerequisites

Before you can use this Terraform configuration, you should have the following prerequisites in place:

1. **Terraform Installed:** Make sure you have Terraform installed on your local machine. You can download it from [Terraform's official website](https://www.terraform.io/downloads.html).

2. **Google Cloud Platform Account:** You need a GCP account with appropriate permissions to create and manage resources. Also, ensure that you have a JSON service account key file (`terraform-gcp-provider-64fbb35e93e3.json`) for authentication.

3. **SSH Key Pair:** This configuration assumes you have an SSH key pair configured on your local machine. If not, you can generate one using `ssh-keygen`. Replace `"~/.ssh/id_rsa.pub"` in the configuration with the path to your public SSH key.

## Configuration Overview

### Provider Configuration

The `provider` block specifies the GCP project, region, and authentication credentials.

### Network Configuration

- The `google_compute_network` resource creates a custom VPC network named `my-custom-mode-network` with specific settings like MTU and disabling auto-created subnetworks.

- The `google_compute_subnetwork` resource creates a subnetwork named `my-custom-subnet` with a defined IP CIDR range and associates it with the custom VPC network.

### Firewall Rules

- The `google_compute_firewall` resource named `all-deny` denies all incoming traffic from any source IP address for all protocols.

- The `google_compute_firewall` resource named `allow-ssh` allows incoming SSH (TCP port 22) traffic from any source IP address.

### Compute Instance

- The `google_compute_instance` resource creates a virtual machine instance named `test` in the `us-west1-a` zone. It uses an Ubuntu 22.04 LTS image, configures SSH access, and attaches it to the previously created network and subnetwork.

### Compute Instance Boot Disk

The `boot_disk` block in the `google_compute_instance` resource configuration is responsible for specifying the image to be used for the virtual machine's boot disk. In this case, the image is defined as follows:

```hcl
boot_disk {
  initialize_params {
    image = "ubuntu-os-cloud/ubuntu-2204-lts"
    labels = {
      my_label = "value"
    }
  }
}
```
#### Official link
 https://cloud.google.com/compute/docs/images/os-details
#### Image formate
    Image project/Image family
    ubuntu-os-cloud/ubuntu-2204-lts
## Usage

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/singhragvendra503/gcp-with-terraform
   cd gcp-with-terraform

   terraform init
   terraform validate
   terraform plan
   terraform apply