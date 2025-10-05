#!/bin/bash
source ./common.sh
name=cart
$Dir_name=$PWD
check_root
setup_logging
app_setup
nodejs_setup
systemd_setup
print_time