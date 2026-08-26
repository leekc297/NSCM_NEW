# -*- coding: utf-8 -*-
"""STATISTICS_LEVEL=ALL 세션에서 SP 실행 → 최종 동적 SQL 의 row-source A-Time/A-Rows 실측.
계측 오버헤드가 붙으므로 '어디에 시간이 쏠리는가'(구성비) 판정 전용. 채택 성적은 별도 측정.
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
cur.execute("ALTER SESSION SET STATISTICS_LEVEL = ALL")
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
print(f"[SP] ver={VER} rc1={n}")

cur.execute("""SELECT SQL_ID FROM V$SQL WHERE PARSING_SCHEMA_NAME='SCM_MGR' AND SQL_TEXT LIKE '%T_DM51_WF%'
               AND SQL_TEXT NOT LIKE '%V$SQL%' ORDER BY LAST_ACTIVE_TIME DESC FETCH FIRST 1 ROWS ONLY""")
sid = cur.fetchone()[0]
print("최종 동적 SQL SQL_ID =", sid)
cur.execute("SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(:1, NULL, 'ALLSTATS LAST'))", [sid])
for (l,) in cur.fetchall():
    print(l)

print("\n[SP 내부 문장별 A-Time — PKG_DMF0051 귀속]")
cur.execute("""
SELECT S.SQL_ID, ROUND(S.ELAPSED_TIME/1e6,2) ELA, S.BUFFER_GETS, S.DISK_READS, S.ROWS_PROCESSED, S.PROGRAM_LINE#,
       SUBSTR(REPLACE(S.SQL_TEXT,CHR(10),' '),1,90)
FROM V$SQL S
WHERE S.PARSING_SCHEMA_NAME='SCM_MGR'
  AND S.PROGRAM_ID=(SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0051' AND OBJECT_TYPE='PACKAGE BODY')
  AND S.LAST_ACTIVE_TIME > SYSDATE - 5/1440 AND S.ELAPSED_TIME > 1e5
ORDER BY S.ELAPSED_TIME DESC""")
for r in cur.fetchall():
    print("  " + " | ".join(str(x) for x in r))
con.close()
