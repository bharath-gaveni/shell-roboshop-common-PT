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
        echo -e "$2 is $R Failed $N"
        exit 1
    else
        echo -e "$2 is $G Success $N"
    fi
}

app_setup() {
    
    mkdir -p /app &>>$log_file
    validate $? "creating app directory"
    
    curl -L -o /tmp/$name.zip https://roboshop-artifacts.s3.amazonaws.com/$name-v3.zip &>>$log_file
    validate  $? "dowloading $name code to temp direc location"
    
    cd /app &>>$log_file
    validate $? "changing to app directory"
    
    rm -rf /app/* &>>$log_file
    validate $? "removing the existing code"
    
    unzip /tmp/$name.zip &>>$log_file
    validate $? "unzipping the $name code in to app dir location"
    
    cd /app &>>$log_file
    validate $? "changing to app directory"
}

nodejs_setup() {
    dnf module disable nodejs -y &>>$log_file
    validate $? "Disabling nodejs"
    
    dnf module enable nodejs:20 -y &>>$log_file
    validate $? "enabling nodejs:20"
    
    dnf install nodejs -y &>>$log_file
    validate $? "installing nodejs"
    
    npm install &>>$log_file
    validate $? "installing dependencies"
}






systemd_setup() {
    id roboshop &>>$log_file
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file
    else
        echo -e "user already exists $Y SKIPPING $N"
    fi
    
    cp $Dir_name/$name.service /etc/systemd/system/$name.service &>>$log_file
    validate $? "copying the sysyemd $name service file"
    
    systemctl daemon-reload &>>$log_file
    validate $? "Daemon-reload"
    
    systemctl enable $name &>>$log_file
    validate $? "enabling $name"
    
    systemctl start $name &>>$log_file
    validate $? "start $name"
    
}

print_time() {
    end_time=$(date +%s)
    total_time=$(($end_time-$start_time))
    echo "Total time taken to execute the script $0 is $total_time seconds" | tee -a $log_file
}

