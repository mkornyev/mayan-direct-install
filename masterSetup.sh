#!/usr/bin/env bash

## MAYAN SETUP ##

# Prevent dpkg-reconfigure from reading std in 
# --> used when provisioning is done w/Vagrant
export DEBIAN_FRONTEND=noninteractive

# Update 
sudo apt-get update 

# Get dependencies 
sudo apt-get install git exiftool g++ gcc coreutils ghostscript gnupg1 graphviz \
libfuse2 libjpeg-dev libmagic1 libpq-dev libpng-dev libreoffice \
libtiff-dev poppler-utils postgresql python3-dev python3-virtualenv \
redis-server sane-utils supervisor tesseract-ocr zlib1g-dev -y

sudo apt-get install libffi-dev libssl-dev -y
sudo apt-get install virtualenv 
sudo apt-get update # for good measure 


# Do setup 
sudo adduser mayan --disabled-password --disabled-login --gecos ""
sudo virtualenv /opt/mayan-edms -p /usr/bin/python3
sudo chown mayan:mayan /opt/mayan-edms -R
sudo -u mayan /opt/mayan-edms/bin/pip install -U pip
sudo -u mayan /opt/mayan-edms/bin/pip install mayan-edms
sudo -u mayan /opt/mayan-edms/bin/pip install psycopg2==2.8.6 redis==3.5.3
sudo -u mayan /opt/mayan-edms/bin/pip install psutil==5.7.0

sudo -u postgres psql -c "CREATE USER mayan WITH password 'mayanuserpass';"
sudo -u postgres createdb -O mayan mayan

sudo -u mayan MAYAN_DATABASES="{'default':{'ENGINE':'django.db.backends.postgresql','NAME':'mayan','PASSWORD':'mayanuserpass','USER':'mayan','HOST':'127.0.0.1'}}" \
MAYAN_MEDIA_ROOT=/opt/mayan-edms/media \
/opt/mayan-edms/bin/mayan-edms.py initialsetup

sudo -u mayan MAYAN_DATABASES="{'default':{'ENGINE':'django.db.backends.postgresql','NAME':'mayan','PASSWORD':'mayanuserpass','USER':'mayan','HOST':'127.0.0.1'}}" \
MAYAN_MEDIA_ROOT=/opt/mayan-edms/media \
/opt/mayan-edms/bin/mayan-edms.py platformtemplate supervisord | sudo sh -c "cat > /etc/supervisor/conf.d/mayan.conf"

echo "maxmemory-policy allkeys-lru" | sudo tee -a /etc/redis/redis.conf
echo "save \"\"" | sudo tee -a /etc/redis/redis.conf
echo "databases 2" | sudo tee -a /etc/redis/redis.conf
echo "requirepass mayanredispassword" | sudo tee -a /etc/redis/redis.conf
sudo systemctl restart redis

sudo systemctl enable supervisor
sudo systemctl restart supervisor

sudo apt-get remove --purge libjpeg-dev libpq-dev libpng-dev libtiff-dev zlib1g-dev
