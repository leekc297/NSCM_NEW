
CREATE PROCEDURE [dbo].[PR_XIF_PDS_WO_TARGET_VERSION_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_PDS_WO_TARGET_VERSION_R
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : PDS (Process Development System)
-- Destination System  : FP SDB
-- Source Table        : 
-- Destination Table   : FP_PDS_TARGET_VERSION_H
--
-- Create(Update) Date : 2023.09.01
-- Author              : FP Pjt.
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_PDS_WO_TARGET_VERSION_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @INX		INT	= 0;
    DECLARE @MAX_NUM	INT	= 0;

	DECLARE	@v_COMPANY_ID		[nvarchar](30)
	DECLARE	@v_DIVISION_ID		[nvarchar](30) 
	DECLARE	@v_SITE_ID			[nvarchar](30) 
	DECLARE	@v_PLANT_ID			[nvarchar](30) 
	DECLARE	@v_FACTORY_ID		[nvarchar](30) 
	DECLARE	@v_SHOP_GROUP_ID	[nvarchar](1) 
	DECLARE	@v_LINE_ID			[nvarchar](30) 
    DECLARE @v_MODEL			[nvarchar](150) 
    DECLARE @v_PROD_VER_CODE	[nvarchar](50) 
    DECLARE @v_OPERATION_ID		[nvarchar](30) 
    DECLARE @v_ITEM_ID			[nvarchar](150) 
    DECLARE @v_EQPT_VER_TEXT	[nvarchar](1000) 
	DECLARE	@v_ATTR_01			[nvarchar](1000) 
	DECLARE	@v_ATTR_02			[nvarchar](1000) 
	DECLARE	@v_ATTR_03			[nvarchar](1000) 
	DECLARE	@v_ATTR_04			[nvarchar](1000) 
	DECLARE	@v_ATTR_05			[nvarchar](1000) 
	DECLARE	@v_ATTR_06			[nvarchar](1000) 
	DECLARE	@v_ATTR_07			[nvarchar](1000) 
	DECLARE	@v_ATTR_08			[nvarchar](1000) 
	DECLARE	@v_ATTR_09			[nvarchar](1000) 
	DECLARE	@v_ATTR_10			[nvarchar](1000) 


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================

	    IF OBJECT_ID('tempdb..#XIF_PDS_TARGET_VERSION_R') IS NOT NULL
            DROP TABLE #XIF_PDS_TARGET_VERSION_R

		CREATE TABLE #XIF_PDS_TARGET_VERSION_R  (
		    TID							INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
			[IF_SEQ]		[nvarchar](50) NOT NULL,
			[IF_TYPE]		[nvarchar](1) NOT NULL,
			[IF_ID]			[nvarchar](50) NOT NULL,
			[IF_RCV_DATE]	[datetime] NOT NULL,
			[PROC_FLAG]		[nvarchar](1) NOT NULL,
			[PROC_DATE]		[datetime] NULL,
			[PROC_MSG]		[nvarchar](1000) NULL,
	        [COMPANY_ID]	[nvarchar](30) NOT NULL,
	        [DIVISION_ID]	[nvarchar](30) NOT NULL,
	        [SITE_ID]		[nvarchar](30) NOT NULL,
	        [PLANT_ID]		[nvarchar](30) NOT NULL,
	        [FACTORY_ID]	[nvarchar](30) NOT NULL,
	        [SHOP_GROUP_ID] [nvarchar](1) NOT NULL,
	        [LINE_ID]		[nvarchar](30) NOT NULL,
	        [MODEL]			[nvarchar](150) NOT NULL,
	        [PROD_VER_CODE] [nvarchar](50) NOT NULL,
	        [OPERATION_ID]	[nvarchar](30) NOT NULL,
	        [ITEM_ID]		[nvarchar](150) NOT NULL,
	        [EQPT_VER_TEXT] [nvarchar](1000) NOT NULL,
	        [ATTR_01]		[nvarchar](1000) NULL,
			[ATTR_02]		[nvarchar](1000) NULL,
			[ATTR_03]		[nvarchar](1000) NULL,
			[ATTR_04]		[nvarchar](1000) NULL,
			[ATTR_05]		[nvarchar](1000) NULL,
			[ATTR_06]		[nvarchar](1000) NULL,
			[ATTR_07]		[nvarchar](1000) NULL,
			[ATTR_08]		[nvarchar](1000) NULL,
			[ATTR_09]		[nvarchar](1000) NULL,
			[ATTR_10]		[nvarchar](1000) NULL
		) 


		INSERT INTO #XIF_PDS_TARGET_VERSION_R (
               [IF_SEQ]
              ,[IF_TYPE]
              ,[IF_ID]
              ,[IF_RCV_DATE]
              ,[PROC_FLAG]
              ,[PROC_DATE]
              ,[PROC_MSG]
              ,[COMPANY_ID]	
              ,[DIVISION_ID]	
              ,[SITE_ID]		
              ,[PLANT_ID]		
              ,[FACTORY_ID]	
              ,[SHOP_GROUP_ID] 
              ,[LINE_ID]		
              ,[MODEL]			
              ,[PROD_VER_CODE] 
              ,[OPERATION_ID]	
              ,[ITEM_ID]		
              ,[EQPT_VER_TEXT] 
              ,[ATTR_01]
              ,[ATTR_02]
              ,[ATTR_03]
              ,[ATTR_04]
              ,[ATTR_05]
              ,[ATTR_06]
              ,[ATTR_07]
              ,[ATTR_08]
              ,[ATTR_09]
              ,[ATTR_10]
		)
        SELECT S.[IF_SEQ]
              ,S.[IF_TYPE]
              ,S.[IF_ID]
              ,S.[IF_RCV_DATE]
              ,S.[PROC_FLAG]
              ,S.[PROC_DATE]
              ,S.[PROC_MSG]
              ,S.[COMPANY_ID]	
              ,T.[DIVISION_ID]	
              ,S.[SITE_ID]		
              ,S.[PLANT_ID]		
              ,S.[FACTORY_ID]	
              ,S.[SHOP_GROUP_ID] 
              ,S.[LINE_ID]		
              ,S.[MODEL]			
              ,S.[PROD_VER_CODE] 
              ,S.[OPERATION_ID]	
              ,S.[ITEM_ID]		
              ,S.[EQPT_VER_TEXT] 
              ,S.[ATTR_01]
              ,S.[ATTR_02]
              ,S.[ATTR_03]
              ,S.[ATTR_04]
              ,S.[ATTR_05]
              ,S.[ATTR_06]
              ,S.[ATTR_07]
              ,S.[ATTR_08]
              ,S.[ATTR_09]
              ,S.[ATTR_10]
		  from sy_XIF_PDS_TARGET_VERSION_R as S with(nolock)
		       JOIN scm_factory_m as T with(nolock)
		    on s.factory_id = t.factory_id
		 where 1 = 1
		   and s.if_id = 'GPDS_OFP0_PDS_WO_TARGET_VERSION'
		   and s.proc_flag = 'N'
		   order by s.if_seq
		   ;

		SELECT @INX			= 1
			  ,@MAX_NUM		= COUNT(*)
		  FROM #XIF_PDS_TARGET_VERSION_R


		WHILE @INX <= @MAX_NUM
		BEGIN

			select 
               @v_COMPANY_ID		= [COMPANY_ID]	
              ,@v_DIVISION_ID		= [DIVISION_ID]	
              ,@v_SITE_ID			= [SITE_ID]		
              ,@v_PLANT_ID			= [PLANT_ID]		
              ,@v_FACTORY_ID		= [FACTORY_ID]	
              ,@v_SHOP_GROUP_ID		= [SHOP_GROUP_ID] 
              ,@v_LINE_ID			= [LINE_ID]		
              ,@v_MODEL				= [MODEL]			
              ,@v_PROD_VER_CODE		= [PROD_VER_CODE] 
              ,@v_OPERATION_ID		= [OPERATION_ID]	
              ,@v_ITEM_ID			= [ITEM_ID]		
              ,@v_EQPT_VER_TEXT		= [EQPT_VER_TEXT] 
              ,@v_ATTR_01			= [ATTR_01]
              ,@v_ATTR_02			= [ATTR_02]
              ,@v_ATTR_03			= [ATTR_03]
              ,@v_ATTR_04			= [ATTR_04]
              ,@v_ATTR_05			= [ATTR_05]
              ,@v_ATTR_06			= [ATTR_06]
              ,@v_ATTR_07			= [ATTR_07]
              ,@v_ATTR_08			= [ATTR_08]
              ,@v_ATTR_09			= [ATTR_09]
              ,@v_ATTR_10			= [ATTR_10]
		     from #XIF_PDS_TARGET_VERSION_R
			where tid = @inx
			;


		   IF((select count(*) from [dbo].[FP_PDS_TARGET_VERSION_H] with(nolock) 
		        where factory_id		= @v_factory_id
				  and line_id			= @v_line_id
				  and model				= @v_model
				  and prod_ver_code		= @v_prod_ver_code
				  and operation_id		= @v_operation_id
				  and item_id			= @v_item_id
			  ) > 0 )
			BEGIN
			   update [dbo].[FP_PDS_TARGET_VERSION_H]
				  SET EQPT_VER_TEXT		= @v_eqpt_ver_text
					, UPDATE_ID			= @v_proc_name
					, UPDATE_TIME		= getdate()
		        where factory_id		= @v_factory_id
				  and line_id			= @v_line_id
				  and model				= @v_model
				  and prod_ver_code		= @v_prod_ver_code
				  and operation_id		= @v_operation_id
				  and item_id			= @v_item_id

			END
			ELSE
			BEGIN

				INSERT [dbo].[FP_PDS_TARGET_VERSION_H]
					 ( [COMPANY_ID]	
					 , [DIVISION_ID]	
					 , [SITE_ID]		
					 , [PLANT_ID]		
					 , [FACTORY_ID]	
					 , [SHOP_GROUP_ID] 
					 , [LINE_ID]		
					 , [MODEL]			
					 , [PROD_VER_CODE] 
					 , [OPERATION_ID]	
					 , [ITEM_ID]		
					 , [EQPT_VER_TEXT] 
					 , [INSERT_ID]
					 , [INSERT_TIME]
					 , [UPDATE_ID]
					 , [UPDATE_TIME]
					 )
				VALUES 
					 ( @v_COMPANY_ID		
					 , @v_DIVISION_ID		
					 , @v_SITE_ID			
					 , @v_PLANT_ID			
					 , @v_FACTORY_ID		
					 , @v_SHOP_GROUP_ID		
					 , @v_LINE_ID			
					 , @v_MODEL				
					 , @v_PROD_VER_CODE		
					 , @v_OPERATION_ID		
					 , @v_ITEM_ID			
					 , @v_EQPT_VER_TEXT		
					 , @v_proc_name
					 , getdate()
					 , @v_proc_name
					 , getdate()
					 )
					 ;

			END


			SET @INX = @INX + 1

		END


		UPDATE X
		   SET PROC_FLAG = 'Y'
		     , PROC_DATE = getdate()
		  FROM sy_XIF_PDS_TARGET_VERSION_R AS X WITH(NOLOCK)
		       JOIN #XIF_PDS_TARGET_VERSION_R AS T
			ON X.IF_SEQ = T.IF_SEQ
			;

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

	IF OBJECT_ID('tempdb..#XIF_PDS_TARGET_VERSION_R') IS NOT NULL
        DROP TABLE #XIF_PDS_TARGET_VERSION_R

END



