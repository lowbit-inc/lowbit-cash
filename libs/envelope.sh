#!/bin/bash

function envelope_help() {
  echo "${system_banner} - Envelope"
  echo
  echo "  ${system_basename} envelope list"
  echo
  exit 0
}

function envelope_list() {

  database_run "SELECT * FROM envelope_view;"

}

function envelope_main() {
  case $1 in
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