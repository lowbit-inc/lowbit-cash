#!/bin/bash
system_banner="Lowbit Cash"
system_basename="$(basename $0)"

function system_help() {
  echo "${system_banner} - Help"
  echo
  echo "Usage: ${system_basename} COMMAND [ACTION] [ARGS]"
  echo
  echo "MAIN COMMANDS:"
  echo "- account"
  echo "? envelope"
  echo "? transaction"
  echo "? report"
  echo
  echo "SYSTEM COMMANDS:"
  echo "? help (this message)"
  echo "? install"
  echo "? version"
  echo
  exit 0
}

function system_install() {
  sudo install -b -ls $(pwd)/$(basename $0) /usr/local/bin/cash
}

function system_version() {
  echo "${system_banner} - Version: unknown, sorry"
}