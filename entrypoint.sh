#!/usr/bin/env bash
set -e

if [[ $# -eq 0 ]] ; then
  echo 'Usage:'
  echo 'CLUSTER_USER="who" \'
  echo 'CLUSTER_PASSWORD="_secret_" \'
  echo 'CLUSTER_HOST="/dnsaddr/cluster.ipfs.io" \'
  echo 'IPFS_GATEWAY="https://ipfs.io"'
  echo 'GITHUB_REPOSITORY="ipfs-shipyard/ipld-explorer" \'
  echo 'GITHUB_SHA="bf3aae3bc98666fbf459b03ab2d87a97505bfab0" \'
  echo 'GITHUB_TOKEN="_secret" \'
  echo './entrypoint.sh <input root dir to pin recursivly>'
  exit 1
fi

INPUT_DIR=$1
PIN_NAME="https://github.com/$GITHUB_REPOSITORY/commits/$GITHUB_SHA"
HOST=${CLUSTER_HOST:-"/dnsaddr/cluster.ipfs.io"}
GATEWAY_URL=${IPFS_GATEWAY:-"https://ipfs.io"}

update_github_status () {
  # only try and update the satus if we have a github token
  if [ -z "$GITHUB_TOKEN" ] ; then
    return 0
  fi

  local STATE=$1
  local DESCRIPTION=$2
  local TARGET_URL=$3
  local CONTEXT='IPFS'
  local STATUS_API_URL="https://api.github.com/repos/$GITHUB_REPOSITORY/statuses/$GITHUB_SHA"
  local params
  params=$(jq --monochrome-output --null-input \
    --arg state "$STATE" \
    --arg target_url "$TARGET_URL" \
    --arg description "$DESCRIPTION" \
    --arg context "$CONTEXT" \
    '{ state: $state, target_url: $target_url, description: $description, context: $context }' )

  curl --silent --output /dev/null -X POST -H "Authorization: token $GITHUB_TOKEN" -H 'Content-Type: application/json' --data "$params" $STATUS_API_URL
}

update_github_status "pending" "Pinnning to IPFS cluster" "https://ipfs.io/"

# pin to cluster
root_cid=$(ipfs-cluster-ctl \
    --host $HOST \
    --basic-auth $CLUSTER_USER:$CLUSTER_PASSWORD \
    add \
    --quieter \
    --name "$PIN_NAME" \
    --recursive $INPUT_DIR )

preview_url="$GATEWAY_URL/ipfs/$root_cid"

update_github_status "success" "Website added to IPFS" "$preview_url"

echo "$root_cid"
