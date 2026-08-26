# -*- coding: utf-8 -*-
"""DMF0022 SALES PLAN Waterfall GET 계측 (hook #129 ⓿ — 조회 전용).

재현 파라미터 = SCM_COM_SQL_LOG LOG_SEQ 227122 원문 (DMF0035 세션에서 확인된 FE 실측).
사용: python measure_sales.py [sales|title|vsql|ash]
"""
import io
import json
import re
import sys
import time

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

cur.execute("SELECT PARAMS FROM SCM_MGR.SCM_COM_SQL_LOG WHERE LOG_SEQ=227122")
raw = cur.fetchone()[0].read()


def jkey(k, default=None):
    m = re.search(r'"%s":"([^"]*)"' % k, raw)
    return m.group(1) if m else default


P = {k: jkey(k) for k in [
    "divisionId", "deptId", "endCustomer", "scmSiteId", "projectCode", "itemId",
    "itemType", "fromYyyymmdd", "toYyyymmdd", "sesUserId", "plantSiteId", "bizType",
    "owner", "versionNo", "bucket", "userDeptId", "groupId", "cellYn", "senderCode",
    "userId", "mnuId"]}
print("[재현 파라미터]", json.dumps(P, ensure_ascii=False))

mode = sys.argv[1] if len(sys.argv) > 1 else "sales"


def rcs(n):
    return [con.cursor() for _ in range(n)]


def sales_args(o, division=None, version=None):
    return [division or P["divisionId"], P["deptId"] or "ALL", P["endCustomer"], P["scmSiteId"],
            P["projectCode"] or "", P["itemId"] or "", P["itemType"], P["fromYyyymmdd"],
            "20260817", P["toYyyymmdd"], P["sesUserId"], P["plantSiteId"], P["bizType"],
            P["owner"] or "", "N", P["cellYn"],
            version if version is not None else P["versionNo"],
            P["bucket"] or "MONTHLY", P["userDeptId"] or "", P["groupId"] or "",
            P["userId"], P["mnuId"]] + o


if mode == "sales":
    o = rcs(3)
    t0 = time.time()
    cur.callproc("SCM_MGR.PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL", sales_args(o))
    el = time.time() - t0
    counts = []
    for a in o:
        try:
            counts.append(len(a.fetchall()) if a.description else "no-desc")
        except Exception as e:
            counts.append(f"err:{e}")
    print(f"[SALES] {el:.2f}s — 커서 행수 {counts}")
elif mode == "title":
    o = rcs(2)
    t0 = time.time()
    cur.callproc("SCM_MGR.PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE", [
        P["fromYyyymmdd"], P["toYyyymmdd"], P["sesUserId"], P["divisionId"],
        P["bucket"] or "MONTHLY", P["userId"], P["mnuId"]] + o)
    el = time.time() - t0
    counts = []
    for a in o:
        try:
            counts.append(len(a.fetchall()) if a.description else "no-desc")
        except Exception as e:
            counts.append(f"err:{e}")
    print(f"[TITLE] {el:.2f}s — 커서 행수 {counts}")
elif mode == "vsql":
    win = int(sys.argv[2]) if len(sys.argv) > 2 else 15
    cur.execute("""
        SELECT SQL_ID, EXECUTIONS, ROUND(ELAPSED_TIME/1e6,2) ELA_S,
               ROUND(ELAPSED_TIME/1e6/GREATEST(EXECUTIONS,1),3) S_EXEC,
               BUFFER_GETS, DISK_READS, ROWS_PROCESSED,
               SUBSTR(REPLACE(REPLACE(SQL_TEXT, CHR(10),' '),CHR(13),' '),1,150) TXT
        FROM   V$SQL
        WHERE  PARSING_SCHEMA_NAME='SCM_MGR' AND LAST_ACTIVE_TIME > SYSDATE - :w/1440
        AND    ELAPSED_TIME > 3e5
        ORDER  BY ELAPSED_TIME DESC FETCH FIRST 25 ROWS ONLY""", {"w": win})
    for r in cur.fetchall():
        print(" | ".join(str(x) for x in r))
con.close()
