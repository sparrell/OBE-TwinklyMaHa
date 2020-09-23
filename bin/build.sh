#!/usr/bin/env bash

set -e
echo "Starting release process..."
cd /opt/release

echo "Fetching project deps..."
mix deps.get

echo "Cleaning and compiling..."
echo "If you are using Phoenix, here is where you would run mix phx.digest"
mix phx.digest

echo "Generating release..."
mix release
