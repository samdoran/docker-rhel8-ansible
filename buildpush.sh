#!/bin/bash

set -e

function cleanup {
    echo "Deleting secrets"
    rm -f ./secrets
}
trap cleanup EXIT

echo "Creating secrets"
# docker swarm init
printf $RHSM_USERNAME | docker secret create rhsm_username -
printf $RHSM_PASSWORD | docker secret create rhsm_password -
printf $RHSM_POOL_ID | docker secret create rhsm_pool_id -

echo "Building container image"
DOCKER_BUILDKIT=1 docker build -t quay.io/samdoran/rhel8-ansible .


# echo "Pushing to Quay"
# docker push quay.io/samdoran/rhel8-ansible
