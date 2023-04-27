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
        _display_value="${key}"
    fi

    if grep "${key}" "$TARGET" > /dev/null; then
        echo "- Overwrite settings: (${key}: ${_display_value})"
        sed -i "/^${key}\s* = / c ${key}\ =\ ${value//\\/\\\\}" "$TARGET"
    else
        echo "- Append settings: (${key}: ${_display_value})"
        echo "${key} = ${value}" >> "$TARGET"
    fi
}

rewriteYAML() {
    local TARGET="$1"
    local key=$2
    local value=$3

    if [ "$value" == "" ]; then
        [ "$DEBUG" != "" ] && echo "!! ${key} env has not provided. ignoring..."
        return 0
    fi

    if [ "$(yq e --unwrapScalar=false "${key}" $TARGET)" == "${value}" ]; then
        [ "$DEBUG" != "" ] && echo "!! ${key} env has not provided. ignoring..."
        return 0
    fi

    if [ $(echo -ne "$key" | grep "secret") ]; then
        echo "- Update yaml: (${key}: <SECRET>)"
    else
        echo "- Update yaml: (${key}: ${value})"
    fi

    yq e -i "${key} = ${value}" $TARGET
}


echo "=> Rewrite settings..."
# Deprecated
#rewriteSettings "forwarding-secret" "\"${VELOCITY_SECRET}\""
echo -ne "${VELOCITY_SECRET}" > /app/server/forwarding.secret
rewriteSettings "online-mode" "${ONLINE_MODE:-true}"
