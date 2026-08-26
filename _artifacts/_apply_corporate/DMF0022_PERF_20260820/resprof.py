# -*- coding: utf-8 -*-
"""부하 독립 자원 프로파일 — SP 1회 실행의 BUFFER_GETS / DISK_READS 델타.

동시 세션 부하(사내 타 세션)로 s/exec 이 흔들리므로, 논리/물리 I/O 를 정본 축으로 병기한다.
사용: python resprof.py <TAG>
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

TAG = sys.argv[1]
CASES = [("C1 div40 CURRENT", "40", "CURRENT"),
         ("C2 div81 CURRENT", "81", "CURRENT"),
         ("C3 div82 CURRENT", "82", "CURRENT"),
         ("C4 div40 CUR+SP_W", "40", "CURRENT,SP_W_20260817_V001"),
         ("C5 div40 SP_W", "40", "SP_W_20260817_V001"),
         ("C6 div81 CUR+SP_W", "81", "CURRENT,SP_W_20260817_V001")]

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT PARAMS FROM SCM_MGR.SCM_COM_SQL_LOG WHERE LOG_SEQ=227122")
raw = cur.fetchone()[0].read()
jk = lambda k: (re.search(r'"%s":"([^"]*)"' % k, raw).group(1)
                if re.search(r'"%s":"([^"]*)"' % k, raw) else None)
P = {k: jk(k) for k in ["deptId", "endCustomer", "scmSiteId", "projectCode", "itemId",
                        "itemType", "fromYyyymmdd", "toYyyymmdd", "sesUserId", "plantSiteId",
                        "bizType", "owner", "bucket", "userDeptId", "groupId", "cellYn",
                        "userId", "mnuId"]}
STAT = """SELECT s.NAME, m.VALUE FROM V$MYSTAT m JOIN V$STATNAME s ON s.STATISTIC# = m.STATISTIC#
           WHERE s.NAME IN ('session logical reads','physical reads','db block gets','consistent gets')"""


def stat():
    cur.execute(STAT)
    return dict(cur.fetchall())


res = {}
for label, div, ver in CASES:
    b = stat()
    o = [con.cursor() for _ in range(3)]
    t0 = time.time()
    cur.callproc("SCM_MGR.PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL", [
        div, P["deptId"] or "ALL", P["endCustomer"], P["scmSiteId"], P["projectCode"] or "",
        P["itemId"] or "", P["itemType"], P["fromYyyymmdd"], "20260817", P["toYyyymmdd"],
        P["sesUserId"], P["plantSiteId"], P["bizType"], P["owner"] or "", "N", P["cellYn"],
        ver, P["bucket"] or "MONTHLY", P["userDeptId"] or "", P["groupId"] or "",
        P["userId"], P["mnuId"]] + o)
    el = time.time() - t0
    n = [len(c.fetchall()) if c.description else None for c in o]
    a = stat()
    lr = a["session logical reads"] - b["session logical reads"]
    pr = a["physical reads"] - b["physical reads"]
    res[label] = dict(sec=round(el, 2), logical=lr, physical=pr, rows=n)
    print(f"[{TAG}] {label:20s} {el:6.2f}s  논리읽기 {lr:10,d}  물리읽기 {pr:9,d}  rows={n}")
json.dump(res, open(f"res_{TAG}.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
con.close()
