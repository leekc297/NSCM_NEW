# -*- coding: utf-8 -*-
"""[E20260825-XLSPRICECOL] 폼 검증 — 단가 테이블 컬럼 계약·키 수·프리필·필터·성능"""
import io, sys, time
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()
FRM, TO = "20260824", "20261130"

# 기준: 원장 키(PLANT 포함) + 게이트
cur.execute("""SELECT COUNT(*) FROM (
    SELECT DISTINCT F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.INCOTERMS, F.FCST_TYPE, F.DOM_EXP, F.CURRENCY
    FROM (SELECT DISTINCT PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, FCST_TYPE, DOM_EXP, CURRENCY, DIVISION_ID
            FROM SCM_MGR.SCM_MST_FUTURE_PRICE
           WHERE DIVISION_ID='81' AND MEASURE='LOC' AND YYYYMMDD BETWEEN :f AND :t) F
    INNER JOIN SCM_MGR.SCM_MST_SITE MS ON MS.DIVISION_ID=F.DIVISION_ID AND MS.SCM_SITE_ID=F.SCM_SITE_ID
        AND MS.SITE_TYPE='SALES' AND MS.VALID_YN='Y'
    INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM SI ON SI.DIVISION_ID=F.DIVISION_ID AND SI.PROJECT_CODE=F.PROJECT_CODE
        AND SI.SCM_SITE_ID=F.SCM_SITE_ID AND SI.ITEM_ID=F.ITEM_ID AND SI.VALID_YN='Y'
    INNER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V IV ON IV.DIVISION_ID=F.DIVISION_ID AND IV.ITEM_ID=F.ITEM_ID)""",
    f=FRM, t=TO)
base = cur.fetchone()[0]
print("[기준] 원장 키(PLANT 포함, 게이트 적용):", base)

def call_form(**kw):
    c2 = con.cursor()
    rc1, rcr = c2.var(oracledb.CURSOR), c2.var(oracledb.CURSOR)
    t0 = time.time()
    c2.callproc("PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA", [
        kw.get("div", "81"), "ALL", kw.get("ec", "ALL"), "ALL",
        kw.get("frm", FRM), kw.get("to", TO),
        kw.get("site", "ALL"), kw.get("item", "ALL"),
        "Current", "N", "minyonglee1", "minyonglee1",
        kw.get("plant", "ALL"), kw.get("prj", "ALL"), "ALL", "ALL",
        rc1, rcr])
    c1 = rc1.getvalue()
    cols = [x[0] for x in c1.description]
    rows = c1.fetchall()
    res = rcr.getvalue().fetchone()
    return cols, rows, res, time.time() - t0

cols, rows, res, dt = call_form()
print("[1] 커서 컬럼:", cols[:14], "... W슬롯", sum(1 for c in cols if c.startswith("W")))
assert "END_CUSTOMER" not in cols, "END_CUSTOMER 잔존!"
for k in ("PROJECT_CODE", "PLANT_SITE_ID", "PROJECT_NAME", "PROJECT_OWNER"):
    assert k in cols, k + " 부재!"
print("    행수 %d vs 기준 %d -> %s / n_key=%s / %.1fs" % (
    len(rows), base, "일치" if len(rows) == base else "불일치!", res[2], dt))
iW01, iPL, iPC = cols.index("W01"), cols.index("PLANT_SITE_ID"), cols.index("PROJECT_CODE")
print("    W01 프리필:", sum(1 for r in rows if r[iW01] is not None),
      "/ PLANT 실값 행:", sum(1 for r in rows if r[iPL] not in (None, "", "-")))
print("    샘플:", [rows[0][cols.index(k)] for k in ("PROJECT_CODE", "SCM_SITE_ID", "PLANT_SITE_ID", "ITEM_ID", "CURRENCY", "MEASURE")] if rows else "-")

# PLANT 필터 동작
if rows:
    pl = rows[0][iPL]
    _, rows2, _, dt2 = call_form(plant=pl)
    print("[2] PLANT 필터(%s): %d행 %.1fs" % (pl, len(rows2), dt2))
    pc = rows[0][iPC]
    _, rows3, _, dt3 = call_form(prj=pc)
    print("[3] PROJECT 필터(%s): %d행 %.1fs" % (pc, len(rows3), dt3))
_, rows4, res4, _ = call_form(div="40")
print("[4] div40 가드: %d행 / CODE=%s" % (len(rows4), res4[0]))
_, rows5, _, dt5 = call_form(to="20260907")
print("[5] 구간 축소(~0907): %d행 %.1fs" % (len(rows5), dt5))
con.close()
