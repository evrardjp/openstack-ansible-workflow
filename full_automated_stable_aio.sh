#!/usr/bin/env zsh
#os rax server create --image 6d833af9-9e31-4d4e-a4ea-1f7f3a4d4406 \
#  --flavor performance1-8 \
#  --key-name laptop-rackspace \
#  evrardjp-aio

openstack --os-cloud rax server create \
  --flavor performance1-8 \
  --image 6d833af9-9e31-4d4e-a4ea-1f7f3a4d4406 \
  --key-name laptop-rackspace \
  --config-drive=true \
  --user-data user_data.yml \
  evrardjp-aio-stable
