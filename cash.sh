#!/bin/bash
#
# Author: fewbits
# Date: 2025-11-10
# Description: Organize your finances without leaving the terminal

########
# Libs #
########
# Dependencies
source ./libs/color.sh
source ./libs/log.sh
source ./libs/system.sh
source ./libs/validate.sh
# Database
source ./libs/database.sh
# Objects
source ./libs/account.sh
source ./libs/envelope.sh
source ./libs/transaction.sh

##########
# Script #
##########

case "$1" in
  "account")
    shift
    account_main "$@"
    ;;
  "balance")
    shift
    account_balance "$@"
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