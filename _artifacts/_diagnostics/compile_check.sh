#!/usr/bin/env bash
# compile_check.sh — SP/PKG 컴파일 + USER_ERRORS 리포트 (파이프라인 Stage 2)
#   사용: ./compile_check.sh PKG_DMF0043      # 특정 object (PACKAGE/PROCEDURE 자동 판별)
#         ./compile_check.sh --all-invalid    # INVALID 전체 재컴파일 + 잔존 리포트
#   EXIT 조건: VALID + USER_ERRORS 0건 → exit 0 / 잔존 에러 → exit 2
set -euo pipefail
DIR=$(cd "$(dirname "$0")" && pwd)
TARGET="${1:?Usage: compile_check.sh <OBJECT_NAME|--all-invalid>}"
TMP=$(mktemp)
if [ "$TARGET" = "--all-invalid" ]; then
cat > "$TMP" << 'SQL'
SET SERVEROUTPUT ON SIZE UNLIMITED
BEGIN
  FOR r IN (SELECT object_name, object_type FROM user_objects
            WHERE status='INVALID' AND object_type IN ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION')
            ORDER BY object_type, object_name) LOOP
    BEGIN
      IF r.object_type = 'PACKAGE BODY' THEN
        EXECUTE IMMEDIATE 'ALTER PACKAGE '||r.object_name||' COMPILE BODY';
      ELSE
        EXECUTE IMMEDIATE 'ALTER '||r.object_type||' '||r.object_name||' COMPILE';
      END IF;
    EXCEPTION WHEN OTHERS THEN NULL; -- 잔존 에러는 아래 리포트에서 검출
    END;
  END LOOP;
END;
/
PROMPT === INVALID 잔존 ===
SELECT object_type, object_name FROM user_objects WHERE status='INVALID' ORDER BY 1,2;
PROMPT === USER_ERRORS ===
SELECT name, type, line, position, text FROM user_errors ORDER BY name, sequence;
SQL
else
cat > "$TMP" << SQL
SET SERVEROUTPUT ON
DECLARE v_type VARCHAR2(30);
BEGIN
  SELECT MIN(object_type) INTO v_type FROM user_objects
  WHERE object_name = UPPER('$TARGET') AND object_type IN ('PACKAGE','PROCEDURE','FUNCTION');
  IF v_type IS NULL THEN RAISE_APPLICATION_ERROR(-20001,'object not found: $TARGET'); END IF;
  EXECUTE IMMEDIATE 'ALTER '||v_type||' $TARGET COMPILE';
  IF v_type = 'PACKAGE' THEN
    BEGIN EXECUTE IMMEDIATE 'ALTER PACKAGE $TARGET COMPILE BODY'; EXCEPTION WHEN OTHERS THEN NULL; END;
  END IF;
END;
/
PROMPT === STATUS ===
SELECT object_type, object_name, status FROM user_objects WHERE object_name = UPPER('$TARGET');
PROMPT === USER_ERRORS ===
SELECT line, position, text FROM user_errors WHERE name = UPPER('$TARGET') ORDER BY sequence;
SQL
fi
OUT=$("$DIR/run_sql.sh" "$TMP"); rm -f "$TMP"
echo "$OUT"
if echo "$OUT" | grep -Eq "INVALID|^ *[0-9]+ +[0-9]+ +PLS-|ORA-" ; then
  echo "RESULT: FAIL (INVALID/에러 잔존 — Stage 2 EXIT 불충족)" >&2; exit 2
fi
echo "RESULT: PASS"
