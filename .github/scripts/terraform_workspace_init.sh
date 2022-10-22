#!/bin/bash
## Handles creating Terraform workspace as required via the Terraform Cloud API

## Don't continue on error
set -e

TF_ORGANISATION=${TF_ORGANISATION:-Cashewhands}

if [[ -z $TF_WORKSPACE ]]; then
  echo "TF_WORKSPACE not set"
  exit 1
fi

if [[ -z $TF_API_TOKEN ]]; then
  echo "TF_API_TOKEN not set"
  exit 1
fi

if [[ -z $WORKSPACE_BASE ]]; then
  echo "WORKSPACE_BASE not set"
  exit 1
fi

echo "Checking if workspace needs to be created.."
response=$(curl -s \
  --header "Authorization: Bearer $TF_API_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request GET \
  https://app.terraform.io/api/v2/organizations/$TF_ORGANISATION/workspaces/$TF_WORKSPACE)
if [[ $(echo $response | jq -r '.errors[0].status') -ne "null" ]] && [[ $(echo $response | jq -r '.errors[0].status') -ne "404" ]]; then
  echo "Exception: Error $(echo $response | jq -r '.errors[0]')"
  exit 1
fi

if [[ $(echo $response | jq -r '.errors[0].status') = "404" ]]; then
  echo "It does, creating Workspace.."
  response=$(curl -s \
    --header "Authorization: Bearer $TF_API_TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data "{\"data\": {\"type\": \"workspaces\", \"attributes\": {\"name\": \"$TF_WORKSPACE\"}}}" \
    https://app.terraform.io/api/v2/organizations/$TF_ORGANISATION/workspaces)
  if [[ $(echo $response | jq -r '.errors[0].status') -ne "null" ]]; then
    echo "Exception: Error $(echo $response | jq -r '.errors[0]')"
    exit 1
  fi
else
  echo "It doesn't, workspace already exists."
fi
workspace_id=$(echo $response | jq -r '.data.id')
sleep 2

echo "Ensuring workspace set to local execution"
response=$(curl -s \
  --header "Authorization: Bearer $TF_API_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request PATCH \
  --data "{\"data\": {\"type\": \"workspaces\", \"attributes\": {\"operations\": false}}}" \
  https://app.terraform.io/api/v2/organizations/$TF_ORGANISATION/workspaces/$TF_WORKSPACE)
if [[ $(echo $response | jq -r '.errors[0].status') -ne "null" ]]; then
  echo "Exception: Error $(echo $response | jq -r '.errors[0]')"
  exit 1
fi
sleep 2

echo "Making sure workspace has the $WORKSPACE_BASE tag"
response=$(curl -s \
  --header "Authorization: Bearer $TF_API_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data "{\"data\": [{\"type\": \"tags\", \"attributes\": {\"name\": \"$WORKSPACE_BASE\"}}]}" \
  https://app.terraform.io/api/v2/workspaces/$workspace_id/relationships/tags)
if [[ $(echo $response | jq -r '.errors[0].status') -ne "null" ]]; then
  echo "Exception: Error $(echo $response | jq -r '.errors[0]')"
  exit 1
fi
