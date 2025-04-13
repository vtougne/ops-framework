#!/bin/bash

. $(dirname $0)/../common/set_env.sh $(readlink -f $0)

# f_log info starting
# f_exec hostname || exit $?

# f_log info continue

# >&2 echo "wrting somthing on stderr "

# f_log info continue

>&2 printf "starting\n"
>&1 echo something
>&2 printf "continue\n"
