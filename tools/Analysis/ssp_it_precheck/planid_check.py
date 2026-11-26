# -*- coding: utf-8 -*-
"""일 계획 ID(SCM_MST_PLAN DAILY) 점검 쿼리 — 클라우드에서 실행할 조회 쿼리 생성 + 사내 ZIOUI1 실행 시험(읽기 전용)
  python -u planid_check.py <시험일 YYYYMMDD> <출력 .sql>
근거(PR_SCM_MST_PLAN 원문 · ZIOUI1 2026-11-25) :
  - 월요일 외 = 전일 행 복사(일자 +1 · PLAN_ID +1). 전일 행이 없으면 0건
  - 월요일   = 전주 월요일 DAILY 행 복사(일자 +7), PLAN_ID = (전주 WEEKLY ID + 1) || '01'. 전주 WEEKLY 행 · 전주 월요일 DAILY 행 필요
  - 월요일 처리 여부 = 넘긴 일자가 「실행 시각(SYSDATE)이 속한 주의 월요일」과 같은지로 판단
  - 넘긴 일자가 실행일보다 뒤면 실행일로 처리"""
import sys, os, io, time, datetime
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dbconn
import dbeaver as D

T = sys.argv[1]; OUT = sys.argv[2]
P = f"WITH PRM AS (SELECT '{T}' AS P_TEST_DATE FROM DUAL)   /* 시험일. 이 줄의 값만 바꿔 실행 */\n"
Q = [
 ('C1', 'DB 현재 시각 · 요일 · 이번 주 월요일', '프로그램은 DB 시각(SYSDATE) 기준으로 동작. TODAY 가 시험일과 같은지, THIS_MONDAY 가 무엇인지 확인',
  P + """SELECT SYSDATE AS DB_NOW
     , TO_CHAR(SYSDATE, 'YYYYMMDD') AS TODAY
     , TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=AMERICAN') AS TODAY_DAY
     , TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD') AS THIS_MONDAY              /* 프로그램이 월요일 처리 여부를 정하는 기준 */
     , TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 14, 'YYYYMMDD') AS LAST_MONDAY             /* 월요일 생성 때 복사하는 전주 월요일 */
     , PRM.P_TEST_DATE AS TEST_DATE
     , SESSIONTIMEZONE AS SESSION_TZ
     , DBTIMEZONE AS DB_TZ
  FROM PRM"""),
 ('C2', '관련 프로그램 상태', '4개 모두 VALID. INVALID 면 재컴파일 후 진행',
  """SELECT OBJECT_NAME
     , OBJECT_TYPE
     , STATUS
     , LAST_DDL_TIME
  FROM ALL_OBJECTS
 WHERE OWNER = 'SCM_MGR'
   AND OBJECT_NAME IN ('PR_SCM_MST_PLAN', 'FN_NEXT_DAY', 'PR_SCM_SYS_LOG_BATCH', 'PR_SSP_ANL_SHIP_PLAN_40')
 ORDER BY OBJECT_NAME"""),
 ('C3', '사업부별 일 계획 ID 마지막 일자', 'LAST_PLAN_NAME 이 언제까지인지, 사업부마다 같은지. GAP_DAYS = 시험일까지 만들어야 할 일수',
  P + """SELECT M.DIVISION_ID
     , MAX(M.PLAN_NAME) AS LAST_PLAN_NAME
     , MAX(M.PLAN_ID) KEEP (DENSE_RANK LAST ORDER BY M.PLAN_NAME) AS LAST_PLAN_ID
     , MAX(M.HORIZON_START_DATE) KEEP (DENSE_RANK LAST ORDER BY M.PLAN_NAME) AS LAST_HORIZON_START
     , MAX(M.HORIZON_END_DATE) KEEP (DENSE_RANK LAST ORDER BY M.PLAN_NAME) AS LAST_HORIZON_END
     , TO_DATE(MAX(PRM.P_TEST_DATE), 'YYYYMMDD') - TO_DATE(MAX(M.PLAN_NAME), 'YYYYMMDD') AS GAP_DAYS
     , COUNT(*) AS ROW_CNT
  FROM SCM_MST_PLAN M
     , PRM
 WHERE M.PLAN_CYCLE = 'DAILY'
 GROUP BY M.DIVISION_ID
 ORDER BY M.DIVISION_ID"""),
 ('C4', '일자별 일 계획 ID 현황(시험일 21일 전부터)', '일자마다 사업부 수 · PLAN_ID 범위. 중간에 빠진 일자, 월요일 ID(끝 두 자리 01) 확인',
  P + """SELECT M.PLAN_NAME
     , TO_CHAR(TO_DATE(M.PLAN_NAME, 'YYYYMMDD'), 'DY', 'NLS_DATE_LANGUAGE=AMERICAN') AS DAY_NAME
     , COUNT(*) AS DIVISION_CNT
     , MIN(M.PLAN_ID) AS MIN_PLAN_ID
     , MAX(M.PLAN_ID) AS MAX_PLAN_ID
     , MIN(M.HORIZON_START_DATE) AS HORIZON_START
     , MAX(M.HORIZON_END_DATE) AS HORIZON_END
     , MAX(M.CREATION_DATE) AS CREATION_DATE
     , MAX(M.CREATED_BY) AS CREATED_BY
  FROM SCM_MST_PLAN M
     , PRM
 WHERE M.PLAN_CYCLE = 'DAILY'
   AND M.PLAN_NAME >= TO_CHAR(TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') - 21, 'YYYYMMDD')
 GROUP BY M.PLAN_NAME
 ORDER BY M.PLAN_NAME"""),
 ('C5', '빠진 일자 · 사업부(시험일 21일 전 ~ 시험일)', '행이 나오는 일자 · 사업부가 만들어야 할 대상. 0행이면 시험일까지 모두 있음',
  P + """SELECT C.YYYYMMDD
     , TO_CHAR(TO_DATE(C.YYYYMMDD, 'YYYYMMDD'), 'DY', 'NLS_DATE_LANGUAGE=AMERICAN') AS DAY_NAME
     , COUNT(*) AS MISSING_DIVISION_CNT
     , LISTAGG(V.DIVISION_ID, ', ') WITHIN GROUP (ORDER BY V.DIVISION_ID) AS MISSING_DIVISIONS
  FROM (SELECT TO_CHAR(TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') - 21 + LEVEL - 1, 'YYYYMMDD') AS YYYYMMDD
          FROM PRM
       CONNECT BY LEVEL <= 22) C
     , (SELECT DISTINCT DIVISION_ID
          FROM SCM_MST_DIVISION) V
 WHERE NOT EXISTS (SELECT 1
                     FROM SCM_MST_PLAN M
                    WHERE M.PLAN_CYCLE = 'DAILY'
                      AND M.DIVISION_ID = V.DIVISION_ID
                      AND M.PLAN_NAME = C.YYYYMMDD)
 GROUP BY C.YYYYMMDD
 ORDER BY C.YYYYMMDD"""),
 ('C6', '주 계획 ID(WEEKLY) 현황(시험일 35일 전부터)', '월요일 일 계획 ID 는 전주 WEEKLY ID + 1 로 만듦. 전주 · 이번 주 월요일 WEEKLY 행이 있는지 확인',
  P + """SELECT M.PLAN_NAME
     , COUNT(*) AS DIVISION_CNT
     , MIN(M.PLAN_ID) AS MIN_PLAN_ID
     , MAX(M.PLAN_ID) AS MAX_PLAN_ID
     , MAX(M.CREATION_DATE) AS CREATION_DATE
  FROM SCM_MST_PLAN M
     , PRM
 WHERE M.PLAN_CYCLE = 'WEEKLY'
   AND M.PLAN_NAME >= TO_CHAR(TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') - 35, 'YYYYMMDD')
 GROUP BY M.PLAN_NAME
 ORDER BY M.PLAN_NAME"""),
 ('C7', '사업부 기준정보 대비 일 · 주 계획 ID 보유', '기준정보에 있는데 DAILY_CNT 가 0 인 사업부는 복사할 전일 행이 없어 만들어지지 않음',
  """SELECT V.DIVISION_ID
     , (SELECT COUNT(*)
          FROM SCM_MST_PLAN M
         WHERE M.DIVISION_ID = V.DIVISION_ID
           AND M.PLAN_CYCLE = 'DAILY') AS DAILY_CNT
     , (SELECT MAX(M.PLAN_NAME)
          FROM SCM_MST_PLAN M
         WHERE M.DIVISION_ID = V.DIVISION_ID
           AND M.PLAN_CYCLE = 'DAILY') AS DAILY_LAST
     , (SELECT COUNT(*)
          FROM SCM_MST_PLAN M
         WHERE M.DIVISION_ID = V.DIVISION_ID
           AND M.PLAN_CYCLE = 'WEEKLY') AS WEEKLY_CNT
     , (SELECT MAX(M.PLAN_NAME)
          FROM SCM_MST_PLAN M
         WHERE M.DIVISION_ID = V.DIVISION_ID
           AND M.PLAN_CYCLE = 'WEEKLY') AS WEEKLY_LAST
  FROM (SELECT DISTINCT DIVISION_ID
          FROM SCM_MST_DIVISION) V
 ORDER BY V.DIVISION_ID"""),
 ('C8', '중복 행(같은 사업부 · 같은 일자, 시험일 60일 전부터)', '0행이어야 함. 행이 있으면 생성 전에 정리 방법을 정해야 함',
  P + """SELECT M.DIVISION_ID
     , M.PLAN_CYCLE
     , M.PLAN_NAME
     , COUNT(*) AS ROW_CNT
     , MIN(M.PLAN_ID) AS MIN_PLAN_ID
     , MAX(M.PLAN_ID) AS MAX_PLAN_ID
  FROM SCM_MST_PLAN M
     , PRM
 WHERE M.PLAN_NAME >= TO_CHAR(TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') - 60, 'YYYYMMDD')
 GROUP BY M.DIVISION_ID
        , M.PLAN_CYCLE
        , M.PLAN_NAME
HAVING COUNT(*) > 1
 ORDER BY M.PLAN_NAME
        , M.DIVISION_ID"""),
 ('C9', '일 계획 ID 생성 프로그램 최근 실행 로그(최근 30행)', '마지막으로 언제 실행됐는지, ERROR 행이 있는지. 0행이면 이 DB 에서 실행된 적이 없고 자료 이관으로 들어온 행',
  P + """SELECT L.LOG_TYPE
     , SUBSTR(L.LOG_MESSAGE, 1, 150) AS LOG_MESSAGE
     , SUBSTR(L.DESCRIPTION, 1, 150) AS DESCRIPTION
     , L.SQL_ERR_CODE
     , L.EVENT_DATE
  FROM SCM_SYS_LOG_BATCH L
     , PRM
 WHERE L.PROGRAM_NAME = 'PR_SCM_MST_PLAN'
   AND L.EVENT_DATE <= TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') + 1
 ORDER BY L.EVENT_DATE DESC
 FETCH FIRST 30 ROWS ONLY"""),
]
BAR = '-- ' + '=' * 110
L = [BAR, f'-- 일 계획 ID(SCM_MST_PLAN, DAILY) 점검 쿼리 · Oracle · 시험일 {T}', '-- 목적 : 클라우드에 일 계획 ID 가 언제까지 만들어져 있는지 확인하고, 시험일까지 만드는 실행 쿼리를 정하기 위한 조회',
     '-- 실행 : DBeaver 에서 쿼리 하나씩(커서를 쿼리 안에 두고 Ctrl+Enter). 조회만 수행', '-- 결과 9개를 모두 보내 주면 그 값으로 실행 쿼리를 만듦(C1 · C3 · C4 · C5 · C6 이 실행 쿼리를 정하는 값)',
     f'-- 생성 {datetime.datetime.now():%Y-%m-%d %H:%M} · tools/Analysis/ssp_it_precheck/planid_check.py', BAR, '']
con = dbconn.connect('tobe'); cur = con.cursor()
cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('ZIOUI1', cur.fetchone()[0])
ng = 0
for i, what, point, sql in Q:
    bad = D.lint(sql); t0 = time.time()
    try:
        cur.execute(sql); rows = cur.fetchmany(200); print(f'{i} OK {time.time() - t0:4.1f}s rows={len(rows)} 금지 형태 {bad} | {what}')
        for r in rows[:26]: print('     ', ' | '.join('' if v is None else str(v)[:40] for v in r))
    except Exception as e:
        ng += 1; print(f'{i} ERR | {str(e)[:260]}')
    L += [BAR, f'-- [{i}] {what}', f'-- 확인 : {point}', BAR, sql + ';', '']
con.close()
io.open(OUT, 'w', encoding='utf-8', newline='\r\n').write('\n'.join(L)); print('저장', OUT, '· 오류', ng)
