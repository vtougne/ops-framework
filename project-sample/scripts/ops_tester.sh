#!/bin/bash

# me=$(readlink -f $0) ; . ${me%/*}/../common/set_env.sh
. $(dirname $0)/../common/set_env.sh
# exit 0

# echo debug ${me%/*}
# f_log info starting

# f_log info the_secret: $the_secret
# export the_name=vince
f_log info "coucou {{ the_password }}"
# f_exec hostname || exit $?

# f_log info continue

# >&2 echo "wrting somthing on stderr "

# f_log info continue

# >&2 printf "starting\n"
# >&1 echo something
# >&2 printf "continue\n"
