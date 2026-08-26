# -*- coding: utf-8 -*-
"""REQ:CHAT-20260820-1 적용 — DMF0003 'Mkt Fcst' 81축 결손 4컬럼을 DMF0082 FcstNPrice 에 INSERT.

사용자 선택(2026-08-20): 결손 4컬럼(DEPT_ID/DEPT_NAME_KO/DEPT_NAME/GROUP_ID)만 적용.
원칙: 값은 AS-IS 원행 실측 승계 (추측 금지 — anti-simplification DDL 계보). 숨김('N')+사용자선택('Y').
"""
import io
import os
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
import pyodbc
from ora import conn_info

# .env.asis 로드 (비밀번호 하드코딩 금지)
ENV = {}
for ln in open(r"C:\Projects\NSCM\.env.asis", encoding="utf-8"):
    ln = ln.strip()
    if ln and not ln.startswith("#") and "=" in ln:
        k, v = ln.split("=", 1)
        ENV[k.strip()] = v.strip()

TARGET_COLS = ["DEPT_ID", "DEPT_NAME_KO", "DEPT_NAME", "GROUP_ID"]
# 81 계열 스코프: AS-IS 원행의 81 계열 토큰만 승계 (DEPT_NAME 은 '81' 뿐 — 임의 확장 금지)
DIV81_FULL = "81,81_UC,81_HM,81_ST,81_HD,81_HG"

ms = pyodbc.connect(
    f"DRIVER={{{ENV.get('ASIS_DB_DRIVER', 'ODBC Driver 17 for SQL Server')}}};"
    f"SERVER={ENV['ASIS_DB_HOST']},{ENV.get('ASIS_DB_PORT', '1433')};"
    f"DATABASE={ENV.get('ASIS_DB_NAME', 'LGCE_SCMDEV')};UID={ENV['ASIS_DB_USER']};PWD={ENV['ASIS_DB_PASS']}")
mc = ms.cursor()
mc.execute("""SELECT COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, DATA_SORT_METHOD_CODE,
                     SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, FIXED_FLAG, COLUMN_WIDTH,
                     CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, HORIZONTAL_ALIGN_CODE,
                     VISIBLE_FLAG, DIVISION_ID, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN
              FROM dbo.SCM_MST_SHEET_COLUMNS
              WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst'
              AND COLUMN_NAME IN ('DEPT_ID','DEPT_NAME_KO','DEPT_NAME','GROUP_ID')""")
asis = {r[0]: r for r in mc.fetchall()}
ms.close()
assert set(asis) == set(TARGET_COLS), f"AS-IS 원행 부족: {sorted(asis)}"
for k, r in asis.items():
    print("[AS-IS]", k, "| LBL:", r[1], "| SORT:", r[2], "| DIV:", r[12], "| V/D:", r[11], "/", repr(r[13]),
          "| CTRL:", r[8], "| ALIGN:", r[10])

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# 전제: 대상 4컬럼 미존재 + SORT 충돌 확인
cur.execute("""SELECT COLUMN_NAME, SORT_ORDER_NO FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
               WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'""")
existing = dict(cur.fetchall())
for c in TARGET_COLS:
    assert c not in existing, f"{c} 이미 존재 — 중단"
used_sorts = set(existing.values())

# SORT 잠정 채번: TEAM 영역(20/30) 인접 — 충돌 회피 (25,26,27) / GROUP_ID=AS-IS 135 유지(충돌 시 +1)
plan_sort = {"DEPT_ID": 25, "DEPT_NAME_KO": 26, "DEPT_NAME": 27, "GROUP_ID": 135}
for c, s in plan_sort.items():
    while s in used_sorts:
        s += 1
    plan_sort[c] = s
    used_sorts.add(s)
print("[SORT 채번]", plan_sort)


def nz(v, sent=" "):
    return v if v not in (None, "") else sent


ins = 0
for c in TARGET_COLS:
    r = asis[c]
    div = "81" if c == "DEPT_NAME" else DIV81_FULL
    cur.execute("""INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS
        (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO,
         DATA_SORT_METHOD_CODE, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, FIXED_FLAG,
         COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, HORIZONTAL_ALIGN_CODE,
         VISIBLE_FLAG, DIVISION_ID, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN,
         CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, INPUT_TP_CD)
        VALUES (:pg, :sh, :col, :lbl, :srt, :dsm, :scls, :lcls, :fix, :wid, :ctrl, :cmbo, :al,
                'N', :div, :def_, 'Y', 'Y', 'admin', SYSDATE, 'admin', SYSDATE, 'S')""",
        dict(pg="DMF0082", sh="FcstNPrice", col=c, lbl=nz(r[1], c), srt=plan_sort[c],
             dsm=nz(r[3]), scls=nz(r[4], nz(r[1], c)), lcls=nz(r[5], nz(r[1], c)), fix=nz(r[6]),
             wid=r[7] if r[7] is not None else 0, ctrl=nz(r[8]), cmbo=nz(r[9], None),
             al=nz(r[10], "L"), div=div, def_=nz(r[13], " ")))
    ins += cur.rowcount
assert ins == 4, f"INSERT {ins}건 — 4 이어야 함"
con.commit()

cur.execute("""SELECT COLUMN_NAME, SORT_ORDER_NO, VISIBLE_FLAG, DEFAULT_FLAG, DIVISION_ID,
                      USER_SELECTABLE_FLAG FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
               WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'
               AND COLUMN_NAME IN ('DEPT_ID','DEPT_NAME_KO','DEPT_NAME','GROUP_ID') ORDER BY SORT_ORDER_NO""")
for row in cur.fetchall():
    print("[AFTER]", row)
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'")
print("[COUNT] FcstNPrice 총", cur.fetchone()[0], "행 (기대 65)")
con.close()
print("[OK] 4컬럼 INSERT 완료")
