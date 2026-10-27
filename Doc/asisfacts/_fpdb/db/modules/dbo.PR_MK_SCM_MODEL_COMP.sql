
--CREATE PROCEDURE [dbo].[PR_MK_SCM_MODEL_COMP]
CREATE PROCEDURE [dbo].[PR_MK_SCM_MODEL_COMP]
-- ================================================================================================
-- Program ID          : FP02010 Model 정보 형성
--
-- Program Name        : PR_MK_SCM_MODEL_COMP
-- Param               :
-- Batch Period        : 12 시간
-- Description         : Operation Flow, BOM 변경 정보를 기반으로 BOM 전개하여 Model별 임시 정보 형성
--
-- Source Table        : SCM_BOM_M, SCM_ITEM_M, SCM_OPERATION_FLOW_M
-- Temp Table          : SCM_MODEL_MODEL_TEMP, SCM_MODEL_COMP_TEMP 
-- Destination Table   : SCM_MODEL_COMP
--
-- Create(Update) Date : 2020.07.22
-- Author              : kim choon dong
-- Version             : 2
--                       kim choon dong 2017-01-31
--                       BOM 전개에 우선 순위 부여.
--                       동일 Plant, 전극 Plant, 동일 Division의 오창 순으로 전개
--                       3.0 
--                       kim choon dong 2017-05-15
--                       BOM Key Date 기준으로 변경된 정보만 추가 형성.
--                       3.1
--                       kimcd 2018-02-06
--                       leaf_level표시하는 조회문 튜닝
--                       2019-11-25 kimcd CONVERT(NUMERIC(20,10),BM.[CHILD_QTY]/BM.[PARENT_QTY]) 소요량 계산에서 0 나와 수정
--                       2020-05-22 kimcd CONCAT_ALT_PRIORITY 컬럼 추가 형성. 대치품목 소요량 구분용
--                       2020-07-22 kimcd BOM 전개 기준으로 Item type P 복원
-- ================================================================================================
	@P_ALL_CREATE   NVARCHAR(50) = NULL,
	@P_DIVISION_ID  NVARCHAR(50) = NULL,
    @P_SITE_ID      NVARCHAR(50) = NULL
AS
	DECLARE C_SITE  CURSOR FOR
        SELECT DISTINCT
			   SS.[COMPANY_ID]
			 , SD.[DIVISION_ID]
			 , SS.[SITE_ID]
        FROM   [DBO].[SCM_SITE_M]     SS WITH(NOLOCK)
			 , [DBO].[SCM_DIVISION_M] SD WITH(NOLOCK)
        WHERE  SS.[COMPANY_ID] = SD.[COMPANY_ID]
		AND    ( @P_DIVISION_ID IS NULL OR SD.[DIVISION_ID] = @P_DIVISION_ID )
		AND    ( @P_SITE_ID IS NULL OR SS.[SITE_ID] = @P_SITE_ID )
		ORDER BY SD.[DIVISION_ID], SS.[SITE_ID];

	DECLARE @COMPANY_ID               NVARCHAR(30)
	DECLARE @DIVISION_ID              NVARCHAR(30)
	DECLARE @SITE_ID                  NVARCHAR(30)
	DECLARE @LOOP_FLAG                NVARCHAR(10)
	DECLARE @LOOP_COUNT               INT

	DECLARE @PLANT_ID				  NVARCHAR(100)
	DECLARE @MODEL_ID				  NVARCHAR(150)
	DECLARE @CHILD_ITEM_ID			  NVARCHAR(150)
	DECLARE @CHILD_QTY				  NUMERIC(20,10)
	DECLARE @CHILD_UOM				  NVARCHAR(150)
	DECLARE @CONCATENATE_ITEM		  NVARCHAR(2000)
	DECLARE @OPERATION_ID			  NVARCHAR(30)
	DECLARE @OPERATION_SEQ			  NUMERIC(20,10)
	DECLARE @LEAF_LEVEL				  NVARCHAR(1)
	DECLARE @NLEVEL                   NUMERIC(20,10)

	DECLARE @HOLD_PLANT_ID            NVARCHAR(100)
	DECLARE @HOLD_MODEL_ID            NVARCHAR(150)
	DECLARE @L_LINE_NUM               INT
	DECLARE @HOLD_LEAF_LEVEL          NVARCHAR(10)
	DECLARE @HOLD_CHILD_ITEM          NVARCHAR(150)
	DECLARE @INSERT_CNT				  NUMERIC(20,10)

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

    -- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_MK_SCM_MODEL_COMP'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @data_s      INTEGER
	DECLARE @site_s      INTEGER

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

    BEGIN TRY
    BEGIN TRANSACTION;
	        
        SET @v_temp1 = 'STEP OPEN CURSOR C_SITE'
    	OPEN C_SITE
        FETCH NEXT FROM C_SITE INTO @COMPANY_ID,
									@DIVISION_ID,
									@SITE_ID
    
        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN
			SET @v_temp1 = 'STEP CLEAR SCM_MODEL_MODEL_TEMP'
			DELETE FROM [dbo].[SCM_MODEL_MODEL_TEMP]
			WHERE  COMPANY_ID  = @COMPANY_ID
			AND	   DIVISION_ID = @DIVISION_ID
			AND	   SITE_ID     = @SITE_ID;

			IF @P_ALL_CREATE  = 'Y'
				BEGIN
					SET @v_temp1 = 'STEP CLEAR SCM_MODEL_COMP_TEMP AT ALL'
					DELETE FROM [dbo].[SCM_MODEL_COMP_TEMP]
					WHERE  COMPANY_ID  = @COMPANY_ID
					AND	   DIVISION_ID = @DIVISION_ID
					AND	   SITE_ID     = @SITE_ID; -- 2017-05-15 kimcd add at  @P_ALL_CREATE  = 'Y'

					SET @v_temp1 = 'STEP INSERT SCM_MODEL_MODEL_TEMP ALL CREATE'
					INSERT INTO [dbo].[SCM_MODEL_MODEL_TEMP]
						([COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[MODEL_ID]
						,[INSERT_ID]
						,[INSERT_TIME]
						,[UPDATE_ID]
						,[UPDATE_TIME])
					SELECT DISTINCT 
						   SMM.[COMPANY_ID]
						 , SMM.[DIVISION_ID]
						 , SMM.[SITE_ID]
						 , SMM.[PLANT_ID]
						 , SMM.[PARENT_ITEM_ID]
						 , @v_proc_name
						 , GETDATE()
						 , @v_proc_name
						 , GETDATE()
					FROM   [dbo].[SCM_ITEM_M]        SIM WITH(NOLOCK)
					     , [dbo].[SCM_ITEM_CLASS_M]  ICM WITH(NOLOCK)
						 , [dbo].[SCM_BOM_M]         SMM WITH(NOLOCK)
					WHERE  SMM.[COMPANY_ID]    = SIM.[COMPANY_ID]
					AND    SMM.[DIVISION_ID]   = SIM.[DIVISION_ID]
					AND    SMM.[SITE_ID]       = SIM.[SITE_ID]
					AND    SMM.[PARENT_ITEM_ID] = SIM.[ITEM_ID]
					AND    ICM.[CLASS_ID]      = SIM.[ITEM_CLASS]
					AND    ( ICM.[LEVEL_1_NAME]  = 'Model' -- 모델 구분자 추가 2017-01-31 KIMCD
							 OR  SIM.[ITEM_TYPE] = 'P' )   -- 2022-07-22 kimcd BOM 전개 대상 조건 item type 복원 -- 모델 구분자 BLOCK 2017-01-31 KIMCD
					AND    SMM.[COMPANY_ID]    = @COMPANY_ID
					AND    SMM.[DIVISION_ID]   = @DIVISION_ID
					AND    SMM.[SITE_ID]       = @SITE_ID;
				END;
			ELSE
				BEGIN
					SET @v_temp1 = 'STEP INSERT SCM_MODEL_MODEL_TEMP'
					INSERT INTO [DBO].[SCM_MODEL_MODEL_TEMP]
						([COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[MODEL_ID]
						,[INSERT_ID]
						,[INSERT_TIME]
						,[UPDATE_ID]
						,[UPDATE_TIME])
					SELECT A.[COMPANY_ID]
						 , A.[DIVISION_ID]
						 , A.[SITE_ID]
						 , A.[PLANT_ID]
						 , A.[MODEL_ID]
						 , @v_proc_name
						 , GETDATE()
						 , @v_proc_name
						 , GETDATE()
					FROM  ( SELECT SMC.[COMPANY_ID]
								 , SMC.[DIVISION_ID]
								 , SMC.[SITE_ID]
								 , SMC.[PLANT_ID]
								 , SMC.[MODEL_ID]
							FROM   [dbo].[SCM_MODEL_COMP_TEMP] SMC WITH(NOLOCK)  -- -- 2017-05-15 kimcd modify
							WHERE  SMC.[COMPANY_ID]    = @COMPANY_ID
							AND    SMC.[DIVISION_ID]   = @DIVISION_ID
							AND    SMC.[SITE_ID]       = @SITE_ID
							AND    SMC.[CHILD_ITEM_ID] IN (/*SELECT  SIM.[ITEM_ID]
														   FROM    [dbo].[SCM_ITEM_M] SIM WITH(NOLOCK)
														   WHERE   SIM.[COMPANY_ID]  = @COMPANY_ID
														   AND     SIM.[DIVISION_ID] = @DIVISION_ID
														   AND     SIM.[SITE_ID]     = @SITE_ID
														   AND     SIM.[FLOW_ID] IS NOT NULL
														   AND     SIM.[UPDATE_TIME] > GETDATE() - 1.5
														   UNION 2017-05-15 kimcd block */
														   SELECT  SBM.[PARENT_ITEM_ID]
														   FROM    [dbo].[SCM_BOM_M] SBM WITH(NOLOCK)
														   WHERE   --SBM.[COMPANY_ID]   = @COMPANY_ID  2017-05-15 kimcd block
														   --AND     SBM.[DIVISION_ID]  = @DIVISION_ID  2017-05-15 kimcd block
														   --AND     SBM.[SITE_ID]      = @SITE_ID  2017-05-15 kimcd block
														   --AND     
														   SBM.[KEY_DATE]     >= CONVERT(NVARCHAR(8), GETDATE()-1,112)  -- 2017-05-15 kimcd add 
														   --AND     SBM.[EFF_END_DATE] > GETDATE() - 1.5 2017-05-15 kimcd block
														   --AND     SBM.[UPDATE_TIME]  > GETDATE() - 1.5 2017-05-15 kimcd block
														   ) 
							UNION
							SELECT SMM.[COMPANY_ID]
								 , SMM.[DIVISION_ID]
								 , SMM.[SITE_ID]
								 , SMM.[PLANT_ID]
								 , SMM.[PARENT_ITEM_ID]
							FROM   [dbo].[SCM_ITEM_M]  SIM WITH(NOLOCK)
								 , [dbo].[SCM_ITEM_CLASS_M]  ICM WITH(NOLOCK)
								 , [dbo].[SCM_BOM_M]   SMM WITH(NOLOCK)
							WHERE  SMM.[COMPANY_ID]    = SIM.[COMPANY_ID]
							AND    SMM.[DIVISION_ID]   = SIM.[DIVISION_ID]
							AND    SMM.[SITE_ID]       = SIM.[SITE_ID]
							AND    SMM.[PARENT_ITEM_ID] = SIM.[ITEM_ID]
							AND    ICM.[CLASS_ID]      = SIM.[ITEM_CLASS]
							AND    ( ICM.[LEVEL_1_NAME]  = 'Model' -- 모델 구분자 추가 2017-01-31 KIMCD
							         OR  SIM.[ITEM_TYPE] = 'P' )   -- 2022-07-22 kimcd BOM 전개 대상 조건 item type 복원 -- 모델 구분자 BLOCK 2017-01-31 KIMCD
							AND    SMM.[COMPANY_ID]    = @COMPANY_ID
							AND    SMM.[DIVISION_ID]   = @DIVISION_ID
							AND    SMM.[SITE_ID]       = @SITE_ID
							AND    SMM.[KEY_DATE]     >= CONVERT(NVARCHAR(8), GETDATE()-1,112)  -- 2017-05-15 kimcd add
							-- AND    SMM.[INSERT_TIME]   > GETDATE() - 1.5  2017-05-15 kimcd block
							) A
							;

					--  2017-05-15 kimcd add start for new bom
					SET @v_temp1 = 'STEP CLEAR SCM_MODEL_COMP_TEMP AT NEW'
					DELETE MCT
					FROM   [dbo].[SCM_MODEL_COMP_TEMP] MCT WITH(NOLOCK)
					WHERE  COMPANY_ID  = @COMPANY_ID
					AND	   DIVISION_ID = @DIVISION_ID
					AND	   SITE_ID     = @SITE_ID
					AND    EXISTS ( SELECT 1 
									FROM   [DBO].[SCM_MODEL_MODEL_TEMP] MMT WITH(NOLOCK)
									WHERE  MMT.[COMPANY_ID]  = MCT.[COMPANY_ID]
									AND	   MMT.[DIVISION_ID] = MCT.[DIVISION_ID]
									AND	   MMT.[SITE_ID]     = MCT.[SITE_ID]
									AND	   MMT.[PLANT_ID]    = MCT.[PLANT_ID]
									AND	   MMT.[MODEL_ID]    = MCT.[MODEL_ID])
					--  2017-05-15 kimcd add end for new bom
				END;  -- @P_ALL_CREATE  = 'Y' ELSE

			SET @v_temp1 = 'STEP insert first item - cell model'
			INSERT INTO [dbo].[SCM_MODEL_COMP_TEMP]
				( [COMPANY_ID]
				, [DIVISION_ID]
				, [SITE_ID]
				, [PLANT_ID]
				, [MODEL_ID]
				, [PARENT_ITEM_ID]
				, [CHILD_ITEM_ID]
				, [CHILD_QTY]
				, [ACCUMULATED_CHILD_QTY] -- 누적 소요량 추가 2017-01-31 KIMCD
				, [CHILD_UOM]
				, [CONCATENATE_ITEM]
				, [SORT_ORDER]
				, [NLEVEL]
				, [CHILD_COMPANY_ID]      -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
				, [CHILD_DIVISION_ID]     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
				, [CHILD_SITE_ID]         -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
				, [CHILD_PLANT_ID]        -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
				, [ALT_PRIORITY]          -- BOM Priority 추가 2017-01-31 KIMCD
				, [CONCAT_ALT_PRIORITY]   -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
				, [INSERT_ID]
				, [INSERT_TIME]
				, [UPDATE_ID]
				, [UPDATE_TIME])
			SELECT @COMPANY_ID
				 , @DIVISION_ID
				 , @SITE_ID
				 , BM.[PLANT_ID]
				 , MMT.[MODEL_ID]
				 , '*'                    -- [PARENT_ITEM_ID]
				 , BM.[PARENT_ITEM_ID]    -- [CHILD_ITEM_ID]
				 , 1                      -- [CHILD_QTY]
				 , 1                      -- [ACCUMULATED_CHILD_QTY] 누적 소요량 추가 2017-01-31 KIMCD
				 , MAX(IM.ITEM_UOM)       -- [CHILD_UOM]
				 , BM.[PARENT_ITEM_ID]    -- [CONCATENATE_ITEM]
				 , '0000'                 -- [SORT_ORDER]
				 , 0                      -- [NLEVEL]
				 , @COMPANY_ID            -- [CHILD_COMPANY_ID]  CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
				 , @DIVISION_ID           -- [CHILD_DIVISION_ID] CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
				 , @SITE_ID               -- [CHILD_SITE_ID]     CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
				 , BM.[PLANT_ID]          -- [CHILD_PLANT_ID]    CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
				 , 'Y'                    -- [ALT_PRIORITY]      BOM Priority 추가 2017-01-31 KIMCD
				 , '00'                   -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용 [CONCAT_ALT_PRIORITY]
				 , @v_proc_name			  -- [INSERT_ID]
				 , GETDATE()			  -- [INSERT_TIME]
				 , @v_proc_name			  -- [UPDATE_ID]
				 , GETDATE()			  -- [UPDATE_TIME]
			FROM   [DBO].[SCM_BOM_M]  BM WITH(NOLOCK)
				 , [DBO].[SCM_ITEM_M] IM WITH(NOLOCK)
				 , [dbo].[SCM_MODEL_MODEL_TEMP]  MMT WITH(NOLOCK)
			WHERE  BM.[COMPANY_ID]     = IM.[COMPANY_ID]
			AND    BM.[DIVISION_ID]    = IM.[DIVISION_ID]
			AND    BM.[SITE_ID]        = IM.[SITE_ID]
			AND    BM.[PARENT_ITEM_ID] = IM.[ITEM_ID]
			AND    BM.[COMPANY_ID]     = MMT.[COMPANY_ID]
			AND    BM.[DIVISION_ID]    = MMT.[DIVISION_ID]
			AND    BM.[SITE_ID]        = MMT.[SITE_ID]
			AND    BM.[PLANT_ID]       = MMT.[PLANT_ID]
			AND    BM.[PARENT_ITEM_ID] = MMT.[MODEL_ID]
			AND    MMT.[COMPANY_ID]    = @COMPANY_ID
			AND    MMT.[DIVISION_ID]   = @DIVISION_ID
			AND    MMT.[SITE_ID]       = @SITE_ID
			GROUP BY BM.[COMPANY_ID]
				   , BM.[DIVISION_ID]
				   , BM.[SITE_ID]
				   , BM.[PLANT_ID]
				   , MMT.[MODEL_ID]
				   , BM.[PARENT_ITEM_ID]

 			SET @v_temp1 = 'STEP INSERT LOOP'
			SET @LOOP_FLAG = 'Y'
			SET @LOOP_COUNT = 0

			WHILE @LOOP_FLAG = 'Y' -- BOM 전개 수행
			BEGIN
				SET @INSERT_CNT = 0; -- LOOP_COUNT별 입력 RECORD 개수 초기화 2017-01-31 KIMCD

                SET @v_temp1 = 'STEP INSERT SAME PLANT'
				INSERT INTO [DBO].[SCM_MODEL_COMP_TEMP]
					( [COMPANY_ID]
					, [DIVISION_ID]
					, [SITE_ID]
					, [PLANT_ID]
					, [MODEL_ID]
					, [PARENT_ITEM_ID]
					, [CHILD_ITEM_ID]
					, [CHILD_QTY]
					, [ACCUMULATED_CHILD_QTY] -- 누적 소요량 추가 2017-01-31 KIMCD
					, [CHILD_UOM]
					, [CONCATENATE_ITEM]
					, [SORT_ORDER]
					, [NLEVEL]
					, [CHILD_COMPANY_ID]      -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [CHILD_DIVISION_ID]     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [CHILD_SITE_ID]         -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [CHILD_PLANT_ID]        -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [ALT_ID]                -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
					, [ALT_PRIORITY]          -- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
					, [ALT_RATE]              -- 대체 BOM 비율 추가 2017-01-31 KIMCD
					, [CONCAT_ALT_PRIORITY]   -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					, [INSERT_ID]
					, [INSERT_TIME]
					, [UPDATE_ID]
					, [UPDATE_TIME])
				SELECT BS.[COMPANY_ID]
					 , BS.[DIVISION_ID]
					 , BS.[SITE_ID]
					 , BS.[PLANT_ID]
					 , BS.[MODEL_ID]
					 , BS.[PARENT_ITEM_ID]
					 , BS.[CHILD_ITEM_ID]
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_QTY] END)  AS CHILD_QTY
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ACCUMULATED_CHILD_QTY] END)  AS ACCUMULATED_CHILD_QTY   -- 누적 소요량 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ITEM_UOM] END)   AS ITEM_UOM
					 , BS.[CONCATENATE_ITEM]+'^'+BS.[CHILD_ITEM_ID]
					 , MAX(BS.[SORT_ORDER] + REPLICATE('0', 4 - LEN(BS.[RANK_ORDER])) + CAST( BS.[RANK_ORDER] AS NVARCHAR)) AS SORT_ORDER   -- [SORT_ORDER]
					 , MAX(BS.[NLEVEL])     AS NLEVEL
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_COMPANY_ID] END)   AS  CHILD_COMPANY_ID  -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_DIVISION_ID] END)  AS  CHILD_DIVISION_ID -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_SITE_ID] END)      AS  CHILD_SITE_ID     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_PLANT_ID] END)     AS  CHILD_PLANT_ID    -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_ID] END)             AS  ALT_ID            -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_PRIORITY] END)       AS  ALT_PRIORITY      -- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_RATE] END)           AS  ALT_RATE          -- 대체 BOM 비율 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CONCAT_ALT_PRIORITY] END) AS [CONCAT_ALT_PRIORITY] -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					 , @v_proc_name			  -- [INSERT_ID]
					 , GETDATE()			  -- [INSERT_TIME]
					 , @v_proc_name			  -- [UPDATE_ID]
					 , GETDATE()			  -- [UPDATE_TIME]
				FROM  ( SELECT INBS.[COMPANY_ID]
								, INBS.[DIVISION_ID]
								, INBS.[SITE_ID]
								, INBS.[PLANT_ID]
								, INBS.[MODEL_ID]
								, INBS.[PARENT_ITEM_ID]
								, INBS.[CHILD_ITEM_ID]
								, INBS.[CHILD_QTY]
								, INBS.[ACCUMULATED_CHILD_QTY] -- 누적 소요량 추가 2017-01-31 KIMCD
								, INBS.[ITEM_UOM]
								, INBS.[CONCATENATE_ITEM]
								, INBS.[NLEVEL]
								, INBS.[CHILD_COMPANY_ID]  -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[CHILD_DIVISION_ID] -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[CHILD_SITE_ID]     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[CHILD_PLANT_ID]    -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[ALT_ID]            -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
								, CASE WHEN INBS.[ALT_PRIORITY] = 1 THEN
											'Y'
								  END                      AS ALT_PRIORITY     -- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
								, INBS.[ALT_RATE]          -- 대체 BOM 비율 추가 2017-01-31 KIMCD
								, INBS.[SORT_ORDER]
								, RANK() OVER ( PARTITION BY INBS.[COMPANY_ID]
														, INBS.[DIVISION_ID]
														, INBS.[SITE_ID]
														, INBS.[PLANT_ID]
														, INBS.[MODEL_ID]
														, INBS.[PARENT_ITEM_ID]
												ORDER BY INBS.[COMPANY_ID]
													, INBS.[DIVISION_ID]
													, INBS.[SITE_ID]
													, INBS.[PLANT_ID]
													, INBS.[MODEL_ID]
													, INBS.[PARENT_ITEM_ID]
													, INBS.[CHILD_ITEM_ID] )  AS RANK_ORDER
								, ROW_NUMBER() OVER ( PARTITION BY INBS.[COMPANY_ID]
														, INBS.[DIVISION_ID]
														, INBS.[SITE_ID]
														, INBS.[PLANT_ID]
														, INBS.[MODEL_ID]
														, INBS.[PARENT_ITEM_ID]
														, INBS.[CHILD_ITEM_ID]
														, INBS.[CONCATENATE_ITEM]
												ORDER BY CASE WHEN INBS.[MMT_PLANT_ID] = INBS.[CHILD_PLANT_ID] THEN 1 ELSE 2 END
												    , CASE WHEN INBS.[MMT_SITE_ID] = INBS.[CHILD_SITE_ID] AND INBS.[MMT_DIVISION_ID] = INBS.[CHILD_DIVISION_ID] THEN 1 ELSE 2 END
												    , CASE WHEN INBS.[MMT_DIVISION_ID] = INBS.[CHILD_DIVISION_ID] THEN 1 ELSE 2 END
												    , INBS.[COMPANY_ID]
													, INBS.[DIVISION_ID]
													, INBS.[SITE_ID]
													, INBS.[PLANT_ID]
													, INBS.[MODEL_ID]
													, INBS.[PARENT_ITEM_ID]
													, INBS.[CHILD_ITEM_ID]
													, INBS.[CHILD_COMPANY_ID]
													, INBS.[CHILD_DIVISION_ID]
													, INBS.[CHILD_SITE_ID]
													, INBS.[CHILD_PLANT_ID] )  AS CHILD_ORDER -- CHILD ITEM 조직 정보 넣기 위해 추가
								, INBS.[CONCAT_ALT_PRIORITY] -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
						FROM  ( SELECT MMT.[COMPANY_ID]
										, MMT.[DIVISION_ID]
										, MMT.[SITE_ID]
										, MMT.[PLANT_ID]
										, MMT.[MODEL_ID]
										, BM.[PARENT_ITEM_ID]
										, BM.[CHILD_ITEM_ID]
										, BM.[CHILD_QTY]/BM.[PARENT_QTY] AS CHILD_QTY
										, MMT.[ACCUMULATED_CHILD_QTY] * CONVERT(NUMERIC(20,10),BM.[CHILD_QTY]/BM.[PARENT_QTY]) AS ACCUMULATED_CHILD_QTY -- 2019-11-25 kimcd 소요량 계산에서 0 나와 수정 CONVERT(NUMERIC(20,10),BM.[CHILD_QTY]/BM.[PARENT_QTY]) -- 누적 소요량 추가 2017-01-31 KIMCD
										, IM.[ITEM_UOM]
										, MMT.[CONCATENATE_ITEM]
										, @LOOP_COUNT+1			  AS NLEVEL
										, MMT.[CHILD_DIVISION_ID] AS MMT_DIVISION_ID    -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, MMT.[CHILD_SITE_ID]     AS MMT_SITE_ID        -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, MMT.[CHILD_PLANT_ID]    AS MMT_PLANT_ID       -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[COMPANY_ID]         AS CHILD_COMPANY_ID   -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[DIVISION_ID]        AS CHILD_DIVISION_ID  -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[SITE_ID]            AS CHILD_SITE_ID      -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[PLANT_ID]           AS CHILD_PLANT_ID     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, CASE WHEN MMT.[ALT_ID] IS NOT NULL AND  BM.[ALT_ID] IS NOT NULL THEN
											       MMT.[ALT_ID] + BM.[ALT_ID]
											   WHEN MMT.[ALT_ID] IS NOT NULL THEN
												   MMT.[ALT_ID]
											   WHEN BM.[ALT_ID] IS NOT NULL THEN
												   BM.[ALT_ID]
										  END                   AS ALT_ID             -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
										, CASE WHEN MMT.[ALT_PRIORITY] = 'Y' THEN
												   CASE WHEN BM.[ALT_ID] IS NULL THEN
													   1
												   ELSE
													   RANK() OVER (PARTITION BY BM.[COMPANY_ID]
																				,BM.[DIVISION_ID]
																				,BM.[SITE_ID]
																				,BM.[PLANT_ID]
																				,BM.[BOM_VERSION_ID]
																				,BM.[PARENT_ITEM_ID]
																				,BM.[KEY_DATE]
																				,BM.[ALT_ID]
																	ORDER BY BM.[COMPANY_ID]
																			,BM.[DIVISION_ID]
																			,BM.[SITE_ID]
																			,BM.[PLANT_ID]
																			,BM.[BOM_VERSION_ID]
																			,BM.[PARENT_ITEM_ID]
																			,BM.[KEY_DATE]
																			,BM.[ALT_ID]
																			,BM.[ALT_PRIORITY])
												   END
										  END                   AS ALT_PRIORITY
										, CASE WHEN MMT.[ALT_RATE] IS NOT NULL AND BM.[ALT_RATE] IS NOT NULL THEN
												   MMT.[ALT_RATE] * BM.[ALT_RATE]
											   WHEN MMT.[ALT_RATE] IS NOT NULL THEN
												   MMT.[ALT_RATE]
											   WHEN BM.[ALT_RATE] IS NOT NULL THEN
												   BM.[ALT_RATE]
										  END                   AS ALT_RATE           -- 대체 BOM 비율 추가 2017-01-31 KIMCD
										, MMT.[SORT_ORDER]
										, MMT.[CONCAT_ALT_PRIORITY] + ISNULL(REPLICATE('0', 2 - LEN(CONVERT(NVARCHAR(20), CONVERT(INT,BM.[ALT_PRIORITY])))),'') + ISNULL(CONVERT(NVARCHAR(20), CONVERT(INT,BM.[ALT_PRIORITY])),'00') AS  CONCAT_ALT_PRIORITY -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용 [CONCAT_ALT_PRIORITY]
								FROM   [DBO].[SCM_BOM_M]  BM WITH(NOLOCK)
										, [DBO].[SCM_ITEM_M] IM WITH(NOLOCK)
										, [dbo].[SCM_MODEL_COMP_TEMP]  MMT WITH(NOLOCK)
										, [DBO].[SCM_MODEL_MODEL_TEMP] XMT WITH(NOLOCK) -- 2017-05-15 kimcd add 현재 형성 대상만 
								WHERE  BM.[COMPANY_ID]     = IM.[COMPANY_ID]
								AND    BM.[DIVISION_ID]    = IM.[DIVISION_ID]
								AND    BM.[SITE_ID]        = IM.[SITE_ID]
								AND    BM.[CHILD_ITEM_ID]  = IM.[ITEM_ID]
								AND    BM.[COMPANY_ID]     = MMT.[CHILD_COMPANY_ID]
								AND    BM.[DIVISION_ID]    = MMT.[CHILD_DIVISION_ID]
								AND    BM.[SITE_ID]        = MMT.[CHILD_SITE_ID]
								AND    BM.[PLANT_ID]       = MMT.[CHILD_PLANT_ID]  -- 동일 Plant 우선 전개
								AND    BM.[PARENT_ITEM_ID] = MMT.[CHILD_ITEM_ID]
								AND    BM.[PARENT_ITEM_ID] != BM.[CHILD_ITEM_ID]
								AND    BM.[BOM_VERSION_ID] = 1
								AND    MMT.[COMPANY_ID]    = @COMPANY_ID
								AND    MMT.[DIVISION_ID]   = @DIVISION_ID
								AND    MMT.[SITE_ID]       = @SITE_ID
								AND    MMT.[NLEVEL]        = @LOOP_COUNT
								-- 2017-05-15 kimcd add start 현재 형성 대상만
								AND    XMT.[COMPANY_ID]  = MMT.[COMPANY_ID]
								AND	   XMT.[DIVISION_ID] = MMT.[DIVISION_ID]
								AND	   XMT.[SITE_ID]     = MMT.[SITE_ID]
								AND	   XMT.[PLANT_ID]    = MMT.[PLANT_ID]
								AND	   XMT.[MODEL_ID]    = MMT.[MODEL_ID]
								AND    XMT.[COMPANY_ID]  = @COMPANY_ID
								AND    XMT.[DIVISION_ID] = @DIVISION_ID
								AND    XMT.[SITE_ID]     = @SITE_ID
								-- 2017-05-15 kimcd add end 현재 형성 대상만
								AND    BM.EFF_START_DATE  <= CAST(GETDATE() AS DATE)
								AND    BM.EFF_END_DATE     > CAST(GETDATE() AS DATE)
								-- AND    IM.ITEM_TYPE       IN ('H', 'P') 
								) INBS
						) BS
				GROUP  BY BS.[COMPANY_ID]
						, BS.[DIVISION_ID]
						, BS.[SITE_ID]
						, BS.[PLANT_ID]
						, BS.[MODEL_ID]
						, BS.[PARENT_ITEM_ID]
						, BS.[CHILD_ITEM_ID]
						, BS.[CONCATENATE_ITEM]
				;

				SET @INSERT_CNT = @INSERT_CNT + @@ROWCOUNT; -- 입력 개수 취합 - 동일 Plant

				/*2017-01-31 KIMCD 추가 시작. 동일 Plant 우선, 동일 Site의 전극 Plant 전개. 다른 Site 동일 Division 전개*/
                SET @v_temp1 = 'STEP INSERT ELECTRODE PLANT'
				INSERT INTO [DBO].[SCM_MODEL_COMP_TEMP]
					( [COMPANY_ID]
					, [DIVISION_ID]
					, [SITE_ID]
					, [PLANT_ID]
					, [MODEL_ID]
					, [PARENT_ITEM_ID]
					, [CHILD_ITEM_ID]
					, [CHILD_QTY]
					, [ACCUMULATED_CHILD_QTY] -- 누적 소요량 추가 2017-01-31 KIMCD
					, [CHILD_UOM]
					, [CONCATENATE_ITEM]
					, [SORT_ORDER]
					, [NLEVEL]
					, [CHILD_COMPANY_ID]      -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [CHILD_DIVISION_ID]     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [CHILD_SITE_ID]         -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [CHILD_PLANT_ID]        -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [ALT_ID]                -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
					, [ALT_PRIORITY]          -- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
					, [ALT_RATE]              -- 대체 BOM 비율 추가 2017-01-31 KIMCD
					, [CONCAT_ALT_PRIORITY]   -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					, [INSERT_ID]
					, [INSERT_TIME]
					, [UPDATE_ID]
					, [UPDATE_TIME])
				SELECT BS.[COMPANY_ID]
					 , BS.[DIVISION_ID]
					 , BS.[SITE_ID]
					 , BS.[PLANT_ID]
					 , BS.[MODEL_ID]
					 , BS.[PARENT_ITEM_ID]
					 , BS.[CHILD_ITEM_ID]
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_QTY] END)  AS CHILD_QTY
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ACCUMULATED_CHILD_QTY] END)  AS ACCUMULATED_CHILD_QTY   -- 누적 소요량 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ITEM_UOM] END)   AS ITEM_UOM
					 , BS.[CONCATENATE_ITEM]+'^'+BS.[CHILD_ITEM_ID]
					 , MAX(BS.[SORT_ORDER] + REPLICATE('0', 4 - LEN(BS.[RANK_ORDER])) + CAST( BS.[RANK_ORDER] AS NVARCHAR)) AS SORT_ORDER   -- [SORT_ORDER]
					 , MAX(BS.[NLEVEL])     AS NLEVEL
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_COMPANY_ID] END)   AS  CHILD_COMPANY_ID  -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_DIVISION_ID] END)  AS  CHILD_DIVISION_ID -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_SITE_ID] END)      AS  CHILD_SITE_ID     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_PLANT_ID] END)     AS  CHILD_PLANT_ID    -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_ID] END)             AS  ALT_ID            -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_PRIORITY] END)       AS  ALT_PRIORITY      -- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_RATE] END)           AS  ALT_RATE          -- 대체 BOM 비율 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CONCAT_ALT_PRIORITY] END) AS [CONCAT_ALT_PRIORITY] -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					 , @v_proc_name			  -- [INSERT_ID]
					 , GETDATE()			  -- [INSERT_TIME]
					 , @v_proc_name			  -- [UPDATE_ID]
					 , GETDATE()			  -- [UPDATE_TIME]
				FROM  ( SELECT INBS.[COMPANY_ID]
								, INBS.[DIVISION_ID]
								, INBS.[SITE_ID]
								, INBS.[PLANT_ID]
								, INBS.[MODEL_ID]
								, INBS.[PARENT_ITEM_ID]
								, INBS.[CHILD_ITEM_ID]
								, INBS.[CHILD_QTY]
								, INBS.[ACCUMULATED_CHILD_QTY] -- 누적 소요량 추가 2017-01-31 KIMCD
								, INBS.[ITEM_UOM]
								, INBS.[CONCATENATE_ITEM]
								, INBS.[NLEVEL]
								, INBS.[CHILD_COMPANY_ID]  -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[CHILD_DIVISION_ID] -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[CHILD_SITE_ID]     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[CHILD_PLANT_ID]    -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[ALT_ID]            -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
								, CASE WHEN INBS.[ALT_PRIORITY] = 1 THEN
											'Y'
								  END                      AS ALT_PRIORITY     -- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
								, INBS.[ALT_RATE]          -- 대체 BOM 비율 추가 2017-01-31 KIMCD
								, INBS.[SORT_ORDER]
								, RANK() OVER ( PARTITION BY INBS.[COMPANY_ID]
														, INBS.[DIVISION_ID]
														, INBS.[SITE_ID]
														, INBS.[PLANT_ID]
														, INBS.[MODEL_ID]
														, INBS.[PARENT_ITEM_ID]
														, INBS.[CONCATENATE_ITEM] -- 기준 추가 2017-01-31 KIMCD
												ORDER BY INBS.[COMPANY_ID]
													, INBS.[DIVISION_ID]
													, INBS.[SITE_ID]
													, INBS.[PLANT_ID]
													, INBS.[MODEL_ID]
													, INBS.[PARENT_ITEM_ID]
													, INBS.[CONCATENATE_ITEM] -- 기준 추가 2017-01-31 KIMCD
													, INBS.[CHILD_ITEM_ID] )  AS RANK_ORDER
								, ROW_NUMBER() OVER ( PARTITION BY INBS.[COMPANY_ID]
														, INBS.[DIVISION_ID]
														, INBS.[SITE_ID]
														, INBS.[PLANT_ID]
														, INBS.[MODEL_ID]
														, INBS.[PARENT_ITEM_ID]
														, INBS.[CHILD_ITEM_ID]
														, INBS.[CONCATENATE_ITEM]
												ORDER BY CASE WHEN INBS.[MMT_PLANT_ID] = INBS.[CHILD_PLANT_ID] THEN 1 ELSE 2 END
												    , CASE WHEN INBS.[MMT_SITE_ID] = INBS.[CHILD_SITE_ID] AND INBS.[MMT_DIVISION_ID] = INBS.[CHILD_DIVISION_ID] THEN 1 ELSE 2 END
												    , CASE WHEN INBS.[MMT_DIVISION_ID] = INBS.[CHILD_DIVISION_ID] THEN 1 ELSE 2 END
												    , INBS.[COMPANY_ID]
													, INBS.[DIVISION_ID]
													, INBS.[SITE_ID]
													, INBS.[PLANT_ID]
													, INBS.[MODEL_ID]
													, INBS.[PARENT_ITEM_ID]
													, INBS.[CHILD_ITEM_ID]
													, INBS.[CONCATENATE_ITEM]
													, INBS.[CHILD_COMPANY_ID]
													, INBS.[CHILD_DIVISION_ID]
													, INBS.[CHILD_SITE_ID]
													, INBS.[CHILD_PLANT_ID] )  AS CHILD_ORDER -- CHILD ITEM 조직 정보 넣기 위해 추가
								, INBS.[CONCAT_ALT_PRIORITY] -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
						FROM  ( SELECT MMT.[COMPANY_ID]
										, MMT.[DIVISION_ID]
										, MMT.[SITE_ID]
										, MMT.[PLANT_ID]
										, MMT.[MODEL_ID]
										, BM.[PARENT_ITEM_ID]
										, BM.[CHILD_ITEM_ID]
										, BM.[CHILD_QTY]/BM.[PARENT_QTY] AS CHILD_QTY
										, MMT.[ACCUMULATED_CHILD_QTY] * CONVERT(NUMERIC(20,10),BM.[CHILD_QTY]/BM.[PARENT_QTY]) AS ACCUMULATED_CHILD_QTY -- 2019-11-25 kimcd 소요량 계산에서 0 나와 수정 CONVERT(NUMERIC(20,10),BM.[CHILD_QTY]/BM.[PARENT_QTY]) -- 누적 소요량 추가 2017-01-31 KIMCD
										, IM.[ITEM_UOM]
										, MMT.[CONCATENATE_ITEM]
										, @LOOP_COUNT+1			  AS NLEVEL
										, MMT.[CHILD_DIVISION_ID] AS MMT_DIVISION_ID    -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, MMT.[CHILD_SITE_ID]     AS MMT_SITE_ID        -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, MMT.[CHILD_PLANT_ID]    AS MMT_PLANT_ID       -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[COMPANY_ID]         AS CHILD_COMPANY_ID   -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[DIVISION_ID]        AS CHILD_DIVISION_ID  -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[SITE_ID]            AS CHILD_SITE_ID      -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[PLANT_ID]           AS CHILD_PLANT_ID     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, CASE WHEN MMT.[ALT_ID] IS NOT NULL AND  BM.[ALT_ID] IS NOT NULL THEN
											       MMT.[ALT_ID] + BM.[ALT_ID]
											   WHEN MMT.[ALT_ID] IS NOT NULL THEN
												   MMT.[ALT_ID]
											   WHEN BM.[ALT_ID] IS NOT NULL THEN
												   BM.[ALT_ID]
										  END                   AS ALT_ID             -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
										, CASE WHEN MMT.[ALT_PRIORITY] = 'Y' THEN
												   CASE WHEN BM.[ALT_ID] IS NULL THEN
													   1
												   ELSE
													   RANK() OVER (PARTITION BY BM.[COMPANY_ID]
																				,BM.[DIVISION_ID]
																				,BM.[SITE_ID]
																				,BM.[PLANT_ID]
																				,BM.[BOM_VERSION_ID]
																				,BM.[PARENT_ITEM_ID]
																				,BM.[KEY_DATE]
																				,BM.[ALT_ID]
																	ORDER BY BM.[COMPANY_ID]
																			,BM.[DIVISION_ID]
																			,BM.[SITE_ID]
																			,BM.[PLANT_ID]
																			,BM.[BOM_VERSION_ID]
																			,BM.[PARENT_ITEM_ID]
																			,BM.[KEY_DATE]
																			,BM.[ALT_ID]
																			,BM.[ALT_PRIORITY])
												   END
										  END                   AS ALT_PRIORITY
										, CASE WHEN MMT.[ALT_RATE] IS NOT NULL AND BM.[ALT_RATE] IS NOT NULL THEN
												   MMT.[ALT_RATE] * BM.[ALT_RATE]
											   WHEN MMT.[ALT_RATE] IS NOT NULL THEN
												   MMT.[ALT_RATE]
											   WHEN BM.[ALT_RATE] IS NOT NULL THEN
												   BM.[ALT_RATE]
										  END                   AS ALT_RATE           -- 대체 BOM 비율 추가 2017-01-31 KIMCD
										, MMT.[SORT_ORDER]
										, MMT.[CONCAT_ALT_PRIORITY] + ISNULL(REPLICATE('0', 2 - LEN(CONVERT(NVARCHAR(20), CONVERT(INT,BM.[ALT_PRIORITY])))),'') + ISNULL(CONVERT(NVARCHAR(20), CONVERT(INT,BM.[ALT_PRIORITY])),'00') AS  CONCAT_ALT_PRIORITY -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용 [CONCAT_ALT_PRIORITY]
								FROM   [DBO].[SCM_BOM_M]  BM WITH(NOLOCK)
										, [DBO].[SCM_ITEM_M] IM WITH(NOLOCK)
										, [DBO].[SCM_SYS_LOOKUP_VALUE]   SSLV   WITH(NOLOCK)
										, [dbo].[SCM_MODEL_COMP_TEMP]  MMT WITH(NOLOCK)
										, [DBO].[SCM_MODEL_MODEL_TEMP] XMT WITH(NOLOCK) -- 2017-05-15 kimcd add 현재 형성 대상만 
								WHERE  BM.[COMPANY_ID]     = IM.[COMPANY_ID]
								AND    BM.[DIVISION_ID]    = IM.[DIVISION_ID]
								AND    BM.[SITE_ID]        = IM.[SITE_ID]
								AND    BM.[CHILD_ITEM_ID]  = IM.[ITEM_ID]
								AND    SSLV.[LOOKUP_TYPE_CODE] = 'BOM_LINK_PLANT'
								AND    SSLV.[ACTIVE_FLAG]  = 'Y'
								AND    SSLV.[SEGMENT1]    != SSLV.[SEGMENT2]
								AND    SSLV.[SEGMENT1]     = MMT.[CHILD_PLANT_ID]
								AND    BM.[SITE_ID]        = MMT.[CHILD_SITE_ID]
								AND    BM.[PLANT_ID]       = SSLV.[SEGMENT2]
								AND    BM.[COMPANY_ID]     = MMT.[CHILD_COMPANY_ID]
								AND    BM.[DIVISION_ID]    = MMT.[CHILD_DIVISION_ID]
								AND    BM.[PARENT_ITEM_ID] = MMT.[CHILD_ITEM_ID]
								AND    BM.[PARENT_ITEM_ID] != BM.[CHILD_ITEM_ID]
								AND    BM.[BOM_VERSION_ID] = 1
								AND    MMT.[COMPANY_ID]    = @COMPANY_ID
								AND    MMT.[DIVISION_ID]   = @DIVISION_ID
								AND    MMT.[SITE_ID]       = @SITE_ID
								AND    MMT.[NLEVEL]        = @LOOP_COUNT
								-- 2017-05-15 kimcd add start 현재 형성 대상만
								AND    XMT.[COMPANY_ID]  = MMT.[COMPANY_ID]
								AND	   XMT.[DIVISION_ID] = MMT.[DIVISION_ID]
								AND	   XMT.[SITE_ID]     = MMT.[SITE_ID]
								AND	   XMT.[PLANT_ID]    = MMT.[PLANT_ID]
								AND	   XMT.[MODEL_ID]    = MMT.[MODEL_ID]
								AND    XMT.[COMPANY_ID]  = @COMPANY_ID
								AND    XMT.[DIVISION_ID] = @DIVISION_ID
								AND    XMT.[SITE_ID]     = @SITE_ID
								-- 2017-05-15 kimcd add end 현재 형성 대상만
								AND    BM.EFF_START_DATE  <= CAST(GETDATE() AS DATE)
								AND    BM.EFF_END_DATE     > CAST(GETDATE() AS DATE)
								-- AND    IM.ITEM_TYPE       IN ('H', 'P') 
								) INBS
						) BS
				WHERE   NOT EXISTS (SELECT 1
									FROM   [dbo].[SCM_MODEL_COMP_TEMP]  MMT WITH(NOLOCK)
									WHERE  MMT.[COMPANY_ID]       = BS.[COMPANY_ID]
									AND	   MMT.[DIVISION_ID]      = BS.[DIVISION_ID]
									AND    MMT.[SITE_ID]          = BS.[SITE_ID]
									AND    MMT.[PLANT_ID]         = BS.[PLANT_ID]
									AND    MMT.[MODEL_ID]         = BS.[MODEL_ID]
									AND    MMT.[PARENT_ITEM_ID]   = BS.[PARENT_ITEM_ID]
									AND    MMT.[CONCATENATE_ITEM] LIKE BS.[CONCATENATE_ITEM] + '^%')
				GROUP  BY BS.[COMPANY_ID]
						, BS.[DIVISION_ID]
						, BS.[SITE_ID]
						, BS.[PLANT_ID]
						, BS.[MODEL_ID]
						, BS.[PARENT_ITEM_ID]
						, BS.[CHILD_ITEM_ID]
						, BS.[CONCATENATE_ITEM]
				;

				SET @INSERT_CNT = @INSERT_CNT + @@ROWCOUNT; -- 전극 Plant 전개 2017-01-31 KIMCD

                SET @v_temp1 = 'STEP INSERT DIVISION SAME'
				INSERT INTO [DBO].[SCM_MODEL_COMP_TEMP]
					( [COMPANY_ID]
					, [DIVISION_ID]
					, [SITE_ID]
					, [PLANT_ID]
					, [MODEL_ID]
					, [PARENT_ITEM_ID]
					, [CHILD_ITEM_ID]
					, [CHILD_QTY]
					, [ACCUMULATED_CHILD_QTY] -- 누적 소요량 추가 2017-01-31 KIMCD
					, [CHILD_UOM]
					, [CONCATENATE_ITEM]
					, [SORT_ORDER]
					, [NLEVEL]
					, [CHILD_COMPANY_ID]      -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [CHILD_DIVISION_ID]     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [CHILD_SITE_ID]         -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [CHILD_PLANT_ID]        -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [ALT_ID]                -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
					, [ALT_PRIORITY]          -- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
					, [ALT_RATE]              -- 대체 BOM 비율 추가 2017-01-31 KIMCD
					, [CONCAT_ALT_PRIORITY]   -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					, [INSERT_ID]
					, [INSERT_TIME]
					, [UPDATE_ID]
					, [UPDATE_TIME])
				SELECT BS.[COMPANY_ID]
					 , BS.[DIVISION_ID]
					 , BS.[SITE_ID]
					 , BS.[PLANT_ID]
					 , BS.[MODEL_ID]
					 , BS.[PARENT_ITEM_ID]
					 , BS.[CHILD_ITEM_ID]
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_QTY] END)  AS CHILD_QTY
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ACCUMULATED_CHILD_QTY] END)  AS ACCUMULATED_CHILD_QTY   -- 누적 소요량 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ITEM_UOM] END)   AS ITEM_UOM
					 , BS.[CONCATENATE_ITEM]+'^'+BS.[CHILD_ITEM_ID]
					 , MAX(BS.[SORT_ORDER] + REPLICATE('0', 4 - LEN(BS.[RANK_ORDER])) + CAST( BS.[RANK_ORDER] AS NVARCHAR)) AS SORT_ORDER   -- [SORT_ORDER]
					 , MAX(BS.[NLEVEL])     AS NLEVEL
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_COMPANY_ID] END)   AS  CHILD_COMPANY_ID  -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_DIVISION_ID] END)  AS  CHILD_DIVISION_ID -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_SITE_ID] END)      AS  CHILD_SITE_ID     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_PLANT_ID] END)     AS  CHILD_PLANT_ID    -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_ID] END)             AS  ALT_ID            -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_PRIORITY] END)       AS  ALT_PRIORITY      -- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_RATE] END)           AS  ALT_RATE          -- 대체 BOM 비율 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CONCAT_ALT_PRIORITY] END) AS [CONCAT_ALT_PRIORITY] -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					 , @v_proc_name			  -- [INSERT_ID]
					 , GETDATE()			  -- [INSERT_TIME]
					 , @v_proc_name			  -- [UPDATE_ID]
					 , GETDATE()			  -- [UPDATE_TIME]
				FROM  ( SELECT INBS.[COMPANY_ID]
								, INBS.[DIVISION_ID]
								, INBS.[SITE_ID]
								, INBS.[PLANT_ID]
								, INBS.[MODEL_ID]
								, INBS.[PARENT_ITEM_ID]
								, INBS.[CHILD_ITEM_ID]
								, INBS.[CHILD_QTY]
								, INBS.[ACCUMULATED_CHILD_QTY] -- 누적 소요량 추가 2017-01-31 KIMCD
								, INBS.[ITEM_UOM]
								, INBS.[CONCATENATE_ITEM]
								, INBS.[NLEVEL]
								, INBS.[CHILD_COMPANY_ID]  -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[CHILD_DIVISION_ID] -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[CHILD_SITE_ID]     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[CHILD_PLANT_ID]    -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[ALT_ID]            -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
								, CASE WHEN INBS.[ALT_PRIORITY] = 1 THEN
											'Y'
								  END                      AS ALT_PRIORITY     -- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
								, INBS.[ALT_RATE]          -- 대체 BOM 비율 추가 2017-01-31 KIMCD
								, INBS.[SORT_ORDER]
								, RANK() OVER ( PARTITION BY INBS.[COMPANY_ID]
														, INBS.[DIVISION_ID]
														, INBS.[SITE_ID]
														, INBS.[PLANT_ID]
														, INBS.[MODEL_ID]
														, INBS.[PARENT_ITEM_ID]
												ORDER BY INBS.[COMPANY_ID]
													, INBS.[DIVISION_ID]
													, INBS.[SITE_ID]
													, INBS.[PLANT_ID]
													, INBS.[MODEL_ID]
													, INBS.[PARENT_ITEM_ID]
													, INBS.[CHILD_ITEM_ID] )  AS RANK_ORDER
								, ROW_NUMBER() OVER ( PARTITION BY INBS.[COMPANY_ID]
														, INBS.[DIVISION_ID]
														, INBS.[SITE_ID]
														, INBS.[PLANT_ID]
														, INBS.[MODEL_ID]
														, INBS.[PARENT_ITEM_ID]
														, INBS.[CHILD_ITEM_ID]
														, INBS.[CONCATENATE_ITEM]
												ORDER BY CASE WHEN INBS.[MMT_PLANT_ID] = INBS.[CHILD_PLANT_ID] THEN 1 ELSE 2 END
												    , CASE WHEN INBS.[MMT_SITE_ID] = INBS.[CHILD_SITE_ID] AND INBS.[MMT_DIVISION_ID] = INBS.[CHILD_DIVISION_ID] THEN 1 ELSE 2 END
												    , CASE WHEN INBS.[MMT_DIVISION_ID] = INBS.[CHILD_DIVISION_ID] THEN 1 ELSE 2 END
												    , INBS.[COMPANY_ID]
													, INBS.[DIVISION_ID]
													, INBS.[SITE_ID]
													, INBS.[PLANT_ID]
													, INBS.[MODEL_ID]
													, INBS.[PARENT_ITEM_ID]
													, INBS.[CHILD_ITEM_ID]
													, INBS.[CHILD_COMPANY_ID]
													, INBS.[CHILD_DIVISION_ID]
													, INBS.[CHILD_SITE_ID]
													, INBS.[CHILD_PLANT_ID] )  AS CHILD_ORDER -- CHILD ITEM 조직 정보 넣기 위해 추가
								, INBS.[CONCAT_ALT_PRIORITY] -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
						FROM  ( SELECT MMT.[COMPANY_ID]
										, MMT.[DIVISION_ID]
										, MMT.[SITE_ID]
										, MMT.[PLANT_ID]
										, MMT.[MODEL_ID]
										, BM.[PARENT_ITEM_ID]
										, BM.[CHILD_ITEM_ID]
										, BM.[CHILD_QTY]/BM.[PARENT_QTY] AS CHILD_QTY
										, MMT.[ACCUMULATED_CHILD_QTY] * CONVERT(NUMERIC(20,10),BM.[CHILD_QTY]/BM.[PARENT_QTY]) AS ACCUMULATED_CHILD_QTY -- 2019-11-25 kimcd 소요량 계산에서 0 나와 수정 CONVERT(NUMERIC(20,10),BM.[CHILD_QTY]/BM.[PARENT_QTY]) -- 누적 소요량 추가 2017-01-31 KIMCD
										, IM.[ITEM_UOM]
										, MMT.[CONCATENATE_ITEM]
										, @LOOP_COUNT+1			  AS NLEVEL
										, MMT.[CHILD_DIVISION_ID] AS MMT_DIVISION_ID    -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, MMT.[CHILD_SITE_ID]     AS MMT_SITE_ID        -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, MMT.[CHILD_PLANT_ID]    AS MMT_PLANT_ID       -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[COMPANY_ID]         AS CHILD_COMPANY_ID   -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[DIVISION_ID]        AS CHILD_DIVISION_ID  -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[SITE_ID]            AS CHILD_SITE_ID      -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[PLANT_ID]           AS CHILD_PLANT_ID     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, CASE WHEN MMT.[ALT_ID] IS NOT NULL AND  BM.[ALT_ID] IS NOT NULL THEN
											       MMT.[ALT_ID] + BM.[ALT_ID]
											   WHEN MMT.[ALT_ID] IS NOT NULL THEN
												   MMT.[ALT_ID]
											   WHEN BM.[ALT_ID] IS NOT NULL THEN
												   BM.[ALT_ID]
										  END                   AS ALT_ID             -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
										, CASE WHEN MMT.[ALT_PRIORITY] = 'Y' THEN
												   CASE WHEN BM.[ALT_ID] IS NULL THEN
													   1
												   ELSE
													   RANK() OVER (PARTITION BY BM.[COMPANY_ID]
																				,BM.[DIVISION_ID]
																				,BM.[SITE_ID]
																				,BM.[PLANT_ID]
																				,BM.[BOM_VERSION_ID]
																				,BM.[PARENT_ITEM_ID]
																				,BM.[KEY_DATE]
																				,BM.[ALT_ID]
																	ORDER BY BM.[COMPANY_ID]
																			,BM.[DIVISION_ID]
																			,BM.[SITE_ID]
																			,BM.[PLANT_ID]
																			,BM.[BOM_VERSION_ID]
																			,BM.[PARENT_ITEM_ID]
																			,BM.[KEY_DATE]
																			,BM.[ALT_ID]
																			,BM.[ALT_PRIORITY])
												   END
										  END                   AS ALT_PRIORITY
										, CASE WHEN MMT.[ALT_RATE] IS NOT NULL AND BM.[ALT_RATE] IS NOT NULL THEN
												   MMT.[ALT_RATE] * BM.[ALT_RATE]
											   WHEN MMT.[ALT_RATE] IS NOT NULL THEN
												   MMT.[ALT_RATE]
											   WHEN BM.[ALT_RATE] IS NOT NULL THEN
												   BM.[ALT_RATE]
										  END                   AS ALT_RATE           -- 대체 BOM 비율 추가 2017-01-31 KIMCD
										, MMT.[SORT_ORDER]
										, MMT.[CONCAT_ALT_PRIORITY] + ISNULL(REPLICATE('0', 2 - LEN(CONVERT(NVARCHAR(20), CONVERT(INT,BM.[ALT_PRIORITY])))),'') + ISNULL(CONVERT(NVARCHAR(20), CONVERT(INT,BM.[ALT_PRIORITY])),'00') AS  CONCAT_ALT_PRIORITY -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용 [CONCAT_ALT_PRIORITY]
								FROM   [DBO].[SCM_BOM_M]  BM WITH(NOLOCK)
										, [DBO].[SCM_ITEM_M] IM WITH(NOLOCK)
										, [dbo].[SCM_MODEL_COMP_TEMP]  MMT WITH(NOLOCK)
										, [DBO].[SCM_MODEL_MODEL_TEMP] XMT WITH(NOLOCK) -- 2017-05-15 kimcd add 현재 형성 대상만 
								WHERE  BM.[COMPANY_ID]     = IM.[COMPANY_ID]
								AND    BM.[DIVISION_ID]    = IM.[DIVISION_ID]
								AND    BM.[SITE_ID]        = IM.[SITE_ID]
								AND    BM.[CHILD_ITEM_ID]  = IM.[ITEM_ID]
								AND    BM.[COMPANY_ID]     != MMT.[CHILD_COMPANY_ID]
								AND    BM.[DIVISION_ID]    = MMT.[CHILD_DIVISION_ID]
								AND    BM.[SITE_ID]        != MMT.[CHILD_SITE_ID]
								AND    BM.[PLANT_ID]       != MMT.[CHILD_PLANT_ID]  -- 다른 Site BOM 전개
								AND    BM.[PARENT_ITEM_ID] = MMT.[CHILD_ITEM_ID]
								AND    BM.[PARENT_ITEM_ID] != BM.[CHILD_ITEM_ID]
								AND    BM.[BOM_VERSION_ID] = 1
								AND    MMT.[COMPANY_ID]    = @COMPANY_ID
								AND    MMT.[DIVISION_ID]   = @DIVISION_ID
								AND    MMT.[SITE_ID]       = @SITE_ID
								AND    MMT.[NLEVEL]        = @LOOP_COUNT
								-- 2017-05-15 kimcd add start 현재 형성 대상만
								AND    XMT.[COMPANY_ID]  = MMT.[COMPANY_ID]
								AND	   XMT.[DIVISION_ID] = MMT.[DIVISION_ID]
								AND	   XMT.[SITE_ID]     = MMT.[SITE_ID]
								AND	   XMT.[PLANT_ID]    = MMT.[PLANT_ID]
								AND	   XMT.[MODEL_ID]    = MMT.[MODEL_ID]
								AND    XMT.[COMPANY_ID]  = @COMPANY_ID
								AND    XMT.[DIVISION_ID] = @DIVISION_ID
								AND    XMT.[SITE_ID]     = @SITE_ID
								-- 2017-05-15 kimcd add end 현재 형성 대상만
								AND    BM.EFF_START_DATE  <= CAST(GETDATE() AS DATE)
								AND    BM.EFF_END_DATE     > CAST(GETDATE() AS DATE)
								-- AND    IM.ITEM_TYPE       IN ('H', 'P') 
								) INBS
						) BS
				WHERE   NOT EXISTS (SELECT 1
									FROM   [dbo].[SCM_MODEL_COMP_TEMP]  MMT WITH(NOLOCK)
									WHERE  MMT.[COMPANY_ID]       = BS.[COMPANY_ID]
									AND	   MMT.[DIVISION_ID]      = BS.[DIVISION_ID]
									AND    MMT.[SITE_ID]          = BS.[SITE_ID]
									AND    MMT.[PLANT_ID]         = BS.[PLANT_ID]
									AND    MMT.[MODEL_ID]         = BS.[MODEL_ID]
									AND    MMT.[PARENT_ITEM_ID]   = BS.[PARENT_ITEM_ID]
									AND    MMT.[CONCATENATE_ITEM] LIKE BS.[CONCATENATE_ITEM] + '^%')
				GROUP  BY BS.[COMPANY_ID]
						, BS.[DIVISION_ID]
						, BS.[SITE_ID]
						, BS.[PLANT_ID]
						, BS.[MODEL_ID]
						, BS.[PARENT_ITEM_ID]
						, BS.[CHILD_ITEM_ID]
						, BS.[CONCATENATE_ITEM]
				;

				SET @INSERT_CNT = @INSERT_CNT + @@ROWCOUNT; -- 다른 Plant 동일 Division 2017-01-31 KIMCD


                SET @v_temp1 = 'STEP INSERT SAME SITE OTHER DIVISION'
				INSERT INTO [DBO].[SCM_MODEL_COMP_TEMP]
					( [COMPANY_ID]
					, [DIVISION_ID]
					, [SITE_ID]
					, [PLANT_ID]
					, [MODEL_ID]
					, [PARENT_ITEM_ID]
					, [CHILD_ITEM_ID]
					, [CHILD_QTY]
					, [ACCUMULATED_CHILD_QTY] -- 누적 소요량 추가 2017-01-31 KIMCD
					, [CHILD_UOM]
					, [CONCATENATE_ITEM]
					, [SORT_ORDER]
					, [NLEVEL]
					, [CHILD_COMPANY_ID]      -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [CHILD_DIVISION_ID]     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [CHILD_SITE_ID]         -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [CHILD_PLANT_ID]        -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					, [ALT_ID]                -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
					, [ALT_PRIORITY]          -- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
					, [ALT_RATE]              -- 대체 BOM 비율 추가 2017-01-31 KIMCD
					, [CONCAT_ALT_PRIORITY]   -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					, [INSERT_ID]
					, [INSERT_TIME]
					, [UPDATE_ID]
					, [UPDATE_TIME])
				SELECT BS.[COMPANY_ID]
					 , BS.[DIVISION_ID]
					 , BS.[SITE_ID]
					 , BS.[PLANT_ID]
					 , BS.[MODEL_ID]
					 , BS.[PARENT_ITEM_ID]
					 , BS.[CHILD_ITEM_ID]
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_QTY] END)  AS CHILD_QTY
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ACCUMULATED_CHILD_QTY] END)  AS ACCUMULATED_CHILD_QTY   -- 누적 소요량 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ITEM_UOM] END)   AS ITEM_UOM
					 , BS.[CONCATENATE_ITEM]+'^'+BS.[CHILD_ITEM_ID]
					 , MAX(BS.[SORT_ORDER] + REPLICATE('0', 4 - LEN(BS.[RANK_ORDER])) + CAST( BS.[RANK_ORDER] AS NVARCHAR)) AS SORT_ORDER   -- [SORT_ORDER]
					 , MAX(BS.[NLEVEL])     AS NLEVEL
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_COMPANY_ID] END)   AS  CHILD_COMPANY_ID  -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_DIVISION_ID] END)  AS  CHILD_DIVISION_ID -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_SITE_ID] END)      AS  CHILD_SITE_ID     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_PLANT_ID] END)     AS  CHILD_PLANT_ID    -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_ID] END)             AS  ALT_ID            -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_PRIORITY] END)       AS  ALT_PRIORITY      -- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_RATE] END)           AS  ALT_RATE          -- 대체 BOM 비율 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CONCAT_ALT_PRIORITY] END) AS [CONCAT_ALT_PRIORITY] -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					 , @v_proc_name			  -- [INSERT_ID]
					 , GETDATE()			  -- [INSERT_TIME]
					 , @v_proc_name			  -- [UPDATE_ID]
					 , GETDATE()			  -- [UPDATE_TIME]
				FROM  ( SELECT INBS.[COMPANY_ID]
								, INBS.[DIVISION_ID]
								, INBS.[SITE_ID]
								, INBS.[PLANT_ID]
								, INBS.[MODEL_ID]
								, INBS.[PARENT_ITEM_ID]
								, INBS.[CHILD_ITEM_ID]
								, INBS.[CHILD_QTY]
								, INBS.[ACCUMULATED_CHILD_QTY] -- 누적 소요량 추가 2017-01-31 KIMCD
								, INBS.[ITEM_UOM]
								, INBS.[CONCATENATE_ITEM]
								, INBS.[NLEVEL]
								, INBS.[CHILD_COMPANY_ID]  -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[CHILD_DIVISION_ID] -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[CHILD_SITE_ID]     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[CHILD_PLANT_ID]    -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								, INBS.[ALT_ID]            -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
								, CASE WHEN INBS.[ALT_PRIORITY] = 1 THEN
											'Y'
								  END                      AS ALT_PRIORITY     -- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
								, INBS.[ALT_RATE]          -- 대체 BOM 비율 추가 2017-01-31 KIMCD
								, INBS.[SORT_ORDER]
								, RANK() OVER ( PARTITION BY INBS.[COMPANY_ID]
														, INBS.[DIVISION_ID]
														, INBS.[SITE_ID]
														, INBS.[PLANT_ID]
														, INBS.[MODEL_ID]
														, INBS.[PARENT_ITEM_ID]
												ORDER BY INBS.[COMPANY_ID]
													, INBS.[DIVISION_ID]
													, INBS.[SITE_ID]
													, INBS.[PLANT_ID]
													, INBS.[MODEL_ID]
													, INBS.[PARENT_ITEM_ID]
													, INBS.[CHILD_ITEM_ID] )  AS RANK_ORDER
								, ROW_NUMBER() OVER ( PARTITION BY INBS.[COMPANY_ID]
														, INBS.[DIVISION_ID]
														, INBS.[SITE_ID]
														, INBS.[PLANT_ID]
														, INBS.[MODEL_ID]
														, INBS.[PARENT_ITEM_ID]
														, INBS.[CHILD_ITEM_ID]
														, INBS.[CONCATENATE_ITEM]
												ORDER BY CASE WHEN INBS.[MMT_PLANT_ID] = INBS.[CHILD_PLANT_ID] THEN 1 ELSE 2 END
												    , CASE WHEN INBS.[MMT_SITE_ID] = INBS.[CHILD_SITE_ID] AND INBS.[MMT_DIVISION_ID] = INBS.[CHILD_DIVISION_ID] THEN 1 ELSE 2 END
												    , CASE WHEN INBS.[MMT_DIVISION_ID] = INBS.[CHILD_DIVISION_ID] THEN 1 ELSE 2 END
												    , INBS.[COMPANY_ID]
													, INBS.[DIVISION_ID]
													, INBS.[SITE_ID]
													, INBS.[PLANT_ID]
													, INBS.[MODEL_ID]
													, INBS.[PARENT_ITEM_ID]
													, INBS.[CHILD_ITEM_ID]
													, INBS.[CHILD_COMPANY_ID]
													, INBS.[CHILD_DIVISION_ID]
													, INBS.[CHILD_SITE_ID]
													, INBS.[CHILD_PLANT_ID] )  AS CHILD_ORDER -- CHILD ITEM 조직 정보 넣기 위해 추가
								, INBS.[CONCAT_ALT_PRIORITY] -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
						FROM  ( SELECT MMT.[COMPANY_ID]
										, MMT.[DIVISION_ID]
										, MMT.[SITE_ID]
										, MMT.[PLANT_ID]
										, MMT.[MODEL_ID]
										, BM.[PARENT_ITEM_ID]
										, BM.[CHILD_ITEM_ID]
										, BM.[CHILD_QTY]/BM.[PARENT_QTY] AS CHILD_QTY
										, MMT.[ACCUMULATED_CHILD_QTY] * CONVERT(NUMERIC(20,10),BM.[CHILD_QTY]/BM.[PARENT_QTY]) AS ACCUMULATED_CHILD_QTY -- 2019-11-25 kimcd 소요량 계산에서 0 나와 수정 CONVERT(NUMERIC(20,10),BM.[CHILD_QTY]/BM.[PARENT_QTY]) -- 누적 소요량 추가 2017-01-31 KIMCD
										, IM.[ITEM_UOM]
										, MMT.[CONCATENATE_ITEM]
										, @LOOP_COUNT+1			  AS NLEVEL
										, MMT.[CHILD_DIVISION_ID] AS MMT_DIVISION_ID    -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, MMT.[CHILD_SITE_ID]     AS MMT_SITE_ID        -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, MMT.[CHILD_PLANT_ID]    AS MMT_PLANT_ID       -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[COMPANY_ID]         AS CHILD_COMPANY_ID   -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[DIVISION_ID]        AS CHILD_DIVISION_ID  -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[SITE_ID]            AS CHILD_SITE_ID      -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, BM.[PLANT_ID]           AS CHILD_PLANT_ID     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, CASE WHEN MMT.[ALT_ID] IS NOT NULL AND  BM.[ALT_ID] IS NOT NULL THEN
											       MMT.[ALT_ID] + BM.[ALT_ID]
											   WHEN MMT.[ALT_ID] IS NOT NULL THEN
												   MMT.[ALT_ID]
											   WHEN BM.[ALT_ID] IS NOT NULL THEN
												   BM.[ALT_ID]
										  END                   AS ALT_ID             -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
										, CASE WHEN MMT.[ALT_PRIORITY] = 'Y' THEN
												   CASE WHEN BM.[ALT_ID] IS NULL THEN
													   1
												   ELSE
													   RANK() OVER (PARTITION BY BM.[COMPANY_ID]
																				,BM.[DIVISION_ID]
																				,BM.[SITE_ID]
																				,BM.[PLANT_ID]
																				,BM.[BOM_VERSION_ID]
																				,BM.[PARENT_ITEM_ID]
																				,BM.[KEY_DATE]
																				,BM.[ALT_ID]
																	ORDER BY BM.[COMPANY_ID]
																			,BM.[DIVISION_ID]
																			,BM.[SITE_ID]
																			,BM.[PLANT_ID]
																			,BM.[BOM_VERSION_ID]
																			,BM.[PARENT_ITEM_ID]
																			,BM.[KEY_DATE]
																			,BM.[ALT_ID]
																			,BM.[ALT_PRIORITY])
												   END
										  END                   AS ALT_PRIORITY
										, CASE WHEN MMT.[ALT_RATE] IS NOT NULL AND BM.[ALT_RATE] IS NOT NULL THEN
												   MMT.[ALT_RATE] * BM.[ALT_RATE]
											   WHEN MMT.[ALT_RATE] IS NOT NULL THEN
												   MMT.[ALT_RATE]
											   WHEN BM.[ALT_RATE] IS NOT NULL THEN
												   BM.[ALT_RATE]
										  END                   AS ALT_RATE           -- 대체 BOM 비율 추가 2017-01-31 KIMCD
										, MMT.[SORT_ORDER]
										, MMT.[CONCAT_ALT_PRIORITY] + ISNULL(REPLICATE('0', 2 - LEN(CONVERT(NVARCHAR(20), CONVERT(INT,BM.[ALT_PRIORITY])))),'') + ISNULL(CONVERT(NVARCHAR(20), CONVERT(INT,BM.[ALT_PRIORITY])),'00') AS  CONCAT_ALT_PRIORITY -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용 [CONCAT_ALT_PRIORITY]
								FROM   [DBO].[SCM_BOM_M]  BM WITH(NOLOCK)
										, [DBO].[SCM_ITEM_M] IM WITH(NOLOCK)
										, [dbo].[SCM_MODEL_COMP_TEMP]  MMT WITH(NOLOCK)
										, [DBO].[SCM_MODEL_MODEL_TEMP] XMT WITH(NOLOCK) -- 2017-05-15 kimcd add 현재 형성 대상만 
								WHERE  BM.[COMPANY_ID]     = IM.[COMPANY_ID]
								AND    BM.[DIVISION_ID]    = IM.[DIVISION_ID]
								AND    BM.[SITE_ID]        = IM.[SITE_ID]
								AND    BM.[CHILD_ITEM_ID]  = IM.[ITEM_ID]
								AND    BM.[COMPANY_ID]     = MMT.[CHILD_COMPANY_ID]
								AND    BM.[DIVISION_ID]    != MMT.[CHILD_DIVISION_ID]
								AND    BM.[SITE_ID]        = MMT.[CHILD_SITE_ID]
								AND    BM.[PLANT_ID]       != MMT.[CHILD_PLANT_ID]  -- 다른 Site BOM 전개
								AND    BM.[PARENT_ITEM_ID] = MMT.[CHILD_ITEM_ID]
								AND    BM.[PARENT_ITEM_ID] != BM.[CHILD_ITEM_ID]
								AND    BM.[BOM_VERSION_ID] = 1
								AND    MMT.[COMPANY_ID]    = @COMPANY_ID
								AND    MMT.[DIVISION_ID]   = @DIVISION_ID
								AND    MMT.[SITE_ID]       = @SITE_ID
								AND    MMT.[NLEVEL]        = @LOOP_COUNT
								-- 2017-05-15 kimcd add start 현재 형성 대상만
								AND    XMT.[COMPANY_ID]  = MMT.[COMPANY_ID]
								AND	   XMT.[DIVISION_ID] = MMT.[DIVISION_ID]
								AND	   XMT.[SITE_ID]     = MMT.[SITE_ID]
								AND	   XMT.[PLANT_ID]    = MMT.[PLANT_ID]
								AND	   XMT.[MODEL_ID]    = MMT.[MODEL_ID]
								AND    XMT.[COMPANY_ID]  = @COMPANY_ID
								AND    XMT.[DIVISION_ID] = @DIVISION_ID
								AND    XMT.[SITE_ID]     = @SITE_ID
								-- 2017-05-15 kimcd add end 현재 형성 대상만
								AND    BM.EFF_START_DATE  <= CAST(GETDATE() AS DATE)
								AND    BM.EFF_END_DATE     > CAST(GETDATE() AS DATE)
								-- AND    IM.ITEM_TYPE       IN ('H', 'P') 
								) INBS
						) BS
				WHERE   NOT EXISTS (SELECT 1
									FROM   [dbo].[SCM_MODEL_COMP_TEMP]  MMT WITH(NOLOCK)
									WHERE  MMT.[COMPANY_ID]       = BS.[COMPANY_ID]
									AND	   MMT.[DIVISION_ID]      = BS.[DIVISION_ID]
									AND    MMT.[SITE_ID]          = BS.[SITE_ID]
									AND    MMT.[PLANT_ID]         = BS.[PLANT_ID]
									AND    MMT.[MODEL_ID]         = BS.[MODEL_ID]
									AND    MMT.[PARENT_ITEM_ID]   = BS.[PARENT_ITEM_ID]
									AND    MMT.[CONCATENATE_ITEM] LIKE BS.[CONCATENATE_ITEM] + '^%')
				GROUP  BY BS.[COMPANY_ID]
						, BS.[DIVISION_ID]
						, BS.[SITE_ID]
						, BS.[PLANT_ID]
						, BS.[MODEL_ID]
						, BS.[PARENT_ITEM_ID]
						, BS.[CHILD_ITEM_ID]
						, BS.[CONCATENATE_ITEM]
				;

				SET @INSERT_CNT = @INSERT_CNT + @@ROWCOUNT; -- 다른 Plant 동일 Site 다른 Division 2017-01-31 KIMCD

				/*2017-01-31 KIMCD 추가 종료. 동일 Plant 우선, 동일 Site의 전극 Plant 전개. 다른 Site 동일 Division 전개*/

				IF @INSERT_CNT > 0
					SET @LOOP_COUNT = @LOOP_COUNT+1
				ELSE
					SET @LOOP_FLAG = 'N'

			END -- WHILE @LOOP_FLAG = 'Y'
                
			SET @v_temp1 = 'STEP UPDATE LEAF NOOD'
			UPDATE MCT
			SET    [LEAF_LEVEL] = 'Y'
			FROM   [dbo].[SCM_MODEL_COMP_TEMP] MCT
			-- 2018-02-06 갱신 조건 추가 kimcd 시작
			WHERE  MCT.COMPANY_ID  = @COMPANY_ID
			AND	   MCT.DIVISION_ID = @DIVISION_ID
			AND	   MCT.SITE_ID     = @SITE_ID
			AND    EXISTS      (SELECT 1 
								FROM   [DBO].[SCM_MODEL_MODEL_TEMP] MMT WITH(NOLOCK)
								WHERE  MMT.[COMPANY_ID]  = MCT.[COMPANY_ID]
								AND	   MMT.[DIVISION_ID] = MCT.[DIVISION_ID]
								AND	   MMT.[SITE_ID]     = MCT.[SITE_ID]
								AND	   MMT.[PLANT_ID]    = MCT.[PLANT_ID]
								AND	   MMT.[MODEL_ID]    = MCT.[MODEL_ID])
			-- 2018-02-06 갱신 조건 추가 kimcd 끝
			AND    NOT EXISTS ( SELECT 1
								FROM   [dbo].[SCM_MODEL_COMP_TEMP]  AS CT WITH(NOLOCK)
								WHERE  CT.[COMPANY_ID]          = MCT.[COMPANY_ID]
								AND    CT.[DIVISION_ID]         = MCT.[DIVISION_ID]
								AND    CT.[SITE_ID]             = MCT.[SITE_ID]
								AND    CT.[PLANT_ID]            = MCT.[PLANT_ID]
								AND    CT.[MODEL_ID]            = MCT.[MODEL_ID]
								AND    CT.[CONCATENATE_ITEM] LIKE MCT.[CONCATENATE_ITEM] + '^%' ) ;

			/* 	2017-05-15 kimcd block start -- SCM_MODEL_COMP 사용 안됨.
			DECLARE C_MODEL_COMP CURSOR FOR 
				SELECT MC.[PLANT_ID]
					 , MC.[MODEL_ID]
					 , MC.[CHILD_ITEM_ID]
					 , MC.[CHILD_QTY]
					 , MC.[CHILD_UOM]
					 , MC.[CONCATENATE_ITEM]
					 , SOF.[OPERATION_ID]
					 , MC.[NLEVEL] * 100 +  ISNULL(SOF.[OPERATION_SEQ],0)  AS OPERATION_SEQ
					 , MC.[NLEVEL]
					 , MC.[LEAF_LEVEL]
				FROM   [dbo].[SCM_MODEL_COMP_TEMP]  AS MC WITH(NOLOCK)
					   LEFT OUTER JOIN [dbo].[SCM_ITEM_M]  AS IT WITH(NOLOCK)
						ON MC.[CHILD_COMPANY_ID] = IT.[COMPANY_ID]
						AND MC.[CHILD_DIVISION_ID] = IT.[DIVISION_ID]
						AND MC.[CHILD_SITE_ID] = IT.[SITE_ID]
						AND MC.[CHILD_ITEM_ID] = IT.[ITEM_ID]
					   LEFT OUTER JOIN [dbo].[SCM_OPERATION_FLOW_M]  AS SOF WITH(NOLOCK)
						ON IT.[COMPANY_ID] = SOF.[COMPANY_ID]
						AND IT.[DIVISION_ID] = SOF.[DIVISION_ID]
						AND IT.[SITE_ID] = SOF.[SITE_ID]
						AND IT.[FLOW_ID] = SOF.[FLOW_ID]
						AND SOF.[ACTIVE_FLAG] = 'Y'
				WHERE  MC.[COMPANY_ID]  = @COMPANY_ID
				AND    MC.[DIVISION_ID] = @DIVISION_ID
				AND    MC.[SITE_ID]     = @SITE_ID
				ORDER BY MC.[PLANT_ID], MC.[MODEL_ID], MC.[SORT_ORDER];

			SET @v_temp1 = 'STEP OPEN CURSOR LOOKUP PRODUCT'
    		OPEN C_MODEL_COMP
            FETCH NEXT FROM C_MODEL_COMP INTO @PLANT_ID
											, @MODEL_ID
											, @CHILD_ITEM_ID
											, @CHILD_QTY
											, @CHILD_UOM
											, @CONCATENATE_ITEM
											, @OPERATION_ID
											, @OPERATION_SEQ
											, @NLEVEL
											, @LEAF_LEVEL

			SET @HOLD_PLANT_ID   = '-1'
			SET @HOLD_MODEL_ID   = '-1'
			SET @L_LINE_NUM      = 1
			SET @HOLD_LEAF_LEVEL = @LEAF_LEVEL
			SET @HOLD_CHILD_ITEM = @CHILD_ITEM_ID

            WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
            BEGIN
			
				IF @HOLD_PLANT_ID != @PLANT_ID
				OR @HOLD_MODEL_ID != @MODEL_ID
					BEGIN
						SET @HOLD_PLANT_ID   = @PLANT_ID
						SET @HOLD_MODEL_ID   = @MODEL_ID
						SET @L_LINE_NUM      = 1

						SET @v_temp1 = 'STEP DELETE [SCM_MODEL_COMP] BY PLANT_ID, MODEL_ID'
						DELETE [DBO].[SCM_MODEL_COMP]
						WHERE  [COMPANY_ID]  = @COMPANY_ID
						AND    [DIVISION_ID] = @DIVISION_ID
						AND    [SITE_ID]     = @SITE_ID
						AND    [PLANT_ID]    = @PLANT_ID
						AND	   [MODEL_ID]	 = @MODEL_ID;
					END;  -- IF @HOLD_PLANT_ID != @PLANT_ID OR @HOLD_MODEL_ID != @MODEL_ID
				ELSE
					BEGIN
						IF @HOLD_LEAF_LEVEL = 'Y'
						AND @HOLD_CHILD_ITEM != @CHILD_ITEM_ID
							BEGIN
								SET @v_temp1 = 'STEP INSERT [SCM_MODEL_COMP] AT LEAF_LEVEL'
								INSERT INTO [dbo].[SCM_MODEL_COMP]
									( [COMPANY_ID]
									, [DIVISION_ID]
									, [SITE_ID]
									, [PLANT_ID]
									, [MODEL_ID]
									, [LINE_NUM]
									, [OPERATION_ID]
									, [OPERATION_SEQ]
									, [CHILD_ITEM_ID]
									, [CHILD_QTY]
									, [CHILD_UOM]
									, [CONCATENATE_ITEM]
									, [INSERT_ID]
									, [INSERT_TIME]
									, [UPDATE_ID]
									, [UPDATE_TIME] )
								SELECT SMC.[COMPANY_ID]
									 , SMC.[DIVISION_ID]
									 , SMC.[SITE_ID]
									 , SMC.[PLANT_ID]   
									 , SMC.[MODEL_ID]
									 , @L_LINE_NUM + 1  -- [LINE_NUM]
									 , SMC.[OPERATION_ID]
									 , SMC.[OPERATION_SEQ]
									 , SMC.[CHILD_ITEM_ID]
									 , SMC.[CHILD_QTY]
									 , SMC.[CHILD_UOM]
									 , SMC.[CONCATENATE_ITEM]
				 					 , @v_proc_name
				 					 , GETDATE()
				 					 , @v_proc_name
				 					 , GETDATE()
				 				FROM   [dbo].[SCM_MODEL_COMP] SMC WITH(NOLOCK)
								WHERE  SMC.[COMPANY_ID]  = @COMPANY_ID 
								AND    SMC.[DIVISION_ID] = @DIVISION_ID
								AND    SMC.[SITE_ID]     = @SITE_ID
								AND    SMC.[PLANT_ID]    = @PLANT_ID
								AND    SMC.[MODEL_ID]    = @MODEL_ID
								AND    SMC.[LINE_NUM]    = @L_LINE_NUM
								AND    SMC. [OPERATION_SEQ] < @NLEVEL *100
								SET @L_LINE_NUM = @L_LINE_NUM + 1
							END;
					END;

				SET @HOLD_LEAF_LEVEL = @LEAF_LEVEL
				SET @HOLD_CHILD_ITEM = @CHILD_ITEM_ID

				SET @v_temp1 = 'STEP INSERT [SCM_MODEL_COMP]'
				INSERT INTO [dbo].[SCM_MODEL_COMP]
					( [COMPANY_ID]
					, [DIVISION_ID]
					, [SITE_ID]
					, [PLANT_ID]
					, [MODEL_ID]
					, [LINE_NUM]
					, [OPERATION_ID]
					, [OPERATION_SEQ]
					, [CHILD_ITEM_ID]
					, [CHILD_QTY]
					, [CHILD_UOM]
					, [CONCATENATE_ITEM]
					, [INSERT_ID]
					, [INSERT_TIME]
					, [UPDATE_ID]
					, [UPDATE_TIME] )
				VALUES ( @COMPANY_ID 
					   , @DIVISION_ID
					   , @SITE_ID    
					   , @PLANT_ID   
					   , @MODEL_ID
					   , @L_LINE_NUM
					   , ISNULL(@OPERATION_ID, '-')  -- @OPERATION_ID
					   , @OPERATION_SEQ
					   , @CHILD_ITEM_ID
					   , @CHILD_QTY
					   , @CHILD_UOM
					   , @CONCATENATE_ITEM
				 	   , @v_proc_name
				 	   , GETDATE()
				 	   , @v_proc_name
				 	   , GETDATE()
				 	   );

   				SET @v_count = @v_count + 1;

				FETCH NEXT FROM C_MODEL_COMP INTO @PLANT_ID
												, @MODEL_ID
												, @CHILD_ITEM_ID
												, @CHILD_QTY
												, @CHILD_UOM
												, @CONCATENATE_ITEM
												, @OPERATION_ID
												, @OPERATION_SEQ
												, @NLEVEL
												, @LEAF_LEVEL

			END -- WHILE @@FETCH_STATUS = 0  C_LOOKUP_PRODUCT
			CLOSE C_MODEL_COMP;
			DEALLOCATE C_MODEL_COMP;   -- 메모리 해제
			2017-05-15 kimcd block end -- SCM_MODEL_COMP 사용 안됨.*/

			FETCH NEXT FROM C_SITE INTO @COMPANY_ID,
										@DIVISION_ID,
										@SITE_ID

        END  -- WHILE @@FETCH_STATUS = 0  C_SITE
        CLOSE C_SITE;
        DEALLOCATE C_SITE;   -- 메모리 해제

        COMMIT TRANSACTION;

        SET @v_temp1 = 'STEP END PROCEDURE'
        EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   @v_count, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
    END TRY

	BEGIN CATCH

	   ROLLBACK TRANSACTION;
		-- 에러나도 로그는 인서트
		SET @data_s = CURSOR_STATUS('global','C_SITE')
		IF @data_s IN (1,0)
						BEGIN
		                    CLOSE C_SITE;
                            DEALLOCATE C_SITE;   -- 메모리 해제
                        END

						
		SET @data_s = CURSOR_STATUS('local','C_MODEL_COMP')
		IF @data_s IN (1,0)
						BEGIN
		                    CLOSE C_MODEL_COMP;
                            DEALLOCATE C_MODEL_COMP;   -- 메모리 해제
                        END

		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, @v_temp1, @v_descr, @sysdate

	END CATCH

END
