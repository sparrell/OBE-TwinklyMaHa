#!/usr/bin/env bash
# Mounting our current directory to the docker image /opt/build. The release was
# created in /opt/release so we will copy this content back to our computer
docker run -i -v $(pwd):/opt/build --rm maha:latest sh << COMMANDS
echo "copying the release...."
cp /opt/release/_build/prod/*gz /opt/build
echo "Done"
COMMANDS
