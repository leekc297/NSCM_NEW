#!/usr/bin/env python3
"""
V5 SP 신규 — V4 base + DTL JOIN 에서 PRODUCT_GROUP 매칭 제거.
이유: 'N' DTL 만 매칭하면 user saves 만큼만 보임 (1 row).
     cloud data (원통형/파우치형/각형/초소형/버튼) 도 활용하려면 PG 제외 JOIN.

영향:
  - 한 (dept,cust,biz,yyyymm) 의 5 PG row 모두 SUM 에 기여
  - 화면 PG 컬럼은 SITE_ITEM 의 'N' 그대로 (label only)
  - 데이터 row 수: 1 → 수십~수백 row 예상
"""
import re
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))
SRC = "DMF0043_GET_CONTRIBUTION_SALES_LIST_V4"
DST = "DMF0043_GET_CONTRIBUTION_SALES_LIST_V5"


def main():
    conn = oracledb.connect(**CONN)
    try:
        cur = conn.cursor()
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=SRC)
        src = "".join(r[0] or "" for r in cur.fetchall())
        cur.close()

        # 이름 변경
        src = re.sub(rf'\bPROCEDURE\s+(\s*"?){re.escape(SRC)}("?)',
                     rf'PROCEDURE \1{DST}\2', src, count=1, flags=re.IGNORECASE)

        # JOIN 의 A.PRODUCT_GROUP = B.PRODUCT_GROUP 제거
        # v_sql_text 안 JOIN 조건 (PL/SQL string concat)
        before = src
        src = re.sub(
            r"\s*AND\s+A\.PRODUCT_GROUP\s*=\s*B\.PRODUCT_GROUP\s*",
            " /* PG match removed for cloud data inclusion */ ",
            src,
            flags=re.IGNORECASE,
        )
        if src == before:
            print("[FAIL] PRODUCT_GROUP join 패턴 매치 0건")
            return 3
        print("[OK] PRODUCT_GROUP join 제거")

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

        # 메타 redirect V4 → V5
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
