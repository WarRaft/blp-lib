#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root_dir"

input_dir="$root_dir/test-data/blp"
output_dir="$root_dir/test-data/png"

# Build all C examples
./build-examples.sh

if [ -d "$output_dir" ]; then
	rm -rf "${output_dir:?}"/*
fi
mkdir -p "$output_dir"

# Convert input_dir to output_dir using decode_dir
examples/dist/decode_dir "$input_dir" "$output_dir" --mip 0

echo "Conversion complete. Check $output_dir for results."
