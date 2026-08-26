# -*- coding: utf-8 -*-
"""BP 원장(DM_PLN_BP_FCST_C) 접근 형태 후보 비교 — 계획 형태 선정용.
채택 성적은 SP 안 실측으로만 판정 (단독재현 성적 채택 금지).
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
cur.execute("DELETE FROM SCM_MGR.GT_DM22_V_VERSION_NO")
cur.execute("INSERT INTO SCM_MGR.GT_DM22_V_VERSION_NO (VERSION_NO, TOBE_VERSION_NO) VALUES ('BP_M_20260810_V001', NULL)")
cur.execute("DELETE FROM SCM_MGR.GT_DM22_SELECT_MEASURE")
cur.execute("""INSERT INTO SCM_MGR.GT_DM22_SELECT_MEASURE (MEASURE, SORT_ORDER_NO)
               SELECT COLUMN_NAME, SORT_ORDER_NO FROM SCM_MGR.SCM_MST_SHEET_MEASURE
                WHERE PROGRAM_ID='DMF0051' AND SHEET_NAME='Biz Plan Waterfall' AND VALID_YN='Y'""")
cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_DM22_SELECT_MEASURE")
print("measures:", cur.fetchone()[0])

CAL = """INNER JOIN (SELECT CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM
              FROM SCM_MGR.SCM_SYS_CALENDAR_M
             WHERE (BASIS_YYYYMM >= '202608' AND BASIS_YYYYMM <= '202702')
             GROUP BY CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM) CAL
        ON CAL.BASIS_YYYYMM = A.YYYYMM"""
W = "WHERE A.YYYYMM >= '202608' AND A.YYYYMM <= '202702' AND A.DIVISION_ID = '40'"

CAND = {
    "AS-IS  IN (semi-join)": f"""
SELECT COUNT(*) FROM SCM_MGR.DM_PLN_BP_FCST_C A
 JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
 {CAL}
 {W} AND A.VERSION_NO IN (SELECT VERSION_NO FROM SCM_MGR.GT_DM22_V_VERSION_NO)""",

    "후보1  JOIN DISTINCT (버전 선행축소)": f"""
SELECT COUNT(*) FROM (SELECT DISTINCT VERSION_NO FROM SCM_MGR.GT_DM22_V_VERSION_NO) V
 JOIN SCM_MGR.DM_PLN_BP_FCST_C A ON A.VERSION_NO = V.VERSION_NO
 JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
 {CAL}
 {W}""",

    "후보2  EXISTS 상관": f"""
SELECT COUNT(*) FROM SCM_MGR.DM_PLN_BP_FCST_C A
 JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
 {CAL}
 {W} AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DM22_V_VERSION_NO V WHERE V.VERSION_NO = A.VERSION_NO)""",
}

for name, sql in CAND.items():
    print("\n" + "=" * 100)
    print(name)
    try:
        cur.execute("EXPLAIN PLAN SET STATEMENT_ID='X' FOR " + sql)
        cur.execute("SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('PLAN_TABLE','X','BASIC +ROWS +COST'))")
        for (l,) in cur.fetchall():
            print(l)
        cur.execute("DELETE FROM PLAN_TABLE WHERE STATEMENT_ID='X'")
    except Exception as e:
        print("ERR:", e)
con.rollback()
con.close()
