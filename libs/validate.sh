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
    log_message error "Invalid account ID (${this_account_id})"
  fi
}

function validate_account_type() {
  this_account_type="$1"

  this_account_type_list="$(echo ${account_type_list} | tr '|' '\n')"
  
  echo "${this_account_type_list}" | grep "^${this_account_type}\$" > /dev/null 2>&1
  grep_rc=$?

  if [[ $grep_rc -ne 0 ]] ; then
    echo "Error: invalid account type"
    exit 1
  fi
}

function validate_date() {
  this_date="$1"

  if [[ "$this_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    log_message debug "Validate - Date: $this_date is a valid date."
  else
    log_message error "Invalid date ($this_date)."
  fi

}

function validate_envelope_type() {
  this_envelope_type="$1"

  log_message debug "Validating envelope type: ${this_envelope_type}"

  case "${this_envelope_type}" in
    "income")
      log_message debug "  OK"
      ;;
    "expense")
      log_message debug "  OK"
      ;;
    *)
      log_message error "Unknown envelope type (${this_envelope_type})"
      ;;
  esac

}

function validate_money() {
  this_money="$1"

  echo "${this_money}" | grep "^.[[:digit:]]*\.[[:digit:]][[:digit:]]$" >/dev/null 2>&1
  grep_rc=$?

  if [[ $grep_rc -ne 0 ]]; then
    echo "Error: invalid money format. String must be in the format '0.00'."
    exit 1
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
    log_message error "Invalid number format"
  fi

}

function validate_string() {
  true
}