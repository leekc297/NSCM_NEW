#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DIV40 저장 차단 사유 분포 진단 — 유효 실증 후보를 찾기 위한 선행 probe (2026-08-22).

`_dmf0082_delete_proof_20260822.py` 가 40 후보 40건 전부 검증차단으로 판정불가가 났다.
차단 메시지를 **분류**해서 어떤 축이 막는지 먼저 가른다(추정 금지 — 실측).
저장은 하지 않는다: `I` 를 보내되 결과 코드만 보고, 원장에 생긴 행은 즉시 정리한다.
"""
import sys
from collections import Counter

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info                                       # noqa: E402
import oracledb                                                 # noqa: E402

USER = "minyonglee1"
PERIOD = ("20260801", "20270201")
WIN = ["2026{0:02d}{1:02d}".format(8, d) for d in range(12, 28)]
N = 60

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

rcs = [con.cursor() for _ in range(6)]
cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
             ["40", "ALL", "ALL", "ALL", PERIOD[0], PERIOD[1], "ALL", "",
              "Current", "N", USER, "DM ADMIN", "ALL", "ALL", "ALL", "ALL"] + rcs)
cols = [c[0] for c in rcs[0].description]
rows = [dict(zip(cols, r)) for r in rcs[0].fetchall()]
cand = [r for r in rows if r.get("MEASURE") == "MKT_FCST" and str(r.get("EDIT_FLAG")) == "Y"]
print(f"== 후보 {len(cand)}건 · {N}건 probe ==")
print("   CELL_PROD_SITE_ID 분포:",
      dict(Counter(str(r.get("CELL_PROD_SITE_ID")) for r in cand).most_common(8)))
print("   FCST_TYPE 분포     :",
      dict(Counter(str(r.get("FCST_TYPE")) for r in cand).most_common(8)))

msgs, okrow = Counter(), None
for r in cand[:N]:
    idate = next((y for y in WIN
                  if r.get("D_" + y) is None or float(r.get("D_" + y) or 0) == 0), None)
    if not idate:
        continue
    s = lambda k: "" if r.get(k) is None else str(r.get(k))      # noqa: E731
    args = ["I", s("DIVISION_ID"), s("PROJECT_CODE") or s("END_CUSTOMER"), s("END_CUSTOMER"),
            s("SCM_SITE_ID"), s("ITEM_ID"), s("DOM_EXP"), s("FCST_TYPE"), s("INCOTERMS"),
            s("MEASURE"), s("PLANT_SITE_ID"), s("CELL_PROD_SITE_ID"), idate, s("CURRENCY"),
            "7", USER, None]
    rc = con.cursor()
    try:
        cur.callproc("PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA", args + [rc])
        out = rc.fetchall()
    except Exception as ex:                                      # noqa: BLE001
        out = [("CALL_ERR", str(ex)[:120], "")]
    rc.close()
    code = str(out[0][0]) if out else "?"
    if code == "0":
        okrow = (r, idate)
        msgs["0 SUCCESS"] += 1
        # 즉시 정리
        cur.execute("""DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE DIVISION_ID='40'
            AND PROJECT_CODE=:pc AND NVL(END_CUSTOMER,'-')=NVL(:ec,'-') AND SCM_SITE_ID=:s
            AND ITEM_ID=:i AND DOM_EXP=:de AND FCST_TYPE=:ft AND INCOTERMS=:ic
            AND MEASURE=:m AND YYYYMMDD=:y""",
                    dict(pc=r["PROJECT_CODE"], ec=r["END_CUSTOMER"], s=r["SCM_SITE_ID"],
                         i=r["ITEM_ID"], de=r["DOM_EXP"], ft=r["FCST_TYPE"],
                         ic=r["INCOTERMS"], m=r["MEASURE"], y=idate))
        con.commit()
        break
    txt = str(out[0][1])[:70] if out and len(out[0]) > 1 else "?"
    msgs[txt] += 1

print(f"{chr(10)}== 차단 사유 분포 ==")
for k, v in msgs.most_common():
    print(f"   {v:4d}  {k}")
print(f"{chr(10)}   저장 통과 후보: {'있음 ' + okrow[0]['ITEM_ID'] + ' @' + okrow[1] if okrow else '없음'}")
con.close()
