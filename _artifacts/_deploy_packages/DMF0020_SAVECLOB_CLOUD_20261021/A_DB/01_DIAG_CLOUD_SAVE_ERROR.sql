/*=============================================================================================================
 * 01_DIAG_CLOUD_SAVE_ERROR — DMF0020 Batch Price Input 대량 저장 "SQL ERROR" 원인 판정 (조회 전용 · 데이터 변경 없음)
 *   실행: SQL Developer 에서 SCM_MGR 로 접속 → 전체 선택 → F5 (스크립트 실행)
 *   특정 건을 보려면 아래 DEFINE LOG_SEQ 에 [D4] 의 LOG_SEQ 를 넣는다. 빈값 = 가장 최근 DMF0020 저장 호출 1건.
 *
 * 판정표 — 어느 섹션에 무엇이 나오면 어떤 원인인가
 * ┌──────────────────────────────────────────────────────┬──────────────────────────────────────────────┐
 * │ 결과                                                  │ 원인                                          │
 * ├──────────────────────────────────────────────────────┼──────────────────────────────────────────────┤
 * │ [D5] 어느 파라미터든 LEN > 32767 → "32K 초과"         │ ① IN VARCHAR2 한도 — 패치 대상 (확정)          │
 * │ [D4] EXCEPTION 에 ORA-06502 / ORA-01460 / ORA-03120   │   (SP 로그 [D3] 에는 아무것도 안 남는 게 정상 — │
 * │      / ORA-22835 / ORA-40478 / "String index"         │    SP 본문 진입 전에 실패)                      │
 * ├──────────────────────────────────────────────────────┼──────────────────────────────────────────────┤
 * │ [D3] START 만 있고 END/ERROR 없음 · [D4] ELAPSED_MS 큼 │ ② 분할 O(N^2) 지연 → BE/게이트웨이 타임아웃     │
 * │      / EXCEPTION 에 timeout · cancel · ORA-01013       │   — 패치 대상 (확정)                           │
 * │ [D6] 지금 PKG_DMF0020 이 오래 실행 중                  │                                              │
 * ├──────────────────────────────────────────────────────┼──────────────────────────────────────────────┤
 * │ [D3] ERROR 행 SQL_ERR_MSG 에 그 밖의 ORA-              │ ③ SP 내부 오류 — SQL_ERR_MSG·BACKTRACE 회신    │
 * │      (예: ORA-00001 PK_SCM_MST_FUTURE_PRICE_H)          │   (ORA-00001 = 이력 SEQ 별건, 10-12 사례)      │
 * ├──────────────────────────────────────────────────────┼──────────────────────────────────────────────┤
 * │ [D3] INVALID 행 · 화면에 '-1' 메시지                   │ ④ 저장 검증 거부(SQL 오류 아님) — DESCRIPTION  │
 * ├──────────────────────────────────────────────────────┼──────────────────────────────────────────────┤
 * │ [D0] ARG DATA_TYPE = CLOB 인데 [D1] PROC_M = VARCHAR   │ ⑤ 패치 반쪽 적용 — 10 재실행 또는 회신          │
 * └──────────────────────────────────────────────────────┴──────────────────────────────────────────────┘
 *   결과 전체(스크립트 출력 창)를 회신해 주세요.
 *=============================================================================================================*/
SET DEFINE ON
DEFINE LOG_SEQ = ''
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 300
SET PAGESIZE 500
SET VERIFY OFF
SET FEEDBACK ON

-- [D0] 환경 · 객체 상태 · 저장 프로시저 입력 타입 (VARCHAR2 = 미패치 · CLOB = 패치됨)
SELECT 'D0 env' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','CON_NAME') CON_NAME, USER USR, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'D0 object' CHK, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_DMF0020' ORDER BY OBJECT_TYPE;
SELECT 'D0 args' CHK, OBJECT_NAME, DATA_TYPE, COUNT(*) N
  FROM ALL_ARGUMENTS
 WHERE OWNER = 'SCM_MGR' AND PACKAGE_NAME = 'PKG_DMF0020' AND IN_OUT = 'IN'
   AND OBJECT_NAME IN ('P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL', 'P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP')
 GROUP BY OBJECT_NAME, DATA_TYPE ORDER BY 2, 3;
SELECT 'D0 patch' CHK, COUNT(*) MARKER_LINES, CASE WHEN COUNT(*) = 0 THEN 'not applied' ELSE 'applied' END JUDGE
  FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_DMF0020' AND TEXT LIKE '%E20261021-DMF0020SAVECLOB%';

-- [D1] BE 바인딩 메타 (DATA_TP_CD VARCHAR → jdbcType=VARCHAR · CLOB → jdbcType=CLOB)
SELECT 'D1 PROC_M' CHK, PROC_NM, COL_TP_CD, DATA_TP_CD, COUNT(*) N, TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI') LAST_UPD
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM IN ('PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL', 'PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP')
 GROUP BY PROC_NM, COL_TP_CD, DATA_TP_CD ORDER BY 2, 3, 4;

-- [D2] 화면 버튼 배선 (모달 저장 = sheet 'main' SAVE → _ALL · Range 팝업 재저장 = 'priceBatch' SAVE → _POPUP)
SELECT 'D2 wiring' CHK, M.MNU_ID, M.SHT_NM, M.MNU_BTN_CD, A.API_URL, M.USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M M JOIN SCM_MGR.SCM_ADM_API_M A ON A.API_ID = M.API_ID
 WHERE M.MNU_ID = 'DMF0020' AND M.MNU_BTN_CD = 'SAVE' ORDER BY M.SHT_NM;

-- [D3] SP 로그 (최근 3일) — START 별 짝(END/ERROR/INVALID)과 소요, 오류 메시지
--      로그 테이블에 인덱스가 없어 한 번만 읽고(R) 창 함수로 START 묶음을 만든다. 같은 프로그램을 여러 명이 동시에 저장하면 짝이 섞일 수 있다.
WITH R AS (
    SELECT B.PROGRAM_NAME, B.LOG_TYPE, B.CREATION_DATE, B.CREATED_BY, B.DESCRIPTION, B.SQL_ERR_CODE, B.SQL_ERR_MSG, B.SQL_BACKTRACE
         , CASE B.LOG_TYPE WHEN 'START' THEN 0 WHEN 'ERROR' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END ORD
      FROM SCM_MGR.SCM_SYS_LOG_BATCH B
     WHERE B.CREATION_DATE >= SYSDATE - 3
       AND ( B.PROGRAM_NAME LIKE '%SAVE_SCM_MST_FUTURE_PRICE_ALL%' OR B.PROGRAM_NAME LIKE '%SAVE_SCM_MST_FUTURE_PRICE_POPUP%' )
), G AS (
    SELECT R.*, SUM(CASE WHEN R.LOG_TYPE = 'START' THEN 1 ELSE 0 END) OVER (PARTITION BY R.PROGRAM_NAME ORDER BY R.CREATION_DATE, R.ORD ROWS UNBOUNDED PRECEDING) GRP
      FROM R
), K AS (
    SELECT G.PROGRAM_NAME, G.GRP
         , MIN(CASE WHEN G.LOG_TYPE = 'START' THEN G.CREATION_DATE END) START_AT
         , MAX(CASE WHEN G.LOG_TYPE = 'START' THEN G.CREATED_BY END) START_BY
         , MIN(CASE WHEN G.LOG_TYPE <> 'START' THEN G.ORD END) FIN_ORD
         , MAX(CASE WHEN G.LOG_TYPE <> 'START' THEN G.CREATION_DATE END) FIN_AT
      FROM G GROUP BY G.PROGRAM_NAME, G.GRP
)
SELECT 'D3 sp-log' CHK
     , TO_CHAR(K.START_AT, 'MM-DD HH24:MI:SS') START_AT
     , K.START_BY
     , K.PROGRAM_NAME
     , CASE K.FIN_ORD WHEN 1 THEN 'ERROR' WHEN 2 THEN 'INVALID' WHEN 3 THEN 'END' ELSE '** END 없음 (중단/타임아웃 의심) **' END FINISH
     , ROUND((K.FIN_AT - K.START_AT) * 86400) SEC
     , SUBSTR(X.DESCRIPTION, 1, 200) DESCRIPTION
     , X.SQL_ERR_CODE
     , SUBSTR(X.SQL_ERR_MSG, 1, 300) SQL_ERR_MSG
     , SUBSTR(X.SQL_BACKTRACE, 1, 300) BACKTRACE
  FROM K
  LEFT JOIN G X ON X.PROGRAM_NAME = K.PROGRAM_NAME AND X.GRP = K.GRP AND X.LOG_TYPE <> 'START' AND X.ORD = K.FIN_ORD
 WHERE K.START_AT IS NOT NULL
 ORDER BY K.START_AT DESC
 FETCH FIRST 30 ROWS ONLY;

-- [D4] BE 로그 (최근 LOG_SEQ 30만 건 PK 범위 · 시간 전수 스캔 없음) — DMF0020 저장 호출 · 소요 · 페이로드 크기 · BE 예외
SELECT 'D4 be-log' CHK
     , L.LOG_SEQ
     , TO_CHAR(L.EXECUTE_TIME, 'MM-DD HH24:MI:SS') EXEC_AT
     , L.CREATED_BY
     , L.ELAPSED_MS
     , CASE WHEN DBMS_LOB.SUBSTR(L.SQL_TEXT, 120, 1) LIKE '%_POPUP(%' THEN '_POPUP' ELSE '_ALL' END PROC
     , DBMS_LOB.GETLENGTH(L.PARAMS) PARAMS_LEN
     , CASE WHEN DBMS_LOB.INSTR(L.PARAMS, '(truncated') > 0 THEN 'Y' ELSE 'N' END TRUNC
     , CASE WHEN L.EXCEPTION IS NULL THEN 'OK' ELSE 'EXCEPTION' END RESULT
     , DBMS_LOB.SUBSTR(L.EXCEPTION, 1000, 1) EXCEPTION_HEAD
  FROM SCM_MGR.SCM_COM_SQL_LOG L
 WHERE L.LOG_SEQ >= (SELECT MAX(LOG_SEQ) FROM SCM_MGR.SCM_COM_SQL_LOG) - 300000
   AND L.SQL_ID = 'com.lgcns.nscm.callProc'
   AND DBMS_LOB.SUBSTR(L.SQL_TEXT, 120, 1) LIKE '{call PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_%'   -- 호출문 앞부분만 (PARAMS 전체 검색 금지 — 대용량 CLOB)
 ORDER BY L.LOG_SEQ DESC
 FETCH FIRST 20 ROWS ONLY;

-- [D5] 선택 건 페이로드 파라미터별 길이 · 행 수 — 32,767 초과 여부 (원인 ① 판정)
DECLARE
    v_seq    NUMBER := TO_NUMBER(NULLIF('&&LOG_SEQ', ''));
    v_params CLOB;
    v_exc    VARCHAR2(4000);
    v_at     VARCHAR2(30);
    v_user   VARCHAR2(200);
    v_ms     NUMBER;
    v_obj    JSON_OBJECT_T;
    v_keys   JSON_KEY_LIST;
    v_val    CLOB;
    v_len    NUMBER;
    v_max    NUMBER := 0;
    v_rows   NUMBER;
    v_over   PLS_INTEGER := 0;
    v_lo     NUMBER;
BEGIN
    SELECT MAX(LOG_SEQ) - 300000 INTO v_lo FROM SCM_MGR.SCM_COM_SQL_LOG;
    BEGIN
        SELECT PARAMS, DBMS_LOB.SUBSTR(EXCEPTION, 4000, 1), TO_CHAR(EXECUTE_TIME, 'YYYY-MM-DD HH24:MI:SS'), CREATED_BY, ELAPSED_MS, LOG_SEQ
          INTO v_params, v_exc, v_at, v_user, v_ms, v_seq
          FROM ( SELECT L.* FROM SCM_MGR.SCM_COM_SQL_LOG L
                  WHERE L.LOG_SEQ >= CASE WHEN v_seq IS NOT NULL THEN v_seq ELSE v_lo END
                    AND (v_seq IS NULL OR L.LOG_SEQ = v_seq)
                    AND L.SQL_ID = 'com.lgcns.nscm.callProc'
                    AND DBMS_LOB.SUBSTR(L.SQL_TEXT, 120, 1) LIKE '{call PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_%'
                  ORDER BY L.LOG_SEQ DESC )
         WHERE ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('D5 대상 BE 로그 없음 (최근 30만 건 안에 DMF0020 저장 호출 없음 · LOG_SEQ 지정 시 그 번호 확인)');
        RETURN;
    END;
    DBMS_OUTPUT.PUT_LINE('D5 LOG_SEQ=' || v_seq || ' · ' || v_at || ' · ' || v_user || ' · ' || v_ms || 'ms · PARAMS ' || DBMS_LOB.GETLENGTH(v_params) || '자');
    DBMS_OUTPUT.PUT_LINE('D5 EXCEPTION=' || NVL(SUBSTR(v_exc, 1, 1500), '(없음)'));
    IF DBMS_LOB.INSTR(v_params, '(truncated') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('D5 PARAMS 가 BE 에서 절단되어 길이 판정 불가 — 절단 전 길이 = 위 PARAMS 길이 이상');
        RETURN;
    END IF;
    BEGIN
        v_obj := JSON_OBJECT_T.parse(v_params);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('D5 PARAMS JSON 해석 실패: ' || SQLERRM);
        RETURN;
    END;
    v_keys := v_obj.get_Keys;
    DBMS_OUTPUT.PUT_LINE('D5 ' || RPAD('KEY', 22) || LPAD('LEN', 10) || LPAD('ROWS', 8) || '  JUDGE');
    FOR i IN 1 .. v_keys.COUNT LOOP
        IF v_keys(i) IN ('activeFlag','divisionId','projectCode','scmSiteId','plantSiteId','itemId','yyyymmdd','currency','measure',
                         'domExp','fcstType','incoterms','price','createdByList','creationDate','lastUpdatedByList','rownumKey') THEN
            v_val := v_obj.get_Clob(v_keys(i));
            v_len := NVL(DBMS_LOB.GETLENGTH(v_val), 0);
            v_rows := CASE WHEN v_len = 0 THEN 0 ELSE (v_len - NVL(DBMS_LOB.GETLENGTH(REPLACE(v_val, '^', '')), 0)) + 1 END;
            v_max := GREATEST(v_max, v_len);
            IF v_len > 32767 THEN v_over := v_over + 1; END IF;
            DBMS_OUTPUT.PUT_LINE('D5 ' || RPAD(v_keys(i), 22) || LPAD(v_len, 10) || LPAD(v_rows, 8) || '  ' ||
                                 CASE WHEN v_len > 32767 THEN '32K 초과 → VARCHAR2 바인드 실패' ELSE 'ok' END);
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('D5 판정: 최대 ' || v_max || '자 · 32K 초과 파라미터 ' || v_over || '개 → ' ||
        CASE WHEN v_over > 0 THEN '원인 ① 확정 (IN VARCHAR2 한도)'
             WHEN v_max > 5000 THEN '32K 미만이나 대량 — 원인 ② (분할 지연·타임아웃) 확인: [D3] END 없음 / [D4] ELAPSED_MS'
             ELSE '소량 — [D3] ERROR 의 SQL_ERR_MSG 로 판정' END);
END;
/

-- [D6] 지금 PKG_DMF0020 실행 중 세션 (오래 걸리면 원인 ②) — 권한 없으면 ORA-00942, 그 섹션만 건너뛰고 회신
SELECT 'D6 running' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.MODULE, S.LAST_CALL_ET CALL_SEC, S.EVENT, S.SQL_ID
  FROM GV$SESSION S
 WHERE S.TYPE = 'USER' AND S.STATUS = 'ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID IN (SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_DMF0020');

UNDEFINE LOG_SEQ
SET DEFINE OFF
