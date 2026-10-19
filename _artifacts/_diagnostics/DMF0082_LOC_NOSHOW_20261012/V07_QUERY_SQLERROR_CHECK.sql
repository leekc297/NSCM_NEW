-- =============================================================================
-- V07_QUERY_SQLERROR_CHECK.sql — DMF0082 조회 SQL ERROR 원인 확보 (전체 F5 · 값 입력 없음)
--   계정: SCM_MGR · BE 가 붙은 클라우드 DB
--   [E1] PKG_DMF0082 상태 · 컴파일 오류 · 오늘 적용 마커(MANDCOL / LATFIX) · 의존 객체 무효 여부
--   [E2] 오늘 화면 호출 중 오류 난 건 — BE 로그의 오류 원문(ORA 체인)
--   [E3] 오늘 SP 가 직접 남긴 오류 로그 — 오류 코드 · 메시지 · 발생 줄(BACKTRACE)
--   [E4] 가장 최근 '오류 난 조회'(없으면 가장 최근 조회)와 같은 인자로 조회 SP 를 직접 실행 — 오류 원문과 발생 줄을 그대로 출력
--        (조회 SP 는 세션 전용 작업 테이블만 쓴다. 끝에 ROLLBACK. 영구 테이블 변경 없음)
--   [E5] 오류 발생 줄 주변 원문 — [E4] 에서 잡힌 줄 번호 기준 (이 DB 의 USER_SOURCE)
-- =============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT WRAPPED
SET LINESIZE 250
SET PAGESIZE 500
SET TRIMSPOOL ON
SET VERIFY OFF
SET FEEDBACK OFF
COLUMN CHK FORMAT A10
COLUMN OBJECT_NAME FORMAT A44
COLUMN OBJECT_TYPE FORMAT A14
COLUMN TXT FORMAT A160
COLUMN ST FORMAT A14
COLUMN AT FORMAT A14
COLUMN WHO FORMAT A14
COLUMN SHT FORMAT A14
COLUMN PROG FORMAT A44
COLUMN ERR FORMAT A200
COLUMN MSG FORMAT A200
COLUMN CODE FORMAT A10
SPOOL V07_QUERY_SQLERROR_CHECK_OUT.txt

PROMPT ################ [E1] 객체 상태 · 컴파일 오류 · 적용 마커 ################
SELECT 'E1 상태' CHK, O.OBJECT_NAME, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME = O.OBJECT_NAME AND E.TYPE = O.OBJECT_TYPE) ERR_CNT
  FROM USER_OBJECTS O
 WHERE O.OBJECT_NAME = 'PKG_DMF0082'
    OR (O.STATUS <> 'VALID' AND O.OBJECT_NAME IN (SELECT REFERENCED_NAME FROM USER_DEPENDENCIES WHERE NAME = 'PKG_DMF0082'))
 ORDER BY O.OBJECT_NAME, O.OBJECT_TYPE;
SELECT 'E1 컴파일' CHK, E.TYPE OBJECT_TYPE, E.LINE, E.POSITION POS, SUBSTR(E.TEXT,1,160) TXT
  FROM USER_ERRORS E WHERE E.NAME = 'PKG_DMF0082' ORDER BY E.SEQUENCE;
SELECT 'E1 마커' CHK, M.MK OBJECT_NAME, COUNT(S.LINE) N, MIN(S.LINE) LINE_MIN, MAX(S.LINE) LINE_MAX
  FROM (SELECT 'E20261012-DMF0082MANDCOL' MK FROM DUAL UNION ALL SELECT 'E20261012-DMF0082LATFIX' FROM DUAL) M
  LEFT JOIN USER_SOURCE S ON S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY' AND S.TEXT LIKE '%' || M.MK || '%'
 GROUP BY M.MK ORDER BY M.MK;
PROMPT --  MANDCOL N=2 = 오늘 패치 적용됨 / 0 = 미적용 / 1 = 부분 적용(비정상)
SELECT 'E1 메타' CHK, C.COLUMN_NAME OBJECT_NAME, C.DIVISION_ID TXT, C.USER_SELECTABLE_FLAG SEL, C.VISIBLE_FLAG VIS, C.VALID_YN VAL
  FROM SCM_MST_SHEET_COLUMNS C
 WHERE C.PROGRAM_ID = 'DMF0082' AND C.SHEET_NAME = 'FcstNPrice' AND C.COLUMN_NAME IN ('CELL_PROD_SITE_ID','PLANT_SITE_ID')
 ORDER BY C.COLUMN_NAME;

PROMPT ################ [E2] ⭐ 오늘 화면 호출 중 오류 건 — BE 로그 오류 원문 (최근 8건 · 건당 최대 4줄) ################
SELECT TO_CHAR(L.TRNM_ST_DTM,'MM-DD HH24:MI:SS') ST, SUBSTR(L.CREATED_BY,1,14) WHO, SUBSTR(L.SHT_NM,1,14) SHT, N.PART,
       SUBSTR(L.EXCT_MSG_CTN, (N.PART - 1) * 200 + 1, 200) ERR
  FROM (SELECT X.*, ROW_NUMBER() OVER (ORDER BY X.TRNM_ST_DTM DESC) RN
          FROM SCM_COM_SYS_LOG X
         WHERE X.MNU_ID = 'DMF0082' AND X.CREATION_DATE >= TRUNC(SYSDATE) AND X.EXCT_MSG_CTN IS NOT NULL) L
 CROSS JOIN (SELECT LEVEL PART FROM DUAL CONNECT BY LEVEL <= 4) N
 WHERE L.RN <= 8 AND (N.PART - 1) * 200 < LENGTH(L.EXCT_MSG_CTN)
 ORDER BY L.TRNM_ST_DTM DESC, N.PART;
PROMPT --  0 rows = BE 로그에 오류 원문이 남지 않음 → [E3][E4] 로 판정

PROMPT ################ [E2b] 오늘 화면 호출 요약 — 시트별 건수 · 오류 건수 · 마지막 호출 ################
SELECT SUBSTR(SHT_NM,1,14) SHT, COUNT(*) CALLS, SUM(CASE WHEN EXCT_MSG_CTN IS NOT NULL THEN 1 ELSE 0 END) ERR_CALLS,
       TO_CHAR(MAX(TRNM_ST_DTM),'MM-DD HH24:MI:SS') LAST_CALL,
       TO_CHAR(MAX(CASE WHEN EXCT_MSG_CTN IS NOT NULL THEN TRNM_ST_DTM END),'MM-DD HH24:MI:SS') LAST_ERR
  FROM SCM_COM_SYS_LOG
 WHERE MNU_ID = 'DMF0082' AND CREATION_DATE >= TRUNC(SYSDATE)
 GROUP BY SUBSTR(SHT_NM,1,14) ORDER BY 1;

PROMPT ################ [E3] ⭐ 오늘 SP 오류 로그 — 코드 · 메시지 · 발생 줄 (최근 10건) ################
SELECT TO_CHAR(CREATION_DATE,'MM-DD HH24:MI:SS') AT, SUBSTR(CREATED_BY,1,14) WHO, SUBSTR(PROGRAM_NAME,1,44) PROG, SUBSTR(SQL_ERR_CODE,1,10) CODE
  FROM SCM_SYS_LOG_BATCH
 WHERE PROGRAM_NAME LIKE 'PKG_DMF0082%' AND CREATION_DATE >= TRUNC(SYSDATE)
   AND (SQL_ERR_CODE IS NOT NULL OR UPPER(LOG_TYPE) = 'ERROR')
 ORDER BY CREATION_DATE DESC FETCH FIRST 10 ROWS ONLY;
SELECT TO_CHAR(CREATION_DATE,'MM-DD HH24:MI:SS') AT, SUBSTR(REPLACE(SQL_ERR_MSG, CHR(10), ' / '),1,200) ERR
  FROM SCM_SYS_LOG_BATCH
 WHERE PROGRAM_NAME LIKE 'PKG_DMF0082%' AND CREATION_DATE >= TRUNC(SYSDATE)
   AND (SQL_ERR_CODE IS NOT NULL OR UPPER(LOG_TYPE) = 'ERROR')
 ORDER BY CREATION_DATE DESC FETCH FIRST 10 ROWS ONLY;
SELECT TO_CHAR(CREATION_DATE,'MM-DD HH24:MI:SS') AT, SUBSTR(REPLACE(SQL_BACKTRACE, CHR(10), ' / '),1,200) ERR
  FROM SCM_SYS_LOG_BATCH
 WHERE PROGRAM_NAME LIKE 'PKG_DMF0082%' AND CREATION_DATE >= TRUNC(SYSDATE)
   AND (SQL_ERR_CODE IS NOT NULL OR UPPER(LOG_TYPE) = 'ERROR')
 ORDER BY CREATION_DATE DESC FETCH FIRST 10 ROWS ONLY;
SELECT TO_CHAR(CREATION_DATE,'MM-DD HH24:MI:SS') AT, SUBSTR(IN_PARA_DATA,1,200) MSG
  FROM SCM_SYS_LOG_BATCH
 WHERE PROGRAM_NAME LIKE 'PKG_DMF0082%' AND CREATION_DATE >= TRUNC(SYSDATE)
   AND (SQL_ERR_CODE IS NOT NULL OR UPPER(LOG_TYPE) = 'ERROR')
 ORDER BY CREATION_DATE DESC FETCH FIRST 10 ROWS ONLY;

PROMPT ################ [E4] ⭐⭐ 같은 인자로 조회 SP 직접 실행 — 오류 원문 · 발생 줄 ################
DECLARE
    v_msg   VARCHAR2(4000);
    v_st    VARCHAR2(30);
    v_err   VARCHAR2(10);
    v_div   VARCHAR2(100);  v_team  VARCHAR2(4000); v_cust  VARCHAR2(4000); v_biz   VARCHAR2(4000);
    v_from  VARCHAR2(20);   v_to    VARCHAR2(20);   v_site  VARCHAR2(4000); v_item  VARCHAR2(4000);
    v_ver   VARCHAR2(200);  v_qty   VARCHAR2(10);   v_user  VARCHAR2(100);  v_grp   VARCHAR2(200);
    v_plant VARCHAR2(4000); v_prj   VARCHAR2(4000); v_owner VARCHAR2(4000); v_send  VARCHAR2(4000);
    rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR; rc4 SYS_REFCURSOR; rc5 SYS_REFCURSOR; rcr SYS_REFCURSOR;
    c       INTEGER;
    n       PLS_INTEGER := 0;
    v_step  VARCHAR2(40) := '인자 읽기';
    PROCEDURE p(s VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(s); END;
    FUNCTION jv(k VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN REGEXP_SUBSTR(v_msg, '"' || k || '":"([^"]*)"', 1, 1, NULL, 1);
    END;
BEGIN
    BEGIN
        -- 오류 난 조회 우선, 없으면 가장 최근 조회
        SELECT ST, MSG, ERR INTO v_st, v_msg, v_err
          FROM (SELECT TO_CHAR(TRNM_ST_DTM,'YYYY-MM-DD HH24:MI:SS') ST, SYS_LOG_MSG_CTN MSG,
                       CASE WHEN EXCT_MSG_CTN IS NOT NULL THEN 'Y' ELSE 'N' END ERR
                  FROM SCM_COM_SYS_LOG
                 WHERE MNU_ID = 'DMF0082' AND SHT_NM = 'FcstNPrice' AND CREATION_DATE >= SYSDATE - 1
                   AND SYS_LOG_MSG_CTN LIKE '%P_DMF0082_GET_MAIN_DATA(%'
                 ORDER BY CASE WHEN EXCT_MSG_CTN IS NOT NULL THEN 0 ELSE 1 END, TRNM_ST_DTM DESC)
         WHERE ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_msg := NULL;
    END;
    IF v_msg IS NULL THEN
        p('!! 최근 24시간 화면 조회 로그 없음 → 기본 인자 (40 · 당월 1일~+6개월 · Current · minyonglee1 / ADMIN)');
        v_div := '40'; v_team := 'ALL'; v_cust := 'ALL'; v_biz := 'ALL';
        v_from := TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD'); v_to := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),6) - 1,'YYYYMMDD');
        v_site := 'ALL'; v_item := NULL; v_ver := 'Current'; v_qty := 'N'; v_user := 'minyonglee1'; v_grp := 'ADMIN';
        v_plant := 'ALL'; v_prj := 'ALL'; v_owner := 'ALL'; v_send := 'ALL';
    ELSE
        v_div  := jv('divisionId');  v_team := jv('deptId');      v_cust  := jv('endCustomer'); v_biz   := jv('bizType');
        v_from := jv('fromYyyymmdd'); v_to  := jv('toYyyymmdd');   v_site  := jv('salesSite');   v_item  := jv('itemId');
        v_ver  := jv('versionType'); v_qty  := jv('qtyYn');       v_user  := jv('sesUserId');   v_grp   := jv('userGroup');
        v_plant := jv('plantSiteId'); v_prj := jv('projectCode');  v_owner := jv('owner');       v_send  := jv('senderCode');
    END IF;
    p('기준 조회 ' || NVL(v_st,'(없음)') || ' · 화면 오류 건 여부 [' || NVL(v_err,'-') || ']');
    p('  div[' || v_div || '] ' || v_from || '~' || v_to || ' team[' || v_team || '] cust[' || v_cust || '] biz[' || v_biz || '] site[' || v_site || '] item[' || v_item || ']');
    p('  ver[' || v_ver || '] qty[' || v_qty || '] user[' || v_user || '] group[' || v_grp || '] plant[' || v_plant || '] project[' || v_prj || '] owner[' || v_owner || '] sender[' || v_send || ']');

    v_step := 'SP 실행';
    SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(
        p_division_id => v_div,   p_team_id => v_team,       p_customer => v_cust,     p_biz_type => v_biz,
        p_from_yyyymmdd => v_from, p_to_yyyymmdd => v_to,    p_scm_site_id => v_site,  p_item_id => v_item,
        p_version_type => v_ver,  p_qty_yn => v_qty,         p_created_by => v_user,   p_user_group => v_grp,
        p_plant_site_id => v_plant, p_project_code => v_prj, p_owner => v_owner,       p_sender_code => v_send,
        O_RC1 => rc1, O_RC2 => rc2, O_RC3 => rc3, O_RC4 => rc4, O_RC5 => rc5, O_RESULT_CURSOR => rcr);
    v_step := '결과 읽기';
    c := DBMS_SQL.TO_CURSOR_NUMBER(rc1);
    WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP n := n + 1; END LOOP;
    DBMS_SQL.CLOSE_CURSOR(c);
    p('E4 결과: 정상 — 그리드 ' || n || ' 행. 이 인자로는 DB 에서 오류가 재현되지 않는다 (화면 오류는 [E2] 원문 · 다른 시트 호출 · 다른 인자 확인)');
EXCEPTION WHEN OTHERS THEN
    p('E4 결과: 오류 재현 — 단계 [' || v_step || ']');
    p('  ' || REPLACE(SQLERRM, CHR(10), CHR(10) || '  '));
    p('  --- 발생 위치 ---');
    p('  ' || REPLACE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, CHR(10), CHR(10) || '  '));
END;
/
ROLLBACK;

PROMPT ################ [E5] 오류 로그에 남은 줄 번호 주변 원문 (가장 최근 SP 오류 로그 기준 · 앞뒤 6줄) ################
SELECT 'E5' CHK, S.LINE, SUBSTR(RTRIM(S.TEXT, CHR(10)||CHR(13)),1,160) TXT
  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
   AND S.LINE BETWEEN (SELECT TO_NUMBER(REGEXP_SUBSTR(B.SQL_BACKTRACE, 'PKG_DMF0082[^0-9]+line ([0-9]+)', 1, 1, 'i', 1)) - 6
                         FROM (SELECT SQL_BACKTRACE FROM SCM_SYS_LOG_BATCH
                                WHERE PROGRAM_NAME LIKE 'PKG_DMF0082%' AND CREATION_DATE >= TRUNC(SYSDATE) AND SQL_BACKTRACE IS NOT NULL
                                ORDER BY CREATION_DATE DESC FETCH FIRST 1 ROWS ONLY) B)
                  AND (SELECT TO_NUMBER(REGEXP_SUBSTR(B.SQL_BACKTRACE, 'PKG_DMF0082[^0-9]+line ([0-9]+)', 1, 1, 'i', 1)) + 6
                         FROM (SELECT SQL_BACKTRACE FROM SCM_SYS_LOG_BATCH
                                WHERE PROGRAM_NAME LIKE 'PKG_DMF0082%' AND CREATION_DATE >= TRUNC(SYSDATE) AND SQL_BACKTRACE IS NOT NULL
                                ORDER BY CREATION_DATE DESC FETCH FIRST 1 ROWS ONLY) B)
 ORDER BY S.LINE;
PROMPT --  0 rows = 오늘 줄 번호가 남은 SP 오류 로그 없음 ([E4] 의 '발생 위치' 줄 번호를 본다)

SPOOL OFF
PROMPT =============================================================================
PROMPT  V07 완료 → V07_QUERY_SQLERROR_CHECK_OUT.txt 회신 ([E1] 마커·상태 · [E2]/[E3] 오류 원문 · [E4] 재현 결과가 핵심)
PROMPT =============================================================================
