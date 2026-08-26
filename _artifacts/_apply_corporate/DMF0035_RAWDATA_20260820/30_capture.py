# -*- coding: utf-8 -*-
"""MKT GET 전 커서 전행 캡처 (값 동등성 대조용). 사용: 30_capture.py <phase>

케이스 (VERPUSH 세션 검증본과 동일 — 패치 경로를 실제로 덮는 집합):
  C1 CURRENT   div40 — 회귀 baseline (L1610 IF 분기 미진입)
  C2 MF        div40 — L1610 문장 진입 (CFM_MKT_DEMAND_PLAN_C 분기)
  C3 MF        div81 — L1610 문장 진입 (DM_PLN_MKT_FCST_C 분기)
  C4 MF 다중   div40 — GT_DM35_VERSION 2행 (세미조인 행 증식 없음 실증)
  C5 SF        div81 — CUTOFF/VERSION '%SF%' 경로
⚠ 기본 ARGS(versionNo='CURRENT') 단독으로는 대상 분기를 안 탄다 — 직전 작업에서 확인된 함정.
"""
import io
import json
import sys
import time

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_RAWDATA_20260820"


def args(div, ver):
    # 위치: 1 DIVISION .. 14 VERSION_NO .. 21 MENU_ID (ALL_ARGUMENTS 실측 기준)
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
        print(f"[{phase}] {name:<18} {el:7.1f}s  rc1={len(cap['rc1'] or [])} "
              f"rc2={len(cap['rc2'] or [])} rc3={len(cap['rc3'] or [])}")
    except Exception as e:
        el = time.time() - t0
        result[name] = {"elapsed_s": round(el, 1), "ok": False, "error": str(e)[:300]}
        print(f"[{phase}] {name:<18} {el:7.1f}s  FAIL: {str(e)[:160]}")
    con.close()

out = f"{BASE}\\{phase}_capture.json"
json.dump(result, open(out, "w", encoding="utf-8"), ensure_ascii=False, sort_keys=True)
print(f"[saved] {out}")
