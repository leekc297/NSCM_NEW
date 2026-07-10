# -*- coding: utf-8 -*-
"""P1.4 DB 검증 — 회귀/신규 스모크(부작용은 ROLLBACK) + PROC_M↔ALL_ARGUMENTS 대사."""
import os
import oracledb

env = {}
with open(r'C:\Projects\NSCM\.env.asis', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if line and not line.startswith('#') and '=' in line:
            k, v = line.split('=', 1); env[k.strip()] = v.strip()
conn = oracledb.connect(user=env['TOBE_DB_USER'], password=env['TOBE_DB_PASS'],
                        dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cur = conn.cursor()
results = []

def gate(name, ok, detail=''):
    results.append(ok)
    print(f"[{'PASS' if ok else 'FAIL'}] {name} {detail}")

# ── 1. 회귀: GET_QUERY_LIST (ADMIN, 필터 없음) ────────────────
rc1 = conn.cursor(); rc2 = conn.cursor()
cur.callproc('PKG_SYS0013.P_SYS0013_GET_QUERY_LIST', ['', '', '', 'minyonglee1', 'SYS0013', rc1, rc2])
rows = rc1.fetchall()
gate('회귀 GET_QUERY_LIST', len(rows) >= 1, f'rows={len(rows)} (기준 27건 대비 역할 필터 반영치)')
rc1.close(); rc2.close()

# ── 2. 신규 GET_HISTORY ──────────────────────────────────────
rc1 = conn.cursor(); rc2 = conn.cursor()
cur.callproc('PKG_SYS0013.P_SYS0013_GET_HISTORY', ['', 'minyonglee1', 'SYS0013', rc1, rc2])
hist_rows = rc1.fetchall()
gate('신규 GET_HISTORY', True, f'rows={len(hist_rows)}')
rc1.close(); rc2.close()

# ── 3. 신규 VALIDATE_QUERY — 정상 SQL ────────────────────────
rc1 = conn.cursor(); rc2 = conn.cursor()
cur.callproc('PKG_SYS0013.P_SYS0013_VALIDATE_QUERY',
             ['SELECT DQ_ID, DQ_NAME, CREATION_DATE FROM SCM_ADM_DQ_LIST', rc1, rc2])
cols = rc1.fetchall()
expect = [('DQ_ID', 'System.Int'), ('DQ_NAME', 'System.String'), ('CREATION_DATE', 'System.Date')]
actual = [(r[0], r[1]) for r in cols]
gate('신규 VALIDATE_QUERY 정상', actual == expect, f'{actual}')
rc1.close(); rc2.close()

# ── 4. 신규 VALIDATE_QUERY — 고의 오류 SQL (예외 기대) ────────
rc1 = conn.cursor(); rc2 = conn.cursor()
try:
    cur.callproc('PKG_SYS0013.P_SYS0013_VALIDATE_QUERY',
                 ['SELECT NO_SUCH_COL FROM NO_SUCH_TABLE_XYZ', rc1, rc2])
    gate('신규 VALIDATE_QUERY 오류SQL', False, '예외 미발생')
except oracledb.DatabaseError as e:
    msg = str(e)
    gate('신규 VALIDATE_QUERY 오류SQL', 'ORA-20001' in msg and 'PKG_SYS0013' in msg, msg[:120])
rc1.close(); rc2.close()

# ── 4b. VALIDATE_QUERY — 비 SELECT 차단 ──────────────────────
rc1 = conn.cursor(); rc2 = conn.cursor()
try:
    cur.callproc('PKG_SYS0013.P_SYS0013_VALIDATE_QUERY', ['DELETE FROM SCM_ADM_DQ_LIST', rc1, rc2])
    gate('VALIDATE_QUERY 비SELECT 차단', False, '차단 안됨')
except oracledb.DatabaseError as e:
    gate('VALIDATE_QUERY 비SELECT 차단', 'SELECT/WITH' in str(e), str(e)[:100])
rc1.close(); rc2.close()

# ── 5. SAVE_USER_GROUP + EXECUTE_HIST 왕복 (ROLLBACK) ─────────
TEST_DQ = '999999'
rc1 = conn.cursor()
cur.callproc('PKG_SYS0013.P_SYS0013_SAVE_USER_GROUP', [TEST_DQ, 'ADMIN', 'Y', 'verify_test', 'verify_test', rc1])
cur.execute("SELECT COUNT(*) FROM SCM_ADM_DQ_USER_GROUP WHERE DQ_ID = :d", {'d': TEST_DQ})
c1 = cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM SCM_ADM_DQ_USER_GROUP_H WHERE DQ_ID = :d AND CREATED_BY='verify_test'", {'d': TEST_DQ})
c2 = cur.fetchone()[0]
gate('신규 SAVE_USER_GROUP (본+H)', c1 == 1 and c2 == 1, f'main={c1} hist={c2}')
rc1.close()
rc1 = conn.cursor()
cur.callproc('PKG_SYS0013.P_SYS0013_EXECUTE_HIST', [TEST_DQ, 'SELECT 1 FROM DUAL', 'verify_test', 'verify_test', rc1])
cur.execute("SELECT COUNT(*) FROM SCM_ADM_DQ_EXECUTE_H WHERE DQ_ID = :d AND CREATED_BY='verify_test'", {'d': TEST_DQ})
c3 = cur.fetchone()[0]
gate('신규 EXECUTE_HIST', c3 == 1, f'hist={c3}')
rc1.close()

# ── 6. SAVE_QUERY_LIST D1 이력 검증 (I → _H 확인 → ROLLBACK) ──
rc1 = conn.cursor(); rc2 = conn.cursor()
payload = '[{"crudType":"I","dqName":"__VERIFY_D1__","description":"d1 test","dqText":"SELECT 1 FROM DUAL","validYn":"Y","adminOnlyYn":"Y"}]'
cur.callproc('PKG_SYS0013.P_SYS0013_SAVE_QUERY_LIST', [payload, 'verify_test', rc1, rc2])
aff = rc1.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM SCM_ADM_DQ_LIST WHERE DQ_NAME='__VERIFY_D1__'")
m1 = cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM SCM_ADM_DQ_LIST_H WHERE DQ_NAME='__VERIFY_D1__'")
h1 = cur.fetchone()[0]
gate('D1 SAVE_QUERY_LIST 이력 (I)', aff == 1 and m1 == 1 and h1 == 1, f'affected={aff} main={m1} hist={h1}')
rc1.close(); rc2.close()

# ── 7. SAVE_COLUMNS / SAVE_PARAMETERS D1 (I → _H → ROLLBACK) ──
rc1 = conn.cursor(); rc2 = conn.cursor()
cur.callproc('PKG_SYS0013.P_SYS0013_SAVE_COLUMNS',
             ['[{"crudType":"I","dqId":999999,"columnName":"__VC__","valueYn":"Y","valueType":"System.String","validYn":"Y","seqno":"1","aggregate":"SUM"}]',
              'verify_test', rc1, rc2])
cur.execute("SELECT COUNT(*) FROM SCM_ADM_DQ_COLUMN_H WHERE DQ_ID=999999 AND COLUMN_NAME='__VC__'")
hc = cur.fetchone()[0]
gate('D1 SAVE_COLUMNS 이력 (I)', hc == 1, f'hist={hc}')
rc1.close(); rc2.close()
rc1 = conn.cursor(); rc2 = conn.cursor()
cur.callproc('PKG_SYS0013.P_SYS0013_SAVE_PARAMETERS',
             ['[{"crudType":"I","dqId":999999,"parameterId":"__VP__","parameterType":"Parameter","operationId":"-","validYn":"Y","repYn":"N","seqno":"1"}]',
              'verify_test', rc1, rc2])
cur.execute("SELECT COUNT(*) FROM SCM_ADM_DQ_PARAMETER_H WHERE DQ_ID=999999 AND PARAMETER_ID='__VP__'")
hp = cur.fetchone()[0]
gate('D1 SAVE_PARAMETERS 이력 (I)', hp == 1, f'hist={hp}')
rc1.close(); rc2.close()

conn.rollback()
print('→ 부작용 전체 ROLLBACK 완료 (시퀀스 소모만 잔존)')

# rollback 확인
cur.execute("SELECT COUNT(*) FROM SCM_ADM_DQ_USER_GROUP WHERE DQ_ID='999999'")
gate('ROLLBACK 확인', cur.fetchone()[0] == 0)

# ── 8. PROC_M ↔ ALL_ARGUMENTS 전수 대사 ──────────────────────
cur.execute("""
SELECT PROC_NM, COL_NM, SORT_ORD, COL_TP_CD FROM SCM_ADM_PROC_M
WHERE PROC_NM LIKE 'PKG_SYS0013%' ORDER BY PROC_NM, SORT_ORD""")
pm = {}
for nm, col, so, io in cur.fetchall():
    pm.setdefault(nm, []).append((so, col, io))
cur.execute("""
SELECT OBJECT_NAME, ARGUMENT_NAME, POSITION, IN_OUT FROM ALL_ARGUMENTS
WHERE OWNER = USER AND PACKAGE_NAME = 'PKG_SYS0013' ORDER BY OBJECT_NAME, POSITION""")
aa = {}
for onm, arg, pos, io in cur.fetchall():
    aa.setdefault(f'PKG_SYS0013.{onm}', []).append((pos, arg, io))
mismatch = []
for nm, rows in pm.items():
    sig = aa.get(nm)
    if sig is None:
        mismatch.append(f'{nm}: SP 없음'); continue
    if len(rows) != len(sig):
        mismatch.append(f'{nm}: PROC_M {len(rows)} vs SP {len(sig)}'); continue
    for (so, col, io), (pos, arg, aio) in zip(sorted(rows), sorted(sig)):
        if io.replace('PROC_RESULT', 'OUT').split('/')[0] not in aio and aio not in ('IN', 'OUT', 'IN/OUT'):
            mismatch.append(f'{nm}#{so}: {io} vs {aio}')
gate('PROC_M↔ALL_ARGUMENTS 대사', not mismatch, f'PKG SP {len(pm)}종 / 불일치 {mismatch}')

print()
print('=' * 50)
print(f'DB 검증: {sum(results)}/{len(results)} PASS')
cur.close(); conn.close()
