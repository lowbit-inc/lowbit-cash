#!/bin/bash

function transaction_help() {
  echo "${system_banner} - Transactions Usage"
  echo
  echo "${system_basename} transaction add"
  echo "  --account ACCOUNT_ID"
  echo "  --envelope ENVELOPE_ID"
  echo "  --date DATE"
  echo "  --amount AMOUNT"
  echo "  [--description OPTIONAL_TEXT]"
  echo
  echo "${system_basename} transaction list"
  echo "  [--account ACCOUNT_ID]"
  echo "  [--envelope ENVELOPE_ID]"
  echo
  exit 0
}

function transaction_list() {

  database_run "SELECT * FROM transactions_view;"

}

function transaction_main() {
  case $1 in
    "help")
      transaction_help
      ;;
    "list")
      transaction_list
      ;;
    *)
      transaction_help
      ;;
  esac
}