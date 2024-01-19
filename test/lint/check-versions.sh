#!/bin/bash

# This script implements a lint that ensures that all manifest
# versions in the monorepo have matching versions.

echo "Checking that all manifest versions match..."

expected=$(jq -r .version ./package.json)

echo "Expected manifest version: $expected"

dist_dirs=(dist dist/cli dist/install)
pkgs_dirs=(pkgs pkgs/cargo-messages pkgs/load)
cmbin=pkgs/cargo-messages/platforms
bin_dirs=($cmbin/android-arm-eabi $cmbin/darwin-arm64 $cmbin/darwin-x64 $cmbin/linux-arm-gnueabihf $cmbin/linux-x64-gnu $cmbin/win32-arm64-msvc $cmbin/win32-x64-msvc)
src_dirs=(src src/cli src/install)
for d in ${dist_dirs[@]} ${pkgs_dirs[@]} ${bin_dirs[@]} ${src_dirs[@]} ; do
  actual=$(jq -r .version $d/package.json)
  if [[ $actual != $expected ]]; then
    echo "❌ $d: $actual"
    failed=true
  fi
done

if [[ $failed = true ]]; then
  exit 1
fi
