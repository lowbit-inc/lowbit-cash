#!/bin/bash
#
# Author: fewbits
# Date: 2025-11-10
# Description: Organize your finances without leaving the terminal

########
# Libs #
########
# First
source ./libs/log.sh
# Others
source ./libs/account.sh
source ./libs/database.sh
source ./libs/envelope.sh
source ./libs/system.sh
source ./libs/transaction.sh
source ./libs/validate.sh

##########
# Script #
##########

case "$1" in
  "account")
    shift
    account_main "$@"
    ;;
  "envelope")
    shift
    envelope_main "$@"
    ;;
  "help"|"--help"|"-h")
    system_help
    ;;
  "install")
    system_install
    ;;
  "transaction")
    shift
    transaction_main "$@"
    ;;
  "version"|"--version"|"-v")
    system_version
    ;;
  *)
    system_help
    ;;
esac