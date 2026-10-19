



/*
 * Program ID   : SCP0049_GET_AllInputModelAllocation
 * Description  : Master Data Management
 * Program History 
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023/08/07   vadabi3		최초생성	UP_FX_GetCommonDataList_SCP.AllInputModelAllocation 분리
 2023/08/08   vadabi3		속도 개선	
 ----------------------------------------------------------------------------------------------	
 exec SCP0049_GET_AllInputModelAllocation 'A'  
                                     
*/
CREATE PROCEDURE [dbo].[SCP0049_GET_AllInputModelAllocation]
	 @p_operation_group		NVARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

		----------------------------------------------------------------------------------------------
	    IF OBJECT_ID('tempdb..#TMP_LIST') IS NOT NULL
		    DROP TABLE #TMP_LIST;
	    IF OBJECT_ID('tempdb..#TMP_LINE') IS NOT NULL
		    DROP TABLE #TMP_LINE;


		----------------------------------------------------------------------------------------------
		-- SCM_MST_SITE_ITEM_PRIORITY
		-- SCM_MST_SITE
		----------------------------------------------------------------------------------------------
		SELECT DISTINCT P.DIVISION_ID
				,P.ITEM_ID
				,P.PLANT_SITE_ID
				,S.SITE_DESCRIPTION
				,S.COMPANY_ID
				,S.PLANT_ID
				,S.SITE_ID
			INTO #TMP_LIST
		FROM SCM_MST_SITE_ITEM_PRIORITY P (NOLOCK)
		JOIN SCM_MST_SITE S (NOLOCK) ON P.DIVISION_ID = S.DIVISION_ID
									AND P.PLANT_SITE_ID = S.SCM_SITE_ID
									AND S.OPERATION_GROUP= @p_operation_group;

		CREATE CLUSTERED INDEX IDX_TMP_LIST ON #TMP_LIST (COMPANY_ID,DIVISION_ID,PLANT_ID,SITE_ID );
		----------------------------------------------------------------------------------------------
		-- SCM_MST_LINE_SN
		----------------------------------------------------------------------------------------------
		  SELECT DISTINCT COMPANY_ID
				,DIVISION_ID
				,PLANT_ID
				,SITE_ID
				,LINE_ID
			 INTO  #TMP_LINE
		    FROM SCM_MST_LINE_SN
		    WHERE ACTIVE_FLAG='Y'


		----------------------------------------------------------------------------------------------
		-- RETURN
		----------------------------------------------------------------------------------------------
			SELECT   S.DIVISION_ID
					,S.ITEM_ID
					,S.PLANT_SITE_ID
					,S.SITE_DESCRIPTION
					,LS.LINE_ID
			FROM #TMP_LIST s
			JOIN #TMP_LINE LS (NOLOCK) ON LS.COMPANY_ID = S.COMPANY_ID
												AND LS.DIVISION_ID = S.DIVISION_ID
												AND LS.PLANT_ID = S.PLANT_ID
												AND LS.SITE_ID = S.SITE_ID
									     
			WHERE 1=1
			ORDER BY S.ITEM_ID, S.PLANT_SITE_ID, LS.LINE_ID;


		----------------------------------------------------------------------------------------------
	    IF OBJECT_ID('tempdb..#TMP_LIST') IS NOT NULL
		    DROP TABLE #TMP_LIST;
	    IF OBJECT_ID('tempdb..#TMP_LINE') IS NOT NULL
		    DROP TABLE #TMP_LINE;
END

