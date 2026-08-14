#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""No.64 검증 — EndCustomerByDivisionDMF0082 division 상별 결과 + 'AJ' 혼입 여부."""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

cur.execute("SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='EndCustomerByDivisionDMF0082'")
row = cur.fetchone()
base = row[0].read() if hasattr(row[0], "read") else row[0]

print("## 메타 배선 확인")
cur.execute(
    """SELECT SHEET_NAME, COLUMN_NAME, CELL_COMBO_DATA_TYPE
       FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
       WHERE PROGRAM_ID='DMF0082' AND COLUMN_NAME LIKE 'END_CUSTOMER%' ORDER BY 1,2"""
)
for r in cur.fetchall():
    print(f"   {r[0]} . {r[1]}  ->  {r[2]}")

print("\n## 콤보 실행 (division 상별)")
for div in ("40", "81", "81_HG", "82", "-"):
    s = base.replace("@sesUserId", "'minyonglee1'").replace("@divisionId", f"'{div}'")
    cur.execute(s)
    rows = cur.fetchall()
    aj = [r[1] for r in rows if r[1] and str(r[1]).upper().startswith("AJ")]
    sample = ", ".join(str(r[1]) for r in rows[:5])
    print(f"   div={div:<6} → {len(rows):>5}종 | AJ* 포함={len(aj)}건 {aj[:3]} | 예: {sample}")

print("\n## 회귀 비교 — 구 등재본 EndCustomerByDivision40 (40 고정)")
cur.execute("SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='EndCustomerByDivision40'")
r0 = cur.fetchone()
old = r0[0].read() if hasattr(r0[0], "read") else r0[0]
cur.execute(old.replace("@sesUserId", "'minyonglee1'"))
oldrows = {str(x[1]) for x in cur.fetchall()}
s = base.replace("@sesUserId", "'minyonglee1'").replace("@divisionId", "'40'")
cur.execute(s)
newrows = {str(x[0]) for x in cur.fetchall()}
print(f"   구본(40 고정) CODE = {len(oldrows)}종 / 신본(div=40) CODE = {len(newrows)}종")
print(f"   신본에서 빠진 코드 = {len(oldrows - newrows)}건 {sorted(oldrows - newrows)[:10]}")
print(f"   신본에만 있는 코드 = {len(newrows - oldrows)}건 {sorted(newrows - oldrows)[:10]}")

con.close()
