#!/bin/bash

# Function to execute Beeline query and get the count
get_hive_count() {
  local query="$1"
  beeline_output=$(beeline -u jdbc:hive2://your_hive_server -e "${query}")
  count=$(echo "${beeline_output}" | tail -n1)
  echo "${count}"
}

# Function to execute vsql query and get the count
get_vertica_count() {
  local query="$1"
  vertica_output=$(vsql -h your_vertica_host -U your_vertica_user -w your_vertica_password -At -c "${query}")
  count=$(echo "${vertica_output}" | tail -n1)
  echo "${count}"
}

# Function to compare counts from Hive and Vertica
compare_counts() {
  local hive_table="$1"
  local vertica_table="$2"

  # Hive Query
  hive_query="SELECT COUNT(*) FROM ${hive_table};"

  # Vertica Query
  vertica_query="SELECT COUNT(*) FROM ${vertica_table};"

  # Get counts from Hive and Vertica
  hive_count=$(get_hive_count "${hive_query}")
  vertica_count=$(get_vertica_count "${vertica_query}")

  # Remove leading and trailing whitespaces from the outputs (optional, for better comparison)
  hive_count=$(echo "${hive_count}" | tr -d '[:space:]')
  vertica_count=$(echo "${vertica_count}" | tr -d '[:space:]')

  # Compare the counts
  if [[ "${hive_count}" -eq "${vertica_count}" ]]; then
    echo "Counts for ${hive_table} from Hive and Vertica match."
  else
    echo "Counts for ${hive_table} from Hive and Vertica do not match."
  fi
}

# List of tables (modify as needed)
tables=("your_hive_table1" "your_hive_table2" "your_hive_table3")

# Loop through the list of tables and compare counts
for table in "${tables[@]}"; do
  compare_counts "${table}" "your_vertica_${table}"
done
