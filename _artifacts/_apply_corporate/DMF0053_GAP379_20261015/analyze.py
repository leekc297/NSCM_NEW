# GAP 379 분석 (조회 전용) — AS-IS DEV SCM_MST_TITLESET_USER(DMF0053) ↔ TO-BE 사내 ZIOUI1 메타·기존 행 대조
#   판정: C = TO-BE SCM_MST_SHEET_COLUMNS(DMF0053/CUST Fcst Waterfall) 에 COLUMN_NAME 존재
#         M = TO-BE SCM_MST_SHEET_MEASURE(같은 시트, VALID_YN='Y') 에 COLUMN_NAME 존재
#         PK(USER_ID,PROGRAM_ID,SHEET_NAME,TYPE,COLUMN_NAME) 가 TO-BE 에 이미 있으면 보존(이관 제외)
#   결과 = asis_rows.json (이관 원천 스냅샷) + 화면 출력
import json, pathlib, sys, datetime, oracledb, pyodbc
sys.path.insert(0, '_artifacts/_diagnostics'); import ora

HERE = pathlib.Path(__file__).parent
env = {}
for line in pathlib.Path('C:/Projects/NSCM/.env.asis').read_text(encoding='utf-8').splitlines():
    if '=' in line and not line.lstrip().startswith('#'):
        k, v = line.split('=', 1); env[k.strip()] = v.strip().strip('"')
ms = pyodbc.connect(f"DRIVER={{{env['ASIS_DB_DRIVER']}}};SERVER={env['ASIS_DB_HOST']},{env['ASIS_DB_PORT']};"
                    f"DATABASE={env['ASIS_DB_NAME']};UID={env['ASIS_DB_USER']};PWD={env['ASIS_DB_PASS']};TrustServerCertificate=yes")
mc = ms.cursor()
mc.execute("SELECT @@SERVERNAME, DB_NAME(), CONVERT(varchar(19),GETDATE(),120)")
src_info = mc.fetchone(); print('AS-IS', tuple(src_info))
COLS = ['USER_ID', 'PROGRAM_ID', 'SHEET_NAME', 'USER_INQUIRY_COLUMN_TYPE_CODE', 'COLUMN_NAME', 'SORT_ORDER_NO',
        'SUB_TOTAL_FLAG', 'DATA_SORT_METHOD_CODE', 'CREATED_BY', 'CREATION_DATE', 'LAST_UPDATED_BY', 'LAST_UPDATE_DATE',
        'ATTRIBUTE1', 'ATTRIBUTE2', 'ATTRIBUTE3', 'ATTRIBUTE4', 'ATTRIBUTE5', 'ATTRIBUTE6', 'ATTRIBUTE7', 'ATTRIBUTE8', 'ATTRIBUTE9', 'ATTRIBUTE10']
mc.execute(f"SELECT {', '.join(COLS)} FROM SCM_MST_TITLESET_USER WITH(NOLOCK) WHERE PROGRAM_ID='DMF0053' ORDER BY USER_ID, USER_INQUIRY_COLUMN_TYPE_CODE, SORT_ORDER_NO")
rows = [dict(zip(COLS, r)) for r in mc.fetchall()]
print('AS-IS rows', len(rows))

u, p, d = ora.conn_info(); oc = oracledb.connect(user=u, password=p, dsn=d).cursor()
oc.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('TO-BE', oc.fetchone())
oc.execute("SELECT COLUMN_NAME, VALID_YN, DEFAULT_FLAG, USER_SELECTABLE_FLAG FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0053' AND SHEET_NAME='CUST Fcst Waterfall'")
sc = {r[0]: r[1:] for r in oc.fetchall()}
oc.execute("SELECT COLUMN_NAME FROM SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID='DMF0053' AND SHEET_NAME='CUST Fcst Waterfall' AND VALID_YN='Y'")
sm = {r[0] for r in oc.fetchall()}
oc.execute("SELECT USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0053'")
tobe_pk = {tuple(r) for r in oc.fetchall()}
oc.execute("SELECT DISTINCT USER_ID || '|' || USER_INQUIRY_COLUMN_TYPE_CODE FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0053'")
tobe_ut = {r[0] for r in oc.fetchall()}

stat = {}
for r in rows:
    t, c = r['USER_INQUIRY_COLUMN_TYPE_CODE'], r['COLUMN_NAME']
    pk = (r['USER_ID'], r['PROGRAM_ID'], r['SHEET_NAME'], t, c)
    if r['SHEET_NAME'] != 'CUST Fcst Waterfall':
        why = 'SKIP_SHEET'
    elif (t == 'C' and c not in sc) or (t == 'M' and c not in sm) or t not in ('C', 'M'):
        why = 'SKIP_NOMETA'
    elif pk in tobe_pk:
        why = 'SKIP_EXISTS'
    elif f"{r['USER_ID']}|{t}" in tobe_ut:
        why = 'SKIP_USER_HAS_TOBE_SET'
    else:
        why = 'MIGRATE'
    r['_JUDGE'] = why
    stat[(t, why)] = stat.get((t, why), 0) + 1
for k in sorted(stat): print('  ', k, stat[k])
print('NOMETA columns:', sorted({(r['USER_INQUIRY_COLUMN_TYPE_CODE'], r['COLUMN_NAME']) for r in rows if r['_JUDGE'] == 'SKIP_NOMETA'}))
mig = [r for r in rows if r['_JUDGE'] == 'MIGRATE']
print('MIGRATE users C:', sorted({r['USER_ID'] for r in mig if r['USER_INQUIRY_COLUMN_TYPE_CODE'] == 'C'}))
print('MIGRATE users M:', sorted({r['USER_ID'] for r in mig if r['USER_INQUIRY_COLUMN_TYPE_CODE'] == 'M'}))
print('M columns (AS-IS):', sorted({r['COLUMN_NAME'] for r in rows if r['USER_INQUIRY_COLUMN_TYPE_CODE'] == 'M'}), '| TO-BE meta M:', sorted(sm))
print('sub_total / sort_method values:', sorted({(r['SUB_TOTAL_FLAG'], r['DATA_SORT_METHOD_CODE']) for r in rows}, key=str))
dflt = lambda o: o.strftime('%Y-%m-%d %H:%M:%S') if isinstance(o, datetime.datetime) else str(o)
(HERE / 'asis_rows.json').write_text(json.dumps({'source': [str(x) for x in src_info], 'rows': rows}, default=dflt, ensure_ascii=False, indent=1), encoding='utf-8')
print('saved asis_rows.json')
