#!/bin/bash
set -e

HOST=localhost
PORT=9200
INDEX_PREFIX=logstash
LOG_FILE=/var/log/elasticsearch/delete_elasticsearch_index.log
LOG_LEVEL=DEBUG
# DRY_RUN=--dry-run

function exec_curator() {
    local command=$1
    local older_than_days=$2
    curator --host $HOST --port $PORT --logfile $LOG_FILE $DRY_RUN \
        $command indices --prefix $INDEX_PREFIX --older-than $older_than_days \
        --time-unit days --timestring %Y.%m.%d
}

exec_curator bloom 2
exec_curator close 10
exec_curator delete 15
