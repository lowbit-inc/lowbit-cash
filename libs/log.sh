#!/bin/bash

function log_message() {
  if [[ "$2" ]]; then
    this_log_level="$1"
    this_log_message="$2"
  else
    echo "Error: missing required args for log_message function."
    exit 1
  fi

  this_timestamp=$(date +'%Y-%m-%d %H:%M:%S')

  case "$this_log_level" in
    "debug")
      if [[ $DEBUG == "true" ]]; then
        printf "${color_gray}[${this_timestamp}] [$this_log_level]${color_reset} $this_log_message\n"
      fi
      ;;
    "error")
      printf "${color_gray}[${this_timestamp}] [${color_bright_red}$this_log_level${color_gray}]${color_reset} $this_log_message\n"
      exit 1
      ;;
    "info")
      printf "${color_gray}[${this_timestamp}] [${color_bright_blue}$this_log_level ${color_gray}]${color_reset} $this_log_message\n"
      ;;
    "user")
      printf "${color_gray}[${this_timestamp}] [${color_bright_magenta}$this_log_level${color_gray} ]${color_reset} $this_log_message${color_gray} - [ENTER] to confirm, [CTRL+c] to cancel${color_reset}\n"
      read
      ;;
    "warn")
      printf "${color_gray}[${this_timestamp}] [${color_bright_yellow}$this_log_level ${color_gray}]${color_reset} $this_log_message\n"
      ;;
    *)
      echo "Error: unknown log level (${this_log_level})"
      exit 1
      ;;
  esac

}