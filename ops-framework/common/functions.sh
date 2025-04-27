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
  local password_key
  local password
  local sed_str=""
  
  for password_key in ${secret_keys//;/ }; do
    local escaped_string=""
    password=$(eval echo \$$password_key)
    escaped_password=$(f_escape_sed_string "$password")
    # echo debug escaped_password: $escaped_password
    sed_str="$sed_str;s/$escaped_password/\$\{$password_key\}/g"
  done
  # echo debug sed_str: ${sed_str#*;}
  # echo "$@" | sed "s/password/********/g"
  # echo "$@" | sed "${sed_str#*;}"
  sed_str="\"${sed_str#*;}\""
  # echo debug sed_string: "${sed_str#*;}"
  # echo "$@" | sed "${sed_str#*;}"
  # echo debug sed_str: "$sed_str"
  sed_cmd="echo "\$@" | sed ${sed_str}"
  # echo debug sed_cmd: $sed_cmd
  eval "$sed_cmd"
  # echo "$@" | sed "$sed_str"
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
  f_mask_password "$(f_template "$out")"
  # f_template "$out" 
  # echo "$out" 
}


function f_escape_sed_string {
  str=$1
  # echo 'The Stro\ng password' | sed "s/\\\n/\\\\\\\n/g"
  str=`echo $str | sed "s/\\\\\\\\/\\\\\\\\\\\\\\\\\\\\\\\\/g"`
  str=`echo $str | sed 's/\\$/\\\\$/g'`
  str=`echo $str | sed 's/\\[/\\\\[/g'`
  str=`echo $str | sed 's/\\//\\\\\//g'`
  str=`echo $str | sed 's/\`/\\\\\`/g'`
  # str=`echo $str | sed "s/'/\\\\\'/g"`
  # str=`echo $str | sed 's/"/\\\\\"/g'`
  # str=`echo $str | sed 's/&/\\\\\&/g'`
  # str=`echo $str | sed 's/</\\\\</g'`
  # str=`echo $str | sed 's/>/\\\\>/g'`
  # str=`echo $str | sed 's/~/\\\\~/g'`
  # str=`echo $str | sed 's/\\$/\\\\$/g'`
  # str=`echo $str | sed 's/\\;/\\\\;/g'`
  # str=`echo $str | sed "s/\t/\\\\\\\\\t/g"`
  # str=`echo $str | sed 's/(/\\\(/g'`
  # str=`echo $str | sed 's/)/\\\)/g'`
  # str=`echo $str | sed 's/#/\\\\#/g'`
  # str=`echo $str | sed 's/\`/\\\\\`/g'`
  echo "$str"
  # echo debug escaped_str: $str
}

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

read_from_pipe() { read "$@" <&0; }

f_read_stdin() {
  local input=""
  if [ -t 1 ] ; then echo terminal; else echo "not a terminal"; fi
  while IFS= read -r line; do
    if [ -z "$input" ]; then
      input="$line"
    else
      input="$input\n$line"
    fi
    # input+="$line\n"
  done
  # echo "******${input}***********"
  if [ -z "$input" ]; then
    # echo "No input provided"
    # return 1
    if [ "$1" == "" ] ; then
      echo usage:
      echo "  echo Hello World | f_template"
      echo "  f_template \$var"
    fi
  fi
  f_template "${input}"
}

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


