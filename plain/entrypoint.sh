#!/bin/bash
set -e

# Initialize Running user
if [ $(id -u) = 0 ]; then
    # Switch provided user
    if [ "${UID:+defined}" ] && [ "$UID" != 0 ] && [[ $UID != $(id -u app) ]]; then
        echo ":: $UID"
        usermod -u $UID app
    fi
    if [ "${GID:+defined}" ] && [ "$GID" != 0 ] && [[ $GID != $(id -g app) ]]; then
        echo ":: $GID"
        groupmod -o -g $GID app
    fi
fi

chown ${UID:-app}:${GID:-app} -R /app/
exec su-exec ${UID:-app} sh /launcher.sh start
