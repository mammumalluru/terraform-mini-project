#!bin/bash

yum update -y
yum install nginx -y
systemctl start nginx
systemctl enable nginx
### rm -rf /usr/share/nginx/html/index.html   
#### > rm-rf is not needed because "">"" this will over ride the old content 
echo "This is executing through terraform" > /usr/share/nginx/html/index.html 