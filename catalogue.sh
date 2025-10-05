#!/bin/bash
source ./common.sh
name=catalogue
Dir_name=$PWD
mongodb_Host_name=mongodb.bharathgaveni.fun
check_root
setup_logging
app_setup
nodejs_setup
systemd_setup

cp $Dir_name/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
validate $? "copying mongo.repo file"

dnf install mongodb-mongosh -y &>>$log_file
validate $? "installing mongodb client software to connect and load data in mongodb server"

index=$(mongosh $mongodb_Host_name --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $index -le 0 ]; then
    mongosh --host $mongodb_Host_name </app/db/master-data.js &>>$log_file
    echo "data is loaded to mongodb DB"
else
    echo -e "data is already loaded $Y SKIPPING $N" | tee -a $log_file
fi
print_time


