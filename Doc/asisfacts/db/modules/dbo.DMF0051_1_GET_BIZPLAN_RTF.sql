/*
 **************************************************************************************************
 * Program ID  : [DMF0051_1_GET_BIZPLAN_RTF]
 * Description : Procedure 작성 가이드                                                              
 * Usage       : Procedure 작성 시 참조하세요!                                                      
 * Parameter   :                                                                                    
 *                                                                                                  
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description                                                             
 *--------------------------------------------------------------------------------------------------
 * 2023/07/19	CHANO0612	사업계획 프로젝트
 * 2023/10/16	CHANO0612	사업계획3차
 **************************************************************************************************
*/
CREATE PROCEDURE [dbo].[DMF0051_1_GET_BIZPLAN_RTF]
--DECLARE
	@p_version_no               NVARCHAR(30),
    @p_division_id              NVARCHAR(30),
    @p_project_code             NVARCHAR(4000),
	@p_scm_site_id              NVARCHAR(4000),
	@p_item_id                  NVARCHAR(4000),
	--@p_item_type              NVARCHAR(4000),
	@p_incoterms                NVARCHAR(4000),
	@p_from_yyyymm              NVARCHAR(4000),
	@p_to_yyyymm                NVARCHAR(4000)	
AS
/*
  EXEC DMF0051_1_GET_BIZPLAN_RTF @p_version_no = 'BP_M_20230828_V002'
  ,@p_division_id='82', @p_project_code='R-21-039', @p_scm_site_id = 'OMRON_JP_OOO', @p_item_id='EH154064P8S2'
  ,@p_incoterms = 'DDP', @p_from_yyyymm = '202401', @p_to_yyyymm = '202412'
*/
BEGIN	

	DECLARE @v_PLAN_ID         NVARCHAR(30)

	IF OBJECT_ID (N'tempdb..#TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM', N'U') IS NOT NULL  DROP TABLE #TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM
	IF OBJECT_ID (N'tempdb..#DATA', N'U') IS NOT NULL  DROP TABLE #DATA
	IF OBJECT_ID (N'tempdb..#DATA_40', N'U') IS NOT NULL  DROP TABLE #DATA_40

	SELECT @v_PLAN_ID = PLAN_ID FROM SCP_ANL_BUSINESS_PLAN_RTF_DM WHERE DIVISION_ID = @p_division_id
	


	PRINT @v_PLAN_ID

	--SELECT * FROM #TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM 

	SET NOCOUNT ON;

	DECLARE @V_QUERY NVARCHAR(MAX);
	DECLARE @Query NVARCHAR(max);

	SELECT *
	INTO #TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM
	FROM SCP_ANL_BUSINESS_PLAN_RTF_DM WHERE PLAN_ID = @v_PLAN_ID AND DIVISION_ID = @p_division_id



	IF (@p_division_id LIKE '81%' OR @p_division_id = '82')
	BEGIN
	SELECT A.DIVISION_ID
	     , A.VERSION_NO
		 , A.INCOTERMS
	     , A.SCM_SITE_ID 
	     , A.PROJECT_CODE
		 --, (SELECT TOP 1 PROJECT_DESC FROM #TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM WHERE PROJECT = A.PROJECT_CODE) PROJECT_NAME
		 , (SELECT TOP 1 PROJECT_NAME FROM SCM_MST_PROJECT WITH(NOLOCK) WHERE PROJECT_CODE = A.PROJECT_CODE) PROJECT_NAME
		 , A.ITEM_ID
		 --, (SELECT TOP 1 MODEL FROM #TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM WHERE MODEL_CODE = A.ITEM_ID) ITEM_NICKNAME
		 , (SELECT TOP 1 NICK_NAME FROM SCM_MST_ITEM_SN WITH(NOLOCK)WHERE ITEM_ID = A.ITEM_ID) ITEM_NICKNAME
		 , A.FCST_TYPE
		 , A.EE_CORP_ID
		 , A.CELL_CORP_ID
		 , A.PACK_CORP_ID
		 , A.OSP_YN		
		 , A.MEASURE
		 , A.YYYYMM
		 , SUM(A.QTY) QTY
	  INTO #DATA
	  FROM dbo.DM_PLN_BIZPLAN_C A 
	 WHERE 1=1
	   AND A.DIVISION_ID	= @p_division_id 
	   AND A.VERSION_NO	    = @p_version_no 
	   AND A.PROJECT_CODE   = @p_project_code 
	   AND A.SCM_SITE_ID	= @p_scm_site_id 
	   AND A.ITEM_ID		= @p_item_id 
	   AND A.INCOTERMS	    = @p_incoterms
	   AND A.YYYYMM		    BETWEEN @p_from_yyyymm and @p_to_yyyymm
	   AND A.MEASURE		= 'RTF'
	 GROUP BY
	       A.DIVISION_ID, A.VERSION_NO, A.INCOTERMS, A.SCM_SITE_ID, A.PROJECT_CODE, A.PROJECT_NAME, A.ITEM_ID
		   , A.FCST_TYPE, A.EE_CORP_ID, A.CELL_CORP_ID, A.PACK_CORP_ID, A.OSP_YN, A.MEASURE, A.YYYYMM

	SET @Query = '';

	--SELECT * FROM #DATA

	SELECT @Query = @Query + '[' +  YYYYMM + '],'
	FROM (SELECT YYYYMM FROM #DATA--DM_PLN_BIZPLAN_C 
	WHERE 1=1
		   AND DIVISION_ID = @p_division_id 
		   AND VERSION_NO = @p_version_no 
		   AND PROJECT_CODE = @p_project_code
		   AND SCM_SITE_ID = @p_scm_site_id 
		   AND ITEM_ID = @p_item_id 
		   AND INCOTERMS = @p_incoterms
		   AND YYYYMM between @p_from_yyyymm and @p_to_yyyymm
		   AND MEASURE = 'RTF'
	GROUP BY YYYYMM) A;

	SET @Query = LEFT(@Query, LEN(@Query)-1);

	---- 실행
	EXEC ('SELECT * FROM
						 (SELECT SCM_SITE_ID, PROJECT_CODE, PROJECT_NAME, ITEM_ID, ITEM_NICKNAME, FCST_TYPE, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, OSP_YN, ''RTF(BP)'' MEASURE, YYYYMM, QTY 
						   FROM #DATA
						 ) 
						 AS RESULT  PIVOT ( SUM(QTY) FOR YYYYMM IN (' + @Query + ') ) AS PIVOT_RESULT
			ORDER BY PROJECT_CODE');

	PRINT 'SELECT * FROM 
	( SELECT SCM_SITE_ID, PROJECT_CODE, PROJECT_NAME, ITEM_ID, ITEM_NICKNAME, FCST_TYPE, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, OSP_YN, ''RTF(BP)''MEASURE, YYYYMM, QTY from DM_PLN_BIZPLAN_C) 
	AS RESULT  PIVOT (ROUND(SUM(QTY), 3) FOR YYYYMM IN (' + @Query + ') ) AS PIVOT_RESULT ORDER BY PROJECT_CODE';



	END
	ELSE IF (@p_division_id = '40') 
	BEGIN
	SELECT A.DIVISION_ID
	     , A.VERSION_NO
		 , '' INCOTERMS
	     , A.SCM_SITE_ID 
	     , A.PROJECT_CODE
		 --, (SELECT TOP 1 PROJECT_DESC FROM #TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM WHERE PROJECT = A.PROJECT_CODE) PROJECT_NAME
		 , (SELECT TOP 1 PROJECT_NAME FROM SCM_MST_PROJECT WITH(NOLOCK) WHERE PROJECT_CODE = A.PROJECT_CODE) PROJECT_NAME
		 , A.ITEM_ID
		 --, (SELECT TOP 1 MODEL FROM #TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM WHERE MODEL_CODE = A.ITEM_ID) ITEM_NICKNAME
		 , (SELECT TOP 1 NICK_NAME FROM SCM_MST_ITEM_SN WITH(NOLOCK)WHERE ITEM_ID = A.ITEM_ID) ITEM_NICKNAME
		 , A.FCST_TYPE
		 , A.EE_CORP_ID
		 , A.CELL_CORP_ID
		 , A.PACK_CORP_ID
		 , A.OSP_YN		
		 , A.MEASURE
		 , A.YYYYMM
		 , SUM(A.QTY) QTY
	  INTO #DATA_40
	  FROM dbo.DM_PLN_BIZPLAN_C A 
	 WHERE 1=1
	   AND A.DIVISION_ID	= @p_division_id 
	   AND A.VERSION_NO	    = @p_version_no 
	   AND A.PROJECT_CODE   = @p_project_code 
	   AND A.SCM_SITE_ID	= @p_scm_site_id 
	   AND A.ITEM_ID		= @p_item_id 
	   AND A.YYYYMM		    BETWEEN @p_from_yyyymm and @p_to_yyyymm
	   AND A.MEASURE		= 'RTF'
	 GROUP BY
	       A.DIVISION_ID, A.VERSION_NO, A.SCM_SITE_ID, A.PROJECT_CODE, A.PROJECT_NAME, A.ITEM_ID
		   , A.FCST_TYPE, A.EE_CORP_ID, A.CELL_CORP_ID, A.PACK_CORP_ID, A.OSP_YN, A.MEASURE, A.YYYYMM

	SET @V_QUERY = '';
	SET @Query = '';

	--SELECT * FROM #DATA_40

	SELECT @Query = @Query + '[' +  YYYYMM + '],'
	FROM (SELECT YYYYMM FROM #DATA_40--DM_PLN_BIZPLAN_C 
	WHERE 1=1
		   AND DIVISION_ID = @p_division_id 
		   AND VERSION_NO = @p_version_no 
		   AND PROJECT_CODE = @p_project_code
		   AND SCM_SITE_ID = @p_scm_site_id 
		   AND ITEM_ID = @p_item_id 
		   AND INCOTERMS = @p_incoterms
		   AND YYYYMM between @p_from_yyyymm and @p_to_yyyymm
		   AND MEASURE = 'RTF'
	GROUP BY YYYYMM) A;


SET @Query = LEFT(@Query, LEN(@Query)-1);

	

	---- 실행
	EXEC ('SELECT * FROM
						 (SELECT SCM_SITE_ID, PROJECT_CODE, PROJECT_NAME, ITEM_ID, ITEM_NICKNAME, FCST_TYPE, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, OSP_YN, ''RTF(BP)'' MEASURE, YYYYMM, QTY 
						   FROM #DATA_40
						 ) 
						 AS RESULT  PIVOT ( SUM(QTY) FOR YYYYMM IN (' + @Query + ') ) AS PIVOT_RESULT
			ORDER BY PROJECT_CODE');

	PRINT 'SELECT * FROM 
	( SELECT SCM_SITE_ID, PROJECT_CODE, PROJECT_NAME, ITEM_ID, ITEM_NICKNAME, FCST_TYPE, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, OSP_YN, ''RTF(BP)'' MEASURE, YYYYMM, QTY from DM_PLN_BIZPLAN_C) 
	AS RESULT  PIVOT (ROUND(SUM(QTY), 3) FOR YYYYMM IN (' + @Query + ') ) AS PIVOT_RESULT ORDER BY PROJECT_CODE';




	END

	IF OBJECT_ID (N'tempdb..#TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM', N'U') IS NOT NULL 	DROP TABLE #TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM
	IF OBJECT_ID (N'tempdb..#DATA', N'U') IS NOT NULL  DROP TABLE #DATA
	IF OBJECT_ID (N'tempdb..#DATA_40', N'U') IS NOT NULL  DROP TABLE #DATA_40




END;

--	DECLARE @i INT
--	DECLARE @Col VARCHAR(2000)
--	DECLARE @ThisMonth VARCHAR(6)

--	DECLARE @v_PLAN_ID         NVARCHAR(30)
--	DECLARE @v_YYYYMMDD		   NVARCHAR(8)
--	DECLARE @v_PLAN_START_DATE NVARCHAR(6)

--	SELECT @v_PLAN_ID = MAX(PLAN_ID) FROM SCP_ANL_BUSINESS_PLAN_INFO WHERE DIVISION_ID = @p_division_id 
--	SELECT @v_PLAN_START_DATE = PLAN_START_DATE FROM SCP_ANL_BUSINESS_PLAN_INFO WHERE DIVISION_ID = @p_division_id AND PLAN_ID = @v_PLAN_ID

--	--SELECT @v_PLAN_ID
--	--SELECT @v_PLAN_START_DATE

--	--SELECT * FROM SCP_ANL_BUSINESS_PLAN_INFO
--	--SELECT * FROM SCP_ANL_BUSINESS_PLAN_RTF_DM

-- --   SELECT * FROM SCP_ANL_BUSINESS_PLAN_RTF_DM WHERE DIVISION_ID = @p_division_id AND PLAN_ID = @v_PLAN_ID
--	SET @v_YYYYMMDD =  SUBSTRING(@v_PLAN_ID, 1, 8);

--	--SELECT * FROM SCP_ANL_BUSINESS_PLAN_INFO WHERE DIVISION_ID = @p_division_id AND PLAN_ID = @v_PLAN_ID

	

--	CREATE TABLE #TMP_RTF (
--		DIVISION_ID		nvarchar(30),	
--		PLAN_ID			nvarchar(30),	
--		SALES_SITE		nvarchar(50),	
--		BIZ_TYPE		nvarchar(30),	
--		CUST			nvarchar(30),	
--		PROJECT			nvarchar(100),	
--		PROJECT_DESC	nvarchar(500),	
--		MODEL			nvarchar(100),	
--		MODEL_CODE		nvarchar(100),	
--		CELL_NICKNAME	nvarchar(100),	
--		CELL_CODE		nvarchar(100),	
--		ELECTRODE		nvarchar(50),	
--		CELL			nvarchar(50),	
--		PACK			nvarchar(50),	
--		UNIT			nvarchar(50),	
--		INCOTERMS		nvarchar(50),	
--		MEASURE			nvarchar(30),	
--	)

--	SET @i = 0

--	WHILE (@i <= 59) 
--	BEGIN
--		---SET @Col = 'ALTER TABLE #TMP_RTF ADD COL' + CAST(@i AS VARCHAR(10)) + ' INT '
--		SET @Col = 'ALTER TABLE #TMP_RTF ADD M_' + CONVERT(CHAR(6), DATEADD(MONTH, @i, @v_PLAN_START_DATE + '01'), 112) + ' INT '
--		EXECUTE(@Col)
--		SET @i = @i + 1
--	END

--	BEGIN
	

--		INSERT INTO #TMP_RTF
--		SELECT 
--		DIVISION_ID,PLAN_ID,SALES_SITE,BIZ_TYPE,CUST,PROJECT,PROJECT_DESC,MODEL,MODEL_CODE,CELL_NICKNAME,CELL_CODE,ELECTRODE,CELL,PACK,UNIT,INCOTERMS,MEASURE 
--		,M1_QTY,M2_QTY,M3_QTY,M4_QTY,M5_QTY,M6_QTY,M7_QTY,M8_QTY,M9_QTY,M10_QTY
--		,M11_QTY,M12_QTY,M13_QTY,M14_QTY,M15_QTY,M16_QTY,M17_QTY,M18_QTY,M19_QTY,M20_QTY
--		,M21_QTY,M22_QTY,M23_QTY,M24_QTY,M25_QTY,M26_QTY,M27_QTY,M28_QTY,M29_QTY,M30_QTY
--		,M31_QTY,M32_QTY,M33_QTY,M34_QTY,M35_QTY,M36_QTY,M37_QTY,M38_QTY,M39_QTY,M40_QTY
--		,M41_QTY,M42_QTY,M43_QTY,M44_QTY,M45_QTY,M46_QTY,M47_QTY,M48_QTY,M49_QTY,M50_QTY
--		,M51_QTY,M52_QTY,M53_QTY,M54_QTY,M55_QTY,M56_QTY,M57_QTY,M58_QTY,M59_QTY,M60_QTY
--		FROM SCP_ANL_BUSINESS_PLAN_RTF_DM
--		WHERE 1=1 
--		AND ATTRIBUTE1 = @v_PLAN_ID 
--		--AND ATTRIBUTE2 = '20230821'
--		AND DIVISION_ID = @p_division_id
--		AND PROJECT = @p_project_code
--		AND SALES_SITE = @p_scm_site_id
--		AND MODEL_CODE = @p_item_id
--		AND INCOTERMS = @p_incoterms

--	END

--	SELECT * FROM #TMP_RTF

------ 생성된 임시테이블 삭제
--	DROP TABLE #TMP_RTF
