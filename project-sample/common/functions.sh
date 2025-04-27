f_date() {
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  echo "$timestamp"
}

f_exec() {
  local rc
  # echo debug from f_exec the_name: $the_name

  f_log exec "$@"
  # eval "$@"
  eval $(f_template "$@")
  rc=$?

  if [ $rc -ne 0 ]; then
    f_log error last cmd failed with status code $rc
    return $rc
  fi
}

f_mask_password() {
  echo "$@" | sed "s/password/********/g"
}

f_log() {
  local level="$1"
  shift
  local msg="$@"
  local timestamp
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  local out=$(printf "%s [%-8s] %s\n" "$timestamp" " $level" "$msg")
  # f_template "$out"
  # echo $out
  # $ops_common_path/templater.sh "$@"
  f_mask_password $(f_template "$out")
  # f_template "$out" 
}


# function f_escape_shell_string {
#   str=$1
#   str=`echo $str | sed "s/\\\\\\\\/\\\\\\\\\\\\\\\\\\\\\\\\/g"`
#   str=`echo $str | sed "s/'/\\\\\'/g"`
#   str=`echo $str | sed 's/"/\\\\\"/g'`
#   str=`echo $str | sed 's/&/\\\\\&/g'`
#   str=`echo $str | sed 's/</\\\\</g'`
#   str=`echo $str | sed 's/>/\\\\>/g'`
#   str=`echo $str | sed 's/~/\\\\~/g'`
#   str=`echo $str | sed 's/\\$/\\\\$/g'`
#   str=`echo $str | sed 's/\\;/\\\\;/g'`
#   str=`echo $str | sed "s/\t/\\\\\\\\\t/g"`
#   str=`echo $str | sed 's/(/\\\(/g'`
#   str=`echo $str | sed 's/)/\\\)/g'`
#   str=`echo $str | sed 's/#/\\\\#/g'`
#   str=`echo $str | sed 's/\`/\\\\\`/g'`
#   # str=`echo $str | sed 's/{{\([^}{]*\)}}/\${\1}/g'`
#   str=`echo $str | sed 's/{{[[:space:]]*\([^{}[:space:]]\+\)[[:space:]]*}}/${\1}/g'`
#   echo "$str"
# }

function f_load_var_file {
  [ "$1" == "--as_secret" ] && { shift; local vars_type="secrets"; }
  
  [ ! -f "$1" ] && { echo "File $1 not found"; return 1; }

    for line in $(cat $1 | grep -v "^#" | grep -v "^$") ; do
      local key=$(echo $line | cut -d'=' -f1)
      local val=$(echo $line | cut -d'=' -f2)
      export $key="$val"

      if [ "$vars_type" == "secrets" ]; then
        # secret_keys="${secret_keys};${key}"
        grep -w ${key} <<< "$secret_keys" > /dev/null || secret_keys="${secret_keys};${key}"
      fi
    done
    secret_keys=$(echo $secret_keys | sed 's/^;//g')
}

f_template() { $ops_common_path/templater.sh "$@"; }


# f_template() {
# export OLD_IFS="$IFS"
# export IFS="
# "

#   # f_log info original string "$@"
#   # f_log info expanded_string "$(f_escape_shell_string "$@")"

#   for line in $(f_escape_shell_string "$@") ; do
#     eval "echo -e $line"
#   done
#   export IFS="$OLD_IFS"
# }


