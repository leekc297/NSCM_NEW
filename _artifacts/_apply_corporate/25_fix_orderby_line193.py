#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTION_SALES_LIST 의 line 193 추가 patch:
  v_orderby := v_orderby || ', A.' || v_col_name;
→
  v_orderby := v_orderby || ', ' || v_col_name;

Phase 1 (이전 23 script) 에서 line 187 만 patched. 후속 ORDER BY 컬럼은 ', A.' 잔존 → 동일 ORA-00904.
"""
import datetime
from pathlib import Path
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)
SP_NAME = "DMF0043_GET_CONTRIBUTION_SALES_LIST"
BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
LOG_DIR = Path(__file__).parent / "_logs"


def fetch_user_source(conn, name: str) -> str:
    cur = conn.cursor()
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=name)
    lines = [r[0] or "" for r in cur.fetchall()]
    cur.close()
    return "".join(lines)


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = BACKUP_DIR / f"{SP_NAME}_before_line193_{ts}.sql"
    log_file = LOG_DIR / f"{ts}_DMF0043_LINE193_FIX.log"
    log = []
    def add(m):
        log.append(m); print(m)

    conn = oracledb.connect(**CONN_PARAMS)
    try:
        src = fetch_user_source(conn, SP_NAME)
        backup_file.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        add(f"Backup: {backup_file} ({len(src)} chars)")

        # line 193 patch
        target = "v_orderby := v_orderby || ', A.' || v_col_name"
        replacement = "v_orderby := v_orderby || ', ' || v_col_name"
        cnt = src.count(target)
        add(f"line 193 target occurrences: {cnt}")
        if cnt == 0:
            add("[INFO] Already patched")
            log_file.write_text("\n".join(log), encoding="utf-8")
            return 0
        patched = src.replace(target, replacement)
        add(f"Patched size: {len(patched)} (delta {len(patched)-len(src)})")

        # CREATE OR REPLACE
        try:
            cur = conn.cursor()
            cur.execute("CREATE OR REPLACE " + patched)
            conn.commit()
            cur.close()
            add("[OK] CREATE OR REPLACE")
        except oracledb.DatabaseError as e:
            add(f"[ERR] {e}")
            return 2

        # STATUS
        cur = conn.cursor()
        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'", n=SP_NAME)
        st = cur.fetchone()
        add(f"STATUS: {st[0] if st else '?'}")
        cur.close()

        # SP 호출 test
        add("\n=== SP 호출 test (DIV=40, VER_SEQ=8, R_B_20250820_V008_C) ===")
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
            add("[OK] callproc 완료")
            for name, cv in [("main", rc_main), ("sort", rc_sort), ("cnt", rc_cnt)]:
                c = cv.getvalue()
                if c is None:
                    add(f"  {name}: None"); continue
                rows = c.fetchmany(3)
                cols = [d[0] for d in c.description] if c.description else []
                remaining = sum(1 for _ in c)
                total = len(rows) + remaining
                add(f"  {name}: total {total} rows")
                add(f"    cols: {cols[:12]}")
                for r in rows:
                    add(f"    Row: {str(r)[:200]}")
                c.close()
        except oracledb.DatabaseError as e:
            add(f"[ERR] {e}")
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
