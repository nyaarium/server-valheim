#!/bin/bash

export APP_NAME="valheim"

set -e
cd "$(dirname "$0")"

mkdir -p data/saves data/mods data/logs

./stop.sh

docker build -t $APP_NAME -f docker/Dockerfile .

if [ "${APP_SERVICE:-}" = "true" ]; then
    DETACHED="-d"
else
    DETACHED=""
fi

docker run --rm -it $DETACHED \
    --name $APP_NAME \
    --log-driver local \
    --log-opt max-size=200k \
    --log-opt max-file=3 \
    -v "$(pwd)/data/saves:/root/.config/unity3d/IronGate/Valheim" \
    -v "$(pwd)/data/logs:/data/logs" \
    -p 8080:8080/tcp \
    -p 2456:2456/tcp \
    -p 2457:2457/tcp \
    -p 2458:2458/tcp \
    -p 2456:2456/udp \
    -p 2457:2457/udp \
    -p 2458:2458/udp \
    $APP_NAME \
    $@
