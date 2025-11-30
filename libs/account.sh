#!/bin/bash

account_type_list="bank investment"

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
      *)
        log_message debug "Getting help message"
        account_add_help
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
  echo "Usage: ${system_basename} account add [ARGS]"
  echo
  echo "REQUIRED ARGS:"
  echo "--name ACCOUNT_NAME"
  echo "--group ACCOUNT_GROUP"
  echo "--type bank|investment"
  echo "--initial-balance INITIAL_BALANCE"
  echo
  exit 0
}

function account_delete() {
  if [[ $1 ]]; then
    validate_number "$1" && this_account_id="$1"
  else
    echo "Error: missing account ID."
    exit 1
  fi

  database_run "DELETE FROM account WHERE id = $this_account_id ;"
}

function account_edit() {

  unset $this_update_query

  if [[ $1 ]]; then
    validate_number "$1" && this_account_id="$1"
    shift
  else
    echo "Error: missing account ID."
    exit 1
  fi

  # Parsing args
  while [[ "$1" ]]; do

    case "$1" in
      "--name")
        shift
        if [[ "$1" ]]; then
          validate_string "$1" && this_account_name="$1"
        else
          echo "Error: missing new account name."
          exit 1
        fi

        if [[ $this_update_query ]]; then
          this_update_query+=" , "
        fi

        this_update_query+="name = '$this_account_name'"

        ;;
      "--group")
        shift
        if [[ "$1" ]]; then
          validate_string "$1" && this_account_group="$1"
        else
          echo "Error: missing new account group."
          exit 1
        fi

        if [[ $this_update_query ]]; then
          this_update_query+=" , "
        fi

        this_update_query+="agroup = '$this_account_group'"

        ;;
      "--type")
        shift
        if [[ "$1" ]]; then
          validate_account_type "$1" && this_account_type="$1"
        else
          echo "Error: missing new account type."
          exit 1
        fi

        if [[ $this_update_query ]]; then
          this_update_query+=" , "
        fi

        this_update_query+="type = '$this_account_type'"

        ;;
      "--initial-balance")
        shift
        if [[ "$1" ]]; then
          validate_money "$1" && this_account_initial_balance="$1"
        else
          echo "Error: missing new account initial balance."
          exit 1
        fi

        if [[ $this_update_query ]]; then
          this_update_query+=" , "
        fi

        this_update_query+="initial_balance = '$this_account_initial_balance'"

        ;;
    esac

    shift
  done

  database_silent "UPDATE account set $this_update_query WHERE id = $this_account_id"

}

function account_help() {
  echo "${system_banner} - Account"
  echo
  echo "Usage: ${system_basename} account ACTION [ARGS]"
  echo
  echo "ACTIONS:"
  echo "- add"
  echo "? delete"
  echo "? edit"
  echo "? help"
  echo "? list"
  echo
  # echo "  ${system_basename} account add ACCOUNT_NAME ACCOUNT_GROUP ACCOUNT_TYPE INITIAL_BALANCE"
  # echo "  ${system_basename} account delete ACCOUNT_ID"
  # echo "  ${system_basename} account edit ACCOUNT_ID [--name NEW_ACCOUNT_NAME] [--group NEW_ACCOUNT_GROUP] [--type NEW_ACCOUNT_TYPE] [--initial-balance NEW_INITIAL_BALANCE]"
  # echo "  ${system_basename} account help (this message)"
  # echo "  ${system_basename} account list"
  # echo
  # echo "Account Types:"
  # echo "  bank"
  # echo "  investment"
  # echo
  exit 0
}

function account_list() {

  database_run "SELECT * FROM account_view;"

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
      account_list "$@"
      ;;
    *)
      account_help
      ;;
  esac
}