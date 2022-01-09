#!/bin/bash
set -e
cd "$(dirname "$0")"

VERSION="$1"
if [ "$VERSION" == "" ]; then
    echo "Usage: <version>"
    exit 1
fi

echo ":: Retrieve latest builds..."
BUILD=$(curl -fsSL https://papermc.io/api/v2/projects/velocity/versions/$VERSION | jq '.builds | max')

echo "-- Detected: $BUILD"

echo ":: Downloading Velocity..."
curl -o velocity.jar -fsSL https://papermc.io/api/v2/projects/velocity/versions/${VERSION}/builds/${BUILD}/downloads/velocity-${VERSION}-${BUILD}.jar
