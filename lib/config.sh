#!/bin/bash

function config_read_file() {
  (grep -E "^${2}=" -m 1 "${1}" 2>/dev/null || echo "VAR=__UNDEFINED__") | head -n 1 | cut -d '=' -f 2-
}

function config_get() {
  val="$(config_read_file "$config_file" "${1}")"
  if [ "${val}" = "__UNDEFINED__" ]; then
    val="$2"
  fi
  printf -- "%s" "${val}"
}

function set_config(){
  config_file="${config_file:-$root_dir/config/.default_config}"
  echo "config_file=${config_file}"
}