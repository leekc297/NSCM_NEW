# -*- coding: utf-8 -*-
"""[E20260930-DMF0082-81SP] 81 저장 → Sales Plan 까지 연결 E2E (사내 ZIOUI1 · 실저장 → 정리).

단계: ① 저장 전 스냅샷(SALES_PLAN·MKT_FCST 키 전체) ② SCM_FCST 1셀 저장(FE save.ts 1:1 인자) ③ 대조
      ④ 정리: 같은 셀 'D' 저장 → 테스트가 만든 SALES_PLAN SCM_FCST 행·이력 행 삭제 → 최종 상태 = 스냅샷 대조
사용: python e02_81_save_e2e.py
"""
import io, sys, time, pathlib, datetime
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

USER = "minyonglee1"
KEY = dict(DIVISION_ID="81", PROJECT_CODE="A19VO6001", SCM_SITE_ID="Volvo AS_WA_SE_GOT", ITEM_ID="AMVCC519H-A1R000",
           DOM_EXP="E", FCST_TYPE="AS", INCOTERMS="FCA", PLANT_SITE_ID="WA00-P")
YMD, QTY = (sys.argv[1] if len(sys.argv) > 1 else "20261016"), 777
START = (datetime.date.today() - datetime.timedelta(days=datetime.date.today().weekday())).strftime("%Y%m%d")

u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 1800000
cur = cn.cursor()
KW = " AND ".join(f"{k}=:{k}" for k in ("DIVISION_ID", "PROJECT_CODE", "SCM_SITE_ID", "ITEM_ID", "DOM_EXP", "FCST_TYPE", "INCOTERMS", "PLANT_SITE_ID"))


def snap_sp():
    cur.execute(f"SELECT MEASURE, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CURRENCY, LAST_UPDATED_BY FROM DM_PLN_SALES_PLAN WHERE {KW} AND YYYYMMDD >= :s", {**KEY, "s": START})
    return {(m, c, y): (q, cu, lu) for m, c, y, q, cu, lu in cur}


def snap_mf():
    cur.execute(f"SELECT MEASURE, YYYYMMDD, QTY FROM DM_PLN_MKT_FCST WHERE {KW} AND YYYYMMDD >= :s", {**KEY, "s": START})
    return {(m, y): q for m, y, q in cur}


def save(flag, qty):
    args = [flag, KEY["DIVISION_ID"], KEY["PROJECT_CODE"], "-", KEY["SCM_SITE_ID"], KEY["ITEM_ID"], KEY["DOM_EXP"],
            KEY["FCST_TYPE"], KEY["INCOTERMS"], "SCM_FCST", KEY["PLANT_SITE_ID"], "-", YMD, "", str(qty), USER, None]
    rc = cn.cursor()
    t = time.time()
    cur.callproc("PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA", args + [rc])
    out = rc.fetchall()
    return time.time() - t, out


def diff(a, b, label):
    keys = sorted(set(a) | set(b), key=str)
    norm = lambda v: None if v is None else (tuple(v[0:2]) if isinstance(v, tuple) else v)
    ch = [(k, a.get(k), b.get(k)) for k in keys if norm(a.get(k)) != norm(b.get(k))]
    print(f"  {label}: 전 {len(a)} → 후 {len(b)} · 값 변경 {len(ch)}")
    for k, x, y in ch[:15]:
        print(f"     {k}: {x} → {y}")
    return ch


sp0, mf0 = snap_sp(), snap_mf()
print(f"키 {KEY}  셀 SCM_FCST {YMD}={QTY}  기준 당주월 {START}")
print(f"[전] SALES_PLAN {len(sp0)}행 (SCM_FCST {sum(1 for k in sp0 if k[0]=='SCM_FCST')}) · MKT_FCST 원장 {len(mf0)}행")

el, out = save("M", QTY)
print(f"\n[저장] {el:.2f}s  결과커서 {out}")
sp1, mf1 = snap_sp(), snap_mf()
new_sp = {k: v for k, v in sp1.items() if k[0] == "SCM_FCST"}
print(f"  SALES_PLAN SCM_FCST 행: {new_sp}")
print(f"  MKT_FCST 원장 SCM_FCST: { {k: v for k, v in mf1.items() if k[0]=='SCM_FCST'} }")
ch_mf = diff(mf0, mf1, "MKT_FCST 원장 (SCM_FCST 추가 외 변화 = BALANCE/RMA 재계산)")
ch_sp = diff({k: v for k, v in sp0.items() if k[0] != "SCM_FCST"}, {k: v for k, v in sp1.items() if k[0] != "SCM_FCST"},
             "SALES_PLAN SCM_FCST 외 메저 (값 보존 여부)")
ok = (("SCM_FCST", "-", YMD) in sp1 and float(sp1[("SCM_FCST", "-", YMD)][0]) == QTY)
print(f"\n판정: SALES_PLAN SCM_FCST 생성 {'PASS' if ok else 'FAIL'}")

# ---- 정리 ----
el2, out2 = save("D", 0)
print(f"\n[정리] 'D' 저장 {el2:.2f}s {out2}")
cur.execute(f"DELETE FROM DM_PLN_SALES_PLAN WHERE {KW} AND MEASURE='SCM_FCST' AND YYYYMMDD=:y", {**KEY, "y": YMD})
print(f"  SALES_PLAN 테스트 SCM_FCST 행 삭제 {cur.rowcount}")
cur.execute(f"DELETE FROM DM_PLN_MKT_FCST_H WHERE {KW} AND MEASURE='SCM_FCST' AND YYYYMMDD=:y AND LAST_UPDATED_BY=:u", {**KEY, "y": YMD, "u": USER})
print(f"  MKT_FCST_H 테스트 이력 삭제 {cur.rowcount}")
cn.commit()
sp2, mf2 = snap_sp(), snap_mf()
diff(mf0, mf2, "정리 후 MKT_FCST 원장 vs 전")
diff(sp0, sp2, "정리 후 SALES_PLAN vs 전 (수량·통화)")
cn.close()
