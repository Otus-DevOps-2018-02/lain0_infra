# Ansible `ansible srvname -i ./inventory -m ping` .
# verbose ansible output
```
ansible all -i inventory.yml -m ping -vvv
```
# test ansible config/inventory OK
`ansible db  -m debug`
# ansible debug
```
ANSIBLE_DEBUG=1 ansible all -i inventory.yml -m ping
```

############################################################
# Ansible-playbook
# lint `ansible-lint` .
# `ansible-playbook check` .

# `--limit` for filtering for hostname applying playbook
```
ansible-playbook reddit_app.yml --check --limit db
```
# `--tags` for filtering on tags applying playbook
```
ansible-playbook reddit_app.yml --check --limit app --tags deploy-tag
```

# debug
```
export ANSIBLE_STRATEGY=debug
```
in playbook:
```
- hosts: localhost
  strategy: debug
    tasks:
```
############################################################
# ansible-vault
```
ansible-vault encrypt environments/prod/credentials.yml
ansible-vault decrypt environments/prod/credentials.yml
ansible-vault edit environments/prod/credentials.yml
```
