
CREATE PROCEDURE [dbo].[PR_XIF_MMD_YIELD_R]


-- ================================================================================================
-- Program ID          : FP02481 
-- Program Name        : PR_XIF_MMD_YIELD_R
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : MMD
-- Destination System  : FP SDB
-- Source Table        : FP_MMD_YIELD_M, SCM_MODEL_COMP_TEMP
-- Destination Table   : SCM_YIELD_M
--
-- Create(Update) Date : 2019.04.09
--						 2020.01.07

-- Author              : PIYONG
-- Version             : 1.0 최초 생성
--						 1.1 2019-04-09 PIYONG NJ 조립 수신 추가
--						 2.0 남경 파우치에 대해서 MMD목표수율이 없는 모델들에 대해서는 수율값 자동생성
--                       2.1 2020-01-02 KIMCD  튜닝
--                       2.2 2020-01-07 KIMCD  Begin Tran, Commit 제거. item type 조건 추가
--                       2.3 2020-01-08 KIMCD  속도 개선 및 기본 수율 입력하기 위해 재구성
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MMD_YIELD_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @COMPANY_ID     NVARCHAR(30)
    DECLARE @DIVISION_ID	NVARCHAR(30)
    DECLARE @SITE_ID		NVARCHAR(30)
	DECLARE @PLANT_ID		NVARCHAR(30)
	DECLARE @MODEL_ID		NVARCHAR(150)
	DECLARE @ITEM_ID		NVARCHAR(150)
	DECLARE @FLOW_ID		NVARCHAR(150)

	DECLARE @ROWCOUNT		INTEGER
	DECLARE @C_COMPANY_ID	NVARCHAR(30)
	DECLARE @C_DIVISION_ID	NVARCHAR(30)
	DECLARE @C_SITE_ID		NVARCHAR(30)
	DECLARE @C_PLANT_ID		NVARCHAR(30)
	DECLARE @C_FACTORY_ID	NVARCHAR(30)
	DECLARE @C_OPERATION_ID	NVARCHAR(30)
	DECLARE @C_LINE_ID		NVARCHAR(30)
	DECLARE @C_ITEM_ID		NVARCHAR(150)
	DECLARE @C_MONTH		NVARCHAR(6)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	DECLARE @ASSY_SPEED_COMPANY NVARCHAR(100)
	DECLARE @ASSY_SPEED_DIVISION NVARCHAR(100)
	DECLARE @ASSY_SPEED_SITE NVARCHAR(100)
	DECLARE @ASSY_SPEED_PLANT NVARCHAR(100)

	SELECT @ASSY_SPEED_COMPANY = (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_MMD_YIELD_R' AND SEGMENT1  = '4' AND ACTIVE_FLAG = 'Y')
	SELECT @ASSY_SPEED_DIVISION = (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_MMD_YIELD_R' AND SEGMENT1  = '2' AND ACTIVE_FLAG = 'Y')
	SELECT @ASSY_SPEED_SITE = (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_MMD_YIELD_R' AND SEGMENT1  = '3' AND ACTIVE_FLAG = 'Y')
	SELECT @ASSY_SPEED_PLANT = (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_MMD_YIELD_R' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')

	BEGIN TRY				

		-- BEGIN TRAN 2020-01-07 KIMCD  Begin Tran, Commit 제거
		-- ================================================
		-- 로직 추가
		-- ================================================
		---------------------------------------------------------------------------------------------------------------------------------------------
		-- 2020-01-08 kimcd 기본 수율 입력 G182만 적용
			INSERT INTO SCM_YIELD_M (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[OPERATION_ID]
					,[LINE_ID]
					,[ITEM_ID]
					,[MONTH]
					,[YIELD]
					,[INSERT_ID]
					,[INSERT_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME])
			SELECT    LA.[COMPANY_ID]
					, LA.[DIVISION_ID]
					, LA.[SITE_ID]
					, LA.[PLANT_ID]
					, LA.[FACTORY_ID]
					, LA.[OPERATION_ID]
					, LA.[LINE_ID]
					, LA.[ITEM_ID]
					, LA.[MONTH]
					, MAX(CONVERT(NUMERIC(20,10),LV.[ATTRIBUTE1]))
					,'PR_XIF_MMD_YIELD_R'
					,GETDATE()
					,'PR_XIF_MMD_YIELD_R'
					,GETDATE()
			FROM SCM_ITEM_LINE_ASSIGN_M LA
				,[dbo].[SCM_SYS_LOOKUP_VALUE] LV 
			WHERE LV.[SEGMENT1] = @ASSY_SPEED_COMPANY --'G180'   -- COMPANY_ID   -- 2020-01-08 KIMCD  CNJ 조립 한정 속도 위해 직접 코딩함
			AND LV.[SEGMENT2]   = @ASSY_SPEED_DIVISION --'40'     -- DIVISION_ID  -- 2020-01-08 KIMCD  CNJ 조립 한정 속도 위해 직접 코딩함
			AND LV.[SEGMENT3]   = @ASSY_SPEED_SITE --'A002'   -- SITE_ID      -- 2020-01-08 KIMCD  CNJ 조립 한정 속도 위해 직접 코딩함
			AND LV.[SEGMENT4]   = @ASSY_SPEED_PLANT --'G182'   -- PLANT_ID     -- 2020-01-08 KIMCD  CNJ 조립 한정 속도 위해 직접 코딩함

			AND LA.[MONTH]	   >= CONVERT(NVARCHAR(6),GETDATE(), 112)
	 		AND ISNULL(LA.ACTIVE_FLAG, 'N') = 'Y'
			AND NOT EXISTS (SELECT 1
							FROM SCM_YIELD_M Y
							WHERE Y.[COMPANY_ID]	= LA.[COMPANY_ID]
							AND Y.[DIVISION_ID]	= LA.[DIVISION_ID]
							AND Y.[SITE_ID]		= LA.[SITE_ID]
							AND Y.[PLANT_ID]		= LA.[PLANT_ID]
							AND Y.[FACTORY_ID]	= LA.[FACTORY_ID]
							AND Y.[OPERATION_ID]	= LA.[OPERATION_ID]
							AND Y.[LINE_ID]		= LA.[LINE_ID]
							AND Y.[ITEM_ID]		= LA.[ITEM_ID]
							AND Y.[MONTH]		= LA.[MONTH]
							)
			AND LV.[LOOKUP_TYPE_CODE] = 'MMD_BASE_YIELD'
			AND LV.[SEGMENT1] = LA.COMPANY_ID
			AND LV.[SEGMENT2] = LA.DIVISION_ID
			AND LV.[SEGMENT3] = LA.SITE_ID
			AND LV.[SEGMENT4] = LA.PLANT_ID
			AND LV.[SEGMENT5] = LA.OPERATION_ID
			AND LV.ACTIVE_FLAG = 'Y'
			GROUP BY  LA.[COMPANY_ID]
					, LA.[DIVISION_ID]
					, LA.[SITE_ID]
					, LA.[PLANT_ID]
					, LA.[FACTORY_ID]
					, LA.[OPERATION_ID]
					, LA.[LINE_ID]
					, LA.[ITEM_ID]
					, LA.[MONTH]

			DECLARE CUR_ITEM_INFO CURSOR FOR -- 2020-01-08 kimcd 대상 추출 커서와 하위 구성품 찾는 커서 합산
				WITH BASE AS (	SELECT    [COMPANY_ID]
										, [DIVISION_ID]
										, [SITE_ID]
										, [MODEL_ID]
										, [PLANT_ID]
									FROM (
										SELECT [COMPANY_ID]
												, [DIVISION_ID]
												, [SITE_ID]
												, [MODEL_ID]
												, [PLANT_ID]
											FROM [FP_MMD_YIELD_M] YM WITH(NOLOCK)
											INNER JOIN SCM_LINE_M LM
											ON YM.LINE_ID = LM.LINE_ID
											AND YM.OPERATION_ID = LM.OPERATION_ID
											WHERE PLANT_ID = @ASSY_SPEED_PLANT
											AND YM.UPDATE_TIME > DATEADD(HOUR,-1,GETDATE()) --1시간
										UNION
										SELECT [COMPANY_ID]
												, [DIVISION_ID]
												, [SITE_ID]
												, [MODEL_ID]
												, [PLANT_ID]
											FROM SCM_MODEL_COMP_TEMP
											WHERE PARENT_ITEM_ID = '*'
											AND PLANT_ID = @ASSY_SPEED_PLANT
											AND UPDATE_TIME > DATEADD(HOUR,-1,GETDATE()) --1시간
										) A
								WHERE EXISTS (
												SELECT 1
													FROM SCM_ITEM_M B
													WHERE B.COMPANY_ID = A.COMPANY_ID
													AND B.DIVISION_ID = A.DIVISION_ID
													AND B.SITE_ID = A.SITE_ID
													AND B.ITEM_ID = A.MODEL_ID
													AND ITEM_CLASS  IN ('EM010104')
												) )
				SELECT  B.[COMPANY_ID], B.[DIVISION_ID], B.[SITE_ID], B.[MODEL_ID], B.[PLANT_ID], I.ITEM_ID, I.FLOW_ID
					FROM [DBO].[SCM_ITEM_M]		I WITH(NOLOCK)
						,[DBO].[SCM_MODEL_COMP_EFFECTIVE_DATE]  C WITH(NOLOCK)
						,BASE   B
					WHERE C.[CHILD_COMPANY_ID]  = I.[COMPANY_ID]
					AND C.[CHILD_DIVISION_ID] = I.[DIVISION_ID]
					AND C.[CHILD_SITE_ID]     = I.[SITE_ID]
					AND C.[CHILD_ITEM_ID]     = I.[ITEM_ID]
					AND C.[COMPANY_ID]  = B.COMPANY_ID
					AND C.[DIVISION_ID] = B.DIVISION_ID
					AND C.[SITE_ID]     = B.SITE_ID
					AND C.[MODEL_ID]    = B.MODEL_ID
					AND C.[PLANT_ID]    = B.PLANT_ID    -- 2020-01-02 KIMCD  튜닝 PLANT 조건 추가
					AND C.[EFF_END_DATE] >= GETDATE()   -- 2020-01-02 KIMCD  튜닝 가용 BOM 조건 추가
					AND C.[PLANT_ID]    = C.[CHILD_PLANT_ID]
					AND C.[MODEL_ID]   != C.[CHILD_ITEM_ID]
					AND (I.[ITEM_TYPE] IS NULL OR I.[ITEM_TYPE]  IN ('H', 'P', ''))  -- 2019-01-07 kimcd 구매품(R), 상품(Q) 제외
				UNION
				SELECT B.[COMPANY_ID], B.[DIVISION_ID], B.[SITE_ID], B.[MODEL_ID], B.[PLANT_ID], I.ITEM_ID, I.FLOW_ID
					FROM [DBO].[SCM_ITEM_M]	I WITH(NOLOCK)
						,BASE   B
					WHERE I.[COMPANY_ID]  = B.COMPANY_ID
					AND I.[DIVISION_ID] = B.DIVISION_ID
					AND I.[SITE_ID]     = B.SITE_ID
					AND I.[ITEM_ID]     = B.MODEL_ID     -- ITEM_ID
					AND (I.[ITEM_TYPE] IS NULL OR I.[ITEM_TYPE]  IN ('H', 'P', ''))  -- 2019-01-07 kimcd 구매품(R), 상품(Q) 제외
				UNION -- 하위 BOM 전개하여 하위 구성품 찾는 로직
				SELECT B.[COMPANY_ID], B.[DIVISION_ID], B.[SITE_ID], B.[MODEL_ID], B.[PLANT_ID], I.ITEM_ID, I.FLOW_ID
					FROM [DBO].[SCM_ITEM_M]  I WITH(NOLOCK),
						[DBO].[SCM_BOM_M_V]  C WITH(NOLOCK),
						BASE   B
					WHERE C.[COMPANY_ID]  = I.[COMPANY_ID]
					AND C.[DIVISION_ID] = I.[DIVISION_ID]
					AND C.[SITE_ID]     = I.[SITE_ID]
					AND C.[CHILD_ITEM_ID] = I.[ITEM_ID]
					AND C.[COMPANY_ID]  = B.COMPANY_ID
					AND C.[DIVISION_ID] = B.DIVISION_ID
					AND C.[SITE_ID]     = B.SITE_ID
					AND C.[PLANT_ID]    = B.PLANT_ID
					AND C.[PARENT_ITEM_ID] = B.MODEL_ID     -- ITEM_ID
					AND C.[EFF_END_DATE] > GETDATE()
					AND (I.[ITEM_TYPE] IS NULL OR I.[ITEM_TYPE]  IN ('H', 'P', ''))  -- 2019-01-07 kimcd 구매품(R), 상품(Q) 제외


			OPEN CUR_ITEM_INFO
			FETCH NEXT FROM CUR_ITEM_INFO INTO   @COMPANY_ID
												,@DIVISION_ID
												,@SITE_ID
												,@MODEL_ID
												,@PLANT_ID  -- 2020-01-20 kimcd 커서 합산
												,@ITEM_ID
												,@FLOW_ID
			WHILE @@FETCH_STATUS = 0
				BEGIN

					MERGE INTO SCM_YIELD_M A
					USING (
							SELECT MAX(SLM.[COMPANY_ID])   AS COMPANY_ID
									, MAX(SLM.[DIVISION_ID]) AS DIVISION_ID
									, MAX(SLM.[SITE_ID]) AS SITE_ID
									, MAX(SLM.[PLANT_ID])  AS PLANT_ID
									, MAX(SLM.[FACTORY_ID]) AS FACTORY_ID
									, MYM.[OPERATION_ID]
									, SLM.[LINE_ID]
									, MYM.[ITEM_ID]
									, MYM.[MONTH]
									, MIN(MYM.[YIELD]) AS YIELD
								FROM SCM_LINE_M SLM
								INNER JOIN FP_MMD_YIELD_M MYM
								ON MYM.LINE_ID		= SLM.LINE_ID
								AND MYM.OPERATION_ID	= SLM.OPERATION_ID
								AND MYM.ITEM_ID		= @ITEM_ID
								AND MYM.MONTH		>= CONVERT(NVARCHAR(6),GETDATE(), 112)
								WHERE SLM.[COMPANY_ID]		= @COMPANY_ID
								AND SLM.[DIVISION_ID]	= @DIVISION_ID
								AND SLM.[SITE_ID]		= @SITE_ID
								AND SLM.[PLANT_ID]		= @PLANT_ID
								AND (
										(
											MYM.OPERATION_ID LIKE 'F%' AND ( MYM.OPERATION_ID <= 'F6000' 
																			OR MYM.OPERATION_ID LIKE '%'+ @FLOW_ID +'%') 	--활성화 이전 공정이거나  해당 공정
											)
										OR
										(
											MYM.OPERATION_ID LIKE 'A%' AND MYM.OPERATION_ID LIKE '%'+ @FLOW_ID +'%'			--노칭 이후 공정 이거나 해당 공정 
										)
											
									)
 								AND ISNULL(SLM.ACTIVE_FLAG, 'N') = 'Y'
								GROUP BY SLM.[LINE_ID]
									, MYM.[ITEM_ID]
									, MYM.[MONTH]
									, MYM.[OPERATION_ID]
									  
							) B
						ON (
							A.[COMPANY_ID]			= B.[COMPANY_ID]
							AND A.[DIVISION_ID]		= B.[DIVISION_ID]
							AND A.[SITE_ID]			= B.[SITE_ID]
							AND A.[PLANT_ID]		= B.[PLANT_ID]
							AND A.[FACTORY_ID]		= B.[FACTORY_ID]
							AND A.[OPERATION_ID]	= B.[OPERATION_ID]
							AND A.[LINE_ID]			= B.[LINE_ID]
							AND A.[ITEM_ID]			= B.[ITEM_ID]
							AND A.[MONTH]			= B.[MONTH]
							)
						WHEN MATCHED THEN
						UPDATE SET [YIELD]			= B.[YIELD]
									, [UPDATE_ID]	= 'PR_XIF_MMD_YIELD_R'
									, [UPDATE_TIME]	= GETDATE()
						WHEN NOT MATCHED THEN
						INSERT (
							[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]
							,[OPERATION_ID]
							,[LINE_ID]
							,[ITEM_ID]
							,[MONTH]
							,[YIELD]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
						) VALUES (
							B.[COMPANY_ID]
							,B.[DIVISION_ID]
							,B.[SITE_ID]
							,B.[PLANT_ID]
							,B.[FACTORY_ID]
							,B.[OPERATION_ID]
							,B.[LINE_ID]
							,B.[ITEM_ID]
							,B.[MONTH]
							,B.[YIELD]
							,'PR_XIF_MMD_YIELD_R'
							,GETDATE()
							,'PR_XIF_MMD_YIELD_R'
							,GETDATE()
						)
						;

					FETCH NEXT FROM CUR_ITEM_INFO INTO   @COMPANY_ID
														,@DIVISION_ID
														,@SITE_ID
														,@MODEL_ID
														,@PLANT_ID  -- 2020-01-20 kimcd 커서 합산
														,@ITEM_ID
														,@FLOW_ID
				END
			CLOSE CUR_ITEM_INFO;
			DEALLOCATE CUR_ITEM_INFO;   -- 메모리 해제

		-- COMMIT TRAN 2020-01-07 KIMCD  Begin Tran, Commit 제거

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



