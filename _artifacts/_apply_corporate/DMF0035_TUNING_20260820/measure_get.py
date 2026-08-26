# -*- coding: utf-8 -*-
"""DMF0035 Waterfall GET 3본 병목 계측 (hook #129 ⓿ — 조회 전용, DML 없음).

재현 파라미터 = SCM_COM_SQL_LOG LOG_SEQ 227122 원문 (FE 실측 — 추정 금지).
사용: python measure_get.py [mkt|sales|biz|vsql]
"""
import io
import json
import sys
import time

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# ── 로그 원문 파라미터 (227122) ───────────────────────────────────────────────
cur.execute("SELECT PARAMS FROM SCM_MGR.SCM_COM_SQL_LOG WHERE LOG_SEQ=227122")
raw = cur.fetchone()[0].read()
# JSON 은 rc1 덤프에서 절단됨 — 키 스칼라만 안전 추출
import re


def jkey(k, default=None):
    m = re.search(r'"%s":"([^"]*)"' % k, raw)
    return m.group(1) if m else default


P = {k: jkey(k) for k in [
    "divisionId", "deptId", "endCustomer", "scmSiteId", "projectCode", "itemId",
    "itemType", "fromYyyymmdd", "toYyyymmdd", "sesUserId", "plantSiteId", "bizType",
    "owner", "versionNo", "bucket", "userDeptId", "groupId", "cellYn", "senderCode",
    "userId", "mnuId"]}
print("[재현 파라미터]", json.dumps(P, ensure_ascii=False))

mode = sys.argv[1] if len(sys.argv) > 1 else "mkt"


def rcs(n):
    return [con.cursor() for _ in range(n)]


def run(label, name, args):
    t0 = time.time()
    cur.callproc(name, args)
    el = time.time() - t0
    counts = []
    for a in args:
        if isinstance(a, oracledb.Cursor) and a.description:
            try:
                counts.append(len(a.fetchall()))
            except Exception as e:
                counts.append(f"err:{e}")
    print(f"[{label}] {el:.1f}s — 커서 행수 {counts}")


if mode == "mkt":
    o = rcs(4)
    run("MKT", "SCM_MGR.PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL", [
        P["divisionId"], P["deptId"] or "ALL", P["endCustomer"], P["scmSiteId"],
        P["projectCode"] or "", P["itemId"] or "", P["itemType"], P["fromYyyymmdd"],
        P["toYyyymmdd"], P["sesUserId"], P["plantSiteId"], P["bizType"], P["owner"] or "",
        P["versionNo"], P["bucket"] or "MONTHLY", P["userDeptId"] or "", P["groupId"] or "",
        P["cellYn"], P["senderCode"], P["userId"], P["mnuId"]] + o)
elif mode == "sales":
    o = rcs(3)
    # P_NOW = FE calcNowYyyymmdd — from~to 사이 오늘(2026-08-20)
    run("SALES", "SCM_MGR.PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL", [
        P["divisionId"], P["deptId"] or "ALL", P["endCustomer"], P["scmSiteId"],
        P["projectCode"] or "", P["itemId"] or "", P["itemType"], P["fromYyyymmdd"],
        "20260817", P["toYyyymmdd"], P["sesUserId"], P["plantSiteId"], P["bizType"],
        P["owner"] or "", "N", P["cellYn"], P["versionNo"], P["bucket"] or "MONTHLY",
        P["userDeptId"] or "", P["groupId"] or "", P["userId"], P["mnuId"]] + o)
elif mode == "biz":
    o = rcs(3)
    run("BIZ", "SCM_MGR.PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL", [
        P["divisionId"], P["deptId"] or "ALL", P["endCustomer"], P["scmSiteId"],
        P["projectCode"] or "", P["itemId"] or "", P["itemType"], P["fromYyyymmdd"],
        "20260817", P["toYyyymmdd"], P["sesUserId"], P["plantSiteId"], P["bizType"],
        P["owner"] or "", P["versionNo"], P["cellYn"], "N", P["userId"], P["mnuId"]] + o)
elif mode == "vsql":
    cur.execute("""
        SELECT SQL_ID, EXECUTIONS, ROUND(ELAPSED_TIME/1e6,1) ELA_S, BUFFER_GETS,
               ROWS_PROCESSED, SUBSTR(REPLACE(SQL_TEXT, CHR(10),' '),1,140) TXT
        FROM   V$SQL
        WHERE  PARSING_SCHEMA_NAME='SCM_MGR' AND LAST_ACTIVE_TIME > SYSDATE - 15/1440
        AND    ELAPSED_TIME > 3e6
        ORDER  BY ELAPSED_TIME DESC FETCH FIRST 15 ROWS ONLY""")
    for r in cur.fetchall():
        print(" | ".join(str(x) for x in r))
con.close()
