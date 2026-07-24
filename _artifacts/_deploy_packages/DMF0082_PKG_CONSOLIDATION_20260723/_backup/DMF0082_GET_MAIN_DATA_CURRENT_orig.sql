CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0082_GET_MAIN_DATA_CURRENT" 
/* [DIV81] 2026-07-14 admin: Division 81(LIKE '81%') 시 GTT 스테이징 INSERT 만 81 테이블(DM_PLN_MKT_FCST(_C)/SCM_MST_FUTURE_PRICE(_C))로 분기. END_CUSTOMER/CELL_PROD_SITE_ID 는 '-' 리터럴 (컬럼 부재 — ALL_TAB_COLUMNS 실측). 하류(pivot/커서) 공통. 40 원문 무수정. */
(
    p_division_id    IN  VARCHAR2
  , p_team_id        IN  VARCHAR2
  , p_customer       IN  VARCHAR2
  , p_biz_type       IN  VARCHAR2
  , p_from_yyyymmdd  IN  VARCHAR2
  , p_to_yyyymmdd    IN  VARCHAR2
  , p_scm_site_id    IN  VARCHAR2
  , p_item_id        IN  VARCHAR2
  , p_version_type   IN  VARCHAR2
  , p_qty_yn         IN  VARCHAR2
  , p_created_by     IN  VARCHAR2
  , p_user_group     IN  VARCHAR2
  , O_RC1            OUT SYS_REFCURSOR   /* 1) 동적 PIVOT 메인 데이터 */
  , O_RC2            OUT SYS_REFCURSOR   /* 2) M+3 월 MONTH_NAME/ISO_WEEK (Monthly 입력제한 기준) */
  , O_RC3            OUT SYS_REFCURSOR   /* 3) 현재/전주 주차 정보 */
  , O_RC4            OUT SYS_REFCURSOR   /* 4) 메저별 EDIT_FLAG (GET_ADMIN_GROUP_MEASURE) */
  , O_RC5            OUT SYS_REFCURSOR   /* 5) 조회구간 캘린더 분배 정보 (M+4 월간 물량 배분용) */
  , O_RESULT_CURSOR  OUT SYS_REFCURSOR   /* 표준 결과 커서 (RESULT_CODE/RESULT_MSG/EVENT) */
)
/*=====================================================================================================================================================
 * Program ID  : DMF0082_GET_MAIN_DATA_CURRENT
 * Description : Procedure 작성 가이드
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=====================================================================================================================================================
 * Date             In Charge    Description
 *=====================================================================================================================================================
 * 2026.01.09       park.choyi   Initial Release (MSSQL)
 * 2026-07-12       Claude       MSSQL dbo.DMF0082_GET_MAIN_DATA_CURRENT → Oracle 19c 1:1 변환 (파일 산출물 — DB 미적용)
 *
 * EXEC DMF0082_GET_MAIN_DATA_CURRENT '40','ALL','ALL','ALL','20260101','20260731','ALL','','Current','Y','park.choyi','ADMIN'
 *=====================================================================================================================================================
 * [변환 노트 — 부록 C 함정 처리 / GTT 재사용]
 *  - #temp 13종 → 기존 GTT_* family 13종 전량 재사용 (컬럼 1:1 실측 일치 — 00_gtt_ddl.sql 헤더 참조. 신규 GTT 불필요):
 *      #TEMP_DM_MST_ITEM_SINGLE_V → GTT_TEMP_DM_MST_ITEM_SINGLE_V / #TempSiteItemAll → GTT_TEMPSITEITEMALL / #TempSiteItem → GTT_TEMPSITEITEM
 *      #TempSelectMeasure → GTT_TEMPSELECTMEASURE / #T_LAST_DATA_SETUP_FCST → GTT_T_LAST_DATA_SETUP_FCST / #T_LAST_DATA_SETUP_PRICE → GTT_T_LAST_DATA_SETUP_PRICE
 *      #T_WS_FCST → GTT_T_WS_FCST / #TempFcstNPrice → GTT_TEMPFCSTNPRICE / #TEMP_INTO_GROUP_MEASURE → GTT_TEMP_INTO_GROUP_MEASURE
 *      #TEMP_ADMIN_GROUP_MEASURE → GTT_TEMP_ADMIN_GROUP_MEASURE / #CAL_MONTH_END_DATE → GTT_CAL_MONTH_END_DATE / #CAL_WEEK_END_DATE → GTT_CAL_WEEK_END_DATE
 *      #MF_SP → GTT_MF_SP
 *  - GTT 초기화 = DELETE FROM (C-2: TRUNCATE 금지 — mutex hang / C-5: INSERT 전 DELETE 의무)
 *  - @@FETCH_STATUS WHILE 루프 2개(C_BUCKET/C_TITLE) → LOOP + FETCH 직후 EXIT WHEN %NOTFOUND (C-10 — 무한루프 방지)
 *  - 동적 SQL/PIVOT 리스트 누적 = CLOB (hook #106) + [@...] placeholder REPLACE 방식은 AS-IS 그대로 유지.
 *    단, AS-IS 는 '[@v_PV_COL_LIST]' 를 @v_PV_LIST 로 치환(MSSQL 에선 두 형태 동일 문자열이라 무해) —
 *    Oracle 은 PIVOT IN 리스트('D_x' AS D_x)와 SELECT 컬럼 리스트(D_x)가 다르므로 각각 올바르게 치환 (원문 버그 교정, 결과 동일)
 *  - MSSQL PIVOT ([D_x],...) → Oracle PIVOT ('D_x' AS D_x, ...) / 서브쿼리·PIVOT 사이 alias 불가 → alias 는 PIVOT 뒤로 이동
 *  - OPTION (ORDER GROUP) MSSQL 힌트 제거
 *  - SUBSTRING(F.OWNER, 0, CHARINDEX...) 첫 토큰 추출 → CASE WHEN INSTR=0 THEN OWNER ELSE SUBSTR(OWNER,1,INSTR-1) END (C-1 SUBSTR-0 함정 회피)
 *  - STUFF(...FOR XML PATH(''))(OWNER 이름 결합) → LISTAGG / STRING_SPLIT → REGEXP_SUBSTR CONNECT BY (룰 4/5)
 *  - CASE WHEN @P = 'ALL' THEN @P ELSE col END IN (SPLIT(@P)) → (@P = 'ALL' OR col IN (SPLIT(@P))) 동치 변환
 *  - ISNULL(x,'')='' / <>'' → IS NULL / IS NOT NULL, ISNULL(x,'') 표시값 → x (Oracle '' = NULL, C-7)
 *  - '' AS CURRENCY / '' AS LAST_DAY_YN 류 → NULL (C-7)
 *  - ISNULL(T2.FORECAST_INFO_CELL_MODEL,'') = T4.ITEM_ID → T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID (''=NULL 은 어떤 값과도 불일치 — 결과 동일)
 *  - LIKE '%CURRENT%' (MSSQL 대소문자 무시 collation) → UPPER(p_version_type) LIKE '%CURRENT%'
 *  - DATEPART(WEEKDAY,GETDATE()) 1~7 → 요일 3문자 매핑 → TO_CHAR(SYSDATE,'DY','NLS_DATE_LANGUAGE=ENGLISH') (C-11: 세션 NLS 비의존)
 *  - CONVERT(CHAR(8),GETDATE(),24)/112, FORMAT(...,'yyyyMM'), DATEADD → TO_CHAR/ADD_MONTHS 명시 마스크 (C-11)
 *  - DATEADD(YY,-1,@p_from_yyyymmdd)(문자열 암묵 DATE 변환) → ADD_MONTHS(TO_DATE(p_from_yyyymmdd,'YYYYMMDD'),-12) 명시 (C-11)
 *  - DATEADD(WEEK,50,@p_from_yyyymmdd) → TO_DATE(p_from_yyyymmdd,'YYYYMMDD') + 50*7 명시 (C-11)
 *  - OUTER APPLY (SELECT TOP(1) ... ORDER BY) → LEFT JOIN LATERAL (... ORDER BY ... FETCH FIRST 1 ROWS ONLY) ON 1=1
 *  - UPDATE ... FROM JOIN (CURRENCY 일괄 UPDATE / ADMIN_GROUP EDIT_FLAG UPDATE) → MERGE(GROUP BY+MAX 로 ORA-30926 방지) / EXISTS (룰 #30)
 *  - MSSQL UPDATE JOIN 다중매치 임의채택 → MAX() 결정적 채택 (주석 명시)
 *  - AS-IS C_TITLE 2번째 UNION 의 C.DEFAULT_FLAG = '' → C.DEFAULT_FLAG IS NULL (C-7. 사내 실측: DEFAULT_FLAG NULL 11건 존재)
 *  - #FCST 일부 서브쿼리의 DIVISION_ID = '40' 하드코딩 (LOOKA/BC) 은 AS-IS 원문 그대로 보존 (임의 수정 금지)
 *  - #TempSiteItemAll 의 K(SSO_DEPT_INFO) 조인 ELSE 분기 S.DEPT_ID: 사내 SCM_MST_SITE.DEPT_ID 컬럼 삭제(Case 39)로
 *    기존 변환 표준(DMF0082_GET_MAIN_DATA)과 동일하게 F.DEPT_ID 사용. (K 는 SELECT 미참조 — 결과 영향 0)
 *  - MSSQL WHILE 커서 결과 PRINT 류 → DBMS_OUTPUT.PUT_LINE (A00x 진행 로그는 원문 유지 목적상 주석으로 보존)
 *  - EXEC PR_DM_SYS_LOG_BATCH 7-인자 → SCM_MGR.PR_DM_SYS_LOG_BATCH(...) 동일 7-인자 (8~11번째 default)
 *  - 표준 O_RESULT_CURSOR + WHEN OTHERS 핸들러 = DMF0082_SAVE_MAIN_DATA / DMF0082_GET_MAIN_DATA Oracle 표준 준수
 *===================================================================================================================================================*/
IS
    --=============================================================================================================================
    -- LOG 용 변수 설정 -- [E20250915-000105]_로그를 찍기위해서 LOG용 변수 추가
    --=============================================================================================================================
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    N_LOG_COUNT         NUMBER := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;

    --=============================================================================================================================
    -- 사용자 컬럼 및 메저 세팅 관련 변수
    --=============================================================================================================================
    V_USER_COL_CNT      NUMBER := 0;
    V_USER_MEA_CNT      NUMBER := 0;
    VA_PROGRAM_ID       VARCHAR2(50 CHAR) := 'DMF0082';
    VA_SHEET_NAME       VARCHAR2(50 CHAR) := 'FcstNPrice';

    --=============================================================================================================================
    -- BUCKET 관련 변수 (hook #106 — PIVOT 리스트 누적 = CLOB)
    --=============================================================================================================================
    V_EXP_YYYYMMDD      VARCHAR2(8 CHAR);
    V_PV_LIST           CLOB;               /* PIVOT IN 절: 'D_20260101' AS D_20260101, ... */
    V_PV_COL_LIST       CLOB;               /* 외부 SELECT 컬럼 리스트: D_20260101, ...      */
    V_PV_COLUMN_NAME    VARCHAR2(200 CHAR);
    V_PV_NAME           VARCHAR2(200 CHAR);
    V_SORT_ORDER_NO     VARCHAR2(50 CHAR);

    /* 조회 할 때 쓸 날짜 관련 변수 */
    V_FROM_YYYYMMDD     VARCHAR2(8 CHAR);
    V_TO_YYYYMMDD       VARCHAR2(8 CHAR);
    V_FROM_RESULT       VARCHAR2(8 CHAR);
    V_TO_RESULT         VARCHAR2(8 CHAR);
    V_USER_TIME_ZONE    VARCHAR2(50 CHAR);

    /* C_TITLE 커서에서만 사용 될 지역변수 */
    V_CUR_COLUMN_NAME   VARCHAR2(200 CHAR);
    V_CUR_PROGRAM_ID    VARCHAR2(50 CHAR);
    V_CUR_SHEET_NAME    VARCHAR2(100 CHAR);
    V_CUR_SORT_ORDER_NO VARCHAR2(50 CHAR);

    /* C_TITLE 커서에서 완성 된 후 동적쿼리에서 쓰여질 변수 */
    V_COLUMN            VARCHAR2(4000 CHAR);
    V_GROUPBY           VARCHAR2(4000 CHAR);
    V_ORDERBY           VARCHAR2(4000 CHAR);

    /* @v_group_id 권한 그룹 */
    V_GROUP_ID          VARCHAR2(50 CHAR) := '';
    V_ADMIN_CNT         NUMBER := 0;
    V_MEASURE_CNT       NUMBER := 0;
    V_LIMIT_CNT         NUMBER := 0;

    /* 최종적으로 실행하는 동적쿼리 */
    V_SQL_TEXT          CLOB;

    /* 표준 예외 변수 */
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(20 CHAR);
    V_SQL_ERRMSG        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);

    --=============================================================================================================================
    -- C_BUCKET : 선택한 bucket(D/W/M)의 동적 PIVOT 컬럼을 만드는 커서
    --  (MSSQL: '[D_x] AS D_x' / '[D_x]' → Oracle: 컬럼명 'D_x' / PIVOT IN piece '''D_x'' AS D_x')
    --  [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : CURSOR 선언에 LOCAL 추가 (Oracle 커서는 기본 local)
    --=============================================================================================================================
    CURSOR C_BUCKET IS
        SELECT 'D_' || A.BASIS_YYYYMMDD                                            AS COLUMN_NAME
             , '''D_' || A.BASIS_YYYYMMDD || ''' AS D_' || A.BASIS_YYYYMMDD        AS PV_NAME
             , A.BASIS_YYYYMMDD || '_31'                                           AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= V_EXP_YYYYMMDD
        UNION ALL
        SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK                                AS COLUMN_NAME
             , '''W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ''' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS PV_NAME
             , A.BASIS_START_DATE || '_21'                                         AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
        UNION ALL
        SELECT 'M_' || A.BASIS_YYYYMM                                              AS COLUMN_NAME
             , '''M_' || A.BASIS_YYYYMM || ''' AS M_' || A.BASIS_YYYYMM            AS PV_NAME
             , MIN(A.BASIS_START_DATE) || '_01'                                    AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM
        ORDER BY SORT_ORDER_NO;

    --=============================================================================================================================
    -- C_TITLE : 선택한 bucket의 값인 MONTH 혹은 WEEK를 이용해서 동적인 컬럼을 만드는 커서
    --=============================================================================================================================
    CURSOR C_TITLE IS
        SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , CASE WHEN U.COLUMN_NAME = 'LAST_UPDATE_DATE' THEN '800'
                    WHEN U.COLUMN_NAME = 'LAST_UPDATED_BY'  THEN '560'
                    ELSE TO_CHAR(U.SORT_ORDER_NO) END AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
             , SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = VA_PROGRAM_ID
        AND    U.SHEET_NAME  = VA_SHEET_NAME
        AND    U.USER_ID     = p_created_by
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        UNION ALL
        /* 2024/05/17   kcw3408     이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , TO_CHAR(CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN NVL(U.SORT_ORDER_NO, 85) - 0.5
                            ELSE C.SORT_ORDER_NO END) AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        LEFT OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
            ON  U.PROGRAM_ID  = C.PROGRAM_ID
            AND U.SHEET_NAME  = C.SHEET_NAME
            AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
            AND U.COLUMN_NAME IN ('ITEM_ID')
            AND U.USER_ID     = p_created_by
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        AND    C.DEFAULT_FLAG IS NULL              /* AS-IS: C.DEFAULT_FLAG = '' (C-7: Oracle '' = NULL) */
        AND    C.VALID_YN     = 'Y'
        ORDER BY SORT_ORDER_NO;

BEGIN
    --PRINT @v_program_name + ' : A001--' ... 'DMF0082_GET_MAIN_DATA_CURRENT 조회쿼리 시작'
    V_PROC_INPUT := JSON_OBJECT(
        'p_division_id'   VALUE p_division_id,
        'p_team_id'       VALUE p_team_id,
        'p_customer'      VALUE p_customer,
        'p_biz_type'      VALUE p_biz_type,
        'p_from_yyyymmdd' VALUE p_from_yyyymmdd,
        'p_to_yyyymmdd'   VALUE p_to_yyyymmdd,
        'p_scm_site_id'   VALUE p_scm_site_id,
        'p_item_id'       VALUE p_item_id,
        'p_version_type'  VALUE p_version_type,
        'p_qty_yn'        VALUE p_qty_yn,
        'p_created_by'    VALUE p_created_by,
        'p_user_group'    VALUE p_user_group
    );

    --=============================================================================================================================
    -- 시작 LOG (START)  -- [E20250915-000105]_로그를 찍기위해서 LOG 추가
    --=============================================================================================================================
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, p_created_by);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    /* [DEFECT_GUARD] p_from_yyyymmdd / p_to_yyyymmdd 형식 검증 (ORA-01841 방어 — 기존 DMF0082_GET_MAIN_DATA 표준) */
    IF p_from_yyyymmdd IS NULL OR NOT REGEXP_LIKE(p_from_yyyymmdd, '^[0-9]{8}$')
       OR SUBSTR(p_from_yyyymmdd, 1, 4) = '0000' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid p_from_yyyymmdd: ' || NVL(p_from_yyyymmdd, '<NULL>'));
    END IF;
    IF p_to_yyyymmdd IS NULL OR NOT REGEXP_LIKE(p_to_yyyymmdd, '^[0-9]{8}$')
       OR SUBSTR(p_to_yyyymmdd, 1, 4) = '0000' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid p_to_yyyymmdd: ' || NVL(p_to_yyyymmdd, '<NULL>'));
    END IF;

    -------------------------------------------------------------------------------------------------------------------------------
    -- 사용자 컬럼 처리 (START)
    -------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*)
    INTO   V_USER_COL_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    U.USER_ID    = p_created_by;

    IF V_USER_COL_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME
        , SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE
        , LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT p_created_by, C.PROGRAM_ID, C.SHEET_NAME, 'C', C.COLUMN_NAME
             , C.SORT_ORDER_NO, 'N', '', p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
             , p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;
    -------------------------------------------------------------------------------------------------------------------------------
    -- 사용자 컬럼 처리 (END) / 사용자 메저 처리 (START)
    -------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*)
    INTO   V_USER_MEA_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.USER_ID    = p_created_by;

    IF V_USER_MEA_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME
        , SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE
        , LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT p_created_by, C.PROGRAM_ID, C.SHEET_NAME, 'M', C.COLUMN_NAME
             , C.SORT_ORDER_NO, 'N', '', p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
             , p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;
    -------------------------------------------------------------------------------------------------------------------------------
    -- 사용자 메저 처리 (END)
    -------------------------------------------------------------------------------------------------------------------------------

    --=============================================================================================================================
    -- BUCKET 관련 세팅 시작 (START)  — @V_PV_COL_LIST , @V_PV_LIST 만들기
    --=============================================================================================================================
    /* SET @V_EXP_YYYYMMDD = CONVERT(NVARCHAR(8), DATEADD(WEEK, 50, @p_from_yyyymmdd), 112);  (C-11 명시 마스크) */
    V_EXP_YYYYMMDD := TO_CHAR(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD') + (50 * 7), 'YYYYMMDD');

    DBMS_LOB.CREATETEMPORARY(V_PV_LIST, TRUE);
    DBMS_LOB.CREATETEMPORARY(V_PV_COL_LIST, TRUE);

    OPEN C_BUCKET;
    LOOP
        FETCH C_BUCKET INTO V_PV_COLUMN_NAME, V_PV_NAME, V_SORT_ORDER_NO;
        EXIT WHEN C_BUCKET%NOTFOUND;          /* C-10: FETCH 직후 종료 판정 의무 */
        IF DBMS_LOB.GETLENGTH(V_PV_COL_LIST) = 0 THEN
            V_PV_COL_LIST := V_PV_COLUMN_NAME;
            V_PV_LIST     := V_PV_NAME;
        ELSE
            V_PV_COL_LIST := V_PV_COL_LIST || ',' || V_PV_COLUMN_NAME;
            V_PV_LIST     := V_PV_LIST     || ',' || V_PV_NAME;
        END IF;
    END LOOP;
    CLOSE C_BUCKET;
    --=============================================================================================================================
    -- BUCKET 관련 세팅 종료 (END)
    --=============================================================================================================================

    --=============================================================================================================================
    -- Version 관련 세팅 시작 (START)
    --=============================================================================================================================
    /* (AS-IS 원문 공란) */
    --=============================================================================================================================
    -- Version 관련 세팅 시작 (END)
    --=============================================================================================================================

    --=============================================================================================================================
    -- GTT 초기화 (AS-IS: IF OBJECT_ID ... DROP TABLE / CREATE TABLE — Oracle: DELETE FROM, C-2/C-5)
    --=============================================================================================================================
    DELETE FROM SCM_MGR.GTT_TEMP_DM_MST_ITEM_SINGLE_V;
    DELETE FROM SCM_MGR.GTT_TEMPSITEITEMALL;
    DELETE FROM SCM_MGR.GTT_TEMPSITEITEM;
    DELETE FROM SCM_MGR.GTT_TEMPSELECTMEASURE;
    DELETE FROM SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST;
    DELETE FROM SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE;
    DELETE FROM SCM_MGR.GTT_T_WS_FCST;
    DELETE FROM SCM_MGR.GTT_TEMPFCSTNPRICE;
    DELETE FROM SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE;
    DELETE FROM SCM_MGR.GTT_TEMP_ADMIN_GROUP_MEASURE;
    DELETE FROM SCM_MGR.GTT_CAL_MONTH_END_DATE;
    DELETE FROM SCM_MGR.GTT_CAL_WEEK_END_DATE;
    DELETE FROM SCM_MGR.GTT_MF_SP;

    --=============================================================================================================================
    -- #TempSiteItem 만들기 시작 (START)
    --  1. #TEMP_DM_MST_ITEM_SINGLE_V 만들기 위해서 ORI_V , A_V , B_V 3개 만들기 그 후 최종적으로 완성
    --     → 2026.01.13 #TEMP_DM_MST_ITEM_SINGLE_V 는 DM_MST_ITEM_SINGLE_V 으로 대체 (AS-IS 원문의 ORI/A/B 블록은 주석 처리됨)
    --  2. #TempSiteItemAll에서 위에서 만든 #TEMP_DM_MST_ITEM_SINGLE_V 사용해서 만들기
    --  3. #TempSiteItemAll를 만든뒤 최종적으로 #TempSiteItem 만들기
    --=============================================================================================================================
    INSERT INTO SCM_MGR.GTT_TEMP_DM_MST_ITEM_SINGLE_V
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
    , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
    , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE
    , ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
    SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
         , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
         , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE
         , ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    FROM   SCM_MGR.DM_MST_ITEM_SINGLE_V
    WHERE  DIVISION_ID = '40'
    AND    ACTIVE_FLAG = 'Y';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_TEMP_DM_MST_ITEM_SINGLE_V', NO_INVALIDATE => FALSE);

    -------------------------------------------------------------------------------------------------------------------------------
    -- #TempSiteItem(All) 만들기 (START)
    -------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GTT_TEMPSITEITEMALL
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
    , CELL_MODEL, END_CUSTOMER, SOLDTO_CUSTOMER
    , COUNTRY, COUNTRY_NAME, CITY, CITY_NAME
    , OWNER, PROJECT_OWNER, USER_ID, ITEM_NAME, ITEM_TYPE
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME
    , MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, CELL_TYPE, FORECAST_INFO_CELL_PACK_COUNT
    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
    , CELL_MODEL_NICK_NAME, VMI_YN, DMS_SALES, DMS_CUSTOMER, DEPT_ID, DEPT_NAME_KO
    , ITEM_VALID_YN )
    SELECT F.DIVISION_ID
         , F.PROJECT_CODE
         , F.SCM_SITE_ID
         , F.ITEM_ID
         , T2.NICK_NAME
         , F.PROJECT_CODE                                   AS PROJECT_NAME
         , F.ATTRIBUTE5                                     AS CELL_MODEL
         , S.END_CUSTOMER
         , S.SOLDTO_CUSTOMER
         , I.COUNTRY
         , I.COUNTRY_NAME
         , H.CITY
         , H.CITY_NAME
         /* STUFF( ... FOR XML PATH('') ) OWNER 다중 사용자 이름 결합 → LISTAGG (AS-IS 로직 동일) */
         , (SELECT LISTAGG(XA.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY XA.USER_NAME_EN)
            FROM  (SELECT DISTINCT ZA.USER_NAME_EN
                   FROM   SCM_MGR.SCM_MST_SSO_USER_INFO ZA
                   WHERE  ZA.USER_ID IN (SELECT REGEXP_SUBSTR(F.OWNER, '[^,]+', 1, LEVEL)
                                         FROM   DUAL
                                         CONNECT BY LEVEL <= NVL(REGEXP_COUNT(F.OWNER, ','), 0) + 1)) XA
           )                                                AS OWNER
         , J.USER_NAME_EN                                   AS PROJECT_OWNER
         , J.USER_ID
         , T2.ITEM_NAME
         , T2.ITEM_TYPE
         , F.CUST_GROUP
         , F.CUST_GROUP_DTL
         , F.APPLICATION
         , F.ROUTE
         , T2.MDM_PROJECT_NAME
         , T2.MIN_CAPACITY
         , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                ELSE T2.FORECAST_INFO_BIZ_TYPE END          AS FORECAST_INFO_BIZ_TYPE
         , T2.FORECAST_INFO_PRODUCT_GROUP
         , LOOK.NAME                                        AS CELL_TYPE
         , CASE WHEN F.ITEM_ID = LOOKA.MODEL
                THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT DEFAULT NULL ON CONVERSION ERROR)
                ELSE T2.FORECAST_INFO_CELL_PACK_COUNT END   AS FORECAST_INFO_CELL_PACK_COUNT
         , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL
         , T2.FORECAST_INFO_SPEC                            AS FORECAST_INFO_SPEC
         , T2.FORECAST_INFOR_VERSION                        AS FORECAST_INFOR_VERSION
         , T4.NICK_NAME                                     AS CELL_MODEL_NICK_NAME   /* ISNULL(T4.NICK_NAME,'') → '' = NULL (C-7) */
         , S.VMI_YN
         , F.ATTRIBUTE1                                     AS DMS_SALES              /* ISNULL(F.ATTRIBUTE1,'') → '' = NULL (C-7) */
         , F.ATTRIBUTE2                                     AS DMS_CUSTOMER           /* ISNULL(F.ATTRIBUTE2,'') → '' = NULL (C-7) */
         , TEAM.DEPT_ID
         , TEAM.DEPT_NAME_KO
         , F.VALID_YN                                       AS ITEM_VALID_YN
    FROM   SCM_MGR.SCM_MST_SITE_ITEM F
    INNER JOIN SCM_MGR.GTT_TEMP_DM_MST_ITEM_SINGLE_V T2
        ON  F.DIVISION_ID = T2.DIVISION_ID
        AND F.ITEM_ID     = T2.ITEM_ID
    INNER JOIN (SELECT DISTINCT '%' || TOKEN || '%' AS TST
                FROM  (SELECT REGEXP_SUBSTR(p_item_id, '[^,]+', 1, LEVEL) AS TOKEN
                       FROM   DUAL
                       CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_item_id, ','), 0) + 1)) B
        ON  (F.ITEM_ID LIKE B.TST OR T2.NICK_NAME LIKE B.TST)
    INNER JOIN SCM_MGR.SCM_MST_SITE S
        ON  F.DIVISION_ID = S.DIVISION_ID
        AND F.SCM_SITE_ID = S.SCM_SITE_ID
        AND S.SITE_TYPE   = 'SALES'
    INNER JOIN SCM_MGR.SCM_MST_CITY H
        ON  S.CITY = H.CITY
    INNER JOIN SCM_MGR.SCM_MST_COUNTRY I
        ON  S.COUNTRY = I.COUNTRY
    LEFT JOIN (SELECT B2.USER_ID, B2.USER_NAME, B2.USER_NAME_EN, B2.DEPT_ID, C.DEPT_NAME_KO
               FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B2
               INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C
                   ON B2.DEPT_ID = C.DEPT_ID) TEAM
        /* (룰 #5) TEAM.USER_ID IN (SELECT TOP 1 TOKEN FROM STRING_SPLIT(F.OWNER,',')) → 첫 토큰 비교 */
        ON TEAM.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0 THEN F.OWNER
                               ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1) END
    LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
        /* (C-1) SUBSTRING(F.OWNER, 0, CHARINDEX...) 첫 토큰 → SUBSTR(s,1,INSTR-1) 보정 */
        ON J.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0 THEN F.OWNER
                            ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1) END
    LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
        /* AS-IS ELSE S.DEPT_ID — 사내 SCM_MST_SITE.DEPT_ID 삭제(Case 39) → F.DEPT_ID (K 는 SELECT 미참조) */
        ON K.DEPT_ID = CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID ELSE F.DEPT_ID END
    LEFT JOIN (SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
               FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
               WHERE  LOOKUP_TYPE = 'CELL_TYPE') LOOK
        ON LOOK.CODE = T2.CELL_TYPE
    LEFT JOIN SCM_MGR.GTT_TEMP_DM_MST_ITEM_SINGLE_V T4
        /* ISNULL(T2.FORECAST_INFO_CELL_MODEL,'') = T4.ITEM_ID → 직접 비교 (C-7, 결과 동일) */
        ON  T2.DIVISION_ID = T4.DIVISION_ID
        AND T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID
    LEFT JOIN (SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK
               FROM  (SELECT SEGMENT2 AS MODEL
                           , SEGMENT3 AS BIZ_TYPE
                           , SEGMENT4 AS CELL_PACK_COUNT
                           , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                      WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
                      AND    SEGMENT1    = '40') A
               WHERE  A.MODEL_RANK = 1) LOOKA
        ON LOOKA.MODEL = F.ITEM_ID
    WHERE  F.DIVISION_ID = '40'                    /* AS-IS 원문 하드코딩('40') 그대로 보존 */
    /* CASE WHEN @P='ALL' THEN @P ELSE col END IN (SPLIT(@P)) → OR 동치 변환 */
    AND    (p_scm_site_id = 'ALL' OR F.SCM_SITE_ID IN (
                SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
    AND    (p_customer = 'ALL' OR F.PROJECT_CODE IN (
                SELECT REGEXP_SUBSTR(p_customer, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_customer, ','), 0) + 1))
    AND    (p_biz_type = 'ALL' OR
                CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                     ELSE T2.FORECAST_INFO_BIZ_TYPE END IN (
                SELECT REGEXP_SUBSTR(p_biz_type, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_biz_type, ','), 0) + 1));
    -------------------------------------------------------------------------------------------------------------------------------
    -- #TempSiteItemAll 만들기 (END)
    -------------------------------------------------------------------------------------------------------------------------------
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_TEMPSITEITEMALL', NO_INVALIDATE => FALSE);

    -------------------------------------------------------------------------------------------------------------------------------
    -- #TempSiteItem 만들기 (START)
    -------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GTT_TEMPSITEITEM
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
    , CELL_MODEL, END_CUSTOMER, SOLDTO_CUSTOMER
    , COUNTRY, COUNTRY_NAME, CITY, CITY_NAME
    , OWNER, PROJECT_OWNER, USER_ID, ITEM_NAME, ITEM_TYPE
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME
    , MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, CELL_TYPE, FORECAST_INFO_CELL_PACK_COUNT
    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
    , CELL_MODEL_NICK_NAME, VMI_YN, DMS_SALES, DMS_CUSTOMER, DEPT_ID, DEPT_NAME_KO
    , ITEM_VALID_YN )
    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
         , MAX(CELL_MODEL)                     AS CELL_MODEL
         , MAX(END_CUSTOMER)                   AS END_CUSTOMER
         , MAX(SOLDTO_CUSTOMER)                AS SOLDTO_CUSTOMER
         , MAX(COUNTRY)                        AS COUNTRY
         , MAX(COUNTRY_NAME)                   AS COUNTRY_NAME
         , MAX(CITY)                           AS CITY
         , MAX(CITY_NAME)                      AS CITY_NAME
         , MAX(OWNER)                          AS OWNER
         , MAX(PROJECT_OWNER)                  AS PROJECT_OWNER
         , MAX(USER_ID)                        AS USER_ID
         , MAX(ITEM_NAME)                      AS ITEM_NAME
         , MAX(ITEM_TYPE)                      AS ITEM_TYPE
         , MAX(CUST_GROUP)                     AS CUST_GROUP
         , MAX(CUST_GROUP_DTL)                 AS CUST_GROUP_DTL
         , MAX(APPLICATION)                    AS APPLICATION
         , MAX(ROUTE)                          AS ROUTE
         , MAX(MDM_PROJECT_NAME)               AS MDM_PROJECT_NAME
         , MAX(MIN_CAPACITY)                   AS MIN_CAPACITY
         , MAX(FORECAST_INFO_BIZ_TYPE)         AS FORECAST_INFO_BIZ_TYPE
         , MAX(FORECAST_INFO_PRODUCT_GROUP)    AS FORECAST_INFO_PRODUCT_GROUP
         , MAX(CELL_TYPE)                      AS CELL_TYPE
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)  AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(FORECAST_INFO_ALL)              AS FORECAST_INFO_ALL
         , MAX(FORECAST_INFO_SPEC)             AS FORECAST_INFO_SPEC
         , MAX(FORECAST_INFOR_VERSION)         AS FORECAST_INFOR_VERSION
         , MAX(CELL_MODEL_NICK_NAME)           AS CELL_MODEL_NICK_NAME
         , MAX(VMI_YN)                         AS VMI_YN
         , MAX(DMS_SALES)                      AS DMS_SALES
         , MAX(DMS_CUSTOMER)                   AS DMS_CUSTOMER
         , MAX(DEPT_ID)                        AS DEPT_ID
         , MAX(DEPT_NAME_KO)                   AS DEPT_NAME_KO
         , MAX(ITEM_VALID_YN)                  AS ITEM_VALID_YN
    FROM   SCM_MGR.GTT_TEMPSITEITEMALL
    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;
    -------------------------------------------------------------------------------------------------------------------------------
    -- #TempSiteItem 만들기 (END)  /  인덱스: GTT 기존 정의 재사용 (AS-IS CREATE INDEX 구간은 GTT DDL 에서 대체)
    -------------------------------------------------------------------------------------------------------------------------------
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_TEMPSITEITEM', NO_INVALIDATE => FALSE);
    --=============================================================================================================================
    -- #TempSiteItem 만들기 시작 (END)
    --=============================================================================================================================

    /* 조회 할 때 쓸 날짜 변수 세팅 시작 */
    V_FROM_YYYYMMDD := '';  --MKT FCST PLAN FROM 주차 월요일
    V_TO_YYYYMMDD   := '';  --MKT FCST PLAN TO 주차 월요일
    V_FROM_RESULT   := '';  --MKT FCST RESULT FROM 주차 월요일
    V_TO_RESULT     := '';  --MKT FCST RESULT TO 주차 월요일
    V_USER_TIME_ZONE := '';

    BEGIN
        SELECT U.TIMEZONE
        INTO   V_USER_TIME_ZONE
        FROM   SCM_MGR.TB_FX_USER U
        WHERE  U.USERID = p_created_by;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_USER_TIME_ZONE := NULL;
        WHEN TOO_MANY_ROWS THEN V_USER_TIME_ZONE := NULL;
    END;

    -- @V_FROM_YYYYMMDD : (USER 시차를 고려한) 당주 월요일
    BEGIN
        SELECT MIN(C.BASIS_YYYYMMDD)
        INTO   V_FROM_YYYYMMDD
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
             , (SELECT DISTINCT ISO_YYYYWW
                FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                WHERE  1 = 1
                /* CONVERT(CHAR(8), DBO.FN_MULTY_TIME(@V_USER_TIME_ZONE), 112) → 명시 마스크 (C-11) */
                AND    BASIS_YYYYMMDD = TO_CHAR(SCM_MGR.FN_MULTY_TIME(V_USER_TIME_ZONE), 'YYYYMMDD')
               ) T
        WHERE  1 = 1
        AND    C.ISO_YYYYWW = T.ISO_YYYYWW;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_YYYYMMDD := NULL;
    END;

    -- FROM 실적 : FROM 조회 구간 월요일부터
    BEGIN
        SELECT C.BASIS_START_DATE
        INTO   V_FROM_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  1 = 1
        AND    C.BASIS_YYYYMMDD = p_from_yyyymmdd;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_RESULT := NULL;
    END;

    -- TO 실적 : TO 조회 구간 월요일 전까지
    BEGIN
        SELECT C.BASIS_START_DATE
        INTO   V_TO_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  1 = 1
        AND    C.BASIS_YYYYMMDD = p_to_yyyymmdd;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_TO_RESULT := NULL;
    END;

    IF V_FROM_YYYYMMDD > V_FROM_RESULT THEN
        -- 실적 보여줌
        V_TO_YYYYMMDD := p_to_yyyymmdd;
        V_TO_RESULT   := V_FROM_YYYYMMDD;   -- TO 실적 : 당주 월요일 전까지
    ELSIF V_FROM_YYYYMMDD <= V_FROM_RESULT THEN
        -- 실적 없음
        V_TO_YYYYMMDD := p_to_yyyymmdd;
        V_FROM_RESULT := '19000101';        --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112);
        V_TO_RESULT   := '19000101';        --CONVERT(CHAR(8), DATEADD(MM, -6, CURRENT_TIMESTAMP), 112);
    ELSIF V_FROM_YYYYMMDD > V_TO_RESULT THEN
        -- 실적만 보여줌
        V_FROM_YYYYMMDD := '19000101';
        V_TO_YYYYMMDD   := '19000101';
        V_FROM_RESULT   := p_from_yyyymmdd; -- FROM 실적 : FROM 조회 구간부터
        V_TO_RESULT     := p_to_yyyymmdd;   -- TO 실적 : TO 조회 구간까지
    ELSIF V_FROM_YYYYMMDD = V_TO_RESULT THEN
        -- 실적 없음
        V_TO_YYYYMMDD := V_FROM_YYYYMMDD;
        V_FROM_RESULT := p_from_yyyymmdd;
        V_TO_RESULT   := p_to_yyyymmdd;
    END IF;
    /* 조회 할 때 쓸 날짜 변수 세팅 종료 */

    --------------------------------------------------------------------------------------------------------------------------------------------------
    -- #TempSelectMeasure 만들기 시작
    --------------------------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GTT_TEMPSELECTMEASURE
    ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, RESULT_MEASURE, SORT_ORDER_NO )
    SELECT DISTINCT U.PROGRAM_ID                        AS PROGRAM_ID
         , U.SHEET_NAME                                 AS SHEET_NAME
         , U.USER_ID                                    AS USER_ID
         , U.COLUMN_NAME                                AS MEASURE_GROUP
         , U.COLUMN_NAME                                AS MEASURE
         , NVL(SMSM.ATTRIBUTE5, U.COLUMN_NAME)          AS RESULT_MEASURE  -- 2025.03.13 RESULT_MEASURE 추가
         , TO_CHAR(U.SORT_ORDER_NO)                     AS SORT_ORDER_NO
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U              /* AS-IS INDEX(PK_SCM_MST_TITLESET_USER) 힌트 제거 */
    JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
        ON  U.PROGRAM_ID                    = SMSM.PROGRAM_ID
        AND U.SHEET_NAME                    = SMSM.SHEET_NAME
        AND U.COLUMN_NAME                   = SMSM.COLUMN_NAME
        AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
        AND SMSM.VALID_YN                   = 'Y'
    WHERE  1 = 1
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.PROGRAM_ID = VA_PROGRAM_ID  --'DMF0082'
    AND    U.SHEET_NAME = VA_SHEET_NAME  --'FcstNPrice'
    AND    U.USER_ID    = p_created_by;

    ------------------------------------------------------------------------------------------------
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 (MKT Fcst AMT/QTY)
    --실적구간 LOC,KRW를 계산하기 위해 필수 메저 RTF_SYS_RP, MKT_AMT_LOC, MKT_AMT_KRW 를 메저에 강제 등록 START
    ------------------------------------------------------------------------------------------------
    SELECT COUNT(*)
    INTO   V_MEASURE_CNT
    FROM   SCM_MGR.GTT_TEMPSELECTMEASURE A
    WHERE  1 = 1
    AND    A.MEASURE IN ('LOC', 'KRW', 'FCST_GAP');  --'FCST_GAP' 추가 [PJ2025-50188] FCST Gap 메저 추가 (MKT FCST - SCM FCST)

    IF V_MEASURE_CNT > 0 THEN
        INSERT INTO SCM_MGR.GTT_TEMPSELECTMEASURE
        ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, RESULT_MEASURE, SORT_ORDER_NO )
        WITH W_TARGET_MEASURE AS (
            SELECT A.PROGRAM_ID
                 , A.SHEET_NAME
                 , 'LOC' AS TARGET_MEASURE
                 , A.COLUMN_NAME AS MEASURE_GROUP
                 , A.COLUMN_NAME AS MEASURE
                 , A.COLUMN_NAME AS RESULT_MEASURE
                 , TO_CHAR(A.SORT_ORDER_NO) AS SORT_ORDER_NO
            FROM   SCM_MGR.SCM_MST_SHEET_MEASURE A
            WHERE  1 = 1
            AND    A.PROGRAM_ID = VA_PROGRAM_ID
            AND    A.SHEET_NAME = VA_SHEET_NAME
            AND    A.COLUMN_NAME IN ('RTF_SYS_RP', 'MKT_AMT_LOC')
            UNION ALL
            SELECT A.PROGRAM_ID
                 , A.SHEET_NAME
                 , 'KRW' AS TARGET_MEASURE
                 , A.COLUMN_NAME AS MEASURE_GROUP
                 , A.COLUMN_NAME AS MEASURE
                 , A.COLUMN_NAME AS RESULT_MEASURE
                 , TO_CHAR(A.SORT_ORDER_NO) AS SORT_ORDER_NO
            FROM   SCM_MGR.SCM_MST_SHEET_MEASURE A
            WHERE  1 = 1
            AND    A.PROGRAM_ID = VA_PROGRAM_ID
            AND    A.SHEET_NAME = VA_SHEET_NAME
            AND    A.COLUMN_NAME IN ('RTF_SYS_RP', 'MKT_AMT_KRW')
            -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST)  START -----
            UNION ALL
            SELECT A.PROGRAM_ID
                 , A.SHEET_NAME
                 , 'FCST_GAP' AS TARGET_MEASURE
                 , A.COLUMN_NAME AS MEASURE_GROUP
                 , A.COLUMN_NAME AS MEASURE
                 , A.COLUMN_NAME AS RESULT_MEASURE
                 , TO_CHAR(A.SORT_ORDER_NO) AS SORT_ORDER_NO
            FROM   SCM_MGR.SCM_MST_SHEET_MEASURE A
            WHERE  1 = 1
            AND    A.PROGRAM_ID = VA_PROGRAM_ID
            AND    A.SHEET_NAME = VA_SHEET_NAME
            AND    A.COLUMN_NAME IN ('MKT_FCST', 'SCM_FCST')
            -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST)  END -----
        )
        SELECT DISTINCT
               W.PROGRAM_ID
             , W.SHEET_NAME
             , 'DM_ADMIN'       AS USER_ID  --USER_ID를 기준으로 단가 계산후 메저를 삭제함(사용자가 선택하지 않은 메저가 화면에 조회되면 안되므로)
             , W.MEASURE_GROUP
             , W.MEASURE
             , W.RESULT_MEASURE
             , W.SORT_ORDER_NO
        FROM   W_TARGET_MEASURE W
        JOIN   SCM_MGR.GTT_TEMPSELECTMEASURE T
            ON  (W.PROGRAM_ID     = T.PROGRAM_ID
           AND   W.SHEET_NAME     = T.SHEET_NAME
           AND   W.TARGET_MEASURE = T.MEASURE)
        WHERE  1 = 1
        AND    NOT EXISTS (SELECT 1
                           FROM   SCM_MGR.GTT_TEMPSELECTMEASURE X
                           WHERE  1 = 1
                           AND    X.MEASURE = W.MEASURE);
    END IF;
    ------------------------------------------------------------------------------------------------
    --실적구간 LOC,KRW를 계산하기 위해 필수 메저 RTF_SYS_RP, MKT_AMT_LOC, MKT_AMT_KRW 를 메저에 강제 등록 END
    ------------------------------------------------------------------------------------------------

    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START----------------------------------------------
    --LOC를 기준으로 CURRENCY를 일괄 업데이트 하기 때문에 무조건 해당 메저 INSERT
    --DM_PLN_CFM_SELLING_PRICE 테이블로 JOIN 해서 업데이트 하면 속도가 너무 느림
    INSERT INTO SCM_MGR.GTT_TEMPSELECTMEASURE
    ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, RESULT_MEASURE, SORT_ORDER_NO )
    SELECT A.PROGRAM_ID
         , A.SHEET_NAME
         , 'DM_ADMIN'
         , A.COLUMN_NAME AS MEASURE_GROUP
         , A.COLUMN_NAME AS MEASURE
         , A.COLUMN_NAME AS RESULT_MEASURE
         , TO_CHAR(A.SORT_ORDER_NO)
    FROM   SCM_MGR.SCM_MST_SHEET_MEASURE A
    WHERE  1 = 1
    AND    A.PROGRAM_ID  = VA_PROGRAM_ID
    AND    A.SHEET_NAME  = VA_SHEET_NAME
    AND    A.COLUMN_NAME = 'LOC'
    AND    NOT EXISTS (SELECT 1
                       FROM   SCM_MGR.GTT_TEMPSELECTMEASURE X
                       WHERE  1 = 1
                       AND    X.MEASURE = A.COLUMN_NAME);
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 END----------------------------------------------

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_TEMPSELECTMEASURE', NO_INVALIDATE => FALSE);
    -- #TempSelectMeasure 만들기 종료

    --------------------------------------------------------------------------------------------------------------------------------------------------
    -- #T_LAST_DATA_SETUP_FCST / #T_LAST_DATA_SETUP_PRICE 만들기 (Current 버전)
    --------------------------------------------------------------------------------------------------------------------------------------------------
    IF UPPER(p_version_type) LIKE '%CURRENT%' THEN   /* AS-IS: @P_VERSION_TYPE LIKE '%CURRENT%' (MSSQL 대소문자 무시) */

        --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START ---------------------------------------------------------------------
        --기존 쿼리 주석 처리 후 일괄 변경
        --1.LAST_UPDATE_DATE 값을 가져올 때, CASE WHEN 에 소형사업부에서 사용하지 않는 메저들만 있어서 해당 로직 제거
        --2.가장 최근 데이터를 입력한 사용자ID가 아니라 MAX사용자ID로 가져와서 수정함
        IF p_division_id LIKE '81%' THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
        INSERT INTO SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , X.LAST_UPDATE_DATE, X.LAST_UPDATED_BY
        FROM  (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                    , TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') AS LAST_UPDATE_DATE   /* CONVERT(NVARCHAR, ..., 112) — 명시 마스크 (C-11) */
                    , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
                    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                                         ORDER BY A.LAST_UPDATE_DATE) AS RN
               FROM   SCM_MGR.DM_PLN_MKT_FCST A
               INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
                   ON A.MEASURE = (CASE WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP'
                                        WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
                                        ELSE B.MEASURE END)
               WHERE  A.DIVISION_ID = p_division_id
               /* DATEADD(YY,-1,@p_from_yyyymmdd) 문자열 암묵 DATE 변환 → 명시 변환 (C-11) */
               AND    A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD'), -12), 'YYYYMMDD')
               AND    A.YYYYMMDD <= p_to_yyyymmdd
               --AND A.QTY <> 0
              ) X
        WHERE  X.PROJECT_CODE IS NOT NULL     /* ISNULL(x,'')<>'' → IS NOT NULL (C-7) */
        AND    X.SCM_SITE_ID  IS NOT NULL
        AND    X.ITEM_ID      IS NOT NULL
        AND    X.RN = 1;
        ELSE
        INSERT INTO SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , X.LAST_UPDATE_DATE, X.LAST_UPDATED_BY
        FROM  (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                    , TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') AS LAST_UPDATE_DATE   /* CONVERT(NVARCHAR, ..., 112) — 명시 마스크 (C-11) */
                    , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
                    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                                         ORDER BY A.LAST_UPDATE_DATE) AS RN
               FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
               INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
                   ON A.MEASURE = (CASE WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP'
                                        WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
                                        ELSE B.MEASURE END)
               WHERE  A.DIVISION_ID = p_division_id
               /* DATEADD(YY,-1,@p_from_yyyymmdd) 문자열 암묵 DATE 변환 → 명시 변환 (C-11) */
               AND    A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD'), -12), 'YYYYMMDD')
               AND    A.YYYYMMDD <= p_to_yyyymmdd
               --AND A.QTY <> 0
              ) X
        WHERE  X.PROJECT_CODE IS NOT NULL     /* ISNULL(x,'')<>'' → IS NOT NULL (C-7) */
        AND    X.SCM_SITE_ID  IS NOT NULL
        AND    X.ITEM_ID      IS NOT NULL
        AND    X.RN = 1;
        END IF;  --[DIV81]
        -- #T_LAST_DATA_SETUP_FCST 만들기 종료

        IF p_division_id LIKE '81%' THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
        INSERT INTO SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , X.LAST_UPDATE_DATE, X.LAST_UPDATED_BY
        FROM  (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                    , TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') AS LAST_UPDATE_DATE
                    , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
                    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                                         ORDER BY A.LAST_UPDATE_DATE) AS RN
               FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
               INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
                   ON A.MEASURE = B.MEASURE
               WHERE  A.DIVISION_ID = p_division_id
               AND    A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD'), -12), 'YYYYMMDD')
               AND    A.YYYYMMDD <= p_to_yyyymmdd
               --AND A.QTY <> 0
              ) X
        WHERE  X.PROJECT_CODE IS NOT NULL
        AND    X.SCM_SITE_ID  IS NOT NULL
        AND    X.ITEM_ID      IS NOT NULL
        AND    X.RN = 1;
        ELSE
        INSERT INTO SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , X.LAST_UPDATE_DATE, X.LAST_UPDATED_BY
        FROM  (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                    , TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') AS LAST_UPDATE_DATE
                    , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
                    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                                         ORDER BY A.LAST_UPDATE_DATE) AS RN
               FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
               INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
                   ON A.MEASURE = B.MEASURE
               WHERE  A.DIVISION_ID = p_division_id
               AND    A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD'), -12), 'YYYYMMDD')
               AND    A.YYYYMMDD <= p_to_yyyymmdd
               --AND A.QTY <> 0
              ) X
        WHERE  X.PROJECT_CODE IS NOT NULL
        AND    X.SCM_SITE_ID  IS NOT NULL
        AND    X.ITEM_ID      IS NOT NULL
        AND    X.RN = 1;
        END IF;  --[DIV81]
        -- #T_LAST_DATA_SETUP_PRICE 만들기 종료

        DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_T_LAST_DATA_SETUP_FCST',  NO_INVALIDATE => FALSE);
        DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_T_LAST_DATA_SETUP_PRICE', NO_INVALIDATE => FALSE);
    END IF;

    --------------------------------------------------------------------------------------------------------------------------------------------------
    -- #T_WS_FCST 만들기
    --------------------------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GTT_T_WS_FCST ( FCST_TYPE )
    SELECT SEGMENT1
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'SALES_TYPE_CODE';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_T_WS_FCST', NO_INVALIDATE => FALSE);

    --------------------------------------------------------------------------------------------------------------------------------------------------
    -- #TempFcstNPrice 만들기 시작 - VERSION - CURRENT
    --------------------------------------------------------------------------------------------------------------------------------------------------
    IF UPPER(p_version_type) LIKE '%CURRENT%' THEN

        IF p_division_id LIKE '81%' THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
        INSERT INTO SCM_MGR.GTT_TEMPFCSTNPRICE
        ( DIVISION_ID       , PROJECT_CODE                  , END_CUSTOMER           , SCM_SITE_ID            , ITEM_ID              , DOM_EXP            , FCST_TYPE          , INCOTERMS        , MEASURE                 , PLANT_SITE_ID
        , CELL_PROD_SITE_ID , YYYYMMDD                      , QTY                    , MEASURE_GROUP          , CELL_MODEL           , NICK_NAME          , DMS_SALES          , DMS_CUSTOMER     , OWNER                   , DEPT_ID
        , DEPT_NAME_KO      , FORECAST_INFO_CELL_PACK_COUNT , ITEM_TYPE              , PROJECT_NAME           , PROJECT_OWNER
        , SOLDTO_CUSTOMER   , COUNTRY_NAME                  , CITY_NAME
        , ITEM_NAME         , VMI_YN                        , CUST_GROUP             , CUST_GROUP_DTL         , APPLICATION          , ROUTE              , MDM_PROJECT_NAME   , MIN_CAPACITY     , FORECAST_INFO_BIZ_TYPE  , CELL_TYPE
        , FORECAST_INFO_ALL , FORECAST_INFO_SPEC            , FORECAST_INFOR_VERSION , CELL_MODEL_NICK_NAME
        , SORT_ORDER_NO
        , CREATE_DATE       , LAST_UPDATED_BY
        , CURRENCY          , VERSION_NO                    , CUTOFF_YYYYMMDD        , NOTATION )

        /* DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 기준 MEASURE */
        -- 기본적인 MEASURE 포함
        -- MKT_FCST [R+P]의 P부분 (기준일 이후)
        -- RTF [R+P] 의 P 부분 (기준일 이후)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN A.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID /*[DIV81] 컬럼 부재*/
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             -- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , NULL AS CURRENCY          /* AS-IS '' AS CURRENCY → NULL (C-7) */
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             --[PJ2025-50188] 'MKT_AMT_LOC','MKT_AMT_KRW' 메저 소숫점3자리 표현을 위해 NOTATION 변경 (INTEGER -> POINT3)
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION -- 소수점 타입 설정 POINT3은 소수점 3자리 INEGER는 정수
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON A.MEASURE = (CASE WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
                                 WHEN B.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF_SYS_RP'
                            ELSE B.MEASURE END)
        /* OUTER APPLY (SELECT TOP(1) ... ORDER BY CREATE_DATE DESC) → LEFT JOIN LATERAL + FETCH FIRST */
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
        AND    (
                   (A.MEASURE <> 'SCM_FCST' AND A.QTY <> 0)
                   OR
                   (A.MEASURE = 'SCM_FCST')
               )
        --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END

        UNION ALL

        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'MKT_FCST_PP' AS MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID /*[DIV81] 컬럼 부재*/
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , NULL AS CURRENCY          /* AS-IS '' AS CURRENCY → NULL (C-7) */
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = 'MKT_FCST'
            AND B.MEASURE = 'MKT_FCST_PP'
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0

        UNION ALL

        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID /*[DIV81] 컬럼 부재*/
             , A.YYYYMMDD
             , NVL(A.PRICE, 0) AS QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , A.CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = B.MEASURE
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD --계획구간만 : [PJ2025-50188] 실적 Unit Price 로직 변경
        --AND A.QTY <> 0

        UNION ALL

        /* DM_PLN_MKT_FCST_RESULT  테이블 기준 MEASURE */
        -- 2025.03.13 실적 (MKT_AMT_KRW,MKT_AMT_LOC Measure는 DM_PLN_SALES_PLAN_RESULT 테이블에서 가져옴) Start
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , B.MEASURE AS MEASURE -- 확인필요
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID  --[DIV81] 컬럼 부재           -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 ('-' ==> CELL_PROD_SITE_ID 추가됨)
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             /* IIF(A.MEASURE LIKE 'VMI%', '', A.CURRENCY) → CASE + NULL (C-7) — 실적데이터도 통화를 보여주기 위해 테이블 변경 [PJ2025-50188] */
             , CASE WHEN A.MEASURE LIKE 'VMI%' THEN NULL ELSE A.CURRENCY END AS CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC', 'MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A --DM_PLN_MKT_FCST_RESULT → 실적데이터도 통화를 보여주기 위해 테이블 변경 [PJ2025-50188]
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = B.RESULT_MEASURE
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;
        ELSE
        INSERT INTO SCM_MGR.GTT_TEMPFCSTNPRICE
        ( DIVISION_ID       , PROJECT_CODE                  , END_CUSTOMER           , SCM_SITE_ID            , ITEM_ID              , DOM_EXP            , FCST_TYPE          , INCOTERMS        , MEASURE                 , PLANT_SITE_ID
        , CELL_PROD_SITE_ID , YYYYMMDD                      , QTY                    , MEASURE_GROUP          , CELL_MODEL           , NICK_NAME          , DMS_SALES          , DMS_CUSTOMER     , OWNER                   , DEPT_ID
        , DEPT_NAME_KO      , FORECAST_INFO_CELL_PACK_COUNT , ITEM_TYPE              , PROJECT_NAME           , PROJECT_OWNER
        , SOLDTO_CUSTOMER   , COUNTRY_NAME                  , CITY_NAME
        , ITEM_NAME         , VMI_YN                        , CUST_GROUP             , CUST_GROUP_DTL         , APPLICATION          , ROUTE              , MDM_PROJECT_NAME   , MIN_CAPACITY     , FORECAST_INFO_BIZ_TYPE  , CELL_TYPE
        , FORECAST_INFO_ALL , FORECAST_INFO_SPEC            , FORECAST_INFOR_VERSION , CELL_MODEL_NICK_NAME
        , SORT_ORDER_NO
        , CREATE_DATE       , LAST_UPDATED_BY
        , CURRENCY          , VERSION_NO                    , CUTOFF_YYYYMMDD        , NOTATION )

        /* DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 기준 MEASURE */
        -- 기본적인 MEASURE 포함
        -- MKT_FCST [R+P]의 P부분 (기준일 이후)
        -- RTF [R+P] 의 P 부분 (기준일 이후)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN A.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             -- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , NULL AS CURRENCY          /* AS-IS '' AS CURRENCY → NULL (C-7) */
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             --[PJ2025-50188] 'MKT_AMT_LOC','MKT_AMT_KRW' 메저 소숫점3자리 표현을 위해 NOTATION 변경 (INTEGER -> POINT3)
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION -- 소수점 타입 설정 POINT3은 소수점 3자리 INEGER는 정수
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON A.MEASURE = (CASE WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
                                 WHEN B.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF_SYS_RP'
                            ELSE B.MEASURE END)
        /* OUTER APPLY (SELECT TOP(1) ... ORDER BY CREATE_DATE DESC) → LEFT JOIN LATERAL + FETCH FIRST */
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
        AND    (
                   (A.MEASURE <> 'SCM_FCST' AND A.QTY <> 0)
                   OR
                   (A.MEASURE = 'SCM_FCST')
               )
        --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END

        UNION ALL

        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'MKT_FCST_PP' AS MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , NULL AS CURRENCY          /* AS-IS '' AS CURRENCY → NULL (C-7) */
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = 'MKT_FCST'
            AND B.MEASURE = 'MKT_FCST_PP'
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0

        UNION ALL

        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , NVL(A.PRICE, 0) AS QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , A.CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = B.MEASURE
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD --계획구간만 : [PJ2025-50188] 실적 Unit Price 로직 변경
        --AND A.QTY <> 0

        UNION ALL

        /* DM_PLN_MKT_FCST_RESULT  테이블 기준 MEASURE */
        -- 2025.03.13 실적 (MKT_AMT_KRW,MKT_AMT_LOC Measure는 DM_PLN_SALES_PLAN_RESULT 테이블에서 가져옴) Start
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , B.MEASURE AS MEASURE -- 확인필요
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID           -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 ('-' ==> CELL_PROD_SITE_ID 추가됨)
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             /* IIF(A.MEASURE LIKE 'VMI%', '', A.CURRENCY) → CASE + NULL (C-7) — 실적데이터도 통화를 보여주기 위해 테이블 변경 [PJ2025-50188] */
             , CASE WHEN A.MEASURE LIKE 'VMI%' THEN NULL ELSE A.CURRENCY END AS CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC', 'MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A --DM_PLN_MKT_FCST_RESULT → 실적데이터도 통화를 보여주기 위해 테이블 변경 [PJ2025-50188]
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = B.RESULT_MEASURE
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;
        END IF;  --[DIV81]

        --------------------------------------------------------------------------------------------------------------------------
        -- CURRENCY 일괄 UPDATE (MSSQL UPDATE ... FROM JOIN → MERGE. GROUP BY+MAX 로 ORA-30926 방지 — MSSQL 임의채택의 결정적 대체)
        --------------------------------------------------------------------------------------------------------------------------
        MERGE INTO SCM_MGR.GTT_TEMPFCSTNPRICE A
        USING (SELECT SP.DIVISION_ID, SP.PROJECT_CODE, SP.SCM_SITE_ID, SP.PLANT_SITE_ID, SP.ITEM_ID
                    , SP.INCOTERMS, SP.DOM_EXP, SP.FCST_TYPE, SP.CELL_PROD_SITE_ID
                    , MAX(SP.CURRENCY) AS CURRENCY
               --FROM DBO.DM_PLN_CFM_SELLING_PRICE SP WITH(NOLOCK)
               FROM   SCM_MGR.GTT_TEMPFCSTNPRICE SP -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
               WHERE  1 = 1
               AND    SP.DIVISION_ID = p_division_id
               AND    (p_scm_site_id = 'ALL' OR SP.SCM_SITE_ID IN (
                           SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                           FROM   DUAL
                           CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
               AND    SP.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
               AND    SP.MEASURE = 'LOC'
               GROUP BY SP.DIVISION_ID, SP.PROJECT_CODE, SP.SCM_SITE_ID, SP.PLANT_SITE_ID, SP.ITEM_ID
                    , SP.INCOTERMS, SP.DOM_EXP, SP.FCST_TYPE, SP.CELL_PROD_SITE_ID) SP
        ON (    A.DIVISION_ID       = SP.DIVISION_ID
            AND A.PROJECT_CODE      = SP.PROJECT_CODE
            AND A.SCM_SITE_ID       = SP.SCM_SITE_ID
            AND A.PLANT_SITE_ID     = SP.PLANT_SITE_ID
            AND A.ITEM_ID           = SP.ITEM_ID
            AND A.INCOTERMS         = SP.INCOTERMS
            AND A.DOM_EXP           = SP.DOM_EXP
            AND A.FCST_TYPE         = SP.FCST_TYPE
            AND A.CELL_PROD_SITE_ID = SP.CELL_PROD_SITE_ID)
        WHEN MATCHED THEN UPDATE
            SET A.CURRENCY = SP.CURRENCY
            WHERE A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD -- [PJ2025-50188] 속도개선
            AND   A.CURRENCY IS NULL                                   /* ISNULL(A.CURRENCY,'')='' → IS NULL (C-7) */
            AND   A.MEASURE NOT LIKE 'VMI%';

        -----------------------------------------------------------------------------------------------------------
        -- #TempFcstNPrice 에 INSERT 한 메저들을 이용하여 판가 실적 계산
        -- LOC = MKT_AMT_LOC/RTF_SYS_RP
        -- KRW = MKT_AMT_KRW/RTF_SYS_RP
        -----------------------------------------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GTT_TEMPFCSTNPRICE
        ( DIVISION_ID       , PROJECT_CODE                  , END_CUSTOMER           , SCM_SITE_ID            , ITEM_ID              , DOM_EXP            , FCST_TYPE          , INCOTERMS        , MEASURE                 , PLANT_SITE_ID
        , CELL_PROD_SITE_ID , YYYYMMDD                      , QTY                    , MEASURE_GROUP          , CELL_MODEL           , NICK_NAME          , DMS_SALES          , DMS_CUSTOMER     , OWNER                   , DEPT_ID
        , DEPT_NAME_KO      , FORECAST_INFO_CELL_PACK_COUNT , ITEM_TYPE              , PROJECT_NAME           , PROJECT_OWNER
        , SOLDTO_CUSTOMER   , COUNTRY_NAME                  , CITY_NAME
        , ITEM_NAME         , VMI_YN                        , CUST_GROUP             , CUST_GROUP_DTL         , APPLICATION          , ROUTE              , MDM_PROJECT_NAME   , MIN_CAPACITY     , FORECAST_INFO_BIZ_TYPE  , CELL_TYPE
        , FORECAST_INFO_ALL , FORECAST_INFO_SPEC            , FORECAST_INFOR_VERSION , CELL_MODEL_NICK_NAME
        , SORT_ORDER_NO
        , CREATE_DATE       , LAST_UPDATED_BY
        , CURRENCY          , VERSION_NO                    , CUTOFF_YYYYMMDD        , NOTATION )
        --기존 소스 개선 및 FCST GAP 추가 [PJ2025-50188] : FCST Gap 메저 추가 (MKT FCST - SCM FCST) START -------------------
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID          -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
             , A.YYYYMMDD
             /* IIF → CASE (분모 0 방어 포함, AS-IS 동일) */
             , CASE D.MEASURE
                    WHEN 'LOC' THEN CASE WHEN SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END) <> 0
                                         THEN SUM(CASE WHEN A.MEASURE = 'MKT_AMT_LOC' THEN A.QTY ELSE 0 END)
                                              / SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END)
                                         ELSE 0 END
                    WHEN 'KRW' THEN CASE WHEN SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END) <> 0
                                         THEN SUM(CASE WHEN A.MEASURE = 'MKT_AMT_KRW' THEN A.QTY ELSE 0 END)
                                              / SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END)
                                         ELSE 0 END
               END AS QTY
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
             , MAX(A.CELL_MODEL) AS CELL_MODEL
             , MAX(A.NICK_NAME) AS NICK_NAME
             , MAX(A.DMS_SALES) AS DMS_SALES
             , MAX(A.DMS_CUSTOMER) AS DMS_CUSTOMER
             , MAX(A.OWNER) AS OWNER
             , MAX(A.DEPT_ID) AS DEPT_ID
             , MAX(A.DEPT_NAME_KO) AS DEPT_NAME_KO
             , MAX(A.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
             , MAX(A.ITEM_TYPE) AS ITEM_TYPE
             , MAX(A.PROJECT_NAME) AS PROJECT_NAME
             , MAX(A.PROJECT_OWNER) AS PROJECT_OWNER
             , MAX(A.SOLDTO_CUSTOMER) AS SOLDTO_CUSTOMER
             , MAX(A.COUNTRY_NAME) AS COUNTRY_NAME
             , MAX(A.CITY_NAME) AS CITY_NAME
             , MAX(A.ITEM_NAME) AS ITEM_NAME
             , MAX(A.VMI_YN) AS VMI_YN
             , MAX(A.CUST_GROUP) AS CUST_GROUP
             , MAX(A.CUST_GROUP_DTL) AS CUST_GROUP_DTL
             , MAX(A.APPLICATION) AS APPLICATION
             , MAX(A.ROUTE) AS ROUTE
             , MAX(A.MDM_PROJECT_NAME) AS MDM_PROJECT_NAME
             , MAX(A.MIN_CAPACITY) AS MIN_CAPACITY
             , MAX(A.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
             , MAX(A.CELL_TYPE) AS CELL_TYPE
             , MAX(A.FORECAST_INFO_ALL) AS FORECAST_INFO_ALL
             , MAX(A.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
             , MAX(A.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
             , MAX(A.CELL_MODEL_NICK_NAME) AS CELL_MODEL_NICK_NAME
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO
             , MAX(A.CREATE_DATE) AS CREATE_DATE
             , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.CURRENCY) AS CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.GTT_TEMPFCSTNPRICE A
        JOIN   SCM_MGR.GTT_TEMPSELECTMEASURE D
            ON D.MEASURE IN ('LOC', 'KRW')
        WHERE  1 = 1
        AND    A.MEASURE IN ('RTF_SYS_RP', 'MKT_AMT_LOC', 'MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD <  V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
               , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
               , A.CELL_PROD_SITE_ID          -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
               , A.CURRENCY, A.YYYYMMDD, D.MEASURE;
        -----------------------------------------------------------------------------------------------------------
        -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 (MKT FCST Amt. /RTF[R+P])  END
        -----------------------------------------------------------------------------------------------------------
    END IF;
    --------------------------------------------------------------------------------------------------------------------------------------------------
    -- #TempFcstNPrice 만들기 종료 - VERSION - CURRENT
    --------------------------------------------------------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 START
    --Unit Price 계산 후 불필요 MEASURE 삭제 (삭제하지 않으면 화면에서 보임)
    -----------------------------------------------------------------------------------------------
    DELETE FROM SCM_MGR.GTT_TEMPFCSTNPRICE A
    WHERE  EXISTS (SELECT 1
                   FROM   SCM_MGR.GTT_TEMPSELECTMEASURE B
                   WHERE  A.MEASURE = B.MEASURE
                   AND    B.USER_ID = 'DM_ADMIN');
    -----------------------------------------------------------------------------------------------
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 END
    -----------------------------------------------------------------------------------------------
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_TEMPFCSTNPRICE', NO_INVALIDATE => FALSE);

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* C_TITLE 커서 시작 — 동적쿼리에서 사용 할 동적 컬럼을 만드는 커서 */
    --------------------------------------------------------------------------------------------------------------------------------------------------
    V_COLUMN  := '';  --필수
    V_GROUPBY := '';
    V_ORDERBY := '';

    OPEN C_TITLE;
    LOOP
        FETCH C_TITLE INTO V_CUR_PROGRAM_ID, V_CUR_SHEET_NAME, V_CUR_COLUMN_NAME, V_CUR_SORT_ORDER_NO;
        EXIT WHEN C_TITLE%NOTFOUND;          /* C-10: FETCH 직후 종료 판정 의무 */
        IF V_COLUMN IS NULL THEN             /* AS-IS: IF @V_COLUMN = '' (Oracle '' = NULL, C-7) */
            V_COLUMN  := V_CUR_COLUMN_NAME;
            V_GROUPBY := ' GROUP BY ' || V_CUR_COLUMN_NAME;
            V_ORDERBY := ' ORDER BY SORT_KEY, ' || CASE WHEN V_CUR_COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN V_CUR_COLUMN_NAME ELSE '' END;
        ELSE
            V_COLUMN  := V_COLUMN  || ', ' || V_CUR_COLUMN_NAME;
            V_GROUPBY := V_GROUPBY || ', ' || V_CUR_COLUMN_NAME;
            V_ORDERBY := V_ORDERBY || CASE WHEN V_CUR_COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN ', ' || V_CUR_COLUMN_NAME ELSE '' END;
        END IF;
    END LOOP;
    CLOSE C_TITLE;

    --[E20240812-000094]_해당컬럼으로 숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 추가 START
    V_COLUMN := CASE WHEN V_COLUMN IS NULL THEN 'NOTATION' ELSE V_COLUMN || ',NOTATION' END;   /* + ',[NOTATION]' */
    --[E20240812-000094] END

    V_GROUPBY := CASE WHEN V_GROUPBY IS NULL THEN ' GROUP BY EDIT_FLAG, SORT_ORDER_NO' ELSE V_GROUPBY || ', EDIT_FLAG, SORT_ORDER_NO' END;
    V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');   /* CAST ... NUMERIC(10,2) */
    V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');
    /* C_TITLE 커서 종료 */

    ---------------------------------------------------------------------------------
    --            권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    V_GROUP_ID := '';

    SELECT COUNT(1)
    INTO   V_ADMIN_CNT
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
    AND    VALID_YN = 'Y'
    AND    SEGMENT1 = p_user_group
    AND    SEGMENT2 = 'ALL';
    --AND SEGMENT3 = LEFT(@P_DIVISION_ID,2)

    IF NVL(V_ADMIN_CNT, 0) > 0 THEN
        V_GROUP_ID := 'ADMIN';
    END IF;
    ---------------------------------------------------------------------------------
    --           권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    -------------------------------------------------------------------------------------------------------------------------
    --사용자의 요건: 소형사업부 계획수립 Timeline 단축으로 MKT FCST / SCM FCST가 월요일에 진행됨에 따라
    --MKT FCST 입력 제한을 시간 단위로 제한할 수 있도록 기능 개발 필요
    --[Timeline 단축에 따른 월요일 MKT FCST, SCM FCST 입력 시간 변경]
    --기존 월 24시 DM cutoff → 기존에는 화요일에 SCM_FCST만 입력 가능하도록 되어 있었으나,
    --변경 월 15시 DM Cutoff → 월 15시 30분 ~ 17시 30분 까지 SCM FCST 수정하고자 함
    --기존 룩업은 모든 메져에 날짜가 적혀있었는데, 의미없음. 실제 제한을 하는 메져만 일자를 두는것으로 룩업구성 변경함
    --룩업명: GET_ADMIN_GROUP_MEASURE
    -------------------------------------------------------------------------------------------------------------------------
    --1). GET_ADMIN_GROUP_MEASURE 룩업에서 데이터를 TEMP로 담는다
    --    (CROSS APPLY STRING_SPLIT × 2 → CROSS JOIN LATERAL REGEXP_SUBSTR CONNECT BY)
    --    (C-11) DATEPART(WEEKDAY)/CONVERT(...,24) → TO_CHAR(SYSDATE,'DY','NLS_DATE_LANGUAGE=ENGLISH') / TO_CHAR(SYSDATE,'HH24MI')
    --    (C-7)  ISNULL(REPLACE(x,' ',''),'')='' 빈값 판정 → REPLACE(x,' ','') IS NULL (빈값 = 제한 없음 = 행 유지)
    INSERT INTO SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE
    ( USER_GROUP, DIVISION_ID, MEASURE, DAYS, FROM_TIME, TO_TIME, LIMIT_MEASURE )
    SELECT B.USER_GROUP, B.DIVISION_ID, B.MEASURE, B.DAYS, B.FROM_TIME, B.TO_TIME, LM.TOKEN AS LIMIT_MEASURE
    FROM  (SELECT A.SEGMENT1 AS USER_GROUP, A.SEGMENT3 AS DIVISION_ID, A.SEGMENT4 AS MEASURE, DT.TOKEN AS DAYS
                , A.ATTRIBUTE2 AS FROM_TIME, A.ATTRIBUTE3 AS TO_TIME, A.ATTRIBUTE4 AS LIMIT_MEASURE
           FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
           CROSS JOIN LATERAL (SELECT REGEXP_SUBSTR(A.ATTRIBUTE1, '[^,]+', 1, LEVEL) AS TOKEN
                               FROM   DUAL
                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(A.ATTRIBUTE1, ','), 0) + 1) DT
           WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
           AND    A.VALID_YN = 'Y'
           AND    A.SEGMENT1 = p_user_group
           AND    A.SEGMENT2 = VA_PROGRAM_ID
           AND    A.SEGMENT3 = p_division_id
          ) B
    CROSS JOIN LATERAL (SELECT REGEXP_SUBSTR(B.LIMIT_MEASURE, '[^,]+', 1, LEVEL) AS TOKEN
                        FROM   DUAL
                        CONNECT BY LEVEL <= NVL(REGEXP_COUNT(B.LIMIT_MEASURE, ','), 0) + 1) LM
    WHERE (REPLACE(B.DAYS, ' ', '') IS NULL
           OR B.DAYS = TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH'))   --일~토 = SUN~SAT
    AND   (REPLACE(B.FROM_TIME, ' ', '') IS NULL
           OR B.FROM_TIME <= TO_CHAR(SYSDATE, 'HH24MI'))
    AND   (REPLACE(B.TO_TIME, ' ', '') IS NULL
           OR B.TO_TIME >= TO_CHAR(SYSDATE, 'HH24MI'));

    --2). 실제 관리하는 MEASURE와 권한이 가진 메져가 다른 경우가 있을수 있으므로, 해당 화면 기준으로 메져를 구한다음에 위에서 구한 메져로 EDIT_FLAG로 붙여준다
    INSERT INTO SCM_MGR.GTT_TEMP_ADMIN_GROUP_MEASURE ( MEASURE, EDIT_FLAG )
    SELECT A.MEASURE
         , CASE WHEN B.MEASURE IS NULL THEN 'N' ELSE 'Y' END AS EDIT_FLAG   /* ISNULL(B.MEASURE,'')='' → IS NULL (C-7) */
    FROM  (SELECT A.SEGMENT4 AS MEASURE
           FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
           WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
           AND    A.VALID_YN = 'Y'
           AND    A.SEGMENT2 = VA_PROGRAM_ID  --'DMF0082'
           GROUP BY A.SEGMENT4 ) A
    LEFT OUTER JOIN (SELECT B.MEASURE
                     FROM   SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE B
                     GROUP BY B.MEASURE ) B
        ON A.MEASURE = B.MEASURE;

    --3). #TEMP_INTO_GROUP_MEASURE 테이블에 적재한 데이터 중 LIMIT_MEASURE가 존재하는 경우 해당 메져의 FLAG는 N으로 변경해준다
    SELECT COUNT(A.LIMIT_MEASURE)
    INTO   V_LIMIT_CNT
    FROM   SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE A
    WHERE  A.LIMIT_MEASURE IS NOT NULL;   /* ISNULL(x,'') != '' → IS NOT NULL (C-7) */

    IF V_LIMIT_CNT >= 1 THEN
        /* MSSQL UPDATE ... FROM INNER JOIN → EXISTS (룰 #30) */
        UPDATE SCM_MGR.GTT_TEMP_ADMIN_GROUP_MEASURE A
        SET    A.EDIT_FLAG = 'N'
        WHERE  EXISTS (SELECT 1
                       FROM   SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE B
                       WHERE  A.MEASURE = B.LIMIT_MEASURE);
    END IF;

    /* IF OBJECT_ID(#TEMP_INTO_GROUP_MEASURE) DROP → GTT 정리 (C-2: DELETE FROM) */
    DELETE FROM SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE;
    --[E20250729-000433]_[공급/생산SCM PI팀] 월요일 SCM FCST 입력 시 MKT FCST 수정 불가하도록 시스템 개선 END
    -------------------------------------------------------------------------------------------------------------------------

    --------------------------------------------------------------------------------------------------------------------------------------------------
    --#CAL_MONTH_END_DATE 만들기 시작
    --------------------------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GTT_CAL_MONTH_END_DATE ( MONTH_END_DATE )
    SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY BASIS_YYYYMM;

    --#CAL_WEEK_END_DATE 만들기 시작
    INSERT INTO SCM_MGR.GTT_CAL_WEEK_END_DATE ( WEEK_END_DATE )
    SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY ISO_YYYYWW || PARTIAL_WEEK_NAME;

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* 동적쿼리에서 사용될 MF_SP 임시테이블 */
    --------------------------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GTT_MF_SP
    ( DIVISION_ID, SCM_SITE_ID, PLANT_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, FCST_TYPE, DOM_EXP, MEASURE
    , END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
    , YYYYMM, YYYYMMWW, YYYYMMDD, DAYOFWEEK
    , FORECAST_INFO_CELL_MODEL, TEAM_ID, TEAM_NAME_KO
    , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
    , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, ITEM_NAME, VMI_YN, CELL_PROD_SITE_ID
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_CELL_PACK_COUNT
    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
    , QTY, MONTH_END_YN, WEEK_END_YN, EDIT_FLAG
    , SORT_ORDER_NO, MEASURE_GROUP, NEW_FLAG, BUCKET, SORT_KEY
    , LAST_UPDATE_DATE, LAST_UPDATED_BY, NOTATION, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD )
    SELECT A.DIVISION_ID
         , A.SCM_SITE_ID
         , A.PLANT_SITE_ID
         , A.PROJECT_CODE
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.MEASURE
         , A.END_CUSTOMER
         , A.NICK_NAME
         , A.DMS_SALES
         , A.DMS_CUSTOMER
         , C.BASIS_YYYYMM  AS YYYYMM
         , C.BASIS_YYYYMM || C.ISO_WEEK AS YYYYMMWW
         , C.BASIS_YYYYMMDD AS YYYYMMDD
         , C.DAYOFWEEK
         , A.CELL_MODEL   AS FORECAST_INFO_CELL_MODEL
         , A.DEPT_ID      AS TEAM_ID
         , A.DEPT_NAME_KO AS TEAM_NAME_KO
         , A.ITEM_TYPE
         , A.PROJECT_NAME
         , A.PROJECT_OWNER
         , A.OWNER
         , A.SOLDTO_CUSTOMER
         , A.COUNTRY_NAME
         , A.CITY_NAME
         , A.ITEM_NAME
         , A.VMI_YN
         , A.CELL_PROD_SITE_ID
         , A.CUST_GROUP
         , A.CUST_GROUP_DTL
         , A.APPLICATION
         , A.ROUTE
         , A.MDM_PROJECT_NAME
         , A.MIN_CAPACITY
         , A.FORECAST_INFO_BIZ_TYPE
         , A.CELL_TYPE
         , A.FORECAST_INFO_CELL_PACK_COUNT
         , A.FORECAST_INFO_ALL
         , A.FORECAST_INFO_SPEC
         , A.FORECAST_INFOR_VERSION
         , A.CELL_MODEL_NICK_NAME
         , CAST(A.QTY AS NUMBER(36,10)) AS QTY
         , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN 'Y' ELSE 'N' END AS MONTH_END_YN
         , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN 'Y' ELSE 'N' END AS WEEK_END_YN
         , CASE
               WHEN MA.DEPT_ID IS NOT NULL AND A.MEASURE_GROUP NOT IN ('CUST_FCST_2','CUST_FCST_3','TMM_FCST') AND A.MEASURE = M1.SEGMENT3  -- 같은부서+MktFcst등 (TMM 제외)
                   THEN 'Y'
               WHEN (V_GROUP_ID = 'ADMIN') AND A.MEASURE_GROUP <> 'TMM_FCST' AND A.MEASURE = M1.SEGMENT3  -- Admin권한자+MktFcst등 (TMM 제외)
                   THEN 'Y'
               ELSE 'N'
           END AS EDIT_FLAG
         , A.SORT_ORDER_NO  -- Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
         , A.MEASURE_GROUP  -- Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
         , 'N' AS NEW_FLAG
         , NVL(BK.BUCKET, '0000000') AS BUCKET
         , 999 AS SORT_KEY
         , CASE WHEN A.CREATE_DATE     IS NULL THEN ' ' ELSE A.CREATE_DATE END     AS LAST_UPDATE_DATE   /* ISNULL(x,'')='' → IS NULL (C-7) */
         , CASE WHEN A.LAST_UPDATED_BY IS NULL THEN ' ' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY
         , A.NOTATION
         , A.CURRENCY
         , A.VERSION_NO
         , A.CUTOFF_YYYYMMDD
    FROM   SCM_MGR.GTT_TEMPFCSTNPRICE A
    INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C
        ON C.BASIS_YYYYMMDD = A.YYYYMMDD
    --LEFT OUTER JOIN SCP_MST_ITEM_GROUP_DETAIL I ON A.DIVISION_ID = I.DIVISION_ID AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID
    LEFT OUTER JOIN SCM_MGR.GTT_CAL_MONTH_END_DATE C2
        ON A.YYYYMMDD = C2.MONTH_END_DATE
    LEFT OUTER JOIN SCM_MGR.GTT_CAL_WEEK_END_DATE C3
        ON A.YYYYMMDD = C3.WEEK_END_DATE
    --LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL X ON A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = 'AS_SITE_PLANT'
    LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M1   -- EDIT가 가능한 MEASURE (수정 해야 하는 MEASURE가 생기면 아래 룩업에 추가해야한다)
        ON  A.DIVISION_ID  = M1.SEGMENT2  -- DIVISION_ID       -- 그리고 수정 해야하는 새로운 MEASURE가 생겼을때 권한그룹별이나 요일별로 관리해야 한다면 필요시 GET_ADMIN_GROUP_MEASURE 에도 넣어야 한다.
        AND A.MEASURE      = M1.SEGMENT3  -- MEASURE
        AND M1.LOOKUP_TYPE = 'DM_UI_EDITABLE_MEASURE'
        AND M1.SEGMENT1    = 'DMF0082'
        AND M1.ATTRIBUTE2  = 'Y'          -- EDIT_YN 여부
        AND M1.VALID_YN    = 'Y'          -- VALID_YN 여부
    LEFT OUTER JOIN (
        /* MSSQL PIVOT ([SUN],[MON],...) → Oracle PIVOT ('SUN' AS SUN, ...) — CONCAT(ISNULL(x,0)...) → NVL || 결합 */
        SELECT PVT.DIVISION_ID, PVT.SCM_SITE_ID, PVT.INCOTERMS
             , TO_CHAR(NVL(PVT.SUN,0)) || TO_CHAR(NVL(PVT.MON,0)) || TO_CHAR(NVL(PVT.TUE,0)) || TO_CHAR(NVL(PVT.WED,0))
               || TO_CHAR(NVL(PVT.THU,0)) || TO_CHAR(NVL(PVT.FRI,0)) || TO_CHAR(NVL(PVT.SAT,0)) AS BUCKET
        FROM  (SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD
                    , CASE WHEN BUCKET_PER = 'Y' THEN 1 ELSE 0 END AS BUCKET_PER
               FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION
               WHERE  DIVISION_ID = p_division_id)
        PIVOT ( MAX(BUCKET_PER) FOR YYYYMMDD IN ('SUN' AS SUN, 'MON' AS MON, 'TUE' AS TUE, 'WED' AS WED, 'THU' AS THU, 'FRI' AS FRI, 'SAT' AS SAT) ) PVT
    ) BK
        ON  A.DIVISION_ID = BK.DIVISION_ID
        AND A.SCM_SITE_ID = BK.SCM_SITE_ID
        AND A.INCOTERMS   = BK.INCOTERMS
    --부서 테이블 추가
    LEFT OUTER JOIN (
        SELECT LOOK.SEGMENT3 AS DEPT_ID
        FROM   SCM_MGR.TB_FX_USER USR
        INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
            ON USR.DEPT_ID = LOOK.SEGMENT1 AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING' AND LOOK.VALID_YN = 'Y'
        WHERE  USR.USERID = p_created_by
        UNION -- 중복값 있으면 안됨
        SELECT DEPT_ID
        FROM   SCM_MGR.TB_FX_USER
        WHERE  USERID = p_created_by
    ) MA
        ON A.DEPT_ID = MA.DEPT_ID
    WHERE  1 = 1
    AND    (p_team_id = 'ALL' OR A.DEPT_ID IN (
                SELECT REGEXP_SUBSTR(p_team_id, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_team_id, ','), 0) + 1));
    --OPTION (HASH JOIN)  → MSSQL 힌트 제거

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_MF_SP', NO_INVALIDATE => FALSE);

    --2025.03.10 Philsu Park: MKT Fcst 수량 없는거 날리고 조회하는 구문 테스트.
    IF p_qty_yn = 'Y' THEN
        DELETE FROM SCM_MGR.GTT_MF_SP SP
        WHERE  NOT EXISTS (SELECT 1
                           FROM  (SELECT DIVISION_ID
                                       , SCM_SITE_ID
                                       , PROJECT_CODE
                                       , ITEM_ID
                                       , INCOTERMS
                                       , FCST_TYPE
                                       , DOM_EXP
                                       , END_CUSTOMER
                                       , CELL_PROD_SITE_ID
                                  FROM   SCM_MGR.GTT_MF_SP
                                  WHERE  MEASURE IN ('MKT_FCST','SCM_FCST') --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : SCM_FCST - MEASURE 추가
                                  GROUP BY DIVISION_ID
                                         , SCM_SITE_ID
                                         , PROJECT_CODE
                                         , ITEM_ID
                                         , INCOTERMS
                                         , FCST_TYPE
                                         , DOM_EXP
                                         , END_CUSTOMER
                                         , CELL_PROD_SITE_ID
                                  HAVING SUM(QTY) <> 0
                                 ) TT
                           WHERE  1 = 1
                           AND    TT.DIVISION_ID       = SP.DIVISION_ID
                           AND    TT.SCM_SITE_ID       = SP.SCM_SITE_ID
                           AND    TT.PROJECT_CODE      = SP.PROJECT_CODE
                           AND    TT.ITEM_ID           = SP.ITEM_ID
                           AND    TT.INCOTERMS         = SP.INCOTERMS
                           AND    TT.FCST_TYPE         = SP.FCST_TYPE
                           AND    TT.DOM_EXP           = SP.DOM_EXP
                           AND    TT.END_CUSTOMER      = SP.END_CUSTOMER
                           AND    TT.CELL_PROD_SITE_ID = SP.CELL_PROD_SITE_ID
                          );
    END IF;

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* [DEFECT_GUARD] PIVOT IN 리스트 비어있음 방어 — C_BUCKET 0행 시 빈 결과셋 조기 반환 (ORA-00936 회피) */
    --------------------------------------------------------------------------------------------------------------------------------------------------
    IF DBMS_LOB.GETLENGTH(V_PV_LIST) = 0 THEN
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST);     EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        OPEN O_RC1 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC2 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC3 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC4 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC5 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS RESULT_CODE, 'NO_BUCKET_DATA' AS RESULT_MSG, '0' AS EVENT FROM DUAL;
        RETURN;
    END IF;

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* 최종적으로 실행하는 동적쿼리 (첫번째 DataTable) — AS-IS placeholder REPLACE 방식 유지 */
    --------------------------------------------------------------------------------------------------------------------------------------------------
    DBMS_LOB.CREATETEMPORARY(V_SQL_TEXT, TRUE);

    V_SQL_TEXT := '
    SELECT [@V_COLUMN], SORT_ORDER_NO, [@V_PV_COL_LIST]
    FROM (      SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY
                FROM   SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
                AND (
                        (F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0) --[PJ2025-50188] FCST Gap 메저 추가 (MKT FCST - SCM FCST)
                        OR
                        (F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'') ) --[PJ2025-50188] FCST Gap 메저 추가 (MKT FCST - SCM FCST)
                    )
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END

                UNION ALL

                SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD
                        , CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'' ) AND F.WEEK_END_YN = ''Y'' THEN  SUM (F.QTY)
                               ELSE SUM(F.QTY)
                            END AS QTY
                FROM SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                  AND F.MEASURE NOT IN  (''KRW'', ''USD'', ''LOC''  ) -- LOC는 하단에서 별도 조회 [PJ2025-50188] 실적 Unit Price 로직 변경
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
                AND (
                        (F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0)
                        OR
                        (F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'') )
                    )
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END
                GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN, F.MEASURE

                -------------------------------------------------------------------------------
                -- [PJ2025-50188] 실적 Unit Price 로직 변경 : Weekly Sum 에서 LOC,KRW,USD 는 평균값으로 보이도록 소스 분리
                -------------------------------------------------------------------------------

                UNION ALL

                SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD
                        , AVG(QTY) AS QTY
                FROM SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                  AND F.MEASURE  IN  (''KRW'', ''USD'', ''LOC''  )
                GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW

                UNION ALL

                SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD
                        , CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv''  ) AND F.MONTH_END_YN = ''Y'' THEN SUM (F.QTY)
                               ELSE SUM(F.QTY)
                            END AS QTY
                FROM SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                  AND F.MEASURE NOT IN  (''KRW'', ''USD'', ''LOC''  ) -- LOC는 하단에서 별도 조회 [PJ2025-50188] 실적 Unit Price 로직 변경
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
                AND (
                        (F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0)
                        OR
                        (F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'') )
                    )
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END
                GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN, F.MEASURE

                -------------------------------------------------------------------------------
                -- [PJ2025-50188] 실적 Unit Price 로직 변경 : Monthly Sum 에서 LOC,KRW,USD 는 월 마지막 일자와 상관없이 일자 전체 평균값으로 보이도록 소스 분리
                -------------------------------------------------------------------------------

                UNION ALL

                SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD
                        , AVG(QTY) AS QTY
                FROM SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                  AND F.MEASURE IN  (''KRW'', ''USD'', ''LOC''  )
                GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM
        )
    PIVOT (SUM(QTY) FOR YYYYMMDD IN ( [@V_PV_LIST] )) PVT
    [@V_ORDERBY]
    ';
    /* AS-IS 말미의 OPTION ( ORDER GROUP ) MSSQL 힌트 제거 */

    /* AS-IS: REPLACE('[@v_PV_COL_LIST]', @v_PV_LIST) — MSSQL 은 두 리스트가 동일 문자열이라 무해.
       Oracle 은 PIVOT IN('D_x' AS D_x)과 SELECT(D_x) 형태가 다르므로 각각 올바른 리스트로 치환 (원문 버그 교정, 결과 동일) */
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_COL_LIST]', V_PV_COL_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_LIST]',     V_PV_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_COLUMN]',      V_COLUMN);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_ORDERBY]',     V_ORDERBY);

    -- 개발중에는 텍스트만 확인하고 실행은 안한다.
    /* SELECT CONVERT(TEXT, @v_sql_text) FOR XML PATH('') */

    /* 첫번째 DataTable */
    OPEN O_RC1 FOR V_SQL_TEXT;

    BEGIN DBMS_LOB.FREETEMPORARY(V_SQL_TEXT);    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST);     EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* 두번째 DataTable */
    ---------------------------------------------------------------------------------------------------------------
    -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : M+3 월까지 Monthly 버킷으로 MKT FCST 입력 불가
    -- Monthly에서 M+4 부터 수정 가능하게 하기. ( ex) 현재 5월이면, 9월부터 수정가능)
    ---------------------------------------------------------------------------------------------------------------
    OPEN O_RC2 FOR
        SELECT MONTH_NAME, ISO_WEEK
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M
        /* FORMAT(DATEADD(MONTH,3,GETDATE()),'yyyyMM') → 명시 마스크 (C-11) */
        WHERE  BASIS_YYYYMM = TO_CHAR(ADD_MONTHS(SYSDATE, 3), 'YYYYMM')
        ORDER BY BASIS_YYYYMMDD
        FETCH FIRST 1 ROWS ONLY;   /* SELECT TOP 1 */

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* 세번째 DataTable — 현재 주차 */
    --------------------------------------------------------------------------------------------------------------------------------------------------
    OPEN O_RC3 FOR
        SELECT 'M_' || A.BASIS_YYYYMM AS THIS_YYYYMM
             , 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS THIS_YYYYMMWW
             , A.BASIS_DATE
             , 'M_' || B.BASIS_YYYYMM AS PRE_YYYYMM
             , 'W_' || B.BASIS_YYYYMM || B.ISO_WEEK AS PRE_YYYYMMWW
             , A.BASIS_YYYYMM
             , A.ISO_WEEK
        FROM  (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M
               WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')          /* CONVERT(VARCHAR(8),GETDATE(),112) — C-11 */
              ) A
        JOIN  (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M
               WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE - 7, 'YYYYMMDD')      /* DATEADD(DAY,-7,GETDATE()) — C-11 */
              ) B ON 1 = 1;

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* 네번째 DataTable — 메저별 EDIT_FLAG */
    --[E20250729-000433]_[공급/생산SCM PI팀] 월요일 SCM FCST 입력 시 MKT FCST 수정 불가하도록 시스템 개선 (START)
    --[PJ2025-50188] 그룹+화면+사업부+MEASURE 별로 권한추가 (신규 Lookup - GET_ADMIN_GROUP_MEASURE) 추가 START
    --개발시점 기준 SCP Planner 만 SCM_FCST 에 대한 수정권한 부여. (실제적으로는 ADMIN , SCM PI ADMIN 도 같이 권한 추가 했음)
    --------------------------------------------------------------------------------------------------------------------------------------------------
    OPEN O_RC4 FOR
        SELECT A.MEASURE, A.EDIT_FLAG
        FROM   SCM_MGR.GTT_TEMP_ADMIN_GROUP_MEASURE A;
    --[PJ2025-50188] 그룹+화면+사업부+MEASURE 별로 권한추가 (신규 Lookup - GET_ADMIN_GROUP_MEASURE) 추가 END
    --[E20250729-000433]_[공급/생산SCM PI팀] 월요일 SCM FCST 입력 시 MKT FCST 수정 불가하도록 시스템 개선 (END)

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* 다섯번째 DataTable */
    --[PJ2025-50188] 고도화 - M+4 월부터 월간 물량 배분 로직 적용 (신규) - START
    --------------------------------------------------------------------------------------------------------------------------------------------------
    OPEN O_RC5 FOR
        SELECT BASIS_YYYYMMDD                 -- UI에서 BASIS_YYYYMMDD 로 값을 가져 온다.
             , BASIS_YYYYMM                   -- UI에서 BASIS_YYYYMM 로 값을 가져 온다.
             /* RIGHT(BASIS_START_DATE,2) → SUBSTR(x,-2) */
             , CASE WHEN SUBSTR(BASIS_START_DATE, -2) = '01' THEN 'Y' ELSE 'N' END AS FIRST_WEEK_FLAG  -- 매월 1일이 포함된 주차를 구분하는 FLAG
             /* LEFT(CONVERT(VARCHAR(8),DATEADD(DAY,7,...),112),6) = LEFT(...,6) → SUBSTR + TO_CHAR/TO_DATE 명시 마스크 (C-11) */
             , CASE WHEN SUBSTR(TO_CHAR(TO_DATE(BASIS_START_DATE, 'YYYYMMDD') + 7, 'YYYYMMDD'), 1, 6)  -- 7일 뒤에도
                         =
                         SUBSTR(BASIS_START_DATE, 1, 6)                                                -- 같은 달이라면 N , 다른 달이되었다면 Y
                    THEN 'N' ELSE 'Y' END AS END_MONTH_FLAG   --월별 마지막 주차 FLAG (해당 주차에 해당하는 일은 모두 표시되있음)
             , COUNT(*) OVER (PARTITION BY BASIS_YYYYMM) AS MONTH_DAY_CNT                    -- 해당 월의 일개수 (이 값으로 나눠야함)
             , COUNT(*) OVER (PARTITION BY ISO_YYYYWW || PARTIAL_WEEK_NAME) AS WEEK_DAY_CNT  -- 해당 주의 일개수 (이 값으로 곱해야함)
             , ISO_YYYYWW  --[20250616] KJIYOON
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M
        WHERE  BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        ORDER BY BASIS_YYYYMMDD;
    --[PJ2025-50188] 고도화 - M+4 월부터 월간 물량 배분 로직 적용 (신규) - END

    --------------------------------------------------------------------------------------------------------------------------------------------------
    -- O_RESULT_CURSOR: 성공 응답 (표준)
    --------------------------------------------------------------------------------------------------------------------------------------------------
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, '0' AS EVENT FROM DUAL;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## SUCCESS END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, p_created_by);
    EXCEPTION WHEN OTHERS THEN NULL; END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        BEGIN DBMS_LOB.FREETEMPORARY(V_SQL_TEXT);    EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST);     EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SUBSTR(SQLERRM, 1, 4000);
        V_BACKTRACE  := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', N_LOG_COUNT
              , '########## FAIL END of procedure ##########', V_DESCRIPTION
              , SYSDATE, p_created_by, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE);
        EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] ' || V_SQL_ERRMSG || CHR(10) || V_BACKTRACE);

END DMF0082_GET_MAIN_DATA_CURRENT;