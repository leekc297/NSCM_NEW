-- PKG_SCP0100 — 생성: tools/Harness/gen-pkg.js 2026-10-20 · 화면 SCP0100→SCP0100 Global_PSI_Report · As-is SP 3개
-- 이식 규칙: Doc/_dev_rules(DB 변환 규칙) · To-be_v2_converted/06_Packages 선례 · ISNULL→NVL, GETDATE→SYSDATE, TOP n→FETCH FIRST n ROWS ONLY, +(문자열)→||, CONVERT→TO_CHAR/TO_DATE, 임시테이블→GTT/WITH, @@ROWCOUNT→SQL%ROWCOUNT · ⭐ 널 센티널 = '/' (ISNULL(x,'')→NVL(x,'/') · 원래 '-' 데이터 유지 · 과도기 빈값 IN ('-','/') — 사용자 2026-10-15, check-pkg P39/P40, port_pkg.md §센티널)
-- 배포 후: SCP0100_registration.sql 재실행(PROC_M 이 ALL_ARGUMENTS 로 확정) → FE pnpm gen:procedures
CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SCP0100
AS
    PROCEDURE P_SCP0100_GET_SHEET_CALENDAR_3SPAN (
        P_START_YYYYMMDD IN  VARCHAR2,  -- As-is @p_start_yyyymmdd nvarchar(16)
        P_END_YYYYMMDD   IN  VARCHAR2,  -- As-is @p_end_yyyymmdd nvarchar(16)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0100_GET_SITE (
        P_SITE_TPYE      IN  VARCHAR2,  -- As-is @p_site_tpye nvarchar(-1)
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(-1)
        P_BUCKET         IN  VARCHAR2,  -- As-is @p_bucket nvarchar(-1)
        O_RC1            OUT SYS_REFCURSOR,
        O_RC2            OUT SYS_REFCURSOR,
        O_RC3            OUT SYS_REFCURSOR,
        O_RC4            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0100_GET_PLAN_DATE (
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(-1)
        P_BUCKET         IN  VARCHAR2,  -- As-is @p_bucket nvarchar(-1)
        P_PROGRAM_ID     IN  VARCHAR2,  -- As-is @p_program_id nvarchar(-1)
        O_RC1            OUT SYS_REFCURSOR,
        O_RC2            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );
END PKG_SCP0100;
/

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SCP0100
AS
/*
 * Program ID   : P_SCP0100_GET_SHEET_CALENDAR_3SPAN
 * Description  : SCP0100 Global_PSI_Report — As-is SCP0100_GET_SHEET_CALENDAR_3SPAN 이식 (GET, 시트 'calendar' / 버튼 SEARCH)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.20   harness        [TobeGen] 골격 생성 — SQL 본문 이식 TODO
 */
PROCEDURE P_SCP0100_GET_SHEET_CALENDAR_3SPAN (
        P_START_YYYYMMDD IN  VARCHAR2,  -- As-is @p_start_yyyymmdd nvarchar(16)
        P_END_YYYYMMDD   IN  VARCHAR2,  -- As-is @p_end_yyyymmdd nvarchar(16)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    -- 필수값 검사(As-is 에서 NOT NULL 로 쓰이는 파라미터만 남길 것)
    IF P_START_YYYYMMDD IS NULL THEN RAISE_INVALID('START_YYYYMMDD IS NULL'); END IF;

    OPEN O_RC1 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0100_GET_SHEET_CALENDAR_3SPAN 결과셋 1 (컬럼: COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, DAY_CODE, SORT_ORDER_NO)

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0100_GET_SHEET_CALENDAR_3SPAN] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_START_YYYYMMDD='||P_START_YYYYMMDD||','||'P_END_YYYYMMDD='||P_END_YYYYMMDD);
END P_SCP0100_GET_SHEET_CALENDAR_3SPAN;

/* ===== ASIS SCP0100_GET_SHEET_CALENDAR_3SPAN (dbo) — 이식 후 이 블록은 삭제 =====
/****************************************************************************************************
* Program ID  : SCP0070_GET_SHEET_CALENDAR_3SPAN     => SCP0100_GET_SHEET_CALENDAR_3SPAN                                                 
* Description : SCP 칼렌더 생성위한 프로시저                                                       
* Usage       : exec SCP0100_GET_SHEET_CALENDAR_3SPAN													
* Parameter   : @p_start_yyyymmdd='2017-12-25'                                                     
*               @p_end_yyyymmdd='20180130'                                                         
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2023/10/17  vadabi3			Initial Release  
* ex)
* EXEC SCP0100_GET_SHEET_CALENDAR_3SPAN @p_start_yyyymmdd ='20230101' , @p_end_yyyymmdd='20231231'
**************************************************************************************************** /

CREATE PROCEDURE [dbo].[SCP0100_GET_SHEET_CALENDAR_3SPAN]
	@p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;
	/*
--------------------------------------------------------------------------------------------
-- DEFAULT
    SELECT 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
        , A.PARTIAL_WEEK_NAME          AS COLUMN_LABEL_NAME   
        , A.PARTIAL_WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
        , A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME 
        , ''                   AS DAY_CODE
	    , A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
    GROUP BY A.BASIS_YYYYMM
            , A.ISO_WEEK 
            , A.PARTIAL_WEEK_NAME
            , A.MONTH_NAME        
            , A.BASIS_START_DATE
--------------------------------------------------------------------------------------------
-- 1차 적용
	SELECT 'W_' + (A.ISO_YYYYWW+REPLACE(A.PARTIAL_WEEK_NAME,'W',''))   AS COLUMN_NAME
		 , (REPLACE(MAX(A.PARTIAL_WEEK_NAME),'W',''))           AS COLUMN_LABEL_NAME   
		 ,  'W_' +(REPLACE(MAX(A.PARTIAL_WEEK_NAME),'W',''))           AS SMALL_CLASS_LABEL_NAME   
		 , MAX(A.MONTH_NAME)         AS LARGE_CLASS_LABEL_NAME 
		 , ''                   AS DAY_CODE
		 , MAX(A.ISO_YYYYWW) + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
	FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
	WHERE  A.BASIS_YYYYMMDD >= '20230101' 
	AND    A.BASIS_YYYYMMDD <= '20231231' 
	GROUP BY (A.ISO_YYYYWW +REPLACE(A.PARTIAL_WEEK_NAME,'W','')) 

	-- 2차 적용
	SELECT 'W_' + (A.ISO_YYYYWW + SUBSTRING(PARTIAL_WEEK_NAME,4,1))		AS COLUMN_NAME
		 , (A.ISO_YYYYWW + SUBSTRING(PARTIAL_WEEK_NAME,4,1))            AS COLUMN_LABEL_NAME   
		 ,  'W_' + (A.ISO_YYYYWW + SUBSTRING(PARTIAL_WEEK_NAME,4,1))    AS SMALL_CLASS_LABEL_NAME   
		 , MAX(A.MONTH_NAME)         AS LARGE_CLASS_LABEL_NAME 
		 , ''                        AS DAY_CODE
		 , MAX(A.ISO_YYYYWW) + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
	FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
	GROUP BY (A.ISO_YYYYWW + SUBSTRING(PARTIAL_WEEK_NAME,4,1)) 
		
--------------------------------------------------------------------------------------------
-- 2차 적용		
	SELECT  'W_' + WEEK_NAME  AS COLUMN_NAME
		 , WEEK_NAME   AS COLUMN_LABEL_NAME   
		 ,  'W_' + MAX(PARTIAL_WEEK_NAME)  AS SMALL_CLASS_LABEL_NAME   
		 , MAX(MONTH_NAME)  AS LARGE_CLASS_LABEL_NAME 
		 , ''               AS DAY_CODE
		 , MAX(SORT_ORDER_NO) AS SORT_ORDER_NO
	FROM
	(

		SELECT ISO_YYYYWW
			 , REPLACE(PARTIAL_WEEK_NAME, 'W','') AS PARTIAL_WEEK_NAME
			 , MONTH_NAME
			 ,CONCAT(BASIS_YYYYMM, SUBSTRING(PARTIAL_WEEK_NAME,2,2),SUBSTRING(PARTIAL_WEEK_NAME,4,1) ) AS WEEK_NAME
			 ,CONCAT(ISO_YYYYWW, PARTIAL_WEEK_NAME) AS SORT_ORDER_NO
		FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)
		WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
		AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
	) DATA
	GROUP BY WEEK_NAME	
--------------------------------------------------------------------------------------------
-- 3차 적용		
    SELECT 'W_' + concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3))   AS COLUMN_NAME
        , concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3))        AS COLUMN_LABEL_NAME   
        , 'W_' + SUBSTRING(concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3)) ,3,8)       AS SMALL_CLASS_LABEL_NAME
        , max(MONTH_NAME)         AS LARGE_CLASS_LABEL_NAME 
        , ''                   AS DAY_CODE
		    , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '21') AS SORT_ORDER_NO
    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
    GROUP BY concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3))	
	
	
		
	* /


    SELECT 'W_' + concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3))   AS COLUMN_NAME
        , concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3))			AS COLUMN_LABEL_NAME   
        , CASE WHEN MAX( SUBSTRING(PARTIAL_WEEK_NAME,4,1)) != ''
		       THEN MAX(  concat(SUBSTRING(PARTIAL_WEEK_NAME,1,3) ,'_', SUBSTRING(PARTIAL_WEEK_NAME,4,1))  ) 
			   ELSE MAX(PARTIAL_WEEK_NAME)
			   END AS SMALL_CLASS_LABEL_NAME
        , max(MONTH_NAME)									AS LARGE_CLASS_LABEL_NAME 
        , MIN(A.BASIS_START_DATE)							AS DAY_CODE
		, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '21')	AS SORT_ORDER_NO
    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
    GROUP BY concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3))


    UNION ALL

    SELECT 'M_' + A.BASIS_YYYYMM			AS COLUMN_NAME
            , A.MONTH_NAME					AS COLUMN_LABEL_NAME
		    , A.MONTH_NAME					AS SMALL_CLASS_LABEL_NAME
		    , A.MONTH_NAME					AS LARGE_CLASS_LABEL_NAME
		    , MIN(A.BASIS_START_DATE)       AS DAY_CODE
		    , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '02') AS SORT_ORDER_NO
    FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
    GROUP BY A.BASIS_YYYYMM
            , A.MONTH_NAME	

	ORDER BY sort_order_no

END
===== END ASIS ===== */

/*
 * Program ID   : P_SCP0100_GET_SITE
 * Description  : SCP0100 Global_PSI_Report — As-is SCP0100_GET_SITE 이식 (GET, 시트 'REPORT' / 버튼 SITE)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.20   harness        [TobeGen] 골격 생성 — SQL 본문 이식 TODO
 */
PROCEDURE P_SCP0100_GET_SITE (
        P_SITE_TPYE      IN  VARCHAR2,  -- As-is @p_site_tpye nvarchar(-1)
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(-1)
        P_BUCKET         IN  VARCHAR2,  -- As-is @p_bucket nvarchar(-1)
        O_RC1            OUT SYS_REFCURSOR,
        O_RC2            OUT SYS_REFCURSOR,
        O_RC3            OUT SYS_REFCURSOR,
        O_RC4            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    -- 필수값 검사(As-is 에서 NOT NULL 로 쓰이는 파라미터만 남길 것)
    IF P_SITE_TPYE IS NULL THEN RAISE_INVALID('SITE_TPYE IS NULL'); END IF;

    OPEN O_RC1 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0100_GET_SITE 결과셋 1 (컬럼: CODE, NAME)

    OPEN O_RC2 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0100_GET_SITE 결과셋 2

    OPEN O_RC3 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0100_GET_SITE 결과셋 3

    OPEN O_RC4 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0100_GET_SITE 결과셋 4

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0100_GET_SITE] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_SITE_TPYE='||P_SITE_TPYE||','||'P_DIVISION_ID='||P_DIVISION_ID||','||'P_BUCKET='||P_BUCKET);
END P_SCP0100_GET_SITE;

/* ===== ASIS SCP0100_GET_SITE (dbo) — 이식 후 이 블록은 삭제 =====
/****************************************************************************************************
* Program ID  : UP_FX_GetCommonDataList) FromSiteByDivision  ->   SCP0100_GET_SITE                                           
* Description : SCP 칼렌더 생성위한 프로시저                                                                                                              
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2023/10/17  vadabi3			Initial Release  
* 2024.08.21   cys     			고도화(JV 사업부 포함)
* ex)
* EXEC SCP0100_GET_SITE @p_site_tpye='FROM_SITE', @p_division_id='81', @p_bucket='MONTHLY'
**************************************************************************************************** /

CREATE PROCEDURE [dbo].[SCP0100_GET_SITE]
	@p_site_tpye NVARCHAR(MAX)  = 'FROM_SITE'
   ,@p_division_id NVARCHAR(MAX) = '81'
   ,@p_bucket NVARCHAR(MAX) = 'MONTHLY'
AS
BEGIN
	SET NOCOUNT ON;

	IF @p_site_tpye =  'FROM_SITE'
	BEGIN


			IF @p_bucket =  'MONTHLY'
			BEGIN
				SELECT FROM_SITE AS CODE
					 , FROM_SITE AS NAME
				FROM SCP_RPT_GLOBAL_PSI_MD_MM
				WHERE 1=1
				AND (
	   			  		(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			  		OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   			  	   )---고도화
	   			  AND  DIVISION_ID LIKE '81%'---고도화
				GROUP BY FROM_SITE
				ORDER BY FROM_SITE
			END
			ELSE IF @p_bucket =  'WEEKLY'
			BEGIN
				SELECT FROM_SITE AS CODE
					 , FROM_SITE AS NAME
				FROM SCP_RPT_GLOBAL_PSI_MD_WW
				WHERE 1=1
				AND (
	   			  		(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			  		OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   			  	   )---고도화
	   			AND  DIVISION_ID LIKE '81%'---고도화
				GROUP BY FROM_SITE
				ORDER BY FROM_SITE
			END




	END

	ELSE IF @p_site_tpye =  'TO_SITE'
	BEGIN
			IF @p_bucket =  'MONTHLY'
			BEGIN
				SELECT TO_SITE AS CODE
					 , TO_SITE AS NAME
				FROM SCP_RPT_GLOBAL_PSI_MD_MM
				WHERE 1=1
				AND (
	   			  		(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			  		OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   			  	   )---고도화
	   			AND  DIVISION_ID LIKE '81%'---고도화
				GROUP BY TO_SITE
				ORDER BY TO_SITE
			END
			ELSE IF @p_bucket =  'WEEKLY'
			BEGIN
				SELECT TO_SITE AS CODE
					 , TO_SITE AS NAME
				FROM SCP_RPT_GLOBAL_PSI_MD_WW
				WHERE 1=1
				AND (
	   			  		(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			  		OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   			  	   )---고도화
	   			AND  DIVISION_ID LIKE '81%'---고도화
				GROUP BY TO_SITE
				ORDER BY TO_SITE
			END
	END

END
===== END ASIS ===== */

/*
 * Program ID   : P_SCP0100_GET_PLAN_DATE
 * Description  : SCP0100 Global_PSI_Report — As-is SCP0100_GET_PLAN_DATE 이식 (GET, 시트 'REPORT' / 버튼 SEARCH)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.20   harness        [TobeGen] 골격 생성 — SQL 본문 이식 TODO
 */
PROCEDURE P_SCP0100_GET_PLAN_DATE (
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(-1)
        P_BUCKET         IN  VARCHAR2,  -- As-is @p_bucket nvarchar(-1)
        P_PROGRAM_ID     IN  VARCHAR2,  -- As-is @p_program_id nvarchar(-1)
        O_RC1            OUT SYS_REFCURSOR,
        O_RC2            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    -- 필수값 검사(As-is 에서 NOT NULL 로 쓰이는 파라미터만 남길 것)
    IF P_DIVISION_ID IS NULL THEN RAISE_INVALID('DIVISION_ID IS NULL'); END IF;

    OPEN O_RC1 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0100_GET_PLAN_DATE 결과셋 1

    OPEN O_RC2 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0100_GET_PLAN_DATE 결과셋 2

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0100_GET_PLAN_DATE] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_DIVISION_ID='||P_DIVISION_ID||','||'P_BUCKET='||P_BUCKET||','||'P_PROGRAM_ID='||P_PROGRAM_ID);
END P_SCP0100_GET_PLAN_DATE;

/* ===== ASIS SCP0100_GET_PLAN_DATE (dbo) — 이식 후 이 블록은 삭제 =====
/****************************************************************************************************
* Program ID  : SCP0100_GET_PLAN_DATE) UP_FX_GetCommonDataList > DATE_WEEKLY 참고                                          
* Description : SCP Plan date                                                                                                             
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2023/11/22  vadabi3			Initial Release  
* 2023/11/29  vadabi3			Plan 있는 경우만 조회 
* 2024.08.21   cys     			고도화(JV 사업부 포함)
*--------------------------------------------------------------------------------------------------
* ex)
* EXEC SCP0100_GET_PLAN_DATE @p_division_id='81', @p_bucket = 'MONTHLY', @p_program_id='SCP0100'
**************************************************************************************************** /

CREATE PROCEDURE [dbo].[SCP0100_GET_PLAN_DATE]
    @p_division_id NVARCHAR(MAX) = '81'
   ,@p_bucket      NVARCHAR(MAX) = 'MONTHLY'
   ,@p_program_id  NVARCHAR(MAX) = 'SCP0100'
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#TMP_PLAN') IS NOT NULL
	DROP TABLE #TMP_PLAN;


	IF @p_program_id =  'SCP0100'
	BEGIN
			--------------------------------------------------------------------------------------------------
			SELECT A.plan_start_yyyymmdd AS code
 	  			 , CASE WHEN FP_TARGET_YN = 'Y' 
						THEN CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')'
 	  		 			ELSE CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')' + ' (No Plan)' 
						END name
			  INTO #TMP_PLAN
  			  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK)
  		INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.plan_start_yyyymmdd = B.basis_yyyymmdd
  			 LEFT JOIN 
  			 (
  		 		SELECT DIVISION_ID
		 			, PLAN_START_YYYYMMDD
		 			, FP_TARGET_YN
		 			, MRP_TARGET_YN
		 			, DM_RTF_YN	 
	  			 FROM [dbo].[SCP_PLN_INTERFACE_YN] WITH(NOLOCK)
				WHERE 1=1
				  --AND PLAN_START_YYYYMMDD >= [dbo].[FN_GET_BUCKET_YYYYMMDD](0)
	   			  --AND DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	   
	   			  AND (
	   			  		(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			  		OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   			  	   )---고도화
	   			  AND  DIVISION_ID LIKE '81%'------고도화
  			 ) C ON A.plan_start_yyyymmdd = C.PLAN_START_YYYYMMDD
			 WHERE 1=1
			   AND (( @p_division_id IS NULL OR  @p_division_id='' ) OR A.division_id= @p_division_id)
			   AND  FP_TARGET_YN = 'Y'
			 GROUP BY A.plan_start_yyyymmdd, B.WEEK_NAME, C.FP_TARGET_YN

			--------------------------------------------------------------------------------------------------
			IF @p_bucket =  'MONTHLY'
			BEGIN
				SELECT CODE , NAME
				  FROM #TMP_PLAN
				 WHERE CODE IN (SELECT DISTINCT plan_start_yyyymmdd FROM SCP_RPT_GLOBAL_PSI_MD_MM)
			  ORDER BY CODE DESC
			END
			ELSE IF @p_bucket =  'WEEKLY'
			BEGIN
				SELECT CODE , NAME
				  FROM #TMP_PLAN
				 WHERE CODE IN (SELECT DISTINCT plan_start_yyyymmdd FROM SCP_RPT_GLOBAL_PSI_MD_WW)
			  ORDER BY CODE DESC
			END
	END
END
===== END ASIS ===== */

END PKG_SCP0100;
/
-- 컴파일 확인: SELECT NAME, TYPE, LINE, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_SCP0100' ORDER BY TYPE, SEQUENCE;
