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
Terraform supports explicit [Dependency][10]
```
depends_on
```
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
```
terraform taint google_compute_instance.app
```
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

#### Task *
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
[29]: https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html
[30]: https://medium.com/@Nklya/%D0%B4%D0%B8%D0%BD%D0%B0%D0%BC%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%BE%D0%B5-%D0%B8%D0%BD%D0%B2%D0%B5%D0%BD%D1%82%D0%BE%D1%80%D0%B8-%D0%B2-ansible-9ee880d540d6
[31]: https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html
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
before `rm -rf` ansible changed=0 becouse directory already existed
after module git cloned it on server and changed=1
#### Task vs *
14) [Dynamic inventory][29] vs json config
`ansible all -i inventory.json -m ping`

# hw10 Ansible Playbooks Templates
[32]: https://gist.githubusercontent.com/Artemmkin/7609a03210e66af90d12bc59a54f6e3f/raw/690bebc6ab17b3a50b82667873c03c0722e8773b/puma.service
[33]: https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#task-and-handler-organization-for-a-role
[34]: https://gist.githubusercontent.com/Artemmkin/b0d74e5e439cb2865597567c3e17170c/raw/588aa069cf39e887595f97de7fd0be86b6b6417d/mongo_play2.yaml
[35]: https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html
[36]: https://docs.ansible.com/ansible/latest/modules/list_of_all_modules.html
[37]: https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html
[38]: https://docs.ansible.com/ansible/latest/modules/apt_module.html#apt-module
[39]: https://docs.ansible.com/ansible/latest/modules/apt_key_module.html#apt-key-module
[40]: https://docs.ansible.com/ansible/latest/modules/apt_repository_module.html#apt-repository-module
[41]: https://docs.ansible.com/ansible/latest/modules/bundler_module.html#bundler-module
[42]: https://docs.ansible.com/ansible/latest/modules/gem_module.html#gem-module
1) One playbook one play
disable provisioning in teraform app/db modules
`terrafotm destroy && terraform apply`
`andible-playlook --check reddit_app.yml`
define variables
`ansible-playbook reddit_app.yml --check --limit db`
# [Handlers][33]
handlers run only after another tasks notification like restart daemon on config change
```
ansible-playbook reddit_app.yml --check --limit db
ansible-playbook reddit_app.yml --limit db
```
deploy vs module git in `reddit_app.yml` playbook vs tag: deploy-tag
```
ansible-playbook reddit_app.yml --check --limit app --tags deploy-tag
ansible-playbook reddit_app.yml --limit app --tags deploy-tag
```
2) one playbook many plays
- Split main play, add new reddit_app2.yml, group tasks by tags
- Define separate play for configuration Mongodb
```
ansible-playbook reddit_app2.yml --tags db-tag --check
ansible-playbook reddit_app2.yml --tags db-tag
ansible-playbook reddit_app2.yml --tags app-tag --check
ansible-playbook reddit_app2.yml --tags app-tag
```
Deploy
```
ansible-playbook reddit_app2.yml --tags deploy-tag --check
ansible-playbook reddit_app2.yml --tags deploy-tag
```
3) multi Playbooks
```
ansible-playbook site.yml --check
ansible-playbook site.yml
```
4) Packer provision vs ansible
[Ansible modules][36]
[Ansible loops][37]
Using modules: [apt][38] [apt_key][39] [apt_repository][40]
[bundler][41] [gem][42]
```
packer validate -var-file=packer/variables.json packer/app.json
packer validate -var-file=packer/variables.json packer/db.json
packer build -var-file=packer/variables.json packer/app.json
packer build -var-file=packer/variables.json packer/db.json
cd terraform/stage && terraform destroy && terraform apply
cd ../../ansible && ansible-playbook site.yml --check && \
ansible-playbook site.yml
```

# hw11 Ansible Galaxy Roles
[43]: https://galaxy.ansible.com/home
[44]: https://docs.ansible.com/ansible/latest/modules/debug_module.html
[45]: https://github.com/jdauphant/ansible-role-nginx
[46]: https://docs.ansible.com/ansible/devel/user_guide/vault.html
1) [Ansible Roles and Ansible Galaxy][43]
```
ansible-galaxy init app
ansible-galaxy init db
```
db && app roles
```
cd terraform/stage && terraform destroy && terraform apply -auto-approve=false
ansible-playbook site.yml --check
ansible-playbook site.yml
```
2) Make 2 enviroments `ansible-playbook -i environments/prod/inventory deploy.yml`
test stage env ansible:
```
cd terraform/stage && terraform destroy && terraform apply -auto-approve=false
cd ../../ansible
ansible-playbook playbooks/site.yml --check
ansible-playbook playbooks/site.yml

test prod env ansible:
```
cd terraform/stage && terraform destroy
cd ../prod && terraform apply -auto-approve=false
cd ../../ansible
ansible-playbook -i environments/prod/inventory playbooks/site.yml --check
ansible-playbook -i environments/prod/inventory playbooks/site.yml
```
using [module debug][44] we can output msg
3) Use [ansible-galaxy community role jdauphant.nginx][45]
install role `ansible-galaxy install -r environments/stage/requirements.yml`
jdauphant.nginx role needs gathering facts == True in ansible config
```
cd terraform/stage && terraform apply
ansible-playbook -i environments/prod/inventory playbooks/site.yml
```
4) [Ansible Voult][46]
