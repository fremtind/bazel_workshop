#!/bin/bash

ALL_CHANGED_TARGETS=()

while read line
do
  ALL_CHANGED_TARGETS+=("$line")
done < "${1:-/dev/stdin}"

DIR="$(realpath "$(dirname "$0")")"


# Get all targets that have the manual tag in the list of changed targets
MANUAL_TARGETS=$(bazel query "attr(tags, 'manual', '//...')")
#echo "manual_targets=\n$MANUAL_TARGETS"

IGNORE_TARGETS="$(cat "$DIR/ignore_targets.txt")"
#echo "ignore_targets=\n$IGNORE_TARGETS"
TARGETS_TO_FILTER="$(echo "$MANUAL_TARGETS" && echo "$IGNORE_TARGETS")"
#echo "targets_to_filter:"
#echo "$TARGETS_TO_FILTER"
FILTERED_CHANGED_TARGETS="$(printf '%s\n' "${ALL_CHANGED_TARGETS[@]}" | grep -v -f <(echo "$TARGETS_TO_FILTER"))"

echo "$FILTERED_CHANGED_TARGETS"
