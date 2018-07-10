# lain0_infra

[![Build Status](https://api.travis-ci.org/Otus-DevOps-2018-02/lain0_infra.svg?branch=master)](https://api.travis-ci.org/Otus-DevOps-2018-02/lain0_infra)


# hw04 GCP, cloud-bastion
```
alias gcp1='ssh -o ProxyCommand="ssh -W %h:%p otus-serj@35.205.136.3" otus-serj@10.132.0.3'
alias gcp-vpn='sudo openvpn --config otus_test_bastion.ovpn'
alias gcp1='ssh -o ProxyCommand="ssh -W %h:%p otus-serj@192.168.248.1" otus-serj@10.132.0.3'
```
bastion_IP = 35.205.136.3
someinternalhost_IP = 10.132.0.3

# hw05 cloud-testapp
testapp_IP = 35.195.86.97
testapp_port = 9292
open firewall tcp:9292 port for non-standart puma server
```
gcloud compute firewall-rules create puma-server \
  --action allow \
  --direction ingress \
  --rules tcp:9292 \
  --source-ranges 0.0.0.0/0 \
  --priority 1000 \
  --target-tags puma-server
```

# hw06 Packer
[0]: https://www.packer.io/downloads.html
1) Install [Packer][0] make alias in .bashrc_aliases
alias packer='~/packer'
2) set project_id
```
gcloud config set project infra-198609
```
3) Application Default Credentials (ADC)
```
gcloud auth application-default login
```
4) Create Packer template vs variables, validate and build image
```
packer validate -var-file=variables.json ubuntu16.json && \
packer build -var-file=variables.json ubuntu16.json
```
5) Create new gcloud instance
```
gcloud compute instances create reddit-app-packer \
  --image-family=reddit-base \
  --image-project=infra-198609 \
  --machine-type=f1-micro \
  --tags=puma-server \
  --zone=europe-west1-b \
  --restart-on-failure \
  --metadata-from-file startup-script=config-scripts/deploy.sh
```

# hw07 Infrastructure as Code, Terraform.key
[1]: https://www.terraform.io/downloads.html
[2]: https://console.cloud.google.com/compute/metadata/sshKeys?project=infra-198609&authuser=1
[3]: https://www.terraform.io/docs/providers/google/index.html
[4]: https://www.terraform.io/docs/providers/google/r/compute_instance.html
[5]: https://www.terraform.io/docs/provisioners/index.html
[6]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-08/puma.service
[7]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-08/part_of_main.tf
1) check if image['reddit-base'].exists?
```
gcloud compute images list --filter reddit
```
2) Del appuser ssh-key from web interface: [Compute Engine->metadata->SSHkeys][2]
3) Install [Terraform][1]
4) Create main configuration terraform file: terraform/main.tf
5) Terraform init && apply
```
terraform init
terraform apply --auto-approve=true
```
6) Add terraform sshkey
7) Filter Terraform output values
```
terraform refresh
terraform output
```
8) Open port for our application - puma server tcp/9292
```
terraform plan
terraform apply
```
9) Add tag to VM
10) Provisioners. Add provisioner section in main.tf,
11) get [puma.service][6]
12) set connection propperties via section connection and sshkey
13) test Provisioners
```
terraform taint google_compute_instance.app
terraform plan
terraform apply --auto-approve=true
```
14) make Input vars vs terraform.tfvars
15) terraform destroy --auto-approve=true && terraform plan && terraform apply --auto-approve=true && terraform output
16) terraform linter:
```
terraform fmt
```
17) ?* keys added via web interface after "terraform apply" are deleted

# hw08 Terraform2
1) Recreate infrastructure by:
```
terraform apply
```
2) add default iptables -A ssh rule ACCEPT vs main.tf
3) import existing infrastructure in terraform
import GCP firewall ssh default policy:
```
terraform import google_compute_firewall.firewall_ssh default-allow-ssh
terraform apply --auto-approve=true && terraform output
```
