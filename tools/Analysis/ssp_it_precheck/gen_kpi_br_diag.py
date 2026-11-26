# -*- coding: utf-8 -*-
"""일별 KPI(PR_SSP_KPI_BR_BOD_REGISTRATION) 0건 원인 확인 쿼리 생성
  원문(ZIOUI1 ALL_SOURCE)에서 대상 추출 SELECT 를 그대로 꺼내 건수 쿼리로 만듦
  python gen_kpi_br_diag.py <실행일 YYYYMMDD> <출력 .sql> [--check]"""
import sys, io, re, datetime
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn

DAY, OUT = sys.argv[1], sys.argv[2]
LINE = '-- ' + '=' * 110
P = 'PR_SSP_KPI_BR_BOD_REGISTRATION'
t = dbconn.connect('tobe'); c = t.cursor(); c.callTimeout = 300000
c.execute("SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); at = c.fetchone()[0]
c.execute("SELECT TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = :p AND object_type = 'PROCEDURE'", p=P)
ddl = c.fetchone()[0]
c.execute("SELECT line, text FROM all_source WHERE owner = 'SCM_MGR' AND name = :p AND type = 'PROCEDURE' ORDER BY line", p=P)
L = {ln: tx.rstrip('\n') for ln, tx in c.fetchall()}


def seg(a, b):
    return '\n'.join(L[i] for i in range(a, b + 1))


# 원문 위치 확인(줄 번호가 바뀌면 멈춤)
assert 'INSERT INTO GT_SKBBR_PIVOT_FROM' in L[77] and 'INSERT INTO GT_SKBBR_PIVOT_TO' in L[87], '원문 줄 번호 변경(PIVOT)'
assert L[128].strip() == 'SELECT DISTINCT' and L[598].strip() == ';' and 'INSERT INTO SSP_KPI_BR_BOD_REGISTRATION' in L[603], '원문 줄 번호 변경(본문)'
piv_from = seg(78, 85).rstrip().rstrip(';').rstrip()
piv_to = seg(88, 102).rstrip().rstrip(';').rstrip()
core = seg(128, 597)
core = core.replace('INNER JOIN GT_SKBBR_PIVOT_FROM FR', 'INNER JOIN (\n' + piv_from + '\n) FR', 1)
core = core.replace('INNER JOIN GT_SKBBR_PIVOT_TO TR', 'INNER JOIN (\n' + piv_to + '\n) TR', 1)
assert 'GT_SKBBR' not in core, 'GT 참조 남음'
core = re.sub(r'(?m)^\s*\n', '', core)
PRM = "WITH PRM AS (SELECT '%s' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */" % DAY
flat = lambda s: re.sub(r'\s+', ' ', s).strip()

Q = []
Q.append(('D1', '실행일 실행 로그(START · TXN · END · ERROR)', [
    '판정 : START 가 없으면 실행되지 않은 것(다른 DB · 다른 접속에서 실행했는지, [R1] 확인 문장 ORA-20001 로 멈췄는지 확인)',
    '       ERROR 행이 있으면 오류로 ROLLBACK 된 것. 프로그램이 오류를 밖으로 내지 않아 실행 창에서는 정상 종료로 보임 → LOG_MESSAGE · DESCRIPTION(오류 줄) 회신',
    '       TXN 행(INSERT INTO SSP_KPI_BR_BOD_REGISTRATION)이 있고 ERROR 가 없으면 COMMIT 까지 끝난 것 → 0건 원인은 [D3] [D4]',
    '       START 만 있고 END 가 없으면 아직 실행 중 → [D2]'],
    PRM + """
SELECT L.EVENT_DATE
     , L.LOG_TYPE
     , L.LOG_COUNT
     , SUBSTR(L.LOG_MESSAGE, 1, 300) AS LOG_MESSAGE
     , SUBSTR(L.DESCRIPTION, 1, 400) AS DESCRIPTION
     , L.SQL_ERR_CODE
     , SUBSTR(L.SQL_ERR_MSG, 1, 300) AS SQL_ERR_MSG
     , L.CREATED_BY
  FROM SCM_SYS_LOG_BATCH L
     , PRM
 WHERE L.PROGRAM_NAME = '%s'
   AND L.EVENT_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND L.EVENT_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 ORDER BY L.EVENT_DATE""" % P))
Q.append(('D2', '지금 실행 중인지(V$ 권한 필요)', ['판정 : 행이 있으면 아직 실행 중. SQL_RUN_MIN · EVENT 확인. ORA-00942 면 DBA 에 실행 요청'],
    """SELECT S.INST_ID
     , S.SID
     , S.SERIAL#
     , S.USERNAME
     , S.MODULE
     , S.STATUS
     , S.SQL_EXEC_START
     , ROUND((SYSDATE - S.SQL_EXEC_START) * 1440, 1) AS SQL_RUN_MIN
     , S.EVENT
     , S.SQL_ID
  FROM GV$SESSION S
 WHERE S.PLSQL_ENTRY_OBJECT_ID = (SELECT O.OBJECT_ID
                                    FROM ALL_OBJECTS O
                                   WHERE O.OWNER       = 'SCM_MGR'
                                     AND O.OBJECT_NAME = '%s'
                                     AND O.OBJECT_TYPE = 'PROCEDURE')""" % P))
Q.append(('D3', '최종 입력 조건 · 기준 정보 건수', [
    '판정 : CALENDAR_CNT = 0 이면 0건(최종 INSERT 가 SCM_SYS_CALENDAR_M 실행일 행과 JOIN, 원문 659 ~ 661줄)',
    '       FROM_SITE_CNT · TO_SITE_CNT · INCOTERMS_CNT · MKT_FCST_CNT 중 0 이 있으면 대상 추출이 0건(원문 77 ~ 102, 165 ~ 178, 571 ~ 574줄)',
    '       BOD_VALID_CNT = 실행일에 유효한 BOD(ATTRIBUTE2 ≤ 실행일 ≤ ATTRIBUTE3) · ROUTE_VALID_CNT = 유효 배송 경로'],
    PRM + """
SELECT (SELECT COUNT(*) FROM SCM_SYS_CALENDAR_M C, PRM WHERE C.BASIS_YYYYMMDD = PRM.P_DAY) AS CALENDAR_CNT
     , (SELECT COUNT(*) FROM (%s)) AS FROM_SITE_CNT
     , (SELECT COUNT(*) FROM (%s)) AS TO_SITE_CNT
     , (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WHERE A.LOOKUP_TYPE = 'INCOTERMS' AND A.VALID_YN = 'Y') AS INCOTERMS_CNT
     , (SELECT COUNT(*) FROM DM_PLN_MKT_FCST F, SCM_MST_DIVISION D WHERE F.DIVISION_ID = D.DIVISION_ID AND D.ATTRIBUTE3 IN ('40', '81', '82') AND F.MEASURE IN ('MKT_FCST', 'VMI_In_Req')) AS MKT_FCST_CNT
     , (SELECT COUNT(*) FROM SCP_MST_BOD B, PRM WHERE B.ATTRIBUTE2 <= PRM.P_DAY AND B.ATTRIBUTE3 >= PRM.P_DAY) AS BOD_VALID_CNT
     , (SELECT COUNT(*) FROM SCP_MST_DISTRIBUTION_ROUTE R WHERE R.VALID_YN = 'Y') AS ROUTE_VALID_CNT
  FROM DUAL""" % (flat(piv_from), flat(piv_to))))
Q.append(('D4', '대상 추출 결과 건수(원문 대상 추출 SELECT 그대로, 사업부별)', [
    '판정 : 프로그램이 넣을 행 수. 결과 0행이면 실행일 기준 BOD 미등록 구간이 없음(MKT FCST 구간이 모두 BOD 등록됨) → 0건이 정상 결과',
    '       TARGET_CNT 가 있는데 테이블에 행이 없으면 → [D1] ERROR · [D3] CALENDAR_CNT 확인',
    '원문 = %s 128 ~ 597줄(사내 ZIOUI1 LAST_DDL_TIME %s). 세션 임시 테이블 GT_SKBBR_PIVOT_FROM · _TO 는 원문 78 ~ 102줄 SELECT 로 바꿈' % (P, ddl),
    'SYSDATE 기준 쿼리라 실행일 당일에 실행'],
    'SELECT X.DIVISION_ID\n     , COUNT(*) AS TARGET_CNT\n     , SUM(X.ROUTE_CNT) AS ROUTE_CNT\n  FROM (\n' + core + '\n       ) X\n GROUP BY X.DIVISION_ID\n ORDER BY X.DIVISION_ID'))
Q.append(('D5', '최근 14일 일별 KPI 적재 이력', ['판정 : 이전 실행일의 사업부별 행 수와 비교. 같은 날 CREATED_AT 이 여러 개면 여러 번 실행된 것'],
    PRM + """
SELECT A.YYYYMMDD
     , A.DIVISION_ID
     , TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') AS CREATED_AT
     , A.CREATED_BY
     , COUNT(*) AS ROW_CNT
  FROM SSP_KPI_BR_BOD_REGISTRATION A
     , PRM
 WHERE A.YYYYMMDD >= TO_CHAR(TO_DATE(PRM.P_DAY, 'YYYYMMDD') - 14, 'YYYYMMDD')
 GROUP BY A.YYYYMMDD
        , A.DIVISION_ID
        , TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS')
        , A.CREATED_BY
 ORDER BY A.YYYYMMDD DESC
        , A.DIVISION_ID"""))

res = {}
if '--check' in sys.argv:
    for k, title, notes, sql in Q:
        t0 = datetime.datetime.now()
        try:
            c.execute(sql); r = c.fetchall()
            res[k] = (round((datetime.datetime.now() - t0).total_seconds(), 1), len(r), str(r[:6])[:300], '')
        except Exception as e:
            res[k] = (round((datetime.datetime.now() - t0).total_seconds(), 1), -1, '', str(e).split('\n')[0][:200])
        print('[%s]' % k, res[k])
t.close()


def blk(k, title, notes, sql):
    return '\n'.join([LINE, '-- [%s] %s' % (k, title)] + ['-- ' + n for n in notes] + [LINE, sql.rstrip().rstrip(';') + ';', '', ''])


head = [LINE, '-- 일별 KPI(PR_SSP_KPI_BR_BOD_REGISTRATION) 0건 원인 확인 · Oracle(클라우드) · 조회만 수행 · 실행일 %s' % DAY,
        '-- 순서 : [D1] 로그 → [D2] 실행 중 여부 → [D3] 기준 정보 → [D4] 대상 추출 건수 → [D5] 적재 이력',
        '-- 0건이 되는 경로(원문 기준) : ① 실행 안 됨 ② 오류 → ROLLBACK(오류를 밖으로 내지 않음) ③ 달력 실행일 행 없음 ④ 대상(BOD 미등록 구간) 0건',
        '-- 실행 : DBeaver 에서 쿼리 하나씩(Ctrl+Enter). 각 쿼리 PRM 줄의 실행일만 바꿈. [D4] 는 SYSDATE 기준이라 실행일 당일에 실행',
        '-- 원문 기준 : 사내 ZIOUI1 %s 조회(LAST_DDL_TIME %s) · 생성 tools/Analysis/ssp_it_precheck/gen_kpi_br_diag.py' % (at, ddl)]
if res:
    head.append('-- ZIOUI1 시험(%s) : ' % at + ' · '.join('%s %s초 %s행' % (k, v[0], v[1]) if v[1] >= 0 else '%s 오류' % k for k, v in res.items()))
head += [LINE, '', '']
io.open(OUT, 'w', encoding='utf-8', newline='\r\n').write('\n'.join(head) + ''.join(blk(*q) for q in Q).rstrip() + '\n')
print('written', OUT)
