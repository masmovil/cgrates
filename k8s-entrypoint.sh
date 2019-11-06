#! /usr/bin/env sh

mkdir -p "$(cat "$CONFIG_PATH/cgrates.json" | jq -r  -r '.cdrc[].cdr_in_path')"
mkdir -p "$(cat "$CONFIG_PATH/cgrates.json" | jq -r  -r '.cdrc[].cdr_out_path')"

exec "$@"
