#!/bin/sh

conf_dir=/vagrant/sender

# fluentd
curl -L http://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh
mv /etc/td-agent/td-agent.conf /etc/td-agent/td-agent.conf.orig
cp ${conf_dir}/td-agent/td-agent.conf /etc/td-agent/
service td-agent start
chkconfig td-agent on

# httpd
yum install -y httpd
chmod +x /var/log/httpd
chmod +r /var/log/httpd/access_log
service httpd start
chkconfig httpd on

# apache-loggen
/opt/td-agent/embedded/bin/fluent-gem install --no-ri --no-rdoc apache-loggen
echo '/opt/td-agent/embedded/bin/apache-loggen --rate=10 --progress /var/log/httpd/access_log' > /home/vagrant/apache-loggen.sh
chmod +x /home/vagrant/apache-loggen.sh

