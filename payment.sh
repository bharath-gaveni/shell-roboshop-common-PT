#!/bin/bash
source ./common.sh
name=payment
Dir_name=$PWD
check_root
setup_logging
app_setup
python_setup
systemd_setup
print_time
