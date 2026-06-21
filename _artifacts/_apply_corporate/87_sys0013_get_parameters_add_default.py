"""SYS0013 GET_PARAMETERS SP body 에 DEFAULT_VALUE alias 추가 (ATTRIBUTE2).

배경:
  사용자 결정 (2026-06-21):
  - Parameters Grid 의 OPERATION_ID 컬럼 = dropdown (= / > / < / IN / LIKE)
  - DEFAULT 컬럼 추가 → 사용자 입력 전 초기값 표시

설계:
  - ATTRIBUTE1 = SEQNO 이미 사용 중 (SP body L232 `NVL(ATTRIBUTE1, '0') AS SEQNO`)
  - ATTRIBUTE2 = DEFAULT_VALUE 로 활용 (메모리 룰 `feedback_existing_column_reuse_before_alter` — ALTER 회피)

변경:
  PKG_SYS0013 BODY L232 직후 1줄 alias 추가:
    , NVL(ATTRIBUTE2, '') AS DEFAULT_VALUE

순서:
  1. DBMS_METADATA.GET_DDL 로 PACKAGE BODY 추출
  2. SELECT 안 'NVL(ATTRIBUTE1, ''0'') AS SEQNO' 다음에 ', NVL(ATTRIBUTE2, ''') AS DEFAULT_VALUE' 추가
  3. CREATE OR REPLACE 적용
  4. STATUS=VALID 확인
  5. 직접 호출 검증 → DEFAULT_VALUE 컬럼 반환 확인

Anti-Simplification: 다른 procedure body 1바이트도 변경 안 함 (메모리 `feedback_sp_body_no_rewrite`).
"""
import os, re, sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv('NSCM_ORA_USER'); p = os.getenv('NSCM_ORA_PASS'); d = os.getenv('NSCM_ORA_DSN')
assert u and p and d, 'NSCM_ORA_USER/PASS/DSN required'

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}')

# Step 1 — 추출
print('\n[ STEP 1 ] PKG_SYS0013 BODY DDL 추출:')
cur.execute("SELECT DBMS_METADATA.GET_DDL('PACKAGE_BODY', 'PKG_SYS0013', 'SCM_MGR') FROM DUAL")
ddl_lob = cur.fetchone()[0]
ddl = ddl_lob.read() if isinstance(ddl_lob, oracledb.LOB) else ddl_lob
print(f'  body length: {len(ddl)}')

# Step 2 — alias 1줄 추가 (idempotent — 이미 있으면 skip)
target = "NVL(ATTRIBUTE1, '0') AS SEQNO"
addition = ",\n   NVL(ATTRIBUTE2, '') AS DEFAULT_VALUE\n   "

if 'DEFAULT_VALUE' in ddl:
    print('  이미 DEFAULT_VALUE 추가됨 — skip (멱등)')
    skip_recompile = True
else:
    # 첫번째 매칭만 (GET_PARAMETERS body — GET_COLUMNS 는 ATTRIBUTE1=SEQNO 미사용)
    if target not in ddl:
        print(f'  ❌ target text 미발견 — {target!r}')
        sys.exit(1)
    new_ddl = ddl.replace(target, target + addition, 1)
    print(f'  변경 후 length: {len(new_ddl)}')
    skip_recompile = False

# Step 3 — CREATE OR REPLACE
if not skip_recompile:
    print('\n[ STEP 3 ] CREATE OR REPLACE PACKAGE BODY:')
    # DBMS_METADATA 의 DDL 끝 / 가 포함될 수 있음 — 제거
    sql = new_ddl.rstrip().rstrip('/').rstrip()
    try:
        cur.execute(sql)
        print('  RECOMPILE OK')
    except Exception as e:
        print(f'  ❌ RECOMPILE FAIL: {e}')
        sys.exit(1)

# Step 4 — VALID 확인
print('\n[ STEP 4 ] PKG_SYS0013 STATUS:')
cur.execute("SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SYS0013'")
for r in cur.fetchall():
    print(f'  {r}')

# Step 5 — 직접 호출 검증
print('\n[ STEP 5 ] P_SYS0013_GET_PARAMETERS 호출 검증 (DQ_ID=7):')
rc1 = conn.cursor()
result_cursor = conn.cursor()
cur.callproc('SCM_MGR.PKG_SYS0013.P_SYS0013_GET_PARAMETERS', ['7', rc1, result_cursor])
cols = [d[0] for d in rc1.description or []]
print(f'  cols: {cols}')
if 'DEFAULT_VALUE' in cols:
    print('  ✅ DEFAULT_VALUE alias 반환 확인')
else:
    print('  ❌ DEFAULT_VALUE 컬럼 부재')
    sys.exit(1)
for r in rc1.fetchmany(3):
    print(f'  {r}')

conn.close()
print('\n[ done ] SP body alias 추가 완료.')
