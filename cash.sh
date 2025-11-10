#!/bin/bash
#
# Author: fewbits
# Date: 2025-11-10
# Description: Organize your finances without leaving the terminal

########
# Libs #
########
source ./libs/account.sh
source ./libs/database.sh
source ./libs/system.sh
source ./libs/validate.sh

##########
# Script #
##########

case "$1" in
  "account")
    shift
    accountMain "$@"
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
  *)
    system_help
    ;;
esac