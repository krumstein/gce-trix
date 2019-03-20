#!/bin/bash 

cd gce_tf/
IP1=$(terraform output -json | python -c 'import sys, json; print str(json.load(sys.stdin)["ip"]["value"])')
HOSTNAME=$(terraform output -json | python -c 'import sys, json; print str(json.load(sys.stdin)["ctrl_hostname"]["value"])')
cd -
cat <<EOF > inventory
[ctrls]
${HOSTNAME} ansible_user=centos ansible_become=yes ansible_host=${IP1} ctrl_hostname=${HOSTNAME}
EOF

