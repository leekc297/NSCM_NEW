--------------------------------------------------------------------------------
-- DMF0044 저장 SQL ERROR 진단 (클라우드 / Oracle / SCM_MGR)
-- 마커 : E20260903-DMF0044
--------------------------------------------------------------------------------
-- 목적 : "클라우드에서 입력 시 계속 SQL ERROR" 의 원인을 **실측으로 확정**한다.
--        ① 패치가 적용되어 있는가(3축)  ② 실제 ORA 코드·발생 라인은 무엇인가
--
-- ⚠ 판정 순서를 지킬 것. §1 이 '미적용' 이면 §2 의 에러는 당연한 결과이며,
--    §1 이 '적용' 인데도 §2 에 에러가 있으면 그때가 진짜 신규 원인이다.
--
-- 실행 : SQLcl / DBeaver. 전 구문 읽기 전용(DML 없음).
--------------------------------------------------------------------------------
SET SERVEROUTPUT OFF
SET LINESIZE 300
SET PAGESIZE 200

COLUMN OBJECT_TYPE      FORMAT A14
COLUMN 축               FORMAT A34
COLUMN 상태             FORMAT A46
COLUMN PROGRAM_NAME     FORMAT A44
COLUMN SQL_ERR_CODE     FORMAT A12
COLUMN SQL_ERR_MSG      FORMAT A70
COLUMN SQL_BACKTRACE    FORMAT A80
COLUMN OBJECT_NAME      FORMAT A38

PROMPT ================ §0. 접속 환경 지문 ================
SELECT SYS_CONTEXT('USERENV','DB_NAME')        AS DB_NAME
     , SYS_CONTEXT('USERENV','SERVER_HOST')    AS SRV
     , SYS_CONTEXT('USERENV','CURRENT_SCHEMA') AS CUR_SCHEMA
     , TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') AS NOW
  FROM DUAL;

PROMPT ================ §1. ⭐ 패치 적용 여부 3축 (여기서 대부분 결론난다) ================
-- 기대(전부 적용 시) : 마커>0 / SP인자 CLOB / 메타 CLOB / 정밀도해제 6 / 배분식교정 4
SELECT '1) 패치 마커(E20260903-DMF0044*)' AS 축
     , TO_CHAR(COUNT(*)) || ' 줄  ' ||
       CASE WHEN COUNT(*) > 0 THEN '=> 적용됨' ELSE '=> ⛔ 미적용' END AS 상태
  FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TEXT LIKE '%E20260903-DMF0044%'
UNION ALL
SELECT '2) SP IN 인자 타입(_C 21/_CF 23)'
     , LISTAGG(OBJECT_NAME || '=' || DATA_TYPE || 'x' || CNT, ' , ')
         WITHIN GROUP (ORDER BY OBJECT_NAME)
  FROM ( SELECT OBJECT_NAME, DATA_TYPE, COUNT(*) CNT
           FROM ALL_ARGUMENTS
          WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0044' AND IN_OUT='IN'
            AND OBJECT_NAME IN ('P_DMF0044_SAVE_SALES_PLAN_REPORT_C'
                               ,'P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF')
          GROUP BY OBJECT_NAME, DATA_TYPE )
UNION ALL
SELECT '3) API 메타 SCM_ADM_PROC_M IN 타입'
     , LISTAGG(DATA_TP_CD || 'x' || CNT, ' , ') WITHIN GROUP (ORDER BY DATA_TP_CD)
  FROM ( SELECT DATA_TP_CD, COUNT(*) CNT
           FROM SCM_MGR.SCM_ADM_PROC_M
          WHERE PROC_NM IN ('PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C'
                           ,'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF')
            AND COL_TP_CD='IN'
          GROUP BY DATA_TP_CD )
UNION ALL
SELECT '4) 중간변수 정밀도 해제(기대 6)'
     , TO_CHAR(COUNT(*)) || ' 곳 (NUMBER(30,10) 잔존 = 미적용)'
  FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
   AND REGEXP_LIKE(TEXT, 'V_(ADJQTY|REST|ORIQTY|LOC_SALESAMT_LOC|LOC_RTF|LOC_PRICE)\s+NUMBER\s*\(')
UNION ALL
SELECT '5) 배분식 교정(기대 4, 미교정=0)'
     , TO_CHAR(COUNT(*)) || ' 곳이 교정됨'
  FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
   AND TEXT LIKE '%V_ADJQTY * (A.QTY / V_ORIQTY)%';

PROMPT ================ §1-1. 패키지 컴파일 상태 ================
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS
     , TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY OBJECT_TYPE;

SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY LINE;

PROMPT ================ §2. ⭐ 실제 발생한 ORA 원문 (최근 20건) ================
-- SP 의 EXCEPTION 블록이 SQLCODE/SQLERRM/BACKTRACE 를 그대로 남긴다.
-- ORA-01438 = 값이 정밀도 초과 / ORA-06502 = 버퍼 초과(대량) / ORA-01722 = 숫자 변환 실패
SELECT TO_CHAR(EVENT_DATE,'MM-DD HH24:MI:SS') AS 발생시각
     , PROGRAM_NAME, LOG_TYPE, SQL_ERR_CODE, SQL_ERR_MSG
  FROM SCM_MGR.SCM_SYS_LOG_BATCH
 WHERE UPPER(PROGRAM_NAME) LIKE '%DMF0044%'
   AND LOG_TYPE IN ('ERROR','INVALID')
 ORDER BY EVENT_DATE DESC
 FETCH FIRST 20 ROWS ONLY;

PROMPT ================ §2-1. 가장 최근 1건의 BACKTRACE + 입력 파라미터 ================
-- BACKTRACE 의 line 번호가 곧 PKG_DMF0044 BODY 의 실패 라인이다.
SELECT TO_CHAR(EVENT_DATE,'YYYY-MM-DD HH24:MI:SS') AS 발생시각
     , SQL_ERR_CODE, SQL_ERR_MSG, SQL_BACKTRACE
     , SUBSTR(IN_PARA_DATA, 1, 1000) AS 입력파라미터
  FROM SCM_MGR.SCM_SYS_LOG_BATCH
 WHERE UPPER(PROGRAM_NAME) LIKE '%DMF0044%' AND LOG_TYPE='ERROR'
 ORDER BY EVENT_DATE DESC
 FETCH FIRST 1 ROWS ONLY;

PROMPT ================ §3. 대상 테이블 수치 컬럼 정밀도 (클라우드 실측) ================
-- 사내는 QTY 가 NUMBER(30,10) 이었다. 클라우드가 다르면 그 자체가 원인이다.
SELECT TABLE_NAME, COLUMN_NAME
     , DATA_TYPE || '(' || DATA_PRECISION || ',' || DATA_SCALE || ')' AS 정밀도
     , (DATA_PRECISION - NVL(DATA_SCALE,0)) AS 정수부자리
  FROM ALL_TAB_COLUMNS
 WHERE OWNER='SCM_MGR'
   AND TABLE_NAME IN ('DM_PLN_SALES_PLAN_REPORT_C','DM_PLN_SALES_ETC_REPORT_C'
                     ,'DM_PLN_SALES_PLAN_REPORT_H','GT_0044_RESULTS_MST','GT_0044_RESULTS_MST_C')
   AND DATA_TYPE='NUMBER'
 ORDER BY TABLE_NAME, COLUMN_NAME;

PROMPT ================ §3-1. GTT 스테이징 QTY 타입 (VARCHAR2 여야 정상) ================
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_LENGTH
  FROM ALL_TAB_COLUMNS
 WHERE OWNER='SCM_MGR' AND TABLE_NAME IN ('GT_0044_RESULTS_MST','GT_0044_RESULTS_MST_C')
   AND COLUMN_NAME='QTY' ORDER BY TABLE_NAME;

PROMPT ================ §4. 사내↔클라우드 SP 원문 차이 확인용 지문 ================
SELECT TYPE, COUNT(*) AS 라인수
  FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
 GROUP BY TYPE ORDER BY TYPE;
-- 사내 기준(2026-09-03 13:02 판) : PACKAGE 72줄 / PACKAGE BODY 10250줄
-- 라인수가 다르면 클라우드 원문이 사내와 다른 판이다.

PROMPT ================ 끝 ================
