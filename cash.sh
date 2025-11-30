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
source ./libs/envelope.sh
source ./libs/log.sh
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
  "help")
    system_help
    ;;
  "install")
    system_install
    ;;
  "transaction")
    shift
    transaction_main "$@"
    ;;
  "version")
    system_version
    ;;
  *)
    system_help
    ;;
esac