#!/bin/bash

# Banner

clear
cat << EOF

██╗    ██╗███████╗██████╗ ██████╗ ██████╗ 
██║    ██║██╔════╝██╔══██╗██╔══██╗██╔══██╗
██║ █╗ ██║█████╗  ██████╔╝██████╔╝██████╔╝
██║███╗██║██╔══╝  ██╔══██╗██╔══██╗██╔═══╝ 
╚███╔███╔╝███████╗██████╔╝██████╔╝██║     
 ╚══╝╚══╝ ╚══════╝╚═════╝ ╚═════╝ ╚═╝  
                                -useraid


Welcome to WebBP.     

For options and flags use -h or --help.
EOF

# Help Function

function help {
cat <<EOF


This program generates a Boilerplate template for your web applications.
    WARNING: Some of the functionality in this program requires root privileges. Use at
your own risk.

    options:

        -h                Display all options and flags. 

        -l                LAMP Stack

        -m                MERN Stack


EOF
}

# Variables

TIMEZONE=$(cat /etc/timezone)
SQLRPASS="rootpwd"
SQLUSER="user"
SQLPASS="password"
SQLDB="newdb"


# Docker Installation Check

function docker {
  # Curl
  if ! command -v curl &> /dev/null
  then
      sudo apt-get -y install curl
  fi
  # Docker
  if ! command -v docker &> /dev/null
  then
      curl -sSL https://get.docker.com/ | sh
      sudo usermod -aG docker $USER
      newgrp docker
      sudo apt-get -y install docker-compose
  fi
}

# Docker Dashboard

function dockerdash {
  # Deploying Portainer
  docker volume create portainer_data
  docker run -d \
  --name portainer \
  -p 9000:9000 \
  -p 9443:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  --restart=always \
  portainer/portainer-ce:latest
}

# LAMP Stack

function lamp {
  mkdir -p ~/lamp/webroot
  touch ~/lamp/docker-compose.yml
  cat << EOF >> ~/lamp/docker-compose.yml
version: '3.7'

services:
    php-httpd:
        image: php:apache
        ports:
            - 80:80
        volumes:
            - "./webroot:/var/www/html"

    mariadb:
        image: mariadb:latest
        volumes:
            - mariadb-volume:/var/lib/mysql
        environment:
            TZ: "$TIMEZONE"
            MYSQL_ALLOW_EMPTY_PASSWORD: "no"
            MYSQL_ROOT_PASSWORD: "$SQLRPASS"
            MYSQL_USER: "$SQLUSER"
            MYSQL_PASSWORD: "$SQLPASS"
            MYSQL_DATABASE: "$SQLDB"

    phpmyadmin:
        image: phpmyadmin/phpmyadmin
        links:
            - 'mariadb:db'
        ports:
            - 8081:80

volumes:
    mariadb-volume:

EOF

docker-compose -f /home/$USER/lamp/docker-compose.yml up -d
}

# MERN Stack

function mern {
  
}

# Selection Flags

while getopts 'hr:' FLAG; do
  case "$FLAG" in
    h)
      help
      ;;
    r)
      rname="$OPTARG"
      echo "value $OPTARG"
      ;;
    \?)
      echo "usage: $(basename \$0) [-flag] *name for app* " >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
