/*
 **************************************************************************************************
 * Program ID  : [DMF0051_1_GET_BIZPLAN_CONF]
 * Description : Procedure 작성 가이드                                                              
 * Usage       : Procedure 작성 시 참조하세요!                                                      
 * Parameter   :                                                                                    
 *                                                                                                  
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description                                                             
 *--------------------------------------------------------------------------------------------------
 * 2023/07/19	CHANO0612	사업계획 프로젝트
 **************************************************************************************************
*/
CREATE PROCEDURE [dbo].[DMF0051_1_GET_BIZPLAN_CONF]
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
  EXEC DMF0051_1_GET_BIZPLAN_CONF @p_version_no = 'BP_M_20230827_V001'
    ,@p_division_id='82', @p_project_code='R-21-039', @p_scm_site_id = 'OMRON_JP_OOO', @p_item_id='EH154064P8S2'
  ,@p_incoterms = 'DDP', @p_from_yyyymm = '202401', @p_to_yyyymm = '202412'
*/

BEGIN	

	DECLARE @v_PLAN_ID         NVARCHAR(30)

	IF OBJECT_ID (N'tempdb..#TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM', N'U') IS NOT NULL 	DROP TABLE #TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM
	IF OBJECT_ID (N'tempdb..#DATA', N'U') IS NOT NULL  DROP TABLE #DATA
	IF OBJECT_ID (N'tempdb..#DATA_40', N'U') IS NOT NULL  DROP TABLE #DATA_40

	SELECT @v_PLAN_ID = PLAN_ID FROM SCP_ANL_BUSINESS_PLAN_RTF_DM WHERE DIVISION_ID = @p_division_id
	SELECT *
	INTO #TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM
	FROM SCP_ANL_BUSINESS_PLAN_RTF_DM WHERE PLAN_ID = @v_PLAN_ID AND DIVISION_ID = @p_division_id

	PRINT @v_PLAN_ID

	--SELECT * FROM #TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM WHERE PROJECT = 'R-21-039' AND MODEL_CODE = 'EH154064P8S2'

	SET NOCOUNT ON;

	DECLARE @V_QUERY NVARCHAR(MAX);
	DECLARE @Query NVARCHAR(max);

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
		 , A.QTY
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
	   AND A.MEASURE		= 'Business_Plan_Conf'
	 GROUP BY
	       A.DIVISION_ID, A.VERSION_NO, A.INCOTERMS, A.SCM_SITE_ID, A.PROJECT_CODE, A.PROJECT_NAME, A.ITEM_ID
		   , A.FCST_TYPE, A.EE_CORP_ID, A.CELL_CORP_ID, A.PACK_CORP_ID, A.OSP_YN, A.MEASURE, A.YYYYMM , A.QTY
	 ;

	SET @Query = '';
	UPDATE #DATA SET MEASURE = 'Business Plan(Conf.)'
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
		   AND MEASURE = 'Business Plan(Conf.)'
	GROUP BY YYYYMM) A;

	SET @Query = LEFT(@Query, LEN(@Query)-1);

	---- 실행
	EXEC ('SELECT * FROM
						 (SELECT SCM_SITE_ID, PROJECT_CODE, PROJECT_NAME, ITEM_ID, ITEM_NICKNAME, FCST_TYPE, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, OSP_YN, MEASURE, YYYYMM, QTY 
						   FROM #DATA
						 ) 
						 AS RESULT  PIVOT ( SUM(QTY) FOR YYYYMM IN (' + @Query + ') ) AS PIVOT_RESULT
			ORDER BY PROJECT_CODE');

	PRINT 'SELECT * FROM 
	( SELECT SCM_SITE_ID, PROJECT_CODE, PROJECT_NAME, ITEM_ID, ITEM_NICKNAME, FCST_TYPE, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, OSP_YN, MEASURE, YYYYMM, QTY from DM_PLN_BIZPLAN_C) 
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
		 , A.QTY
	  INTO #DATA_40
	  FROM dbo.DM_PLN_BIZPLAN_C A 
	 WHERE 1=1
	   AND A.DIVISION_ID	= @p_division_id 
	   AND A.VERSION_NO	    = @p_version_no 
	   AND A.PROJECT_CODE   = @p_project_code 
	   AND A.SCM_SITE_ID	= @p_scm_site_id 
	   AND A.ITEM_ID		= @p_item_id 
	   --AND A.INCOTERMS	    = @p_incoterms
	   AND A.YYYYMM		    BETWEEN @p_from_yyyymm and @p_to_yyyymm
	   AND A.MEASURE		= 'Business_Plan_Conf'
	 GROUP BY
	       A.DIVISION_ID, A.VERSION_NO, A.SCM_SITE_ID, A.PROJECT_CODE, A.PROJECT_NAME, A.ITEM_ID
		   , A.FCST_TYPE, A.EE_CORP_ID, A.CELL_CORP_ID, A.PACK_CORP_ID, A.OSP_YN, A.MEASURE, A.YYYYMM , A.QTY
	 ;

	SET @Query = '';
	UPDATE #DATA_40 SET MEASURE = 'Business Plan(Conf.)'
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
		   AND MEASURE = 'Business Plan(Conf.)'
	GROUP BY YYYYMM) A;

	SET @Query = LEFT(@Query, LEN(@Query)-1);

	---- 실행
	EXEC ('SELECT * FROM
						 (SELECT SCM_SITE_ID, PROJECT_CODE, PROJECT_NAME, ITEM_ID, ITEM_NICKNAME, FCST_TYPE, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, OSP_YN, MEASURE, YYYYMM, QTY 
						   FROM #DATA_40
						 ) 
						 AS RESULT  PIVOT ( SUM(QTY) FOR YYYYMM IN (' + @Query + ') ) AS PIVOT_RESULT
			ORDER BY PROJECT_CODE');

	PRINT 'SELECT * FROM 
	( SELECT SCM_SITE_ID, PROJECT_CODE, PROJECT_NAME, ITEM_ID, ITEM_NICKNAME, FCST_TYPE, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, OSP_YN, MEASURE, YYYYMM, QTY from DM_PLN_BIZPLAN_C) 
	AS RESULT  PIVOT (ROUND(SUM(QTY), 3) FOR YYYYMM IN (' + @Query + ') ) AS PIVOT_RESULT ORDER BY PROJECT_CODE';
	
	END

	IF OBJECT_ID (N'tempdb..#TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM', N'U') IS NOT NULL 	DROP TABLE #TEMP_SCP_ANL_BUSINESS_PLAN_RTF_DM
	IF OBJECT_ID (N'tempdb..#DATA', N'U') IS NOT NULL  DROP TABLE #DATA
	IF OBJECT_ID (N'tempdb..#DATA_40', N'U') IS NOT NULL  DROP TABLE #DATA_40

END;