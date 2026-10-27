
/*
 * Program ID   : PR_XLS_SAVE_DM_PLN_SHIPMENT_REQ
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   declare @ret nvarchar(max)
   exec PR_XLS_SAVE_DM_PLN_SHIPMENT_REQ 'UC1', 'crjung', @ret OUTPUT
   select @ret as ret
 */

create PROCEDURE [dbo].[PR_XLS_SAVE_DM_PLN_SHIPMENT_REQ_20240913]
    @p_apl_code					nvarchar(max) = 'UC1'
,	@p_user_id					NVARCHAR(MAX)    
,   @p_return					NVARCHAR(max) = NULL OUTPUT

AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @v_descr			NVARCHAR(max)

	DECLARE	@v_apl_code			NVARCHAR(MAX)
	DECLARE @v_user_id			nvarchar(max)
	declare @INVALID_COUNT                int

	declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)

	DECLARE @INX				INT				= 0;
    DECLARE @MAX_NUM			INT				= 0;

	set @v_apl_code				= @p_apl_code
	set @v_user_id				= @p_user_id


	if object_id('tempdb..#BUF_AMEND_PLAN_SSP_R_XLS') is not null
		drop table #BUF_AMEND_PLAN_SSP_R_XLS


	create table #BUF_AMEND_PLAN_SSP_R_XLS (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
		    , [DIVISION_ID]				[nvarchar](30)
		    , [PROJECT_CODE]			[nvarchar](50)
		    , [SCM_SITE_ID]				[nvarchar](30)
		    , [ITEM_ID]					[nvarchar](50)
		    , [FCST_TYPE]				[nvarchar](20)
		    , [INCOTERMS]				[nvarchar](10)
		    , [TRANSPORT_MODE]			[nvarchar](10)
		    , [BOD_ID]					[nvarchar](150)
		    , [MEASURE]					[nvarchar](50)
		    , [PLANT_SITE_ID]			[nvarchar](50)
		    , [SITE_TYPE]				[nvarchar](10)
		    , [YYYYMMDD]				[nvarchar](8) 
		    , [QTY]						[numeric](20, 10) 
		    , [CREATED_BY]				[nvarchar](150) 
		    , [CREATION_DATE]			[datetime] 
		    , [LAST_UPDATED_BY]			[nvarchar](150) 
		    , [LAST_UPDATE_DATE]		[datetime] 
			)
			;


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

	    insert into #BUF_AMEND_PLAN_SSP_R_XLS       
		     ( 									 	
               [DIVISION_ID]						  
             , [PROJECT_CODE]				
             , [SCM_SITE_ID]					  
             , [ITEM_ID]							
             , [FCST_TYPE]							
             , [INCOTERMS]						
             , [TRANSPORT_MODE]							
             , [BOD_ID]							
             , [MEASURE]								
             , [PLANT_SITE_ID]					
             , [SITE_TYPE]							
             , [YYYYMMDD]					
             , [QTY]								
             , [CREATED_BY]					
             , [CREATION_DATE]					 
             , [LAST_UPDATED_BY]					 
             , [LAST_UPDATE_DATE]				  

			 )
		SELECT 
               A.[DIVISION_ID]		
             , A.[PROJECT_CODE]		
             , A.[SCM_SITE_ID]		
             , A.[ITEM_ID]			
             , A.[FCST_TYPE]			
             , c.ssp_incoterms as INCOTERMS			
             , c.transport_mode as TRANSPORT_MODE		
             , c.bod_id as BOD_ID				
             , 'SHIP_REQ' as MEASURE			
             , A.[PLANT_SITE_ID]		
             , c.bod_type as SITE_TYPE			
             , A.[YYYYMMDD]			
             , A.[QTY]				
             , A.JOB_USER_ID		
             , getdate()		
             , A.JOB_USER_ID
             , getdate()
          FROM BUF_AMEND_PLAN_SSP_R_XLS AS A with(nolock)
		       join dbo.SCM_SYS_LOOKUP_VALUE as b with(nolock)
			on b.lookup_type_code = 'XLS_SSP_PLAN_BOD'
		   and a.division_id = b.segment1
		   and a.plant_site_id = b.segment2
		   and a.scm_site_id = b.segment3
		       join SY_SCP_MST_BOD_N_V as c with(nolock)
			on a.division_id = c.division_id
		   and b.attribute1 = c.bod_id
		 where JOB_USER_ID = @v_user_id

		SELECT @INX			= 1
			 , @MAX_NUM		= COUNT(*)
		  FROM #BUF_AMEND_PLAN_SSP_R_XLS

	  
		IF @MAX_NUM = 0
		BEGIN
			PRINT 'NG|' + 'No data in buf table.'
			RAISERROR  ( 'No data in buf table or check your authority.', 16, 1 ); 
		END


		DECLARE  @v_ow_day_cnt INT ; -- 사업부별로 확정구간 이후 구간에 대해서 사용자가 입력/변경한 데이터를 며칠까지 보존할 것인지의 일수	

		SELECT @v_ow_day_cnt	= CAST(SEGMENT2 AS INT)
		  FROM SY_SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		 WHERE LOOKUP_TYPE		= 'DM_SHIP_OW_FROZEN'
		   AND SEGMENT1			= '81_UC'
		;


		BEGIN TRAN

		DELETE A
		  FROM SY_DM_PLN_SHIPMENT_REQ AS A WITH(NOLOCK)
			   JOIN SY_SCM_MST_SITE AS FS WITH(NOLOCK) 
			ON A.DIVISION_ID	= FS.DIVISION_ID 
		   AND A.PLANT_SITE_ID	= FS.SCM_SITE_ID
			   JOIN SY_SCM_MST_SITE AS TS WITH(NOLOCK) 
			ON A.DIVISION_ID	= TS.DIVISION_ID 
		   AND A.SCM_SITE_ID	= TS.SCM_SITE_ID
		 WHERE 1 = 1
		   and A.DIVISION_ID	= @v_division_id
		   and A.PLANT_SITE_ID  = @v_plant_id + '-A'
		   AND A.SITE_TYPE		= 'SALES'
		   AND ISNULL(TS.ATTRIBUTE2, 'N') = N'Y'		--	해당 사이트가 자동생성 사이트일 경우
		   AND A.YYYYMMDD		>= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10) , getdate()), 112) -- 확정구간 보존
				   
		   -- 확정구간 이후 사업부별 보존구간 적용
		   AND ( (
					A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10) , getdate()), 112) 
					AND A.YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10)  + ISNULL(@v_ow_day_cnt, 0) , getdate()), 112) 
					AND ISNULL(A.ATTRIBUTE1,'Y') = N'N'			--	사용자가 수정한 데이터가 아니고
				 ) 
				 OR	-- 그 이후 구간은 그냥 삭제
				 (	
					A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10)  + ISNULL(@v_ow_day_cnt, 0) , getdate()), 112) 
				 )
				 OR A.Qty = 0
			   )


		INSERT INTO SY_DM_PLN_SHIPMENT_REQ (
					DIVISION_ID
				  , PROJECT_CODE
				  , SCM_SITE_ID
				  , ITEM_ID
				  , FCST_TYPE
				  , INCOTERMS
				  , TRANSPORT_MODE
				  , BOD_ID
				  , MEASURE
				  , PLANT_SITE_ID
				  , SITE_TYPE
				  , YYYYMMDD
				  , QTY
				  , CREATED_BY
				  , CREATION_DATE
				  , LAST_UPDATED_BY
				  , LAST_UPDATE_DATE
				  , ATTRIBUTE1
				  )
			 SELECT A.DIVISION_ID
				  , A.PROJECT_CODE
				  , A.SCM_SITE_ID
				  , A.ITEM_ID
				  , ISNULL(A.FCST_TYPE,'')
				  , A.INCOTERMS
				  , A.TRANSPORT_MODE		
				  , A.BOD_ID
				  , 'SHIP_REQ'				
				  , A.PLANT_SITE_ID 
				  , 'SALES'					
				  , A.YYYYMMDD
				  , SUM(A.QTY)
				  , 'System'		
				  , getdate()	
				  , 'System'		
				  , getdate()	
				  , N'N'					AS ATTRIBUTE1
			   FROM #BUF_AMEND_PLAN_SSP_R_XLS				AS A WITH(NOLOCK)	
				    INNER JOIN TH_UIS_CAL			AS O WITH(NOLOCK)  
				 ON A.YYYYMMDD			= O.YYYYMMDD
				    JOIN SY_SCM_MST_SITE					AS TS WITH(NOLOCK) 
				 ON A.DIVISION_ID		= TS.DIVISION_ID
				AND A.SCM_SITE_ID			= TS.SCM_SITE_ID 
				    LEFT OUTER JOIN SY_SCM_MST_SITE			AS FS  WITH(NOLOCK) 
				 ON A.DIVISION_ID		= FS.DIVISION_ID 
				AND A.PLANT_SITE_ID			= FS.SCM_SITE_ID
				    LEFT OUTER JOIN SY_DM_PLN_SHIPMENT_REQ	AS E  WITH(NOLOCK) 
				 ON A.DIVISION_ID		= E.DIVISION_ID 
				AND A.PROJECT_CODE		= E.PROJECT_CODE 
				AND A.SCM_SITE_ID		= E.SCM_SITE_ID 
				AND A.ITEM_ID			= E.ITEM_ID 
				AND A.FCST_TYPE			= E.FCST_TYPE 
				AND A.INCOTERMS			= E.INCOTERMS 
				AND A.TRANSPORT_MODE	= E.TRANSPORT_MODE 
				AND A.MEASURE           = E.MEASURE
				AND A.PLANT_SITE_ID		= E.PLANT_SITE_ID 
				AND A.YYYYMMDD			= E.YYYYMMDD 
				AND E.QTY				<> 0 
			  WHERE 1 = 1
				AND A.YYYYMMDD			>= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10) , getdate()), 112) -- 확정구간 보존
				AND A.YYYYMMDD          <  CONVERT(VARCHAR, DATEADD(D, 365, getdate()) ,112)
				AND E.DIVISION_ID	IS NULL						-- 키가 겹치는 경우 제외
				AND ISNULL(TS.ATTRIBUTE2, 'N') = 'Y'				-- 자동 생성여부를 SITE 별로 적용
				AND A.QTY				<> 0
				AND A.SCM_SITE_ID NOT IN (
				                      SELECT SCM_SITE_ID 
										FROM SY_SCM_MST_SITE WITH(NOLOCK) 
									   WHERE DIVISION_ID		= '81_UC'
										 AND OPERATION_GROUP	= 'W'  
										 AND SITE_TYPE		    = 'SALES' 
										 AND VALID_YN			= 'Y'
									  )
			  GROUP BY 
				    A.DIVISION_ID
				  , A.PROJECT_CODE
				  , A.SCM_SITE_ID
				  , A.ITEM_ID
				  , ISNULL(A.FCST_TYPE,'')
				  , A.INCOTERMS
				  , A.TRANSPORT_MODE
				  , A.MEASURE
				  , A.PLANT_SITE_ID 
				  , A.YYYYMMDD

		COMMIT TRAN

        SELECT 'OK' as ret, '' as msg   
		PRINT 'OK'
		SET @p_return = 'OK' 

	END TRY

	BEGIN CATCH

		IF @@TRANCOUNT > 0
			ROLLBACK TRAN

		SELECT 'NG' as ret, ERROR_MESSAGE() as msg
		PRINT 'NG|' + ERROR_MESSAGE()
		SET @p_return = 'NG|' + ERROR_MESSAGE()

		if object_id('tempdb..#BUF_AMEND_PLAN_SSP_R_XLS') is not null
			drop table #BUF_AMEND_PLAN_SSP_R_XLS

	END CATCH

	if object_id('tempdb..#BUF_AMEND_PLAN_SSP_R_XLS') is not null
		drop table #BUF_AMEND_PLAN_SSP_R_XLS

END



