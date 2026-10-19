PACKAGE BODY PKG_DMF0043 IS

PROCEDURE P_DMF0043_GET_CONTRIBUTE_RATE_POPUP 
(
	p_yyyy		    VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 **************************************************************************************************
 * Program ID  :  DMF0043_GET_CONTRIBUTE_RATE_POPUP
 * Description : DMF0043 > 기여율 관리 팝업
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description
 *--------------------------------------------------------------------------------------------------
 * 2019/05/09  JYE       Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 **************************************************************************************************
*/
AS
    v_in_para_data VARCHAR2(4000);
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
BEGIN

    v_in_para_data := JSON_OBJECT(
	    'p_yyyy' VALUE p_yyyy
	  );
	OPEN O_RC1 FOR
	SELECT
		VER_SEQ
		,YYYY
		,VERSION_NM
		,DESCRIPTION
		,VALID_YN
	FROM DM_MST_CONTRIBUTE_VER
	WHERE YYYY = CASE WHEN p_yyyy IS NULL OR p_yyyy = 'ALL' THEN YYYY ELSE p_yyyy END
    ORDER BY YYYY DESC;
    OPEN O_RESULT_CURSOR FOR
    SELECT '1' AS RESULT_CODE, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG, 'SUCCESS' AS ERR_EVENT FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
	    p_in_para_data  => v_in_para_data,
	    p_sql_err_code  => SQLCODE,
	    p_sql_err_msg   => SQLERRM,
	    p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
	);
	RAISE_APPLICATION_ERROR(-20001,
	    '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
	    ' / SQLERRM=' || SQLERRM ||
	    ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	    ' / PARAMS=' || v_in_para_data
	);
END P_DMF0043_GET_CONTRIBUTE_RATE_POPUP;

PROCEDURE P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP 
/*
 **************************************************************************************************
 * Program ID  :  DMF0043_GET_CONTRIBUTE_YEAR_POPUP
 * Description : DMF0043 > 검색 연도
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description
 *--------------------------------------------------------------------------------------------------
 * 2019/05/09  JYE       Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 **************************************************************************************************
*/
(
    p_user_id VARCHAR2
  , p_menu_id VARCHAR2
  , O_RC1  OUT	SYS_REFCURSOR
)
AS
    V_LOG_TYPE	  VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE	  VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
    v_in_para_data VARCHAR2(4000) := NULL;
BEGIN

	/* TODO:EDIT_YN:수동확인필요 */
	OPEN O_RC1 FOR
	SELECT CODE, NAME
	     , 'Y' AS EDIT_YN
	FROM
	(
		SELECT
			'ALL' AS CODE
			,'ALL' AS NAME
			,0 SORTORDER
		FROM DUAL
		UNION ALL

		SELECT
			YYYY AS CODE
			,YYYY NAME
		-- 2026.09.28 AJS 주석처리 (GAP-08 버전 팝업 연도 목록 오름차순 복원) (START)
		--,ROW_NUMBER() OVER (ORDER BY YYYY DESC) SORTORDER
			,ROW_NUMBER() OVER (ORDER BY YYYY) SORTORDER
		-- 2026.09.28 AJS 주석처리 (GAP-08 버전 팝업 연도 목록 오름차순 복원) (END)
		FROM DM_MST_CONTRIBUTE_VER
		GROUP BY YYYY
	) MA
	ORDER BY SORTORDER;

EXCEPTION
    WHEN OTHERS THEN
	V_LOG_TYPE   := 'ERROR';
	V_SQL_CODE   := TO_CHAR(SQLCODE);
	V_SQL_ERRMSG := SQLERRM;
	V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
			    V_LOG_TYPE,
			    N_LOG_COUNT,
			    V_LOG_MESSAGE,
			    V_DESCRIPTION,
			    D_EVENT_DATE,
			    V_PROC_INPUT,
			    V_SQL_CODE,
			    V_SQL_ERRMSG,
			    V_BACKTRACE
			    );
    RAISE_APPLICATION_ERROR(-20001,
	'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
	' / SQLERRM=' || SQLERRM ||
	' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	' / PARAMS=' || v_in_para_data
    );
END P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP;

PROCEDURE P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP 
(
    p_start_yyyymmdd  VARCHAR2,
    p_end_yyyymmdd    VARCHAR2,
	--p_created_by	   VARCHAR2,
	p_division_id	   VARCHAR2,
	p_version_type	   VARCHAR2,
	--p_version_no	   VARCHAR2,
	p_description	   VARCHAR2
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
)
/***************************************************************************************************
 Program ID  : DMF0043_GET_CONT_VIEW_VERSIONPOPUP
 Description : Procedure 작성 가이드
 Usage       : Procedure 작성 시 참조하세요!
 Parameter   :

-- -----------------------------------------------------------------------------------------------
 Date	     In Charge	  Description
-- -----------------------------------------------------------------------------------------------
 2019/08/19  JYE       Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 2020/01/28  P.C.I     [CSR ID:prepare] Report Plan List 조회로 변경
 2020/06/12  HWI1993	[C20200605-000077] GSCM 해외법인 기여율 매출 버전 리스트 정리 요청의 건
 2021/07/03	HWI1993		하반기과제 속도개선 - 데이터 이동보관 처리
**************************************************************************************************/
AS
    v_in_para_data VARCHAR2(4000);
    V_LOG_TYPE	  VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE	  VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
BEGIN

    v_in_para_data := JSON_OBJECT(
	    'p_start_yyyymmdd' VALUE p_start_yyyymmdd,
	    'p_end_yyyymmdd' VALUE p_end_yyyymmdd,
	    /*'p_created_by' VALUE p_created_by,*/
	    'p_division_id' VALUE p_division_id,
	    'p_version_type' VALUE p_version_type,
	    /*'p_version_no' VALUE p_version_no,*/
	    'p_description' VALUE p_description
	  );

	/*
	   OPEN O_RC1 FOR
	   SELECT VERSION_NO AS CODE, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE)
		 FROM DM_MST_VERSION
	   WHERE (YYYYMMDD >= p_start_yyyymmdd and YYYYMMDD <= p_end_yyyymmdd)
		  AND DIVISION_ID IN (SELECT token FROM TABLE(fn_string_split(p_division_id	,',')))
		  AND VERSION_TYPE IN (SELECT token FROM TABLE(fn_string_split(p_version_type	,',')))
		  AND Exists (Select * from TABLE(fn_string_split(p_version_no,',')) P Where VERSION_NO LIKE P.token ||'%')
	   GROUP BY VERSION_NO , VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD
	   ORDER BY CODE DESC, VERSION_NO DESC*/
		OPEN O_RC1 FOR
		SELECT VERSION_NO AS CODE, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE)
		     , tei.EDIT_YN
		FROM DM_MDF_VERSION A
		INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
		   ON tei.UNIT_ID = A.DIVISION_ID
		WHERE
			A.DIVISION_ID = p_division_id
			AND A.YYYYMMDD BETWEEN p_start_yyyymmdd AND p_end_yyyymmdd
			AND A.VERSION_TYPE = p_version_type
			
			--AND UPPER(A.VERSION_DESCRIPTION) LIKE '%'  ||  UPPER(p_description)  ||  '%'           -- 2026.09.28 AJS  
			AND NVL(UPPER(A.VERSION_DESCRIPTION), ' ') LIKE '%'  ||  UPPER(p_description)  ||  '%'   -- 2026.09.28 AJS  (F-02 설명 없는 버전 표시 — 빈 설명 NVL 보정)  
		 
			AND A.SEND_YN <> 'D'
			--AND NVL(A.ATTRIBUTE1, NULL) <> 'MOVE'             -- 2026.09.28 AJS 
			AND NVL(A.ATTRIBUTE1, '-') <> 'MOVE'                -- 2026.09.28 AJS 주석처리 (F-02 ATTRIBUTE1 빈 값 비교 보정) 
	   GROUP BY VERSION_NO , VERSION_NO, A.VERSION_DESCRIPTION, A.VERSION_TYPE, A.VER_CRE_SEQ, A.YYYYMMDD, tei.EDIT_YN
	   ORDER BY CODE DESC, VERSION_NO DESC;

EXCEPTION
    WHEN OTHERS THEN
	V_LOG_TYPE   := 'ERROR';
	V_SQL_CODE   := TO_CHAR(SQLCODE);
	V_SQL_ERRMSG := SQLERRM;
	V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
			    V_LOG_TYPE,
			    N_LOG_COUNT,
			    V_LOG_MESSAGE,
			    V_DESCRIPTION,
			    D_EVENT_DATE,
			    V_PROC_INPUT,
			    V_SQL_CODE,
			    V_SQL_ERRMSG,
			    V_BACKTRACE
			    );
    RAISE_APPLICATION_ERROR(-20001,
	'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
	' / SQLERRM=' || SQLERRM ||
	' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	' / PARAMS=' || v_in_para_data
    );
END P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP;

    PROCEDURE P_DMF0043_GET_MAIN_SPREAD_TITLE_CORE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_YYYY          VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RC2           OUT SYS_REFCURSOR
       ,O_RC3           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /****************************************************************************************************/
        /* Program ID  : DMF0043_GET_SPREAD_TITLE                                                             */
        /* Description : Procedure 작성 가이드                                                              */
        /* Usage       : Procedure 작성 시 참조하세요!                                                      */
        /* Parameter   :                                                                                    */
        /*                                                                                                  */
        /*--------------------------------------------------------------------------------------------------*/
        /* Date        In Charge    Description                                                             */
        /*--------------------------------------------------------------------------------------------------*/
        /* 2019/06/20     JYE   기여율 해더                    */
        /****************************************************************************************************/
     AS

        V_PROGRAM_ID   VARCHAR2(4000 CHAR) := 'DMF0043';
        V_SHEET_NAME   VARCHAR2(4000 CHAR) := 'ContributeMain';
        V_CODELIST     VARCHAR2(1000 CHAR) := NULL;
        V_NAMELIST     VARCHAR2(1000 CHAR) := NULL;
        V_NSQL         VARCHAR2(4000 CHAR) := NULL;
        V_I            INTEGER := 0;
        V_USER_COL_CNT INTEGER := 0;
        V_IN_PARA_DATA VARCHAR2(4000);
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN

        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;

        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID, 'p_yyyy' VALUE P_YYYY, 'p_created_by' VALUE P_CREATED_BY);

        INSERT /*+ NO_PARALLEL */
        INTO GT_GMST_TEMP_2
            SELECT L.SEGMENT1 AS CODE, L.SEGMENT2 NAME, DISPLAY_SEQ DISPLAY_SEQ
            FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
            WHERE  1 = 1
            AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
            AND    L.VALID_YN = 'Y'
            AND    L.SEGMENT4 = 'N'
            ORDER  BY DISPLAY_SEQ;

        --INSERT /*+ NO_PARALLEL */ INTO GT_GMST_TEMP_2 VALUES ('RBU_0099', '구분', 99)
        INSERT /*+ NO_PARALLEL */
        INTO GT_GMST_TEMP2_2
            SELECT -- 연도만
             P_YYYY || '  ' AS YYYYMM, 'Y' AS FLAG, CODE, NAME, DISPLAY_SEQ
            FROM   GT_GMST_TEMP_2;
        --ORDER BY DISPLAY_SEQ;

        WHILE (V_I < 12) LOOP
            V_I := V_I + 1;
            IF (LENGTH(TO_CHAR(V_I)) >= 2) THEN
                INSERT /*+ NO_PARALLEL */
                INTO GT_GMST_TEMP2_2
                --SELECT p_yyyy || '-' || CAST(v_i AS VARCHAR) YYYYMM, 'M' AS FLAG, CODE, NAME, DISPLAY_SEQ
                    SELECT P_YYYY || TO_CHAR(V_I) YYYYMM, 'M' AS FLAG, CODE, NAME, DISPLAY_SEQ FROM GT_GMST_TEMP_2;
            ELSE
                INSERT /*+ NO_PARALLEL */
                INTO GT_GMST_TEMP2_2
                    SELECT P_YYYY || '0' || TO_CHAR(V_I) YYYYMM, 'M' AS FLAG, CODE, NAME, DISPLAY_SEQ FROM GT_GMST_TEMP_2;
            END IF;
        END LOOP;

        -- ############### OS_CORP 반복 end ###############
        SELECT COUNT(*)
        INTO   V_USER_COL_CNT
        FROM   SCM_MST_TITLESET_USER U
        WHERE  1 = 1
        AND    U.PROGRAM_ID = V_PROGRAM_ID
        AND    U.SHEET_NAME = V_SHEET_NAME
        AND    U.USER_ID = P_CREATED_BY;

        --select v_user_col_cnt
        IF V_USER_COL_CNT = 0 THEN
            OPEN O_RC3 FOR
                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,C.COLUMN_LABEL_NAME
                      ,C.SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,TEI.EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = C.DIVISION_ID
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.DEFAULT_FLAG = 'Y'
                AND    C.VALID_YN = 'Y'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ',')))

                UNION ALL

                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,C.COLUMN_LABEL_NAME
                      ,C.SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,'N' AS EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = 'N'
                AND    C.DEFAULT_FLAG IS NULL
                AND    C.VALID_YN = 'Y'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ',')))

                UNION ALL

                SELECT V_PROGRAM_ID AS PROGRAM_ID
                      ,V_SHEET_NAME SHEET_NAME
                      ,T.FLAG || '#' || T.YYYYMM || '#' || CODE AS COLUMN_NAME
                      ,T.NAME COLUMN_LABEL_NAME
                      ,TO_NUMBER(DISPLAY_SEQ) SORT_ORDER_NO
                      ,'' AS DATA_SORT_METHOD_CODE
                       --, T.YYYYMM SMALL_CLASS_LABEL_NAME
                      ,T.NAME SMALL_CLASS_LABEL_NAME
                      ,CASE
                           WHEN LENGTH(T.YYYYMM) = 4 THEN
                            T.YYYYMM
                           ELSE
                            SUBSTR(T.YYYYMM, 1, 4) || '-' || SUBSTR(T.YYYYMM, 5, 2)
                       END AS LARGE_CLASS_LABEL_NAME
                       --, p_yyyy LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,'' AS FIXED_FLAG
                      ,80 COLUMN_WIDTH
                      ,'' AS CELL_CONTROL_OBJECT_TYPE_CODE
                      ,'' AS CELL_COMBO_DATA_TYPE
                      ,2 AS DATA_SCALE_NUMBER
                      ,NULL AS DATA_MAX_LENGTH
                      ,'R' AS HORIZONTAL_ALIGN_CODE
                      ,'Y' AS UPPERCASE_APPLY_FLAG
                      ,'Y' AS VISIBLE_FLAG
                      ,'' AS DEFAULT_FLAG
                      ,'' AS USER_SELECTABLE_FLAG
                      ,'' AS VALID_YN
                      ,'' AS DIVISION_ID
                      ,'N' AS EDIT_YN
                FROM   (SELECT REPLACE(YYYYMM, ' ', '') YYYYMM
                              ,FLAG
                              ,CODE
                              ,NAME
                              ,TO_CHAR(REPLACE(REPLACE(YYYYMM, ' ', ''), '-', '')) || TO_CHAR(DISPLAY_SEQ) DISPLAY_SEQ
                        FROM   GT_GMST_TEMP2_2) T
                ORDER  BY SORT_ORDER_NO;
        END IF;

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
    END P_DMF0043_GET_MAIN_SPREAD_TITLE_CORE;

PROCEDURE P_DMF0043_GET_MAIN_VARSION_DATA 
/****************************************************************************************************/
/* Program ID  : DMF0043_GET_MAIN_VARSION_DATA								   */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :										    */
/*												    */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description 							    */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/07/18     JYE		기여율 등록화면 Version 바인딩 데이터                    */
/****************************************************************************************************/
(
    p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
)
AS
    v_in_para_data VARCHAR2(4000);
    V_LOG_TYPE	  VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE	  VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
BEGIN

	/* TODO:EDIT_YN:수동확인필요 */
	OPEN O_RC1 FOR
	SELECT
		VER_SEQ AS CODE
		,VERSION_NM NAME
		,VER_SEQ
		,YYYY
		,VERSION_NM
		,DESCRIPTION
		,YYYY  ||  '('	||  VERSION_NM	||  ')' AS NAME2
		, 'Y' AS EDIT_YN
	FROM DM_MST_CONTRIBUTE_VER
	WHERE VALID_YN = 'Y'
    ORDER BY YYYY DESC;

EXCEPTION
    WHEN OTHERS THEN
	V_LOG_TYPE   := 'ERROR';
	V_SQL_CODE   := TO_CHAR(SQLCODE);
	V_SQL_ERRMSG := SQLERRM;
	V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
			    V_LOG_TYPE,
			    N_LOG_COUNT,
			    V_LOG_MESSAGE,
			    V_DESCRIPTION,
			    D_EVENT_DATE,
			    V_PROC_INPUT,
			    V_SQL_CODE,
			    V_SQL_ERRMSG,
			    V_BACKTRACE
			    );
	RAISE_APPLICATION_ERROR(-20001,
	    '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
	    ' / SQLERRM=' || SQLERRM ||
	    ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	    ' / PARAMS=' || v_in_para_data
	);
END P_DMF0043_GET_MAIN_VARSION_DATA;

PROCEDURE P_DMF0043_GET_SALES_LIST_SPREAD_TITLE (
    p_division_id VARCHAR2,
    p_created_by  VARCHAR2,
    p_menu_id	  VARCHAR2,
    O_RC1	  OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN O_RC1 FOR
	SELECT
	    'DMF0043'		  AS PROGRAM_ID,
	    'ContributeSalesList' AS SHEET_NAME,
	    X.COLUMN_NAME,
	    X.COLUMN_LABEL_NAME,
	    X.SORT_ORDER_NO,
	    CAST(NULL AS VARCHAR2(10)) AS DATA_SORT_METHOD_CODE,
	    X.SMALL_CLASS_LABEL_NAME,
	    X.LARGE_CLASS_LABEL_NAME,
	    ''			   AS DAY_CODE,
	    CAST(NULL AS VARCHAR2(1))  AS FIXED_FLAG,
	    X.COLUMN_WIDTH,
	    X.CELL_CONTROL_OBJECT_TYPE_CODE,
	    CAST(NULL AS VARCHAR2(10)) AS CELL_COMBO_DATA_TYPE,
	    TO_NUMBER(NULL) AS DATA_SCALE_NUMBER,
	    TO_NUMBER(NULL) AS DATA_MAX_LENGTH,
	    X.HORIZONTAL_ALIGN_CODE,
	    'Y' AS UPPERCASE_APPLY_FLAG,
	    'Y' AS VISIBLE_FLAG,
	    'Y' AS DEFAULT_FLAG,
	    'Y' AS USER_SELECTABLE_FLAG,
	    'Y' AS VALID_YN,
	    p_division_id AS DIVISION_ID,
	    'Y' AS EDIT_YN
	FROM (
	    SELECT DISTINCT
		C.COLUMN_NAME,
		C.COLUMN_LABEL_NAME,
		C.SORT_ORDER_NO,
		C.COLUMN_LABEL_NAME AS SMALL_CLASS_LABEL_NAME,
		C.COLUMN_LABEL_NAME AS LARGE_CLASS_LABEL_NAME,
		C.COLUMN_WIDTH,
		C.CELL_CONTROL_OBJECT_TYPE_CODE,
		C.HORIZONTAL_ALIGN_CODE
	    FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
	    WHERE C.PROGRAM_ID = 'DMF0043'
	      AND C.SHEET_NAME = 'ContributeSalesList'
	      AND C.DEFAULT_FLAG = 'Y'
	      AND C.VALID_YN = 'Y'
	    UNION ALL
	    SELECT DISTINCT
		L.SEGMENT1 || '#' || CASE WHEN L.SEGMENT1 = 'Total' THEN '' ELSE M.SEGMENT1 END AS COLUMN_NAME,
		CASE WHEN L.SEGMENT1 = 'Total' THEN 'Total' ELSE M.SEGMENT2 END			 AS COLUMN_LABEL_NAME,
		1000 + L.DISPLAY_SEQ + CASE WHEN L.SEGMENT1 = 'Total' THEN 0 ELSE M.DISPLAY_SEQ END AS SORT_ORDER_NO,
		CASE WHEN L.SEGMENT1 = 'Total' THEN 'Total' ELSE M.SEGMENT2 END			 AS SMALL_CLASS_LABEL_NAME,
		L.SEGMENT2			 AS LARGE_CLASS_LABEL_NAME,
		80				 AS COLUMN_WIDTH,
		'FPNumber'			 AS CELL_CONTROL_OBJECT_TYPE_CODE,
		'R'				 AS HORIZONTAL_ALIGN_CODE
	    FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
	    CROSS JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M
	    WHERE L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
	      AND L.VALID_YN = 'Y'
	      AND L.SEGMENT3 = 'Y'
	      AND M.LOOKUP_TYPE = 'DM_CONTRIBUTION_TYPE_CD'
	      AND M.VALID_YN = 'Y'
	) X
	ORDER BY X.SORT_ORDER_NO, X.COLUMN_NAME;
END P_DMF0043_GET_SALES_LIST_SPREAD_TITLE;

PROCEDURE P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO 
(

	-- Add the parameters for the stored procedure here
     p_active_flag				VARCHAR2
    ,p_ver_seq					VARCHAR2
    ,p_department_id			VARCHAR2
    ,p_dept_id					VARCHAR2
    ,p_end_cust_report			VARCHAR2
    ,p_soldto_cust_report		VARCHAR2
    ,p_product_group			VARCHAR2
    ,p_dm_biz_type				VARCHAR2
    ,p_yyyymm					VARCHAR2
    ,p_os_corp_cd				VARCHAR2
    ,p_contribution_type		VARCHAR2
    ,p_contribution_ratio		VARCHAR2
    ,p_created_by				VARCHAR2

    , O_RC1  OUT  SYS_REFCURSOR
)
/*
 * Program ID	: DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO
 * Description	: 'DM_MST_CONTRIBUTE_RATIO' TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date	In Charge      Description
 *===================================================================================================
 * 20190730  KHSONG  Initial Release PJ20189106 전지.GSCM 고도화 이행, DM 시스템
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */
AS

/*
 * ========================================
 * [변환검증] 2026-03-13 12:16:41
 * 파일: DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO.sql
 * ----------------------------------------
 * ⚠ IF: IF:4  END IF:3  차이:+1
 * ⚠ LOOP: LOOP:1  END LOOP:0  차이:+1
 * ⚠ BEGIN: BEGIN:4  END:5  차이:-1
 * ----------------------------------------
 * IF 위치:     L147, L193, L278, L470
 * END IF 위치: L343, L344, L483
 * BEGIN 위치:  L77, L225, L310, L371
 * END;  위치:  L256, L341, L402, L437, L485
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * LOOP 위치:     L131
 * END LOOP 위치:
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    v_active_flag VARCHAR2(4000 CHAR);
    v_ver_seq VARCHAR2(4000 CHAR);
    v_department_id VARCHAR2(4000 CHAR);
    v_dept_id VARCHAR2(4000 CHAR);
    v_end_cust_report VARCHAR2(4000 CHAR);
    v_soldto_cust_report VARCHAR2(4000 CHAR);
    v_product_group VARCHAR2(4000 CHAR);
    v_dm_biz_type VARCHAR2(4000 CHAR);
    v_yyyymm VARCHAR2(4000 CHAR);
    v_os_corp_cd VARCHAR2(4000 CHAR);
    v_contribution_type VARCHAR2(4000 CHAR);
    v_contribution_ratio VARCHAR2(4000 CHAR);
    v_created_by VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_max_ver_seq VARCHAR2(4000 CHAR);
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_log_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_delete_count INTEGER := 0;
    n_insert_count INTEGER := 0;
    n_input_count INTEGER := 0;
    n_logo_count INTEGER := 0;
    v_index_active_flag INTEGER;
    v_index_ver_seq INTEGER;
    v_index_department_id INTEGER;
    v_index_dept_id INTEGER;
    v_index_end_cust_report INTEGER;
    v_index_soldto_cust_report INTEGER;
    v_index_product_group INTEGER;
    v_index_dm_biz_type INTEGER;
    v_index_yyyymm INTEGER;
    v_index_os_corp_cd INTEGER;
    v_index_contribution_type INTEGER;
    v_index_contribution_ratio INTEGER;
    v_index_created_by INTEGER;
    v_in_para_data CLOB;
    vp_active_flag CLOB;  -- [CLOB FIX 07-06]
    vp_ver_seq CLOB;  -- [CLOB FIX 07-06]
    vp_department_id CLOB;  -- [CLOB FIX 07-06]
    vp_dept_id CLOB;  -- [CLOB FIX 07-06]
    vp_end_cust_report CLOB;  -- [CLOB FIX 07-06]
    vp_soldto_cust_report CLOB;  -- [CLOB FIX 07-06]
    vp_product_group CLOB;  -- [CLOB FIX 07-06]
    vp_dm_biz_type CLOB;  -- [CLOB FIX 07-06]
    vp_yyyymm CLOB;  -- [CLOB FIX 07-06]
    vp_os_corp_cd CLOB;  -- [CLOB FIX 07-06]
    vp_contribution_type CLOB;  -- [CLOB FIX 07-06]
    vp_contribution_ratio CLOB;  -- [CLOB FIX 07-06]
    vp_created_by CLOB;  -- [CLOB FIX 07-06]
BEGIN

    SELECT JSON_OBJECT(
	    'p_active_flag' VALUE p_active_flag,
	    'p_ver_seq' VALUE p_ver_seq,
	    'p_department_id' VALUE p_department_id,
	    'p_dept_id' VALUE p_dept_id,
	    'p_end_cust_report' VALUE p_end_cust_report,
	    'p_soldto_cust_report' VALUE p_soldto_cust_report,
	    'p_product_group' VALUE p_product_group,
	    'p_dm_biz_type' VALUE p_dm_biz_type,
	    'p_yyyymm' VALUE p_yyyymm,
	    'p_os_corp_cd' VALUE p_os_corp_cd,
	    'p_contribution_type' VALUE p_contribution_type,
	    'p_contribution_ratio' VALUE p_contribution_ratio,
	    'p_created_by' VALUE p_created_by RETURNING CLOB
	  ) INTO v_in_para_data FROM DUAL;
	v_in_para_data := DBMS_LOB.SUBSTR(v_in_para_data, 4000, 1);  -- [CLOB FIX 07-06] 진단 로깅 VARCHAR2 한도 대비 truncate (PR_SCM_SYS_LOG_BATCH.p_in_para_data=VARCHAR2)

	-- 스플릿관련 변수
	v_delimiter := '^'; -- 데이터 구분자

	vp_active_flag := RTRIM(p_active_flag				    )  ||  '^';
	vp_ver_seq := RTRIM(p_ver_seq					    )  ||  '^';
	vp_department_id := RTRIM(p_department_id			    )  ||  '^';
	vp_dept_id := RTRIM(p_dept_id					    )  ||  '^';
	vp_end_cust_report := RTRIM(p_end_cust_report			    )  ||  '^';
	vp_soldto_cust_report := RTRIM(p_soldto_cust_report			)  ||  '^';
	vp_product_group := RTRIM(p_product_group			    )  ||  '^';
	vp_dm_biz_type := RTRIM(p_dm_biz_type				    )  ||  '^';
	vp_yyyymm := RTRIM(p_yyyymm					    )  ||  '^';
	vp_os_corp_cd := RTRIM(p_os_corp_cd				    )  ||  '^';
	vp_contribution_type := RTRIM(p_contribution_type		    )  ||  '^';
	vp_contribution_ratio := RTRIM(p_contribution_ratio		    )  ||  '^';
	vp_created_by := RTRIM(p_created_by				    )  ||  '^';

	-- GT_SDMCR_RESULTS_MST_2 TEMP TABLE
	DELETE FROM GT_SDMCR_RESULTS_MST_2;

	-- 시작 LOG  (START)
	v_log_type := 'START';
	v_log_message := '########## Start of procedure @@@##########';
	v_log_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date,
	p_in_para_data => v_in_para_data
      );
	v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)
	-- 트랜잭션 (START)
	-- -----------------------------------------------------------------------------------------
	-- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
	-- -----------------------------------------------------------------------------------------
	--===================================================================================== GT_SDMCR_RESULTS_MST_2 테이블에 split후 INSERT INTO start
	--###############################################  GT_SDMCR_RESULTS_MST_2 테이블에 split후 insert (START)
	WHILE LENGTH(vp_ver_seq) > 0 LOOP

		v_index_active_flag := INSTR(vp_active_flag, '^');
		v_index_ver_seq := INSTR(vp_ver_seq, '^');
		v_index_department_id := INSTR(vp_department_id, '^');
		v_index_dept_id := INSTR(vp_dept_id, '^');
		v_index_end_cust_report := INSTR(vp_end_cust_report, '^');
		v_index_soldto_cust_report := INSTR(vp_soldto_cust_report, '^');
		v_index_product_group := INSTR(vp_product_group, '^');
		v_index_dm_biz_type := INSTR(vp_dm_biz_type, '^');
		v_index_yyyymm := INSTR(vp_yyyymm, '^');
		v_index_os_corp_cd := INSTR(vp_os_corp_cd, '^');
		v_index_contribution_type := INSTR(vp_contribution_type, '^');
		v_index_contribution_ratio := INSTR(vp_contribution_ratio, '^');
		v_index_created_by := INSTR(vp_created_by, '^');

		IF vp_ver_seq is not null THEN

				v_active_flag := SUBSTR(vp_active_flag			, 1, v_index_active_flag - 1			);
				v_ver_seq := SUBSTR(vp_ver_seq				, 1, v_index_ver_seq - 1				);
				v_department_id := SUBSTR(vp_department_id		, 1, v_index_department_id - 1		);
				v_dept_id := SUBSTR(vp_dept_id				, 1, v_index_dept_id - 1				);
				v_end_cust_report := SUBSTR(vp_end_cust_report		, 1, v_index_end_cust_report - 1		);
				v_soldto_cust_report := SUBSTR(vp_soldto_cust_report	, 1, v_index_soldto_cust_report - 1	);
				v_product_group := SUBSTR(vp_product_group		, 1, v_index_product_group - 1		);
				v_dm_biz_type := SUBSTR(vp_dm_biz_type			, 1, v_index_dm_biz_type - 1			);
				v_yyyymm := SUBSTR(vp_yyyymm				, 1, v_index_yyyymm - 1				);
				v_os_corp_cd := SUBSTR(vp_os_corp_cd			, 1, v_index_os_corp_cd - 1			);
				v_contribution_type := SUBSTR(vp_contribution_type	, 1, v_index_contribution_type - 1	);
				v_contribution_ratio := SUBSTR(vp_contribution_ratio	, 1, v_index_contribution_ratio - 1	);
				v_created_by := SUBSTR(vp_created_by			, 1, v_index_created_by - 1			);

				vp_active_flag := SUBSTR(vp_active_flag			, LENGTH(v_active_flag			 ||  '^') + 1, LENGTH(vp_active_flag			));
				vp_ver_seq := SUBSTR(vp_ver_seq				, LENGTH(v_ver_seq				|| '^') + 1, LENGTH(vp_ver_seq				));
				vp_department_id := SUBSTR(vp_department_id		, LENGTH(v_department_id			 ||  '^') + 1, LENGTH(vp_department_id		));
				vp_dept_id := SUBSTR(vp_dept_id				, LENGTH(v_dept_id				 ||  '^') + 1, LENGTH(vp_dept_id				));
				vp_end_cust_report := SUBSTR(vp_end_cust_report		, LENGTH(v_end_cust_report		 ||  '^') + 1, LENGTH(vp_end_cust_report		));
				vp_soldto_cust_report := SUBSTR(vp_soldto_cust_report	, LENGTH(v_soldto_cust_report		 ||  '^') + 1, LENGTH(vp_soldto_cust_report	));
				vp_product_group := SUBSTR(vp_product_group		, LENGTH(v_product_group			 ||  '^') + 1, LENGTH(vp_product_group		));
				vp_dm_biz_type := SUBSTR(vp_dm_biz_type			, LENGTH(v_dm_biz_type			 ||  '^') + 1, LENGTH(vp_dm_biz_type			));
				vp_yyyymm := SUBSTR(vp_yyyymm				, LENGTH(v_yyyymm					 ||  '^') + 1, LENGTH(vp_yyyymm				));
				vp_os_corp_cd := SUBSTR(vp_os_corp_cd			, LENGTH(v_os_corp_cd				 ||  '^') + 1, LENGTH(vp_os_corp_cd			));
				vp_contribution_type := SUBSTR(vp_contribution_type	, LENGTH(v_contribution_type		 ||  '^') + 1, LENGTH(vp_contribution_type	));
				vp_contribution_ratio := SUBSTR(vp_contribution_ratio	, LENGTH(v_contribution_ratio		|| '^') + 1, LENGTH(vp_contribution_ratio	));
				vp_created_by := SUBSTR(vp_created_by			, LENGTH(v_created_by				 ||  '^') + 1, LENGTH(vp_created_by			));

				--공백제거
				v_active_flag := rtrim(ltrim(v_active_flag					));
				v_ver_seq := rtrim(ltrim(v_ver_seq						));
				v_department_id := rtrim(ltrim(v_department_id					));
				v_dept_id := rtrim(ltrim(v_dept_id						));
				v_end_cust_report := rtrim(ltrim(v_end_cust_report				));
				v_soldto_cust_report := rtrim(ltrim(v_soldto_cust_report				));
				v_product_group := rtrim(ltrim(v_product_group					));
				v_dm_biz_type := rtrim(ltrim(v_dm_biz_type					));
				v_yyyymm := rtrim(ltrim(v_yyyymm							));
				v_os_corp_cd := rtrim(ltrim(v_os_corp_cd						));
				v_contribution_type := rtrim(ltrim(v_contribution_type				));
				v_contribution_ratio := rtrim(ltrim(v_contribution_ratio				));
				v_created_by := rtrim(ltrim(v_created_by						));
				--공백제거
				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (BEGIN)
				IF LENGTH(v_yyyymm) > 4 THEN
							INSERT INTO GT_SDMCR_RESULTS_MST_2 (
													 active_flag
													,ver_seq
													,department_id
													,dept_id
													,end_cust_report
													,soldto_cust_report
													,product_group
													,dm_biz_type
													,yyyymm
													,os_corp_cd
													,contribution_type
													,contribution_ratio
													,created_by
							) VALUES (
													 v_active_flag
													,v_ver_seq
													,v_department_id
													,v_dept_id
													,v_end_cust_report
													,v_soldto_cust_report
													,v_product_group
													,v_dm_biz_type
													,v_yyyymm
													,v_os_corp_cd
													,v_contribution_type
													,v_contribution_ratio
													,v_created_by
							);
				ELSE
					-- 년모드인 경우 (12개월을 INSERT함)
					BEGIN
							INSERT INTO GT_SDMCR_RESULTS_MST_2 (
													 active_flag
													,ver_seq
													,department_id
													,dept_id
													,end_cust_report
													,soldto_cust_report
													,product_group
													,dm_biz_type
													,yyyymm
													,os_corp_cd
													,contribution_type
													,contribution_ratio
													,created_by
							)
							select
									 v_active_flag
									,v_ver_seq
									,v_department_id
									,v_dept_id
									,v_end_cust_report
									,v_soldto_cust_report
									,v_product_group
									,v_dm_biz_type
									,basis_yyyymm
									,v_os_corp_cd
									,v_contribution_type
									,v_contribution_ratio
									,v_created_by
							from SCM_SYS_CALENDAR_M  where SUBSTR(basis_yyyymm,1,4) = v_yyyymm GROUP BY basis_yyyymm;
					END;
				END IF;
				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (END)
		ELSE
				v_ver_seq := vp_ver_seq;
				vp_ver_seq := NULL;

				--공백제거
				v_active_flag := rtrim(ltrim(v_active_flag					));
				v_ver_seq := rtrim(ltrim(v_ver_seq						));
				v_department_id := rtrim(ltrim(v_department_id					));
				v_dept_id := rtrim(ltrim(v_dept_id						));
				v_end_cust_report := rtrim(ltrim(v_end_cust_report				));
				v_soldto_cust_report := rtrim(ltrim(v_soldto_cust_report				));
				v_product_group := rtrim(ltrim(v_product_group					));
				v_dm_biz_type := rtrim(ltrim(v_dm_biz_type					));
				v_yyyymm := rtrim(ltrim(v_yyyymm							));
				v_os_corp_cd := rtrim(ltrim(v_os_corp_cd						));
				v_contribution_type := rtrim(ltrim(v_contribution_type				));
				v_contribution_ratio := rtrim(ltrim(v_contribution_ratio				));
				v_created_by := rtrim(ltrim(v_created_by						));
				--공백제거
				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (BEGIN)
				IF LENGTH(v_yyyymm) > 4 THEN
							INSERT INTO GT_SDMCR_RESULTS_MST_2 (
													 active_flag
													,ver_seq
													,department_id
													,dept_id
													,end_cust_report
													,soldto_cust_report
													,product_group
													,dm_biz_type
													,yyyymm
													,os_corp_cd
													,contribution_type
													,contribution_ratio
													,created_by
							) VALUES (
													 v_active_flag
													,v_ver_seq
													,v_department_id
													,v_dept_id
													,v_end_cust_report
													,v_soldto_cust_report
													,v_product_group
													,v_dm_biz_type
													,v_yyyymm
													,v_os_corp_cd
													,v_contribution_type
													,v_contribution_ratio
													,v_created_by
							);
				ELSE
					-- 년모드인 경우 (12개월을 INSERT함)
					BEGIN
							INSERT INTO GT_SDMCR_RESULTS_MST_2 (
													 active_flag
													,ver_seq
													,department_id
													,dept_id
													,end_cust_report
													,soldto_cust_report
													,product_group
													,dm_biz_type
													,yyyymm
													,os_corp_cd
													,contribution_type
													,contribution_ratio
													,created_by
							)
							select
									 v_active_flag
									,v_ver_seq
									,v_department_id
									,v_dept_id
									,v_end_cust_report
									,v_soldto_cust_report
									,v_product_group
									,v_dm_biz_type
									,basis_yyyymm
									,v_os_corp_cd
									,v_contribution_type
									,v_contribution_ratio
									,v_created_by
							from SCM_SYS_CALENDAR_M  where SUBSTR(basis_yyyymm,1,4) = v_yyyymm GROUP BY basis_yyyymm;
					END;
				END IF;
				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (END)
		END IF;
	END LOOP;

	--===================================================================================== GT_SDMCR_RESULTS_MST_2 테이블에 split후 INSERT INTO end
--select department_id
--		,dept_id
--		,end_cust_report
--		,soldto_cust_report
--		,product_group
--		,dm_biz_type
--		, Contribution_Type
--		, SUM(CAST (Contribution_Ratio AS NUMBER(5,2)))
--from GT_SDMCR_RESULTS_MST_2
--GROUP BY department_id
--		,dept_id
--		,end_cust_report
--		,soldto_cust_report
--		,product_group
--		,dm_biz_type
--		, Contribution_Type
--RAISE_APPLICATION_ERROR(-20001, 'sdf')
	-- INPUT COUNT 확인
	SELECT count(ver_seq) INTO n_input_count
								FROM GT_SDMCR_RESULTS_MST_2;

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_MST 테이블 DELETE,INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN
		-- INSERT INTO COUNT 확인
		SELECT count(M.ver_seq) INTO n_logo_count
									FROM GT_SDMCR_RESULTS_MST_2 M
										where 1=1;

		-- MST INSERT전 DELETE수행 (BEGIN)
		DELETE
		FROM DM_MST_CONTRIBUTE_RATIO_MST
		WHERE EXISTS (
				SELECT 1
					FROM GT_SDMCR_RESULTS_MST_2 M
					where 1=1
						and DM_MST_CONTRIBUTE_RATIO_MST.ver_seq				= M.ver_seq
						and DM_MST_CONTRIBUTE_RATIO_MST.department_id		= M.department_id
						and DM_MST_CONTRIBUTE_RATIO_MST.dept_id				= M.dept_id
						and DM_MST_CONTRIBUTE_RATIO_MST.end_cust_report		= M.end_cust_report
						and DM_MST_CONTRIBUTE_RATIO_MST.soldto_cust_report	= M.soldto_cust_report
						and DM_MST_CONTRIBUTE_RATIO_MST.product_group		= M.product_group
						and DM_MST_CONTRIBUTE_RATIO_MST.dm_biz_type			= M.dm_biz_type
				);
		-- MST INSERT전 DELETE수행 (END)
		-- MST INSERT수행 (BEGIN)
		INSERT INTO DM_MST_CONTRIBUTE_RATIO_MST
			(VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
		SELECT VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE,MAX(CREATED_BY),SYSDATE,MAX(CREATED_BY) LAST_UPDATED_BY,SYSDATE
			FROM GT_SDMCR_RESULTS_MST_2
				WHERE 1=1
		GROUP BY VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE;
		-- MST INSERT수행 (END)
	END;
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_MST 테이블 DELETE,INSERT (END)
	--------------------------------------------------------------------------------------------◇◇◇◇
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_DTL 테이블 DELETE,INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇

		-- DTL INSERT전 DELETE수행 (BEGIN)
		DELETE
		FROM DM_MST_CONTRIBUTE_RATIO_DTL
		WHERE EXISTS (
				SELECT 1
					FROM GT_SDMCR_RESULTS_MST_2 M
					where 1=1
						and DM_MST_CONTRIBUTE_RATIO_DTL.ver_seq				= M.ver_seq
						and DM_MST_CONTRIBUTE_RATIO_DTL.department_id		= M.department_id
						and DM_MST_CONTRIBUTE_RATIO_DTL.dept_id				= M.dept_id
						and DM_MST_CONTRIBUTE_RATIO_DTL.end_cust_report		= M.end_cust_report
						and DM_MST_CONTRIBUTE_RATIO_DTL.soldto_cust_report	= M.soldto_cust_report
						and DM_MST_CONTRIBUTE_RATIO_DTL.product_group		= M.product_group
						and DM_MST_CONTRIBUTE_RATIO_DTL.dm_biz_type			= M.dm_biz_type
				);
		-- DTL INSERT전 DELETE수행 (END)
		-- DTL INSERT수행 (BEGIN)
		INSERT INTO DM_MST_CONTRIBUTE_RATIO_DTL
			(VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE
			,YYYYMM,OS_CORP_CD,CONTRIBUTION_TYPE,CONTRIBUTION_RATIO
			,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
		SELECT VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE
			,YYYYMM,OS_CORP_CD,CONTRIBUTION_TYPE,CONTRIBUTION_RATIO
			,CREATED_BY,SYSDATE,CREATED_BY LAST_UPDATED_BY,SYSDATE
			FROM GT_SDMCR_RESULTS_MST_2
				WHERE 1=1;
		-- DTL INSERT수행 (END)

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_DTL 테이블 DELETE,INSERT (END)
	--------------------------------------------------------------------------------------------◇◇◇◇
  	-- 트랜잭션 (COMMIT)
		-- -----------------------------------------------------------------------------------------
		-- END TRY
	-- -----------------------------------------------------------------------------------------
    COMMIT;
	-- -----------------------------------------------------------
    EXCEPTION
	WHEN OTHERS THEN
	-- -----------------------------------------------------------
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		v_log_type := 'ERROR';
		v_log_message := SUBSTR(SQLERRM, 1, 1000);
		v_log_description := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
		d_event_date := SYSTIMESTAMP;

		v_log_message := '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/

		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date,
	p_in_para_data	=> v_in_para_data,
	p_sql_err_code	=> SQLCODE,
	p_sql_err_msg	=> SQLERRM,
	p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
      );

	-- -----------------------------------------------------------
    -- END CATCH
	-- -----------------------------------------------------------
	-- 수행결과 성공여부 DISPLAY
	ROLLBACK;

	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date,
	    p_in_para_data  => v_in_para_data,
	    p_sql_err_code  => SQLCODE,
	    p_sql_err_msg   => SQLERRM,
	    p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
	  );
    RAISE_APPLICATION_ERROR(-20001,
	'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
	' / SQLERRM=' || SQLERRM ||
	' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	' / PARAMS=' || v_in_para_data
    );
END P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO;

PROCEDURE P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER 
(

	-- Add the parameters for the stored procedure here
    p_active_flag	VARCHAR2,
    p_ver_seq		VARCHAR2,
    p_yyyy			VARCHAR2,
    p_version_nm	VARCHAR2,
    p_description	VARCHAR2,
    p_valid_yn		VARCHAR2,
    p_created_by	VARCHAR2

    , O_RC1  OUT  SYS_REFCURSOR
    , O_RC2  OUT  SYS_REFCURSOR
)
/*
 * Program ID	: DMF0043_SAVE_DM_MST_CONTRIBUTE_VER
 * Description	: 'DM_MST_CONTRIBUTE_VER' TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date	In Charge      Description
 *===================================================================================================
 * 20190508  KHSONG  Initial Release PJ20189106 전지.GSCM 고도화 이행, DM 시스템
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */
AS

/*
 * ========================================
 * [변환검증] 2026-03-13 12:16:42
 * 파일: DMF0043_SAVE_DM_MST_CONTRIBUTE_VER.sql
 * ----------------------------------------
 * ⚠ BEGIN: BEGIN:2  END:3  차이:-1
 * ----------------------------------------
 * IF 위치:     L110, L283, L395
 * END IF 위치: L190, L362, L408
 * BEGIN 위치:  L58, L201
 * END;  위치:  L221, L363, L410
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * LOOP 위치:     L100
 * END LOOP 위치: L191
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    v_active_flag VARCHAR2(4000 CHAR);
    v_ver_seq VARCHAR2(4000 CHAR);
    v_yyyy VARCHAR2(4000 CHAR);
    v_version_nm VARCHAR2(4000 CHAR);
    v_description VARCHAR2(4000 CHAR);
    v_valid_yn VARCHAR2(4000 CHAR);
    v_created_by VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_max_ver_seq VARCHAR2(4000 CHAR);
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_log_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_delete_count INTEGER := 0;
    n_insert_count INTEGER := 0;
    n_input_count INTEGER := 0;
    n_logo_count INTEGER := 0;
    v_index_active_flag INTEGER;
    v_index_ver_seq INTEGER;
    v_index_yyyy INTEGER;
    v_index_version_nm INTEGER;
    v_index_description INTEGER;
    v_index_valid_yn INTEGER;
    v_index_created_by INTEGER;
    v_in_para_data VARCHAR2(4000);
    v_w_active_flag VARCHAR2(4000 CHAR);
    v_w_ver_seq VARCHAR2(4000 CHAR);
    v_w_yyyy VARCHAR2(4000 CHAR);
    v_w_version_nm VARCHAR2(4000 CHAR);
    v_w_description VARCHAR2(4000 CHAR);
    v_w_valid_yn VARCHAR2(4000 CHAR);
    v_w_created_by VARCHAR2(4000 CHAR);
BEGIN

    v_in_para_data := JSON_OBJECT(
	    'p_active_flag' VALUE p_active_flag,
	    'p_ver_seq' VALUE p_ver_seq,
	    'p_yyyy' VALUE p_yyyy,
	    'p_version_nm' VALUE p_version_nm,
	    'p_description' VALUE p_description,
	    'p_valid_yn' VALUE p_valid_yn,
	    'p_created_by' VALUE p_created_by
	  );

	-- 스플릿관련 변수
	v_delimiter := '^'; -- 데이터 구분자

	v_w_active_flag := RTRIM(p_active_flag	    )  ||  '^';
	v_w_ver_seq := RTRIM(p_ver_seq		    )  ||  '^';
	v_w_yyyy := RTRIM(p_yyyy			    )  ||  '^';
	v_w_version_nm := RTRIM(p_version_nm	    )  ||  '^';
	v_w_description := RTRIM(p_description	    )  ||  '^';
	v_w_valid_yn := RTRIM(p_valid_yn		    )  ||  '^';
	v_w_created_by := RTRIM(p_created_by	    )  ||  '^';

	-- GT_SDMCV_RESULTS_MST_2 TEMP TABLE
	DELETE FROM GT_SDMCV_RESULTS_MST_2;

	-- 시작 LOG  (START)
	v_log_type := 'START';
	v_log_message := '########## Start of procedure @@@##########';
	v_log_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date,
	p_in_para_data => v_in_para_data
      );
	v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)
	-- 트랜잭션 (START)
	-- -----------------------------------------------------------------------------------------
	-- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
	-- -----------------------------------------------------------------------------------------
	--===================================================================================== GT_SDMCV_RESULTS_MST_2 테이블에 split후 INSERT INTO start
	--###############################################  GT_SDMCV_RESULTS_MST_2 테이블에 split후 insert (START)
	WHILE LENGTH(v_w_yyyy) > 0 LOOP

		v_index_active_flag := INSTR(v_w_active_flag, '^');
		v_index_ver_seq := INSTR(v_w_ver_seq, '^');
		v_index_yyyy := INSTR(v_w_yyyy, '^');
		v_index_version_nm := INSTR(v_w_version_nm, '^');
		v_index_description := INSTR(v_w_description, '^');
		v_index_valid_yn := INSTR(v_w_valid_yn, '^');
		v_index_created_by := INSTR(v_w_created_by, '^');

		IF v_index_yyyy > 0 THEN

				v_active_flag := SUBSTR(v_w_active_flag, 1, v_index_active_flag - 1);
				v_w_active_flag := SUBSTR(v_w_active_flag, LENGTH(v_active_flag  ||  '^') + 1, LENGTH(v_w_active_flag));

				v_ver_seq := SUBSTR(v_w_ver_seq, 1, v_index_ver_seq - 1);
				v_w_ver_seq := SUBSTR(v_w_ver_seq, LENGTH(v_ver_seq || '^') + 1, LENGTH(v_w_ver_seq));

				v_yyyy := SUBSTR(v_w_yyyy, 1, v_index_yyyy - 1);
				v_w_yyyy := SUBSTR(v_w_yyyy, LENGTH(v_yyyy  ||	'^') + 1, LENGTH(v_w_yyyy));

				v_version_nm := SUBSTR(v_w_version_nm, 1, v_index_version_nm - 1);
				v_w_version_nm := SUBSTR(v_w_version_nm, LENGTH(v_version_nm  ||  '^') + 1, LENGTH(v_w_version_nm));

				v_description := SUBSTR(v_w_description, 1, v_index_description - 1);
				v_w_description := SUBSTR(v_w_description, LENGTH(v_description  ||  '^') + 1, LENGTH(v_w_description));

				v_valid_yn := SUBSTR(v_w_valid_yn, 1, v_index_valid_yn - 1);
				v_w_valid_yn := SUBSTR(v_w_valid_yn, LENGTH(v_valid_yn	||  '^') + 1, LENGTH(v_w_valid_yn));

				v_created_by := SUBSTR(v_w_created_by, 1, v_index_created_by - 1);
				v_w_created_by := SUBSTR(v_w_created_by, LENGTH(v_created_by  ||  '^') + 1, LENGTH(v_w_created_by));

				--공백제거
				v_active_flag := rtrim(ltrim(v_active_flag			));
				v_ver_seq := rtrim(ltrim(v_ver_seq		));
				v_yyyy := rtrim(ltrim(v_yyyy			));
				v_version_nm := rtrim(ltrim(v_version_nm		));
				v_description := rtrim(ltrim(v_description	));
				v_valid_yn := rtrim(ltrim(v_valid_yn		));
				v_created_by := rtrim(ltrim(v_created_by		));
				--공백제거
				INSERT INTO GT_SDMCV_RESULTS_MST_2 (
										 active_flag
										,ver_seq
										,yyyy
										,version_nm
										,description
										,valid_yn
										,created_by
				) VALUES (
										 v_active_flag
										,v_ver_seq
										,v_yyyy
										,v_version_nm
										,v_description
										,v_valid_yn
										,v_created_by
				);

		ELSE
				v_yyyy := v_w_yyyy;
				v_w_yyyy := NULL;

				--공백제거
				v_active_flag := rtrim(ltrim(v_active_flag	));
				v_ver_seq := rtrim(ltrim(v_ver_seq		));
				v_yyyy := rtrim(ltrim(v_yyyy			));
				v_version_nm := rtrim(ltrim(v_version_nm		));
				v_description := rtrim(ltrim(v_description	));
				v_valid_yn := rtrim(ltrim(v_valid_yn		));
				v_created_by := rtrim(ltrim(v_created_by		));
				--공백제거
				INSERT INTO GT_SDMCV_RESULTS_MST_2 (
										 active_flag
										,ver_seq
										,yyyy
										,version_nm
										,description
										,valid_yn
										,created_by
				) VALUES (
										 v_active_flag
										,v_ver_seq
										,v_yyyy
										,v_version_nm
										,v_description
										,v_valid_yn
										,v_created_by
				);
			END IF;
	END LOOP;

	--===================================================================================== GT_SDMCV_RESULTS_MST_2 테이블에 split후 INSERT INTO end
	-- INPUT COUNT 확인
	SELECT count(yyyy) INTO n_input_count
								FROM GT_SDMCV_RESULTS_MST_2;

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                                  DM_MST_CONTRIBUTE_VER 테이블 DELETE (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN

		-- DELETE FROM COUNT 확인
		SELECT COUNT(YYYY)  INTO n_delete_count FROM DM_MST_CONTRIBUTE_VER A
								WHERE (
										SELECT count(1)
											FROM GT_SDMCV_RESULTS_MST_2 M
											where M.active_flag		= 'D'
												and A.VER_SEQ	= M.VER_SEQ
										) > 0;

		--  select * from GT_SDMCV_RESULTS_MST_2
		DELETE
		FROM DM_MST_CONTRIBUTE_VER
		WHERE (
				SELECT count(1)
					FROM GT_SDMCV_RESULTS_MST_2 M
					where M.active_flag		= 'D'
						and DM_MST_CONTRIBUTE_VER.VER_SEQ	= M.VER_SEQ
				) > 0;
	END;
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                                  DM_MST_CONTRIBUTE_VER 테이블 DELETE (END)
	--------------------------------------------------------------------------------------------◇◇◇◇
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_VER 테이블 UPDATE, INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇

		-- INSERT INTO COUNT 확인
		SELECT count(M.yyyy) INTO n_insert_count
									FROM GT_SDMCV_RESULTS_MST_2 M
										where M.active_flag	 <> 'D';

					MERGE INTO DM_MST_CONTRIBUTE_VER A
					USING (
							SELECT *
								FROM GT_SDMCV_RESULTS_MST_2 M
									where M.active_flag	 <> 'D'
						  ) B
					ON(
							    A.VER_SEQ = B.VER_SEQ
					  )
					WHEN MATCHED THEN
						 UPDATE SET
									 A.YYYY				= B.YYYY
									,A.VERSION_NM		= B.VERSION_NM
									,A.DESCRIPTION		= B.DESCRIPTION
									,A.VALID_YN			= B.VALID_YN
								    ,A.last_updated_by	= B.CREATED_BY
								    ,A.last_update_date	= SYSDATE

					WHEN NOT MATCHED THEN

						 INSERT ( -- VER_SEQ
								   YYYY
								  ,VERSION_NM
								  ,DESCRIPTION
								  ,VALID_YN
								  ,CREATED_BY
								  ,CREATION_DATE
								  ,LAST_UPDATED_BY
								  ,LAST_UPDATE_DATE
								  ,ATTRIBUTE1
								  ,ATTRIBUTE2
								  ,ATTRIBUTE3
								  ,ATTRIBUTE4
								  ,ATTRIBUTE5
								)
						 VALUES (   B.YYYY
								   ,B.VERSION_NM
								   ,B.DESCRIPTION
								   ,B.VALID_YN
								   ,B.CREATED_BY
								   ,SYSDATE
								   ,B.CREATED_BY
								   ,SYSDATE
								   ,NULL,NULL,NULL,NULL,NULL
								);

        -- 기여율 copy
	SELECT MAX(VER_SEQ) INTO v_max_ver_seq FROM DM_MST_CONTRIBUTE_VER;
	IF SQL%ROWCOUNT >= 0 THEN
	    SELECT COUNT(1) INTO n_logo_count
	      FROM DM_MST_CONTRIBUTE_RATIO_MST
	     WHERE VER_SEQ = v_max_ver_seq;
	END IF;
	IF n_logo_count = 0 THEN
		INSERT INTO DM_MST_CONTRIBUTE_RATIO_DTL
		     ( VER_SEQ
		     , DEPARTMENT_ID
		     , DEPT_ID
		     , END_CUST_REPORT
		     , SOLDTO_CUST_REPORT
		     , PRODUCT_GROUP
		     , DM_BIZ_TYPE
		     , YYYYMM
		     , OS_CORP_CD
		     , CONTRIBUTION_TYPE
		     , CONTRIBUTION_RATIO
					 , CREATED_BY
					 , CREATION_DATE
					 , LAST_UPDATED_BY
					 , LAST_UPDATE_DATE
					 , ATTRIBUTE1
					 , ATTRIBUTE2
					 , ATTRIBUTE3
					 , ATTRIBUTE4
					 , ATTRIBUTE5 )
		SELECT v_max_ver_seq AS VER_SEQ
		     , DEPARTMENT_ID
		     , DEPT_ID
		     , END_CUST_REPORT
		     , SOLDTO_CUST_REPORT
		     , PRODUCT_GROUP
		     , DM_BIZ_TYPE
		     , (SELECT YYYY
			  FROM DM_MST_CONTRIBUTE_VER
			 WHERE VER_SEQ = v_max_ver_seq)  ||  SUBSTR(YYYYMM,5,2)
		     , OS_CORP_CD
		     , CONTRIBUTION_TYPE
		     , CONTRIBUTION_RATIO
		     , p_created_by
		     , SYSDATE
		     , p_created_by
		     , SYSDATE
				     , NULL,NULL,NULL,NULL,NULL
		  FROM DM_MST_CONTRIBUTE_RATIO_DTL
		 WHERE VER_SEQ = (SELECT MAX(VER_SEQ) FROM DM_MST_CONTRIBUTE_RATIO_MST );

		INSERT INTO DM_MST_CONTRIBUTE_RATIO_MST
		     ( VER_SEQ
		     , DEPARTMENT_ID
		     , DEPT_ID
		     , END_CUST_REPORT
		     , SOLDTO_CUST_REPORT
		     , PRODUCT_GROUP
		     , DM_BIZ_TYPE
					 , CREATED_BY
					 , CREATION_DATE
					 , LAST_UPDATED_BY
					 , LAST_UPDATE_DATE
					 , ATTRIBUTE1
					 , ATTRIBUTE2
					 , ATTRIBUTE3
					 , ATTRIBUTE4
					 , ATTRIBUTE5 )
		SELECT v_max_ver_seq AS VER_SEQ
		     , DEPARTMENT_ID
		     , DEPT_ID
		     , END_CUST_REPORT
		     , SOLDTO_CUST_REPORT
		     , PRODUCT_GROUP
		     , DM_BIZ_TYPE
		     , p_created_by
		     , SYSDATE
		     , p_created_by
		     , SYSDATE
				     , NULL,NULL,NULL,NULL,NULL
		  FROM DM_MST_CONTRIBUTE_RATIO_MST
		 WHERE VER_SEQ = (SELECT MAX(VER_SEQ) FROM DM_MST_CONTRIBUTE_RATIO_MST );

	    END IF;
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_VER 테이블 UPDATE, INSERT (END)
	--------------------------------------------------------------------------------------------◇◇◇◇
  	-- 트랜잭션 (COMMIT)
		-- -----------------------------------------------------------------------------------------
		-- END TRY
	-- -----------------------------------------------------------------------------------------
	-- -----------------------------------------------------------
    
    COMMIT;                           -- 2026.09.28 AJS 주석처리 (GAP-03 버전 저장 정상 종료 확정)  
    
    EXCEPTION
	WHEN OTHERS THEN
	-- -----------------------------------------------------------
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		v_log_type := 'ERROR';
		v_log_message := SUBSTR(SQLERRM, 1, 1000);
		v_log_description := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
		d_event_date := SYSTIMESTAMP;

		v_log_message := '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/

		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date,
	p_in_para_data	=> v_in_para_data,
	p_sql_err_code	=> SQLCODE,
	p_sql_err_msg	=> SQLERRM,
	p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
      );

	-- -----------------------------------------------------------
    -- END CATCH
	-- -----------------------------------------------------------
	-- 수행결과 성공여부 DISPLAY
	ROLLBACK;               -- 2026.09.28 AJS 주석처리 (GAP-03 버전 저장 오류 시 되돌림)
     IF v_log_message IS NULL THEN
	  v_log_message := 'success';

    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure @@@##########';
    v_log_description := 'input_count: '  ||  TO_CHAR(n_input_count) ;
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date,
	p_in_para_data => v_in_para_data
      );

  END IF;

	-- 2026.09.28 AJS 주석처리 (GAP-03 버전 저장 오류를 화면으로 전달) (START)
    RAISE_APPLICATION_ERROR(-20001,
	'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
	' / SQLERRM=' || SQLERRM ||
	' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	' / PARAMS=' || v_in_para_data
    );
	-- 2026.09.28 AJS 주석처리 (GAP-03 버전 저장 오류를 화면으로 전달) (END)

END P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER;

    -- [2026-09-15 UIPKG] standalone DMF0043_GET_MAIN_SPREAD_TITLE 취합
PROCEDURE P_DMF0043_GET_MAIN_SPREAD_TITLE 
(
    p_division_id  IN  VARCHAR2,
    p_yyyy         IN  VARCHAR2,
    p_created_by   IN  VARCHAR2,
    p_user_id      IN  VARCHAR2,
    p_menu_id      IN  VARCHAR2,
    O_RC1          OUT SYS_REFCURSOR,
    O_RC2          OUT SYS_REFCURSOR,
    O_RC3          OUT SYS_REFCURSOR
) AS
    v_pkg_rc1    SYS_REFCURSOR;
    v_pkg_rc2    SYS_REFCURSOR;
    v_pkg_rc3    SYS_REFCURSOR;
    v_pkg_result SYS_REFCURSOR;
    v_program_id VARCHAR2(100) := 'DMF0043';
    v_sheet_name VARCHAR2(100) := 'ContributeMain';
BEGIN
    -- ────────────────────────────────────────────────────────────────────
    -- STEP 0 : GT_GMST GTT 사전 정리 (PKG INSERT 누적 방지)
    --   PKG body 의 INSERT INTO GT_GMST_TEMP_2 / GT_GMST_TEMP2_2 는
    --   DELETE 없이 누적. 같은 session 안에서 wrapper 가 N번 호출되면 117 × N row.
    --   wrapper 가 자체 책임으로 정리 — caller 빌드 시 중복 alias (ORA-00918) 방지.
    -- ────────────────────────────────────────────────────────────────────
    BEGIN DELETE FROM SCM_MGR.GT_GMST_TEMP_2;  EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DELETE FROM SCM_MGR.GT_GMST_TEMP2_2; EXCEPTION WHEN OTHERS THEN NULL; END;

    -- ────────────────────────────────────────────────────────────────────
    -- STEP 1 : PKG.P_DMF0043_GET_MAIN_SPREAD_TITLE 호출
    --   → GT_GMST_TEMP_2 (9 row) + GT_GMST_TEMP2_2 (117 row) 적재 (매 호출 117 보장)
    -- ────────────────────────────────────────────────────────────────────
    P_DMF0043_GET_MAIN_SPREAD_TITLE_CORE(
        P_DIVISION_ID   => p_division_id,
        P_YYYY          => p_yyyy,
        P_CREATED_BY    => p_created_by,
        P_USER_ID       => p_user_id,
        P_MENU_ID       => p_menu_id,
        O_RC1           => v_pkg_rc1,
        O_RC2           => v_pkg_rc2,
        O_RC3           => v_pkg_rc3,
        O_RESULT_CURSOR => v_pkg_result
    );

    -- PKG OUT cursor 4개 모두 close (wrapper 가 자체 cursor 사용)
    BEGIN CLOSE v_pkg_rc1;    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN CLOSE v_pkg_rc2;    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN CLOSE v_pkg_rc3;    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN CLOSE v_pkg_result; EXCEPTION WHEN OTHERS THEN NULL; END;

    -- ────────────────────────────────────────────────────────────────────
    -- STEP 2 : caller fetch 용 22 컬럼 cursor 를 O_RC1 에 OPEN
    --   PKG SPREAD_TITLE 의 3 UNION SELECT 와 동일 구조 + EDIT_YN 컬럼 제거
    -- ────────────────────────────────────────────────────────────────────
    OPEN O_RC1 FOR
        -- 1st UNION : SCM_MST_SHEET_COLUMNS DEFAULT_FLAG='Y' + PR_SCM_EDIT_YN 권한 필터
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , C.FIXED_FLAG
             , C.COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , C.DATA_SCALE_NUMBER
             , C.DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             , C.VALID_YN
             , C.DIVISION_ID
          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
          INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) TEI
             ON TEI.UNIT_ID = C.DIVISION_ID
         WHERE 1 = 1
           AND C.PROGRAM_ID = v_program_id
           AND C.SHEET_NAME = v_sheet_name
           AND C.DEFAULT_FLAG = 'Y'
           AND C.VALID_YN    = 'Y'
           AND p_division_id IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(C.DIVISION_ID, ',')))

        UNION ALL

        -- 2nd UNION : VISIBLE_FLAG='N' hidden cols (PKG line 401 동일 — Oracle 'N' 사용)
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , C.FIXED_FLAG
             , C.COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , C.DATA_SCALE_NUMBER
             , C.DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             , C.VALID_YN
             , C.DIVISION_ID
          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
         WHERE 1 = 1
           AND C.PROGRAM_ID = v_program_id
           AND C.SHEET_NAME = v_sheet_name
           AND C.VISIBLE_FLAG = 'N'
           AND C.DEFAULT_FLAG IS NULL
           AND C.VALID_YN = 'Y'
           AND p_division_id IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(C.DIVISION_ID, ',')))

        UNION ALL

        -- 3rd UNION : dynamic 컬럼 (FLAG#YYYYMM#CODE) — GT_GMST_TEMP2_2 117 row
        SELECT v_program_id AS PROGRAM_ID
             , v_sheet_name AS SHEET_NAME
             , T.FLAG || '#' || T.YYYYMM || '#' || CODE AS COLUMN_NAME
             , T.NAME AS COLUMN_LABEL_NAME
             , TO_NUMBER(DISPLAY_SEQ) AS SORT_ORDER_NO
             , '' AS DATA_SORT_METHOD_CODE
             , T.NAME AS SMALL_CLASS_LABEL_NAME
             , CASE WHEN LENGTH(T.YYYYMM) = 4 THEN T.YYYYMM
                    ELSE SUBSTR(T.YYYYMM, 1, 4) || '-' || SUBSTR(T.YYYYMM, 5, 2) END AS LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , '' AS FIXED_FLAG
             , 80 AS COLUMN_WIDTH
             , '' AS CELL_CONTROL_OBJECT_TYPE_CODE
             , '' AS CELL_COMBO_DATA_TYPE
             , 2 AS DATA_SCALE_NUMBER
             , NULL AS DATA_MAX_LENGTH
             , 'R' AS HORIZONTAL_ALIGN_CODE
             , 'Y' AS UPPERCASE_APPLY_FLAG
             , 'Y' AS VISIBLE_FLAG
             , '' AS DEFAULT_FLAG
             , '' AS USER_SELECTABLE_FLAG
             , '' AS VALID_YN
             , '' AS DIVISION_ID
          FROM (SELECT REPLACE(YYYYMM, ' ', '') AS YYYYMM
                     , FLAG
                     , CODE
                     , NAME
                     , TO_CHAR(REPLACE(REPLACE(YYYYMM, ' ', ''), '-', '')) || TO_CHAR(DISPLAY_SEQ) AS DISPLAY_SEQ
                  FROM SCM_MGR.GT_GMST_TEMP2_2) T

        UNION ALL

        -- 4th UNION : EDIT_FLAG row 강제 포함 (caller v_ColumnData 빌드 logic 의 EDIT_FLAG SORT 기준점 보장)
        --   PKG 1st UNION 의 INNER JOIN PR_SCM_EDIT_YN 권한 / DEFAULT_FLAG 필터 등으로 EDIT_FLAG 제외 시
        --   caller WHERE SORT > EDIT_FLAG SORT NULL → 0 row → v_Query invalid → ORA-00936 사고 방지
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , C.FIXED_FLAG
             , C.COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , C.DATA_SCALE_NUMBER
             , C.DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             , C.VALID_YN
             , C.DIVISION_ID
          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
         WHERE C.PROGRAM_ID = v_program_id
           AND C.SHEET_NAME = v_sheet_name
           AND C.COLUMN_NAME = 'EDIT_FLAG'
           -- 다른 필터 없음: DEFAULT_FLAG / VALID_YN / VISIBLE_FLAG 무관 — 강제 포함
           AND NOT EXISTS (
             -- 1st UNION 이 이미 EDIT_FLAG 반환했으면 중복 회피
             SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C2
              INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) TEI2
                 ON TEI2.UNIT_ID = C2.DIVISION_ID
              WHERE C2.PROGRAM_ID = v_program_id
                AND C2.SHEET_NAME = v_sheet_name
                AND C2.COLUMN_NAME = 'EDIT_FLAG'
                AND C2.DEFAULT_FLAG = 'Y'
                AND C2.VALID_YN = 'Y'
                AND p_division_id IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(C2.DIVISION_ID, ',')))
           )

        ORDER BY 5;  -- SORT_ORDER_NO

    -- ────────────────────────────────────────────────────────────────────
    -- STEP 3 : O_RC2 / O_RC3 = empty cursor (caller close 안전)
    -- ────────────────────────────────────────────────────────────────────
    OPEN O_RC2 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
    OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,
            '[DMF0043_GET_MAIN_SPREAD_TITLE wrapper] SQLCODE=' || SQLCODE ||
            ' / SQLERRM=' || SQLERRM);
END P_DMF0043_GET_MAIN_SPREAD_TITLE;

    -- [2026-09-15 UIPKG] standalone DMF0043_GET_CONTRIBUTE_MAIN_DATA 취합
PROCEDURE P_DMF0043_GET_CONTRIBUTE_MAIN_DATA 
(
    p_yyyy	       IN  VARCHAR2,
    p_ver_seq	       IN  VARCHAR2,
    p_dis	       IN  VARCHAR2,
    p_his	       IN  VARCHAR2,
    p_created_by       IN  VARCHAR2,
    p_user_group       IN  VARCHAR2,
    O_RC1	       OUT SYS_REFCURSOR
)
/* 2026.05.20  ZIONEX	     [PJ202650304]  NextSCM Migration */
/* 2026.10.06   AJS          불일치 여부 산출(GT_DMF0043_TEMP2 적재) 조인 방식을 해시 조인으로 지정 — 속도 개선(결과 동일) */
IS

    v_sdt	   VARCHAR2(10 CHAR) := p_yyyy || '01';
    v_edt	   VARCHAR2(10 CHAR) := p_yyyy || '12';
    v_thismm	   VARCHAR2(10 CHAR);
    v_ColumnData       CLOB := '';
    v_ColumnDataPivot  CLOB := '';
    v_ColumnData2      CLOB := '';
    v_Query	       CLOB := '';

    /* DMF0043_GET_MAIN_SPREAD_TITLE OUT 커서 수신용 */
    v_rc1	   SYS_REFCURSOR;
    v_rc2	   SYS_REFCURSOR;
    v_rc3	   SYS_REFCURSOR;

    /* #Title FETCH 작업변수 */
    v_PROGRAM_ID		       VARCHAR2(100 CHAR);
    v_SHEET_NAME		       VARCHAR2(100 CHAR);
    v_COLUMN_NAME		       VARCHAR2(100 CHAR);
    v_COLUMN_LABEL_NAME 	       VARCHAR2(100 CHAR);
    v_SORT_ORDER_NO		       VARCHAR2(100 CHAR);
    v_DATA_SORT_METHOD_CODE	       VARCHAR2(100 CHAR);
    v_SMALL_CLASS_LABEL_NAME	       VARCHAR2(100 CHAR);
    v_LARGE_CLASS_LABEL_NAME	       VARCHAR2(100 CHAR);
    v_DAY_CODE			       VARCHAR2(100 CHAR);
    v_FIXED_FLAG		       VARCHAR2(100 CHAR);
    v_COLUMN_WIDTH		       VARCHAR2(100 CHAR);
    v_CELL_CONTROL_OBJECT_TYPE_CODE    VARCHAR2(100 CHAR);
    v_CELL_COMBO_DATA_TYPE	       VARCHAR2(100 CHAR);
    v_DATA_SCALE_NUMBER 	       VARCHAR2(100 CHAR);
    v_DATA_MAX_LENGTH		       VARCHAR2(100 CHAR);
    v_HORIZONTAL_ALIGN_CODE	       VARCHAR2(100 CHAR);
    v_UPPERCASE_APPLY_FLAG	       VARCHAR2(100 CHAR);
    v_VISIBLE_FLAG		       VARCHAR2(100 CHAR);
    v_DEFAULT_FLAG		       VARCHAR2(100 CHAR);
    v_USER_SELECTABLE_FLAG	       VARCHAR2(100 CHAR);
    v_VALID_YN			       VARCHAR2(100 CHAR);
    v_DIVISION_ID		       VARCHAR2(100 CHAR);

BEGIN

    -- SET NOCOUNT ON; (Oracle: 불필요)

    IF (EXTRACT(MONTH FROM SYSDATE) < 10) THEN
	v_thismm := p_yyyy || '0' || TO_CHAR(EXTRACT(MONTH FROM SYSDATE));
    ELSE
	v_thismm := p_yyyy || TO_CHAR(EXTRACT(MONTH FROM SYSDATE));
    END IF;

    /* GTT 사전 정리 (세션 잔존 행 제거) — #temp/#temp2/#temp3/#Title DROP 대응 */
    DELETE FROM GT_DMF0043_TEMP;
    DELETE FROM GT_DMF0043_TEMP2;
    DELETE FROM GT_DMF0043_TEMP3;
    DELETE FROM GT_DMF0043_TITLE;
    DELETE FROM GT_DMF0043_MASTER_LIST;
    DELETE FROM GT_DMF0043_TEMP_LIST;
    DELETE FROM GT_DMF0043_DATA_TABLE;

    -- ######################## 해더 칼럼 데이터 ########################

    /* insert #Title exec DMF0043_GET_MAIN_SPREAD_TITLE '40',@p_yyyy,@p_created_by
       Oracle: OUT SYS_REFCURSOR 호출 후 FETCH 하여 GT_DMF0043_TITLE 적재 */
    P_DMF0043_GET_MAIN_SPREAD_TITLE
    (
	p_division_id => '40',
	p_yyyy	      => p_yyyy,
	p_created_by  => p_created_by,
	p_user_id     => p_created_by,
	p_menu_id     => 'DMF0043',
	O_RC1	      => v_rc1,
	O_RC2	      => v_rc2,
	O_RC3	      => v_rc3
    );

    LOOP
	FETCH v_rc1 INTO
	    v_PROGRAM_ID, v_SHEET_NAME, v_COLUMN_NAME, v_COLUMN_LABEL_NAME,
	    v_SORT_ORDER_NO, v_DATA_SORT_METHOD_CODE, v_SMALL_CLASS_LABEL_NAME,
	    v_LARGE_CLASS_LABEL_NAME, v_DAY_CODE, v_FIXED_FLAG, v_COLUMN_WIDTH,
	    v_CELL_CONTROL_OBJECT_TYPE_CODE, v_CELL_COMBO_DATA_TYPE,
	    v_DATA_SCALE_NUMBER, v_DATA_MAX_LENGTH, v_HORIZONTAL_ALIGN_CODE,
	    v_UPPERCASE_APPLY_FLAG, v_VISIBLE_FLAG, v_DEFAULT_FLAG,
	    v_USER_SELECTABLE_FLAG, v_VALID_YN, v_DIVISION_ID;
	EXIT WHEN v_rc1%NOTFOUND;

	INSERT INTO GT_DMF0043_TITLE
	(PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME,
	 SORT_ORDER_NO, DATA_SORT_METHOD_CODE, SMALL_CLASS_LABEL_NAME,
	 LARGE_CLASS_LABEL_NAME, DAY_CODE, FIXED_FLAG, COLUMN_WIDTH,
	 CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE,
	 DATA_SCALE_NUMBER, DATA_MAX_LENGTH, HORIZONTAL_ALIGN_CODE,
	 UPPERCASE_APPLY_FLAG, VISIBLE_FLAG, DEFAULT_FLAG,
	 USER_SELECTABLE_FLAG, VALID_YN, DIVISION_ID)
	VALUES
	(v_PROGRAM_ID, v_SHEET_NAME, v_COLUMN_NAME, v_COLUMN_LABEL_NAME,
	 v_SORT_ORDER_NO, v_DATA_SORT_METHOD_CODE, v_SMALL_CLASS_LABEL_NAME,
	 v_LARGE_CLASS_LABEL_NAME, v_DAY_CODE, v_FIXED_FLAG, v_COLUMN_WIDTH,
	 v_CELL_CONTROL_OBJECT_TYPE_CODE, v_CELL_COMBO_DATA_TYPE,
	 v_DATA_SCALE_NUMBER, v_DATA_MAX_LENGTH, v_HORIZONTAL_ALIGN_CODE,
	 v_UPPERCASE_APPLY_FLAG, v_VISIBLE_FLAG, v_DEFAULT_FLAG,
	 v_USER_SELECTABLE_FLAG, v_VALID_YN, v_DIVISION_ID);
    END LOOP;
    CLOSE v_rc1;
    BEGIN CLOSE v_rc2; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN CLOSE v_rc3; EXCEPTION WHEN OTHERS THEN NULL; END;

    -- [Fix v2] LISTAGG -> CLOB cursor loop. MSSQL [col] -> Oracle "col" (delimited identifier).
    -- v_ColumnData	 = "col1","col2",...			   (SELECT column ref list)
    -- v_ColumnDataPivot = 'col1' AS "col1",...  (PIVOT IN list, Oracle syntax)
    v_ColumnData      := '';
    v_ColumnDataPivot := '';
    DECLARE v_first BOOLEAN := TRUE; BEGIN
      FOR r IN (SELECT COLUMN_NAME FROM GT_DMF0043_TITLE
		 WHERE TO_NUMBER(SORT_ORDER_NO) > NVL((SELECT TO_NUMBER(SORT_ORDER_NO) FROM GT_DMF0043_TITLE WHERE COLUMN_NAME = 'EDIT_FLAG'), 0)
		 ORDER BY TO_NUMBER(SORT_ORDER_NO)) LOOP
	IF v_first THEN
	  v_ColumnData	    := '"' || r.COLUMN_NAME || '"';
	  v_ColumnDataPivot := '''' || r.COLUMN_NAME || ''' AS "' || r.COLUMN_NAME || '"';
	  v_first := FALSE;
	ELSE
	  v_ColumnData	    := v_ColumnData	 || ',"' || r.COLUMN_NAME || '"';
	  v_ColumnDataPivot := v_ColumnDataPivot || ',''' || r.COLUMN_NAME || ''' AS "' || r.COLUMN_NAME || '"';
	END IF;
      END LOOP;
    END;
    --select @ColumnData

    -- [Fix v2] LISTAGG #2 -> CLOB cursor loop with Oracle CAST + delimited identifier.
    -- Format: CAST("col" AS NUMBER(5,2)) AS "col"  ( contains 999 -> just "col" — contribution_type passthrough)
    v_ColumnData2 := '';
    DECLARE v_first BOOLEAN := TRUE; v_seg VARCHAR2(4000); BEGIN
      FOR r IN (SELECT COLUMN_NAME FROM GT_DMF0043_TITLE
		 WHERE TO_NUMBER(SORT_ORDER_NO) > NVL((SELECT TO_NUMBER(SORT_ORDER_NO) FROM GT_DMF0043_TITLE WHERE COLUMN_NAME = 'EDIT_FLAG'), 0)
		 ORDER BY TO_NUMBER(SORT_ORDER_NO)) LOOP
	IF INSTR(r.COLUMN_NAME, '999') <> 0 THEN
	  v_seg := '"' || r.COLUMN_NAME || '"';
	ELSE
	  v_seg := 'CAST("' || r.COLUMN_NAME || '" AS NUMBER(5,2)) AS "' || r.COLUMN_NAME || '"';
	END IF;
	IF v_first THEN v_ColumnData2 := v_seg; v_first := FALSE;
	ELSE v_ColumnData2 := v_ColumnData2 || ',' || v_seg; END IF;
      END LOOP;
    END;
    --select @ColumnData2
    -- ######################## 해더 칼럼 데이터 ########################

    IF (p_his = 'N') THEN
        -- ######################## DM_MST_CONTRIBUTE_RATIO 데이터 ########################
        -- 연도 데이터
	INSERT INTO GT_DMF0043_TEMP
	(VER_SEQ, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT,
	 PRODUCT_GROUP, DM_BIZ_TYPE, RATIO, COLUMN_NAME)
	SELECT VER_SEQ
	     , DEPARTMENT_ID
	     , DEPT_ID
	     , END_CUST_REPORT
	     , SOLDTO_CUST_REPORT
	     , PRODUCT_GROUP
	     , DM_BIZ_TYPE
	     , TO_CHAR(CONTRIBUTION_RATIO) AS RATIO
	     , 'Y#' || p_yyyy || '#' || OS_CORP_CD AS COLUMN_NAME
	  FROM (SELECT MA.VER_SEQ
		     , MA.DEPARTMENT_ID
		     , MA.DEPT_ID
		     , MA.END_CUST_REPORT
		     , MA.SOLDTO_CUST_REPORT
		     , MA.PRODUCT_GROUP
		     , MA.DM_BIZ_TYPE
		     , DT.YYYYMM
		     , DT.OS_CORP_CD
		     , DT.CONTRIBUTION_TYPE
		     , DT.CONTRIBUTION_RATIO
		  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
		       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
			  ON MA.VER_SEQ = DT.VER_SEQ
			 AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
			 AND MA.DEPT_ID = DT.DEPT_ID
			 AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
			 AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
			 AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
			 AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
	       ) MA
	 WHERE YYYYMM = v_thismm
	   AND VER_SEQ = p_ver_seq

	UNION ALL

	SELECT VER_SEQ
	     , DEPARTMENT_ID
	     , DEPT_ID
	     , END_CUST_REPORT
	     , SOLDTO_CUST_REPORT
	     , PRODUCT_GROUP
	     , DM_BIZ_TYPE
	     , TO_CHAR(CONTRIBUTION_TYPE) AS RATIO
	     , 'Y#' || p_yyyy || '#RBU_0999' AS COLUMN_NAME
	  FROM (SELECT MA.VER_SEQ
		     , MA.DEPARTMENT_ID
		     , MA.DEPT_ID
		     , MA.END_CUST_REPORT
		     , MA.SOLDTO_CUST_REPORT
		     , MA.PRODUCT_GROUP
		     , MA.DM_BIZ_TYPE
		     , DT.YYYYMM
		     , DT.OS_CORP_CD
		     , DT.CONTRIBUTION_TYPE
		     , DT.CONTRIBUTION_RATIO
		  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
		       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
			  ON MA.VER_SEQ = DT.VER_SEQ
			 AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
			 AND MA.DEPT_ID = DT.DEPT_ID
			 AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
			 AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
			 AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
			 AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
	       ) MA
	 WHERE YYYYMM  = v_thismm
	   AND VER_SEQ = p_ver_seq

	UNION ALL

        -- 월 데이터
	SELECT VER_SEQ
	     , DEPARTMENT_ID
	     , DEPT_ID
	     , END_CUST_REPORT
	     , SOLDTO_CUST_REPORT
	     , PRODUCT_GROUP
	     , DM_BIZ_TYPE
	     , TO_CHAR(CONTRIBUTION_RATIO) AS RATIO
	     , 'M#' || YYYYMM || '#' || OS_CORP_CD AS COLUMN_NAME
	  FROM (SELECT MA.VER_SEQ
		     , MA.DEPARTMENT_ID
		     , MA.DEPT_ID
		     , MA.END_CUST_REPORT
		     , MA.SOLDTO_CUST_REPORT
		     , MA.PRODUCT_GROUP
		     , MA.DM_BIZ_TYPE
		     , DT.YYYYMM
		     , DT.OS_CORP_CD
		     , DT.CONTRIBUTION_TYPE
		     , DT.CONTRIBUTION_RATIO
		  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
		       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
			  ON MA.VER_SEQ = DT.VER_SEQ
			 AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
			 AND MA.DEPT_ID = DT.DEPT_ID
			 AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
			 AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
			 AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
			 AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
	       ) MA
	 WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
	   AND VER_SEQ = p_ver_seq

	UNION ALL

	SELECT VER_SEQ
	     , DEPARTMENT_ID
	     , DEPT_ID
	     , END_CUST_REPORT
	     , SOLDTO_CUST_REPORT
	     , PRODUCT_GROUP
	     , DM_BIZ_TYPE
	     , TO_CHAR(CONTRIBUTION_TYPE) AS RATIO
	     , 'M#' || YYYYMM || '#RBU_0999' AS COLUMN_NAME
	  FROM (SELECT MA.VER_SEQ
		     , MA.DEPARTMENT_ID
		     , MA.DEPT_ID
		     , MA.END_CUST_REPORT
		     , MA.SOLDTO_CUST_REPORT
		     , MA.PRODUCT_GROUP
		     , MA.DM_BIZ_TYPE
		     , DT.YYYYMM
		     , DT.OS_CORP_CD
		     , DT.CONTRIBUTION_TYPE
		     , DT.CONTRIBUTION_RATIO
		  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
		       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
			  ON MA.VER_SEQ = DT.VER_SEQ
			 AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
			 AND MA.DEPT_ID = DT.DEPT_ID
			 AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
			 AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
			 AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
			 AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
	       ) MA
	 WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
	   AND VER_SEQ = p_ver_seq;

	IF (p_dis = 'ALL') THEN --2019/08/27
                -- 불일치 조회 관련 칼럼 추가
		INSERT INTO GT_DMF0043_TEMP2
		(VER_SEQ, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT,
		 PRODUCT_GROUP, DM_BIZ_TYPE, RATIO, COLUMN_NAME, DISCARD)
--		SELECT MAIN.VER_SEQ                                                                                  --  2026.10.06 AJS
		SELECT /*+ LEADING(DISCARD MAIN) USE_HASH(MAIN) NO_MERGE(DISCARD) NO_PUSH_PRED(DISCARD) */ MAIN.VER_SEQ  --  2026.10.06 AJS
		     , MAIN.DEPARTMENT_ID
		     , MAIN.DEPT_ID
		     , MAIN.END_CUST_REPORT
		     , MAIN.SOLDTO_CUST_REPORT
		     , MAIN.PRODUCT_GROUP
		     , MAIN.DM_BIZ_TYPE
		     , MAIN.RATIO
		     , MAIN.COLUMN_NAME
		     , DISCARD.DISCARD
		  FROM GT_DMF0043_TEMP MAIN
		       INNER JOIN (SELECT VER_SEQ
					, DEPARTMENT_ID
					, DEPT_ID
					, END_CUST_REPORT
					, SOLDTO_CUST_REPORT
					, PRODUCT_GROUP
					, DM_BIZ_TYPE
					, CASE WHEN SUM(CONTRIBUTION_RATIO) = 1200 THEN 'Y' ELSE 'N' END AS DISCARD
				     FROM (SELECT MA.VER_SEQ
						, MA.DEPARTMENT_ID
						, MA.DEPT_ID
						, MA.END_CUST_REPORT
						, MA.SOLDTO_CUST_REPORT
						, MA.PRODUCT_GROUP
						, MA.DM_BIZ_TYPE
						, DT.YYYYMM
						, DT.OS_CORP_CD
						, DT.CONTRIBUTION_TYPE
						, DT.CONTRIBUTION_RATIO
					     FROM DM_MST_CONTRIBUTE_RATIO_MST MA
						  INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
						     ON MA.VER_SEQ = DT.VER_SEQ
						    AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
						    AND MA.DEPT_ID = DT.DEPT_ID
						    AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
						    AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
						    AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
						    AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
					  ) MA
				    WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
				      AND VER_SEQ = p_ver_seq
				    GROUP BY VER_SEQ
					, DEPARTMENT_ID
					, DEPT_ID
					, END_CUST_REPORT
					, SOLDTO_CUST_REPORT
					, PRODUCT_GROUP
					, DM_BIZ_TYPE
				  ) DISCARD
			  ON MAIN.VER_SEQ = DISCARD.VER_SEQ
			 AND MAIN.DEPARTMENT_ID = DISCARD.DEPARTMENT_ID
			 AND MAIN.DEPT_ID = DISCARD.DEPT_ID
			 AND MAIN.END_CUST_REPORT = DISCARD.END_CUST_REPORT
			 AND MAIN.SOLDTO_CUST_REPORT = DISCARD.SOLDTO_CUST_REPORT
			 AND MAIN.PRODUCT_GROUP = DISCARD.PRODUCT_GROUP
			 AND MAIN.DM_BIZ_TYPE = DISCARD.DM_BIZ_TYPE;
                -- ######################## DM_MST_CONTRIBUTE_RATIO 데이터 ########################


		v_Query := '
SELECT *
  FROM (SELECT SITE_ITEM.*
	     , RATIO.VER_SEQ
	     , CASE WHEN RATIO.DISCARD = ''Y'' THEN RATIO.DISCARD ELSE ''N'' END DISCARD
	     , CASE WHEN ((SITE_ITEM.department_id IS NOT NULL)
			   AND (SITE_ITEM.dept_id IS NOT NULL)
			   AND (SITE_ITEM.end_cust_report IS NOT NULL)
			   AND (SITE_ITEM.SOLDTO_CUST_REPORT IS NOT NULL)
               AND (SITE_ITEM.PRODUCT_GROUP IS NOT NULL)
			   AND (SITE_ITEM.dm_biz_type IS NOT NULL))
			  THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
	     , ' || v_ColumnData2 || '
	  FROM (SELECT DISTINCT A.DIVISION_ID
		     , TEAM.DEPARTMENT_ID
		     , TEAM.DEPARTMENT_NAME
		     , TEAM.DEPT_ID AS DEPT_ID
		     , TEAM.DEPT_NAME_KO AS DEPT_NAME
             , TRIM(A.ATTRIBUTE2) AS END_CUST_REPORT
             , TRIM(A.ATTRIBUTE1) AS SOLDTO_CUST_REPORT
             , TRIM(A.REPORT_GROUP3) AS PRODUCT_GROUP --PRODUCT_GR (As-Is parity, 2026-06-01)
             , C.FORECAST_INFO_BIZ_TYPE AS DM_BIZ_TYPE
		  FROM SCM_MST_SITE_ITEM A
		       INNER JOIN SCM_MST_SITE B
			  ON A.DIVISION_ID = B.DIVISION_ID
			 AND A.SCM_SITE_ID = B.SCM_SITE_ID
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL SAM
			  ON SAM.SEGMENT1 = B.COMPANY_ID
			 AND SAM.LOOKUP_TYPE = ''INTERNAL_TXN''
		       INNER JOIN DM_MST_ITEM_SINGLE_V C
			  ON A.DIVISION_ID = C.DIVISION_ID
			 AND A.ITEM_ID = C.ITEM_ID
			LEFT OUTER JOIN (SELECT UPPER(B.USER_ID) AS USER_ID
					      , B.USER_NAME
					      , B.USER_NAME_EN
					      , B.DEPT_ID
					      , C.DEPT_NAME_KO
					      , D.DEPT_ID AS DEPARTMENT_ID
					      , D.DEPT_NAME_KO AS DEPARTMENT_NAME
					   FROM SCM_MST_SSO_USER_INFO B
						INNER JOIN SCM_MST_SSO_DEPT_INFO C
						   ON B.DEPT_ID = C.DEPT_ID
						INNER JOIN SCM_MST_SSO_DEPT_INFO D
						   ON C.UPPER_DEPT_ID = D.DEPT_ID
					) TEAM
			  ON UPPER(TEAM.USER_ID) = REGEXP_SUBSTR(UPPER(A.OWNER), ''[^,]+'', 1, 1)
		 WHERE A.DIVISION_ID = ''40''
		   AND B.SITE_TYPE = ''SALES''
--		   AND NVL(C.FORECAST_INFO_BIZ_TYPE,''-'') <> ''-''
--		   AND NVL(A.ATTRIBUTE2,''-'') <> ''-''
--		   AND NVL(A.ATTRIBUTE1,''-'') <> ''-''
--		   AND NVL(A.REPORT_GROUP3,''-'') <> ''-''
		 GROUP BY A.DIVISION_ID
		     , TEAM.DEPARTMENT_ID
		     , TEAM.DEPARTMENT_NAME
		     , TEAM.DEPT_ID
		     , TEAM.DEPT_NAME_KO
             , SAM.SEGMENT3
             , A.ATTRIBUTE2
             , A.ATTRIBUTE1
             , A.REPORT_GROUP3
             , C.FORECAST_INFO_BIZ_TYPE
	       ) SITE_ITEM
	       LEFT JOIN (SELECT * FROM (SELECT VER_SEQ
			       , DEPARTMENT_ID
			       , DEPT_ID
			       , END_CUST_REPORT
			       , SOLDTO_CUST_REPORT
			       , PRODUCT_GROUP
			       , DM_BIZ_TYPE
			       , DISCARD
			       , RATIO
			       , COLUMN_NAME
			    FROM GT_DMF0043_TEMP2) MA
				 PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' || v_ColumnDataPivot || ')) PVT
			  ) RATIO
		 ON SITE_ITEM.DEPARTMENT_ID   = RATIO.DEPARTMENT_ID
		AND SITE_ITEM.DEPT_ID	      = RATIO.DEPT_ID
		AND SITE_ITEM.END_CUST_REPORT = RATIO.END_CUST_REPORT
		AND SITE_ITEM.SOLDTO_CUST_REPORT  = RATIO.SOLDTO_CUST_REPORT
		AND SITE_ITEM.PRODUCT_GROUP   = RATIO.PRODUCT_GROUP
		AND SITE_ITEM.DM_BIZ_TYPE     = RATIO.DM_BIZ_TYPE
       ) MA
 WHERE DISCARD = CASE WHEN ''' || p_dis || ''' = ''ALL'' THEN DISCARD ELSE ''' || p_dis || ''' END
   AND MA.DEPARTMENT_ID IS NOT NULL  
 ORDER BY DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT, PRODUCT_GROUP, DM_BIZ_TYPE
';

        ELSE  -- 2019/08/27 (@p_dis = 'Y') 추가
                /* #master_list / #temp_list 사전 정리 (DROP 대응) */
		DELETE FROM GT_DMF0043_MASTER_LIST;
		DELETE FROM GT_DMF0043_TEMP_LIST;

		INSERT INTO GT_DMF0043_MASTER_LIST
		(DIVISION_ID, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME,
		 END_CUST_REPORT, SOLDTO_CUST_REPORT
		 , PRODUCT_GROUP --(As-Is parity, 2026-06-01)
		 , DM_BIZ_TYPE)
		SELECT A.DIVISION_ID
-- 20260906 DEPT_ID 기준으르 OWNER 에서 SCM_MST_SITE_ITEM 의 DEPT_ID 기준으로 변경
		     , E.DEPT_ID  AS DEPARTMENT_ID
		     , E.DEPT_NAME_KO AS DEPARTMENT_NAME
		     , A.DEPT_ID AS DEPT_ID
		     , D.DEPT_NAME_KO AS DEPT_NAME
-- 		     , TEAM.DEPARTMENT_ID  AS DEPARTMENT_ID
--		     , TEAM.DEPARTMENT_NAME AS DEPARTMENT_NAME
--		     , TEAM.DEPT_ID AS DEPT_ID
--		     , TEAM.DEPT_NAME_KO AS DEPT_NAME
		     , TRIM(A.ATTRIBUTE2) AS END_CUST_REPORT
		     , TRIM(A.ATTRIBUTE1) AS SOLDTO_CUST_REPORT
		     , TRIM(A.REPORT_GROUP3) AS PRODUCT_GROUP --PRODUCT_GR (As-Is parity, 2026-06-01)
		     , C.FORECAST_INFO_BIZ_TYPE AS DM_BIZ_TYPE
		  FROM SCM_MST_SITE_ITEM A
		       INNER JOIN SCM_MST_SITE B
			  ON A.DIVISION_ID = B.DIVISION_ID
			 AND A.SCM_SITE_ID = B.SCM_SITE_ID
		       INNER JOIN DM_MST_ITEM_SINGLE_V C
			  ON A.DIVISION_ID = C.DIVISION_ID
			 AND A.ITEM_ID = C.ITEM_ID
-- 20260906 DEPT_ID 기준으르 OWNER 에서 SCM_MST_SITE_ITEM 의 DEPT_ID 기준으로 변경			 
			LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D ON A.DEPT_ID = D.DEPT_ID 
			LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO E ON D.UPPER_DEPT_ID  = E.DEPT_ID
--			LEFT JOIN (SELECT B.USER_ID
--					, B.USER_NAME
--					, B.USER_NAME_EN
--					, B.DEPT_ID
--					, C.DEPT_NAME_KO
--					, D.DEPT_ID AS DEPARTMENT_ID
--					, D.DEPT_NAME_KO AS DEPARTMENT_NAME
--				     FROM SCM_MST_SSO_USER_INFO B
--					  INNER JOIN SCM_MST_SSO_DEPT_INFO C
--					     ON B.DEPT_ID = C.DEPT_ID
--					  INNER JOIN SCM_MST_SSO_DEPT_INFO D
--					     ON C.UPPER_DEPT_ID = D.DEPT_ID
--				   ) TEAM
--			  ON UPPER(TEAM.USER_ID) = REGEXP_SUBSTR(UPPER(A.OWNER), '[^,]+', 1, 1)
			
		 WHERE A.DIVISION_ID = '40'
		   AND B.SITE_TYPE = 'SALES'
		 GROUP BY A.DIVISION_ID
-- 20260906 DEPT_ID 기준으르 OWNER 에서 SCM_MST_SITE_ITEM 의 DEPT_ID 기준으로 변경
		     , E.DEPT_ID
		     , E.DEPT_NAME_KO 
		     , A.DEPT_ID 
		     , D.DEPT_NAME_KO 
--		     , TEAM.DEPARTMENT_ID
--		     , TEAM.DEPARTMENT_NAME
--		     , TEAM.DEPT_ID
--		     , TEAM.DEPT_NAME_KO
		     , A.ATTRIBUTE2
		     , A.ATTRIBUTE1
		     , A.REPORT_GROUP3
		     , C.FORECAST_INFO_BIZ_TYPE
		;

		INSERT INTO GT_DMF0043_TEMP_LIST
		(VER_SEQ, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT,
		 PRODUCT_GROUP, DM_BIZ_TYPE, RATIO, COLUMN_NAME, DISCARD)
		SELECT MAIN.VER_SEQ
		     , MAIN.DEPARTMENT_ID
		     , MAIN.DEPT_ID
		     , MAIN.END_CUST_REPORT
		     , MAIN.SOLDTO_CUST_REPORT
		     , MAIN.PRODUCT_GROUP
		     , MAIN.DM_BIZ_TYPE
		     , MAIN.RATIO
		     , MAIN.COLUMN_NAME
		     , DISCARD.DISCARD
		  FROM GT_DMF0043_TEMP MAIN
		       INNER JOIN (SELECT VER_SEQ
					, DEPARTMENT_ID
					, DEPT_ID
					, END_CUST_REPORT
					, SOLDTO_CUST_REPORT
					, PRODUCT_GROUP
					, DM_BIZ_TYPE
					, CASE WHEN SUM(CASE WHEN RATIO = 100 THEN 0 ELSE 1 END) > 0 THEN 'Y' ELSE 'N' END AS DISCARD
				     FROM (SELECT MA.VER_SEQ
						, MA.DEPARTMENT_ID
						, MA.DEPT_ID
						, MA.END_CUST_REPORT
						, MA.SOLDTO_CUST_REPORT
						, MA.PRODUCT_GROUP
						, MA.DM_BIZ_TYPE
						, DT.YYYYMM
						, DT.OS_CORP_CD
						, DT.CONTRIBUTION_TYPE
						, DT.CONTRIBUTION_RATIO
						, SUM(CONTRIBUTION_RATIO) OVER(PARTITION BY MA.VER_SEQ
											  , MA.DEPARTMENT_ID
											  , MA.DEPT_ID
											  , MA.END_CUST_REPORT
											  , MA.SOLDTO_CUST_REPORT
											  , MA.PRODUCT_GROUP
											  , MA.DM_BIZ_TYPE
											  , DT.YYYYMM) AS RATIO
					     FROM DM_MST_CONTRIBUTE_RATIO_MST MA
						  INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
						     ON MA.VER_SEQ = DT.VER_SEQ
						    AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
						    AND MA.DEPT_ID = DT.DEPT_ID
						    AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
						    AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
						    AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
						    AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
					    WHERE MA.VER_SEQ = p_ver_seq
					      AND DT.YYYYMM >= v_sdt
					      AND DT.YYYYMM <= v_edt
					  ) MA
				    GROUP BY VER_SEQ
					   , DEPARTMENT_ID
					   , DEPT_ID
					   , END_CUST_REPORT
					   , SOLDTO_CUST_REPORT
					   , PRODUCT_GROUP
					   , DM_BIZ_TYPE
				  ) DISCARD
			  ON MAIN.VER_SEQ	  = DISCARD.VER_SEQ
			 AND MAIN.DEPARTMENT_ID   = DISCARD.DEPARTMENT_ID
			 AND MAIN.DEPT_ID	  = DISCARD.DEPT_ID
			 AND MAIN.END_CUST_REPORT = DISCARD.END_CUST_REPORT
			 AND MAIN.SOLDTO_CUST_REPORT  = DISCARD.SOLDTO_CUST_REPORT
			 AND MAIN.PRODUCT_GROUP   = DISCARD.PRODUCT_GROUP
			 AND MAIN.DM_BIZ_TYPE	  = DISCARD.DM_BIZ_TYPE
		 WHERE DISCARD.DISCARD = 'Y';

		v_Query := '
SELECT *
  FROM (SELECT SITE_ITEM.*
	     , RATIO.VER_SEQ
	     , CASE WHEN RATIO.DISCARD = ''Y'' THEN RATIO.DISCARD ELSE ''N'' END DISCARD
	     , CASE WHEN ((SITE_ITEM.department_id IS NOT NULL)
			   AND (SITE_ITEM.dept_id IS NOT NULL)
			   AND (SITE_ITEM.end_cust_report IS NOT NULL)
			   AND (SITE_ITEM.SOLDTO_CUST_REPORT IS NOT NULL)
               AND (SITE_ITEM.PRODUCT_GROUP IS NOT NULL)
			   AND (SITE_ITEM.dm_biz_type IS NOT NULL))
			 THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
	     ,' || v_ColumnData2 || '
	  FROM GT_DMF0043_MASTER_LIST SITE_ITEM
	       INNER JOIN (SELECT * FROM (SELECT VER_SEQ
				, DEPARTMENT_ID
				, DEPT_ID
				, END_CUST_REPORT
				, SOLDTO_CUST_REPORT
				, PRODUCT_GROUP
				, DM_BIZ_TYPE
				, DISCARD
				, RATIO
				, COLUMN_NAME

			     FROM GT_DMF0043_TEMP_LIST
				    WHERE DISCARD = ''Y'') MA
			    PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' || v_ColumnDataPivot || ')) PVT
			  ) RATIO
		  ON  SITE_ITEM.DEPARTMENT_ID = RATIO.DEPARTMENT_ID
		 AND SITE_ITEM.DEPT_ID = RATIO.DEPT_ID
		 AND SITE_ITEM.END_CUST_REPORT = RATIO.END_CUST_REPORT
		 AND SITE_ITEM.SOLDTO_CUST_REPORT = RATIO.SOLDTO_CUST_REPORT
		 AND SITE_ITEM.DM_BIZ_TYPE = RATIO.DM_BIZ_TYPE

	UNION ALL
	SELECT SITE_ITEM.*
	     , RATIO.VER_SEQ
	     , ''Y'' AS DISCARD
	     , CASE WHEN ((SITE_ITEM.department_id IS NOT NULL)
			   AND (SITE_ITEM.dept_id IS NOT NULL)
			   AND (SITE_ITEM.end_cust_report IS NOT NULL)
			   AND (SITE_ITEM.SOLDTO_CUST_REPORT IS NOT NULL)
               AND (SITE_ITEM.PRODUCT_GROUP IS NOT NULL)
			   AND (SITE_ITEM.dm_biz_type IS NOT NULL))
			 THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
	     , ' || v_ColumnData2 || '
	  FROM GT_DMF0043_MASTER_LIST SITE_ITEM
	       LEFT OUTER JOIN (SELECT * FROM (SELECT VER_SEQ
				     , DEPARTMENT_ID
				     , DEPT_ID
				     , END_CUST_REPORT
				     , SOLDTO_CUST_REPORT
				     , PRODUCT_GROUP
				     , DM_BIZ_TYPE
				     , RATIO
				     , COLUMN_NAME
				  FROM GT_DMF0043_TEMP) MA
				 PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' || v_ColumnDataPivot || ')) PVT
			       ) RATIO
		 ON SITE_ITEM.DEPARTMENT_ID = RATIO.DEPARTMENT_ID
		AND SITE_ITEM.DEPT_ID = RATIO.DEPT_ID
		AND SITE_ITEM.END_CUST_REPORT = RATIO.END_CUST_REPORT
		AND SITE_ITEM.SOLDTO_CUST_REPORT = RATIO.SOLDTO_CUST_REPORT
		AND SITE_ITEM.PRODUCT_GROUP = RATIO.PRODUCT_GROUP
		AND SITE_ITEM.DM_BIZ_TYPE = RATIO.DM_BIZ_TYPE
	 WHERE RATIO.VER_SEQ IS NULL
       ) MA
     WHERE MA.DEPARTMENT_ID IS NOT NULL  
     ORDER BY DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT, PRODUCT_GROUP, DM_BIZ_TYPE  
';

	END IF;

    ELSE   -- (@p_his = 'Y')
        -- ######################## 데이터 ########################
	INSERT INTO GT_DMF0043_DATA_TABLE
	(VER_SEQ, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT,
	 PRODUCT_GROUP, DM_BIZ_TYPE, DIVISION_ID)
	SELECT CONTRIBUTE.VER_SEQ
	     , CONTRIBUTE.DEPARTMENT_ID
	     , CONTRIBUTE.DEPT_ID
	     , CONTRIBUTE.END_CUST_REPORT
	     , CONTRIBUTE.SOLDTO_CUST_REPORT
	     , CONTRIBUTE.PRODUCT_GROUP
	     , CONTRIBUTE.DM_BIZ_TYPE
	     , SITE_ITEM.DIVISION_ID
	  FROM (SELECT MA.VER_SEQ
		     , MA.DEPARTMENT_ID
		     , MA.DEPT_ID
		     , MA.END_CUST_REPORT
		     , MA.SOLDTO_CUST_REPORT
		     , MA.PRODUCT_GROUP
		     , MA.DM_BIZ_TYPE
		  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
	       ) CONTRIBUTE
	       LEFT OUTER JOIN (
		    SELECT DISTINCT
			   A.DIVISION_ID
-- 20260906 DEPT_ID 기준으르 OWNER 에서 SCM_MST_SITE_ITEM 의 DEPT_ID 기준으로 변경
		     , E.DEPT_ID  AS DEPARTMENT_ID
		     , E.DEPT_NAME_KO AS DEPARTMENT_NAME
		     , A.DEPT_ID AS DEPT_ID
		     , D.DEPT_NAME_KO AS DEPT_NAME
-- 		     , TEAM.DEPARTMENT_ID  AS DEPARTMENT_ID
--		     , TEAM.DEPARTMENT_NAME AS DEPARTMENT_NAME
--		     , TEAM.DEPT_ID AS DEPT_ID
--		     , TEAM.DEPT_NAME_KO AS DEPT_NAME		
			 , TRIM(A.ATTRIBUTE2) AS END_CUST_REPORT
			 , TRIM(A.ATTRIBUTE1) AS SOLDTO_CUST_REPORT
			 , TRIM(A.REPORT_GROUP3) AS PRODUCT_GROUP --PRODUCT_GR (As-Is parity, 2026-06-01)
			 , C.FORECAST_INFO_BIZ_TYPE AS DM_BIZ_TYPE
		      FROM SCM_MST_SITE_ITEM A
			   INNER JOIN SCM_MST_SITE B
			      ON A.DIVISION_ID = B.DIVISION_ID
			     AND A.SCM_SITE_ID = B.SCM_SITE_ID
			    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL SAM
			      ON SAM.SEGMENT1 = B.COMPANY_ID
			     AND SAM.LOOKUP_TYPE = 'INTERNAL_TXN'
			   INNER JOIN DM_MST_ITEM_SINGLE_V C
			      ON A.DIVISION_ID = C.DIVISION_ID
			     AND A.ITEM_ID = C.ITEM_ID
			-- 20260906 DEPT_ID 기준으르 OWNER 에서 SCM_MST_SITE_ITEM 의 DEPT_ID 기준으로 변경			 
			LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D ON A.DEPT_ID = D.DEPT_ID 
			LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO E ON D.UPPER_DEPT_ID  = E.DEPT_ID
--			    LEFT JOIN (SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN
--					    , B.DEPT_ID, C.DEPT_NAME_KO, D.DEPT_ID AS DEPARTMENT_ID
--					    , D.DEPT_NAME_KO AS DEPARTMENT_NAME
--					 FROM SCM_MST_SSO_USER_INFO B
--					      INNER JOIN SCM_MST_SSO_DEPT_INFO C
--						 ON B.DEPT_ID = C.DEPT_ID
--					      INNER JOIN SCM_MST_SSO_DEPT_INFO D
--						 ON C.UPPER_DEPT_ID = D.DEPT_ID
--				      ) TEAM
--			      ON UPPER(TEAM.USER_ID) = REGEXP_SUBSTR(UPPER(A.OWNER), '[^,]+', 1, 1)
		     WHERE A.DIVISION_ID = '40'
		       AND B.SITE_TYPE = 'SALES'
		       AND NVL(C.FORECAST_INFO_BIZ_TYPE,'-') <> '-'
		       AND NVL(A.ATTRIBUTE2,'-') <> '-'
		       AND NVL(A.ATTRIBUTE1,'-') <> '-'
                       -- AND NVL(A.REPORT_GROUP3,'') <> '' -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP3 제거 (Oracle 마이그레이션 2026.05.22)
		     GROUP BY A.DIVISION_ID
-- 20260906 DEPT_ID 기준으르 OWNER 에서 SCM_MST_SITE_ITEM 의 DEPT_ID 기준으로 변경
		     , E.DEPT_ID
		     , E.DEPT_NAME_KO 
		     , A.DEPT_ID 
		     , D.DEPT_NAME_KO 
--		     , TEAM.DEPARTMENT_ID
--		     , TEAM.DEPARTMENT_NAME
--		     , TEAM.DEPT_ID
--		     , TEAM.DEPT_NAME_KO
			 , SAM.SEGMENT3
			 , A.ATTRIBUTE2
			 , A.ATTRIBUTE1
			 , A.REPORT_GROUP3
			 , C.FORECAST_INFO_BIZ_TYPE
		   ) SITE_ITEM
		 ON SITE_ITEM.DEPARTMENT_ID = CONTRIBUTE.DEPARTMENT_ID
		AND SITE_ITEM.DEPT_ID = CONTRIBUTE.DEPT_ID
		AND SITE_ITEM.END_CUST_REPORT = CONTRIBUTE.END_CUST_REPORT
		AND SITE_ITEM.SOLDTO_CUST_REPORT = CONTRIBUTE.SOLDTO_CUST_REPORT
                -- AND SITE_ITEM.PRODUCT_GROUP = CONTRIBUTE.PRODUCT_GROUP -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP3 제거로 조인키 제외 (Oracle 마이그레이션 2026.05.22)
		-- 2026.09.28 AJS 주석처리 (GAP-02 History 분기 기여율 키 PRODUCT_GROUP 대조 복원) (START)
		AND SITE_ITEM.PRODUCT_GROUP = CONTRIBUTE.PRODUCT_GROUP
		-- 2026.09.28 AJS 주석처리 (GAP-02 History 분기 기여율 키 PRODUCT_GROUP 대조 복원) (END)
		AND SITE_ITEM.DM_BIZ_TYPE = CONTRIBUTE.DM_BIZ_TYPE
	 WHERE SITE_ITEM.DIVISION_ID IS NULL;
    
        -- 연도 데이터
	INSERT INTO GT_DMF0043_TEMP3
	(VER_SEQ, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT,
	 PRODUCT_GROUP, DM_BIZ_TYPE, RATIO, COLUMN_NAME)
	SELECT MA.VER_SEQ
	     , MA.DEPARTMENT_ID
	     , MA.DEPT_ID
	     , MA.END_CUST_REPORT
	     , MA.SOLDTO_CUST_REPORT
	     , MA.PRODUCT_GROUP
	     , MA.DM_BIZ_TYPE
	     , TO_CHAR(DTL.CONTRIBUTION_RATIO) AS RATIO
	     , 'Y#' || p_yyyy || '#' || DTL.OS_CORP_CD AS COLUMN_NAME
	  FROM GT_DMF0043_DATA_TABLE MA
	       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DTL
		  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
		 AND MA.DEPT_ID = DTL.DEPT_ID
		 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
		 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
		 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
		 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
	 WHERE YYYYMM = v_thismm
	   AND MA.VER_SEQ = p_ver_seq

	UNION ALL

	SELECT MA.VER_SEQ
	     , MA.DEPARTMENT_ID
	     , MA.DEPT_ID
	     , MA.END_CUST_REPORT
	     , MA.SOLDTO_CUST_REPORT
	     , MA.PRODUCT_GROUP
	     , MA.DM_BIZ_TYPE
	     , TO_CHAR(DTL.CONTRIBUTION_TYPE) AS RATIO
	     , 'Y#' || p_yyyy || '#RBU_0999' AS COLUMN_NAME
	  FROM GT_DMF0043_DATA_TABLE MA
	       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DTL
		  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
		 AND MA.DEPT_ID = DTL.DEPT_ID
		 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
		 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
		 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
		 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
	 WHERE YYYYMM = v_thismm
	   AND MA.VER_SEQ = p_ver_seq

	UNION ALL

        -- 월 데이터
	SELECT MA.VER_SEQ
	     , MA.DEPARTMENT_ID
	     , MA.DEPT_ID
	     , MA.END_CUST_REPORT
	     , MA.SOLDTO_CUST_REPORT
	     , MA.PRODUCT_GROUP
	     , MA.DM_BIZ_TYPE
	     , TO_CHAR(DTL.CONTRIBUTION_RATIO) AS RATIO
	     , 'M#' || YYYYMM || '#' || OS_CORP_CD AS COLUMN_NAME
	  FROM GT_DMF0043_DATA_TABLE MA
	       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DTL
		  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
		 AND MA.DEPT_ID = DTL.DEPT_ID
		 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
		 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
		 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
		 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
	 WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
	   AND MA.VER_SEQ = p_ver_seq

	UNION ALL

	SELECT MA.VER_SEQ
	     , MA.DEPARTMENT_ID
	     , MA.DEPT_ID
	     , MA.END_CUST_REPORT
	     , MA.SOLDTO_CUST_REPORT
	     , MA.PRODUCT_GROUP
	     , MA.DM_BIZ_TYPE
	     , TO_CHAR(DTL.CONTRIBUTION_TYPE) AS RATIO
	     , 'M#' || YYYYMM || '#RBU_0999' AS COLUMN_NAME
	  FROM GT_DMF0043_DATA_TABLE MA
	       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DTL
		  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
		 AND MA.DEPT_ID = DTL.DEPT_ID
		 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
		 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
		 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
		 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
	 WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
	   AND MA.VER_SEQ = p_ver_seq ;
	-- select * from #temp
        -- ######################## 데이터 ########################

	v_Query := '
SELECT VER_SEQ
     , DEPARTMENT_ID
     , DEPT_ID
     , END_CUST_REPORT
     , SOLDTO_CUST_REPORT
     , PRODUCT_GROUP
     , DM_BIZ_TYPE
     , ''N'' AS EDIT_FLAG
     , ' || v_ColumnData || '
  FROM (SELECT *
	  FROM GT_DMF0043_TEMP3
      WHERE DEPARTMENT_ID IS NOT NULL) MA
 PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' || v_ColumnDataPivot || ')) PVT
 ORDER BY DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT, PRODUCT_GROUP, DM_BIZ_TYPE
 ';
    END IF;

    --SELECT CONVERT(TEXT, @Query)
    --FOR XML PATH('')--,ROOT('x')

    /* EXECUTE dbo.SP_EXECUTESQL @Query
       Oracle: SYS_REFCURSOR OUT 으로 결과셋 반환 */
    OPEN O_RC1 FOR v_Query;

EXCEPTION
    WHEN OTHERS THEN
	RAISE_APPLICATION_ERROR(-20001, $$PLSQL_UNIT || ' Error: ' || SQLERRM);
END P_DMF0043_GET_CONTRIBUTE_MAIN_DATA;

    -- [2026-09-15 UIPKG] standalone DMF0043_GET_CONTRIBUTION_SALES_LIST 취합
PROCEDURE P_DMF0043_GET_CONTRIBUTION_SALES_LIST 
(
    p_division_id      IN  VARCHAR2,
    p_ver_seq	       IN  VARCHAR2,
    p_version_no       IN  VARCHAR2,
    p_end_cust_report  IN  VARCHAR2,
    p_product_group    IN  VARCHAR2,
    p_biz_type	       IN  VARCHAR2,
    p_million_yn       IN  VARCHAR2,
    p_compatibility_yn IN  VARCHAR2,
    p_created_by       IN  VARCHAR2,
    O_RC1      OUT SYS_REFCURSOR,   -- 동적 SQL(@v_sql_text) 결과셋
    O_RC2      OUT SYS_REFCURSOR,   -- 정렬 정보 쿼리(@nsql2) 결과셋
    O_RC3       OUT SYS_REFCURSOR    -- CNT 결과셋
)
IS
/* 2026.05.20  ZIONEX	     [PJ202650304]  NextSCM Migration */

    v_sql_text		CLOB;
    v_code			VARCHAR2(4000 CHAR);
    v_large_code	VARCHAR2(4000 CHAR);
    v_small_code	VARCHAR2(4000 CHAR);
    v_groupby		VARCHAR2(4000 CHAR);
    v_orderby		VARCHAR2(4000 CHAR);
    v_col_name		VARCHAR2(50 CHAR);
    v_sort_order_no	VARCHAR2(50 CHAR);
    v_program_id	VARCHAR2(10 CHAR);
    v_sheet_name	VARCHAR2(100 CHAR);
    v_user_col_cnt	PLS_INTEGER;
    v_seq		PLS_INTEGER; 

    -- 동적쿼리에사용하는 컬럼 관련 ( CTE 문을 이용한 마지막 Select 문에서 사용 )
    v_col               VARCHAR2(4000 CHAR);            -- 일반 로우의 일반 컬럼
    v_col_sum           VARCHAR2(4000 CHAR) := '';      -- 일반로우의 합계컬럼 ( 국가별, commision/markup 구분별)
    v_bottom            VARCHAR2(4000 CHAR);            -- 합계로우의 일반컬럼
    v_bottom_sum        VARCHAR2(4000 CHAR) := '';      -- 합계로우의 합계컬럼 ( 국가별, commision/markup 구분별)
    v_col_total         VARCHAR2(4000 CHAR) := '';      -- Total 컬럼 ( 로우 구분 없음 - 수식이 동일해서 )

    nsql2               CLOB; -- order by 정보

    va_program_id	VARCHAR2(4000 CHAR);
    va_sheet_name	VARCHAR2(4000 CHAR);

--    /* c_title 커서 : 사용자/디폴트 컬럼 정의 */
--    CURSOR c_title IS
--	SELECT U.PROGRAM_ID
--	     , U.SHEET_NAME
--	     , U.COLUMN_NAME
--	     , U.SORT_ORDER_NO
--	FROM   SCM_MST_TITLESET_USER U
--	     , SCM_MST_SHEET_COLUMNS C
--	WHERE  1 = 1
--	AND    U.PROGRAM_ID  = C.PROGRAM_ID
--	AND    U.SHEET_NAME  = C.SHEET_NAME
--	AND    U.COLUMN_NAME = C.COLUMN_NAME
--	AND    U.PROGRAM_ID  = va_program_id
--	AND    U.SHEET_NAME  = va_sheet_name
--	AND    U.USER_ID     = p_created_by
--	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
--	UNION ALL
--	SELECT C.PROGRAM_ID
--	     , C.SHEET_NAME
--	     , C.COLUMN_NAME
--	     , C.SORT_ORDER_NO
--	FROM   SCM_MST_SHEET_COLUMNS C
--	WHERE  1 = 1
--	AND    C.PROGRAM_ID  = va_program_id
--	AND    C.SHEET_NAME  = va_sheet_name
--	AND    C.DEFAULT_FLAG = ''
--	AND    C.VALID_YN     = 'Y'
--	ORDER BY SORT_ORDER_NO;

--    /* c_code 커서 : 기여도 코드 매트릭스 */
--    CURSOR c_code IS
--	SELECT DISTINCT CODE, LARGE_CODE, SMALL_CODE, SEQ
--	FROM (
--	    SELECT
--		  L.SEGMENT1 || '#' || CASE WHEN L.SEGMENT4 = 'Y' THEN '' ELSE M.SEGMENT1 END AS CODE
--		, L.SEGMENT1  AS LARGE_CODE
--		, UPPER(CASE WHEN L.SEGMENT4 = 'Y' THEN L.SEGMENT1 ELSE M.SEGMENT1 END) AS SMALL_CODE
--		, RANK() OVER ( ORDER BY L.DISPLAY_SEQ, CASE WHEN L.SEGMENT4 = 'Y' THEN 0 ELSE M.DISPLAY_SEQ END ) AS SEQ
--	    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
--		,  SCM_ADM_LOOKUP_MASTER_DETAIL M
--	    WHERE  1 = 1
--	    AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
--	    AND    M.LOOKUP_TYPE = 'DM_CONTRIBUTION_TYPE_CD'
--	    AND    L.VALID_YN	 = 'Y'
--	    AND    L.SEGMENT3	 = 'Y'
--	    AND    M.VALID_YN	 = 'Y'
--	    ) A
--	ORDER BY A.SEQ;

BEGIN

    va_program_id := 'DMF0043';
    va_sheet_name := 'ContributeSalesList';

    v_col_name := '';
    v_col := '';
    v_groupby := '';
    v_user_col_cnt := 0;

    SELECT COUNT(*)
      INTO v_user_col_cnt
    FROM   SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = va_program_id
    AND    U.SHEET_NAME = va_sheet_name
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    U.USER_ID	= p_created_by;

    IF v_user_col_cnt = 0 THEN  -- patched 2026-06-01 TITLESET_USER PK index unusable workaround
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
		     , 'C'
		     , C.COLUMN_NAME
		     , C.SORT_ORDER_NO
		     , 'N'
		     , ''
		     , p_created_by
		     , SYSDATE
		     , p_created_by
		     , SYSDATE
		FROM   SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = va_program_id
		AND    C.SHEET_NAME  = va_sheet_name
		AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y' ;
    END IF;

    --정렬 정보 쿼리 add son young suk 20180727
    nsql2 := 'SELECT U.PROGRAM_ID
	     , U.SHEET_NAME
	     , U.COLUMN_NAME
	     , U.SORT_ORDER_NO
	     , U.DATA_SORT_METHOD_CODE
	FROM   SCM_MST_TITLESET_USER U
	     , SCM_MST_SHEET_COLUMNS C
	WHERE  1 = 1
	AND    U.PROGRAM_ID  = C.PROGRAM_ID
	AND    U.SHEET_NAME  = C.SHEET_NAME
	AND    U.COLUMN_NAME = C.COLUMN_NAME
	AND    U.PROGRAM_ID  = ''' || va_program_id ||'''
	AND    U.SHEET_NAME  = ''' || va_sheet_name ||'''
	AND    U.USER_ID     = ''' || p_created_by || '''
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = ''C''
	AND    C.VALID_YN = ''Y''
	AND  ''' || p_division_id || ''' IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(C.DIVISION_ID, '','')) )  -- 20190214
	UNION ALL
	SELECT C.PROGRAM_ID
	     , C.SHEET_NAME
	     , C.COLUMN_NAME
	     , C.SORT_ORDER_NO
	     , C.DATA_SORT_METHOD_CODE
	FROM   SCM_MST_SHEET_COLUMNS C
	WHERE  1 = 1
	AND    C.PROGRAM_ID  = ''' || va_program_id ||'''
	AND    C.SHEET_NAME  = ''' || va_sheet_name ||'''
	AND    C.DEFAULT_FLAG = ''-''	
	AND    C.VALID_YN     = ''Y''
	ORDER BY SORT_ORDER_NO';
    
    DECLARE  /* c_title 커서 : 사용자/디폴트 컬럼 정의 */
    CURSOR c_title IS
	SELECT U.PROGRAM_ID
	     , U.SHEET_NAME
	     , U.COLUMN_NAME
	     , U.SORT_ORDER_NO
	FROM   SCM_MST_TITLESET_USER U
	     , SCM_MST_SHEET_COLUMNS C
	WHERE  1 = 1
	AND    U.PROGRAM_ID  = C.PROGRAM_ID
	AND    U.SHEET_NAME  = C.SHEET_NAME
	AND    U.COLUMN_NAME = C.COLUMN_NAME
	AND    U.PROGRAM_ID  = va_program_id
	AND    U.SHEET_NAME  = va_sheet_name
	AND    U.USER_ID     = p_created_by
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
	UNION ALL
	SELECT C.PROGRAM_ID
	     , C.SHEET_NAME
	     , C.COLUMN_NAME
	     , C.SORT_ORDER_NO
	FROM   SCM_MST_SHEET_COLUMNS C
	WHERE  1 = 1
	AND    C.PROGRAM_ID  = va_program_id
	AND    C.SHEET_NAME  = va_sheet_name
	AND    C.DEFAULT_FLAG = '-'
	AND    C.VALID_YN     = 'Y'
	ORDER BY SORT_ORDER_NO;
    
    BEGIN

	    OPEN c_title;
	    LOOP
		FETCH c_title INTO v_program_id, v_sheet_name, v_col_name, v_sort_order_no;
		EXIT WHEN c_title%NOTFOUND;
	
	      IF v_col = '' OR v_col IS NULL THEN
		      v_col :=	'A.' || v_col_name;
		      v_groupby := ' GROUP BY A.' || v_col_name;
		      -- 2026.09.28 AJS 주석처리 (F-03 정렬 대소문자 무시) (START)
		      --v_orderby := ' ORDER BY ' || v_col_name;
		      v_orderby := ' ORDER BY NLSSORT(' || v_col_name || ', ''NLS_SORT=BINARY_CI'')';
		      -- 2026.09.28 AJS 주석처리 (F-03 정렬 대소문자 무시) (END)
	              -- 합계로우용
		      v_bottom := '''Total''';
	      ELSE
		      v_col := v_col || ', A.' || v_col_name;
		      v_groupby := v_groupby || ', A.' || v_col_name;
		      -- 2026.09.28 AJS 주석처리 (F-03 정렬 대소문자 무시) (START)
		      --v_orderby := v_orderby || ', ' || v_col_name;
		      v_orderby := v_orderby || ', NLSSORT(' || v_col_name || ', ''NLS_SORT=BINARY_CI'')';
		      -- 2026.09.28 AJS 주석처리 (F-03 정렬 대소문자 무시) (END)
	              -- 합계 로우 용
		      v_bottom := v_bottom || ', null';
	      END IF;
	    END LOOP;
	
	    CLOSE c_title;
    END;

    /* IF OBJECT_ID (N'tempdb..#tmp_plan_report_c', N'U') IS NOT NULL
	DROP TABLE #tmp_plan_report_c; */
    DELETE FROM GT_DMF0043_PLAN_REPORT_C;
    /*IF OBJECT_ID (N'tempdb..#tmp_sales_plan_c', N'U') IS NOT NULL
	DROP TABLE #tmp_sales_plan_c;
    IF OBJECT_ID (N'tempdb..#tmp_sales_result_c', N'U') IS NOT NULL
	DROP TABLE #tmp_sales_result_c;*/
    /* IF OBJECT_ID (N'tempdb..#tmp_sales_list_c', N'U') IS NOT NULL
	DROP TABLE #tmp_sales_list_c; */
    DELETE FROM GT_DMF0043_SALES_LIST_C;


	/*

    SELECT DIVISION_ID
	 , VERSION_NO
		 , PROJECT_CODE
	 , SCM_SITE_ID
	 , ITEM_ID
	 , YYYYMMDD
	 , QTY
      INTO #tmp_sales_plan_c
      FROM DM_PLN_SALES_PLAN_C WITH (NOLOCK)
     WHERE DIVISION_ID = @p_division_id
       AND VERSION_NO = @p_version_no
       AND MEASURE = 'SalesAmt_USD'
       AND SCM_SITE_ID NOT IN (SELECT SEGMENT1
				 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
                       WHERE LOOKUP_TYPE = 'INTERNAL_TXN')  -- 20190906 소거매출 제외
       AND YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WITH (NOLOCK) WHERE VER_SEQ = @p_ver_seq)+'%'
    ;




    SELECT PR.DIVISION_ID
	 , PR.VERSION_NO
	 , PR.PROJECT_CODE
	 , PR.SCM_SITE_ID
	 , PR.ITEM_ID
	 , PR.YYYYMMDD
	 , CASE WHEN ISNULL(FP.EXCHANGE_PRICE,0) = 0 THEN 0
		ELSE PR.QTY/ISNULL(FP.EXCHANGE_PRICE,0)
	   END AS QTY
      INTO #tmp_sales_result_c
      FROM DM_PLN_SALES_PLAN_RESULT_C PR WITH (NOLOCK)
	   LEFT OUTER JOIN DM_MST_EXCHANGE_RATE_C FP WITH (NOLOCK)
	     ON PR.DIVISION_ID = FP.DIVISION_ID
	    AND PR.VERSION_NO = FP.VERSION_NO
	    AND SUBSTRING(PR.YYYYMMDD,1,6)+'01' = FP.YYYYMMDD
	    AND FP.UNIT_CURRENCY = 'USD'
     WHERE PR.DIVISION_ID = @p_division_id
       AND PR.VERSION_NO = @p_version_no
       AND PR.MEASURE = 'SalesAmt_KRW'
       AND PR.SCM_SITE_ID NOT IN (SELECT SEGMENT1
				    FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
                                   WHERE LOOKUP_TYPE = 'INTERNAL_TXN')  -- 20190906 소거매출 제외
       AND PR.YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WITH (NOLOCK) WHERE VER_SEQ = @p_ver_seq)+'%'
    ;
	*/

    /* CREATE TABLE #tmp_plan_report_c ... → GT_DMF0043_PLAN_REPORT_C (GTT 사용) */

    IF ( p_version_no LIKE 'BP%') THEN
		INSERT INTO GT_DMF0043_PLAN_REPORT_C
		SELECT DIVISION_ID
		     , VERSION_NO
		     , PROJECT_CODE
		     , SCM_SITE_ID
		     , ITEM_ID
		     , YYYYMMDD
		     , QTY
		 FROM (
			   SELECT DIVISION_ID
			     , VERSION_NO
			     , PROJECT_CODE
			     , SCM_SITE_ID
			     , ITEM_ID
			     , YYYYMM AS YYYYMMDD
			     , QTY
			  FROM DM_PLN_BP_FCST_REPORT_C
			 WHERE DIVISION_ID = p_division_id
			   AND VERSION_NO = p_version_no
			   AND MEASURE = 'SalesAmt_USD'
			   AND SCM_SITE_ID NOT IN (
	                                            --SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'INTERNAL_TXN'  -- 20190906 소거매출 제외 -- 20200427 KHSONG 주석처리
	                                            SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN  -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
						    )
			   AND YYYYMM LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WHERE VER_SEQ = TO_NUMBER(p_ver_seq))||'%'
			   ) A;
    ELSE
		INSERT INTO GT_DMF0043_PLAN_REPORT_C
		SELECT DIVISION_ID
		     , VERSION_NO
		     , PROJECT_CODE
		     , SCM_SITE_ID
		     , ITEM_ID
		     , YYYYMMDD
		     , QTY
		 FROM ( SELECT DIVISION_ID
			     , VERSION_NO
			     , PROJECT_CODE
			     , SCM_SITE_ID
			     , ITEM_ID
			     , YYYYMMDD
			     , QTY
			  FROM DM_PLN_SALES_PLAN_REPORT_C
			 WHERE DIVISION_ID = p_division_id
			   AND VERSION_NO = p_version_no
			   AND MEASURE = 'SalesAmt_USD'
			   AND SCM_SITE_ID NOT IN (
	                                            --SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'INTERNAL_TXN'  -- 20190906 소거매출 제외 -- 20200427 KHSONG 주석처리
	                                            SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN  -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
						    )
			   AND YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WHERE VER_SEQ = TO_NUMBER(p_ver_seq))||'%'
			) A;
    END IF;

    INSERT INTO GT_DMF0043_SALES_LIST_C
      ( YYYYMM, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
      , CUST_REPORT, END_CUST_REPORT, SOLDTO_CUST_REPORT, SHIPTO_CODE
      , PRODUCT_GROUP, DM_BIZ_TYPE, AMT, EDIT_FLAG )
    SELECT *
      FROM
	  (SELECT /*+ LEADING(A) USE_HASH(I) USE_HASH(SC) USE_HASH(B) USE_HASH(C) USE_HASH(TEAM) DYNAMIC_SAMPLING(A 10) */ SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
-- 20260906 DEPT_ID 기준으르 OWNER 에서 SCM_MST_SITE_ITEM 의 DEPT_ID 기준으로 변경
	     , E.DEPT_ID  AS DEPARTMENT_ID
	     , E.DEPT_NAME_KO AS DEPARTMENT_NAME
	     , I.DEPT_ID AS DEPT_ID
	     , D.DEPT_NAME_KO AS DEPT_NAME	  
--	     , TEAM.DEPARTMENT_ID
--	     , TEAM.DEPARTMENT_NAME
--	     , TEAM.DEPT_ID
--	     , TEAM.DEPT_NAME_KO AS DEPT_NAME
         , NVL(I.REPORT_GROUP2,'-') AS CUST_REPORT 
	     , NVL(I.ATTRIBUTE2,'-') AS END_CUST_REPORT
	     , NVL(I.ATTRIBUTE1,'-') AS SOLDTO_CUST_REPORT
	     , NVL(SC.SHIPTO_CODE,'/') AS SHIPTO_CODE
         , NVL(I.REPORT_GROUP3,'-') AS PRODUCT_GROUP 
	     , NVL(C.FORECAST_INFO_BIZ_TYPE,'-') AS DM_BIZ_TYPE
	     , CASE WHEN NVL(p_million_yn,'N') = 'Y' THEN SUM(QTY)/1000000 ELSE SUM(QTY) END AS AMT
	     , 'Y' AS EDIT_FLAG
          FROM GT_DMF0043_PLAN_REPORT_C A --Inner join에서 Left join 으로 변경
		LEFT JOIN SCM_MST_SITE_ITEM I
		  ON A.DIVISION_ID = I.DIVISION_ID
		 AND A.PROJECT_CODE = I.PROJECT_CODE
		 AND A.SCM_SITE_ID = I.SCM_SITE_ID
		 AND A.ITEM_ID = I.ITEM_ID
		LEFT JOIN SCM_MST_SITE_CUSTOMER SC
		  ON SC.DIVISION_ID = I.DIVISION_ID
		 AND SC.SCM_SITE_ID = I.SCM_SITE_ID
		 AND SC.REP_YN	    = 'Y'
		LEFT JOIN SCM_MST_SITE B
		  ON A.DIVISION_ID = B.DIVISION_ID
		 AND A.SCM_SITE_ID = B.SCM_SITE_ID
		LEFT JOIN DM_MST_ITEM_SINGLE_V C
		  ON A.DIVISION_ID = C.DIVISION_ID
		 AND A.ITEM_ID = C.ITEM_ID
		 --AND ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') <> ''
-- 20260906 DEPT_ID 기준으르 OWNER 에서 SCM_MST_SITE_ITEM 의 DEPT_ID 기준으로 변경			 
		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D ON I.DEPT_ID = D.DEPT_ID 
		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO E ON D.UPPER_DEPT_ID  = E.DEPT_ID		 
--		LEFT JOIN (
--			SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
--			FROM SCM_MST_SSO_USER_INFO B
--			INNER JOIN SCM_MST_SSO_DEPT_INFO C
--			ON B.DEPT_ID = C.DEPT_ID
--			INNER JOIN SCM_MST_SSO_DEPT_INFO D
--			ON C.UPPER_DEPT_ID = D.DEPT_ID
--		    )  TEAM
----      ON TEAM.USER_ID = TRIM(SUBSTR(I.OWNER, 1, NVL(NULLIF(INSTR(I.OWNER, ','), 0) - 1, LENGTH(I.OWNER)))) --*[20260810] 아래로직으로대체
--	  ON UPPER(TEAM.USER_ID) = REGEXP_SUBSTR(UPPER(I.OWNER), '[^,]+', 1, 1)      
	 WHERE A.DIVISION_ID = p_division_id
	   AND A.VERSION_NO = p_version_no
	   AND A.YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WHERE VER_SEQ = TO_NUMBER(p_ver_seq))||'%'
	 GROUP BY SUBSTR(A.YYYYMMDD,1,6)
-- 20260906 DEPT_ID 기준으르 OWNER 에서 SCM_MST_SITE_ITEM 의 DEPT_ID 기준으로 변경
	     , E.DEPT_ID
	     , E.DEPT_NAME_KO 
	     , I.DEPT_ID 
	     , D.DEPT_NAME_KO 	 
--	     , TEAM.DEPARTMENT_ID
--	     , TEAM.DEPARTMENT_NAME
--	     , TEAM.DEPT_ID
--	     , TEAM.DEPT_NAME_KO
         , NVL(I.REPORT_GROUP2,'-') 
	     , NVL(I.ATTRIBUTE2,'-')
	     , NVL(I.ATTRIBUTE1,'-')
	     , NVL(SC.SHIPTO_CODE,'/')
         , NVL(I.REPORT_GROUP3,'-') 
	     , NVL(C.FORECAST_INFO_BIZ_TYPE,'-')
	     /*
	UNION ALL

	SELECT SUBSTRING(A.YYYYMMDD,1,6) AS YYYYMM
	     , TEAM.DEPARTMENT_ID
	     , TEAM.DEPARTMENT_NAME
	     , TEAM.DEPT_ID
	     , TEAM.DEPT_NAME_KO AS DEPT_NAME
             -- , ISNULL(I.REPORT_GROUP2,'') AS CUST_REPORT -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP2 제거 (Oracle 마이그레이션 2026.05.22)
	     , ISNULL(I.ATTRIBUTE2,'') AS END_CUST_REPORT
	     , ISNULL(I.ATTRIBUTE1,'') AS SOLDTO_CUST_REPORT
	     , ISNULL(SC.SHIPTO_CODE,'') AS SHIPTO_CODE
             -- , ISNULL(I.REPORT_GROUP3,'') AS PRODUCT_GROUP -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP3 제거 (Oracle 마이그레이션 2026.05.22)
	     , ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') AS DM_BIZ_TYPE
	     , CASE WHEN ISNULL(@p_million_yn,'N') = 'Y' THEN SUM(QTY)/1000000 ELSE SUM(QTY) END AS AMT
			 , 'Y' AS EDIT_FLAG
	  FROM #tmp_sales_result_c A WITH (NOLOCK)
	       INNER JOIN SCM_MST_SITE_ITEM I WITH (NOLOCK)
ON A.DIVISION_ID = I.DIVISION_ID
		 AND A.PROJECT_CODE = I.PROJECT_CODE
		 AND A.SCM_SITE_ID = I.SCM_SITE_ID
		 AND A.ITEM_ID = I.ITEM_ID
	       INNER JOIN SCM_MST_SITE_CUSTOMER SC WITH (NOLOCK)
		  ON SC.DIVISION_ID = I.DIVISION_ID
	    AND SC.SCM_SITE_ID = I.SCM_SITE_ID
		 AND SC.REP_YN	    = 'Y'
	       INNER JOIN SCM_MST_SITE B WITH (NOLOCK)
		  ON A.DIVISION_ID = B.DIVISION_ID
		 AND A.SCM_SITE_ID = B.SCM_SITE_ID
	       INNER JOIN DM_MST_ITEM_SINGLE_V C WITH (NOLOCK)
ON A.DIVISION_ID = C.DIVISION_ID
		 AND A.ITEM_ID = C.ITEM_ID
		 --AND ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') <> ''
	       LEFT JOIN (
			SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
			FROM [SCM_MST_SSO_USER_INFO] AS B WITH (NOLOCK)
			INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH (NOLOCK)
			ON B.DEPT_ID = C.DEPT_ID
			INNER JOIN SCM_MST_SSO_DEPT_INFO AS D WITH (NOLOCK)
			ON C.UPPER_DEPT_ID = D.DEPT_ID
		    ) AS TEAM
		    ON TEAM.USER_ID IN (SELECT TOP 1 TOKEN FROM [DBO].[STRING_SPLIT](I.OWNER, ','))
	 WHERE A.DIVISION_ID = @p_division_id
	   AND A.VERSION_NO = @p_version_no
	   AND A.YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WITH (NOLOCK) WHERE VER_SEQ = @p_ver_seq)+'%'
	 GROUP BY SUBSTRING(A.YYYYMMDD,1,6)
	     , TEAM.DEPARTMENT_ID
	     , TEAM.DEPARTMENT_NAME
	     , TEAM.DEPT_ID
	     , TEAM.DEPT_NAME_KO
             -- , ISNULL(I.REPORT_GROUP2,'') -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP2 제거 (Oracle 마이그레이션 2026.05.22)
	     , ISNULL(I.ATTRIBUTE2,'')
	     , ISNULL(I.ATTRIBUTE1,'')
	     , ISNULL(SC.SHIPTO_CODE,'')
             -- , ISNULL(I.REPORT_GROUP3,'') -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP3 제거 (Oracle 마이그레이션 2026.05.22)
	     , ISNULL(C.FORECAST_INFO_BIZ_TYPE,'')*/
	     ) A;
    
    /* c_code 커서 : 기여도 코드 매트릭스 */
    DECLARE CURSOR c_code IS
		SELECT DISTINCT CODE, LARGE_CODE, SMALL_CODE, SEQ
		FROM (
		    SELECT
			  L.SEGMENT1 || '#' || CASE WHEN L.SEGMENT4 = 'Y' THEN '' ELSE M.SEGMENT1 END AS CODE
			, L.SEGMENT1  AS LARGE_CODE
			, UPPER(CASE WHEN L.SEGMENT4 = 'Y' THEN L.SEGMENT1 ELSE M.SEGMENT1 END) AS SMALL_CODE
			, RANK() OVER ( ORDER BY L.DISPLAY_SEQ, CASE WHEN L.SEGMENT4 = 'Y' THEN 0 ELSE M.DISPLAY_SEQ END ) AS SEQ
		    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
			,  SCM_ADM_LOOKUP_MASTER_DETAIL M
		    WHERE  1 = 1
		    AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
		    AND    M.LOOKUP_TYPE = 'DM_CONTRIBUTION_TYPE_CD'
		    AND    L.VALID_YN	 = 'Y'
		    AND    L.SEGMENT3	 = 'Y'
		    AND    M.VALID_YN	 = 'Y'
		    ) A
		ORDER BY A.SEQ;
    BEGIN
	    v_sql_text := '
	WITH SALES_LIST AS (
	    SELECT A.YYYYMM
		 , A.DEPARTMENT_NAME
		 , A.DEPT_NAME
		 , A.DEPARTMENT_ID
		 , A.DEPT_ID
	     , A.CUST_REPORT
		 , A.END_CUST_REPORT
		 , A.SOLDTO_CUST_REPORT
		 , A.SHIPTO_CODE
		 , A.PRODUCT_GROUP
		 , A.DM_BIZ_TYPE
		 , A.EDIT_FLAG ';
	
	    OPEN c_code;
	    LOOP
	        FETCH c_code INTO v_code, v_large_code, v_small_code, v_seq; -- v_seq 는 사용하지 않음. 커서문에서 distinct 를 넣기 위해 사용
		EXIT WHEN c_code%NOTFOUND;
	
		v_sql_text := v_sql_text || '
		 , SUM(CASE WHEN NVL(B.CONTRIBUTION_RATIO,0) > 0 AND B.CONTRIBUTION_TYPE = ''' || v_small_code || ''' AND B.OS_CORP_CD = ''' || v_large_code || '''
				 THEN B.CONTRIBUTION_RATIO/100*A.AMT
			    ELSE 0
		       END) AS ' || v_code || ' ';
	
	--select @v_code
	
	        -- 행별합계
		IF v_code NOT LIKE '%Total%' THEN
		    v_col_sum := v_col_sum || ', SUM('||v_code||') AS ' || v_code;
		    v_bottom_sum := v_bottom_sum || ', SUM('||v_code||') AS ' || v_code;
		END IF;
	
	        ---- 컬럼합계 ( Total )
	        IF v_code NOT LIKE '%Total%' THEN   -- Total 이 아닌 컬럼에서는 SUM 을 구성하고
		    v_col_total := v_col_total ||  CASE WHEN v_col_total = '' THEN '' ELSE ' +' END || 'NVL(SUM(' || v_code || '), 0)';
	        ELSE                                -- Total 컬럼에서는 AS 를 붙여서 마무리
		    v_col_total := v_col_total || ' AS ' || v_code;
		END IF;
	
	-- select @v_col_Sum as v_sum_column, @v_code as v_code, @v_col_Total, @v_ttsum_column_com
	    END LOOP;
	
	    CLOSE c_code;
    
    END;


    v_sql_text := v_sql_text || '
      FROM GT_DMF0043_SALES_LIST_C A
INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL B
	      ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
	     AND A.DEPT_ID = B.DEPT_ID
	     AND A.END_CUST_REPORT = B.END_CUST_REPORT
	     AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
	     AND A.PRODUCT_GROUP = B.PRODUCT_GROUP /* 2026.08.12 AJS */
	     AND A.DM_BIZ_TYPE = B.DM_BIZ_TYPE /* 2026.08.12 AJS */
	     AND A.YYYYMM = B.YYYYMM
     WHERE B.VER_SEQ = ' || p_ver_seq || '
     [@v_end_cust_report]
     [@v_product_group]
     [@v_biz_type]
     ';

     v_sql_text := v_sql_text || '
     GROUP BY A.YYYYMM
	 , A.DEPARTMENT_NAME
	 , A.DEPT_NAME
	 , A.DEPARTMENT_ID
	 , A.DEPT_ID
	 , A.CUST_REPORT
	 , A.END_CUST_REPORT
	 , A.SOLDTO_CUST_REPORT
	 , A.SHIPTO_CODE
	 , A.PRODUCT_GROUP
	 , A.DM_BIZ_TYPE
	 , A.EDIT_FLAG
)

SELECT [@v_col]  [@v_col_Sum],' || v_col_total || '
FROM   SALES_LIST A
[@v_groupby]
UNION ALL	--합계행
SELECT [@v_bottom] [@v_bottom_Sum],' || v_col_total || '
FROM   SALES_LIST A
[@v_orderby]
';


--    SET @v_sql_text = REPLACE(@v_sql_text,'[@v_end_cust_report]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('A.END_CUST_REPORT'	, 'IN', @p_end_cust_report));
    v_sql_text := REPLACE(v_sql_text,'[@v_end_cust_report]'  , ' AND UPPER(A.END_CUST_REPORT) LIKE ''%' || UPPER(p_end_cust_report) || '%'' '); --260820 조회조건 Upper 처리
    v_sql_text := REPLACE(v_sql_text,'[@v_product_group]'  , FN_SCM_GET_WHERE_SQL('A.PRODUCT_GROUP'  , 'IN', p_product_group));
    v_sql_text := REPLACE(v_sql_text,'[@v_biz_type]'  , FN_SCM_GET_WHERE_SQL('A.DM_BIZ_TYPE'  , 'IN', p_biz_type));
    v_sql_text := REPLACE(v_sql_text,'[@v_col]'  , v_col);
    v_sql_text := REPLACE(v_sql_text,'[@v_bottom]'  , v_bottom);
    v_sql_text := REPLACE(v_sql_text,'[@v_col_Sum]'  , v_col_sum);
 --   SET @v_sql_text = REPLACE(@v_sql_text,'[@v_col_Sum]'  , @v_col_Sum);
 --   SET @v_sql_text = REPLACE(@v_sql_text,'[@v_col_Sum]'  , @v_col_Sum);
    v_sql_text := REPLACE(v_sql_text,'[@v_bottom_Sum]'	, v_bottom_sum);
    v_sql_text := REPLACE(v_sql_text,'[@v_groupby]'  , v_groupby);
    -- 2026.09.28 AJS 주석처리 (F-03 복합 질의 바깥에서 정렬 — 표현식 정렬 ORA-01785 회피) (START)
    --v_sql_text := REPLACE(v_sql_text,'[@v_orderby]'  , v_orderby);
    v_sql_text := REPLACE(v_sql_text,'[@v_orderby]'  , '');
    v_sql_text := 'SELECT * FROM (' || v_sql_text || ') XA ' || v_orderby;
    -- 2026.09.28 AJS 주석처리 (F-03 복합 질의 바깥에서 정렬 — 표현식 정렬 ORA-01785 회피) (END)

    --select @v_col;
    --select @v_sql_text;
    --return;
    BEGIN
      OPEN O_RC1 FOR v_sql_text;
    EXCEPTION WHEN OTHERS THEN
      BEGIN OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;
    END;
    BEGIN
      OPEN O_RC2 FOR nsql2;
    EXCEPTION WHEN OTHERS THEN
      BEGIN OPEN O_RC2 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;
    END;

    IF NVL(p_compatibility_yn,'N') = 'Y' THEN
	OPEN O_RC3 FOR
	SELECT
            -- 등록이 안된 건 count
	    (SELECT COUNT(*)
	      FROM (SELECT 
-- 20260906 DEPT_ID 기준으르 OWNER 에서 SCM_MST_SITE_ITEM 의 DEPT_ID 기준으로 변경
		     E.DEPT_ID  AS DEPARTMENT_ID
		     , A.DEPT_ID AS DEPT_ID		     
--	      	TEAM.DEPARTMENT_ID
--			 , TEAM.DEPT_ID AS DEPT_ID
			 , NVL(A.ATTRIBUTE2,'-') AS END_CUST_REPORT
			 , NVL(A.ATTRIBUTE1,'-') AS SOLDTO_CUST_REPORT
             , NVL(A.REPORT_GROUP3,'-') AS PRODUCT_GROUP 
			 , NVL(C.FORECAST_INFO_BIZ_TYPE,'-') AS DM_BIZ_TYPE
		      FROM SCM_MST_SITE_ITEM A
			   INNER JOIN SCM_MST_SITE B
			      ON A.DIVISION_ID = B.DIVISION_ID
			     AND A.SCM_SITE_ID = B.SCM_SITE_ID
			   INNER JOIN DM_MST_ITEM_SINGLE_V C
			      ON A.DIVISION_ID = C.DIVISION_ID
			     AND A.ITEM_ID = C.ITEM_ID
-- 20260906 DEPT_ID 기준으르 OWNER 에서 SCM_MST_SITE_ITEM 의 DEPT_ID 기준으로 변경			 
			   LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D ON A.DEPT_ID = D.DEPT_ID 
			   LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO E ON D.UPPER_DEPT_ID  = E.DEPT_ID			     
--			   LEFT JOIN (
--				    SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
--					     , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
--				      FROM SCM_MST_SSO_USER_INFO B
--				INNER JOIN SCM_MST_SSO_DEPT_INFO C
--				        ON B.DEPT_ID = C.DEPT_ID
--			    INNER JOIN SCM_MST_SSO_DEPT_INFO D
--		                ON C.UPPER_DEPT_ID = D.DEPT_ID
--				     )	TEAM
----			      ON TEAM.USER_ID = TRIM(SUBSTR(A.OWNER, 1, NVL(NULLIF(INSTR(A.OWNER, ','), 0) - 1, LENGTH(A.OWNER))))
--				  ON UPPER(TEAM.USER_ID) = REGEXP_SUBSTR(UPPER(A.OWNER), '[^,]+', 1, 1) 
		     WHERE A.DIVISION_ID = p_division_id
		       AND B.SITE_TYPE = 'SALES'
		       AND NVL(C.FORECAST_INFO_BIZ_TYPE,'-') <> '-'
		       AND NVL(A.ATTRIBUTE2,'-') <> '-'
		       AND NVL(A.ATTRIBUTE1,'-') <> '-'
               AND NVL(A.REPORT_GROUP3,'-') <> '-' -- 2026.08.12 AJS
		     GROUP BY A.DIVISION_ID
-- 20260906 DEPT_ID 기준으르 OWNER 에서 SCM_MST_SITE_ITEM 의 DEPT_ID 기준으로 변경
		     , E.DEPT_ID--  DEPARTMENT_ID
		     , A.DEPT_ID 
--			 , TEAM.DEPARTMENT_ID
--			 , TEAM.DEPT_ID
			 , NVL(A.ATTRIBUTE2,'-')
			 , NVL(A.ATTRIBUTE1,'-')
             , NVL(A.REPORT_GROUP3,'-') -- 2026.08.12 AJS
			 , NVL(C.FORECAST_INFO_BIZ_TYPE,'-')
		   ) LIST
		  LEFT OUTER JOIN DM_MST_CONTRIBUTE_RATIO_MST RATIO
		    ON LIST.DEPARTMENT_ID = RATIO.DEPARTMENT_ID
		   AND LIST.DEPT_ID = RATIO.DEPT_ID
		   AND LIST.END_CUST_REPORT = RATIO.END_CUST_REPORT
		   AND LIST.SOLDTO_CUST_REPORT = RATIO.SOLDTO_CUST_REPORT
		   AND LIST.PRODUCT_GROUP = RATIO.PRODUCT_GROUP
		   AND LIST.DM_BIZ_TYPE = RATIO.DM_BIZ_TYPE
	     WHERE RATIO.DEPARTMENT_ID IS NULL
	       AND RATIO.VER_SEQ = TO_NUMBER(p_ver_seq))
	       +
            -- 100%가 안되는 건 COUNT
	    (SELECT COUNT(*)
	      FROM (SELECT SUM(A.CONTRIBUTION_RATIO) AS RATIO
		      FROM DM_MST_CONTRIBUTE_RATIO_MST M
			   INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL A
			      ON M.VER_SEQ = A.VER_SEQ
			     AND M.DEPARTMENT_ID = A.DEPARTMENT_ID
			     AND M.DEPT_ID = A.DEPT_ID
			     AND M.END_CUST_REPORT = A.END_CUST_REPORT
			     AND M.SOLDTO_CUST_REPORT = A.SOLDTO_CUST_REPORT
			     AND M.PRODUCT_GROUP = A.PRODUCT_GROUP
			     AND M.DM_BIZ_TYPE = A.DM_BIZ_TYPE
		     WHERE A.VER_SEQ = TO_NUMBER(p_ver_seq)
		     GROUP BY A.DEPARTMENT_ID
			    , A.DEPT_ID
			    , A.END_CUST_REPORT
			    , A.SOLDTO_CUST_REPORT
			    , A.PRODUCT_GROUP
			    , A.DM_BIZ_TYPE
			    , A.YYYYMM
		   ) R
	     WHERE R.RATIO <> 100)
	    +
	    (
	     SELECT COUNT(*)
	      FROM GT_DMF0043_SALES_LIST_C A
	    left outer JOIN DM_MST_CONTRIBUTE_RATIO_DTL B
			  ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
			 AND A.DEPT_ID = B.DEPT_ID
			 AND A.END_CUST_REPORT = B.END_CUST_REPORT
			 AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
			 AND A.PRODUCT_GROUP = B.PRODUCT_GROUP -- 2026.08.12 AJS
			 AND A.DM_BIZ_TYPE = B.DM_BIZ_TYPE -- 2026.08.12 AJS
			 AND A.YYYYMM = B.YYYYMM
			 and B.VER_SEQ = 2
		 WHERE A.END_CUST_REPORT LIKE '%%'
		  and b.dept_id is null
		) AS CNT
	FROM DUAL;
    ELSE
	OPEN O_RC3 FOR
	SELECT 0 AS CNT FROM DUAL;
    END IF;

-- --xml확인할경우
--SELECT CONVERT(TEXT, @v_sql_text)
--FOR XML PATH('')--,ROOT('x')


 /*
select max(version_no) from dm_pln_sales_plan_c with (nolock);

select * from DM_MST_CONTRIBUTE_VER where version_no = 'SP_W_20190905_V001'


EXEC DMF0043_GET_CONTRIBUTION_SALES_LIST


EXEC [dbo].[DMF0043_GET_CONTRIBUTION_SALES_LIST]

 */


EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[outer] ' || SQLERRM || ' / BT=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    BEGIN IF NOT O_RC1%ISOPEN THEN OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF NOT O_RC2%ISOPEN THEN OPEN O_RC2 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF NOT O_RC3%ISOPEN  THEN OPEN O_RC3  FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
END P_DMF0043_GET_CONTRIBUTION_SALES_LIST;

END PKG_DMF0043;