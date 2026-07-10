# -*- coding: utf-8 -*-
"""DMF0014 Excel Upload 2-Step 적용 — ① PKG BODY 게이트 복원(P_MODE>0) ② SAVE call-proc 메타.
멱등 · 재컴파일 VALID 검증 · 배포 전 백업(01_ddl/00_..ORIG_backup.sql)."""
import os, re, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
env = {}
for line in open(r'C:\Projects\NSCM\.env.asis', encoding='utf-8'):
    line = line.strip()
    if line and not line.startswith('#') and '=' in line:
        k, v = line.split('=', 1); env[k.strip()] = v.strip()
conn = oracledb.connect(user=env['TOBE_DB_USER'], password=env['TOBE_DB_PASS'],
                        dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cur = conn.cursor()

# ── ① PACKAGE BODY 배포 (CREATE OR REPLACE — DDL 단일 실행) ──
body = open(os.path.join(HERE, '01_ddl', '01_PKG_DMF0014_BODY_2step_FIX.sql'), encoding='utf-8').read()
print('=== ① PKG_DMF0014 BODY 배포 (P_MODE>0 게이트 복원) ===')
cur.execute(body)
conn.commit()
# 재컴파일 + 상태 검증
cur.execute("ALTER PACKAGE SCM_MGR.PKG_DMF0014 COMPILE BODY")
cur.execute("SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0014' AND OBJECT_TYPE='PACKAGE BODY'")
st = cur.fetchone()[0]
print('  PKG_DMF0014 BODY STATUS:', st)
if st != 'VALID':
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY' ORDER BY SEQUENCE")
    for r in cur.fetchall(): print('   ERR L%s:%s %s' % r)
    conn.rollback(); conn.close(); sys.exit(1)
# 변경 라인 확인 (게이트 복원 반영)
cur.execute("SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY' AND INSTR(TEXT,'[DMF0014 2-Step]')>0")
print('  게이트 복원 라인(1 기대):', cur.fetchone()[0])

# ── ② 메타 배선 (멱등 MERGE) ──
meta = open(os.path.join(HERE, '02_meta', '01_dmf0014_upload_save_meta.sql'), encoding='utf-8').read()
stmts = [s.strip() for s in re.sub(r'^--.*$', '', meta, flags=re.M).split(';') if s.strip() and s.strip().upper() != 'COMMIT']
print('=== ② 메타 배선 — %d statements ===' % len(stmts))
for i, s in enumerate(stmts, 1):
    cur.execute(s)
    print('  [%d] OK (%d rows) : %s' % (i, cur.rowcount, ' '.join(s.split()[:4])))
conn.commit()

print('\n=== VERIFY ===')
for chk, sql in [
    ('API DMF0014_upload_SAVE(1)', "SELECT COUNT(*) FROM SCM_ADM_API_M WHERE API_ID='DMF0014_upload_SAVE'"),
    ('PROC EXCEL_UPLOAD(5)', "SELECT COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM='PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD'"),
    ('BTN UPLOAD_SAVE(1)', "SELECT COUNT(*) FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0014' AND MNU_BTN_CD='UPLOAD_SAVE'"),
    ('USER_GR UPLOAD_SAVE(2)', "SELECT COUNT(*) FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0014' AND MNU_BTN_CD='UPLOAD_SAVE'"),
    ('PKG BODY VALID', "SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0014' AND OBJECT_TYPE='PACKAGE BODY'"),
]:
    cur.execute(sql); print('  %-28s = %s' % (chk, cur.fetchone()[0]))
cur.close(); conn.close(); print('DONE')
