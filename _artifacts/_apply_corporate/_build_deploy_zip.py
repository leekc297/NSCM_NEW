"""
SYS0013 클라우드 이관 zip 패키지 빌드:
- 01_FE: 변경 FE 파일 (3개)
- 02_DB_DDL: PKG + 8 standalone SP body
- 03_GRANT_SYNONYM: SCMD_APP 권한
- 04_META: 9 메타 테이블 INSERT SQL (멱등)
- 05_DATA: 5 DQ 테이블 데이터 (107/1886/272/157/192 row)
- 06_DEPLOY: apply.sh + README
"""
import os, shutil, zipfile, datetime as dt
import oracledb

STAMP = dt.datetime.now().strftime('%Y%m%d')
OUT = f'C:/Projects/NSCM/_artifacts/_deploy_packages/SYS0013_{STAMP}'
SRC = 'C:/Projects/NSCM'
ZIP = f'{OUT}.zip'

if os.path.exists(OUT): shutil.rmtree(OUT)
for sub in ['01_FE','02_DB_DDL','03_GRANT_SYNONYM','04_META','05_DATA','06_DEPLOY']:
    os.makedirs(f'{OUT}/{sub}', exist_ok=True)

conn = oracledb.connect(user='SCM_MGR', password='!SCMroqkf2026', dsn='121.162.245.167:2521/ESSCMD')
cur = conn.cursor()

# ============================================================
# 01_FE
# ============================================================
print('=== 01_FE ===')
fe_files = [
    ('nscm-fe/packages/shared/src/hooks/useTabBtnPermissions.ts', 'useTabBtnPermissions.ts'),
    ('nscm-fe/packages/shared/src/hooks/index.ts', 'shared_hooks_index.ts'),
    ('nscm-fe/features/admin/src/pages/dynamic-query/DynamicQuery.tsx', 'DynamicQuery.tsx'),
    ('nscm-fe/features/admin/src/pages/dynamic-query/components/DynamicQueryMainGrid.tsx', 'DynamicQueryMainGrid.tsx'),
    ('nscm-fe/features/admin/src/pages/dynamic-query/dynamic-query.constants.ts', 'dynamic-query.constants.ts'),
]
for src, dst in fe_files:
    shutil.copy(f'{SRC}/{src}', f'{OUT}/01_FE/{dst}')
    print(f'  {dst}')

# ============================================================
# 02_DB_DDL
# ============================================================
print('=== 02_DB_DDL ===')

def extract_source(name, typ):
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE=:t ORDER BY LINE", {'n':name,'t':typ})
    return ''.join(r[0] for r in cur.fetchall())

# PKG spec + body
pkg_spec = extract_source('PKG_SYS0013', 'PACKAGE')
pkg_body = extract_source('PKG_SYS0013', 'PACKAGE BODY')
with open(f'{OUT}/02_DB_DDL/01_PKG_SYS0013_spec.sql', 'w', encoding='utf-8') as f:
    f.write('CREATE OR REPLACE ' + pkg_spec + '\n/\n')
with open(f'{OUT}/02_DB_DDL/02_PKG_SYS0013_body.sql', 'w', encoding='utf-8') as f:
    f.write('CREATE OR REPLACE ' + pkg_body + '\n/\n')
print(f'  PKG_SYS0013 spec + body')

# 8 standalone SPs
standalone_sps = [
    ('SYS0013_GET_HISTORY',       '03'),
    ('SYS0013_SAVE_QUERY',        '04'),
    ('SYS0013_SAVE_COLUMNS',      '05'),
    ('SYS0013_SAVE_PARAMETERS',   '06'),
    ('SYS0013_SAVE_USER_GROUP',   '07'),
    ('SYS0013_DELETE_USER_GROUP', '08'),
    ('SYS0013_EXECUTE_HIST',      '09'),
]
for name, prefix in standalone_sps:
    body = extract_source(name, 'PROCEDURE')
    with open(f'{OUT}/02_DB_DDL/{prefix}_{name}.sql', 'w', encoding='utf-8') as f:
        f.write('CREATE OR REPLACE ' + body + '\n/\n')
    print(f'  {name}')

# ============================================================
# 03_GRANT_SYNONYM
# ============================================================
print('=== 03_GRANT_SYNONYM ===')
with open(f'{OUT}/03_GRANT_SYNONYM/01_GRANT_SCMD_APP.sql', 'w', encoding='utf-8') as f:
    f.write('-- SCMD_APP EXECUTE GRANT — 사내 SCM_MGR user 로 실행\n')
    f.write('GRANT EXECUTE ON PKG_SYS0013 TO SCMD_APP;\n')
    for name, _ in standalone_sps:
        f.write(f'GRANT EXECUTE ON {name} TO SCMD_APP;\n')

with open(f'{OUT}/03_GRANT_SYNONYM/02_SYNONYM_SCMD_APP.sql', 'w', encoding='utf-8') as f:
    f.write('-- SCMD_APP user 로 실행 (SCM_MGR 권한 X)\n')
    f.write('CREATE OR REPLACE SYNONYM PKG_SYS0013 FOR SCM_MGR.PKG_SYS0013;\n')
    for name, _ in standalone_sps:
        f.write(f'CREATE OR REPLACE SYNONYM {name} FOR SCM_MGR.{name};\n')
print(f'  GRANT + SYNONYM')

# ============================================================
# 04_META — 9 메타 SQL (멱등 NOT EXISTS)
# ============================================================
print('=== 04_META ===')

def quote(v):
    if v is None: return 'NULL'
    if isinstance(v, (int, float)): return str(v)
    if isinstance(v, dt.datetime):
        return f"TO_DATE('{v.strftime('%Y-%m-%d %H:%M:%S')}', 'YYYY-MM-DD HH24:MI:SS')"
    s = str(v).replace("'", "''")
    return f"'{s}'"

def gen_insert_idempotent(table, pk_cols, rows, all_cols):
    """NOT EXISTS 패턴 멱등 INSERT 생성"""
    sql_lines = [f'-- {table} ({len(rows)} row)']
    for row in rows:
        cols_str = ', '.join(all_cols)
        vals_str = ', '.join(quote(v) for v in row)
        pk_cond = ' AND '.join(f"{c} = {quote(row[all_cols.index(c)])}" for c in pk_cols)
        sql_lines.append(f"INSERT INTO {table} ({cols_str}) SELECT {vals_str} FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM {table} WHERE {pk_cond});")
    return '\n'.join(sql_lines) + '\n'

# 01_MNU_M
cur.execute("""SELECT MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC, SORT_ORD, MNU_LV_NO, MNU_TP_CD,
                      UNIT_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 FROM SCM_ADM_MNU_M WHERE MNU_ID='SYS0013'""")
cols = ['MNU_ID','UPPR_MNU_ID','MNU_URL','MNU_MSG_ID','MNU_DESC','SORT_ORD','MNU_LV_NO','MNU_TP_CD',
        'UNIT_TP_CD','USE_YN','CREATED_BY','CREATION_DATE','LAST_UPDATED_BY','LAST_UPDATE_DATE']
with open(f'{OUT}/04_META/01_MNU_M.sql', 'w', encoding='utf-8') as f:
    f.write(gen_insert_idempotent('SCM_ADM_MNU_M', ['MNU_ID'], cur.fetchall(), cols))
    f.write('COMMIT;\n')

# 02_MSG_M (MNU00211)
cur.execute("SELECT MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE FROM SCM_ADM_MSG_M WHERE MSG_ID='MNU00211'")
cols = ['MSG_ID','LANG_CD','MSG_NM','MSG_TP_CD','USE_YN','CREATED_BY','CREATION_DATE','LAST_UPDATED_BY','LAST_UPDATE_DATE']
with open(f'{OUT}/04_META/02_MSG_M.sql', 'w', encoding='utf-8') as f:
    f.write(gen_insert_idempotent('SCM_ADM_MSG_M', ['MSG_ID','LANG_CD'], cur.fetchall(), cols))
    f.write('COMMIT;\n')

# 03_API_M
cur.execute("""SELECT API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 FROM SCM_ADM_API_M WHERE API_ID LIKE 'API_SCM0005_%' ORDER BY API_ID""")
cols = ['API_ID','API_TP_CD','API_MSG_ID','API_MSG_DESC','API_URL','USE_YN','CREATED_BY','CREATION_DATE','LAST_UPDATED_BY','LAST_UPDATE_DATE']
api_rows = cur.fetchall()
with open(f'{OUT}/04_META/03_API_M.sql', 'w', encoding='utf-8') as f:
    f.write(gen_insert_idempotent('SCM_ADM_API_M', ['API_ID'], api_rows, cols))
    # API_URL UPDATE (멱등)
    f.write('\n-- API_URL UPDATE (사내 적용 시 새 명칭 동기화)\n')
    for r in api_rows:
        f.write(f"UPDATE SCM_ADM_API_M SET API_URL={quote(r[4])}, USE_YN={quote(r[5])} WHERE API_ID={quote(r[0])};\n")
    f.write('COMMIT;\n')

# 04_PROC_M (SYS0013_*)
cur.execute("""SELECT PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE 'SYS0013%' OR PROC_NM LIKE 'PKG_SYS0013%' ORDER BY PROC_NM, SORT_ORD""")
cols = ['PROC_NM','COL_NM','DATA_TP_CD','COL_TP_CD','SORT_ORD','CREATED_BY','CREATION_DATE','LAST_UPDATED_BY','LAST_UPDATE_DATE']
with open(f'{OUT}/04_META/04_PROC_M.sql', 'w', encoding='utf-8') as f:
    f.write("-- 멱등 — 기존 row DELETE 후 INSERT\n")
    f.write("DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE 'SYS0013%' OR PROC_NM LIKE 'PKG_SYS0013%';\n")
    for row in cur.fetchall():
        f.write(f"INSERT INTO SCM_ADM_PROC_M ({', '.join(cols)}) VALUES ({', '.join(quote(v) for v in row)});\n")
    f.write('COMMIT;\n')

# 05_MNU_BTN_MPG_M
cur.execute("""SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SYS0013' ORDER BY SHT_NM, MNU_BTN_CD""")
cols = ['MNU_ID','SHT_NM','MNU_BTN_CD','API_ID','USE_YN','CREATED_BY','CREATION_DATE','LAST_UPDATED_BY','LAST_UPDATE_DATE']
with open(f'{OUT}/04_META/05_MNU_BTN_MPG_M.sql', 'w', encoding='utf-8') as f:
    f.write(gen_insert_idempotent('SCM_ADM_MNU_BTN_MPG_M', ['MNU_ID','SHT_NM','MNU_BTN_CD'], cur.fetchall(), cols))
    f.write('COMMIT;\n')

# 06_USER_GR_MNU_MPG_M
cur.execute("""SELECT USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='SYS0013'""")
cols = ['USER_GR_ID','MNU_ID','USE_YN','CREATED_BY','CREATION_DATE','LAST_UPDATED_BY','LAST_UPDATE_DATE']
with open(f'{OUT}/04_META/06_USER_GR_MNU_MPG_M.sql', 'w', encoding='utf-8') as f:
    f.write(gen_insert_idempotent('SCM_ADM_USER_GR_MNU_MPG_M', ['USER_GR_ID','MNU_ID'], cur.fetchall(), cols))
    f.write('COMMIT;\n')

# 07_USER_GR_MNU_BTN_MPG_M
cur.execute("""SELECT USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='SYS0013' ORDER BY USER_GR_ID, SHT_NM""")
cols = ['USER_GR_ID','MNU_ID','SHT_NM','MNU_BTN_CD','USE_YN','CREATED_BY','CREATION_DATE','LAST_UPDATED_BY','LAST_UPDATE_DATE']
with open(f'{OUT}/04_META/07_USER_GR_MNU_BTN_MPG_M.sql', 'w', encoding='utf-8') as f:
    f.write(gen_insert_idempotent('SCM_ADM_USER_GR_MNU_BTN_MPG_M', ['USER_GR_ID','MNU_ID','SHT_NM','MNU_BTN_CD'], cur.fetchall(), cols))
    f.write('COMMIT;\n')

# 08_SHEET_COLUMNS
cur.execute("""SELECT * FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SYS0013' ORDER BY SHEET_NAME, SORT_ORDER_NO""")
cols = [d[0] for d in cur.description]
with open(f'{OUT}/04_META/08_SHEET_COLUMNS.sql', 'w', encoding='utf-8') as f:
    f.write("-- 멱등 — 기존 SYS0013 row DELETE 후 INSERT\n")
    f.write("DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SYS0013';\n")
    rows = cur.fetchall()
    for row in rows:
        f.write(f"INSERT INTO SCM_MST_SHEET_COLUMNS ({', '.join(cols)}) VALUES ({', '.join(quote(v) for v in row)});\n")
    f.write('COMMIT;\n')

print(f'  9 META SQL files')

# ============================================================
# 05_DATA — 5 DQ tables
# ============================================================
print('=== 05_DATA ===')
data_tables = [
    ('SCM_ADM_DQ_LIST',       ['DQ_ID']),
    ('SCM_ADM_DQ_COLUMN',     ['DQ_ID','COLUMN_NAME']),
    ('SCM_ADM_DQ_PARAMETER',  ['DQ_ID','PARAMETER_ID']),
    ('SCM_ADM_DQ_USER_GROUP', ['DQ_ID','GROUP_ID']),
    ('SCM_ADM_DQ_EXECUTE_H',  ['HISTORY_SEQ']),
]
for tab, pk in data_tables:
    cur.execute(f"SELECT * FROM {tab}")
    cols = [d[0] for d in cur.description]
    rows = cur.fetchall()
    with open(f'{OUT}/05_DATA/{tab}.sql', 'w', encoding='utf-8') as f:
        f.write(f"-- {tab} ({len(rows)} row) — 멱등 NOT EXISTS\n")
        for row in rows:
            cols_str = ', '.join(cols)
            vals_str = ', '.join(quote(v if not hasattr(v, 'read') else v.read()) for v in row)
            pk_cond = ' AND '.join(f"{c} = {quote(row[cols.index(c)])}" for c in pk)
            f.write(f"INSERT INTO {tab} ({cols_str}) SELECT {vals_str} FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM {tab} WHERE {pk_cond});\n")
        f.write('COMMIT;\n')
    print(f'  {tab} ({len(rows)} row)')

# ============================================================
# 06_DEPLOY — apply.sh + README
# ============================================================
print('=== 06_DEPLOY ===')

with open(f'{OUT}/06_DEPLOY/apply.sh', 'w', encoding='utf-8', newline='\n') as f:
    f.write("""#!/bin/bash
# SYS0013 클라우드 적용 스크립트
# 사용: ./apply.sh <SCM_MGR_PASSWORD> <SCMD_APP_PASSWORD> <DSN>
set -e
SCM_PWD=$1; APP_PWD=$2; DSN=$3
echo "=== Step 1: SCM_MGR — DDL + GRANT + META + DATA ==="
for f in ../02_DB_DDL/*.sql ../03_GRANT_SYNONYM/01_GRANT_SCMD_APP.sql ../04_META/*.sql ../05_DATA/*.sql; do
  echo "  apply: $f"
  tr -d '\\r' < "$f" | sqlplus -L -S "SCM_MGR/\\"$SCM_PWD\\"@$DSN" || exit 1
done
echo "=== Step 2: SCMD_APP — SYNONYM ==="
tr -d '\\r' < ../03_GRANT_SYNONYM/02_SYNONYM_SCMD_APP.sql | sqlplus -L -S "SCMD_APP/\\"$APP_PWD\\"@$DSN" || exit 1
echo "=== Step 3: FE — 5 파일을 수동 배포 (../01_FE/) ==="
echo "All DB steps done."
""")

with open(f'{OUT}/06_DEPLOY/README.md', 'w', encoding='utf-8') as f:
    f.write(f"""# SYS0013 (Dynamic Query List) — 클라우드 이관 패키지

**빌드일자**: {dt.datetime.now().isoformat()}
**원본 환경**: 121.162.245.167:2521/ESSCMD (사내 검증 완료)

## 구조
- `01_FE/` — Frontend 5 파일 (수동 배포)
- `02_DB_DDL/` — PKG + 8 standalone SP (SCM_MGR)
- `03_GRANT_SYNONYM/` — SCMD_APP 권한 (Step 1: SCM_MGR / Step 2: SCMD_APP)
- `04_META/` — 9 메타 테이블 (멱등 NOT EXISTS)
- `05_DATA/` — 5 DQ 데이터 (107 / 1886 / 272 / 157 / 192 = 2,614 row)
- `06_DEPLOY/` — apply.sh + README

## 적용 순서 (수동)

### 1) DB — SCM_MGR user
```bash
sqlplus SCM_MGR/<PWD>@<DSN>
# 02_DB_DDL: PKG spec → body → 8 standalone (순서 중요)
@02_DB_DDL/01_PKG_SYS0013_spec.sql
@02_DB_DDL/02_PKG_SYS0013_body.sql
@02_DB_DDL/03_SYS0013_GET_HISTORY.sql
... (04~09 동일)
# 03_GRANT_SYNONYM
@03_GRANT_SYNONYM/01_GRANT_SCMD_APP.sql
# 04_META (순서)
@04_META/01_MNU_M.sql ~ 08_SHEET_COLUMNS.sql
# 05_DATA
@05_DATA/SCM_ADM_DQ_LIST.sql ~ DQ_EXECUTE_H.sql
```

### 2) DB — SCMD_APP user (SYNONYM 만)
```bash
sqlplus SCMD_APP/<PWD>@<DSN>
@03_GRANT_SYNONYM/02_SYNONYM_SCMD_APP.sql
```

### 3) FE — 5 파일 수동 배포
- `01_FE/useTabBtnPermissions.ts` → `nscm-fe/packages/shared/src/hooks/`
- `01_FE/shared_hooks_index.ts` → `nscm-fe/packages/shared/src/hooks/index.ts`
- `01_FE/DynamicQuery.tsx` → `nscm-fe/features/admin/src/pages/dynamic-query/`
- `01_FE/DynamicQueryMainGrid.tsx` → `nscm-fe/features/admin/src/pages/dynamic-query/components/`
- `01_FE/dynamic-query.constants.ts` → `nscm-fe/features/admin/src/pages/dynamic-query/`

### 4) 검증
- 클라우드 FE 재빌드/배포
- F12 → Clear site data + 재로그인
- SYS0013 메뉴 진입 → 107 row 표시 + DQ_ID ASC 정렬 + columns/parameters/history tab 동작
""")

conn.close()

# ============================================================
# MANIFEST + Zip
# ============================================================
files = []
for root, _, fns in os.walk(OUT):
    for fn in fns:
        full = os.path.join(root, fn)
        files.append(full)
files.sort()

with open(f'{OUT}/MANIFEST.txt', 'w', encoding='utf-8') as f:
    f.write(f"SYS0013 Deploy Package — {STAMP}\n")
    f.write(f"Total files: {len(files)+1}\n\n")
    for fp in files:
        rel = fp.replace(OUT.replace('/','\\\\')+'\\\\', '').replace('\\\\','/')
        rel = fp.replace(OUT,'').lstrip('/\\\\').replace('\\\\','/')
        size = os.path.getsize(fp)
        f.write(f"  {rel:60s} {size:>10} bytes\n")

print(f'\n=== Zip 생성 ===')
with zipfile.ZipFile(ZIP, 'w', zipfile.ZIP_DEFLATED) as zf:
    for root, _, fns in os.walk(OUT):
        for fn in fns:
            full = os.path.join(root, fn)
            arc = full.replace(OUT, f'SYS0013_{STAMP}')
            zf.write(full, arc)
print(f'  {ZIP}')
print(f'  Size: {os.path.getsize(ZIP)/1024:.1f} KB')
