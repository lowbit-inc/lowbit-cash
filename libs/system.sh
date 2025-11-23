#!/bin/bash
system_banner="Lowbit Cash"
system_basename="$(basename $0)"

function system_help() {
  echo "${system_banner} - Usage:"
  echo "  ${system_basename} COMMAND ARGS"
  echo
  echo "Commands:"
  echo "  account"
  echo "  envelope"
  echo "  help (this message)"
  echo "  install"
  echo "  report"
  echo "  transaction"
  echo "  version"
  echo
  exit 0
}

function system_version() {
  echo "${system_banner} - Version: unknown, sorry"
}