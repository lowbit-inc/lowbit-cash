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

function accountHelp() {
  echo "${system_banner} - Account"
  echo "  ${system_basename} add ACCOUNT_NAME ACCOUNT_GROUP ACCOUNT_TYPE INITIAL_BALANCE"
  echo "  ${system_basename} delete ACCOUNT_ID"
  echo "  ${system_basename} edit ACCOUNT_ID [--name NEW_ACCOUNT_NAME] [--group NEW_ACCOUNT_GROUP] [--type NEW_ACCOUNT_TYPE] [--initial-balance NEW_INITIAL_BALANCE]"
  echo "  ${system_basename} help (this message)"
  echo "  ${system_basename} list"
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