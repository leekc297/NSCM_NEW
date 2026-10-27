
/*
 * Program ID   : PR_XLS_GET_DP_MF_W
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.10.01   FP Pjt.         Create.
 * 2024.11.07   shineuiho67     [dbo].[SY_DM_MST_VERSION] : with(nolock)추가
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_DP_MF_W] 'UC1'
 */

create PROCEDURE [dbo].[PR_XLS_GET_DP_MF_W_20241120]
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

	declare @v_version_no           nvarchar(50)


	if object_id('tempdb..#DP_MF_W') is not null
		drop table #DP_MF_W


	create table #DP_MF_W (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
            , ITEM_ID                   nvarchar(50) 
			, YYYYMMDD 				    nvarchar(30)
			, TO_SITE                   nvarchar(50)
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

		select top 1 
		       @v_version_no = version_no
		  from [dbo].[SY_DM_MST_VERSION] with(nolock)
		 where 1 = 1 
		   and division_id = @v_division_id
		   and version_type = 'MF_W'
		 order by version_no desc 


        insert into #DP_MF_W (item_id, yyyymmdd, TO_SITE, QTY)
        select x.ITEM_ID
		     , x.YYYYMMDD
			 --, x.SCM_SITE_ID as TO_SITE
			 , '-' as TO_SITE
			 , SUM(x.QTY) 
          from SY_DM_PLN_MKT_FCST_C as x with(nolock)
               join dbo.SCM_SYS_LOOKUP_VALUE as y with(nolock)
            ON Y.LOOKUP_TYPE_CODE		= 'XLS_SSP_PLAN_BOD'
           AND X.DIVISION_ID			= Y.SEGMENT1
           AND X.PLANT_SITE_ID			= Y.SEGMENT2
           AND X.SCM_SITE_ID			= Y.SEGMENT3
         where x.DIVISION_ID			= @v_division_id
           and x.VERSION_NO     	    = @v_version_no
           and x.cutoff_type			= 'MF_W'
          and x.MEASURE					= 'MKT_FCST'
		   and x.PLANT_SITE_ID          like @v_plant_id + '%'
         group by 
               x.ITEM_ID
			 , x.YYYYMMDD
			 --, x.SCM_SITE_ID


		select @v_yyyymmdd_from		= min(yyyymmdd) 
	         , @v_yyyymmdd_to		= max(yyyymmdd)
		  from #DP_MF_W

		-- 없는 일자 데이터 생성
		insert into #DP_MF_W
			(
			  ITEM_ID  
			, YYYYMMDD
			, TO_SITE
			, QTY      
			)
		select 
			  X.ITEM_ID  
			, X.YYYYMMDD 
			, X.TO_SITE
			, 0
		 from (
				SELECT B.ITEM_ID  
					 , B.YYYYMMDD 
					 , B.TO_SITE
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
							  , TO_SITE
						   FROM #DP_MF_W
					   ) AS B
			  ) as x
		WHERE 1 = 1
		  AND NOT EXISTS (
						 SELECT 'X'
						   FROM #DP_MF_W AS Z 
						  WHERE 1 = 1
							AND Z.ITEM_ID  	   = X.ITEM_ID  
							AND Z.YYYYMMDD 	   = X.YYYYMMDD 
							AND Z.TO_SITE      = X.TO_SITE
						 )
			;

        -- 계획 - 실적
		select X.YYYYMMDD
			 , x.ITEM_ID
			 , X.TO_SITE
			 , SUM(QTY) as QTY
		  from (
                select X.ITEM_ID
                     , X.YYYYMMDD
					 , X.TO_SITE
                	 , X.QTY - ISNULL(Y.QTY, 0 )	AS QTY
                  from #DP_MF_W as X
                	   left outer join (
                	    SELECT A.ITEM_ID			AS ITEM_ID 
                			 , A.PLANT_ISSUE_DATE   AS YYYYMMDD
							 , A.TO_SITE
                		     , SUM(A.LOT_QTY)       AS QTY 
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
							 , A.TO_SITE
                	   ) as Y
                	on X.ITEM_ID  = Y.ITEM_ID
                   and X.YYYYMMDD = Y.YYYYMMDD
				   and x.to_site = y.to_site
               ) AS X
         where x.qty != 0
         group by 
		       X.YYYYMMDD
			 , x.ITEM_ID
			 , X.TO_SITE
		 order by 
		       X.YYYYMMDD
			 , x.ITEM_ID
			 , X.TO_SITE


		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH

	if object_id('tempdb..#DP_MF_W') is not null
		drop table #DP_MF_W

END



