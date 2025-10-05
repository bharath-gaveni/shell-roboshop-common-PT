#!/bin/bash
source ./common.sh
check_root
setup_logging

dnf install rabbitmq-server -y &>>$log_file
validate $? "installing rabbitmq"

systemctl enable rabbitmq-server &>>$log_file
validate $? "installing rabbitmq"

systemctl start rabbitmq-server &>>$log_file
validate $? "installing rabbitmq"

USER_NAME="roboshop"
USER_PASS="roboshop123"
rabbitmqctl list_users | grep -w "$USER_NAME" &>>$log_file
if [ $? -ne 0 ]; then
    rabbitmqctl add_user $USER_NAME $USER_PASS
    validate $? "adding username and password"
else
    echo "username is already exists $Y SKIPPING $N" | tee -a $log_file
fi

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
validate $? "setting permissions to allow all traffic to receive the que"

print_time



