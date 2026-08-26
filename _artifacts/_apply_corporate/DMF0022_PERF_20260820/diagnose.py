# -*- coding: utf-8 -*-
"""PKG_DMF0022 전수 진단표 생성 (hook #129 ⓿).

- 6 케이스 각 1회 실행 → V$SQL 델타로 문장별 s/exec·buffer·disk·rows 확정
- 문장 귀속 = SQL_FULLTEXT 정규화 ↔ BODY(주석제거) 세그먼트 매칭 (권위)
  + PROGRAM_LINE# (보조 — 단독 사용 금지)
- 각 문장 실행계획에서 ② 비-SARG(FULL + 필터술어) / ③ 인덱스 사용 / ④ 선행축소 판단 근거 수집
출력: 99_DIAG.md
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

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0022_PERF_20260820"
BODY = open(BASE + r"\00_BACKUP_PKG_DMF0022_BODY.sql", encoding="utf-8").read().splitlines()
LIVE = open(BASE + r"\_live_nocomment.sql", encoding="utf-8").read().splitlines()


def norm(s):
    return re.sub(r"\s+", " ", s or "").strip().upper()


LIVE_N = [norm(x) for x in LIVE]


def find_body_line(sqltext):
    """SQL_FULLTEXT 앞부분을 LIVE BODY 에서 찾아 1-based 라인 반환 (권위 매칭)."""
    t = norm(sqltext)
    # 첫 40자 / 80자 토큰으로 순차 탐색
    for width in (120, 80, 45):
        head = t[:width]
        if not head:
            continue
        for i in range(len(LIVE_N)):
            # 연속 라인 병합 후 비교
            acc = ""
            for j in range(i, min(i + 25, len(LIVE_N))):
                acc = (acc + " " + LIVE_N[j]).strip()
                if len(acc) >= width:
                    break
            if acc.startswith(head):
                return i + 1
    return None


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
CASES = [("C1 div40 CURRENT", "40", "CURRENT"),
         ("C2 div81 CURRENT", "81", "CURRENT"),
         ("C3 div82 CURRENT", "82", "CURRENT"),
         ("C4 div40 CUR+SP_W", "40", "CURRENT,SP_W_20260817_V001"),
         ("C5 div40 SP_W", "40", "SP_W_20260817_V001"),
         ("C6 div81 CUR+SP_W", "81", "CURRENT,SP_W_20260817_V001")]

SNAP = """SELECT s.SQL_ID, s.CHILD_NUMBER, s.EXECUTIONS, s.ELAPSED_TIME, s.BUFFER_GETS,
                 s.DISK_READS, s.ROWS_PROCESSED, s.PROGRAM_LINE#, o.OBJECT_NAME
            FROM V$SQL s LEFT JOIN DBA_OBJECTS o ON o.OBJECT_ID = s.PROGRAM_ID
           WHERE s.PARSING_SCHEMA_NAME='SCM_MGR'"""


def snap():
    cur.execute(SNAP)
    return {(r[0], r[1]): r[2:] for r in cur.fetchall()}


agg = {}   # sql_id -> {case: metrics}
for label, div, ver in CASES:
    b = snap()
    o = [con.cursor() for _ in range(3)]
    t0 = time.time()
    cur.callproc("SCM_MGR.PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL", [
        div, P["deptId"] or "ALL", P["endCustomer"], P["scmSiteId"], P["projectCode"] or "",
        P["itemId"] or "", P["itemType"], P["fromYyyymmdd"], "20260817", P["toYyyymmdd"],
        P["sesUserId"], P["plantSiteId"], P["bizType"], P["owner"] or "", "N", P["cellYn"],
        ver, P["bucket"] or "MONTHLY", P["userDeptId"] or "", P["groupId"] or "",
        P["userId"], P["mnuId"]] + o)
    tot = time.time() - t0
    nrows = [len(c.fetchall()) if c.description else None for c in o]
    a = snap()
    print(f"[{label}] {tot:.2f}s rows={nrows}")
    for k, v in a.items():
        ex0, ela0, bg0, dr0, rp0 = b.get(k, (0, 0, 0, 0, 0))[:5]
        # 커서 무효화(GATHER_TABLE_STATS no_invalidate=>FALSE)로 카운터가 리셋되면
        # 델타가 음수가 되어 조용히 누락된다 → 리셋 감지 시 baseline 0 으로 재설정
        if v[0] < ex0 or v[1] < ela0:
            ex0 = ela0 = bg0 = dr0 = rp0 = 0
        dex, dela = v[0] - ex0, (v[1] - ela0) / 1e6
        if dex <= 0 or dela <= 0.005:
            continue
        rec = agg.setdefault(k[0], {"line#": v[5], "obj": v[6], "cases": {}})
        rec["cases"][label] = dict(ela=round(dela, 3), ex=dex, bg=v[2] - bg0,
                                   dr=v[3] - dr0, rows=v[4] - rp0)

# SQL_TEXT + PLAN 수집
rows_out = []
for sid, rec in agg.items():
    cur.execute("SELECT SQL_FULLTEXT FROM V$SQL WHERE SQL_ID=:s AND ROWNUM=1", {"s": sid})
    r = cur.fetchone()
    ft = (r[0].read() if hasattr(r[0], "read") else r[0]) if r else ""
    if "PKG_DMF0022" not in (rec["obj"] or "") and "BEGIN" not in norm(ft)[:10]:
        if rec["obj"] not in (None, "-") or norm(ft).startswith("SELECT S.SQL_ID"):
            continue
    bl = find_body_line(ft) if (rec["obj"] == "PKG_DMF0022") else None
    # plan
    plan = []
    try:
        cur.execute("""SELECT PLAN_TABLE_OUTPUT FROM TABLE(
                       DBMS_XPLAN.DISPLAY_CURSOR(:s, NULL, 'BASIC +PREDICATE'))""", {"s": sid})
        plan = [x[0] for x in cur.fetchall()]
    except Exception as e:
        plan = [f"(plan err {e})"]
    ptxt = "\n".join(plan)
    fulls = re.findall(r"TABLE ACCESS FULL\s*\|\s*([A-Z0-9_$]+)", ptxt)
    idxs = re.findall(r"INDEX (?:RANGE|UNIQUE|FAST FULL|SKIP) SCAN[^|]*\|\s*([A-Z0-9_$]+)", ptxt)
    rows_out.append(dict(sid=sid, line_hint=rec["line#"], body_line=bl, obj=rec["obj"],
                         cases=rec["cases"], sql=norm(ft)[:300], fulls=fulls, idxs=idxs,
                         plan=ptxt))

rows_out.sort(key=lambda r: -max(c["ela"] for c in r["cases"].values()))
json.dump(rows_out, open(BASE + r"\_diag_raw.json", "w", encoding="utf-8"),
          ensure_ascii=False, indent=1)
print(f"\n[saved] _diag_raw.json — {len(rows_out)} statements")
con.close()
