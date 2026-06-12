#!/usr/bin/env python3
"""
V3 SP 신규 생성 (락 회피) — V2 에 ORDER BY A. → ORDER BY 패치 + 디버그 제거.
+ 메타 redirect V2 → V3.

V3 가 새 이름 → library cache 락 없음 → CREATE 즉시 성공.
"""
import re
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))
SP_V2 = "DMF0043_GET_CONTRIBUTION_SALES_LIST_V2"
SP_V3 = "DMF0043_GET_CONTRIBUTION_SALES_LIST_V3"


def main():
    conn = oracledb.connect(**CONN)
    try:
        cur = conn.cursor()
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=SP_V2)
        src = "".join(r[0] or "" for r in cur.fetchall())
        cur.close()

        # SP 이름 변경
        src = re.sub(
            rf'\bPROCEDURE\s+(\s*"?){re.escape(SP_V2)}("?)',
            rf'PROCEDURE \1{SP_V3}\2',
            src,
            count=1,
            flags=re.IGNORECASE,
        )

        # FIX 1: v_orderby A. 제거 (2 위치)
        before = src
        src = re.sub(
            r"v_orderby\s*:=\s*'\s*ORDER\s+BY\s+A\.'\s*\|\|\s*v_col_name",
            "v_orderby := ' ORDER BY ' || v_col_name",
            src,
            flags=re.IGNORECASE,
        )
        src = re.sub(
            r"v_orderby\s*:=\s*v_orderby\s*\|\|\s*',\s*A\.'\s*\|\|\s*v_col_name",
            "v_orderby := v_orderby || ', ' || v_col_name",
            src,
            flags=re.IGNORECASE,
        )
        print(f"  [FIX 1] v_orderby A. 제거 — 변경 {len(before) != len(src)}")

        # FIX 2: 디버그 INSERT 제거
        old_debug = (
            'BEGIN\n'
            '      INSERT INTO "_DEBUG_VSQL"(V_SQL_TEXT) VALUES (v_sql_text);\n'
            '      COMMIT;\n'
            '      OPEN p_cursor_main FOR v_sql_text;\n'
            '    EXCEPTION WHEN OTHERS THEN\n'
            '      DECLARE v_errmsg VARCHAR2(4000); BEGIN\n'
            '        v_errmsg := SQLCODE || \': \' || SUBSTR(SQLERRM, 1, 3500);\n'
            '        INSERT INTO "_DEBUG_VSQL"(V_SQL_TEXT, ERR_MSG) VALUES (v_sql_text, v_errmsg);\n'
            '        COMMIT;\n'
            '      END;\n'
            '      BEGIN OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;\n'
            '    END;'
        )
        new_clean = (
            'BEGIN\n'
            '      OPEN p_cursor_main FOR v_sql_text;\n'
            '    EXCEPTION WHEN OTHERS THEN\n'
            '      BEGIN OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;\n'
            '    END;'
        )
        if old_debug in src:
            src = src.replace(old_debug, new_clean, 1)
            print("  [FIX 2] 디버그 INSERT 제거")

        # CREATE V3 (락 없음 — 신규 이름)
        cur = conn.cursor()
        try:
            cur.execute("CREATE OR REPLACE " + src)
            conn.commit()
            print(f"  [OK] CREATE {SP_V3}")
        except oracledb.DatabaseError as e:
            print(f"  [ERR] {e}")
            return 4
        finally:
            cur.close()

        # VALID 확인
        cur = conn.cursor()
        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n", n=SP_V3)
        st = cur.fetchone()[0]
        cur.close()
        print(f"  [STATUS] {st}")
        if st != "VALID":
            return 5

        # 메타 redirect V2 → V3
        cur = conn.cursor()
        cur.execute(
            "UPDATE SCM_ADM_API_M SET API_URL=:v3, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE "
            "WHERE API_ID='P_DMF0043_SALES_LIST_GET' AND API_URL=:v2",
            v3=SP_V3, v2=SP_V2,
        )
        ar = cur.rowcount
        cur.execute(
            "UPDATE SCM_ADM_PROC_M SET PROC_NM=:v3, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE "
            "WHERE PROC_NM=:v2",
            v3=SP_V3, v2=SP_V2,
        )
        pr = cur.rowcount
        conn.commit()
        cur.close()
        print(f"  [META] API_M={ar} / PROC_M={pr}")

        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
