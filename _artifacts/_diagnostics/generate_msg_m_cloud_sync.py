#!/usr/bin/env python3
"""
generate_msg_m_cloud_sync.py — 사내 Oracle SCM_ADM_MSG_M → 클라우드 MERGE 생성

테이블: SCM_MGR.SCM_ADM_MSG_M (10 cols)
PK: (MSG_ID, LANG_CD) — 2-col 자연키
중복 시: WHEN MATCHED THEN UPDATE 8 non-key cols (사내 → 클라우드 덮어쓰기)
청크: LANG_CD 별 (KO / EN / CN) — 단일 MERGE 너무 크지 않게 분리

산출:
  _artifacts/_deploy_packages/MSG_M_CLOUD_SYNC/
    cloud_sync_msg_m_export.sql       — 클라우드 적용 deploy
    cloud_sync_msg_m_inventory.json   — 추출 stats
    README.md                          — 사용법
"""
import re
import json
import pathlib
from datetime import datetime
import oracledb

ROOT = pathlib.Path(__file__).resolve().parents[2]
BE_CFG = ROOT / 'nscm-be' / 'src' / 'main' / 'resources' / 'config' / 'config-local.yml'
OUT_DIR = ROOT / '_artifacts' / '_deploy_packages' / 'MSG_M_CLOUD_SYNC'

ALL_COLS = [
    'MSG_ID', 'LANG_CD', 'MSG_NM', 'MSG_DESC', 'MSG_TP_CD',
    'USE_YN', 'CREATED_BY', 'CREATION_DATE',
    'LAST_UPDATED_BY', 'LAST_UPDATE_DATE',
]
KEY_COLS = ['MSG_ID', 'LANG_CD']
NON_KEY_COLS = [c for c in ALL_COLS if c not in KEY_COLS]
DATE_COLS = {'CREATION_DATE', 'LAST_UPDATE_DATE'}
INT_COLS = set()
# 사내 DDL: 모든 NOT NULL 컬럼이 DEFAULT 없음 → AS-IS 가 NULL 일 가능성 0 (사내 → 사내 복제)


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
        return 'NULL'
    if col in INT_COLS:
        return str(int(val))
    if col in DATE_COLS:
        s = val.strftime('%Y-%m-%d %H:%M:%S') if hasattr(val, 'strftime') else str(val)
        return f"TO_DATE('{s}', 'YYYY-MM-DD HH24:MI:SS')"
    s = str(val).replace("'", "''")
    return f"N'{s}'"


def render_source_row(row_dict: dict) -> str:
    return '    SELECT ' + ', '.join(
        f"{ora_literal(c, row_dict.get(c))} AS {c}" for c in ALL_COLS
    ) + ' FROM DUAL'


def render_merge(rows: list[dict]) -> str:
    source_block = ' UNION ALL\n'.join(render_source_row(r) for r in rows)
    on_block = '\n    AND '.join(f't.{k} = s.{k}' for k in KEY_COLS)
    update_lines = ',\n    '.join(f't.{c} = s.{c}' for c in NON_KEY_COLS)
    insert_cols_block = ', '.join(ALL_COLS)
    insert_vals_block = ', '.join(f's.{c}' for c in ALL_COLS)
    return f"""MERGE INTO SCM_MGR.SCM_ADM_MSG_M t
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
    u, p, d = creds()
    print(f'접속: {u} @ {d}')
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()

    col_list = ', '.join(ALL_COLS)
    cur.execute(f"""
        SELECT {col_list}
          FROM SCM_MGR.SCM_ADM_MSG_M
         ORDER BY LANG_CD, MSG_TP_CD, MSG_ID
    """)
    all_rows = [dict(zip(ALL_COLS, r)) for r in cur.fetchall()]
    print(f'추출: {len(all_rows)} rows')

    # LANG_CD 별 group
    groups: dict[str, list] = {}
    for r in all_rows:
        groups.setdefault(r['LANG_CD'], []).append(r)

    OUT_DIR.mkdir(parents=True, exist_ok=True)

    out_lines = [
        '--==============================================================================',
        '-- cloud_sync_msg_m_export.sql',
        '-- 출처: 사내 Oracle SCM_MGR.SCM_ADM_MSG_M 전체 → 클라우드 적용용 MERGE',
        f'-- 생성: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}',
        f'-- 총 row: {len(all_rows)} / chunk (LANG_CD): {len(groups)}',
        '-- PK (자연키, 2-col): MSG_ID, LANG_CD',
        '-- 중복 시: WHEN MATCHED THEN UPDATE all-non-key (사내 → 클라우드 덮어쓰기)',
        '-- 클라우드 only row: 유지 (DELETE 없음)',
        '-- 청크: LANG_CD 별 별도 MERGE + COMMIT',
        '--',
        '-- 실행 도구: DBeaver "Execute SQL Script" (Ctrl+Alt+X) — Run Statement (F9) 금지',
        '-- 또는: sqlplus / SQLcl 에서 @cloud_sync_msg_m_export.sql',
        '--==============================================================================',
        '',
        'SET DEFINE OFF',
        'SET SERVEROUTPUT ON',
        '',
    ]

    inventory = {
        'generated_at': datetime.now().isoformat(timespec='seconds'),
        'table': 'SCM_MGR.SCM_ADM_MSG_M',
        'pk': KEY_COLS,
        'total_rows': len(all_rows),
        'chunks': [],
    }

    for chunk_idx, (lang, rows) in enumerate(sorted(groups.items()), 1):
        out_lines.append(
            f'-- ─────────────────────── chunk {chunk_idx}/{len(groups)} : '
            f'LANG_CD = {lang} ({len(rows)} rows) ───────────────────────'
        )
        out_lines.append(f"PROMPT === [{chunk_idx}/{len(groups)}] MERGE LANG_CD={lang} ({len(rows)} rows) ===")
        out_lines.append(render_merge(rows))
        out_lines.append('')
        inventory['chunks'].append({'lang': lang, 'rows': len(rows)})

    out_lines += [
        '-- ─────────────────────── 적용 후 검증 ───────────────────────',
        'PROMPT === [POST] 클라우드 전체 row 수 ===',
        'SELECT COUNT(*) AS TOTAL FROM SCM_MGR.SCM_ADM_MSG_M;',
        '',
        'PROMPT === [POST] LANG_CD × MSG_TP_CD 분포 ===',
        'SELECT LANG_CD, MSG_TP_CD, COUNT(*) AS CNT',
        '  FROM SCM_MGR.SCM_ADM_MSG_M',
        '  GROUP BY LANG_CD, MSG_TP_CD',
        '  ORDER BY LANG_CD, MSG_TP_CD;',
        '',
        'PROMPT === cloud_sync_msg_m_export.sql 적용 완료 ===',
    ]

    out_path = OUT_DIR / 'cloud_sync_msg_m_export.sql'
    out_path.write_text('\n'.join(out_lines), encoding='utf-8')
    inv_path = OUT_DIR / 'cloud_sync_msg_m_inventory.json'
    inv_path.write_text(json.dumps(inventory, ensure_ascii=False, indent=2), encoding='utf-8')

    readme = f"""# MSG_M_CLOUD_SYNC — SCM_ADM_MSG_M 사내 → 클라우드 이관

## 산출
- `cloud_sync_msg_m_export.sql` ({out_path.stat().st_size:,} bytes) — 클라우드 적용 deploy
- `cloud_sync_msg_m_inventory.json` — 추출 stats

## 정보
- **출처 테이블**: 사내 `SCM_MGR.SCM_ADM_MSG_M`
- **PK (자연키, 2-col)**: `(MSG_ID, LANG_CD)`
- **컬럼 수**: 10
- **총 row**: {len(all_rows)}
- **LANG_CD 분포 (chunk)**: {' / '.join(f"{c['lang']}={c['rows']}" for c in inventory['chunks'])}
- **MSG_TP_CD 분포 (사내)**: LBL=580 / MNU=639 / MSG=100 / API=32

## 정책
- WHEN MATCHED → UPDATE 8 non-key cols (사내 덮어쓰기)
- WHEN NOT MATCHED → INSERT 10 cols
- 클라우드 only row 유지 (DELETE 없음)
- chunk별 COMMIT (LANG_CD 별 격리)

## 클라우드 적용
1. 클라우드 Oracle SCM_MGR 접속
2. DBeaver → `cloud_sync_msg_m_export.sql` 열기 → **Execute SQL Script** (`Ctrl+Alt+X`)
3. POST audit SELECT 결과 = `cloud_sync_msg_m_inventory.json` 의 chunks 와 비교 검증

## 생성 출처
- `_artifacts/_diagnostics/generate_msg_m_cloud_sync.py` (사내 직접 조회 + 파일 생성)
- 자격 정보: `nscm-be/.../config-local.yml` 자동 추출 (inline 노출 0)
"""
    (OUT_DIR / 'README.md').write_text(readme, encoding='utf-8')

    print(f'\n산출:')
    print(f'  {out_path}: {out_path.stat().st_size:,} bytes')
    print(f'  {inv_path}: {inv_path.stat().st_size:,} bytes')
    print(f'  {OUT_DIR / "README.md"}')
    print(f'\nChunk 분포:')
    for c in inventory['chunks']:
        print(f"  LANG_CD={c['lang']:3} → {c['rows']} rows")

    con.close()


if __name__ == '__main__':
    main()
