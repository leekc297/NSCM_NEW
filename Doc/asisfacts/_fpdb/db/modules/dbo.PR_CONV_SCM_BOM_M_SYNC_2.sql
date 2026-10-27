
CREATE PROCEDURE [dbo].[PR_CONV_SCM_BOM_M_SYNC_2]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_CONV_SCM_BOM_M_SYNC_2
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : FP
-- Destination System  : FP
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 
-- Author              : FP Pjt.
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name		NVARCHAR(100) = 'PR_CONV_SCM_BOM_M_SYNC_2'
	DECLARE @v_descr			NVARCHAR(250)
	DECLARE @v_count			INTEGER	   = 0
	DECLARE @sysdate			DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1			NVARCHAR(1000)
	DECLARE @v_temp2			NVARCHAR(1000)

    declare @SCM_BOM_M_Target table
    (
		[COMPANY_ID]		[nvarchar](30),
		[DIVISION_ID]		[nvarchar](30),
		[SITE_ID]			[nvarchar](30),
		[PLANT_ID]			[nvarchar](30),
		[PARENT_ITEM_ID]	[nvarchar](50),
		[CHILD_ITEM_ID]		[nvarchar](50),
		[BOM_VERSION_ID]	[nvarchar](50)
	)


	declare @SCM_BOM_M table
    (
		[COMPANY_ID]		[nvarchar](30),
		[DIVISION_ID]		[nvarchar](30),
		[SITE_ID]			[nvarchar](30),
		[PLANT_ID]			[nvarchar](30),
		[PARENT_ITEM_ID]	[nvarchar](50),
		[CHILD_ITEM_ID]		[nvarchar](50),
		[BOM_VERSION_ID]	[nvarchar](50),
		[KEY_DATE]			[nvarchar](12),
		[BOM_VERSION_LINE]	[nvarchar](50),
		[PARENT_QTY]		[numeric](20, 10),
		[PARENT_UOM]		[nvarchar](10),
		[CHILD_QTY]			[numeric](20, 10),
		[CHILD_UOM]			[nvarchar](10),
		[ALT_ID]			[nvarchar](150),
		[ALT_PRIORITY]		[numeric](20, 10),
		[ALT_RATE]			[numeric](20, 10),
		[EFF_START_DATE]	[datetime],
		[EFF_END_DATE]		[datetime],
		[ECO_CODE]			[nvarchar](50),
		[PHANTOM]			[nvarchar](10),
		[STANDARD_FLAG]		[nvarchar](1),
		[ACTIVE_FLAG]		[nvarchar](1),
		[DESCRIPTION]		[nvarchar](200),
		[INSERT_ID]			[nvarchar](150),
		[INSERT_TIME]		[datetime],
		[UPDATE_ID]			[nvarchar](150),
		[UPDATE_TIME]		[datetime]
	)


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================

		-- Target
		INSERT INTO @SCM_BOM_M_Target	
		          ( [COMPANY_ID]	
		          , [DIVISION_ID]	
		          , [SITE_ID]		
		          , [PLANT_ID]		
		          , [PARENT_ITEM_ID]
		          , [CHILD_ITEM_ID]	
		          , [BOM_VERSION_ID]
		          )		
		SELECT S.[COMPANY_ID]
			 , S.[DIVISION_ID]
			 , S.[SITE_ID]
			 , S.[PLANT_ID]
			 , S.[PARENT_ITEM_ID]
			 , S.[CHILD_ITEM_ID]
			 , S.[BOM_VERSION_ID]
		  from scm_bom_m as s with(nolock) 
			   join scm_item_m as x with(nolock)
		    on s.company_id			= x.company_id
		   and s.division_id		= x.division_id
		   and s.site_id			= x.SITE_ID
		   and s.PARENT_ITEM_ID		= x.ITEM_ID
		  	   join scm_item_m as y with(nolock)
		    on s.company_id			= y.company_id
		   and s.division_id		= y.division_id
		   and s.site_id			= y.SITE_ID
		   and s.CHILD_ITEM_ID		= y.ITEM_ID
		 where 1 = 1
		   and s.COMPANY_ID			!= 'C100'
		   and y.ITEM_CLASS			= 'ES1901'
		 group by
		       s.[COMPANY_ID]	
		     , s.[DIVISION_ID]	
		     , s.[SITE_ID]		
		     , s.[PLANT_ID]		
		     , s.[PARENT_ITEM_ID]
		     , s.[CHILD_ITEM_ID]	
		     , s.[BOM_VERSION_ID]


        -- Target to Parent
		INSERT INTO @SCM_BOM_M
		SELECT S.[COMPANY_ID]
			 , S.[DIVISION_ID]
			 , S.[SITE_ID]
			 , S.[PLANT_ID]
			 , T.[PARENT_ITEM_ID] 
			 , S.[CHILD_ITEM_ID]
			 , S.[BOM_VERSION_ID]
			 , S.[KEY_DATE]
			 , S.[BOM_VERSION_LINE]
			 , S.[PARENT_QTY]
			 , S.[PARENT_UOM]
			 , S.[CHILD_QTY]
			 , S.[CHILD_UOM]
			 , S.[ALT_ID]
			 , S.[ALT_PRIORITY]
			 , S.[ALT_RATE]
			 , S.[EFF_START_DATE]
			 , S.[EFF_END_DATE]
			 , S.[ECO_CODE]
			 , S.[PHANTOM]
			 , S.[STANDARD_FLAG]
			 , S.[ACTIVE_FLAG]
			 , S.[DESCRIPTION]
			 , S.[INSERT_ID]
			 , S.[INSERT_TIME]
			 , S.[UPDATE_ID]
			 , S.[UPDATE_TIME]
		  from scm_bom_m as s with(nolock) 
		  	   join scm_item_m as x with(nolock)
		    on s.company_id			= x.company_id
		   and s.division_id		= x.division_id
		   and s.site_id			= x.SITE_ID
		   and s.PARENT_ITEM_ID		= x.ITEM_ID
		  	   join scm_item_m as y with(nolock)
		    on s.company_id			= y.company_id
		   and s.division_id		= y.division_id
		   and s.site_id			= y.SITE_ID
		   and s.CHILD_ITEM_ID		= y.ITEM_ID
		       join @SCM_BOM_M_Target as t
		    ON S.COMPANY_ID			= T.COMPANY_ID
		   AND S.DIVISION_ID		= T.DIVISION_ID
		   AND S.SITE_ID			= T.SITE_ID
		   AND S.PLANT_ID			= T.PLANT_ID
		   AND S.PARENT_ITEM_ID		= T.CHILD_ITEM_ID
		   AND S.BOM_VERSION_ID		= T.BOM_VERSION_ID
		 where 1 = 1
		   and s.COMPANY_ID			!= 'C100'
		   and x.ITEM_CLASS			= 'ES1901'

		INSERT INTO @SCM_BOM_M
		SELECT S.[COMPANY_ID]
			 , S.[DIVISION_ID]
			 , S.[SITE_ID]
			 , S.[PLANT_ID]
			 , S.[PARENT_ITEM_ID] 
			 , S.[CHILD_ITEM_ID]
			 , S.[BOM_VERSION_ID]
			 , S.[KEY_DATE]
			 , S.[BOM_VERSION_LINE]
			 , S.[PARENT_QTY]
			 , S.[PARENT_UOM]
			 , S.[CHILD_QTY]
			 , S.[CHILD_UOM]
			 , S.[ALT_ID]
			 , S.[ALT_PRIORITY]
			 , S.[ALT_RATE]
			 , S.[EFF_START_DATE]
			 , S.[EFF_END_DATE]
			 , S.[ECO_CODE]
			 , S.[PHANTOM]
			 , S.[STANDARD_FLAG]
			 , S.[ACTIVE_FLAG]
			 , S.[DESCRIPTION]
			 , S.[INSERT_ID]
			 , S.[INSERT_TIME]
			 , S.[UPDATE_ID]
			 , S.[UPDATE_TIME]
		  from scm_bom_m as s with(nolock) 
		       join @SCM_BOM_M as t
		    ON S.COMPANY_ID			= T.COMPANY_ID
		   AND S.DIVISION_ID		= T.DIVISION_ID
		   AND S.SITE_ID			= T.SITE_ID
		   AND S.PLANT_ID			= T.PLANT_ID
		   AND S.PARENT_ITEM_ID		= T.PARENT_ITEM_ID
		   AND S.CHILD_ITEM_ID      = T.CHILD_ITEM_ID
		   AND S.BOM_VERSION_ID		= T.BOM_VERSION_ID
		 where 1 = 1
		   and s.COMPANY_ID			!= 'C100'
		   and not exists (
		                  select *
						    from @SCM_BOM_M as x
						   where 1 = 1
						     and x.company_id		= s.company_id
		                     AND x.DIVISION_ID		= s.DIVISION_ID
		                     AND x.SITE_ID			= s.SITE_ID
		                     AND x.PLANT_ID			= s.PLANT_ID
		                     AND x.PARENT_ITEM_ID	= s.PARENT_ITEM_ID
		                     AND x.CHILD_ITEM_ID    = s.CHILD_ITEM_ID
		                     AND x.BOM_VERSION_ID	= s.BOM_VERSION_ID
		                     AND x.KEY_DATE         = s.KEY_DATE
		                     )

		
		MERGE INTO CONV_SCM_BOM_M AS T
		USING @SCM_BOM_M AS S
		   ON S.COMPANY_ID			= T.COMPANY_ID
		  AND S.DIVISION_ID			= T.DIVISION_ID
		  AND S.SITE_ID				= T.SITE_ID
		  AND S.PLANT_ID			= T.PLANT_ID
		  AND S.PARENT_ITEM_ID		= T.PARENT_ITEM_ID
		  AND S.CHILD_ITEM_ID		= T.CHILD_ITEM_ID
		  AND S.BOM_VERSION_ID		= T.BOM_VERSION_ID
		  AND S.KEY_DATE			= T.KEY_DATE
		 WHEN MATCHED THEN
			  UPDATE SET
				     [BOM_VERSION_LINE] = S.[BOM_VERSION_LINE] 
				   , [PARENT_QTY]		= S.[PARENT_QTY]		
				   , [PARENT_UOM]		= S.[PARENT_UOM]		
				   , [CHILD_QTY]		= S.[CHILD_QTY]		
				   , [CHILD_UOM]		= S.[CHILD_UOM]		
				   , [ALT_ID]			= S.[ALT_ID]			
				   , [ALT_PRIORITY]		= S.[ALT_PRIORITY]		
				   , [ALT_RATE]			= S.[ALT_RATE]			
				   , [EFF_START_DATE]	= S.[EFF_START_DATE]	
				   , [EFF_END_DATE]		= S.[EFF_END_DATE]		
				   , [ECO_CODE]			= S.[ECO_CODE]			
				   , [PHANTOM]			= S.[PHANTOM]			
				   , [STANDARD_FLAG]	= S.[STANDARD_FLAG]	
				   , [ACTIVE_FLAG]		= S.[ACTIVE_FLAG]		
				   , [DESCRIPTION]		= S.[DESCRIPTION]		
				   , [INSERT_ID]		= S.[INSERT_ID]		
				   , [INSERT_TIME]		= S.[INSERT_TIME]		
				   , [UPDATE_ID]		= S.[UPDATE_ID]		
				   , [UPDATE_TIME]		= S.[UPDATE_TIME]
		 WHEN NOT MATCHED THEN
			  INSERT (
		             [COMPANY_ID]
			       , [DIVISION_ID]
			       , [SITE_ID]
			       , [PLANT_ID]
			       , [PARENT_ITEM_ID]
			       , [CHILD_ITEM_ID]
			       , [BOM_VERSION_ID]
			       , [KEY_DATE]
			       , [BOM_VERSION_LINE]
			       , [PARENT_QTY]
			       , [PARENT_UOM]
			       , [CHILD_QTY]
			       , [CHILD_UOM]
			       , [ALT_ID]
			       , [ALT_PRIORITY]
			       , [ALT_RATE]
			       , [EFF_START_DATE]
			       , [EFF_END_DATE]
			       , [ECO_CODE]
			       , [PHANTOM]
			       , [STANDARD_FLAG]
			       , [ACTIVE_FLAG]
			       , [DESCRIPTION]
			       , [INSERT_ID]
			       , [INSERT_TIME]
			       , [UPDATE_ID]
			       , [UPDATE_TIME]
				     )
              VALUES (
		             S.[COMPANY_ID]
			       , S.[DIVISION_ID]
			       , S.[SITE_ID]
			       , S.[PLANT_ID]
			       , S.[PARENT_ITEM_ID]
			       , S.[CHILD_ITEM_ID]
			       , S.[BOM_VERSION_ID]
			       , S.[KEY_DATE]
			       , S.[BOM_VERSION_LINE]
			       , S.[PARENT_QTY]
			       , S.[PARENT_UOM]
			       , S.[CHILD_QTY]
			       , S.[CHILD_UOM]
			       , S.[ALT_ID]
			       , S.[ALT_PRIORITY]
			       , S.[ALT_RATE]
			       , S.[EFF_START_DATE]
			       , S.[EFF_END_DATE]
			       , S.[ECO_CODE]
			       , S.[PHANTOM]
			       , S.[STANDARD_FLAG]
			       , S.[ACTIVE_FLAG]
			       , S.[DESCRIPTION]
			       , S.[INSERT_ID]
			       , S.[INSERT_TIME]
			       , S.[UPDATE_ID]
			       , S.[UPDATE_TIME]
				   )
				   ;

 		
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



