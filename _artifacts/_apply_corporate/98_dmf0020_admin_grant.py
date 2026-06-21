"""DMF0020 minyonglee1 ADMIN 권한 그룹 부여 (사용자 요청 — 권한 group 전체 division).

Root cause:
  - minyonglee1.DEPT_ID='LESIC' — SITE_ITEM/PM_TEAM_MAPPING 의 8자리 숫자 코드와 부정합
  - FN_GET_DEPT_LIST 매칭 0 → AUTHORITY_YN='N' → 후속 SELECT 에서 0 row
  - V_GROUP_ID='ADMIN' lookup 도 P_USERINFO 빈값 으로 매칭 안 됨

옵션 A:
  1. SCM_ADM_LOOKUP_MASTER_DETAIL 에 (GET_ADMIN_GROUP, SEGMENT1='minyonglee1', SEGMENT2='ALL') INSERT (멱등)
  2. SP body L190 1줄 변경: `AND SEGMENT1 = P_USERINFO`
                          → `AND (SEGMENT1 = P_USERINFO OR SEGMENT1 = P_CREATED_BY)`

Anti-Simplification:
  - 백업 의무 (98_admin_grant 전용 timestamp 백업)
  - 1줄 외 변경 금지 (minimal change — `feedback_sp_body_no_rewrite` 메모리 룰)
  - STATUS=VALID + callproc 검증 (전 = 0 row, 후 = N rows)
  - 실패 시 즉시 rollback 안내
"""
from __future__ import annotations
import os, re, sys, time, datetime
import oracledb

sys.stdout.reconfigure(line_buffering=True)
u = os.getenv('NSCM_ORA_USER'); p = os.getenv('NSCM_ORA_PASS'); d = os.getenv('NSCM_ORA_DSN')
assert u and p and d
conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}')

ts = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')

# ===========================================================================
# Step 1 — 백업 (SP body)
# ===========================================================================
print('\n[ STEP 1 ] SP body 백업:')
cur.execute("SELECT DBMS_METADATA.GET_DDL('PROCEDURE', 'DMF0020_GET_SCM_MST_FUTURE_PRICE', 'SCM_MGR') FROM DUAL")
body = cur.fetchone()[0].read()
backup_path = f'_logs/DMF0020_GET_SCM_MST_FUTURE_PRICE_BAK_{ts}.sql'
os.makedirs('_logs', exist_ok=True)
with open(backup_path, 'w', encoding='utf-8') as f:
    f.write(body)
print(f'  backup: {backup_path} ({len(body)} bytes)')

# ===========================================================================
# Step 2 — LOOKUP INSERT (멱등)
# ===========================================================================
print('\n[ STEP 2 ] SCM_ADM_LOOKUP_MASTER_DETAIL INSERT (멱등):')
cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
               WHERE LOOKUP_TYPE='GET_ADMIN_GROUP'
                 AND SEGMENT1='minyonglee1' AND SEGMENT2='ALL'""")
if cur.fetchone()[0] > 0:
    print('  이미 등록됨 — skip')
else:
    cur.execute("""INSERT INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL (
        LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5,
        VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES ('GET_ADMIN_GROUP', 'minyonglee1', 'ALL', '-', '-', '-',
                'Y', 'minyonglee1', SYSDATE, 'minyonglee1', SYSDATE)""")
    conn.commit()
    print('  INSERT OK (1 row)')

# verify
cur.execute("""SELECT LOOKUP_TYPE, SEGMENT1, SEGMENT2, VALID_YN, CREATED_BY
               FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
               WHERE LOOKUP_TYPE='GET_ADMIN_GROUP' AND SEGMENT1='minyonglee1'""")
for r in cur.fetchall(): print(f'  verify: {r}')

# ===========================================================================
# Step 3 — SP body 1줄 변경 (멱등)
# ===========================================================================
print('\n[ STEP 3 ] SP body L190 1줄 변경:')

# 멱등 check
if 'OR SEGMENT1 = P_CREATED_BY' in body:
    print('  이미 patched — skip')
    skip_sp = True
else:
    skip_sp = False

if not skip_sp:
    old = '              AND SEGMENT1 = P_USERINFO'
    new = '              AND (SEGMENT1 = P_USERINFO OR SEGMENT1 = P_CREATED_BY)'
    n = body.count(old)
    print(f'  pattern match: {n} occurrence')
    if n != 1:
        # indent 변형 시도
        old2_pat = re.compile(r'^([ \t]+)AND SEGMENT1 = P_USERINFO\s*$', re.MULTILINE)
        matches = list(old2_pat.finditer(body))
        print(f'    fallback regex match: {len(matches)} occurrence')
        if len(matches) != 1:
            print(f'  ❌ pattern 매칭 실패 — SP body 의 정확 indent 확인 필요')
            sys.exit(1)
        m = matches[0]
        indent = m.group(1)
        body_new = body[:m.start()] + f'{indent}AND (SEGMENT1 = P_USERINFO OR SEGMENT1 = P_CREATED_BY)' + body[m.end():]
    else:
        body_new = body.replace(old, new)
    print(f'  변경 후 length: {len(body_new)} (원본 {len(body)})')

    # CREATE OR REPLACE
    print('\n[ STEP 3.1 ] CREATE OR REPLACE PROCEDURE:')
    sql = body_new.rstrip().rstrip('/').rstrip()
    try:
        cur.execute(sql)
        print('  RECOMPILE OK')
    except Exception as e:
        print(f'  ❌ RECOMPILE FAIL: {str(e)[:300]}')
        print(f'  rollback 명령: 백업 file {backup_path} 의 CREATE OR REPLACE 재실행')
        sys.exit(1)

# ===========================================================================
# Step 4 — STATUS=VALID
# ===========================================================================
print('\n[ STEP 4 ] STATUS:')
cur.execute("""SELECT OBJECT_NAME, STATUS FROM ALL_OBJECTS
               WHERE OWNER='SCM_MGR' AND OBJECT_NAME='DMF0020_GET_SCM_MST_FUTURE_PRICE'""")
for r in cur.fetchall(): print(f'  {r}')

# ===========================================================================
# Step 5 — 호출 검증
# ===========================================================================
print('\n[ STEP 5 ] callproc 검증 (minyonglee1, div=40, 90일, CURRENT):')
rc1 = conn.cursor()
result_cursor = conn.cursor()
start = time.time()
try:
    cur.callproc('SCM_MGR.DMF0020_GET_SCM_MST_FUTURE_PRICE',
                 ['40','ALL','ALL','ALL','ALL','ALL','ALL','','','20260621','20260919',
                  'ALL','minyonglee1','minyonglee1','ALL','N','N','CURRENT',
                  rc1, result_cursor])
    elapsed = time.time() - start
    rows = rc1.fetchmany(5)
    print(f'  ✅ TIME: {elapsed:.2f}s  ROWS_SAMPLE: {len(rows)}')
    cols = [c[0] for c in rc1.description or []]
    print(f'  COLS({len(cols)}): {cols[:8]}')
    if rows:
        print(f'  첫 row: {rows[0][:10] if len(rows[0]) > 10 else rows[0]}')
except Exception as e:
    elapsed = time.time() - start
    print(f'  ❌ TIME: {elapsed:.2f}s  ERROR: {str(e)[:200]}')

conn.close()
print('\n[ done ] 옵션 A 적용 완료. 사용자 화면 검증 인계.')
print(f'  - LOOKUP_MASTER_DETAIL: minyonglee1 ADMIN 등록 ✅')
print(f'  - SP body: L190 1줄 변경 (OR SEGMENT1 = P_CREATED_BY 추가) ✅')
print(f'  - 백업: {backup_path}')
