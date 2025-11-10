#!/bin/bash
#
# Author: fewbits
# Date: 2025-11-10
# Description: Organize your finances without leaving the terminal

########
# Libs #
########
source ./libs/system.sh

##########
# Script #
##########

usr_args="$@"

case "$1" in
  "account")
    ;;
  "envelope")
    ;;
  "help")
    system_help
    ;;
  "transaction")
    ;;
  "version")
    system_version
    ;;
esac