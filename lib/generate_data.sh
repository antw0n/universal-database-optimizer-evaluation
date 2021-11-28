#!/bin/bash

function generate_data() {
  cd "$dbgen_path"
  echo "Generating TBL files for TPC-H dataset SF=$(config_get scale) MODE=$(config_get mode)"
  mkdir -p "$output_dir" &&
  if [[ "$(config_get mode)" == "psql" ]]; then
    ./dbgen -f -s $(config_get scale)  -v && mv -f *.tbl "$output_dir"
  else
    ./dbgen -f -T c -s $(config_get scale)  -v && ./dbgen -f -T o -s $(config_get scale) -v && mv -f *.tbl "$output_dir"
  fi

  cd "$output_dir"
  convert_to_valid_csv

  cd "$root_dir"
  case "$(config_get mode)" in
  'psql_json')
    sort_data
    echo -n "Producing json bin/crjoin/crjoin" \
    "-d 0" \
    "-m 3" \
    "-c \"$output_dir/customer.tbl\""  \
    "-o \"$output_dir/orders_sorted.tbl\""  \
    "-l \"$output_dir/lineitem_sorted.tbl\""  \
    "-r \"$output_dir/data.json\""
    bin/crjoin/crjoin \
    -d 0 \
    -m 3 \
    -c "$output_dir/customer.tbl" \
    -o "$output_dir/orders_sorted.tbl" \
    -l "$output_dir/lineitem_sorted.tbl" \
    -r "$output_dir/data.json"
    echo '... done.'
    ;;
  'mongo_1c')
    sort_data
    echo -n "Producing json bin/crjoin/crjoin" \
    "-d 1" \
    "-m 0" \
    "-c \"$output_dir/customer.tbl\""  \
    "-o \"$output_dir/orders_sorted.tbl\""  \
    "-l \"$output_dir/lineitem_sorted.tbl\""  \
    "-r \"$output_dir/data.json\""
    bin/crjoin/crjoin \
    -d 1 \
    -m 0 \
    -c "$output_dir/customer.tbl" \
    -o "$output_dir/orders_sorted.tbl" \
    -l "$output_dir/lineitem_sorted.tbl" \
    -r "$output_dir/data.json"
    echo '... done.'
    ;;
  'mongo_2c')
    echo -n "Producing json bin/crjoin/crjoin -d 1 -m 2 -c \"$output_dir/customer.tbl\" -r \"$output_dir/customer.json\""
    bin/crjoin/crjoin -d 1 -m 2 -c "$output_dir/customer.tbl" -r "$output_dir/customer.json"
    echo -n "Producing json bin/crjoin/crjoin -d 1 -m 1 -o \"$output_dir/orders.tbl\" -l \"$output_dir/lineitem.tbl\" -r \"$output_dir/orders-lineitem.json\""
    bin/crjoin/crjoin -d 1 -m 1 -o "$output_dir/orders.tbl" -l "$output_dir/lineitem.tbl" -r "$output_dir/orders-lineitem.json"
    echo '... done.'
    ;;
  'mongo_3c')
    echo -n "Producing json files bin/crjoin/crjoin -d 1 -m 2 -c \"$output_dir/customer.tbl\" -r \"$output_dir/customer.json\""
    bin/crjoin/crjoin -d 1 -m 2 -c "$output_dir/customer.tbl" -r "$output_dir/customer.json"
    echo -n "Producing json files bin/crjoin/crjoin -d 1 -m 2 -o \"$output_dir/orders.tbl\" -r \"$output_dir/orders.json\""
    bin/crjoin/crjoin -d 1 -m 2 -o "$output_dir/orders.tbl" -r "$output_dir/orders.json"
    echo -n "Producing json files bin/crjoin/crjoin -d 1 -m 2 -c \"$output_dir/lineitem.tbl\" -r \"$output_dir/lineitem.json\""
    bin/crjoin/crjoin -d 1 -m 2 -l "$output_dir/lineitem.tbl" -r "$output_dir/lineitem.json"
    echo '... done.'
    ;;
  esac
}
