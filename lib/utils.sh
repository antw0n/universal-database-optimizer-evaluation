#!/bin/bash

function cleanup() {
  echo -n "Cleaning directory $output_dir "
  rm -r "$output_dir"
  echo "... done."
  echo -n "Removing output_dir from $root_dir/templates/vars.yml "
  sed -i '/^output_dir/d' "$root_dir/templates/vars.yml"
  echo "... done."
  echo -n "Adding output_dir to $root_dir/templates/vars.yml "
  echo "output_dir: $output_dir" >>"$root_dir/templates/vars.yml"
  echo "... done."
}

function render_templates() {
  echo -n "Rendering creation templates "
  python bin/create_queries.py -f "$root_dir/templates/vars.yml" -t "$root_dir/templates/creation" -o "$root_dir/output/creation"
  python bin/create_queries.py -f "$root_dir/templates/vars.yml" -t "$root_dir/templates/experiments" -o "$root_dir/output/experiments"
  echo "... done."
}

function sort_data() {
  echo -n "Sorting orders by customer key (o_custkey) "
  sort -nk2 -t '|' -T "$output_dir" "$output_dir/orders.tbl" -o "$output_dir/orders_sorted.tbl"
  echo "... done"
  echo -n "Sorting lineitem by order key (l_orderkey) "
  awk -F '|' 'NR==FNR{o[$1]=FNR; next} {print o[$1] "|" $0}' <(awk -F '|' '{print $1}' "$output_dir/orders_sorted.tbl" | uniq) "$output_dir/lineitem.tbl"| sort -t '|' -T "$output_dir" -nk1 | cut -d '|' -f2- >"$output_dir/lineitem_sorted.tbl"
  echo "... done"
}

function convert_to_valid_csv() {
  echo "Converting TBLs to valid CSVs"
  for f in *; do
    [[ -e $f ]] || [[ ! -d $f  ]] || continue
    sed -i 's/|$//' "$f"
    echo "${f}... done."
  done
}