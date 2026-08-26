#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0082 수요 measure DELETE 실증 (40 / 81) — 2026-08-22.

## 왜 다시 만들었나 — 앞선 두 검증이 모두 무효였다

1. `crud_roundtrip_dmf0082.py` 40 축: 선정 행이 검증에 걸려 **I 가 실행되지 않았는데** D 판정을
   PASS 로 냈다. 원장이 처음부터 0행이면 "삭제됨"과 구분되지 않는다.
2. 그 앞 버전은 D 기대값에 **실측값을 대입**(`d_expect = float(ad[0])`)해 항상 PASS 였다.

⇒ 본 도구는 **삽입이 원장에 실제로 생긴 것을 확인한 뒤에만** 삭제를 판정한다.

## GET 행을 키로 쓰면 안 되는 이유 (실측)

`P_DMF0082_GET_MAIN_DATA` 는 `CELL_PROD_SITE_ID` 를 **388건 전부 `None`** 으로 돌려준다.
그대로 저장하면 SP 가 `Common` 으로 보고 막는다:

    "Model*: MCCH350040A1-000는 Cell Prod Site* 를 Common으로 등록 할 수 없습니다."  (60건 중 58건)

화면은 사용자가 셀에서 고른 실제 값을 보내므로 통과한다. 그래서 여기서는 **원장에 이미 있는 행의
전체 키**(검증을 통과한 적이 있는 조합)를 그대로 쓰고, 그 키의 **빈 일자**에만 행을 만든다.

⚠ 저장 SP 는 내부 COMMIT 이라 rollback 이 무의미하다. 원래 없던 (키, 일자) 에만 쓰고 끝나면 정리한다.
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info                                       # noqa: E402
import oracledb                                                 # noqa: E402

USER = "minyonglee1"
WIN = ["2026{0:02d}{1:02d}".format(8, d) for d in range(12, 28)]   # 편집가능 미래 창
TBL = {"40": "DM_PLN_CFM_MKT_DEMAND_PLAN", "81": "DM_PLN_MKT_FCST"}
# ⚠ 두 원장은 컬럼 구성이 다르다(실측) — 81 에는 END_CUSTOMER·CELL_PROD_SITE_ID 가 **없다**.
#   공통 키로 뭉뚱그리면 ORA-00904 로 죽는다. 분리해서 쓴다.
KEYS_BY_DIV = {
    "40": ("DIVISION_ID", "PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID",
           "DOM_EXP", "FCST_TYPE", "INCOTERMS", "MEASURE", "PLANT_SITE_ID", "CELL_PROD_SITE_ID"),
    "81": ("DIVISION_ID", "PROJECT_CODE", "SCM_SITE_ID", "ITEM_ID",
           "DOM_EXP", "FCST_TYPE", "INCOTERMS", "MEASURE", "PLANT_SITE_ID"),
}
MAX_TRY = 25

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def candidates(div):
    """원장 실키 — 검증을 통과한 적 있는 조합만. 편집창 안에 빈 일자가 있는 키."""
    tbl, keys = TBL[div], KEYS_BY_DIV[div]
    where = "DIVISION_ID = '40'" if div == "40" else "DIVISION_ID <> '40'"
    cur.execute(f"""SELECT {", ".join(keys)}, COUNT(*) FROM SCM_MGR.{tbl}
        WHERE {where} AND MEASURE = 'MKT_FCST'
          AND YYYYMMDD BETWEEN :a AND :b
        GROUP BY {", ".join(keys)}
        HAVING COUNT(*) < :n
        ORDER BY COUNT(*) DESC
        FETCH FIRST :m ROWS ONLY""", a=WIN[0], b=WIN[-1], n=len(WIN), m=MAX_TRY)
    return [dict(zip(keys, r[:-1])) for r in cur.fetchall()]


def ledger(div, key, ymd):
    tbl = TBL[div]
    w = " AND ".join(f"NVL({k},'~')=NVL(:{k},'~')" for k in KEYS_BY_DIV[div])
    b = dict(key)
    b["y"] = ymd
    cur.execute(f"SELECT NVL(SUM(QTY),0), COUNT(*) FROM SCM_MGR.{tbl} WHERE {w} AND YYYYMMDD=:y", b)
    a, c = cur.fetchone()
    return float(a or 0), int(c)


def free_date(div, key):
    for y in WIN:
        if ledger(div, key, y)[1] == 0:
            return y
    return None


def save(key, ymd, qty, flag):
    s = lambda k: "" if key.get(k) is None else str(key.get(k))   # noqa: E731
    args = [flag, s("DIVISION_ID"), s("PROJECT_CODE") or s("END_CUSTOMER"), s("END_CUSTOMER"),
            s("SCM_SITE_ID"), s("ITEM_ID"), s("DOM_EXP"), s("FCST_TYPE"), s("INCOTERMS"),
            s("MEASURE"), s("PLANT_SITE_ID"), s("CELL_PROD_SITE_ID"), ymd, "",
            str(qty), USER, None]
    rc = con.cursor()
    try:
        cur.callproc("PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA", args + [rc])
        return rc.fetchall()
    except Exception as ex:                                       # noqa: BLE001
        return [("CALL_ERR", str(ex)[:150], "")]
    finally:
        try:
            rc.close()
        except Exception:                                          # noqa: BLE001
            pass


def cleanup(div, key, ymd):
    tbl = TBL[div]
    w = " AND ".join(f"NVL({k},'~')=NVL(:{k},'~')" for k in KEYS_BY_DIV[div])
    b = dict(key)
    b["y"] = ymd
    cur.execute(f"DELETE FROM SCM_MGR.{tbl} WHERE {w} AND YYYYMMDD=:y", b)
    n = cur.rowcount
    con.commit()
    return n


def run(div):
    print(f"{chr(10)}===== DIV {div}  ({TBL[div]}) =====")
    cands = candidates(div)
    print(f"   원장 실키 후보 {len(cands)}건")
    blocked = []
    for key in cands:
        ymd = free_date(div, key)
        if not ymd:
            continue
        out = save(key, ymd, 7, "I")
        if str(out[0][0]) != "0":
            blocked.append(str(out[0][1])[:60] if len(out[0]) > 1 else "?")
            continue
        q, c = ledger(div, key, ymd)
        if c != 1:
            blocked.append(f"I SUCCESS 인데 원장 미생성 (rows={c})")
            continue

        print(f"   후보 확정 ITEM={key['ITEM_ID']} SITE={key['SCM_SITE_ID']} "
              f"PJT={key['PROJECT_CODE']} CPS={key.get('CELL_PROD_SITE_ID', '-')} DATE={ymd}")
        print(f"   [I] SAVE 7 → QTY={q} rows={c}   (기대 QTY=7 rows=1)  "
              f"{'PASS' if abs(q - 7) < 0.001 and c == 1 else 'FAIL'}")
        out = save(key, ymd, 0, "D")
        q2, c2 = ledger(div, key, ymd)
        ok = abs(q2) < 0.001 and c2 == 0
        print(f"   [D] SAVE D → QTY={q2} rows={c2}  (기대 QTY=0 rows=0 · 고정)  "
              f"{'PASS' if ok else 'FAIL'}   SP={out[0] if out else '?'}")
        n = cleanup(div, key, ymd)
        if n:
            print(f"   [정리] 잔존 {n}건 삭제")
        return ok

    print(f"   판정불가 — 유효 후보 없음. 차단 사유 상위:")
    from collections import Counter
    for m, v in Counter(blocked).most_common(5):
        print(f"      {v:3d}  {m}")
    return None


def regress_81_zero_edit():
    """81 회귀 — '값을 0 으로 고침'(M) 은 행이 **남아야** 한다.

    81 MERGE 소스에는 `QTY_PRICE <> 0` 필터가 없고 주석(L13789)이 "DMF0003 과 동일하게 QTY=0 행도
    물리 저장" 이라고 설계 의도를 못박았다. 삭제를 `ACTION='D'` 기준으로 넣은 이유가 바로 이것이므로,
    정정이 이 의도를 깨지 않았는지 반드시 같이 본다. (QTY=0 기준으로 넣었다면 여기서 FAIL 이 난다.)
    """
    print(f"{chr(10)}===== DIV 81 회귀 — M 으로 0 입력 시 행 유지 =====")
    for key in candidates("81"):
        for y in WIN:
            q, c = ledger("81", key, y)
            if c == 1 and q > 0:
                out = save(key, y, 0, "M")
                if str(out[0][0]) != "0":
                    continue
                q2, c2 = ledger("81", key, y)
                ok = (c2 == 1 and abs(q2) < 0.001)
                print(f"   ITEM={key['ITEM_ID']} DATE={y}  {q} → M(0)")
                print(f"   원장 QTY={q2} rows={c2}  (기대 QTY=0 rows=1 · 행 유지)  "
                      f"{'PASS' if ok else 'FAIL'}")
                save(key, y, q, "M")                      # 원복
                q3, c3 = ledger("81", key, y)
                print(f"   [원복] QTY={q3} rows={c3}  (기대 QTY={q} rows=1)  "
                      f"{'PASS' if c3 == 1 and abs(q3 - q) < 0.001 else 'FAIL'}")
                return ok
    print("   판정불가 — QTY>0 인 후보 없음")
    return None


res = {dv: run(dv) for dv in ("40", "81")}
res["81-M0"] = regress_81_zero_edit()
print(f"{chr(10)}===== 종합 =====")
LABEL = {"40": "DIV 40  수요 MKT_FCST DELETE      ",
         "81": "DIV 81  수요 MKT_FCST DELETE      ",
         "81-M0": "DIV 81  회귀: M(0) 행 유지        "}
VERD = {"40": ("PASS — 삭제 확인", "FAIL — 행 잔존"),
        "81": ("PASS — 삭제 확인", "FAIL — 행 잔존"),
        "81-M0": ("PASS — 행 유지", "FAIL — 행이 사라짐(설계 위반)")}
for dv, r in res.items():
    okmsg, ngmsg = VERD[dv]
    print(f"   {LABEL[dv]}: " + (okmsg if r else (ngmsg if r is False else "판정불가")))
con.close()
sys.exit(0 if all(res.values()) else 1)
