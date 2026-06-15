#!/bin/bash
# SYS0013 클라우드 적용 — DB 만 (FE 별도 배포)
set -e
SCM_PWD=$1; APP_PWD=$2; DSN=$3
echo "=== Step 1: SCM_MGR — DDL + GRANT + META ==="
for f in ../02_DB_DDL/*.sql ../03_GRANT_SYNONYM/01_GRANT_SCMD_APP.sql ../04_META/*.sql; do
  echo "  apply: $f"
  tr -d '\r' < "$f" | sqlplus -L -S "SCM_MGR/\"$SCM_PWD\"@$DSN" || exit 1
done
echo "=== Step 2: SCMD_APP — SYNONYM ==="
tr -d '\r' < ../03_GRANT_SYNONYM/02_SYNONYM_SCMD_APP.sql | sqlplus -L -S "SCMD_APP/\"$APP_PWD\"@$DSN" || exit 1
echo "Done. FE: 01_FE/ 5 파일을 수동 배포."
