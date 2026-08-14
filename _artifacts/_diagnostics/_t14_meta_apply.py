#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form 메타 적용 + 5축 값 단언 검증."""
import io, json, pathlib, sys, datetime
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

SQLF = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0014_EXCELFORM_20260814\03_META_EXCEL_FORM.sql")
BK = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\BACKUP_DMF0014_excelform_20260814.json")

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def rows(sql):
    cur.execute(sql)
    cols = [c[0] for c in cur.description]
    out = []
    for r in cur.fetchall():
        rec = {}
        for i, c in enumerate(cols):
            v = r[i]
            rec[c] = v.strftime("%Y-%m-%d %H:%M:%S") if isinstance(v, datetime.datetime) else v
        out.append(rec)
    return out


BK.write_text(json.dumps({
    "btn": rows("SELECT * FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0014'"),
    "btn_auth": rows("SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0014'"),
    "api": rows("SELECT * FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE '%DMF0014%'"),
    "proc": rows("SELECT * FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE '%DMF0014%'"),
}, ensure_ascii=False, indent=1), encoding="utf-8")
print(f"[backup] {BK.name}")


def split_stmts(text):
    stmts, buf = [], []
    for line in text.replace("\r", "").splitlines():
        buf.append(line)
        if line.rstrip().endswith(";"):
            s = "\n".join(buf).rstrip().rstrip(";")
            lines = s.splitlines()
            i = 0
            while i < len(lines) and (not lines[i].strip() or lines[i].lstrip().startswith("--")
                                      or lines[i].lstrip().startswith("/*") or lines[i].lstrip().startswith("*")
                                      or lines[i].strip() == "SET DEFINE OFF"):
                i += 1
            s = "\n".join(lines[i:]).strip()
            if s:
                stmts.append(s)
            buf = []
    return stmts


for i, s in enumerate(split_stmts(SQLF.read_text(encoding="utf-8")), 1):
    head = " ".join(s.split())[:64]
    if head.upper().startswith("COMMIT"):
        con.commit(); print(f"  [{i}] COMMIT"); continue
    try:
        cur.execute(s); print(f"  [{i}] OK rows={cur.rowcount} :: {head}")
    except Exception as e:
        print(f"  [{i}] FAIL {str(e)[:150]}\n      :: {head}")
con.commit()

print("\n=== VERIFY : hook #135 §5 메타 5축 ===")
checks = [
    ("① EXCEL_COLUMNS", "SELECT PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID='DMF0014'"),
    ("② 버튼 배선", "SELECT SHT_NM, MNU_BTN_CD, API_ID, USE_YN FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0014' ORDER BY MNU_BTN_CD"),
    ("③ FORM_DATA 권한", "SELECT USER_GR_ID, USE_YN FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0014' AND MNU_BTN_CD='FORM_DATA' ORDER BY 1"),
    ("④ API_M", "SELECT API_ID, API_URL, USE_YN FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID='DMF0014_GET_EXCEL_FORM'"),
    ("⑤ PROC_M", "SELECT COUNT(*) CNT FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM='PKG_DMF0014.P_DMF0014_GET_EXCEL_FORM_DATA'"),
]
for title, sql in checks:
    print(f"\n-- {title}")
    cur.execute(sql)
    cols = [c[0] for c in cur.description]
    rs = cur.fetchall()
    print("   " + " | ".join(cols)) if rs else print("   ⛔ 0행")
    for r in rs:
        print("   " + " | ".join("" if v is None else str(v)[:52] for v in r))

con.close()
