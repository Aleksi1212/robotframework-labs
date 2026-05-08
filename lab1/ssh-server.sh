#!/bin/bash

args=("$@")

if  [ $# -lt 1 ]; then
    echo "no args"
    exit 1
fi
command=${args[0]}

if [ "$command" = "start" ]; then
    docker compose up -d
fi

if [ "$command" = "stop" ]; then
    docker compose down
fi