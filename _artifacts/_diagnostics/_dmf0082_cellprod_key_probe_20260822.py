#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0082 div40 — GET 이 CELL_PROD_SITE_ID 를 반환하지 않아 저장 키가 어긋나는지 실증 (2026-08-22).

## 실측된 사실

    · `P_DMF0082_GET_MAIN_DATA` rc0 컬럼 418종에 **CELL_PROD_SITE_ID 가 없다** (전수 확인).
    · 메타는 표시 컬럼이다 — DMF0082/FcstNPrice/CELL_PROD_SITE_ID VISIBLE='Y' DIV='40'
      W=110 INPUT_TP_CD='IO'(신규행만 편집) CTRL='FPComboBox'.
    · FE 는 그리드 행에서 읽는다 — forecast-price.save.ts L72 `cellProdSiteId: str(item['CELL_PROD_SITE_ID'])`.
    · 원장 실값 보유율(편집창 20260812~27, div40 MKT_FCST): 134/186 = 72%.

⇒ 조회된 기존 행은 그리드에 이 값이 **비어 있고**, 저장 시 `''` 가 전송된다.
   그런데 원장 키와 MERGE ON 절에는 이 컬럼이 들어간다(L13773 `A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID`).

## 이 도구가 가르는 것

원장에 `CELL_PROD_SITE_ID='NJ01-A'` 인 행을 만들고, **그리드가 보내는 형태(`''`)로 수정(M)** 을 보낸다.

    가설 A (키 어긋남) : NJ01-A 행은 그대로 남고 `''` 행이 **새로 생긴다** → 수정 안 됨 + 중복 발생
    가설 B (정상)      : NJ01-A 행이 갱신된다

⚠ 저장 SP 는 내부 COMMIT 이다. 원래 없던 (키, 일자) 에만 쓰고 끝나면 전량 정리한다.
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info                                       # noqa: E402
import oracledb                                                 # noqa: E402

USER = "minyonglee1"
WIN = ["2026{0:02d}{1:02d}".format(8, d) for d in range(12, 28)]
KEYS = ("DIVISION_ID", "PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID",
        "DOM_EXP", "FCST_TYPE", "INCOTERMS", "MEASURE", "PLANT_SITE_ID", "CELL_PROD_SITE_ID")

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def save(key, ymd, qty, flag, cps):
    """cps 를 명시 인자로 받는다 — 그리드가 보내는 형태('')를 재현하기 위해."""
    s = lambda k: "" if key.get(k) is None else str(key.get(k))   # noqa: E731
    args = [flag, s("DIVISION_ID"), s("PROJECT_CODE") or s("END_CUSTOMER"), s("END_CUSTOMER"),
            s("SCM_SITE_ID"), s("ITEM_ID"), s("DOM_EXP"), s("FCST_TYPE"), s("INCOTERMS"),
            s("MEASURE"), s("PLANT_SITE_ID"), cps, ymd, "", str(qty), USER, None]
    rc = con.cursor()
    try:
        cur.callproc("PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA", args + [rc])
        return rc.fetchall()
    except Exception as ex:                                       # noqa: BLE001
        return [("CALL_ERR", str(ex)[:150], "")]
    finally:
        rc.close()


def snap(key, ymd):
    """이 (키 - CPS, 일자) 의 전 행을 CPS 별로."""
    b = {k: key[k] for k in KEYS if k != "CELL_PROD_SITE_ID"}
    w = " AND ".join(f"NVL({k},'~')=NVL(:{k},'~')" for k in b)
    b["y"] = ymd
    cur.execute(f"""SELECT NVL(CELL_PROD_SITE_ID,'(NULL)'), QTY
                      FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
                     WHERE {w} AND YYYYMMDD=:y ORDER BY 1""", b)
    return cur.fetchall()


def cleanup(key, ymd):
    b = {k: key[k] for k in KEYS if k != "CELL_PROD_SITE_ID"}
    w = " AND ".join(f"NVL({k},'~')=NVL(:{k},'~')" for k in b)
    b["y"] = ymd
    cur.execute(f"DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN WHERE {w} AND YYYYMMDD=:y", b)
    n = cur.rowcount
    con.commit()
    return n


# 실값 CPS 를 가진 원장 실키 하나
cur.execute(f"""SELECT {", ".join(KEYS)} FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
                 WHERE DIVISION_ID='40' AND MEASURE='MKT_FCST'
                   AND CELL_PROD_SITE_ID IS NOT NULL AND CELL_PROD_SITE_ID <> '-'
                   AND YYYYMMDD BETWEEN :a AND :b
                 GROUP BY {", ".join(KEYS)} FETCH FIRST 20 ROWS ONLY""", a=WIN[0], b=WIN[-1])
cands = [dict(zip(KEYS, r)) for r in cur.fetchall()]
print(f"== 실값 CPS 보유 실키 후보 {len(cands)}건 ==")

for key in cands:
    ymd = next((y for y in WIN if not snap(key, y)), None)
    if not ymd:
        continue
    cps = key["CELL_PROD_SITE_ID"]
    out = save(key, ymd, 7, "I", cps)
    if str(out[0][0]) != "0":
        continue
    s1 = snap(key, ymd)
    if len(s1) != 1:
        cleanup(key, ymd)
        continue

    print(f"{chr(10)}== 실증 ==")
    print(f"   ITEM={key['ITEM_ID']} SITE={key['SCM_SITE_ID']} DATE={ymd} CPS={cps}")
    print(f"   [1] I(qty=7, CPS='{cps}')        → 원장 {s1}")
    out = save(key, ymd, 55, "M", "")            # ← 그리드가 보내는 형태
    s2 = snap(key, ymd)
    print(f"   [2] M(qty=55, CPS='')  SP={out[0] if out else '?'}")
    print(f"       원장 {s2}")

    orig = [q for c, q in s2 if c == cps]
    ghost = [q for c, q in s2 if c != cps]
    if len(s2) == 1 and orig and abs(float(orig[0]) - 55) < 0.001:
        print("   판정: 가설 B — 정상. CPS 공란 전송에도 원행이 갱신됨")
    elif ghost:
        print(f"   판정: ⛔ 가설 A — **키 어긋남**. 원행 CPS='{cps}' 는 QTY={orig} 로 남고, "
              f"CPS 공란 행이 새로 생김(QTY={ghost}) → 화면에서 '수정이 안 됨' + 중복 행")
    else:
        print(f"   판정: 기타 — 원장 {s2} (수동 확인 필요)")

    n = cleanup(key, ymd)
    print(f"   [정리] {n}건 삭제")
    break
else:
    print("   유효 후보 없음 — 판정불가")

con.close()
