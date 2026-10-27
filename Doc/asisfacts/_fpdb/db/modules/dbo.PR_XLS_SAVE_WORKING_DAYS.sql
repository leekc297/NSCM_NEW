
/*
 * Program ID   : PR_XLS_SAVE_WORKING_DAYS
 * Description  : CAPA_UI_LOSS_TYPE_DEFINIT : Not-Available	/ Shut Down of Holiday
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.09.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec PR_XLS_SAVE_WORKING_DAYS 'UC1', 'crjung'
 */

CREATE PROCEDURE [dbo].[PR_XLS_SAVE_WORKING_DAYS]
    @p_apl_code					nvarchar(max) = 'UC1'
,	@p_user_id					NVARCHAR(MAX)   
,   @p_return					NVARCHAR(max) = NULL OUTPUT
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

	if object_id('tempdb..#BUF_SCM_WORK_CALENDAR_M') is not null
		drop table #BUF_SCM_WORK_CALENDAR_M


	create table #BUF_SCM_WORK_CALENDAR_M (
	          TID				    INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, [COMPANY_ID]			[nvarchar](30) NOT NULL
			, [DIVISION_ID]			[nvarchar](30) NOT NULL
			, [SITE_ID]				[nvarchar](30) NOT NULL
			, [PLANT_ID]			[nvarchar](30) NOT NULL
			, [FACTORY_ID]			[nvarchar](30) NOT NULL
			, [OPERATION_ID]		[nvarchar](30) NOT NULL
			, [LINE_ID]				[nvarchar](30) NOT NULL
			, [ELECTRODE_TYPE]		[nvarchar](30) NOT NULL
			, [WORK_DATE]			[datetime] NOT NULL
			, [LOSS_CODE]			[nvarchar](150) NOT NULL
			, [TIME_TERM]			[numeric](20, 10) NOT NULL
			, [TIME_TERM_RESULT]	[numeric](20, 10) NOT NULL
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
	declare @work_DATE 					datetime
    declare @LOSS_CODE                  nvarchar(150)
	declare @TIME_TERM                  numeric(20, 10)
	declare @TIME_TERM_RESULT           numeric(20, 10)
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
		 where lookup_type_code = 'XLS_PLAN_APL_PLANT'
		   and segment1 = @v_apl_code
		   and active_flag = 'Y'


	    insert into #BUF_SCM_WORK_CALENDAR_M
		    ( 
			  [COMPANY_ID]		
			, [DIVISION_ID]		
			, [SITE_ID]			
			, [PLANT_ID]		
			, [FACTORY_ID]		
			, [OPERATION_ID]	
			, [LINE_ID]			
			, [ELECTRODE_TYPE]	
			, [WORK_DATE]		
			, [LOSS_CODE]		
			, [TIME_TERM]		
			, [TIME_TERM_RESULT]
			, [DESCRIPTION]		
			, [INSERT_ID]		
			, [INSERT_TIME]		
			, [UPDATE_ID]		
			, [UPDATE_TIME]		
			)
	   SELECT 
			  [COMPANY_ID]		
			, [DIVISION_ID]		
			, [SITE_ID]			
			, [PLANT_ID]		
			, [FACTORY_ID]		
			, [OPERATION_ID]	
			, [LINE_ID]			
			, [ELECTRODE_TYPE]	
			, [WORK_DATE]		
			, 'EL001' AS [LOSS_CODE]		
			, ROUND(1440*(1-[TIME_TERM]), 0) AS TIME_TERM		
			, [TIME_TERM_RESULT]
			, [DESCRIPTION]		
			, [INSERT_ID]		
			, [INSERT_TIME]		
			, [UPDATE_ID]		
			, [UPDATE_TIME]	
		 FROM BUF_SCM_WORK_CALENDAR_M with(nolock)
	    where JOB_USER_ID	= @p_user_id
		  AND COMPANY_ID	= @v_company_id
		  AND DIVISION_ID	= @v_division_id
		  AND SITE_ID		= @v_site_id
		  AND PLANT_Id		IN (@v_plant_id, @v_elec_plant_id)


		SELECT @INX			= 1
			 , @MAX_NUM		= COUNT(*)
		  FROM #BUF_SCM_WORK_CALENDAR_M
	  
		IF @MAX_NUM = 0
		BEGIN
			RAISERROR  ( 'No data in buf table.', 16, 1 ); 
		END

		BEGIN TRAN

		WHILE @INX <= @MAX_NUM
		BEGIN

			SELECT  @COMPANY_ID		          = [COMPANY_ID]			
				  , @DIVISION_ID 			  = [DIVISION_ID]		
				  , @SITE_ID 				  = [SITE_ID]			
				  , @PLANT_ID 				  = [PLANT_ID]		
				  , @FACTORY_ID 			  = [FACTORY_ID]		
				  , @OPERATION_ID 			  = [OPERATION_ID]	
				  , @LINE_ID 				  = [LINE_ID]			
				  , @ELECTRODE_TYPE 		  = [ELECTRODE_TYPE]	
				  , @work_DATE 				  = [WORK_DATE]		
				  , @LOSS_CODE          	  = [LOSS_CODE]		
				  , @TIME_TERM          	  = [TIME_TERM]		
				  , @TIME_TERM_RESULT   	  = [TIME_TERM_RESULT]
				  , @DESCRIPTION        	  = [DESCRIPTION]		
				  , @INSERT_ID				  = [INSERT_ID]		
				  , @INSERT_TIME			  = [INSERT_TIME]		
				  , @UPDATE_ID				  = [UPDATE_ID]		
				  , @UPDATE_TIME			  = [UPDATE_TIME]	
			   FROM #BUF_SCM_WORK_CALENDAR_M 
			  WHERE TID						= @INX


			  MERGE INTO SCM_WORK_CALENDAR_M AS A
			  USING (SELECT @COMPANY_ID		     AS COMPANY_ID		  
						  , @DIVISION_ID 		 AS DIVISION_ID	
						  , @SITE_ID 			 AS SITE_ID			
						  , @PLANT_ID 			 AS PLANT_ID		
						  , @FACTORY_ID 		 AS FACTORY_ID	
						  , @OPERATION_ID 		 AS OPERATION_ID	
						  , @LINE_ID 			 AS LINE_ID		
						  , @ELECTRODE_TYPE 	 AS ELECTRODE_TYPE
						  , @work_DATE 			 AS WORK_DATE		
						  , @LOSS_CODE           AS LOSS_CODE	
						  , @TIME_TERM           AS TIME_TERM	
						  , @TIME_TERM_RESULT    AS TIME_TERM_RESULT
						  , @DESCRIPTION         AS DESCRIPTION		
						  , @INSERT_ID			 AS INSERT_ID		
						  , @INSERT_TIME		 AS INSERT_TIME		
						  , @UPDATE_ID			 AS UPDATE_ID		
						  , @UPDATE_TIME		 AS UPDATE_TIME	
					) B
				 ON A.[COMPANY_ID]	     = B.[COMPANY_ID]			
				AND A.[DIVISION_ID]		 = B.[DIVISION_ID]		
				AND A.[SITE_ID]			 = B.[SITE_ID]			
				AND A.[PLANT_ID]		 = B.[PLANT_ID]		
				AND A.[FACTORY_ID]		 = B.[FACTORY_ID]		
				AND A.[OPERATION_ID]	 = B.[OPERATION_ID]	
				AND A.[LINE_ID]			 = B.[LINE_ID]			
				AND A.[ELECTRODE_TYPE]	 = B.[ELECTRODE_TYPE]	
				AND A.[WORK_DATE]		 = B.[WORK_DATE]		
				AND A.[LOSS_CODE]		 = B.[LOSS_CODE]		
			  WHEN MATCHED THEN
					UPDATE SET [TIME_TERM]		      = B.[TIME_TERM]		
						     , [TIME_TERM_RESULT]	  = B.[TIME_TERM_RESULT]
						     , [DESCRIPTION]		  = B.[DESCRIPTION]		
						     , [UPDATE_ID]			  = B.[UPDATE_ID]		
						     , [UPDATE_TIME]		  = B.[UPDATE_TIME]	

			  WHEN NOT MATCHED THEN
					INSERT (
						   [COMPANY_ID]		
						 , [DIVISION_ID]		
						 , [SITE_ID]			
						 , [PLANT_ID]		
						 , [FACTORY_ID]		
						 , [OPERATION_ID]	
						 , [LINE_ID]			
						 , [ELECTRODE_TYPE]	
						 , [WORK_DATE]		
						 , [LOSS_CODE]		
						 , [TIME_TERM]		
						 , [TIME_TERM_RESULT]
						 , [DESCRIPTION]		
						 , [INSERT_ID]		
						 , [INSERT_TIME]		
						 , [UPDATE_ID]		
						 , [UPDATE_TIME]	
						 )
				  VALUES (
						   B.[COMPANY_ID]		
						 , B.[DIVISION_ID]		
						 , B.[SITE_ID]			
						 , B.[PLANT_ID]		
						 , B.[FACTORY_ID]		
						 , B.[OPERATION_ID]	
						 , B.[LINE_ID]			
						 , B.[ELECTRODE_TYPE]	
						 , B.[WORK_DATE]		
						 , B.[LOSS_CODE]		
						 , B.[TIME_TERM]		
						 , B.[TIME_TERM_RESULT]
						 , B.[DESCRIPTION]		
						 , B.[INSERT_ID]		
						 , B.[INSERT_TIME]		
						 , B.[UPDATE_ID]		
						 , B.[UPDATE_TIME]	
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

	if object_id('tempdb..#BUF_SCM_WORK_CALENDAR_M') is not null
		drop table #BUF_SCM_WORK_CALENDAR_M

END



