#!/bin/bash

root_dir="$(dirname "$0")"
output_dir="$root_dir/output"
template_dir="$root_dir/templates/experiments"
experiment_dir="$output_dir/experiments"
query_dir="$output_dir/queries"
result_dir="$output_dir/results"

create_queries_script="${root_dir}/bin/create_queries.py"

vars="${root_dir}/templates/vars.yml"

function run_mongo() {
    echo "mongo --host \"$(config_get connection_string)\" \"${1}\""
    mongo --host "$(config_get connection_string)" "${1}" >>"${2}" || true
    wait $!
    echo -e "\n" >>"${2}"
}

function prepare_input() {
  s_dir="$root_dir/_input/"
  d_dir="$root_dir/input"
  cp -a "${s_dir}/." "${d_dir}"
}

function run_experiment() {
  # run all queries - full experiment
  # $root_dir/experiment_run.sh -c $root_dir/config/.experiment_config -r ${1} -q 1,2,3,4,12,13,22
  $root_dir/experiment_run.sh -c $root_dir/config/.experiment_config -r ${1} -q 1,2,3,4,12,13,22
}

function store_experiment() {
  # store queries and results
  destination_dir="${experiment_dir}/${1}"
  mkdir -p $destination_dir
  mv -v "${query_dir}" "${destination_dir}"
  mv -v "${result_dir}" "${destination_dir}"
}

# run queries, force time-out
python $create_queries_script -f $vars -t $template_dir -o $query_dir
run_experiment 1
store_experiment "no-index/basic"

# run and explain queries, force time-out
python $create_queries_script -e -f $vars -t $template_dir -o $query_dir
run_experiment 5
store_experiment "no-index/explain"

# index and run queries, force time-out
python $create_queries_script -i -f $vars -t $template_dir -o $query_dir
run_experiment 1
store_experiment "index/basic"

# index, run and explain queries, force time-out
python $create_queries_script -i -e -f $vars -t $template_dir -o $query_dir
run_experiment 5
store_experiment "index/explain"

# optimized, run and explain queries, force time-out
python $create_queries_script -e -f $vars -t $template_dir -o $query_dir
prepare_input
run_experiment 5
store_experiment "optim"