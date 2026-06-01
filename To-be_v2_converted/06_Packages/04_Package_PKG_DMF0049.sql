/*=============================================================================================
 * File         : 04_Package_PKG_DMF0049.sql
 * Description  : Package — PKG_DMF0049
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0049 IS
    /*
    * Program ID   : PKG_DMF0049
    * Description  : PKG_DMF0049
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0049_GET_MEASURE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0049_GET_SPREAD_TITLE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_START_DT      VARCHAR2
       ,P_END_DT        VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );


    -- [P1-2 재처리 흡수]
    PROCEDURE P_DMF0049_GET_SALES_ETC_REPORTS_DATA (
    	v_division_id				VARCHAR2,
    	p_mdf_type				VARCHAR2,
    	p_yyyy					VARCHAR2,
    	p_sp_version_no		VARCHAR2,
    	p_user_group			VARCHAR2,
    	p_created_by			VARCHAR2
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
     */
    );

    END PKG_DMF0049;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0049 IS

    PROCEDURE P_DMF0049_GET_MEASURE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
         * Program ID   : DMF0049_GET_MEASURE
         * Description  :  Sales ETC Report 메저 가져오기
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2020/03/30 HWI1993   Initial Release -- dmf0044 에서 복사해서 생성
         * 2020/05/04 HWI1993   DIVISION_ID 를 WHERE 절에 추가
         * 2020/06/10 HWI1993   40이 아닌 경우 USD 추가
         * 2021/01/28 P.C.I   [C20210125-000207] 소형사업부 RTF_SYS_RP Measure 추가
           2022.04.25 HWI1993   GM JV 작업
           2026.03.14 김준규   [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS
    
        $$PLSQL_UNIT VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE     VARCHAR2(30 CHAR);
        N_LOG_COUNT    INTEGER := 0;
        V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
        V_DESCRIPTION  VARCHAR2(500 CHAR);
        D_EVENT_DATE   DATE;
        V_IN_PARA_DATA CLOB;
    BEGIN
    
        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID);
    
        IF P_DIVISION_ID = '40' THEN
            OPEN O_RC1 FOR
                SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME NAME, TEI.EDIT_YN
                FROM   SCM_MST_SHEET_MEASURE A
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = A.DIVISION_ID
                WHERE  1 = 1
                AND    PROGRAM_ID = 'DMF0049'
                AND    SHEET_NAME IN ( 'MDF Reports','mdfReports' )
                AND    COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'RTF_SYS_RP') --[C20210125-000207] 소형사업부 RTF_SYS_RP Measure 추가
                AND    INSTR(A.DIVISION_ID, P_DIVISION_ID) > 0
                ORDER  BY SORT_ORDER_NO;
        ELSE
            OPEN O_RC1 FOR
                SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME NAME, TEI.EDIT_YN
                FROM   SCM_MST_SHEET_MEASURE A
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = A.DIVISION_ID
                WHERE  1 = 1
                AND    PROGRAM_ID = 'DMF0049'
                AND    SHEET_NAME IN ( 'MDF Reports','mdfReports' )
                AND    COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD')
                AND    INSTR(A.DIVISION_ID, P_DIVISION_ID) > 0
                ORDER  BY SORT_ORDER_NO;
        END IF;
    
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE  => SQLCODE
                                ,P_SQL_ERR_MSG   => SQLERRM
                                ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0049_GET_MEASURE;

    PROCEDURE P_DMF0049_GET_SPREAD_TITLE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_START_DT      VARCHAR2
       ,P_END_DT        VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0049_GET_SPREAD_TITLE
        * Description  :
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 2020/04/02 hwi1993   DMF0049_GET_SPREAD_TITLE
        * 2022/05/12 hwi1993   GM JV
        * 2026/03/15 김준규      [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS
    
        P_PROGRAM_ID   VARCHAR2(50 CHAR);
        P_SHEET_NAME   VARCHAR2(50 CHAR);
        V_IN_PARA_DATA CLOB;
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN
    
        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID
                                     ,'p_created_by' VALUE P_CREATED_BY
                                     ,'p_start_dt' VALUE P_START_DT
                                     ,'p_end_dt' VALUE P_END_DT);
    
        P_PROGRAM_ID := 'DMF0049';
        P_SHEET_NAME := 'MDF Reports';
    
        OPEN O_RC1 FOR
            SELECT C.PROGRAM_ID
                  ,C.SHEET_NAME
                  ,C.COLUMN_NAME
                  ,C.COLUMN_LABEL_NAME
                   --, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) SORT_ORDER_NO
                  ,CASE
                       WHEN P_DIVISION_ID = '40' THEN
                        TO_CHAR(C.SORT_ORDER_NO)
                       WHEN P_DIVISION_ID LIKE '81%' THEN
                        C.ATTRIBUTE2
                       WHEN P_DIVISION_ID = '82' THEN
                        C.ATTRIBUTE3
                   END AS SORT_ORDER_NO
                  ,C.DATA_SORT_METHOD_CODE
                  ,C.SMALL_CLASS_LABEL_NAME
                  ,C.LARGE_CLASS_LABEL_NAME
                  ,'' AS DAY_CODE
                  ,C.FIXED_FLAG
                  ,CASE
                       WHEN CASE
                                WHEN P_DIVISION_ID = '40' THEN
                                 C.VISIBLE_FLAG
                                WHEN P_DIVISION_ID LIKE '81%' THEN
                                 C.ATTRIBUTE4
                                WHEN P_DIVISION_ID = '82' THEN
                                 C.ATTRIBUTE5
                            END = 'Y' THEN
                        C.COLUMN_WIDTH
                       ELSE
                        0
                   END AS COLUMN_WIDTH
                  ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                  ,C.CELL_COMBO_DATA_TYPE
                  ,TO_CHAR(C.DATA_SCALE_NUMBER) DATA_SCALE_NUMBER
                  ,TO_CHAR(C.DATA_MAX_LENGTH) DATA_MAX_LENGTH
                  ,C.HORIZONTAL_ALIGN_CODE
                  ,C.UPPERCASE_APPLY_FLAG
                  ,CASE
                       WHEN P_DIVISION_ID = '40' THEN
                        C.VISIBLE_FLAG
                       WHEN P_DIVISION_ID LIKE '81%' THEN
                        C.ATTRIBUTE4
                       WHEN P_DIVISION_ID = '82' THEN
                        C.ATTRIBUTE5
                   END AS VISIBLE_FLAG
                  ,C.DEFAULT_FLAG
                  ,C.USER_SELECTABLE_FLAG
                  ,C.VALID_YN
                  ,C.DIVISION_ID
                  ,P_DIVISION_ID ATTRIBUTE1 -- COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다.
                  ,CASE
                       WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN
                        C.ATTRIBUTE1
                       ELSE
                        C.ATTRIBUTE1
                   END AS ATTRIBUTE2
                  ,'' AS ATTRIBUTE3
                  ,'' AS ATTRIBUTE4
                  ,'' AS ATTRIBUTE5
                  ,TEI.EDIT_YN
            FROM   SCM_MST_SHEET_COLUMNS C
            INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
            ON     TEI.UNIT_ID = C.DIVISION_ID
            WHERE  1 = 1
            AND    C.PROGRAM_ID = P_PROGRAM_ID
            AND    C.SHEET_NAME = P_SHEET_NAME
            AND    C.VALID_YN = 'Y'
            AND    C.DIVISION_ID LIKE '%' || P_DIVISION_ID || '%'
            UNION ALL
            
            SELECT P_PROGRAM_ID PROGRAM_ID
                  ,P_SHEET_NAME SHEET_NAME
                  ,MA.COLUMN_NAME
                  ,MA.COLUMN_LABEL_NAME
                  ,MA.SORT_ORDER_NO
                  ,'' AS DATA_SORT_METHOD_CODE
                  ,MA.SMALL_CLASS_LABEL_NAME
                  ,MA.LARGE_CLASS_LABEL_NAME
                  ,MA.DAY_CODE
                  ,'' AS FIXED_FLAG
                  ,120 COLUMN_WIDTH
                  ,MA.CELL_CONTROL_OBJECT_TYPE_CODE --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                  ,'' AS CELL_COMBO_DATA_TYPE
                   --, '2'         AS DATA_SCALE_NUMBER
                  ,'3' AS DATA_SCALE_NUMBER -- 20181029
                  ,'2' AS DATA_MAX_LENGTH
                  ,'R' AS HORIZONTAL_ALIGN_CODE
                  ,'' AS UPPERCASE_APPLY_FLAG
                  ,'Y' AS VISIBLE_FLAG
                  ,'' AS DEFAULT_FLAG
                  ,'' AS USER_SELECTABLE_FLAG
                  ,'' AS VALID_YN
                  ,'' AS DIVISION_ID
                  ,'' AS ATTRIBUTE1
                  ,'' AS ATTRIBUTE2
                  ,'' AS ATTRIBUTE3
                  ,'' AS ATTRIBUTE4
                  ,'' AS ATTRIBUTE5
                  ,'' AS EDIT_YN
            FROM   (SELECT DISTINCT 'M_' || BASIS_YYYYMM AS COLUMN_NAME
                                   ,MONTH_NAME COLUMN_LABEL_NAME
                                   ,MONTH_NAME SMALL_CLASS_LABEL_NAME
                                   ,MONTH_NAME LARGE_CLASS_LABEL_NAME
                                   ,'' AS DAY_CODE
                                   ,TO_CHAR(BASIS_YYYYMM) SORT_ORDER_NO
                                   ,'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                    FROM   SCM_SYS_CALENDAR_M
                    WHERE  BASIS_YYYYMMDD >= P_START_DT
                    AND    BASIS_YYYYMMDD <= P_END_DT
                    
                    ) MA
            
            ORDER  BY SORT_ORDER_NO;
    
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    
    EXCEPTION
        WHEN OTHERS THEN
            V_LOG_TYPE   := 'ERROR';
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,V_PROC_INPUT
                                ,V_SQL_CODE
                                ,V_SQL_ERRMSG
                                ,V_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0049_GET_SPREAD_TITLE;


    -- [P1-2 재처리 흡수]
    PROCEDURE P_DMF0049_GET_SALES_ETC_REPORTS_DATA (
    	v_division_id				VARCHAR2,
    	p_mdf_type				VARCHAR2,
    	p_yyyy					VARCHAR2,
    	p_sp_version_no		VARCHAR2,
    	p_user_group			VARCHAR2,
    	p_created_by			VARCHAR2
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
     */
    )
        IS
    V_PROD VARCHAR2(4000 CHAR) := NULL;
        V_SQL VARCHAR2(4000 CHAR) := NULL;
        v_group_id VARCHAR2(4000 CHAR) := NULL;
        v_team_id VARCHAR2(4000 CHAR) := NULL;
        v_user_mea_cnt INTEGER;
        v_cnt_1  INTEGER := 0;
    BEGIN
    
    
    
    
    
    
    	-- 권한 그룹
    	--IF p_user_group = 'ADMIN' OR p_user_group = 'DM ADMIN'
    	--	v_group_id := 'ADMIN';
    
    	-- ------------------------------------------------------------------------------
    	--            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    	-- ------------------------------------------------------------------------------
    	SELECT COUNT(1)
    	INTO v_cnt_1
    	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    	where LOOKUP_TYPE = 'GET_ADMIN_GROUP'
    	AND VALID_YN = 'Y'
    	AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
    	AND SEGMENT1 = p_user_group;
    	IF v_cnt_1 > 0 THEN
    			v_group_id := 'ADMIN';
    		END IF;
    	-- ------------------------------------------------------------------------------
    	--            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    	-- ------------------------------------------------------------------------------
    	-- 팀 권한
    	select Dept_ID
      INTO v_team_id
    	from TB_FX_User  where UserID = p_created_by;
    	v_user_mea_cnt := 0;
    
    
    	-- MEASURE JOIN 처리용
    	-- 사용자메저 처리
    	SELECT COUNT(*)
      INTO V_USER_MEA_CNT
    	FROM   SCM_MST_TITLESET_USER U
    	WHERE  U.PROGRAM_ID = 'DMF0049'
        AND    U.SHEET_NAME = 'MDF Reports'
    	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
        AND    U.USER_ID    = p_created_by;
    
    
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
    			 , ''
    			 , ''
    			 , p_created_by
    			 , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3')
    			 , p_created_by
    			 , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3')
    		FROM   SCM_MST_SHEET_MEASURE C
    		WHERE  1 = 1
    		AND    C.PROGRAM_ID  = 'DMF0049'
    		AND    C.SHEET_NAME  = 'MDF Reports'
    		AND    C.DEFAULT_FLAG = 'Y'
    		AND    C.VALID_YN     = 'Y'	;
    	END IF;
    
    
    
    		/* TODO:GTT:GT_DMF0_SELECT_MEASURE-->GT_DMF0_SELECT_MEASURE */
    		INSERT INTO GT_DMF0_SELECT_MEASURE
    		SELECT U.PROGRAM_ID
    				, U.SHEET_NAME
    				, U.USER_ID
    				, U.COLUMN_NAME AS MEASURE
    				, U.SORT_ORDER_NO
    		FROM SCM_MST_TITLESET_USER U  WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
    		WHERE 1 = 1
    		AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    		AND U.PROGRAM_ID   = 'DMF0049'
    		AND U.USER_ID      = p_created_by;
    
    
    
    
    	/* TODO:GTT:GT_DMF0_PJT-->GT_DMF0_PJT */
    	INSERT INTO GT_DMF0_PJT
    	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_NAME, A.PRODUCT_GROUP_NAME
    	FROM SCM_MST_PROJECT A
    	JOIN (
    		SELECT PROJECT_CODE, MAX(PROJECT_VER_SEQ) AS SEQ
    		FROM SCM_MST_PROJECT
    		WHERE DIVISION_ID = v_division_id
    		GROUP BY PROJECT_CODE
    		) B ON A.PROJECT_CODE = B.PROJECT_CODE AND A.PROJECT_VER_SEQ = B.SEQ
    	WHERE A.DIVISION_ID = v_division_id;
    
    
    
    	-- 단계1. 데이터 쿼리 ########################################################
    
    	/* TODO:GTT:GT_DMF0_-->GT_DMF0_ */
    	INSERT INTO GT_DMF0_
    	SELECT
    		R.DIVISION_ID
    		,R.VERSION_NO
    		,R.CUTOFF_TYPE
    		,R.CUTOFF_YYYYMMDD
    		,R.DEPARTMENT_ID
    		,R.DEPARTMENT_ID AS T_DEPARTMENT_ID
    		, CASE WHEN NVL(R.DEPARTMENT_NAME, NULL) IS NOT NULL THEN R.DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS T_DEPARTMENT_NAME
    		,R.DEPT_ID
    		,R.DEPT_ID AS T_DEPT_ID
    		, CASE WHEN NVL(R.DEPT_NAME, NULL) IS NOT NULL THEN R.DEPT_NAME ELSE LK2.SEGMENT2 END AS T_DEPT_NAME
    		,R.END_CUST_REPORT
    		,R.CUST_REPORT
    		,R.PRODUCT_GROUP
    		,R.PROJECT_CODE
    		,R.SCM_SITE_ID
    		,R.ITEM_ID
    		,SINGLE.NICK_NAME
    		--,SI.APPLICATION
    		--,R.DOM_EXP
    		--,R.FCST_TYPE
    		--,R.INCOTERMS
    		,R.MEASURE
    		,R.PLANT_SITE_ID
    		,R.COMPANY_ID
    		,'M_'  ||  SUBSTR(R.YYYYMMDD, 1, 6) AS YYYYMM
    		,R.CURRENCY
    		,SUM(R.QTY) AS QTY
    		,CASE WHEN (v_group_id = 'ADMIN') THEN 'Y' ELSE '' END AS EDIT_FLAG
    		, R.APPLICATION AS APP
    		, R.SOLDTO_CUST_REPORT -- 20190213 KHSONG [CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건 --20190322 KHSONG 고객군, 판매처 컬럼 NULL처리조건 추가
    		,NVL(SI.attribute2, NULL) DMS_CUSTOMER  -- 20190213 KHSONG [CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건 --20190322 KHSONG 고객군, 판매처 컬럼 NULL처리조건 추가
    		--, SINGLE.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40
    		, R.BIZ_TYPE as BIZ_TYPE
    		, R.APPLICATION_GR AS APPLICATION_GR
    		, R.PRODUCT_DETAILS AS PRODUCT_DETAILS
    		--, SI.REPORT_GROUP6 AS CELL_MODEL_INFO --[C20210125-000207] Master 대신 ETC Report에서 입력한 40사업부 CELL_MODEL_INFO 적용
    		, LK1.DISPLAY_SEQ AS DISPLAY_SEQ1
    		, LK2.DISPLAY_SEQ AS DISPLAY_SEQ2
    		, R.COUNTRY_CODE
    		, R.SOLDTO_CODE
    		, SI.CELL_PER_CAR
    		, '' AS CELL_NAME
    		, R.FCST_TYPE
    		, R.DATA_SEQ
    		, R.INCOTERMS
    		, NVL(R.ITEM_USE, NULL) AS ITEM_USE
    		, ITEM_V.ITEM_CLASS_NAME AS MODEL_TYPE
    		, CASE WHEN SI.CELL_PER_MODULE <> 0 THEN SI.CELL_PER_CAR / SI.CELL_PER_MODULE END AS MODULE_PER_CAR
    		, LK3.SEGMENT3 AS PROJECT_NAME
    		, NVL(R.SOLDTO_COUNTRY, NULL) AS SOLDTO_COUNTRY
    		, NVL(R.SHIPTO_COUNTRY, NULL) AS SHIPTO_COUNTRY
    		, NVL(R.END_CUSTOMER, NULL) AS END_CUSTOMER
    		, NVL(R.ATTRIBUTE3, NULL) AS CELL_MODEL --[C20211112-000213]
    		, NVL(R.CELL_MODEL_INFO, NULL) AS CELL_MODEL_INFO --[C20211112-000213]
    	FROM DM_PLN_SALES_ETC_REPORT_C R
    	LEFT JOIN SCM_MST_SITE_ITEM SI
    		ON R.DIVISION_ID = SI.DIVISION_ID
    			AND R.PROJECT_CODE = SI.PROJECT_CODE
    			AND R.SCM_SITE_ID = SI.SCM_SITE_ID
    			AND R.ITEM_ID = SI.ITEM_ID
    		LEFT JOIN DM_MST_ITEM_SINGLE_V SINGLE
    		ON SI.DIVISION_ID = SINGLE.DIVISION_ID
    			AND SI.ITEM_ID = SINGLE.ITEM_ID
    
    	LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 (NOLOCK) ON R.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'  ||  CASE WHEN R.DIVISION_ID= '40' THEN '' ELSE '_'  ||  R.DIVISION_ID END
    	LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 (NOLOCK) ON R.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0049_DEPARTMENT_TEAM2'  ||  CASE WHEN R.DIVISION_ID= '40' THEN '' ELSE '_'  ||  R.DIVISION_ID END
    	LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 (NOLOCK) ON R.PROJECT_CODE = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_ETC_PROJECT' AND LK3.SEGMENT1 = R.DIVISION_ID
    	LEFT OUTER JOIN SCM_MST_SITE ST (NOLOCK) ON R.SCM_SITE_ID = ST.SCM_SITE_ID AND R.DIVISION_ID = ST.DIVISION_ID
    	LEFT OUTER JOIN SCM_MST_COUNTRY CO (NOLOCK) ON ST.COUNTRY = CO.COUNTRY
    	LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER CS (NOLOCK) ON R.DIVISION_ID = CS.DIVISION_ID AND R.SCM_SITE_ID = CS.SCM_SITE_ID AND CS.REP_YN = 'Y' AND CS.VALID_YN = 'Y'
    	LEFT OUTER JOIN GT_DMF0_PJT PJT (NOLOCK) ON R.DIVISION_ID= PJT.DIVISION_ID AND R.PROJECT_CODE = PJT.PROJECT_CODE
    
    	LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V ITEM_V  ON	R.DIVISION_ID = ITEM_V.DIVISION_ID AND	R.ITEM_ID = ITEM_V.ITEM_ID
    	WHERE R.DIVISION_ID = v_division_id
    		AND R.CUTOFF_TYPE = p_mdf_type
    		AND SUBSTR(R.YYYYMMDD, 1, 4) = p_yyyy
    		AND R.VERSION_NO = p_sp_version_no
    		--AND R.MEASURE <> 'RTF'
    		--AND p_mdf_type = 'REPORT_SP_W'
    	GROUP BY;
    		R.DIVISION_ID
    		,R.VERSION_NO
    		,R.CUTOFF_TYPE
    		,R.CUTOFF_YYYYMMDD
    		,R.DEPARTMENT_ID
    		,R.DEPT_ID
    		,R.END_CUST_REPORT
    		,R.CUST_REPORT
    		,R.PRODUCT_GROUP
    		,R.PROJECT_CODE
    		,R.SCM_SITE_ID
    		,R.ITEM_ID
    		,SINGLE.NICK_NAME
    		,R.MEASURE
    		,R.PLANT_SITE_ID
    		,R.COMPANY_ID
    		,SUBSTR(R.YYYYMMDD, 1, 6)
    		,R.CURRENCY
    		, R.APPLICATION
    		, R.SOLDTO_CUST_REPORT
    		,NVL(SI.attribute2, NULL)
    		, R.BIZ_TYPE
    		, R.APPLICATION_GR
    		, R.PRODUCT_DETAILS
    		--, SI.REPORT_GROUP6 --[C20210125-000207] Master 대신 ETC Report에서 입력한 40사업부 CELL_MODEL_INFO 적용
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
    		, NVL(R.SOLDTO_COUNTRY, NULL)
    		, NVL(R.SHIPTO_COUNTRY, NULL)
    		, NVL(R.END_CUSTOMER, NULL)
    		, NVL(R.ITEM_USE, NULL)
    		, NVL(R.ATTRIBUTE3, NULL) --[C20211112-000213]
    		, NVL(R.CELL_MODEL_INFO, NULL)  --[C20211112-000213]
    		, CASE WHEN NVL(R.DEPT_NAME, NULL) IS NOT NULL THEN R.DEPT_NAME ELSE LK2.SEGMENT2 END
    		, CASE WHEN NVL(R.DEPARTMENT_NAME, NULL) IS NOT NULL THEN R.DEPARTMENT_NAME ELSE LK1.SEGMENT2 END
    --SELECT * FROM GT_DMF0_
    --select * from GT_DMF0_SELECT_MEASURE
    
    
    
    	-- 단계3. PIVOT 기간 쿼리 ########################################################
    	SELECT V_PROD  ||  '[M_'  ||  BASIS_YYYYMM  ||  ']
      INTO V_PROD
    	FROM (
    		SELECT
    		DISTINCT BASIS_YYYYMM
    		FROM SCM_SYS_CALENDAR_M
    		WHERE CALENDAR_YYYY = p_yyyy
    	) A;
    	ORDER BY BASIS_YYYYMM;
    	IF V_PROD IS NOT NULL THEN
    		SELECT V_PROD = SUBSTR(V_PROD, 1, LENGTH(V_PROD)-1)
    	END IF;
    
    DBMS_OUTPUT.PUT_LINE('B');
    	--SELECT  V_PROD
    
    
    	-- 단계4. 실행 쿼리 ########################################################
    	SELECT  '
      INTO V_SQL
    From(
    	SELECT
    		A.*
    	FROM GT_DMF0_ A
    	JOIN GT_DMF0_SELECT_MEASURE B ON A.Measure = B.Measure
    	) T;
    PIVOT (SUM(QTY) FOR YYYYMM IN (' + V_PROD + ')
    ) AS PVT
    ORDER BY;
    	DIVISION_ID
    	,VERSION_NO
    	,DISPLAY_SEQ1
    	,DISPLAY_SEQ2
    	,CUST_REPORT
    	,END_CUST_REPORT
    	,SOLDTO_CODE
    	,SOLDTO_CUST_REPORT
    	,PRODUCT_GROUP
    	,ITEM_ID
    	,NICK_NAME
    	, PRODUCT_DETAILS
    	, CELL_MODEL_INFO
    	, CELL_MODEL
    	,CURRENCY
    	,COMPANY_ID -- 정렬추가
    	,BIZ_TYPE -- 정렬추가
    	,APPLICATION_GR
    	,NVL(APP, '''')
    	,COUNTRY_CODE
    	,DATA_SEQ
    	, CASE WHEN MEASURE IN (''LOC'') THEN 1
    			WHEN MEASURE IN ( ''RTF'',''Business_Plan'') THEN 2
    			WHEN MEASURE IN (''SalesAmt_LOC'') THEN 3
    			WHEN MEASURE IN (''SalesAmt_KRW'') THEN 4-- [C20210125-000207]RTF_SYS_RP Sort 마지막
    			ELSE 5
    			END;
    	, END_CUSTOMER
    ';
    execute  SP_executesql V_SQL
    
    -- xml확인할경우
    --SELECT CAST(V_SQL AS TEXT)
    --FOR XML PATH('')--,ROOT('x')
    
    END P_DMF0049_GET_SALES_ETC_REPORTS_DATA;

    END PKG_DMF0049;
/
