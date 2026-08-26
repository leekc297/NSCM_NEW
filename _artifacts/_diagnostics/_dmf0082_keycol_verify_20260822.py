#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""저장 키 컬럼 항상 반환(A안) 실효 검증 — 2026-08-22.

    V1  키 컬럼을 숨긴 계정(minyonglee1)의 GET 이 CELL_PROD_SITE_ID 를 **실값으로** 반환하는가
    V2  그 계정으로 기존 행 수정(M)이 **차단 없이** 통과하는가  (정정 전: Common 오판으로 차단)
    V3  이미 보유한 계정(bottle)은 **변화 없는가**              (행수 회귀 — A안 부작용 확인)

V2 는 원장을 건드리므로 원래 없던 (키, 일자) 에만 쓰고 끝나면 정리한다.
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info                                       # noqa: E402
import oracledb                                                 # noqa: E402

HID, HAVE = "minyonglee1", "bottle"
WIN = ["2026{0:02d}{1:02d}".format(8, d) for d in range(12, 28)]
KEYS = ("DIVISION_ID", "PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID",
        "DOM_EXP", "FCST_TYPE", "INCOTERMS", "MEASURE", "PLANT_SITE_ID", "CELL_PROD_SITE_ID")

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def get(uid):
    rcs = [con.cursor() for _ in range(6)]
    cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
                 ["40", "ALL", "ALL", "ALL", "20260801", "20270201", "ALL", "",
                  "Current", "N", uid, "DM ADMIN", "ALL", "ALL", "ALL", "ALL"] + rcs)
    cols = [c[0] for c in rcs[0].description]
    rows = [dict(zip(cols, r)) for r in rcs[0].fetchall()]
    for c in rcs:
        try:
            c.close()
        except Exception:                                        # noqa: BLE001
            pass
    return cols, rows


print("===== V1 · V3  GET 결과 =====")
res = {}
for uid in (HID, HAVE):
    cols, rows = get(uid)
    has = "CELL_PROD_SITE_ID" in cols
    real = sum(1 for r in rows if r.get("CELL_PROD_SITE_ID") not in (None, "", "-")) if has else 0
    res[uid] = (len(rows), has, real)
    print(f"   {uid:14s} rows={len(rows):6d}  CELL_PROD_SITE_ID={'있음' if has else '없음':4s}  실값행={real}")

v1 = res[HID][1] and res[HID][2] > 0
print(f"   V1 (숨긴 계정도 실값 수신)      : {'PASS' if v1 else 'FAIL'}")
v3 = res[HAVE][0] == 7809 and res[HAVE][1]
print(f"   V3 (보유 계정 행수 7,809 불변)  : {'PASS' if v3 else 'FAIL — 행수 ' + str(res[HAVE][0])}")


def ledger(key, ymd):
    w = " AND ".join(f"NVL({k},'~')=NVL(:{k},'~')" for k in KEYS)
    b = dict(key)
    b["y"] = ymd
    cur.execute(f"""SELECT NVL(SUM(QTY),0), COUNT(*) FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
                     WHERE {w} AND YYYYMMDD=:y""", b)
    a, c = cur.fetchone()
    return float(a or 0), int(c)


def save(key, ymd, qty, flag, uid):
    s = lambda k: "" if key.get(k) is None else str(key.get(k))   # noqa: E731
    args = [flag, s("DIVISION_ID"), s("PROJECT_CODE") or s("END_CUSTOMER"), s("END_CUSTOMER"),
            s("SCM_SITE_ID"), s("ITEM_ID"), s("DOM_EXP"), s("FCST_TYPE"), s("INCOTERMS"),
            s("MEASURE"), s("PLANT_SITE_ID"), s("CELL_PROD_SITE_ID"), ymd, "",
            str(qty), uid, None]
    rc = con.cursor()
    try:
        cur.callproc("PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA", args + [rc])
        return rc.fetchall()
    except Exception as ex:                                       # noqa: BLE001
        return [("CALL_ERR", str(ex)[:150], "")]
    finally:
        rc.close()


print(f"{chr(10)}===== V2  숨긴 계정으로 기존 행 수정(M) =====")
# 정정 후 GET 이 주는 값을 그대로 쓴다 = 화면이 보내는 것과 동일
_, rows = get(HID)
v2 = None
for r in rows:
    if r.get("MEASURE") != "MKT_FCST" or str(r.get("EDIT_FLAG")) != "Y":
        continue
    cps = r.get("CELL_PROD_SITE_ID")
    if cps in (None, "", "-"):
        continue
    key = {k: r.get(k) for k in KEYS}
    ymd = next((y for y in WIN if ledger(key, y)[1] == 0), None)
    if not ymd:
        continue
    out = save(key, ymd, 7, "I", HID)
    if str(out[0][0]) != "0":
        continue
    if ledger(key, ymd)[1] != 1:
        continue
    print(f"   ITEM={r['ITEM_ID']} CPS={cps} DATE={ymd}")
    print(f"   [I] qty=7  → 원장 {ledger(key, ymd)}")
    out = save(key, ymd, 55, "M", HID)
    q2, c2 = ledger(key, ymd)
    v2 = (c2 == 1 and abs(q2 - 55) < 0.001)
    print(f"   [M] qty=55 → 원장 QTY={q2} rows={c2}  (기대 QTY=55 rows=1)  "
          f"{'PASS' if v2 else 'FAIL'}   SP={out[0] if out else '?'}")
    w = " AND ".join(f"NVL({k},'~')=NVL(:{k},'~')" for k in KEYS)
    b = dict(key)
    b["y"] = ymd
    cur.execute(f"DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN WHERE {w} AND YYYYMMDD=:y", b)
    print(f"   [정리] {cur.rowcount}건 삭제")
    con.commit()
    break

print(f"{chr(10)}===== 종합 =====")
print(f"   V1 숨긴 계정 실값 수신     : {'PASS' if v1 else 'FAIL'}")
print(f"   V2 숨긴 계정 기존행 수정   : "
      + ("PASS" if v2 else ("FAIL" if v2 is False else "판정불가 — 유효 후보 없음")))
print(f"   V3 보유 계정 회귀 불변     : {'PASS' if v3 else 'FAIL'}")
con.close()
sys.exit(0 if (v1 and v2 and v3) else 1)
