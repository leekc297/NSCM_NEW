#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTE_MAIN_DATA 의 line 427 patch:
GROUP BY 안의 `, ''` (이전 patch 결과 — REPORT_GROUP3 자리) 제거.
GROUP BY 에 literal 값은 invalid → 해당 항목 자체 삭제.

또한 line 약 700~720 의 비슷한 GROUP BY 패턴 (혹은 다른 곳) 도 점검.
"""
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


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = BACKUP_DIR / f"{SP_NAME}_before_groupby_{ts}.sql"

    conn = oracledb.connect(**CONN_PARAMS)
    cur = conn.cursor()
    cur.execute(
        "SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE",
        n=SP_NAME,
    )
    rows = cur.fetchall()
    cur.close()
    src = "".join((r[1] or "") for r in rows)
    backup_file.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
    print(f"Backup: {backup_file} ({len(src)} chars)")

    # Find lines containing only `, ''` or `, ''<comment>` (이전 patch 의 결과)
    # Target: 단독 line `\t\t     , ''` 그리고 GROUP BY 맥락
    # 안전하게: 모든 line 중 "GROUP BY" 컨텍스트 + ", ''" line 식별
    new_lines = []
    in_groupby = False
    removed = 0
    for line_no, text in rows:
        if not text:
            new_lines.append(text)
            continue

        upper = text.upper()
        # GROUP BY 시작
        if "GROUP BY" in upper:
            in_groupby = True
            new_lines.append(text)
            continue

        # GROUP BY 종료 (다음 SELECT / FROM / WHERE / ORDER BY / ) 도달)
        if in_groupby:
            stripped = text.strip().upper()
            # group by 종료 marker
            if stripped.startswith(("FROM ", "WHERE ", "ORDER BY", "UNION", "SELECT ", ")", ";", "HAVING ")):
                in_groupby = False

        # GROUP BY 안에서 , '' 형식 line 식별
        if in_groupby:
            stripped = text.strip()
            # ", ''" 또는 ", '' --comment"
            if stripped.startswith(", ''") or stripped == "''" or stripped.startswith("''"):
                # 제거 (전체 line 빈 line 으로)
                print(f"  Remove line {line_no}: {text.rstrip()[:100]}")
                new_lines.append("\n")
                removed += 1
                continue

        new_lines.append(text)

    if removed == 0:
        print("[INFO] No GROUP BY ', ''' lines found")
        return 0

    patched = "".join(new_lines)
    print(f"Removed: {removed} lines, new size: {len(patched)} (delta {len(patched)-len(src)})")

    ddl = "CREATE OR REPLACE " + patched
    try:
        cur = conn.cursor()
        cur.execute(ddl)
        conn.commit()
        cur.close()
        print("[OK] CREATE OR REPLACE")
    except oracledb.DatabaseError as e:
        print(f"[ERR] {e}")
        return 2

    cur = conn.cursor()
    cur.execute(
        "SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'",
        n=SP_NAME,
    )
    st = cur.fetchone()
    print(f"STATUS: {st[0] if st else '?'}")
    cur.close()

    # callproc test
    print("\n=== callproc test (DMF0043_GET_CONTRIBUTE_MAIN_DATA 2024/12) ===")
    cur = conn.cursor()
    rc = cur.var(oracledb.CURSOR)
    try:
        cur.callproc(SP_NAME, ["2024", "12", "ALL", "N", "minyonglee1", "", rc])
        c = rc.getvalue()
        rows_main = sum(1 for _ in c) if c else 0
        print(f"  main: {rows_main} rows")
        if c: c.close()
        print("[OK] SP 호출 정상")
    except oracledb.DatabaseError as e:
        print(f"  [ERR] {e}")
    cur.close()
    conn.close()


if __name__ == "__main__":
    main()
