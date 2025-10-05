#!/bin/bash
source ./common.sh
name=shipping
Dir_name=$PWD
mysql_Host_name=mysql.bharathgaveni.fun
check_root
setup_logging
app_setup
java_setup
systemd_setup

dnf install mysql -y &>>$log_file
validate $? "installing mysql client software to connect with mysql and run the DB scripts"

mysql -h $mysql_Host_name -uroot -pRoboShop@1 -e 'use cities' &>>$log_file
if [ $? -ne 0 ]; then
    mysql -h $mysql_Host_name -uroot -pRoboShop@1 < /app/db/schema.sql &>>$log_file
    mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$log_file
    mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$log_file
    echo -e "$G data is loaded succesfully $N" | tee -a $log_file
else
    echo "Data is already is loaded $Y SKIPPING $N" | tee -a $log_file
fi

systemctl restart $name &>>$log_file
validate $? "restarted the $name"

print_time