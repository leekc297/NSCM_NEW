
CREATE PROCEDURE [dbo].[PR_MK_SCM_MODEL_EFF]
-- ================================================================================================
-- Program ID          : FP02010 Model 정보 형성
--
-- Program Name        : PR_MK_SCM_MODEL_EFF
-- Param               :
-- Batch Period        : 30분
-- Description         : Operation Flow, BOM 변경 정보를 기반으로 BOM 전개하여 Model별 임시 정보 형성
--
-- Source Table        : SCM_BOM_M, SCM_ITEM_M, SCM_OPERATION_FLOW_M
-- Temp Table          : SCM_MODEL_MODEL_TEMP
-- Destination Table   : SCM_MODEL_COMP_EFFECTIVE_DATE
--
-- Create(Update) Date : 2022.07.22
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
--                       2018-06-14 KIMCD PR_MK_SCM_MODEL_COMP 기반으로 다시 구성
--                       2019-07-02 KIMCD BOM 적용 일자별 소요량 수량 정합화. 기존에 누적 소요량이 오류로 인해
--                                        수량 정보 정합성 맞추는 작업 진행함
--                       2019-11-25 kimcd CONVERT(NUMERIC(20,10),BM.[CHILD_QTY]/BM.[PARENT_QTY]) 소요량 계산에서 0 나와 수정
--                       2020-01-02 kimcd transaction begin, commit, rollback 제거 - 속도 개선용
--                       2020-01-03 kimcd table index hint 추가. loop안의 delete 제거. insert를 미래만 함
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
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_MK_SCM_MODEL_EFF'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @data_s      INTEGER
	DECLARE @site_s      INTEGER
	DECLARE @v_skip_check  integer

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

    BEGIN TRY
    -- BEGIN TRANSACTION; 2020-01-02 kimcd transaction begin, commit, rollback 제거 - 속도 개선용
	        
        SET @v_temp1 = 'STEP OPEN CURSOR C_SITE'
    	OPEN C_SITE
        FETCH NEXT FROM C_SITE INTO @COMPANY_ID,
									@DIVISION_ID,
									@SITE_ID
    
        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN

		    --LOOKUP : PR_MK_SCM_MODEL_EFF 계획 릴리즈 시간대 실행 SKIP
			SELECT @v_skip_check = COUNT(*)
			  FROM SCM_SYS_LOOKUP_VALUE LV WITH(NOLOCK)
			 WHERE LV.LOOKUP_TYPE_CODE  = 'PR_MK_SCM_MODEL_EFF'
			   AND SEGMENT1				= @SITE_ID
			   AND SEGMENT2				= DATENAME(WEEKDAY, GETDATE())
			   AND SEGMENT3				= FORMAT(getdate(),'HH')
			   AND ACTIVE_FLAG			= 'Y'

			IF @v_skip_check > 0
			BEGIN
				SET @v_temp1 = 'LOOP SITE SKIP'
				SET @v_temp2 = @COMPANY_ID + '_' + @DIVISION_ID + '_' + @SITE_ID + '_' + DATENAME(WEEKDAY, GETDATE()) + '_' + FORMAT(getdate(),'HH')

				EXEC PR_XIF_LOG @v_proc_name, NULL, 'LOG',   @v_count, @v_temp1, @v_temp2, NULL, @sysdate

				FETCH NEXT FROM C_SITE INTO @COMPANY_ID,
											@DIVISION_ID,
											@SITE_ID
				CONTINUE ;
			END

			SET @v_temp1 = 'STEP CLEAR SCM_MODEL_MODEL_TEMP'
			DELETE FROM [dbo].[SCM_MODEL_MODEL_TEMP]
			WHERE  COMPANY_ID  = @COMPANY_ID
			AND	   DIVISION_ID = @DIVISION_ID
			AND	   SITE_ID     = @SITE_ID;

			IF @P_ALL_CREATE  = 'Y'
				BEGIN
					SET @v_temp1 = 'STEP CLEAR SCM_MODEL_COMP_EFFECTIVE_DATE AT ALL'
					DELETE FROM [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]
					WHERE  COMPANY_ID    = @COMPANY_ID
					AND	   DIVISION_ID   = @DIVISION_ID
					AND	   SITE_ID       = @SITE_ID  -- 2017-05-15 kimcd add at  @P_ALL_CREATE  = 'Y'
					AND    EFF_END_DATE >= CAST(GETDATE()-1 AS DATE); -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성

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
							FROM   [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE] SMC WITH(NOLOCK)  -- -- 2017-05-15 kimcd modify
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
														   SBM.[KEY_DATE]     >= CONVERT(NVARCHAR(8), GETDATE()-1,112)  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
							         OR  SIM.[ITEM_TYPE] = 'P' )   -- 2022-07-22 kimcd BOM 전개 대상 조건 item type 복원  -- 모델 구분자 BLOCK 2017-01-31 KIMCD
							AND    SMM.[COMPANY_ID]    = @COMPANY_ID
							AND    SMM.[DIVISION_ID]   = @DIVISION_ID
							AND    SMM.[SITE_ID]       = @SITE_ID
							AND    SMM.[KEY_DATE]     >= CONVERT(NVARCHAR(8), GETDATE()-1,112)  -- 2017-05-15 kimcd add
							-- AND    SMM.[INSERT_TIME]   > GETDATE() - 1.5  2017-05-15 kimcd block
							) A
							;

					--  2017-05-15 kimcd add start for new bom
					SET @v_temp1 = 'STEP CLEAR SCM_MODEL_COMP_EFFECTIVE_DATE AT NEW'
					DELETE MCT
					FROM   [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE] MCT WITH(NOLOCK)
					WHERE  COMPANY_ID    = @COMPANY_ID
					AND	   DIVISION_ID   = @DIVISION_ID
					AND	   SITE_ID       = @SITE_ID
					AND    EFF_END_DATE >= CAST(GETDATE()-1 AS DATE) -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
			INSERT INTO [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]
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
				, [EFF_START_DATE]        -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
				, [EFF_END_DATE]          -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
				 , '1990-01-01'           -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
				 , '9999-12-31'           -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
			    -- LOOP_COUNT별 입력 RECORD 개수 초기화 2017-01-31 KIMCD
				SET @INSERT_CNT = 0; 

				-- 2019-07-03 kimcd 기존 BOM 삭제 시작 - BOM 적용 일자 삭제의 경우 보완. 적용일을 상위품 적용일과 혼합 사용하여 발생하는 중복 방지용
				/*-- 2020-01-03 kimcd 중간 Delete 제거 미래만 입력함
                DELETE MMT
				FROM (  SELECT INBS.[COMPANY_ID]
							 , INBS.[DIVISION_ID]
							 , INBS.[SITE_ID]
							 , INBS.[PLANT_ID]
							 , INBS.[MODEL_ID]
							 , INBS.[PARENT_ITEM_ID]
							 , INBS.[CONCATENATE_ITEM]
							 , MIN(INBS.[EFF_START_DATE]) AS   [EFF_START_DATE]
						FROM  ( SELECT MMT.[COMPANY_ID]
										, MMT.[DIVISION_ID]
										, MMT.[SITE_ID]
										, MMT.[PLANT_ID]
										, MMT.[MODEL_ID]
										, BM.[PARENT_ITEM_ID]
										, BM.[CHILD_ITEM_ID]
										, BM.[CHILD_QTY]/BM.[PARENT_QTY] AS CHILD_QTY
										,CASE WHEN BM.[EFF_START_DATE] > MMT.EFF_START_DATE THEN BM.[EFF_START_DATE] ELSE MMT.EFF_START_DATE END AS EFF_START_DATE -- 2019-07-03 kimcd 일자 변경 상위, 하위 비교하여 큰 값 입력
										,CASE WHEN BM.[EFF_END_DATE] > MMT.EFF_END_DATE THEN MMT.EFF_END_DATE ELSE BM.[EFF_END_DATE] END AS EFF_END_DATE   -- 2019-07-03 kimcd 일자 변경 상위, 하위 비교하여 작은 값 입력
										, MMT.[CONCATENATE_ITEM]
										, MMT.[CHILD_DIVISION_ID] AS MMT_DIVISION_ID    -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, MMT.[CHILD_SITE_ID]     AS MMT_SITE_ID        -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
										, MMT.[CHILD_PLANT_ID]    AS MMT_PLANT_ID       -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
								FROM   [DBO].[SCM_BOM_M]  BM WITH(NOLOCK)
										, [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]  MMT WITH(NOLOCK)
										, [DBO].[SCM_MODEL_MODEL_TEMP] XMT WITH(NOLOCK) -- 2017-05-15 kimcd add 현재 형성 대상만 
								WHERE  BM.[PARENT_ITEM_ID] = MMT.[CHILD_ITEM_ID]
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
								AND    BM.EFF_END_DATE   >= CAST(GETDATE()-1 AS DATE)  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
								-- 2019-07-03 kimcd add date condition 시작
								AND    BM.EFF_START_DATE < MMT.EFF_END_DATE
								AND    BM.EFF_END_DATE   > MMT.EFF_START_DATE
								-- 2019-07-03 kimcd add date condition 끝
								-- AND    IM.ITEM_TYPE       IN ('H', 'P') 
								) INBS
						GROUP BY  INBS.[COMPANY_ID]
								, INBS.[DIVISION_ID]
								, INBS.[SITE_ID]
								, INBS.[PLANT_ID]
								, INBS.[MODEL_ID]
								, INBS.[PARENT_ITEM_ID]
								, INBS.[CONCATENATE_ITEM]
						) BS
					, [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]  MMT
				WHERE  MMT.[COMPANY_ID]       = BS.[COMPANY_ID]
				AND	   MMT.[DIVISION_ID]      = BS.[DIVISION_ID]
				AND    MMT.[SITE_ID]          = BS.[SITE_ID]
				AND    MMT.[PLANT_ID]         = BS.[PLANT_ID]
				AND    MMT.[MODEL_ID]         = BS.[MODEL_ID]
				AND    MMT.[PARENT_ITEM_ID]   = BS.[PARENT_ITEM_ID]
				AND    MMT.[CONCATENATE_ITEM] LIKE BS.[CONCATENATE_ITEM] + '^%'
				AND    MMT.EFF_START_DATE    >= BS.EFF_START_DATE 
				-- 2020-01-03 kimcd 중간 Delete 제거 미래만 입력함*/ 
				-- 2019-07-03 kimcd 기존 BOM 삭제 끝

                SET @v_temp1 = 'STEP INSERT SAME PLANT'

/*
				INSERT INTO [DBO].[SCM_MODEL_COMP_EFFECTIVE_DATE]
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
					, [EFF_START_DATE]        -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					, [EFF_END_DATE]          -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
					 , BS.[EFF_START_DATE]    -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					 , MAX(BS.[EFF_END_DATE]) -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
								, INBS.[EFF_START_DATE]    -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
								, INBS.[EFF_END_DATE]      -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
														, INBS.[EFF_START_DATE]  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
														, INBS.[EFF_START_DATE]  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
										--, BM.[EFF_START_DATE]   -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성 -- 2019-07-03 kimcd 일자 조건 막음
										--, BM.[EFF_END_DATE]     -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성 -- 2019-07-03 kimcd 일자 조건 막음
										,CASE WHEN BM.[EFF_START_DATE] > MMT.EFF_START_DATE THEN BM.[EFF_START_DATE] ELSE MMT.EFF_START_DATE END AS EFF_START_DATE -- 2019-07-03 kimcd 일자 변경 상위, 하위 비교하여 큰 값 입력
										,CASE WHEN BM.[EFF_END_DATE] > MMT.EFF_END_DATE THEN MMT.EFF_END_DATE ELSE BM.[EFF_END_DATE] END AS EFF_END_DATE   -- 2019-07-03 kimcd 일자 변경 상위, 하위 비교하여 작은 값 입력
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
										, [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]  MMT WITH(NOLOCK)
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
								AND    BM.EFF_END_DATE   >= CAST(GETDATE()-1 AS DATE)  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
								-- 2019-07-03 kimcd add date condition 시작
								AND    BM.EFF_START_DATE < MMT.EFF_END_DATE
								AND    BM.EFF_END_DATE   > MMT.EFF_START_DATE
								-- 2019-07-03 kimcd add date condition 끝
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
						, BS.[EFF_START_DATE]  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
				HAVING  MAX(BS.[EFF_END_DATE]) >= CAST(GETDATE()-1 AS DATE) -- 2020-01-03 kimcd 미래 적용일 정보만 입력
				;

				SET @INSERT_CNT = @INSERT_CNT + @@ROWCOUNT; -- 입력 개수 취합 - 동일 Plant
*/

				MERGE INTO [DBO].[SCM_MODEL_COMP_EFFECTIVE_DATE] AS T
				USING (
				      SELECT BS.[COMPANY_ID]
					       , BS.[DIVISION_ID]
					       , BS.[SITE_ID]
					       , BS.[PLANT_ID]
					       , BS.[MODEL_ID]
					       , BS.[PARENT_ITEM_ID]
					       , BS.[CHILD_ITEM_ID]
					       , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_QTY] END)				AS CHILD_QTY
					       , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ACCUMULATED_CHILD_QTY] END)	AS ACCUMULATED_CHILD_QTY   -- 누적 소요량 추가 2017-01-31 KIMCD
					       , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ITEM_UOM] END)					AS CHILD_UOM
					       , BS.[CONCATENATE_ITEM]+'^'+BS.[CHILD_ITEM_ID]								AS CONCATENATE_ITEM
					       , MAX(BS.[SORT_ORDER] + REPLICATE('0', 4 - LEN(BS.[RANK_ORDER])) + CAST( BS.[RANK_ORDER] AS NVARCHAR)) AS SORT_ORDER   -- [SORT_ORDER]
					       , MAX(BS.[NLEVEL])     AS NLEVEL
					       , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_COMPANY_ID] END)   AS  CHILD_COMPANY_ID  -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					       , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_DIVISION_ID] END)  AS  CHILD_DIVISION_ID -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					       , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_SITE_ID] END)      AS  CHILD_SITE_ID     -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					       , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_PLANT_ID] END)     AS  CHILD_PLANT_ID    -- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					       , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_ID] END)             AS  ALT_ID            -- 대체 BOM 구분자 추가 2017-01-31 KIMCD
					       , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_PRIORITY] END)       AS  ALT_PRIORITY      -- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
					       , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_RATE] END)           AS  ALT_RATE          -- 대체 BOM 비율 추가 2017-01-31 KIMCD
					       , BS.[EFF_START_DATE]    AS EFF_START_DATE-- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					       , MAX(BS.[EFF_END_DATE]) AS EFF_END_DATE-- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					       , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CONCAT_ALT_PRIORITY] END) AS [CONCAT_ALT_PRIORITY] -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					       , @v_proc_name			AS INSERT_ID
					       , GETDATE()				AS INSERT_TIME
					       , @v_proc_name 	        AS UPDATE_ID
					       , GETDATE()				AS UPDATE_TIME
				        FROM ( 
						     SELECT INBS.[COMPANY_ID]
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
								  , INBS.[EFF_START_DATE]    -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
								  , INBS.[EFF_END_DATE]      -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
								  , CASE WHEN INBS.[ALT_PRIORITY] = 1 THEN 'Y' END AS ALT_PRIORITY     -- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
								  , INBS.[ALT_RATE]          -- 대체 BOM 비율 추가 2017-01-31 KIMCD
								  , INBS.[SORT_ORDER]
								  , RANK() OVER ( PARTITION BY INBS.[COMPANY_ID]
								  						     , INBS.[DIVISION_ID]
								  						     , INBS.[SITE_ID]
								  						     , INBS.[PLANT_ID]
								  						     , INBS.[MODEL_ID]
								  						     , INBS.[PARENT_ITEM_ID]
								  						     , INBS.[EFF_START_DATE]  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
								  						     , INBS.[EFF_START_DATE]  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
						       FROM ( 
							        SELECT MMT.[COMPANY_ID]
										 , MMT.[DIVISION_ID]
										 , MMT.[SITE_ID]
										 , MMT.[PLANT_ID]
										 , MMT.[MODEL_ID]
										 , BM.[PARENT_ITEM_ID]
										 , BM.[CHILD_ITEM_ID]
										 , BM.[CHILD_QTY]/BM.[PARENT_QTY] AS CHILD_QTY
										 , CASE WHEN BM.[EFF_START_DATE] > MMT.EFF_START_DATE THEN BM.[EFF_START_DATE] ELSE MMT.EFF_START_DATE END AS EFF_START_DATE -- 2019-07-03 kimcd 일자 변경 상위, 하위 비교하여 큰 값 입력
										 , CASE WHEN BM.[EFF_END_DATE] > MMT.EFF_END_DATE THEN MMT.EFF_END_DATE ELSE BM.[EFF_END_DATE] END AS EFF_END_DATE   -- 2019-07-03 kimcd 일자 변경 상위, 하위 비교하여 작은 값 입력
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
										 	    CASE WHEN BM.[ALT_ID] IS NULL THEN 1
										 		     ELSE
										 			   RANK() OVER (PARTITION BY BM.[COMPANY_ID]
										 									   , BM.[DIVISION_ID]
										 									   , BM.[SITE_ID]
										 									   , BM.[PLANT_ID]
										 									   , BM.[BOM_VERSION_ID]
										 									   , BM.[PARENT_ITEM_ID]
										 									   , BM.[KEY_DATE]
										 									   , BM.[ALT_ID]
										 							    ORDER BY BM.[COMPANY_ID]
										 									   , BM.[DIVISION_ID]
										 									   , BM.[SITE_ID]
										 									   , BM.[PLANT_ID]
										 									   , BM.[BOM_VERSION_ID]
										 									   , BM.[PARENT_ITEM_ID]
										 									   , BM.[KEY_DATE]
										 									   , BM.[ALT_ID]
										 									   , BM.[ALT_PRIORITY])
										 		     END
										   END AS ALT_PRIORITY
										 , CASE WHEN MMT.[ALT_RATE] IS NOT NULL AND BM.[ALT_RATE] IS NOT NULL THEN MMT.[ALT_RATE] * BM.[ALT_RATE]
										 	    WHEN MMT.[ALT_RATE] IS NOT NULL THEN MMT.[ALT_RATE]
										 	   WHEN BM.[ALT_RATE] IS NOT NULL THEN BM.[ALT_RATE]
										   END                   AS ALT_RATE           -- 대체 BOM 비율 추가 2017-01-31 KIMCD
										 , MMT.[SORT_ORDER]
										 , MMT.[CONCAT_ALT_PRIORITY] + ISNULL(REPLICATE('0', 2 - LEN(CONVERT(NVARCHAR(20), CONVERT(INT,BM.[ALT_PRIORITY])))),'') + ISNULL(CONVERT(NVARCHAR(20), CONVERT(INT,BM.[ALT_PRIORITY])),'00') AS  CONCAT_ALT_PRIORITY -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용 [CONCAT_ALT_PRIORITY]
								     FROM  [DBO].[SCM_BOM_M]  BM WITH(NOLOCK)
										 , [DBO].[SCM_ITEM_M] IM WITH(NOLOCK)
										 , [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]  MMT WITH(NOLOCK)
										 , [DBO].[SCM_MODEL_MODEL_TEMP] XMT WITH(NOLOCK) -- 2017-05-15 kimcd add 현재 형성 대상만 
								     WHERE BM.[COMPANY_ID]     = IM.[COMPANY_ID]
								       AND BM.[DIVISION_ID]    = IM.[DIVISION_ID]
								       AND BM.[SITE_ID]        = IM.[SITE_ID]
								       AND BM.[CHILD_ITEM_ID]  = IM.[ITEM_ID]
								       AND BM.[COMPANY_ID]     = MMT.[CHILD_COMPANY_ID]
								       AND BM.[DIVISION_ID]    = MMT.[CHILD_DIVISION_ID]
								       AND BM.[SITE_ID]        = MMT.[CHILD_SITE_ID]
								       AND BM.[PLANT_ID]       = MMT.[CHILD_PLANT_ID]  -- 동일 Plant 우선 전개
								       AND BM.[PARENT_ITEM_ID] = MMT.[CHILD_ITEM_ID]
								       AND BM.[PARENT_ITEM_ID] != BM.[CHILD_ITEM_ID]
								       AND BM.[BOM_VERSION_ID] = 1
								       AND MMT.[COMPANY_ID]    = @COMPANY_ID
								       AND MMT.[DIVISION_ID]   = @DIVISION_ID
								       AND MMT.[SITE_ID]       = @SITE_ID
								       AND MMT.[NLEVEL]        = @LOOP_COUNT
								       AND XMT.[COMPANY_ID]    = MMT.[COMPANY_ID]
								       AND XMT.[DIVISION_ID]   = MMT.[DIVISION_ID]
								       AND XMT.[SITE_ID]       = MMT.[SITE_ID]
								       AND XMT.[PLANT_ID]      = MMT.[PLANT_ID]
								       AND XMT.[MODEL_ID]      = MMT.[MODEL_ID]
								       AND XMT.[COMPANY_ID]    = @COMPANY_ID
								       AND XMT.[DIVISION_ID]   = @DIVISION_ID
								       AND XMT.[SITE_ID]       = @SITE_ID
								       AND BM.EFF_END_DATE     >= CAST(GETDATE()-1 AS DATE)  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
								       AND BM.EFF_START_DATE   < MMT.EFF_END_DATE
								       AND BM.EFF_END_DATE     > MMT.EFF_START_DATE
								    ) INBS
						     ) BS
				    GROUP BY BS.[COMPANY_ID]
						   , BS.[DIVISION_ID]
						   , BS.[SITE_ID]
						   , BS.[PLANT_ID]
						   , BS.[MODEL_ID]
						   , BS.[PARENT_ITEM_ID]
						   , BS.[CHILD_ITEM_ID]
						   , BS.[CONCATENATE_ITEM]
						   , BS.[EFF_START_DATE]  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
				      HAVING MAX(BS.[EFF_END_DATE]) >= CAST(GETDATE()-1 AS DATE) -- 2020-01-03 kimcd 미래 적용일 정보만 입력
				      ) AS S
                   ON T.COMPANY_ID			= S.COMPANY_ID
				  AND T.DIVISION_ID			= S.DIVISION_ID
				  AND T.SITE_ID				= S.SITE_ID
				  AND T.PLANT_ID			= S.PLANT_ID
				  AND T.MODEL_ID			= S.MODEL_ID
				  AND T.CONCATENATE_ITEM	= S.CONCATENATE_ITEM
				  AND T.EFF_START_DATE		= S.EFF_START_DATE
				WHEN MATCHED THEN
				    UPDATE SET
					       PARENT_ITEM_ID			= S.PARENT_ITEM_ID
						 , CHILD_ITEM_ID			= S.CHILD_ITEM_ID
						 , CHILD_QTY				= S.CHILD_QTY
						 , CHILD_UOM				= S.CHILD_UOM
						 , ACCUMULATED_CHILD_QTY	= S.ACCUMULATED_CHILD_QTY
						 , SORT_ORDER				= S.SORT_ORDER
						 , NLEVEL					= S.NLEVEL
						 , CHILD_COMPANY_ID			= S.CHILD_COMPANY_ID
						 , CHILD_DIVISION_ID		= S.CHILD_DIVISION_ID
						 , CHILD_SITE_ID			= S.CHILD_SITE_ID
						 , CHILD_PLANT_ID			= S.CHILD_PLANT_ID
						 , ALT_ID					= S.ALT_ID
						 , ALT_PRIORITY				= S.ALT_PRIORITY
						 , ALT_RATE					= S.ALT_RATE
						 , EFF_END_DATE				= S.EFF_END_DATE
						 , UPDATE_ID 		        = 'PR_MK_SCM_MODEL_EFF_TEMP'
						 , UPDATE_TIME				= S.UPDATE_TIME
						 , CONCAT_ALT_PRIORITY		= S.CONCAT_ALT_PRIORITY
				WHEN NOT MATCHED THEN
					INSERT (
					       [COMPANY_ID]
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
					     , [EFF_START_DATE]        -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					     , [EFF_END_DATE]          -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					     , [CONCAT_ALT_PRIORITY]   -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					     , [INSERT_ID]
					     , [INSERT_TIME]
					     , [UPDATE_ID]
					     , [UPDATE_TIME])
				    VALUES (
					     S.[COMPANY_ID]
					   , S.[DIVISION_ID]
					   , S.[SITE_ID]
					   , S.[PLANT_ID]
					   , S.[MODEL_ID]
					   , S.[PARENT_ITEM_ID]
					   , S.[CHILD_ITEM_ID]
					   , S.[CHILD_QTY]
					   , S.[ACCUMULATED_CHILD_QTY] 
					   , S.[CHILD_UOM]
					   , S.[CONCATENATE_ITEM]
					   , S.[SORT_ORDER]
					   , S.[NLEVEL]
					   , S.[CHILD_COMPANY_ID]      
					   , S.[CHILD_DIVISION_ID]     
					   , S.[CHILD_SITE_ID]         
					   , S.[CHILD_PLANT_ID]        
					   , S.[ALT_ID]                
					   , S.[ALT_PRIORITY]          
					   , S.[ALT_RATE]              
					   , S.[EFF_START_DATE]        
					   , S.[EFF_END_DATE]          
					   , S.[CONCAT_ALT_PRIORITY]   
					   , S.[INSERT_ID]
					   , S.[INSERT_TIME]
					   , S.[UPDATE_ID]
					   , S.[UPDATE_TIME]
					   )
					 ;

				SET @INSERT_CNT = @INSERT_CNT + @@ROWCOUNT; -- 입력 개수 취합 - 동일 Plant


				/*2017-01-31 KIMCD 추가 시작. 동일 Plant 우선, 동일 Site의 전극 Plant 전개. 다른 Site 동일 Division 전개*/
                SET @v_temp1 = 'STEP INSERT ELECTRODE PLANT'
				INSERT INTO [DBO].[SCM_MODEL_COMP_EFFECTIVE_DATE]
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
					, [EFF_START_DATE]        -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					, [EFF_END_DATE]          -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					, [CONCAT_ALT_PRIORITY]   -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					, [INSERT_ID]
					, [INSERT_TIME]
					, [UPDATE_ID]
					, [UPDATE_TIME])
				SELECT BS.[COMPANY_ID]														AS COMPANY_ID
					 , BS.[DIVISION_ID]														AS DIVISION_ID
					 , BS.[SITE_ID]															AS SITE_ID
					 , BS.[PLANT_ID]														AS PLANT_ID
					 , BS.[MODEL_ID]														AS MODEL_ID
					 , BS.[PARENT_ITEM_ID]													AS PARENT_ITEM_ID
					 , BS.[CHILD_ITEM_ID]													AS CHILD_ITEM_ID
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_QTY] END)			AS CHILD_QTY
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ACCUMULATED_CHILD_QTY] END)  AS ACCUMULATED_CHILD_QTY   -- 누적 소요량 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ITEM_UOM] END)			AS ITEM_UOM
					 , BS.[CONCATENATE_ITEM]+'^'+BS.[CHILD_ITEM_ID]							AS CONCATENATE_ITEM
					 , MAX(BS.[SORT_ORDER] + REPLICATE('0', 4 - LEN(BS.[RANK_ORDER])) + CAST( BS.[RANK_ORDER] AS NVARCHAR)) AS SORT_ORDER   -- [SORT_ORDER]
					 , MAX(BS.[NLEVEL])														AS NLEVEL
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_COMPANY_ID] END)   AS  CHILD_COMPANY_ID		-- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_DIVISION_ID] END)  AS  CHILD_DIVISION_ID		-- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_SITE_ID] END)      AS  CHILD_SITE_ID			-- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_PLANT_ID] END)     AS  CHILD_PLANT_ID			-- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_ID] END)             AS  ALT_ID					-- 대체 BOM 구분자 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_PRIORITY] END)       AS  ALT_PRIORITY			-- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_RATE] END)           AS  ALT_RATE				-- 대체 BOM 비율 추가 2017-01-31 KIMCD
					 , BS.[EFF_START_DATE]													AS EFF_START_DATE			-- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					 , MAX(BS.[EFF_END_DATE])												AS EFF_END_DATE				-- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CONCAT_ALT_PRIORITY] END) AS CONCAT_ALT_PRIORITY		-- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					 , @v_proc_name															AS INSERT_ID
					 , GETDATE()															AS INSERT_TIME
					 , @v_proc_name 														AS UPDATE_ID
					 , GETDATE()															AS UPDATE_TIME
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
								, INBS.[EFF_START_DATE]    -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
								, INBS.[EFF_END_DATE]      -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
														, INBS.[EFF_START_DATE]   -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
														, INBS.[EFF_START_DATE]    -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
										--, BM.[EFF_START_DATE]   -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성 -- 2019-07-03 kimcd 일자 조건 막음
										--, BM.[EFF_END_DATE]     -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성 -- 2019-07-03 kimcd 일자 조건 막음
										,CASE WHEN BM.[EFF_START_DATE] > MMT.EFF_START_DATE THEN BM.[EFF_START_DATE] ELSE MMT.EFF_START_DATE END AS EFF_START_DATE -- 2019-07-03 kimcd 일자 변경 상위, 하위 비교하여 큰 값 입력
										,CASE WHEN BM.[EFF_END_DATE] > MMT.EFF_END_DATE THEN MMT.EFF_END_DATE ELSE BM.[EFF_END_DATE] END AS EFF_END_DATE   -- 2019-07-03 kimcd 일자 변경 상위, 하위 비교하여 작은 값 입력
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
										, [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]  MMT WITH(NOLOCK)
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
								AND    BM.EFF_END_DATE   >= CAST(GETDATE()-1 AS DATE)   -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
								-- 2019-07-03 kimcd add date condition 시작
								AND    BM.EFF_START_DATE < MMT.EFF_END_DATE
								AND    BM.EFF_END_DATE   > MMT.EFF_START_DATE
								-- 2019-07-03 kimcd add date condition 끝
								-- AND    IM.ITEM_TYPE       IN ('H', 'P') 
								) INBS
						) BS
				WHERE   NOT EXISTS (SELECT 1
									FROM   [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]  MMT WITH(NOLOCK)
									WHERE  MMT.[COMPANY_ID]       = BS.[COMPANY_ID]
									AND	   MMT.[DIVISION_ID]      = BS.[DIVISION_ID]
									AND    MMT.[SITE_ID]          = BS.[SITE_ID]
									AND    MMT.[PLANT_ID]         = BS.[PLANT_ID]
									AND    MMT.[MODEL_ID]         = BS.[MODEL_ID]
									AND    MMT.[PARENT_ITEM_ID]   = BS.[PARENT_ITEM_ID]
									AND    MMT.[CONCATENATE_ITEM] LIKE BS.[CONCATENATE_ITEM] + '^%'
									-- 2019-07-03 kimcd add date condition 시작
									AND    MMT.EFF_END_DATE       > BS.EFF_START_DATE
									-- 2019-07-03 kimcd add date condition 끝
									-- AND    MMT.[EFF_END_DATE]    >= CAST(GETDATE()-1 AS DATE)  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성 2019-07-03 kimcd 종료된 유효 일자 형성될 수 있어 조건 막음
									)
				GROUP  BY BS.[COMPANY_ID]
						, BS.[DIVISION_ID]
						, BS.[SITE_ID]
						, BS.[PLANT_ID]
						, BS.[MODEL_ID]
						, BS.[PARENT_ITEM_ID]
						, BS.[CHILD_ITEM_ID]
						, BS.[CONCATENATE_ITEM]
						, BS.[EFF_START_DATE]   -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
				HAVING  MAX(BS.[EFF_END_DATE]) >= CAST(GETDATE()-1 AS DATE) -- 2020-01-03 kimcd 미래 적용일 정보만 입력
				;

				SET @INSERT_CNT = @INSERT_CNT + @@ROWCOUNT; -- 전극 Plant 전개 2017-01-31 KIMCD

                SET @v_temp1 = 'STEP INSERT DIVISION SAME'
				INSERT INTO [DBO].[SCM_MODEL_COMP_EFFECTIVE_DATE]
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
					, [EFF_START_DATE]        -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					, [EFF_END_DATE]          -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					, [CONCAT_ALT_PRIORITY]   -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					, [INSERT_ID]
					, [INSERT_TIME]
					, [UPDATE_ID]
					, [UPDATE_TIME])
SELECT X.COMPANY_ID
     , X.DIVISION_ID
	 , X.SITE_ID
	 , X.PLANT_ID
	 , X.MODEL_ID
	 , X.PARENT_ITEM_ID
	 , X.CHILD_ITEM_ID
	 , X.CHILD_QTY
	 , X.ACCUMULATED_CHILD_QTY
	 , X.ITEM_UOM
	 , X.CONCATENATE_ITEM
	 , X.SORT_ORDER
	 , X.NLEVEL
	 , X.CHILD_COMPANY_ID 
	 , X.CHILD_DIVISION_ID
	 , X.CHILD_SITE_ID    
	 , X.CHILD_PLANT_ID   
	 , X.ALT_ID           
	 , X.ALT_PRIORITY     
	 , X.ALT_RATE         
	 , X.EFF_START_DATE
	 , X.EFF_END_DATE
	 , X.CONCAT_ALT_PRIORITY
	 , X.INSERT_ID
	 , X.INSERT_TIME
	 , X.UPDATE_ID
	 , X.UPDATE_TIME
  FROM ( 
				SELECT BS.[COMPANY_ID]														AS COMPANY_ID
					 , BS.[DIVISION_ID]														AS DIVISION_ID
					 , BS.[SITE_ID]															AS SITE_ID
					 , BS.[PLANT_ID]														AS PLANT_ID
					 , BS.[MODEL_ID]														AS MODEL_ID
					 , BS.[PARENT_ITEM_ID]													AS PARENT_ITEM_ID
					 , BS.[CHILD_ITEM_ID]													AS CHILD_ITEM_ID
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_QTY] END)			AS CHILD_QTY
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ACCUMULATED_CHILD_QTY] END)  AS ACCUMULATED_CHILD_QTY   -- 누적 소요량 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ITEM_UOM] END)			AS ITEM_UOM
					 , BS.[CONCATENATE_ITEM]+'^'+BS.[CHILD_ITEM_ID]							AS CONCATENATE_ITEM
					 , MAX(BS.[SORT_ORDER] + REPLICATE('0', 4 - LEN(BS.[RANK_ORDER])) + CAST( BS.[RANK_ORDER] AS NVARCHAR)) AS SORT_ORDER   -- [SORT_ORDER]
					 , MAX(BS.[NLEVEL])														AS NLEVEL
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_COMPANY_ID] END)   AS  CHILD_COMPANY_ID		-- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_DIVISION_ID] END)  AS  CHILD_DIVISION_ID		-- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_SITE_ID] END)      AS  CHILD_SITE_ID			-- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_PLANT_ID] END)     AS  CHILD_PLANT_ID			-- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_ID] END)             AS  ALT_ID					-- 대체 BOM 구분자 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_PRIORITY] END)       AS  ALT_PRIORITY			-- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_RATE] END)           AS  ALT_RATE				-- 대체 BOM 비율 추가 2017-01-31 KIMCD
					 , BS.[EFF_START_DATE]													AS EFF_START_DATE			-- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					 , MAX(BS.[EFF_END_DATE])												AS EFF_END_DATE				-- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CONCAT_ALT_PRIORITY] END) AS [CONCAT_ALT_PRIORITY]	-- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					 , @v_proc_name															AS INSERT_ID
					 , GETDATE()															AS INSERT_TIME
					 , @v_proc_name															AS UPDATE_ID
					 , GETDATE()															AS UPDATE_TIME
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
								, INBS.[EFF_START_DATE]    -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
								, INBS.[EFF_END_DATE]      -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
														, INBS.[EFF_START_DATE]  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
														, INBS.[EFF_START_DATE]  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
										--, BM.[EFF_START_DATE]   -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성 -- 2019-07-03 kimcd 일자 조건 막음
										--, BM.[EFF_END_DATE]     -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성 -- 2019-07-03 kimcd 일자 조건 막음
										,CASE WHEN BM.[EFF_START_DATE] > MMT.EFF_START_DATE THEN BM.[EFF_START_DATE] ELSE MMT.EFF_START_DATE END AS EFF_START_DATE -- 2019-07-03 kimcd 일자 변경 상위, 하위 비교하여 큰 값 입력
										,CASE WHEN BM.[EFF_END_DATE] > MMT.EFF_END_DATE THEN MMT.EFF_END_DATE ELSE BM.[EFF_END_DATE] END AS EFF_END_DATE   -- 2019-07-03 kimcd 일자 변경 상위, 하위 비교하여 작은 값 입력
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
								FROM   [DBO].[SCM_BOM_M]  BM WITH(NOLOCK, INDEX(PK_SCM_BOM_M))   -- 2020-01-03 kimcd index hint 추가
										, [DBO].[SCM_ITEM_M] IM WITH(NOLOCK, INDEX(PK_SCM_ITEM_M))
										, [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]  MMT WITH(NOLOCK, INDEX(PK_SCM_MODEL_COMP_EFFECTIVE_DATE))
										, [DBO].[SCM_MODEL_MODEL_TEMP] XMT WITH(NOLOCK, INDEX(PK_SCM_MODEL_MODEL_TEMP)) -- 2017-05-15 kimcd add 현재 형성 대상만
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
								AND    BM.EFF_END_DATE   >= CAST(GETDATE()-1 AS DATE)  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
								-- 2019-07-03 kimcd add date condition 시작
								AND    BM.EFF_START_DATE < MMT.EFF_END_DATE
								AND    BM.EFF_END_DATE   > MMT.EFF_START_DATE
								-- 2019-07-03 kimcd add date condition 끝
								-- AND    IM.ITEM_TYPE       IN ('H', 'P') 
								) INBS
						) BS
				WHERE   NOT EXISTS (SELECT 1
									FROM   [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]  MMT WITH(NOLOCK)
									WHERE  MMT.[COMPANY_ID]       = BS.[COMPANY_ID]
									AND	   MMT.[DIVISION_ID]      = BS.[DIVISION_ID]
									AND    MMT.[SITE_ID]          = BS.[SITE_ID]
									AND    MMT.[PLANT_ID]         = BS.[PLANT_ID]
									AND    MMT.[MODEL_ID]         = BS.[MODEL_ID]
									AND    MMT.[PARENT_ITEM_ID]   = BS.[PARENT_ITEM_ID]
									AND    MMT.[CONCATENATE_ITEM] LIKE BS.[CONCATENATE_ITEM] + '^%'
									-- 2019-07-03 kimcd add date condition 시작
									AND    MMT.EFF_END_DATE       > BS.EFF_START_DATE
									-- 2019-07-03 kimcd add date condition 끝
									-- AND    MMT.[EFF_END_DATE]    >= CAST(GETDATE()-1 AS DATE)  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성 2019-07-03 kimcd 종료된 유효 일자 형성될 수 있어 조건 막음
									)
				GROUP  BY BS.[COMPANY_ID]
						, BS.[DIVISION_ID]
						, BS.[SITE_ID]
						, BS.[PLANT_ID]
						, BS.[MODEL_ID]
						, BS.[PARENT_ITEM_ID]
						, BS.[CHILD_ITEM_ID]
						, BS.[CONCATENATE_ITEM]
						, BS.[EFF_START_DATE]    -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
				HAVING  MAX(BS.[EFF_END_DATE]) >= CAST(GETDATE()-1 AS DATE) -- 2020-01-03 kimcd 미래 적용일 정보만 입력
       ) X
 --  에러 방지 : PRIMARY KEY 제약 조건 'PK_SCM_MODEL_COMP_EFFECTIVE_DATE'을(를) 위반했습니다.
 WHERE NOT EXISTS ( SELECT 1
					  FROM [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]  MMT WITH(NOLOCK)
					 WHERE MMT.[COMPANY_ID]			= X.[COMPANY_ID]
					   AND MMT.[DIVISION_ID]		= X.[DIVISION_ID]
					   AND MMT.[SITE_ID]			= X.[SITE_ID]
					   AND MMT.[PLANT_ID]			= X.[PLANT_ID]
					   AND MMT.[MODEL_ID]			= X.[MODEL_ID]
					   AND MMT.[CONCATENATE_ITEM]	= X.[CONCATENATE_ITEM]
					   AND MMT.EFF_START_DATE       = X.EFF_START_DATE
			      )
				;

				SET @INSERT_CNT = @INSERT_CNT + @@ROWCOUNT; -- 다른 Plant 동일 Division 2017-01-31 KIMCD


                SET @v_temp1 = 'STEP INSERT SAME SITE OTHER DIVISION'
				INSERT INTO [DBO].[SCM_MODEL_COMP_EFFECTIVE_DATE]
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
					, [EFF_START_DATE]        -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					, [EFF_END_DATE]          -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					, [CONCAT_ALT_PRIORITY]   -- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					, [INSERT_ID]
					, [INSERT_TIME]
					, [UPDATE_ID]
					, [UPDATE_TIME])
SELECT X.COMPANY_ID
     , X.DIVISION_ID
	 , X.SITE_ID
	 , X.PLANT_ID
	 , X.MODEL_ID
	 , X.PARENT_ITEM_ID
	 , X.CHILD_ITEM_ID
	 , X.CHILD_QTY
	 , X.ACCUMULATED_CHILD_QTY
	 , X.ITEM_UOM
	 , X.CONCATENATE_ITEM
	 , X.SORT_ORDER
	 , X.NLEVEL
	 , X.CHILD_COMPANY_ID 
	 , X.CHILD_DIVISION_ID
	 , X.CHILD_SITE_ID    
	 , X.CHILD_PLANT_ID   
	 , X.ALT_ID           
	 , X.ALT_PRIORITY     
	 , X.ALT_RATE         
	 , X.EFF_START_DATE
	 , X.EFF_END_DATE
	 , X.CONCAT_ALT_PRIORITY
	 , X.INSERT_ID
	 , X.INSERT_TIME
	 , X.UPDATE_ID
	 , X.UPDATE_TIME
  FROM ( 
				SELECT BS.[COMPANY_ID]														AS COMPANY_ID
					 , BS.[DIVISION_ID]														AS DIVISION_ID
					 , BS.[SITE_ID]															AS SITE_ID
					 , BS.[PLANT_ID]														AS PLANT_ID
					 , BS.[MODEL_ID]														AS MODEL_ID
					 , BS.[PARENT_ITEM_ID]													AS PARENT_ITEM_ID
					 , BS.[CHILD_ITEM_ID]													AS CHILD_ITEM_ID
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_QTY] END)			AS CHILD_QTY
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ACCUMULATED_CHILD_QTY] END)  AS ACCUMULATED_CHILD_QTY   -- 누적 소요량 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ITEM_UOM] END)			AS ITEM_UOM
					 , BS.[CONCATENATE_ITEM]+'^'+BS.[CHILD_ITEM_ID]                         AS CONCATENATE_ITEM
					 , MAX(BS.[SORT_ORDER] + REPLICATE('0', 4 - LEN(BS.[RANK_ORDER])) + CAST( BS.[RANK_ORDER] AS NVARCHAR)) AS SORT_ORDER   -- [SORT_ORDER]
					 , MAX(BS.[NLEVEL])														AS NLEVEL
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_COMPANY_ID] END)   AS  CHILD_COMPANY_ID		-- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_DIVISION_ID] END)  AS  CHILD_DIVISION_ID		-- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_SITE_ID] END)      AS  CHILD_SITE_ID			-- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CHILD_PLANT_ID] END)     AS  CHILD_PLANT_ID			-- CHILD 품목 조직 정보 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_ID] END)             AS  ALT_ID					-- 대체 BOM 구분자 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_PRIORITY] END)       AS  ALT_PRIORITY			-- 대체 BOM 우선 순위 추가 2017-01-31 KIMCD
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[ALT_RATE] END)           AS  ALT_RATE				-- 대체 BOM 비율 추가 2017-01-31 KIMCD
					 , BS.[EFF_START_DATE]													AS EFF_START_DATE			-- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					 , MAX(BS.[EFF_END_DATE])												AS EFF_END_DATE				-- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
					 , MAX(CASE WHEN BS.[CHILD_ORDER] = 1 THEN BS.[CONCAT_ALT_PRIORITY] END) AS [CONCAT_ALT_PRIORITY]	-- 2020-05-22 kimcd 대치품목의 소요합산단위 구분용
					 , @v_proc_name															AS INSERT_ID
					 , GETDATE()															AS INSERT_TIME
					 , @v_proc_name															AS UPDATE_ID
					 , GETDATE()															AS UPDATE_TIME
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
								, INBS.[EFF_START_DATE]    -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
								, INBS.[EFF_END_DATE]      -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
														, INBS.[EFF_START_DATE]  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
														, INBS.[EFF_START_DATE]  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
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
										--, BM.[EFF_START_DATE]   -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성 -- 2019-07-03 kimcd 일자 조건 막음
										--, BM.[EFF_END_DATE]     -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성 -- 2019-07-03 kimcd 일자 조건 막음
										,CASE WHEN BM.[EFF_START_DATE] > MMT.EFF_START_DATE THEN BM.[EFF_START_DATE] ELSE MMT.EFF_START_DATE END AS EFF_START_DATE -- 2019-07-03 kimcd 일자 변경 상위, 하위 비교하여 큰 값 입력
										,CASE WHEN BM.[EFF_END_DATE] > MMT.EFF_END_DATE THEN MMT.EFF_END_DATE ELSE BM.[EFF_END_DATE] END AS EFF_END_DATE   -- 2019-07-03 kimcd 일자 변경 상위, 하위 비교하여 작은 값 입력
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
								FROM   [DBO].[SCM_BOM_M]  BM WITH(NOLOCK, INDEX(PK_SCM_BOM_M))   -- 2020-01-03 kimcd index hint 추가
										, [DBO].[SCM_ITEM_M] IM WITH(NOLOCK, INDEX(PK_SCM_ITEM_M))
										, [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]  MMT WITH(NOLOCK, INDEX(PK_SCM_MODEL_COMP_EFFECTIVE_DATE))
										, [DBO].[SCM_MODEL_MODEL_TEMP] XMT WITH(NOLOCK, INDEX(PK_SCM_MODEL_MODEL_TEMP)) -- 2017-05-15 kimcd add 현재 형성 대상만
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
								AND    BM.EFF_END_DATE   >= CAST(GETDATE()-1 AS DATE)  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성
								-- 2019-07-03 kimcd add date condition 시작
								AND    BM.EFF_START_DATE < MMT.EFF_END_DATE
								AND    BM.EFF_END_DATE   > MMT.EFF_START_DATE
								-- 2019-07-03 kimcd add date condition 끝
								-- AND    IM.ITEM_TYPE       IN ('H', 'P') 
								) INBS
						) BS
				WHERE   NOT EXISTS (SELECT 1
									FROM   [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]  MMT WITH(NOLOCK)
									WHERE  MMT.[COMPANY_ID]       = BS.[COMPANY_ID]
									AND	   MMT.[DIVISION_ID]      = BS.[DIVISION_ID]
									AND    MMT.[SITE_ID]          = BS.[SITE_ID]
									AND    MMT.[PLANT_ID]         = BS.[PLANT_ID]
									AND    MMT.[MODEL_ID]         = BS.[MODEL_ID]
									AND    MMT.[PARENT_ITEM_ID]   = BS.[PARENT_ITEM_ID]
									AND    MMT.[CONCATENATE_ITEM] LIKE BS.[CONCATENATE_ITEM] + '^%'
									-- 2019-07-03 kimcd add date condition 시작
									AND    MMT.EFF_END_DATE       > BS.EFF_START_DATE
									-- 2019-07-03 kimcd add date condition 끝
									-- AND    MMT.[EFF_END_DATE]    >= CAST(GETDATE()-1 AS DATE)  -- 2018-06-14 kimcd BOM 유효 일자별 정보 형성 2019-07-03 kimcd 종료된 유효 일자 형성될 수 있어 조건 막음
									)
				GROUP  BY BS.[COMPANY_ID]
						, BS.[DIVISION_ID]
						, BS.[SITE_ID]
						, BS.[PLANT_ID]
						, BS.[MODEL_ID]
						, BS.[PARENT_ITEM_ID]
						, BS.[CHILD_ITEM_ID]
						, BS.[CONCATENATE_ITEM]
						, BS.[EFF_START_DATE]
				HAVING  MAX(BS.[EFF_END_DATE]) >= CAST(GETDATE()-1 AS DATE) -- 2020-01-03 kimcd 미래 적용일 정보만 입력
       ) X
 --  에러 방지 : PRIMARY KEY 제약 조건 'PK_SCM_MODEL_COMP_EFFECTIVE_DATE'을(를) 위반했습니다.
 WHERE NOT EXISTS ( SELECT 1
					  FROM [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]  MMT WITH(NOLOCK)
					 WHERE MMT.[COMPANY_ID]			= X.[COMPANY_ID]
					   AND MMT.[DIVISION_ID]		= X.[DIVISION_ID]
					   AND MMT.[SITE_ID]			= X.[SITE_ID]
					   AND MMT.[PLANT_ID]			= X.[PLANT_ID]
					   AND MMT.[MODEL_ID]			= X.[MODEL_ID]
					   AND MMT.[CONCATENATE_ITEM]	= X.[CONCATENATE_ITEM]
					   AND MMT.EFF_START_DATE       = X.EFF_START_DATE
			      )
				;

				SET @INSERT_CNT = @INSERT_CNT + @@ROWCOUNT; -- 다른 Plant 동일 Site 다른 Division 2017-01-31 KIMCD

				/*2017-01-31 KIMCD 추가 종료. 동일 Plant 우선, 동일 Site의 전극 Plant 전개. 다른 Site 동일 Division 전개*/

				IF @INSERT_CNT > 0
					SET @LOOP_COUNT = @LOOP_COUNT+1
				ELSE
					SET @LOOP_FLAG = 'N'

			END -- WHILE @LOOP_FLAG = 'Y'
                
			SET @v_temp1 = 'STEP UPDATE LEAF NOOD'
			--UPDATE MCT
			--SET    [LEAF_LEVEL] = 'Y'
			--FROM   [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE] MCT
			---- 2018-02-06 갱신 조건 추가 kimcd 시작
			--WHERE  MCT.COMPANY_ID  = @COMPANY_ID
			--AND	   MCT.DIVISION_ID = @DIVISION_ID
			--AND	   MCT.SITE_ID     = @SITE_ID
			--AND    EXISTS      (SELECT 1 
			--					FROM   [DBO].[SCM_MODEL_MODEL_TEMP] MMT WITH(NOLOCK)
			--					WHERE  MMT.[COMPANY_ID]  = MCT.[COMPANY_ID]
			--					AND	   MMT.[DIVISION_ID] = MCT.[DIVISION_ID]
			--					AND	   MMT.[SITE_ID]     = MCT.[SITE_ID]
			--					AND	   MMT.[PLANT_ID]    = MCT.[PLANT_ID]
			--					AND	   MMT.[MODEL_ID]    = MCT.[MODEL_ID])
			---- 2018-02-06 갱신 조건 추가 kimcd 끝
			--AND    NOT EXISTS ( SELECT 1
			--					FROM   [dbo].[SCM_MODEL_COMP_EFFECTIVE_DATE]  AS CT WITH(NOLOCK)
			--					WHERE  CT.[COMPANY_ID]          = MCT.[COMPANY_ID]
			--					AND    CT.[DIVISION_ID]         = MCT.[DIVISION_ID]
			--					AND    CT.[SITE_ID]             = MCT.[SITE_ID]
			--					AND    CT.[PLANT_ID]            = MCT.[PLANT_ID]
			--					AND    CT.[MODEL_ID]            = MCT.[MODEL_ID]
			--					AND    CT.[CONCATENATE_ITEM] LIKE MCT.[CONCATENATE_ITEM] + '^%' ) ;

			FETCH NEXT FROM C_SITE INTO @COMPANY_ID,
										@DIVISION_ID,
										@SITE_ID

        END  -- WHILE @@FETCH_STATUS = 0  C_SITE

        CLOSE C_SITE;
        DEALLOCATE C_SITE;   -- 메모리 해제

        -- COMMIT TRANSACTION; 2020-01-02 kimcd transaction begin, commit, rollback 제거 - 속도 개선용

		-- STEP INSERT SAME PLANT에서 UPDATE한 BOM에 해당하는 EFF_START_DATE, EFF_END_DATE 조건별 데이터 정리
		DELETE T
			FROM [DBO].[SCM_MODEL_COMP_EFFECTIVE_DATE] as T with(nolock)
				JOIN ( 
					SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CONCATENATE_ITEM, EFF_START_DATE, EFF_END_DATE
						FROM [DBO].[SCM_MODEL_COMP_EFFECTIVE_DATE] as S with(nolock)
						WHERE update_id = 'PR_MK_SCM_MODEL_EFF_TEMP'
					) AS S
			ON T.COMPANY_ID		= S.COMPANY_ID
			AND T.DIVISION_ID		= S.DIVISION_ID
			AND T.SITE_ID			= S.SITE_ID
			AND T.PLANT_ID		= S.PLANT_ID
			AND T.MODEL_ID		= S.MODEL_ID
			AND T.CONCATENATE_ITEM = S.CONCATENATE_ITEM
			AND T.EFF_START_DATE	> S.EFF_START_DATE
			AND T.EFF_END_DATE	<= S.EFF_END_DATE

		SET @v_temp1 = 'STEP END PROCEDURE'
        EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   @v_count, @v_temp1, '############### End of procedure ###############', NULL, @sysdate


    END TRY

	BEGIN CATCH

	   -- ROLLBACK TRANSACTION; 2020-01-02 kimcd transaction begin, commit, rollback 제거 - 속도 개선용
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
