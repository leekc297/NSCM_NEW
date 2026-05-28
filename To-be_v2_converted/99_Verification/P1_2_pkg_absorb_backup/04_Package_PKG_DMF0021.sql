/*=============================================================================================
 * File         : 04_Package_PKG_DMF0021.sql
 * Description  : Package — PKG_DMF0021
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - $$PLSQL_UNIT 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0021
/*
 * Program ID   : PKG_DMF0021
 * Description  : PKG_DMF0201
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.23   jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                          UI 항목으로 Package로 전환
 */
AS
    -- 프로시저 선언    
    PROCEDURE P_DMF0021_GET_SALES_PLAN_MEASUREINFO
    (
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0021_GET_SALES_PLAN_MEASUREINFO2
    (
        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn

        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );


    PROCEDURE P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL
    (
        P_ACTIVE_FLAG         IN VARCHAR2,
        P_DIVISION_ID         IN VARCHAR2,
        P_PROJECT_CODE        IN VARCHAR2,
        P_SCM_SITE_ID         IN VARCHAR2,
        P_PLANT_SITE_ID       IN VARCHAR2,
        P_ITEM_ID             IN VARCHAR2,
        P_DOM_EXP             IN VARCHAR2,
        P_FCST_TYPE           IN VARCHAR2,
        P_INCOTERMS           IN VARCHAR2,
        P_MEASURE             IN VARCHAR2,
        P_YYYYMMDD            IN VARCHAR2,
        P_QTY                 IN VARCHAR2,
        P_CURRENCY            IN VARCHAR2,
        P_CREATED_BY          IN VARCHAR2,
        P_LAST_UPDATED_BY     IN VARCHAR2,
        P_TEXT                IN VARCHAR2,
        P_DEPT_ID             IN VARCHAR2,  --[PJ2024-50611] 부서ID추가
        P_CELL_PROD_SITE_ID   IN VARCHAR2,  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
        O_RESULT_CURSOR       OUT SYS_REFCURSOR
    );





END PKG_DMF0021;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0021
AS

PROCEDURE P_DMF0021_GET_SALES_PLAN_MEASUREINFO
(
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0021_GET_SALES_PLAN_MEASUREINFO     
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15	JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2024.11.15	KJJ			[PJ2024-50611] 소형사업부 Sales Plan 기타매출 입력 추가
							룩업에 등록된 메저 가져옴(DM_SALES_PLAN_MEASURE)
 * 2026.03.17  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 EXEC DMF0021_GET_SALES_PLAN_MEASUREINFO
 */
AS

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    OPEN O_RC1 FOR
    SELECT SEGMENT1    AS CODE
         , SEGMENT2    AS NAME
         , DISPLAY_SEQ
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'DM_SALES_PLAN_MEASURE'
    AND    VALID_YN    = 'Y'
    ORDER BY DISPLAY_SEQ;
    --[PJ2024-50611]기존 쿼리 주석처리
    /*
    SELECT  COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME, SORT_ORDER_NO AS DISPLAY_SEQ
    FROM     SCM_MST_SHEET_MEASURE
    WHERE  
    PROGRAM_ID = 'DMF1007' AND SHEET_NAME = 'Sales Plan'
    */

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  := JSON_OBJECT('NO_PARAM' VALUE 'N/A');
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0021_GET_SALES_PLAN_MEASUREINFO;





PROCEDURE P_DMF0021_GET_SALES_PLAN_MEASUREINFO2
(
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn

    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0021_GET_SALES_PLAN_MEASUREINFO2
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15  JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.17  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    OPEN O_RC1 FOR
    SELECT COLUMN_NAME      AS CODE
         , COLUMN_LABEL_NAME AS NAME
         , SORT_ORDER_NO    AS DISPLAY_SEQ
         , NVL(T2.EDIT_YN,'') AS EDIT_YN
    FROM   SCM_MST_SHEET_MEASURE T1
        INNER JOIN (SELECT * -- EDIT_YN 
                     FROM SCM_ADM_USER_MNU_EDIT_AUTH_V 
                     WHERE USER_ID = P_USER_ID 
                     AND MNU_ID = P_MNU_ID 
                     AND UNIT_TP_CD = 'D') T2
         ON T2.UNIT_ID in (
             SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL))
             FROM   DUAL
             CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
         )
    WHERE  PROGRAM_ID  = 'DMF1007'
    AND    SHEET_NAME  = 'Sales Plan'
    AND    COLUMN_NAME LIKE 'SalesAmt%'
    ORDER BY SORT_ORDER_NO;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  := JSON_OBJECT(
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
        );
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0021_GET_SALES_PLAN_MEASUREINFO2;



PROCEDURE         P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL
(
    P_ACTIVE_FLAG         IN VARCHAR2,
    P_DIVISION_ID         IN VARCHAR2,
    P_PROJECT_CODE        IN VARCHAR2,
    P_SCM_SITE_ID         IN VARCHAR2,
    P_PLANT_SITE_ID       IN VARCHAR2,
    P_ITEM_ID             IN VARCHAR2,
    P_DOM_EXP             IN VARCHAR2,
    P_FCST_TYPE           IN VARCHAR2,
    P_INCOTERMS           IN VARCHAR2,
    P_MEASURE             IN VARCHAR2,
    P_YYYYMMDD            IN VARCHAR2,
    P_QTY                 IN VARCHAR2,
    P_CURRENCY            IN VARCHAR2,
    P_CREATED_BY          IN VARCHAR2,
    P_LAST_UPDATED_BY     IN VARCHAR2,
    P_TEXT                IN VARCHAR2,
    P_DEPT_ID             IN VARCHAR2,  --[PJ2024-50611] 부서ID추가
    P_CELL_PROD_SITE_ID   IN VARCHAR2,  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
)
/*========================================================================================================================
 * Program ID   : DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL
 * Description  : SALES PLAN SAVE 버튼 클릭시 실행 프로시져 ('DM_PLN_SALES_PLAN' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *========================================================================================================================
 *   Date       In Charge      Description
 *========================================================================================================================
 * 2018.03.12   KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.14	KHSOMG		40 DIVISION 조건 추가
 * 2021.05.13	P.C.I		[PJ20209642R] DM_MST_EXCHANGE_RATE_C에 CURRENCY = 'KRW' 조건 추가
 * 2021.08.31	hwi1993		[C20210830-000508] [ESS영업관리팀] GSCM Sales Plan창 입력 가능 최대값 수정 요청의 건
 * 2021.11.03	ROSIA27		[PJ20209643] SALES PLAN속도 개선
 * 2021.11.03	ROSIA27		[PJ20209643] SALES PLAN속도 개선. 323라인 DELETE 구문 변경
 * 2021.12.22	rosia27		[C20211220-000276]Sales Plan, Sales Monitoring - 색상 수정 필요
 * 2024.04.04   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가(속도개선)
 * 2024.04.16   KCW3408     이동계획 기타매출 추가 요건(TEXT추가)
 * 2024.11.05	KJJ			[PJ2024-50611] 소형사업부 Sales Plan 기타매출 입력 추가
 * 2024.11.27	KJJ			[PJ2024-50611] 소형사업부 Sales Plan Catch Up 입력 추가
 * 2024.12.12	KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025.02.13	JSSBAE		[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청
 * 2025.03.12   dsiol		[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
 * 2025.04.04   JSSBAE		[E20250401-000548] SMS 선감지 대상 정리
 * 2025.05.07   dsiol	    [PJ2025-50017] 프로젝트와 관련한 각종 주석 추가 작성 및 임시테이블 명칭 변경
 * 2025.05.20   JSSBAE	    [E20250520-000572]_Sales Plan 데이터 Validation 로직 변경
 * 2025.06.02   KANG.H.J	[PJ2025-50188] SALES_PLAN 추가 및 수정시 ATTRIBUTE2(FROM_SITE_ID) 데이터 생성
 * 2025.06.12   KANG.H.J	[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
 * 2025.06.20   JSSBAE	    [E20250520-000605]_[영업.마케팅PI] Sales Plan - ETC Data 'Monthly' 입력 Bucket 기능 수정 요청
 * 2025.10.03	JSSBAE		[E20250919-001699]_N-ERP 3차 Roll-in 관련 DM Incoterms 전환 대응 건
 * 2025.11.17	JSSBAE		[E20251027-000091]_Sales Plan UI RTF 간편조정 시 RTF_SYS_RP, RTF_SCP 데이터 동기화
 * 2026.03.17   jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 ========================================================================================================================*/
AS

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    v_active_flag         VARCHAR2(4000 CHAR);
    v_division_id_val     VARCHAR2(4000 CHAR);
    v_project_code_val    VARCHAR2(4000 CHAR);
    v_scm_site_id_val     VARCHAR2(4000 CHAR);
    v_plant_site_id_val   VARCHAR2(4000 CHAR);
    v_item_id_val         VARCHAR2(4000 CHAR);
    v_dom_exp_val         VARCHAR2(4000 CHAR);
    v_fcst_type_val       VARCHAR2(4000 CHAR);
    v_incoterms_val       VARCHAR2(4000 CHAR);
    v_measure_val         VARCHAR2(4000 CHAR);
    v_wyyyymmdd           VARCHAR2(4000 CHAR);
    v_yyyymmdd_val        VARCHAR2(8 CHAR);
    v_currency_val        VARCHAR2(4000 CHAR);
    v_qty_val             NUMBER(30,10);
    v_created_by_val      VARCHAR2(4000 CHAR);
    v_last_updated_by_val VARCHAR2(4000 CHAR);
    v_text_val            VARCHAR2(4000 CHAR);
    v_dept_id_val         VARCHAR2(4000 CHAR);
    v_cell_prod_val       VARCHAR2(4000 CHAR);
    v_bucket_val          VARCHAR2(10 CHAR);
    v_weeknumber          VARCHAR2(2 CHAR);
    v_yyyy                VARCHAR2(4 CHAR);
    v_yyyymm              VARCHAR2(6 CHAR);
    v_max_cnt             PLS_INTEGER := 0;

    -- FCST_TYPE 룩업
    T_FCST_TYPE           T_STR_TAB := T_STR_TAB();

    --=============================================================================================================
    -- LOG 용 변수 설정
    --=============================================================================================================
    v_log_type            VARCHAR2(30 CHAR);
    n_log_count           PLS_INTEGER := 0;
    v_log_message         VARCHAR2(1000 CHAR);
    v_description         VARCHAR2(4000 CHAR);
    d_event_date          DATE;
    n_del_count           PLS_INTEGER := 0;
    n_insert_count        PLS_INTEGER := 0;
    n_event_count         PLS_INTEGER := 0;

    --=============================================================================================================
    -- VALIDATION 변수
    --=============================================================================================================
    V_S_VALIDATION        VARCHAR2(4000 CHAR) := NULL;
    V_S_CODE              VARCHAR2(50 CHAR)   := NULL;

    --=============================================================================================================
    -- VERSION 변수
    --=============================================================================================================
    v_max_mf_w_version    VARCHAR2(100 CHAR);
    v_max_mf_w_yyyymmdd   VARCHAR2(8 CHAR);
    v_max_sf_w_version    VARCHAR2(100 CHAR);
    v_max_sf_w_yyyymmdd   VARCHAR2(8 CHAR);
    v_cutoff_start        VARCHAR2(8 CHAR);
    v_cutoff_end          VARCHAR2(8 CHAR);

    --=============================================================================================================
    -- EXCEPTION 변수
    --=============================================================================================================
    V_PROC_INPUT          VARCHAR2(4000 CHAR);
    V_BACKTRACE           VARCHAR2(4000 CHAR);
    V_SQL_CODE            VARCHAR2(100 CHAR);
    V_SQL_ERRMSG          VARCHAR2(1000 CHAR);
    
    V_CNT                 NUMBER;
BEGIN

    --=============================================================================================================
    -- GTT TRUNCATE
    --=============================================================================================================
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F021_SALES_PLAN';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F021_SALES_PLAN_LOC';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F021_SALES_PLAN_RTF';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F021_DATA_DUP';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F021_PRICE_RTF_SYS_RP';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F021_SALES_PLAN_INSERT';

    -- 당주 월요일 관련 날짜 미리 계산
    v_cutoff_start := TO_CHAR(TRUNC(SYSDATE, 'IW') - 7, 'YYYYMMDD');
    v_cutoff_end   := TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD');

    --=============================================================================================================
    -- 시작 LOG
    --=============================================================================================================
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    --=============================================================================================================
    -- '^' 구분자 파싱 → GT_F021_SALES_PLAN INSERT (PL/SQL FOR LOOP)
    -- MSSQL WHILE 루프 내부에 날짜변환(M_bucket→월말일/01일, W_bucket→IIF+CALENDAR조회) 로직이 있어
    -- 단순 REGEXP INSERT 불가 → 행별 루프 처리
    --=============================================================================================================
    v_max_cnt := REGEXP_COUNT(P_DIVISION_ID, '\^') + 1;

    FOR i IN 1..v_max_cnt LOOP

        v_active_flag         := TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,       '[^\^]+', 1, i));
        v_division_id_val     := TRIM(REGEXP_SUBSTR(P_DIVISION_ID,       '[^\^]+', 1, i));
        v_project_code_val    := TRIM(REGEXP_SUBSTR(P_PROJECT_CODE,      '[^\^]+', 1, i));
        v_scm_site_id_val     := TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID,      '[^\^]+', 1, i));
        v_plant_site_id_val   := TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,    '[^\^]+', 1, i));
        v_item_id_val         := TRIM(REGEXP_SUBSTR(P_ITEM_ID,          '[^\^]+', 1, i));
        v_dom_exp_val         := TRIM(REGEXP_SUBSTR(P_DOM_EXP,          '[^\^]+', 1, i));
        v_fcst_type_val       := TRIM(REGEXP_SUBSTR(P_FCST_TYPE,        '[^\^]+', 1, i));
        v_incoterms_val       := TRIM(REGEXP_SUBSTR(P_INCOTERMS,        '[^\^]+', 1, i));
        v_measure_val         := TRIM(REGEXP_SUBSTR(P_MEASURE,          '[^\^]+', 1, i));
        v_wyyyymmdd           := TRIM(REGEXP_SUBSTR(P_YYYYMMDD,         '[^\^]+', 1, i));
        v_currency_val        := TRIM(REGEXP_SUBSTR(P_CURRENCY,         '[^\^]+', 1, i));
        v_qty_val             := TO_NUMBER(TRIM(REGEXP_SUBSTR(P_QTY,    '[^\^]+', 1, i)));
        v_created_by_val      := TRIM(REGEXP_SUBSTR(P_CREATED_BY,       '[^\^]+', 1, i));
        v_last_updated_by_val := TRIM(REGEXP_SUBSTR(P_LAST_UPDATED_BY,  '[^\^]+', 1, i));
        v_text_val            := TRIM(REGEXP_SUBSTR(P_TEXT,              '[^\^]+', 1, i));
        v_dept_id_val         := TRIM(REGEXP_SUBSTR(P_DEPT_ID,          '[^\^]+', 1, i));
        v_cell_prod_val       := TRIM(REGEXP_SUBSTR(P_CELL_PROD_SITE_ID,'[^\^]+', 1, i));

        -- Bucket 구분: 첫글자
        v_bucket_val := SUBSTR(v_wyyyymmdd, 1, 1);
        v_weeknumber := SUBSTR(v_wyyyymmdd, -2);
        v_yyyy       := SUBSTR(v_wyyyymmdd, 3, 4);
        v_yyyymm     := SUBSTR(v_wyyyymmdd, 3, 6);

        -- 날짜 변환 로직
        IF v_bucket_val = 'M' THEN
            --[E20250520-000605]_40사업부 + ETC → 달의 마지막 날
            IF v_division_id_val = '40' AND v_fcst_type_val = 'ETC' THEN
                SELECT v_yyyymm || MAX(CALENDAR_DAY)
                INTO   v_yyyymmdd_val
                FROM   SCM_SYS_CALENDAR_M
                WHERE  BASIS_YYYYMM = v_yyyymm;
            ELSE
                v_yyyymmdd_val := v_yyyymm || '01';
            END IF;
        ELSE
            IF SUBSTR(v_yyyymm, 5, 2) <> '12' THEN
                SELECT CASE WHEN MIN(A.BASIS_YYYYMM) = MAX(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            WHEN v_yyyymm = MIN(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            ELSE MAX(A.BASIS_YYYYMM) || '01'
                       END
                INTO   v_yyyymmdd_val
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.CALENDAR_YYYY = v_yyyy
                AND    A.ISO_WEEK      = v_weeknumber;
            ELSE
                SELECT CASE WHEN MIN(A.BASIS_YYYYMM) = MAX(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            WHEN v_yyyymm = MIN(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            ELSE MAX(A.BASIS_YYYYMM) || '01'
                       END
                INTO   v_yyyymmdd_val
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.CALENDAR_YYYY = v_yyyy
                AND    A.ISO_WEEK      = v_weeknumber
                AND    A.BASIS_YYYYMM  = v_yyyymm;
            END IF;
        END IF;

        INSERT INTO GT_F021_SALES_PLAN
        (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
         V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE,
         V_YYYYMMDD, V_CURRENCY, V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY,
         V_TEXT, V_DEPT_ID, V_BUCKET, V_CELL_PROD_SITE_ID)
        VALUES
        (v_active_flag, v_division_id_val, v_project_code_val, v_scm_site_id_val, v_plant_site_id_val,
         v_item_id_val, v_dom_exp_val, v_fcst_type_val, v_incoterms_val, v_measure_val,
         v_yyyymmdd_val, v_currency_val, v_qty_val, v_created_by_val, v_last_updated_by_val,
         v_text_val, v_dept_id_val, v_bucket_val, v_cell_prod_val);

    END LOOP;

    --COMMIT;

    --=============================================================================================================
    -- [PJ2025-50188] FROM_SITE_ID 업데이트
    --=============================================================================================================
    MERGE INTO GT_F021_SALES_PLAN A
    USING (
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
             , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
             , MAX(ATTRIBUTE2) AS FROM_SITE_ID
        FROM   DM_PLN_SALES_PLAN
        WHERE  DIVISION_ID = v_division_id_val
        AND    MEASURE     = 'RTF_SYS_RP'
        AND    YYYYMMDD   >= v_cutoff_start
        AND    ATTRIBUTE2 IS NOT NULL
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
               , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
    ) B
    ON (    A.V_DIVISION_ID      = B.DIVISION_ID
        AND A.V_PROJECT_CODE     = B.PROJECT_CODE
        AND A.V_SCM_SITE_ID      = B.SCM_SITE_ID
        AND A.V_PLANT_SITE_ID    = B.PLANT_SITE_ID
        AND A.V_ITEM_ID          = B.ITEM_ID
        AND A.V_DOM_EXP          = B.DOM_EXP
        AND A.V_FCST_TYPE        = B.FCST_TYPE
        AND A.V_INCOTERMS        = B.INCOTERMS
        AND A.V_MEASURE          = B.MEASURE
        AND A.V_CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
    )
    WHEN MATCHED THEN UPDATE SET A.V_FROM_SITE_ID = B.FROM_SITE_ID;

    --COMMIT;

    --=============================================================================================================
    -- GTT 통계 수집
    --=============================================================================================================
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_F021_SALES_PLAN',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);

    --=============================================================================================================
    -- 저장 데이터 유형 별로 GTT 분리
    --=============================================================================================================
    INSERT INTO GT_F021_SALES_PLAN_LOC SELECT * FROM GT_F021_SALES_PLAN WHERE V_MEASURE = 'SalesAmt_LOC';

    INSERT INTO GT_F021_SALES_PLAN_RTF SELECT * FROM GT_F021_SALES_PLAN WHERE V_MEASURE = 'RTF_SYS_RP';

    --[E20251027-000091]_RTF_SYS_RP 메져로 RTF_SCP, RTF 생성
    INSERT INTO GT_F021_SALES_PLAN_RTF
    SELECT A.V_ACTIVE_FLAG, A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_PLANT_SITE_ID
         , A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, B.MEASURE
         , A.V_YYYYMMDD, A.V_CURRENCY, A.V_QTY, A.V_CREATED_BY, A.V_LAST_UPDATED_BY
         , A.V_TEXT, A.V_DEPT_ID, A.V_BUCKET, A.V_CELL_PROD_SITE_ID, A.V_FROM_SITE_ID
    FROM GT_F021_SALES_PLAN_RTF A
    CROSS JOIN (SELECT 'RTF' AS MEASURE FROM DUAL UNION ALL SELECT 'RTF_SCP' FROM DUAL) B
    WHERE A.V_MEASURE = 'RTF_SYS_RP';

    --COMMIT;

    --=============================================================================================================
    -- VALIDATION (START)
    --=============================================================================================================

    -- [E20250919-001699]_Incoterms 데이터 처리 VALID 처리
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN R
            WHERE R.V_INCOTERMS IN (
                SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'INCOTERMS_ID' GROUP BY OLD_VALUE1
            )
        );
        v_log_type    := 'INVALID';
        V_S_CODE      := 'MSG00467';
        V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- PROJECT_CODE 유효성 (40사업부 제외)
    BEGIN
        SELECT V_PROJECT_CODE INTO V_S_VALIDATION
        FROM (
            SELECT A.V_PROJECT_CODE
            FROM   GT_F021_SALES_PLAN A
            LEFT OUTER JOIN SCM_MST_PROJECT B
                ON A.V_DIVISION_ID  = B.DIVISION_ID
                AND A.V_PROJECT_CODE = B.PROJECT_CODE
            WHERE A.V_PROJECT_CODE <> ''
            AND   A.V_DIVISION_ID  <> '40'
            AND   B.PROJECT_CODE IS NULL
        )
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00457';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    --[E20250520-000572]_INVALID2, INVALID4 VALIDATION 통합
    INSERT INTO GT_F021_DATA_DUP
    (V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP,
     V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD, V_CELL_PROD_SITE_ID)
    SELECT LOC.V_DIVISION_ID, LOC.V_PROJECT_CODE, LOC.V_SCM_SITE_ID, LOC.V_ITEM_ID, LOC.V_DOM_EXP
         , LOC.V_FCST_TYPE, LOC.V_INCOTERMS, LOC.V_MEASURE, LOC.V_PLANT_SITE_ID, LOC.V_YYYYMMDD
         , LOC.V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_LOC LOC
    INNER JOIN DM_PLN_SALES_ETC_PLAN P
        ON  LOC.V_DIVISION_ID   = P.DIVISION_ID
        AND LOC.V_PROJECT_CODE  = P.PROJECT_CODE
        AND LOC.V_SCM_SITE_ID   = P.SCM_SITE_ID
        AND LOC.V_ITEM_ID       = P.ITEM_ID
        AND LOC.V_DOM_EXP       = P.DOM_EXP
        AND LOC.V_FCST_TYPE     = P.FCST_TYPE
        AND LOC.V_INCOTERMS     = P.INCOTERMS
        AND LOC.V_MEASURE       = P.MEASURE
        AND LOC.V_PLANT_SITE_ID = P.PLANT_SITE_ID
        AND LOC.V_YYYYMMDD      = P.YYYYMMDD
        AND LOC.V_TEXT           = P.REMARK_TEXT
    WHERE LOC.V_ACTIVE_FLAG = 'I'
    UNION ALL
    SELECT RTF.V_DIVISION_ID, RTF.V_PROJECT_CODE, RTF.V_SCM_SITE_ID, RTF.V_ITEM_ID, RTF.V_DOM_EXP
         , RTF.V_FCST_TYPE, RTF.V_INCOTERMS, RTF.V_MEASURE, RTF.V_PLANT_SITE_ID, RTF.V_YYYYMMDD
         , RTF.V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF RTF
    INNER JOIN DM_PLN_SALES_PLAN P
        ON  RTF.V_DIVISION_ID       = P.DIVISION_ID
        AND RTF.V_PROJECT_CODE      = P.PROJECT_CODE
        AND RTF.V_SCM_SITE_ID       = P.SCM_SITE_ID
        AND RTF.V_ITEM_ID           = P.ITEM_ID
        AND RTF.V_DOM_EXP           = P.DOM_EXP
        AND RTF.V_FCST_TYPE         = P.FCST_TYPE
        AND RTF.V_INCOTERMS         = P.INCOTERMS
        AND RTF.V_MEASURE           = P.MEASURE
        AND RTF.V_PLANT_SITE_ID     = P.PLANT_SITE_ID
        AND RTF.V_YYYYMMDD          = P.YYYYMMDD
        AND RTF.V_CELL_PROD_SITE_ID = P.CELL_PROD_SITE_ID
    WHERE RTF.V_ACTIVE_FLAG = 'I';

    BEGIN
        SELECT CHR(10) || '*Div : ' || NVL(V_DIVISION_ID,'')
             || CHR(10) || CASE WHEN V_DIVISION_ID = '40' THEN '*End Customer : ' ELSE '*Project Code : ' END || NVL(V_PROJECT_CODE,'')
             || CHR(10) || '*Sales Site : '          || NVL(V_SCM_SITE_ID,'')
             || CHR(10) || '*Model : '               || NVL(V_ITEM_ID,'')
             || CHR(10) || '*Customer Handbook : '   || NVL(V_DOM_EXP,'')
             || CHR(10) || '*FCST Type : '           || NVL(V_FCST_TYPE,'')
             || CHR(10) || '*INCOTERMS : '           || NVL(V_INCOTERMS,'')
             || CHR(10) || '*Measure : '             || NVL(V_MEASURE,'')
             || CHR(10) || '*Plant Site : '          || NVL(V_PLANT_SITE_ID,'')
             || CHR(10) || '*YYYYMMDD : '            || NVL(V_YYYYMMDD,'')
             || CHR(10) || '*Cell Prod Site ID : '   || NVL(V_CELL_PROD_SITE_ID,'')
        INTO V_S_VALIDATION
        FROM (SELECT * FROM GT_F021_DATA_DUP ORDER BY V_YYYYMMDD)
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00428';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    -- Catch_Up 모델 유효성
    BEGIN
        SELECT A.V_ITEM_ID INTO V_S_VALIDATION
        FROM (
            SELECT A.V_ITEM_ID
            FROM   GT_F021_SALES_PLAN A
            LEFT OUTER JOIN SCM_MST_SITE_ITEM B
                ON  A.V_DIVISION_ID  = B.DIVISION_ID
                AND A.V_PROJECT_CODE = B.PROJECT_CODE
                AND A.V_SCM_SITE_ID  = B.SCM_SITE_ID
                AND A.V_ITEM_ID      = B.ITEM_ID
            WHERE A.V_DIVISION_ID = '40'
            AND   A.V_MEASURE     = 'Catch_Up'
            AND   B.ITEM_ID IS NULL
        ) A
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00458';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    -- Catch_Up 판가 유효성 체크
    SELECT SEGMENT2
    BULK COLLECT INTO T_FCST_TYPE
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE  MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
    AND    MST.SEGMENT1    = 'FCST_TYPE'
    AND    VALID_YN        = 'Y';

    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN TMP
            WHERE TMP.V_DIVISION_ID = '40'
            AND   TMP.V_MEASURE     = 'Catch_Up'
            AND   TMP.V_FCST_TYPE NOT IN (SELECT COLUMN_VALUE FROM TABLE(T_FCST_TYPE))
            AND   NOT EXISTS (
                SELECT 1 FROM DM_PLN_CFM_SELLING_PRICE FP
                WHERE FP.DIVISION_ID               = TMP.V_DIVISION_ID
                AND   FP.PROJECT_CODE              = TMP.V_PROJECT_CODE
                AND   FP.SCM_SITE_ID               = TMP.V_SCM_SITE_ID
                AND   FP.PLANT_SITE_ID             = TMP.V_PLANT_SITE_ID
                AND   FP.ITEM_ID                   = TMP.V_ITEM_ID
                AND   SUBSTR(FP.YYYYMMDD,1,6)      = SUBSTR(TMP.V_YYYYMMDD,1,6)
                AND   FP.MEASURE                   = 'LOC'
                AND   FP.DOM_EXP                   = TMP.V_DOM_EXP
                AND   FP.FCST_TYPE                 = TMP.V_FCST_TYPE
                AND   FP.INCOTERMS                 = TMP.V_INCOTERMS
                AND   FP.CELL_PROD_SITE_ID         = TMP.V_CELL_PROD_SITE_ID
            )
        );
        v_log_type     := 'INVALID';
        V_S_CODE       := 'MSG00328';
        V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- RMA 음수값 확인
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN
            WHERE V_FCST_TYPE = 'RMA' AND V_MEASURE = 'RTF_SYS_RP' AND NVL(V_QTY, 0) > 0
        );
        v_log_type := 'INVALID'; V_S_CODE := 'MSG00459'; V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- RMA 이외 정수값 확인
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN
            WHERE V_FCST_TYPE <> 'RMA' AND V_MEASURE = 'RTF_SYS_RP' AND NVL(V_QTY, 0) < 0
        );
        v_log_type := 'INVALID'; V_S_CODE := 'MSG00460'; V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- RTF Price 존재 체크
    INSERT INTO GT_F021_PRICE_RTF_SYS_RP
    (V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID, V_CELL_PROD_SITE_ID, WEEK_NAME)
    SELECT A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE
         , A.V_INCOTERMS, A.V_PLANT_SITE_ID, A.V_CELL_PROD_SITE_ID, A.WEEK_NAME
    FROM (
        SELECT AA.V_YYYYMMDD, AA.V_DIVISION_ID, AA.V_PROJECT_CODE, AA.V_SCM_SITE_ID, AA.V_PLANT_SITE_ID
             , AA.V_CELL_PROD_SITE_ID, AA.V_ITEM_ID, AA.V_DOM_EXP, AA.V_FCST_TYPE, AA.V_INCOTERMS
             , AA.V_MEASURE, M.BASIS_START_DATE, AA.V_QTY, M.WEEK_NAME
        FROM   GT_F021_SALES_PLAN_RTF AA
        JOIN   SCM_SYS_CALENDAR_M M ON AA.V_YYYYMMDD = M.BASIS_YYYYMMDD
        WHERE  AA.V_MEASURE = 'RTF_SYS_RP'
    ) A
    LEFT JOIN (
        SELECT BB.YYYYMMDD, BB.DIVISION_ID, BB.PROJECT_CODE, BB.SCM_SITE_ID, BB.PLANT_SITE_ID
             , BB.CELL_PROD_SITE_ID, BB.ITEM_ID, BB.DOM_EXP, BB.FCST_TYPE, BB.INCOTERMS
             , BB.MEASURE, M.BASIS_START_DATE, BB.END_CUSTOMER
        FROM   DM_PLN_CFM_SELLING_PRICE BB
        JOIN   SCM_SYS_CALENDAR_M M ON BB.YYYYMMDD = M.BASIS_YYYYMMDD
        WHERE  BB.MEASURE = 'LOC'
    ) B
        ON  A.V_DIVISION_ID      = B.DIVISION_ID
        AND A.V_PROJECT_CODE     = B.PROJECT_CODE
        AND A.V_PROJECT_CODE     = B.END_CUSTOMER
        AND A.V_SCM_SITE_ID      = B.SCM_SITE_ID
        AND A.V_PLANT_SITE_ID    = B.PLANT_SITE_ID
        AND A.V_CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
        AND A.V_ITEM_ID          = B.ITEM_ID
        AND A.V_DOM_EXP          = B.DOM_EXP
        AND A.V_FCST_TYPE        = B.FCST_TYPE
        AND A.V_INCOTERMS        = B.INCOTERMS
        AND A.BASIS_START_DATE   = B.BASIS_START_DATE
    WHERE B.BASIS_START_DATE IS NULL
    AND   A.V_FCST_TYPE <> 'ETC'
    AND   NVL(A.V_QTY, 0) <> 0;

    BEGIN
        SELECT CHR(10) || 'Project Code________ : '      || NVL(V_PROJECT_CODE,'')
             || CHR(10) || 'Sales site_____________ : '  || NVL(V_SCM_SITE_ID,'')
             || CHR(10) || 'Model________________ : '    || NVL(V_ITEM_ID,'')
             || CHR(10) || 'Customs Handbook__ : '       || NVL(V_DOM_EXP,'')
             || CHR(10) || 'Fcst Type_____________ : '   || NVL((SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT1 = V_FCST_TYPE AND ROWNUM = 1), '')
             || CHR(10) || 'Incoterms____________ : '    || NVL(V_INCOTERMS,'')
             || CHR(10) || 'Plant Site___________ : '    || NVL(V_PLANT_SITE_ID,'')
             || CHR(10) || 'Cell Prod Site___________ : ' || NVL(V_CELL_PROD_SITE_ID,'')
             || CHR(10) || 'Week_________ : '            || NVL(WEEK_NAME,'')
        INTO V_S_VALIDATION
        FROM GT_F021_PRICE_RTF_SYS_RP WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00462';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    -- [E20250401-000548] 동일일자 CURRENCY 중복 체크
    BEGIN
        SELECT CHR(10) || 'Div: '            || NVL(V_DIVISION_ID,'')
             || CHR(10) || 'Project Code: '  || NVL(V_PROJECT_CODE,'')
             || CHR(10) || 'Scm Site Id: '   || NVL(V_SCM_SITE_ID,'')
             || CHR(10) || 'Model: '         || NVL(V_ITEM_ID,'')
             || CHR(10) || 'Currency : '     || NVL(V_CURRENCY,'')
        INTO V_S_VALIDATION
        FROM (
            SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_TEXT, V_YYYYMMDD
                 , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_CURRENCY, V_PLANT_SITE_ID
            FROM   GT_F021_SALES_PLAN_LOC
            GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_TEXT, V_YYYYMMDD
                   , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_CURRENCY, V_PLANT_SITE_ID
            HAVING COUNT(*) > 1
        )
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00461';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    --=============================================================================================================
    -- VALIDATION (END)
    --=============================================================================================================

    --=============================================================================================================
    -- DELETE SECTION
    --=============================================================================================================

    -- [E20250211-000653] Monthly / Weekly 분기
    SELECT COUNT(1) INTO V_CNT FROM GT_F021_SALES_PLAN WHERE V_BUCKET = 'M';
    IF V_CNT > 0 THEN

        -- Monthly: DM_PLN_SALES_ETC_PLAN (SalesAmt_LOC)
        DELETE FROM DM_PLN_SALES_ETC_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE       = 'SalesAmt_LOC'
            AND    A.DIVISION_ID       = TMP.V_DIVISION_ID
            AND    A.PROJECT_CODE      = TMP.V_PROJECT_CODE
            AND    A.SCM_SITE_ID       = TMP.V_SCM_SITE_ID
            AND    A.PLANT_SITE_ID     = TMP.V_PLANT_SITE_ID
            AND    A.ITEM_ID           = TMP.V_ITEM_ID
            AND    A.DOM_EXP           = TMP.V_DOM_EXP
            AND    A.FCST_TYPE         = TMP.V_FCST_TYPE
            AND    A.INCOTERMS         = TMP.V_INCOTERMS
            AND    A.REMARK_TEXT       = TMP.V_TEXT
            AND    C2.BASIS_YYYYMM     = C1.BASIS_YYYYMM
        )
        AND A.MEASURE NOT IN ('MKT_FCST','RTF','CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');
        
        n_del_count := n_del_count + SQL%ROWCOUNT;
        
        -- Monthly: DM_PLN_SALES_PLAN (RTF_SYS_RP)
        DELETE FROM DM_PLN_SALES_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE           = 'RTF_SYS_RP'
            AND    A.DIVISION_ID           = TMP.V_DIVISION_ID
            AND    A.PROJECT_CODE          = TMP.V_PROJECT_CODE
            AND    A.SCM_SITE_ID           = TMP.V_SCM_SITE_ID
            AND    A.PLANT_SITE_ID         = TMP.V_PLANT_SITE_ID
            AND    A.ITEM_ID               = TMP.V_ITEM_ID
            AND    A.DOM_EXP               = TMP.V_DOM_EXP
            AND    A.FCST_TYPE             = TMP.V_FCST_TYPE
            AND    A.INCOTERMS             = TMP.V_INCOTERMS
            AND    C2.BASIS_YYYYMM         = C1.BASIS_YYYYMM
            AND    A.CELL_PROD_SITE_ID     = TMP.V_CELL_PROD_SITE_ID
        )
        AND A.DIVISION_ID = '40'
        AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

        n_del_count := n_del_count + SQL%ROWCOUNT;

    ELSE
        -- Weekly: DM_PLN_SALES_ETC_PLAN (SalesAmt_LOC)
        DELETE FROM DM_PLN_SALES_ETC_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE       = 'SalesAmt_LOC'
            AND    A.DIVISION_ID       = TMP.V_DIVISION_ID
            AND    A.PROJECT_CODE      = TMP.V_PROJECT_CODE
            AND    A.SCM_SITE_ID       = TMP.V_SCM_SITE_ID
            AND    A.PLANT_SITE_ID     = TMP.V_PLANT_SITE_ID
            AND    A.ITEM_ID           = TMP.V_ITEM_ID
            AND    A.DOM_EXP           = TMP.V_DOM_EXP
            AND    A.FCST_TYPE         = TMP.V_FCST_TYPE
            AND    A.INCOTERMS         = TMP.V_INCOTERMS
            AND    A.REMARK_TEXT       = TMP.V_TEXT
            AND    C2.BASIS_YYYYMM     = C1.BASIS_YYYYMM
            AND    C2.ISO_YYYYWW       = C1.ISO_YYYYWW
        )
        AND A.MEASURE NOT IN ('MKT_FCST','RTF','CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');

        n_del_count := n_del_count + SQL%ROWCOUNT;

        -- Weekly: DM_PLN_SALES_PLAN (RTF_SYS_RP)
        DELETE FROM DM_PLN_SALES_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE           = 'RTF_SYS_RP'
            AND    A.DIVISION_ID           = TMP.V_DIVISION_ID
            AND    A.PROJECT_CODE          = TMP.V_PROJECT_CODE
            AND    A.SCM_SITE_ID           = TMP.V_SCM_SITE_ID
            AND    A.PLANT_SITE_ID         = TMP.V_PLANT_SITE_ID
            AND    A.ITEM_ID               = TMP.V_ITEM_ID
            AND    A.DOM_EXP               = TMP.V_DOM_EXP
            AND    A.FCST_TYPE             = TMP.V_FCST_TYPE
            AND    A.INCOTERMS             = TMP.V_INCOTERMS
            AND    C2.BASIS_YYYYMM         = C1.BASIS_YYYYMM
            AND    C2.ISO_YYYYWW           = C1.ISO_YYYYWW
            AND    A.CELL_PROD_SITE_ID     = TMP.V_CELL_PROD_SITE_ID
        )
        AND A.DIVISION_ID = '40'
        AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

        n_del_count := n_del_count + SQL%ROWCOUNT;

    END IF;

    -- SalesAmt_LOC/CATCH_UP/RTF_SYS_RP delete
    DELETE FROM DM_PLN_SALES_ETC_PLAN A
    WHERE EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN TMP
        JOIN SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
        JOIN SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
        WHERE TMP.V_MEASURE    = 'SalesAmt_LOC'
        AND   A.DIVISION_ID   = TMP.V_DIVISION_ID
        AND   A.PROJECT_CODE  = TMP.V_PROJECT_CODE
        AND   A.SCM_SITE_ID   = TMP.V_SCM_SITE_ID
        AND   A.PLANT_SITE_ID = TMP.V_PLANT_SITE_ID
        AND   A.ITEM_ID       = TMP.V_ITEM_ID
        AND   A.DOM_EXP       = TMP.V_DOM_EXP
        AND   A.FCST_TYPE     = TMP.V_FCST_TYPE
        AND   A.INCOTERMS     = TMP.V_INCOTERMS
        AND   A.REMARK_TEXT   = TMP.V_TEXT
        AND   C2.BASIS_YYYYMM = C1.BASIS_YYYYMM
        AND   C2.ISO_YYYYWW   = C1.ISO_YYYYWW
    )
    AND A.MEASURE NOT IN ('MKT_FCST','RTF','CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');

    n_del_count := n_del_count + SQL%ROWCOUNT;

    -- CATCH_UP delete
    DELETE FROM DM_PLN_SALES_ETC_PLAN A
    WHERE EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN TMP
        JOIN SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
        JOIN SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
        WHERE TMP.V_MEASURE    = 'CATCH_UP'
        AND   A.DIVISION_ID   = TMP.V_DIVISION_ID
        AND   A.PROJECT_CODE  = TMP.V_PROJECT_CODE
        AND   A.SCM_SITE_ID   = TMP.V_SCM_SITE_ID
        AND   A.PLANT_SITE_ID = TMP.V_PLANT_SITE_ID
        AND   A.ITEM_ID       = TMP.V_ITEM_ID
        AND   A.DOM_EXP       = TMP.V_DOM_EXP
        AND   A.FCST_TYPE     = TMP.V_FCST_TYPE
        AND   A.INCOTERMS     = TMP.V_INCOTERMS
        AND   A.REMARK_TEXT   = TMP.V_TEXT
        AND   C2.BASIS_YYYYMM = C1.BASIS_YYYYMM
        AND   C2.ISO_YYYYWW   = C1.ISO_YYYYWW
    )
    AND A.MEASURE IN ('CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');

    n_del_count := n_del_count + SQL%ROWCOUNT;

    -- RTF_SYS_RP delete from DM_PLN_SALES_PLAN
    DELETE FROM DM_PLN_SALES_PLAN A
    WHERE EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN TMP
        JOIN SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
        JOIN SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
        WHERE TMP.V_MEASURE           = 'RTF_SYS_RP'
        AND   A.DIVISION_ID          = TMP.V_DIVISION_ID
        AND   A.PROJECT_CODE         = TMP.V_PROJECT_CODE
        AND   A.SCM_SITE_ID          = TMP.V_SCM_SITE_ID
        AND   A.PLANT_SITE_ID        = TMP.V_PLANT_SITE_ID
        AND   A.ITEM_ID              = TMP.V_ITEM_ID
        AND   A.DOM_EXP              = TMP.V_DOM_EXP
        AND   A.FCST_TYPE            = TMP.V_FCST_TYPE
        AND   A.INCOTERMS            = TMP.V_INCOTERMS
        AND   C2.BASIS_YYYYMM        = C1.BASIS_YYYYMM
        AND   C2.ISO_YYYYWW          = C1.ISO_YYYYWW
        AND   A.CELL_PROD_SITE_ID    = TMP.V_CELL_PROD_SITE_ID
    )
    AND A.DIVISION_ID = '40'
    AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

    n_del_count := n_del_count + SQL%ROWCOUNT;

    --=============================================================================================================
    -- KRW INSERT (SalesAmt_LOC → SalesAmt_KRW 파생)
    --=============================================================================================================
    INSERT INTO GT_F021_SALES_PLAN_LOC
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE,
     V_YYYYMMDD, V_CURRENCY, V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID,
     V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_KRW'
         , V_YYYYMMDD, V_CURRENCY
         , CASE WHEN tmp.V_CURRENCY = 'KRW' THEN tmp.V_QTY
                WHEN tmp.V_CURRENCY = 'USD' THEN NVL(tmp.V_QTY * (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = 'USD' AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
                ELSE NVL(tmp.V_QTY * (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = tmp.V_CURRENCY AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
           END
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_LOC tmp
    WHERE  tmp.V_MEASURE     = 'SalesAmt_LOC'
    AND    V_ACTIVE_FLAG    <> 'D';

    --=============================================================================================================
    -- USD INSERT (SalesAmt_LOC → SalesAmt_USD 파생)
    --=============================================================================================================
    INSERT INTO GT_F021_SALES_PLAN_LOC
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE,
     V_YYYYMMDD, V_CURRENCY, V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID,
     V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_USD'
         , V_YYYYMMDD, V_CURRENCY
         , CASE WHEN tmp.V_CURRENCY = 'KRW' THEN NVL(tmp.V_QTY / (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = 'USD' AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
                WHEN tmp.V_CURRENCY = 'USD' THEN tmp.V_QTY
                ELSE NVL(tmp.V_QTY * (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = tmp.V_CURRENCY AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE)
                    / (SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                       WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                       AND UNIT_CURRENCY = 'USD' AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
           END
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_LOC tmp
    WHERE  tmp.V_MEASURE     = 'SalesAmt_LOC'
    AND    V_ACTIVE_FLAG    <> 'D';

    --=============================================================================================================
    -- Catch_Up 관련 메저 추가 (SalesAmt_KRW_Catch_Up, SalesAmt_LOC_Catch_Up, SalesAmt_USD_Catch_Up)
    --=============================================================================================================
    -- 1) SalesAmt_KRW_Catch_Up
    INSERT INTO GT_F021_SALES_PLAN
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_KRW_Catch_Up', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (SELECT FP.PRICE FROM DM_PLN_CFM_SELLING_PRICE FP
                             JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                             WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                             AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                             AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                             AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                             AND FP.MEASURE = 'KRW' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD
                             AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID AND ROWNUM = 1), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'Catch_Up' AND V_ACTIVE_FLAG <> 'D';
   
    -- 2) SalesAmt_LOC_Catch_Up
    INSERT INTO GT_F021_SALES_PLAN
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_LOC_Catch_Up', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (SELECT FP.PRICE FROM DM_PLN_CFM_SELLING_PRICE FP
                             JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                             WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                             AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                             AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                             AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                             AND FP.MEASURE = 'LOC' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD
                             AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID AND ROWNUM = 1), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'Catch_Up' AND V_ACTIVE_FLAG <> 'D';
    
    -- 3) SalesAmt_USD_Catch_Up
    INSERT INTO GT_F021_SALES_PLAN
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_USD_Catch_Up', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (SELECT FP.PRICE FROM DM_PLN_CFM_SELLING_PRICE FP
                             JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                             WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                             AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                             AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                             AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                             AND FP.MEASURE = 'USD' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD
                             AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID AND ROWNUM = 1), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'Catch_Up' AND V_ACTIVE_FLAG <> 'D';

    --=============================================================================================================
    -- DM_PLN_SALES_ETC_PLAN INSERT
    --=============================================================================================================
    -- SELECT COUNT(1) INTO n_insert_count FROM GT_F021_SALES_PLAN WHERE V_MEASURE IN ('SalesAmt_LOC','Catch_Up');

    INSERT INTO DM_PLN_SALES_ETC_PLAN
    (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, REMARK_TEXT,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1,
     ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_TEXT,
           V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY, V_QTY,
           V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE, V_DEPT_ID,
           NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    FROM   GT_F021_SALES_PLAN_LOC
    WHERE  V_ACTIVE_FLAG <> 'D';

    n_insert_count := n_insert_count + SQL%ROWCOUNT;

    
    
    -- HISTORY INSERT
    INSERT INTO DM_PLN_SALES_ETC_PLAN_H
    (DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, REMARK_TEXT,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1,
     ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
    SELECT V_DIVISION_ID, 
    SEQ1_DM_PLN_SALES_PLAN_H.NEXTVAL,
    V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_TEXT,
           V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY, V_QTY,
           V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE, V_DEPT_ID,
           NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, V_ACTIVE_FLAG
    FROM   GT_F021_SALES_PLAN_LOC;

    n_insert_count := n_insert_count + SQL%ROWCOUNT;
    --DBMS_OUTPUT.PUT_LINE('DM_PLN_SALES_ETC_PLAN_H: '||n_insert_count);
    
    --=============================================================================================================
    -- RTF_SYS_RP 기반 SalesAmt_KRW/LOC/USD 파생 INSERT into GT_F021_SALES_PLAN_RTF
    -- (판가 조회: SCM_MST_FUTURE_PRICE 또는 DM_PLN_CFM_SELLING_PRICE - 사업부별 분기)
    --=============================================================================================================
    -- 1) RTF_SYS_RP → SalesAmt_KRW
    INSERT INTO GT_F021_SALES_PLAN_RTF
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_KRW', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (
              SELECT PRICE FROM (
                  SELECT 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM SCM_MST_FUTURE_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'KRW' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
                  UNION ALL
                  SELECT 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM DM_PLN_CFM_SELLING_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'KRW' AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID
                  AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
              ) AA WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' THEN 'DM_PLN_CFM_SELLING_PRICE' ELSE 'SCM_MST_FUTURE_PRICE' END
           ), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF tmp
    WHERE  tmp.V_MEASURE = 'RTF_SYS_RP' AND V_ACTIVE_FLAG <> 'D';

    -- 2) RTF_SYS_RP → SalesAmt_LOC (동일 패턴, MEASURE='LOC')
    INSERT INTO GT_F021_SALES_PLAN_RTF
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_LOC', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (
              SELECT PRICE FROM (
                  SELECT 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM SCM_MST_FUTURE_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'LOC' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
                  UNION ALL
                  SELECT 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM DM_PLN_CFM_SELLING_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'LOC' AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID
                  AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
              ) AA WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' THEN 'DM_PLN_CFM_SELLING_PRICE' ELSE 'SCM_MST_FUTURE_PRICE' END
           ), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF tmp
    WHERE  tmp.V_MEASURE = 'RTF_SYS_RP' AND V_ACTIVE_FLAG <> 'D';

    -- 3) RTF_SYS_RP → SalesAmt_USD (동일 패턴, MEASURE='USD')
    INSERT INTO GT_F021_SALES_PLAN_RTF
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_USD', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (
              SELECT PRICE FROM (
                  SELECT 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM SCM_MST_FUTURE_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'USD' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
                  UNION ALL
                  SELECT 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM DM_PLN_CFM_SELLING_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'USD' AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID
                  AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
              ) AA WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' THEN 'DM_PLN_CFM_SELLING_PRICE' ELSE 'SCM_MST_FUTURE_PRICE' END
           ), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'RTF_SYS_RP' AND V_ACTIVE_FLAG <> 'D';

    --=============================================================================================================
    -- DM_PLN_SALES_PLAN INSERT (RTF_SYS_RP 계열)
    --=============================================================================================================
    INSERT INTO DM_PLN_SALES_PLAN
    (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
     ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10,
     CELL_PROD_SITE_ID)
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID
         , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY, V_QTY
         , V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE
         , V_DEPT_ID, V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
         , V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF
    WHERE  V_MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
    AND    V_ACTIVE_FLAG <> 'D';

    n_insert_count := n_insert_count + SQL%ROWCOUNT;
    
    -- HISTORY INSERT
    INSERT INTO DM_PLN_SALES_PLAN_H
    (DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
     ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10,
     CELL_PROD_SITE_ID)
    SELECT V_DIVISION_ID, SEQ1_DM_PLN_SALES_PLAN_H.NEXTVAL, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID
         , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY, V_QTY
         , V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE
         , V_DEPT_ID, V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, V_ACTIVE_FLAG
         , V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF
    WHERE  V_MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

    n_insert_count := n_insert_count + SQL%ROWCOUNT;
    
    --=============================================================================================================
    -- [PJ2025-50017] CFM_MKT_DEMAND_PLAN / MKT_FCST 동기화
    --=============================================================================================================
    INSERT INTO GT_F021_SALES_PLAN_INSERT
    (V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID,
     V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_LAST_UPDATED_BY,
     V_CELL_PROD_SITE_ID, V_YYYYMM, V_FROM_SITE_ID)
    SELECT DISTINCT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID
         , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_LAST_UPDATED_BY
         , V_CELL_PROD_SITE_ID, SUBSTR(V_YYYYMMDD,1,6), V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF;

    --COMMIT;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_F021_SALES_PLAN_INSERT',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);

    -- DELETE CFM_MKT_DEMAND_PLAN
    DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN
    WHERE DIVISION_ID = v_division_id_val
    AND   MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW')
    AND   EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z
        WHERE Z.V_DIVISION_ID      = DM_PLN_CFM_MKT_DEMAND_PLAN.DIVISION_ID
        AND   Z.V_PROJECT_CODE     = DM_PLN_CFM_MKT_DEMAND_PLAN.PROJECT_CODE
        AND   Z.V_SCM_SITE_ID      = DM_PLN_CFM_MKT_DEMAND_PLAN.SCM_SITE_ID
        AND   Z.V_ITEM_ID          = DM_PLN_CFM_MKT_DEMAND_PLAN.ITEM_ID
        AND   Z.V_DOM_EXP          = DM_PLN_CFM_MKT_DEMAND_PLAN.DOM_EXP
        AND   Z.V_FCST_TYPE        = DM_PLN_CFM_MKT_DEMAND_PLAN.FCST_TYPE
        AND   Z.V_INCOTERMS        = DM_PLN_CFM_MKT_DEMAND_PLAN.INCOTERMS
        AND   Z.V_MEASURE          = DM_PLN_CFM_MKT_DEMAND_PLAN.MEASURE
        AND   Z.V_PLANT_SITE_ID    = DM_PLN_CFM_MKT_DEMAND_PLAN.PLANT_SITE_ID
        AND   Z.V_CELL_PROD_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN.CELL_PROD_SITE_ID
        AND   Z.V_YYYYMM           = SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN.YYYYMMDD, 1, 6)
    );

    n_del_count := n_del_count + SQL%ROWCOUNT;
    
    -- INSERT CFM_MKT_DEMAND_PLAN
    INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN
    (DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
     MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE,
     LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
     ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
         , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
         , A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, NULL, Z.V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    FROM   DM_PLN_SALES_PLAN A
    JOIN   GT_F021_SALES_PLAN_INSERT Z
        ON  A.DIVISION_ID          = Z.V_DIVISION_ID
        AND A.PROJECT_CODE         = Z.V_PROJECT_CODE
        AND A.SCM_SITE_ID          = Z.V_SCM_SITE_ID
        AND A.ITEM_ID              = Z.V_ITEM_ID
        AND A.DOM_EXP              = Z.V_DOM_EXP
        AND A.FCST_TYPE            = Z.V_FCST_TYPE
        AND A.INCOTERMS            = Z.V_INCOTERMS
        AND A.MEASURE              = Z.V_MEASURE
        AND A.PLANT_SITE_ID        = Z.V_PLANT_SITE_ID
        AND A.CELL_PROD_SITE_ID    = Z.V_CELL_PROD_SITE_ID
        AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
    WHERE  A.DIVISION_ID = v_division_id_val
    AND    A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW');

    n_insert_count := n_insert_count + SQL%ROWCOUNT;
    
    -- DELETE/INSERT DM_PLN_MKT_FCST
    DELETE FROM DM_PLN_MKT_FCST
    WHERE DIVISION_ID = v_division_id_val
    AND   MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
    AND   EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z
        WHERE Z.V_DIVISION_ID   = DM_PLN_MKT_FCST.DIVISION_ID
        AND   Z.V_PROJECT_CODE  = DM_PLN_MKT_FCST.PROJECT_CODE
        AND   Z.V_SCM_SITE_ID   = DM_PLN_MKT_FCST.SCM_SITE_ID
        AND   Z.V_ITEM_ID       = DM_PLN_MKT_FCST.ITEM_ID
        AND   Z.V_DOM_EXP       = DM_PLN_MKT_FCST.DOM_EXP
        AND   Z.V_FCST_TYPE     = DM_PLN_MKT_FCST.FCST_TYPE
        AND   Z.V_INCOTERMS     = DM_PLN_MKT_FCST.INCOTERMS
        AND   Z.V_MEASURE       = DM_PLN_MKT_FCST.MEASURE
        AND   Z.V_PLANT_SITE_ID = DM_PLN_MKT_FCST.PLANT_SITE_ID
        AND   Z.V_YYYYMM        = SUBSTR(DM_PLN_MKT_FCST.YYYYMMDD, 1, 6)
    );

    n_del_count := n_del_count + SQL%ROWCOUNT;

    
    INSERT INTO DM_PLN_MKT_FCST
    (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
     MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
         , A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
         , MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
    FROM   DM_PLN_SALES_PLAN A
    JOIN   GT_F021_SALES_PLAN_INSERT Z
        ON  A.DIVISION_ID          = Z.V_DIVISION_ID
        AND A.PROJECT_CODE         = Z.V_PROJECT_CODE
        AND A.SCM_SITE_ID          = Z.V_SCM_SITE_ID
        AND A.ITEM_ID              = Z.V_ITEM_ID
        AND A.DOM_EXP              = Z.V_DOM_EXP
        AND A.FCST_TYPE            = Z.V_FCST_TYPE
        AND A.INCOTERMS            = Z.V_INCOTERMS
        AND A.MEASURE              = Z.V_MEASURE
        AND A.PLANT_SITE_ID        = Z.V_PLANT_SITE_ID
        AND A.CELL_PROD_SITE_ID    = Z.V_CELL_PROD_SITE_ID
        AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
    WHERE  A.DIVISION_ID = v_division_id_val
    AND    A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
           , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD;

    n_insert_count := n_insert_count + SQL%ROWCOUNT;
    
    --=============================================================================================================
    -- VERSION 기반 _C 테이블 동기화 (MF_W, SF_W)
    --=============================================================================================================
    -- MF_W VERSION
    SELECT MAX(VERSION_NO) INTO v_max_mf_w_version
    FROM   DM_MST_VERSION
    WHERE  DIVISION_ID  = v_division_id_val
    AND    VERSION_TYPE = 'MF_W'
    AND    YYYYMMDD    >= v_cutoff_start
    AND    YYYYMMDD     < v_cutoff_end;

    
    IF v_max_mf_w_version IS NOT NULL THEN
        SELECT YYYYMMDD INTO v_max_mf_w_yyyymmdd
        FROM   DM_MST_VERSION
        WHERE  DIVISION_ID  = v_division_id_val
        AND    VERSION_NO   = v_max_mf_w_version
        AND    VERSION_TYPE = 'MF_W';

        -- DELETE/INSERT DM_PLN_CFM_MKT_DEMAND_PLAN_C (MF_W)
        DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
        WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_mf_w_version AND CUTOFF_TYPE = 'MF_W'
        AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW')
        AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.MEASURE AND Z.V_PLANT_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID AND Z.V_CELL_PROD_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID AND Z.V_YYYYMM = SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD,1,6));
        
        n_del_count := n_del_count + SQL%ROWCOUNT;
        
        INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        SELECT A.DIVISION_ID, v_max_mf_w_version, 'MF_W', v_max_mf_w_yyyymmdd, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, NULL, Z.V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND A.PLANT_SITE_ID = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW');
        
        n_insert_count := n_insert_count + SQL%ROWCOUNT;
        
        -- DELETE/INSERT DM_PLN_MKT_FCST_C (MF_W)
        DELETE FROM DM_PLN_MKT_FCST_C WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_mf_w_version AND CUTOFF_TYPE = 'MF_W' AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP') AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_MKT_FCST_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_MKT_FCST_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_MKT_FCST_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_MKT_FCST_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_MKT_FCST_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_MKT_FCST_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_MKT_FCST_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_MKT_FCST_C.MEASURE AND Z.V_PLANT_SITE_ID = DM_PLN_MKT_FCST_C.PLANT_SITE_ID AND Z.V_YYYYMM = SUBSTR(DM_PLN_MKT_FCST_C.YYYYMMDD,1,6));

        n_del_count := n_del_count + SQL%ROWCOUNT;
        
        INSERT INTO DM_PLN_MKT_FCST_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT A.DIVISION_ID, v_max_mf_w_version, 'MF_W', v_max_mf_w_yyyymmdd, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND A.PLANT_SITE_ID = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD;
        
        n_insert_count := n_insert_count + SQL%ROWCOUNT;
        
    END IF;

    -- SF_W VERSION (동일 패턴)
    SELECT MAX(VERSION_NO) INTO v_max_sf_w_version
    FROM   DM_MST_VERSION
    WHERE  DIVISION_ID  = v_division_id_val
    AND    VERSION_TYPE = 'SF_W'
    AND    YYYYMMDD    >= v_cutoff_start
    AND    YYYYMMDD     < v_cutoff_end;

    
    IF v_max_sf_w_version IS NOT NULL THEN
        SELECT YYYYMMDD INTO v_max_sf_w_yyyymmdd
        FROM   DM_MST_VERSION
        WHERE  DIVISION_ID  = v_division_id_val AND VERSION_NO = v_max_sf_w_version AND VERSION_TYPE = 'SF_W';

        DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_sf_w_version AND CUTOFF_TYPE = 'SF_W' AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW') AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.MEASURE AND Z.V_PLANT_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID AND Z.V_CELL_PROD_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID AND Z.V_YYYYMM = SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD,1,6));

        INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        SELECT A.DIVISION_ID, v_max_sf_w_version, 'SF_W', v_max_sf_w_yyyymmdd, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, NULL, Z.V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND A.PLANT_SITE_ID = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW');
        
        n_insert_count := n_insert_count + SQL%ROWCOUNT;
        
        DELETE FROM DM_PLN_MKT_FCST_C WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_sf_w_version AND CUTOFF_TYPE = 'SF_W' AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP') AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_MKT_FCST_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_MKT_FCST_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_MKT_FCST_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_MKT_FCST_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_MKT_FCST_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_MKT_FCST_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_MKT_FCST_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_MKT_FCST_C.MEASURE AND Z.V_PLANT_SITE_ID = DM_PLN_MKT_FCST_C.PLANT_SITE_ID AND Z.V_YYYYMM = SUBSTR(DM_PLN_MKT_FCST_C.YYYYMMDD,1,6));

        n_del_count := n_del_count + SQL%ROWCOUNT;

        INSERT INTO DM_PLN_MKT_FCST_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT A.DIVISION_ID, v_max_sf_w_version, 'SF_W', v_max_sf_w_yyyymmdd, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND A.PLANT_SITE_ID = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, 
        A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, 
        v_max_sf_w_version, 'SF_W', v_max_sf_w_yyyymmdd;

        n_insert_count := n_insert_count + SQL%ROWCOUNT;

    END IF;
    
    COMMIT;

    -- 종료 LOG
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := 'delete_count= ' || TO_CHAR(n_del_count) || ' / insert_count= ' || TO_CHAR(n_insert_count);
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


    IF P_ACTIVE_FLAG = 'I' THEN
        n_event_count := n_insert_count;
    ELSIF P_ACTIVE_FLAG = 'D' THEN
        n_event_count := n_del_count; 
    END IF;

    OPEN O_RESULT_CURSOR FOR 
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_event_count) AS EVENT FROM DUAL;


    RETURN;

    --=============================================================================================================
    -- VALIDATION FAIL 처리
    --=============================================================================================================
    <<VALIDATION_FAIL>>
    ROLLBACK;
    v_log_message := V_S_CODE;
    v_description := V_S_CODE || '^' || V_S_VALIDATION;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
        

    OPEN O_RESULT_CURSOR FOR
    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_S_CODE || '^' || V_S_VALIDATION AS EVENT FROM DUAL;
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DIVISION_ID' VALUE SUBSTR(P_DIVISION_ID,1,500),
            'P_CREATED_BY'  VALUE P_CREATED_BY
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL;

END PKG_DMF0021;
/
