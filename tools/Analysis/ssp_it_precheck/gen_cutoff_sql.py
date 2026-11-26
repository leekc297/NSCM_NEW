# -*- coding: utf-8 -*-
"""SSP 사업부별 일마감 JOB 점검 · 실행 쿼리 파일 생성(Oracle, 클라우드 실행용)
  python gen_cutoff_sql.py <실행일 YYYYMMDD> <사전점검 검증쿼리 ORACLE .sql> <출력 .sql>
  점검 쿼리 = 사전점검 검증쿼리 파일의 VQ 블록 그대로(ZIOUI1 시험 끝난 쿼리) + 일마감 현황표 · JOB 상태 · 실행 로그 쿼리
  실행 블록 = 사내 ZIOUI1 ALL_SCHEDULER_JOBS 의 JOB_ACTION 을 실행 때 새로 읽어 그대로 씀(끝에 / 줄)
  일마감 기준 = PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND 원문(81·82 · 전극 = 스케줄 CURRENT_PLAN_DATE_YN, 40 = 당일 SHIP_CONFIRM 행, 법인별 기준 시각)"""
import sys, io, re, datetime
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn

DAY, VQFILE, OUT = sys.argv[1], sys.argv[2], sys.argv[3]
LINE = '-- ' + '=' * 110
RUN = [  # (번호, 이름, JOB, 운영 시각, 실행 전 확인, 실행 후 확인)
    ('R1', '40(Mobility&IT) 법인 HQ00 일마감', 'JOB_PR_SSP_PLN_SHIP_PLAN_40', '매일 08:00 · 마감 기준 08:10', '[C0] 40 HQ00 · [VQ-35] · [VQ-37]', '[C0] 40 HQ00 DONE_YN = Y · [L1]'),
    ('R2', '40(Mobility&IT) 법인 AZ00 일마감', 'JOB_PR_SSP_PLN_SHIP_PLAN_40_AZ', '매일 10:30 · 마감 기준 10:40', '[C0] 40 AZ00 · [VQ-37]', '[C0] 40 AZ00 DONE_YN = Y · [L1]'),
    ('R3', '40(Mobility&IT) 법인 NJ00 일마감', 'JOB_PR_SSP_PLN_SHIP_PLAN_40_C', '매일 11:00 · 마감 기준 11:10', '[C0] 40 NJ00 · [VQ-37]', '[C0] 40 NJ00 DONE_YN = Y · [L1]'),
    ('R4', '81·82(Auto&ESS) 법인별 일마감(CUTOFF)', 'JOB_PR_SSP_PLN_SHIP_PLAN_81_82', '05:07 ~ 23:57 10분마다 · 법인별 마감 기준 [C0]', '[C0] 81·82 · [VQ-38]', '[C0] 81·82 DONE_YN = Y · [VQ-54] · [L1]'),
    ('R5', '전극(Electrode) 법인별 일마감', 'JOB_PR_SSP_PLN_SHIP_PLAN_EE', '10분마다 · 법인별 마감 기준 [C0]', '[C0] 전극 · [VQ-40]', '[C0] 전극 DONE_YN = Y · [VQ-54] · [L1]'),
    ('R6', 'Packer 일 산출', 'JOB_PR_SSP_PLN_SHIP_PLAN_P', '매일 07:15(마감 지연 문자 대상 아님)', '[VQ-39]', '[L1]'),
    ('R7', '사업부별 출하계획 · 확정 통합 스냅샷', 'JOB_PR_SSP_ANL_SHIP_PLAN_ALL', '30분마다', 'R1 ~ R6 끝난 뒤', '[L1]'),
]
VQ_KEEP = ['VQ-35', 'VQ-37', 'VQ-38', 'VQ-39', 'VQ-40', 'VQ-54', 'VQ-57']

t = dbconn.connect('tobe'); c = t.cursor()
c.execute("SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); at = c.fetchone()[0]
act = {}
for _, _, j, *_ in RUN + [('', '', 'JOB_PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND')]:
    c.execute("SELECT job_action, enabled FROM all_scheduler_jobs WHERE owner = 'SCM_MGR' AND job_name = :j", j=j)
    r = c.fetchone()
    if not r:
        sys.exit('JOB 없음 : %s' % j)
    a = r[0].read() if hasattr(r[0], 'read') else r[0]
    act[j] = a.strip()
c.execute("SELECT TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND' AND object_type = 'PROCEDURE'")
sms_ddl = c.fetchone()[0]
t.close()

src = io.open(VQFILE, encoding='utf-8').read().replace('\r\n', '\n')
blocks = {}
for m in re.finditer(r'(?ms)^-- =+\n-- \[(VQ-\d+)\].*?;\n', src):
    blocks[m.group(1)] = m.group(0).rstrip('\n')
miss = [k for k in VQ_KEEP if k not in blocks]
if miss:
    sys.exit('VQ 블록 없음 : %s' % miss)
fix_day = lambda s: re.sub(r"'\d{8}' AS P_TEST_DATE", "'%s' AS P_TEST_DATE" % DAY, s)

C0 = """WITH PRM AS (SELECT '%s' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
, BASE AS (
SELECT '81·82' AS UNIT
     , S.COMPANY_ID
     , S.CURRENT_PLAN_DATE_YN AS DONE_FLAG
     , CASE WHEN S.CURRENT_PLAN_DATE_YN = 'Y' THEN 'Y' ELSE 'N' END AS DONE_YN
     , S.LAST_UPDATE_DATE
     , CASE S.COMPANY_ID WHEN 'WA00' THEN '16:20' WHEN 'NJ00' THEN '10:40' WHEN 'NB00' THEN '10:40' WHEN 'HM00' THEN '09:30'
                         WHEN 'HQ00' THEN '07:30' WHEN 'HG00' THEN '20:40' WHEN 'GM00' THEN '21:10' WHEN 'HD00' THEN '21:40'
                         WHEN 'MI00' THEN '20:40' WHEN 'NA00' THEN '10:40' WHEN 'ST00' THEN '20:40' END AS CUTOFF_TIME
  FROM SSP_MST_SHIP_PLAN_SCHEDULE S
     , PRM
 WHERE S.PLAN_START_YYYYMMDD = PRM.P_DAY
 UNION ALL
SELECT '전극'
     , E.COMPANY_ID
     , E.CURRENT_PLAN_DATE_YN
     , CASE WHEN E.CURRENT_PLAN_DATE_YN = 'Y' THEN 'Y' ELSE 'N' END
     , E.LAST_UPDATE_DATE
     , CASE E.COMPANY_ID WHEN 'WA00' THEN '15:50' WHEN 'NJ00' THEN '11:50' WHEN 'NB00' THEN '10:50' WHEN 'HM00' THEN '09:50'
                         WHEN 'HQ00' THEN '07:50' WHEN 'HG00' THEN '21:00' WHEN 'GM00' THEN '20:00' WHEN 'HD00' THEN '20:50'
                         WHEN 'MI00' THEN '20:50' WHEN 'NA00' THEN '10:50' WHEN 'ST00' THEN '20:50' END
  FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE E
     , PRM
 WHERE E.PLAN_START_YYYYMMDD = PRM.P_DAY
 UNION ALL
SELECT '40'
     , C.COMPANY_ID
     , TO_CHAR(NVL(P.CNT, 0))
     , CASE WHEN NVL(P.CNT, 0) > 0 THEN 'Y' ELSE 'N' END
     , P.LAST_UPDATE_DATE
     , C.CUTOFF_TIME
  FROM (SELECT 'HQ00' AS COMPANY_ID, '08:10' AS CUTOFF_TIME FROM DUAL
         UNION ALL
        SELECT 'AZ00', '10:40' FROM DUAL
         UNION ALL
        SELECT 'NJ00', '11:10' FROM DUAL) C
     , (SELECT A.ATTRIBUTE10 AS COMPANY_ID
             , COUNT(*) AS CNT
             , MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
          FROM SSP_ANL_SHIP_PLAN_40 A
             , PRM
         WHERE A.DIVISION_ID         = '40'
           AND A.PLAN_START_YYYYMMDD = PRM.P_DAY
           AND A.MEASURE             = 'SHIP_CONFIRM'
         GROUP BY A.ATTRIBUTE10) P
 WHERE P.COMPANY_ID(+) = C.COMPANY_ID
)
SELECT B.UNIT
     , B.COMPANY_ID
     , B.CUTOFF_TIME
     , B.DONE_FLAG       /* 81·82 · 전극 = CURRENT_PLAN_DATE_YN(N 미수행, P 진행 중, Y 완료, E 오류) · 40 = 당일 SHIP_CONFIRM 행 수 */
     , B.DONE_YN
     , CASE WHEN B.DONE_YN = 'Y' THEN '마감 완료'
            WHEN PRM.P_DAY < TO_CHAR(SYSDATE, 'YYYYMMDD') OR (PRM.P_DAY = TO_CHAR(SYSDATE, 'YYYYMMDD') AND B.CUTOFF_TIME < TO_CHAR(SYSDATE, 'HH24:MI')) THEN '마감 지연'
            ELSE '마감 전' END AS STATUS
     , B.LAST_UPDATE_DATE
  FROM BASE B
     , PRM
 ORDER BY DECODE(B.UNIT, '40', 1, '81·82', 2, 3)
        , B.CUTOFF_TIME
        , B.COMPANY_ID""" % DAY

JOBS = [j for _, _, j, *_ in RUN]
C1 = """SELECT J.JOB_NAME
     , J.ENABLED
     , J.STATE
     , NVL(J.REPEAT_INTERVAL, J.SCHEDULE_NAME) AS SCHEDULE
     , J.LAST_START_DATE
     , J.LAST_RUN_DURATION
     , J.NEXT_RUN_DATE
     , R.SESSION_ID AS RUNNING_SID
     , R.ELAPSED_TIME AS RUNNING_ELAPSED
  FROM ALL_SCHEDULER_JOBS J
  LEFT JOIN ALL_SCHEDULER_RUNNING_JOBS R
    ON R.OWNER    = J.OWNER
   AND R.JOB_NAME = J.JOB_NAME
 WHERE J.OWNER = 'SCM_MGR'
   AND J.JOB_NAME IN (%s)
 ORDER BY J.JOB_NAME""" % ',\n                      '.join("'%s'" % j for j in JOBS + ['JOB_PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND'])

PROGS = ['PR_SSP_ANL_SHIP_PLAN_40_BALANCE', 'PR_SSP_ANL_SHIP_CONFIRM_BATCH_40', 'PR_SSP_ANL_SHIP_PLAN_40', 'PR_SSP_ANL_INVENTORY_RAW', 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40',
         'PR_SSP_PLN_SHIP_PLAN_CUTOFF', 'PR_SSP_ANL_SHIP_PLAN_CUTOFF', 'PR_SSP_ANL_SHIP_PLAN_CUTOFF_FP_AUTO', 'PR_SSP_ANL_SHIP_CONFIRM_BATCH_N', 'PR_SSP_ANL_SHIP_CONFIRM_BATCH_N_FP_AUTO',
         'PR_SSP_ANL_SHIP_PLAN_EE', 'PR_SSP_ANL_SHIP_PLAN_P', 'PR_SSP_ANL_SHIP_CONFIRM_P', 'PR_SSP_ANL_SHIP_PLAN_ALL', 'PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND']
L1 = """WITH PRM AS (SELECT '%s' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
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
   AND L.PROGRAM_NAME IN (%s)
 ORDER BY L.EVENT_DATE DESC""" % (DAY, ',\n                          '.join("'%s'" % p for p in PROGS))

def blk(key, title, notes, sql, plsql=False):
    body = sql.rstrip().rstrip(';') + ';'
    tail = '\n\n/' if plsql else ''
    return '\n'.join([LINE, '-- [%s] %s' % (key, title)] + ['-- ' + n for n in notes] + [LINE, body + tail, '', ''])

gen = datetime.datetime.now().strftime('%Y-%m-%d %H:%M')
head = '\n'.join([LINE,
    '-- SSP 사업부별 일마감 JOB 점검 · 실행 · Oracle(클라우드) · 실행일 %s' % DAY,
    '-- 순서 : 1부 점검(조회 문장) → 결과 확인 → 2부 실행(변경 문장, 사업부 블록 하나씩) → 3부 실행 뒤 확인',
    '-- 실행 : DBeaver = 쿼리 · 블록 안에 커서를 두고 Ctrl+Enter(블록 아래 / 줄은 실행하지 않음). SQL Developer · SQLcl = 블록과 / 줄까지 선택해 실행',
    '--        파일 전체 실행(F5, Alt+X)은 하지 않음. 2부 블록이 한꺼번에 돌아감',
    '-- 주의 : 2부는 프로그램 안에서 COMMIT 함. 되돌릴 수 없음. 2부 실행 전 1부 결과로 진입 조건 확인',
    '--        산출 프로그램은 날짜 인자가 없고 실행 시각(SYSDATE) 기준. 실행일(%s) 당일에 실행해야 함' % DAY,
    '-- 일마감 JOB(사내 ZIOUI1 %s 조회 · AS-IS 개발 msdb JOB 8개와 단계 · 인자 일치)' % at,
    '--   40 HQ00 = JOB_PR_SSP_PLN_SHIP_PLAN_40 · 40 AZ00 = _40_AZ · 40 NJ00 = _40_C',
    '--   81·82 = JOB_PR_SSP_PLN_SHIP_PLAN_81_82(PR_SSP_PLN_SHIP_PLAN_CUTOFF) · 전극 = JOB_PR_SSP_PLN_SHIP_PLAN_EE · Packer = JOB_PR_SSP_PLN_SHIP_PLAN_P',
    '--   통합 스냅샷 = JOB_PR_SSP_ANL_SHIP_PLAN_ALL · 마감 지연 문자 = JOB_PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND(문자 발송이라 2부에 넣지 않음)',
    '-- 마감 판정 · 기준 시각 = PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND 원문(LAST_DDL_TIME %s)' % sms_ddl,
    '--   81·82 · 전극 = 실행일 스케줄 행 CURRENT_PLAN_DATE_YN = Y · 40 = 실행일 SSP_ANL_SHIP_PLAN_40 SHIP_CONFIRM 행 1건 이상(법인 = ATTRIBUTE10)',
    '-- 40 은 실행일 일 계획 ID(SCM_MST_PLAN DAILY)가 있어야 함([VQ-35]). 없으면 SCM_MST_PLAN_일계획ID_생성_실행쿼리 파일 먼저',
    '-- 생성 %s · tools/Analysis/ssp_it_precheck/gen_cutoff_sql.py' % gen,
    LINE, '', ''])
parts = [head, LINE, '-- 1부 점검(조회 문장)', LINE, '', '',
         blk('C0', '사업부 · 법인별 일마감 현황', ['확인 : STATUS = 마감 완료 / 마감 전 / 마감 지연(기준 시각 지남). 2부에서 실행할 사업부 · 법인을 고름',
                                                '      81·82 · 전극 법인 행이 없으면 실행일 스케줄 행이 없는 것. 그 법인은 마감되지 않음'], C0),
         blk('C1', '일마감 JOB 상태 · 실행 중 JOB', ['확인 : ENABLED = TRUE 이면 스케줄대로 자동 실행됨. RUNNING_SID 값이 있으면 실행 중이므로 2부 같은 블록 실행하지 않음'], C1)]
for k in VQ_KEEP:
    parts.append(fix_day(blocks[k]) + '\n\n')
parts += [LINE, '-- 2부 실행(변경 문장) : 사업부 블록 하나씩. 실행 전 [C0] [C1] 과 블록에 적힌 확인 쿼리', LINE, '', '']
for key, name, job, when, pre, post in RUN:
    parts.append(blk(key, name, ['JOB : %s(운영 %s)' % (job, when), '실행 전 확인 : %s · 실행 뒤 확인 : %s' % (pre, post),
                                 '실행문 = JOB 실행문 그대로(사내 ZIOUI1 %s 조회)' % at], act[job], plsql=True))
parts += [LINE, '-- 3부 실행 뒤 확인 : [C0] [C1] [VQ-54] [VQ-57] 다시 실행 + 아래 [L1]', LINE, '', '',
          blk('L1', '실행일 일마감 프로그램 로그', ['확인 : 프로그램마다 START 뒤 END. ERROR 면 LOG_MESSAGE · SQL_ERR_MSG 회신'], L1)]
io.open(OUT, 'w', encoding='utf-8', newline='\r\n').write('\n'.join(parts).rstrip() + '\n')
print('written', OUT, '· ZIOUI1', at, '· 실행 블록', len(RUN), '· 점검', 2 + len(VQ_KEEP), '+ L1')
