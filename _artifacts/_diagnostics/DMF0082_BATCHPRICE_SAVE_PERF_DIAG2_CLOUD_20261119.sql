-- =============================================================================
-- DMF0082_BATCHPRICE_SAVE_PERF_DIAG2_CLOUD_20261119.sql
--   1차 점검(DMF0082_BATCHPRICE_SAVE_PERF_DIAG_CLOUD_20261119.sql) 후속.
--   병목 문장 PKG_DMF0082 BODY 라인 24890 (sql_id 7f0qhkutuh6dm, 검증 5. Site/Item Master Valid)
--   의 운영 실행계획과, 계획을 가르는 두 테이블의 인덱스·통계를 확인함.
--   조회만 함. 변경 없음. 계정 SCM_MGR. 전체 F5 실행 가능.
--
--   사내(ZIOUI1) 대조값 2026-11-19
--     계획 = FILTER → SCM_ITEM_M(IX_SCM_ITEM_M_FBI01) + SCM_MST_SITE_ITEM(IDX04) 인덱스 NESTED LOOPS SEMI
--     FP_MGR.SCM_ITEM_M 796,166행 30,272블록 / SCM_MST_SITE_ITEM 129,498행 4,014블록
--     45,495행 저장 전 구간(■8 까지) 41.0초, 이 문장 1초 이내
-- =============================================================================
SET LINESIZE 300
SET PAGESIZE 500
SET TRIMSPOOL ON
SET FEEDBACK ON
COLUMN PLAN_TABLE_OUTPUT FORMAT A200
COLUMN COLS FORMAT A120

SPOOL DMF0082_BATCHPRICE_SAVE_PERF_DIAG2.txt

PROMPT ############################################################
PROMPT [1] 병목 문장 커서 상태 (아직 실행 중이면 EXECUTIONS 0, LAST_ACTIVE 갱신)
PROMPT ############################################################
SELECT INST_ID, CHILD_NUMBER, PLAN_HASH_VALUE, EXECUTIONS, ROUND(ELAPSED_TIME/1e6,1) AS ELA_SEC
     , BUFFER_GETS, ROWS_PROCESSED, OPTIMIZER_ENV_HASH_VALUE
     , TO_CHAR(LAST_ACTIVE_TIME,'MM-DD HH24:MI:SS') AS LAST_ACTIVE
  FROM GV$SQL
 WHERE SQL_ID = '7f0qhkutuh6dm';

PROMPT ############################################################
PROMPT [2] 실행 중 세션 (남아 있으면 BE TIMEOUT 뒤에도 DB 가 계속 도는 것임)
PROMPT ############################################################
SELECT INST_ID, SID, SERIAL#, USERNAME, MODULE, SQL_ID, LAST_CALL_ET, EVENT
  FROM GV$SESSION
 WHERE SQL_ID = '7f0qhkutuh6dm' OR PREV_SQL_ID = '7f0qhkutuh6dm';

PROMPT ############################################################
PROMPT [3] 운영 실행계획 (커서 캐시) - 계획 라인 5, 6, 7 이 무엇인지 확인
PROMPT ############################################################
SELECT P.PLAN_TABLE_OUTPUT
  FROM ( SELECT DISTINCT INST_ID, CHILD_NUMBER FROM GV$SQL WHERE SQL_ID = '7f0qhkutuh6dm' ) S
     , TABLE(DBMS_XPLAN.DISPLAY_CURSOR('7f0qhkutuh6dm', S.CHILD_NUMBER, 'TYPICAL +OUTLINE')) P
 WHERE S.INST_ID = SYS_CONTEXT('USERENV','INSTANCE');

PROMPT [3-B] 다른 인스턴스에 있는 커서 계획 (RAC 2노드)
SELECT INST_ID, CHILD_NUMBER, ID, PARENT_ID, LPAD(' ', DEPTH) || OPERATION || ' ' || OPTIONS AS OP
     , OBJECT_OWNER || '.' || OBJECT_NAME AS OBJ, CARDINALITY, COST
  FROM GV$SQL_PLAN
 WHERE SQL_ID = '7f0qhkutuh6dm'
 ORDER BY INST_ID, CHILD_NUMBER, ID;

PROMPT ############################################################
PROMPT [4] 이 세션의 옵티마이저 설정 (저장 프로시저는 시작 시 dynamic_sampling=2 로 바꿈)
PROMPT ############################################################
SELECT E.INST_ID, E.CHILD_NUMBER, E.NAME, E.VALUE
  FROM GV$SQL_OPTIMIZER_ENV E
 WHERE E.SQL_ID = '7f0qhkutuh6dm'
   AND E.NAME IN ('optimizer_dynamic_sampling','optimizer_adaptive_plans','optimizer_features_enable'
                 ,'_optimizer_use_feedback','optimizer_mode','_fix_control')
 ORDER BY E.INST_ID, E.CHILD_NUMBER, E.NAME;

PROMPT ############################################################
PROMPT [5] 두 테이블 통계와 인덱스 (사내와 대조)
PROMPT ############################################################
SELECT OWNER, TABLE_NAME, NUM_ROWS, BLOCKS, TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD') AS LAST_ANALYZED, PARTITIONED
  FROM DBA_TABLES
 WHERE (OWNER, TABLE_NAME) IN (('FP_MGR','SCM_ITEM_M'), ('SCM_MGR','SCM_MST_SITE_ITEM'));

SELECT I.TABLE_OWNER, I.TABLE_NAME, I.INDEX_NAME, I.INDEX_TYPE, I.STATUS, I.VISIBILITY
     , I.NUM_ROWS, I.DISTINCT_KEYS, I.CLUSTERING_FACTOR
     , ( SELECT LISTAGG(C.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY C.COLUMN_POSITION)
           FROM DBA_IND_COLUMNS C WHERE C.INDEX_OWNER = I.OWNER AND C.INDEX_NAME = I.INDEX_NAME ) AS COLS
  FROM DBA_INDEXES I
 WHERE (I.TABLE_OWNER, I.TABLE_NAME) IN (('FP_MGR','SCM_ITEM_M'), ('SCM_MGR','SCM_MST_SITE_ITEM'))
 ORDER BY I.TABLE_NAME, I.INDEX_NAME;

PROMPT [5-B] 함수 기반 인덱스 식 (사내 IX_SCM_ITEM_M_FBI01 = DIVISION_ID, SUBSTR(ITEM_ID,1,12) 계열)
SELECT INDEX_OWNER, INDEX_NAME, COLUMN_POSITION, COLUMN_EXPRESSION
  FROM DBA_IND_EXPRESSIONS
 WHERE TABLE_OWNER = 'FP_MGR' AND TABLE_NAME = 'SCM_ITEM_M';

PROMPT [5-C] SCM_ITEM_M 제약·가상 컬럼 (SUBSTR(ITEM_ID,1,12) 술어가 생기는 근거)
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, STATUS, VALIDATED, SEARCH_CONDITION_VC
  FROM DBA_CONSTRAINTS
 WHERE OWNER = 'FP_MGR' AND TABLE_NAME = 'SCM_ITEM_M' AND CONSTRAINT_TYPE IN ('C','P','U');

SELECT COLUMN_NAME, VIRTUAL_COLUMN, HIDDEN_COLUMN, DATA_DEFAULT
  FROM DBA_TAB_COLS
 WHERE OWNER = 'FP_MGR' AND TABLE_NAME = 'SCM_ITEM_M' AND (VIRTUAL_COLUMN = 'YES' OR HIDDEN_COLUMN = 'YES');

PROMPT ############################################################
PROMPT [6] SCM_MST_ITEM_SN 시노님 대상 (사내 = FP_MGR.SCM_ITEM_M)
PROMPT ############################################################
SELECT OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME, DB_LINK
  FROM DBA_SYNONYMS
 WHERE SYNONYM_NAME IN ('SCM_MST_ITEM_SN','SCM_ITEM_M_SN');

SPOOL OFF
