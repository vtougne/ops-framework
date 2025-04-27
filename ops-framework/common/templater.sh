#!/bin/bash
[ ! -z "$OPS_INSTANCE_PATH" ] && . $(dirname $0)/../common/set_env.sh


# me=$(readlink -f $0) ; . ${me%/*}/../common/set_env.sh
 

function f_escape_shell_string {
  str=$1
  str=`echo $str | sed "s/\\\\\\\\/\\\\\\\\\\\\\\\\\\\\\\\\/g"`
  str=`echo $str | sed "s/'/\\\\\'/g"`
  str=`echo $str | sed 's/"/\\\\\"/g'`
  str=`echo $str | sed 's/&/\\\\\&/g'`
  str=`echo $str | sed 's/</\\\\</g'`
  str=`echo $str | sed 's/>/\\\\>/g'`
  str=`echo $str | sed 's/~/\\\\~/g'`
  str=`echo $str | sed 's/\\$/\\\\$/g'`
  str=`echo $str | sed 's/\\;/\\\\;/g'`
  str=`echo $str | sed "s/\t/\\\\\\\\\t/g"`
  str=`echo $str | sed 's/(/\\\(/g'`
  str=`echo $str | sed 's/)/\\\)/g'`
  str=`echo $str | sed 's/#/\\\\#/g'`
  str=`echo $str | sed 's/\`/\\\\\`/g'`
  # str=`echo $str | sed 's/{{\([^}{]*\)}}/\${\1}/g'`
  str=`echo $str | sed 's/{{[[:space:]]*\([^{}[:space:]]\+\)[[:space:]]*}}/${\1}/g'`
  echo "$str"
}

export IFS="
"

# f_log info original string "$@"
# f_log info expanded_string "$(f_escape_shell_string "$@")"

for line in $(f_escape_shell_string "$@") ; do
  eval "echo $line"
done
