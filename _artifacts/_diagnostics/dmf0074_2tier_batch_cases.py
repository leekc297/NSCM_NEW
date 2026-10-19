"""dmf0074_2tier_batch_cases.py — 케이스 전량을 AS-IS 2단 양식 1파일(행=케이스)로 합쳐 실업로드(P_MODE=0),
행별 기대 메시지 ↔ 실측 메시지 대사 + 화면 표시값(O_CUR_LIST) ↔ 스테이징 대사. 2026-09-14"""
import glob, json, os, re, pathlib, requests, openpyxl, oracledb
from openpyxl.utils import get_column_letter
ROOT = r"C:\Projects\NSCM\Doc\단위테스트\_excel_upload_cases"
SRC = r"C:\TRANFILE\RECEIVE\DMF0074_MetalLinkPricePopup_ASIS.xlsx"
OUT = pathlib.Path(r"C:\Users\ejene\AppData\Local\Temp\claude\c--Projects-NSCM\0ea4cbc9-b2ef-4b42-8284-e360f3928fc5\scratchpad\dmf0074_2tier_batch.xlsx")
cases = json.load(open(sorted(glob.glob(ROOT + r"\cases_*.json"))[-1], encoding="utf-8"))["DMF0074"]
exp = {f"{c['no']:02d}_{c['cid']}"[:31]: c for c in cases}
wb = openpyxl.load_workbook(SRC); ws = wb.active
for c in ws[3]: c.value = None
r_out, meta, month = 3, [], 0
def ym(i):  # 202610 부터 월 증가 (키 중복 회피)
    y, m = divmod(9 + i, 12); return str(2026 + y) + f"{m+1:02d}"
for f in sorted(glob.glob(ROOT + r"\DMF0074\*.xlsx")):
    name = os.path.splitext(os.path.basename(f))[0]
    src = openpyxl.load_workbook(f).active; rows = list(src.iter_rows(values_only=True))
    hdr = rows[0]
    if len(hdr) < 53 or hdr[4] != "Model Code": continue          # 40 레이아웃(53열) 케이스만
    data = [r for r in rows[1:] if any(v not in (None, "") for v in r)]
    if not data: continue
    for k, r in enumerate(data):
        if r_out == 20: r_out += 1   # 중간 빈 행 1개 — 행 위치 보존(EXCEL_ROW) 검증용
        vals = list(r[:53])
        if name.split("_", 1)[1] not in ("C13", "C14", "C12") and vals[1] not in (None, ""):
            vals[1] = ym(month)
        team = f"R{r_out}_{name}"[:30]; vals[2] = team
        for j, v in enumerate(vals):
            if v not in (None, ""): ws[f"{get_column_letter(j+1)}{r_out}"] = v
        meta.append((r_out, team, name, exp.get(name, {}).get("expect", "?")))
        r_out += 1
    if name.split("_", 1)[1] not in ("C12",): month += 1
wb.save(OUT); print("rows", len(meta), "file", OUT)
s = requests.Session(); s.post("http://localhost:8080/user/login", json={"userId": "minyonglee1"}, timeout=30)
with open(OUT, "rb") as fh:
    body = s.post("http://localhost:8080/DMF0074_40/Metal Link Price/UPLOAD/excel-upload", files={"file": (OUT.name, fh)}, timeout=900).json()
res = body.get("result") or {}; print("code", body.get("code"), body.get("message"), "CNT", res.get("O_CUR_CNT"))
lst = res.get("O_CUR_LIST") or []
con = oracledb.connect(user="SCM_MGR", password="zionex1!", dsn="175.211.29.206:2521/ZIOUI1"); cur = con.cursor()
cur.execute("""SELECT ATTRIBUTE3, UPLOAD_STATUS_CODE, MESSAGE_TEXT, UPLOAD_ID FROM SCM_ADM_EXCEL_UPLOAD WHERE PROGRAM_ID='DMF0074_40' AND SHEET_NAME='Metal Link Price' AND CREATED_BY='minyonglee1'
               AND CREATION_DATE=(SELECT MAX(CREATION_DATE) FROM SCM_ADM_EXCEL_UPLOAD WHERE PROGRAM_ID='DMF0074_40' AND SHEET_NAME='Metal Link Price' AND CREATED_BY='minyonglee1') ORDER BY UPLOAD_ID""")
stg = {t: (st, m, uid) for t, st, m, uid in cur.fetchall()}
by_team_list = {x.get("ATTRIBUTE3"): x for x in lst}
print(f"{'xlsRow':6} {'LIST.EXCEL_ROW':14} {'case':12} {'verdict':7} expect || staging")
fails = 0
for r, team, name, e in meta:
    st, m, uid = stg.get(team, ("-", None, None)); li = by_team_list.get(team, {})
    want_none = e.startswith("(")
    ok = (not m and st != "ERROR") if want_none else (m is not None and e.split(" : ")[0] in m)
    fails += (not ok)
    rowok = (st != "ERROR") or (str(li.get("EXCEL_ROW")) == str(r))
    fails += (not rowok)
    print(f"{r:<6} {str(li.get('EXCEL_ROW','-')):14} {'ROW-OK' if rowok else 'ROW-NG':7} {name:12} {'PASS' if ok else 'FAIL':7} {e[:45]:45} || {st}:{m}")
print("FAIL", fails, "/", len(meta))
