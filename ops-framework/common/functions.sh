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

# echo coucocu from function