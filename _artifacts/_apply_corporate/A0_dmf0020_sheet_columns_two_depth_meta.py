"""DMF0020 SHEET_COLUMNS 의 SMALL_CLASS_LABEL_NAME = COLUMN_LABEL_NAME UPDATE.

ROOT CAUSE (2026-06-21):
  DMF0007 (reference) = SMALL_CLASS_LABEL_NAME 이 COLUMN_LABEL_NAME 과 동일 + LARGE_CLASS_LABEL_NAME=NULL.
  wrapper getColumnDepth (foundation/columnMapping.ts L116-135) 의 분기:
    - DMF0007: lCls=NULL → TWO_DEPTH → height=24 자동 적용.
    - DMF0020: sCls=NULL → ONE_DEPTH → height=48 자동 (3단 동적 column 과 정합 깨짐).

해결:
  DMF0020.main 의 SHEET_COLUMNS 의 모든 row 의 SMALL_CLASS_LABEL_NAME = COLUMN_LABEL_NAME UPDATE.
  → wrapper TWO_DEPTH 처리 → 정적 column height=24 자동 적용.
  → 3단 동적 column 의 group/leaf 와 wrapper 자동 정합.

메모리 룰 P6:
  "admin staticColumns SMALL_CLASS_LABEL_NAME=COLUMN_LABEL_NAME UPDATE 의무 (wrapper TWO_DEPTH 판정)"
  = 본 fix 의 명시 룰.

Anti-Simplification:
  - 백업 의무 (rollback SQL 자동 생성)
  - 멱등 (이미 UPDATE 된 row 는 skip)
  - VALID_YN='Y' row 만 (운영 정합)
"""
from __future__ import annotations
import os, sys, datetime
import oracledb

sys.stdout.reconfigure(line_buffering=True)
u = os.getenv('NSCM_ORA_USER'); p = os.getenv('NSCM_ORA_PASS'); d = os.getenv('NSCM_ORA_DSN')
assert u and p and d
conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}')

ts = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')

# 1. 대상 row 인벤토리 + rollback 데이터 백업
print('\n[ STEP 1 ] DMF0020 SHEET_COLUMNS 대상 row 인벤토리 (PRE-UPDATE):')
cur.execute("""SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME
               FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
               WHERE PROGRAM_ID='DMF0020' AND VALID_YN='Y'
               ORDER BY SHEET_NAME, COLUMN_NAME""")
rows = cur.fetchall()
print(f'  총 {len(rows)} row')
backup_path = f'_logs/DMF0020_SHEET_COLUMNS_BAK_{ts}.sql'
os.makedirs('_logs', exist_ok=True)
with open(backup_path, 'w', encoding='utf-8') as f:
    f.write(f'-- DMF0020 SHEET_COLUMNS backup (SMALL_CLASS_LABEL_NAME UPDATE 전) — {ts}\n')
    for r in rows:
        sht, col, lbl, sCls, lCls = r
        sCls_lit = "NULL" if sCls is None else f"'{sCls.replace(chr(39), chr(39)+chr(39))}'"
        f.write(
            f"UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS SET SMALL_CLASS_LABEL_NAME={sCls_lit} "
            f"WHERE PROGRAM_ID='DMF0020' AND SHEET_NAME='{sht}' AND COLUMN_NAME='{col}';\n"
        )
print(f'  backup: {backup_path}')

# 2. UPDATE (멱등 — 이미 SMALL_CLASS_LABEL_NAME = COLUMN_LABEL_NAME 인 row 는 skip)
print('\n[ STEP 2 ] UPDATE SMALL_CLASS_LABEL_NAME = COLUMN_LABEL_NAME:')
cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
               SET SMALL_CLASS_LABEL_NAME = COLUMN_LABEL_NAME, LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE
               WHERE PROGRAM_ID='DMF0020' AND VALID_YN='Y'
                 AND (SMALL_CLASS_LABEL_NAME IS NULL OR SMALL_CLASS_LABEL_NAME != COLUMN_LABEL_NAME)""")
updated = cur.rowcount
conn.commit()
print(f'  UPDATE OK — {updated} row 변경')

# 3. POST-UPDATE 검증
print('\n[ STEP 3 ] POST-UPDATE 검증:')
cur.execute("""SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME
               FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
               WHERE PROGRAM_ID='DMF0020' AND VALID_YN='Y' AND SHEET_NAME='main'
               ORDER BY COLUMN_NAME FETCH FIRST 10 ROWS ONLY""")
print('  DMF0020.main 첫 10 row:')
for r in cur.fetchall():
    print(f'    col={r[1]:<25} lbl={r[2]!s:<30} sCls={r[3]!r:<30} lCls={r[4]!r}')

conn.close()
print(f'\n[ done ] DMF0020 SHEET_COLUMNS TWO_DEPTH 메타 UPDATE 완료.')
print(f'  rollback: 백업 file {backup_path} 의 UPDATE 재실행')
print(f'  FE 검증: 브라우저 새로고침 → DMF0020 진입 → 검색 → columnHeader 정합 확인.')
