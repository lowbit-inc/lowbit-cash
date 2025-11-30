#!/bin/bash

## Thinking...
# Data Structure
# - id
# - date
# - account
# - envelope
# - amount
# - description
#
# Income
# |id|date      |account|amount   |description|
# |1 |2025-11-28|1      |+10000.00|salary     |
#
# Expense
# |id|date      |account|envelope|amount|description|
# |2 |2025-11-29|1      |1       |-78.00|medicine   |
#
# Account Transfer
# |id|date      |account|amount |description|
# |3 |2025-11-30|1      |-100.00|fatura     |
# |4 |2025-11-30|2      |100.00 |fatura     |
#
# Envelope Transfer
# |id|date      |envelope|amount|description|
# |5 |2025-11-30|        |-50.00|extra      |
# |6 |2025-11-30|1       |50.00 |extra      |

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