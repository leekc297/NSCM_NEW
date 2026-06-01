#!/usr/bin/env bash
# row_count_diff.sh — As-Is MSSQL vs To-Be Oracle 동일 테이블 row count 비교
#
# 사용:
#   ./row_count_diff.sh <TABLE_NAME> [TOBE_TABLE_NAME]
#
# 예:
#   ./row_count_diff.sh DM_MST_CONTRIBUTE_RATIO_DTL

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

ASIS_CNT=$(sqlcmd -S "$ASIS_DB_HOST,$ASIS_DB_PORT" -d "$ASIS_DB_NAME" \
  -U "$ASIS_DB_USER" -P "$ASIS_DB_PASS" -C -W -h-1 -y0 \
  -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM $ASIS_TBL;" 2>/dev/null | tr -d ' \r')

TOBE_CNT=$(docker exec -i nscm-oracle bash -c "sqlplus -S -L 'scm_mgr/\"!SCMroqkf2026\"@//localhost:1521/FREEPDB1' <<'EOF' 2>/dev/null
SET HEADING OFF FEEDBACK OFF PAGESIZE 0
SELECT COUNT(*) FROM $TOBE_TBL;
EXIT
EOF" | tr -d ' \r')

DIFF=$(( ASIS_CNT - TOBE_CNT ))
PCT="0"
if [ "$ASIS_CNT" -gt 0 ]; then
  PCT=$(awk "BEGIN{printf \"%.2f\", ($DIFF / $ASIS_CNT) * 100}")
fi

echo "=== Row count diff: $ASIS_TBL vs $TOBE_TBL ==="
printf "  As-Is  (MSSQL):  %10s\n" "$ASIS_CNT"
printf "  To-Be  (Oracle): %10s\n" "$TOBE_CNT"
printf "  Diff:            %10s  (%s%%)\n" "$DIFF" "$PCT"

if [ "$DIFF" -ne 0 ]; then
  echo ""
  echo "⚠️  Row count mismatch detected. Investigate before proceeding."
  exit 5
fi
