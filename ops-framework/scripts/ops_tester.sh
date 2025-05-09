#!/bin/bash

# me=$(readlink -f $0) ; . ${me%/*}/../common/set_env.sh
. $(dirname $0)/../common/set_env.sh
# exit 0

# echo debug ${me%/*}
# f_log info starting

# f_log info the_secret: $the_secret
# export the_name=vince
f_log info "should be masked:  {{ the_password }}"
echo "debug should be clear:         $the_password"
f_template "from template should be clear: {{ the_password }}"
f_template "template var OPS_INSTANCE_NAME: {{ OPS_INSTANCE_NAME }}"

f_exec hostname
f_exec hostnamedsz

# >&2 printf "starting\n"
# >&1 echo something
# >&2 printf "continue\n"
