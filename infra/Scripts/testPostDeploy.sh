#! /bin/bash
# Script to test the custom script extension

echo "Testing post deployment by installing Apache and opening port 80 in firewalld"
echo "$1" >> /home/bhadmin/scriptoutput.txt 

yum install httpd -y
echo "test" > /var/www/html/index.html
chown -R apache. /var/www/html
systemctl start httpd
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --reload
