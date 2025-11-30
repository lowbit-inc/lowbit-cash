#!/bin/bash

function envelope_add() {

  # Parsing args
  while [[ "$1" ]]; do
    case "$1" in
      "--name")
        ;;
      "--help")
        envelope_add_help
        ;;
      *)
        ;;
    esac
  done
  # Required args
  # Action

  echo "testing..."

}

function envelope_add_help() {
  echo "${system_banner} - Envelope Add"
  echo
  echo "Usage:"
  exit 0
}

function envelope_edit() {

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


function envelope_help() {
  echo "${system_banner} - Envelope"
  echo
  echo "Usage: ${system_basename} envelope ACTION"
  echo
  echo "ACTIONs:"
  echo " ? add"
  echo " ? delete"
  echo " ? edit"
  echo " - help (this message)"
  echo " - list"
  echo
  exit 0
}

function envelope_list() {

  database_run "SELECT * FROM envelope_view;"

}

function envelope_main() {
  case $1 in
    "add")
      shift
      envelope_add "$@"
      ;;
    "help")
      envelope_help
      ;;
    "list")
      envelope_list
      ;;
    *)
      envelope_help
      ;;
  esac
}