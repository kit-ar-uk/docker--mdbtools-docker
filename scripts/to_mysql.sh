#!/bin/bash

# Create an SQL-Dump
# https://stackoverflow.com/a/32423570
# Usage: ./to_mysql.sh database.mdb > data.sql

TABLES=$(mdb-tables -1 $1)

for t in $TABLES
do
    echo "DROP TABLE IF EXISTS $t;"
done

mdb-schema $1 mysql

for t in $TABLES
do
    mdb-export -D '%Y-%m-%d %H:%M:%S' -I mysql $1 $t
done

