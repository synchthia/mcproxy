#!/bin/sh
set -e

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

    echo "- Update yaml: (${key}: ${value})"
    yq e -i "${key} = ${value}" $TARGET
}


echo "=> Rewrite config.yml..."
rewriteYAML "config.yml" ".listeners[].host" "${BIND_ADDRESS:-0.0.0.0}:${PORT:-25565}"
rewriteYAML "config.yml" ".listeners[].tab_list" "\"${TAB_LIST:-SERVER}\""
rewriteYAML "config.yml" ".listeners[].max_players" "${MAX_PLAYERS:-1}"
rewriteYAML "config.yml" ".listeners[].query_port" "${QUERY_PORT:-${PORT}}"
rewriteYAML "config.yml" ".listeners[].motd" "\"${MOTD:-\&1MCProxy}\""
rewriteYAML "config.yml" ".listeners[].query_enabled" "${QUERY_ENABLED:-true}"
rewriteYAML "config.yml" ".listeners[].proxy_protocol" "${PROXY_PROTOCOL:-false}"
rewriteYAML "config.yml" ".listeners[].ping_passthrough" "${PING_PASSTHROUGH:-true}"
rewriteYAML "config.yml" ".listeners[].force_default_server" "${FORCE_DEFAULT_SERVER:-true}"

rewriteYAML "config.yml" ".player_limit" "${PLAYER_LIMIT:--1}"
rewriteYAML "config.yml" ".enforce_secure_profile" "${ENFORCE_SECURE_PROFILE:-true}"
rewriteYAML "config.yml" ".log_commands" "${LOG_COMMANDS:-true}"
rewriteYAML "config.yml" ".forge_support" "${FORGE_SUPPORT:-true}"
rewriteYAML "config.yml" ".online_mode" "${ONLINE_MODE:-true}"
rewriteYAML "config.yml" ".ip_forward" "${IP_FORWARD:-true}"
rewriteYAML "config.yml" ".prevent_proxy_connections" "${PREVENT_PROXY_CONNECTIONS:-true}"
