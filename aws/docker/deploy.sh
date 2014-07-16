#!/bin/bash
echo "Deploying BOSH Lite Release"
set -e
set -x

cd bosh-lite/aws

vagrant up --provider=aws

export BOSH_USERNAME=admin
export BOSH_PASSWORD=admin
bosh target 54.88.199.99

bosh upload stemcell http://bosh-jenkins-gems-warden.s3.amazonaws.com/stemcells/latest-bosh-stemcell-warden.tgz

export DIRECTORID=`bosh status | grep UUID | cut -dD -f2 | tr -d ' '`

cd /bosh-deployment
sed -i "s/DIRECTORUUID/$DIRECTORUUID/g" *.yml
bosh deployment *.yml
bosh deploy

vagrant destroy -f
