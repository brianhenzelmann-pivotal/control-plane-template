# Control Plane
This repo is meant to capture the information needed to build and manage the Henzelmann homelab control plane.

## Configuration
The following vars and secrets files should be updated prior to installation:

- `bosh-deployment/cloud-config-vars.yml`
- `bosh-deployment/vcenter-vars.yml`
- `concourse-deployment/concourse-vars.yml`
- `secrets/certs.yml`
- `secrets/concourse-secrets.yml`
- `secrets/minio-secrets.yml`
- `secrets/vcenter-secrets.yml`

## Installation
```
. ./install.sh
```
