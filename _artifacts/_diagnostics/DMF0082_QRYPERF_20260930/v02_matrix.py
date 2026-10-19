# -*- coding: utf-8 -*-
"""GET_MAIN_DATA 시나리오 매트릭스 동등성 — 원본 PKG_DMF0082 vs 개선 PKG_DMF0082_QPT.

축: division 40/81/82 × {Cutoff MF_W / SP_W / SF_W(40), Current+MF_W 복수, Current+SalesSite 단일,
     Current+Item 단일, Current+qtyYn=Y}. (Current 전체 조회는 v01_compare 에서 PASS 완료)
판정 = 6개 커서 행수+정렬 SHA+컬럼수 (cur3 = SYSDATE 시각 → 행수·컬럼수만). 데이터 0행 시나리오는 '미실증' 표기(#126).
사용: python v02_matrix.py [div ...]
"""
import datetime, hashlib, io, pathlib, sys, time
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

DIVS = sys.argv[1:] or ["40", "81", "82"]
USER = "minyonglee1"
today = datetime.date.today()
frm = today.replace(day=1)
m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
FRM, TO = frm.strftime("%Y%m%d"), to.strftime("%Y%m%d")

u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 1800000
cur = cn.cursor()


def latest(div, vtype):
    cur.execute("SELECT MAX(VERSION_NO) KEEP (DENSE_RANK LAST ORDER BY YYYYMMDD) FROM DM_MST_VERSION "
                "WHERE DIVISION_ID=:d AND VERSION_TYPE=:t", d=div, t=vtype)
    return cur.fetchone()[0]


def sample(div):
    # 조회기간 수요 원장에서 행이 가장 많은 SITE / ITEM 1개 (필터 시나리오가 데이터를 싣도록)
    tbl = "DM_PLN_MKT_FCST" if div != "40" else "DM_PLN_CFM_MKT_DEMAND_PLAN"
    cur.execute(f"SELECT SCM_SITE_ID, ITEM_ID FROM (SELECT SCM_SITE_ID, ITEM_ID, COUNT(*) N FROM SCM_MGR.{tbl} "
                "WHERE DIVISION_ID=:d AND YYYYMMDD BETWEEN :f AND :t GROUP BY SCM_SITE_ID, ITEM_ID ORDER BY N DESC) "
                "WHERE ROWNUM=1", d=div, f=FRM, t=TO)
    return cur.fetchone()


def run(pkg, args):
    outs = [cn.cursor() for _ in range(6)]
    t0 = time.time()
    cur.callproc(f"SCM_MGR.{pkg}.P_DMF0082_GET_MAIN_DATA", args + outs)
    el = time.time() - t0
    res = []
    for oc in outs:
        oc.arraysize = 5000
        rows = oc.fetchall()
        ncol = len(oc.description) if oc.description else 0
        res.append((len(rows), hashlib.sha256("\n".join(sorted(repr(tuple(r)) for r in rows)).encode()).hexdigest()[:16], ncol))
    cn.rollback()
    return el, res


fails = 0
for div in DIVS:
    site, item = sample(div)
    vers = {t: latest(div, t) for t in ("MF_W", "SP_W", "SF_W")}
    base = lambda **k: [div, "ALL", "ALL", "ALL", FRM, TO, k.get("site", "ALL"), k.get("item"), k.get("ver", "Current"),
                        k.get("qty", "N"), USER, "ADMIN", "ALL", "ALL", "ALL", "ALL"]
    sc = []
    for t in ("MF_W", "SP_W", "SF_W"):
        if vers[t]:
            sc.append((f"Cutoff {vers[t]}", base(ver=vers[t])))
    if vers["MF_W"]:
        sc.append((f"Current,{vers['MF_W']}", base(ver=f"Current,{vers['MF_W']}")))
    sc.append((f"Current site={site}", base(site=site)))
    sc.append((f"Current item={item}", base(item=item)))
    sc.append(("Current qtyYn=Y", base(qty="Y")))
    for name, args in sc:
        ta, ra = run("PKG_DMF0082", args)
        tb, rb = run("PKG_DMF0082_QPT", args)
        ok = all((a[0] == b[0] and a[2] == b[2]) if i == 2 else a == b for i, (a, b) in enumerate(zip(ra, rb)))
        fails += 0 if ok else 1
        note = "" if ra[0][0] > 0 else "  ⚠ 0행(미실증)"
        print(f"div{div} {name:34} {'PASS' if ok else 'FAIL'}  rows={ra[0][0]:>6}  원본 {ta:6.2f}s → 개선 {tb:6.2f}s{note}", flush=True)
        if not ok:
            for i, (a, b) in enumerate(zip(ra, rb)):
                if a != b:
                    print(f"      cur{i + 1}: 원본 {a} / 개선 {b}")
print(f"\nFAIL 합계 = {fails}")
cn.close()
