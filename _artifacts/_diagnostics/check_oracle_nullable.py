#!/usr/bin/env python3
"""사내 Oracle SCM_MST_SHEET_COLUMNS NOT NULL 컬럼 인벤토리 + AS-IS NULL 충돌 분석."""
import re
import sys
import json
import pathlib
import oracledb

ROOT = pathlib.Path(__file__).resolve().parents[2]
BE_CFG = ROOT / 'nscm-be' / 'src' / 'main' / 'resources' / 'config' / 'config-local.yml'


def creds():
    t = BE_CFG.read_text(encoding='utf-8')
    url = next(re.match(r'jdbc-url:\s*(\S+)', l.strip()).group(1)
               for l in t.splitlines() if not l.strip().startswith('#') and 'jdbc-url:' in l)
    user = next(re.match(r'username:\s*"?([^"]+)"?', l.strip()).group(1)
                for l in t.splitlines() if not l.strip().startswith('#') and 'username:' in l).strip()
    pwd = next(re.match(r'password:\s*"([^"]+)"', l.strip()).group(1)
               for l in t.splitlines() if not l.strip().startswith('#') and 'password:' in l)
    m = re.search(r'@([^/]+)/(\S+)', url)
    return user, pwd, f'{m.group(1)}/{m.group(2)}'


u, p, d = creds()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""
    SELECT COLUMN_ID, COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE, DATA_DEFAULT
      FROM ALL_TAB_COLUMNS
     WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_MST_SHEET_COLUMNS'
     ORDER BY COLUMN_ID
""")
oracle_cols = cur.fetchall()
print('=== Oracle SCM_MST_SHEET_COLUMNS DDL ===')
print(f'{"#":>3} {"COL":30} {"TYPE":15} {"NULL?":5} DEFAULT')
not_null_cols = []
for r in oracle_cols:
    cid, cn, dt, dl, nullable, ddef = r
    n_flag = 'N' if nullable == 'N' else 'Y'
    if nullable == 'N':
        not_null_cols.append(cn)
    print(f'{cid:3} {cn:30} {dt:15} {n_flag:5} {ddef or ""}')

print()
print(f'NOT NULL 컬럼 ({len(not_null_cols)}): {not_null_cols}')

# AS-IS JSON 에서 NULL 충돌 검증
asis = json.loads((pathlib.Path(__file__).parent / 'asis_sheet_columns_5screens.json').read_text(encoding='utf-8'))
src_cols = asis['columns']
src_rows = asis['rows']
print()
print('=== AS-IS NULL 충돌 (Oracle NOT NULL 인데 AS-IS NULL 인 경우) ===')
conflict = {}
for col in not_null_cols:
    if col not in src_cols:
        continue
    idx = src_cols.index(col)
    null_rows = [r for r in src_rows if r[idx] is None]
    if null_rows:
        # PROGRAM_ID 별 group
        pid_idx = src_cols.index('PROGRAM_ID')
        from collections import Counter
        by_pid = Counter(r[pid_idx] for r in null_rows)
        conflict[col] = dict(by_pid)
        print(f'  {col}: 총 {len(null_rows)} rows NULL → {dict(by_pid)}')

if not conflict:
    print('  (no conflict)')

# 빈 문자열 → NULL 변환 후의 충돌도 확인
print()
print('=== 빈 문자열 → NULL 변환 시 추가 충돌 ===')
for col in not_null_cols:
    if col not in src_cols:
        continue
    idx = src_cols.index(col)
    empty_rows = [r for r in src_rows if r[idx] == '']
    if empty_rows:
        from collections import Counter
        pid_idx = src_cols.index('PROGRAM_ID')
        by_pid = Counter(r[pid_idx] for r in empty_rows)
        print(f'  {col}: 빈문자열 {len(empty_rows)} rows → {dict(by_pid)}')

con.close()
