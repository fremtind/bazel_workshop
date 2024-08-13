#!/bin/bash

result="$(./examples/case3/hello)"

expected="Hello, World!"

if [ "$result" == "$expected" ]; then
  exit 0
else
  echo "Test failed, expected: '$expected', got: '$result'"
  exit 1
fi
