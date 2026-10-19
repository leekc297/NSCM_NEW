"""ZT 검증 결과를 작업대상 xlsx 에 '9_ZT검증결과' 시트로 누적 기록.  python zt_report.py
입력: zt/_result/<case>.json (zt_case.run 산출) + zt/<case>.json (케이스 정의)"""
import os, glob, json, collections
from openpyxl import load_workbook
from openpyxl.styles import Font, PatternFill, Alignment
from openpyxl.utils import get_column_letter
HERE = os.path.dirname(os.path.abspath(__file__)); RES = os.path.join(HERE, "_result")
XLSX = max(glob.glob(os.path.join(os.path.dirname(HERE), "NULL*작업대상*.xlsx")), key=os.path.getmtime)
rows = []
for rp in sorted(glob.glob(os.path.join(RES, "*.json"))):
    name = os.path.basename(rp)[:-5]
    case = json.load(open(os.path.join(HERE, name.lower() + ".json"), encoding="utf-8")) if os.path.exists(os.path.join(HERE, name.lower() + ".json")) else {}
    tables = case.get("tables") or [case.get("table", "")]
    cols = ", ".join(case.get("map_cols", []))
    edits = sum(len(v.get("edits", [])) for v in case.get("packages", {}).values())
    for it in json.load(open(rp, encoding="utf-8")):
        call = it["call"]
        if it.get("error"):
            rows.append([name, ", ".join(tables), cols, edits, f"{call['pkg']}.{call['proc']}", " | ".join(str(p) for p in call["params"]), "",
                         "", "", "실행 실패(타임아웃/오류) — 증거 없음", "", "", it["error"], "", "", "", "", ""])
            continue
        for nm, r in it["compare"].items():
            if r["rows_orig"] == 0 and r["rows_zt"] == 0:
                verdict = "0행 — 증거 불충분"
            else:
                verdict = "동일(출력 바이트 일치)" if r.get("raw_same") else ("치환만 차이('-'→'/' 로 설명됨)" if r.get("rename_only") else "차이 있음 — 검토")
            rows.append([name, ", ".join(tables), cols, edits, f"{call['pkg']}.{call['proc']}", " | ".join(str(p) for p in call["params"]), nm,
                         r["rows_orig"], r["rows_zt"], verdict, r.get("only_orig", 0), r.get("only_zt", 0),
                         ", ".join(f"{k}:{v}" for k, v in (r.get("coldiff") or {}).items()), it["sec_orig"], it["sec_zt"],
                         it["dash_cells_orig"].get(nm, ""), it["slash_cells_zt"].get(nm, ""), ""])
    for n in case.get("notes", []):
        rows.append([name, ", ".join(tables), cols, edits, n, "", "", "", "", "실행 비교 제외(사유 참조)", "", "", "", "", "", "", "", ""])
hdr = ["케이스", "테이블(뷰 매핑)", "컬럼", "코드 변경 지점 수", "실행 객체", "파라미터", "커서", "행수 원본", "행수 ZT", "판정", "원본만 행", "ZT만 행", "차이 컬럼", "원본 초", "ZT 초",
       "원본 '-' 셀", "ZT '/' 셀", "비고"]
wb = load_workbook(XLSX)
if "9_ZT검증결과" in wb.sheetnames:
    del wb["9_ZT검증결과"]
ws = wb.create_sheet("9_ZT검증결과")
ws.append(hdr)
for r in rows:
    ws.append(r)
for c in ws[1]:
    c.font = Font(bold=True); c.fill = PatternFill("solid", fgColor="DDEBF7"); c.alignment = Alignment(wrap_text=True, vertical="center")
for i, w in enumerate([22, 40, 30, 8, 46, 60, 8, 9, 9, 28, 8, 8, 40, 7, 7, 9, 9, 30], 1):
    ws.column_dimensions[get_column_letter(i)].width = w
fill = {"동일(출력 바이트 일치)": "C6E0B4", "치환만 차이('-'→'/' 로 설명됨)": "E2EFDA", "차이 있음 — 검토": "F8CBAD", "0행 — 증거 불충분": "FFF2CC", "실행 실패(타임아웃/오류) — 증거 없음": "EDEDED"}
for row in ws.iter_rows(min_row=2, min_col=10, max_col=10):
    f = fill.get(str(row[0].value))
    if f:
        row[0].fill = PatternFill("solid", fgColor=f)
ws.freeze_panes = "F2"; ws.auto_filter.ref = ws.dimensions
wb.save(XLSX)
print("rows", len(rows), "->", XLSX, "| 판정", dict(collections.Counter(r[9] for r in rows)))
