
/*
 * Program ID   : PR_XLS_SAVE_PROD_EFFICIENCY
 * Description  : CAPA_UI_LOSS_TYPE_DEFINIT : No-Run / Wait
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.09.01   FP Pjt.         Create.
 * 2024-10-17   --LOSS_RATE / 100   -- 그대로 들어가도록 수정 => 1.0 - x 로 수정     
 * 
 ex) 
   exec PR_XLS_SAVE_PROD_EFFICIENCY 'UC1', 'crjung'
 */

CREATE PROCEDURE [dbo].[PR_XLS_SAVE_PROD_EFFICIENCY]
    @p_apl_code					nvarchar(max) = 'UC1'
,	@p_user_id					NVARCHAR(MAX)  
--,   @p_return					NVARCHAR(max) = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code			NVARCHAR(MAX)
	DECLARE @v_user_id			nvarchar(max)

	declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)

	DECLARE @INX				INT				= 0;
    DECLARE @MAX_NUM			INT				= 0;

	set @v_apl_code				= @p_apl_code
	set @v_user_id				= @p_user_id

	if object_id('tempdb..#BUF_SCM_LOSS_M') is not null
		drop table #BUF_SCM_LOSS_M


	create table #BUF_SCM_LOSS_M (
	          TID				    INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, [COMPANY_ID]			[nvarchar](30) NOT NULL
			, [DIVISION_ID]			[nvarchar](30) NOT NULL
			, [SITE_ID]				[nvarchar](30) NOT NULL
			, [PLANT_ID]			[nvarchar](30) NOT NULL
			, [FACTORY_ID]			[nvarchar](30) NOT NULL
			, [OPERATION_ID]		[nvarchar](30) NOT NULL
			, [LINE_ID]				[nvarchar](30) NOT NULL
			, [ELECTRODE_TYPE]		[nvarchar](30) NOT NULL
			, [WORK_MONTH]			[nvarchar](6) NOT NULL
			, [LOSS_CODE]			[nvarchar](150) NOT NULL
			, [LOSS_RATE]			[numeric](20, 10) NOT NULL
			, [LOSS_RATE_RESULT]	[numeric](20, 10) NULL
			, [DESCRIPTION]			[nvarchar](200) NULL
			, [INSERT_ID]			[nvarchar](150) NULL
			, [INSERT_TIME]			[datetime] NOT NULL
			, [UPDATE_ID]			[nvarchar](150) NULL
			, [UPDATE_TIME]			[datetime] NOT NULL
			)
			;


	declare @COMPANY_ID					nvarchar(30)
	declare @DIVISION_ID 				nvarchar(30)
	declare @SITE_ID 					nvarchar(30)
	declare @PLANT_ID 					nvarchar(30)
	declare @FACTORY_ID 				nvarchar(30)
	declare @OPERATION_ID 				nvarchar(30)
	declare @LINE_ID 					nvarchar(30)
	declare @ELECTRODE_TYPE 			nvarchar(30)
	declare @work_month 				nvarchar(6)
    declare @LOSS_CODE                  nvarchar(150)
	declare @LOSS_RATE                  numeric(20, 10)
	declare @LOSS_RATE_RESULT           numeric(20, 10)
	declare @DESCRIPTION                nvarchar(200)
	declare @INSERT_ID					nvarchar(150)
	declare @INSERT_TIME				datetime
	declare @UPDATE_ID					nvarchar(150)
	declare @UPDATE_TIME				datetime

	BEGIN TRY	
	

		select @v_company_id		= attribute1
			 , @v_division_id		= attribute2
			 , @v_site_id			= attribute3
			 , @v_plant_id			= attribute4
			 , @v_elec_plant_id		= attribute5
		  from dbo.SCM_SYS_LOOKUP_VALUE with(nolock)
		 where lookup_type_code		= 'XLS_PLAN_APL_PLANT'
		   and segment1				= @v_apl_code
		   and active_flag			= 'Y'

	    insert into #BUF_SCM_LOSS_M
		    ( 
			  COMPANY_ID		
			, DIVISION_ID 		
			, SITE_ID 			
			, PLANT_ID 			
			, FACTORY_ID 		
			, OPERATION_ID 		
			, LINE_ID 			
			, ELECTRODE_TYPE 	
			, work_month 		
			, LOSS_CODE         
			, LOSS_RATE         
			, LOSS_RATE_RESULT  
			, DESCRIPTION       
			, INSERT_ID			
			, INSERT_TIME		
			, UPDATE_ID			
			, UPDATE_TIME		
			)
	   SELECT 
			  COMPANY_ID		
			, DIVISION_ID 		
			, SITE_ID 			
			, PLANT_ID 			
			, FACTORY_ID 		
			, OPERATION_ID 		
			, LINE_ID 			
			, ELECTRODE_TYPE 	
			, work_month 		
			, 'EL019' AS LOSS_CODE         
			--, LOSS_RATE / 100   -- 그대로 들어가도록 수정 2024-10-17 => 1.0 - x 로 수정      
            , 1.0 - LOSS_RATE
			, LOSS_RATE_RESULT  
			, DESCRIPTION       
			, INSERT_ID			
			, INSERT_TIME		
			, UPDATE_ID			
			, UPDATE_TIME		
		 FROM BUF_SCM_LOSS_M with(nolock)
	    where JOB_USER_ID	= @p_user_id
		  AND COMPANY_ID	= @v_company_id
		  AND DIVISION_ID	= @v_division_id
		  AND SITE_ID		= @v_site_id
		  AND PLANT_Id		IN (@v_plant_id, @v_elec_plant_id)


		SELECT @INX			= 1
			 , @MAX_NUM		= COUNT(*)
		  FROM #BUF_SCM_LOSS_M
	  
		IF @MAX_NUM = 0
		BEGIN
			RAISERROR  ( 'No data in buf table.', 16, 1 ); 
		END

		BEGIN TRAN

		WHILE @INX <= @MAX_NUM
		BEGIN

			SELECT  @COMPANY_ID				= COMPANY_ID					
				  , @DIVISION_ID 			= DIVISION_ID 			
				  , @SITE_ID 				= SITE_ID 				
				  , @PLANT_ID 				= PLANT_ID 				
				  , @FACTORY_ID 			= FACTORY_ID 			
				  , @OPERATION_ID 			= OPERATION_ID 			
				  , @LINE_ID 				= LINE_ID 				
				  , @ELECTRODE_TYPE 		= ELECTRODE_TYPE 		
				  , @work_month 			= work_month 			
				  , @LOSS_CODE              = LOSS_CODE              
				  , @LOSS_RATE              = LOSS_RATE              
				  , @LOSS_RATE_RESULT       = LOSS_RATE_RESULT       
				  , @DESCRIPTION            = DESCRIPTION            
				  , @INSERT_ID				= INSERT_ID				
				  , @INSERT_TIME			= INSERT_TIME			
				  , @UPDATE_ID				= UPDATE_ID				
				  , @UPDATE_TIME			= UPDATE_TIME			
			   FROM #BUF_SCM_LOSS_M 		 
			  WHERE TID						= @INX


			  MERGE INTO SCM_LOSS_M AS A
			  USING (SELECT @COMPANY_ID		    AS COMPANY_ID				
						  , @DIVISION_ID 		AS DIVISION_ID 		
						  , @SITE_ID 			AS SITE_ID 			
						  , @PLANT_ID 			AS PLANT_ID 			
						  , @FACTORY_ID 		AS FACTORY_ID 			
						  , @OPERATION_ID 		AS OPERATION_ID 		
						  , @LINE_ID 			AS LINE_ID 			
						  , @ELECTRODE_TYPE 	AS ELECTRODE_TYPE 		
						  , @work_month 		AS work_month 			
						  , @LOSS_CODE          AS LOSS_CODE          
						  , @LOSS_RATE          AS LOSS_RATE          
						  , @LOSS_RATE_RESULT   AS LOSS_RATE_RESULT   
						  , @DESCRIPTION        AS DESCRIPTION        
						  , @INSERT_ID			AS INSERT_ID			
						  , @INSERT_TIME		AS INSERT_TIME			
						  , @UPDATE_ID			AS UPDATE_ID			
						  , @UPDATE_TIME		AS UPDATE_TIME			
					) B
				 ON A.[COMPANY_ID]				= B.[COMPANY_ID]			
				AND A.[DIVISION_ID]				= B.[DIVISION_ID]		
				AND A.[SITE_ID]					= B.[SITE_ID]			
				AND A.[PLANT_ID]				= B.[PLANT_ID]		
				AND A.[FACTORY_ID]				= B.[FACTORY_ID]		
				AND A.[OPERATION_ID]			= B.[OPERATION_ID]	
				AND A.[LINE_ID]					= B.[LINE_ID]			
				AND A.[ELECTRODE_TYPE]			= B.[ELECTRODE_TYPE]	
				AND A.[WORK_MONTH]				= B.[WORK_MONTH]		
				AND A.[LOSS_CODE]				= B.[LOSS_CODE]		
			  WHEN MATCHED THEN
					UPDATE SET LOSS_RATE         = B.LOSS_RATE         
						     , LOSS_RATE_RESULT  = B.LOSS_RATE_RESULT  
						     , DESCRIPTION       = B.DESCRIPTION       
						     , UPDATE_ID		 = B.UPDATE_ID			
						     , UPDATE_TIME		 = B.UPDATE_TIME		

			  WHEN NOT MATCHED THEN
					INSERT (
						   COMPANY_ID		
						 , DIVISION_ID 		
						 , SITE_ID 			
						 , PLANT_ID 			
						 , FACTORY_ID 		
						 , OPERATION_ID 		
						 , LINE_ID 			
						 , ELECTRODE_TYPE 	
						 , work_month 		
						 , LOSS_CODE         
						 , LOSS_RATE         
						 , LOSS_RATE_RESULT  
						 , DESCRIPTION       
						 , INSERT_ID			
						 , INSERT_TIME		
						 , UPDATE_ID			
						 , UPDATE_TIME		
						 )
				  VALUES (
						   B.COMPANY_ID		
						 , B.DIVISION_ID 		
						 , B.SITE_ID 			
						 , B.PLANT_ID 			
						 , B.FACTORY_ID 		
						 , B.OPERATION_ID 		
						 , B.LINE_ID 			
						 , B.ELECTRODE_TYPE 	
						 , B.work_month 		
						 , B.LOSS_CODE         
						 , B.LOSS_RATE         
						 , B.LOSS_RATE_RESULT  
						 , B.DESCRIPTION       
						 , B.INSERT_ID			
						 , B.INSERT_TIME		
						 , B.UPDATE_ID			
						 , B.UPDATE_TIME		
						 )
			;


			SET @INX = @INX + 1

		END

		COMMIT TRAN

        SELECT 'OK' as ret, '' as msg   
		PRINT 'OK'
		--SET @p_return = 'OK' 

	END TRY

	BEGIN CATCH

		IF @@TRANCOUNT > 0
			ROLLBACK TRAN

		SELECT 'NG' as ret, ERROR_MESSAGE() as msg
		PRINT 'NG|' + ERROR_MESSAGE()
		--SET @p_return = 'NG|' + ERROR_MESSAGE()

	END CATCH

	if object_id('tempdb..#BUF_SCM_LOSS_M') is not null
		drop table #BUF_SCM_LOSS_M

END



