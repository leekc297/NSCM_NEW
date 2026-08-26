#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""'Sales Price Save All' — AS-IS DEFAULT_FLAG 로 확정 → TO-BE VISIBLE_FLAG 로 표현 (사용자 지시 2026-08-22).

> "As-is의 Default_flag 로 값을 확정 한 후 Visible = 'Y' 로 처리해서
>  Tobe 는 Visible 을 바라보는 표준으로 구현되도록 해주세요."

## 왜 VISIBLE_FLAG 가 기준이 아니었나 (AS-IS 실측)

AS-IS 팝업은 title SP 결과를 그대로 컬럼화한다
(`DMF0082_SaveSalesFuturePrice_Popup.cs:544  siMain.CreateSheetHeaderColumn(...)`).
그 title SP 의 **LIVE** WHERE 절(주석 아님 — hook #138):

    DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE  L75~L81
        AND ( C.DEFAULT_FLAG = 'Y'
              OR ( C.VISIBLE_FLAG = 'N' AND C.DEFAULT_FLAG = '' AND C.VALID_YN = 'Y' ) )
        AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID, ','))

⇒ 포함을 결정하는 것은 **`DEFAULT_FLAG`** 이고 `VISIBLE_FLAG` 는 보조 조건이다.
   그래서 TO-BE 가 `VISIBLE_FLAG` 만 보면 AS-IS 와 결과가 어긋난다.

## 정정 방침 (사용자 지시)

    AS-IS 포함 판정  =  DEFAULT_FLAG='Y' OR (VISIBLE_FLAG='N' AND DEFAULT_FLAG='' AND VALID_YN='Y')
    TO-BE VISIBLE_FLAG := 'Y' if 포함 else 'N'
    TO-BE DIVISION_ID  := AS-IS 실값 (등록된 의도적 확장은 보존)

이후 TO-BE 는 **VISIBLE_FLAG 만 보면 된다** — FE 는 이미 그 표준이다:
`SavePricePeriodModal.tsx:286  .filter(c => c.visible !== false && c.colNm !== 'PRICE_ALL')`
(`PRICE_ALL` 은 편집 상수로 별도 append 하므로 메타를 'Y' 로 바꿔도 중복되지 않는다.)

## 의도적 확장 (AS-IS 와 다르지만 되돌리지 않음)

    DMF0082 / PLANT_SITE_ID  DIVISION_ID  AS-IS 81계열 → TO-BE 81계열 + '82'
      근거: 2026-08-07 UICATEGORY 81/82 확장. 82 는 81 과 동일 경로이며
            81/82 판가 원장 SCM_MST_FUTURE_PRICE 에 PLANT_SITE_ID 컬럼이 실재한다.

## 대상

    PROGRAM_ID ∈ {DMF0082, DMF0020}  ·  SHEET_NAME = 'Sales Price Save All'

목표값은 **AS-IS 에서 런타임 산출**한다 (하드코딩 금지 — ui-category-setup-no-arbitrary-data).
멱등: 이미 같으면 무변경. 실행: python apply.py   (점검만: --dry)
"""
import os
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import asis                                                     # noqa: E402
import cfg                                                      # noqa: E402

SHEET = "Sales Price Save All"
PROGS = ("DMF0082", "DMF0020")
BAK = "BAK_SHEETCOL_SAVEPRICE_20260822"
NL = chr(10)
COLS = ("COLUMN_NAME", "VISIBLE_FLAG", "DEFAULT_FLAG", "VALID_YN", "DIVISION_ID", "COLUMN_WIDTH")

# AS-IS 와 다르지만 **현재 TO-BE 값을 그대로 유지**하는 항목 — (PROGRAM_ID, COLUMN_NAME, 속성) → 사유
KEEP = {
    ("DMF0082", "PLANT_SITE_ID", "DIVISION_ID"):
        "2026-08-07 UICATEGORY 81/82 확장 — 82 는 81 동일 경로, SCM_MST_FUTURE_PRICE 에 컬럼 실재",
}

# AS-IS 도 TO-BE 현재값도 아닌 **명시 목표값**으로 강제하는 항목 → (값, 사유)
OVERRIDE = {
    ("DMF0082", "CELL_PROD_SITE_ID", "DIVISION_ID"): ("40",
        "AS-IS 'Sales Price Save All' 은 8 division 이지만 **81/82 판가 원장 "
        "SCM_MST_FUTURE_PRICE 에 CELL_PROD_SITE_ID 컬럼이 없다**(실측) — 81/82 는 항상 빈 칸이 된다. "
        "같은 컬럼을 메인 시트 FcstNPrice 에서 이미 '40' 으로 확정했고(사용자 결정 2026-08-22), "
        "사용자 요구 '3원천 동일'을 만족시키려면 두 시트가 같아야 하므로 '40' 으로 통일한다."),
}


def n(v):
    return "" if v is None else str(v).strip()


def included(r):
    """AS-IS title SP L75~L80 규칙."""
    return r["DEFAULT_FLAG"] == "Y" or (
        r["VISIBLE_FLAG"] == "N" and r["DEFAULT_FLAG"] == "" and r["VALID_YN"] == "Y")


def asis_rows(prog):
    cur = asis._conn().cursor()
    cur.execute(f"""SELECT {", ".join(COLS)} FROM SCM_MST_SHEET_COLUMNS
                     WHERE PROGRAM_ID=? AND SHEET_NAME=?""", prog, SHEET)
    return {r[0]: dict(zip(COLS, [n(v) for v in r])) for r in cur.fetchall()}


def tobe_rows(cur, prog):
    cur.execute(f"""SELECT {", ".join(COLS)} FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                     WHERE PROGRAM_ID=:p AND SHEET_NAME=:s""", p=prog, s=SHEET)
    return {r[0]: dict(zip(COLS, [n(v) for v in r])) for r in cur.fetchall()}


def divset(v):
    return set(x.strip() for x in n(v).split(",") if x.strip())


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    plan = []          # (prog, col, attr, before, after, why)
    for prog in PROGS:
        A, T = asis_rows(prog), tobe_rows(cur, prog)
        if not A:
            sys.exit(f"[ABORT] AS-IS {prog}/{SHEET} 0행 — 중단.")
        only_t = sorted(set(T) - set(A))
        only_a = sorted(set(A) - set(T))
        print(f"== {prog} — AS-IS {len(A)}행 / TO-BE {len(T)}행 ==")
        if only_a:
            print(f"   ⚠ TO-BE 에 없는 AS-IS 컬럼 {only_a} — 본 패키지는 INSERT 하지 않는다(보고만).")
        if only_t:
            print(f"   ⚠ AS-IS 에 없는 TO-BE 컬럼 {only_t} — 판정 제외(보고만).")

        for c in sorted(set(A) & set(T)):
            # OVERRIDE 는 AS-IS 보다 우선한다 (근거는 OVERRIDE 딕셔너리에 명시)
            for attr in ("VISIBLE_FLAG", "DIVISION_ID"):
                ov = OVERRIDE.get((prog, c, attr))
                if ov and T[c][attr] != ov[0]:
                    plan.append((prog, c, attr, T[c][attr], ov[0], "OVERRIDE: " + ov[1][:60]))

            if (prog, c, "VISIBLE_FLAG") in OVERRIDE:
                continue
            want_v = "Y" if included(A[c]) else "N"
            if T[c]["VISIBLE_FLAG"] != want_v:
                plan.append((prog, c, "VISIBLE_FLAG", T[c]["VISIBLE_FLAG"], want_v,
                             f"AS-IS DEFAULT_FLAG={A[c]['DEFAULT_FLAG'] or '(공란)'}"
                             f" VALID_YN={A[c]['VALID_YN']} → {'포함' if want_v == 'Y' else '제외'}"))
            if divset(A[c]["DIVISION_ID"]) != divset(T[c]["DIVISION_ID"]):
                key = (prog, c, "DIVISION_ID")
                if key in OVERRIDE:
                    continue
                if key in KEEP:
                    print(f"   [유지] {c}.DIVISION_ID TO-BE={T[c]['DIVISION_ID']} — {KEEP[key]}")
                    continue
                plan.append((prog, c, "DIVISION_ID", T[c]["DIVISION_ID"], A[c]["DIVISION_ID"],
                             "AS-IS 실값 복사"))

    print(f"{NL}== 변경 계획 {len(plan)}건 ==")
    if not plan:
        print("   무변경 — 이미 AS-IS 기준과 일치")
        con.close()
        return 0
    for prog, c, attr, b, a, why in plan:
        print(f"   {prog} {c:20s} {attr:14s} {b!r:12s} → {a!r:52s} {why}")

    if dry:
        print(f"{NL}== --dry: DB 미적용 종료 ==")
        con.close()
        return 0

    # 백업 (최초 1회) — 대상 두 프로그램의 시트 전량
    cur.execute("SELECT COUNT(*) FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t", t=BAK)
    if cur.fetchone()[0] == 0:
        cur.execute(f"""CREATE TABLE SCM_MGR.{BAK} AS
                        SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                         WHERE SHEET_NAME='{SHEET}' AND PROGRAM_ID IN ('DMF0082','DMF0020')""")
        con.commit()
        cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{BAK}")
        print(f"{NL}== BACKUP {BAK} {cur.fetchone()[0]}행 생성 ==")
    else:
        print(f"{NL}== BACKUP {BAK} 기존 유지 ==")

    for prog, c, attr, _b, a, _w in plan:
        cur.execute(f"""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                           SET {attr}=:v, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                         WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c""",
                    v=a, p=prog, s=SHEET, c=c)
    con.commit()
    print(f"== UPDATE {len(plan)}건 적용 ==")

    print(f"{NL}== VERIFY — AS-IS 포함판정 ↔ TO-BE VISIBLE_FLAG 일치 ==")
    bad = 0
    for prog in PROGS:
        A, T = asis_rows(prog), tobe_rows(cur, prog)
        miss = [c for c in sorted(set(A) & set(T))
                if T[c]["VISIBLE_FLAG"] != ("Y" if included(A[c]) else "N")]
        dv = []
        for c in sorted(set(A) & set(T)):
            key = (prog, c, "DIVISION_ID")
            if key in OVERRIDE:
                if T[c]["DIVISION_ID"] != OVERRIDE[key][0]:
                    dv.append(c + "(OVERRIDE 미반영)")
                continue
            if key in KEEP:
                continue
            if divset(A[c]["DIVISION_ID"]) != divset(T[c]["DIVISION_ID"]):
                dv.append(c)
        print(f"   {'PASS' if not miss else 'FAIL'}  {prog} VISIBLE 불일치 {len(miss)}건 {miss or ''}")
        print(f"   {'PASS' if not dv else 'FAIL'}  {prog} DIVISION_ID 불일치 {len(dv)}건 {dv or ''}")
        bad += len(miss) + len(dv)

    print(f"{NL}== division 별 표시 컬럼 수 (TO-BE VISIBLE='Y' 기준) ==")
    for prog in PROGS:
        T = tobe_rows(cur, prog)
        for dv in ("40", "81", "82"):
            k = [c for c, r in T.items() if r["VISIBLE_FLAG"] == "Y" and dv in divset(r["DIVISION_ID"])]
            print(f"   {prog} div {dv:4s} {len(k):3d}컬럼")

    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
