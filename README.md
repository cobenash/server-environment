# drupal-nginx-dockerfil
1.Download and go to Folder

2.nano Dockerfil Write your MYSQLPASSWORD

3.build your docker image

docker build -t wazlo2004/drupal-nginx:tag .

docker run -ti --name YOURCONTAINERNAME wazlo2004/drupal-nginx:20150216 /bin/bash

If you want user drupal on container  
go to container /usr/share/nginx/www  
drush dl drupal  
can user clean url

if you -v run dockerfile   
you can user 1.sh

cd /  
bash 1.sh --drupal_path=/usr/share/nginx/www --drupal_user=root


SSH Key

```
ssh-keygen -b 4096 -f develop_server.key
```
