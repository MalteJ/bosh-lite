#!/bin/bash
echo "Deploying BOSH Lite Release"
set -e
set -x

cd bosh-lite/aws

vagrant up --provider=aws | tee vagrantup.out
export DIRECTORIP=`cat vagrantup.out | grep "bosh target" | cut -d, -f1 | rev | cut -d' ' -f1 | rev`

bosh --non-interactive target $DIRECTORIP
bosh login admin admin

bosh upload stemcell http://bosh-jenkins-gems-warden.s3.amazonaws.com/stemcells/latest-bosh-stemcell-warden.tgz

export DIRECTORUUID=`bosh status | grep UUID | cut -dD -f2 | tr -d ' '`

cd /bosh-deployment
sed -i "s/.*director_uuid.*/director_uuid: $DIRECTORUUID/" *.yml
bosh deployment *.yml
bosh deploy

vagrant destroy -f
