#!/usr/bin/env python3
"""
extract_asis_sheet_columns.py — AS-IS MSSQL SCM_MST_SHEET_COLUMNS 추출 + 사전 인벤토리

사용:
  python extract_asis_sheet_columns.py inventory   # 컬럼 + row 수 + DIVISION_ID 분포 보고만
  python extract_asis_sheet_columns.py extract     # 5 PROGRAM_IDs row 전체 → JSON 파일 출력

대상 PROGRAM_IDs: DMF0043, DMF0043_01, DMF0008, DMF0020, DMF0072
PK (자연키): (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, DIVISION_ID)

환경변수 또는 .env.asis (프로젝트 root) 에서 ASIS_DB_* 읽음.
"""
import os
import sys
import json
import pathlib
import pyodbc
from datetime import datetime, date
from decimal import Decimal


PROGRAM_IDS = ('DMF0043', 'DMF0043_01', 'DMF0008', 'DMF0020', 'DMF0072')


def load_env():
    root = pathlib.Path(__file__).resolve().parents[2]
    env = root / '.env.asis'
    kv = {}
    if env.exists():
        for line in env.read_text(encoding='utf-8', errors='ignore').splitlines():
            if '=' in line and not line.strip().startswith('#'):
                k, v = line.split('=', 1)
                kv[k.strip()] = v.strip()
    return kv


def connect():
    kv = load_env()
    host = os.getenv('ASIS_DB_HOST', kv.get('ASIS_DB_HOST'))
    port = os.getenv('ASIS_DB_PORT', kv.get('ASIS_DB_PORT', '1433'))
    db = os.getenv('ASIS_DB_NAME', kv.get('ASIS_DB_NAME'))
    user = os.getenv('ASIS_DB_USER', kv.get('ASIS_DB_USER'))
    pwd = os.getenv('ASIS_DB_PASS', kv.get('ASIS_DB_PASS'))
    drv = kv.get('ASIS_DB_DRIVER', 'ODBC Driver 17 for SQL Server')
    if not all([host, db, user, pwd]):
        sys.exit('ERROR: .env.asis 의 ASIS_DB_* 누락')
    conn_str = (
        f'DRIVER={{{drv}}};SERVER={host},{port};DATABASE={db};'
        f'UID={user};PWD={pwd};TrustServerCertificate=yes;Encrypt=no;'
    )
    return pyodbc.connect(conn_str, timeout=30)


def show(cols, rows, limit=500):
    if not rows:
        print('(no rows)')
        return
    widths = [
        max(len(str(c)), *(len(str(r[i])) for r in rows[:limit]))
        for i, c in enumerate(cols)
    ]
    print(' | '.join(str(c).ljust(widths[i]) for i, c in enumerate(cols)))
    print('-+-'.join('-' * w for w in widths))
    for r in rows[:limit]:
        print(' | '.join(str('' if v is None else v).ljust(widths[i]) for i, v in enumerate(r)))
    print(f'({len(rows)} rows)')


def inventory(conn):
    cur = conn.cursor()

    print('=== [1] SCM_MST_SHEET_COLUMNS 컬럼 인벤토리 (INFORMATION_SCHEMA) ===')
    cur.execute("""
        SELECT ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE,
               CHARACTER_MAXIMUM_LENGTH AS MAX_LEN,
               NUMERIC_PRECISION AS PREC, NUMERIC_SCALE AS SCALE,
               IS_NULLABLE
          FROM INFORMATION_SCHEMA.COLUMNS
         WHERE TABLE_NAME = 'SCM_MST_SHEET_COLUMNS'
         ORDER BY ORDINAL_POSITION
    """)
    cols = [c[0] for c in cur.description]
    rows = cur.fetchall()
    show(cols, rows)
    column_inventory = [tuple(r) for r in rows]

    print()
    print('=== [2] 5 PROGRAM_IDs row 수 + DIVISION_ID 분포 ===')
    placeholders = ','.join(f"'{p}'" for p in PROGRAM_IDS)
    cur.execute(f"""
        SELECT PROGRAM_ID,
               COUNT(*) AS TOTAL,
               COUNT(DISTINCT SHEET_NAME) AS SHEET_CNT,
               COUNT(DISTINCT COLUMN_NAME) AS COL_CNT,
               COUNT(DISTINCT DIVISION_ID) AS DIV_CNT,
               SUM(CASE WHEN DIVISION_ID IS NULL THEN 1 ELSE 0 END) AS DIV_NULL_CNT
          FROM SCM_MST_SHEET_COLUMNS
         WHERE PROGRAM_ID IN ({placeholders})
         GROUP BY PROGRAM_ID
         ORDER BY PROGRAM_ID
    """)
    cols = [c[0] for c in cur.description]
    rows = cur.fetchall()
    show(cols, rows)

    print()
    print('=== [3] PROGRAM_ID × SHEET_NAME × DIVISION_ID 별 row 수 (4-col PK distribution) ===')
    cur.execute(f"""
        SELECT PROGRAM_ID, SHEET_NAME, ISNULL(DIVISION_ID, '(NULL)') AS DIV, COUNT(*) AS CNT
          FROM SCM_MST_SHEET_COLUMNS
         WHERE PROGRAM_ID IN ({placeholders})
         GROUP BY PROGRAM_ID, SHEET_NAME, DIVISION_ID
         ORDER BY PROGRAM_ID, SHEET_NAME, DIV
    """)
    cols = [c[0] for c in cur.description]
    rows = cur.fetchall()
    show(cols, rows)

    print()
    print('=== [4] 4-col 자연키 중복 검증 (있으면 데이터 결함) ===')
    cur.execute(f"""
        SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME,
               ISNULL(DIVISION_ID, '(NULL)') AS DIV, COUNT(*) AS DUP_CNT
          FROM SCM_MST_SHEET_COLUMNS
         WHERE PROGRAM_ID IN ({placeholders})
         GROUP BY PROGRAM_ID, SHEET_NAME, COLUMN_NAME, DIVISION_ID
        HAVING COUNT(*) > 1
         ORDER BY DUP_CNT DESC, PROGRAM_ID, SHEET_NAME, COLUMN_NAME
    """)
    cols = [c[0] for c in cur.description]
    rows = cur.fetchall()
    if rows:
        show(cols, rows)
        print('⚠️ 4-col PK 중복 존재 — MERGE 키 재검토 필요')
    else:
        print('✅ 4-col 자연키 (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, DIVISION_ID) 중복 0건')

    return column_inventory


def _py_to_json(v):
    if v is None:
        return None
    if isinstance(v, (datetime, date)):
        return v.isoformat()
    if isinstance(v, Decimal):
        return str(v)
    if isinstance(v, bytes):
        return v.hex()
    return v


def extract(conn):
    cur = conn.cursor()
    placeholders = ','.join(f"'{p}'" for p in PROGRAM_IDS)
    cur.execute(f"""
        SELECT *
          FROM SCM_MST_SHEET_COLUMNS
         WHERE PROGRAM_ID IN ({placeholders})
         ORDER BY PROGRAM_ID, SHEET_NAME, COLUMN_NAME, DIVISION_ID
    """)
    cols = [c[0] for c in cur.description]
    raw_rows = cur.fetchall()
    rows = [[_py_to_json(v) for v in r] for r in raw_rows]
    out = pathlib.Path(__file__).parent / 'asis_sheet_columns_5screens.json'
    out.write_text(
        json.dumps({'columns': cols, 'rows': rows}, ensure_ascii=False, indent=1),
        encoding='utf-8',
    )
    print(f'추출 완료: {out} ({len(rows)} rows, {len(cols)} cols)')


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    cmd = sys.argv[1]
    conn = connect()
    try:
        if cmd == 'inventory':
            inventory(conn)
        elif cmd == 'extract':
            extract(conn)
        else:
            sys.exit(f'unknown command: {cmd}')
    finally:
        conn.close()


if __name__ == '__main__':
    main()
