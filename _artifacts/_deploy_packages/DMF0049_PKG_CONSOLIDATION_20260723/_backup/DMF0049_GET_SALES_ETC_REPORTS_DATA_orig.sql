
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0049_GET_SALES_ETC_REPORTS_DATA" 
(
    p_division_id     IN  VARCHAR2,
    p_mdf_type        IN  VARCHAR2,
    p_yyyy            IN  VARCHAR2,
    p_sp_version_no   IN  VARCHAR2,
    p_user_group      IN  VARCHAR2,
    p_created_by      IN  VARCHAR2,
    p_user_id         IN  VARCHAR2,   -- For EditYn
    p_menu_id         IN  VARCHAR2,   -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0049_GET_SALES_ETC_REPORTS_DATA
 * Description  : ETC Sales Reports 메인 데이터 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/04/02  HWI1993	Initial Release
 * 2020/05/19	HWI1993	SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, ITEM_USE ISNULL 처리 ( NULL 과 공백이 GROUPING 분리됨 )
 * 2021/01/26     P.C.I		[C20210125-000207] 40사업부 RTF Measure, CELL_MODEL_INFO 컬럼 추가
 * 2022/01/12	rosia27		[C20220105-000064]ETC Report 구버전 조회시 조직 명칭 오류의 건
 * 2022/01/21	rosia27		[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
 * 2026/06/05	NextSCM Migration	[PJ202650304] 기존 배포본(미완성 자동변환, INVALID) 전면 재변환. #SELECT_MEASURE/#PJT/#temp→GTT(GT_DMF0049_*), @PROD 누적→FOR LOOP, 동적 SQL/PIVOT 정정(EXECUTE 대신 OPEN O_RC1 FOR), Pilot 표준 적용(로깅/EXCEPTION/O_RESULT_CURSOR/EDIT_YN 권한 INNER JOIN). 템플릿=DMF0044_GET_SALES_REPORTS_DATA(VALID)
 */
IS

    V_PROD          VARCHAR2(4000 CHAR) := '';   -- PIVOT IN 절 (값 AS 별칭)
    V_COLS          VARCHAR2(4000 CHAR) := '';   -- 외부 SELECT 의 PIVOT 컬럼 참조
    V_SQL           VARCHAR2(32767 CHAR) := '';
    V_GROUP_ID      VARCHAR2(100 CHAR) := '';
    V_TEAM_ID       VARCHAR2(100 CHAR) := '';
    V_USER_MEA_CNT  PLS_INTEGER := 0;

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── GTT 초기화 (세션 보존 GTT 이므로 DELETE) ── */
    DELETE FROM SCM_MGR.GT_DMF0049_SELECT_MEASURE;
    DELETE FROM SCM_MGR.GT_DMF0049_PJT;
    DELETE FROM SCM_MGR.GT_DMF0049_T;

    ---------------------------------------------------------------------------------
    --            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    BEGIN
        SELECT 1
        INTO   V_USER_MEA_CNT
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
            AND    VALID_YN = 'Y'
            AND    SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
            AND    SEGMENT1 = p_user_group
        );
        V_GROUP_ID := 'ADMIN';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_GROUP_ID := '';
    END;
    ---------------------------------------------------------------------------------
    --            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    -- 팀 권한
    BEGIN
        SELECT DEPT_ID
        INTO   V_TEAM_ID
        FROM   TB_FX_USER
        WHERE  USERID = p_created_by;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_TEAM_ID := '';
        WHEN TOO_MANY_ROWS THEN
            V_TEAM_ID := '';
    END;

    V_USER_MEA_CNT := 0;

    -- MEASURE JOIN 처리용
    -- 사용자메저 처리
    BEGIN
        SELECT 1
        INTO   V_USER_MEA_CNT
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MST_TITLESET_USER U
            WHERE  U.PROGRAM_ID = 'DMF0049'
            AND    U.SHEET_NAME = 'MDF Reports'
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
            AND    U.USER_ID    = p_created_by
        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_USER_MEA_CNT := 0;
    END;

    IF V_USER_MEA_CNT = 0 THEN
        INSERT INTO SCM_MST_TITLESET_USER
        ( USER_ID
        , PROGRAM_ID
        , SHEET_NAME
        , USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME
        , SORT_ORDER_NO
        , SUB_TOTAL_FLAG
        , DATA_SORT_METHOD_CODE
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
        )
        SELECT p_created_by
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'M'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , 'N'
             , ''
             , p_created_by
             , SYSDATE                 -- [PJ202650304] DATE 컬럼: 문자열 변환 제거(ORA-01861 예방)
             , p_created_by
             , SYSDATE
        FROM   SCM_MST_SHEET_MEASURE C
        WHERE  1 = 1
        AND    C.PROGRAM_ID  = 'DMF0049'
        AND    C.SHEET_NAME  = 'MDF Reports'
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;

    /* ── GT_DMF0049_SELECT_MEASURE 적재 (#SELECT_MEASURE) ── */
    INSERT INTO SCM_MGR.GT_DMF0049_SELECT_MEASURE
        (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE, SORT_ORDER_NO)
    SELECT U.PROGRAM_ID
         , U.SHEET_NAME
         , U.USER_ID
         , U.COLUMN_NAME AS MEASURE
         , U.SORT_ORDER_NO
    FROM SCM_MST_TITLESET_USER U
    WHERE 1 = 1
    AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND U.PROGRAM_ID   = 'DMF0049'
    AND U.USER_ID      = p_created_by;

    /* ── GT_DMF0049_PJT 적재 (#PJT) ── */
    INSERT INTO SCM_MGR.GT_DMF0049_PJT
        (DIVISION_ID, PROJECT_CODE, PROJECT_NAME, PRODUCT_GROUP_NAME)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_NAME, A.PRODUCT_GROUP_NAME
    FROM SCM_MST_PROJECT A
    JOIN (
        SELECT PROJECT_CODE, MAX(PROJECT_VER_SEQ) AS SEQ
        FROM SCM_MST_PROJECT
        WHERE DIVISION_ID = p_division_id
        GROUP BY PROJECT_CODE
    ) B ON A.PROJECT_CODE = B.PROJECT_CODE AND A.PROJECT_VER_SEQ = B.SEQ
    WHERE A.DIVISION_ID = p_division_id;

    -- 단계1. 데이터 쿼리 ########################################################
    /* ── GT_DMF0049_T 적재 (#temp) ── */
    INSERT INTO SCM_MGR.GT_DMF0049_T
         ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID
         , T_DEPARTMENT_ID, T_DEPARTMENT_NAME, DEPT_ID, T_DEPT_ID, T_DEPT_NAME
         , END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
         , ITEM_ID, NICK_NAME, MEASURE, PLANT_SITE_ID, COMPANY_ID
         , YYYYMM, CURRENCY, QTY, EDIT_FLAG, APP
         , SOLDTO_CUST_REPORT, DMS_CUSTOMER, BIZ_TYPE, APPLICATION_GR, PRODUCT_DETAILS
         , DISPLAY_SEQ1, DISPLAY_SEQ2, COUNTRY_CODE, SOLDTO_CODE, CELL_PER_CAR
         , CELL_NAME, FCST_TYPE, DATA_SEQ, INCOTERMS, ITEM_USE
         , MODEL_TYPE, MODULE_PER_CAR, PROJECT_NAME, SOLDTO_COUNTRY, SHIPTO_COUNTRY
         , END_CUSTOMER, CELL_MODEL, CELL_MODEL_INFO )
    SELECT
        R.DIVISION_ID
        , R.VERSION_NO
        , R.CUTOFF_TYPE
        , R.CUTOFF_YYYYMMDD
        , R.DEPARTMENT_ID
        , R.DEPARTMENT_ID AS T_DEPARTMENT_ID
        , CASE WHEN NVL(R.DEPARTMENT_NAME,'') <> '' THEN R.DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS T_DEPARTMENT_NAME
        , R.DEPT_ID
        , R.DEPT_ID AS T_DEPT_ID
        , CASE WHEN NVL(R.DEPT_NAME,'') <> '' THEN R.DEPT_NAME ELSE LK2.SEGMENT2 END AS T_DEPT_NAME
        , R.END_CUST_REPORT
        , R.CUST_REPORT
        , R.PRODUCT_GROUP
        , R.PROJECT_CODE
        , R.SCM_SITE_ID
        , R.ITEM_ID
        , SINGLE.NICK_NAME
        , R.MEASURE
        , R.PLANT_SITE_ID
        , R.COMPANY_ID
        , 'M_' || SUBSTR(R.YYYYMMDD, 1, 6) AS YYYYMM
        , R.CURRENCY
        , SUM(R.QTY) AS QTY
        , CASE WHEN (V_GROUP_ID = 'ADMIN') THEN 'Y' ELSE 'N' END AS EDIT_FLAG
        , R.APPLICATION AS APP
        , R.SOLDTO_CUST_REPORT
        , NVL(SI.ATTRIBUTE2,'') AS DMS_CUSTOMER
        , R.BIZ_TYPE AS BIZ_TYPE
        , R.APPLICATION_GR AS APPLICATION_GR
        , R.PRODUCT_DETAILS AS PRODUCT_DETAILS
        , LK1.DISPLAY_SEQ AS DISPLAY_SEQ1
        , LK2.DISPLAY_SEQ AS DISPLAY_SEQ2
        , R.COUNTRY_CODE
        , R.SOLDTO_CODE
        , SI.CELL_PER_CAR
        , '' AS CELL_NAME
        , R.FCST_TYPE
        , R.DATA_SEQ
        , R.INCOTERMS
        , NVL(R.ITEM_USE,'') AS ITEM_USE
        , ITEM_V.ITEM_CLASS_NAME AS MODEL_TYPE
        , CASE WHEN SI.CELL_PER_MODULE <> 0 THEN SI.CELL_PER_CAR / SI.CELL_PER_MODULE END AS MODULE_PER_CAR
        , LK3.SEGMENT3 AS PROJECT_NAME
        , NVL(R.SOLDTO_COUNTRY,'') AS SOLDTO_COUNTRY
        , NVL(R.SHIPTO_COUNTRY,'') AS SHIPTO_COUNTRY
        , NVL(R.END_CUSTOMER,'') AS END_CUSTOMER
        , NVL(R.ATTRIBUTE3,'') AS CELL_MODEL          --[C20211112-000213]
        , NVL(R.CELL_MODEL_INFO, '') AS CELL_MODEL_INFO --[C20211112-000213]
    FROM DM_PLN_SALES_ETC_REPORT_C R
    LEFT JOIN SCM_MST_SITE_ITEM SI
        ON R.DIVISION_ID = SI.DIVISION_ID
            AND R.PROJECT_CODE = SI.PROJECT_CODE
            AND R.SCM_SITE_ID = SI.SCM_SITE_ID
            AND R.ITEM_ID = SI.ITEM_ID
    LEFT JOIN DM_MST_ITEM_SINGLE_V SINGLE
        ON SI.DIVISION_ID = SINGLE.DIVISION_ID
            AND SI.ITEM_ID = SINGLE.ITEM_ID
    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON R.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT' || CASE WHEN R.DIVISION_ID = '40' THEN '' ELSE '_' || R.DIVISION_ID END
    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 ON R.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0049_DEPARTMENT_TEAM2' || CASE WHEN R.DIVISION_ID = '40' THEN '' ELSE '_' || R.DIVISION_ID END
    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 ON R.PROJECT_CODE = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_ETC_PROJECT' AND LK3.SEGMENT1 = R.DIVISION_ID
    LEFT OUTER JOIN SCM_MST_SITE ST ON R.SCM_SITE_ID = ST.SCM_SITE_ID AND R.DIVISION_ID = ST.DIVISION_ID
    LEFT OUTER JOIN SCM_MST_COUNTRY CO ON ST.COUNTRY = CO.COUNTRY
    LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER CS ON R.DIVISION_ID = CS.DIVISION_ID AND R.SCM_SITE_ID = CS.SCM_SITE_ID AND CS.REP_YN = 'Y' AND CS.VALID_YN = 'Y'
    LEFT OUTER JOIN SCM_MGR.GT_DMF0049_PJT PJT ON R.DIVISION_ID = PJT.DIVISION_ID AND R.PROJECT_CODE = PJT.PROJECT_CODE
    LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V ITEM_V ON R.DIVISION_ID = ITEM_V.DIVISION_ID AND R.ITEM_ID = ITEM_V.ITEM_ID
    WHERE R.DIVISION_ID = p_division_id
        AND R.CUTOFF_TYPE = p_mdf_type
        AND SUBSTR(R.YYYYMMDD, 1, 4) = p_yyyy
        AND R.VERSION_NO = p_sp_version_no
    GROUP BY
        R.DIVISION_ID
        , R.VERSION_NO
        , R.CUTOFF_TYPE
        , R.CUTOFF_YYYYMMDD
        , R.DEPARTMENT_ID
        , R.DEPT_ID
        , R.END_CUST_REPORT
        , R.CUST_REPORT
        , R.PRODUCT_GROUP
        , R.PROJECT_CODE
        , R.SCM_SITE_ID
        , R.ITEM_ID
        , SINGLE.NICK_NAME
        , R.MEASURE
        , R.PLANT_SITE_ID
        , R.COMPANY_ID
        , SUBSTR(R.YYYYMMDD, 1, 6)
        , R.CURRENCY
        , R.APPLICATION
        , R.SOLDTO_CUST_REPORT
        , NVL(SI.ATTRIBUTE2,'')
        , R.BIZ_TYPE
        , R.APPLICATION_GR
        , R.PRODUCT_DETAILS
        , LK1.DISPLAY_SEQ
        , LK2.DISPLAY_SEQ
        , R.COUNTRY_CODE
        , R.SOLDTO_CODE
        , SI.CELL_PER_CAR
        , R.FCST_TYPE
        , R.DATA_SEQ
        , R.INCOTERMS
        , SUBSTR(R.PROJECT_CODE, 1, 1)
        , ITEM_V.ITEM_CLASS_NAME
        , CASE WHEN SI.CELL_PER_MODULE <> 0 THEN SI.CELL_PER_CAR / SI.CELL_PER_MODULE END
        , LK3.SEGMENT3
        , NVL(R.SOLDTO_COUNTRY, '')
        , NVL(R.SHIPTO_COUNTRY, '')
        , NVL(R.END_CUSTOMER, '')
        , NVL(R.ITEM_USE, '')
        , NVL(R.ATTRIBUTE3,'')          --[C20211112-000213]
        , NVL(R.CELL_MODEL_INFO, '')    --[C20211112-000213]
        , CASE WHEN NVL(R.DEPT_NAME,'') <> '' THEN R.DEPT_NAME ELSE LK2.SEGMENT2 END
        , CASE WHEN NVL(R.DEPARTMENT_NAME,'') <> '' THEN R.DEPARTMENT_NAME ELSE LK1.SEGMENT2 END;

    -- 단계3. PIVOT 기간 쿼리 ########################################################
    V_PROD := '';
    V_COLS := '';
    FOR rec IN (
        SELECT DISTINCT BASIS_YYYYMM
        FROM SCM_SYS_CALENDAR_M
        WHERE CALENDAR_YYYY = p_yyyy
        ORDER BY BASIS_YYYYMM
    )
    LOOP
        V_PROD := V_PROD || '''M_' || rec.BASIS_YYYYMM || ''' AS "M_' || rec.BASIS_YYYYMM || '",';
        V_COLS := V_COLS || '"M_' || rec.BASIS_YYYYMM || '",';
    END LOOP;

    IF V_PROD IS NOT NULL AND LENGTH(V_PROD) > 0 THEN
        V_PROD := RTRIM(V_PROD, ',');
        V_COLS := RTRIM(V_COLS, ',');
    END IF;

    -- 단계4. 실행 쿼리 ########################################################
    V_SQL :=
       'SELECT DIVISION_ID, VERSION_NO, DEPARTMENT_ID, T_DEPARTMENT_ID, T_DEPARTMENT_NAME, DEPT_ID, T_DEPT_ID, T_DEPT_NAME'
    || ', NVL(END_CUST_REPORT, '''') AS END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID'
    || ', NVL(NICK_NAME, '''') AS NICK_NAME, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, COMPANY_ID, CURRENCY'
    || ', NVL(APP, '''') AS APPLICATION, EDIT_FLAG, SOLDTO_CUST_REPORT, BIZ_TYPE, APPLICATION_GR, PRODUCT_DETAILS'
    || ', CELL_MODEL_INFO, CELL_MODEL, COUNTRY_CODE, SOLDTO_CODE, CELL_PER_CAR, CELL_NAME, DATA_SEQ, FCST_TYPE, INCOTERMS'
    || ', ITEM_USE, MODEL_TYPE, MODULE_PER_CAR, PROJECT_NAME, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER'
    || CASE WHEN V_COLS IS NOT NULL AND LENGTH(V_COLS) > 0 THEN ', ' || V_COLS ELSE '' END
    || ' FROM ( SELECT A.* FROM SCM_MGR.GT_DMF0049_T A'
    || ' JOIN SCM_MGR.GT_DMF0049_SELECT_MEASURE B ON A.MEASURE = B.MEASURE'
    || ' INNER JOIN ( SELECT * FROM SCM_ADM_USER_MNU_EDIT_AUTH_V WHERE USER_ID = ''' || p_user_id || ''' AND MNU_ID = ''' || p_menu_id || ''' AND UNIT_TP_CD = ''D'' ) T2 ON A.DIVISION_ID = T2.UNIT_ID'
    || ' ) T'
    || ' PIVOT ( SUM(QTY) FOR YYYYMM IN ( ' || V_PROD || ' ) ) PVT'
    || ' ORDER BY DIVISION_ID, VERSION_NO, DISPLAY_SEQ1, DISPLAY_SEQ2, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT'
    || ', PRODUCT_GROUP, ITEM_ID, NICK_NAME, PRODUCT_DETAILS, CELL_MODEL_INFO, CELL_MODEL, CURRENCY, COMPANY_ID, BIZ_TYPE, APPLICATION_GR, NVL(APP, ''''), COUNTRY_CODE, DATA_SEQ'
    || ', CASE WHEN MEASURE IN (''LOC'') THEN 1 WHEN MEASURE IN (''RTF'',''Business_Plan'') THEN 2 WHEN MEASURE IN (''SalesAmt_LOC'') THEN 3 WHEN MEASURE IN (''SalesAmt_KRW'') THEN 4 ELSE 5 END'
    || ', END_CUSTOMER';

    OPEN O_RC1 FOR V_SQL;

    /* ── COMMIT (종료 직전 1회) ── */
    COMMIT;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회+DML 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'p_division_id'   VALUE p_division_id,
            'p_mdf_type'      VALUE p_mdf_type,
            'p_yyyy'          VALUE p_yyyy,
            'p_sp_version_no' VALUE p_sp_version_no,
            'p_user_group'    VALUE p_user_group,
            'p_created_by'    VALUE p_created_by,
            'p_user_id'       VALUE p_user_id,
            'p_menu_id'       VALUE p_menu_id
        );
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
END DMF0049_GET_SALES_ETC_REPORTS_DATA;
/