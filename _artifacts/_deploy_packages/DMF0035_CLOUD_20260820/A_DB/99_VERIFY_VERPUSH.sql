-- =====================================================================================================
-- 99_VERIFY_VERPUSH.sql — VERPUSH 패치 효과 확인 (SELECT 전용 · 즉시)
--
--   ⚠ **왜 98 로는 안 보이는가**: 98 의 W3/W4 는 `cbxpxq839ydqs` 를 고정으로 본다. 그런데 VERPUSH 로
--     **SQL 텍스트가 바뀌었으므로 SQL_ID 자체가 새로 생긴다**(사내 실측: cbxpxq839ydqs → 6qbykgbmmjr15).
--     즉 98 이 보여준 239.8s·plan 은 **패치 전 문장의 누적치**다(LAST_ACT 22:16 < 배포 22:19:02).
--   ⇒ 여기서는 SQL_ID 를 고정하지 않고 **문장 텍스트로 현재본을 찾아** 판정한다.
--
--   배포 확인은 이미 완료: PKG_DMF0035 LAST_DDL 08-20 22:19:02 / DS2 1 (98 W1).
-- =====================================================================================================
SET LINESIZE 240
SET PAGESIZE 200

PROMPT ===== X1. ⭐ GT_DM35_T_LAST_SETUP_C 적재문 — 현재 커서 목록 (최신이 패치본) =====
SELECT SQL_ID, PLAN_HASH_VALUE, EXECUTIONS EXEC_,
       ROUND(ELAPSED_TIME/GREATEST(EXECUTIONS,1)/1e6,1) ELA_PER_EXEC_S,
       BUFFER_GETS, ROWS_PROCESSED,
       TO_CHAR(FIRST_LOAD_TIME) FIRST_LOAD,
       TO_CHAR(LAST_ACTIVE_TIME,'MM-DD HH24:MI') LAST_ACT,
       CASE WHEN UPPER(SQL_FULLTEXT) LIKE '%GT_DM35_VERSION)%' THEN 'VERPUSH본' ELSE '구본' END AS GEN
  FROM V$SQL
 WHERE UPPER(SQL_TEXT) LIKE 'INSERT INTO%GT_DM35_T_LAST_SETUP_C%'
 ORDER BY LAST_ACTIVE_TIME DESC FETCH FIRST 10 ROWS ONLY;
--  ⇒ `GEN='VERPUSH본'` 행이 패치 후 문장이다. 그 행의 ELA_PER_EXEC_S 가 실제 효과.

PROMPT ===== X2. ⭐⭐ VERSION_NO 가 access predicate 로 승격됐는가 (핵심 판정) =====
SELECT P.SQL_ID, P.PLAN_HASH_VALUE, P.OBJECT_NAME,
       SUBSTR(P.ACCESS_PREDICATES, 1, 120) ACCESS_PRED,
       CASE WHEN UPPER(P.ACCESS_PREDICATES) LIKE '%VERSION_NO%' THEN 'PASS (승격됨)'
            ELSE '*** FAIL — DIVISION_ID 단독 (효과 없음) ***' END VERDICT
  FROM V$SQL_PLAN P
 WHERE P.SQL_ID IN (SELECT SQL_ID FROM V$SQL
                     WHERE UPPER(SQL_TEXT) LIKE 'INSERT INTO%GT_DM35_T_LAST_SETUP_C%'
                       AND UPPER(SQL_FULLTEXT) LIKE '%GT_DM35_VERSION)%')
   AND P.OPERATION = 'INDEX' AND P.OPTIONS LIKE 'RANGE%'
 ORDER BY P.SQL_ID, P.ID;
--  PK 는 (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, ...) 이므로 access 에 VERSION_NO 가 붙어야 범위가 좁아진다.
--  FAIL 이면 옵티마이저가 semi-join 을 해시로 풀어 승격이 안 된 것 → 힌트로 고정하는 다음 수가 필요하다.

PROMPT ===== X3. 패치본의 대형표 접근 추정 행수 (구본 대비) =====
--  구본(클라우드 실측): MKT_FCST_C 586,715 / CFM_..._C 344,105 / RESULT_C 367,523 ≈ 130만
SELECT P.OBJECT_NAME, P.OPERATION || ' ' || P.OPTIONS OP, P.CARDINALITY, P.COST
  FROM V$SQL_PLAN P
 WHERE P.SQL_ID IN (SELECT SQL_ID FROM V$SQL
                     WHERE UPPER(SQL_TEXT) LIKE 'INSERT INTO%GT_DM35_T_LAST_SETUP_C%'
                       AND UPPER(SQL_FULLTEXT) LIKE '%GT_DM35_VERSION)%')
   AND P.OBJECT_NAME IN ('DM_PLN_MKT_FCST_C','DM_PLN_CFM_MKT_DEMAND_PLAN_C','DM_PLN_MKT_FCST_RESULT_C',
                         'PK_DM_PLN_MKT_FCST_C_PART','PK_DM_PLN_CFM_MKT_DEMAND_PLAN_C_PART',
                         'PK_DM_PLN_MKT_FCST_RESULT_C_PART')
 ORDER BY P.SQL_ID, P.ID;

PROMPT ===== X4. 조회 전체 소요 — 화면 호출 기준 (최근 30분) =====
SELECT LOG_SEQ, ROUND(ELAPSED_MS/1000,1) ELA_S, TO_CHAR(EXECUTE_TIME,'HH24:MI:SS') T,
       SUBSTR(REGEXP_SUBSTR(DBMS_LOB.SUBSTR(PARAMS,4000,1), '"procExec":"\{call ([A-Z0-9_.]+)', 1, 1, NULL, 1), 1, 60) PROC
  FROM SCM_MGR.SCM_COM_SQL_LOG
 WHERE SQL_ID = 'com.lgcns.nscm.callProc' AND EXECUTE_TIME > SYSDATE - 30/1440
 ORDER BY EXECUTE_TIME DESC FETCH FIRST 8 ROWS ONLY;

PROMPT ===== X5. 지금 실행 중인 문장 (아직 스피너면) =====
SELECT S.SID, S.SERIAL#, S.LAST_CALL_ET RUNNING_SEC, S.EVENT, S.SQL_ID,
       SUBSTR(Q.SQL_TEXT, 1, 90) SQL_HEAD
  FROM V$SESSION S LEFT JOIN V$SQL Q ON Q.SQL_ID=S.SQL_ID AND Q.CHILD_NUMBER=S.SQL_CHILD_NUMBER
 WHERE S.STATUS='ACTIVE' AND S.USERNAME IN ('SCMP_APP','SCMD_APP')
 ORDER BY S.LAST_CALL_ET DESC FETCH FIRST 5 ROWS ONLY;

PROMPT ===== 판독 =====
PROMPT   X1 에 'VERPUSH본' 행이 없다   → 패치 후 아직 조회를 안 한 것. 화면에서 1회 조회 후 재실행
PROMPT   X2 PASS + X3 카디널리티 급감 → 의도대로 동작. X1 의 ELA_PER_EXEC_S 가 최종 성적
PROMPT   X2 FAIL                      → 승격 실패. 힌트 고정(다음 패치)이 필요하니 X2/X3 결과를 보내줄 것
PROMPT   X5 에 다른 SQL_ID 가 오래 돈다 → 병목 이동(사내에서는 GT_DM35_RAW_DATA 적재가 다음 1위였음)
