#!/usr/bin/env python3
"""
DMF0008 SUMMARY + REPAIR SP body 의 NVL(EXCEPTION_FLAG, NULL) != 'Y' 사고 fix.

진단:
  AS-IS MSSQL: ISNULL(EXCEPTION_FLAG, '') != 'Y'   → NULL → '' → '' != 'Y' = TRUE
  TO-BE 잘못:  NVL(EXCEPTION_FLAG, NULL) != 'Y'     → NVL(NULL, NULL) = NULL → NULL != 'Y' = UNKNOWN → CASE THEN 1 ELSE 0 END = 0
  올바름:      NVL(EXCEPTION_FLAG, 'N') != 'Y'      → NULL → 'N' → 'N' != 'Y' = TRUE → 1

사용자 보고:
  Summary 정상 건수 = 0 (전체 데이터의 대부분이 EXCEPTION_FLAG=NULL → 사고로 ELSE 0)

대상 SP:
  DMF0008_GET_EDI_MST_SUMMARY (line 72, 73 — GSCM_MASTER_DATA, SUCCESS)
  DMF0008_GET_EDI_MST_REPAIR (동일 패턴 가능 — 검색)
"""
import re
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))
SP_LIST = ["DMF0008_GET_EDI_MST_SUMMARY", "DMF0008_GET_EDI_MST_REPAIR"]


def patch_sp(conn, name):
    cur = conn.cursor()
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=name)
    src = "".join(r[0] or "" for r in cur.fetchall())
    cur.close()

    # 패턴: NVL(<col>.EXCEPTION_FLAG, NULL)  (대소문자 무관, fLAG/FLAG 등)
    # → NVL(<col>.EXCEPTION_FLAG, 'N')
    pattern = re.compile(
        r"NVL\(\s*([A-Za-z_]+\.)?EXCEPTION[_]?FL?AG\s*,\s*NULL\s*\)",
        re.IGNORECASE,
    )
    matches = pattern.findall(src)
    patched = pattern.sub(
        lambda m: f"NVL({m.group(1) or ''}EXCEPTION_FLAG, 'N')",
        src,
    )
    if patched == src:
        return f"[{name}] no pattern (이미 fix 됐거나 형태 다름)"

    cur = conn.cursor()
    try:
        cur.execute("CREATE OR REPLACE " + patched)
        conn.commit()
        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n", n=name)
        st = cur.fetchone()[0]
        return f"[{name}] patched {len(matches)} 곳 / STATUS={st}"
    except oracledb.DatabaseError as e:
        return f"[{name}] ERR: {str(e)[:120]}"
    finally:
        cur.close()


def main():
    conn = oracledb.connect(**CONN)
    cur0 = conn.cursor()
    cur0.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
    cur0.close()
    try:
        for sp in SP_LIST:
            print(patch_sp(conn, sp))

        # 검증 — Summary 호출 결과
        cur = conn.cursor()
        o1=cur.var(oracledb.DB_TYPE_CURSOR); o3=cur.var(oracledb.DB_TYPE_CURSOR); ores=cur.var(oracledb.DB_TYPE_CURSOR)
        cur.callproc('DMF0008_GET_EDI_MST_SUMMARY', ['20260601','20260831','81','minyonglee1','DMF0008',o1,o3,ores])
        rc1 = o1.getvalue()
        rows = rc1.fetchall() if rc1 else []
        print(f"\n[VERIFY] SUMMARY rows: {len(rows)}")
        if rows:
            cols = [c[0] for c in rc1.description]
            print(f"  cols: {cols}")
            print(f"  first 3 rows:")
            for r in rows[:3]:
                print(f"    {r}")
        cur.close()
    finally:
        conn.close()
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
