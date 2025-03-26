#!/bin/bash

port="3306"
password=""
version="latest"
volume="mysql-data"

longopts="help,port:,password:,version:"
shortopts="h"

args=$(getopt -n "$0" -l "${longopts}" -o "${shortopts}" -- "$@")

help() {
    echo "Usage: $0 [OPTIONS] <VOLUME>"
    echo "Start a MySQL server in a Docker container"
    echo ""
    echo "Options:"
    echo "  --port     <port>       Port number for MySQL server"
    echo "  --password <password>   Password for MySQL root user"
    echo "  --version  <version>    Version of MySQL server"
    echo "  -h, --help              Display this help message"
    echo ""
    echo "Arguments:"
    echo "  <VOLUME>                Volume name for MySQL data"
}

if [ $? -ne 0 ]; then
    help
    exit 1
fi

eval set -- "$args"

while true; do
    case "$1" in
        --port)
            port=$2
            shift 2
            ;;
        --password)
            password=$2
            shift 2
            ;;
        -h | --help)
            help
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "ERROR: Unrecognized option $1"
            exit 1
            ;;
    esac
done

if [ -n "$1" ]; then
    volume=$1
fi

echo "$1"

docker run --name mysql \
    -p "${port}:3306" \
    -e "MYSQL_ALLOW_EMPTY_PASSWORD=yes" \
    -v "${volume}:/var/lib/mysql" \
    "mysql:${version}"
