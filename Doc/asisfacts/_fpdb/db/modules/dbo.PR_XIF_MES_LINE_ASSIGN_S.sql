
CREATE PROCEDURE [dbo].[PR_XIF_MES_LINE_ASSIGN_S]
--ALTER PROCEDURE [dbo].[PR_XIF_MES_LINE_ASSIGN_S]

-- ================================================================================================
-- Program ID          : FP02491
-- Program Name        : PR_XIF_MES_LINE_ASSIGN_S
-- Param               :
-- Batch Period        : 6Hour
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : ERP
-- Source Table        : SCM_ITEM_LINE_ASSIGN_M
-- Destination Table   : XIF_MES_EQSG_PROC_PRDT_S
--
-- Create Date		   : 2017.06.20
-- Update Date		   : 2018.12.03 piyong 1.1
--						 2019.01.09 PIYONG 1.2
--						 2022.07.14 kimcd  1.3


-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 전송 대상 기간 체크 로직 변경
--							 설비 수정일자 추가
--						 1.2 조회 기준 1일에서 1시간으로 변경
--                       1.3 2022-07-14 kimcd ERP W/C 관리 기준으로 라인으로 변경함에 따라 수정
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_LINE_ASSIGN_S'
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

	DECLARE CUR_EQSG_PROC_PRDT CURSOR FOR
		SELECT ROW_NUMBER() OVER( ORDER BY ITEM_ID) AS NUM 
			 , ISNULL(SEQ.MES_LINE_ID,SEM.[MES_LINE_ID])            AS EQSGID
			 , ILA.[OPERATION_ID] AS PROCID
			 , ILA.[ITEM_ID] AS PRODID
			 , (SELECT MIN(TTM.[TACT_TIME])
				  FROM [DBO].[SCM_TACT_TIME_M]  TTM  WITH(NOLOCK)
				 WHERE TTM.[COMPANY_ID]     = ILA.[COMPANY_ID]
				   AND TTM.[DIVISION_ID]    = ILA.[DIVISION_ID]
				   AND TTM.[SITE_ID]        = ILA.[SITE_ID]
				   AND TTM.[PLANT_ID]       = ILA.[PLANT_ID]
				   AND TTM.[FACTORY_ID]     = ILA.[FACTORY_ID]
				   AND TTM.[OPERATION_ID]   = ILA.[OPERATION_ID]
				   AND TTM.[LINE_ID]        = MAX(ILA.[LINE_ID])
				   AND TTM.[ELECTRODE_TYPE] = ILA.[ELECTRODE_TYPE]
				   AND TTM.[ITEM_ID]        = ILA.[ITEM_ID]
				   AND TTM.[MONTH]          = MIN(ILA.[MONTH]) )   AS TACT_TIME
			  , ILA.[ACTIVE_FLAG]             AS USE_FLAG
			  ,'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR) AS IF_SEQ
		FROM   [DBO].[SCM_OPERATION_M]         SOM WITH(NOLOCK)
			  ,[DBO].[SCM_LINE_M]              SEM WITH(NOLOCK)  -- 2022-07-14 kimcd ERP W/C 관리 기준으로 라인으로 변경함에 따라 수정
  			    LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M]         SEQ WITH(NOLOCK)
		 	    ON    SEM.[COMPANY_ID]     = SEQ.[COMPANY_ID]
				AND   SEM.[DIVISION_ID]    = SEQ.[DIVISION_ID]
				AND   SEM.[SITE_ID]        = SEQ.[SITE_ID]
				AND   SEM.[PLANT_ID]       = SEQ.[PLANT_ID]
				AND   SEM.[FACTORY_ID]     = SEQ.[FACTORY_ID]
				AND   SEM.[OPERATION_ID]   = SEQ.[OPERATION_ID]
				AND   SEM.[LINE_ID]        = SEQ.[LINE_ID]
				AND   SEM.[ELECTRODE_TYPE] = SEQ.[ELECTRODE_TYPE]
				AND   SEQ.[EQUIPMENT_TYPE]  = 'M'
			  ,[DBO].[SCM_ITEM_LINE_ASSIGN_M]  ILA WITH(NOLOCK)
		WHERE SEM.[COMPANY_ID]     = ILA.[COMPANY_ID]
		AND   SEM.[DIVISION_ID]    = ILA.[DIVISION_ID]
		AND   SEM.[SITE_ID]        = ILA.[SITE_ID]
		AND   SEM.[PLANT_ID]       = ILA.[PLANT_ID]
		AND   SEM.[FACTORY_ID]     = ILA.[FACTORY_ID]
		AND   SEM.[OPERATION_ID]   = ILA.[OPERATION_ID]
		AND   SEM.[LINE_ID]        = ILA.[LINE_ID]
		AND   SEM.[ELECTRODE_TYPE] = ILA.[ELECTRODE_TYPE]
		AND   SOM.[COMPANY_ID]     = SEM.[COMPANY_ID]
		AND   SOM.[DIVISION_ID]    = SEM.[DIVISION_ID]
		AND   SOM.[SITE_ID]        = SEM.[SITE_ID]
		AND   SOM.[OPERATION_ID]   = SEM.[OPERATION_ID]
		AND   ( ILA.UPDATE_TIME >= DATEADD(HOUR, -1, GETDATE()) --2019-01-09 PIYONG CHANGE DD -> HOUR
				OR
				SEM.UPDATE_TIME >= DATEADD(HOUR, -1, GETDATE())	--2018-12-03 PIYONG ADD --2019-01-09 PIYONG CHANGE DD -> HOUR
			  )
		AND   SEM.MES_LINE_ID > '' -- 2022-07-14 kimcd ERP W/C 관리 기준으로 라인으로 변경함에 따라 수정
		GROUP BY ILA.[COMPANY_ID]
			   , ILA.[DIVISION_ID]
			   , ILA.[SITE_ID]
			   , ILA.[PLANT_ID]
			   , ILA.[FACTORY_ID]
			   , ISNULL(SEQ.MES_LINE_ID,SEM.[MES_LINE_ID])
			   , ILA.[OPERATION_ID]
			   , ILA.[ITEM_ID]
			   , ILA.[ELECTRODE_TYPE]
			   , ISNULL(SEQ.WORK_CENTER_ID,SEM.[WORK_CENTER_ID])
			   , ILA.[ACTIVE_FLAG]
			   ;

	SET @ROWCOUNT = @@ROWCOUNT

	DECLARE @IFSEQNO            NVARCHAR(50);
	DECLARE @NUM			    NUMERIC(10);

	DECLARE @EQSGID				NVARCHAR(50);
	DECLARE @PROCID				NVARCHAR(50);
	DECLARE @PRODID             NVARCHAR(50);
	DECLARE @TACT_TIME          NUMERIC(18,5);
	DECLARE @ACTIVE_FLAG        NVARCHAR(1);
	
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

		SET @v_temp1 = 'STEP DELETE [dbo].SY_XIF_MES_EQSG_PROC_PRDT_S]'

		SET @v_temp1 = 'STEP OPEN CURSOR'
		OPEN CUR_EQSG_PROC_PRDT

        FETCH NEXT FROM CUR_EQSG_PROC_PRDT INTO @NUM
												,@EQSGID
												,@PROCID
												,@PRODID
												,@TACT_TIME
												,@ACTIVE_FLAG
												,@IFSEQNO
		;

        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
			BEGIN
				MERGE INTO [dbo].[SY_XIF_MES_EQSG_PROC_PRDT_S] MLA
				USING ( SELECT  @IFSEQNO AS IFSEQNO
							   ,@EQSGID AS EQSGID
							   ,@PROCID AS PROCID
							   ,@PRODID AS PRODID
							   ,ISNULL(@TACT_TIME, 0) AS TACT_TIME
							   ,@ACTIVE_FLAG AS ACTIVE_FLAG
					  ) TEMP
				   ON (
						MLA.EQSGID = TEMP.EQSGID
						AND MLA.PROCID = TEMP.PROCID
						AND MLA.PRODID = TEMP.PRODID
				      ) 
				WHEN MATCHED THEN
					UPDATE 
					   SET MLA.IF_FLAG = 'N'
					       ,MLA.IF_INS_DATE = GETDATE()
						   ,MLA.TACT_TIME = TEMP.TACT_TIME
						   ,MLA.USE_FLAG = TEMP.ACTIVE_FLAG
						   ,MLA.UPDUSER = @v_proc_name
						   ,MLA.UPDDTTM = GETDATE()
				WHEN NOT MATCHED THEN
					INSERT (
						  [IF_SEQ]
						  ,[IF_TYPE]
						  ,[IF_ID]
						  ,[IF_INS_DATE]
						  ,[IF_FLAG]
						  ,[IF_SND_DATE]
						  ,[EQSGID]
						  ,[PROCID]
						  ,[PRODID]
						  ,[TACT_TIME]
						  ,[USE_FLAG]
						  ,[INSUSER]
						  ,[INSDTTM]
						  ,[UPDUSER]
						  ,[UPDDTTM]
					) VALUES ( 
						TEMP.IFSEQNO
						,'S'
						,'OFP0_OSC1_FP_EQSG_PROC_PRDT'
						,GETDATE()
						,'N'
						,GETDATE()
						,TEMP.EQSGID
						,TEMP.PROCID
						,TEMP.PRODID
						,ISNULL(TEMP.TACT_TIME, 0)
						,TEMP.ACTIVE_FLAG
						,@v_proc_name
						,GETDATE()
						,@v_proc_name
						,GETDATE()
						);


			FETCH NEXT FROM CUR_EQSG_PROC_PRDT INTO @NUM
													,@EQSGID
													,@PROCID
													,@PRODID
													,@TACT_TIME
													,@ACTIVE_FLAG
													,@IFSEQNO
			;

		END;  -- WHILE @@FETCH_STATUS = 0
        CLOSE CUR_EQSG_PROC_PRDT;
        DEALLOCATE CUR_EQSG_PROC_PRDT;   -- 메모리 해제

		SET @v_temp1 = 'STEP END PROCEDURE'
		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp1, NULL, @v_descr, @sysdate

	END CATCH

END;

