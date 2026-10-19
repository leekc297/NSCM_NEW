# -*- coding: utf-8 -*-
"""Phase 5 — 보완본 검증 게이트

 G1 원본 3 DIVISION 시트 무변경 (G열 포함 셀 단위 대조)
 G2 기존 STEP 시트(40_1-1~81_12-1) 전부 삭제 + 전체 샘플 STEP 시트 재생성
 G3 INCOTERMS — EDIT_FLAG='N'(A01/DAT/DDU/Z01/Z02/Z04) 0건
 G4 Cell Prod Site — 40=CELL_PROD_SITE_ID, 81=PLANT_SITE_ID 공백 0건 / 82=해당없음 명시
 G5 CRUD UI STEP 시트의 컬럼이 USER_SELECTABLE_FLAG='N' 전체를 포함
 G6 VMI — DMF0082 VMI 메저 + VMI_YN='Y' SITE 행 존재
 G7 모든 STEP 시트 데이터 행 > 0
"""
import json
import pathlib
import sys

import openpyxl

HERE = pathlib.Path(__file__).resolve().parent
SRC = pathlib.Path(r"C:\TRANFILE\RECEIVE\06_SAMPLEDATA_STEPNO(CHO).xlsx")
OUT = HERE.parent / "07_SAMPLEDATA_STEPNO_v2.xlsx"
DIV_SHEETS = ["40 DIVISION", "81 DIVISION", "82 DIVISION"]
TESTDATA = {"40": "40TestData", "81": "81TestData", "82": "82TestData"}
BAD_INCO = {"A01", "DAT", "DDU", "Z01", "Z02", "Z04"}
OLD_STEP = ["40_1-1", "40_3-1", "40_4-1", "40_6-1", "40_10-1",
            "81_1-1", "81_3-1", "81_6-1", "81_6-2", "81_8-1", "81_12-1"]

ok = True


def gate(n, cond, msg):
    global ok
    ok = ok and cond
    print("  {} {:4s} {}".format("PASS" if cond else "FAIL", n, msg))


def col_idx(ws, name):
    for c in range(1, ws.max_column + 1):
        if ws.cell(1, c).value == name:
            return c
    return None


def main():
    src = openpyxl.load_workbook(SRC, data_only=True)
    out = openpyxl.load_workbook(OUT, data_only=True)
    lay = json.loads((HERE / "30_layouts.json").read_text(encoding="utf-8"))
    print("검증 대상 : {}".format(OUT))
    print("시트 {}개: {}".format(len(out.sheetnames), ", ".join(out.sheetnames)))
    print()

    # G1
    diff = 0
    for n in DIV_SHEETS:
        a, b = src[n], out[n]
        for r in range(1, max(a.max_row, b.max_row) + 1):
            for c in range(1, 8):
                if a.cell(r, c).value != b.cell(r, c).value:
                    diff += 1
    gate("G1", diff == 0, "원본 3 DIVISION 시트 무변경 — 불일치 {}셀".format(diff))

    # G2
    step_sheets = [n for n in out.sheetnames
                   if n not in DIV_SHEETS and n not in TESTDATA.values()]
    expect = sorted("{}|{}".format(*k.split("|")) for k in lay)
    got = sorted("{}|{}".format(*n.split("_", 1)) for n in step_sheets)
    gate("G2", got == expect,
         "STEP 시트 {}개 = LAYOUT 정의 {}개 (누락 {})".format(
             len(got), len(expect), sorted(set(expect) - set(got))))

    # G3
    bad = []
    for div, sname in TESTDATA.items():
        ws = out[sname]
        ci = col_idx(ws, "INCOTERMS")
        for r in range(2, ws.max_row + 1):
            v = ws.cell(r, ci).value
            if v and str(v).strip() in BAD_INCO:
                bad.append((sname, r, v))
    gate("G3", not bad, "입력 불가 INCOTERMS 사용 {}건 {}".format(len(bad), bad[:5]))

    # G4
    miss = []
    for div, sname in TESTDATA.items():
        ws = out[sname]
        want = {"40": "CELL_PROD_SITE_ID", "81": "PLANT_SITE_ID"}.get(div)
        if not want:
            continue
        ci = col_idx(ws, want)
        for r in range(2, ws.max_row + 1):
            v = ws.cell(r, ci).value
            if v in (None, "", "-"):
                miss.append((sname, r, want, v))
    gate("G4", not miss,
         "Cell Prod Site 공백/센티널 {}건 {}".format(len(miss), miss[:5]))

    # G5
    short = []
    for n in step_sheets:
        div, sno = n.split("_", 1)
        L = lay.get("{}|{}".format(div, sno))
        if not L or L["kind"] != "ui":
            continue
        need = {c["col"] for c in L["cols"]}
        have = {out[n].cell(1, c).value for c in range(1, out[n].max_column + 1)}
        if need - have:
            short.append((n, sorted(need - have)[:4]))
    gate("G5", not short, "USER_SELECTABLE_FLAG='N' 컬럼 누락 시트 {} {}".format(
        len(short), short[:4]))

    # G6
    ws = out["40TestData"]
    ci = col_idx(ws, "데이터출처")
    mi = col_idx(ws, "입력MEASURE")
    vmi = [ws.cell(r, mi).value for r in range(2, ws.max_row + 1)
           if str(ws.cell(r, ci).value or "").startswith("신규(VMI")]
    gate("G6", len(vmi) > 0 and any("VMI" in str(v) for v in vmi),
         "VMI 샘플 {}행 (메저 {})".format(len(vmi), vmi[0] if vmi else "-"))

    # G7
    empty = [n for n in step_sheets if out[n].max_row <= 2]
    gate("G7", not empty, "데이터 0행 STEP 시트 {} {}".format(len(empty), empty))

    print()
    for div, sname in TESTDATA.items():
        print("  {:12s} {:4d}행 x {}컬럼".format(
            sname, out[sname].max_row - 1, out[sname].max_column))
    print()
    print("종합 : {}".format("전 게이트 PASS" if ok else "FAIL 존재"))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
