
--ALTER PROCEDURE [dbo].[PR_XIF_DW_ITEM_EQUIP_HIS]
CREATE PROCEDURE [dbo].[PR_XIF_DW_ITEM_EQUIP_HIS]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_DW_ITEM_EQUIP_HIS
-- Param               :
-- Batch Period        : 1 DAY
-- Description         :
--
-- Source System       : FP Interface Table
-- Destination System  : FP SDB
-- Source Table        : XIF_DW_WIP_HISTORY_R
-- Destination Table   : FP_ITEM_EQUIP_RESULT_HIS
--
-- Create Date         : 2016.10.23
-- Update Date         : 2017.04.24
-- Author              : 김 춘 동
-- Version             : 1.0
--                     : 1.1 CUR_MES_RESULT CURSOR  BASE TABLE CHANGE(SY_XIF_DW_WIP_HISTORY_R -> SY_XIF_MES_DAILY_WIP_HISTORY_R)
-- ================================================================================================
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_DW_ITEM_EQUIP_HIS'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME    = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @data_s      INTEGER
	
	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE CUR_MES_RESULT CURSOR FOR
		SELECT ML.[COMPANY_ID]
			 , ML.[DIVISION_ID]
			 , ML.[SITE_ID]
			 , ML.[PLANT_ID]
			 , ML.[FACTORY_ID]
			 , BASE.[OPERATION_ID]
			 , BASE.[LINE_ID]
			 , BASE.[EQUIPMENT_ID]
			 , BASE.[ITEM_ID]
			 , BASE.[LAST_PROD_DATE]
		FROM   [DBO].[SCM_MMD_LINE_M]   ML	with(nolock)
			 , (SELECT SS.[PRODID] AS ITEM_ID       -- ITEM ID
					 , SS.[PROCID] AS OPERATION_ID  -- Operation ID
					 , SS.[EQSGID] AS LINE_ID       -- 설비 세그먼트 ID
					 , ISNULL(SS.[EQPTID],'-')  AS EQUIPMENT_ID  -- 설비 ID
					 --, MAX(DATEADD(SECOND, CAST(SS.WIPDTTM_ST AS NUMERIC(30,3)), '01/01/1970 00:00:00'))   AS LAST_PROD_DATE -- 재공 작업시작일시					 
					 , MAX(CAST(SS.WIPDTTM_ST AS DATETIME)) AS LAST_PROD_DATE -- 재공 작업시작일시
				FROM   [dbo].[SY_XIF_MES_DAILY_WIP_HISTORY_R]  SS	with(nolock)
				WHERE  SS.[CREATE_DATE] > GETDATE() - 2
				AND    SS.[WOID] IS NOT NULL
				AND    SS.WIPDTTM_ST IS NOT NULL
				GROUP  BY SS.[PRODID] -- ITEM ID
						, SS.[PROCID] -- Operation ID
						, SS.[EQSGID] -- LINE ID
						, SS.[EQPTID] -- EQUIPMENT ID 
				) BASE
		WHERE ML.[LINE_ID] = BASE.[LINE_ID]

	DECLARE @COMPANY_ID		 NVARCHAR(30);
	DECLARE @DIVISION_ID	 NVARCHAR(30);
	DECLARE @SITE_ID		 NVARCHAR(30);
	DECLARE @PLANT_ID		 NVARCHAR(30);
	DECLARE @FACTORY_ID 	 NVARCHAR(30);
	DECLARE @OPERATION_ID	 NVARCHAR(30);
	DECLARE @LINE_ID		 NVARCHAR(30);
	DECLARE @EQUIPMENT_ID	 NVARCHAR(30);
	DECLARE @ITEM_ID            NVARCHAR(150);
	DECLARE @LAST_PROD_DATE     DATETIME;
	
	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				
	BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
		SET @v_temp1 = 'STEP OPEN MAIN CURSOR'
		OPEN CUR_MES_RESULT
        FETCH NEXT FROM CUR_MES_RESULT INTO @COMPANY_ID
										  , @DIVISION_ID
										  , @SITE_ID
										  , @PLANT_ID
										  , @FACTORY_ID
										  , @OPERATION_ID
										  , @LINE_ID
										  , @EQUIPMENT_ID
										  , @ITEM_ID
										  , @LAST_PROD_DATE;

        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN

			SET @v_temp1 = 'STEP MERGE [dbo].[SY_XIF_ERP_ITEM_LINE_ASSIGN_S]'
			MERGE INTO [DBO].[FP_ITEM_EQUIP_RESULT_HIS] IER
			USING ( SELECT @COMPANY_ID     AS COMPANY_ID
						 , @DIVISION_ID    AS DIVISION_ID
						 , @SITE_ID        AS SITE_ID
						 , @PLANT_ID       AS PLANT_ID
						 , @FACTORY_ID     AS FACTORY_ID
						 , @OPERATION_ID   AS OPERATION_ID
						 , @LINE_ID        AS LINE_ID
						 , @EQUIPMENT_ID   AS EQUIPMENT_ID
						 , @ITEM_ID        AS ITEM_ID
						 , @LAST_PROD_DATE AS LAST_PROD_DATE ) XXX  -- 
			ON (    IER.[OPERATION_ID] = XXX.[OPERATION_ID]
				AND IER.[LINE_ID]      = XXX.[LINE_ID]
				AND IER.[EQUIPMENT_ID] = XXX.[EQUIPMENT_ID]
				AND IER.[ITEM_ID]      = XXX.[ITEM_ID])
			WHEN MATCHED THEN
				UPDATE SET IER.[LAST_PROD_DATE] = XXX.LAST_PROD_DATE
						 , IER.[UPDATE_ID]      = @v_proc_name
						 , IER.[UPDATE_TIME]    = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT ( [COMPANY_ID]
					  , [DIVISION_ID]
					  , [SITE_ID]
					  , [PLANT_ID]
					  , [FACTORY_ID]
					  , [OPERATION_ID]
					  , [LINE_ID]
					  , [EQUIPMENT_ID]
					  , [ITEM_ID]
					  , [LAST_PROD_DATE]
					  , [INSERT_ID]
					  , [INSERT_TIME]
					  , [UPDATE_ID]
					  , [UPDATE_TIME]
					  )
				VALUES ( XXX.COMPANY_ID
					   , XXX.DIVISION_ID
					   , XXX.SITE_ID
					   , XXX.PLANT_ID
					   , XXX.FACTORY_ID
					   , XXX.OPERATION_ID
					   , XXX.LINE_ID
					   , XXX.EQUIPMENT_ID
					   , XXX.ITEM_ID
					   , XXX.LAST_PROD_DATE
					   , @v_proc_name
					   , GETDATE()
					   , @v_proc_name
					   , GETDATE()
					   );

			FETCH NEXT FROM CUR_MES_RESULT INTO @COMPANY_ID
											  , @DIVISION_ID
											  , @SITE_ID
											  , @PLANT_ID
											  , @FACTORY_ID
											  , @OPERATION_ID
											  , @LINE_ID
											  , @EQUIPMENT_ID
											  , @ITEM_ID
											  , @LAST_PROD_DATE;
		END;  -- WHILE @@FETCH_STATUS = 0
        CLOSE CUR_MES_RESULT;
        DEALLOCATE CUR_MES_RESULT;   -- 메모리 해제

		SET @v_temp1 = 'STEP END PROCEDURE'
		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN
		
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   @@ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @data_s = CURSOR_STATUS('global','CUR_MES_RESULT')
		IF @data_s IN (1,0)
						 BEGIN
		                     CLOSE CUR_MES_RESULT;
                             DEALLOCATE CUR_MES_RESULT;   -- 메모리 해제
                         END
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp1, NULL, @v_descr, @sysdate

	END CATCH

END;



