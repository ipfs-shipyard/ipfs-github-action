#!/usr/bin/env bash
set -e

# Interpolate env vars in the $INPUT_PATH_TO_ADD, see: https://docs.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions#entrypoint
# This handles situation where user provides path to add as $GITHUB_WORKSPACE/some/path
INPUT_DIR=$(sh -c "echo $INPUT_PATH_TO_ADD")
PIN_NAME="https://github.com/$GITHUB_REPOSITORY/commits/$GITHUB_SHA"

echo "Pinning $INPUT_DIR to $INPUT_CLUSTER_HOST"

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

# pin to cluster
root_cid=$(ipfs-cluster-ctl \
    --host "$INPUT_CLUSTER_HOST" \
    --basic-auth "$INPUT_CLUSTER_USER:$INPUT_CLUSTER_PASSWORD" \
    add \
    --quieter \
    --local \
    --cid-version 1 \
    --name "$PIN_NAME" \
    --recursive "$INPUT_DIR" )

preview_url="https://$root_cid.ipfs.$INPUT_IPFS_GATEWAY"

update_github_status "success" "Website added to IPFS" "$preview_url"

echo "Pinned to IPFS - $preview_url"

echo "::set-output name=cid::$root_cid"

echo "::set-output name=url::$preview_url"
