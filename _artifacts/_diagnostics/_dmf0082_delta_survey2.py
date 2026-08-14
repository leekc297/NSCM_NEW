#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 이관 서베이 2부 — PROC/API/BTN/MSG + 소비콤보 ∩ 변경콤보 교집합."""
import sys, io, re, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

CUT = "2026-08-12"
FE = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\forecast-price")

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def q(title, sql, binds=None):
    print("\n" + "=" * 96)
    print(f"## {title}")
    cur.execute(sql, binds or {})
    cols = [c[0] for c in cur.description]
    rows = cur.fetchall()
    print("   " + " | ".join(cols) if rows else "   (변경 없음)")
    for r in rows:
        print("   " + " | ".join("" if v is None else str(v) for v in r))
    print(f"   ({len(rows)} rows)")
    return rows


for tbl, idcol in (("SCM_ADM_PROC_M", "PROC_ID"), ("SCM_ADM_API_M", "API_ID")):
    cur.execute(
        "SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t AND COLUMN_NAME LIKE '%UPDATE%'",
        {"t": tbl},
    )
    has = [r[0] for r in cur.fetchall()]
    try:
        q(f"{tbl} 변경 ({CUT} 이후, DMF0082)",
          f"""SELECT {idcol} ID, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD
              FROM SCM_MGR.{tbl} WHERE {idcol} LIKE '%DMF0082%'
              AND LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD') ORDER BY 1""", {"c": CUT})
    except Exception as e:
        print(f"   [{tbl}] SKIP — {str(e)[:90]} (컬럼={has})")

q(f"MSG/LBL/MNU 변경 ({CUT} 이후)", """
  SELECT MSG_ID, MSG_TP_CD, LANG_CD, SUBSTR(MSG_NM,1,38) NM,
         TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD
  FROM SCM_MGR.SCM_ADM_MSG_M WHERE LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD')
  ORDER BY MSG_ID, LANG_CD""", {"c": CUT})

# ── DMF0082 소비 콤보 ∩ 변경 콤보 ──────────────────────────────────────
cur.execute("""SELECT DISTINCT TRIM(CELL_COMBO_DATA_TYPE) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
               WHERE PROGRAM_ID='DMF0082' AND CELL_COMBO_DATA_TYPE IS NOT NULL
               AND TRIM(CELL_COMBO_DATA_TYPE) IS NOT NULL""")
consumed = {r[0] for r in cur.fetchall()}
pat = re.compile(r"comboId:\s*'([A-Za-z0-9_]+)'|filters:\s*\[\s*'([A-Za-z0-9_]+)'")
for f in FE.rglob("*.ts*"):
    for m in pat.finditer(f.read_text(encoding="utf-8", errors="ignore")):
        consumed.add(m.group(1) or m.group(2))
consumed = {c for c in consumed if c}

cur.execute("""SELECT SQL_ID, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI')
               FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD')""",
            {"c": CUT})
changed = dict(cur.fetchall())

print("\n" + "=" * 96)
print(f"## DMF0082 소비 콤보({len(consumed)}종) ∩ {CUT} 이후 변경({len(changed)}종)")
hit = sorted(set(consumed) & set(changed))
for c in hit:
    print(f"   ✔ {c:<32} {changed[c]}")
print(f"   → 이관 포함 대상 {len(hit)}종")
print(f"   (DMF0082 미소비 변경 콤보 = {sorted(set(changed) - set(consumed))} → 별도 패키지 소관)")

con.close()
