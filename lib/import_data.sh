#!/bin/bash

function import_data() {
  cd "$root_dir"
  case "$(config_get mode)" in
  'psql')
    import_data_psql
    ;;
  'psql_json')
    import_data_psql_json
    ;;
  'mongo_1c')
    import_data_mongo "scale$(config_get scale)" "data.json"
    ;;
  'mongo_2c')
    collections=("customer" "orders-lineitem")
    import_data_mongo_CjOjLs collections
    ;;
  'mongo_3c')
    collections=("customer" "orders" "lineitem")
    import_data_mongo_CjOjLs collections
    ;;
  esac
}

function import_data_psql() {
  create_rdb="$root_dir/output/creation/$(config_get mode)/create_rdb.sql"
  echo -n "Importing data psql -h $(config_get host) -p $(config_get port) -U $(config_get user) -w -f ${create_rdb}"
  PGPASSWORD="$(config_get password)" psql -h "$(config_get host)" -p "$(config_get port)" -U "$(config_get user)" -w -f "${create_rdb}"
  echo "... done."
}

function import_data_psql_json() {
  echo -n "Importing data psql -h $(config_get host) -p $(config_get port) -U $(config_get user) -w -f \"$root_dir/output/creation/$(config_get mode)/create_jsonb.sql\""
  PGPASSWORD="$(config_get password)" psql -h "$(config_get host)" -p "$(config_get port)" -U "$(config_get user)" -w -f "$output_dir/creation/$(config_get mode)/create_jsonb.sql"
  echo "... done."
}

function import_data_mongo_CjOjLs {
    local -n collections=$1
    for collection in "${collections[@]}"; do
      import_data_mongo "$collection" "$collection.json"
    done
}

# TODO: template and authentication
# 1. Transform to template
# 2. add to echo:
# "--authenticationDatabase \"$(config_get auth_database)\"" \
# "--username \"$(config_get username)\"" \
# "--password \"$(config_get password)\"" \
# 3. add to import:
# --authenticationDatabase "$(config_get auth_database)" \
# --username "$(config_get username)" \
# --password "$(config_get password)" \
function import_data_mongo {
  echo -n "Importing data mongoimport" \
  "--host \"$(config_get connection_string)\"" \
  "--db \"$(config_get database)\"" \
  "--collection \"${1}\"" \
  "--file \"$output_dir/${2}\"" \
  "--numInsertionWorkers 8 --drop"
  mongoimport \
  --host "$(config_get connection_string)" \
  --db "$(config_get database)" \
  --collection "${1}" \
  --file "$output_dir/${2}" \
  --numInsertionWorkers 8 --drop
  echo "... done."
}
