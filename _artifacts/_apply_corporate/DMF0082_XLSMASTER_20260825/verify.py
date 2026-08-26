# -*- coding: utf-8 -*-
"""검증: Excel Form 실호출 — 마스터 기준 행 생성·MAIN 미종속·프리필·필터 동작"""
import io
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# 기준: 마스터 LOC 대상 (81, SITE/SITE_ITEM 유효)
cur.execute("""SELECT COUNT(*) FROM (
    SELECT DISTINCT F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, F.INCOTERMS, F.FCST_TYPE, F.DOM_EXP, F.CURRENCY
    FROM SCM_MGR.SCM_MST_FUTURE_PRICE F
    INNER JOIN SCM_MGR.SCM_MST_SITE MS ON MS.DIVISION_ID=F.DIVISION_ID AND MS.SCM_SITE_ID=F.SCM_SITE_ID AND MS.VALID_YN='Y'
    INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM SI ON SI.DIVISION_ID=F.DIVISION_ID AND SI.PROJECT_CODE=F.PROJECT_CODE
        AND SI.SCM_SITE_ID=F.SCM_SITE_ID AND SI.ITEM_ID=F.ITEM_ID AND SI.VALID_YN='Y'
    WHERE F.DIVISION_ID='81' AND F.MEASURE='LOC')""")
master_keys = cur.fetchone()[0]
print("마스터 LOC 대상 키(81, 유효조합):", master_keys)

def call_form(**kw):
    c2 = con.cursor()
    rc1, rcr = c2.var(oracledb.CURSOR), c2.var(oracledb.CURSOR)
    c2.callproc("PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA", [
        kw.get("div", "81"), "ALL", kw.get("ec", "ALL"), "ALL",
        kw.get("frm", "20260601"), kw.get("to", "20261031"),
        kw.get("site", "ALL"), kw.get("item", "ALL"),
        "Current", "N", "minyonglee1", "minyonglee1", "ALL", "ALL", "ALL", "ALL",
        rc1, rcr])
    c1 = rc1.getvalue()
    cols = [x[0] for x in c1.description]
    rows = c1.fetchall()
    res = rcr.getvalue().fetchone()
    c2.close()
    return cols, rows, res

# 1) 전체 (81)
cols, rows, res = call_form()
print("\n[1] div81 전체: o_rc1 %d행 / RESULT=%s / n_key(EVENT)=%s / WEEK_LIST=%s..." % (
    len(rows), res[0], res[2], (res[3] or "")[:40]))
iW01 = cols.index("W01")
iMea = cols.index("MEASURE")
prefill = sum(1 for r in rows if r[iW01] is not None)
print("    W01 프리필 보유 행: %d / MEASURE 종류: %s" % (prefill, sorted({r[iMea] for r in rows})[:3]))
iEC, iSITE, iITEM, iCUR = (cols.index(k) for k in ("END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID", "CURRENCY"))
print("    샘플:", [rows[0][i] for i in (iEC, iSITE, iITEM, iCUR)] if rows else "-")

# 2) 사이트 필터
if rows:
    site = rows[0][iSITE]
    _, rows2, _ = call_form(site=site)
    print("[2] 사이트 필터(%s): %d행 (전체 %d)" % (site, len(rows2), len(rows)))

# 3) 40 가드 (81 전용 유지)
_, rows3, res3 = call_form(div="40")
print("[3] div40 가드: %d행 / CODE=%s (기대 0행·CODE 1)" % (len(rows3), res3[0]))

# 4) MAIN 스테이징 미사용 확인 — 폼 호출 직후 GT_TEMP 는 이 세션에서 비어있어야(호출 안 했으므로)
cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE")
print("[4] GT_TEMP_FCST_N_PRICE(세션):", cur.fetchone()[0], "(0 = MAIN 파이프라인 미호출 확증)")
con.close()
