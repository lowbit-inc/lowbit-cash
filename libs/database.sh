#!/bin/bash
database_dir="${HOME}/.lowbit-cash"
database_file="cash.db"
database_path="${database_dir}/${database_file}"

function database_check(){
  if [[ ! -f "${database_path}" ]] ; then
    echo "Database file not found. Initializing..."
    database_init
    echo
  fi
}

function database_init(){
  mkdir -p "${database_dir}"
  sqlite3 "${database_path}" < ./libs/database_init.sql
}

function database_run(){
  this_query="$@"

  sqlite3 --box "${database_path}" "${this_query}"
}

function database_silent(){
  this_query="$@"

  sqlite3 --csv "${database_path}" "${this_query}"
}

database_check