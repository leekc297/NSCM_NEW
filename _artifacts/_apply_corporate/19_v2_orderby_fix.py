#!/usr/bin/env python3
"""
V2 SP: UNION ALL 의 ORDER BY 에 `A.` prefix 제거 (Oracle ORA-00904 fix) + 디버그 INSERT 제거.

진단:
  _DEBUG_VSQL.ERR_MSG = `-904: ORA-00904: "A"."DM_BIZ_TYPE": 부적합한 식별자`

  v_sql_text 의 마지막 ORDER BY (UNION ALL 직후) 가 `ORDER BY A.YYYYMM, ..., A.DM_BIZ_TYPE`.
  Oracle 의 UNION ALL ORDER BY 는 컬럼명 또는 position 만 허용 — 테이블 alias 불허.
  MSSQL 에서는 동작 (사내 변환 시 SP body 그대로 옮김 — 차이 미인지).

Fix:
  1) v_orderby 구성에서 `A.` prefix 제거
     기존: SET @v_orderby = ' ORDER BY A.' + @v_col_name
     수정: SET @v_orderby = ' ORDER BY ' + @v_col_name
     동일 패턴 누적 부분도 변경
  2) 디버그 INSERT 제거 (이제 진단 완료)
"""
import re
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))
SP = "DMF0043_GET_CONTRIBUTION_SALES_LIST_V2"


def main():
    conn = oracledb.connect(**CONN)
    cur0 = conn.cursor()
    cur0.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 180")
    cur0.close()
    try:
        cur = conn.cursor()
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=SP)
        src = "".join(r[0] or "" for r in cur.fetchall())
        cur.close()

        # FIX 1: v_orderby 구성에서 'A.' 제거 (오라클 PL/SQL string 안 — 따옴표 escape '')
        # 패턴 a (초기): v_orderby := ' ORDER BY A.' || v_col_name;
        # 패턴 b (누적): v_orderby := v_orderby || ', A.' || v_col_name;
        patched = re.sub(
            r"v_orderby\s*:=\s*'\s*ORDER\s+BY\s+A\.'\s*\|\|\s*v_col_name",
            "v_orderby := ' ORDER BY ' || v_col_name",
            src,
            flags=re.IGNORECASE,
        )
        patched = re.sub(
            r"v_orderby\s*:=\s*v_orderby\s*\|\|\s*',\s*A\.'\s*\|\|\s*v_col_name",
            "v_orderby := v_orderby || ', ' || v_col_name",
            patched,
            flags=re.IGNORECASE,
        )

        if patched == src:
            print("[WARN] v_orderby A. 패턴 매치 0건 — SP body 검토 필요")
            return 3

        # FIX 2: 디버그 INSERT 제거 (script 18b 적용 본)
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
        if old_debug in patched:
            patched = patched.replace(old_debug, new_clean, 1)
            print("[OK] 디버그 INSERT 제거")
        else:
            print("[INFO] 디버그 INSERT 매치 0건 (이미 제거됐거나 형태 다름)")

        cur = conn.cursor()
        cur.execute("CREATE OR REPLACE " + patched)
        conn.commit()
        cur.execute(
            "SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'",
            n=SP,
        )
        st = cur.fetchone()[0]
        cur.close()
        print(f"[OK] V2 STATUS={st}")
        return 0 if st == "VALID" else 5
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
