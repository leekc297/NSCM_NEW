
/*
 * Program ID   : PR_XLS_GET_DIST_PLAN
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.10.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_DIST_PLAN] 'UC1'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_DIST_PLAN]
    @p_apl_code                 nvarchar(max)  = 'UC1'
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

	declare @v_plan_start_yyyymmdd  nvarchar(50)
	declare @v_plan_type              nvarchar(50)
	declare @v_seq                    bigint

	if object_id('tempdb..#DP_PLAN') is not null
		drop table #DP_PLAN


	create table #DP_PLAN (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
            , ITEM_ID                   nvarchar(50) 
			, YYYYMMDD 				    nvarchar(30)
			, QTY                       numeric(20, 10)
			)
			;

	set @v_apl_code			= @p_apl_code

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


		select TOP 1 
			   @v_plan_start_yyyymmdd	= plan_start_yyyymmdd
			 , @v_plan_type				= plan_type
			 , @v_seq					= plan_seq
		  from SY_SCP_PLAN_VERSION_V 
		 where division_id = @v_division_id
		   and plan_type = 'FN'
		 order by plan_version_id desc

        insert into #DP_PLAN (item_id, yyyymmdd, qty)
        select ITEM_ID, YYYYMMDD, SUM(qty) 
          from SY_SCP_ANL_SHIPMENT_PLAN_FG as x with(nolock)
               join dbo.SCM_SYS_LOOKUP_VALUE as y with(nolock)
            ON Y.LOOKUP_TYPE_CODE		= 'XLS_SSP_PLAN_BOD'
           AND X.DIVISION_ID			= Y.SEGMENT1
           AND X.FROM_SITE				= Y.SEGMENT2
           AND X.TO_SITE				= Y.SEGMENT3
           AND X.BOD_ID					= Y.ATTRIBUTE1
         where x.DIVISION_ID			= @v_division_id
           and x.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
           and x.plan_type				= @v_plan_type
           and x.seq					= @v_seq
           and x.MEASURE				= 'SHIP_PLAN_AMEND'
		   and x.from_site              like @v_plant_id + '%'
         group by 
               ITEM_ID
		     , YYYYMMDD


		select @v_yyyymmdd_from		= min(yyyymmdd) 
	         , @v_yyyymmdd_to		= max(yyyymmdd)
		  from #DP_PLAN

		-- 없는 일자 데이터 생성
		insert into #DP_PLAN
			(
			  ITEM_ID  
			, YYYYMMDD 
			, QTY      
			)
		select 
			  X.ITEM_ID  
			, X.YYYYMMDD 
			, 0
		 from (
				SELECT B.ITEM_ID  
					 , B.YYYYMMDD 
				  FROM (
						 SELECT YYYYMMDD 
						   FROM TH_UIS_CAL WITH(NOLOCK)
						  WHERE 1 = 1
						 	AND YYYYMMDD >= @v_yyyymmdd_from
						 	AND YYYYMMDD <= @v_yyyymmdd_to
					   ) AS A
					   CROSS APPLY (
						 SELECT DISTINCT
						  	    ITEM_ID  
						 	  , YYYYMMDD 
						   FROM #DP_PLAN
					   ) AS B
			  ) as x
		WHERE 1 = 1
		  AND NOT EXISTS (
						 SELECT 'X'
						   FROM #DP_PLAN AS Z 
						  WHERE 1 = 1
							AND Z.ITEM_ID  	   = X.ITEM_ID  
							AND Z.YYYYMMDD 	   = X.YYYYMMDD 
						 )
			;


		select LEFT(x.YYYYMMDD, 6) AS YYYYMM
			 , x.ITEM_ID
			 , SUM(QTY) as QTY
		  from (
                select X.ITEM_ID
                     , X.YYYYMMDD
                	 , X.QTY - ISNULL(Y.QTY, 0 ) AS QTY
                  from #DP_PLAN as X
                	   left outer join (
                	    SELECT A.ITEM_ID           AS ITEM_ID 
                			 , A.PLANT_ISSUE_DATE   as YYYYMMDD
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
                		 GROUP BY A.ITEM_ID  
                		     , A.PLANT_ISSUE_DATE  
                	   ) as Y
                	on X.ITEM_ID  = Y.ITEM_ID
                   and X.YYYYMMDD = Y.YYYYMMDD
               ) AS X
         where x.qty != 0
         group by 
		       LEFT(x.YYYYMMDD, 6)
			 , x.ITEM_ID
		 order by 
		       LEFT(x.YYYYMMDD, 6)
			 , x.ITEM_ID


		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH

	if object_id('tempdb..#DP_PLAN') is not null
		drop table #DP_PLAN

END



