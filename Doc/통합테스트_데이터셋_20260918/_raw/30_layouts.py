# -*- coding: utf-8 -*-
"""Phase 2 — STEP 별 LAYOUT 해석 (읽기 전용)

사용자 요구 (2026-09-18):
  · "CRUD 기능이 있는 UI 에 대해서는 각 division 별 User Selected flag = 'N' 인 Column에
     대해서 전체 Data 을 생성해주세요."
  · G열: 화면 LAYOUT / IF LAYOUT / UPLOAD LAYOUT / N:N MAPPING LAYOUT 기준 샘플 작성

LAYOUT 원천 (성격별)
  UI    : SCM_MGR.SCM_MST_SHEET_COLUMNS  (VALID_YN='Y', USER_SELECTABLE_FLAG='N', division 토큰 매칭)
          → 화면에 고정 표시되는 컬럼 = 테스트 데이터가 반드시 채워야 하는 컬럼
  IF    : ALL_TAB_COLUMNS (해당 IF 테이블 실제 컬럼)
  UPLOAD: SCM_MGR.SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT (파이프 구분 토큰)
"""
import json
import pathlib
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

HERE = pathlib.Path(__file__).resolve().parent


def connect():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
    m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


# division 토큰 매칭 — DIVISION_ID 는 '40,82,81,81_UC,...' 형태의 콤마 목록
def div_tokens(s):
    return [t.strip() for t in (s or "").split(",") if t.strip()]


def div_match(cell, div):
    """SHEET_COLUMNS.DIVISION_ID 가 이 division 에 적용되는가.
       NULL/공백 = 전 division 공통."""
    toks = div_tokens(cell)
    if not toks:
        return True
    if div == "81":
        return any(t == "81" or t.startswith("81_") for t in toks)
    return div in toks


def ui_layout(cur, program_id, div, sheet_name=None):
    """화면 LAYOUT — USER_SELECTABLE_FLAG='N' 고정 컬럼 전체."""
    sql = """SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, DIVISION_ID,
                    SORT_ORDER_NO, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE,
                    INPUT_TP_CD, VISIBLE_FLAG, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME
               FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
              WHERE PROGRAM_ID = :pid AND VALID_YN = 'Y'
                AND USER_SELECTABLE_FLAG = 'N'"""
    args = {"pid": program_id}
    if sheet_name:
        sql += " AND SHEET_NAME = :sn"
        args["sn"] = sheet_name
    sql += " ORDER BY SHEET_NAME, SORT_ORDER_NO"
    cur.execute(sql, args)
    out = []
    for r in cur.fetchall():
        if not div_match(r[3], div):
            continue
        out.append({
            "sheet": r[0], "col": r[1], "label": r[2], "div_meta": r[3],
            "sort": float(r[4]) if r[4] is not None else None,
            "ctrl": r[5], "combo": r[6], "input_tp": r[7], "visible": r[8],
            "small": r[9], "large": r[10],
        })
    return out


def if_layout(cur, owner, table):
    cur.execute("""SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE, COLUMN_ID
                     FROM ALL_TAB_COLUMNS WHERE OWNER=:o AND TABLE_NAME=:t
                    ORDER BY COLUMN_ID""", {"o": owner, "t": table})
    return [{"col": r[0], "type": r[1], "len": r[2], "nullable": r[3], "pos": r[4]}
            for r in cur.fetchall()]


def upload_layout(cur, program_id):
    cur.execute("""SELECT SHEET_NAME, HEADER_CONTENT FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS
                    WHERE PROGRAM_ID=:p""", {"p": program_id})
    out = []
    for sn, h in cur.fetchall():
        h = h.read() if hasattr(h, "read") else h
        out.append({"sheet": sn, "tokens": [t for t in (h or "").split("|")]})
    return out


# ── STEP 별 LAYOUT 지정 ────────────────────────────────────────────────────
# (DIV, StepNo, LAYOUT종류, 인자)
#   ui     : (PROGRAM_ID, SHEET_NAME or None)
#   if     : (OWNER, TABLE)
#   upload : (PROGRAM_ID,)
LAYOUT_SPEC = {
    # ── 40 ──
    ("40", "1-1"):  ("ui",     ("DMF0005", None)),
    ("40", "3-1"):  ("if",     ("INF_MGR", "XIF_ERP_SALES_RESULT_R")),
    ("40", "4-1"):  ("ui",     ("DMF0082", None)),
    ("40", "6-1"):  ("ui",     ("DMF0082", None)),
    ("40", "9-1"):  ("ui",     ("DMF0082", None)),      # RTF 생성 점검 (신규)
    ("40", "10-1"): ("ui",     ("DMF0021", None)),
    # ── 81 ──
    ("81", "1-1"):  ("ui",     ("DMF0005", None)),
    ("81", "3-1"):  ("ui",     ("DMF0072", None)),
    ("81", "3-2a"): ("if",     ("INF_MGR", "XIF_ERP_EDI_CALLOFF_HEAD_R")),
    ("81", "3-2b"): ("if",     ("INF_MGR", "XIF_ERP_EDI_CALLOFF_ITEM_R")),
    ("81", "3-2c"): ("if",     ("INF_MGR", "XIF_ERP_EDI_CALLOFF_PARTNER_R")),
    ("81", "3-2d"): ("if",     ("INF_MGR", "XIF_CUST_DEMAND_MAPPING_MST_R")),
    ("81", "4-1"):  ("ui",     ("DMF0007", None)),
    ("81", "4-2"):  ("ui",     ("DMF0007", None)),
    ("81", "4-3"):  ("upload", ("DMF0014",)),
    ("81", "5-1"):  ("if",     ("INF_MGR", "XIF_ERP_SALES_RESULT_R")),
    ("81", "6-1"):  ("ui",     ("DMF0082", None)),
    ("81", "6-2"):  ("ui",     ("DMF0082", None)),
    ("81", "8-1"):  ("ui",     ("DMF0082", None)),
    ("81", "11-1"): ("ui",     ("DMF0082", None)),      # RTF 생성 점검 (신규)
    ("81", "12-1"): ("ui",     ("DMF0021", None)),
    # ── 82 ──
    ("82", "1-1"):  ("ui",     ("DMF0005", None)),
    ("82", "3-1"):  ("if",     ("FP_MGR", "SCM_STOCK_H")),   # = SCM_DNM_STOCK_SN 시노님 대상
    ("82", "4-1"):  ("if",     ("INF_MGR", "XIF_ERP_SALES_RESULT_R")),
    ("82", "5-1"):  ("ui",     ("DMF0020", None)),
    ("82", "5-2"):  ("ui",     ("DMF0020", None)),
    ("82", "6-1"):  ("ui",     ("DMF0003", None)),
    ("82", "6-2"):  ("ui",     ("DMF0003", None)),
    ("82", "9-1"):  ("ui",     ("DMF0003", None)),      # RTF 생성 점검 (신규)
    ("82", "10-1"): ("ui",     ("DMF0021", None)),
}


def resolve_all():
    db = connect()
    cur = db.cursor()
    out = {}
    for (div, sno), (kind, args) in sorted(LAYOUT_SPEC.items()):
        if kind == "ui":
            cols = ui_layout(cur, args[0], div, args[1])
        elif kind == "if":
            cols = if_layout(cur, args[0], args[1])
        else:
            cols = upload_layout(cur, args[0])
        out["{}|{}".format(div, sno)] = {"kind": kind, "args": list(args), "cols": cols}
    return out


if __name__ == "__main__":
    res = resolve_all()
    (HERE / "30_layouts.json").write_text(
        json.dumps(res, ensure_ascii=False, indent=1), encoding="utf-8")
    print("STEP LAYOUT 해석 결과")
    print("=" * 78)
    for k, v in res.items():
        if v["kind"] == "upload":
            n = sum(len(s["tokens"]) for s in v["cols"])
            print("  {:10s} {:6s} {:44s} {:3d} 토큰".format(
                k, v["kind"], "/".join(map(str, v["args"])), n))
        else:
            print("  {:10s} {:6s} {:44s} {:3d} 컬럼".format(
                k, v["kind"], "/".join(map(str, v["args"])), len(v["cols"])))
            if v["kind"] == "ui":
                sheets = {}
                for c in v["cols"]:
                    sheets.setdefault(c["sheet"], []).append(c["col"])
                for sn, cs in sheets.items():
                    print("        [{}] {}".format(sn, ", ".join(cs)))
