# -*- coding: utf-8 -*-
"""값 동등성 캡처 — 다중 케이스 rc1 전행 + GTT 전행 (before/after 대조용).

GTT 는 서버측 집계 해시(ORA_HASH 2종 + COUNT)로 대조한다 — 40만행 클라이언트 페치 제거.
  · 순서 무관 멀티셋 동등성: SUM/COUNT 집계이므로 정렬 불필요
  · 서로 다른 시드 2개 + 행수 동시 일치 → 우연 충돌 확률 무시 가능

사용: python capture.py before|after
"""
import hashlib
import io
import json
import re
import sys
import time

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

LABEL = sys.argv[1]
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT PARAMS FROM SCM_MGR.SCM_COM_SQL_LOG WHERE LOG_SEQ=227122")
raw = cur.fetchone()[0].read()
J = lambda k: (re.search(r'"%s":"([^"]*)"' % k, raw) or [None, None])[1]
B = {k: J(k) for k in ["divisionId", "deptId", "endCustomer", "scmSiteId", "projectCode", "itemId",
                       "itemType", "fromYyyymmdd", "toYyyymmdd", "sesUserId", "plantSiteId", "bizType",
                       "owner", "cellYn", "userId", "mnuId"]}


def args(**ov):
    a = dict(div=B["divisionId"], dept=B["deptId"] or "ALL", endc=B["endCustomer"], site=B["scmSiteId"],
             proj=B["projectCode"] or "", item=B["itemId"] or "", itype=B["itemType"],
             frm=B["fromYyyymmdd"], now="20260817", to=B["toYyyymmdd"], user=B["sesUserId"],
             plant=B["plantSiteId"], biz=B["bizType"], owner=B["owner"] or "", ver="CURRENT",
             cell=B["cellYn"], qty="N", uid=B["userId"], mnu=B["mnuId"])
    a.update(ov)
    return [a["div"], a["dept"], a["endc"], a["site"], a["proj"], a["item"], a["itype"], a["frm"],
            a["now"], a["to"], a["user"], a["plant"], a["biz"], a["owner"], a["ver"], a["cell"],
            a["qty"], a["uid"], a["mnu"]]


CASES = {
    "C1_div40_CURRENT":         args(),
    "C2_div40_BP20260810":      args(ver="BP_M_20260810_V001"),
    "C3_div40_BP20260805":      args(ver="BP_M_20260805_V001"),
    "C4_div40_CURRENT+BP2":     args(ver="CURRENT^BP_M_20260810_V001^BP_M_20260223_V001"),
    "C5_div40_CURRENT_cellY":   args(cell="Y"),
    "C6_div40_CURRENT_qtyY":    args(qty="Y"),
    "C7_div40_BP_owner필터":     args(ver="BP_M_20260810_V001", owner="lee"),
    "C8_div40_BP_itemtype":     args(ver="BP_M_20260810_V001", itype="P"),
    "C9_div81_CURRENT":         args(div="81", ver="CURRENT"),
    "C10_div40_CURRENT_narrow": args(frm="20260901", to="20261130"),
}

GTTS = ["GT_DM51_SCM_MST_SITE_ITEM", "GT_DM22_DM_MST_ITEM_SINGLE_V", "GT_DM51_RAW_DATA",
        "GT_DM51_SCM_CITY", "GT_DM22_SELECT_MEASURE", "GT_DM22_V_VERSION_NO"]

# GTT 별 전 컬럼 연결식 (서버측 해시용) — 컬럼 순서 = COLUMN_ID
HASH_SQL = {}
for g in GTTS:
    cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:1
                   ORDER BY COLUMN_ID""", [g])
    cols = [r[0] for r in cur.fetchall()]
    expr = " || CHR(31) || ".join(f"NVL(TO_CHAR(\"{c}\"),CHR(0))" for c in cols)
    HASH_SQL[g] = (f"SELECT COUNT(*), NVL(SUM(ORA_HASH(T.RT,4294967295,0)),0), "
                   f"NVL(SUM(ORA_HASH(T.RT,4294967295,17)),0), COUNT(DISTINCT T.RT) "
                   f"FROM (SELECT {expr} AS RT FROM SCM_MGR.{g}) T")


cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
               AND TABLE_NAME='GT_DM22_DM_MST_ITEM_SINGLE_V' ORDER BY COLUMN_ID""")
_sv = [r[0] for r in cur.fetchall()]
_svexpr = " || CHR(31) || ".join(f"NVL(TO_CHAR(D.\"{c}\"),CHR(0))" for c in _sv)
CONSUMED_SQL = f"""
SELECT COUNT(*), NVL(SUM(ORA_HASH(T.RT,4294967295,0)),0), NVL(SUM(ORA_HASH(T.RT,4294967295,17)),0)
FROM (SELECT {_svexpr} AS RT
        FROM (SELECT DISTINCT DIVISION_ID, ITEM_ID FROM SCM_MGR.GT_DM51_RAW_DATA) A
        JOIN SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V D
          ON D.DIVISION_ID = A.DIVISION_ID AND D.ITEM_ID = A.ITEM_ID) T"""


def h(rows):
    m = hashlib.sha256()
    for r in rows:
        m.update(("\x1f".join("\x00" if x is None else str(x) for x in r) + "\x1e").encode("utf-8"))
    return m.hexdigest()


res = {}
for name, a in CASES.items():
    out = [con.cursor() for _ in range(3)]
    t0 = time.time()
    cur.callproc("SCM_MGR.PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL", a + out)
    rows = out[0].fetchall() if out[0].description else []
    el = time.time() - t0
    cols = [c[0] for c in out[0].description] if out[0].description else []
    rec = {"elapsed": round(el, 2), "rows": len(rows), "cols": cols,
           "hash_ordered": h(rows),
           "hash_sorted": h(sorted(rows, key=lambda r: tuple("" if x is None else str(x) for x in r)))}
    for g in GTTS:
        cur.execute(HASH_SQL[g])
        c, h1, h2, dc = cur.fetchone()
        rec[g] = {"cnt": c, "h1": str(h1), "h2": str(h2), "distinct": dc}
    # [P4 대응] ITEM_SINGLE 계열은 선행축소로 GTT 원문 행수가 바뀌므로 '실제 소비되는 슬라이스' 로 등가 판정한다.
    #   소비처는 전부 정확 (DIVISION_ID, ITEM_ID) 조인/EXISTS → 아래 슬라이스가 같으면 관측 가능한 결과가 같다.
    cur.execute(CONSUMED_SQL)
    c, h1, h2 = cur.fetchone()
    rec["SINGLE_V_CONSUMED"] = {"cnt": c, "h1": str(h1), "h2": str(h2), "distinct": c}
    res[name] = rec
    print(f"  {name:26} {el:6.2f}s  rc1={len(rows):7d}  " +
          "  ".join(f"{g[8:]}={rec[g]['cnt']}" for g in GTTS[:4]))

open(f"cap_{LABEL}.json", "w", encoding="utf-8").write(json.dumps(res, ensure_ascii=False, indent=1))
print(f"[saved] cap_{LABEL}.json")
con.close()
