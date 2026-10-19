-- =============================================================================
-- R07_MEASURE_SET_HISTORY.sql — DMF0082 조회 속도 재점검 ⑦ 사용자 메저 선택 집합과 그 변경 시점 (READ-ONLY, 전체 F5)
--   계정: SCM_MGR · BE 가 붙는 DB (QA)
--   왜: R04 에서 클라우드 결과 행수(40 8,041 · 81 8,239 · 82 16,365)가 사내(2,099 · 2,383 · 2,608)의 4~6배였는데,
--       사내 minyonglee1 의 선택 메저는 LOC 1개, 클라우드 minyonglee1 은 9개(CUST_FCST·MKT_AMT_KRW 포함)였다.
--       조회 행수·시간은 선택 메저 수(특히 고객 축을 가르는 CUST_FCST)에 비례하므로, "느려진 시점" 과 "메저 집합이 바뀐 시점" 을 맞춰 본다.
--   변경 없음: SELECT 만 수행
-- =============================================================================
SET LINESIZE 400
SET PAGESIZE 500
SET TRIMSPOOL ON
SET VERIFY OFF
COLUMN USR FORMAT A14
COLUMN MEASURE_LIST FORMAT A120
COLUMN MSG FORMAT A150
SPOOL R07_MEASURE_SET_HISTORY_OUT.txt

PROMPT ################ [M1] 사용자별 현재 선택 메저 — 메저마다 LAST_UPDATE_DATE (언제 추가·변경됐나) ################
PROMPT --  사내(10-12): minyonglee1 = LOC 1개 (09-29 21:22) · k0101 = 9개 (08-31) · jaeuk.shin = 7개 (08-20)
SELECT USER_ID USR, COLUMN_NAME, SORT_ORDER_NO, TO_CHAR(CREATION_DATE,'MM-DD HH24:MI') CREATED, TO_CHAR(LAST_UPDATE_DATE,'MM-DD HH24:MI') UPDATED, LAST_UPDATED_BY
  FROM SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND USER_INQUIRY_COLUMN_TYPE_CODE='M'
   AND USER_ID IN (SELECT DISTINCT CREATED_BY FROM SCM_COM_SYS_LOG WHERE MNU_ID='DMF0082' AND SHT_NM='FcstNPrice' AND MNU_BTN_CD='SEARCH' AND CREATION_DATE >= TRUNC(SYSDATE)-14)
 ORDER BY USER_ID, SORT_ORDER_NO;

PROMPT ################ [M2] 사용자별 요약 — 메저 수 · CUST/AMT 포함 · 집합이 마지막으로 바뀐 시각 ################
SELECT USER_ID USR, COUNT(*) MEASURES,
       SUM(CASE WHEN UPPER(COLUMN_NAME) LIKE 'CUST%' THEN 1 ELSE 0 END) CUST_SEL,
       SUM(CASE WHEN COLUMN_NAME IN ('MKT_AMT_KRW','MKT_AMT_LOC') THEN 1 ELSE 0 END) AMT_SEL,
       TO_CHAR(MIN(CREATION_DATE),'MM-DD HH24:MI') FIRST_SET, TO_CHAR(MAX(LAST_UPDATE_DATE),'MM-DD HH24:MI') LAST_CHANGED,
       LISTAGG(COLUMN_NAME, ',' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY SORT_ORDER_NO) MEASURE_LIST
  FROM SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND USER_INQUIRY_COLUMN_TYPE_CODE='M'
 GROUP BY USER_ID ORDER BY LAST_CHANGED DESC;

PROMPT ################ [M3] titleSet SAVE 이력 14일 — 누가 언제 메저 집합을 저장했나 (저장 본문 앞 150자) ################
SELECT TO_CHAR(TRNM_ST_DTM,'MM-DD HH24:MI:SS') ST, CREATED_BY USR, REGEXP_SUBSTR(SYS_LOG_MSG_CTN,'"divisionId":"([^"]*)"',1,1,NULL,1) DIV,
       SUBSTR(REGEXP_REPLACE(SYS_LOG_MSG_CTN,'\s+',' '),1,150) MSG
  FROM SCM_COM_SYS_LOG
 WHERE MNU_ID='DMF0082' AND SHT_NM='titleSet' AND MNU_BTN_CD='SAVE' AND CREATION_DATE >= TRUNC(SYSDATE)-14
 ORDER BY TRNM_ST_DTM;
PROMPT --  판정: [M3] 의 저장 시각 직후부터 R02 [C4] 의 그 사용자 FcstNPrice 소요가 뛰면 "메저 추가" 가 원인. 10-06(81 6~9s) 과 10-11(81 31~35s) 사이에 저장이 있는지 본다

PROMPT ################ [M4] 메저 메타 — 81/82 에서 열려 있는 메저 (MKT_AMT 가 81 에 열려 있으면 10-02 금액 arm 이 실제로 돈다) ################
SELECT COLUMN_NAME, DIVISION_ID, VALID_YN, USER_SELECTABLE_FLAG, DEFAULT_FLAG
  FROM SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND VALID_YN='Y'
 ORDER BY DIVISION_ID, COLUMN_NAME;

SPOOL OFF
PROMPT =============================================================================
PROMPT  R07 완료 → R07_MEASURE_SET_HISTORY_OUT.txt 회신
PROMPT  이어서 R04 를 c_user := 'k0101' 로 1회 더 실행해 주세요 (사내 k0101 과 같은 CUST_FCST 포함 조건으로 사내·클라우드 직접 비교)
PROMPT =============================================================================
