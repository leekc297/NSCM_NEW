-- =============================================================================
-- V02_LOC_STAGE_TRACE.sql — DMF0082 LOC 미표시 2차: 화면과 같은 인자로 조회 SP 를 직접 실행하고 단계별 잔존 확인 (전체 F5)
--   계정: SCM_MGR · BE 가 붙은 클라우드 DB · V01 결과(조건①~⑤ 전부 PASS) 다음 단계
--   무엇을 하나:
--     [W1] 사용자(&P_USER)의 가장 최근 화면 조회(FcstNPrice) 인자를 BE 로그에서 그대로 읽는다 (전문 출력)
--     [W2] 그 인자로 PKG_DMF0082.P_DMF0082_GET_MAIN_DATA 를 1회 실행한다 (화면 Search 와 동일 호출)
--     [W3]~[W6] 같은 세션에 남은 작업 테이블(GTT)에서 대상 Site-Item 의 메저별 잔존을 본다
--         [W3] 선택 메저 목록   [W4] Site-Item 대상 목록   [W5] 적재·필터 후 원자료   [W6] 화면 출력 직전 자료
--     [W7] 판정 한 줄
--   변경: 영구 테이블 변경 없음. SP 는 세션 전용 작업 테이블만 채운다 (조회 SP 자체의 실행 로그 1~2행은 화면 조회 때와 동일하게 남는다).
--         마지막 줄 ROLLBACK 은 작업 테이블 비우기용.
--   전체 F5 · 값 입력 없음. 다른 건을 볼 때는 DEFINE 4줄만 변경.
--   ⚠ SQL Developer 는 반드시 "스크립트 실행(F5)" — 문장 실행(Ctrl+Enter)으로 나눠 돌려도 되지만 같은 접속(세션)이어야 [W3]~[W7] 이 나온다.
-- =============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT WRAPPED
SET LINESIZE 400
SET PAGESIZE 500
SET TRIMSPOOL ON
SET VERIFY OFF
SET DEFINE ON
DEFINE P_DIV  = '40'
DEFINE P_SITE = 'AJ상사_AB_TES'
DEFINE P_ITEM = 'MCCM356015A2'
DEFINE P_USER = 'k0101'
COLUMN JUDGE FORMAT A110
SPOOL V02_LOC_STAGE_TRACE_OUT.txt

PROMPT ################ [W0] 접속 DB · 시각 ################
SELECT SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, USER USR, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;

PROMPT ################ [W1][W2] 최근 화면 조회 인자 → SP 직접 실행 ################
DECLARE
    v_msg   VARCHAR2(4000);
    v_st    VARCHAR2(30);
    v_div   VARCHAR2(100);  v_team  VARCHAR2(4000); v_cust  VARCHAR2(4000); v_biz   VARCHAR2(4000);
    v_from  VARCHAR2(20);   v_to    VARCHAR2(20);   v_site  VARCHAR2(4000); v_item  VARCHAR2(4000);
    v_ver   VARCHAR2(200);  v_qty   VARCHAR2(10);   v_user  VARCHAR2(100);  v_grp   VARCHAR2(200);
    v_plant VARCHAR2(4000); v_prj   VARCHAR2(4000); v_owner VARCHAR2(4000); v_send  VARCHAR2(4000);
    rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR; rc4 SYS_REFCURSOR; rc5 SYS_REFCURSOR; rcr SYS_REFCURSOR;
    t0      NUMBER;

    PROCEDURE p(s VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(s); END;
    -- BE 로그 JSON 에서 "키":"값" 추출 (키가 없거나 null 이면 NULL)
    FUNCTION jv(k VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN REGEXP_SUBSTR(v_msg, '"' || k || '":"([^"]*)"', 1, 1, NULL, 1);
    END;
BEGIN
    BEGIN
        SELECT ST, MSG INTO v_st, v_msg
          FROM (SELECT TO_CHAR(TRNM_ST_DTM,'YYYY-MM-DD HH24:MI:SS') ST, SYS_LOG_MSG_CTN MSG
                  FROM SCM_COM_SYS_LOG
                 WHERE MNU_ID = 'DMF0082' AND SHT_NM = 'FcstNPrice'
                   AND CREATION_DATE >= SYSDATE - 1
                   AND UPPER(CREATED_BY) = UPPER('&P_USER')
                   AND SYS_LOG_MSG_CTN LIKE '%P_DMF0082_GET_MAIN_DATA(%'
                 ORDER BY TRNM_ST_DTM DESC)
         WHERE ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_msg := NULL;
    END;

    IF v_msg IS NULL THEN
        p('!! 최근 24시간 &P_USER 의 화면 조회 로그 없음 → 기본 인자로 실행 (division &P_DIV · 당월 1일~+6개월 · Current · 그룹 ADMIN)');
        v_div := '&P_DIV'; v_team := 'ALL'; v_cust := 'ALL'; v_biz := 'ALL';
        v_from := TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD'); v_to := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),6) - 1,'YYYYMMDD');
        v_site := 'ALL'; v_item := NULL; v_ver := 'Current'; v_qty := 'N'; v_user := '&P_USER'; v_grp := 'ADMIN';
        v_plant := 'ALL'; v_prj := 'ALL'; v_owner := 'ALL'; v_send := 'ALL';
    ELSE
        p('[W1] 기준 화면 조회 시각 = ' || v_st);
        p('     로그 길이 = ' || LENGTH(v_msg) || ' (4000 이면 뒤가 잘렸을 수 있음 — 아래 인자 중 NULL 확인)');
        v_div  := jv('divisionId');  v_team := jv('deptId');      v_cust  := jv('endCustomer'); v_biz   := jv('bizType');
        v_from := jv('fromYyyymmdd'); v_to  := jv('toYyyymmdd');   v_site  := jv('salesSite');   v_item  := jv('itemId');
        v_ver  := jv('versionType'); v_qty  := jv('qtyYn');       v_user  := jv('sesUserId');   v_grp   := jv('userGroup');
        v_plant := jv('plantSiteId'); v_prj := jv('projectCode');  v_owner := jv('owner');       v_send  := jv('senderCode');
    END IF;

    p('     p_division_id   = [' || v_div   || ']');
    p('     p_team_id       = [' || v_team  || ']');
    p('     p_customer      = [' || v_cust  || ']');
    p('     p_biz_type      = [' || v_biz   || ']');
    p('     p_from_yyyymmdd = [' || v_from  || ']');
    p('     p_to_yyyymmdd   = [' || v_to    || ']');
    p('     p_scm_site_id   = [' || v_site  || ']');
    p('     p_item_id       = [' || v_item  || ']');
    p('     p_version_type  = [' || v_ver   || ']   ← Current 가 아니면 판가는 DM_PLN_CFM_SELLING_PRICE 가 아닌 버전 원장에서 읽는다');
    p('     p_qty_yn        = [' || v_qty   || ']');
    p('     p_created_by    = [' || v_user  || ']');
    p('     p_user_group    = [' || v_grp   || ']');
    p('     p_plant_site_id = [' || v_plant || ']');
    p('     p_project_code  = [' || v_prj   || ']');
    p('     p_owner         = [' || v_owner || ']');
    p('     p_sender_code   = [' || v_send  || ']');

    t0 := DBMS_UTILITY.GET_TIME;
    SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(
        p_division_id => v_div,   p_team_id => v_team,       p_customer => v_cust,     p_biz_type => v_biz,
        p_from_yyyymmdd => v_from, p_to_yyyymmdd => v_to,    p_scm_site_id => v_site,  p_item_id => v_item,
        p_version_type => v_ver,  p_qty_yn => v_qty,         p_created_by => v_user,   p_user_group => v_grp,
        p_plant_site_id => v_plant, p_project_code => v_prj, p_owner => v_owner,       p_sender_code => v_send,
        O_RC1 => rc1, O_RC2 => rc2, O_RC3 => rc3, O_RC4 => rc4, O_RC5 => rc5, O_RESULT_CURSOR => rcr);
    p('[W2] SP 실행 완료 ' || ROUND((DBMS_UTILITY.GET_TIME - t0)/100, 1) || ' 초');

    IF rc1%ISOPEN THEN CLOSE rc1; END IF;
    IF rc2%ISOPEN THEN CLOSE rc2; END IF;
    IF rc3%ISOPEN THEN CLOSE rc3; END IF;
    IF rc4%ISOPEN THEN CLOSE rc4; END IF;
    IF rc5%ISOPEN THEN CLOSE rc5; END IF;
    IF rcr%ISOPEN THEN CLOSE rcr; END IF;
EXCEPTION WHEN OTHERS THEN
    p('!!! SP 실행 오류: ' || SQLERRM);
    p(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT ################ [W3] 선택 메저 목록 (SP 가 이번 실행에 쓴 값) — LOC 의 USER_ID 가 로그인 ID 여야 한다 ################
PROMPT --  LOC 의 USER_ID = 'DM_ADMIN' 이면 = 사용자 선택으로 인식 안 됨 → 최종 단계에서 LOC 삭제
SELECT MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID
  FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE
 ORDER BY SORT_ORDER_NO, MEASURE;

PROMPT ################ [W4] Site-Item 대상 목록 — 이번 조회에서 이 Site-Item 이 대상에 들어왔는가 ################
PROMPT --  0 rows = 권한·조회조건(팀/고객/Biz Type 등)에서 이 Site-Item 이 빠짐 → 어떤 메저도 안 나온다.  ITEM_VALID_YN <> 'Y' = 수요·판가 적재 제외
SELECT '[' || PROJECT_CODE || ']' PROJECT_CODE, '[' || END_CUSTOMER || ']' END_CUSTOMER, '[' || PLANT_SITE_ID || ']' PLANT_SITE_ID,
       ITEM_VALID_YN, DEPT_ID, OWNER, BIZ_TYPE, VMI_YN
  FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM
 WHERE DIVISION_ID = '&P_DIV' AND SCM_SITE_ID = '&P_SITE' AND ITEM_ID = '&P_ITEM';

PROMPT ################ [W5] ⭐ 적재·필터 후 원자료 — 대상 Site-Item 의 메저별 잔존 (키 값 포함) ################
PROMPT --  여기에 LOC 가 없다 = SP 안에서 탈락 (적재 또는 후속 삭제).  LOC 가 있다 = [W6] 로
SELECT MEASURE, '[' || PROJECT_CODE || ']' PROJECT_CODE, '[' || END_CUSTOMER || ']' END_CUSTOMER,
       '[' || DOM_EXP || ']' DOM_EXP, '[' || FCST_TYPE || ']' FCST_TYPE, '[' || INCOTERMS || ']' INCOTERMS,
       '[' || PLANT_SITE_ID || ']' PLANT_SITE_ID, '[' || CELL_PROD_SITE_ID || ']' CELL_PROD_SITE_ID, '[' || CURRENCY || ']' CURRENCY,
       VERSION_NO, COUNT(*) ROW_CNT, MIN(YYYYMMDD) YMD_MIN, MAX(YYYYMMDD) YMD_MAX,
       SUM(CASE WHEN QTY <> 0 THEN 1 ELSE 0 END) NONZERO, ROUND(SUM(QTY),3) QTY_SUM
  FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
 WHERE DIVISION_ID = '&P_DIV' AND SCM_SITE_ID = '&P_SITE' AND ITEM_ID = '&P_ITEM'
 GROUP BY MEASURE, PROJECT_CODE, END_CUSTOMER, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, CURRENCY, VERSION_NO
 ORDER BY MEASURE, 2, 3, 4, 5, 6, 7, 8;

PROMPT ################ [W6] ⭐ 화면 출력 직전 자료 — 대상 Site-Item 의 메저별 잔존 (이 자료가 그대로 화면 행이 된다) ################
PROMPT --  NONZERO = 0 인 메저는 화면에 안 나온다 (SCM_FCST·FCST_GAP 제외, 값 0 인 칸은 출력 대상에서 빠짐)
SELECT MEASURE, '[' || PROJECT_CODE || ']' PROJECT_CODE, '[' || END_CUSTOMER || ']' END_CUSTOMER,
       '[' || DOM_EXP || ']' DOM_EXP, '[' || FCST_TYPE || ']' FCST_TYPE, '[' || INCOTERMS || ']' INCOTERMS,
       '[' || PLANT_SITE_ID || ']' PLANT_SITE_ID, '[' || CELL_PROD_SITE_ID || ']' CELL_PROD_SITE_ID, '[' || CURRENCY || ']' CURRENCY,
       '[' || AS_FROM_SITE || ']' AS_FROM_SITE, MAX(SORT_ORDER_NO) SORT_NO, MAX(EDIT_FLAG) EDIT_FLAG,
       COUNT(*) ROW_CNT, MIN(BUCKET_KEY) BKT_MIN, MAX(BUCKET_KEY) BKT_MAX,
       SUM(CASE WHEN QTY <> 0 THEN 1 ELSE 0 END) NONZERO, ROUND(SUM(QTY),3) QTY_SUM
  FROM SCM_MGR.GT_DMF0082_MF_SP
 WHERE DIVISION_ID = '&P_DIV' AND SCM_SITE_ID = '&P_SITE' AND ITEM_ID = '&P_ITEM'
 GROUP BY MEASURE, PROJECT_CODE, END_CUSTOMER, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, CURRENCY, AS_FROM_SITE
 ORDER BY MAX(SORT_ORDER_NO), MEASURE, 2, 3, 4, 5, 6, 7, 8;

PROMPT ################ [W7] ⭐⭐ 판정 ################
SELECT CASE
         WHEN (SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE) = 0
           THEN 'ERROR — SP 가 실행되지 않았거나 작업 테이블이 비어 있음 ([W2] 오류 메시지 확인 · 같은 세션에서 실행했는지 확인)'
         WHEN (SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE WHERE MEASURE = 'LOC' AND NVL(USER_ID,'/') <> 'DM_ADMIN') = 0
           THEN 'A — LOC 가 사용자 선택 메저로 인식되지 않음 ([W3]) → SP 가 LOC 를 최종 삭제'
         WHEN (SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM WHERE DIVISION_ID = '&P_DIV' AND SCM_SITE_ID = '&P_SITE' AND ITEM_ID = '&P_ITEM') = 0
           THEN 'B — 이 Site-Item 이 조회 대상 목록에 없음 ([W4]) → 권한·조회조건 필터에서 탈락 (전 메저 미표시)'
         WHEN (SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE WHERE DIVISION_ID = '&P_DIV' AND SCM_SITE_ID = '&P_SITE' AND ITEM_ID = '&P_ITEM' AND MEASURE = 'LOC') = 0
           THEN 'C — LOC 가 SP 원자료 단계에서 없음 ([W5]) → 적재 조건(버전·ITEM_VALID_YN·기간) 또는 후속 삭제에서 탈락'
         WHEN (SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_MF_SP WHERE DIVISION_ID = '&P_DIV' AND SCM_SITE_ID = '&P_SITE' AND ITEM_ID = '&P_ITEM' AND MEASURE = 'LOC') = 0
           THEN 'D — 원자료에는 LOC 가 있으나 출력 직전 자료에 없음 ([W5] 있음 · [W6] 없음) → 날짜(캘린더) 결합에서 탈락'
         WHEN (SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_MF_SP WHERE DIVISION_ID = '&P_DIV' AND SCM_SITE_ID = '&P_SITE' AND ITEM_ID = '&P_ITEM' AND MEASURE = 'LOC' AND QTY <> 0) = 0
           THEN 'E — LOC 행은 있으나 값이 전부 0 → 출력에서 제외'
         ELSE 'F — DB 는 LOC 를 반환한다 ([W6] 에 LOC 존재) → 원인은 화면(FE) 표시 쪽. [W6] 의 LOC 행 키와 화면의 수요 행 키를 비교'
       END JUDGE
  FROM DUAL;

ROLLBACK;
SPOOL OFF
PROMPT =============================================================================
PROMPT  V02 완료 → V02_LOC_STAGE_TRACE_OUT.txt 회신 ([W1] 인자 · [W5] · [W6] · [W7] 이 핵심)
PROMPT =============================================================================
