#!/bin/zsh
system_banner="Lowbit Cash"
system_basename="$(basename $0)"

function system_help() {
  printf "${color_bold}${system_banner} - Help${color_reset}\n"
  printf "\n"
  printf "${color_underline}Usage:${color_reset} ${system_basename} ${color_bright_red}COMMAND${color_reset} ${color_gray}[${color_reset}${color_bright_green}ACTION${color_reset}${color_gray}]${color_reset} ${color_gray}[${color_reset}${color_bright_blue}ARGS${color_reset}${color_gray}]${color_reset}\n"
  printf "\n"
  printf "${color_bold}MAIN COMMANDS:${color_reset}\n"
  printf "  account\n"
  printf "  balance\n"
  printf "  envelope\n"
  printf "  transaction\n"
  printf "  report\n"
  printf "\n"
  printf "${color_bold}SYSTEM COMMANDS:${color_reset}\n"
  printf "  help      ${color_gray}(this message)${color_reset}\n"
  printf "  install\n"
  printf "  version\n"
  printf "\n"
  exit 0
}

function system_install() {
  sudo install -b -ls $(pwd)/$(basename $0) /usr/local/bin/cash
}

function system_version() {
  echo "${system_banner} - Version: unknown, sorry"
}