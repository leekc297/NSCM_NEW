#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""No.64 — DMF0082 가 소비하는 콤보 중 division '40' 하드코딩 전수 스윕.

수집 축 2개:
  (a) 메타 셀 콤보  : SCM_MST_SHEET_COLUMNS.CELL_COMBO_DATA_TYPE (PROGRAM_ID='DMF0082')
  (b) FE 명시 호출  : nscm-fe forecast-price 소스의 comboId / useTabComboQueries filters
각 SQL_ID 의 등재 SQL 에서 '40' 리터럴 출현 절을 함께 출력한다
  (리터럴 출현 카운트만으로 판정하지 않기 위해 해당 라인 원문을 붙인다).
"""
import sys, io, re, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

FE = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\forecast-price")

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# (a) 메타 셀 콤보
cur.execute(
    """SELECT DISTINCT SHEET_NAME, COLUMN_NAME, CELL_COMBO_DATA_TYPE
       FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
       WHERE  PROGRAM_ID='DMF0082' AND CELL_COMBO_DATA_TYPE IS NOT NULL
       AND    TRIM(CELL_COMBO_DATA_TYPE) IS NOT NULL
       ORDER BY 1,2"""
)
meta = cur.fetchall()
meta_ids = {r[2].strip(): f"메타 {r[0]}.{r[1]}" for r in meta if r[2] and r[2].strip()}

# (b) FE 명시 호출
fe_ids = {}
pat = re.compile(r"comboId:\s*'([A-Za-z0-9_]+)'|filters:\s*\[\s*'([A-Za-z0-9_]+)'")
for f in FE.rglob("*.ts*"):
    txt = f.read_text(encoding="utf-8", errors="ignore")
    for m in pat.finditer(txt):
        cid = m.group(1) or m.group(2)
        if cid:
            fe_ids.setdefault(cid, set()).add(f.name)
    for m in re.finditer(r"comboId:\s*'([A-Za-z0-9_]+)'", txt):
        fe_ids.setdefault(m.group(1), set()).add(f.name)

all_ids = sorted(set(meta_ids) | set(fe_ids))
print(f"# DMF0082 소비 콤보 후보 = {len(all_ids)}종\n")

hard40 = []
for cid in all_ids:
    cur.execute("SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID=:i", {"i": cid})
    row = cur.fetchone()
    src = []
    if cid in meta_ids:
        src.append(meta_ids[cid])
    if cid in fe_ids:
        src.append("FE " + ",".join(sorted(fe_ids[cid])))
    if not row:
        print(f"[MISSING] {cid:<32} ({' / '.join(src)}) — 등재 없음(빈 콤보)")
        continue
    txt = row[0].read() if hasattr(row[0], "read") else row[0]
    hits = [ln.strip() for ln in txt.splitlines() if re.search(r"'40'|=\s*'40|LIKE\s*'40", ln)]
    has_div_param = "@divisionId" in txt or "@param1" in txt
    if hits:
        hard40.append(cid)
        print(f"[HARD-40] {cid:<32} ({' / '.join(src)}) @divisionId={'Y' if has_div_param else 'N'}")
        for h in hits:
            print(f"          | {h}")
    else:
        print(f"[ok]      {cid:<32} ({' / '.join(src)}) @divisionId={'Y' if has_div_param else 'N'}")

print(f"\n## '40' 하드코딩 = {len(hard40)}종 : {', '.join(hard40)}")
con.close()
