#!/usr/bin/env python3
"""
generate_cloud_sync.py — 사내 Oracle 의 SCM_MST_SHEET_COLUMNS 전체 → 클라우드 배포용 MERGE 생성

사내 SCM_MGR.SCM_MST_SHEET_COLUMNS 전체 row 를 직접 조회한 뒤 (자격 정보 BE config 자동 추출),
PROGRAM_ID 별 chunk MERGE 문으로 분할한 단일 SQL 파일 출력.

산출:
  _artifacts/_deploy_packages/SHEET_COLUMNS_ASIS_SYNC/04_CLOUD_SYNC/
    cloud_sync_sheet_columns_export.sql   (사용자가 클라우드 SCM_MGR 계정으로 실행)
    cloud_sync_inventory.json              (추출 stats: PROGRAM_ID 별 count + 생성 시각)

정책:
  PK (4-col): PROGRAM_ID, SHEET_NAME, COLUMN_NAME, DIVISION_ID (NVL guard)
  WHEN MATCHED THEN UPDATE all-non-key (32 cols)
  WHEN NOT MATCHED THEN INSERT (36 cols)
  NOT NULL DEFAULT 컬럼 (8종) — NULL/빈문자열 시 사내 DDL DEFAULT 로 대체
"""
import json
import pathlib
import re
import sys
from datetime import datetime

import oracledb

ROOT = pathlib.Path(__file__).resolve().parents[2]
BE_CFG = ROOT / 'nscm-be' / 'src' / 'main' / 'resources' / 'config' / 'config-local.yml'
OUT_DIR = ROOT / '_artifacts' / '_deploy_packages' / 'SHEET_COLUMNS_ASIS_SYNC' / '04_CLOUD_SYNC'

# ────────────────────────────────────────────────────────────────────────────
# 36 컬럼 (사내 = AS-IS = 동일 — 사전 검증 완료)
# ────────────────────────────────────────────────────────────────────────────
ALL_COLS = [
    'PROGRAM_ID', 'SHEET_NAME', 'COLUMN_NAME', 'COLUMN_LABEL_NAME', 'SORT_ORDER_NO',
    'DATA_SORT_METHOD_CODE', 'SMALL_CLASS_LABEL_NAME', 'LARGE_CLASS_LABEL_NAME',
    'FIXED_FLAG', 'COLUMN_WIDTH', 'CELL_CONTROL_OBJECT_TYPE_CODE',
    'CELL_COMBO_DATA_TYPE', 'DATA_SCALE_NUMBER', 'DATA_MAX_LENGTH',
    'HORIZONTAL_ALIGN_CODE', 'UPPERCASE_APPLY_FLAG', 'VISIBLE_FLAG',
    'DIVISION_ID', 'DEFAULT_FLAG', 'USER_SELECTABLE_FLAG', 'VALID_YN',
    'CREATED_BY', 'CREATION_DATE', 'LAST_UPDATED_BY', 'LAST_UPDATE_DATE',
    'ATTRIBUTE1', 'ATTRIBUTE2', 'ATTRIBUTE3', 'ATTRIBUTE4', 'ATTRIBUTE5',
    'ATTRIBUTE6', 'ATTRIBUTE7', 'ATTRIBUTE8', 'ATTRIBUTE9', 'ATTRIBUTE10',
    'INPUT_TP_CD',
]
INT_COLS = {'SORT_ORDER_NO', 'COLUMN_WIDTH', 'DATA_SCALE_NUMBER', 'DATA_MAX_LENGTH'}
DATE_COLS = {'CREATION_DATE', 'LAST_UPDATE_DATE'}
KEY_COLS = ['PROGRAM_ID', 'SHEET_NAME', 'COLUMN_NAME', 'DIVISION_ID']
NON_KEY_COLS = [c for c in ALL_COLS if c not in KEY_COLS]

# 사내 Oracle DDL DEFAULT (check_oracle_nullable.py 출력 기반)
ORACLE_NOT_NULL_DEFAULTS = {
    'FIXED_FLAG': 'N',
    'COLUMN_WIDTH': 80,
    'HORIZONTAL_ALIGN_CODE': 'C',
    'UPPERCASE_APPLY_FLAG': 'N',
    'VISIBLE_FLAG': 'Y',
    'DEFAULT_FLAG': 'Y',
    'USER_SELECTABLE_FLAG': 'Y',
    'INPUT_TP_CD': 'S',
}


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


def ora_literal(col: str, val) -> str:
    if val is None or val == '':
        if col in ORACLE_NOT_NULL_DEFAULTS:
            dv = ORACLE_NOT_NULL_DEFAULTS[col]
            if col in INT_COLS:
                return str(int(dv))
            return f"N'{dv}'"
        return 'NULL'
    if col in INT_COLS:
        return str(int(val))
    if col in DATE_COLS:
        # oracledb 는 DATE 를 datetime.datetime 으로 반환
        s = val.strftime('%Y-%m-%d %H:%M:%S') if hasattr(val, 'strftime') else str(val)
        return f"TO_DATE('{s}', 'YYYY-MM-DD HH24:MI:SS')"
    s = str(val).replace("'", "''")
    return f"N'{s}'"


def render_source_row(row_dict: dict) -> str:
    parts = []
    for col in ALL_COLS:
        parts.append(f"{ora_literal(col, row_dict.get(col))} AS {col}")
    return '    SELECT ' + ', '.join(parts) + ' FROM DUAL'


def render_merge_for_program(pid: str, rows: list[dict]) -> str:
    source_block = ' UNION ALL\n'.join(render_source_row(r) for r in rows)
    on_clauses = []
    for k in KEY_COLS:
        if k == 'DIVISION_ID':
            on_clauses.append(
                "    NVL(t.DIVISION_ID, '~~NULL~~') = NVL(s.DIVISION_ID, '~~NULL~~')"
            )
        else:
            on_clauses.append(f'    t.{k} = s.{k}')
    on_block = '\n    AND '.join(on_clauses).lstrip()
    update_lines = ',\n    '.join(f't.{c} = s.{c}' for c in NON_KEY_COLS)
    insert_cols_block = ', '.join(ALL_COLS)
    insert_vals_block = ', '.join(f's.{c}' for c in ALL_COLS)
    return f"""MERGE INTO SCM_MGR.SCM_MST_SHEET_COLUMNS t
USING (
{source_block}
) s
ON (
    {on_block}
)
WHEN MATCHED THEN UPDATE SET
    {update_lines}
WHEN NOT MATCHED THEN INSERT (
    {insert_cols_block}
) VALUES (
    {insert_vals_block}
);
COMMIT;
"""


def main():
    user, pwd, dsn = creds()
    print(f'접속: {user} @ {dsn}')
    con = oracledb.connect(user=user, password=pwd, dsn=dsn)
    cur = con.cursor()

    col_list = ', '.join(ALL_COLS)
    cur.execute(f"""
        SELECT {col_list}
          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
         ORDER BY PROGRAM_ID, SHEET_NAME, COLUMN_NAME, DIVISION_ID
    """)
    all_rows = []
    while True:
        batch = cur.fetchmany(1000)
        if not batch:
            break
        for r in batch:
            all_rows.append(dict(zip(ALL_COLS, r)))

    # PROGRAM_ID 별 group (정렬 유지)
    groups = {}
    for r in all_rows:
        groups.setdefault(r['PROGRAM_ID'], []).append(r)

    total_rows = len(all_rows)
    total_pids = len(groups)
    print(f'추출 완료: {total_rows} rows / {total_pids} PROGRAM_IDs')

    OUT_DIR.mkdir(parents=True, exist_ok=True)

    # ─── 본문 ───
    out_lines = [
        '--==============================================================================',
        '-- cloud_sync_sheet_columns_export.sql',
        '-- 출처: 사내 Oracle SCM_MGR.SCM_MST_SHEET_COLUMNS 전체 데이터 → 클라우드 배포용 MERGE',
        f'-- 생성 시각: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}',
        f'-- 총 row 수: {total_rows} / 총 chunk (PROGRAM_ID): {total_pids}',
        '-- PK (자연키, 4-col): PROGRAM_ID, SHEET_NAME, COLUMN_NAME, DIVISION_ID (NVL guard)',
        '-- 중복 시: WHEN MATCHED THEN UPDATE all-non-key (사내 → 클라우드 덮어쓰기)',
        '-- 클라우드 only row 는 유지 (DELETE 없음)',
        '-- NOT NULL DEFAULT 컬럼 (8종) — NULL/빈문자열 시 사내 DDL DEFAULT 대체',
        '-- 청크 전략: PROGRAM_ID 별 별도 MERGE + COMMIT (부분 실패 격리)',
        '--',
        '-- 실행 도구: DBeaver "Execute SQL Script" (Ctrl+Alt+X) 권장 — Run Statement (F9) 사용 금지',
        '-- 또는: sqlplus / SQLcl 에서 @cloud_sync_sheet_columns_export.sql',
        '--==============================================================================',
        '',
        'SET DEFINE OFF',
        'SET SERVEROUTPUT ON',
        '',
    ]

    inventory = {
        'generated_at': datetime.now().isoformat(timespec='seconds'),
        'total_rows': total_rows,
        'total_pids': total_pids,
        'chunks': [],
    }

    for chunk_idx, (pid, rows) in enumerate(sorted(groups.items()), 1):
        out_lines.append(
            f'-- ─────────────────────── chunk {chunk_idx}/{total_pids} : '
            f'PROGRAM_ID = {pid} ({len(rows)} rows) ───────────────────────'
        )
        out_lines.append(f"PROMPT === [{chunk_idx}/{total_pids}] MERGE {pid} ({len(rows)} rows) ===")
        out_lines.append(render_merge_for_program(pid, rows))
        out_lines.append('')
        inventory['chunks'].append({'pid': pid, 'rows': len(rows)})

    # 사후 검증
    out_lines += [
        '-- ─────────────────────── 적용 후 검증 ───────────────────────',
        'PROMPT === [POST] 클라우드 전체 row 수 ===',
        'SELECT COUNT(*) AS TOTAL FROM SCM_MGR.SCM_MST_SHEET_COLUMNS;',
        '',
        'PROMPT === [POST] PROGRAM_ID 별 row 수 (사내 값과 비교) ===',
        'SELECT PROGRAM_ID, COUNT(*) AS CNT',
        '  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS',
        '  GROUP BY PROGRAM_ID',
        '  ORDER BY PROGRAM_ID;',
        '',
        'PROMPT === cloud_sync_sheet_columns_export.sql 적용 완료 ===',
    ]

    out_path = OUT_DIR / 'cloud_sync_sheet_columns_export.sql'
    out_path.write_text('\n'.join(out_lines), encoding='utf-8')
    inv_path = OUT_DIR / 'cloud_sync_inventory.json'
    inv_path.write_text(json.dumps(inventory, ensure_ascii=False, indent=2), encoding='utf-8')

    print()
    print(f'산출:')
    print(f'  {out_path}: {out_path.stat().st_size:,} bytes')
    print(f'  {inv_path}: {inv_path.stat().st_size:,} bytes')
    print()
    print('Chunk 분포 (Top 10):')
    sorted_chunks = sorted(inventory['chunks'], key=lambda x: -x['rows'])[:10]
    for c in sorted_chunks:
        print(f"  {c['pid']:20} {c['rows']:6d} rows")
    print(f"  ... (총 {total_pids} PROGRAM_IDs)")

    con.close()


if __name__ == '__main__':
    main()
