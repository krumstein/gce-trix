#!/bin/bash 

cd gce_tf/
IP1=$(terraform output -json | python -c 'import sys, json; print str(json.load(sys.stdin)["ip"]["value"])')
cd -
ssh centos@${IP1}

