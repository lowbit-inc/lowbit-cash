#!/bin/bash

function envelope_add() {

  if [[ ! "$1" ]]; then
    envelope_add_help
  fi

  ## Parsing args
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
      "--budget")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got envelope budget: $1"
          validate_money "$1" && this_envelope_budget="$1"
        else
          log_message error "Missing envelope budget."
        fi
        ;;
      "--group")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got envelope group: $1"
          validate_string "$1" && this_envelope_group="$1"
        else
          log_message error "Missing envelope group."
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        envelope_add_help
        ;;
      "--name")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got envelope name: $1"
          validate_string "$1" && this_envelope_name="$1"
        else
          log_message error "Missing envelope name."
        fi
        ;;
      "--type")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got envelope type: $1"
          validate_envelope_type "$1" && this_envelope_type="$1"
        else
          log_message error "Missing envelope type."
        fi
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_envelope_name ]]   || log_message error "Missing envelope name."
  [[ $this_envelope_group ]]  || log_message error "Missing envelope group."
  [[ $this_envelope_type ]]   || log_message error "Missing envelope type."
  [[ $this_envelope_budget ]] || log_message error "Missing envelope budget."

  ## Action
  database_run "INSERT INTO envelope (name, egroup, type, budget) VALUES ('$this_envelope_name', '${this_envelope_group}', '${this_envelope_type}', $this_envelope_budget);"
  database_run_rc=$?
  if [[ $database_run_rc -eq 0 ]]; then
    log_message info "Added envelope ${color_bold}${this_envelope_group}:${this_envelope_name}${color_reset}"
  else
    log_message error "Failed to add envelope (${this_envelope_group}:${this_envelope_name})"
  fi


}

function envelope_add_help() {
  printf "${color_bold}${system_banner} - Envelope Add${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} envelope add${color_reset} ${color_bright_green}ARGS${color_reset}\n"
  printf "\n"
  printf "${color_bold}REQUIRED ARGS:${color_reset}\n"
  printf "  --name ${color_bright_blue}ENVELOPE_NAME${color_reset}\n"
  printf "  --group ${color_bright_blue}ENVELOPE_GROUP${color_reset}\n"
  printf "  --type ${color_bright_blue}income${color_gray}|${color_bright_blue}expense${color_reset}\n"
  printf "  --budget ${color_bright_blue}MONTHLY_BUDGET${color_reset}\n"
  printf "\n"
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

function envelope_delete() {

  if [[ ! "$1" ]]; then
    envelope_delete_help
  fi

  ## Parsing args
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
      "--id")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got envelope ID: $1"
          validate_number "$1" && this_envelope_id="$1"
        else
          log_message error "Missing envelope ID."
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        envelope_delete_help
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_envelope_id ]] || log_message error "Missing envelope ID."

  ## Action
  database_silent "DELETE FROM envelope WHERE id = $this_envelope_id;"

}

function envelope_delete_help() {
  printf "${color_bold}${system_banner} - Envelope Delete${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} envelope delete${color_reset} ${color_bright_green}ARGS${color_reset}\n"
  printf "\n"
  printf "${color_bold}REQUIRED ARGS:${color_reset}\n"
  printf "  --id ${color_bright_blue}ENVELOPE_ID${color_reset}\n"
  printf "\n"
  exit 0
}

function envelope_edit() {

  if [[ ! "$1" ]]; then
    envelope_edit_help
  fi

  ## Parsing args
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
      "--budget")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got envelope budget: $1"
          validate_money "$1" && this_envelope_budget="$1"
        else
          log_message error "Missing envelope budget."
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        envelope_add_help
        ;;
      "--id")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got envelope ID: $1"
          validate_number "$1" && this_envelope_id="$1"
        else
          log_message error "Missing envelope ID."
        fi
        ;;
      "--name")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got envelope name: $1"
          validate_string "$1" && this_envelope_name="$1"
        else
          log_message error "Missing envelope name."
        fi
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_envelope_id ]] || log_message error "Missing envelope ID."

  ## Optional args
  [[ $this_envelope_budget ]] && this_update_query+="budget = '$this_envelope_budget',"
  [[ $this_envelope_name ]]   && this_update_query+="name = '$this_envelope_name',"

  ## Action
  this_update_query=${this_update_query%?}
  log_message debug "Update query: $this_update_query"
  database_silent "UPDATE envelope set $this_update_query WHERE id = $this_envelope_id"
}

function envelope_edit_help() {
  echo "${system_banner} - Envelope Edit"
  echo
  echo "Usage: ${system_basename} envelope edit ARGS"
  echo
  echo "REQUIRED ARGS:"
  echo "--id ENVELOPE_ID"
  echo
  echo "OPTIONAL ARGS:"
  echo "--name ENVELOPE_NAME"
  echo "--budget MONTHLY_BUDGET"
  echo
  exit 0
}

function envelope_help() {
  printf "${color_bold}${system_banner} - Envelope${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} envelope${color_reset} ${color_bright_green}ACTION${color_reset}\n"
  printf "\n"
  printf "${color_bold}ACTIONs:${color_reset}\n"
  printf "  add\n"
  printf "  delete\n"
  printf "  edit\n"
  printf "  help    ${color_gray}(this message)${color_reset}\n"
  printf "  list\n"
  printf "\n"
  exit 0
}

function envelope_list() {

  ## Parsing args
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
      "--help")
        log_message debug "Getting help message"
        envelope_list_help
        ;;
    esac
    shift
  done

  ## Optional args
  # soon

  ## Action
  database_run "SELECT * FROM envelope_view;"

  printf "Total balance:     ${color_bold}"
    database_silent "SELECT COALESCE(SUM(Balance), 0.00) FROM envelope_view"
    printf "${color_reset}\n"
  printf "Budget - Income:   ${color_bold}"
    database_silent "SELECT COALESCE(SUM(Budget), 0.00) FROM envelope_view WHERE Type = 'income';"
    printf "${color_reset}"
  printf "Budget - Expense:  ${color_bold}"
    database_silent "SELECT COALESCE(SUM(Budget), 0.00) FROM envelope_view WHERE Type = 'expense';"
    printf "${color_reset}"
}

function envelope_list_help() {
  echo "${system_banner} - Envelope List"
  echo
  echo "Usage: ${system_basename} envelope list [ARGS]"
  echo
  echo "OPTIONAL ARGS:"
  echo "(soon)"
  echo
  exit 0
}

function envelope_main() {
  case $1 in
    "add")
      shift
      envelope_add "$@"
      ;;
    "delete")
      shift
      envelope_delete "$@"
      ;;
    "edit")
      shift
      envelope_edit "$@"
      ;;
    "help")
      envelope_help
      ;;
    "list")
      shift
      envelope_list "$@"
      ;;
    *)
      envelope_help
      ;;
  esac
}