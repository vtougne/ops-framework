#!/bin/bash

caller_arg=$@

ops_mode=batch

set -a

common_path=${caller_arg%/*}

if [ ! "$1" ] ; then
  echo "Env set for user"
  ops_mode=user
  me=$(readlink -f $BASH_SOURCE)
  common_path=${me%/*}
fi

appli_path=${common_path%/*}
env_path=${appli_path%/*}
appli_code=${appli_path##*/}
appli_code=${appli_code,,}
appli_code_u=${appli_code^^}
appli_env=${env_path##*/}
appli_env=${appli_env,,}
appli_env_u=${appli_env^^}
 

case $appli_env in
  devl|DEVL)
  appli_env_letter=d
  ;;

  intg|INTG)
  appli_env_letter=i
  ;;

  pprd|PPRD)
  appli_env_letter=t
  ;;

  prod|PROD)
  appli_env_letter=p
  ;;

  *)
  fct_trace "$msg_error Working on an unknow environnment, the caller script should be located in a path like this /intg/appli_code/a_path/the_script"
  exit 20
  ;;
esac

appli_env_letter_u=${appli_env_letter^^}
msg_debug="[DEBUG   ]"
msg_error="[ERROR   ]"
msg_exec="[EXEC    ]"
msg_info="[INFO    ]"
msg_success="[SUCCESS ]"
msg_usage_error="************** error"
msg_warning="[WARNING ]"

function fct_mkdir {
  the_folder=$1
  fct_trace "$msg_info ${appli_code_u} $the_folder"
  if [ ! -d $the_folder ] ; then
    fct_exec "mkdir $the_folder"
  else
    fct_trace "$msg_info  skipped folder already exist"
  fi
}

 

function fct_exec {
  [ ! "$1" ] && { echo "usage: functiion fct_exec required a command line in argument\neg:fct_exec hostname" ; exit 1 ; }
  fct_exec_arg="$@"
  echo $fct_exec_arg | grep "{{[A-Za-z0-9_-]*}}">/dev/null
  if [ $? -eq 0 ] ; then
    if [ -f $shadow_file ] ; then
      eval `cat $shadow_file | sed "s/^\([^=]*\)=\(.*\)/export \1=xxxxxxxxxxx/g"`
      export fct_exec_arg_hiden_shadow_keys=$($appli_path/common/templator.sh "$fct_exec_arg")
      . $shadow_file
    fi
    export fct_exec_arg=$($appli_path/common/templator.sh "$fct_exec_arg")
  fi

  if [[ ! -z $fct_exec_arg_hiden_shadow_keys ]] ; then
    fct_trace "$msg_exec $fct_exec_arg_hiden_shadow_keys"
  else
    fct_trace "$msg_exec $fct_exec_arg"
  fi

  eval "$fct_exec_arg"
  cmd_status=$?

  if [ $cmd_status -ne 0 ] ; then
    if [[ ! -z $fct_exec_arg_hiden_shadow_keys ]] ; then
      fct_trace "$msg_error The command failed (cmd: $fct_exec_arg_hiden_shadow_keys)"
    else
      fct_trace "$msg_exec $@"
    fi
    return $cmd_status
  else
    fct_trace "$msg_success The command worked successfully (${cmd_status})"
    return 0
  fi
}

 

function fct_trace {

  output=$FCT_LOG_FILE_NAME
  echo -e  "`date "+%Y%m%d %H%M%S"` $caller $@"
  [ ! -z $output ] && echo -e "`date "+%Y%m%d %H%M%S"` $caller $@" >>$output

  return 0
}

caller=${caller_arg}
caller=${caller##*/}
caller=${caller%.*}
export -f fct_exec
export -f fct_trace

export mail_from=somebyf@somewhere.com
export mail_end_body_disclaimer="\n\nFor any request, you can contact your support by replying to this email"
export mail_end_body_disclaimer_enable=yes
export mail_subject_prefix="[ $appli_code_u | $appli_env_u ] "
export ORACLE_BASE=/opt/oracle/srv/12.2.0
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ORACLE_BASE}/lib
export PATH=$PATH:${ORACLE_BASE}/bin
export ORACLE_HOME=${ORACLE_BASE}
export ORACLE_SID=${appli_env_letter_u}${appli_code_u}1
export dump_path=/dumptmp/dmp

date_yyyymodd=`date +%Y%m%d`
time_hhmiss=`date +%H%M%S`

export shadow_file=${HOME}/.${appli_env_letter}_${appli_code}_shadow.txt
[ -f $shadow_file ] && . $shadow_file

specific_env_file=$appli_path/par/${appli_code}_env.sh
[ -f $specific_env_file ] && . $specific_env_file

if [[ $ops_mode == user ]] ; then
  echo " Variables below are set for you"
  echo
  env | egrep "^appli_|^mail_|^msg_|^shadow_file|^ORACLE_HOME|^ORACLE_SID|^dump_path" | sort -u
fi

