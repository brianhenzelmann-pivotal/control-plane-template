#!/bin/bash

bosh create-env bosh-deployment/bosh.yml \
    --state=bosh-deployment/state.json \
    --vars-store=secrets/bosh-creds.yml \
    -o bosh-deployment/cpi.yml \
    -o bosh-deployment/uaa.yml \
    -o bosh-deployment/config-server.yml \
    -o bosh-deployment/credhub.yml \
    -o bosh-deployment/resource-pool.yml \
    -l bosh-deployment/vcenter-vars.yml \
    -l secrets/vcenter-secrets.yml \
    -l secrets/certs.yml

. ./set-bosh-env.sh

bosh update-config ./bosh-deployment/cloud-config.yml --name default --type cloud --vars-file=./bosh-deployment/cloud-config-vars.yml -n
bosh update-config ./bosh-deployment/cpi-config.yml -l secrets/vcenter-secrets.yml --name cpi-config --type cpi -n

if [[ $* == *--skip-stemcells* ]]
then
  echo "Skipping stemcells\n"
else
  bosh upload-stemcell https://s3.amazonaws.com/bosh-core-stemcells/3586.100/bosh-stemcell-3586.100-vsphere-esxi-ubuntu-trusty-go_agent.tgz
  bosh upload-stemcell https://bosh-core-stemcells.s3-accelerate.amazonaws.com/621.84/bosh-stemcell-621.84-vsphere-esxi-ubuntu-xenial-go_agent.tgz
fi

bosh deploy \
  -e control-plane \
  -d concourse concourse-deployment/concourse.yml \
  -o concourse-deployment/static-web.yml \
  -o concourse-deployment/basic-auth.yml \
  -o concourse-deployment/credhub.yml \
  -l secrets/certs.yml \
  -l concourse-deployment/versions.yml \
  -l concourse-deployment/concourse-vars.yml \
  -l secrets/concourse-secrets.yml \
  -l secrets/bosh-secrets.yml \
  --vars-store secrets/concourse-creds.yml \
  -n

bosh upload-release https://bosh.io/d/github.com/minio/minio-boshrelease

bosh deploy \
    -d minio \
    minio-deployment/minio.yml \
    -l ./minio-deployment/minio-vars.yml \
    -l ./secrets/minio-secrets.yml \
    -l secrets/certs.yml \
    -n
