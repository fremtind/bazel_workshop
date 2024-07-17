#!/bin/bash

set -e

# Path to your Bazel executable
bazel_path="$(which bazel)"
# Path to your Bazel WORKSPACE directory
workspace_path="$(bazel info workspace)"

bazel_diff_workdir=$1
bazel_diff_bin=$2
bazel_diff_seed=$3
# Starting Revision SHA
previous_revision=$4
# Final Revision SHA
final_revision=$5
external_repos=$6

starting_hashes_json="$bazel_diff_workdir/starting-hashes/$previous_revision-$bazel_diff_seed.json"
final_hashes_json="$bazel_diff_workdir/final_hashes.json"
impacted_targets_path="$BAZEL_DIFF_IMPACTED_TARGETS"

command_args="--fineGrainedHashExternalRepos=$external_repos"

function generate_hashes() {
  local output=$1
  $bazel_diff_bin generate-hashes \
    -w "$workspace_path" \
    -b "$bazel_path" \
    --includeTargetType \
    "$command_args" \
    "$output"
}

function get_impacted_targets() {
  local starting_hashes=$1
  local output=$2
  $bazel_diff_bin get-impacted-targets \
    -sh "$starting_hashes" \
    -fh "$final_hashes_json" \
    -o "$output"
}

# Starting hash calculation
SECONDS=0
mkdir -p "$(dirname "$starting_hashes_json")"
>&2 echo "Got starting hash file: $starting_hashes_json"
git -C "$workspace_path" checkout "$previous_revision" --quiet

>&2 echo "Generating Hashes for Revision '$previous_revision'"
generate_hashes "$starting_hashes_json"
duration=$SECONDS
>&2 echo "Starting hash generation took $duration seconds."
# End starting hash calculation

# Final hash calculation
SECONDS=0
mkdir -p "$(dirname "$final_hashes_json")"
git -C "$workspace_path" checkout "$final_revision" --quiet

>&2 echo "Generating Hashes for Revision '$final_revision'"
generate_hashes "$final_hashes_json"
duration=$SECONDS
>&2 echo "Final hash generation took $duration seconds."
# End final hash calculation

# Determining changed targets
SECONDS=0
>&2 echo "Determining Impacted Targets"
get_impacted_targets "$starting_hashes_json" "$impacted_targets_path"
duration=$SECONDS
>&2 echo "Impacted target generation took $duration seconds."
# End determining changed targets

impacted_targets=()
IFS=$'\n' read -d '' -r -a impacted_targets < $impacted_targets_path || true
formatted_impacted_targets=$(IFS=$'\n'; echo "${impacted_targets[*]}")
>&2 echo "Impacted Targets between $previous_revision and $final_revision:"
echo "$formatted_impacted_targets"
