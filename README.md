vagrant-centos-kibana
=====================

CentOS with Fluentd + Elasticsearch + Kibana on Vagrant.

## Usage

1. Run `vagrant up` to start two guest VMs.
1. Open [http://localhost:10080/](http://localhost:10080/) to show Kibana dashboard.
1. Login to sender VM and generate dummy access logs of Apache.

```
$ vagrant ssh sender
[vagrant@sender ~]$ sudo ./apache-loggen.sh
```

## Verification environment

* Mac OS 10.10.5
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
* Fluentd (td-agent 2.2.1)
  - fluent-plugin-elasticsearch
* Elasticsearch 1.7.1
  - elasticsearch-curator
* Kibana 4.1.1

You can login to receiver VM as following:

```
$ vagrant ssh receiver
```

Elasticsearch indices are automatically deleted every 15 days.

```
[root@receiver ~]# crontab -l
0 2 * * * /etc/elasticsearch/delete-elasticsearch-index.sh
[root@receiver ~]# cat /etc/elasticsearch/delete-elasticsearch-index.sh
...
exec_curator bloom 2
exec_curator close 10
exec_curator delete 15
```
