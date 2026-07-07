#!/usr/bin/env python3
"""
generate_merge_sql.py — asis_sheet_columns_5screens.json → Oracle MERGE 스크립트 생성

산출:
  _artifacts/_deploy_packages/SHEET_COLUMNS_ASIS_SYNC/03_META/
    010_AUDIT_PRE.sql               — 사전 row 수 검증
    020_MERGE_DMF0008.sql           — 121 rows
    030_MERGE_DMF0020.sql           — 77 rows
    040_MERGE_DMF0043.sql           — 23 rows
    050_MERGE_DMF0072.sql           — 23 rows
    090_AUDIT_POST.sql              — 사후 row 수

PK (자연키, 4-col): (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, DIVISION_ID)
중복 시 정책: WHEN MATCHED THEN UPDATE all-non-key cols ← AS-IS

⚠️ MSSQL 빈 문자열 ''는 Oracle 에서 NULL 로 변환됨.
   DIVISION_ID 빈 문자열 (DMF0008/SSPM 5건) → NULL 로 처리됨.
   ON 절은 NVL guard 사용.
"""
import json
import pathlib
from datetime import datetime


JSON_PATH = pathlib.Path(__file__).parent / 'asis_sheet_columns_5screens.json'
OUT_DIR = pathlib.Path(__file__).resolve().parents[1] / '_deploy_packages' / 'SHEET_COLUMNS_ASIS_SYNC' / '03_META'

# ────────────────────────────────────────────────────────────────────────────
# SCM_MST_SHEET_COLUMNS 36 컬럼 (Oracle 측 명세 — INFORMATION_SCHEMA 와 동일 순서)
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
# 정수 컬럼 (Oracle NUMBER 캐스팅)
INT_COLS = {'SORT_ORDER_NO', 'COLUMN_WIDTH', 'DATA_SCALE_NUMBER', 'DATA_MAX_LENGTH'}
# datetime 컬럼 (TO_DATE 형식)
DATE_COLS = {'CREATION_DATE', 'LAST_UPDATE_DATE'}
# 4-col 자연키
KEY_COLS = ['PROGRAM_ID', 'SHEET_NAME', 'COLUMN_NAME', 'DIVISION_ID']
NON_KEY_COLS = [c for c in ALL_COLS if c not in KEY_COLS]
# 사내 Oracle NOT NULL with DEFAULT — AS-IS 가 NULL/빈문자열일 때 default 로 대체
# 사내 DDL grep: check_oracle_nullable.py 출력 기반 (2026-06-22)
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
# 사내 Oracle NOT NULL but NO DEFAULT — AS-IS NULL/빈문자열 시 ORA-01400 직결.
# AS-IS 자체가 NOT NULL 인 컬럼들 (PROGRAM_ID/SHEET_NAME/COLUMN_NAME/COLUMN_LABEL_NAME/
# SORT_ORDER_NO/VALID_YN/CREATED_BY/LAST_UPDATED_BY) — 충돌 발생 가능성 0 (cross-check 완료)


def ora_literal(col: str, val) -> str:
    """Oracle 리터럴 변환 (single-quote escape + 타입별 처리 + NOT NULL default 적용)."""
    # NULL / 빈문자열 → NOT NULL with DEFAULT 일 때 default 대체
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
        # MSSQL datetime ISO 'YYYY-MM-DDTHH:MM:SS' or 'YYYY-MM-DDTHH:MM:SS.fff'
        s = str(val).replace('T', ' ')
        if '.' in s:
            s = s.split('.', 1)[0]
        return f"TO_DATE('{s}', 'YYYY-MM-DD HH24:MI:SS')"
    s = str(val).replace("'", "''")
    return f"N'{s}'"


def render_source_row(row_dict: dict) -> str:
    """USING (...) 안의 SELECT...FROM DUAL 1 줄."""
    parts = []
    for col in ALL_COLS:
        lit = ora_literal(col, row_dict.get(col))
        parts.append(f"{lit} AS {col}")
    return '    SELECT ' + ', '.join(parts) + ' FROM DUAL'


def render_merge(program_id: str, rows: list) -> str:
    """단일 PROGRAM_ID 대상 MERGE 문 (전체 36 cols, 4-col PK, NVL guard)."""
    source_block = ' UNION ALL\n'.join(render_source_row(r) for r in rows)

    on_clauses = []
    for k in KEY_COLS:
        if k == 'DIVISION_ID':
            # 빈 문자열도 NULL — NVL guard 로 NULL 매치 보장
            on_clauses.append(
                "    NVL(t.DIVISION_ID, '~~NULL~~') = NVL(s.DIVISION_ID, '~~NULL~~')"
            )
        else:
            on_clauses.append(f'    t.{k} = s.{k}')
    on_block = '\n    AND '.join(on_clauses).lstrip()

    # UPDATE — 32 non-key cols
    update_lines = ',\n    '.join(f't.{c} = s.{c}' for c in NON_KEY_COLS)

    # INSERT — 36 cols
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
"""


def main():
    data = json.loads(JSON_PATH.read_text(encoding='utf-8'))
    src_cols = data['columns']
    src_rows = data['rows']

    # cross-check: AS-IS 컬럼 36 = ALL_COLS 와 동일 (anti-simplification)
    assert src_cols == ALL_COLS, (
        f'AS-IS column 인벤토리 mismatch:\n'
        f'  AS-IS: {src_cols}\n'
        f'  Oracle: {ALL_COLS}'
    )

    # row → dict
    dict_rows = [dict(zip(src_cols, r)) for r in src_rows]

    # PROGRAM_ID 별 group
    groups: dict[str, list] = {}
    for r in dict_rows:
        groups.setdefault(r['PROGRAM_ID'], []).append(r)

    OUT_DIR.mkdir(parents=True, exist_ok=True)

    # ────────── 010_AUDIT_PRE.sql ──────────
    pre_audit_lines = [
        '-- 010_AUDIT_PRE.sql — 사전 row 수 검증',
        'SET PAGESIZE 0',
        'SET LINESIZE 200',
        'SET FEEDBACK ON',
        '',
        'PROMPT === [PRE] 5 PROGRAM_IDs 사내 Oracle 현재 row 수 ===',
        '',
        "SELECT PROGRAM_ID, COUNT(*) AS CURRENT_ROW_CNT",
        "  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS",
        "  WHERE PROGRAM_ID IN ('DMF0008', 'DMF0020', 'DMF0043', 'DMF0043_01', 'DMF0072')",
        "  GROUP BY PROGRAM_ID",
        "  ORDER BY PROGRAM_ID;",
        '',
        'PROMPT === [PRE] AS-IS 와 4-col PK 교집합 row 수 (UPDATE 예상) ===',
        '-- 본 사전 검증은 AS-IS JSON 과 직접 비교는 불가 (별도 환경) → POST AUDIT 의 BEFORE/AFTER diff 로 검증.',
    ]
    (OUT_DIR / '010_AUDIT_PRE.sql').write_text(
        '\n'.join(pre_audit_lines), encoding='utf-8'
    )

    # ────────── 020/030/040/050 MERGE_{PID}.sql ──────────
    pid_seq = [
        ('DMF0008', '020'),
        ('DMF0020', '030'),
        ('DMF0043', '040'),
        ('DMF0072', '050'),
    ]
    total_merge_rows = 0
    for pid, seq in pid_seq:
        rows = groups.get(pid, [])
        total_merge_rows += len(rows)
        header = (
            f'-- {seq}_MERGE_{pid}.sql\n'
            f'-- AS-IS MSSQL → 사내 Oracle MERGE — {len(rows)} rows\n'
            f'-- PK (자연키): {", ".join(KEY_COLS)}\n'
            f"-- 중복 시: UPDATE all non-key cols (AS-IS 덮어쓰기)\n"
            f'-- 생성: {datetime.now().isoformat(timespec="seconds")}\n'
            f'-- ⚠️ DBeaver 실행 시 Run Script (Ctrl+Alt+X) 권장 — Run Statement (F9) X\n'
            f'SET DEFINE OFF\n'
            f'SET SERVEROUTPUT ON\n\n'
        )
        merge_sql = render_merge(pid, rows) if rows else '-- (AS-IS 0 rows — skip)\n'
        footer = (
            f'\nPROMPT === [POST] {pid} row count after MERGE ===\n'
            f"SELECT '{pid}' AS PROGRAM_ID, COUNT(*) AS ROW_CNT\n"
            f"  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS\n"
            f"  WHERE PROGRAM_ID = '{pid}';\n\n"
            f'COMMIT;\n'
        )
        (OUT_DIR / f'{seq}_MERGE_{pid}.sql').write_text(
            header + merge_sql + footer, encoding='utf-8'
        )

    # ────────── 090_AUDIT_POST.sql ──────────
    post_audit_lines = [
        '-- 090_AUDIT_POST.sql — 사후 row 수 + sample diff',
        'SET PAGESIZE 0',
        'SET LINESIZE 200',
        '',
        'PROMPT === [POST] 5 PROGRAM_IDs 적용 후 row 수 ===',
        '',
        "SELECT PROGRAM_ID, COUNT(*) AS ROW_CNT",
        "  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS",
        "  WHERE PROGRAM_ID IN ('DMF0008', 'DMF0020', 'DMF0043', 'DMF0043_01', 'DMF0072')",
        "  GROUP BY PROGRAM_ID",
        "  ORDER BY PROGRAM_ID;",
        '',
        'PROMPT === [POST] PROGRAM_ID x SHEET_NAME x DIVISION_ID 별 row 수 (분포 확인) ===',
        "SELECT PROGRAM_ID, SHEET_NAME, NVL(DIVISION_ID, '(NULL)') AS DIV, COUNT(*) AS CNT",
        "  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS",
        "  WHERE PROGRAM_ID IN ('DMF0008', 'DMF0020', 'DMF0043', 'DMF0043_01', 'DMF0072')",
        "  GROUP BY PROGRAM_ID, SHEET_NAME, DIVISION_ID",
        "  ORDER BY PROGRAM_ID, SHEET_NAME, DIV;",
        '',
        'PROMPT === [POST] LAST_UPDATED_BY 분포 (AS-IS 출처 추적) ===',
        "SELECT LAST_UPDATED_BY, COUNT(*) AS CNT",
        "  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS",
        "  WHERE PROGRAM_ID IN ('DMF0008', 'DMF0020', 'DMF0043', 'DMF0072')",
        "  GROUP BY LAST_UPDATED_BY",
        "  ORDER BY CNT DESC;",
    ]
    (OUT_DIR / '090_AUDIT_POST.sql').write_text(
        '\n'.join(post_audit_lines), encoding='utf-8'
    )

    print(f'생성 완료 ({total_merge_rows} merge rows, 5 files):')
    for f in sorted(OUT_DIR.iterdir()):
        print(f'  {f.name}: {f.stat().st_size} bytes')


if __name__ == '__main__':
    main()
