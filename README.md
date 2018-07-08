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

# hw05
cloud-testapp

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

