# Ansible
ansible srvname -i ./inventory -m ping

# verbose ansible output
ansible all -i inventory.yml -m ping -vvv

# test ansible config/inventory OK
ansible db  -m debug

# ansible debug
ANSIBLE_DEBUG=1 ansible all -i inventory.yml -m ping

# lint
ansible-lint
