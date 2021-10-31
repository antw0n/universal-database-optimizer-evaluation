#!/bin/bash

source lib/config.sh

root_dir="$(dirname "$0")"
output_dir="$root_dir/output"
query_dir="$output_dir/experiments"
runs=5
force_timeout=false

function abort() {
  local lineno=$1
  local msg=$2
  echo >&2 '
***************
*** ABORTED ***
***************
'
  echo "An error occurred at line $lineno:" >&2
  echo "$msg" >&2
  exit 1
}

function usage() {
  echo "usage: $0 -q queries [-s sourcedir] [-o outdir] [-r runs] [-c path/to/config] [-t timoeut]"
  echo "       $0 -h"
  echo
  echo "  -q queries     queries to run list of comma separated numbers. e.g. 3,4,12,13,22"
  echo "  -s sourcedir   path to directory from where to get queries"
  echo "                 filenames must match *qQUERYNUMBER(v[0-9]+)?_*"
  echo "                   e.g. File containing Q1:"
  echo "                        q1_something.sql"
  echo "                   e.g. File containing version 2 of Q1:"
  echo "                        q1v2_something.js"
  echo "                 (Default: $query_dir)"
  echo "  -o outdir      path to directory to where results will be written"
  echo "                 (Default: Directory named after the process id)"
  echo "  -r runs        Runs per query. Used to compute average runtime"
  echo "                 (Default: $runs)"
  echo "  -c             Path to configuration file"
  echo "  -t             Force timeout (Default: $force_timeout)"
  echo "  -h             Print this message"
}

function drop_psql_cache() {
  echo "Dropping Postgres system caches"
  postgres_control "stop"
  # Drop system caches
  multipass exec mt-postgres -- sudo bash -c 'sync && echo 3 > /proc/sys/vm/drop_caches' >>"$file_out"
  postgres_control  "start"
}

function postgres_control() {
  multipass exec mt-postgres -- sudo bash -c "systemctl ${1} postgresql" >>"$file_out"
  case "${1}" in
  "start")
    verify ${1} "active"
    ;;
  "stop")
    verify ${1} "inactive"
    ;;
  esac
}

function verify() {
  echo "Verifying ${1}"
  while true; do
    if multipass exec mt-postgres -- sudo bash -c "systemctl status postgresql" | grep -E "Active: ${2}"; then
      echo "OK"
      break
    else
      sleep 5
      echo "WAITING..."
    fi
  done
  echo '... done.'
}

function drop_mongo_cache() {
  echo "Dropping Mongo system caches"
  mongo_control "shutdown" ${1}
  # Drop system caches
  multipass exec mt-mongo-1 -- sudo bash -c 'sync && echo 3 > /proc/sys/vm/drop_caches' >>"$file_out"
  mongo_control "startup" ${1}
}

function mongo_control() {
  mongocli ops-manager clusters ${1} mt-exp-replica-001 --force >/dev/null 2>&1
  case "${1}" in
  "shutdown")
    verify_shutdown
    ;;
  "startup")
    verify_startup
    ;;
  esac
}

function verify_shutdown() {
  echo "Verifying shutdown"
  while true; do
    if multipass exec mt-mongo-1 -- sudo bash -c 'systemctl status mongodb-mms-automation-agent.service' | grep -E '27011|27012|27013'; then
      sleep 5
      echo "WAITING..."
    else
      echo "OK"
      break
    fi
  done
  echo '... done.'
}

function verify_startup() {
  echo "Verifying startup"
  while true; do
    local result=$(multipass exec mt-mongo-1 -- sudo bash -c 'systemctl status mongodb-mms-automation-agent.service')
    echo "$(grep -E '27011|27012|27013' <<<$result)"
    if grep -q "27011" <<<"$result" && grep -q "27012" <<<"$result" && grep -q "27013" <<<"$result"; then
      echo "OK"
      break
    else
      sleep 5
      echo "WAITING..."
    fi
  done
  echo '... done.'
}

function experiment_with_postgres() {
  for ((i = 0; i < runs; i++)); do
    drop_psql_cache
    echo "PGPASSWORD=\"$(config_get password)\" psql -h \"$(config_get host)\" -p \"$(config_get port)\" -U \"$(config_get user)\" -f \"${1}\""
    PGPASSWORD="$(config_get password)" psql -h "$(config_get host)" -p "$(config_get port)" -U "$(config_get user)" -f "${1}" >>"${2}" &
    wait $!
    echo -e "\n" >>"${2}"
  done
}

function experiment_with_mongo() {
  if $force_timeout; then
    run_mongo_force_timeout "$@"
  else
    run_mongo "$@"
  fi
}

function run_mongo() {
    for ((i = 0; i < runs; i++)); do
      drop_mongo_cache ${2}
      echo "mongo --host \"$(config_get connection_string)\" \"${1}\""
      mongo --host "$(config_get connection_string)" "${1}" >>"${2}" || true
      wait $!
      echo -e "\n" >>"${2}"
    done
  }

function run_mongo_force_timeout() {
    for ((i = 0; i < runs; i++)); do
      drop_mongo_cache ${2}
      echo "timeout \"$(config_get mongo_force_timeout_duration)\" mongo --host \"$(config_get connection_string)\" \"${1}\""
      timeout $(config_get mongo_force_timeout_duration) mongo --host "$(config_get connection_string)" "${1}" >>"${2}" || true
      if [[ $? -eq 124 ]]; then
        echo "timeout" >>"${2}"
      else
        wait $!
        echo -e "\n" >>"${2}"
      fi
    done
}

q_selected=false
while getopts ":o:s:q:r:tc:h" opt; do
  case $opt in
  o)
    output_dir="$OPTARG"
    ;;
  s)
    query_dir="$OPTARG"
    ;;
  q)
    q_selected=true
    IFS=, read -a selected_queries <<<"$OPTARG"
    ;;
  r)
    runs=$OPTARG
    ;;
  t)
    force_timeout=true
    ;;
  c)
    config_file="$OPTARG"
    ;;
  h)
    usage
    ;;
  \?)
    echo "Unknown option: -$OPTARG" >&2
    exit 1
    ;;
  :)
    echo "Missing argument for option: -$OPTARG" >&2
    exit 1
    ;;
  esac
done

if ! $q_selected; then
  echo "Please specify the queries to be run (-q option)" >&2
  echo "Use option -h to print usage" >&2
  exit 1
fi

mkdir -p $output_dir
if [ $? -ne 0 ]; then
  echo "Could not create output dir: $output_dir" >&2
  exit 1
fi

trap 'abort ${LINENO} "$BASH_COMMAND"' ERR
set -e

set_config

echo "Experimenting..."
for q in "${selected_queries[@]}"; do
  for file in $(find "$query_dir" -type f -regextype awk -regex ".*q${q}(v[0-9]+)?_.*"); do
    echo "Running experiment q=${file}"
    wt=""
    bname=$(basename $file)
    extension="${bname##*.}"
    fname="${bname%%.*}"
    file_without_query_dir=${file//$query_dir\//}
    file_without_query_dir_and_bname=${file_without_query_dir//\/$bname/}
    fpath="$file_without_query_dir_and_bname/$fname"
    file_out="$output_dir/results/$fpath.out"
    mkdir -p "$(dirname "$file_out")" && touch "$file_out"
    case "$extension" in
    "sql")
      experiment_with_postgres $file $file_out
      wt=$(awk '/Execution Time/{sum += $3; n++} END {print sum/n}' "$file_out")
      ;;
    "js")
      experiment_with_mongo $file $file_out
      wt=$(awk -F'[:,]' '/executionTimeMillis/{sum += $2; n++} END {print sum/n}' "$file_out")
      if [ "$wt" = "-nan" ] && [ $(grep -c "MaxTimeMSExpired" "$file_out") -ne 0 ]; then
        wt="timeout"
      fi
      ;;
    esac
    echo "Result=$fpath $wt"
    echo "$fpath $wt" >>"$output_dir/results/results.csv"
    echo "Finished experiment q=${file}"
  done
done