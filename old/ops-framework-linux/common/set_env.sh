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

# echo "running_mode: $0"
unset ops_common_path OPS_PROJECT_PATH OPS_PROJECT_NAME OPS_ENV_PATH OPS_ENV_NAME OPS_LOG_PATH

f_log() {
  local level="$1"
  shift
  local msg="$@"
  local timestamp
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  printf "%s [%-8s] %s\n" "$timestamp" "$level" "$msg"
}


f_exec() {
  local rc

  f_log exec "$@"
  eval "$@"
  rc=$?

  if [ $rc -ne 0 ]; then
    f_log error last cmd failed with status code $rc
    return $rc
  fi
}

# f_log debug "caller_arg: $caller_arg"
# export instance_name=${caller_arg##*--instance_name=}
# f_log debug "instance_name: $instance_name"

ops_common_path=${me%/*}
export OPS_PROJECT_PATH=${ops_common_path%/*}
export OPS_PROJECT_NAME=${OPS_PROJECT_PATH##*/}
export OPS_ENV_PATH=${OPS_PROJECT_PATH%/*}
export OPS_ENV_NAME=${OPS_ENV_PATH##*/}
export OPS_LOG_PATH=${OPS_ENV_PATH}$/logs/${OPS_PROJECT_PATH}/logs


if [ "$running_mode" == "interactive" ]; then
  echo "running_mode: $running_mode"
  echo -e "\n**** Framework Environment ****"
  current_env=$(env | sort | uniq)
  comm -31 <(echo "$initial_env" | sort) <(echo "$current_env" | sort) | cut -d"=" -f1,2
  echo "**** End of Environment ****"
  # echo "$current_env" > /tmp/current_env.txt
fi
# export IFS="$OLD_IFS"
