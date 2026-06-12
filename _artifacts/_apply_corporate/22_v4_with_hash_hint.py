#!/usr/bin/env python3
"""
V4 SP 신규 — V3 source + HASH 힌트 + DYNAMIC_SAMPLING + 메타 redirect V3 → V4.
락 회피 (새 이름).
"""
import re
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))
SRC = "DMF0043_GET_CONTRIBUTION_SALES_LIST_V3"
DST = "DMF0043_GET_CONTRIBUTION_SALES_LIST_V4"


def main():
    conn = oracledb.connect(**CONN)
    try:
        cur = conn.cursor()
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=SRC)
        src = "".join(r[0] or "" for r in cur.fetchall())
        cur.close()

        # SP 이름 변경
        src = re.sub(rf'\bPROCEDURE\s+(\s*"?){re.escape(SRC)}("?)',
                     rf'PROCEDURE \1{DST}\2', src, count=1, flags=re.IGNORECASE)

        # 힌트 추가: INSERT 의 SELECT 에
        hint = "/*+ LEADING(A) USE_HASH(I) USE_HASH(SC) USE_HASH(B) USE_HASH(C) USE_HASH(TEAM) DYNAMIC_SAMPLING(A 10) */ "
        p = re.compile(r"(\(\s*SELECT\s+)(SUBSTR\(A\.YYYYMMDD,1,6\)\s+AS\s+YYYYMM)", re.IGNORECASE)
        m = p.findall(src)
        if not m:
            print("[FAIL] hint 패턴 매치 0건")
            return 3
        src = p.sub(rf"\1{hint}\2", src)
        print(f"[OK] hint 추가 (매치 {len(m)})")

        # CREATE V4
        cur = conn.cursor()
        try:
            cur.execute("CREATE OR REPLACE " + src)
            conn.commit()
            print(f"[OK] CREATE {DST}")
        except oracledb.DatabaseError as e:
            print(f"[ERR] {str(e)[:200]}")
            return 4
        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n", n=DST)
        st = cur.fetchone()[0]
        cur.close()
        print(f"[STATUS] {st}")
        if st != "VALID":
            return 5

        # 메타 redirect V3 → V4
        cur = conn.cursor()
        cur.execute(
            "UPDATE SCM_ADM_API_M SET API_URL=:d WHERE API_ID='P_DMF0043_SALES_LIST_GET' AND API_URL=:s",
            d=DST, s=SRC,
        )
        ar = cur.rowcount
        cur.execute("UPDATE SCM_ADM_PROC_M SET PROC_NM=:d WHERE PROC_NM=:s", d=DST, s=SRC)
        pr = cur.rowcount
        conn.commit()
        cur.close()
        print(f"[META] API_M={ar} / PROC_M={pr}")
        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
