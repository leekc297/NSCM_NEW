
CREATE PROCEDURE [dbo].[PR_XIF_PLM_PJT_SCHEDULE_R]

-- ================================================================================================
-- Program ID          : FP03530
-- Program Name        : PR_XIF_PLM_PJT_SCHEDULE_R
-- Param               :
-- Batch Period        : 30 MIN
-- Description         :
--
-- Source System       : PLM
-- Destination System  : FP SDB
-- Source Table        : XIF_PLM_PJT_MODEL_MASTER_R, XIF_PLM_PJT_SCHEDULE_R
-- Destination Table   : FP_PJT_MODEL_MASTER_R
--
-- Create Date		   : 2017.05.16
-- Update Date		   : 2018.06.18
--						 2018.08.27 PIYONG 1.2
--						 2019.06.25 PIYONG 2.0
--                       2022.03.20 kimcd  2.1

-- Author              : piyong
-- Version             : 1.0
--                       1.1 2018-06-18 kimcd 사업부 코드 전환 case 문장 변경
--						 1.2 ATTR_02, ATTR_03 추가 수신
--						 2.0 FP_PLM_PJT_MODEL_MASTER 정보 생성
--                       2.1 2022-03-20 kimcd 가상 Division 사용에 따른 로직 보완
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_PLM_PJT_SCHEDULE_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @PROJECT_ID			NVARCHAR(30)
	DECLARE @PROJECT_NAME		NVARCHAR(500)
	DECLARE @DIVISION_ID		NVARCHAR(30)
	DECLARE @MODEL_NAME			NVARCHAR(40)
	DECLARE @PJT_SCHEDULE_DATE	NVARCHAR(10)
	DECLARE @PJT_PROGRESS_STEP	NVARCHAR(50)
	DECLARE @PJT_STATUS			NVARCHAR(50)
	DECLARE @PRODUCTION_TYPE	NVARCHAR(50)

	DECLARE @BEFORE_PJT_SCHEDULE_DATE	NVARCHAR(10)
	DECLARE @BEFORE_PJT_PROGRESS_STEP	NVARCHAR(10)
	DECLARE @BEFORE_PJT_STATUS	NVARCHAR(50)
	DECLARE @BEFORE_PROJECT_ID	NVARCHAR(30)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			UPDATE [SY_XIF_PLM_PJT_SCHEDULE_R]
			   SET PROC_FLAG = 'P'
			 WHERE ISNULL(PROC_FLAG, 'N') = 'N'


			 MERGE INTO [DBO].[FP_PLM_PJT_SCHEDULE_R] A
				USING ( SELECT [PROJECT_ID]
							   ,[DIVISION_ID]
							   ,[MODEL_NAME]
							   ,[REP_YN]
							   ,[CV_APP_PLAN_START_DATE]
							   ,[CV_APP_PLAN_END_DATE]
							   ,[CV_PLAN_START_DATE]
							   ,[CV_PLAN_END_DATE]
							   ,[CV_ACTUAL_START_DATE]
							   ,[CV_ACTUAL_END_DATE]
							   ,[DV_APP_PLAN_START_DATE]
							   ,[DV_APP_PLAN_END_DATE]
							   ,[DV_PLAN_START_DATE]
							   ,[DV_PLAN_END_DATE]
							   ,[DV_ACTUAL_START_DATE]
							   ,[DV_ACTUAL_END_DATE]
							   ,[PD_APP_PLAN_START_DATE]
							   ,[PD_APP_PLAN_END_DATE]
							   ,[PD_PLAN_START_DATE]
							   ,[PD_PLAN_END_DATE]
							   ,[PD_ACTUAL_START_DATE]
							   ,[PD_ACTUAL_END_DATE]
							   ,[PV_APP_PLAN_START_DATE]
							   ,[PV_APP_PLAN_END_DATE]
							   ,[PV_PLAN_START_DATE]
							   ,[PV_PLAN_END_DATE]
							   ,[PV_ACTUAL_START_DATE]
							   ,[PV_ACTUAL_END_DATE]
							   ,[PJT_PROGRESS_STEP]		-- 2018-08-27 PIYONG ADD
							   ,[PJT_STATUS]			-- 2018-08-27 PIYONG ADD
						  FROM ( SELECT MM.[PROJECT_ID]
									    ,MM.[MODEL_NAME]
									    ,MM.[REP_YN]
									    ,S.[CV_APP_PLAN_START_DATE]
									    ,S.[CV_APP_PLAN_END_DATE]
									    ,S.[CV_PLAN_START_DATE]
									    ,S.[CV_PLAN_END_DATE]
									    ,S.[CV_ACTUAL_START_DATE]
									    ,S.[CV_ACTUAL_END_DATE]
									    ,S.[DV_APP_PLAN_START_DATE]
									    ,S.[DV_APP_PLAN_END_DATE]
									    ,S.[DV_PLAN_START_DATE]
									    ,S.[DV_PLAN_END_DATE]
									    ,S.[DV_ACTUAL_START_DATE]
									    ,S.[DV_ACTUAL_END_DATE]
									    ,S.[PD_APP_PLAN_START_DATE]
									    ,S.[PD_APP_PLAN_END_DATE]
									    ,S.[PD_PLAN_START_DATE]
									    ,S.[PD_PLAN_END_DATE]
									    ,S.[PD_ACTUAL_START_DATE]
									    ,S.[PD_ACTUAL_END_DATE]
									    ,S.[PV_APP_PLAN_START_DATE]
									    ,S.[PV_APP_PLAN_END_DATE]
									    ,S.[PV_PLAN_START_DATE]
									    ,S.[PV_PLAN_END_DATE]
									    ,S.[PV_ACTUAL_START_DATE]
									    ,S.[PV_ACTUAL_END_DATE]
									    ,CASE S.ATTR_01 WHEN 'AUTO' THEN '81'
														 WHEN 'MOBILE' THEN '40'
														 WHEN 'ESS' THEN '82'
														 END AS [DIVISION_ID]	 -- 2018-06-18 kimcd case 문장 변경
										 /*,CASE MM.ATTR_01 WHEN 'AUTO' THEN '40'
													  WHEN 'MOBILE' THEN '81'
													  WHEN 'ESS' THEN '82'
													   END AS [DIVISION_ID]  2018-06-18 kimcd  기존 문장 */
										,ROW_NUMBER() OVER ( PARTITION BY MM.[PROJECT_ID], MM.[MODEL_NAME], MM.[REP_YN]
																 ORDER BY S.IF_RCV_DATE DESC, MM.IF_SEQ DESC ) ROWUMBER		 -- 2018-08-27 PIYONG  CHANGE MM.IF_SEQ -> S.IF_RCV_DATE
										,S.ATTR_02 AS PJT_PROGRESS_STEP			-- 2018-08-27 PIYONG ADD
									    ,S.ATTR_03 AS PJT_STATUS				-- 2018-08-27 PIYONG ADD
										,MM.IF_TYPE								-- 2019-06-25 PIYONG ADD
								   FROM [SY_XIF_PLM_PJT_MODEL_MASTER_R] MM
								   JOIN [SY_XIF_PLM_PJT_SCHEDULE_R] S
									  ON MM.PROJECT_ID = S.PROJECT_ID
								   WHERE S.PROC_FLAG = 'P'
								) A
						  WHERE ROWUMBER = 1
						    AND IF_TYPE != 'D'								-- 2019-06-25 PIYONG ADD
					  )B
				  ON ( A.PROJECT_ID = B.PROJECT_ID
				       AND A.MODEL_NAME = B.MODEL_NAME
					   AND A.REP_YN = B.REP_YN
					  )
				WHEN MATCHED THEN

					UPDATE SET A.DIVISION_ID			   = B.[DIVISION_ID]
							   ,A.[CV_APP_PLAN_START_DATE] = B.[CV_APP_PLAN_START_DATE]
							   ,A.[CV_APP_PLAN_END_DATE]   = B.[CV_APP_PLAN_END_DATE]
							   ,A.[CV_PLAN_START_DATE]     = B.[CV_PLAN_START_DATE]
							   ,A.[CV_PLAN_END_DATE]       = B.[CV_PLAN_END_DATE]
							   ,A.[CV_ACTUAL_START_DATE]   = B.[CV_ACTUAL_START_DATE]
							   ,A.[CV_ACTUAL_END_DATE]     = B.[CV_ACTUAL_END_DATE]
							   ,A.[DV_APP_PLAN_START_DATE] = B.[DV_APP_PLAN_START_DATE]
							   ,A.[DV_APP_PLAN_END_DATE]   = B.[DV_APP_PLAN_END_DATE]
							   ,A.[DV_PLAN_START_DATE]     = B.[DV_PLAN_START_DATE]
							   ,A.[DV_PLAN_END_DATE]       = B.[DV_PLAN_END_DATE]
							   ,A.[DV_ACTUAL_START_DATE]   = B.[DV_ACTUAL_START_DATE]
							   ,A.[DV_ACTUAL_END_DATE]     = B.[DV_ACTUAL_END_DATE]
							   ,A.[PD_APP_PLAN_START_DATE] = B.[PD_APP_PLAN_START_DATE]
							   ,A.[PD_APP_PLAN_END_DATE]   = B.[PD_APP_PLAN_END_DATE]
							   ,A.[PD_PLAN_START_DATE]     = B.[PD_PLAN_START_DATE]
							   ,A.[PD_PLAN_END_DATE]       = B.[PD_PLAN_END_DATE]
							   ,A.[PD_ACTUAL_START_DATE]   = B.[PD_ACTUAL_START_DATE]
							   ,A.[PD_ACTUAL_END_DATE]     = B.[PD_ACTUAL_END_DATE]
							   ,A.[PV_APP_PLAN_START_DATE] = B.[PV_APP_PLAN_START_DATE]
							   ,A.[PV_APP_PLAN_END_DATE]   = B.[PV_APP_PLAN_END_DATE]
							   ,A.[PV_PLAN_START_DATE]     = B.[PV_PLAN_START_DATE]
							   ,A.[PV_PLAN_END_DATE]       = B.[PV_PLAN_END_DATE]
							   ,A.[PV_ACTUAL_START_DATE]   = B.[PV_ACTUAL_START_DATE]
							   ,A.[PV_ACTUAL_END_DATE]     = B.[PV_ACTUAL_END_DATE]
							   ,A.[PJT_PROGRESS_STEP]	   = B.[PJT_PROGRESS_STEP]			--2018-08-27 PIYONG ADD
							   ,A.[PJT_STATUS]			   = B.[PJT_STATUS]					--2018-08-27 PIYONG ADD
							   ,A.[UPDATE_ID]			   = 'PR_XIF_PLM_PJT_SCHEDULE_R'
							   ,A.[UPDATE_TIME]			   = GETDATE()

				WHEN NOT MATCHED THEN

					INSERT ([PROJECT_ID]
							,[DIVISION_ID]
							,[MODEL_NAME]
							,[REP_YN]
							,[CV_APP_PLAN_START_DATE]
							,[CV_APP_PLAN_END_DATE]
							,[CV_PLAN_START_DATE]
							,[CV_PLAN_END_DATE]
							,[CV_ACTUAL_START_DATE]
							,[CV_ACTUAL_END_DATE]
							,[DV_APP_PLAN_START_DATE]
							,[DV_APP_PLAN_END_DATE]
							,[DV_PLAN_START_DATE]
							,[DV_PLAN_END_DATE]
							,[DV_ACTUAL_START_DATE]
							,[DV_ACTUAL_END_DATE]
							,[PD_APP_PLAN_START_DATE]
							,[PD_APP_PLAN_END_DATE]
							,[PD_PLAN_START_DATE]
							,[PD_PLAN_END_DATE]
							,[PD_ACTUAL_START_DATE]
							,[PD_ACTUAL_END_DATE]
							,[PV_APP_PLAN_START_DATE]
							,[PV_APP_PLAN_END_DATE]
							,[PV_PLAN_START_DATE]
							,[PV_PLAN_END_DATE]
							,[PV_ACTUAL_START_DATE]
							,[PV_ACTUAL_END_DATE]
							,[PJT_PROGRESS_STEP]		--2018-08-27 PIYONG ADD
							,[PJT_STATUS]				--2018-08-27 PIYONG ADD
							,[INSERT_TIME]
							,[INSERT_ID]
							,[UPDATE_TIME]
							,[UPDATE_ID]
					) VALUES (
							B.[PROJECT_ID]
							,B.[DIVISION_ID]
							,B.[MODEL_NAME]
							,B.[REP_YN]
							,B.[CV_APP_PLAN_START_DATE]
							,B.[CV_APP_PLAN_END_DATE]
							,B.[CV_PLAN_START_DATE]
							,B.[CV_PLAN_END_DATE]
							,B.[CV_ACTUAL_START_DATE]
							,B.[CV_ACTUAL_END_DATE]
							,B.[DV_APP_PLAN_START_DATE]
							,B.[DV_APP_PLAN_END_DATE]
							,B.[DV_PLAN_START_DATE]
							,B.[DV_PLAN_END_DATE]
							,B.[DV_ACTUAL_START_DATE]
							,B.[DV_ACTUAL_END_DATE]
							,B.[PD_APP_PLAN_START_DATE]
							,B.[PD_APP_PLAN_END_DATE]
							,B.[PD_PLAN_START_DATE]
							,B.[PD_PLAN_END_DATE]
							,B.[PD_ACTUAL_START_DATE]
							,B.[PD_ACTUAL_END_DATE]
							,B.[PV_APP_PLAN_START_DATE]
							,B.[PV_APP_PLAN_END_DATE]
							,B.[PV_PLAN_START_DATE]
							,B.[PV_PLAN_END_DATE]
							,B.[PV_ACTUAL_START_DATE]
							,B.[PV_ACTUAL_END_DATE]
							,B.[PJT_PROGRESS_STEP]		--2018-08-27 PIYONG ADD
							,B.[PJT_STATUS]				--2018-08-27 PIYONG ADD
							,GETDATE()
							,'PR_XIF_PLM_PJT_SCHEDULE_R'
							,GETDATE()
							,'PR_XIF_PLM_PJT_SCHEDULE_R'
					)

				;


			---------------------------------------------------------------------------------------------------------------------------------
			--2019-06-25 PIYONG ADD
			DECLARE CUR_PJT CURSOR FOR
				SELECT [PROJECT_ID]
					   ,[PROJECT_NAME]
					   --,[DIVISION_ID]
					   ,BBB.[PSEUDO_DIVISION_ID] -- 2022-03-20 kimcd 가상 Division 사용에 따른 로직 보완. 가상 디비전으로 변경
					   ,[MODEL_NAME]
					   ,[PJT_PROGRESS_STEP]
					   ,[PJT_STATUS]
					   ,CASE WHEN [PJT_STATUS] = 'Complete' THEN
								'MASS'
							 WHEN [PJT_PROGRESS_STEP] = 'PV' AND [DIVISION_ID] = '81' THEN
								'SPECIAL'
							 WHEN [PJT_PROGRESS_STEP] = 'PV' AND [DIVISION_ID] != '81' THEN
								'D-SAMPLE'
							 ELSE
								'D-SAMPLE'
							 END AS PRODUCTION_TYPE
					   ,MAX(VDATE) AS PJT_SCHEDULE_DATE
				  FROM (
						SELECT *
						  FROM (
								SELECT [PROJECT_ID]
										,[PROJECT_NAME]
										,[DIVISION_ID]
										,[MODEL_NAME]							
										,[PJT_PROGRESS_STEP]
										,[PJT_STATUS]
										,[CV_PLAN_END_DATE]
										,[DV_PLAN_END_DATE]
										,[PD_PLAN_END_DATE]
										,[PV_PLAN_END_DATE]
								  FROM (
										SELECT DM.[PROJECT_ID]
											   ,DM.[PROJECT_NAME]
											   ,DM.[MODEL_NAME]
											   ,S.[CV_PLAN_END_DATE]
											   ,S.[DV_PLAN_END_DATE]
											   ,S.[PD_PLAN_END_DATE]
											   ,S.[PV_PLAN_END_DATE]
											   ,CASE S.ATTR_01 WHEN 'AUTO' THEN '81'
															   WHEN 'MOBILE' THEN '40'
															   WHEN 'ESS' THEN '82'
															   END						 AS [DIVISION_ID]
											   ,ROW_NUMBER() OVER ( PARTITION BY DM.[PROJECT_ID], DM.[MODEL_NAME]
																		ORDER BY S.IF_RCV_DATE DESC, S.IF_SEQ DESC ) ROWNUMBER
											   ,S.ATTR_02 AS PJT_PROGRESS_STEP
											   ,S.ATTR_03 AS PJT_STATUS
										  FROM [SY_XIF_PLM_PJT_DV_MASTER_R] DM WITH(NOLOCK)	-- 동일한 정보가 1시간 마다 수신 될 수도 있음
										  JOIN [SY_XIF_PLM_PJT_SCHEDULE_R] S
											ON DM.PROJECT_ID = S.PROJECT_ID
										 WHERE S.PROC_FLAG = 'P'
										   AND DM.IF_RCV_DATE >= DATEADD(HOUR, -1, GETDATE())
									   ) A
								 WHERE ROWNUMBER = 1
							   ) AA
							   UNPIVOT ( 
										VDATE FOR DATE_GB IN (
																[CV_PLAN_END_DATE]
																,[DV_PLAN_END_DATE]
																,[PD_PLAN_END_DATE]
																,[PV_PLAN_END_DATE]
															 )
									   ) PVT
					   ) AAA
					LEFT OUTER JOIN (SELECT DISTINCT DIVISION_ID AS PSEUDO_DIVISION_ID, DIVISION_ID AS ORIGINAL_DIVISION_ID
									 FROM   DBO.SCM_DIVISION_M (NOLOCK)
									 UNION  
									 SELECT DISTINCT PSEUDO_DIVISION_ID, ORIGINAL_DIVISION_ID
									 FROM   DBO.SCM_PSEUDO_DIVISION_M (NOLOCK)) BBB
						ON AAA.DIVISION_ID = BBB.ORIGINAL_DIVISION_ID  -- 2022-03-20 kimcd 가상 Division 사용에 따른 로직 보완. 가상 디비전과 연결
				 WHERE MODEL_NAME IS NOT NULL
				 GROUP BY [PROJECT_ID]
						,[PROJECT_NAME]
						,[DIVISION_ID]
						,BBB.[PSEUDO_DIVISION_ID] -- 2022-03-20 kimcd 가상 Division 사용에 따른 로직 보완. 가상 디비전 추가
						,[MODEL_NAME]
						,[PJT_PROGRESS_STEP]
						,[PJT_STATUS] ;

			OPEN CUR_PJT;
			FETCH NEXT FROM CUR_PJT INTO @PROJECT_ID
										 ,@PROJECT_NAME
										 ,@DIVISION_ID
										 ,@MODEL_NAME
										 ,@PJT_PROGRESS_STEP
										 ,@PJT_STATUS
										 ,@PRODUCTION_TYPE
										 ,@PJT_SCHEDULE_DATE
										 ;

			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				IF ( SELECT COUNT(*) FROM [DBO].[FP_PLM_PJT_MODEL_MASTER]
				      WHERE [PROJECT_ID] IS NULL AND DIVISION_ID = @DIVISION_ID AND [MODEL_ID] = @MODEL_NAME) > 0		-- SCP생산 TARGET에서 생성된 MODEL
					BEGIN
						UPDATE [DBO].[FP_PLM_PJT_MODEL_MASTER]
						   SET [PROJECT_ID]				= @PROJECT_ID
							   ,[PROJECT_NAME]			= @PROJECT_NAME
							   ,[PJT_SCHEDULE_DATE]		= @PJT_SCHEDULE_DATE
							   ,[PJT_PROGRESS_STEP_ID]	= @PJT_PROGRESS_STEP
							   ,[PJT_STATUS_ID]			= @PJT_STATUS
						 WHERE [MODEL_ID]   = @MODEL_NAME -- 2022-03-20 kimcd 갱신 조건을 PROJECT_ID에서 MODEL_ID로 변경
						   AND DIVISION_ID  = @DIVISION_ID
					END
				ELSE
					BEGIN
						IF ( SELECT COUNT(*) FROM [DBO].[FP_PLM_PJT_MODEL_MASTER] WHERE [MODEL_ID] = @MODEL_NAME AND DIVISION_ID = @DIVISION_ID ) > 0	--저장되어 있는 MODEL
							BEGIN
								-- 저장되어 있는 PJT 상태값, 최종예정일 정보를 조회
								SELECT @BEFORE_PJT_SCHEDULE_DATE=[PJT_SCHEDULE_DATE]
									   , @BEFORE_PJT_STATUS = [PJT_STATUS_ID]
									   , @BEFORE_PJT_PROGRESS_STEP =[PJT_PROGRESS_STEP_ID]
									   , @BEFORE_PROJECT_ID = [PROJECT_ID]
								  FROM [FP_PLM_PJT_MODEL_MASTER] WITH(NOLOCK)
								 WHERE [MODEL_ID] = @MODEL_NAME
								   AND DIVISION_ID = @DIVISION_ID;


								-- 저장되어 있는 정보와 현재의 정보와 비교
								IF ( @BEFORE_PROJECT_ID = @PROJECT_ID )			-- 프로젝트 코드가 같으면 경우
								   OR ( @BEFORE_PROJECT_ID != @PROJECT_ID		-- 프로젝트 코드가 다르고 저장되어 있는 단계보다 이후 단계 이거나 상태가 Complete 경우
										AND ( 
												(
													@PJT_STATUS NOT IN ('Drop', 'Holding', 'Planning Holding')
													AND @BEFORE_PJT_STATUS != 'Complete'
													AND ISNULL(@BEFORE_PJT_PROGRESS_STEP, 'AA') < @PJT_PROGRESS_STEP	-- AA단계는 임의적생성
												)
												OR ( @PJT_STATUS ='Complete' AND @BEFORE_PJT_STATUS != 'Complete' )
											)
								      )

									BEGIN
										UPDATE [DBO].[FP_PLM_PJT_MODEL_MASTER]
										   SET [DIVISION_ID]			= @DIVISION_ID
											   ,[PROJECT_NAME]			= @PROJECT_NAME
											   ,[PJT_SCHEDULE_DATE]		= @PJT_SCHEDULE_DATE
											   ,[PJT_PROGRESS_STEP_ID]	= @PJT_PROGRESS_STEP
											   ,[PJT_STATUS_ID]			= @PJT_STATUS
											   ,[PRODUCTION_TYPE]		= CASE WHEN [UPDATE_ID] = 'PR_XIF_PLM_PJT_SCHEDULE_R' THEN
																				@PRODUCTION_TYPE
																			   ELSE
																				[PRODUCTION_TYPE]
																			   END
											   ,[FP_PJT_SCHEDULE_DATE]	= CASE WHEN [UPDATE_ID] = 'PR_XIF_PLM_PJT_SCHEDULE_R' THEN
																				@PJT_SCHEDULE_DATE
																			   ELSE
																				[FP_PJT_SCHEDULE_DATE]
																			   END
											   ,[UPDATE_ID]				= CASE WHEN [UPDATE_ID] = 'PR_XIF_PLM_PJT_SCHEDULE_R' THEN
																				'PR_XIF_PLM_PJT_SCHEDULE_R'
																			   ELSE
																				[UPDATE_ID]
																			   END
											   ,[UPDATE_TIME]			= CASE WHEN [UPDATE_ID] = 'PR_XIF_PLM_PJT_SCHEDULE_R' THEN
																				GETDATE()
																			   ELSE
																				[UPDATE_TIME]
																			   END
										WHERE [MODEL_ID] = @MODEL_NAME
										  AND DIVISION_ID = @DIVISION_ID
										;
									END
							END
						ELSE																															-- 신규 수신
							BEGIN
								INSERT INTO [DBO].[FP_PLM_PJT_MODEL_MASTER](
									[PROJECT_ID]
									,[PROJECT_NAME]
									,[DIVISION_ID]
									,[MODEL_ID]
									,[PJT_SCHEDULE_DATE]
									,[PJT_PROGRESS_STEP_ID]
									,[PJT_STATUS_ID]
									,[PRODUCTION_TYPE]
									,[FP_PJT_SCHEDULE_DATE]
									,[INSERT_TIME]
									,[INSERT_ID]
									,[UPDATE_TIME]
									,[UPDATE_ID]
								) VALUES (
									@PROJECT_ID
									,@PROJECT_NAME
									,@DIVISION_ID
									,@MODEL_NAME
									,@PJT_SCHEDULE_DATE
									,@PJT_PROGRESS_STEP
									,@PJT_STATUS
									,@PRODUCTION_TYPE
									,@PJT_SCHEDULE_DATE
									,GETDATE()
									,'PR_XIF_PLM_PJT_SCHEDULE_R'
									,GETDATE()
									,'PR_XIF_PLM_PJT_SCHEDULE_R'
								);
							END
					END

				FETCH NEXT FROM CUR_PJT INTO @PROJECT_ID
											 ,@PROJECT_NAME
											 ,@DIVISION_ID
											 ,@MODEL_NAME
											 ,@PJT_PROGRESS_STEP
											 ,@PJT_STATUS
											 ,@PRODUCTION_TYPE
											 ,@PJT_SCHEDULE_DATE
											 ;
			END;
			CLOSE CUR_PJT;
			DEALLOCATE CUR_PJT;


			--2019-06-25 PIYONG ADD END
			---------------------------------------------------------------------------------------------------------------------------------
		

			UPDATE [SY_XIF_PLM_PJT_SCHEDULE_R]
			   SET PROC_FLAG = 'Y'
				   ,PROC_DATE = GETDATE()
			 WHERE PROC_FLAG = 'P'
			;

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
