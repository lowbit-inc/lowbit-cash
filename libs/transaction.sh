#!/bin/bash

## Thinking...
# Data Structure
# - id
# - account
# - envelope
# - date
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
  echo "${system_banner} - Transactions"
  echo
  echo "Usage: ${system_basename} transaction ACTION [ARGS]"
  echo
  echo "ACTIONS:"
  echo "? add"
  echo "? delete"
  echo "? edit"
  echo "- help (this message)"
  echo "- list"
  echo
  exit 0
}

function transaction_list() {

  ## Parsing args
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
      "--help")
        log_message debug "Getting help message"
        transaction_list_help
        ;;
    esac
    shift
  done

  ## Optional args
  # soon

  ## Action
  database_run "SELECT * FROM transactions_view;"

}

function transaction_list_help() {
  echo "${system_banner} - Transaction List"
  echo
  echo "Usage: ${system_basename} transaction list [ARGS]"
  echo
  echo "OPTIONAL ARGS:"
  echo "(soon)"
  echo
  exit 0
}

function transaction_main() {
  case $1 in
    "help")
      transaction_help
      ;;
    "list")
      shift
      transaction_list "$@"
      ;;
    *)
      transaction_help
      ;;
  esac
}