#!/bin/bash

account_type_list="bank|creditcard|investment|money"

function account_add() {

  if [[ ! "$1" ]]; then
    account_add_help
  fi

  ## Parsing args
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
      "--group")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got account group: $1"
          validate_string "$1" && this_account_group="$1"
        else
          log_message error "Missing account group."
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        account_add_help
        ;;
      "--initial-balance")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got initial balance: $1"
          validate_money "$1" && this_account_initial_balance="$1"
        else
          log_message error "Missing initial balance."
        fi
        ;;
      "--name")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got account name: $1"
          validate_string "$1" && this_account_name="$1"
        else
          log_message error "Missing account name."
        fi
        ;;
      "--type")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got account type: $1"
          validate_account_type "$1" && this_account_type="$1"
        else
          log_message error "Missing account type."
        fi
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_account_name ]]            || log_message error "Missing account name."
  [[ $this_account_group ]]           || log_message error "Missing account group."
  [[ $this_account_type ]]            || log_message error "Missing account type."
  [[ $this_account_initial_balance ]] || log_message error "Missing account initial balance."

  ## Action
  # Adding the account
  database_run "INSERT INTO account (name, agroup, type) VALUES ('$this_account_name', '$this_account_group', '$this_account_type');"
  database_run_rc=$?
  if [[ $database_run_rc -eq 0 ]]; then
    log_message info "Added account ${color_bold}${this_account_group}:${this_account_name}${color_reset}"
  else
    log_message error "Failed to add account (${this_account_group}:${this_account_name})"
  fi

  # Getting account ID
  this_account_id=$(database_silent "SELECT id FROM account WHERE name = '${this_account_name}' AND agroup = '${this_account_group}'")

  # Adding opening balance transaction
  database_run "INSERT INTO transactions (account_id, envelope_id, date, amount, description) VALUES (${this_account_id}, 1, DATE('now', 'localtime'), ${this_account_initial_balance}, 'Opening balance');"
  database_run_rc=$?
  if [[ $database_run_rc -eq 0 ]]; then
    log_message info "Added Opening Balance transaction for account ${color_bold}${this_account_group}:${this_account_name}${color_reset}"
  else
    log_message error "Failed to add transaction for account (${this_account_group}:${this_account_name})"
  fi

}

function account_add_help() {
  printf "${color_bold}${system_banner} - Account Add${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} account add${color_reset} ${color_bright_green}ARGS${color_reset}\n"
  printf "\n"
  printf "${color_bold}REQUIRED ARGS:${color_reset}\n"
  printf "  --name ${color_bright_blue}ACCOUNT_NAME${color_reset}\n"
  printf "  --group ${color_bright_blue}ACCOUNT_GROUP${color_reset}\n"
  printf "  --type ${color_bright_blue}bank${color_gray}|${color_bright_blue}creditcard${color_gray}|${color_bright_blue}investment${color_gray}|${color_bright_blue}money${color_reset}\n"
  printf "  --initial-balance ${color_bright_blue}INITIAL_BALANCE${color_reset}\n"
  printf "\n"
  exit 0
}

function account_balance() {

  this_account_balance=$(database_silent "SELECT COALESCE(SUM(Balance), 0.00) FROM account_view;")

  printf "Total balance:"
  if [[ "${this_account_balance:0:1}" != "-" ]]; then
    printf "${color_bright_green}"
  else
    printf "${color_bright_red}"
  fi
  printf " ${color_bold}${this_account_balance}${color_reset}\n"

}

function account_delete() {

  if [[ ! "$1" ]]; then
    account_delete_help
  fi

  ## Parsing args
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
      "--id")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got account ID: $1"
          validate_account_id "$1" && this_account_id="$1"
        else
          log_message error "Missing account ID."
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        account_delete_help
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_account_id ]] || log_message error "Missing account ID."

  ## Action

  # Getting account information
  log_message debug "Getting account name and group from ID"
  this_account_name=$(database_silent "SELECT name FROM account WHERE id = ${this_account_id};")
  this_account_group=$(database_silent "SELECT agroup FROM account WHERE id = ${this_account_id};")

  # Deleting account
  log_message user "Are you sure you want to ${color_bold}delete${color_reset} account ${color_bold}${this_account_group}:${this_account_name}${color_reset} (ID ${this_account_id})?"
  database_run "DELETE FROM account WHERE id = $this_account_id ;"
  database_run_rc=$?
  if [[ $database_run_rc -eq 0 ]]; then
    log_message info "Deleted account ${color_bold}${this_account_id}${color_reset}"
  else
    log_message error "Failed to delete account (${this_account_id})"
  fi

  # Deleting transactions
  database_run "DELETE FROM transactions WHERE account_id = $this_account_id ;"
  database_run_rc=$?
  if [[ $database_run_rc -eq 0 ]]; then
    log_message info "Deleted transactions for account ${color_bold}${this_account_id}${color_reset}"
  else
    log_message error "Failed to delete account transactions (${this_account_id})"
  fi

}

function account_delete_help() {
  printf "${color_bold}${system_banner} - Account Delete${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} account delete${color_reset} ${color_bright_green}ARGS${color_reset}\n"
  printf "\n"
  printf "${color_bold}REQUIRED ARGS:${color_reset}\n"
  printf "  --id ${color_bright_blue}ACCOUNT_ID${color_reset}\n"
  printf "\n"
  exit 0
}

function account_edit() {

  if [[ ! "$1" ]]; then
    account_edit_help
  fi

  ## Parsing args
  this_edit_count=0
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
      "--group")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got account group: $1"
          validate_string "$1" && this_account_group="$1"
          ((this_edit_count++))
        else
          log_message error "Missing account group."
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        account_edit_help
        ;;
      "--id")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got account ID: $1"
          validate_account_id "$1" && this_account_id="$1"
        else
          log_message error "Missing account ID."
        fi
        ;;
      "--name")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got account name: $1"
          validate_string "$1" && this_account_name="$1"
          ((this_edit_count++))
        else
          log_message error "Missing account name."
        fi
        ;;
      "--type")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got account type: $1"
          validate_account_type "$1" && this_account_type="$1"
          ((this_edit_count++))
        else
          log_message error "Missing account type."
        fi
        ;;
    esac
    shift
  done

  if [[ $this_edit_count -eq 0 ]]; then
    log_message error "At least one optional arg must be passed"
  fi

  ## Required args
  [[ $this_account_id ]] || log_message error "Missing account ID."

  ## Optional args
  [[ $this_account_group ]] && this_update_query+="agroup = '$this_account_group',"
  [[ $this_account_name ]]  && this_update_query+="name = '$this_account_name',"
  [[ $this_account_type ]]  && this_update_query+="type = '$this_account_type',"

  ## Action

  this_update_query=${this_update_query%?}
  log_message debug "Update query: $this_update_query"
  database_run "UPDATE account set $this_update_query WHERE id = $this_account_id"
  if [[ $database_run_rc -eq 0 ]]; then
    # Getting account information
    log_message debug "Getting account name and group from ID"
    this_account_name=$(database_silent "SELECT name FROM account WHERE id = ${this_account_id};")
    this_account_group=$(database_silent "SELECT agroup FROM account WHERE id = ${this_account_id};")
    log_message info "Edited account ${color_bold}${this_account_group}:${this_account_name}${color_reset}"
  else
    log_message error "Failed to edit account (${this_account_group}:${this_account_name})"
  fi

}

function account_edit_help() {
  printf "${color_bold}${system_banner} - Account Edit${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} account edit${color_reset} ${color_bright_green}ARGS${color_reset}\n"
  printf "\n"
  printf "${color_bold}REQUIRED ARGS:${color_reset}\n"
  printf "  --id ${color_bright_blue}ACCOUNT_ID${color_reset}\n"
  printf "\n"
  printf "${color_bold}OPTIONAL ARGS:${color_reset}\n"
  printf "  --name ${color_bright_blue}ACCOUNT_NAME${color_reset}\n"
  printf "  --group ${color_bright_blue}ACCOUNT_GROUP${color_reset}\n"
  printf "  --type ${color_bright_blue}bank${color_gray}|${color_bright_blue}creditcard${color_gray}|${color_bright_blue}investment${color_gray}|${color_bright_blue}money${color_reset}\n"
  printf "\n"
  exit 0
}

function account_help() {
  printf "${color_bold}${system_banner} - Account\n${color_reset}"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} account${color_reset} ${color_bright_green}ACTION${color_reset} ${color_gray}[${color_reset}${color_bright_green}ARGS${color_reset}${color_gray}]${color_reset}\n"
  printf "\n"
  printf "${color_bold}ACTIONS:${color_reset}\n"
  printf "  add\n"
  printf "  delete\n"
  printf "  edit\n"
  printf "  help    ${color_gray}(this message)${color_reset}\n"
  printf "  list\n"
  printf "\n"
  exit 0
}

function account_list() {

  ## Parsing args
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
      "--help")
        log_message debug "Getting help message"
        account_list_help
        ;;
    esac
    shift
  done

  ## Optional args
  # soon

  ## Action
  database_run "SELECT * FROM account_view;"
  account_balance

}

function account_list_help() {
  echo "${system_banner} - Account List"
  echo
  echo "Usage: ${system_basename} account list [ARGS]"
  echo
  echo "OPTIONAL ARGS:"
  echo "(soon)"
  echo
  exit 0
}

function account_main() {
  case $1 in
    "add")
      shift
      account_add "$@"
      ;;
    "delete")
      shift
      account_delete "$@"
      ;;
    "edit")
      shift
      account_edit "$@"
      ;;
    "help")
      account_help "$@"
      ;;
    "list")
      shift
      account_list "$@"
      ;;
    *)
      account_help
      ;;
  esac
}