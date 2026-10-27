
--ALTER PROCEDURE [dbo].[PR_XIF_MES_LOSS_SUM_R]
CREATE PROCEDURE [dbo].[PR_XIF_MES_LOSS_SUM_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_MES_LOSS_SUM_R
-- Param               :
-- Batch Period        : 1day
-- Description         :
--
-- Source System       : DW(MES)
-- Destination System  : FP SDB
-- Source Table        : XIF_DW_TB_SFC_EQPT_LOSS_HIST_R
-- Destination Table   : FP_LOSS_H
--
-- Create(Update) Date : 2016.10.19
-- Author              : 김 춘 동
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_LOSS_SUM_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME    = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @data_s      INTEGER
	
	-- ================================================
    -- Declare start
	-- ================================================


	DECLARE CUR_DW_LOSS CURSOR FOR
		SELECT EQ.[COMPANY_ID]
			 , EQ.[DIVISION_ID]
			 , EQ.[SITE_ID]
			 , EQ.[PLANT_ID]
			 , EQ.[FACTORY_ID]
			 , EQ.[OPERATION_ID]
			 , EQ.[LINE_ID]
			 , DATEADD(mm, DATEDIFF(mm,0,CAST(X.[STRT_DTTM]  AS DATETIME)), 0)  AS STRT_DTTM
			 , X.[LOSS_CODE]
		FROM   [DBO].[SCM_EQUIPMENT_M]  EQ WITH(NOLOCK)
			 , [DBO].[SCM_OFF_TYPE_M]   OT WITH(NOLOCK)
			 , [dbo].[SY_XIF_DW_TB_SFC_EQPT_LOSS_HIST_R] X WITH(NOLOCK)
		WHERE EQ.[FACTORY_ID]   = X.[AREAID]
		AND   EQ.[EQUIPMENT_ID] = X.[EQPTID]
		AND   EQ.[EQUIPMENT_TYPE] = 'M'
		AND   EQ.[ACTIVE_FLAG]    = 'Y'
		AND   OT.[COMPANY_ID]   = EQ.[COMPANY_ID]
		AND   OT.[OFF_TYPE_ID]  = X.[LOSS_CODE]
		AND   OT.[OFFTIME_USE_FLAG] = 'Y'
		AND   X.[TRANSFER_FLAG] = 'P'
		AND   X.[USE_FLAG] = 'Y'
		GROUP BY EQ.[COMPANY_ID]
				,EQ.[DIVISION_ID]
				,EQ.[SITE_ID]
				,EQ.[PLANT_ID]
				,EQ.[FACTORY_ID]
				,EQ.[OPERATION_ID]
				,EQ.[LINE_ID]
				,DATEADD(mm, DATEDIFF(mm,0,CAST(X.[STRT_DTTM]  AS DATETIME)), 0)
				,X.[LOSS_CODE]
		ORDER BY EQ.[OPERATION_ID]
				,EQ.[LINE_ID]
	;

	SET @ROWCOUNT = @@ROWCOUNT

	DECLARE @COMPANY_ID		 NVARCHAR(30);
	DECLARE @DIVISION_ID	 NVARCHAR(30);
	DECLARE @SITE_ID		 NVARCHAR(30);
	DECLARE @PLANT_ID		 NVARCHAR(30);
	DECLARE @FACTORY_ID		 NVARCHAR(30);
	DECLARE @OPERATION_ID	 NVARCHAR(30);
	DECLARE @LINE_ID		 NVARCHAR(30);
	DECLARE @STRT_DTTM			NVARCHAR(50);
	DECLARE @LOSS_CODE			NVARCHAR(100);
	DECLARE @FIRST_DATE			DATETIME;
	DECLARE @NEXT_FIRST_DATE	DATETIME;
	DECLARE @H_OPERATION_ID	 NVARCHAR(30);
	DECLARE @H_LINE_ID		 NVARCHAR(30);
	DECLARE @H_START_TIME       DATETIME;
	DECLARE @TOT_TIME           NUMERIC(20,10);
	
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
		SET @v_temp1 = 'STEP UPDATE [XIF_DW_TB_SFC_EQPT_LOSS_HIST_R]'
		UPDATE [dbo].[SY_XIF_DW_TB_SFC_EQPT_LOSS_HIST_R]
		SET    TRANSFER_FLAG = 'P'
			  ,TRANSFER_DATE = GETDATE()
		WHERE TRANSFER_FLAG = 'N'

		SET @v_temp1 = 'STEP OPEN CUR_DW_LOSS CURSOR'
		OPEN CUR_DW_LOSS
        FETCH NEXT FROM CUR_DW_LOSS INTO @COMPANY_ID
									   , @DIVISION_ID
									   , @SITE_ID
									   , @PLANT_ID
									   , @FACTORY_ID
									   , @OPERATION_ID
									   , @LINE_ID
									   , @STRT_DTTM
									   , @LOSS_CODE

		SET @H_OPERATION_ID = '-1';
		SET @H_LINE_ID      = '-1';
		SET @H_START_TIME   = '1900-01-01';

        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN
			SET @v_temp1 = 'STEP SET MONTH CONDITION'
			SELECT @FIRST_DATE = DATEADD(mm, DATEDIFF(mm,0,@STRT_DTTM), 0) 
			SELECT @NEXT_FIRST_DATE = DATEADD(mm, 1, @FIRST_DATE)

			IF @H_OPERATION_ID != @OPERATION_ID OR @H_LINE_ID != @LINE_ID OR @H_START_TIME != @FIRST_DATE
				BEGIN
					SET @v_temp1 = 'STEP GET TOTAL MINUTES'
					SELECT @TOT_TIME = COUNT(*) * DATEDIFF(MI,@FIRST_DATE,@NEXT_FIRST_DATE)
					FROM    [DBO].[SCM_EQUIPMENT_M]  EQ WITH(NOLOCK)
					WHERE  EQ.COMPANY_ID   = @COMPANY_ID
					AND	   EQ.DIVISION_ID  = @DIVISION_ID
					AND	   EQ.SITE_ID      = @SITE_ID
					AND	   EQ.PLANT_ID     = @PLANT_ID
					AND	   EQ.FACTORY_ID   = @FACTORY_ID
					AND	   EQ.OPERATION_ID = @OPERATION_ID
					AND	   EQ.LINE_ID      = @LINE_ID
					AND    EQ.EQUIPMENT_TYPE = 'M'
					AND    EQ.ACTIVE_FLAG  = 'Y';

					SET @H_OPERATION_ID = @OPERATION_ID;
					SET @H_LINE_ID      = @LINE_ID;
					SET @H_START_TIME   = @FIRST_DATE;
				END;

			IF @TOT_TIME > 0
				BEGIN
					SET @v_temp1 = 'STEP MERGE [DBO].[FP_LOSS_H]'
					MERGE INTO [DBO].[FP_LOSS_H] FLH
					USING ( SELECT @COMPANY_ID       AS COMPANY_ID
								 , @DIVISION_ID      AS DIVISION_ID
								 , @SITE_ID          AS SITE_ID
								 , @PLANT_ID         AS PLANT_ID
								 , @FACTORY_ID       AS FACTORY_ID
								 , @OPERATION_ID     AS OPERATION_ID
								 , @LINE_ID          AS LINE_ID
								 , @LOSS_CODE        AS LOSS_CODE
								 , SUBSTRING(CONVERT(NVARCHAR(12), @FIRST_DATE, 112), 1,6)    AS YYYYMM
								 , SUM(DATEDIFF(MI, X.[STRT_DTTM]
												  , X.[END_DTTM]))/@TOT_TIME  AS LOSS_RATE
							FROM   [DBO].[SCM_EQUIPMENT_M]  EQ  WITH(NOLOCK)
								 , ( SELECT CAST(TL.[STRT_DTTM]  AS DATETIME) AS STRT_DTTM
								          , CAST(TL.[END_DTTM]  AS DATETIME)  AS END_DTTM
										  , TL.[AREAID]
										  , TL.[EQPTID]
										  , TL.[LOSS_CODE]
										  , TL.[USE_FLAG]
									 FROM   [dbo].[SY_XIF_DW_TB_SFC_EQPT_LOSS_HIST_R] TL WITH(NOLOCK)
									 WHERE  TL.[LOSS_CODE]   = @LOSS_CODE
									 AND    TL.[USE_FLAG]    = 'Y' ) X
							WHERE  EQ.[FACTORY_ID]     = X.AREAID
							AND    EQ.[EQUIPMENT_ID]   = X.EQPTID
							AND    EQ.[COMPANY_ID]     = @COMPANY_ID
							AND	   EQ.[DIVISION_ID]    = @DIVISION_ID
							AND	   EQ.[SITE_ID]        = @SITE_ID
							AND	   EQ.[PLANT_ID]       = @PLANT_ID
							AND	   EQ.[FACTORY_ID]     = @FACTORY_ID
							AND	   EQ.[OPERATION_ID]   = @OPERATION_ID
							AND	   EQ.[LINE_ID]        = @LINE_ID
							AND    EQ.[EQUIPMENT_TYPE] = 'M'
							AND    EQ.[ACTIVE_FLAG]    = 'Y'
							AND    X.[STRT_DTTM]  >= @FIRST_DATE
							AND	   X.[STRT_DTTM]   < @NEXT_FIRST_DATE
							) XXX
					ON (    FLH.[COMPANY_ID]   = XXX.[COMPANY_ID]
						AND FLH.[DIVISION_ID]  = XXX.[DIVISION_ID]
						AND FLH.[SITE_ID]      = XXX.[SITE_ID]
						AND FLH.[PLANT_ID]     = XXX.[PLANT_ID]
						AND FLH.[FACTORY_ID]   = XXX.[FACTORY_ID]
						AND FLH.[OPERATION_ID] = XXX.[OPERATION_ID]
						AND FLH.[LINE_ID]      = XXX.[LINE_ID]
						AND FLH.[MONTH]        = XXX.[YYYYMM]
						AND FLH.[OFF_TYPE_ID]  = XXX.[LOSS_CODE])
					WHEN MATCHED THEN
						UPDATE SET FLH.[LOSS_RATE]   = XXX.LOSS_RATE
								 , FLH.[UPDATE_ID]   = @v_proc_name
								 , FLH.[UPDATE_TIME] = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT ( [COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[FACTORY_ID]
								,[OPERATION_ID]
								,[LINE_ID]
								,[MONTH]
								,[OFF_TYPE_ID]
								,[LOSS_RATE]
								,[INSERT_ID]
								,[INSERT_TIME]
								,[UPDATE_ID]
								,[UPDATE_TIME]
								)
						VALUES ( XXX.[COMPANY_ID]
								,XXX.[DIVISION_ID]
								,XXX.[SITE_ID]
								,XXX.[PLANT_ID]
								,XXX.[FACTORY_ID]
								,XXX.[OPERATION_ID]
								,XXX.[LINE_ID]
								,XXX.[YYYYMM]      -- [MONTH]
								,XXX.[LOSS_CODE]   -- [OFF_TYPE_ID]
								,XXX.[LOSS_RATE]
								,@v_proc_name
								,GETDATE()
								,@v_proc_name
								,GETDATE()
								);
				END; -- IF @TOT_TIME > 0

			FETCH NEXT FROM CUR_DW_LOSS INTO @COMPANY_ID
										   , @DIVISION_ID
										   , @SITE_ID
										   , @PLANT_ID
										   , @FACTORY_ID
										   , @OPERATION_ID
										   , @LINE_ID
										   , @STRT_DTTM
										   , @LOSS_CODE
		END;  -- WHILE @@FETCH_STATUS = 0
        CLOSE CUR_DW_LOSS;
        DEALLOCATE CUR_DW_LOSS;   -- 메모리 해제

		SET @v_temp1 = 'STEP MARK END [XIF_DW_TB_SFC_EQPT_LOSS_HIST_R]'
		UPDATE [dbo].[SY_XIF_DW_TB_SFC_EQPT_LOSS_HIST_R]
		SET    TRANSFER_FLAG = 'Y'
			  ,TRANSFER_DATE = GETDATE()
		WHERE TRANSFER_FLAG = 'P'

		SET @v_temp1 = 'STEP END PROCEDURE'
		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @data_s = CURSOR_STATUS('local','CUR_DW_LOSS')
		IF @data_s IN (1,0)
						 BEGIN
		                     CLOSE CUR_DW_LOSS;
                             DEALLOCATE CUR_DW_LOSS;   -- 메모리 해제
                         END
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp1, NULL, @v_descr, @sysdate

	END CATCH

END;



