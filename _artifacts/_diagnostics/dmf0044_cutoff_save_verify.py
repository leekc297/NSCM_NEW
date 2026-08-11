#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_cutoff_save_verify.py — Cutoff(Data Type=1) 셀 저장 왕복 실증 (2026-08-11)

## 배경
`ui_http_e2e` 의 F 섹션(SAVE 왕복)은 관찰 대상이 `DM_PLN_SALES_PLAN_REPORT_C (DATA_TYPE='2')` 로
**ETC 계열만** 덮는다. DMF0044 의 저장은 이원화되어 있고
  · ETC(Data Type=2)    → `P_DMF0044_SAVE_SALES_PLAN_REPORT_C`     (20키 '^' bulk)
  · Cutoff(Data Type=1) → `P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF`  (22키 '^' bulk, 'M' 만)
**Cutoff 저장 경로는 자동화 커버리지가 0** 이었다 → 본 스크립트로 채운다.

## 방식 (실데이터 · 원복 보장)
기존 실행(existing) 행 1건을 골라 `기록 → M(+delta) → 원장 검증 → M(원값) → 원장 재검증`.
⚠ 저장 SP 는 내부 COMMIT 하므로 rollback 이 무의미하다([[feedback_save_sp_direct_call_commits]]).
   따라서 **원본값을 먼저 기록**하고 마지막에 같은 SP 로 되돌린 뒤 일치까지 확인한다.
   신규 행을 만들지 않으므로(‘M’ 전용) 원장 행수 불변이 추가 안전장치다.

## 대상 선정 근거
Cutoff 는 `CUTOFF_TYPE='REPORT_SP_W'` × `DATA_TYPE='1'` 행이다(ETC 전송분은 `_E` 태그라 조회 제외).
편집 매트릭스상 MEASURE='LOC' 는 계획구간(현재월 이후)이 열리므로 미래월을 고른다.

사용:
  python dmf0044_cutoff_save_verify.py            # dry-run (대상·계획만)
  python dmf0044_cutoff_save_verify.py --apply    # 실제 왕복
"""
import argparse
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

T = "SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C"
SP = "SCM_MGR.PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF"
DELTA = 7  # 원값과 확실히 구분되는 증분

# 대상 행 (2026-08-11 실측 — 실행 중 버전/미래월/LOC)
KEY = dict(
    VERSION_NO="R_S_20260810_V010_C", DIVISION_ID="40", CUTOFF_TYPE="REPORT_SP_W",
    DEPARTMENT_ID="58607728", DEPT_ID="70265670", END_CUST_REPORT="Chery_PV",
    CUST_REPORT="중국EV", PRODUCT_GROUP="원통형", ITEM_ID="MPCCERT19C1E",
    MEASURE="LOC", YYYYMMDD="20261201", CURRENCY="CNY",
    SCM_SITE_ID="Chery_CN_WHI", PROJECT_CODE="Chery_PV", COMPANY_ID="HQ00",
    FCST_TYPE="MPS", INCOTERMS="DDP",
)
# 저장 payload 전용 (원장 키는 아니지만 SP 파라미터로 필요)
EXTRA = dict(CUTOFF_YYYYMMDD="20251125", DEPARTMENT_NAME="마케팅2.아시아1", DEPT_NAME="중국EV Task")

WHERE = " AND ".join(f"{k} = :{k}" for k in KEY)


def qty(cur):
    cur.execute(f"SELECT QTY FROM {T} WHERE {WHERE} AND DATA_TYPE='1'", KEY)
    r = cur.fetchall()
    return (float(r[0][0]) if r else None), len(r)


def rowcount(cur):
    cur.execute(f"SELECT COUNT(*) FROM {T} WHERE VERSION_NO=:v AND DIVISION_ID=:d",
                {"v": KEY["VERSION_NO"], "d": KEY["DIVISION_ID"]})
    return cur.fetchone()[0]


def call_save(cur, oracledb, new_qty):
    """AS-IS Cutoff 저장 = 1행 'M' 만 (신규행 없음 — Insert 는 ETC 전용, .cs L973)."""
    args = {
        "P_ACTIVE_FLAG": "M",
        "P_DIVISION_ID": KEY["DIVISION_ID"], "P_VERSION_NO": KEY["VERSION_NO"],
        "P_CUTOFF_TYPE": KEY["CUTOFF_TYPE"], "P_CUTOFF_YYYYMMDD": EXTRA["CUTOFF_YYYYMMDD"],
        "P_DEPARTMENT_ID": KEY["DEPARTMENT_ID"], "P_DEPARTMENT_NAME": EXTRA["DEPARTMENT_NAME"],
        "P_DEPT_ID": KEY["DEPT_ID"], "P_DEPT_NAME": EXTRA["DEPT_NAME"],
        "P_END_CUST_REPORT": KEY["END_CUST_REPORT"], "P_CUST_REPORT": KEY["CUST_REPORT"],
        "P_PRODUCT_GROUP": KEY["PRODUCT_GROUP"], "P_ITEM_ID": KEY["ITEM_ID"],
        "P_MEASURE": KEY["MEASURE"], "P_YYYYMMDD": KEY["YYYYMMDD"][:6],  # FE 는 M_yyyymm → yyyymm
        "P_CURRENCY": KEY["CURRENCY"], "P_QTY": str(new_qty),
        "P_SCM_SITE_ID": KEY["SCM_SITE_ID"], "P_PROJECT_CODE": KEY["PROJECT_CODE"],
        "P_COMPANY_ID": KEY["COMPANY_ID"], "P_FCST_TYPE": KEY["FCST_TYPE"],
        "P_INCOTERMS": KEY["INCOTERMS"], "P_CREATED_BY": "claude_cutoff_verify",
    }
    out = cur.var(oracledb.DB_TYPE_CURSOR)
    args["O_RESULT_CURSOR"] = out
    cur.callproc(SP, keywordParameters=args)
    try:
        rc = out.getvalue()
        cols = [c[0] for c in rc.description] if rc.description else []
        rows = rc.fetchall()
        return dict(zip(cols, rows[0])) if rows else {}
    except Exception as e:  # noqa: BLE001
        return {"(cursor)": str(e)[:120]}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true")
    a = ap.parse_args()

    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        orig, n = qty(cur)
        total0 = rowcount(cur)
        print("[대상] %s / %s / %s / %s" % (KEY["VERSION_NO"], KEY["ITEM_ID"],
                                           KEY["MEASURE"], KEY["YYYYMMDD"]))
        print("[사전] 매칭 %d행 / QTY=%s / 버전 총 %d행" % (n, orig, total0))
        if n != 1:
            sys.exit("[error] 대상 행이 1건이 아니다 (%d) — 키 재선정 필요" % n)

        if not a.apply:
            print("\n(dry-run) 계획: M(%s → %s) → 검증 → M(원복 %s) → 재검증"
                  % (orig, orig + DELTA, orig))
            return 0

        # ── 1) 변경 저장 ────────────────────────────────────────────────────────────────
        target = orig + DELTA
        print("\n[1] SAVE 'M' QTY=%s …" % target, call_save(cur, oracledb, target))
        after, _ = qty(cur)
        ok_up = after == target
        print("    원장 QTY = %s (기대 %s) ⇒ UPDATE %s" % (after, target, "PASS" if ok_up else "FAIL"))

        # ── 2) 원복 ─────────────────────────────────────────────────────────────────────
        print("[2] SAVE 'M' 원복 QTY=%s …" % orig, call_save(cur, oracledb, orig))
        back, _ = qty(cur)
        ok_back = back == orig
        print("    원장 QTY = %s (원값 %s) ⇒ 원복 %s" % (back, orig, "PASS" if ok_back else "FAIL"))

        # ── 3) 집합 불변식 ──────────────────────────────────────────────────────────────
        total1 = rowcount(cur)
        ok_inv = total1 == total0
        print("[3] 버전 총 행수 %d → %d ⇒ 불변식 %s" % (total0, total1, "PASS" if ok_inv else "FAIL"))

        allok = ok_up and ok_back and ok_inv
        print("\n=== Cutoff 저장 왕복 종합: %s ===" % ("PASS" if allok else "FAIL"))
        return 0 if allok else 1


if __name__ == "__main__":
    sys.exit(main())
