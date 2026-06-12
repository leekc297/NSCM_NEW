#!/usr/bin/env python3
"""
V2 SP: v_sql_text 를 _DEBUG_VSQL 테이블에 INSERT + 실 OPEN 의 EXCEPTION 메시지도 기록.
silent 0 rows 사고 진단용.

절차:
  1) CREATE TABLE _DEBUG_VSQL (id, ts, v_sql_text, err_msg) (없으면)
  2) SP 의 OPEN p_cursor_main FOR v_sql_text 직전에 INSERT 추가
  3) EXCEPTION 절에서 SQLERRM 도 INSERT
  4) 사용자 재테스트 → _DEBUG_VSQL 조회로 원인 파악
"""
import re, datetime
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
        # 디버그 테이블 생성 (재실행 안전)
        try:
            cur.execute("""
                CREATE TABLE "_DEBUG_VSQL" (
                    ID NUMBER GENERATED ALWAYS AS IDENTITY,
                    TS TIMESTAMP DEFAULT SYSTIMESTAMP,
                    V_SQL_TEXT CLOB,
                    ERR_MSG VARCHAR2(4000)
                )
            """)
            conn.commit()
            print("[OK] _DEBUG_VSQL 테이블 생성")
        except oracledb.DatabaseError as e:
            if "ORA-00955" in str(e):  # already exists
                print("[INFO] _DEBUG_VSQL 이미 존재 — 재사용")
            else:
                print(f"[WARN] 테이블 생성: {e}")
        cur.close()

        # SP source fetch
        cur = conn.cursor()
        cur.execute(
            "SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE",
            n=SP,
        )
        src = "".join(r[0] or "" for r in cur.fetchall())
        cur.close()

        # OPEN p_cursor_main FOR v_sql_text; 직전에 INSERT 추가
        # 패턴: BEGIN\n      OPEN p_cursor_main FOR v_sql_text;
        old = "BEGIN\n      OPEN p_cursor_main FOR v_sql_text;\n    EXCEPTION WHEN OTHERS THEN\n      BEGIN OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;\n    END;"
        new = """DECLARE v_errmsg VARCHAR2(4000); BEGIN
      INSERT INTO \"_DEBUG_VSQL\"(V_SQL_TEXT) VALUES (v_sql_text);
      COMMIT;
      OPEN p_cursor_main FOR v_sql_text;
    EXCEPTION WHEN OTHERS THEN
      v_errmsg := SQLCODE || ': ' || SUBSTR(SQLERRM, 1, 3500);
      INSERT INTO \"_DEBUG_VSQL\"(V_SQL_TEXT, ERR_MSG) VALUES (v_sql_text, v_errmsg);
      COMMIT;
      BEGIN OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;
    END;"""
        # fallback pattern (실제 source line breaks 따라 다를 수 있음)
        if old in src:
            patched = src.replace(old, new, 1)
            print("[OK] 정확 매치 1건")
        else:
            # 다른 줄바꿈 패턴 try
            p = re.compile(
                r"BEGIN\s*\n\s*OPEN\s+p_cursor_main\s+FOR\s+v_sql_text;\s*\n\s*EXCEPTION\s+WHEN\s+OTHERS\s+THEN\s*\n\s*BEGIN\s+OPEN\s+p_cursor_main\s+FOR\s+SELECT\s+NULL\s+AS\s+DUMMY\s+FROM\s+DUAL\s+WHERE\s+1=0;\s+EXCEPTION\s+WHEN\s+OTHERS\s+THEN\s+NULL;\s+END;\s*\n\s*END;",
                re.IGNORECASE,
            )
            m = p.search(src)
            if not m:
                print("[FAIL] 패턴 매치 0건")
                return 3
            patched = src[:m.start()] + new + src[m.end():]
            print("[OK] 정규식 매치")

        cur = conn.cursor()
        cur.execute("CREATE OR REPLACE " + patched)
        conn.commit()
        cur.execute(
            "SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'",
            n=SP,
        )
        st = cur.fetchone()[0]
        cur.close()
        print(f"[OK] V2 patched, STATUS={st}")
        return 0 if st == "VALID" else 5
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
