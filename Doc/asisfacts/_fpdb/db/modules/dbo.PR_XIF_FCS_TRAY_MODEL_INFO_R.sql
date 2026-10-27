
CREATE PROCEDURE [dbo].[PR_XIF_FCS_TRAY_MODEL_INFO_R]

-- ================================================================================================
-- Program ID          : FP00412
-- Program Name        : PR_XIF_FCS_TRAY_MODEL_INFO_R
-- Param               :
-- Batch Period        : 1DAY
-- Description         :
--
-- Source System       : FCS
-- Destination System  : FP SDB
-- Source Table        : [XIF_FCS_TRAY_TYPE_R], [XIF_FCS_FP_TRAY_TYPE_R]
-- Destination Table   : SCM_FCS_TRAY_M, SCM_FCS_TRAY_MODEL_M
--
-- Create(Update) Date : 2023.01.20
-- Author              : PIYONG
-- Version             : 1.0 2020-03-04 PIYONG
--                       1.1 2020-08-12 kimcd 당일 갱신 안 된 정보는 삭제, 모델 정보 점검을 라인 할당 기준으로 변경
--                       1.2 2021-02-19 kimcd FCS나 DW의 장애로 정보 수신 안 되는 경우 전체 정보 삭제되는 현상 발생
--                                            당일 변경된 것이 없는 경우 삭제 안 함. 삭제한 경우 이력 정보 형성
--                       1.3 2021-11-22 kimcd 삭제 조건에 PR_XIF_FCS_TRAY_MODEL_INFO_R 이 만든 것만 삭제하도록 조건 추가
--                       1.4 2023-01-20	kimcd WA 법인 동별 Tray Simulation에 따라 Master 수신 작업 보완
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_FCS_TRAY_MODEL_INFO_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @PLANT_ID			NVARCHAR(30)
--	DECLARE @FACTORY_ID			NVARCHAR(30)
	DECLARE @TRAY_TYPE_CODE		NVARCHAR(30)
	DECLARE @TRAY_TYPE_NAME		NVARCHAR(150)
	DECLARE @LINE_ID			NVARCHAR(30)
	DECLARE @MODEL_ID			NVARCHAR(150)
	DECLARE @USE_YN				NVARCHAR(1)
	DECLARE @DEGAS_BEFORE_TYPE	NVARCHAR(1)
	DECLARE @CELL_CNT			NVARCHAR(30)
	DECLARE @FACTORY_ID         NVARCHAR(30) -- 2022-01-20 kimcd 동 추가
	DECLARE @PSEUDO_FACTORY_ID  NVARCHAR(30) -- 2022-01-20 kimcd 동 추가


	DECLARE CR_TRAY CURSOR FOR
		SELECT I.[PLANT_ID]
			   ,I.TRAY_TYPE_CODE
		       ,I.[TRAY_TYPE_NAME]
			   ,I.[DEGAS_BEFORE_TYPE]
			   ,I.[CELL_CNT]
			   ,I.[USE_YN]
		       ,ISNULL(ISNULL(L.PSEUDO_FACTORY_ID, F.FACTORY_ID), '-') AS PSEUDO_FACTORY_ID -- 2022-01-20 kimcd 동 추가
		  FROM (
				SELECT DISTINCT
						y.PLANT_ID
				       ,x.[BUILDING]     AS FACTORY_ID  -- 2022-01-20 kimcd 동 추가
					   ,x.[TRAY_TYPE_CD] AS TRAY_TYPE_CODE
					   ,x.[TRAY_TYPE_NAME]
					   ,CASE WHEN x.[DEGAS_BEFORE_YN] = '' THEN  '-'
							 ELSE x.[DEGAS_BEFORE_YN]
							 END									 AS [DEGAS_BEFORE_TYPE]
					   ,x.[CELL_CNT]
					   ,x.[USE_YN]
			       FROM [SY_XIF_FCS_TRAY_TYPE_R] as x
			       JOIN scm_factory_m as y with(nolock)
				   on x.building = y.factory_id

		  		 WHERE TRANSFER_FLAG = 'P'
			   ) I
			   -- 2022-01-20 kimcd 동 추가 시작
			   LEFT OUTER JOIN (SELECT IFM.INSTANCE_ID
									  ,IFM.FACTORY_ID
								FROM   SCM_SYS_LOOKUP_VALUE   F (NOLOCK)
									  ,FP_INSTANCE_FACTORY_M  IFM  (NOLOCK)
								WHERE  F.LOOKUP_TYPE_CODE = 'FORM_TRAY_SIMUL_OPTION'
								AND    F.SEGMENT1 = IFM.INSTANCE_ID
								AND    F.ACTIVE_FLAG = 'Y'
								AND    F.ATTRIBUTE1 = 'building' ) F
				   ON  I. FACTORY_ID = F.FACTORY_ID
				LEFT OUTER JOIN ( SELECT SEGMENT1 AS INSTANCE_ID
										,SEGMENT3 AS PLANT_ID
										,SEGMENT4 AS FACTORY_ID
										,SEGMENT5 AS PSEUDO_FACTORY_ID
				                  FROM   SCM_SYS_LOOKUP_VALUE   L (NOLOCK)
								  WHERE  L.LOOKUP_TYPE_CODE = 'FORMATION_TRAY_FACTORY_OPTION'
								  AND    L.ACTIVE_FLAG = 'Y' ) L
				   ON  L.PLANT_ID    = I.PLANT_ID
				   AND L.INSTANCE_ID = F.INSTANCE_ID
				   AND L.FACTORY_ID  = F.FACTORY_ID
			   -- 2022-01-20 kimcd 동 추가 종료
		 ORDER BY I.[PLANT_ID]
		       ,ISNULL(ISNULL(L.PSEUDO_FACTORY_ID, F.FACTORY_ID), '-')  -- 2022-01-20 kimcd 동 추가
			   ,I.TRAY_TYPE_CODE
			   ,I.[DEGAS_BEFORE_TYPE]
			   ,I.[USE_YN]


	DECLARE CR_MODEL CURSOR FOR  -- 2020-08-12 kimcd 모델 정보 점검을 라인 할당 기준으로 변경하기위해 재구성
		SELECT AAA.PLANT_ID 
		       ,AAA.FACTORY_ID   -- 2022-01-20 kimcd 동 추가
			   ,AAA.PSEUDO_FACTORY_ID  -- 2022-01-20 kimcd 가상 동 추가
			   ,AAA.TRAY_TYPE_CD
			   ,C.[MODEL_ID]
			   ,AAA.LINE_ID
			   ,AAA.USE_YN
		  FROM (SELECT   ISNULL( L.PLANT_ID, AA.[PLANT_ID] ) AS PLANT_ID
						,ISNULL( L.FACTORY_ID, AA.[BUILDING] ) AS BUILDING
						,CASE WHEN F.FACTORY_ID IS NOT NULL THEN ISNULL( L.FACTORY_ID, F.FACTORY_ID) ELSE '-' END AS FACTORY_ID  -- 2022-01-20 kimcd 가상 동 추가
						,CASE WHEN F.FACTORY_ID IS NOT NULL THEN ISNULL( L.PSEUDO_FACTORY_ID, F.FACTORY_ID) ELSE '-' END  AS PSEUDO_FACTORY_ID  -- 2022-01-20 kimcd 가상 동 추가
						,AA.[TRAY_TYPE_CD]
						,AA.[MODEL_ID]
						,AA.LINE_ID
						,AA.[USE_YN]
		        FROM  (	SELECT  y.[PLANT_ID]
							   ,A.[BUILDING]
							   ,[TRAY_TYPE_CD]
							   ,A.[MODEL_ID]
							   ,ISNULL(SSLV.SEGMENT3, A.LINE_ID ) AS LINE_ID
							   ,[USE_YN]
						  FROM [SY_XIF_FCS_FP_TRAY_TYPE_R] AS A
							   JOIN scm_factory_m as y with(nolock)
							   on a.building = y.factory_id
							   LEFT OUTER JOIN (
												SELECT *
												  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
												 WHERE LOOKUP_TYPE_CODE = 'FORMATION_TRAY_DEGAS_LANE_MAPPING'
												   AND ACTIVE_FLAG = 'Y'
											   ) SSLV
											ON A.LINE_ID  = SSLV.SEGMENT2
										   AND A.BUILDING = SSLV.SEGMENT1
						 WHERE A.TRANSFER_FLAG = 'P'
						UNION
						SELECT y.[PLANT_ID]
							   ,A.[BUILDING]
							   ,[TRAY_TYPE_CD]
							   ,A.[MODEL_ID]
							   , ISNULL(SSLV.SEGMENT3, A.LINE_ID ) AS LINE_ID
							   ,[USE_YN]
						  FROM [SY_XIF_FCS_TRAY_TYPE_DEGAS_EMPTY_R] AS A
							   JOIN scm_factory_m as y with(nolock)
							   on a.building = y.factory_id
							   LEFT OUTER JOIN (
												SELECT *
												  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
												 WHERE LOOKUP_TYPE_CODE = 'FORMATION_TRAY_DEGAS_LANE_MAPPING'
												   AND ACTIVE_FLAG = 'Y'
											   ) SSLV
											ON A.LINE_ID  = SSLV.SEGMENT2
										   AND A.BUILDING = SSLV.SEGMENT1
						 WHERE A.TRANSFER_FLAG = 'P'
					   ) AA
					   LEFT OUTER JOIN (SELECT IFM.FACTORY_ID
										FROM   SCM_SYS_LOOKUP_VALUE   F (NOLOCK)
											  ,FP_INSTANCE_FACTORY_M  IFM  (NOLOCK)
										WHERE  F.LOOKUP_TYPE_CODE = 'FORM_TRAY_SIMUL_OPTION'
										AND    F.SEGMENT1 = IFM.INSTANCE_ID
										AND    F.ACTIVE_FLAG = 'Y'
										AND    F.ATTRIBUTE1 = 'building' ) F
						   ON  AA.BUILDING = F.FACTORY_ID  -- 2022-01-20 kimcd 가상 동 추가
					   LEFT OUTER JOIN ( SELECT DISTINCT PLANT_ID, FACTORY_ID, ISNULL(L.PSEUDO_FACTORY_ID, L.FACTORY_ID) AS PSEUDO_FACTORY_ID, LINE_ID
												-- 2022-01-20 kimcd 가상 동 추가
										   FROM SCM_LINE_M L (NOLOCK)
										  WHERE OPERATION_ID IN ( 'F5300','F5500','F5600','F6000')	 ) L
									ON AA.LINE_ID = L.LINE_ID ) AAA
					   INNER JOIN FP_MODEL_LOT_M C with(nolock)
							   ON AAA.BUILDING = C.FACTORY_ID
							  AND AAA.[MODEL_ID] = C.MODEL_LOT_ID
					   INNER JOIN SCM_PLANT_M P
							   ON AAA.PLANT_ID = P.PLANT_ID
					   INNER JOIN SCM_ITEM_M M								-- 불필요한 ITEM 제거를 위한 JOIN
							   ON C.MODEL_ID = M.ITEM_ID
   							  AND P.COMPANY_ID = M.COMPANY_ID
							  AND P.DIVISION_ID = M.DIVISION_ID
							  AND P.SITE_ID = M.SITE_ID
		 ORDER BY AAA.PLANT_ID
			   ,AAA.TRAY_TYPE_CD
			   ,C.MODEL_ID
			   ,AAA.LINE_ID

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			UPDATE [SY_XIF_FCS_TRAY_TYPE_R]
			   SET TRANSFER_FLAG = 'P'
			 WHERE TRANSFER_FLAG = 'N'

			OPEN CR_TRAY;
			FETCH NEXT FROM CR_TRAY INTO @PLANT_ID
									--	  ,@FACTORY_ID
										 ,@TRAY_TYPE_CODE
										 ,@TRAY_TYPE_NAME
										 ,@DEGAS_BEFORE_TYPE
										 ,@CELL_CNT
										 ,@USE_YN
										 ,@PSEUDO_FACTORY_ID  -- 2022-01-20 kimcd 동 추가


			WHILE (@@FETCH_STATUS = 0)
				BEGIN

					MERGE INTO [SCM_FCS_TRAY_M] A
					USING (
							SELECT DISTINCT P.COMPANY_ID
								   ,P.DIVISION_ID
								   ,P.SITE_ID
								   ,P.[PLANT_ID]
								   ,@TRAY_TYPE_CODE AS TRAY_TYPE_CODE
								   ,@TRAY_TYPE_NAME AS [TRAY_TYPE_NAME]
								   ,@DEGAS_BEFORE_TYPE AS [DEGAS_BEFORE_TYPE]
								   ,@CELL_CNT AS [CELL_CNT]
								   ,@USE_YN AS [USE_YN]
								   ,@PSEUDO_FACTORY_ID  AS  PSEUDO_FACTORY_ID -- 2022-01-20 kimcd 동 추가
							  FROM SCM_PLANT_M P
							 WHERE PLANT_ID = @PLANT_ID

						  ) B
					   ON (
							A.COMPANY_ID			= B.COMPANY_ID
							AND A.DIVISION_ID		= B.DIVISION_ID
							AND A.SITE_ID			= B.SITE_ID
							AND A.PLANT_ID			= B.PLANT_ID
							AND A.TRAY_TYPE_CODE	= B.TRAY_TYPE_CODE
							AND A.FACTORY_ID        = B.PSEUDO_FACTORY_ID -- 2022-01-20 kimcd 동 추가
						  )
					 WHEN MATCHED THEN
						UPDATE SET
							A.CELL_CNT				= B.CELL_CNT
							,A.[TRAY_TYPE_NAME]		= B.[TRAY_TYPE_NAME]
							,A.[DEGAS_BEFORE_TYPE]	= B.[DEGAS_BEFORE_TYPE]
							,A.USE_YN				= B.USE_YN
							,A.UPDATE_ID			= @v_proc_name
							,A.UPDATE_DATE			= GETDATE()
					 WHEN NOT MATCHED  THEN
						INSERT (
							[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]  -- 2022-01-20 kimcd 동 추가
							,[TRAY_TYPE_CODE]
							,[TRAY_TYPE_NAME]
							,[DEGAS_BEFORE_TYPE]
							,[CELL_CNT]
							,[USE_YN]
							,[INSERT_ID]
							,[INSERT_DATE]
							,[UPDATE_ID]
							,[UPDATE_DATE]
						) VALUES (
							B.[COMPANY_ID]
							,B.[DIVISION_ID]
							,B.[SITE_ID]
							,B.[PLANT_ID]
							,B.PSEUDO_FACTORY_ID -- 2022-01-20 kimcd 동 추가
							,B.[TRAY_TYPE_CODE]
							,B.[TRAY_TYPE_NAME]
							,B.[DEGAS_BEFORE_TYPE]
							,B.[CELL_CNT]
							,B.[USE_YN]
							,@v_proc_name
							,GETDATE()
							,@v_proc_name
							,GETDATE()
						)
					;

					FETCH NEXT FROM CR_TRAY INTO @PLANT_ID
											--	  ,@FACTORY_ID
												 ,@TRAY_TYPE_CODE
												 ,@TRAY_TYPE_NAME
												 ,@DEGAS_BEFORE_TYPE
												 ,@CELL_CNT
												 ,@USE_YN
												 ,@PSEUDO_FACTORY_ID  -- 2022-01-20 kimcd 동 추가

				END;

			CLOSE CR_TRAY;
			DEALLOCATE CR_TRAY; 

			-- 2021-02-19 kimcd 당일 변경 정보가 없는 경우 삭제 전 이력 형성
			INSERT INTO HIS_FCS_TRAY_M
				(  [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]  -- 2022-01-20 kimcd 동 추가
				  ,[TRAY_TYPE_CODE]
				  ,[TRAY_TYPE_NAME]
				  ,[DEGAS_BEFORE_TYPE]
				  ,[CELL_CNT]
				  ,[LOAD_YIELD]
				  ,[BUFFER_DAY]
				  ,[TRAY_CNT]
				  ,[INTRANSIT_CNT]
				  ,[DESCRIPTION]
				  ,[USE_YN]
				  ,[INSERT_ID]
				  ,[INSERT_DATE]
				  ,[UPDATE_ID]
				  ,[UPDATE_DATE]
				  ,[TRAY_TYPE_GROUP]
				  ,[JOB_USER_ID]
				  ,[JOB_TIME]
				  ,[JOB_TYPE])
			SELECT [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID] -- 2022-01-20 kimcd 동 추가
				  ,[TRAY_TYPE_CODE]
				  ,[TRAY_TYPE_NAME]
				  ,[DEGAS_BEFORE_TYPE]
				  ,[CELL_CNT]
				  ,[LOAD_YIELD]
				  ,[BUFFER_DAY]
				  ,[TRAY_CNT]
				  ,[INTRANSIT_CNT]
				  ,[DESCRIPTION]
				  ,[USE_YN]
				  ,[INSERT_ID]
				  ,[INSERT_DATE]
				  ,[UPDATE_ID]
				  ,[UPDATE_DATE]
				  ,[TRAY_TYPE_GROUP]
				  ,@v_proc_name
				  ,GETDATE()
				  ,'BATCH DELETE'
			FROM   [SCM_FCS_TRAY_M]
			WHERE  PLANT_ID IN  ( SELECT DISTINCT y.[PLANT_ID]
								  FROM [SY_XIF_FCS_TRAY_TYPE_R] as x
									   JOIN scm_factory_m as y with(nolock)
									   on x.building = y.factory_id
								WHERE TRANSFER_FLAG = 'P' )
			AND    INSERT_ID   = 'PR_XIF_FCS_TRAY_MODEL_INFO_R' -- 2021-11-22 kimcd 삭제 조건에 PR_XIF_FCS_TRAY_MODEL_INFO_R 이 만든 것만 삭제하도록 조건 추가
			AND    UPDATE_DATE < CONVERT(DATE, GETDATE())
			-- 2021-02-19 kimcd 당일 변경 정보가 없는 경우 삭제 전 이력 형성 끝

			-- 2020-08-12 kimcd 당일 변경 정보가 없는 경우 삭제 시작
			DELETE FROM [SCM_FCS_TRAY_M]
			WHERE PLANT_ID IN  ( SELECT DISTINCT y.[PLANT_ID]
								 FROM [SY_XIF_FCS_TRAY_TYPE_R] as x
									   JOIN scm_factory_m as y with(nolock)
									   on x.building = y.factory_id
								WHERE TRANSFER_FLAG = 'P' )
			AND   INSERT_ID   = 'PR_XIF_FCS_TRAY_MODEL_INFO_R' -- 2021-11-22 kimcd 삭제 조건에 PR_XIF_FCS_TRAY_MODEL_INFO_R 이 만든 것만 삭제하도록 조건 추가
			AND   UPDATE_DATE < CONVERT(DATE, GETDATE())
			-- 2020-08-12 kimcd 당일 변경 정보가 없는 경우 삭제 끝

			UPDATE [SY_XIF_FCS_TRAY_TYPE_R]
			   SET TRANSFER_FLAG = 'Y'
			 WHERE TRANSFER_FLAG = 'P'




			UPDATE [SY_XIF_FCS_FP_TRAY_TYPE_R]
			   SET TRANSFER_FLAG = 'P'
			 WHERE TRANSFER_FLAG = 'N'

			 UPDATE [SY_XIF_FCS_TRAY_TYPE_DEGAS_EMPTY_R]
			   SET TRANSFER_FLAG = 'P'
			 WHERE TRANSFER_FLAG = 'N'


			OPEN CR_MODEL;
			FETCH NEXT FROM CR_MODEL INTO @PLANT_ID
									        ,@FACTORY_ID         -- 2022-01-20 kimcd 동 추가
										    ,@PSEUDO_FACTORY_ID  -- 2022-01-20 kimcd 가상 동 추가
											,@TRAY_TYPE_CODE
											,@MODEL_ID
											,@LINE_ID
											,@USE_YN

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					MERGE INTO [SCM_FCS_TRAY_MODEL_M] A
					USING (
							SELECT P.COMPANY_ID
								   ,P.DIVISION_ID
								   ,P.SITE_ID
								   ,P.[PLANT_ID]
						           ,@FACTORY_ID         AS FACTORY_ID         -- 2022-01-20 kimcd 동 추가
							       ,@PSEUDO_FACTORY_ID  AS PSEUDO_FACTORY_ID  -- 2022-01-20 kimcd 가상 동 추가
								   ,@TRAY_TYPE_CODE AS TRAY_TYPE_CODE
								   ,@MODEL_ID AS ITEM_ID
								   ,@LINE_ID AS LINE_ID
								   ,@USE_YN AS USE_YN
							  FROM SCM_PLANT_M P
							WHERE P.[PLANT_ID] = @PLANT_ID
						  ) B
					   ON (
							A.COMPANY_ID			= B.COMPANY_ID
							AND A.DIVISION_ID		= B.DIVISION_ID
							AND A.SITE_ID			= B.SITE_ID
							AND A.PLANT_ID			= B.PLANT_ID
							AND A.TRAY_TYPE_CODE	= B.TRAY_TYPE_CODE
							AND A.ITEM_ID			= B.ITEM_ID
							AND A.LINE_ID			= B.LINE_ID
							AND A.FACTORY_ID        = B.FACTORY_ID
						  )
					 WHEN MATCHED THEN
						UPDATE SET
				--			A.USE_YN			= CASE WHEN A.UPDATE_ID = @v_proc_name THEN B.USE_YN ELSE A.USE_YN END
							A.PSEUDO_FACTORY_ID = B.PSEUDO_FACTORY_ID    -- 2022-01-20 kimcd 가상 동 추가
							,A.UPDATE_ID		= @v_proc_name
							,A.UPDATE_DATE		= GETDATE()
					 WHEN NOT MATCHED  THEN
						INSERT (
							[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]         -- 2022-01-20 kimcd 동 추가
							,[PSEUDO_FACTORY_ID]  -- 2022-01-20 kimcd 가상 동 추가
							,[TRAY_TYPE_CODE]
							,[ITEM_ID]
							,[LINE_ID]
							,[USE_YN]
	  						,[INSERT_ID]
							,[INSERT_DATE]
							,[UPDATE_ID]
							,[UPDATE_DATE]
						) VALUES (
							B.[COMPANY_ID]
							,B.[DIVISION_ID]
							,B.[SITE_ID]
							,B.[PLANT_ID]
							,B.[FACTORY_ID]         -- 2022-01-20 kimcd 동 추가
							,B.[PSEUDO_FACTORY_ID]  -- 2022-01-20 kimcd 가상 동 추가
							,B.[TRAY_TYPE_CODE]
							,B.[ITEM_ID]
							,B.[LINE_ID]
							,'Y' --B.[USE_YN]
							,@v_proc_name
							,GETDATE()
							,@v_proc_name
							,GETDATE()
						)
					;

					FETCH NEXT FROM CR_MODEL INTO @PLANT_ID
												        ,@FACTORY_ID         -- 2022-01-20 kimcd 동 추가
													    ,@PSEUDO_FACTORY_ID  -- 2022-01-20 kimcd 가상 동 추가
														,@TRAY_TYPE_CODE
														,@MODEL_ID
														,@LINE_ID
														,@USE_YN

				END;

			CLOSE CR_MODEL;
			DEALLOCATE CR_MODEL;


			-- 2021-02-19 kimcd 당일 변경 정보가 없는 경우 삭제 이력 형성 시작
			INSERT INTO [HIS_FCS_TRAY_MODEL_M]
				(  [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]         -- 2022-01-20 kimcd 동 추가
				  ,[PSEUDO_FACTORY_ID]  -- 2022-01-20 kimcd 가상 동 추가
				  ,[LINE_ID]
				  ,[TRAY_TYPE_CODE]
				  ,[ITEM_ID]
				  ,[USE_YN]
				  ,[INSERT_ID]
				  ,[INSERT_DATE]
				  ,[UPDATE_ID]
				  ,[UPDATE_DATE]
				  ,[JOB_USER_ID]
				  ,[JOB_TIME]
				  ,[JOB_TYPE])
			SELECT [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]         -- 2022-01-20 kimcd 동 추가
				  ,[PSEUDO_FACTORY_ID]  -- 2022-01-20 kimcd 가상 동 추가
				  ,[LINE_ID]
				  ,[TRAY_TYPE_CODE]
				  ,[ITEM_ID]
				  ,[USE_YN]
				  ,[INSERT_ID]
				  ,[INSERT_DATE]
				  ,[UPDATE_ID]
				  ,[UPDATE_DATE]
				  ,@v_proc_name
				  ,GETDATE()
				  ,'BATCH DELETE'
			 FROM [SCM_FCS_TRAY_MODEL_M]
			WHERE PLANT_ID IN  (SELECT ISNULL(L.PLANT_ID,AA.PLANT_ID) AS PLANT_ID 
								FROM (SELECT y.[PLANT_ID]
										   , ISNULL(SSLV.SEGMENT3, A.LINE_ID ) AS LINE_ID
									  FROM [SY_XIF_FCS_FP_TRAY_TYPE_R] A
										   JOIN scm_factory_m as y with(nolock)
										   on a.building = y.factory_id
											   LEFT OUTER JOIN (
																SELECT *
																  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
																 WHERE LOOKUP_TYPE_CODE = 'FORMATION_TRAY_DEGAS_LANE_MAPPING'
																   AND ACTIVE_FLAG = 'Y'
															   ) SSLV
															ON A.LINE_ID  = SSLV.SEGMENT2
														   AND A.BUILDING = SSLV.SEGMENT1
									  WHERE A.TRANSFER_FLAG = 'P'
									  UNION
									  SELECT y.[PLANT_ID]
										   , ISNULL(SSLV.SEGMENT3, A.LINE_ID ) AS LINE_ID
									  FROM [SY_XIF_FCS_TRAY_TYPE_DEGAS_EMPTY_R] A
										   JOIN scm_factory_m as y with(nolock)
										   on a.building = y.factory_id
											   LEFT OUTER JOIN (
																SELECT *
																  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
																 WHERE LOOKUP_TYPE_CODE = 'FORMATION_TRAY_DEGAS_LANE_MAPPING'
																   AND ACTIVE_FLAG = 'Y'
															   ) SSLV
															ON A.LINE_ID  = SSLV.SEGMENT2
														   AND A.BUILDING = SSLV.SEGMENT1
									  WHERE A.TRANSFER_FLAG = 'P'
									  ) AA
								   LEFT OUTER JOIN ( SELECT DISTINCT PLANT_ID, FACTORY_ID, LINE_ID
													   FROM SCM_LINE_M 
													  WHERE OPERATION_ID IN ( 'F5300','F5500','F5600','F6000')	 ) L
										ON AA.LINE_ID = L.LINE_ID
								 GROUP BY ISNULL(L.PLANT_ID,AA.PLANT_ID) )
			AND   INSERT_ID   = 'PR_XIF_FCS_TRAY_MODEL_INFO_R' -- 2021-11-22 kimcd 삭제 조건에 PR_XIF_FCS_TRAY_MODEL_INFO_R 이 만든 것만 삭제하도록 조건 추가
			AND   UPDATE_DATE < CONVERT(DATE, GETDATE())
			-- 2021-02-19 kimcd 당일 변경 정보가 없는 경우 삭제 이력 형성 끝

			-- 2020-08-12 kimcd 당일 변경 정보가 없는 경우 삭제 시작
			DELETE FROM [SCM_FCS_TRAY_MODEL_M]
			WHERE PLANT_ID IN  (SELECT ISNULL(L.PLANT_ID,AA.PLANT_ID) AS PLANT_ID 
								FROM (SELECT y.[PLANT_ID]
										   , ISNULL(SSLV.SEGMENT3, A.LINE_ID ) AS LINE_ID
									  FROM [SY_XIF_FCS_FP_TRAY_TYPE_R] A
										   JOIN scm_factory_m as y with(nolock)
										   on a.building = y.factory_id
											   LEFT OUTER JOIN (
																SELECT *
																  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
																 WHERE LOOKUP_TYPE_CODE = 'FORMATION_TRAY_DEGAS_LANE_MAPPING'
																   AND ACTIVE_FLAG = 'Y'
															   ) SSLV
															ON A.LINE_ID  = SSLV.SEGMENT2
														   AND A.BUILDING = SSLV.SEGMENT1
									  WHERE A.TRANSFER_FLAG = 'P'
									  UNION
									  SELECT y.[PLANT_ID]
										   , ISNULL(SSLV.SEGMENT3, A.LINE_ID ) AS LINE_ID
									  FROM [SY_XIF_FCS_TRAY_TYPE_DEGAS_EMPTY_R] A
										   JOIN scm_factory_m as y with(nolock)
										   on a.building = y.factory_id
											   LEFT OUTER JOIN (
																SELECT *
																  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
																 WHERE LOOKUP_TYPE_CODE = 'FORMATION_TRAY_DEGAS_LANE_MAPPING'
																   AND ACTIVE_FLAG = 'Y'
															   ) SSLV
															ON A.LINE_ID  = SSLV.SEGMENT2
														   AND A.BUILDING = SSLV.SEGMENT1
									  WHERE A.TRANSFER_FLAG = 'P'
									  ) AA
								   LEFT OUTER JOIN ( SELECT DISTINCT PLANT_ID, FACTORY_ID, LINE_ID
													   FROM SCM_LINE_M 
													  WHERE OPERATION_ID IN ( 'F5300','F5500','F5600','F6000')	 ) L
										ON AA.LINE_ID = L.LINE_ID
								 GROUP BY ISNULL(L.PLANT_ID,AA.PLANT_ID) )
			AND   INSERT_ID   = 'PR_XIF_FCS_TRAY_MODEL_INFO_R' -- 2021-11-22 kimcd 삭제 조건에 PR_XIF_FCS_TRAY_MODEL_INFO_R 이 만든 것만 삭제하도록 조건 추가
			AND   UPDATE_DATE < CONVERT(DATE, GETDATE())
			-- 2020-08-12 kimcd 당일 변경 정보가 없는 경우 삭제 끝

			UPDATE [SY_XIF_FCS_FP_TRAY_TYPE_R]
			   SET TRANSFER_FLAG = 'Y'
			 WHERE TRANSFER_FLAG = 'P'

 			 UPDATE [SY_XIF_FCS_TRAY_TYPE_DEGAS_EMPTY_R]
			   SET TRANSFER_FLAG = 'Y'
			 WHERE TRANSFER_FLAG = 'P'


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
