#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Batch Price Input(Sales Price Save All) 컬럼 — **3원천 일치** 대조 (사용자 요구 2026-08-22).

> "위의 3개중 어떤 것을 사용해도 동일한 내용이 추출되어야 합니다."
>   1. DMF0082 · DMF0020 의 'Sales Price Save All'
>   2. DMF0082 'FcstNPrice' 의 DIVISION 별 값
>   3. Column 사전정보

## 포함 규칙은 VISIBLE_FLAG 가 아니다 (AS-IS 실측)

AS-IS 팝업은 `siMain.CreateSheetHeaderColumn(...)` 로 title SP 결과를 그대로 컬럼화한다
(`DMF0082_SaveSalesFuturePrice_Popup.cs:544`). 그 title SP 의 **LIVE** WHERE 절:

    DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE  L75~L81
        AND ( C.DEFAULT_FLAG = 'Y'
              OR ( C.VISIBLE_FLAG = 'N' AND C.DEFAULT_FLAG = '' AND C.VALID_YN = 'Y' ) )
        AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID, ','))

⇒ **`DEFAULT_FLAG` 이 포함을 결정**하고, division 은 CSV 토큰 정확 일치다.
   (L66~68 · L164~ 이하의 `FN_GET_DIVISION_YN` 분기는 **주석**이라 근거가 아니다 — hook #138.)

⚠ 그러므로 "VISIBLE_FLAG='N' 이라 안 보인다" 는 판정은 이 시트에 **성립하지 않는다.**
"""
import io
import json
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import asis                                                     # noqa: E402
import cfg                                                      # noqa: E402

SHEET = "Sales Price Save All"
MAIN = "FcstNPrice"
DIVS = ["40", "81", "81_UC", "81_HM", "81_ST", "81_HD", "81_HG", "82"]
COLS = ("COLUMN_NAME", "COLUMN_LABEL_NAME", "VISIBLE_FLAG", "DEFAULT_FLAG", "VALID_YN",
        "DIVISION_ID", "COLUMN_WIDTH", "SORT_ORDER_NO")
NL = chr(10)
# 의도적 확장 (AS-IS 와 다르지만 유지) — 2026-08-07 UICATEGORY 81/82 확장
KEEP_EXTRA = {dv: {"PLANT_SITE_ID"} for dv in ("82",)}
# AS-IS 와 의도적으로 다른 항목 — 사유는 패키지 apply.py 의 KEEP/OVERRIDE 에 명시
REGISTERED = {
    "CELL_PROD_SITE_ID": "81/82 판가 원장 SCM_MST_FUTURE_PRICE 에 컬럼 부재 → '40' 통일 (FcstNPrice 와 동일)",
    "PLANT_SITE_ID": "2026-08-07 UICATEGORY 81/82 확장 — 82 추가",
    # 아래 3종은 SaveAll 쪽 결함이 아니다 — AS-IS 에 FcstNPrice 행이 없거나(=TO-BE 신설),
    # AS-IS 가 두 시트를 의도적으로 다르게 정의한 경우다 (실측 2026-08-22).
    "DEPT_ID": "AS-IS 에 FcstNPrice 행 자체가 없음(SaveAll 전용) — TO-BE 가 신설한 행이라 대조 대상 아님",
    "END_CUSTOMER": "AS-IS 가 시트별로 분리 정의 — SaveAll 은 81계열(40 은 END_CUSTOMER40 로 분리) / FcstNPrice='40'",
    "NEW_FLAG": "AS-IS 에 FcstNPrice 행 자체가 없음(SaveAll='82' 전용) — TO-BE 신설 행",
}


def norm(v):
    return "" if v is None else str(v).strip()


def divset(v):
    return set(x.strip() for x in norm(v).split(",") if x.strip())


def included(r):
    """AS-IS title SP L75~L80 규칙 — DEFAULT_FLAG 이 포함을 결정한다."""
    return r["DEFAULT_FLAG"] == "Y" or (
        r["VISIBLE_FLAG"] == "N" and r["DEFAULT_FLAG"] == "" and r["VALID_YN"] == "Y")


def fetch_asis(prog, sheet):
    cur = asis._conn().cursor()
    cur.execute(f"""SELECT {", ".join(COLS)} FROM SCM_MST_SHEET_COLUMNS
                     WHERE PROGRAM_ID=? AND SHEET_NAME=?""", prog, sheet)
    return {r[0]: dict(zip(COLS, [norm(v) for v in r])) for r in cur.fetchall()}


def fetch_tobe(cur, prog, sheet):
    cur.execute(f"""SELECT {", ".join(COLS)} FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                     WHERE PROGRAM_ID=:p AND SHEET_NAME=:s""", p=prog, s=sheet)
    return {r[0]: dict(zip(COLS, [norm(v) for v in r])) for r in cur.fetchall()}


con = cfg.tobe_connect()
cur = con.cursor()

A82 = fetch_asis("DMF0082", SHEET)
A20 = fetch_asis("DMF0020", SHEET)
T82 = fetch_tobe(cur, "DMF0082", SHEET)
T20 = fetch_tobe(cur, "DMF0020", SHEET)
TMAIN = fetch_tobe(cur, "DMF0082", MAIN)
AMAIN = fetch_asis("DMF0082", MAIN)

print("== 원천별 행수 ==")
for nm, d in (("AS-IS DMF0082/" + SHEET, A82), ("AS-IS DMF0020/" + SHEET, A20),
              ("TO-BE DMF0082/" + SHEET, T82), ("TO-BE DMF0020/" + SHEET, T20),
              ("AS-IS DMF0082/" + MAIN, AMAIN), ("TO-BE DMF0082/" + MAIN, TMAIN)):
    print(f"   {nm:40s} {len(d):4d}행")

# ---------- 원천 1: Save All (AS-IS DMF0082 ∪ DMF0020) ----------
def per_div(meta, rule):
    """rule='asis' → AS-IS DEFAULT_FLAG 규칙 / rule='tobe' → **VISIBLE_FLAG='Y'**.

    ⭐ 사용자 지시(2026-08-22): "As-is의 Default_flag 로 값을 확정 한 후 Visible='Y' 로 처리해서
       Tobe 는 Visible 을 바라보는 표준으로 구현되도록" — 그러므로 TO-BE 에 AS-IS 규칙을 그대로
       적용하면 오탐이 난다(실제로 AUTHORITY_YN 등 4종이 거짓 '누락'으로 잡혔다).
    """
    f = included if rule == "asis" else (lambda r: r["VISIBLE_FLAG"] == "Y")
    out = {}
    for dv in DIVS:
        out[dv] = sorted(c for c, r in meta.items() if f(r) and dv in divset(r["DIVISION_ID"]))
    return out


S1_82, S1_20 = per_div(A82, "asis"), per_div(A20, "asis")
S1T_82, S1T_20 = per_div(T82, "tobe"), per_div(T20, "tobe")

print(f"{NL}== 원천1 — AS-IS 'Sales Price Save All' division 별 컬럼 수 ==")
print(f"   {'DIV':8s} {'DMF0082':>8s} {'DMF0020':>8s}  차이(0082-0020)")
for dv in DIVS:
    a, b = set(S1_82[dv]), set(S1_20[dv])
    print(f"   {dv:8s} {len(a):8d} {len(b):8d}  +{sorted(a-b) or '-'} / -{sorted(b-a) or '-'}")

print(f"{NL}== 원천1 AS-IS ↔ TO-BE (DMF0082) division 별 차이 ==")
gap1 = {}
for dv in DIVS:
    a, t = set(S1_82[dv]), set(S1T_82[dv])
    a, t = a - set(REGISTERED), t - set(REGISTERED)   # 등록된 의도적 차이는 세지 않는다
    if a != t:
        gap1[dv] = {"missing": sorted(a - t), "extra": sorted(t - a)}
        print(f"   {dv:8s} AS-IS {len(a):3d} / TO-BE {len(t):3d}   "
              f"TO-BE 누락={sorted(a - t) or '-'}  TO-BE 추가={sorted(t - a) or '-'}")
if not gap1:
    print("   차이 없음")

gap1_20 = {dv: {"missing": sorted(set(S1_20[dv]) - set(S1T_20[dv])),
                "extra": sorted(set(S1T_20[dv]) - set(S1_20[dv]))}
           for dv in DIVS if set(S1_20[dv]) != set(S1T_20[dv])}
print(f"{NL}== 원천1 AS-IS ↔ TO-BE (DMF0020) ==")
print("   " + ("차이 없음" if not gap1_20 else str(gap1_20)))

# ---------- 원천 2: TO-BE FcstNPrice 의 division 값 ----------
#   실제 화면이 소비하는 것은 TO-BE 이므로 TO-BE ↔ TO-BE 로 본다.
print(f"{NL}== 원천2 — TO-BE 'Sales Price Save All' ↔ TO-BE 'FcstNPrice' DIVISION_ID ==")
n2, n2_reg = 0, 0
for c in sorted(set(T82) & set(TMAIN)):
    ds_, dm = divset(T82[c]["DIVISION_ID"]), divset(TMAIN[c]["DIVISION_ID"])
    if ds_ == dm:
        continue
    if c in REGISTERED:
        n2_reg += 1
        print(f"   [등록] {c:20s} SaveAll={sorted(ds_)} / FcstNP={sorted(dm)} — {REGISTERED[c]}")
        continue
    n2 += 1
    print(f"   {c:22s} SaveAll={sorted(ds_)}")
    print(f"   {'':22s} FcstNP ={sorted(dm)}")
print(f"   ---- 미등록 불일치 {n2}건 · 등록된 차이 {n2_reg}건 / 공통 {len(set(T82) & set(TMAIN))}개")
print(f"   (SaveAll 전용 컬럼 {sorted(set(T82)-set(TMAIN))} — 시트 고유이므로 대조 대상 아님)")

# ---------- 원천 3: Column 사전 ----------
print(f"{NL}== 원천3 — Column 사전(dict_sheet_columns.json) 대조 ==")
dic = json.load(io.open(
    r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821\dict_sheet_columns.json",
    encoding="utf-8"))
ent = {e["key"]: e for e in dic["columns"]}
print(f"   사전 컬럼 {len(ent)}종 · 스냅샷 {dic['meta'].get('snapshot', '?')}")
miss = sorted(c for c in T82 if c.upper() not in ent)
print(f"   본 시트 {len(T82)}종 중 사전 미수록 {len(miss)}종 {miss or ''}")

# 사전의 division_usage 가 시트 실측 division 을 포함하는가
bad3 = []
for c, r in sorted(T82.items()):
    e = ent.get(c.upper())
    if not e:
        continue
    du = e.get("division_usage") or {}
    used = set(du) if isinstance(du, dict) else set(du or [])
    need = divset(r["DIVISION_ID"])
    if need and used and not need <= used:
        bad3.append((c, sorted(need - used)))
print(f"   division_usage 미포함 {len(bad3)}건")
for c, d in bad3[:10]:
    print(f"      {c:24s} 사전에 없는 division={d}")

# ---------- 최종: 3원천 동일 여부 ----------
print(f"{NL}== 최종 — 3원천 동일 판정 ==")
ok1 = not gap1
print(f"   원천1 DMF0082 AS-IS ↔ TO-BE            : {'PASS' if ok1 else 'FAIL ' + str(gap1)}")
print(f"   원천1 DMF0020 AS-IS ↔ TO-BE            : {'PASS' if not gap1_20 else 'FAIL ' + str(gap1_20)}")
print(f"   원천2 TO-BE SaveAll ↔ TO-BE FcstNPrice  : {'PASS' if n2 == 0 else 'FAIL ' + str(n2) + '건'}"
      f"  (등록된 의도적 차이 {n2_reg}건 제외)")
print(f"   원천3 Column 사전 division_usage       : {'PASS' if not bad3 else 'FAIL'}")
