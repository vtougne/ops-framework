vi
cd /repo/ops-framework/
ll
. ./common/set_env.sh 
vi /home/lab_user/repo_ops-framework.secrets
. ./common/set_env.sh 
cat /home/lab_user/repo_ops-framework.secrets
./scripts/ops_tester.sh 
cd /repo/ops-framework/
./scripts/ops_tester.sh 
cd /repo/ops-framework/
./scripts/ops_tester.sh 
./common/set_env.sh 
. ./common/set_env.sh 
f_log info coucou
. ./common/set_env.sh 
f_log info coucou
f_log info "coucou {{ the_password }}"
echo $the_password
cd /repo/ops-framework/
./common/launcher.sh f_log "coucou {{ the_password }}"
./common/launcher.sh f_log "info coucou {{ the_password }}"
cd /repo/ops-framework/
. ./common/set_env.sh 
./scripts/ops_tester.sh 
rm /home/lab_user/repo_ops-framework.secrets
./scripts/ops_tester.sh 
cd /repo/ops-framework/
./scripts/ops_tester.sh 
. ./common/set_env.sh 
./scripts/ops_tester.sh 
vi /home/lab_user/repo_ops-framework.secrets
./scripts/ops_tester.sh 
vi /home/lab_user/repo_ops-framework.secrets
./scripts/ops_tester.sh 
./common/packager.sh 
cd
ll
cd project-sample/
tar xvf /tmp/ops-framework-repo.tar.gz
. common/set_env.sh 
ll home/lab_user/
ll /home/lab_user/
vi /home/lab_user/dev_project-sample.secrets
./scripts/ops_tester.sh 
. common/set_env.sh 
f_log info coucou
f_log info coucou {{ the_password }}
f_exec echo  coucou {{ the_password }}
cd /repo/ops-framework/
ll
. common/set_env.sh 
f_looper hostname
. common/set_env.sh 
f_looper hostname
i=2
j=5
[ $i -lt $j ] && echo youpi
. common/set_env.sh 
f_looper hostname
. common/set_env.sh  && f_looper hostname
f_looper hostname
. common/set_env.sh 
f_looper hostname
. common/set_env.sh 
f_looper hostname
f_looper() hostname
cd /repo/ops-framework/
. common/set_env.sh 
f_looper hostname
f_looper
. common/set_env.sh 
f_looper
f_looper hostname
cat common/functions.sh 
. common/set_env.sh
f_looper hostname
. ./common/set_env.sh
f_looper hostname
f_log coucou
. ./common/set_env.sh
f_looper hostname
f_looper
. ./common/set_env.sh
f_looper
. ./common/set_env.sh
f_looper
. ./common/set_env.sh
f_looper
. ./common/set_env.sh && f_looper hostname
echo "Hello $the_password"
echo "Hello \n vince"
echo -e "Hello \n vince"
echo -e "Hello \ vince"
echo -e "Hello \t vince"
. ./common/set_env.sh && f_looper hostname
. ./common/set_env.sh && f_looper hostname | sed "s/Att/bobo/g"
. ./common/set_env.sh && f_exec echo {{ the_password }}
. ./common/set_env.sh && f_exec "echo {{ the_password }}"
vi /home/lab_user/repo_ops-framework.secrets
. ./common/set_env.sh && f_exec "echo {{ the_password }}"
. ./common/set_env.sh && f_exec '"echo {{ the_password }}"'
f_exec '"echo {{ the_password }}"'
f_exec echo '"{{ the_password }}"'
f_exec '"echo {{ the_password }}"'
f_exec hostname
f_exec '"echo {{ the_password }}"'
f_exec '"hostname {{ the_password }}"'
. ./common/set_env.sh
f_exec '"hostname {{ the_password }}"'
f_exec '"echo {{ the_password }}"'
f_exec 'echo "{{ the_password }}"'
f_exec 'echo "{{ 'the_password' }}"'
f_exec 'echo "{{ 'the_password\' }}"'
f_exec 'echo "{{ 'the_password\\' }}"'
f_exec 'echo "{{ 'the_password\\\' }}"'
f_exec 
f_exec '"echo {{ the_password }}"'
./common/launcher.sh echo coucou
/common/launcher.sh "echo coucou"
./common/launcher.sh echo coucou
./common/launcher.sh "echo coucou"
./common/launcher.sh "echo coucou {{ the_password }}"
f_exec "echo coucou {{ the_password }}"
. /repo/ops-framework/common/set_env.sh 
f_exec "echo coucou {{ the_password }}"
. /repo/ops-framework/common/set_env.sh 
f_exec "echo coucou {{ the_password }}"
. /repo/ops-framework/common/set_env.sh 
f_exec "echo coucou {{ the_password }}"
f_exec hostname
f_exec "echo coucou {{ the_password }}"
. /repo/ops-framework/common/set_env.sh 
f_exec hostname
. /repo/ops-framework/common/set_env.sh 
f_exec hostname
. /repo/ops-framework/common/templater coucou
. /repo/ops-framework/common/templater.sh coucou
/repo/ops-framework/common/templater.sh coucou
ll
cd project-sample/
/repo/ops-framework/common/packager.sh 
cd /repo/ops-framework/
./common/packager.sh 
./scripts/ops_tester.sh 
cd /repo/ops-framework/
./scripts/ops_tester.sh 
set -x ./scripts/ops_tester.sh
set -x
./scripts/ops_tester.sh 
sh -x ./scripts/ops_tester.sh
bash -x ./scripts/ops_tester.sh
cd /repo/ops-framework/
./scripts/ops_tester.sh
bash -x ./scripts/ops_tester.sh
./scripts/ops_tester.sh
. /repo/ops-framework/common/set_env.sh 
f_log coucou
f_log info coucou
f_exec "echo coucou {{ the_password }}"
cd /repo/ops-framework/
ll
./scripts/ops_tester.sh 
. ./common/set_env.sh 
. ./common/packager.sh 
