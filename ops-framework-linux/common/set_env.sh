#!/bin/bash


if [ "$0" == "-bash" -o "$0" == "/usr/bin/bash" ] ; then
  running_mode="interactive"
  if [ -z "$initial_env" ] ; then
    initial_env="$(env | sort | uniq)"
  fi
  me=$(readlink -f $BASH_SOURCE)
  echo debug SHLVL: "$SHLVL"
else
  running_mode="non-interactive"
  me=$(readlink -f "$0")
  echo debug me: "$me"
  echo debug SHLVL: "$SHLVL"
fi

ops_common_path=${me%/*}
export OPS_PROJECT_PATH=${ops_common_path%/*}
export OPS_PROJECT_NAME=${OPS_PROJECT_PATH##*/}
export OPS_ENV_PATH=${OPS_PROJECT_PATH%/*}
export OPS_ENV_NAME=${OPS_ENV_PATH##*/}
export OPS_LOG_PATH=${OPS_ENV_PATH}$/logs/${OPS_PROJECT_PATH}/logs

. $ops_common_path/functions.sh


if [ "$running_mode" == "interactive" ]; then
  echo "running_mode: $running_mode"
  echo -e "\n**** Framework Environment ****"
  current_env=$(env | sort | uniq)
  comm -31 <(echo "$initial_env" | sort) <(echo "$current_env" | sort) | cut -d"=" -f1,2
  echo "**** End of Environment ****"
  # echo "$current_env" > /tmp/current_env.txt
fi
# export IFS="$OLD_IFS"
