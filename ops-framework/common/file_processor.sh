#!/usr/bin/env bash
. $(dirname $0)/../common/set_env.sh

set -euo pipefail

declare -A fp_vars
actions=""
on_failure=""
on_success=""
always=""


usage() {
  cat <<EOF
Usage: file_processor key=value [key=value ...] actions="..."

Required arguments:
  the_source=FILENAME            Name of the source file ({{ ... }} must be preprocessed)
  new_name=FILENAME              New filename (e.g., the_file_{{ yyyymmdd_hhmmss }}.txt)
  actions="..."                  Block of actions to execute (see syntax below)

Optional arguments:
  encrypted_name=FILENAME       Name of the encrypted file (can reference %new_name%)
  from_path=PATH                Source directory path
  work_path=PATH                Temporary working directory
  target_path=PATH              Destination directory
  gpg_key=KEY_ID                GPG key to use for encryption

Actions block:
  Each line defines a command to run:
    copy SRC DST
    gpg_encrypt SRC DST --gpg_key KEY
    del FILE
    try_del FILE    (safe delete, does not fail on error)

  Conditional blocks:
    on_failure:     commands to run if the main block fails
    on_success:     commands to run if the main block succeeds
    always:         commands to always run (cleanup, etc.)

Internal variables:
  Use %var_name% to reference internal variables set via key=value or during execution.

Note:
  for examples of the syntax, run './file_processor.sh --examples'
EOF
}

examples() {
  cat <<EOF
Examples:
  # Encrypt a file and move it to a new location
./file_processor.sh \\
  from_path=/source_path \\
  source_fil_name=the_file.txt \\
  new_file_name=the_file_20250508_152300.txt \\
  encrypted_name=%new_name%.asc \\
  gpg_key=the_key \\
  actions='
    copy /from_path/%the_source% /work_path/%new_name%;
    gpg_encrypt /work_path/%new_name% %encrypted_name% --gpg_key %gpg_key%;
    copy %work_path%/%new_name% %target_path%/%new_name%;
    on_failure:
      try_del %work_path%/%new_name%;
    on_success:
      del %from_path%/%the_source%;
      copy %from_path%/%the_source%;
    always:
      del %work_path%/%new_name%;
  '
EOF
  }


[ $# -eq 0 ] && usage && exit 1

[ "$1" == "--examples" ] && examples && exit 0


# --- 1. Lecture des arguments ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    *=*)
      key="${1%%=*}"
      value="${1#*=}"
      if [[ "$key" == "actions" ]]; then
        actions="$value"
      else
        fp_vars["$key"]="$value"
      fi
      shift
      ;;
    *)
      echo "Argument inconnu : $1" >&2
      exit 1
      ;;
  esac
done

# --- 2. Substitution des %var% ---
substitute_vars() {
  local line="$1"
  for key in "${!fp_vars[@]}"; do
    line="${line//%$key%/${fp_vars[$key]}}"
  done
  echo "$line"
}

# --- 3. Exécution des actions ---
run_block() {
  local block="$1"
  local lines
  IFS=';' read -ra lines <<< "$block"
  for line in "${lines[@]}"; do
    line="$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')" # trim
    [[ -z "$line" ]] && continue
    cmd=$(substitute_vars "$line")
    echo "+ $cmd"
    eval "$cmd"
  done
}

# --- 4. Séparation des blocs ---
parse_actions() {
  local mode="main"
  while IFS= read -r line; do
    case "$line" in
      on_failure:*) mode="failure" ;;
      on_success:*) mode="success" ;;
      always:*) mode="always" ;;
      *)
        case "$mode" in
          main) actions+="$line;" ;;
          failure) on_failure+="$line;" ;;
          success) on_success+="$line;" ;;
          always) always+="$line;" ;;
        esac
        ;;
    esac
  done <<< "$(echo -e "$actions")"
}

# --- 5. Execution ---
main() {
  parse_actions

  if run_block "$actions"; then
    run_block "$on_success"
  else
    run_block "$on_failure"
  fi
  run_block "$always"
}

main

for key in "${!fp_vars[@]}"; do
  echo "info $key: ${fp_vars[$key]}"
done


