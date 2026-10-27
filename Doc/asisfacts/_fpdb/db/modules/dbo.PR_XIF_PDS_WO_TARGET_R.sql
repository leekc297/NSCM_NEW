
CREATE PROCEDURE [dbo].[PR_XIF_PDS_WO_TARGET_R]

-- ================================================================================================
-- Program ID          : FPX0004
-- Program Name        : PR_XIF_PDS_WO_TARGET_R
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : PDS (Process Development System)
-- Destination System  : FP SDB
-- Source Table        : 
-- Destination Table   : FP_WEEKLY_DEMAND_PRODUCT_PDS_H
--
-- Create(Update) Date : 2023.09.01
-- Author              : FP Pjt.
-- Version             : 1.0
--					     1.1 2024.12.06 FP Pjt. PDS_EQUIPMENT_ID 적용
--                       1.2 2025-03-01 FP Pjt. PDS_TARGET_ID 적용	-- PDS-4MCC 고도화 관련  (2025-03-19)
/* 2026/03/04   SYngSn			E20260316-000249 : FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건*/
-- 2026.08.04    kimcd   1.3 [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_PDS_WO_TARGET_R'
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
	DECLARE	@v_SHOP_GROUP_ID	[nvarchar](1) 
	DECLARE	@v_PDS_PLAN_ID		[nvarchar](30) 
	DECLARE	@v_PDS_TARGET_ID	[nvarchar](150) 
	DECLARE	@v_MODEL			[nvarchar](150) 
	DECLARE	@v_ITEM_ID			[nvarchar](150) 
	DECLARE	@v_MARKET			[nvarchar](10) 
	DECLARE	@v_PRODUCTION_TYPE	[nvarchar](30) 
	DECLARE	@v_PROD_VER_CODE	[nvarchar](50) 
	DECLARE	@v_FACTORY_ID		[nvarchar](30) 
	DECLARE	@v_LINE_ID			[nvarchar](30) 
	DECLARE	@v_OPERATION_ID		[nvarchar](30) 
	DECLARE	@v_DUE_DATE			[date] 
	DECLARE	@v_SEQ				[int]
	DECLARE	@v_MFG_WEEK			[nvarchar](10) 
	DECLARE	@v_MFG_QTY			[numeric](18, 0) 
	DECLARE	@v_MFG_QTY_UOM		[nvarchar](50) 
	DECLARE	@v_DESCRIPTION		[nvarchar](150) 
	DECLARE	@v_DEMAND_TYPE		[nvarchar](10) 
	DECLARE	@v_IS_PREV_SCHEDULE [nvarchar](1) 
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
	DECLARE	@v_ATTR_13			[nvarchar](1000) 	-- PDS-4MCC 고도화 관련  (2025-03-19)


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================

	    IF OBJECT_ID('tempdb..#XIF_PDS_TARGET_R') IS NOT NULL
            DROP TABLE #XIF_PDS_TARGET_R

		CREATE TABLE #XIF_PDS_TARGET_R  (
		    TID							INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
			[IF_SEQ] [nvarchar](50) NOT NULL,
			[IF_TYPE] [nvarchar](1) NOT NULL,
			[IF_ID] [nvarchar](50) NOT NULL,
			[IF_RCV_DATE] [datetime] NOT NULL,
			[PROC_FLAG] [nvarchar](1) NOT NULL,
			[PROC_DATE] [datetime] NULL,
			[PROC_MSG] [nvarchar](1000) NULL,
			[COMPANY_ID] [nvarchar](30) NOT NULL,
			[DIVISION_ID] [nvarchar](30) NOT NULL,
			[SITE_ID] [nvarchar](30) NOT NULL,
			[PLANT_ID] [nvarchar](30) NOT NULL,
			[SHOP_GROUP_ID] [nvarchar](1) NOT NULL,
			[PDS_PLAN_ID] [nvarchar](30) NOT NULL,
			[PDS_TARGET_ID] [nvarchar](150) NOT NULL,
			[MODEL] [nvarchar](150) NOT NULL,
			[ITEM_ID] [nvarchar](150) NOT NULL,
			[MARKET] [nvarchar](10) NOT NULL,
			[PRODUCTION_TYPE] [nvarchar](30) NOT NULL,
			[PROD_VER_CODE] [nvarchar](50) NOT NULL,
			[FACTORY_ID] [nvarchar](30) NOT NULL,
			[LINE_ID] [nvarchar](30) NOT NULL,
			[OPERATION_ID] [nvarchar](30) NOT NULL,
			[DUE_DATE] [date] NOT NULL,
			[SEQ] [int] NOT NULL,
			[MFG_WEEK] [nvarchar](10) NULL,
			[MFG_QTY] [numeric](18, 0) NOT NULL,
			[MFG_QTY_UOM] [nvarchar](50) NOT NULL,
			[DESCRIPTION] [nvarchar](150) NULL,
			[DEMAND_TYPE] [nvarchar](10) NULL,
			[IS_PREV_SCHEDULE] [nvarchar](1) NULL,
			[ATTR_01] [nvarchar](1000) NULL,
			[ATTR_02] [nvarchar](1000) NULL,
			[ATTR_03] [nvarchar](1000) NULL,
			[ATTR_04] [nvarchar](1000) NULL,
			[ATTR_05] [nvarchar](1000) NULL,
			[ATTR_06] [nvarchar](1000) NULL,
			[ATTR_07] [nvarchar](1000) NULL,
			[ATTR_08] [nvarchar](1000) NULL,
			[ATTR_09] [nvarchar](1000) NULL,
			[ATTR_10] [nvarchar](1000) NULL,
			[ATTR_13] [nvarchar](1000) NULL		-- PDS-4MCC 고도화 관련  (2025-03-19)
		) 

		INSERT INTO #XIF_PDS_TARGET_R (
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
              ,[SHOP_GROUP_ID]
              ,[PDS_PLAN_ID]
              ,[PDS_TARGET_ID]
              ,[MODEL]
              ,[ITEM_ID]
              ,[MARKET]
              ,[PRODUCTION_TYPE]
              ,[PROD_VER_CODE]
              ,[FACTORY_ID]
              ,[LINE_ID]
              ,[OPERATION_ID]
              ,[DUE_DATE]
              ,[SEQ]
              ,[MFG_WEEK]
              ,[MFG_QTY]
              ,[MFG_QTY_UOM]
              ,[DESCRIPTION]
              ,[DEMAND_TYPE]
              ,[IS_PREV_SCHEDULE]
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
	      ,[ATTR_13]	-- PDS-4MCC 고도화 관련  (2025-03-19)
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
              ,S.[SHOP_GROUP_ID]
              ,S.[PDS_PLAN_ID]
              ,S.[PDS_TARGET_ID]
              ,S.[MODEL]
              ,S.[ITEM_ID]
              ,S.[MARKET]
              ,S.[PRODUCTION_TYPE]
              ,ISNULL(( SELECT TOP 1  CASE WHEN S.[PROD_VER_CODE] IS NOT NULL THEN CONCAT(S.[PROD_VER_CODE],SSLV.ATTRIBUTE3) ELSE NULL END
			            FROM   SCM_SYS_LOOKUP_VALUE SSLV WITH(NOLOCK)   -- 2026-08-04 kimcd LINE별 버전 반영
					    WHERE  SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
						AND    SSLV.SEGMENT4 = S.FACTORY_ID
					    AND    SSLV.SEGMENT5 = S.LINE_ID ), S.[PROD_VER_CODE])  -- 2026.08.04    kimcd   1.4 [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
              ,S.[FACTORY_ID]
              ,S.[LINE_ID]
              ,S.[OPERATION_ID]
              ,S.[DUE_DATE]
              ,S.[SEQ]
              ,C.ISO_YYYYWW AS MFG_WEEK
              ,S.[MFG_QTY]
              ,S.[MFG_QTY_UOM]
              ,S.[DESCRIPTION]
              ,S.[DEMAND_TYPE]
              ,S.[IS_PREV_SCHEDULE]
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
	      ,ISNULL(S.[ATTR_13],'-') AS ATTR_13	-- PDS-4MCC 고도화 관련  (2025-03-19)
		  from sy_XIF_PDS_TARGET_R as S with(nolock)
		       JOIN scm_factory_m as T with(nolock)
		    on s.factory_id = t.factory_id
			   JOIN th_uis_cal as c with(nolock)
			on s.DUE_DATE = c.DT
		 where 1 = 1
		   and s.if_id = 'GPDS_OFP0_PDS_WO_TARGET'
		   and s.proc_flag = 'N'
		   order by s.if_seq
		   ;

		SELECT @INX			= 1
			  ,@MAX_NUM		= COUNT(*)
		  FROM #XIF_PDS_TARGET_R


		WHILE @INX <= @MAX_NUM
		BEGIN

			select 
               @v_COMPANY_ID		= [COMPANY_ID]
              ,@v_DIVISION_ID		= [DIVISION_ID]
              ,@v_SITE_ID			= [SITE_ID]
              ,@v_PLANT_ID			= [PLANT_ID]
              ,@v_SHOP_GROUP_ID		= [SHOP_GROUP_ID]
              ,@v_PDS_PLAN_ID		= [PDS_PLAN_ID]
              ,@v_PDS_TARGET_ID		= [PDS_TARGET_ID]
              ,@v_MODEL				= [MODEL]
              ,@v_ITEM_ID			= [ITEM_ID]
              ,@v_MARKET			= [MARKET]
              ,@v_PRODUCTION_TYPE	= [PRODUCTION_TYPE]
              ,@v_PROD_VER_CODE		= [PROD_VER_CODE]
              ,@v_FACTORY_ID		= [FACTORY_ID]
              ,@v_LINE_ID			= [LINE_ID]
              ,@v_OPERATION_ID		= [OPERATION_ID]
              ,@v_DUE_DATE			= [DUE_DATE]
              ,@v_SEQ				= [SEQ]
              ,@v_MFG_WEEK			= [MFG_WEEK]
              ,@v_MFG_QTY			= [MFG_QTY]
              ,@v_MFG_QTY_UOM		= [MFG_QTY_UOM]
              ,@v_DESCRIPTION		= [DESCRIPTION]
              ,@v_DEMAND_TYPE		= [DEMAND_TYPE]
              ,@v_IS_PREV_SCHEDULE	= [IS_PREV_SCHEDULE]
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
	      ,@v_ATTR_13			= [ATTR_13]	-- PDS-4MCC 고도화 관련  (2025-03-19)
		     from #XIF_PDS_TARGET_R
			where tid = @inx
			;


		   IF((select count(*) 
		         from [DBO].[FP_WEEKLY_DEMAND_PRODUCT_PDS_H] with(nolock) 
		        where COMPANY_ID		= @v_company_id
				  and DIVISION_ID		= @v_division_id
				  and SITE_ID			= @v_site_id
				  and PLANT_ID			= @v_plant_id
				  and SHOP_GROUP_ID		= @v_shop_group_id
				  and PDS_TARGET_ID_ORG = @v_pds_target_id
			  ) > 0 )
			BEGIN
			   update [DBO].[FP_WEEKLY_DEMAND_PRODUCT_PDS_H]
				  SET DUE_DATE			= @v_DUE_DATE
				    , SEQ               = @v_SEQ
					, MFG_WEEK          = @v_MFG_WEEK
					, UPDATE_ID			= @v_proc_name
					, UPDATE_TIME		= getdate()
					, PDS_EQUIPMENT_ID  = @v_ATTR_13		-- PDS-4MCC 고도화 관련  (2025-03-19)
					, PLM_EC_NO         = @v_PDS_TARGET_ID		-- PDS-4MCC 고도화 관련  (2025-03-19)
			    where COMPANY_ID		= @v_COMPANY_ID
			      AND DIVISION_ID		= @v_DIVISION_ID
			      AND SITE_ID			= @v_SITE_ID
			      AND PLANT_ID			= @v_PLANT_ID
			      AND SHOP_GROUP_ID		= @v_SHOP_GROUP_ID
			      AND PDS_TARGET_ID_ORG = @v_PDS_TARGET_ID

			END
			ELSE
			BEGIN

				INSERT [DBO].[FP_WEEKLY_DEMAND_PRODUCT_PDS_H]
					 ( [COMPANY_ID]
					 , [DIVISION_ID]
					 , [SITE_ID]
					 , [PLANT_ID]
					 , [SHOP_GROUP_ID]
					 , [PDS_PLAN_ID]
					 , [PDS_TARGET_ID]
					 , [MODEL]
					 , [ITEM_ID]
					 , [MARKET]
					 , [PRODUCTION_TYPE]
					 , [VERSION]
					 , [PLM_EC_NO]
					 , [FACTORY_ID]
					 , [LINE_ID]
					 , [OPERATION_ID]
					 , [DUE_DATE]
					 , [SEQ]
					 , [MFG_WEEK]
					 , [MFG_QTY]
					 , [MFG_QTY_UOM]
					 , [DESCRIPTION]
					 , [DEMAND_TYPE]
					 , [IS_PREV_SCHEDULE]
					 , [INSERT_ID]
					 , [INSERT_TIME]
					 , [UPDATE_ID]
					 , [UPDATE_TIME]
					 , [PDS_TARGET_ID_ORG]
					 , PDS_EQUIPMENT_ID	-- PDS-4MCC 고도화 관련  (2025-03-19)
					 , ACTIVE_FLAG      --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
					 )
				VALUES 
					 ( @v_COMPANY_ID
					 , @v_DIVISION_ID
					 , @v_SITE_ID
					 , @v_PLANT_ID
					 , @v_SHOP_GROUP_ID
					 , @v_PDS_PLAN_ID
					 , @v_PDS_PLAN_ID + '_' + RIGHT('0000000000' + convert(varchar, NEXT VALUE FOR [dbo].[XIF_PDS_SEQ]) , 10)
					 , @v_MODEL
					 , @v_ITEM_ID
					 , @v_MARKET
					 , @v_PRODUCTION_TYPE
					 , @v_PROD_VER_CODE
					 , @v_PDS_TARGET_ID	-- PDS-4MCC 고도화 관련  (2025-03-19)
					 , @v_FACTORY_ID
					 , @v_LINE_ID
					 , @v_OPERATION_ID
					 , @v_DUE_DATE
					 , @v_SEQ
					 , @v_MFG_WEEK
					 , @v_MFG_QTY
					 , @v_MFG_QTY_UOM
					 , @v_DESCRIPTION
					 , @v_DEMAND_TYPE
					 , @v_IS_PREV_SCHEDULE
					 , @v_proc_name
					 , getdate()
					 , @v_proc_name
					 , getdate()
					 , @v_PDS_TARGET_ID
					 , @v_ATTR_13		-- PDS-4MCC 고도화 관련  (2025-03-19)
					 , 'Y'              --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
					 )
					 ;

			END


			SET @INX = @INX + 1

		END


		UPDATE X
		   SET PROC_FLAG = 'Y'
		     , PROC_DATE = getdate()
		  FROM sy_XIF_PDS_TARGET_R AS X WITH(NOLOCK)
		       JOIN #XIF_PDS_TARGET_R AS T
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

	IF OBJECT_ID('tempdb..#XIF_PDS_TARGET_R') IS NOT NULL
        DROP TABLE #XIF_PDS_TARGET_R

END



