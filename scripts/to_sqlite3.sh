#!/usr/bin/env bash
#
# v1.0.1    2021-04-06a     webdev+jc@kit-ar.com
#
# inspired in
#   https://gist.github.com/peteWT/f229d27875572b577cf301b05b08eb2d
#   https://gist.github.com/kazlauskis/1d0bdb9efb3b1bb1e76d48aa368f3a64
#
#
set -eo pipefail
##set -u
set -x

MY_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
T_STAMP=$(date -u +"%Y%m%d_%H%M%SZ")

MDB_FILE="$1"
[ -e "${MDB_FILE}" ] || exit -2

if [ "$2" != "" ]; then
    OUT_DIR="$2"
else
    OUT_DIR="${PWD}/_out/${MDB_FILE}.${T_STAMP}.sqlite3"
    [ -d "${OUT_DIR}" ] && exit -5
fi
mkdir -p "${OUT_DIR}"
[ -d "${OUT_DIR}" ] || exit -6

OUT_FILE_DB=${OUT_DIR}/${MDB_FILE}.sqlite3
[ -f "${OUT_FILE_DB}" ] && exit -7

echo "Converting MSAccess to SQLite..."
echo ""
echo "   from: [${MDB_FILE}]"
echo "     to: [${OUT_FILE_DB}]"
echo "     on: [${OUT_DIR}]"
echo ""
echo "SQLite version:"
sqlite3 -version
echo "mdb-tools version"
apt list mdbtools
echo ""

OUT_FILE_SQL_PRFX="${OUT_DIR}/sqlite3"
touch "${OUT_FILE_SQL_PRFX}.1.schema.sql"
touch "${OUT_FILE_SQL_PRFX}.2.data.sql"

dump_sql__schema() {
    mdb-schema \
        --default-values \
        --not-empty \
        "${MDB_FILE}" \
        sqlite | sed 's/=Now()/CURRENT_DATE/g'
}

dump_sql__data() {
    local MDB_TABLES=$(mdb-tables -1 -t table "${MDB_FILE}" |grep -v "Paste Error" |grep -v "~TMP")

    echo "BEGIN;"
    echo ""
    for t in ${MDB_TABLES}; do
        mdb-export \
            "${MDB_FILE}" "$t" \
            --date-format='%Y-%m-%d' \
            --datetime-format='%Y-%m-%d %H:%M:%S' \
            -I sqlite

            # --boolean-words
            # -0
            # --namespace
        echo ""
    done
    echo "COMMIT;"
    echo ""
}

dump_sql__schema >> "${OUT_FILE_SQL_PRFX}.1.schema.sql"
dump_sql__data   >> "${OUT_FILE_SQL_PRFX}.2.data.sql"

# https://unixsheikh.com/articles/sqlite-the-only-database-you-will-ever-need-in-most-cases.html
# https://sqlite.org/pragma.html
# need to add:
#   PRAGMA auto_vacuum = INCREMENTAL;
#   PRAGMA busy_timeout = 30000;
#   PRAGMA encoding = 'UTF-8';
#   PRAGMA foreign_keys = true;
#   PRAGMA journal_mode = WAL;
#   PRAGMA locking_mode = EXCLUSIVE;
#   PRAGMA read_uncommitted = FALSE;
#   PRAGMA recursive_triggers = TRUE;
#   # PRAGMA schema.synchronous = NORMAL;
#   # PRAGMA schema.synchronous = FULL;
#   PRAGMA schema.synchronous = EXTRA;
#   PRAGMA schema.user_version = 0;
#
#   PRAGMA writable_schema = ??;

mdb-ver "${MDB_FILE}"
time \
    cat \
        "${OUT_FILE_SQL_PRFX}.1.schema.sql" \
        "${OUT_FILE_SQL_PRFX}.2.data.sql" \
    | \
    sqlite3 \
        -bail \
        -batch \
        "${OUT_FILE_DB}"

ls -la "${OUT_FILE_DB}"
