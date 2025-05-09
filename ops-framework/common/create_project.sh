#!/usr/bin/env bash
. $(dirname $0)/../common/set_env.sh


local project_name=$1
local project_path=$2


if [ -z "$project_name" ] || [ -z "$project_path" ]; then
  echo "Usage: f_create_project <project_name> <project_path> <project_type>"
  return 1
fi

[ ! -d "$project_path" ] && { echo "Project path $project_path does not exist"; return 2; }
[ -d "$project_path/$project_name" ] && { echo "Project $project_name already exists in $project_path"; return 3; }

mkdir -p "$project_path/$project_name"
echo "Project $project_name of type $project_type created at $project_path/$project_name"



