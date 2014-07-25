#!/bin/bash --login
echo "Deploying BOSH Lite Release"
set -e
set -x

function destroy {
  cd /bosh-lite/aws
  vagrant destroy -f
}

trap destroy EXIT SIGHUP SIGINT SIGTERM

bosh --version

cp /bosh-environment/tests/aws/$BOSH_AWS_PRIVATE_KEY ~/id_rsa_bosh
chown root ~/id_rsa_bosh
export BOSH_LITE_PRIVATE_KEY=~/id_rsa_bosh

cd /bosh-lite/aws

set +x
echo "vagrant up --provider=aws"
vagrant up --provider=aws | tee vagrantup.out
set -x
export DIRECTORIP=`cat vagrantup.out | grep "bosh target" | cut -d, -f1 | rev | cut -d' ' -f1 | rev`

sleep 60
bosh --non-interactive target $DIRECTORIP
bosh login admin admin

bosh upload stemcell http://bosh-jenkins-gems-warden.s3.amazonaws.com/stemcells/latest-bosh-stemcell-warden.tgz

export DIRECTORUUID=`bosh status | grep UUID | cut -dD -f2 | tr -d ' '`

cp -ra /bosh-environment /bosh-environment.local
chown -R root /bosh-environment.local
find /bosh-environment.local -type f -name "*.yml" -print0 | xargs -0 sed -i "s/.*director_uuid.*/director_uuid: $DIRECTORUUID/"

cd /bosh-environment.local
tests/$BOSH_TEST

trap - EXIT INT SIG
destroy