#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0082 CRUD 규모 테스트 — 저장 페이로드 **SIZE 10,000자** (hook #145 §4, 사용자 확정 기준).

> "CRUD 규모는 최대행수로 하면 너무 양이 많으니 **SIZE 기준 (10,000)** 까지의 테스트를 진행하면 됩니다."

## 왜 규모 축이 필요한가 — 실사고

DMF0082 저장이 **168행**에서 전면 실패했다:

    ORA-20001: ORA-06502 … 문자열 버퍼가 너무 작습니다
    ORA-06512: "SCM_MGR.PKG_DMF0082", 11399행

`V_PROC_INPUT VARCHAR2(4000 CHAR)` 에 24개 파라미터를 통째로 JSON 으로 담는데, 파라미터는 행 수만큼
`'^'` 로 이어붙인 문자열이라 `p_scm_site_id` 하나가 3,863자였다. **1행 테스트로는 절대 안 잡힌다.**
프로시저 **시작부**에서 터지므로 아무것도 저장되지 않는다("저장했는데 조회에 안 보임"과 동일 원인).

## 이 도구가 하는 일

1. 원장 실키(검증을 통과한 적 있는 조합)에서 후보를 모은다
2. 각 키의 **빈 일자**로 행을 만들어 페이로드 SIZE 가 10,000자를 넘을 때까지 누적
3. `I` 로 전건 저장 → **원장 delta** 로 실제 생성 건수 확인
4. `D` 로 전건 삭제 → 원장에서 사라졌는지 확인
5. 잔존분 정리 (저장 SP 는 내부 COMMIT 이라 rollback 이 무의미하다)

판정은 **토스트·리턴코드가 아니라 원장 delta** 다 (hook #130).
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info                                       # noqa: E402
import oracledb                                                 # noqa: E402

USER = "minyonglee1"
WIN = ["2026{0:02d}{1:02d}".format(8, d) for d in range(25, 32)] + \
      ["202609{0:02d}".format(d) for d in range(1, 29)]          # 편집가능 미래 창
TARGET_SIZE = 10000
KEYS = ("DIVISION_ID", "PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID",
        "DOM_EXP", "FCST_TYPE", "INCOTERMS", "MEASURE", "PLANT_SITE_ID", "CELL_PROD_SITE_ID")
TBL = "DM_PLN_CFM_MKT_DEMAND_PLAN"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
NL = chr(10)


def ledger_count(pairs):
    """(key, ymd) 목록의 원장 존재 건수."""
    if not pairs:
        return 0
    w = " AND ".join(f"NVL({k},'~')=NVL(:{k},'~')" for k in KEYS)
    n = 0
    for key, ymd in pairs:
        b = dict(key)
        b["y"] = ymd
        cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{TBL} WHERE {w} AND YYYYMMDD=:y", b)
        n += cur.fetchone()[0]
    return n


def cleanup(pairs):
    w = " AND ".join(f"NVL({k},'~')=NVL(:{k},'~')" for k in KEYS)
    n = 0
    for key, ymd in pairs:
        b = dict(key)
        b["y"] = ymd
        cur.execute(f"DELETE FROM SCM_MGR.{TBL} WHERE {w} AND YYYYMMDD=:y", b)
        n += cur.rowcount
    con.commit()
    return n


def build_payload(rows, flag, qty):
    """FE `buildSavePayload` 1:1 — 17 IN, 각 파라미터를 '^' 로 연결."""
    g = lambda k: [str(r[0].get(k) or "") for r in rows]          # noqa: E731
    cols = [
        [flag] * len(rows),
        g("DIVISION_ID"),
        [r[0].get("PROJECT_CODE") or r[0].get("END_CUSTOMER") or "" for r in rows],
        g("END_CUSTOMER"), g("SCM_SITE_ID"), g("ITEM_ID"), g("DOM_EXP"), g("FCST_TYPE"),
        g("INCOTERMS"), g("MEASURE"), g("PLANT_SITE_ID"), g("CELL_PROD_SITE_ID"),
        [r[1] for r in rows],                                      # yyyymmdd
        [""] * len(rows),                                          # currency
        [str(qty)] * len(rows),
    ]
    joined = ["^".join(c) for c in cols]
    return joined, sum(len(x) for x in joined)


def call_save(joined):
    args = joined + [USER, None]
    rc = con.cursor()
    try:
        cur.callproc("PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA", args + [rc])
        return rc.fetchall()
    except Exception as ex:                                       # noqa: BLE001
        return [("CALL_ERR", str(ex)[:220], "")]
    finally:
        rc.close()


# ── 후보 수집 ────────────────────────────────────────────────────────────────
cur.execute(f"""SELECT {", ".join(KEYS)} FROM SCM_MGR.{TBL}
                 WHERE DIVISION_ID='40' AND MEASURE='MKT_FCST'
                   AND CELL_PROD_SITE_ID IS NOT NULL AND CELL_PROD_SITE_ID <> '-'
                   AND YYYYMMDD BETWEEN '20260801' AND '20270201'
                 GROUP BY {", ".join(KEYS)} FETCH FIRST 60 ROWS ONLY""")
cands = [dict(zip(KEYS, r)) for r in cur.fetchall()]
print(f"== 원장 실키 후보 {len(cands)}건 ==")

rows, size = [], 0
for key in cands:
    for ymd in WIN:
        if ledger_count([(key, ymd)]) != 0:
            continue
        rows.append((key, ymd))
        _, size = build_payload(rows, "I", 7)
        if size >= TARGET_SIZE:
            break
    if size >= TARGET_SIZE:
        break

joined, size = build_payload(rows, "I", 7)
print(f"== 페이로드 구성 ==")
print(f"   행 수 {len(rows)} · **SIZE {size:,}자** (기준 {TARGET_SIZE:,})")
print(f"   최장 파라미터 {max(len(x) for x in joined):,}자  ← 구 `V_PROC_INPUT VARCHAR2(4000)` 초과 구간")
if size < TARGET_SIZE:
    print("   ⚠ 후보 부족으로 기준 미달 — 판정불가")
    con.close()
    sys.exit(1)

pre = ledger_count(rows)
print(f"{NL}== [I] 대량 저장 =={NL}   원장 pre {pre}건 (기대 0)")
out = call_save(joined)
print(f"   SP 응답: {out[0] if out else '?'}")
post = ledger_count(rows)
i_ok = (str(out[0][0]) == "0") and (post - pre == len(rows))
print(f"   원장 post {post}건 · delta {post - pre} (기대 {len(rows)})  {'PASS' if i_ok else 'FAIL'}")

d_ok = None
if i_ok:
    joined_d, _ = build_payload(rows, "D", 0)
    out = call_save(joined_d)
    print(f"{NL}== [D] 대량 삭제 =={NL}   SP 응답: {out[0] if out else '?'}")
    after = ledger_count(rows)
    d_ok = (after == pre)
    print(f"   원장 {after}건 (기대 {pre})  {'PASS' if d_ok else 'FAIL'}")

n = cleanup(rows)
print(f"{NL}== 정리: 잔존 {n}건 삭제 ==")
print(f"{NL}===== 종합 (SIZE {size:,}자 / {len(rows)}행) =====")
print(f"   [I] 대량 저장 : {'PASS' if i_ok else 'FAIL'}")
print(f"   [D] 대량 삭제 : {'PASS' if d_ok else ('FAIL' if d_ok is False else '판정불가(I 실패)')}")
con.close()
sys.exit(0 if (i_ok and d_ok) else 1)
