#!/bin/bash

function log_message() {
  if [[ "$2" ]]; then
    this_log_level="$1"
    this_log_message="$2"
  else
    echo "Error: missing required args for log_message function."
    exit 1
  fi

  case "$this_log_level" in
    "debug")
      if [[ $DEBUG == "true" ]]; then
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$this_log_level] $this_log_message"
      fi
      ;;
    "info")
      echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$this_log_level ] $this_log_message"
      ;;
    "warn")
      echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$this_log_level ] $this_log_message"
      ;;
    "error")
      echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$this_log_level] $this_log_message"
      exit 1
      ;;
  esac

}