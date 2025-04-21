#!/bin/bash

uname_return=$(uname)
if [ "$uname_return" == "MINGW64_NT-10.0-26100" ]; then
  running_context="mingw"
else
  running_context="Linux"
fi

dollar_zero=$0


if [ "$dollar_zero" == "-bash" -o "$dollar_zero" == "/usr/bin/bash" -o "$dollar_zero" == "bash" ] ; then
  running_mode="interactive"
  if [ -z "$initial_env" ] ; then
    initial_env="$(env | sort | uniq)"
  fi
  setup_file=$(readlink -f $BASH_SOURCE)
  caller=human
  ops_common_path=${setup_file%/*}

else
  caller=$(readlink -f $0)
  running_mode="non-interactive"
  me=$(readlink -f "$0")
  ops_common_path=$(readlink -f "${caller%/*}/../common")
fi

# echo debug dollar zero: $0
# echo debug uname_return: $uname_return
# echo debug BASH_SOURCE: $BASH_SOURCE
# echo debug running_context: $running_context
# echo debug running_mode: $running_mode
# echo debug setup_file: $setup_file
# echo debug caller: $caller
# echo debug ops_common_path: $ops_common_path

export OPS_INSTANCE_PATH=${ops_common_path%/*}
export OPS_INSTANCE_NAME=${OPS_INSTANCE_PATH##*/}
# export OPS_PROJECT_NAME=${OPS_PROJECT_PATH##*/}
export OPS_ENV_PATH=${OPS_INSTANCE_PATH%/*}
export OPS_ENV_NAME=${OPS_ENV_PATH##*/}
export OPS_LOG_PATH=${OPS_ENV_PATH}$/logs/${OPS_INSTANCE_PATH}/logs

# echo debug OPS_INSTANCE_PATH: $OPS_INSTANCE_PATH
# echo debug OPS_ENV_PATH: $OPS_ENV_PATH

. $OPS_INSTANCE_PATH/common/functions.sh


if [ "$running_mode" == "interactive" ]; then
  echo "running_mode: $running_mode"
  echo -e "\n**** Framework Environment ****"
  current_env=$(env | sort | uniq)
  comm -31 <(echo "$initial_env" | sort) <(echo "$current_env" | sort) | cut -d"=" -f1,2
  echo "**** End of Environment ****"
  # echo "$current_env" > /tmp/current_env.txt
fi
# export IFS="$OLD_IFS"
