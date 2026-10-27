
/*
 * Program ID   : PR_XLS_GET_SHIP_RESULT
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_SHIP_RESULT] 'UC1', '20240803' , '20240811'
 */

create PROCEDURE [dbo].[PR_XLS_GET_SHIP_RESULT_20240802]
    @p_apl_code                 nvarchar(max)  = 'UC1'
,	@p_yyyymmdd_from			NVARCHAR(MAX)
,	@p_yyyymmdd_to				NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE  @v_yyyymmdd_from   nvarchar(max)
	DECLARE  @v_yyyymmdd_to     nvarchar(max)

	set @v_yyyymmdd_from	= format( convert(datetime, @p_yyyymmdd_from), 'yyyyMMdd')
	set @v_yyyymmdd_to		= format( convert(datetime, @p_yyyymmdd_to), 'yyyyMMdd')


	BEGIN TRY		

		SELECT A.DIVISION_ID       AS DIVISION_ID 
		     , y.plant_id     
		     , A.ITEM_ID           AS ITEM_ID 
		   --  , A.FROM_SITE         AS FROM_SITE
		     --, CASE WHEN A.TO_SITE ='-' THEN A.CUSTOMER_CODE ELSE  A.TO_SITE END          AS TO_SITE
		     --, A.PLANT_ISSUE_DATE  AS YYYYMMDD
             , convert(DATE, A.PLANT_ISSUE_DATE, 112) as YYYYMMDD
		     , A.SHIP_TYPE AS SHIP_TYPE
			 , z.nick_name
		     , SUM(A.LOT_QTY)            AS QTY 
		  FROM SY_SSP_DNM_SHIP_RESULT_OWMS as A WITH(NOLOCK)
		       join sy_scm_mst_site as y with(nolock) 
            on a.division_id = y.division_id
		   and a.from_site = y.scm_site_id
		       left outer join scm_item_m as z with(nolock)
		    on a.division_id = z.division_id
		   and y.company_id = z.company_id
		   and a.item_id = z.item_id
		 WHERE 1 = 1
		   and a.ship_type != N'기타출고(其他出库)'
		   and a.division_id = '81_UC'
		   and y.PLANT_ID = 'G671'
		   and A.PLANT_ISSUE_DATE BETWEEN  @v_yyyymmdd_from  AND @v_yyyymmdd_to
		 GROUP BY A.DIVISION_ID        
		     , A.ITEM_ID  
		     , y.plant_id
	--	     , A.FROM_SITE   
		     --, CASE WHEN A.TO_SITE ='-' THEN A.CUSTOMER_CODE ELSE A.TO_SITE  END  
		     , A.PLANT_ISSUE_DATE  
		     , A.SHIP_TYPE
			 , z.nick_name

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH

END



