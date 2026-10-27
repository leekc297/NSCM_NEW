
CREATE PROCEDURE [dbo].[PR_CONV_SCM_BOM_M_SYNC_1]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_CONV_SCM_BOM_M_SYNC_1
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
	DECLARE @v_proc_name		NVARCHAR(100) = 'PR_CONV_SCM_BOM_M_SYNC_1'
	DECLARE @v_descr			NVARCHAR(250)
	DECLARE @v_count			INTEGER	   = 0
	DECLARE @sysdate			DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1			NVARCHAR(1000)
	DECLARE @v_temp2			NVARCHAR(1000)

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

		-- 동기화 : 신규 데이터 Insert 
		INSERT INTO CONV_SCM_BOM_M		
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
		  	   left outer join CONV_SCM_BOM_M as t with(nolock)
		    ON S.COMPANY_ID			= T.COMPANY_ID
		   AND S.DIVISION_ID		= T.DIVISION_ID
		   AND S.SITE_ID			= T.SITE_ID
		   AND S.PLANT_ID			= T.PLANT_ID
		   AND S.PARENT_ITEM_ID		= T.PARENT_ITEM_ID
		   AND S.CHILD_ITEM_ID		= T.CHILD_ITEM_ID
		   AND S.BOM_VERSION_ID		= T.BOM_VERSION_ID
		   AND S.KEY_DATE			= T.KEY_DATE
		 where 1 = 1
		   and t.PARENT_ITEM_ID is null   --new
		   and s.COMPANY_ID			!= 'C100'
		   and x.ITEM_CLASS			!= 'ES1901'
		   and y.ITEM_CLASS			!= 'ES1901'


        -- 동기화 : 기존 데이터 update
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
		  	   join CONV_SCM_BOM_M  as t with(nolock)
		    ON S.COMPANY_ID			= T.COMPANY_ID
		   AND S.DIVISION_ID		= T.DIVISION_ID
		   AND S.SITE_ID			= T.SITE_ID
		   AND S.PLANT_ID			= T.PLANT_ID
		   AND S.PARENT_ITEM_ID		= T.PARENT_ITEM_ID
		   AND S.CHILD_ITEM_ID		= T.CHILD_ITEM_ID
		   AND S.BOM_VERSION_ID		= T.BOM_VERSION_ID
		   AND S.KEY_DATE			= T.KEY_DATE
		 where 1 = 1
		   and s.COMPANY_ID			!= 'C100'
		   and x.ITEM_CLASS			!= 'ES1901'
		   and y.ITEM_CLASS			!= 'ES1901'
		   and s.UPDATE_TIME		!= t.UPDATE_TIME

        update t
		   set
			   T.[BOM_VERSION_LINE] = S.[BOM_VERSION_LINE] 
			 , T.[PARENT_QTY]		= S.[PARENT_QTY]		
			 , T.[PARENT_UOM]		= S.[PARENT_UOM]		
			 , T.[CHILD_QTY]		= S.[CHILD_QTY]		
			 , T.[CHILD_UOM]		= S.[CHILD_UOM]		
			 , T.[ALT_ID]			= S.[ALT_ID]			
			 , T.[ALT_PRIORITY]		= S.[ALT_PRIORITY]		
			 , T.[ALT_RATE]			= S.[ALT_RATE]			
			 , T.[EFF_START_DATE]	= S.[EFF_START_DATE]	
			 , T.[EFF_END_DATE]		= S.[EFF_END_DATE]		
			 , T.[ECO_CODE]			= S.[ECO_CODE]			
			 , T.[PHANTOM]			= S.[PHANTOM]			
			 , T.[STANDARD_FLAG]	= S.[STANDARD_FLAG]	
			 , T.[ACTIVE_FLAG]		= S.[ACTIVE_FLAG]		
			 , T.[DESCRIPTION]		= S.[DESCRIPTION]		
			 , T.[INSERT_ID]		= S.[INSERT_ID]		
			 , T.[INSERT_TIME]		= S.[INSERT_TIME]		
			 , T.[UPDATE_ID]		= S.[UPDATE_ID]		
			 , T.[UPDATE_TIME]		= S.[UPDATE_TIME]		
          from CONV_SCM_BOM_M as t
		       join @SCM_BOM_M as s
		    ON S.COMPANY_ID			= T.COMPANY_ID
		   AND S.DIVISION_ID		= T.DIVISION_ID
		   AND S.SITE_ID			= T.SITE_ID
		   AND S.PLANT_ID			= T.PLANT_ID
		   AND S.PARENT_ITEM_ID		= T.PARENT_ITEM_ID
		   AND S.CHILD_ITEM_ID		= T.CHILD_ITEM_ID
		   AND S.BOM_VERSION_ID		= T.BOM_VERSION_ID
		   AND S.KEY_DATE			= T.KEY_DATE
		 --

 		
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



