-- 사용자 1명 기준 전 화면 오류 내역 (클라우드 LIVE 에서 전체 F5)
-- 조회만 함. 대상 사용자는 각 블록 P 의 'regina28', 기간은 SYSDATE - 30 을 바꿈

-- [1] 화면별 오류 건수
--   화면에 'Sql Error' 등 오류가 뜬 요청을 화면, 시트, 버튼 단위로 셈
WITH P AS (SELECT 'regina28' AS U, SYSDATE - 30 AS FR FROM DUAL)
SELECT L.MNU_ID
     , L.MENU_DESCRIPTION
     , L.SHT_NM                                                  AS SHEET
     , L.MNU_BTN_CD                                              AS BUTTON
     , COUNT(*)                                                  AS ERR_CNT
     , TO_CHAR(MIN(L.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS')    AS FIRST_AT
     , TO_CHAR(MAX(L.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS')    AS LAST_AT
     , MAX(SUBSTR(L.EXCT_MSG_CTN, 1, 300))                       AS ORA_MSG_SAMPLE
  FROM SCM_MGR.SCM_COM_SYS_LOG L, P
 WHERE L.CREATED_BY = P.U
   AND L.CREATION_DATE >= P.FR
   AND LENGTH(TRIM(L.EXCT_MSG_CTN)) > 0
 GROUP BY L.MNU_ID, L.MENU_DESCRIPTION, L.SHT_NM, L.MNU_BTN_CD
 ORDER BY LAST_AT DESC;

-- [2] 오류 요청 상세 (최근 100건)
--   ORA_MSG = 오류 원문. SENT_VALUES = 화면이 보낸 조회, 저장 값
WITH P AS (SELECT 'regina28' AS U, SYSDATE - 30 AS FR FROM DUAL)
SELECT *
  FROM (
        SELECT TO_CHAR(L.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') AS ERR_AT
             , L.MNU_ID
             , L.SHT_NM                                          AS SHEET
             , L.MNU_BTN_CD                                      AS BUTTON
             , L.CALL_PGM_URL
             , L.EXCT_MSG_CTN                                    AS ORA_MSG
             , SUBSTR(L.SYS_LOG_MSG_CTN, 1, 2000)                AS SENT_VALUES
          FROM SCM_MGR.SCM_COM_SYS_LOG L, P
         WHERE L.CREATED_BY = P.U
           AND L.CREATION_DATE >= P.FR
           AND LENGTH(TRIM(L.EXCT_MSG_CTN)) > 0
         ORDER BY L.CREATION_DATE DESC
       )
 WHERE ROWNUM <= 100;

-- [3] 같은 사용자의 전체 요청 순서 (오류 앞뒤로 무엇을 했는지. 최근 7일, 최근 300건)
--   ERR_YN = Y 인 행 앞뒤 행을 봄. 저장 직후 조회 오류인지 등
WITH P AS (SELECT 'regina28' AS U, SYSDATE - 7 AS FR FROM DUAL)
SELECT *
  FROM (
        SELECT TO_CHAR(L.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS')                AS REQ_AT
             , L.LOG_TP_CD
             , L.MNU_ID
             , L.SHT_NM                                                         AS SHEET
             , L.MNU_BTN_CD                                                     AS BUTTON
             , CASE WHEN LENGTH(TRIM(L.EXCT_MSG_CTN)) > 0 THEN 'Y' ELSE 'N' END  AS ERR_YN
             , SUBSTR(L.EXCT_MSG_CTN, 1, 200)                                   AS ORA_MSG
          FROM SCM_MGR.SCM_COM_SYS_LOG L, P
         WHERE L.CREATED_BY = P.U
           AND L.CREATION_DATE >= P.FR
         ORDER BY L.CREATION_DATE DESC
       )
 WHERE ROWNUM <= 300;

-- [4] 저장 SP 가 남긴 오류, 검증 실패 (저장 SP 는 사용자 ID 로 로그를 남김)
--   SQL_BACKTRACE 의 'line 숫자' = PKG 몇 번째 줄에서 실패했는지
--   FAIL-2 행 = 검증 실패. 화면에는 DESCRIPTION 문구가 뜸
--   조회 SP 오류는 사용자 ID 없이 scm_batch 로 남아 여기 안 나옴. [2] 로 봄
WITH P AS (SELECT 'regina28' AS U, SYSDATE - 30 AS FR FROM DUAL)
SELECT TO_CHAR(B.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') AS ERR_AT
     , B.PROGRAM_NAME
     , B.LOG_TYPE
     , B.LOG_MESSAGE
     , B.SQL_ERR_CODE
     , B.SQL_ERR_MSG
     , B.SQL_BACKTRACE
     , SUBSTR(B.DESCRIPTION, 1, 500)                     AS DESCRIPTION
  FROM SCM_MGR.SCM_SYS_LOG_BATCH B, P
 WHERE B.CREATED_BY = P.U
   AND B.CREATION_DATE >= P.FR
   AND (   B.LOG_TYPE IN ('ERROR','E')
        OR B.SQL_ERR_MSG IS NOT NULL
        OR B.LOG_MESSAGE LIKE '%FAIL%')
 ORDER BY B.CREATION_DATE DESC;

-- [5] BE SQL 로그의 오류 호출문 (값이 채워진 실제 호출문. 최근 LOG_SEQ 200000행 범위)
--   찾는 오류가 안 나오면 200000 을 늘림. K 의 ROWNUM > 0 은 지우지 않음(지우면 전체 PARAMS 를 읽어 오래 걸림)
WITH P AS (SELECT 'regina28' AS U, MAX(LOG_SEQ) - 200000 AS P_SEQ FROM SCM_MGR.SCM_COM_SQL_LOG)
   , K AS (SELECT X.LOG_SEQ
             FROM SCM_MGR.SCM_COM_SQL_LOG X, P
            WHERE X.LOG_SEQ >= P.P_SEQ
              AND X.CREATED_BY = P.U
              AND X.EXCEPTION IS NOT NULL
              AND ROWNUM > 0)
SELECT *
  FROM (
        SELECT S.LOG_SEQ
             , S.EXECUTE_TIME
             , S.SQL_ID
             , S.ELAPSED_MS
             , DBMS_LOB.SUBSTR(S.EXCEPTION, 2000, 1) AS EXCEPTION_MSG
             , DBMS_LOB.SUBSTR(S.SQL_TEXT, 3000, 1)  AS CALL_TEXT
          FROM K
          JOIN SCM_MGR.SCM_COM_SQL_LOG S
            ON S.LOG_SEQ = K.LOG_SEQ
         ORDER BY S.LOG_SEQ DESC
       )
 WHERE ROWNUM <= 50;
