#!/usr/bin/env python3
"""
_extract_sys0013_data.py — dev/local 의 SYS0013 운영 데이터 추출 (DELETE + INSERT).
대상 테이블:
  SCM_ADM_DQ_LIST       (grid - query list 등록)
  SCM_ADM_DQ_COLUMN     (column - query 의 결과 컬럼 메타)
  SCM_ADM_DQ_PARAMETER  (parameters - query 의 입력 파라미터)
"""
import os, datetime
from pathlib import Path
import oracledb

con = oracledb.connect(user=os.environ['NSCM_ORA_USER'], password=os.environ['NSCM_ORA_PASS'], dsn=os.environ['NSCM_ORA_DSN'])
cur = con.cursor()

ROOT = Path(__file__).resolve().parent
SEED = ROOT / 'SYS0013' / '02_SEED_DATA'
SEED.mkdir(parents=True, exist_ok=True)

def quote(v):
    if v is None: return 'NULL'
    if isinstance(v, (int, float)): return str(v)
    if isinstance(v, datetime.datetime): return f"TO_DATE('{v.strftime('%Y-%m-%d %H:%M:%S')}','YYYY-MM-DD HH24:MI:SS')"
    if isinstance(v, datetime.date): return f"TO_DATE('{v.strftime('%Y-%m-%d')}','YYYY-MM-DD')"
    # CLOB / LOB 처리
    if hasattr(v, 'read'):
        v = v.read()
    s = str(v).replace("'", "''")
    # 4000 char 초과 시 TO_CLOB(...) || concat
    if len(s) <= 4000:
        return f"'{s}'"
    chunks = [s[i:i+3900] for i in range(0, len(s), 3900)]
    return ' || '.join(f"TO_CLOB('{c}')" for c in chunks)

def extract_table(file: Path, table: str, header: str):
    cur.execute(f"SELECT * FROM SCM_MGR.{table}")
    cols = [c[0] for c in cur.description]
    rows = cur.fetchall()
    body = [f"-- ============================================================",
            f"-- {header}",
            f"-- 실행 계정: SCM_MGR · 멱등: 전체 DELETE 선행 + INSERT",
            f"-- 행 수: {len(rows)} · dev/local extract 2026-06-22",
            f"-- ============================================================", ""]
    body.append(f"DELETE FROM SCM_MGR.{table};")
    body.append('')
    col_list = ', '.join(cols)
    for r in rows:
        vals = ', '.join(quote(v) for v in r)
        body.append(f"INSERT INTO SCM_MGR.{table} ({col_list}) VALUES ({vals});")
    body.extend(['', 'COMMIT;', ''])
    file.write_text('\n'.join(body), encoding='utf-8')
    return len(rows)

n1 = extract_table(SEED / '010_SCM_ADM_DQ_LIST.sql',       'SCM_ADM_DQ_LIST',
                   'SYS0013 — SCM_ADM_DQ_LIST (Grid: query list 등록)')
n2 = extract_table(SEED / '020_SCM_ADM_DQ_COLUMN.sql',     'SCM_ADM_DQ_COLUMN',
                   'SYS0013 — SCM_ADM_DQ_COLUMN (Column: query 결과 컬럼 메타)')
n3 = extract_table(SEED / '030_SCM_ADM_DQ_PARAMETER.sql',  'SCM_ADM_DQ_PARAMETER',
                   'SYS0013 — SCM_ADM_DQ_PARAMETER (Parameters: query 입력 파라미터)')

# (선택) USER_GROUP 도 함께
n4 = extract_table(SEED / '040_SCM_ADM_DQ_USER_GROUP.sql', 'SCM_ADM_DQ_USER_GROUP',
                   'SYS0013 — SCM_ADM_DQ_USER_GROUP (Role: query 별 사용 그룹 권한)')

con.close()
print(f"\n✅ SYS0013 운영 데이터 추출 완료")
print(f"   SCM_ADM_DQ_LIST       = {n1:>5d} rows")
print(f"   SCM_ADM_DQ_COLUMN     = {n2:>5d} rows")
print(f"   SCM_ADM_DQ_PARAMETER  = {n3:>5d} rows")
print(f"   SCM_ADM_DQ_USER_GROUP = {n4:>5d} rows")
