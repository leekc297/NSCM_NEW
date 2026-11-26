# -*- coding: utf-8 -*-
"""LOOKUP 테이블의 모듈 구분 확인 — SCM_ADM_LOOKUP_MASTER.LOOKUP_GROUP 분포 · SSP 그룹 목록 · 상세 건수(읽기 전용)"""
import sys, collections
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
t = dbconn.connect('tobe'); tc = t.cursor(); a = dbconn.connect('asis'); a.timeout = 120; ac = a.cursor()
tc.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('TO-BE ZIOUI1', tc.fetchone()[0])
tc.execute("SELECT LOOKUP_GROUP, COUNT(*), SUM(CASE WHEN VALID_YN = 'Y' THEN 1 ELSE 0 END) FROM SCM_ADM_LOOKUP_MASTER GROUP BY LOOKUP_GROUP ORDER BY 1"); og = {r[0]: r[1:] for r in tc.fetchall()}
ac.execute("SELECT LOOKUP_GROUP, COUNT(*), SUM(CASE WHEN VALID_YN = 'Y' THEN 1 ELSE 0 END) FROM dbo.SCM_ADM_LOOKUP_MASTER WITH (NOLOCK) GROUP BY LOOKUP_GROUP ORDER BY 1"); mg = {r[0]: tuple(r[1:]) for r in ac.fetchall()}
print('LOOKUP_GROUP | TO-BE 유형 수(사용) | AS-IS 유형 수(사용)')
for g in sorted(set(og) | set(mg), key=str): print(f'  {g!s:28s} | {og.get(g, ("-", "-"))} | {mg.get(g, ("-", "-"))}')
# 마스터 다른 열에 모듈 표시가 있는지
tc.execute("SELECT COUNT(DISTINCT SEGMENT1), COUNT(DISTINCT SEGMENT2), COUNT(DISTINCT ATTRIBUTE1), COUNT(DISTINCT ATTRIBUTE2), MIN(SEGMENT1), MAX(SEGMENT1) FROM SCM_ADM_LOOKUP_MASTER"); print('마스터 SEGMENT1 · 2 · ATTRIBUTE1 · 2 값 종류', tc.fetchone())
tc.execute("SELECT LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SUBSTR(DESCRIPTION, 1, 50) FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_GROUP LIKE '%SSP%' AND ROWNUM <= 5"); print('SSP 그룹 예', tc.fetchall())
# SSP 그룹 유형 · 상세 건수 양쪽
tc.execute("""SELECT M.LOOKUP_GROUP, M.LOOKUP_TYPE, M.VALID_YN, (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL D WHERE D.LOOKUP_TYPE = M.LOOKUP_TYPE) FROM SCM_ADM_LOOKUP_MASTER M WHERE UPPER(M.LOOKUP_GROUP) LIKE '%SSP%' ORDER BY 2"""); o = {r[1]: r for r in tc.fetchall()}
ac.execute("""SELECT M.LOOKUP_GROUP, M.LOOKUP_TYPE, M.VALID_YN, (SELECT COUNT(*) FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL D WITH (NOLOCK) WHERE D.LOOKUP_TYPE = M.LOOKUP_TYPE) FROM dbo.SCM_ADM_LOOKUP_MASTER M WITH (NOLOCK) WHERE UPPER(M.LOOKUP_GROUP) LIKE '%SSP%' ORDER BY 2"""); m = {r[1]: tuple(r) for r in ac.fetchall()}
print(f'SSP 그룹 유형 : TO-BE {len(o)} · AS-IS {len(m)} · 양쪽 {len(set(o) & set(m))} · TO-BE 에만 {sorted(set(o) - set(m))[:20]} · AS-IS 에만 {sorted(set(m) - set(o))[:20]}')
print('  상세 건수 합 TO-BE', sum(r[3] for r in o.values()), '· AS-IS', sum(r[3] for r in m.values()), '· 건수 다른 유형', sum(1 for k in set(o) & set(m) if o[k][3] != m[k][3]))
# SSP 프로그램이 읽지만 그룹이 SSP 가 아닌 유형이 있는지(앞에서 본 것)
for ty in ('IF_STOCK_CHECK', 'COMPANY_DESC', 'BASIS_START_TIME_PLANT', 'SSP_ANL_SHIP_PLAN_P', 'SSP_ANL_SHIP_PLAN_ALL', 'FUNCTION_BLOCK'):
    tc.execute("SELECT LOOKUP_GROUP FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = :t", t=ty); x = tc.fetchone()
    ac.execute("SELECT LOOKUP_GROUP FROM dbo.SCM_ADM_LOOKUP_MASTER WITH (NOLOCK) WHERE LOOKUP_TYPE = ?", ty); y = ac.fetchone()
    print(f'  {ty:26s} 그룹 TO-BE {x[0] if x else "마스터 없음"} · AS-IS {y[0] if y else "마스터 없음"}')
# 상세에는 있는데 마스터에 없는 유형
tc.execute("SELECT COUNT(DISTINCT D.LOOKUP_TYPE) FROM SCM_ADM_LOOKUP_MASTER_DETAIL D WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_TYPE = D.LOOKUP_TYPE)"); print('TO-BE 상세에만 있는 유형 수(마스터 없음)', tc.fetchone()[0])
# SCM_CODE_LOOKUP_VALUE 쪽
tc.execute("SELECT COUNT(DISTINCT LOOKUP_TYPE_CODE), SUM(CASE WHEN LOOKUP_TYPE_CODE LIKE '%SSP%' THEN 1 ELSE 0 END), COUNT(*) FROM SCM_CODE_LOOKUP_VALUE"); print('SCM_CODE_LOOKUP_VALUE 유형 수 · SSP 이름 행 · 전체 행', tc.fetchone())
t.close(); a.close()
