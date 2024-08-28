#!/bin/bash

# location of script is passed in as first argument from the target
result="$($1)"

expected="Hello, World!"

if [ "$result" == "$expected" ]; then
  exit 0
else
  echo "Test failed, expected: '$expected', got: '$result'"
  exit 1
fi
