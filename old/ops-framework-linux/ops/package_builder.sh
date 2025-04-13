#!/bin/bash

. $(dirname $0)/../common/set_env.sh $(readlink -f $0)

 

# vtougne 202004 Creation

echo;fct_trace package_builder.sh linux version 1.11

echo

 

LIST_FILE=$1

usage="usage: $0 required package_file_list"

 

[ ! "$1" ]  && { echo "$usage" ; exit 1 ; }

pwd

fct_exec cd ..

pwd

 

[ ! -f ops/$LIST_FILE ] &&  { echo "[ERRO] $LIST_FILE not found"; exit 2 ; }

 

 

# TAR_FILE=${LIST_FILE%.*}_`date +%Y%m%d_%H%M%S`.tar

TAR_FILE=${LIST_FILE%.*}.tar

list_file_x_env=${LIST_FILE%.*}_X.txt

list_file_env_depending=${LIST_FILE%.*}_${appli_env_letter_u}.txt

 

fct_trace $msg_info TAR_FILE: $TAR_FILE

fct_trace $msg_info list_file_x_env: $list_file_x_env

fct_trace $msg_info list_file_env_depending: $list_file_env_depending

 

fct_exec cp -p ops/$LIST_FILE ops/$list_file_env_depending

 

>ops/$TAR_FILE

 

 

for file in `cat ops/$LIST_FILE` ; do

  new_file_name=`echo $file | sed "s/scripts\/${appli_env_letter_u}${appli_code_u}/scripts\/X${appli_code_u}/g"`

  if [ ! "$file" == "$new_file_name" ] ; then

    fct_exec "cp -p $file $new_file_name" || exit 3

  fi

  echo "debug new_file_name : $new_file_name"

  [ ! -f $new_file_name ] && { fct_trace "$msg_error file $new_file_name not found, exiting..." ; exit 3 ; }

  [ ! -f ops/$TAR_FILE ] && echo "pas de fichier"

  fct_exec "tar uvf ops/$TAR_FILE $new_file_name" || exit 5

  [ ! "$file" == "$new_file_name" ] &&  rm $new_file_name

done

 

fct_exec "tar uvf ops/$TAR_FILE ops/$LIST_FILE"

 

 

fct_exec cp -p ops/$LIST_FILE ops/$list_file_env_depending

set -x

cat ops/$LIST_FILE | sed "s/scripts\/${appli_env_letter_u}${appli_code_u}/scripts\/X${appli_code_u}/g">ops/$list_file_x_env

set +x

 

fct_exec "tar uvf ops/$TAR_FILE ops/$list_file_x_env" || exit 5

fct_exec "tar uvf ops/$TAR_FILE ops/$list_file_env_depending" || exit 5

 

 

chmod 777 ops/$TAR_FILE

[ ! -d /tmp/${GLB_P_APPLI} ] && fct_exec "mkdir /tmp/${GLB_P_APPLI}" && fct_exec "chmod 777 /tmp/${GLB_P_APPLI}"

fct_exec cp -p ops/$TAR_FILE /tmp/${GLB_P_APPLI}

chmod  777 /tmp/${GLB_P_APPLI}/* 2>/dev/null

