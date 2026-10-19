



/*
 * Program ID   : SCP0046_GET_AllInputModelAllocation
 * Description  : Master Data Management
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================

*/
CREATE PROCEDURE [dbo].[SCP0046_GET_AllInputModelAllocation]
	 @p_operation_group		NVARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

		----------------------------------------------------------------------------------------------
	    IF OBJECT_ID('tempdb..#TMP_LIST') IS NOT NULL
		    DROP TABLE #TMP_LIST;

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
									AND S.OPERATION_GROUP= 'A';

		CREATE CLUSTERED INDEX IDX_TMP_LIST ON #TMP_LIST (COMPANY_ID,DIVISION_ID,PLANT_ID,SITE_ID );

		----------------------------------------------------------------------------------------------
		-- SCM_MST_LINE_SN
		----------------------------------------------------------------------------------------------
				SELECT DISTINCT S.DIVISION_ID
						,S.ITEM_ID
						,S.PLANT_SITE_ID
						,S.SITE_DESCRIPTION
						,LS.LINE_ID
				FROM #TMP_LIST s
				JOIN SCM_MST_LINE_SN LS (NOLOCK) ON LS.COMPANY_ID = S.COMPANY_ID
														AND LS.DIVISION_ID = S.DIVISION_ID
														AND LS.PLANT_ID = S.PLANT_ID
														AND LS.SITE_ID = S.SITE_ID
									                    AND LS.ACTIVE_FLAG ='Y'
				WHERE 1=1
			 ORDER BY S.ITEM_ID, S.PLANT_SITE_ID, LS.LINE_ID
					

END

