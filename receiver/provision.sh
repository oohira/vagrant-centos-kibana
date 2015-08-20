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
wget -q https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.1.noarch.rpm
rpm -ivh elasticsearch-1.7.1.noarch.rpm
mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.orig
cp ${conf_dir}/elasticsearch/elasticsearch.yml /etc/elasticsearch/
service elasticsearch start
chkconfig elasticsearch on

# curator
curl -OL https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python get-pip.py
pip install elasticsearch-curator==3.2.3
cp ${conf_dir}/elasticsearch/delete-elasticsearch-index.sh /etc/elasticsearch/
chmod 755 /etc/elasticsearch/delete-elasticsearch-index.sh
echo "0 2 * * * /etc/elasticsearch/delete-elasticsearch-index.sh" | crontab -

# kibana
wget -q https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x64.tar.gz
tar xvzf kibana-4.1.1-linux-x64.tar.gz
mv kibana-4.1.1-linux-x64 /opt/kibana
mv /opt/kibana/config/kibana.yml /opt/kibana/config/kibana.yml.orig
cp ${conf_dir}/kibana/kibana.yml /opt/kibana/config/
cp ${conf_dir}/kibana/kibana /etc/init.d/
chmod 755 /etc/init.d/kibana
service kibana start
chkconfig kibana on

# fluentd
wget -q http://packages.treasuredata.com.s3.amazonaws.com/2/redhat/6/x86_64/td-agent-2.2.1-0.el6.x86_64.rpm
rpm -ivh td-agent-2.2.1-0.el6.x86_64.rpm
yum install -y gcc-c++ libcurl-devel
/opt/td-agent/embedded/bin/fluent-gem install --no-ri --no-rdoc fluent-plugin-elasticsearch
mv /etc/td-agent/td-agent.conf /etc/td-agent/td-agent.conf.orig
cp ${conf_dir}/td-agent/td-agent.conf /etc/td-agent/
service td-agent start
chkconfig td-agent on
