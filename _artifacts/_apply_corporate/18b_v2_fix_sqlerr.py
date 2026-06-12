#!/usr/bin/env python3
"""V2 SP: SQLCODE/SQLERRM 을 PL/SQL 변수로 capture 후 INSERT (line 546 ORA-00984 fix)."""
import re
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))
SP = "DMF0043_GET_CONTRIBUTION_SALES_LIST_V2"

def main():
    conn = oracledb.connect(**CONN)
    cur0 = conn.cursor(); cur0.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 180"); cur0.close()
    try:
        cur = conn.cursor()
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=SP)
        src = "".join(r[0] or "" for r in cur.fetchall())
        cur.close()

        # 변환:
        #   EXCEPTION WHEN OTHERS THEN
        #     INSERT ... VALUES (v_sql_text, SQLCODE || ': ' || ...);
        #     COMMIT;
        # →
        #     EXCEPTION WHEN OTHERS THEN
        #     DECLARE v_errmsg VARCHAR2(4000); BEGIN
        #       v_errmsg := SQLCODE || ': ' || SUBSTR(SQLERRM, 1, 3500);
        #       INSERT INTO "_DEBUG_VSQL"(V_SQL_TEXT, ERR_MSG) VALUES (v_sql_text, v_errmsg);
        #       COMMIT;
        #     END;
        old = ('EXCEPTION WHEN OTHERS THEN\n'
               '      INSERT INTO "_DEBUG_VSQL"(V_SQL_TEXT, ERR_MSG) VALUES (v_sql_text, SQLCODE || \': \' || SUBSTR(SQLERRM, 1, 3500));\n'
               '      COMMIT;')
        new = ('EXCEPTION WHEN OTHERS THEN\n'
               '      DECLARE v_errmsg VARCHAR2(4000); BEGIN\n'
               '        v_errmsg := SQLCODE || \': \' || SUBSTR(SQLERRM, 1, 3500);\n'
               '        INSERT INTO "_DEBUG_VSQL"(V_SQL_TEXT, ERR_MSG) VALUES (v_sql_text, v_errmsg);\n'
               '        COMMIT;\n'
               '      END;')
        if old not in src:
            # 다른 줄바꿈 가능 — regex로
            p = re.compile(
                r'EXCEPTION WHEN OTHERS THEN\s*\n\s*INSERT INTO "_DEBUG_VSQL"\(V_SQL_TEXT, ERR_MSG\) VALUES \(v_sql_text, SQLCODE \|\| \': \' \|\| SUBSTR\(SQLERRM, 1, 3500\)\);\s*\n\s*COMMIT;',
                re.IGNORECASE,
            )
            m = p.search(src)
            if not m:
                print("[FAIL] 패턴 매치 0건"); return 3
            patched = src[:m.start()] + new + src[m.end():]
        else:
            patched = src.replace(old, new, 1)

        cur = conn.cursor()
        cur.execute("CREATE OR REPLACE " + patched)
        conn.commit()
        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n", n=SP)
        st = cur.fetchone()[0]
        cur.close()
        print(f"[OK] STATUS={st}")
        return 0 if st == "VALID" else 5
    finally:
        conn.close()

if __name__ == "__main__":
    import sys
    sys.exit(main())
