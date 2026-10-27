
/*
 * Program ID   : PR_XLS_GET_SHIP_RESULT
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 2024.11.20   FP Pjt.         ERP 실적 적용
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_SHIP_RESULT] 'UC1', '20241101' , '20241130'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_SHIP_RESULT]
    @p_apl_code                 nvarchar(max)  = 'UC1'
,	@p_yyyymmdd_from			NVARCHAR(MAX)
,	@p_yyyymmdd_to				NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	DECLARE	@v_apl_code				NVARCHAR(MAX)
	DECLARE @v_yyyymmdd_from		nvarchar(max)
	DECLARE @v_yyyymmdd_to			nvarchar(max)

	declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)

	set @v_apl_code			= @p_apl_code
	set @v_yyyymmdd_from	= format( convert(datetime, @p_yyyymmdd_from), 'yyyyMMdd')
	set @v_yyyymmdd_to		= format( convert(datetime, @p_yyyymmdd_to), 'yyyyMMdd')


	BEGIN TRY		

		select @v_company_id		= attribute1
			 , @v_division_id		= attribute2
			 , @v_site_id			= attribute3
			 , @v_plant_id			= attribute4
			 , @v_elec_plant_id		= attribute5
		  from dbo.SCM_SYS_LOOKUP_VALUE with(nolock)
		 where lookup_type_code = 'XLS_PLAN_APL_PLANT'
		   and segment1 = @v_apl_code
		   and active_flag = 'Y'
/*
		SELECT A.DIVISION_ID       AS DIVISION_ID 
		     , y.plant_id     
		     , A.ITEM_ID           AS ITEM_ID 
		   --  , A.FROM_SITE         AS FROM_SITE
		     , CASE WHEN A.TO_SITE ='-' THEN A.CUSTOMER_CODE ELSE  A.TO_SITE END          AS TO_SITE
		     , A.PLANT_ISSUE_DATE  AS YYYYMMDD
            -- , convert(DATE, A.PLANT_ISSUE_DATE, 112) as YYYYMMDD
		    -- , A.SHIP_TYPE AS SHIP_TYPE
			 , z.nick_name
		     , SUM(A.LOT_QTY)            AS QTY 
		  FROM SY_SSP_DNM_SHIP_RESULT_OWMS as A WITH(NOLOCK)
		       join sy_scm_mst_site as y with(nolock) 
            on a.division_id		= y.division_id
		   and a.from_site			= y.scm_site_id
		       left outer join scm_item_m as z with(nolock)
		    on a.division_id		= z.division_id
		   and y.company_id			= z.company_id
		   and a.item_id			= z.item_id
		 WHERE 1 = 1
		   and a.ship_type			!= N'기타출고(其他出库)'
		   and a.division_id		= @v_division_id
		   and y.PLANT_ID			= @v_plant_id
		   and A.PLANT_ISSUE_DATE BETWEEN  @v_yyyymmdd_from  AND @v_yyyymmdd_to
		 GROUP BY A.DIVISION_ID        
		     , A.ITEM_ID  
		     , y.plant_id
	--	     , A.FROM_SITE   
		     , CASE WHEN A.TO_SITE ='-' THEN A.CUSTOMER_CODE ELSE A.TO_SITE  END  
		     , A.PLANT_ISSUE_DATE  
		    -- , A.SHIP_TYPE
			 , z.nick_name
*/

		SELECT X.DIVISION_ID
		     , X.PLANT_ID
		     , X.ITEM_ID
			 , X.TO_SITE
			 , X.YYYYMMDD
			 , X.NICK_NAME
			 , SUM(x.QTY ) as QTY
		  from (
		         select e.division_id
					  , e.plant_id
					  , e.item_id
					  , e.TO_SCM_SITE_ID as to_site
					  , format(convert(datetime, E.EXFACTORY_DATE), 'yyyy-MM-dd') as yyyymmdd
					  , t.NICK_NAME
					  , E.EXFACTORY_QTY as qty
				   from [SY_SCM_DNM_EXFACTORY_RESULT] e with(nolock)
						JOIN SY_SCM_MST_SITE AS S WITH(NOLOCK)					 
					 ON E.FROM_SCM_SITE_ID		= S.SCM_SITE_ID				 
					AND E.DIVISION_ID			= S.DIVISION_ID				 
					AND S.SITE_TYPE				= 'PLANT'					 				 
						JOIN SCM_ITEM_M AS T WITH(NOLOCK)				 
					 ON E.ITEM_ID				= T.ITEM_ID					 
					AND E.DIVISION_ID			= T.DIVISION_ID				 
					AND E.COMPANY_ID				= T.COMPANY_ID	
					AND E.SITE_ID				= T.SITE_ID
					AND T.ITEM_TYPE				NOT IN ('Q','R')
						JOIN SY_SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
					 ON L.LOOKUP_TYPE			= 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
					AND L.VALID_YN				= 'Y'
					AND L.SEGMENT1				= E.SSP_TYPE	
						join dbo.SCM_SYS_LOOKUP_VALUE as y with(nolock)
					 ON Y.LOOKUP_TYPE_CODE		= 'XLS_SSP_PLAN_BOD'
					AND e.DIVISION_ID			= Y.SEGMENT1
					AND e.FROM_SCM_SITE_ID			= Y.SEGMENT2
					AND e.TO_SCM_SITE_ID			= Y.SEGMENT3
				  where 1 = 1
					AND ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
					AND E.EXFACTORY_DATE BETWEEN  @v_yyyymmdd_from  AND @v_yyyymmdd_to
					and e.EXFACTORY_DATE < convert(nvarchar, dbo.FN_SITE_TIME(e.site_id), 112)
					and e.company_id				= @v_company_id
					and e.division_id			= @v_division_id
					and e.site_id				= @v_site_id
					and e.plant_id				= @v_plant_id
		            and E.CONFIRM_ID LIKE 'C%'	
				  union all
		         select e.division_id
					  , e.plant_id
					  , e.item_id
					  , e.TO_SCM_SITE_ID as to_site
					  , format(convert(datetime, E.EXFACTORY_DATE), 'yyyy-MM-dd') as yyyymmdd
					  , t.NICK_NAME
					  , E.EXFACTORY_QTY as qty
				   from [SY_SCM_DNM_EXFACTORY_RESULT] e with(nolock)
						JOIN SY_SCM_MST_SITE AS S WITH(NOLOCK)					 
					 ON E.FROM_SCM_SITE_ID		= S.SCM_SITE_ID				 
					AND E.DIVISION_ID			= S.DIVISION_ID				 
					AND S.SITE_TYPE				= 'PLANT'					 				 
						JOIN SCM_ITEM_M AS T WITH(NOLOCK)				 
					 ON E.ITEM_ID				= T.ITEM_ID					 
					AND E.DIVISION_ID			= T.DIVISION_ID				 
					AND E.COMPANY_ID				= T.COMPANY_ID	
					AND E.SITE_ID				= T.SITE_ID
					AND T.ITEM_TYPE				NOT IN ('Q','R')
						JOIN SY_SCM_ADM_LOOKUP_MASTER_DETAIL L2 WITH(NOLOCK)
					 ON L2.LOOKUP_TYPE			= 'ERP_ORDER_TYPE' -- LOOKUP에 등록된 ORDER_TYPE만 대상으로 함 
					AND L2.VALID_YN				= 'Y'
					AND L2.SEGMENT1				= E.ORDER_TYPE_CODE 	
						join dbo.SCM_SYS_LOOKUP_VALUE as y with(nolock)
					 ON Y.LOOKUP_TYPE_CODE		= 'XLS_SSP_PLAN_BOD'
					AND e.DIVISION_ID			= Y.SEGMENT1
					AND e.FROM_SCM_SITE_ID			= Y.SEGMENT2
					AND e.TO_SCM_SITE_ID			= Y.SEGMENT3
				  where 1 = 1
					AND ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
					AND E.EXFACTORY_DATE BETWEEN  @v_yyyymmdd_from  AND @v_yyyymmdd_to
					and e.EXFACTORY_DATE < convert(nvarchar, dbo.FN_SITE_TIME(e.site_id), 112)
					and e.company_id				= @v_company_id
					and e.division_id			= @v_division_id
					and e.site_id				= @v_site_id
					and e.plant_id				= @v_plant_id
		            and ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
			   ) AS X
		 GROUP BY 
		       X.DIVISION_ID
		     , X.PLANT_ID
			 , X.ITEM_ID
			 , X.TO_SITE
			 , X.YYYYMMDD
			 , X.NICK_NAME

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH

END



