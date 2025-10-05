#!/bin/bash
source ./common.sh
check_root
systemd_setup

dnf install mysql-server -y &>>$log_file
validate $? "installing mysql"

systemctl enable mysqld &>>$log_file
validate $? "enable mysql"

systemctl start mysqld &>>$log_file
validate $? "start mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$log_file
validate $? "settingup password for mysql"

print_time