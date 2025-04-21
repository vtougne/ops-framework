#!/bin/bash

. $(dirname $0)/../common/set_env.sh

# f_log info starting
package_path=/tmp
f_log OPS_INSTANCE_NAME: $OPS_INSTANCE_NAME
f_exec cd $OPS_INSTANCE_PATH
f_exec tar -czf $package_path/${OPS_INSTANCE_NAME}-${OPS_ENV_NAME}.tar.gz . || exit $?
f_log info success
f_exec curl artifactory:8082 -T $package_path/${OPS_INSTANCE_NAME}-${OPS_ENV_NAME}.tar.gz