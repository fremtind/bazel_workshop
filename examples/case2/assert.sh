if [ "$(cat "$1")" != "$2" ]; then
  echo "file '$1' does not contain '$2'"
fi
