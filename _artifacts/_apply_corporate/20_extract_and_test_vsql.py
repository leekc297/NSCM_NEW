#!/usr/bin/env python3
"""
log 파일에서 [DUMP] SQL_H1/H2/H3/TAIL 추출 → file → Python execute → ORA 정확 위치.
"""
import re
from pathlib import Path
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)

LOG_DIR = Path(__file__).parent / "_logs"
OUT_DIR = Path(__file__).parent.parent / "_diagnostics"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def find_latest_dump_log():
    candidates = sorted(LOG_DIR.glob("*_DMF0043_VSQL_DUMP.log"), reverse=True)
    if not candidates:
        return None
    return candidates[0]


def extract_vsql(log_path: Path) -> str:
    text = log_path.read_text(encoding="utf-8", errors="replace")
    # [DUMP] SQL_H1: <content>\n[DUMP] SQL_H2: <content>\n...
    # 각 chunk 의 끝은 다음 [DUMP] line 직전까지
    parts = {}
    # 각 H1/H2/H3/TAIL 의 content 추출 (multiline)
    for key in ("SQL_H1", "SQL_H2", "SQL_H3", "SQL_TAIL"):
        m = re.search(rf'\[DUMP\] {key}: (.*?)(?=\n\[DUMP\] |\n===|\Z)', text, re.S)
        if m:
            parts[key] = m.group(1)
    # H1 + H2 + H3 만 합치면 전체 v_sql_text (TAIL 은 끝부분 중복 — 제외)
    sql = (parts.get("SQL_H1", "") or "") + (parts.get("SQL_H2", "") or "") + (parts.get("SQL_H3", "") or "")
    return sql, parts


def main():
    log_path = find_latest_dump_log()
    if not log_path:
        print("[FAIL] no dump log found")
        return 1
    print(f"Log: {log_path}")

    sql, parts = extract_vsql(log_path)
    print(f"H1 len={len(parts.get('SQL_H1',''))}, H2={len(parts.get('SQL_H2',''))}, H3={len(parts.get('SQL_H3',''))}, TAIL={len(parts.get('SQL_TAIL',''))}")
    print(f"Reconstructed v_sql_text len={len(sql)}")

    out_file = OUT_DIR / "DMF0043_vsql_dumped.sql"
    out_file.write_text(sql, encoding="utf-8")
    print(f"Saved: {out_file}")

    # Python 으로 직접 parse + execute
    conn = oracledb.connect(**CONN_PARAMS)
    cur = conn.cursor()
    print("\n=== Test 1: cursor.parse(sql) — syntax only ===")
    try:
        cur.parse(sql)
        print("[OK] parse OK")
    except oracledb.DatabaseError as e:
        err = str(e).strip()
        print(f"[ERR] {err}")
        # ORA fail offset 추출
        m = re.search(r'Help:.*?(?:position|line)\s*(\d+)', err, re.I)
        if m:
            pos = int(m.group(1))
            ctx_start = max(0, pos - 200)
            print(f"  Context around offset {pos}:")
            print(f"  ...{sql[ctx_start:pos+200]}...")

    print("\n=== Test 2: cursor.execute(sql) — actual execution ===")
    try:
        cur.execute(sql)
        rows = cur.fetchall()
        print(f"[OK] rows={len(rows)}")
        if rows:
            cols = [d[0] for d in cur.description]
            print(f"  Cols: {cols}")
            for r in rows[:2]:
                print(f"  Row: {str(r)[:300]}")
    except oracledb.DatabaseError as e:
        err = str(e).strip()
        print(f"[ERR] {err}")

    cur.close()
    conn.close()


if __name__ == "__main__":
    main()
