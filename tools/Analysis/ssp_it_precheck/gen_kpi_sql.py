# -*- coding: utf-8 -*-
"""SSP KPI 배치 실행 쿼리 파일 생성(Oracle, 클라우드 실행용) · 일별 PR_SSP_KPI_BR_BOD_REGISTRATION · 주별 PR_SSP_KPI_SHIPMENT_PSI_DW
  python gen_kpi_sql.py <실행일 YYYYMMDD> <출력 .sql> [--check]
  실행 블록 = 사내 ZIOUI1 JOB_ACTION 을 실행 때 새로 읽어 씀. 일별은 같은 날 두 번 넣지 않도록 실행 전 확인을 덧붙임(원문 = INSERT 만, 삭제 · PK 없음)
  --check : 조회 문장은 ZIOUI1 에서 실행, PL/SQL 블록은 DBMS_SQL.PARSE 로 컴파일만(실행하지 않음)"""
import sys, io, re, datetime
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn

DAY, OUT = sys.argv[1], sys.argv[2]
LINE = '-- ' + '=' * 110
JB, JP = 'JOB_PR_SSP_KPI_BR_BOD_REGISTRATION', 'JOB_PR_SSP_KPI_SHIPMENT_PSI_DW'
t = dbconn.connect('tobe'); c = t.cursor()
c.execute("SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); at = c.fetchone()[0]
act, ddl = {}, {}
for j in (JB, JP):
    c.execute("SELECT job_action FROM all_scheduler_jobs WHERE owner = 'SCM_MGR' AND job_name = :j", j=j)
    a = c.fetchone()[0]; act[j] = (a.read() if hasattr(a, 'read') else a).strip()
for p in ('PR_SSP_KPI_BR_BOD_REGISTRATION', 'PR_SSP_KPI_SHIPMENT_PSI_DW'):
    c.execute("SELECT TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') || ' ' || status FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = :p AND object_type = 'PROCEDURE'", p=p)
    ddl[p] = c.fetchone()[0]
wd = datetime.datetime.strptime(DAY, '%Y%m%d').strftime('%a').upper()

PRM = "WITH PRM AS (SELECT '%s' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */" % DAY
S = []  # (key, title, notes, sql, plsql)
S.append(('K0', 'KPI 테이블 실행일 건수 · 마지막 집계일', ['확인 : BR_DAY_CNT = 0 이어야 [R1] 실행(1 이상이면 실행일 행이 이미 있음). PSI_DAY_CNT 는 0 이 아니어도 [R2] 가 지우고 다시 넣음'],
          PRM + """
SELECT (SELECT COUNT(*) FROM SSP_KPI_BR_BOD_REGISTRATION B, PRM WHERE B.YYYYMMDD = PRM.P_DAY) AS BR_DAY_CNT
     , (SELECT MAX(B.YYYYMMDD) FROM SSP_KPI_BR_BOD_REGISTRATION B) AS BR_LAST_DAY
     , (SELECT COUNT(*) FROM SSP_KPI_SHIPMENT_PSI P, PRM WHERE P.SUM_YYYYMMDD = PRM.P_DAY) AS PSI_DAY_CNT
     , (SELECT MAX(P.SUM_YYYYMMDD) FROM SSP_KPI_SHIPMENT_PSI P) AS PSI_LAST_SUM_DAY
     , (SELECT C.ISO_YYYYWW FROM SCM_SYS_CALENDAR_M C, PRM WHERE C.BASIS_YYYYMMDD = PRM.P_DAY) AS DAY_ISO_YYYYWW
     , (SELECT TO_CHAR(TO_DATE(PRM.P_DAY, 'YYYYMMDD'), 'DY', 'NLS_DATE_LANGUAGE=AMERICAN') FROM PRM) AS DAY_OF_WEEK
  FROM DUAL""", False))
S.append(('K1', 'KPI JOB 상태 · 실행 중 JOB', ['확인 : ENABLED = TRUE 면 스케줄대로 자동 실행됨(일별 매일 07:10 · 주별 매주 월요일 06:00). RUNNING_SID 값이 있으면 실행 중이므로 같은 블록 실행하지 않음'],
          """SELECT J.JOB_NAME
     , J.ENABLED
     , J.STATE
     , J.REPEAT_INTERVAL
     , J.LAST_START_DATE
     , J.LAST_RUN_DURATION
     , J.NEXT_RUN_DATE
     , R.SESSION_ID AS RUNNING_SID
  FROM ALL_SCHEDULER_JOBS J
  LEFT JOIN ALL_SCHEDULER_RUNNING_JOBS R
    ON R.OWNER    = J.OWNER
   AND R.JOB_NAME = J.JOB_NAME
 WHERE J.OWNER = 'SCM_MGR'
   AND J.JOB_NAME IN ('%s', '%s')
 ORDER BY J.JOB_NAME""" % (JB, JP), False))
S.append(('K2', '주별 KPI 입력 자료(일마감 결과) 최근 일자', ['확인 : 주별 KPI 는 SSP_ANL_SHIP_PLAN_40 · SSP_ANL_SHIP_PLAN_C 를 읽음. 실행일 일마감이 끝난 뒤 [R2] 실행'],
          PRM + """
SELECT '40' AS SRC
     , MAX(A.PLAN_START_YYYYMMDD) AS LAST_PLAN_START
     , SUM(CASE WHEN A.PLAN_START_YYYYMMDD = PRM.P_DAY THEN 1 ELSE 0 END) AS DAY_ROWS
  FROM SSP_ANL_SHIP_PLAN_40 A
     , PRM
 WHERE A.PLAN_START_YYYYMMDD >= TO_CHAR(TO_DATE(PRM.P_DAY, 'YYYYMMDD') - 7, 'YYYYMMDD')
 UNION ALL
SELECT 'C'
     , MAX(A.PLAN_START_YYYYMMDD)
     , SUM(CASE WHEN A.PLAN_START_YYYYMMDD = PRM.P_DAY THEN 1 ELSE 0 END)
  FROM SSP_ANL_SHIP_PLAN_C A
     , PRM
 WHERE A.PLAN_START_YYYYMMDD >= TO_CHAR(TO_DATE(PRM.P_DAY, 'YYYYMMDD') - 7, 'YYYYMMDD')""", False))
br = act[JB]
br_guard = br.replace('BEGIN', """DECLARE
  N_CNT NUMBER;
BEGIN
  /* 실행 전 확인(원문에 없음) : 실행일 행이 이미 있으면 멈춤. 원문은 INSERT 만 하고 PK 가 없어 다시 실행하면 같은 행이 한 번 더 들어감 */
  SELECT COUNT(*) INTO N_CNT FROM SSP_KPI_BR_BOD_REGISTRATION WHERE YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');
  IF N_CNT > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'SSP_KPI_BR_BOD_REGISTRATION 실행일 행 ' || N_CNT || '건 있음. 다시 실행하지 않음');
  END IF;""", 1)
S.append(('R1', '일별 KPI 실행 : PR_SSP_KPI_BR_BOD_REGISTRATION(MKT Forecast 기준 물류 BOD 미등록 건수)',
          ['JOB : %s(운영 매일 07:10) · 집계일 = 실행 시각(SYSDATE) 일자' % JB, '실행 전 [K0] BR_DAY_CNT = 0 · 실행 뒤 [A1] · [L1]',
           '변경 문장. 프로그램 안에서 COMMIT 함. 하루 1회만'], br_guard, True))
S.append(('R2', '주별 KPI 실행 : PR_SSP_KPI_SHIPMENT_PSI_DW(출하 PSI 주간 DW)',
          ['JOB : %s(운영 매주 월요일 06:00) · 집계일 SUM_YYYYMMDD = 실행 시각(SYSDATE) 일자' % JP,
           '실행일 %s(%s). 월요일이 아니면 집계일이 월요일이 아닌 행이 생기고, 다음 회차 시작일 판정(이전 집계일 기준)에 이 행이 쓰임' % (DAY, wd),
           '같은 날 다시 실행하면 그 집계일 행을 지우고 다시 넣음 · 실행 전 [K0] [K2] · 실행 뒤 [A2] · [L1]', '변경 문장. 프로그램 안에서 COMMIT 함'], act[JP], True))
S.append(('A1', '일별 KPI 결과(실행일 · 사업부별)', ['확인 : 사업부별 미등록 건수. 실행 전 0 → 실행 뒤 행 생김'],
          PRM + """
SELECT B.DIVISION_ID
     , COUNT(*) AS ROW_CNT
     , SUM(B.ROUTE_CNT) AS ROUTE_CNT
     , MIN(B.CREATION_DATE) AS FIRST_CREATED
     , MAX(B.CREATION_DATE) AS LAST_CREATED
  FROM SSP_KPI_BR_BOD_REGISTRATION B
     , PRM
 WHERE B.YYYYMMDD = PRM.P_DAY
 GROUP BY B.DIVISION_ID
 ORDER BY B.DIVISION_ID""", False))
S.append(('A2', '주별 KPI 결과(실행일 집계 · 사업부 · 법인별)', ['확인 : YYYYMM = 집계 대상 월, START_YYYYMMDD = 집계 시작일. 사업부 · 법인별 행 수와 수량'],
          PRM + """
SELECT P.DIVISION_ID
     , P.COMPANY_ID
     , P.YYYYMM
     , P.START_YYYYMMDD
     , COUNT(*) AS ROW_CNT
     , SUM(P.PLAN_QTY) AS PLAN_QTY
     , SUM(P.SALES_AMT) AS SALES_AMT
     , MIN(P.YYYYMMDD) AS FROM_DAY
     , MAX(P.YYYYMMDD) AS TO_DAY
  FROM SSP_KPI_SHIPMENT_PSI P
     , PRM
 WHERE P.SUM_YYYYMMDD = PRM.P_DAY
 GROUP BY P.DIVISION_ID
        , P.COMPANY_ID
        , P.YYYYMM
        , P.START_YYYYMMDD
 ORDER BY P.DIVISION_ID
        , P.COMPANY_ID""", False))
S.append(('L1', 'KPI 프로그램 실행 로그(실행일)', ['확인 : START 뒤 END. ERROR 면 LOG_MESSAGE · SQL_ERR_MSG 회신. END 의 DESCRIPTION = 소요 시간'],
          PRM + """
SELECT L.EVENT_DATE
     , L.PROGRAM_NAME
     , L.LOG_TYPE
     , L.LOG_COUNT
     , SUBSTR(L.LOG_MESSAGE, 1, 200) AS LOG_MESSAGE
     , SUBSTR(L.DESCRIPTION, 1, 300) AS DESCRIPTION
     , L.SQL_ERR_CODE
     , SUBSTR(L.SQL_ERR_MSG, 1, 300) AS SQL_ERR_MSG
  FROM SCM_SYS_LOG_BATCH L
     , PRM
 WHERE L.EVENT_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND L.EVENT_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
   AND L.PROGRAM_NAME IN ('PR_SSP_KPI_BR_BOD_REGISTRATION', 'PR_SSP_KPI_SHIPMENT_PSI_DW')
 ORDER BY L.EVENT_DATE DESC""", False))

if '--check' in sys.argv:
    c.callTimeout = 180000
    for k, title, notes, sql, pl in S:
        t0 = datetime.datetime.now()
        try:
            if pl:
                c.execute("DECLARE N INTEGER := DBMS_SQL.OPEN_CURSOR; BEGIN DBMS_SQL.PARSE(N, :s, DBMS_SQL.NATIVE); DBMS_SQL.CLOSE_CURSOR(N); END;", s=sql)
                print('[%s] 컴파일 통과(실행 안 함)' % k)
            else:
                c.execute(sql); rows = c.fetchall()
                print('[%s] %.1f초 · %d행 · %s' % (k, (datetime.datetime.now() - t0).total_seconds(), len(rows), str(rows[:3])[:300]))
        except Exception as e:
            print('[%s] 오류 %s' % (k, str(e).split('\n')[0][:200]))
    t.rollback()
t.close()

def blk(k, title, notes, sql, pl):
    body = sql.rstrip().rstrip(';') + ';' + ('\n\n/' if pl else '')
    return '\n'.join([LINE, '-- [%s] %s' % (k, title)] + ['-- ' + n for n in notes] + [LINE, body, '', ''])

head = [LINE, '-- SSP KPI 배치 실행 · Oracle(클라우드) · 실행일 %s(%s)' % (DAY, wd),
        '-- 대상 : 일별 PR_SSP_KPI_BR_BOD_REGISTRATION(%s) · 주별 PR_SSP_KPI_SHIPMENT_PSI_DW(%s)' % (ddl['PR_SSP_KPI_BR_BOD_REGISTRATION'], ddl['PR_SSP_KPI_SHIPMENT_PSI_DW']),
        '-- 두 프로그램은 서로 이어지지 않음(쓰는 테이블이 다르고 서로의 결과를 읽지 않음). 시험 범위에 맞춰 [R1] · [R2] 를 따로 실행',
        '-- 순서 : [K0] [K1] [K2] 확인 → [R1] 일별 → [R2] 주별(실행일 일마감 뒤) → [A1] [A2] [L1] 확인',
        '-- 실행 : DBeaver = 쿼리 · 블록 안에 커서를 두고 Ctrl+Enter(블록 아래 / 줄은 실행하지 않음). SQL Developer · SQLcl = 블록과 / 줄까지 선택해 실행',
        '--        파일 전체 실행(F5, Alt+X)은 하지 않음. [R1] [R2] 가 한꺼번에 돌아감',
        '-- 주의 : [R1] [R2] 는 프로그램 안에서 COMMIT 함. 되돌릴 수 없음. 날짜 인자가 없고 실행 시각(SYSDATE) 기준이라 실행일 당일에 실행',
        '-- 실행문 = TO-BE JOB 실행문(사내 ZIOUI1 %s 조회). [R1] 은 실행일 행이 있으면 멈추는 확인을 앞에 덧붙임' % at,
        '-- 생성 %s · tools/Analysis/ssp_it_precheck/gen_kpi_sql.py' % datetime.datetime.now().strftime('%Y-%m-%d %H:%M'), LINE, '', '']
io.open(OUT, 'w', encoding='utf-8', newline='\r\n').write('\n'.join(head) + ''.join(blk(*x) for x in S).rstrip() + '\n')
print('written', OUT)
