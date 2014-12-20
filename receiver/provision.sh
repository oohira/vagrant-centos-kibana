#!/bin/sh

conf_dir=/vagrant/receiver

# httpd
yum install -y httpd
mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.orig
cp ${conf_dir}/httpd/httpd.conf /etc/httpd/conf/
service httpd start
chkconfig httpd on

# elasticsearch
yum install -y java-1.8.0-openjdk-headless
wget -q https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.1.noarch.rpm
rpm -ivh elasticsearch-1.4.1.noarch.rpm
mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.orig
cp ${conf_dir}/elasticsearch/elasticsearch.yml /etc/elasticsearch/
service elasticsearch start
chkconfig elasticsearch on

# kibana
wget -q https://download.elasticsearch.org/kibana/kibana/kibana-3.1.2.tar.gz
tar xvzf kibana-3.1.2.tar.gz
mv kibana-3.1.2/config.js kibana-3.1.2/config.js.orig
cp ${conf_dir}/kibana/config.js kibana-3.1.2/
mv kibana-3.1.2 /opt/
ln -snf /opt/kibana-3.1.2 /var/www/html/kibana

# fluentd
curl -L http://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh
yum install -y gcc-c++ libcurl-devel
/opt/td-agent/embedded/bin/fluent-gem install --no-ri --no-rdoc fluent-plugin-elasticsearch
mv /etc/td-agent/td-agent.conf /etc/td-agent/td-agent.conf.orig
cp ${conf_dir}/td-agent/td-agent.conf /etc/td-agent/
service td-agent start
chkconfig td-agent on
