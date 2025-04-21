#!/bin/bash

 
[ -z $appli_path ] && . $(dirname $0)/../common/set_env.sh $(readlink -f $0)

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
  str=`echo $str | sed "s/^ *[0-9]*\t//g"`
  str=`echo $str | sed "s/\t/\\\\\\\\\t/g"`
  str=`echo $str | sed 's/(/\\\(/g'`
  str=`echo $str | sed 's/)/\\\)/g'`
  str=`echo $str | sed 's/#/\\\\#/g'`
  str=`echo $str | sed 's/\`/\\\\\`/g'`
  str=`echo $str | sed 's/{{\([^}{]*\)}}/\${\1}/g'`
  echo "$str"
}

IFS=$'
'
arg1=$1

if [[ "$1" == "--template_file" ]] ; then
   shift
   target_file=$2
else
  if [[ -f "$1" && "${arg1##*.}" == "template" ]] ; then
    target_file=${arg1%.*}
  else
    eval "echo -e $(expand_string "$@")"
    exit 0
  fi
fi

template_file=$1

echo "debug template_file: $template_file"
echo "debug target_file: $target_file"

[ ! -f  $template_file ] && { echo "$msg_error template_file $template_file not found" ; exit 2 ; }

tmp_target_file="${template_file}.tmp"
sed_file="${template_file}.tmp.sed"
cp -p $template_file $tmp_target_file
>$tmp_target_file

for line in `cat -n $template_file` ; do
  prepared_string=$(expand_string "$line")
  new_str=`eval "echo -e $prepared_string"`
  echo "$new_str">>$tmp_target_file
done

if [ ! -f $target_file ] ; then

  fct_exec "mv $tmp_target_file $target_file" || exit 4
  fct_trace "$msg_info new file created :$target_file"
  ls -l $target_file
  exit 0
fi

fct_exec "diff $tmp_target_file $target_file">/dev/null

if [ $? == 0 ] ; then
  fct_trace "[SKIPPING] skipping, nothing to change on $target_file"
  [ -f  $sed_file ] && rm $sed_file
  [ -f $tmp_target_file ] && rm $tmp_target_file
  exit 0
fi

fct_trace "$msg_info new config will be applied, changes below"
sdiff -s $tmp_target_file $target_file
echo ""
fct_trace "$msg_info backuping config file ${target_file}"
fct_exec "cp -p ${target_file} ${target_file}_$(date +%Y%m%d_%H%M%S)"
fct_exec "mv $tmp_target_file $target_file" || exit 4

[ -f  $sed_file ] && rm $sed_file
fct_trace "$msg_info new file created:"
ls -l $target_file
