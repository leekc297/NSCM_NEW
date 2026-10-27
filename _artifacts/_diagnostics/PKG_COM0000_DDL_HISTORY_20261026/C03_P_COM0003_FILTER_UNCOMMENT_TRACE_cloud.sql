--------------------------------------------------------------------------------
-- C03 · P_COM0003_GET_STORAGE_BY_DIVISION_POPUP WHERE 필터 "주석 해제" 추적 (기간 제한 없음)
--   작성 2026-10-26 · 계정 SCM_MGR · SELECT 전용(DB 변경 없음) · 클라우드 QA · DEV 각각 F5 실행
--
--   대상 필터 (WHERE 절 6줄)
--     AND ( S.STORAGE_ID LIKE '6%' OR S.STORAGE_ID LIKE 'A%' OR S.STORAGE_ID LIKE 'B%'
--           OR (S.STORAGE_ID LIKE '799%' AND S.STORAGE_ID NOT IN ('7990','7999')) )
--
--   판정 : 원문이 남은 PKG_COM0000 BODY 재생성 이벤트(감사 전 기간 + AWR) 마다 필터 상태를 판정
--          ACTIVE    = 필터 살아 있음 (주석 해제 상태)
--          COMMENTED = '--' 또는 /* */ 로 주석 처리
--          직전이 COMMENTED 이고 이번이 ACTIVE 인 이벤트 = ★ 주석 해제한 실행
--   한계 : 원문이 남는 것은 감사(SYSTEM 등 *ANY 권한 사용)·AWR 뿐. SCM_MGR 이 DBeaver 등으로 직접 저장한 DDL 은
--          원문이 없으므로 그 사이의 상태 변화는 [B] 의 원문 없는 DDL 목록으로 후보만 제시한다.
--------------------------------------------------------------------------------
SET DEFINE OFF
SET LINESIZE 400
SET PAGESIZE 500
SET TRIMSPOOL ON
SET TRIMOUT ON
SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT WRAPPED

PROMPT ================= §0 환경 지문 =================
SELECT SYS_CONTEXT('USERENV','DB_NAME') AS DB_NAME, USER AS CONNECTED_AS
     , TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') AS RUN_AT
  FROM DUAL;

PROMPT ================= §1 필터 상태 이력 =================
DECLARE
  TYPE T_DT IS TABLE OF DATE INDEX BY PLS_INTEGER;
  V_SEG    VARCHAR2(32767);
  V_STATE  VARCHAR2(40);
  V_PREV   VARCHAR2(40);
  V_PREV_T DATE;
  V_CHG    VARCHAR2(80);
  V_CNT    PLS_INTEGER := 0;
  V_LAST_UNC_TXT VARCHAR2(1000);
  V_LAST_UNC_T   DATE;
  V_AUD_MIN  VARCHAR2(30);
  V_CUR    VARCHAR2(32767);
  V_CUR_ST VARCHAR2(40);
  V_LDDL   DATE;
  V_TEXT_T DATE;   -- 원문 있는 마지막 이벤트 시각

  -- 원문 CLOB 에서 BODY 의 대상 멤버 정의부 ~ 다음 멤버 직전
  FUNCTION GET_SEG(P_TXT CLOB) RETURN VARCHAR2 IS
    V_FROM PLS_INTEGER; V_TO PLS_INTEGER; V_POS PLS_INTEGER; V_OUT VARCHAR2(32767);
  BEGIN
    V_FROM := REGEXP_INSTR(P_TXT, 'PROCEDURE\s+P_COM0003_GET_STORAGE_BY_DIVISION_POPUP\s*(\([^;]*?\))?\s*(IS|AS)\s', 1, 1, 0, 'in');
    IF V_FROM = 0 THEN RETURN NULL; END IF;
    V_TO := REGEXP_INSTR(P_TXT, CHR(10) || '\s*(PROCEDURE|FUNCTION)\s+\w+', V_FROM + 10, 1, 0, 'in');
    IF V_TO = 0 THEN V_TO := DBMS_LOB.GETLENGTH(P_TXT) + 1; END IF;
    V_POS := V_FROM;
    WHILE V_POS < V_TO LOOP
      BEGIN
        V_OUT := V_OUT || DBMS_LOB.SUBSTR(P_TXT, LEAST(1000, V_TO - V_POS), V_POS);
      EXCEPTION WHEN VALUE_ERROR THEN EXIT;
      END;
      V_POS := V_POS + 1000;
    END LOOP;
    RETURN V_OUT;
  END;

  -- 필터 상태 판정 : 기준 줄 = "STORAGE_ID LIKE 'A%'" (6줄 중 고유 줄)
  FUNCTION FILTER_STATE(P_SEG VARCHAR2) RETURN VARCHAR2 IS
    V_POS PLS_INTEGER; V_LS PLS_INTEGER; V_PREFIX VARCHAR2(4000);
    V_OPEN PLS_INTEGER; V_CLOSE PLS_INTEGER;
  BEGIN
    IF P_SEG IS NULL THEN RETURN 'MEMBER_MISSING'; END IF;
    V_POS := REGEXP_INSTR(P_SEG, 'STORAGE_ID\s+LIKE\s+''A%''', 1, 1, 0, 'i');
    IF V_POS = 0 THEN RETURN 'FILTER_REMOVED'; END IF;
    V_LS := INSTR(SUBSTR(P_SEG, 1, V_POS), CHR(10), -1);
    V_PREFIX := SUBSTR(P_SEG, V_LS + 1, V_POS - V_LS - 1);
    IF INSTR(V_PREFIX, '--') > 0 THEN RETURN 'COMMENTED(--)'; END IF;
    V_OPEN  := INSTR(SUBSTR(P_SEG, 1, V_POS), '/*', -1);
    V_CLOSE := INSTR(SUBSTR(P_SEG, 1, V_POS), '*/', -1);
    IF V_OPEN > 0 AND V_OPEN > V_CLOSE THEN RETURN 'COMMENTED(/* */)'; END IF;
    RETURN 'ACTIVE';
  END;

  FUNCTION WHO(P_PROG VARCHAR2) RETURN VARCHAR2 IS
    V VARCHAR2(4000) := UPPER(NVL(P_PROG,'-'));
  BEGIN
    RETURN CASE
      WHEN V LIKE '%DBEAVER%' OR V LIKE '%SQL DEVELOPER%' OR V LIKE '%TOAD%' OR V LIKE '%ORANGE%' THEN '사람(GUI 도구)'
      WHEN V LIKE '%PYTHON%' OR V LIKE '%POWERSHELL%' OR V LIKE '%NODE%' THEN 'AI·자동화 추정(스크립트)'
      ELSE '구분 불가' END;
  END;
BEGIN
  SELECT TO_CHAR(MIN(EVENT_TIMESTAMP),'YYYY-MM-DD HH24:MI:SS') INTO V_AUD_MIN FROM UNIFIED_AUDIT_TRAIL;

  DBMS_OUTPUT.PUT_LINE('[A] 원문이 남은 BODY 재생성 이벤트별 필터 상태  (감사 기록 최古 = ' || NVL(V_AUD_MIN,'없음') || ')');
  DBMS_OUTPUT.PUT_LINE(RPAD('No',4) || ' | ' || RPAD('언제',19) || ' | ' || RPAD('출처',5) || ' | ' || RPAD('DB계정',10) || ' | '
                    || RPAD('OS사용자',14) || ' | ' || RPAD('PC',20) || ' | ' || RPAD('수행 주체',24) || ' | '
                    || RPAD('필터 상태',16) || ' | 직전 대비');
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 200, '-'));

  FOR R IN (
    SELECT 'AUDIT' AS SRC, CAST(A.EVENT_TIMESTAMP AS DATE) AS TS
         , A.DBUSERNAME AS USR, A.OS_USERNAME AS OSU, A.USERHOST AS HOST, A.CLIENT_PROGRAM_NAME AS PROG
         , A.SQL_TEXT AS TXT
      FROM UNIFIED_AUDIT_TRAIL A
     WHERE UPPER(A.OBJECT_SCHEMA) = 'SCM_MGR'
       AND UPPER(A.OBJECT_NAME)   = 'PKG_COM0000'
       AND A.ACTION_NAME = 'CREATE PACKAGE BODY'
       AND A.RETURN_CODE = 0
    UNION ALL
    SELECT 'AWR', CAST(G.T_FROM AS DATE), U.USERNAME, NULL, G.MACHINE, G.PROGRAM, X.SQL_TEXT
      FROM (SELECT SQL_ID, MIN(SAMPLE_TIME) AS T_FROM, MAX(USER_ID) AS USER_ID
                 , MAX(MACHINE) AS MACHINE, MAX(PROGRAM) AS PROGRAM
              FROM (SELECT SQL_ID, SAMPLE_TIME, USER_ID, MACHINE, PROGRAM
                      FROM GV$ACTIVE_SESSION_HISTORY WHERE SQL_OPCODE = 97
                    UNION ALL
                    SELECT SQL_ID, SAMPLE_TIME, USER_ID, MACHINE, PROGRAM
                      FROM DBA_HIST_ACTIVE_SESS_HISTORY WHERE SQL_OPCODE = 97)
             GROUP BY SQL_ID) G
      JOIN (SELECT SQL_ID, SQL_TEXT
              FROM (SELECT T.SQL_ID, T.SQL_TEXT, ROW_NUMBER() OVER (PARTITION BY T.SQL_ID ORDER BY T.DBID) AS RN
                      FROM DBA_HIST_SQLTEXT T)
             WHERE RN = 1) X ON X.SQL_ID = G.SQL_ID
      LEFT JOIN DBA_USERS U ON U.USER_ID = G.USER_ID
     WHERE UPPER(REGEXP_SUBSTR(DBMS_LOB.SUBSTR(X.SQL_TEXT, 400, 1)
                 , 'PACKAGE\s+(BODY\s+)?("?\w+"?\.)?"?(\w+)', 1, 1, 'i', 3)) = 'PKG_COM0000'
     ORDER BY 2
  ) LOOP
    V_CNT   := V_CNT + 1;
    V_SEG   := GET_SEG(R.TXT);
    V_STATE := FILTER_STATE(V_SEG);
    V_CHG   := CASE
                 WHEN V_PREV IS NULL THEN '기준(첫 원문)'
                 WHEN V_PREV LIKE 'COMMENTED%' AND V_STATE = 'ACTIVE' THEN '★★ 주석 해제됨 (이 실행이 해제)'
                 WHEN V_PREV = 'ACTIVE' AND V_STATE LIKE 'COMMENTED%' THEN '★ 주석 처리됨'
                 WHEN V_PREV <> V_STATE THEN '★ 상태 변경 (' || V_PREV || '→' || V_STATE || ')'
                 ELSE '동일' END;
    IF V_CHG LIKE '★★%' THEN
      V_LAST_UNC_T   := R.TS;
      V_LAST_UNC_TXT := TO_CHAR(R.TS,'YYYY-MM-DD HH24:MI:SS') || ' · ' || R.USR || ' / OS=' || NVL(R.OSU,'-')
                     || ' / PC=' || NVL(R.HOST,'-') || ' / ' || NVL(SUBSTR(R.PROG,1,60),'-') || ' · ' || WHO(R.PROG);
    END IF;
    DBMS_OUTPUT.PUT_LINE(RPAD('#' || V_CNT, 4) || ' | ' || TO_CHAR(R.TS,'YYYY-MM-DD HH24:MI:SS') || ' | ' || RPAD(R.SRC,5) || ' | '
                      || RPAD(NVL(R.USR,'-'),10) || ' | ' || RPAD(NVL(R.OSU,'-'),14) || ' | ' || RPAD(NVL(SUBSTR(R.HOST,1,20),'-'),20) || ' | '
                      || RPAD(WHO(R.PROG),24) || ' | ' || RPAD(V_STATE,16) || ' | ' || V_CHG);
    V_PREV   := V_STATE;
    V_PREV_T := R.TS;
  END LOOP;
  IF V_CNT = 0 THEN DBMS_OUTPUT.PUT_LINE('(원문이 남은 BODY 재생성 이벤트 없음)'); END IF;
  V_TEXT_T := V_PREV_T;

  -- 현재 원문 상태
  FOR L IN (
    WITH S AS (SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_COM0000' AND TYPE = 'PACKAGE BODY')
       , B AS (SELECT MIN(LINE) AS L_FROM FROM S
                WHERE REGEXP_LIKE(TEXT, '^\s*PROCEDURE\s+P_COM0003_GET_STORAGE_BY_DIVISION_POPUP(\s|\(|$)', 'i'))
       , N AS (SELECT MIN(S.LINE) AS L_NEXT FROM S, B
                WHERE S.LINE > B.L_FROM AND REGEXP_LIKE(S.TEXT, '^\s*(PROCEDURE|FUNCTION)\s+\w+', 'i'))
    SELECT S.TEXT FROM S, B, N
     WHERE S.LINE >= B.L_FROM AND (N.L_NEXT IS NULL OR S.LINE < N.L_NEXT)
     ORDER BY S.LINE
  ) LOOP
    BEGIN V_CUR := V_CUR || L.TEXT; EXCEPTION WHEN VALUE_ERROR THEN EXIT; END;
  END LOOP;
  V_CUR_ST := FILTER_STATE(V_CUR);
  SELECT LAST_DDL_TIME INTO V_LDDL FROM ALL_OBJECTS
   WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_COM0000' AND OBJECT_TYPE = 'PACKAGE BODY';
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 200, '-'));
  DBMS_OUTPUT.PUT_LINE('현재  | ' || TO_CHAR(V_LDDL,'YYYY-MM-DD HH24:MI:SS') || ' (BODY LAST_DDL) | 현재 원문 필터 상태 = ' || V_CUR_ST
                    || CASE WHEN V_PREV IS NOT NULL AND V_PREV <> V_CUR_ST
                            THEN '   ← ★ 마지막 원문(' || V_PREV || ') 이후 원문 없는 DDL 에서 상태 변경' END);

  DBMS_OUTPUT.PUT_LINE(' ');
  DBMS_OUTPUT.PUT_LINE('[결론] 원문으로 확정되는 마지막 "주석 해제" 실행 = '
                    || NVL(V_LAST_UNC_TXT, '없음 — 원문이 남은 기간 내 COMMENTED→ACTIVE 전환 없음'));
  IF V_LAST_UNC_TXT IS NULL AND V_CNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('        첫 원문(#1)이 이미 ACTIVE 이면 해제는 첫 원문 이전(감사 기록 최古 ' || NVL(V_AUD_MIN,'-')
                      || ' 이전) 또는 원문 없는 DDL 에서 일어났다 → [B] 후보 확인');
  END IF;

  -- [B] 원문 없는 BODY DDL (ASH) — 상태 변화가 숨어 있을 수 있는 구간의 후보
  DBMS_OUTPUT.PUT_LINE(' ');
  DBMS_OUTPUT.PUT_LINE('[B] 원문 없는 BODY DDL 후보 (ASH · AWR 보존기간 내 · 대상 패키지 미확인 — 다른 패키지일 수 있음)');
  FOR H IN (
    SELECT TO_CHAR(MIN(H.SAMPLE_TIME),'YYYY-MM-DD HH24:MI:SS') AS T_FROM
         , U.USERNAME, H.MACHINE, SUBSTR(H.PROGRAM,1,40) AS PROGRAM
         , (SELECT MAX(S.OSUSER) FROM GV$SESSION S
             WHERE UPPER(REGEXP_SUBSTR(S.MACHINE,'[^\\]+$')) = UPPER(REGEXP_SUBSTR(H.MACHINE,'[^\\]+$'))) AS OSU
      FROM (SELECT SQL_ID, SAMPLE_TIME, USER_ID, MACHINE, PROGRAM, SESSION_ID, SESSION_SERIAL#
              FROM GV$ACTIVE_SESSION_HISTORY WHERE SQL_OPCODE = 97
            UNION ALL
            SELECT SQL_ID, SAMPLE_TIME, USER_ID, MACHINE, PROGRAM, SESSION_ID, SESSION_SERIAL#
              FROM DBA_HIST_ACTIVE_SESS_HISTORY WHERE SQL_OPCODE = 97) H
      LEFT JOIN DBA_USERS U ON U.USER_ID = H.USER_ID
     WHERE NOT EXISTS (SELECT 1 FROM DBA_HIST_SQLTEXT T WHERE T.SQL_ID = H.SQL_ID)
     GROUP BY H.SQL_ID, H.SESSION_ID, H.SESSION_SERIAL#, U.USERNAME, H.MACHINE, SUBSTR(H.PROGRAM,1,40)
     ORDER BY MIN(H.SAMPLE_TIME)
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('    ' || H.T_FROM || ' | ' || RPAD(NVL(H.USERNAME,'-'),10) || ' | ' || RPAD(NVL(H.OSU,'-'),14) || ' | '
                      || RPAD(NVL(H.MACHINE,'-'),24) || ' | ' || RPAD(H.PROGRAM,40) || ' | ' || WHO(H.PROGRAM)
                      || CASE WHEN V_TEXT_T IS NOT NULL AND TO_DATE(H.T_FROM,'YYYY-MM-DD HH24:MI:SS') > V_TEXT_T
                              THEN '  (마지막 원문 이후)' END);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('C03 ERROR: ' || SQLERRM || ' / ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT ================= 끝 =================
