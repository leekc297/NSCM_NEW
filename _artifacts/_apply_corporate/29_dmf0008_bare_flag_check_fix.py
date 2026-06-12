#!/usr/bin/env python3
"""
DMF0008 SP body 의 bare `EXCEPTION_FLAG != 'Y'` (NVL 없는 형태) 도 NVL wrap.

진단:
  script 28 은 NVL(.., NULL) 패턴만 patch.
  REPAIR SP line 153 의 SUM(CASE WHEN STATUS_CODE IN ('U','E') AND A.EXCEPTION_FLAG != 'Y' THEN 1 ELSE 0 END) STATUS_CODE_
  는 bare != 'Y' 라 미patch.
  NULL EXCEPTION_FLAG row 가 모두 0 처리 → SUM=0 → STATUS_CODE_=0
  → flag=4 (정비필요) 필터 'STATUS_CODE_ > 0' 가 false → 0 rows.

Fix:
  EXCEPTION_FLAG != 'Y' / EXCEPTION_fLAG != 'Y' (typo) → NVL(EXCEPTION_FLAG, 'N') != 'Y'
  단 = 'Y' 패턴은 그대로 (정상 동작)
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

    # bare `<alias>.EXCEPTION_FLAG != 'Y'` 또는 `<alias>.EXCEPTION_fLAG != 'Y'`
    # NVL 이 이미 wrap 된 것은 매치 안 함 (앞에 NVL( 가 없도록 negative lookbehind)
    # 단순화: NVL( 가 앞에 있으면 skip 위해 \b 만 사용 + 본문 NVL( 포함 안 함
    pattern = re.compile(
        r"(?<!NVL\()(?<!,\s)([A-Za-z_]+\.)?EXCEPTION[_]?FL?AG\s*!=\s*'Y'",
        re.IGNORECASE,
    )

    def repl(m):
        alias = m.group(1) or ""
        return f"NVL({alias}EXCEPTION_FLAG, 'N') != 'Y'"

    matches = pattern.findall(src)
    patched = pattern.sub(repl, src)
    if patched == src:
        return f"[{name}] no bare pattern"

    cur = conn.cursor()
    try:
        cur.execute("CREATE OR REPLACE " + patched)
        conn.commit()
        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n", n=name)
        st = cur.fetchone()[0]
        return f"[{name}] patched {len(matches)} 곳 / STATUS={st}"
    except oracledb.DatabaseError as e:
        return f"[{name}] ERR: {str(e)[:150]}"
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

        # 검증
        cur = conn.cursor()
        for flag in ['4', '5', '6']:
            o1=cur.var(oracledb.DB_TYPE_CURSOR); ores=cur.var(oracledb.DB_TYPE_CURSOR)
            cur.callproc('DMF0008_GET_EDI_MST_REPAIR',
                         ['81','20260601','20260831','BMW',flag,'minyonglee1','DMF0008',o1,ores])
            rc1 = o1.getvalue()
            rows = rc1.fetchall() if rc1 else []
            print(f"[VERIFY] REPAIR BMW flag={flag}: rows={len(rows)}")
        cur.close()
    finally:
        conn.close()
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
