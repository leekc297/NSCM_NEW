# -*- coding: utf-8 -*-
"""DMF0051 BIZ Waterfall GET 계측 + V$SQL 문장별 귀속 (hook #129 ⓿ — 조회 전용).

사용: python measure_biz.py [--version VER] [--div 40] [--label L] [--dump out.json]
귀속 = PROGRAM_ID(=PKG object_id) + SQL_FULLTEXT 세그먼트 매칭.
"""
import argparse
import io
import json
import re
import sys
import time

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

ap = argparse.ArgumentParser()
ap.add_argument("--version", default=None)
ap.add_argument("--div", default=None)
ap.add_argument("--label", default="BIZ")
ap.add_argument("--dump", default=None)
ap.add_argument("--novsql", action="store_true")
A = ap.parse_args()

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
if A.version is not None:
    P["versionNo"] = A.version
if A.div is not None:
    P["divisionId"] = A.div

ARGS = [P["divisionId"], P["deptId"] or "ALL", P["endCustomer"], P["scmSiteId"],
        P["projectCode"] or "", P["itemId"] or "", P["itemType"], P["fromYyyymmdd"],
        "20260817", P["toYyyymmdd"], P["sesUserId"], P["plantSiteId"], P["bizType"],
        P["owner"] or "", P["versionNo"], P["cellYn"], "N", P["userId"], P["mnuId"]]
print(f"[파라미터] div={ARGS[0]} ver={ARGS[14]} from={ARGS[7]} to={ARGS[9]} user={ARGS[10]}/{ARGS[17]} mnu={ARGS[18]} cellYn={ARGS[15]}")

# ── V$SQL 스냅샷 (PKG_DMF0051 귀속분 + 최근 동적SQL) ────────────────────────
# ⚠ FIRST_LOAD_TIME 을 커서 정체성으로 함께 잡는다.
#   SP 안의 DBMS_STATS.GATHER_TABLE_STATS(no_invalidate=>FALSE) 가 커서를 무효화하면
#   같은 (SQL_ID, CHILD_NUMBER) 자리에 EXECUTIONS 가 되감긴 새 커서가 앉는다.
#   되감김이 '더 작음'이 아니라 '같음'(1→1)으로 나타나는 경우가 있어 크기 비교만으로는 못 잡고
#   해당 문장이 조용히 누락된다 (DMF0051 최종 동적 SQL 에서 실제 발생).
SNAP = """
SELECT SQL_ID, CHILD_NUMBER, EXECUTIONS, ELAPSED_TIME, BUFFER_GETS, DISK_READS,
       ROWS_PROCESSED, PROGRAM_LINE#, SUBSTR(SQL_TEXT,1,200), FIRST_LOAD_TIME, LAST_LOAD_TIME
FROM V$SQL
WHERE PARSING_SCHEMA_NAME='SCM_MGR'
  AND (PROGRAM_ID = (SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0051' AND OBJECT_TYPE='PACKAGE BODY')
       OR SQL_TEXT LIKE '%T_DM51_WF%')
"""


def snap():
    cur.execute(SNAP)
    return {(r[0], r[1]): r for r in cur.fetchall()}


before = {} if A.novsql else snap()

out = [con.cursor() for _ in range(3)]
t0 = time.time()
cur.callproc("SCM_MGR.PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL", ARGS + out)
el = time.time() - t0
rows = []
for c in out:
    if c.description:
        rows.append(c.fetchall())
    else:
        rows.append([])
print(f"[{A.label}] 총 {el:.2f}s — 커서 행수 {[len(r) for r in rows]}")

if A.dump:
    cols0 = [c[0] for c in out[0].description] if out[0].description else []
    with open(A.dump, "w", encoding="utf-8") as f:
        json.dump({"elapsed": el, "cols": cols0,
                   "rc1": [[str(x) for x in r] for r in rows[0]],
                   "rc2": [[str(x) for x in r] for r in rows[1]]}, f, ensure_ascii=False)
    print(f"[dump] {A.dump} ({len(rows[0])} rows, {len(cols0)} cols)")

if not A.novsql:
    after = snap()
    diffs = []
    reset = 0
    for k, r in after.items():
        b = before.get(k)
        # ⚠ SP 안의 DBMS_STATS.GATHER_TABLE_STATS(no_invalidate=>FALSE) 가 커서를 무효화하면
        #   같은 (SQL_ID, CHILD) 의 EXECUTIONS 가 되감긴다 → 단순 차분은 음수가 되어 문장이 조용히 누락된다.
        #   (DMF0022 작업자 실사고) 되감김을 감지하면 before 를 0 으로 보정한다.
        if b is not None and (r[2] < b[2] or r[9] != b[9] or r[10] != b[10]):
            reset += 1
            b = None
        de = r[2] - (b[2] if b else 0)
        if de <= 0:
            continue
        diffs.append(dict(sql_id=r[0], execs=de,
                          ela=(r[3] - (b[3] if b else 0)) / 1e6,
                          bg=r[4] - (b[4] if b else 0),
                          dr=r[5] - (b[5] if b else 0),
                          rp=r[6] - (b[6] if b else 0),
                          line=r[7], txt=r[8].replace("\n", " ")))
    diffs.sort(key=lambda x: -x["ela"])
    print(f"\n{'SQL_ID':15} {'ELA_S':>8} {'BUFGETS':>10} {'DISK':>9} {'ROWS':>9} {'LINE':>6}  TEXT")
    tot = 0.0
    for x in diffs:
        tot += x["ela"]
        print(f"{x['sql_id']:15} {x['ela']:8.2f} {x['bg']:10d} {x['dr']:9d} {x['rp']:9d} {x['line']:6d}  {x['txt'][:110]}")
    print(f"{'합계':15} {tot:8.2f}  (SP 총 {el:.2f}s)")
    if reset:
        print(f"[주의] 커서 카운터 되감김 {reset}건 감지 — before=0 으로 보정하여 누락 방지 (GATHER_TABLE_STATS 무효화)")
con.close()
