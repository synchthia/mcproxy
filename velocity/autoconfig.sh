#!/bin/sh
set -e

# Rewrite velocity.toml
rewriteSettings() {
    local TARGET="velocity.toml"
    local key=$1
    local value=$2

    if [ "$value" == "" ]; then
        [ "$DEBUG" != "" ] && echo "!! ${key} env has not provided. ignoring..."
        return 0
    fi

    if [ $(echo -ne "$key" | grep "secret") ]; then
        _display_value="<SECRET>"
    else
        _display_value="${value}"
    fi

    if grep "${key}" "$TARGET" > /dev/null; then
        echo "- Overwrite settings: (${key}: ${_display_value})"
        sed -i "/^${key}\s* = / c ${key}\ =\ ${value//\\/\\\\}" "$TARGET"
    else
        echo "- Append settings: (${key}: ${_display_value})"
        echo "${key} = ${value}" >> "$TARGET"
    fi
}

echo "=> Rewrite settings..."
# Deprecated
#rewriteSettings "forwarding-secret" "\"${VELOCITY_SECRET}\""
echo -ne "${VELOCITY_SECRET}" > /app/server/forwarding.secret

rewriteSettings "bind" "\"${BIND_ADDRESS:-0.0.0.0}:${PORT:-25565}\""
rewriteSettings "motd" "\"${MOTD:-A Velocity Server}\""
rewriteSettings "show-max-players" "${MAX_PLAYERS:-5000}"
rewriteSettings "online-mode" "${ONLINE_MODE:-true}"
rewriteSettings "prevent-client-proxy-connections" "${PREVENT_PROXY_CONNECTION:-true}"
rewriteSettings "player-info-forwarding-mode" "\"${PLAYER_INFO_FORWARDING_MODE:-modern}\""
rewriteSettings "ping-passthrough" "\"${PING_PASSTHROUGH:-ALL}\""
