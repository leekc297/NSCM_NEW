# -*- coding: utf-8 -*-
"""v3 실측 재채움 — ZIOUI1 복구 후 실행 (읽기 전용 조회)

2026-09-20 시점에 ZIOUI1 서비스가 미등록(인스턴스 다운)이라
08_SAMPLEDATA_STEPNO_v3.xlsx 의 v2 유래 행은
  · `기간(실측)`  = 미측정(재조회 필요)
  · `현재값(실측)` = 미측정(재조회 필요)
상태로 남아 있다. 본 스크립트는 DB 복구 후 두 컬럼을 채우고,
동시에 **'기존' 으로 분류된 모든 행의 키가 실제로 원장에 존재하는지 재검증**한다.

  python 42_refill_measure.py            # 조회 + 리포트만
  python 42_refill_measure.py --write    # 08 xlsx 에 반영 (서식 유지, 셀 값만 갱신)

실존하지 않는 키가 나오면 `데이터보유(실측)` 에 `⚠ 키 미존재(재선별 필요)` 를 적고
종료코드 1 을 반환한다 — 임의 보정은 하지 않는다(anti-simplification).
"""
import importlib.util
import pathlib
import sys

import openpyxl

HERE = pathlib.Path(__file__).resolve().parent
XLSX = HERE.parent / "08_SAMPLEDATA_STEPNO_v3.xlsx"
NOT_MEASURED = "미측정(재조회 필요)"

_p = importlib.util.spec_from_file_location("pick", HERE / "31_pick.py")
PICK = importlib.util.module_from_spec(_p)
_p.loader.exec_module(PICK)

# 실제화면 -> (원장, 값컬럼)  — 06_build_testdata.py / 31_pick.SRC_OF 와 동일 기준
LEDGER = {
    "DMF0082": ("DM_PLN_MKT_FCST", "QTY"),
    "DMF0003": ("DM_PLN_MKT_FCST", "QTY"),
    "DMF0021": ("DM_PLN_SALES_PLAN", "QTY"),
    "DMF0020": ("SCM_MST_FUTURE_PRICE", "PRICE"),
    "DMF0042": ("DM_PLN_BIZPLAN", "QTY"),
    "DMF0005": ("SCM_MST_SITE_ITEM", None),
    "DMF0007": ("DM_MST_CUSTOMER_FCST", None),
    "DMF0072": ("DM_CUST_MODEL_MAPPING_M", None),
    "DMF0014": ("DM_PLN_CUSTOMER_PSI", "QTY"),
}
# IF STEP 의 **값 출처** 표 (31_pick.IF_VALUE_SRC 실측 기준).
# `대상원장` 표기는 하류 전이까지 적은 것이라 측정 대상이 아니다 —
# 예: 82 3-1 은 SCM_DNM_STOCK 에서 뽑았는데 대상원장은 DM_PLN_MKT_FCST_RESULT 다.
IF_SRC = {
    "81_3-2a": ("SCM_MGR", "DM_DNM_EDI_CALLOFF_HEAD"),
    "81_3-2b": ("SCM_MGR", "DM_DNM_EDI_CALLOFF_ITEM"),
    "81_3-2c": ("SCM_MGR", "DM_DNM_EDI_CALLOFF_PARTNER"),
    "81_3-2d": ("SCM_MGR", "DM_CUST_MODEL_MAPPING_M"),
    "40_3-1": ("SCM_MGR", "DM_DNM_SALES_RESULT_IF"),
    "81_5-1": ("SCM_MGR", "DM_DNM_SALES_RESULT_IF"),
    "82_4-1": ("SCM_MGR", "DM_DNM_SALES_RESULT_IF"),
    "82_3-1": ("SCM_MGR", "SCM_DNM_STOCK"),
}
DATE_CANDIDATES = ["YYYYMMDD", "YYYYMM", "PLAN_WEEK", "YMD", "BASE_YMD", "PLAN_YMD"]
SENTINEL = ("미측정", "해당없음", "재조회", "(")   # 값이 아니라 표기인 셀 — 필터로 쓰면 0건
KEY_CANDIDATES = ["ITEM_ID", "SCM_SITE_ID", "PROJECT_CODE", "FCST_TYPE",
                  "INCOTERMS", "DOM_EXP", "PLANT_SITE_ID", "CELL_PROD_SITE_ID"]
SHEETS = ["40TestData", "81TestData", "82TestData"]

_cols_cache = {}


def table_cols(cur, table):
    if table not in _cols_cache:
        cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS
                        WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t""", {"t": table})
        _cols_cache[table] = {r[0] for r in cur}
    return _cols_cache[table]


def measure_one(cur, div, table, valcol, key):
    """(데이터보유, 기간, 현재값) 반환. 조회 실패/미존재도 사실대로 돌려준다."""
    have = table_cols(cur, table)
    if not have:
        return "⚠ 표 없음({})".format(table), "-", "-"
    where, bind = [PICK.div_pred(div)] if "DIVISION_ID" in have else [], {}
    for i, (c, v) in enumerate(key.items()):
        if c not in have or v in (None, "", "-") or any(t in str(v) for t in SENTINEL):
            continue
        where.append("{} = :k{}".format(c, i))
        bind["k{}".format(i)] = v
    if not where:
        return "⚠ 조회키 없음", "-", "-"
    dcol = next((c for c in DATE_CANDIDATES if c in have), None)
    mcol = "MEASURE" if "MEASURE" in have else None
    sel = ["COUNT(*)"]
    if dcol:
        sel += ["MIN({0})".format(dcol), "MAX({0})".format(dcol)]
    cur.execute("SELECT {} FROM SCM_MGR.{} WHERE {}".format(
        ", ".join(sel), table, " AND ".join(where)), bind)
    r = cur.fetchone()
    cnt = r[0] or 0
    if not cnt:
        return "⚠ 키 미존재(재선별 필요)", "-", "-"
    period = "{} ~ {}".format(r[1], r[2]) if dcol else "-"
    curval = "-"
    if mcol and valcol and valcol in have:
        cur.execute("""SELECT {m}, COUNT(*), SUM({v}) FROM SCM_MGR.{t}
                        WHERE {w} GROUP BY {m} ORDER BY 2 DESC
                        FETCH FIRST 4 ROWS ONLY""".format(
            m=mcol, v=valcol, t=table, w=" AND ".join(where)), bind)
        curval = "; ".join("{} {}행 SUM({})={}".format(a, b, valcol, c)
                           for a, b, c in cur) or "-"
    elif valcol and valcol in have:
        cur.execute("SELECT COUNT(*), SUM({v}) FROM SCM_MGR.{t} WHERE {w}".format(
            v=valcol, t=table, w=" AND ".join(where)), bind)
        a, b = cur.fetchone()
        curval = "{}행 SUM({})={}".format(a, valcol, b)
    return "있음 {:,}행".format(cnt), period, curval


def measure_table(cur, div, table):
    """7키 축이 아닌 LAYOUT(EDI HEAD/PARTNER 등) — division 단위 실존으로 측정."""
    have = table_cols(cur, table)
    if not have:
        return "⚠ 표 없음({})".format(table), "-", "-"
    w = PICK.div_pred(div) if "DIVISION_ID" in have else "1=1"
    dcol = next((c for c in DATE_CANDIDATES if c in have), None)
    sel = ["COUNT(*)"] + ([f"MIN({dcol})", f"MAX({dcol})"] if dcol else [])
    cur.execute("SELECT {} FROM SCM_MGR.{} WHERE {}".format(", ".join(sel), table, w))
    r = cur.fetchone()
    if not r or not r[0]:
        return "⚠ 표 0행({})".format(table), "-", "-"
    return ("있음 {:,}행 (표 단위 — 이 LAYOUT 은 7키 축이 아님)".format(r[0]),
            "{} ~ {}".format(r[1], r[2]) if dcol else "-",
            "{} 전체 {:,}행".format(table, r[0]))


def main(write=False):
    wb = openpyxl.load_workbook(XLSX)
    db = PICK.connect()
    cur = db.cursor()
    n_fix = n_missing = n_skip = n_na = 0
    missing = []
    for sname in SHEETS:
        ws = wb[sname]
        hdr = {c.value: c.column for c in ws[1]}
        for row in ws.iter_rows(min_row=2):
            get = lambda c: (row[hdr[c] - 1].value if c in hdr else None)
            src = str(get("데이터출처") or "")
            if not src.startswith("기존"):
                continue
            div, scr = str(get("DIV")), str(get("실제화면"))
            step_sheet = str(get("STEP시트") or "")
            if step_sheet in IF_SRC:
                table, valcol = IF_SRC[step_sheet][1], None
            else:
                table, valcol = LEDGER.get(scr, (None, None))
            if not table:
                # 대상원장 표기는 'A/B/C → D(MEASURE)' 처럼 복합이다. 첫 표만 뽑고
                # '/' 축약·괄호·소유자 접두를 떼어낸 뒤 실존 여부를 확인한다.
                led = str(get("대상원장") or "")
                table = (led.split(",")[0].split("→")[0].strip()
                            .split(".")[-1].split("/")[0].split("(")[0].strip())
                valcol = None
                if table and not table_cols(cur, table):
                    table = None
            # 조회 전용 화면(DMF0044/0049/0035)은 저장 원장이 '-' 다.
            # 기존 실측값을 덮어쓰면 v1 측정치가 소실되므로 건너뛴다.
            if not table or table in ("-", ""):
                n_na += 1
                if write and str(get("데이터보유(실측)") or "") in ("", "None"):
                    row[hdr["데이터보유(실측)"] - 1].value =                         "해당없음 — 조회 전용 화면(저장 원장 없음)"
                    row[hdr["기간(실측)"] - 1].value = "-"
                    row[hdr["현재값(실측)"] - 1].value = "-"
                continue
            key = {c: get(c) for c in KEY_CANDIDATES}
            try:
                have, period, curval = measure_one(cur, div, table, valcol, key)
            except Exception as e:
                n_skip += 1
                have, period, curval = ("⚠ 조회오류: " + str(e).split("\n")[0][:70],
                                        "-", "-")
            # 판정 불가(원장 미지정 / 이 행의 키가 원장 컬럼과 무관한 IF 행)는
            # 덮어쓰지 않는다 — v1 실측치를 지우면 안 된다.
            if have.startswith("⚠ 조회키 없음"):
                have, period, curval = measure_table(cur, div, table)
            if have.startswith("⚠ 표 없음") or have.startswith("⚠ 조회키 없음"):
                n_na += 1
                continue
            if have.startswith("⚠ 키 미존재"):
                n_missing += 1
                missing.append((sname, get("StepNo"), get("ITEM_ID"), get("SCM_SITE_ID")))
            if write:
                row[hdr["데이터보유(실측)"] - 1].value = have
                row[hdr["기간(실측)"] - 1].value = period
                row[hdr["현재값(실측)"] - 1].value = curval
            n_fix += 1
    print("대상 '기존' 행 {:,}  /  키 미존재 {}  /  조회오류 {}  /  "
          "저장원장 없음(조회전용·미갱신) {}".format(n_fix, n_missing, n_skip, n_na))
    for m in missing[:20]:
        print("   ⚠ 미존재 {} {} {} {}".format(*m))
    if write:
        wb.save(XLSX)
        print("반영 저장 → {}".format(XLSX))
    return 1 if (n_missing or n_skip) else 0


if __name__ == "__main__":
    sys.exit(main("--write" in sys.argv))
