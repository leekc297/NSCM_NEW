#!/usr/bin/env bash
# sp_body_diff.sh — As-Is MSSQL SP body vs To-Be Oracle PKG body diff
#
# 사용:
#   ./sp_body_diff.sh <ASIS_SP_NAME> <TOBE_PKG_NAME> [TOBE_PROC_NAME]
#
# 예:
#   ./sp_body_diff.sh "P_DMF0043_GET_CONTRIBUTE_MAIN_DATA" "PKG_DMF0043"
#
# Pre-condition:
#   - 프로젝트 루트의 .env.asis 존재
#   - sqlcmd 설치 (MSSQL CLI)
#   - docker exec nscm-oracle sqlplus 작동
#
# 출력: stdout 에 통합 diff (As-Is = -, To-Be = +)

set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <ASIS_SP_NAME> <TOBE_PKG_NAME> [TOBE_PROC_NAME]" >&2
  exit 1
fi

ASIS_SP=$1
TOBE_PKG=$2
TOBE_PROC=${3:-$ASIS_SP}

ROOT=$(cd "$(dirname "$0")/../.." && pwd)
ENV_FILE="$ROOT/.env.asis"
if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE not found" >&2
  exit 2
fi
# shellcheck disable=SC1090
# Load .env.asis values, supporting unquoted spaces (e.g. ODBC Driver 17 for SQL Server)
while IFS='=' read -r k v; do
  case "$k" in ''|\#*) continue;; esac
  export "$k=$v"
done < "$ENV_FILE"

# As-Is body
ASIS_OUT=$(mktemp)
trap "rm -f $ASIS_OUT" EXIT
sqlcmd -S "$ASIS_DB_HOST,$ASIS_DB_PORT" -d "$ASIS_DB_NAME" \
  -U "$ASIS_DB_USER" -P "$ASIS_DB_PASS" -C -W -h-1 -y0 -Y0 \
  -Q "SET NOCOUNT ON; SELECT definition FROM sys.sql_modules WHERE object_id = OBJECT_ID('$ASIS_SP');" \
  > "$ASIS_OUT" 2>&1 || { echo "ERROR: As-Is sqlcmd failed:" >&2; cat "$ASIS_OUT" >&2; exit 3; }

# To-Be body
TOBE_OUT=$(mktemp)
trap "rm -f $ASIS_OUT $TOBE_OUT" EXIT
docker exec -i nscm-oracle bash -c "sqlplus -S -L 'scm_mgr/\"!SCMroqkf2026\"@//localhost:1521/FREEPDB1' <<'EOF' > /tmp/tobe.txt
SET HEADING OFF FEEDBACK OFF PAGESIZE 0 LINESIZE 32767 LONG 5000000 LONGCHUNKSIZE 32767 TRIMSPOOL ON
SELECT TEXT FROM USER_SOURCE WHERE NAME='$TOBE_PKG' AND TYPE='PACKAGE BODY' ORDER BY LINE;
EXIT
EOF
cat /tmp/tobe.txt" > "$TOBE_OUT" 2>&1 || { echo "ERROR: To-Be sqlplus failed:" >&2; cat "$TOBE_OUT" >&2; exit 4; }

echo "=== ASIS: $ASIS_SP @ $ASIS_DB_NAME ==="
echo "=== TOBE: $TOBE_PKG.$TOBE_PROC @ FREEPDB1 ==="
echo ""
diff -u "$ASIS_OUT" "$TOBE_OUT" | head -200 || true
echo ""
echo "(Full diff truncated to 200 lines. Use 'diff -u <asis> <tobe>' for complete output.)"
