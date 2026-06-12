#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTE_MAIN_DATA 의 REPORT_GROUP3 컬럼 reference 6건 fix.

근본 원인:
  사내 DB 의 SCM_MST_SITE_ITEM (운영 테이블) 에 REPORT_GROUP3 컬럼 미존재
  (마이그레이션 시 제거됨, 히스토리 테이블 _H/_BK/_OLD 에만 잔존)
  → SP body 의 line 387/427/471/503/680/716 에 NVL(A.REPORT_GROUP3,...) 잔존 → INVALID

Fix 전략:
  1. USER_SOURCE 에서 body 추출 (CREATE OR REPLACE PROCEDURE prefix 제외)
  2. NVL(A.REPORT_GROUP3, ...) → '' (빈 문자열 literal) 로 대체
     - PRODUCT_GROUP alias 보존, 의미 = NULL/빈 (사내 schema 정합)
     - 동일 별칭 GROUP BY 도 보존
  3. CREATE OR REPLACE PROCEDURE 로 재정의
  4. 적용 후 INVALID → VALID 검증

⚠️ 자동 백업: USER_SOURCE → _diagnostics/dmf0043_main_data_before_<ts>.sql
"""
import re
import datetime
from pathlib import Path
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)
SP_NAME = "DMF0043_GET_CONTRIBUTE_MAIN_DATA"

BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
BACKUP_DIR.mkdir(parents=True, exist_ok=True)
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)


def fetch_user_source(conn, name: str) -> str:
    """USER_SOURCE 의 TEXT 모두 fetch → 결합"""
    cursor = conn.cursor()
    cursor.execute(
        "SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE",
        n=name,
    )
    lines = [row[0] or "" for row in cursor.fetchall()]
    cursor.close()
    return "".join(lines)


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = BACKUP_DIR / f"{SP_NAME}_before_{ts}.sql"
    log_file = LOG_DIR / f"{ts}_DMF0043_MAIN_DATA_REPORT_GROUP3_FIX.log"

    log_lines = [
        f"=== FIX: {SP_NAME} REPORT_GROUP3 references ===",
        f"  TIME: {datetime.datetime.now().isoformat()}",
        f"  BACKUP: {backup_file}",
    ]

    conn = oracledb.connect(**CONN_PARAMS)
    try:
        # 1. backup
        src = fetch_user_source(conn, SP_NAME)
        if not src:
            log_lines.append(f"[FAIL] {SP_NAME} not found in USER_SOURCE")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print(f"[FAIL] {SP_NAME} not found")
            return 1

        backup_file.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        log_lines.append(f"  Backup: {len(src)} chars")

        # 2. count references
        # USER_SOURCE 의 TEXT 의 single-quote literal: 4-quote escape (`''''` = empty literal in 동적 SQL)
        # 도 매치 가능하도록 `(?:''|[^'])*` 사용 (escape-aware literal body)
        ref_pattern = re.compile(r"NVL\(\s*A\.REPORT_GROUP3\s*,\s*'(?:''|[^'])*'\s*\)", re.I)
        matches = list(ref_pattern.finditer(src))
        log_lines.append(f"  REPORT_GROUP3 references (active, non-comment): {len(matches)}")
        for m in matches:
            log_lines.append(f"    @{m.start()}: {m.group(0)[:80]}")

        if not matches:
            log_lines.append("[INFO] No active references found — already patched?")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print("[INFO] No active references")
            return 0

        # 3. replace — preserve alias structure
        # Strategy: NVL(A.REPORT_GROUP3, '...') → '''' (4-quote = PL/SQL 안 동적 SQL string builder
        # 컨텍스트에서 SQL '' empty literal 의 escape). 다른 NVL(A.ATTRIBUTE2,'''') 등과 동일 패턴.
        # 2-quote 사용 시 PL/SQL parse 의 single quote 1개로 → 동적 SQL stray quote → ORA-00923
        patched = ref_pattern.sub("''''", src)
        log_lines.append(f"  Patched size: {len(patched)} chars (delta {len(patched)-len(src)})")

        # 4. CREATE OR REPLACE
        ddl = "CREATE OR REPLACE " + patched
        cursor = conn.cursor()
        try:
            cursor.execute(ddl)
            log_lines.append("  [OK] CREATE OR REPLACE PROCEDURE executed")
        except oracledb.DatabaseError as e:
            log_lines.append(f"  [ERR] {e}")
            # 컴파일 에러 시 USER_ERRORS 출력
            cursor.execute(
                "SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY SEQUENCE",
                n=SP_NAME,
            )
            for line, pos, text in cursor.fetchall():
                log_lines.append(f"    Line {line}:{pos}  {text}")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print(f"[ERR] compile failed — see {log_file}")
            return 2
        finally:
            cursor.close()

        # 5. verify STATUS
        cursor = conn.cursor()
        cursor.execute(
            "SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'",
            n=SP_NAME,
        )
        status_row = cursor.fetchone()
        cursor.close()
        status = status_row[0] if status_row else "?"
        log_lines.append(f"  Final STATUS: {status}")

        if status == "VALID":
            print(f"[OK] {SP_NAME} → VALID")
            log_lines.append("[OK] VALID")
        else:
            print(f"[WARN] {SP_NAME} STATUS = {status}")
            log_lines.append(f"[WARN] STATUS = {status}")

        conn.commit()
        return 0 if status == "VALID" else 2
    finally:
        log_file.write_text("\n".join(log_lines), encoding="utf-8")
        try:
            conn.close()
        except Exception:
            pass


if __name__ == "__main__":
    import sys
    sys.exit(main())
