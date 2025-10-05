#!/bin/bash
N="\e[0m"
R="\e[0;31m"
G="\e[0;32m"
Y="\e[0;33m"
Dir_name=$PWD

check_root() {
    id=$(id -u)
    if [ $id -ne 0 ]; then
        echo -e " $R Please execute the script $0 with root user access privilage $N"
        exit 1
    fi
}

log_folder=/var/log/shell-roboshop-common-PT
script_name=$(echo $0 | cut -d "." -f1)
log_file=$log_folder/$script_name.log

setup_logging(){
    mkdir -p $log_folder
    start_time=$(date +%s)
    echo "script $0 execution started at time: $(date)" | tee -a $log_file
}

validate() {
    if [ $1 -ne 0 ]; then
        echo -e "$2 is $R Failed $N" | tee -a $log_file
        exit 1
    else
        echo -e "$2 is $G Success $N" | tee -a $log_file
    fi
}

dnf module disable nginx -y &>>$log_file
validate $? "disabling nginx"

dnf module enable nginx:1.24 -y &>>$log_file
validate $? "enabling nginx1.24"

dnf install nginx -y &>>$log_file
validate $? "installing nginx"

systemctl enable nginx &>>$log_file
validate $? "enabling nginx"

systemctl start nginx &>>$log_file
validate $? "start nginx"

rm -rf /usr/share/nginx/html/* &>>$log_file
validate $? "removing existing code of nginx"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$log_file
validate $? "downloading the nginx code to temp direc"
cd /usr/share/nginx/html &>>$log_file
validate $? "changing the directory nginx"
unzip /tmp/frontend.zip &>>$log_file
validate $? "unzipping frontend nginx code"
cp $Dir_name/nginx.conf /etc/nginx/nginx.conf &>>$log_file
validate $? "copying the nginx.conf for reverse proxy"

systemctl restart nginx &>>$log_file
validate $? "restarting nginx"


