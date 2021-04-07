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

TMP_DIR="${PWD}/_out/${MDB_FILE}.${T_STAMP}.sqlite3"
[ -d "${TMP_DIR}" ] && exit -5

mkdir -p "${TMP_DIR}"

OUT_FILE_SQL_PRFX="${TMP_DIR}/sqlite3"
touch "${OUT_FILE_SQL_PRFX}.1.schema.sql"
touch "${OUT_FILE_SQL_PRFX}.2.data.sql"

mdb-schema \
    --default-values \
    --not-empty \
    "${MDB_FILE}" \
    sqlite >> "${OUT_FILE_SQL_PRFX}.1.schema.sql"

MDB_TABLES=$(mdb-tables -1 -t table "${MDB_FILE}" |grep -v "Paste Error" |grep -v "~TMP")

echo "BEGIN;" >> "${OUT_FILE_SQL_PRFX}.2.data.sql"
echo "" >> "${OUT_FILE_SQL_PRFX}.2.data.sql"
for t in ${MDB_TABLES}; do 
    mdb-export \
        "${MDB_FILE}" "$t" \
        --date-format='%Y-%m-%d' \
        --datetime-format='%Y-%m-%d %H:%M:%S' \
        -I sqlite >> "${OUT_FILE_SQL_PRFX}.2.data.sql"

        # --boolean-words 
        # -0
        # --namespace
    echo "" >> "${OUT_FILE_SQL_PRFX}.2.data.sql"
done
echo "COMMIT;" >> "${OUT_FILE_SQL_PRFX}.2.data.sql"
echo "" >> "${OUT_FILE_SQL_PRFX}.2.data.sql"

time \
    cat \
        "${OUT_FILE_SQL_PRFX}.1.schema.sql" 
        "${OUT_FILE_SQL_PRFX}.2.data.sql" \
    | \
    sqlite3 \
        -bail \
        -batch \
        "${TMP_DIR}/${MDB_FILE}.sqlite3"

sqlite3 -version

