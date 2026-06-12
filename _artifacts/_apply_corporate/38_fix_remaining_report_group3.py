#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTE_MAIN_DATA 의 REPORT_GROUP3 추가 patch.
이전 fix (05_*) 는 NVL(A.REPORT_GROUP3, '') 형식만 잡았고
escape quote 형식 NVL(A.REPORT_GROUP3, '''') 등 잔존.

전략: ALL `A.REPORT_GROUP3` reference (NVL wrapper 안/밖 모두) → 'NULL'
- 단 주석 line (`--` 또는 `/*..*/` 안) 제외
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
SP_NAME = "DMF0043_GET_CONTRIBUTE_MAIN_DATA"
BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
BACKUP_DIR.mkdir(parents=True, exist_ok=True)


def fetch_source_lines(conn, name):
    cur = conn.cursor()
    cur.execute(
        "SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE",
        n=name,
    )
    rows = cur.fetchall()
    cur.close()
    return rows


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = BACKUP_DIR / f"{SP_NAME}_before_remaining_{ts}.sql"

    conn = oracledb.connect(**CONN_PARAMS)
    try:
        rows = fetch_source_lines(conn, SP_NAME)
        src = "".join((r[1] or "") for r in rows)
        backup_file.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        print(f"Backup: {backup_file} ({len(src)} chars, {len(rows)} lines)")

        # 1. 잔존 REPORT_GROUP3 reference 식별 (line 별, 주석 제외)
        active_lines = []
        for line_no, text in rows:
            if not text:
                continue
            if "REPORT_GROUP3" not in text.upper():
                continue
            stripped = text.lstrip()
            if stripped.startswith("--"):
                continue  # 주석 line
            active_lines.append((line_no, text))

        print(f"\nActive REPORT_GROUP3 references (non-comment): {len(active_lines)}")
        for ln, t in active_lines:
            print(f"  Line {ln}: {t[:120].rstrip()}")

        if not active_lines:
            print("[INFO] No active references — already patched")
            return 0

        # 2. patch — 광범위 regex (escape quote, single quote 모두):
        #   NVL(A.REPORT_GROUP3, <whatever quote pattern>) → ''
        #   A.REPORT_GROUP3 단독 → NULL
        pat1 = re.compile(
            r"NVL\s*\(\s*A\.REPORT_GROUP3\s*,\s*'+[^()]*?'+\s*\)",
            re.I,
        )
        # 단독 (rare): A.REPORT_GROUP3 → NULL
        pat2 = re.compile(r"\bA\.REPORT_GROUP3\b", re.I)

        # line 별 patch — 주석 line 은 건너뜀
        new_lines = []
        patched_count = 0
        for line_no, text in rows:
            if not text:
                new_lines.append(text)
                continue
            stripped = text.lstrip()
            if stripped.startswith("--"):
                new_lines.append(text)
                continue
            # 우선 NVL wrapper
            new_text, n1 = pat1.subn("''", text)
            # 단독 (NVL wrapper 이미 변환됐으면 0)
            new_text, n2 = pat2.subn("NULL", new_text)
            if n1 + n2 > 0:
                patched_count += n1 + n2
                print(f"  Patched line {line_no} ({n1} NVL + {n2} single): {new_text[:120].rstrip()}")
            new_lines.append(new_text)

        if patched_count == 0:
            print("[INFO] No patches made (regex no match)")
            return 0

        patched_src = "".join(new_lines)
        print(f"\nTotal patches: {patched_count}, new size: {len(patched_src)} (delta {len(patched_src)-len(src)})")

        ddl = "CREATE OR REPLACE " + patched_src
        try:
            cur = conn.cursor()
            cur.execute(ddl)
            conn.commit()
            cur.close()
            print("[OK] CREATE OR REPLACE")
        except oracledb.DatabaseError as e:
            print(f"[ERR] {e}")
            return 2

        # STATUS
        cur = conn.cursor()
        cur.execute(
            "SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'",
            n=SP_NAME,
        )
        st = cur.fetchone()
        print(f"STATUS: {st[0] if st else '?'}")
        cur.close()

        # 직접 호출 test
        print("\n=== callproc test (DMF0043_GET_CONTRIBUTE_MAIN_DATA 2024/12) ===")
        cur = conn.cursor()
        rc = cur.var(oracledb.CURSOR)
        try:
            cur.callproc(
                SP_NAME,
                ["2024", "12", "ALL", "N", "minyonglee1", "", rc],
            )
            c = rc.getvalue()
            rows_main = sum(1 for _ in c) if c else 0
            print(f"  main: {rows_main} rows")
            if c: c.close()
            print("[OK] SP 호출 정상")
        except oracledb.DatabaseError as e:
            print(f"  [ERR] {e}")
        cur.close()
    finally:
        try:
            conn.close()
        except Exception:
            pass

    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
