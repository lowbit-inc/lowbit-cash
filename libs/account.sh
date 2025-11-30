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
  database_silent "INSERT INTO account (name, agroup, type, initial_balance) VALUES ('$this_account_name', '$this_account_group', '$this_account_type', $this_account_initial_balance);"

}

function account_add_help() {
  echo "${system_banner} - Account Add"
  echo
  echo "Usage: ${system_basename} account add ARGS"
  echo
  echo "REQUIRED ARGS:"
  echo "--name ACCOUNT_NAME"
  echo "--group ACCOUNT_GROUP"
  echo "--type $account_type_list"
  echo "--initial-balance INITIAL_BALANCE"
  echo
  exit 0
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
          validate_number "$1" && this_account_id="$1"
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
  database_silent "DELETE FROM account WHERE id = $this_account_id ;"

}

function account_delete_help() {
  echo "${system_banner} - Account Delete"
  echo
  echo "Usage: ${system_basename} account delete ARGS"
  echo
  echo "REQUIRED ARGS:"
  echo "--id ACCOUNT_ID"
  echo
  exit 0
}

function account_edit() {

  if [[ ! "$1" ]]; then
    account_edit_help
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
      "--id")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got account ID: $1"
          validate_number "$1" && this_account_id="$1"
        else
          log_message error "Missing account ID."
        fi
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
  [[ $this_account_id ]] || log_message error "Missing account ID."

  ## Optional args
  [[ $this_account_group ]]           && this_update_query+="agroup = '$this_account_group',"
  [[ $this_account_initial_balance ]] && this_update_query+="initial_balance = '$this_account_initial_balance',"
  [[ $this_account_name ]]            && this_update_query+="name = '$this_account_name',"
  [[ $this_account_type ]]            && this_update_query+="type = '$this_account_type',"

  ## Action
  this_update_query=${this_update_query%?}
  log_message debug "Update query: $this_update_query"
  database_silent "UPDATE account set $this_update_query WHERE id = $this_account_id"
}

function account_edit_help() {
  echo "${system_banner} - Account Edit"
  echo
  echo "Usage: ${system_basename} account edit ARGS"
  echo
  echo "REQUIRED ARGS:"
  echo "--id ACCOUNT_ID"
  echo
  echo "OPTIONAL ARGS:"
  echo "--name ACCOUNT_NAME"
  echo "--group ACCOUNT_GROUP"
  echo "--type $account_type_list"
  echo "--initial-balance INITIAL_BALANCE"
  echo
  exit 0
}

function account_help() {
  echo "${system_banner} - Account"
  echo
  echo "Usage: ${system_basename} account ACTION [ARGS]"
  echo
  echo "ACTIONS:"
  echo "- add"
  echo "- delete"
  echo "- edit"
  echo "- help (this message)"
  echo "? list"
  echo
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
      account_help
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