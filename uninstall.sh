#!/bin/bash
set -e

bosh delete-deployment \
    -d concourse \
    -n

bosh delete-deployment \
    -d minio \
    -n

bosh clean-up --all -n

bosh delete-env bosh-deployment/bosh.yml \
    --state=bosh-deployment/state.json \
    --vars-store=secrets/bosh-creds.yml \
    -o bosh-deployment/cpi.yml \
    -o bosh-deployment/uaa.yml \
    -o bosh-deployment/config-server.yml \
    -o bosh-deployment/credhub.yml \
    -o bosh-deployment/resource-pool.yml \
    -l bosh-deployment/vcenter-vars.yml \
    -l secrets/vcenter-secrets.yml
