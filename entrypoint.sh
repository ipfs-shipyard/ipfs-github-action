#!/usr/bin/env bash
set -e

# if [[ $# -lt 5 ]] ; then
#   echo 'Usage:'
#   echo 'GITHUB_REPOSITORY="ipfs-shipyard/ipld-explorer" \'
#   echo 'GITHUB_SHA="bf3aae3bc98666fbf459b03ab2d87a97505bfab0" \'
#   echo 'GITHUB_TOKEN="_secret" \'
#   echo './entrypoint.sh <input root dir to pin recursivly> <cluster_user> <cluster_password> <cluster_host> <ipfs_gateway>'
#   exit 1
# fi

# interpolate env vars in the path, see: 
# INPUT_DIR=$(sh -c "echo $1")
# CLUSTER_USER=$2
# CLUSTER_PASSWORD=$3
# CLUSTER_HOST=$4
# IPFS_GATEWAY=$5
PIN_NAME="https://github.com/$GITHUB_REPOSITORY/commits/$GITHUB_SHA"

INPUT_DIR="$INPUT_PATH_TO_ADD"
echo "Pinning $INPUT_DIR to $INPUT_CLUSTER_HOST"
echo "GITHUB_WORKSPACE is $GITHUB_WORKSPACE"
echo "GITHUB_REPOSITORY is $GITHUB_REPOSITORY"
echo "pwd $(pwd)"
ls -la "$1"

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

update_github_status "pending" "Pinnning to IPFS cluster" "$INPUT_IPFS_GATEWAY"

# check command works
ipfs-cluster-ctl

# ipfs-cluster-ctl \
#     --host $INPUT_CLUSTER_HOST \
#     --basic-auth $INPUT_CLUSTER_USER:$INPUT_CLUSTER_PASSWORD \
#     add \
#     --quieter \
#     --name "$PIN_NAME" \
#     --recursive $INPUT_DIR

# pin to cluster
root_cid=$(ipfs-cluster-ctl \
    --host "$INPUT_CLUSTER_HOST" \
    --basic-auth "$INPUT_CLUSTER_USER:$INPUT_CLUSTER_PASSWORD" \
    add \
    --quieter \
    --name "$PIN_NAME" \
    --recursive "$INPUT_DIR" )

preview_url="$INPUT_IPFS_GATEWAY/ipfs/$root_cid"

update_github_status "success" "Website added to IPFS" "$preview_url"

echo "::set-output name=cid::$root_cid"
