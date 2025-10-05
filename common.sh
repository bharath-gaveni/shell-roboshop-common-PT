#!/bin/bash
N="\e[0m"
R="\e[0;31m"
G="\e[0;32m"
Y="\e[0;33m"

id=$(id -u)

check_root() {
    if [ $id -ne 0 ]; then
        echo -e "Please execute the script $0 with root user access privilage"
        exit 1
    fi
}

log_folder=/var/log/shell-roboshop-common-PT
script_name=$(echo $0 | cut -d "." -f1)
log_file=$log_folder/$script_name.log

mkdir -p $log_folder
start_time=$(date +%s)
echo "script $0 execution started at time: $(date)"








end_time=$(date +%s)
total_time=$(($end_time-$start_time))
echo "Total time taken to execute the script is $total_time seconds"
