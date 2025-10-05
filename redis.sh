#!/bin/bash

source ./common.sh
check_root
setup_logging

dnf module disable redis -y
validate $? "disabling redis"

dnf module enable redis:7 -y
validate $? "enabling redis"

dnf install redis -y
validate $? "installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/' -e 'protected-mode/ c protected-mode no ' /etc/redis/redis.conf
validate $? "Allowing remote connections to redis and updated protected mode from yes to no"

systemctl enable redis
validate $? "eanbling redis"

systemctl start redis
validate $? "start redis"

print_time
