#!/bin/bash

. $(dirname $0)/../common/set_env.sh

# f_log debug the_name: $the_name
# f_exec $(echo -e "\"$@\"")
f_exec "$@"
# echo debug secret_keys ${secret_keys//;/ }

# for secret in ${secret_keys//;/ } ; do
#     echo debug secret: $secret
# done