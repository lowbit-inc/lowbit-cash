#!/bin/bash

function transaction_add_account_transfer() {

  if [[ ! "$1" ]]; then
    transaction_add_account_transfer_help
  fi

  ## Parsing args
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
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
      "--from")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got source account ID: $1"
          validate_number "$1" && this_transaction_from="$1"
        else
          log_message error "Missing source account ID."
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        transaction_add_account_transfer_help
        ;;
      "--to")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got target account ID: $1"
          validate_number "$1" && this_transaction_to="$1"
        else
          log_message error "Missing target account ID."
        fi
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_transaction_amount ]]      || log_message error "Missing transaction amount."
  [[ $this_transaction_date ]]        || log_message error "Missing transaction date."
  [[ $this_transaction_description ]] || log_message error "Missing account description."
  [[ $this_transaction_from ]]        || log_message error "Missing source account ID."
  [[ $this_transaction_to ]]          || log_message error "Missing target account ID."

  ## Action
  database_silent "INSERT INTO transactions (account_id, amount, date, description) VALUES ($this_transaction_from, -$this_transaction_amount, '$this_transaction_date', '$this_transaction_description');"
  database_silent "INSERT INTO transactions (account_id, amount, date, description) VALUES ($this_transaction_to, $this_transaction_amount, '$this_transaction_date', '$this_transaction_description');"

}

function transaction_add_account_transfer_help() {
  echo "${system_banner} - Transaction Add Account Transfer"
  echo
  echo "Usage: ${system_basename} transaction add-account-transfer ARGS"
  echo
  echo "REQUIRED ARGS:"
  echo "--from SOURCE_ACCOUNT_ID"
  echo "--to TARGET_ACCOUNT_ID"
  echo "--date DATE"
  echo "--amount AMOUNT"
  echo "--description DESCRIPTION"
  echo
  exit 0
}

function transaction_add_envelope_transfer() {

  if [[ ! "$1" ]]; then
    transaction_add_envelope_transfer_help
  fi

  ## Parsing args
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
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
      "--from")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got source envelope ID: $1"
          validate_number "$1" && this_transaction_from="$1"
        else
          log_message error "Missing source envelope ID."
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        transaction_add_account_transfer_help
        ;;
      "--to")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got target envelope ID: $1"
          validate_number "$1" && this_transaction_to="$1"
        else
          log_message error "Missing target envelope ID."
        fi
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_transaction_amount ]]      || log_message error "Missing transaction amount."
  [[ $this_transaction_date ]]        || log_message error "Missing transaction date."
  [[ $this_transaction_description ]] || log_message error "Missing transaction description."
  [[ $this_transaction_from ]]        || log_message error "Missing source envelope ID."
  [[ $this_transaction_to ]]          || log_message error "Missing target envelope ID."

  ## Action
  database_silent "INSERT INTO transactions (envelope_id, amount, date, description) VALUES ($this_transaction_from, -$this_transaction_amount, '$this_transaction_date', '$this_transaction_description');"
  database_silent "INSERT INTO transactions (envelope_id, amount, date, description) VALUES ($this_transaction_to, $this_transaction_amount, '$this_transaction_date', '$this_transaction_description');"

}

function transaction_add_envelope_transfer_help() {
  echo "${system_banner} - Transaction Add Envelope Transfer"
  echo
  echo "Usage: ${system_basename} transaction add-envelope-transfer ARGS"
  echo
  echo "REQUIRED ARGS:"
  echo "--from SOURCE_ENVELOPE_ID"
  echo "--to TARGET_ENVELOPE_ID"
  echo "--date DATE"
  echo "--amount AMOUNT"
  echo "--description DESCRIPTION"
  echo
  exit 0
}

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
  [[ $this_transaction_description ]] || log_message error "Missing transaction description."
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
        transaction_add_income_help
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_transaction_account_id ]]  || log_message error "Missing account ID."
  [[ $this_transaction_envelope_id ]] || log_message error "Missing envelope ID."
  [[ $this_transaction_amount ]]      || log_message error "Missing transaction amount."
  [[ $this_transaction_date ]]        || log_message error "Missing transaction date."
  [[ $this_transaction_description ]] || log_message error "Missing account description."

  ## Action
  database_silent "INSERT INTO transactions (account_id, envelope_id, amount, date, description) VALUES ($this_transaction_account_id, $this_transaction_envelope_id, $this_transaction_amount, '$this_transaction_date', '$this_transaction_description');"

}

function transaction_add_income_help() {
  echo "${system_banner} - Transaction Add Income"
  echo
  echo "Usage: ${system_basename} transaction add-income ARGS"
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

function transaction_edit() {

  if [[ ! "$1" ]]; then
    transaction_edit_help
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
          log_message debug "Got transaction envelope: $1"
          validate_number "$1" && this_transaction_envelope_id="$1"
        else
          log_message error "Missing transaction envelope ID."
        fi
        ;;
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
        transaction_edit_help
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_transaction_id ]] || log_message error "Missing transaction ID."

  ## Optional args
  [[ $this_transaction_account_id ]]  && this_update_query+="account_id = '$this_transaction_account_id',"
  [[ $this_transaction_amount ]]      && this_update_query+="amount = '$this_transaction_amount',"
  [[ $this_transaction_date ]]        && this_update_query+="date = '$this_transaction_date',"
  [[ $this_transaction_description ]] && this_update_query+="description = '$this_transaction_description',"
  [[ $this_transaction_envelope_id ]] && this_update_query+="envelope_id = '$this_transaction_envelope_id',"

  ## Action
  this_update_query=${this_update_query%?}
  log_message debug "Update query: $this_update_query"
  database_silent "UPDATE transactions set $this_update_query WHERE id = $this_transaction_id"
}

function transaction_edit_help() {
  echo "${system_banner} - Transaction Edit"
  echo
  echo "Usage: ${system_basename} transaction edit ARGS"
  echo
  echo "REQUIRED ARGS:"
  echo "--id TRANSACTION_ID"
  echo
  echo "OPTIONAL ARGS:"
  echo "--account ACCOUNT_ID"
  echo "--amount AMOUNT"
  echo "--date DATE"
  echo "--description DESCRIPTION"
  echo "--envelope ENVELOPE_ID"
  echo
  exit 0
}

function transaction_help() {
  echo "${system_banner} - Transactions"
  echo
  echo "Usage: ${system_basename} transaction ACTION [ARGS]"
  echo
  echo "ACTIONS:"
  echo "- add-account-transfer"
  echo "- add-envelope-transfer"
  echo "- add-expense"
  echo "- add-income"
  echo "- delete"
  echo "- edit"
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
    "add-account-transfer")
      shift
      transaction_add_account_transfer "$@"
      ;;
    "add-envelope-transfer")
      shift
      transaction_add_envelope_transfer "$@"
      ;;
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
    "edit")
      shift
      transaction_edit "$@"
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