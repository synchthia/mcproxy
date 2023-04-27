#!/bin/bash
set -e

VERSION="$1"
if [ "$VERSION" == "" ]; then
    echo "Usage: <version>"
    exit 1
fi

if [ "$VERSION" == "latest" ]; then
    VERSION=$(curl -fsSL https://papermc.io/api/v2/projects/waterfall/ | jq -cr '.versions | last')
    echo ":: Use latest version: $VERSION"
fi

echo ":: Retrieve latest $VERSION builds..."
BUILD=$(curl -fsSL https://papermc.io/api/v2/projects/waterfall/versions/$VERSION | jq '.builds | max')

echo "-- Detected: $BUILD"

echo ":: Downloading Waterfall..."
curl -o waterfall.jar -fsSL https://papermc.io/api/v2/projects/waterfall/versions/${VERSION}/builds/${BUILD}/downloads/waterfall-${VERSION}-${BUILD}.jar
