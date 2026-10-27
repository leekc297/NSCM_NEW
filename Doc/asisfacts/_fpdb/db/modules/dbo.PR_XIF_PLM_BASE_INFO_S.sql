
CREATE PROCEDURE [dbo].[PR_XIF_PLM_BASE_INFO_S]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_PLM_BASE_INFO_S
-- Param               :
-- Batch Period        : 6 HOUR
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : INF
-- Source Table        : SCM_FACTORY_M, SCM_LINE_M, SCM_OPERATION_M
-- Destination Table   : XIF_PLM_FACTORY_S, XIF_PLM_LINE_S, XIF_PLM_OPERATION_S
--
-- Create(Update) Date : 2022-03-28
--
-- Author              : piyong
-- Version             : 1.0 2018-11-28 초기 형성
--						 1.1 2022-03-28 kimcd 가상 Division 사용에 따른 보완
-- ================================================================================================
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_PLM_BASE_INFO_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER	  = 0

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @send_if_seq            NVARCHAR(50)
	DECLARE @send_date              NVARCHAR(50)
	DECLARE @if_seq_next            BIGINT

	DECLARE @IF_SEQ				NVARCHAR(50)
	DECLARE @IF_TYPE			CHAR(1)
	DECLARE @IF_ID				NVARCHAR(50)
	DECLARE @IF_INS_DATE		DATETIME
	DECLARE @IF_FLAG			CHAR(1)
	DECLARE @IF_SND_DATE		DATETIME

	DECLARE @COMPANY_ID			NVARCHAR(30)
	DECLARE @DIVISION_ID		NVARCHAR(30)
	DECLARE @SITE_ID			NVARCHAR(30)
	DECLARE @PLANT_ID			NVARCHAR(50)
	DECLARE @FACTORY_ID			NVARCHAR(30)
	DECLARE @FACTORY_NAME		NVARCHAR(150)
	DECLARE @OPERATION_ID		NVARCHAR(30)
	DECLARE @OPERATION_NAME		NVARCHAR(150)
	DECLARE @LINE_ID			NVARCHAR(30)
	DECLARE @LINE_NAME			NVARCHAR(150)
	DECLARE @ELECTRODE_TYPE		NVARCHAR(50)
	DECLARE @DESCRIPTION		NVARCHAR(200)
	DECLARE @ACTIVE_FLAG		CHAR(1)
	DECLARE @INSERT_ID			NVARCHAR(150)
	DECLARE @INSERT_TIME		DATETIME
	DECLARE @UPDATE_ID			NVARCHAR(150)
	DECLARE @UPDATE_TIME		DATETIME
	
	
	



	DECLARE CR_FACTORY CURSOR FOR
		SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
						  + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_PLM_SEND_SEQ])) 
						  + CAST( NEXT VALUE FOR [DBO].[XIF_PLM_SEND_SEQ] AS NVARCHAR) AS IF_SEQ
				,'S'            AS IF_TYPE
				,'OFP0_OPLM_DSV_FP_PLM_002'   AS IF_ID
				,GETDATE()     AS IF_INS_DATE
				,'N'           AS IF_FLAG
				,NULL          AS IF_SND_DATE
				,[COMPANY_ID]
				,[FACTORY_ID]
				,[FACTORY_NAME]
				,[DESCRIPTION]
				,[ACTIVE_FLAG]
				,[INSERT_ID]
				,[INSERT_TIME]
				,[UPDATE_ID]
				,[UPDATE_TIME]
		   FROM [dbo].[SCM_FACTORY_M]
		  WHERE [UPDATE_TIME] >= CONVERT(NVARCHAR(20), DATEADD(HOUR, -7, GETDATE()),120)

	DECLARE CR_LINE CURSOR FOR
		SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
						  + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_PLM_SEND_SEQ])) 
						  + CAST( NEXT VALUE FOR [DBO].[XIF_PLM_SEND_SEQ] AS NVARCHAR) AS IF_SEQ
				,'S'            AS IF_TYPE
				,'OFP0_OPLM_DSV_FP_PLM_003'   AS IF_ID
				,GETDATE()     AS IF_INS_DATE
				,'N'           AS IF_FLAG
				,NULL          AS IF_SND_DATE
				,A.COMPANY_ID
				,ISNULL(PD.ORIGINAL_DIVISION_ID, A.DIVISION_ID) AS DIVISION_ID  -- 2022-03-28 kimcd 가상 Division 로직 추가
				,SITE_ID
				,A.PLANT_ID
				,FACTORY_ID
				,OPERATION_ID
				,LINE_ID
				,LINE_NAME
				,ACTIVE_FLAG
				,ELECTRODE_TYPE
				,A.DESCRIPTION
				,A.INSERT_ID
				,A.INSERT_TIME
				,A.UPDATE_ID
				,A.UPDATE_TIME
		   FROM [dbo].[SCM_LINE_M] A
		   		LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-28 kimcd 가상 Division 로직 추가
					ON PD.PLANT_ID = A.PLANT_ID
		  WHERE A.[UPDATE_TIME] >= CONVERT(NVARCHAR(20), DATEADD(HOUR, -7, GETDATE()),120)


	DECLARE CR_OPERATION CURSOR FOR
		SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
						  + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_PLM_SEND_SEQ])) 
						  + CAST( NEXT VALUE FOR [DBO].[XIF_PLM_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
				,'S'            AS IF_TYPE
				,'OFP0_OPLM_DSV_FP_PLM_004'   AS IF_ID
				,GETDATE()     AS IF_INS_DATE
				,'N'           AS IF_FLAG
				,NULL          AS IF_SND_DATE
				,A.COMPANY_ID
				,ISNULL((SELECT TOP 1 PD.ORIGINAL_DIVISION_ID
						 FROM   [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)
						 WHERE  PD.COMPANY_ID         = A.COMPANY_ID
						 AND    PD.PSEUDO_DIVISION_ID = A.DIVISION_ID ), A.DIVISION_ID) AS DIVISION_ID    -- 2022-03-28 kimcd 가상 Division 로직 추가
				,SITE_ID
				,OPERATION_ID
				,OPERATION_NAME
				,ACTIVE_FLAG
				,INSERT_ID
				,INSERT_TIME
				,UPDATE_ID
				,UPDATE_TIME
		   FROM [dbo].[SCM_OPERATION_M] A
		  WHERE [UPDATE_TIME] >= CONVERT(NVARCHAR(20), DATEADD(HOUR, -7, GETDATE()),120)

	-- ================================================
    -- Declare end
	-- ================================================

	SET @send_date = 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
			OPEN CR_FACTORY

			FETCH NEXT FROM CR_FACTORY INTO @IF_SEQ
											,@IF_TYPE
											,@IF_ID
											,@IF_INS_DATE
											,@IF_FLAG
											,@IF_SND_DATE
											,@COMPANY_ID
											,@FACTORY_ID
											,@FACTORY_NAME
											,@DESCRIPTION
											,@ACTIVE_FLAG
											,@INSERT_ID
											,@INSERT_TIME
											,@UPDATE_ID
											,@UPDATE_TIME
											;

			WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
			BEGIN
				MERGE INTO  [dbo].[SY_XIF_PLM_FACTORY_S] M
				USING ( SELECT @IF_SEQ			AS IF_SEQ
								,@IF_TYPE		AS IF_TYPE
								,@IF_ID			AS IF_ID
								,@IF_INS_DATE	AS IF_INS_DATE
								,@IF_FLAG		AS IF_FLAG
								,@IF_SND_DATE	AS IF_SND_DATE
								,@COMPANY_ID	AS [COMPANY_ID]
							    ,@FACTORY_ID	AS [FACTORY_ID]
							    ,@FACTORY_NAME	AS [FACTORY_NAME]
							    ,@DESCRIPTION	AS [DESCRIPTION]
							    ,@ACTIVE_FLAG	AS [ACTIVE_FLAG]
							    ,@INSERT_ID		AS [INSERT_ID]
							    ,@INSERT_TIME	AS [INSERT_TIME]
							    ,@UPDATE_ID		AS [UPDATE_ID]
							    ,@UPDATE_TIME	AS [UPDATE_TIME]
					 ) B
				  ON (	M.[COMPANY_ID]     = B.[COMPANY_ID]
					    AND M.[FACTORY_ID]	 = B.[FACTORY_ID]
					 )
				WHEN MATCHED THEN
					UPDATE SET M.[IF_SEQ]         = B.[IF_SEQ]
							 , M.[IF_TYPE]        = B.[IF_TYPE]
							 , M.[IF_ID]          = B.[IF_ID]
							 , M.[IF_INS_DATE]    = B.[IF_INS_DATE]
							 , M.[IF_FLAG]        = B.[IF_FLAG]
							 , M.[IF_SND_DATE]    = B.[IF_SND_DATE]
							 , M.[FACTORY_NAME]   = B.[FACTORY_NAME]
							 , M.[DESCRIPTION]    = B.[DESCRIPTION]
							 , M.[ACTIVE_FLAG]    = B.[ACTIVE_FLAG]
							 , M.[UPDATE_ID]      = B.[UPDATE_ID]
							 , M.[UPDATE_TIME]    = B.[UPDATE_TIME]
				WHEN NOT MATCHED THEN			
					INSERT (
							[IF_SEQ]
							,[IF_TYPE]
							,[IF_ID]
							,[IF_INS_DATE]
							,[IF_FLAG]
							,[IF_SND_DATE]
							,[COMPANY_ID]
							,[FACTORY_ID]
							,[FACTORY_NAME]
							,[DESCRIPTION]
							,[ACTIVE_FLAG]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
					  ) VALUES (
							 B.IF_SEQ
							,B.IF_TYPE
							,B.IF_ID
							,B.IF_INS_DATE
							,B.IF_FLAG
							,B.IF_SND_DATE
							,[COMPANY_ID]
							,[FACTORY_ID]
							,[FACTORY_NAME]
							,[DESCRIPTION]
							,[ACTIVE_FLAG]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
					)
				;

				SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
				FETCH NEXT FROM CR_FACTORY INTO @IF_SEQ
												,@IF_TYPE
												,@IF_ID
												,@IF_INS_DATE
												,@IF_FLAG
												,@IF_SND_DATE
												,@COMPANY_ID
												,@FACTORY_ID
												,@FACTORY_NAME
												,@DESCRIPTION
												,@ACTIVE_FLAG
												,@INSERT_ID
												,@INSERT_TIME
												,@UPDATE_ID
												,@UPDATE_TIME
				;

			END;  -- WHILE @@FETCH_STATUS = 0
			CLOSE CR_FACTORY;
			DEALLOCATE CR_FACTORY;   -- 메모리 해제			





			OPEN CR_LINE

			FETCH NEXT FROM CR_LINE INTO @IF_SEQ
										,@IF_TYPE
										,@IF_ID
										,@IF_INS_DATE
										,@IF_FLAG
										,@IF_SND_DATE
										,@COMPANY_ID
										,@DIVISION_ID
										,@SITE_ID
										,@PLANT_ID
										,@FACTORY_ID
										,@OPERATION_ID
										,@LINE_ID
										,@LINE_NAME
										,@ACTIVE_FLAG
										,@ELECTRODE_TYPE
										,@DESCRIPTION
										,@INSERT_ID
										,@INSERT_TIME
										,@UPDATE_ID
										,@UPDATE_TIME
								;

			WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
			BEGIN
				MERGE INTO  [dbo].[SY_XIF_PLM_LINE_S] M
				USING ( SELECT @IF_SEQ				AS IF_SEQ
								,@IF_TYPE			AS IF_TYPE
								,@IF_ID				AS IF_ID
								,@IF_INS_DATE		AS IF_INS_DATE
								,@IF_FLAG			AS IF_FLAG
								,@IF_SND_DATE		AS IF_SND_DATE
								,@COMPANY_ID		AS COMPANY_ID
								,@DIVISION_ID		AS DIVISION_ID
								,@SITE_ID			AS SITE_ID
								,@PLANT_ID			AS PLANT_ID
								,@FACTORY_ID		AS FACTORY_ID
								,@OPERATION_ID		AS OPERATION_ID
								,@LINE_ID			AS LINE_ID
								,@LINE_NAME			AS LINE_NAME
								,@ACTIVE_FLAG		AS ACTIVE_FLAG
								,@ELECTRODE_TYPE	AS ELECTRODE_TYPE
								,@DESCRIPTION		AS DESCRIPTION
								,@INSERT_ID			AS INSERT_ID
								,@INSERT_TIME		AS INSERT_TIME
								,@UPDATE_ID			AS UPDATE_ID
								,@UPDATE_TIME		AS UPDATE_TIME
					 ) B
				  ON (	M.[COMPANY_ID]			= B.[COMPANY_ID]
  					    AND M.[DIVISION_ID]		= B.[DIVISION_ID]
					    AND M.[SITE_ID]			= B.[SITE_ID]
						AND M.[PLANT_ID]		= B.[PLANT_ID]
						AND M.[FACTORY_ID]		= B.[FACTORY_ID]
						AND M.[OPERATION_ID]	= B.[OPERATION_ID]
						AND M.[LINE_ID]			= B.[LINE_ID]
						AND M.[ELECTRODE_TYPE]	= B.[ELECTRODE_TYPE]
					 )
				WHEN MATCHED THEN
					UPDATE SET M.[IF_SEQ]		= B.[IF_SEQ]
							 , M.[IF_TYPE]		= B.[IF_TYPE]
							 , M.[IF_ID]		= B.[IF_ID]
							 , M.[IF_INS_DATE]	= B.[IF_INS_DATE]
							 , M.[IF_FLAG]		= B.[IF_FLAG]
							 , M.[IF_SND_DATE]	= B.[IF_SND_DATE]
							 , M.[LINE_NAME]	= B.[LINE_NAME]
							 , M.[DESCRIPTION]	= B.[DESCRIPTION]
							 , M.[ACTIVE_FLAG]	= B.[ACTIVE_FLAG]
							 , M.[UPDATE_ID]	= B.[UPDATE_ID]
							 , M.[UPDATE_TIME]	= B.[UPDATE_TIME]
				WHEN NOT MATCHED THEN			
					INSERT (
							[IF_SEQ]
							,[IF_TYPE]
							,[IF_ID]
							,[IF_INS_DATE]
							,[IF_FLAG]
							,[IF_SND_DATE]
							,[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]
							,[OPERATION_ID]
							,[LINE_ID]
							,[LINE_NAME]
							,[ACTIVE_FLAG]
							,[ELECTRODE_TYPE]
							,[DESCRIPTION]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
					  ) VALUES (
							 B.[IF_SEQ]
							,B.[IF_TYPE]
							,B.[IF_ID]
							,B.[IF_INS_DATE]
							,B.[IF_FLAG]
							,B.[IF_SND_DATE]
							,B.[COMPANY_ID]
							,B.[DIVISION_ID]
							,B.[SITE_ID]
							,B.[PLANT_ID]
							,B.[FACTORY_ID]
							,B.[OPERATION_ID]
							,B.[LINE_ID]
							,B.[LINE_NAME]
							,B.[ACTIVE_FLAG]
							,B.[ELECTRODE_TYPE]
							,B.[DESCRIPTION]
							,B.[INSERT_ID]
							,B.[INSERT_TIME]
							,B.[UPDATE_ID]
							,B.[UPDATE_TIME]
					)
				;

				SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
				FETCH NEXT FROM CR_LINE INTO @IF_SEQ
										,@IF_TYPE
										,@IF_ID
										,@IF_INS_DATE
										,@IF_FLAG
										,@IF_SND_DATE
										,@COMPANY_ID
										,@DIVISION_ID
										,@SITE_ID
										,@PLANT_ID
										,@FACTORY_ID
										,@OPERATION_ID
										,@LINE_ID
										,@LINE_NAME
										,@ACTIVE_FLAG
										,@ELECTRODE_TYPE
										,@DESCRIPTION
										,@INSERT_ID
										,@INSERT_TIME
										,@UPDATE_ID
										,@UPDATE_TIME
								;

			END;  -- WHILE @@FETCH_STATUS = 0
			CLOSE CR_LINE;
			DEALLOCATE CR_LINE;   -- 메모리 해제


		

			OPEN CR_OPERATION

			FETCH NEXT FROM CR_OPERATION INTO @IF_SEQ
											,@IF_TYPE
											,@IF_ID
											,@IF_INS_DATE
											,@IF_FLAG
											,@IF_SND_DATE
											,@COMPANY_ID
											,@DIVISION_ID
											,@SITE_ID
											,@OPERATION_ID
											,@OPERATION_NAME
											,@ACTIVE_FLAG
											,@INSERT_ID
											,@INSERT_TIME
											,@UPDATE_ID
											,@UPDATE_TIME
								;

			WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
			BEGIN
				MERGE INTO  [dbo].[SY_XIF_PLM_OPERATION_S] M
				USING ( SELECT @IF_SEQ				AS IF_SEQ
								,@IF_TYPE			AS IF_TYPE
								,@IF_ID				AS IF_ID
								,@IF_INS_DATE		AS IF_INS_DATE
								,@IF_FLAG			AS IF_FLAG
								,@IF_SND_DATE		AS IF_SND_DATE
								,@COMPANY_ID		AS COMPANY_ID
								,@DIVISION_ID		AS DIVISION_ID
								,@SITE_ID			AS SITE_ID
								,@OPERATION_ID		AS OPERATION_ID
								,@OPERATION_NAME	AS OPERATION_NAME
								,@ACTIVE_FLAG		AS ACTIVE_FLAG
								,@INSERT_ID			AS INSERT_ID
								,@INSERT_TIME		AS INSERT_TIME
								,@UPDATE_ID			AS UPDATE_ID
								,@UPDATE_TIME		AS UPDATE_TIME
					 ) B
				  ON (	M.[COMPANY_ID]			= B.[COMPANY_ID]
  					    AND M.[DIVISION_ID]		= B.[DIVISION_ID]
					    AND M.[SITE_ID]			= B.[SITE_ID]
						AND M.[OPERATION_ID]	= B.[OPERATION_ID]
					 )
				WHEN MATCHED THEN
					UPDATE SET M.[IF_SEQ]			= B.[IF_SEQ]
							 , M.[IF_TYPE]			= B.[IF_TYPE]
							 , M.[IF_ID]			= B.[IF_ID]
							 , M.[IF_INS_DATE]		= B.[IF_INS_DATE]
							 , M.[IF_FLAG]			= B.[IF_FLAG]
							 , M.[IF_SND_DATE]		= B.[IF_SND_DATE]
							 , M.[OPERATION_NAME]	= B.[OPERATION_NAME]
							 , M.[ACTIVE_FLAG]		= B.[ACTIVE_FLAG]
							 , M.[UPDATE_ID]		= B.[UPDATE_ID]
							 , M.[UPDATE_TIME]		= B.[UPDATE_TIME]
				WHEN NOT MATCHED THEN			
					INSERT (
							[IF_SEQ]
							,[IF_TYPE]
							,[IF_ID]
							,[IF_INS_DATE]
							,[IF_FLAG]
							,[IF_SND_DATE]
							,[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[OPERATION_ID]
							,[OPERATION_NAME]
							,[ACTIVE_FLAG]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
					  ) VALUES (
							 B.[IF_SEQ]
							,B.[IF_TYPE]
							,B.[IF_ID]
							,B.[IF_INS_DATE]
							,B.[IF_FLAG]
							,B.[IF_SND_DATE]
							,B.[COMPANY_ID]
							,B.[DIVISION_ID]
							,B.[SITE_ID]
							,B.[OPERATION_ID]
							,B.[OPERATION_NAME]
							,B.[ACTIVE_FLAG]
							,B.[INSERT_ID]
							,B.[INSERT_TIME]
							,B.[UPDATE_ID]
							,B.[UPDATE_TIME]
					)
				;

				SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
				FETCH NEXT FROM CR_OPERATION INTO @IF_SEQ
												,@IF_TYPE
												,@IF_ID
												,@IF_INS_DATE
												,@IF_FLAG
												,@IF_SND_DATE
												,@COMPANY_ID
												,@DIVISION_ID
												,@SITE_ID
												,@OPERATION_ID
												,@OPERATION_NAME
												,@ACTIVE_FLAG
												,@INSERT_ID
												,@INSERT_TIME
												,@UPDATE_ID
												,@UPDATE_TIME
								;

			END;  -- WHILE @@FETCH_STATUS = 0
			CLOSE CR_OPERATION;
			DEALLOCATE CR_OPERATION;   -- 메모리 해제




		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END