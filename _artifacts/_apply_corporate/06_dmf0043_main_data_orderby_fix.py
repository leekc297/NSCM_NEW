#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTE_MAIN_DATA 의 OPEN O_RC1 FOR v_Query 에 ORDER BY 추가.

사용자 요구 (2026-06-11):
  부문, 팀, 고객군, 판매처, 제품군, 형태 순으로 정렬
  = DEPARTMENT_NAME, DEPT_NAME, END_CUST_REPORT, SOLDTO_CUST_REPORT, PRODUCT_GROUP, DM_BIZ_TYPE

Fix 전략:
  1. USER_SOURCE backup
  2. REGEXP: OPEN\\s+O_RC1\\s+FOR\\s+v_Query\\s*;
     → OPEN O_RC1 FOR v_Query || ' ORDER BY DEPARTMENT_NAME, DEPT_NAME, END_CUST_REPORT, SOLDTO_CUST_REPORT, PRODUCT_GROUP, DM_BIZ_TYPE';
  3. CREATE OR REPLACE
  4. STATUS=VALID 검증
  5. 멱등: 이미 ORDER BY 들어있으면 skip

⚠️ 자동 백업: _diagnostics/DMF0043_GET_CONTRIBUTE_MAIN_DATA_orderby_before_<ts>.sql
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
ORDER_BY = "DEPARTMENT_NAME, DEPT_NAME, END_CUST_REPORT, SOLDTO_CUST_REPORT, PRODUCT_GROUP, DM_BIZ_TYPE"

BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
BACKUP_DIR.mkdir(parents=True, exist_ok=True)
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)


def fetch_user_source(conn, name: str) -> str:
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
    backup_file = BACKUP_DIR / f"{SP_NAME}_orderby_before_{ts}.sql"
    log_file = LOG_DIR / f"{ts}_DMF0043_MAIN_DATA_ORDERBY_FIX.log"

    log_lines = [
        f"=== FIX: {SP_NAME} ORDER BY {ORDER_BY} ===",
        f"  TIME: {datetime.datetime.now().isoformat()}",
        f"  BACKUP: {backup_file}",
    ]

    conn = oracledb.connect(**CONN_PARAMS)
    try:
        src = fetch_user_source(conn, SP_NAME)
        if not src:
            print(f"[FAIL] {SP_NAME} not found")
            return 1

        backup_file.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        log_lines.append(f"  Backup: {len(src)} chars")

        # 멱등 — 이미 ORDER BY DEPARTMENT_NAME 들어있으면 skip
        if "ORDER BY DEPARTMENT_NAME, DEPT_NAME" in src:
            log_lines.append("[INFO] ORDER BY already applied — skip")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print("[INFO] ORDER BY already applied")
            return 0

        # OPEN\s+O_RC1\s+FOR\s+v_Query\s*; 매치
        # v_Query 가 동적 SQL 빌더의 마지막 변수. ORDER BY 를 동적 append.
        pattern = re.compile(
            r"(OPEN\s+O_RC1\s+FOR\s+v_Query)(\s*;)",
            re.I,
        )
        matches = list(pattern.finditer(src))
        log_lines.append(f"  OPEN O_RC1 FOR v_Query matches: {len(matches)}")
        for m in matches:
            log_lines.append(f"    @{m.start()}: {m.group(0)[:80]}")

        if not matches:
            log_lines.append("[FAIL] OPEN O_RC1 FOR v_Query 패턴 미매치")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print("[FAIL] pattern not found")
            return 2

        # ⚠️ PL/SQL 안 동적 SQL string literal escape (4-quote = SQL ' empty)
        # 'ORDER BY ...' 동적 SQL string 을 v_Query 에 || append.
        # PL/SQL source: v_Query || ' ORDER BY ...' — single-quote 1쌍 = literal start/end
        replacement = rf"\1 || ' ORDER BY {ORDER_BY}'\2"
        patched = pattern.sub(replacement, src)
        log_lines.append(f"  Patched size: {len(patched)} chars (delta {len(patched)-len(src)})")

        ddl = "CREATE OR REPLACE " + patched
        cursor = conn.cursor()
        try:
            cursor.execute(ddl)
            log_lines.append("  [OK] CREATE OR REPLACE executed")
        except oracledb.DatabaseError as e:
            log_lines.append(f"  [ERR] {e}")
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
            print(f"[OK] {SP_NAME} → VALID (ORDER BY {ORDER_BY})")
            log_lines.append("[OK] VALID")
        else:
            print(f"[WARN] {SP_NAME} STATUS = {status}")

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
