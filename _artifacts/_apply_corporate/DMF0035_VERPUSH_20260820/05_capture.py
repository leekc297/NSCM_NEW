# -*- coding: utf-8 -*-
"""MKT GET 전 커서 전행 캡처 (값 동등성 대조용 — 읽기 전용). 사용: 05_capture.py <phase>

capture_mkt.py 원형을 다중 케이스로 확장.
 ⚠ 원형 ARGS 의 P_VERSION_NO='CURRENT' 는 **패치 대상 IF 블록(LIKE '%MF%' OR '%SF%')에 진입하지 않는다.**
   따라서 패치 3분기를 실제로 덮는 케이스를 추가한다:
     C1 CURRENT   div40 — 기존 회귀 baseline (패치 경로 미진입)
     C2 MF        div40 — 분기2(DM_PLN_CFM_MKT_DEMAND_PLAN_C) + 분기3(RESULT_C)
     C3 MF        div81 — 분기1(DM_PLN_MKT_FCST_C) + 분기3(RESULT_C)
     C4 MF 다중   div40 — GT_DM35_VERSION 2행(semi-join 행 증식 없음 실증)
     C5 SF        div81 — CUTOFF_TYPE '%SF%' 경로
"""
import io
import json
import sys
import time

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_VERPUSH_20260820"


def args(div, ver):
    # 위치: 1 DIVISION .. 14 VERSION_NO .. 21 MENU_ID   (ALL_ARGUMENTS 실측 기준)
    return [div, "ALL", "ALL", "ALL", "", "", "ALL", "20260801", "20270228", "minyonglee1",
            "ALL", "ALL", "", ver, "MONTHLY", "", "", "N", "ALL", "minyonglee1", "DMF0035"]


CASES = {
    "C1_CURRENT_div40": args("40", "CURRENT"),
    "C2_MF_div40":      args("40", "MF_W_20260805_V001"),
    "C3_MF_div81":      args("81", "MF_D_20260817_V001"),
    "C4_MF2_div40":     args("40", "MF_W_20260805_V001,MF_W_20260805_V002"),
    "C5_SF_div81":      args("81", "SF_W_20260817_V001"),
}

phase = sys.argv[1]
u, p, d = conn_info()
result = {}
for name, a in CASES.items():
    con = oracledb.connect(user=u, password=p, dsn=d)   # 케이스마다 새 세션 (GTT 격리)
    cur = con.cursor()
    o = [con.cursor() for _ in range(4)]
    t0 = time.time()
    try:
        cur.callproc("SCM_MGR.PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL", a + o)
        el = time.time() - t0
        cap = {}
        for i in range(3):
            if o[i].description is None:
                cap[f"rc{i+1}"] = None
                continue
            cols = [c[0] for c in o[i].description]
            rows = [dict(zip(cols, [str(v) for v in r])) for r in o[i].fetchall()]
            rows.sort(key=lambda r: json.dumps(r, sort_keys=True, ensure_ascii=False))
            cap[f"rc{i+1}"] = rows
        result[name] = {"elapsed_s": round(el, 1), "ok": True,
                        "counts": {k: (len(v) if v is not None else None) for k, v in cap.items()},
                        "data": cap}
        print(f"[{phase}] {name:<18} {el:6.1f}s  rc1={len(cap['rc1'] or [])} "
              f"rc2={len(cap['rc2'] or [])} rc3={len(cap['rc3'] or [])}")
    except Exception as e:
        el = time.time() - t0
        result[name] = {"elapsed_s": round(el, 1), "ok": False, "error": str(e)[:300]}
        print(f"[{phase}] {name:<18} {el:6.1f}s  FAIL: {str(e)[:160]}")
    con.close()

out = f"{BASE}\\{phase}_capture.json"
json.dump(result, open(out, "w", encoding="utf-8"), ensure_ascii=False, sort_keys=True)
print(f"[saved] {out}")
