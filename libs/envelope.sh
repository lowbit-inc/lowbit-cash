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
  printf "  --group ${color_bright_blue}ENVELOPE_GROUP${color_reset}\n"
  printf "  --name ${color_bright_blue}ENVELOPE_NAME${color_reset}\n"
  printf "  --type ${color_bright_blue}income${color_gray}|${color_bright_blue}expense${color_reset}\n"
  printf "  --budget ${color_bright_blue}MONTHLY_BUDGET${color_reset}\n"
  printf "\n"
  exit 0
}

function envelope_budget() {

  # Getting information
  this_budget_income=$(database_silent "SELECT COALESCE(SUM(Budget), 0.00) FROM envelope_view WHERE Type = 'income';")
  this_budget_expense=$(database_silent "SELECT COALESCE(SUM(Budget), 0.00) FROM envelope_view WHERE Type = 'expense';")
  this_budget_difference=$(database_silent "SELECT (SELECT COALESCE(SUM(Budget), 0.00) FROM envelope_view WHERE Type = 'income') - (SELECT COALESCE(SUM(Budget), 0.00) FROM envelope_view WHERE Type = 'expense');")

  # Printing information
  printf "Budgeted Income:  ${color_bright_green}${this_budget_income}${color_reset}\n"
  printf "Budgeted Expense: ${color_bright_red}${this_budget_expense}${color_reset}\n"
  printf "Difference:       ${this_budget_difference}\n"
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
          validate_envelope_id "$1" && this_envelope_id="$1"
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

  # Can't delete envelope ID 1 (reserved envelope)
  if [[ $this_envelope_id -eq 1 ]]; then
    log_message error "It is not possible to delete envelope with ${color_bold}ID 1${color_reset} ${color_gray}(reserved envelope)${color_reset}"
  fi

  # Getting envelope information
  log_message debug "Getting envelope name and group from ID"
  this_envelope_name=$(database_silent "SELECT name FROM envelope WHERE id = ${this_envelope_id};")
  this_envelope_group=$(database_silent "SELECT egroup FROM envelope WHERE id = ${this_envelope_id};")

  # Deleting envelope
  log_message user "Are you sure you want to ${color_bold}delete${color_reset} envelope ${color_bold}${this_envelope_group}:${this_envelope_name}${color_reset} (ID ${this_envelope_id})?"
  database_run "DELETE FROM envelope WHERE id = $this_envelope_id ;"
  database_run_rc=$?
  if [[ $database_run_rc -eq 0 ]]; then
    log_message info "Deleted envelope ${color_bold}${this_envelope_id}${color_reset}"
  else
    log_message error "Failed to delete envelope (${this_envelope_id})"
  fi

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
  this_edit_count=0
  while [[ "$1" ]]; do
    log_message debug "Got arg: $1"
    case "$1" in
      "--budget")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got envelope budget: $1"
          validate_money "$1" && this_envelope_budget="$1"
          ((this_edit_count++))
        else
          log_message error "Missing envelope budget"
        fi
        ;;
      "--group")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got envelope group: $1"
          validate_string "$1" && this_envelope_group="$1"
          ((this_edit_count++))
        else
          log_message error "Missing envelope group"
        fi
        ;;
      "--help")
        log_message debug "Getting help message"
        envelope_edit_help
        ;;
      "--id")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got envelope ID: $1"
          validate_envelope_id "$1" && this_envelope_id="$1"
        else
          log_message error "Missing envelope ID."
        fi
        ;;
      "--name")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got envelope name: $1"
          validate_string "$1" && this_envelope_name="$1"
          ((this_edit_count++))
        else
          log_message error "Missing envelope name."
        fi
        ;;
      "--type")
        shift
        if [[ "$1" ]]; then
          log_message debug "Got envelope type: $1"
          validate_envelope_type "$1" && this_envelope_type="$1"
          ((this_edit_count++))
        else
          log_message error "Missing envelope type."
        fi
        ;;
    esac
    shift
  done

  ## Required args
  [[ $this_envelope_id ]] || log_message error "Missing envelope ID."

  ## Optional args
  [[ $this_envelope_budget ]] && this_update_query+="budget = $this_envelope_budget,"
  [[ $this_envelope_group ]]  && this_update_query+="egroup = '$this_envelope_group',"
  [[ $this_envelope_name ]]   && this_update_query+="name = '$this_envelope_name',"
  [[ $this_envelope_type ]]   && this_update_query+="type = '$this_envelope_type',"

  # Can't edit envelope ID 1 (reserved envelope)
  if [[ $this_envelope_id -eq 1 ]]; then
    log_message error "It is not possible to edit envelope with ${color_bold}ID 1${color_reset} ${color_gray}(reserved envelope)${color_reset}"
  fi

  # Checking if something needs to be changed
  if [[ $this_edit_count -eq 0 ]]; then
    log_message error "At least one optional arg must be passed"
  fi

  ## Action

  this_update_query=${this_update_query%?}
  log_message debug "Update query: $this_update_query"
  database_run "UPDATE envelope set $this_update_query WHERE id = $this_envelope_id"
  if [[ $database_run_rc -eq 0 ]]; then
    # Getting envelope information
    log_message debug "Getting envelope name and group from ID"
    this_envelope_name=$(database_silent "SELECT name FROM envelope WHERE id = ${this_envelope_id};")
    this_envelope_group=$(database_silent "SELECT egroup FROM envelope WHERE id = ${this_envelope_id};")
    log_message info "Edited envelope ${color_bold}${this_envelope_group}:${this_envelope_name}${color_reset}"
  else
    log_message error "Failed to edit envelope (${this_envelope_group}:${this_envelope_name})"
  fi


}

function envelope_edit_help() {
  printf "${color_bold}${system_banner} - Envelope Edit${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${color_bold}${system_basename} envelope edit${color_reset} ${color_bright_green}ARGS${color_reset}\n"
  printf "\n"
  printf "${color_bold}REQUIRED ARGS:${color_reset}\n"
  printf "  --id ${color_bright_blue}ENVELOPE_ID${color_reset}\n"
  printf "\n"
  printf "${color_bold}OPTIONAL ARGS:${color_reset}\n"
  printf "  --group ${color_bright_blue}ENVELOPE_GROUP${color_reset}\n"
  printf "  --name ${color_bright_blue}ENVELOPE_NAME${color_reset}\n"
  printf "  --type ${color_bright_blue}income${color_gray}|${color_bright_blue}expense${color_reset}\n"
  printf "  --budget ${color_bright_blue}MONTHLY_BUDGET${color_reset}\n"
  printf "\n"
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
  this_envelope_balance=$(database_silent "SELECT COALESCE(SUM(Balance), 0.00) FROM envelope_view;")
  this_envelope_unallocated=$(database_silent "SELECT COALESCE(SUM(Balance), 0.00) FROM envelope_view WHERE id = 1;")

  printf "Total balance:"
  if [[ "${this_envelope_balance:0:1}" != "-" ]]; then
    printf "${color_bright_green}"
  else
    printf "${color_bright_red}"
  fi
  printf "    ${color_bold}${this_envelope_balance}${color_reset}\n"
  printf "Unallocated:      ${this_envelope_unallocated}\n"
  printf "\n"
  envelope_budget
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