#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_sheet_columns_diff.py — DMF0044 SHEET_COLUMNS AS-IS ↔ TO-BE 전수 대조 (2026-08-10)

사용자 요청: "GRID COLUMN 의 경우에는 AS-IS DB와 UI CATEGORY SETUP 데이터를 확인해서 비교".

⛔ **SHEET_NAME 은 절대 변경 불가** — 본 스크립트는 **읽기 전용**이며 어떤 DDL/DML 도 실행하지 않는다.
⛔ 클라우드 이관 시에도 `SHEET_NAME` 기준 **일괄 DELETE 금지**(사용자 확정 2026-08-10).
   메타 이관은 INSERT-only + 행 단위 UPDATE 만 허용(hook #98 §9).

사용: python dmf0044_sheet_columns_diff.py [--menu DMF0044] [--sheet "MDF Reports"]
"""
import argparse
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

# 대조 대상 속성 — 화면 렌더에 직접 영향을 주는 것만(감사 컬럼 제외)
COLS = [
    "COLUMN_LABEL_NAME", "SORT_ORDER_NO", "SMALL_CLASS_LABEL_NAME", "LARGE_CLASS_LABEL_NAME",
    "FIXED_FLAG", "COLUMN_WIDTH", "CELL_CONTROL_OBJECT_TYPE_CODE", "CELL_COMBO_DATA_TYPE",
    "DATA_SCALE_NUMBER", "DATA_MAX_LENGTH", "HORIZONTAL_ALIGN_CODE", "VISIBLE_FLAG",
    "DIVISION_ID", "DEFAULT_FLAG", "USER_SELECTABLE_FLAG", "VALID_YN",
    "ATTRIBUTE1", "ATTRIBUTE3", "INPUT_TP_CD",
]


def norm(v):
    """비교 정규화 — None/공백 문자열은 모두 '' 로 본다(센티널 공백 규약)."""
    if v is None:
        return ""
    s = str(v).strip()
    return s


def fetch_tobe(menu, sheet):
    import oracledb
    from ora import conn_info

    u, p, d = conn_info()
    sel = ", ".join(COLS)
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(
            f"""SELECT COLUMN_NAME, {sel} FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                 WHERE PROGRAM_ID = :m AND SHEET_NAME = :s""",
            {"m": menu, "s": sheet},
        )
        return {r[0]: dict(zip(COLS, r[1:])) for r in cur.fetchall()}


def fetch_asis(menu, sheet):
    import pyodbc  # noqa: F401  (asis.py 가 사용)
    import asis

    cn = asis._conn()
    cur = cn.cursor()
    sel = ", ".join(COLS)
    cur.execute(
        f"""SELECT COLUMN_NAME, {sel} FROM SCM_MST_SHEET_COLUMNS
             WHERE PROGRAM_ID = ? AND SHEET_NAME = ?""",
        menu, sheet,
    )
    out = {r[0]: dict(zip(COLS, r[1:])) for r in cur.fetchall()}
    cn.close()
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--menu", default="DMF0044")
    ap.add_argument("--sheet", default="MDF Reports")
    a = ap.parse_args()

    tobe = fetch_tobe(a.menu, a.sheet)
    try:
        asis = fetch_asis(a.menu, a.sheet)
    except Exception as e:  # noqa: BLE001
        sys.exit("[error] AS-IS 접속 실패 — 대조 불가(추정 금지): %s" % str(e)[:200])

    print(f"# {a.menu} / SHEET_NAME='{a.sheet}' — SHEET_COLUMNS AS-IS ↔ TO-BE 전수 대조")
    print(f"\nAS-IS {len(asis)}행 / TO-BE {len(tobe)}행\n")

    only_asis = sorted(set(asis) - set(tobe))
    only_tobe = sorted(set(tobe) - set(asis))
    both = sorted(set(asis) & set(tobe))

    print(f"## 1. 컬럼 집합 — 공통 {len(both)} / AS-IS 전용 {len(only_asis)} / TO-BE 전용 {len(only_tobe)}")
    if only_asis:
        print("\n**AS-IS 에만 있음(TO-BE 미이관 의심)**")
        for c in only_asis:
            print(f"  - {c}  (label={norm(asis[c]['COLUMN_LABEL_NAME'])} / visible={norm(asis[c]['VISIBLE_FLAG'])})")
    if only_tobe:
        print("\n**TO-BE 에만 있음(신설 — 사유 필요)**")
        for c in only_tobe:
            print(f"  - {c}  (label={norm(tobe[c]['COLUMN_LABEL_NAME'])} / visible={norm(tobe[c]['VISIBLE_FLAG'])})")
    if not only_asis and not only_tobe:
        print("\n→ **집합 완전 일치** ✅")

    print("\n## 2. 공통 컬럼 속성 차이")
    diffs = []
    for c in both:
        for k in COLS:
            av, tv = norm(asis[c][k]), norm(tobe[c][k])
            if av != tv:
                diffs.append((c, k, av, tv))
    if not diffs:
        print("\n→ **전 속성 일치** ✅ (정규화: NULL≡공백)")
    else:
        print(f"\n차이 **{len(diffs)}건**\n")
        print("| COLUMN_NAME | 속성 | AS-IS | TO-BE |")
        print("|---|---|---|---|")
        for c, k, av, tv in diffs:
            print(f"| {c} | {k} | `{av or '(공백)'}` | `{tv or '(공백)'}` |")

    print("\n## 3. 헤더 단수 판정 (TO-BE 공용 `getColumnDepth` 규약)")
    print("\n> 1단 조건 = 전 행이 `(SCLS·LCLS 둘 다 공백)` **또는** `(colLbl = SCLS = LCLS)`")
    for label, src in (("AS-IS", asis), ("TO-BE", tobe)):
        bad = [
            c for c, r in src.items()
            if not (
                (not norm(r["SMALL_CLASS_LABEL_NAME"]) and not norm(r["LARGE_CLASS_LABEL_NAME"]))
                or (norm(r["COLUMN_LABEL_NAME"]) == norm(r["SMALL_CLASS_LABEL_NAME"])
                    == norm(r["LARGE_CLASS_LABEL_NAME"]))
            )
        ]
        verdict = "1단" if not bad else f"2단 이상 (조건 위반 {len(bad)}행: {', '.join(sorted(bad))})"
        print(f"\n- **{label}** → {verdict}")
    print("\n> ⚠ AS-IS 화면은 메타와 무관하게 `DMF0044_Sales_Reports.cs:235~236` 이")
    print(">   `iColumnHeaderRowCount = 1` 을 넘겨 **1단으로 강제**한다. 즉 AS-IS 에서")
    print(">   SMALL/LARGE_CLASS_LABEL_NAME 은 1단 화면에서 **표시에 쓰이지 않는다**.")
    print(">   ⇒ 메타를 고치는 게 아니라 **화면이 1단임을 선언**해야 파리티가 맞는다.")


if __name__ == "__main__":
    main()
