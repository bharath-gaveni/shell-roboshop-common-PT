#!/bin/bash
name=user
Dir_name=$PWD

check_root
setup_logging
app_setup
nodejs_setup
systemd_setup