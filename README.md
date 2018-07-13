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
Deploy [monolith](https://github.com/express42/reddit.git) to GCP via `git clone`

# hw06 Packer
[0]: https://www.packer.io/downloads.html
1) Install [Packer][0] make alias in .bashrc_aliases
`alias packer='~/packer'`
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
terraform refresh && terraform output
```
8) Open port for our application - puma server tcp/9292
```
terraform plan && terraform apply
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
17) ?* keys added via web interface after `terraform apply` are deleted

# hw08 Terraform2
[8]: https://console.cloud.google.com/networking/networks/list?project=infra-198609&authuser=1
[9]: https://www.terraform.io/intro/getting-started/dependencies.html
[10]: https://www.terraform.io/docs/configuration/resources.html
[11]: https://github.com/express42/otus-snippets
[12]: https://www.terraform.io/docs/providers/template/index.html
[13]: https://www.terraform.io/docs/modules/sources.html
[14]: https://cloud.google.com/vpc/docs/using-firewalls
[15]: https://registry.terraform.io/
[16]: https://registry.terraform.io/modules/SweetOps/storage-bucket/google
[17]: https://registry.terraform.io/browse?provider=google
[18]: https://www.terraform.io/docs/backends/index.html
1) Recreate infrastructure by:
```
terraform apply
```
2) add default iptables -A ssh rule ACCEPT vs main.tf
3) import existing infrastructure in terraform
import GCP firewall ssh default policy:
```
terraform import google_compute_firewall.firewall_ssh default-allow-ssh
terraform apply --auto-approve=true
```
4) Resources
from webinterface delete [Bastion Statis IP][8]
5) del all resources and recreate
```
terraform destroy && terraform apply --auto-approve=true
```
6) Another resourse attribute and implicit [Resource Dependencies][9]
Dependencies affect priority order for applying/creation of instances
```
terraform destroy
terraform plan && terraform apply
```
Terraform supports explicit [Dependency][10] `depends_on` .
7) Resources structuring
Separate main.tf into two configs
via packer make 2 new images in GCP
```
packer build -var-file=variables.json app.json
packer build -var-file=variables.json db.json
```
we need mongo to bind IP to be not 127.0.0.1
provision new mongodb.conf and puma.service vs ENV database URL
get [terraform template provider][12] plugin vs `terraform init`
add template var in puma.service.tpl and in app.tf  and recreate instance
`terraform taint google_compute_instance.app` .
8) Modules [Terraform modules][13]
cp .tf cfgs into modules folders files and `terraform init && terraform get` .
create module "vpc" , now we cat set source_ip from main.tf see and cachanges by [gcp firewall-rules list][14]:
```
gcloud compute firewall-rules list --filter network=default \
    --sort-by priority \
    --format="table(
        name,
        priority,
        sourceRanges.list():label=[SRC_RANGES],
        destinationRanges.list():label=[DEST_RANGES],
        allowed[].map().firewall_rule().list():label=ALLOW,
        denied[].map().firewall_rule().list():label=DENY,
        sourceTags.list():label=[SRC_TAGS],
        targetTags.list():label=[TARGET_TAGS]
        )"
```
9) Reuse modules
prod and stage can use modules app and db like DRY way
10) Terraform [Module Registry][15]
install module [Terraform ][16] `terraform init`
list backets in GCP
```
gsutil ls
```
now we can keep tf state in [GCP Remote backends][18]
we need backends.tf vs `backends` secton in prod and stage configs to save and
use it's stages from cloud

##### Task *
Terraform locks tf state in Remote backends, while applying, so another tf job fails vs Error 412: Precondition Failed

# hw09 Ansible
[19]: https://habrahabr.ru/company/ruvds/blog/340306/
[20]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-10/ansible.cfg
[21]: http://docs.ansible.com/ansible/latest/intro_inventory.html
[22]: https://gist.github.com/Nklya/95a875d054d7956a54ddcd88b23f58a5
[23]: https://docs.ansible.com/ansible/latest/modules/command_module.html
[24]: https://docs.ansible.com/ansible/latest/modules/shell_module.html
[25]: https://docs.ansible.com/ansible/latest/modules/systemd_module.html
[26]: https://docs.ansible.com/ansible/latest/modules/service_module.html
[27]: https://docs.ansible.com/ansible/latest/modules/git_module.html
[28]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-10/clone.yml
1) Install ansible
```
pip install -r requirements.txt
pip install ansible>=2.4
easy_install `cat requirements.txt`
```
2) Create [inventory][19] file
3) Ansible can ping host
```
ansible appserver -i ./inventory -m ping
ansible dbserver -i ./inventory -m ping
```
4) Add [ansible.cfg][20]
now ansible can ping inventory hosts just like:
```
ansible appserver  -m ping
ansible dbserver -m ping
```
5) Commend module usage: `ansible dbserver -m command -a uptime` .
6) Inventory hosts group
```
ansible db -m ping
ansible all -m ping
```
7) [YAML Inventory][21]
ansible db -i ./inventory.yml -m ping
8) [comand module][23]
```
ansible db -m command -a 'systemctl status mongod'
```
9) [shell module][24] `ansible db -m shell -a 'systemctl status mongod'`
10) [systemd module][25] `ansible db -m systemd -a name=mongod`
11) [service module][26] `ansible db -m service -a name=mongod`
this module supports init.d
12) [git module][27]
```
ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/appuser/reddit'

```
13) Playbook `ansible-playbook clone.yml`
