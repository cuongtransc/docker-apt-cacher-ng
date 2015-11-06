#!/bin/bash
set -e

if [ "$1" = 'apt-cacher-ng' ]; then
    ##################### handle SIGTERM #####################
    function _term() {
        printf "%s\n" "Caught terminate signal!"
        /etc/init.d/apt-cacher-ng stop

        # kill -SIGTERM $child 2>/dev/null
        exit 0
    }

    trap _term SIGHUP SIGINT SIGTERM SIGQUIT

    ##################### start application #####################
    chown -R apt-cacher-ng /var/cache/apt-cacher-ng

    # start service
    /etc/init.d/apt-cacher-ng start

    # make sure log file existed
    # touch /var/log/apt-cacher-ng/apt-cacher.log

    tail -f /var/log/apt-cacher-ng/apt-cacher.log &
    child=$!
    wait "$child"
fi

exec "$@"

