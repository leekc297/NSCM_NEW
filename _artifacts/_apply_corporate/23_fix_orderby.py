#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTION_SALES_LIST 의 line 187:
  v_orderby := ' ORDER BY A.' || v_col_name;
→
  v_orderby := ' ORDER BY ' || v_col_name;

근본 원인: UNION ALL result 의 ORDER BY 에 source alias 'A.' 직접 참조 → ORA-00904

Backup → REPLACE → CREATE OR REPLACE → VALID 검증 → SP 직접 호출 test
"""
import datetime
import re
from pathlib import Path
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)
SP_NAME = "DMF0043_GET_CONTRIBUTION_SALES_LIST"

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
    backup_file = BACKUP_DIR / f"{SP_NAME}_before_orderby_fix_{ts}.sql"
    log_file = LOG_DIR / f"{ts}_DMF0043_ORDERBY_FIX.log"
    log = []
    def add(msg):
        log.append(msg)
        print(msg)

    conn = oracledb.connect(**CONN_PARAMS)
    try:
        add(f"=== Phase 1: Backup ===")
        src = fetch_user_source(conn, SP_NAME)
        backup_file.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        add(f"  Backup: {backup_file} ({len(src)} chars)")

        add(f"\n=== Phase 2: REPLACE 'ORDER BY A.' → 'ORDER BY ' ===")
        target = "' ORDER BY A.' || v_col_name"
        replacement = "' ORDER BY ' || v_col_name"
        count_before = src.count(target)
        add(f"  Target occurrences: {count_before}")
        if count_before == 0:
            add(f"  [INFO] Already patched or pattern not found")
            log_file.write_text("\n".join(log), encoding="utf-8")
            return 0

        patched = src.replace(target, replacement)
        add(f"  Patched size: {len(patched)} (delta {len(patched)-len(src)})")

        add(f"\n=== Phase 3: CREATE OR REPLACE PROCEDURE ===")
        ddl = "CREATE OR REPLACE " + patched
        try:
            cur = conn.cursor()
            cur.execute(ddl)
            conn.commit()
            cur.close()
            add(f"  [OK] CREATE OR REPLACE")
        except oracledb.DatabaseError as e:
            add(f"  [ERR] {e}")
            log_file.write_text("\n".join(log), encoding="utf-8")
            return 2

        add(f"\n=== Phase 4: STATUS 검증 ===")
        cur = conn.cursor()
        cur.execute(
            "SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'",
            n=SP_NAME,
        )
        st = cur.fetchone()
        status = st[0] if st else "?"
        add(f"  STATUS: {status}")
        cur.close()
        if status != "VALID":
            add(f"  [WARN] STATUS = {status}")

        add(f"\n=== Phase 5: SP 직접 호출 test (DIV=40, VER_SEQ=8, R_B_20250820_V008_C) ===")
        cur = conn.cursor()
        cur.callproc("DBMS_OUTPUT.ENABLE", [None])
        rc_main = cur.var(oracledb.CURSOR)
        rc_sort = cur.var(oracledb.CURSOR)
        rc_cnt = cur.var(oracledb.CURSOR)
        try:
            cur.callproc(
                SP_NAME,
                ["40", "8", "R_B_20250820_V008_C", "", "", "", "N", "N", "minyonglee1",
                 rc_main, rc_sort, rc_cnt],
            )
            add(f"  [OK] callproc 완료")

            for name, cur_var in [("main", rc_main), ("sort", rc_sort), ("cnt", rc_cnt)]:
                cv = cur_var.getvalue()
                if cv is None:
                    add(f"  {name}: None")
                    continue
                rows = cv.fetchmany(3)
                cols = [d[0] for d in cv.description] if cv.description else []
                remaining = sum(1 for _ in cv)
                total = len(rows) + remaining
                add(f"  {name}: total {total} rows, cols={cols[:10]}")
                for r in rows:
                    add(f"    Row: {str(r)[:250]}")
                cv.close()
        except oracledb.DatabaseError as e:
            add(f"  [ERR] {e}")
        cur.close()
    finally:
        log_file.write_text("\n".join(log), encoding="utf-8")
        try:
            conn.close()
        except Exception:
            pass

    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
