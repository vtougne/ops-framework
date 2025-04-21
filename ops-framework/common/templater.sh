#!/bin/bash
. $(dirname $0)/../common/set_env.sh

# me=$(readlink -f $0) ; . ${me%/*}/../common/set_env.sh
 

function expand_string {
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
  # str=`echo $str | sed "s/^ *[0-9]*\t//g"`
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

f_log info original string "$@"
f_log info expanded_string "$(expand_string "$@")"
for line in $(expand_string "$@") ; do
  # prepared_string=$(expand_string "$line")
  eval "echo -e $line"
  # eval "echo -e \"$line\""
done

# for line in `cat -n $template_file` ; do
#   prepared_string=$(expand_string "$line")
#   new_str=`eval "echo -e $prepared_string"`
#   echo "$new_str">>$tmp_target_file
# done