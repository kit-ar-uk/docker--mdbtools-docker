#!/bin/bash

# Create an SQL-Dump
# https://stackoverflow.com/a/32423570
# Usage: ./to_mysql.sh database.mdb > data.sql

TABLES=$(mdb-tables -1 "$1")

for t in $TABLES
do
    [[ "$t" != ~TMP* ]] && \
	echo "DROP TABLE IF EXISTS $t;" && \
	mdb-schema "$1" -T "$t" mysql
done

for t in $TABLES
do
    [[ "$t" != ~TMP* ]] && mdb-export -D '%Y-%m-%d %H:%M:%S' -I mysql "$1" "$t"
done
