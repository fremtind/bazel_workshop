#!/bin/bash

set -e

# Path to your Bazel WORKSPACE directory
workspace_path=$(bazel info workspace)
# Path to your Bazel executable
bazel_path=$(which bazel)
# Starting Revision SHA
previous_revision=$1
# Final Revision SHA
final_revision=$2

current_branch="$(git rev-parse --abbrev-ref HEAD)"

if [[ -z "$final_revision" ]]; then
  final_revision="$(git rev-parse HEAD)"
fi

if [[ -z "$previous_revision" ]]; then
  echo "You need to supply at least previous revision SHAs"
  exit 1
fi

starting_hashes_json="/tmp/starting_hashes.json"
final_hashes_json="/tmp/final_hashes.json"
impacted_targets_path="/tmp/impacted_targets.txt"
bazel_diff="/tmp/bazel_diff"

# Generates the bazel-diff script
"$bazel_path" run //:bazel-diff --script_path="$bazel_diff"

git -C "$workspace_path" checkout "$previous_revision" --quiet

echo "Generating Hashes for Revision '$previous_revision'"
$bazel_diff generate-hashes -w "$workspace_path" -b "$bazel_path" $starting_hashes_json

git -C "$workspace_path" checkout "$final_revision" --quiet

echo "Generating Hashes for Revision '$final_revision'"
$bazel_diff generate-hashes -w "$workspace_path" -b "$bazel_path" $final_hashes_json

echo "Determining Impacted Targets"
$bazel_diff get-impacted-targets -sh $starting_hashes_json -fh $final_hashes_json -o $impacted_targets_path

impacted_targets=()
IFS=$'\n' read -d '' -r -a impacted_targets < $impacted_targets_path || true
formatted_impacted_targets=$(IFS=$'\n'; echo "${impacted_targets[*]}")
echo "Impacted Targets between $previous_revision and $final_revision:"
echo "$formatted_impacted_targets"
echo ""

git checkout "$current_branch"
