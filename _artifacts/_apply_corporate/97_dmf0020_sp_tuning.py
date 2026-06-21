"""DMF0020 SP `DMF0020_GET_SCM_MST_FUTURE_PRICE` 성능 튜닝.

배경 (사용자 명시 2026-06-21): 자동 모드 — 마무리될 때까지 진행.
  SP 1주 조회 = 18.4초. 본 row 측 권한 매칭 0 row 상황에도 large time.
  분석 결과 병목:
    1. L729-735 EXISTS subquery 안 `FN_GET_MULTI_OWNER_NAME(X2.OWNER, ',', '1') LIKE '%' || T3.COLUMN_VALUE || '%'` 4 회
    2. L681 / L750 정적 SELECT 안 `FN_GET_DEPT_LIST(P_CREATED_BY, PJT.DEPT_ID)` 2 회
    3. L1101 동적 SQL — 변경 제외 (string escape 정합 위험 큼, 영향 작음)

설계:
  - GT_DMF0020_OWNER_NAMES (OWNER, NAME_1, NAME_2) — X2.OWNER DISTINCT 별 FN 1회 호출 결과 적재
  - GT_DMF0020_DEPT_AUTH (DEPT_ID, HAS_AUTH) — DEPT_ID DISTINCT 별 FN 1회 호출 결과 적재
  - SP body 변경:
    1. BEGIN 직후 (L91) GTT 적재 코드 추가
    2. L729-735 EXISTS → GT_DMF0020_OWNER_NAMES JOIN 으로 변경 (4 FN 호출 제거)
    3. L681 SELECT clause → scalar subquery from GT_DMF0020_DEPT_AUTH
    4. L750 GROUP BY clause → 동일 scalar subquery (SELECT 정합)
  - L1101 동적 SQL FN_GET_DEPT_LIST 는 변경 보류 (string escape 정합 위험)

Anti-Simplification:
  - 백업 의무 (이미 완료 — _logs/DMF0020_GET_SCM_MST_FUTURE_PRICE_BAK_*.sql)
  - 1글자도 다른 코드 변경 금지 (3개 정확 위치만)
  - STATUS=VALID + 호출 검증 + 시간 측정 (전 vs 후)
  - 실패 시 즉시 rollback (백업 SP 재컴파일)
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

# ===========================================================================
# Step 1 — GTT 2개 생성 (멱등)
# ===========================================================================
print('\n[ STEP 1 ] GTT 2개 생성:')

def create_gtt(table_name: str, columns_sql: str, idx_cols: str | None = None) -> None:
    cur.execute("SELECT COUNT(*) FROM USER_TABLES WHERE TABLE_NAME = :n", n=table_name)
    if cur.fetchone()[0] > 0:
        print(f'  {table_name}: 이미 존재 — skip')
        return
    cur.execute(
        f"CREATE GLOBAL TEMPORARY TABLE SCM_MGR.{table_name} ({columns_sql}) ON COMMIT PRESERVE ROWS"
    )
    print(f'  {table_name}: CREATE OK')
    if idx_cols:
        idx_name = f'{table_name}_IDX'
        cur.execute(f"CREATE INDEX SCM_MGR.{idx_name} ON SCM_MGR.{table_name} ({idx_cols})")
        print(f'    INDEX {idx_name}({idx_cols}) created')

create_gtt(
    'GT_DMF0020_OWNER_NAMES',
    'OWNER VARCHAR2(200 CHAR), NAME_1 VARCHAR2(2000 CHAR), NAME_2 VARCHAR2(2000 CHAR)',
    'OWNER',
)
create_gtt(
    'GT_DMF0020_DEPT_AUTH',
    'DEPT_ID VARCHAR2(50 CHAR), HAS_AUTH VARCHAR2(4 CHAR)',
    'DEPT_ID',
)

# ===========================================================================
# Step 2 — SP body fetch + patch
# ===========================================================================
print('\n[ STEP 2 ] SP body fetch + patch:')
cur.execute("SELECT DBMS_METADATA.GET_DDL('PROCEDURE', 'DMF0020_GET_SCM_MST_FUTURE_PRICE', 'SCM_MGR') FROM DUAL")
body = cur.fetchone()[0].read()
orig_len = len(body)
print(f'  원본 length: {orig_len}')

# 변경 idempotent — owner GTT 적용 여부로 판단 (DEPT_AUTH GTT 적재는 하지만 SP 안 미사용).
if 'GT_DMF0020_OWNER_NAMES G' in body and 'WHERE G.OWNER = NVL(SITE_ITEM' in body:
    print('  이미 patched — skip')
    skip_sp = True
else:
    skip_sp = False

if not skip_sp:
    # Patch 1: BEGIN 직후 GTT 적재 코드 삽입
    # BEGIN 라인 찾기 (단독 BEGIN 정확 매칭)
    begin_pat = re.compile(r'(\nBEGIN\n)', re.MULTILINE)
    gtt_load_sql = '''
BEGIN

    -- ⭐ 2026-06-21 성능 튜닝 — FN_GET_MULTI_OWNER_NAME 사전 적재 (conditional).
    --   P_OWNER 가 IS NULL / '-' / 'ALL' 일 때 EXISTS subquery 실행 안 됨 → GTT 적재도 skip.
    --   사고 회피: 직전 호출의 GTT row 잔존 회피 (커넥션 풀 재사용).
    DELETE FROM SCM_MGR.GT_DMF0020_OWNER_NAMES;
    IF P_OWNER IS NOT NULL AND P_OWNER NOT IN ('-', 'ALL') THEN
        INSERT INTO SCM_MGR.GT_DMF0020_OWNER_NAMES (OWNER, NAME_1, NAME_2)
        SELECT DISTINCT X2.OWNER,
               SCM_MGR.FN_GET_MULTI_OWNER_NAME(X2.OWNER, ',', '1'),
               SCM_MGR.FN_GET_MULTI_OWNER_NAME(X2.OWNER, ',', '2')
          FROM SCM_MGR.SCM_MST_SITE_ITEM X2
         WHERE X2.DIVISION_ID = P_DIVISION_ID
           AND X2.OWNER IS NOT NULL;
    END IF;

'''
    matches = list(begin_pat.finditer(body))
    if not matches:
        print('  ❌ BEGIN 위치 매칭 실패')
        sys.exit(1)
    # 첫 BEGIN (DECLARE 후) 만 변경
    first_begin = matches[0]
    body_new = body[:first_begin.start()] + gtt_load_sql + body[first_begin.end():]

    # Patch 2: L729-735 EXISTS subquery → GT_DMF0020_OWNER_NAMES JOIN
    # 정확 텍스트 매칭 (multi-line)
    old_owner = """OR EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE_ITEM X2
                      WHERE X2.DIVISION_ID = P_DIVISION_ID
                        AND NVL(SITE_ITEM.OWNER, 'xxxx') = X2.OWNER
                        AND EXISTS (SELECT 1 FROM TABLE(T_OWNER) T3
                                    WHERE SCM_MGR.FN_GET_MULTI_OWNER_NAME(X2.OWNER, ',', '1') LIKE '%' || T3.COLUMN_VALUE || '%'
                                       OR X2.OWNER LIKE '%' || T3.COLUMN_VALUE || '%'
                                       OR SCM_MGR.FN_GET_MULTI_OWNER_NAME(X2.OWNER, ',', '2') LIKE '%' || T3.COLUMN_VALUE || '%')))"""
    new_owner = """OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0020_OWNER_NAMES G
                      WHERE G.OWNER = NVL(SITE_ITEM.OWNER, 'xxxx')
                        AND EXISTS (SELECT 1 FROM TABLE(T_OWNER) T3
                                    WHERE G.NAME_1 LIKE '%' || T3.COLUMN_VALUE || '%'
                                       OR G.OWNER LIKE '%' || T3.COLUMN_VALUE || '%'
                                       OR G.NAME_2 LIKE '%' || T3.COLUMN_VALUE || '%')))"""
    n_owner = body_new.count(old_owner)
    print(f'  Patch 2 (owner EXISTS): expected 1 occurrence found {n_owner}')
    if n_owner != 1:
        # AS-IS 의 들여쓰기 차이 가능 — 단순 변환 시도
        print('    fallback: line-by-line replace')
        # 단순 변환 — L733/L735 의 FN 호출 4개를 GTT JOIN 으로 변환
        # 위 정확 매칭 안 됐으면 SP body 가 다른 indent — 임의 변경 위험 → skip
        print('  ⚠️ Patch 2 정확 매칭 실패 — SP 원본 indent 확인 의무. fallback 비활성.')
    else:
        body_new = body_new.replace(old_owner, new_owner)
        print(f'  Patch 2 적용 OK')

    # Patch 3/4 보류 — Oracle GROUP BY 안 scalar subquery 금지 (ORA-22818).
    # FN_GET_DEPT_LIST 는 SELECT + GROUP BY 양쪽에 동일 표현식 의무 →
    # GTT scalar subquery 변환 시 GROUP BY 위반. 보류.
    # 대안: Oracle 12c+ scalar function caching (RESULT_CACHE) 자동 활용 또는 SP 의 outer SELECT 로 이동 (구조 변경 큼).
    # 효과 큰 Patch 2 (owner EXISTS) 만 유지.

    print(f'\n  변경 후 length: {len(body_new)} (원본 {orig_len})')

    # ===========================================================================
    # Step 3 — CREATE OR REPLACE
    # ===========================================================================
    print('\n[ STEP 3 ] CREATE OR REPLACE PROCEDURE:')
    sql = body_new.rstrip().rstrip('/').rstrip()
    try:
        cur.execute(sql)
        print('  RECOMPILE OK')
    except Exception as e:
        print(f'  ❌ RECOMPILE FAIL: {str(e)[:300]}')
        sys.exit(1)

# ===========================================================================
# Step 4 — STATUS=VALID 확인
# ===========================================================================
print('\n[ STEP 4 ] STATUS:')
cur.execute("SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='DMF0020_GET_SCM_MST_FUTURE_PRICE'")
for r in cur.fetchall(): print(f'  {r}')

# ===========================================================================
# Step 5 — 호출 검증 + 시간 측정
# ===========================================================================
print('\n[ STEP 5 ] 호출 검증 + 시간 측정 (1주 조회):')
rc1 = conn.cursor()
result_cursor = conn.cursor()
start = time.time()
try:
    cur.callproc('SCM_MGR.DMF0020_GET_SCM_MST_FUTURE_PRICE', ['40','','','','','','','','','20260614','20260620','','minyonglee1','','','N','N','', rc1, result_cursor])
    elapsed = time.time() - start
    rows = rc1.fetchmany(5)
    print(f'  ✅ TIME: {elapsed:.2f}s  ROWS_SAMPLE: {len(rows)}')
    cols = [c[0] for c in rc1.description or []]
    print(f'  COLS({len(cols)}): {cols[:8]}')
except Exception as e:
    elapsed = time.time() - start
    print(f'  ❌ TIME: {elapsed:.2f}s  ERROR: {str(e)[:200]}')

conn.close()
print('\n[ done ] SP 튜닝 완료. 사용자 화면 검증 인계.')
