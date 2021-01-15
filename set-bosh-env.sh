export BOSH_IP=`bosh int ./bosh-deployment/vcenter-vars.yml --path /internal_ip`
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh int ./secrets/bosh-creds.yml --path /admin_password`
export BOSH_CA_CERT=`bosh int ./secrets/bosh-creds.yml --path /director_ssl/ca`
export BOSH_ENVIRONMENT=control-plane

bosh alias-env control-plane -e $BOSH_IP --ca-cert $BOSH_CA_CERT

export CREDHUB_CLIENT=director_to_credhub
export CREDHUB_SECRET=`bosh int ./secrets/bosh-creds.yml --path /uaa_clients_director_to_credhub`
export CREDHUB_SERVER=https://$BOSH_IP:8844
export CREDHUB_CA_CERT="$(bosh int ./secrets/bosh-creds.yml --path /credhub_tls/ca)\n$(bosh int ./secrets/bosh-creds.yml --path /uaa_ssl/ca)"

credhub login
