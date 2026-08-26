# -*- coding: utf-8 -*-
"""V$SQL 델타 계측 — 1회 실행 전/후 스냅샷 차분으로 문장별 s/exec·buffer·disk 를 확정.

누적치(EXECUTIONS 8회 섞임) 오귀속을 피하기 위한 정본.
사용: python delta.py [sales|title] [division] [version]
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
jk = lambda k: (re.search(r'"%s":"([^"]*)"' % k, raw).group(1)
                if re.search(r'"%s":"([^"]*)"' % k, raw) else None)
P = {k: jk(k) for k in ["divisionId", "deptId", "endCustomer", "scmSiteId", "projectCode",
                        "itemId", "itemType", "fromYyyymmdd", "toYyyymmdd", "sesUserId",
                        "plantSiteId", "bizType", "owner", "versionNo", "bucket",
                        "userDeptId", "groupId", "cellYn", "userId", "mnuId"]}

mode = sys.argv[1] if len(sys.argv) > 1 else "sales"
DIV = sys.argv[2] if len(sys.argv) > 2 else P["divisionId"]
VER = sys.argv[3] if len(sys.argv) > 3 else P["versionNo"]

SNAP = """SELECT s.SQL_ID, s.CHILD_NUMBER, s.EXECUTIONS, s.ELAPSED_TIME, s.BUFFER_GETS,
                 s.DISK_READS, s.ROWS_PROCESSED, s.PROGRAM_LINE#, o.OBJECT_NAME
            FROM V$SQL s LEFT JOIN DBA_OBJECTS o ON o.OBJECT_ID = s.PROGRAM_ID
           WHERE s.PARSING_SCHEMA_NAME IN ('SCM_MGR','SYS')"""


def snap():
    cur.execute(SNAP)
    return {(r[0], r[1]): r[2:] for r in cur.fetchall()}


b = snap()
o = [con.cursor() for _ in range(3 if mode == "sales" else 2)]
t0 = time.time()
if mode == "sales":
    cur.callproc("SCM_MGR.PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL", [
        DIV, P["deptId"] or "ALL", P["endCustomer"], P["scmSiteId"], P["projectCode"] or "",
        P["itemId"] or "", P["itemType"], P["fromYyyymmdd"], "20260817", P["toYyyymmdd"],
        P["sesUserId"], P["plantSiteId"], P["bizType"], P["owner"] or "", "N", P["cellYn"],
        VER, P["bucket"] or "MONTHLY", P["userDeptId"] or "", P["groupId"] or "",
        P["userId"], P["mnuId"]] + o)
else:
    cur.callproc("SCM_MGR.PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE", [
        P["fromYyyymmdd"], P["toYyyymmdd"], P["sesUserId"], DIV,
        P["bucket"] or "MONTHLY", P["userId"], P["mnuId"]] + o)
el = time.time() - t0
counts = []
for c in o:
    try:
        counts.append(len(c.fetchall()) if c.description else "no-desc")
    except Exception as e:
        counts.append(f"err:{e}")
print(f"[{mode} div={DIV} ver={VER}] TOTAL {el:.2f}s — 커서 행수 {counts}")

a = snap()
rows = []
for k, v in a.items():
    ex0, ela0, bg0, dr0, rp0 = b.get(k, (0, 0, 0, 0, 0))[:5]
    dex, dela, dbg, ddr, drp = v[0] - ex0, v[1] - ela0, v[2] - bg0, v[3] - dr0, v[4] - rp0
    if dela <= 0 or dex <= 0:
        continue
    rows.append((dela / 1e6, dex, dbg, ddr, drp, v[5], v[6] or "-", k[0]))
rows.sort(reverse=True)
cur.execute("""SELECT SQL_ID, SUBSTR(REPLACE(REPLACE(SQL_TEXT,CHR(10),' '),CHR(13),' '),1,200)
                 FROM V$SQL WHERE PARSING_SCHEMA_NAME IN ('SCM_MGR','SYS')""")
txt = dict(cur.fetchall())
print(f"\n{'ELA_S':>7} {'S/EXEC':>8} {'EXEC':>7} {'BUFFER':>11} {'DISK':>9} {'ROWS':>9} {'LINE#':>6}  OBJ")
tot = 0.0
for ela, ex, bg, dr, rp, pl, obj, sid in rows:
    if ela < 0.02:
        continue
    tot += ela
    print(f"{ela:7.2f} {ela/ex:8.4f} {ex:7d} {bg:11d} {dr:9d} {rp:9d} {str(pl):>6}  {obj} [{sid}]")
    print(f"        {txt.get(sid,'')[:200]}")
print(f"\n델타 합계 = {tot:.2f}s")
con.close()
