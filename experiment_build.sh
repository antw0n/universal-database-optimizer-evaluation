#!/bin/bash

source lib/utils.sh
source lib/config.sh
source lib/generate_data.sh
source lib/import_data.sh

root_dir="$(dirname "$0")"
dbgen_path="$root_dir/tpch_tools/TPC-H_Tools_v3.0.0/dbgen"
output_dir="__UNDEFINED__"
generate=false

function usage() {
  echo "usage: $0 [-g] [-c /path/to/config_file] -[h]"
  echo "  -g (Re)generate dataset"
  echo "  -c Path to configuration file"
  echo "  -h Print this message"
}

while getopts ":gc:h:" opt; do
  case $opt in
  g)
    generate=true
    ;;
  c)
    config_file="$OPTARG"
    ;;
  h)
    usage
    exit 0
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

set_config
echo "generate=${generate}"
output_dir="$root_dir/output/dataset/$(config_get mode)/tpch-sf$(config_get scale)"
if [[ "$generate" == true ]]; then
  cleanup
  render_templates
  generate_data
fi
import_data
