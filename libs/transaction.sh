#!/bin/bash

## Thinking...
# Data Structure
# - account
# - amount
# - date
# - description
# - envelope
# - id
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

function transaction_add_expense() {

  if [[ ! "$1" ]]; then
    transaction_add_expense_help
  fi

  ## Parsing args
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
      "--account")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got account ID: $1"
          validate_number "$1" && this_transaction_account_id="$1"
        else
          log_message error "Missing account ID."
        fi
        ;;
      "--amount")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got transaction amount: $1"
          validate_money "$1" && this_transaction_amount="$1"
        else
          log_message error "Missing transaction amount."
        fi
        ;;
      "--date")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got transaction date: $1"
          validate_date "$1" && this_transaction_date="$1"
        else
          log_message error "Missing transaction date."
        fi
        ;;
      "--description")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got transaction description: $1"
          validate_string "$1" && this_transaction_description="$1"
        else
          log_message error "Missing transaction description."
        fi
        ;;
      "--envelope")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got envelope ID: $1"
          validate_number "$1" && this_transaction_envelope_id="$1"
        else
          log_message error "Missing envelope ID."
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        transaction_add_expense_help
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_transaction_account_id ]]  || log_message error "Missing account ID."
  [[ $this_transaction_amount ]]      || log_message error "Missing transaction amount."
  [[ $this_transaction_date ]]        || log_message error "Missing transaction date."
  [[ $this_transaction_description ]] || log_message error "Missing account initial balance."
  [[ $this_transaction_envelope_id ]] || log_message error "Missing envelope ID."

  ## Action
  database_silent "INSERT INTO transactions (account_id, envelope_id, amount, date, description) VALUES ($this_transaction_account_id, $this_transaction_envelope_id, -$this_transaction_amount, '$this_transaction_date', '$this_transaction_description');"

}

function transaction_add_expense_help() {
  echo "${system_banner} - Transaction Add Expense"
  echo
  echo "Usage: ${system_basename} transaction add-expense ARGS"
  echo
  echo "REQUIRED ARGS:"
  echo "--account ACCOUNT_ID"
  echo "--envelope ENVELOPE_ID"
  echo "--date DATE"
  echo "--amount AMOUNT"
  echo "--description DESCRIPTION"
  echo
  exit 0
}

function transaction_add_income() {

  if [[ ! "$1" ]]; then
    transaction_add_income_help
  fi

  ## Parsing args
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
      "--account")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got account ID: $1"
          validate_number "$1" && this_transaction_account_id="$1"
        else
          log_message error "Missing account ID."
        fi
        ;;
      "--amount")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got transaction amount: $1"
          validate_money "$1" && this_transaction_amount="$1"
        else
          log_message error "Missing transaction amount."
        fi
        ;;
      "--date")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got transaction date: $1"
          validate_date "$1" && this_transaction_date="$1"
        else
          log_message error "Missing transaction date."
        fi
        ;;
      "--description")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got transaction description: $1"
          validate_string "$1" && this_transaction_description="$1"
        else
          log_message error "Missing transaction description."
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        transaction_add_income_help
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_transaction_account_id ]]  || log_message error "Missing account ID."
  [[ $this_transaction_amount ]]      || log_message error "Missing transaction amount."
  [[ $this_transaction_date ]]        || log_message error "Missing transaction date."
  [[ $this_transaction_description ]] || log_message error "Missing account initial balance."

  ## Action
  database_silent "INSERT INTO transactions (account_id, amount, date, description) VALUES ($this_transaction_account_id, $this_transaction_amount, '$this_transaction_date', '$this_transaction_description');"

}

function transaction_add_income_help() {
  echo "${system_banner} - Transaction Add Income"
  echo
  echo "Usage: ${system_basename} transaction add-income ARGS"
  echo
  echo "REQUIRED ARGS:"
  echo "--account ACCOUNT_ID"
  echo "--date DATE"
  echo "--amount AMOUNT"
  echo "--description DESCRIPTION"
  echo
  exit 0
}

function transaction_delete() {

  if [[ ! "$1" ]]; then
    transaction_delete_help
  fi

  ## Parsing args
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
      "--id")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got transaction ID: $1"
          validate_number "$1" && this_transaction_id="$1"
        else
          log_message error "Missing transaction ID."
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        transaction_delete_help
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_transaction_id ]] || log_message error "Missing transaction ID."

  ## Action
  database_silent "DELETE FROM transactions WHERE id = $this_transaction_id ;"

}

function transaction_delete_help() {
  echo "${system_banner} - Transaction Delete"
  echo
  echo "Usage: ${system_basename} transaction delete ARGS"
  echo
  echo "REQUIRED ARGS:"
  echo "--id TRANSACTION_ID"
  echo
  exit 0
}

function transaction_help() {
  echo "${system_banner} - Transactions"
  echo
  echo "Usage: ${system_basename} transaction ACTION [ARGS]"
  echo
  echo "ACTIONS:"
  echo "? add-account-transfer"
  echo "? add-envelope-transfer"
  echo "- add-expense"
  echo "- add-income"
  echo "- delete"
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
    "add-expense")
      shift
      transaction_add_expense "$@"
      ;;
    "add-income")
      shift
      transaction_add_income "$@"
      ;;
    "delete")
      shift
      transaction_delete "$@"
      ;;
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