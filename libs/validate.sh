#!/bin/bash

function validate_account_id() {
  this_account_id="$1"

  # First of all, must be a valid number
  validate_number "${this_account_id}"

  log_message debug "Validating account ID"

  # Checking if it is an actual account ID
  database_return=$(database_silent "SELECT id FROM account WHERE id = ${this_account_id}")
  if [[ "${database_return}" == "${this_account_id}" ]]; then
    log_message debug "Valid account ID"
  else
    log_message error "Invalid account ID ${color_gray}(${this_account_id})${color_reset}"
  fi
}

function validate_account_type() {
  this_account_type="$1"

  log_message debug "Validating account type"

  this_account_type_list="$(echo ${account_type_list} | tr '|' '\n')"
  
  echo "${this_account_type_list}" | grep "^${this_account_type}\$" > /dev/null 2>&1
  grep_rc=$?

  if [[ $grep_rc -eq 0 ]] ; then
    log_message debug "Valid account type"
  else
    log_message error "Invalid account type ${color_gray}(${this_account_type})${color_reset}"
  fi
}

function validate_date() {
  this_date="$1"

  log_message debug "Validating date format"

  if [[ "$this_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    log_message debug "Valid date format"
  else
    log_message error "Invalid date format ${color_gray}($this_date)${color_reset}"
  fi

}

function validate_envelope_type() {
  this_envelope_type="$1"

  log_message debug "Validating envelope type"

  case "${this_envelope_type}" in
    "income")
      log_message debug "Valid envelope type"
      ;;
    "expense")
      log_message debug "Valid envelope type"
      ;;
    *)
      log_message error "Invalid envelope type ${color_gray}(${this_envelope_type})${color_reset}"
      ;;
  esac

}

function validate_money() {
  this_money="$1"

  log_message debug "Validating money format"

  echo "${this_money}" | grep "^.[[:digit:]]*\.[[:digit:]][[:digit:]]$" >/dev/null 2>&1
  grep_rc=$?

  if [[ $grep_rc -eq 0 ]]; then
    log_message debug "Valid money format"
  else
    log_message error "Invalid money format ${color_gray}(${this_money})${color_reset} - String must be in the format '${color_bold}0.00${color_reset}'."
  fi
}

function validate_number() {
  this_number="$1"

  log_message debug "Validating number"

  echo "${this_number}" | grep "^.[[:digit:]]*$" >/dev/null 2>&1
  grep_rc=$?

  if [[ $grep_rc -eq 0 ]]; then
    log_message debug "Valid number"
  else
    log_message error "Invalid number ${color_gray}(${this_number})${color_reset}"
  fi

}

function validate_string() {
  log_message debug "Validating string"
  log_message debug "(Validation stil not implemented - skipping)"  
}