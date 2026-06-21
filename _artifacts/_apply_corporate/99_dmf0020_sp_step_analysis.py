"""DMF0020 SP `DMF0020_GET_SCM_MST_FUTURE_PRICE` 단위별 GTT row count 측정.

사용자 명시 (2026-06-21): 데이터 조회 안 됨. SP 단위별 끊어서 정밀 분석 요구.

방법:
  - 같은 session 에서 callproc 호출 후 GTT (ON COMMIT PRESERVE ROWS) row count SELECT.
  - SP body 의 11 단계 GTT 적재 위치 측정.
  - 0 으로 떨어지는 단계 = root cause.

Anti-Simplification:
  - 단위별 모두 측정 (단순 grep / 표본 금지)
  - row count 0 시 그 단계의 WHERE/JOIN 분기 정밀 추적
"""
from __future__ import annotations
import os, sys, time
import oracledb

sys.stdout.reconfigure(line_buffering=True)
u = os.getenv('NSCM_ORA_USER'); p = os.getenv('NSCM_ORA_PASS'); d = os.getenv('NSCM_ORA_DSN')
assert u and p and d
conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}')

# SP 호출 (사용자 화면 정확 payload — 4 키 신규 포함)
print('\n[ STEP 1 ] callproc — minyonglee1 div=40 90일 CURRENT:')
rc1 = conn.cursor(); rcr = conn.cursor()
start = time.time()
try:
    cur.callproc('SCM_MGR.DMF0020_GET_SCM_MST_FUTURE_PRICE', [
        '40',           # 1 divisionId
        'ALL',          # 2 deptId
        'ALL',          # 3 endCustomer
        'ALL',          # 4 scmSiteId
        'ALL',          # 5 plantSiteId
        'ALL',          # 6 projectCode
        'ALL',          # 7 itemId
        'ALL',          # 8 customerProjectCode
        'ALL',          # 9 customerModel
        '20260621',     # 10 fromYyyymmdd
        '20260919',     # 11 toYyyymmdd
        'ALL',          # 12 biztype
        'minyonglee1',  # 13 sesUserId (P_CREATED_BY)
        'minyonglee1',  # 14 userInfo (P_USERINFO)
        'ALL',          # 15 owner
        'N',            # 16 overRange
        'N',            # 17 invalidExec
        'CURRENT',      # 18 versionType
        rc1, rcr])
    elapsed = time.time() - start
    rows = rc1.fetchall()  # 전체 카운트
    print(f'  TIME: {elapsed:.2f}s')
    print(f'  o_rc1 ROW COUNT: {len(rows)}')
except Exception as e:
    elapsed = time.time() - start
    print(f'  ❌ ERROR: {str(e)[:200]}  TIME: {elapsed:.2f}s')
    sys.exit(1)

# 같은 session 에서 GTT row count (ON COMMIT PRESERVE ROWS)
print('\n[ STEP 2 ] GTT 단위별 row count (같은 session 내 측정):')
gtts = [
    ('GT_FTPR_SCM_MST_FUTURE_PRICE_OVER', 'L213/225 OVER_RANGE 분기'),
    ('GT_FTPR_DM_PLN_SALES_PLAN',          'L248 CURRENT 분기 SALES_PLAN'),
    ('GT_FTPR_SCM_MST_FUTURE_PRICE',       'L285 CURRENT 분기 FUTURE_PRICE'),
    ('GT_FTPR_TMPOVERRANGE',               'L497 OVER_RANGE 추가'),
    ('GT_FTPR_TMPOVERRANGELIST',           'L573 OVER_RANGE 컬럼 list'),
    ('GT_FTPR_DM_MST_ITEM_SINGLE_ORI_V',   'L587 ITEM_SN 사전 적재'),
    ('GT_FTPR_TMPITEM',                    'L595/608 ITEM dim'),
    ('GT_FTPR_TMPPLANDATA',                'L626 Plan+Price UNION'),
    ('GT_FTPR_TMPDATA',                    'L650 dim 적재 (메인 dim)'),
    ('GT_FTPR_TMPOUTPUTALL',               'L760/814 dim+price JOIN'),
    ('GT_FTPR_TMPOUTPUTOMISSION',          'L867 누락 row'),
    ('GT_FTPR_TMPOUTPUT',                  'L906/983 최종 결과 (rc1 source)'),
    ('GT_FTPR_TMPSALESSITEMODELALL',       'L1017 보조 dim ALL'),
    ('GT_FTPR_TMPSALESSITEMODEL',          'L1080 보조 dim'),
]
results = {}
for tbl, desc in gtts:
    try:
        cur.execute(f'SELECT COUNT(*) FROM SCM_MGR.{tbl}')
        cnt = cur.fetchone()[0]
        results[tbl] = cnt
        marker = '🔴' if cnt == 0 else '✅' if cnt > 0 else '⚪'
        print(f'  {marker} {tbl:<38} = {cnt:>10}   ({desc})')
    except Exception as e:
        print(f'  ❌ {tbl:<38} ERROR: {str(e)[:60]}')

# 0 으로 떨어지는 단계 강조
zero_steps = [t for t, c in results.items() if c == 0]
print(f'\n[ STEP 3 ] 0 으로 떨어지는 단계 ({len(zero_steps)}):')
for t in zero_steps: print(f'  - {t}')

# 최종 rc1 cursor 결과 = GT_FTPR_TMPOUTPUT 의 row count 와 일치 여부
print(f'\n[ STEP 4 ] 일치 검증:')
print(f'  o_rc1 rows = {len(rows)}')
print(f'  GT_FTPR_TMPOUTPUT count = {results.get("GT_FTPR_TMPOUTPUT", "?")}')
print(f'  (rc1 = TMPOUTPUT 이어야 정상)')

conn.close()
print('\n[ done ]')
