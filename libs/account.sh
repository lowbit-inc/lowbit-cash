#!/bin/bash

account_type_list="bank investment"

function accountAdd() {
  if [[ $4 ]]; then
    validate_string       "$1" && this_account_name="$1"
    validate_string       "$2" && this_account_group="$2"
    validate_account_type "$3" && this_account_type="$3"
    validate_money        "$4" && this_account_initial_balance="$4"
  else
    echo "Error: missing required args"
    exit 1
  fi

  database_run "INSERT INTO account (name, agroup, type, initial_balance) VALUES ('$this_account_name', '$this_account_group', '$this_account_type', $this_account_initial_balance);"

}

function accountDelete() {
  if [[ $1 ]]; then
    validate_number "$1" && this_account_id="$1"
  else
    echo "Error: missing account ID."
    exit 1
  fi

  database_run "DELETE FROM account WHERE id = $this_account_id ;"
}

function accountEdit() {

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

function accountHelp() {
  echo "${system_banner} - Account"
  echo "  ${system_basename} account add ACCOUNT_NAME ACCOUNT_GROUP ACCOUNT_TYPE INITIAL_BALANCE"
  echo "  ${system_basename} account delete ACCOUNT_ID"
  echo "  ${system_basename} account edit ACCOUNT_ID [--name NEW_ACCOUNT_NAME] [--group NEW_ACCOUNT_GROUP] [--type NEW_ACCOUNT_TYPE] [--initial-balance NEW_INITIAL_BALANCE]"
  echo "  ${system_basename} account help (this message)"
  echo "  ${system_basename} account list"
  echo
  echo "Account Types:"
  echo "  bank"
  echo "  investment"
  echo
  exit 0
}

function accountList() {

  database_run "SELECT * FROM account ORDER BY type ASC, agroup ASC, name ASC;"


}

function accountMain() {
  case $1 in
    "add")
      shift
      accountAdd "$@"
      ;;
    "delete")
      shift
      accountDelete "$@"
      ;;
    "edit")
      shift
      accountEdit "$@"
      ;;
    "help")
      accountHelp
      ;;
    "list")
      accountList
      ;;
    *)
      accountHelp
      ;;
  esac
}