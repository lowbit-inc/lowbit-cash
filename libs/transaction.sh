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
          log_message debug "Got source account 'Group:Name': $1"
          validate_account_group_name "${1}" && this_source_account_group_name="$1"
        else
          log_message error "Missing source account"
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        transaction_add_account_transfer_help
        ;;
      "--to")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got target account 'Group:Name': $1"
          validate_account_group_name "${1}" && this_target_account_group_name="$1"
        else
          log_message error "Missing target account"
        fi
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_source_account_group_name ]] || log_message error "Missing source account ID."
  [[ $this_target_account_group_name ]] || log_message error "Missing target account ID."
  [[ $this_transaction_amount ]]        || log_message error "Missing transaction amount."
  [[ $this_transaction_date ]]          || log_message error "Missing transaction date."
  [[ $this_transaction_description ]]   || log_message error "Missing account description."

  ## Action

  # Getting account IDs
  this_source_account_id=$(account_get_id_from_group_name "${this_source_account_group_name}")
  this_target_account_id=$(account_get_id_from_group_name "${this_target_account_group_name}")

  database_run "INSERT INTO transactions (account_id, amount, date, description) VALUES ($this_source_account_id, -$this_transaction_amount, '$this_transaction_date', '$this_transaction_description');"
  database_run_rc=$?
  if [[ $database_run_rc -eq 0 ]]; then
    log_message info "Added transaction for ${color_bold}${this_source_account_group_name}${color_reset}"
  else
    log_message error "Failed to add transaction for account ${this_source_account_group_name}"
  fi

  database_run "INSERT INTO transactions (account_id, amount, date, description) VALUES ($this_target_account_id, $this_transaction_amount, '$this_transaction_date', '$this_transaction_description');"
  database_run_rc=$?
  if [[ $database_run_rc -eq 0 ]]; then
    log_message info "Added transaction for ${color_bold}${this_target_account_group_name}${color_reset}"
  else
    log_message error "Failed to add transaction for account ${this_target_account_group_name}"
  fi

  account_reconcile_check "${this_source_account_id}"
  account_reconcile_check "${this_target_account_id}"

}

function transaction_add_account_transfer_help() {
  printf "${color_bold}${system_banner} - Transaction Add Account Transfer${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} transaction add-account-transfer${color_reset} ${color_bright_green}ARGS${color_reset}\n"
  printf "\n"
  printf "${color_bold}REQUIRED ARGS:${color_reset}\n"
  printf "  --from ${color_bright_blue}ACCOUNT_GROUP:ACCOUNT_NAME${color_reset}\n"
  printf "  --to ${color_bright_blue}ACCOUNT_GROUP:ACCOUNT_NAME${color_reset}\n"
  printf "  --date ${color_bright_blue}DATE${color_reset}\n"
  printf "  --amount ${color_bright_blue}AMOUNT${color_reset}\n"
  printf "  --description ${color_bright_blue}DESCRIPTION${color_reset}\n"
  printf "\n"
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
          log_message debug "Got source envelope 'Group:Name': $1"
          validate_envelope_group_name "${1}" && this_source_envelope_group_name="$1"
        else
          log_message error "Missing source envelope"
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        transaction_add_envelope_transfer_help
        ;;
      "--to")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got target envelope 'Group:Name': $1"
          validate_envelope_group_name "${1}" && this_target_envelope_group_name="$1"
        else
          log_message error "Missing target envelope"
        fi
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_source_envelope_group_name ]]  || log_message error "Missing source envelope ID."
  [[ $this_target_envelope_group_name ]]  || log_message error "Missing target envelope ID."
  [[ $this_transaction_amount ]]          || log_message error "Missing transaction amount."
  [[ $this_transaction_date ]]            || log_message error "Missing transaction date."
  [[ $this_transaction_description ]]     || log_message error "Missing envelope description."

  ## Action

  # Getting envelope IDs
  this_source_envelope_id=$(envelope_get_id_from_group_name "${this_source_envelope_group_name}")
  this_target_envelope_id=$(envelope_get_id_from_group_name "${this_target_envelope_group_name}")

  database_run "INSERT INTO transactions (envelope_id, amount, date, description) VALUES ($this_source_envelope_id, -$this_transaction_amount, '$this_transaction_date', '$this_transaction_description');"
  database_run_rc=$?
  if [[ $database_run_rc -eq 0 ]]; then
    log_message info "Added transaction for ${color_bold}${this_source_envelope_group_name}${color_reset}"
  else
    log_message error "Failed to add transaction for envelope ${this_source_envelope_group_name}"
  fi

  database_run "INSERT INTO transactions (envelope_id, amount, date, description) VALUES ($this_target_envelope_id, $this_transaction_amount, '$this_transaction_date', '$this_transaction_description');"
  database_run_rc=$?
  if [[ $database_run_rc -eq 0 ]]; then
    log_message info "Added transaction for ${color_bold}${this_target_envelope_group_name}${color_reset}"
  else
    log_message error "Failed to add transaction for envelope ${this_target_envelope_group_name}"
  fi

}

function transaction_add_envelope_transfer_help() {
  printf "${color_bold}${system_banner} - Transaction Add Envelope Transfer${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} transaction add-envelope-transfer${color_reset} ${color_bright_green}ARGS${color_reset}\n"
  printf "\n"
  printf "${color_bold}REQUIRED ARGS:${color_reset}\n"
  printf "  --from ${color_bright_blue}ENVELOPE_GROUP:ENVELOPE_NAME${color_reset}\n"
  printf "  --to ${color_bright_blue}ENVELOPE_GROUP:ENVELOPE_NAME${color_reset}\n"
  printf "  --date ${color_bright_blue}DATE${color_reset}\n"
  printf "  --amount ${color_bright_blue}AMOUNT${color_reset}\n"
  printf "  --description ${color_bright_blue}DESCRIPTION${color_reset}\n"
  printf "\n"
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
          log_message debug "Got transaction account: $1"
          validate_account_group_name "${1}" && this_transaction_account_group_name="$1"
        else
          log_message error "Missing transaction account"
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
          validate_envelope_group_name "${1}" && this_transaction_envelope_group_name="$1"
        else
          log_message error "Missing transaction envelope"
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        transaction_add_envelope_transfer_help
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_transaction_account_group_name ]]  || log_message error "Missing transaction account"
  [[ $this_transaction_amount ]]              || log_message error "Missing transaction amount"
  [[ $this_transaction_date ]]                || log_message error "Missing transaction date"
  [[ $this_transaction_description ]]         || log_message error "Missing transaction description"
  [[ $this_transaction_envelope_group_name ]] || log_message error "Missing transaction envelope"

  ## Action

  # Getting account and envelope IDs
  this_transaction_account_id=$(account_get_id_from_group_name "${this_transaction_account_group_name}")
  this_transaction_envelope_id=$(envelope_get_id_from_group_name "${this_transaction_envelope_group_name}")

  database_run "INSERT INTO transactions (account_id, envelope_id, amount, date, description) VALUES ($this_transaction_account_id, $this_transaction_envelope_id, -$this_transaction_amount, '$this_transaction_date', '$this_transaction_description');"
  database_run_rc=$?
  if [[ $database_run_rc -eq 0 ]]; then
    log_message info "Added expense transaction for ${color_bold}${this_transaction_account_group_name}${color_reset}"
  else
    log_message error "Failed to add expense transaction for envelope ${this_transaction_account_group_name}"
  fi

  account_reconcile_check "${this_transaction_account_id}"

}

function transaction_add_expense_help() {
  printf "${color_bold}${system_banner} - Transaction Add Expense${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} transaction add-expense${color_reset} ${color_bright_green}ARGS${color_reset}\n"
  printf "\n"
  printf "${color_bold}REQUIRED ARGS:${color_reset}\n"
  printf "  --account ${color_bright_blue}ACCOUNT_GROUP:ACCOUNT_NAME${color_reset}\n"
  printf "  --envelope ${color_bright_blue}ENVELOPE_GROUP:ENVELOPE_NAME${color_reset}\n"
  printf "  --date ${color_bright_blue}DATE${color_reset}\n"
  printf "  --amount ${color_bright_blue}AMOUNT${color_reset}\n"
  printf "  --description ${color_bright_blue}DESCRIPTION${color_reset}\n"
  printf "\n"
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
          log_message debug "Got transaction account: $1"
          validate_account_group_name "${1}" && this_transaction_account_group_name="$1"
        else
          log_message error "Missing transaction account"
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
          validate_envelope_group_name "${1}" && this_transaction_envelope_group_name="$1"
        else
          log_message error "Missing transaction envelope"
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        transaction_add_envelope_transfer_help
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_transaction_account_group_name ]]  || log_message error "Missing transaction account"
  [[ $this_transaction_amount ]]              || log_message error "Missing transaction amount"
  [[ $this_transaction_date ]]                || log_message error "Missing transaction date"
  [[ $this_transaction_description ]]         || log_message error "Missing transaction description"
  [[ $this_transaction_envelope_group_name ]] || log_message error "Missing transaction envelope"

  ## Action

  # Getting account and envelope IDs
  this_transaction_account_id=$(account_get_id_from_group_name "${this_transaction_account_group_name}")
  this_transaction_envelope_id=$(envelope_get_id_from_group_name "${this_transaction_envelope_group_name}")

  database_run "INSERT INTO transactions (account_id, envelope_id, amount, date, description) VALUES ($this_transaction_account_id, $this_transaction_envelope_id, $this_transaction_amount, '$this_transaction_date', '$this_transaction_description');"
  database_run_rc=$?
  if [[ $database_run_rc -eq 0 ]]; then
    log_message info "Added income transaction for ${color_bold}${this_transaction_account_group_name}${color_reset}"
  else
    log_message error "Failed to add income transaction for envelope ${this_transaction_account_group_name}"
  fi

  account_reconcile_check "${this_transaction_account_id}"

}

function transaction_add_income_help() {
  printf "${color_bold}${system_banner} - Transaction Add Income${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} transaction add-income${color_reset} ${color_bright_green}ARGS${color_reset}\n"
  printf "\n"
  printf "${color_bold}REQUIRED ARGS:${color_reset}\n"
  printf "  --account ${color_bright_blue}ACCOUNT_GROUP:ACCOUNT_NAME${color_reset}\n"
  printf "  --envelope ${color_bright_blue}ENVELOPE_GROUP:ENVELOPE_NAME${color_reset}\n"
  printf "  --date ${color_bright_blue}DATE${color_reset}\n"
  printf "  --amount ${color_bright_blue}AMOUNT${color_reset}\n"
  printf "  --description ${color_bright_blue}DESCRIPTION${color_reset}\n"
  printf "\n"
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
          validate_transaction_id "$1" && this_transaction_id="$1"
        else
          log_message error "Missing transaction ID"
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
  [[ $this_transaction_id ]] || log_message error "Missing transaction ID"

  ## Action

  # Getting transaction information
  log_message debug "Getting transaction description from ID"
  this_transaction_description=$(database_silent "SELECT description FROM transactions WHERE id = ${this_transaction_id};")

  # Deleting transaction
  log_message user "Are you sure you want to ${color_bold}delete${color_reset} transaction with description ${color_bold}${this_transaction_description}${color_reset} (ID ${this_transaction_id})?"
  database_run "DELETE FROM transactions WHERE id = $this_transaction_id ;"
  database_run_rc=$?
  if [[ $database_run_rc -eq 0 ]]; then
    log_message info "Deleted transaction ${color_bold}${this_transaction_id}${color_reset}"
  else
    log_message error "Failed to delete transaction (${this_transaction_id})"
  fi

}

function transaction_delete_help() {
  printf "${color_bold}${system_banner} - Transaction Delete${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} transaction delete${color_reset} ${color_bright_green}ARGS${color_reset}\n"
  printf "\n"
  printf "${color_bold}REQUIRED ARGS:${color_reset}\n"
  printf "  --id ${color_bright_blue}TRANSACTION_ID${color_reset}\n"
  printf "\n"
  exit 0
}

function transaction_edit() {

  if [[ ! "$1" ]]; then
    transaction_edit_help
  fi

  ## Parsing args
  this_edit_count=0
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
      "--account")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got account ID: $1"
          validate_number "$1" && this_transaction_account_id="$1"
          ((this_edit_count++))
        else
          log_message error "Missing account ID."
        fi
        ;;
      "--amount")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got transaction amount: $1"
          validate_money "$1" && this_transaction_amount="$1"
          ((this_edit_count++))
        else
          log_message error "Missing transaction amount."
        fi
        ;;
      "--date")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got transaction date: $1"
          validate_date "$1" && this_transaction_date="$1"
          ((this_edit_count++))
        else
          log_message error "Missing transaction date."
        fi
        ;;
      "--description")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got transaction description: $1"
          validate_string "$1" && this_transaction_description="$1"
          ((this_edit_count++))
        else
          log_message error "Missing transaction description."
        fi
        ;;
      "--envelope")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got transaction envelope: $1"
          validate_number "$1" && this_transaction_envelope_id="$1"
          ((this_edit_count++))
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

  if [[ $this_edit_count -eq 0 ]]; then
    log_message error "At least one optional arg must be passed"
  fi

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
  database_run "UPDATE transactions set $this_update_query WHERE id = $this_transaction_id"
  if [[ $database_run_rc -eq 0 ]]; then
    # Getting transaction information
    log_message debug "Getting transaction description from ID"
    this_transaction_description=$(database_silent "SELECT description FROM transactions WHERE id = ${this_transaction_id};")
    log_message info "Edited transaction with description ${color_bold}${this_transaction_description}${color_reset} (ID ${this_transaction_id})"
  else
    log_message error "Failed to edit transaction with description ${this_transaction_description} (ID ${this_transaction_id})"
  fi

}

function transaction_edit_help() {
  printf "${color_bold}${system_banner} - Transaction Edit${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage: ${system_basename} transaction edit${color_reset} ${color_bright_green}ARGS${color_reset}\n"
  printf "\n"
  printf "${color_bold}REQUIRED ARGS:${color_reset}\n"
  printf "  --id ${color_bright_blue}TRANSACTION_ID${color_reset}\n"
  printf "\n"
  printf "${color_bold}OPTIONAL ARGS:${color_reset}\n"
  printf "  --account ${color_bright_blue}ACCOUNT_ID${color_reset}\n"
  printf "  --amount ${color_bright_blue}AMOUNT${color_reset}\n"
  printf "  --date ${color_bright_blue}DATE${color_reset}\n"
  printf "  --description ${color_bright_blue}DESCRIPTION${color_reset}\n"
  printf "  --envelope ${color_bright_blue}ENVELOPE_ID${color_reset}\n"
  printf "\n"
  exit 0
}

function transaction_help() {
  printf "${color_bold}${system_banner} - Transactions${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} transaction${color_reset} ${color_bright_green}ACTION${color_reset} ${color_gray}[${color_bright_green}ARGS${color_gray}]${color_reset}\n"
  printf "\n"
  printf "${color_bold}ACTIONS:${color_reset}\n"
  printf "  add-account-transfer\n"
  printf "  add-envelope-transfer\n"
  printf "  add-expense\n"
  printf "  add-income\n"
  printf "  delete\n"
  printf "  edit\n"
  printf "  help                    ${color_gray}(this message)${color_reset}\n"
  printf "  list\n"
  printf "\n"
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
  printf "${color_bold}${system_banner} - Transaction List${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} transaction list${color_reset} ${color_gray}[${color_bright_green}ARGS${color_gray}]${color_reset}\n"
  printf "\n"
  printf "${color_bold}OPTIONAL ARGS:${color_reset}\n"
  printf "  ${color_gray}(soon)${color_reset}\n"
  printf "\n"
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