/*=============================================================================================================
 * DMF0082 저장 로그 → payload.json 추출 (Oracle SQL Developer · F5 스크립트 실행)
 *   원천 = SCM_MGR.SCM_COM_SQL_LOG.PARAMS  (BE 가 call-proc 실행 시 남긴 파라미터 JSON = 저장 페이로드 그대로)
 *   결과 = SPOOL 경로의 payload.json → Make-Dmf0082ReplaySql.ps1 -InputJson 에 그대로 사용
 *
 * 사용 순서
 *   1) [A] 를 실행해 어느 건인지 고른다 (최근 1건이면 생략 가능)
 *   2) 특정 건이면 [B] 의 &&RID 에 [A] 의 RID 값을 넣고, 아니면 그대로 둔다 (빈값 = 최근 1건)
 *   3) [B] 전체를 선택하고 F5 → D:\Downloads\Source\DMF0082_REPLAY\payload.json 생성
 *   ⚠ TRUNCATED_YN='Y' 인 건은 BE 가 4,000자에서 잘라 저장한 것이라 payload 로 쓸 수 없다 (생성기가 거부).
 *     그 건은 저장 당시 DevTools Payload 로만 복원 가능.
 *=============================================================================================================*/

-- [A] 최근 DMF0082 저장 호출 목록 (최신순)
SELECT  ROWIDTOCHAR(L.ROWID)                               AS RID
      , TO_CHAR(L.EXECUTE_TIME,'YYYY-MM-DD HH24:MI:SS')    AS EXECUTE_TIME
      , L.ELAPSED_MS
      , L.CREATED_BY
      , L.RESULT_COUNT
      , DBMS_LOB.SUBSTR(L.EXCEPTION, 200, 1)               AS EXCEPTION_HEAD
      , DBMS_LOB.GETLENGTH(L.PARAMS)                       AS PARAMS_LEN
      , CASE WHEN DBMS_LOB.INSTR(L.PARAMS, '(truncated') > 0 THEN 'Y' ELSE 'N' END AS TRUNCATED_YN
      , REGEXP_COUNT(DBMS_LOB.SUBSTR(L.PARAMS, 4000, 1), '\^') AS CARET_CNT   -- 대략적 행수 지표
      , DBMS_LOB.SUBSTR(L.PARAMS, 200, 1)                  AS PARAMS_HEAD
FROM    SCM_MGR.SCM_COM_SQL_LOG L
WHERE   L.EXECUTE_TIME >= SYSDATE - 7
AND     L.SQL_ID = 'com.lgcns.nscm.callProc'
AND     L.LOG_SEQ >= (SELECT MAX(LOG_SEQ) FROM SCM_MGR.SCM_COM_SQL_LOG) - 500000   -- PK 범위 선필터(EXECUTE_TIME 인덱스 없음 · 1.2M행 전수 CLOB 검사 회피)
AND     DBMS_LOB.INSTR(UPPER(L.PARAMS), 'P_DMF0082_SAVE_MAIN_DATA') > 0
ORDER BY L.EXECUTE_TIME DESC;


-- [B] payload.json 생성 — 아래 블록 전체 선택 후 F5
SET DEFINE ON
DEFINE RID = ''                                   -- 예: DEFINE RID = 'AAAbCdAAEAAAAgvAAB'  (빈값 = 최근 1건)
SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF
SET PAGESIZE 0
SET LINESIZE 32767
SET LONG 2000000
SET LONGCHUNKSIZE 32767
SET TRIMSPOOL ON
SET TRIMOUT ON
SPOOL D:\Downloads\Source\DMF0082_REPLAY\payload.json
SELECT  L.PARAMS
FROM    SCM_MGR.SCM_COM_SQL_LOG L
WHERE   L.ROWID = (
            SELECT CASE WHEN '&&RID' IS NOT NULL THEN CHARTOROWID('&&RID')
                        ELSE ( SELECT MAX(X.ROWID) KEEP (DENSE_RANK FIRST ORDER BY X.EXECUTE_TIME DESC)
                               FROM   SCM_MGR.SCM_COM_SQL_LOG X
                               WHERE  X.EXECUTE_TIME >= SYSDATE - 7
                               AND    X.SQL_ID = 'com.lgcns.nscm.callProc'
                               AND    X.LOG_SEQ >= (SELECT MAX(LOG_SEQ) FROM SCM_MGR.SCM_COM_SQL_LOG) - 500000   -- PK 범위 선필터(EXECUTE_TIME 인덱스 없음 · 1.2M행 전수 CLOB 검사 회피)
                               AND    DBMS_LOB.INSTR(UPPER(X.PARAMS), 'P_DMF0082_SAVE_MAIN_DATA') > 0 )
                   END
            FROM DUAL );
SPOOL OFF
SET HEADING ON
SET FEEDBACK ON
SET PAGESIZE 50
UNDEFINE RID

-- [C] 생성 직후 확인용 (화면 출력) — 선택한 건의 메타 + 절단 여부
SELECT  TO_CHAR(L.EXECUTE_TIME,'YYYY-MM-DD HH24:MI:SS') AS EXECUTE_TIME, L.CREATED_BY, L.ELAPSED_MS
      , DBMS_LOB.GETLENGTH(L.PARAMS) AS PARAMS_LEN
      , CASE WHEN DBMS_LOB.INSTR(L.PARAMS, '(truncated') > 0 THEN 'Y (payload 사용 불가)' ELSE 'N (사용 가능)' END AS TRUNCATED
FROM    SCM_MGR.SCM_COM_SQL_LOG L
WHERE   L.EXECUTE_TIME >= SYSDATE - 7
AND     L.SQL_ID = 'com.lgcns.nscm.callProc'
AND     L.LOG_SEQ >= (SELECT MAX(LOG_SEQ) FROM SCM_MGR.SCM_COM_SQL_LOG) - 500000   -- PK 범위 선필터(EXECUTE_TIME 인덱스 없음 · 1.2M행 전수 CLOB 검사 회피)
AND     DBMS_LOB.INSTR(UPPER(L.PARAMS), 'P_DMF0082_SAVE_MAIN_DATA') > 0
ORDER BY L.EXECUTE_TIME DESC
FETCH FIRST 1 ROWS ONLY;
