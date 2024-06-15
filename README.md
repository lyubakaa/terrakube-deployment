
# Project Setup Guide

## Prerequisites

Before you begin, ensure you have the following installed:
- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://aws.amazon.com/cli/)

## Initial Setup

1. Clone the repository:

```sh
git clone <repository_url>
cd <repository_directory>
```

2. Change the mode of the shell script to make it executable and then execute it to create an SSH key and upload it to AWS:

```sh
chmod +x create-keys.sh
./create-keys.sh
```

## Create the `terraform.tfvars` File

Create a `terraform.tfvars` file in the project root directory and fill in the necessary values for the variables as shown below:

```hcl
region            = "<your-aws-region>"
vpc_cidr          = "<your-vpc-cidr>"
cluster_version   = "<your-cluster-version>"
vpn_ami_type      = "<your-vpn-ami-type>"
vpn_instance_type = "<your-vpn-instance-type>"
private_key_name  = "<your-private-key-name>"
private_key_path  = "<path-to-your-private-key>"
wireguard_pass    = "<your-wireguard-password>"
```

Replace the placeholder values with your actual configuration details. 

## Terraform Commands

Run the following Terraform commands to deploy the infrastructure:

1. Initialize Terraform:

```sh
terraform init
```

2. Plan the Terraform deployment:

```sh
terraform plan
```

3. Apply the Terraform deployment:

```sh
terraform apply
```

Follow any prompts and review the changes Terraform will apply to your infrastructure.

## Post-Deployment Steps

1. Once deployed, navigate to the IP address of the bastion host on port `51821` to download the WireGuard configuration file. Enter the password you specified (`wireguard_pass`) to access the file.

2. Edit the downloaded WireGuard configuration file to add a line about DNS. You can use either Cloudflare or Google DNS IPs as shown below:

    ```ini
    [Interface]
    # existing configuration
    DNS = <IP_of_eks_coredns_pod>, <IP_of_eks_coredns_pod>, 1.1.1.1 # For Cloudflare DNS

    # or

    DNS = <IP_of_eks_coredns_pod>, <IP_of_eks_coredns_pod>, 8.8.8.8 # For Google DNS
    ```

Replace `<IP_of_eks_coredns_pod>` with the actual IP address of your EKS CoreDNS pod.



## Accessing the Service

The service will be accessible on the appointed DNS name at `terrakube.ui.your_dnsname`.

## Tear Down the Infrastructure

If you need to destroy the deployed infrastructure, run the following command:

    ```sh
    terraform destroy
    ```

Follow any prompts to confirm the destruction of the infrastructure.

---

That's it! Your setup is now complete. If you encounter any issues, please refer to the Terraform, AWS CLI, and WireGuard documentation or contact the project maintainers for assistance.