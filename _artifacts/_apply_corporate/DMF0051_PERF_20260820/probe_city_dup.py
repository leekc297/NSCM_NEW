# -*- coding: utf-8 -*-
"""GT_DM51_SCM_CITY 중복이 최종 조인에서 행 증식(=SUM 왜곡)을 일으키는지 실측.
SP 실행 후 같은 세션에서 GTT 를 직접 조회 (GTT = ON COMMIT PRESERVE ROWS).
진단 SQL 도 set-based (선계산 GROUP BY + LEFT JOIN) — 상관 서브쿼리 금지.
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

VER = sys.argv[1] if len(sys.argv) > 1 else "CURRENT"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT PARAMS FROM SCM_MGR.SCM_COM_SQL_LOG WHERE LOG_SEQ=227122")
raw = cur.fetchone()[0].read()
J = lambda k: (re.search(r'"%s":"([^"]*)"' % k, raw) or [None, None])[1]
P = {k: J(k) for k in ["divisionId", "deptId", "endCustomer", "scmSiteId", "projectCode", "itemId",
                       "itemType", "fromYyyymmdd", "toYyyymmdd", "sesUserId", "plantSiteId", "bizType",
                       "owner", "cellYn", "userId", "mnuId"]}
ARGS = [P["divisionId"], P["deptId"] or "ALL", P["endCustomer"], P["scmSiteId"], P["projectCode"] or "",
        P["itemId"] or "", P["itemType"], P["fromYyyymmdd"], "20260817", P["toYyyymmdd"], P["sesUserId"],
        P["plantSiteId"], P["bizType"], P["owner"] or "", VER, P["cellYn"], "N", P["userId"], P["mnuId"]]
out = [con.cursor() for _ in range(3)]
cur.callproc("SCM_MGR.PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL", ARGS + out)
n = len(out[0].fetchall()) if out[0].description else 0
print(f"[SP 실행] ver={VER} rc1={n} 행")


def q(t, sql):
    cur.execute(sql)
    cols = [c[0] for c in cur.description]
    print(f"  {t}")
    print("    " + " | ".join(cols))
    for r in cur.fetchall():
        print("    " + " | ".join("" if x is None else str(x) for x in r))


q("GT_DM51_SCM_CITY 총행 / 조인키 distinct / 전컬럼 distinct", """
SELECT COUNT(*) TOT,
       COUNT(DISTINCT DIVISION_ID||'|'||SCM_SITE_ID||'|'||END_CUSTOMER||'|'||DEPT_ID) KEY_DISTINCT,
       COUNT(DISTINCT DIVISION_ID||'|'||SCM_SITE_ID||'|'||END_CUSTOMER||'|'||DEPT_ID||'|'||
             VMI_YN||'|'||CITY_NAME||'|'||COUNTRY_NAME||'|'||SOLDTO_CUSTOMER||'|'||VALID_YN) ROW_DISTINCT
  FROM SCM_MGR.GT_DM51_SCM_CITY""")

q("GT_DM51_RAW_DATA 행수", "SELECT COUNT(*) CNT FROM SCM_MGR.GT_DM51_RAW_DATA")

q("증식 실측 (BASE=RAW×SITE_ITEM, G 매칭 배수)", """
WITH BASE AS (
  SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.END_CUSTOMER, C.DEPT_ID CDEPT
    FROM SCM_MGR.GT_DM51_RAW_DATA A
    LEFT JOIN SCM_MGR.GT_DM51_SCM_MST_SITE_ITEM C
      ON A.DIVISION_ID=C.DIVISION_ID AND A.SCM_SITE_ID=C.SCM_SITE_ID
     AND A.PROJECT_CODE=C.PROJECT_CODE AND A.ITEM_ID=C.ITEM_ID),
GK AS (
  SELECT DIVISION_ID, SCM_SITE_ID, END_CUSTOMER, DEPT_ID, COUNT(*) CNT
    FROM SCM_MGR.GT_DM51_SCM_CITY
   GROUP BY DIVISION_ID, SCM_SITE_ID, END_CUSTOMER, DEPT_ID)
SELECT COUNT(*) BASE_ROWS,
       SUM(CASE WHEN G.CNT IS NULL THEN 0 ELSE 1 END) MATCHED_ROWS,
       NVL(MAX(G.CNT),0) MAX_DUP,
       SUM(NVL(G.CNT,1)) ROWS_AFTER_G
  FROM BASE B
  LEFT JOIN GK G
    ON G.DIVISION_ID = B.DIVISION_ID
   AND G.SCM_SITE_ID = B.SCM_SITE_ID
   AND G.END_CUSTOMER = CASE WHEN B.DIVISION_ID='40' THEN B.PROJECT_CODE ELSE B.END_CUSTOMER END
   AND G.DEPT_ID = B.CDEPT""")
con.close()
