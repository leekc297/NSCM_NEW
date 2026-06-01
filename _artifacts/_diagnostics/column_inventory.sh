#!/usr/bin/env bash
# column_inventory.sh — As-Is MSSQL vs To-Be Oracle 테이블 컬럼 인벤토리 cross-check
#
# 사용:
#   ./column_inventory.sh <TABLE_NAME> [TOBE_TABLE_NAME]

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <TABLE_NAME> [TOBE_TABLE_NAME]" >&2
  exit 1
fi
ASIS_TBL=$1
TOBE_TBL=${2:-$1}

ROOT=$(cd "$(dirname "$0")/../.." && pwd)
ENV_FILE="$ROOT/.env.asis"
if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE not found" >&2
  exit 2
fi
# shellcheck disable=SC1090
while IFS='=' read -r k v; do
  case "$k" in ''|\#*) continue;; esac
  export "$k=$v"
done < "$ENV_FILE"

ASIS_COLS=$(sqlcmd -S "$ASIS_DB_HOST,$ASIS_DB_PORT" -d "$ASIS_DB_NAME" \
  -U "$ASIS_DB_USER" -P "$ASIS_DB_PASS" -C -W -h-1 \
  -Q "SET NOCOUNT ON; SELECT COLUMN_NAME + '|' + DATA_TYPE + '|' + ISNULL(CONVERT(VARCHAR(20), CHARACTER_MAXIMUM_LENGTH), '') FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='$ASIS_TBL' ORDER BY ORDINAL_POSITION;" \
  2>/dev/null | grep -v "^$" | sort)

TOBE_COLS=$(docker exec -i nscm-oracle bash -c "sqlplus -S -L 'scm_mgr/\"!SCMroqkf2026\"@//localhost:1521/FREEPDB1' <<'EOF' 2>/dev/null
SET HEADING OFF FEEDBACK OFF PAGESIZE 0 LINESIZE 200
SELECT COLUMN_NAME || '|' || DATA_TYPE || '|' || NVL(TO_CHAR(DATA_LENGTH), '') FROM USER_TAB_COLUMNS WHERE TABLE_NAME='$TOBE_TBL' ORDER BY COLUMN_ID;
EXIT
EOF" | grep -v "^$" | tr -d ' \r' | sort)

ASIS_FILE=$(mktemp); TOBE_FILE=$(mktemp)
trap "rm -f $ASIS_FILE $TOBE_FILE" EXIT
printf "%s\n" "$ASIS_COLS" > "$ASIS_FILE"
printf "%s\n" "$TOBE_COLS" > "$TOBE_FILE"

ASIS_N=$(wc -l < "$ASIS_FILE")
TOBE_N=$(wc -l < "$TOBE_FILE")
echo "=== Column inventory: $ASIS_TBL ($ASIS_N cols) vs $TOBE_TBL ($TOBE_N cols) ==="
echo ""
diff -u "$ASIS_FILE" "$TOBE_FILE" | head -100 || true
echo ""
if [ "$ASIS_N" -ne "$TOBE_N" ]; then
  echo "⚠️  Column count mismatch. Investigate before proceeding."
  exit 6
fi
