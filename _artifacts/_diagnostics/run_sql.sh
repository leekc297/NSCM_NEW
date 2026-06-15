#!/usr/bin/env bash
# run_sql.sh — Oracle 에 SQL 파일/구문을 1회 실행 (docker exec sqlplus 경유)
#   사용: ./run_sql.sh <file.sql>           # 파일 실행
#         echo "SELECT ..." | ./run_sql.sh  # stdin 실행
#   접속: 환경변수 ORA_CONN 우선 (예: SCM_MGR/"pwd"@10.20.100.153:2521/ESSCMD)
#         없으면 ROOT/.env.asis 의 TOBE_* 로 로컬 Docker 접속 구성
#   주의: CRLF 는 자동 제거 (tr -d '\r') — 룰 db-corporate-apply §1
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
if [ -z "${ORA_CONN:-}" ]; then
  ENV_FILE="$ROOT/.env.asis"
  [ -f "$ENV_FILE" ] && . "$ENV_FILE"
  ORA_CONN="${TOBE_DB_USER:?ORA_CONN 또는 .env.asis 필요}/\"${TOBE_DB_PASS}\"@${TOBE_DB_HOST:-localhost}:${TOBE_DB_PORT:-1521}/${TOBE_DB_PDB:-FREEPDB1}"
fi
SRC="${1:-/dev/stdin}"
{ cat "$SRC"; printf "\nEXIT;\n"; } | tr -d '\r' | \
  docker exec -i nscm-oracle bash -c "sqlplus -L -S '$ORA_CONN'"
