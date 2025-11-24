#!/bin/bash
system_banner="Lowbit Cash"
system_basename="$(basename $0)"

function system_help() {
  echo "${system_banner} - Usage:"
  echo
  echo "  ${system_basename} COMMAND ARGS"
  echo
  echo "Cash commands:"
  echo "  account"
  echo "  envelope"
  echo "  transaction"
  echo "  report"
  echo
  echo "System commands:"
  echo "  help (this message)"
  echo "  install"
  echo "  version"
  echo
  exit 0
}

function system_install() {
  sudo install -b -ls $(pwd)/$(basename $0) /usr/local/bin/cash
}

function system_version() {
  echo "${system_banner} - Version: unknown, sorry"
}