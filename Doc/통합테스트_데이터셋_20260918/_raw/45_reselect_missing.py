# -*- coding: utf-8 -*-
"""'기존' 분류인데 원장에 키가 없는 행 재선별 (2026-09-21)

사용자 요구 — "기존에 존재하던 데이터의 경우 실제 존재하는 데이터를 기준으로 생성"
42_refill_measure.py 가 `⚠ 키 미존재(재선별 필요)` 로 찍은 행은 이 요구를 위반한다.
본 스크립트가 **같은 원장에서 실존하는 조합**으로 키를 교체한다.

선별 규칙 (v2 31_pick.existing_rows 와 동일)
  · 같은 DIVISION · 같은 원장
  · 7키 조합 단위 GROUP BY 행수 **상위**
  · INCOTERMS 는 입력 가능(EDIT_FLAG='Y') 값만
  · Cell Prod Site 축 컬럼(40=CELL_PROD_SITE_ID / 81=PLANT_SITE_ID) 비어있지 않은 것

교체한 행은 `분류기준` 에 재선별 사유·일자를, `행출처` 에 `+재선별(YYYY-MM-DD)` 를 남긴다.

  python 45_reselect_missing.py            # 리포트만
  python 45_reselect_missing.py --write    # 08 xlsx 반영
"""
import datetime
import importlib.util
import pathlib
import sys

import openpyxl

HERE = pathlib.Path(__file__).resolve().parent
XLSX = HERE.parent / "08_SAMPLEDATA_STEPNO_v3.xlsx"
TODAY = datetime.date.today().isoformat()
SHEETS = ["40TestData", "81TestData", "82TestData"]

_m = importlib.util.spec_from_file_location("refill", HERE / "42_refill_measure.py")
RF = importlib.util.module_from_spec(_m)
_m.loader.exec_module(RF)
PICK = RF.PICK

KEY7 = ["ITEM_ID", "SCM_SITE_ID", "PROJECT_CODE", "FCST_TYPE", "INCOTERMS",
        "DOM_EXP", "PLANT_SITE_ID", "CELL_PROD_SITE_ID"]
CELL_COL = {"40": "CELL_PROD_SITE_ID", "81": "PLANT_SITE_ID", "82": None}
_pool = {}


def candidates(cur, div, table, inco, n=20):
    """(div, table) 의 실존 7키 조합 상위 n — 행수 내림차순."""
    k = (div, table)
    if k in _pool:
        return _pool[k]
    have = RF.table_cols(cur, table)
    cols = [c for c in KEY7 if c in have]
    if not cols:
        _pool[k] = []
        return []
    where = [PICK.div_pred(div)] if "DIVISION_ID" in have else []
    if "INCOTERMS" in have:
        where.append("INCOTERMS IN ({})".format(",".join("'" + c + "'" for c in inco)))
    cell = CELL_COL[div]
    if cell and cell in have:
        where.append("{c} IS NOT NULL AND {c} <> '-'".format(c=cell))
    cur.execute("""SELECT {c}, COUNT(*) CNT FROM SCM_MGR.{t}
                    WHERE {w} GROUP BY {c} ORDER BY CNT DESC
                    FETCH FIRST :n ROWS ONLY""".format(
        c=", ".join(cols), t=table, w=" AND ".join(where) or "1=1"), {"n": n})
    out = [(dict(zip(cols, r[:-1])), r[-1]) for r in cur]
    _pool[k] = out
    return out


def main(write=False):
    wb = openpyxl.load_workbook(XLSX)
    db = PICK.connect()
    cur = db.cursor()
    inco = PICK.editable_incoterms(cur)
    fixed, unfixed = [], []
    for sname in SHEETS:
        ws = wb[sname]
        hdr = {c.value: c.column for c in ws[1]}
        used = {}
        for row in ws.iter_rows(min_row=2):
            get = lambda c: (row[hdr[c] - 1].value if c in hdr else None)
            if not str(get("데이터출처") or "").startswith("기존"):
                continue
            div, scr = str(get("DIV")), str(get("실제화면"))
            table, valcol = RF.LEDGER.get(scr, (None, None))
            if not table:
                continue
            key = {c: get(c) for c in RF.KEY_CANDIDATES}
            have, _, _ = RF.measure_one(cur, div, table, valcol, key)
            if not have.startswith("⚠ 키 미존재"):
                continue
            old = "{} / {}".format(get("ITEM_ID"), get("SCM_SITE_ID"))
            pool = candidates(cur, div, table, inco)
            pick = None
            for cand, cnt in pool:
                sig = tuple(sorted(cand.items()))
                if used.get((div, table, sig)):
                    continue
                used[(div, table, sig)] = True
                pick = (cand, cnt)
                break
            if not pick:
                unfixed.append((sname, get("StepNo"), old, "실존 조합 풀 고갈"))
                continue
            cand, cnt = pick
            if write:
                for c, v in cand.items():
                    if c in hdr:
                        row[hdr[c] - 1].value = v
                row[hdr["분류기준"] - 1].value = (
                    "재선별 {} — 기존 키[{}] 가 {} 에 미존재 → 같은 division 실존 조합 "
                    "행수 상위 ({:,}행)".format(TODAY, old, table, cnt))
                row[hdr["행출처"] - 1].value = str(get("행출처")) + "+재선별"
            fixed.append((sname, get("StepNo"), old,
                          "{} / {}".format(cand.get("ITEM_ID"),
                                           cand.get("SCM_SITE_ID")), cnt))
    print("재선별 {}행 / 실패 {}행".format(len(fixed), len(unfixed)))
    for f in fixed:
        print("   {} {} : {}  →  {}  ({:,}행)".format(*f))
    for u in unfixed:
        print("   ⚠ {} {} {} — {}".format(*u))
    if write:
        wb.save(XLSX)
        print("반영 저장 → {}".format(XLSX))
    return 1 if unfixed else 0


if __name__ == "__main__":
    sys.exit(main("--write" in sys.argv))
