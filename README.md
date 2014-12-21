vagrant-centos-kibana
=====================

CentOS with Fluentd + Elasticsearch + Kibana on Vagrant.

## Usage

1. Run `vagrant up` to start two guest VMs.
1. Open [http://localhost:10080/kibana/](http://localhost:10080/kibana/) to show Kibana dashboard.
1. Login to sender VM and generate dummy access logs of Apache.

```
$ vagrant ssh sender
[vagrant@sender ~]$ sudo ./apache-loggen.sh
```

## Verification environment

* Mac OS 10.9.5
* VirtualBox 4.3.12
* Vagrant 1.6.3

## Installed packages

### Sender VM

Fluentd collects Apache access logs and forwards them to receiver VM's Fluentd (192.168.33.20:24224).

* CentOS (192.168.33.10)
* Apache
* Fluentd (td-agent)
* apache-loggen

You can login to sender VM as following:

```
$ vagrant ssh sender
```

### Receiver VM

Fluentd collects logs from sender VM and adds them to Elasticsearch indices. They are visualized by Kibana on Apache port 80. Port forwarding from host 10080 to guest 80 is enabled.

* CentOS (192.168.33.20)
* Apache
* Fluentd (td-agent)
  - fluent-plugin-elasticsearch
* Elasticsearch
* Kibana

You can login to receiver VM as following:

```
$ vagrant ssh receiver
```
