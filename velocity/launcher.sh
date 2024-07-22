#!/bin/bash
set -e
cd "$(dirname $0)"

## prepare - copy files from templates
_task_prepare() {
    _template() {
        # Copy from templates directory
        echo "Make from template"

        # plugins (symlink / keep templates plugin)
        # make symlink from provided plugin
        cd /app/templates/plugins
        for target in $(find . -mindepth 1 -maxdepth 1 | sed -e 's/\.\///'); do
            ln -sfnv ${PWD}/${target} /app/plugins/${target}
        done

        # files (ex. velocity.toml)
        cd /app/templates
        for target in $(find . -mindepth 1 -maxdepth 1 -type f | sed -e 's/\.\///'); do
            cp -TRpnv ${PWD}/${target} /app/server/${target}
        done
    }

    _fetch() {
        if [ "$USE_PACKY" ]; then
            packy fetch -s "${PACKY_NAMESPACES:-velocity_global}" -d /app/server/plugins
        fi
    }

    _template

    _fetch
}

## start - start server
_task_start() {
    _task_prepare

    # Auto configuration
    echo "Running pre-configuration..."
    cd /app/server
    bash /autoconfig.sh

    echo "Starting server..."
    exec java \
        -jar /velocity/velocity.jar \
        --port="${PORT:-25565}"
}

if [ "$1" == "" ] && [ "$2" == "" ]; then
    cmds="$(cat $0 | grep -E '^(_task).*\{$' | sort | tr -d '\ (){}' | tr '\n' '|' | sed -e 's/_task_//g' -e 's/|$/\n/g')"
    echo -e "Usage: $0 <${cmds}> [options...]"
    exit 1
fi

_args=$(shift 1 && echo $@)
_task_$1 $_args
