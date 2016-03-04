# drupal-nginx-dockerfil
## 1.Download and go to Folder

## 2.nano Dockerfil Write your MYSQLPASSWORD

## 3.build your docker image
docker build -t wazlo2004/drupal-nginx:tag .
docker run -ti --name YOURCONTAINERNAME wazlo2004/drupal-nginx:20150216 /bin/bash

## If you want user drupal on container  
go to container /usr/share/nginx/www  
drush dl drupal  
## can user clean url

## 4.Permission to drupal  
在建立drupal的空白網站時  
必須要給sites/default/裡的files與settings.php 777權限  
但是這是不安全的，所以我們這個時候執行一下下面的指令  
使自己的drupal更加安全  
cd ~/sh/  
bash 1.sh --drupal_path=/usr/share/nginx/www --drupal_user=root  

or go to /usr/share/nginx/www/  
carried out  
~/sh/bs.sh



SSH Key

```
ssh-keygen -b 4096 -f develop_server.key
```
