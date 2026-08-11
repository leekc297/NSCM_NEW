#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_exchange_sheet_meta_apply.py — 환율 Modal 컬럼 메타 등재 (2026-08-10)

## 왜

TO-BE `ExchangeRateModal.tsx` 가 정적 3컬럼을 **소스에 하드코딩**하고 있었다(hook #113 위반 —
"컬럼은 admin 동적 메타가 소유"). 실측 결과 `SCM_MST_SHEET_COLUMNS` 에 환율 팝업 시트가 **미등록**이다
(DMF0044 등록분 = `MDF Reports` 46 / `MDFVerpopup` 12 뿐).

## 등재 내용 — AS-IS 원문 1:1

`DMF0044_SalesReportExchangePopup.cs`:
- L55  `shtMain = "Sales Price PopUp"`  ⇒ **SHEET_NAME 은 AS-IS 원문 그대로**(변경 금지 규약)
- L253 `AddComboColumn("Division", DIVISION_ID, Restricted, 120, true, dtDivision2)`  → 콤보 `Division`
- L254 `AddTextColumn("Currency", CURRENCY, Restricted, 70, true)`
- L255 `AddComboColumn("Unit", UNIT_CURRENCY, None, 50, true, dtCurrency)`          → 콤보 `CurrencyList`
- L256 `AddTextColumn("Currency", CURRENCY_UNITCURRENCY, Restricted, 50, **false**)` → **VISIBLE 'N'**

사용자 제공 AS-IS 캡쳐(2026-08-10)와도 일치 — 보이는 고정 컬럼은 **Div / Currency / Unit 3개**이고
4번째 `CURRENCY_UNITCURRENCY` 는 화면에 없다(내부 키 컬럼).

## 규약 준수
- **INSERT-only** — MERGE INTO / DELETE 금지 (hook #98 §9). 이미 존재하면 건너뛴다(멱등).
- 감사컬럼 **'admin' 고정** (claude ID 금지).
- `DIVISION_ID` 는 `MDFVerpopup` 등록분과 동일 값 세트를 그대로 승계 (팝업은 division 무관 공용).

사용: python dmf0044_exchange_sheet_meta_apply.py --plan / --apply / --verify
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

PROGRAM_ID = "DMF0044"
# ⭐ TO-BE 등록명 = 'exchangeRate' (사용자 확정 2026-08-10).
#   FE 는 `/admin/menu/DMF0044/column` 에 `sheetNm` 을 그대로 실어 보내므로 SHEET_NAME 은
#   **TO-BE 배선 시트명**과 같아야 한다 — AS-IS FarPoint 시트명('Sales Price PopUp')이 아니다.
#   (버전 팝업이 SP배선 'unitedVersion' ↔ 컬럼메타 'MDFVerpopup' 로 갈리는 것과 달리,
#    환율 팝업은 SCM_ADM_MNU_BTN_MPG_M 등록명 'exchangeRate' 를 컬럼 메타에도 그대로 쓴다.)
SHEET_NAME = "exchangeRate"
# 2026-08-10 오등재 정정 대상 — 본 스크립트가 같은 날 잘못 넣은 AS-IS 시트명 행(--fix-wrong-sheet)
WRONG_SHEET = "Sales Price PopUp"
DIVS = "40,82,81,81_UC,81_HM,81_ST,81_HD,81_HG"  # MDFVerpopup 등록분 승계

# (COLUMN_NAME, LABEL, SORT, WIDTH, CTL, COMBO, ALIGN, VISIBLE, INPUT_TP_CD)
#   INPUT_TP_CD: 'IM' = Insert/Modify 편집 가능 / 'S' = 조회 전용
#   AS-IS: Division·Unit 은 InsertRow 에서 셀 콤보로 편집(L627), Currency 는 InsertRow 가 잠근다(L628)
COLS = [
    ("DIVISION_ID", "Div", 10, 120, "FPComboBox", "Division", "L", "Y", "IM"),
    ("CURRENCY", "Currency", 20, 70, None, None, "L", "Y", "S"),
    ("UNIT_CURRENCY", "Unit", 30, 50, "FPComboBox", "CurrencyList", "L", "Y", "IM"),
    ("CURRENCY_UNITCURRENCY", "Currency", 40, 50, None, None, "L", "N", "S"),
]

INS = """
INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS
  (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO,
   FIXED_FLAG, COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE,
   HORIZONTAL_ALIGN_CODE, VISIBLE_FLAG, DIVISION_ID, VALID_YN, INPUT_TP_CD,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (:pid, :sht, :col, :lbl, :so, 'Y', :w, :ctl, :cmbo, :al, :vis, :div, 'Y', :itc,
        'admin', SYSDATE, 'admin', SYSDATE)
"""


def rows_present(cur):
    cur.execute(
        """SELECT COLUMN_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
            WHERE PROGRAM_ID=:p AND SHEET_NAME=:s""",
        {"p": PROGRAM_ID, "s": SHEET_NAME},
    )
    return {r[0] for r in cur.fetchall()}


def main():
    import oracledb

    ap = argparse.ArgumentParser()
    for f in ("plan", "apply", "verify"):
        ap.add_argument("--" + f, action="store_true")
    ap.add_argument("--fix-wrong-sheet", action="store_true",
                    help="2026-08-10 본 스크립트가 오등재한 AS-IS 시트명 행만 제거(당일 'admin' 생성분 한정)")
    a = ap.parse_args()
    if not (a.plan or a.apply or a.verify or a.fix_wrong_sheet):
        ap.error("--plan / --apply / --verify / --fix-wrong-sheet 중 하나 필요")

    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()

    if a.fix_wrong_sheet:
        # ⚠ 이관 메타 DELETE 금지 규약의 예외가 아니다 — **본 세션이 방금 만든 오등재 행**을
        #   되돌리는 것이며, 조건을 '오늘 + admin + 그 시트명' 으로 좁혀 다른 행에 닿지 않게 한다.
        cur.execute(
            """DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                WHERE PROGRAM_ID=:p AND SHEET_NAME=:s
                  AND CREATED_BY='admin' AND CREATION_DATE >= TRUNC(SYSDATE)""",
            {"p": PROGRAM_ID, "s": WRONG_SHEET},
        )
        n = cur.rowcount
        con.commit()
        cur.execute(
            "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:p AND SHEET_NAME=:s",
            {"p": PROGRAM_ID, "s": WRONG_SHEET},
        )
        print("[fix] 오등재 시트 %r 제거 %d건 / 잔존 %d건" % (WRONG_SHEET, n, cur.fetchone()[0]))

    have = rows_present(cur)
    todo = [c for c in COLS if c[0] not in have]

    if a.plan or a.apply:
        print("[%s] PROGRAM_ID=%s SHEET_NAME=%r" % ("apply" if a.apply else "plan", PROGRAM_ID, SHEET_NAME))
        print("  기존 등록 %d건 / 신규 대상 %d건 (INSERT-only, 기존 행은 건드리지 않음)"
              % (len(have), len(todo)))
        for c in todo:
            print("    + %-24s %-10s so=%-3d w=%-4d ctl=%-11s cmbo=%-12s vis=%s itc=%s"
                  % (c[0], c[1], c[2], c[3], c[4] or "-", c[5] or "-", c[7], c[8]))
        if a.apply and todo:
            for c in todo:
                cur.execute(INS, {"pid": PROGRAM_ID, "sht": SHEET_NAME, "col": c[0], "lbl": c[1],
                                  "so": c[2], "w": c[3], "ctl": c[4], "cmbo": c[5], "al": c[6],
                                  "vis": c[7], "div": DIVS, "itc": c[8]})
            con.commit()
            print("  INSERT %d건 커밋" % len(todo))
        elif a.apply:
            print("  신규 없음 — 멱등 skip")

    if a.verify or a.apply:
        cur.execute(
            """SELECT COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, COLUMN_WIDTH,
                      NVL(CELL_CONTROL_OBJECT_TYPE_CODE,'-'), NVL(CELL_COMBO_DATA_TYPE,'-'),
                      VISIBLE_FLAG, INPUT_TP_CD, CREATED_BY
                 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                WHERE PROGRAM_ID=:p AND SHEET_NAME=:s ORDER BY SORT_ORDER_NO""",
            {"p": PROGRAM_ID, "s": SHEET_NAME},
        )
        print("\n[verify] 등재 결과")
        for r in cur.fetchall():
            print("  %-24s %-10s so=%-3d w=%-4d ctl=%-11s cmbo=%-12s vis=%s itc=%-2s by=%s" % r)
        bad = [c for c in COLS if c[0] not in rows_present(cur)]
        print("  누락 %d건 %s" % (len(bad), [c[0] for c in bad] or "✅"))
    con.close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
