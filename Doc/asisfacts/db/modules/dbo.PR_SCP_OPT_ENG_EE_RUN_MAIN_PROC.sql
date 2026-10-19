

CREATE   PROCEDURE [dbo].[PR_SCP_OPT_ENG_EE_RUN_MAIN_PROC]
     @P_PLAN_ID     NVARCHAR(50)
AS 
BEGIN
    --2025.02.05 Y.S.H Initial Release
    -- 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영.
	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET ANSI_WARNINGS OFF;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- Set Prameter
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME       NVARCHAR(150) = 'PR_SCP_OPT_ENG_EE_RUN_MAIN_PROC';
    DECLARE @V_PLAN_ID            NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT       NVARCHAR(1000);
    DECLARE @V_DETAIL_START_DATE  DATETIME;
    DECLARE @V_DETAIL_END_DATE    DATETIME;
    ------------------------------------------------------------------------  
    DECLARE @V_DIVISION_ID         NVARCHAR(20);
    DECLARE @V_GROUP_ID            NVARCHAR(20);
    DECLARE @V_PLAN_START_YYYYMMDD NVARCHAR(8);
    DECLARE @V_PLAN_END_YYYYMMDD   NVARCHAR(8);
	
    DECLARE @T_SCP_PLAN        optTableType_SCP_PLAN; -- SCP Plan 정보 저장용 UserType Table

	------------------------------------------------------------------------
    -- LOG DELETE
    ------------------------------------------------------------------------
    --DELETE FROM SCP_OPT_ENG_ENGINE_RUN_STATUS_SN        WHERE PLAN_ID = @V_PLAN_ID
    --DELETE FROM SCP_OPT_ENG_ENGINE_RUN_STATUS_DETAIL_SN WHERE PLAN_ID = @V_PLAN_ID
    DELETE FROM SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N_SN   WHERE PLAN_ID = @V_PLAN_ID
	-- Step 1. ENGINE_RUN_STATUS 생성
	------------------------------------------------------------------------
	--EXEC PR_SCP_OPT_ENG_LOG_STATUS_PROC 'I',@V_PLAN_ID,'N','N','N','N','N','N','N','N',NULL,NULL	
    ------------------------------------------------------------------------  
    -- Step 2. ENGINE_RUN_STATUS_DETAIL 생성
	------------------------------------------------------------------------
	--EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'I',@V_PLAN_ID,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	------------------------------------------------------------------------  
    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
	------------------------------------------------------------------------
	EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID
    
    ------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
	--BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------  
	BEGIN TRY
    ------------------------------------------------------------------------
    -- INPUT Start
    ------------------------------------------------------------------------
    --EXEC PR_SCP_OPT_ENG_LOG_STATUS_PROC 'U',@V_PLAN_ID,NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
    ------------------------------------------------------------------------
    SELECT @V_DETAIL_START_DATE = GETDATE()
    ------------------------------------------------------------------------
	--EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,@V_DETAIL_START_DATE,NULL,NULL,'RUNNING'
    ------------------------------------------------------------------------
            
        --SELECT  @V_DIVISION_ID         = DIVISION_ID
        --       ,@V_GROUP_ID            = PLAN_TYPE_CODE
        --       ,@V_PLAN_START_YYYYMMDD = PLAN_START_YYYYMMDD
        --       ,@V_PLAN_END_YYYYMMDD   = CONVERT(NVARCHAR(8),DATEADD(DAY,1,PLAN_END_YYYYMMDD),112)
        --FROM    SCP_OPT_ENG_SCP_PLAN_ID_M_SN WITH(NOLOCK)
        --WHERE   1=1
        --AND     PLAN_ID = @V_PLAN_ID


        --SELECT   @V_DIVISION_ID         = PM.DIVISION_ID         
        --        ,@V_GROUP_ID            = PGM.OPMZ_PLAN_GR_NAME  
        --        ,@V_PLAN_START_YYYYMMDD = PM.PLAN_START_YYYYMMDD 
        --        ,@V_PLAN_END_YYYYMMDD   = CONVERT(NVARCHAR(8),DATEADD(DAY,1,PM.PLAN_END_YYYYMMDD),112) 
        --FROM     SCP_OPMZ_PLAN_M PM WITH(NOLOCK)
        --    INNER JOIN SCP_OPMZ_PLAN_GR_M PGM WITH(NOLOCK)
        --        ON PM.OPMZ_PLAN_GR_ID = PGM.OPMZ_PLAN_GR_ID
        --WHERE   PM.OPMZ_PLAN_ID = @V_PLAN_ID

        SELECT  @V_DIVISION_ID         = A.DIVISION_ID
               ,@V_GROUP_ID            = A.PLAN_GROUP_ID
               ,@V_PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
               ,@V_PLAN_END_YYYYMMDD   = A.PLAN_END_YYYYMMDD
        FROM(
             SELECT PM.DIVISION_ID          AS DIVISION_ID
                   ,PGM.OPMZ_PLAN_GR_NAME   AS PLAN_GROUP_ID
                   ,PM.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
                   ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,PM.PLAN_END_YYYYMMDD),112)  AS PLAN_END_YYYYMMDD
             FROM     SCP_OPMZ_PLAN_M PM WITH(NOLOCK)
                 INNER JOIN SCP_OPMZ_PLAN_GR_M PGM WITH(NOLOCK)
                     ON PM.OPMZ_PLAN_GR_ID = PGM.OPMZ_PLAN_GR_ID
             WHERE   PM.OPMZ_PLAN_ID = @V_PLAN_ID
             UNION
             SELECT  DIVISION_ID             AS DIVISION_ID
                    ,PLAN_TYPE_CODE          AS PLAN_GROUP_ID
                    ,PLAN_START_YYYYMMDD     AS PLAN_START_YYYYMMDD
                    ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,PLAN_END_YYYYMMDD),112) AS PLAN_END_YYYYMMDD
             FROM    SCP_OPT_ENG_SCP_PLAN_ID_M_SN WITH(NOLOCK)
             WHERE   1=1
             AND     PLAN_ID = @V_PLAN_ID
        ) A
        
		-- 사업부별 SCP 최신 Plan 정보
		INSERT INTO @T_SCP_PLAN
		SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.PLAN_SEQ 
        FROM  (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
		            , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_TYPE_ORDER DESC, PLAN_SEQ DESC ) AS PLAN_RANK
               FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
			   -- 전극 Division 에 해당하는 사업부 확인
               WHERE  DIVISION_ID          IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WITH(NOLOCK)
												WHERE  VALID_YN = 'Y'
												AND    ATTRIBUTE3 <> 'EE'
												AND    ATTRIBUTE4 = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID) -- 전극 Division 변수
			                                  )
               AND    PLAN_START_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -14, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 전주 월요일 YYYYMMDD
               AND    PLAN_START_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD,  -7, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 당주 월요일 YYYYMMDD
              ) A   
        WHERE PLAN_RANK = 1
        ;

        -- 2025.05.15 Philsu Park: 동일 Plan_Id 로 존재하는 데이터 지우고 수행 시점 기준으로 돌려야 함.
        DELETE 
        FROM    SCP_OPT_ENG_LOOKUP_SN
        WHERE   PLAN_ID = @V_PLAN_ID
        ;

        -- PLAN_ID 별 LOOKUP SETTING 확인을 위한 조치 /선웅 선임님 요청/20250514/김태현 선임
        INSERT INTO SCP_OPT_ENG_LOOKUP_SN 
                ( PLAN_ID,      LOOKUP_TYPE
                , SEGMENT1,     SEGMENT2,       SEGMENT3,       SEGMENT4,       SEGMENT5,       SEGMENT6,   SEGMENT7,   SEGMENT8,   SEGMENT9,   SEGMENT10
                , DISPLAY_SEQ,  VALID_YN,       DESCRIPTION,    CREATED_BY,     CREATION_DATE,  LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1,   ATTRIBUTE2,     ATTRIBUTE3,     ATTRIBUTE4,     ATTRIBUTE5,     ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                , ATTRIBUTE11,  ATTRIBUTE12,    ATTRIBUTE13,    ATTRIBUTE14,    ATTRIBUTE15
                )
            SELECT @V_PLAN_ID,LOOKUP_TYPE
                , SEGMENT1,     SEGMENT2,       SEGMENT3,       SEGMENT4,       SEGMENT5,       SEGMENT6,   SEGMENT7,   SEGMENT8,   SEGMENT9,   SEGMENT10
                , DISPLAY_SEQ,  VALID_YN,       DESCRIPTION,    CREATED_BY,     CREATION_DATE,  LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1,   ATTRIBUTE2,     ATTRIBUTE3,     ATTRIBUTE4,     ATTRIBUTE5,     ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                , ATTRIBUTE11,  ATTRIBUTE12,    ATTRIBUTE13,    ATTRIBUTE14,    ATTRIBUTE15
            FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
            WHERE LOOKUP_TYPE LIKE N'%SCP_OPT%'

        EXEC PR_SCP_OPT_ENG_EE_INPUT_FROZEN_MASTER    @V_PLAN_ID
        EXEC PR_SCP_OPT_ENG_INPUT_DELETE_PROC           @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD -- DELETE Proc 는 일반 사업부와 같이 사용
        EXEC PR_SCP_OPT_ENG_EE_INPUT_PLAN_MASTER        @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD, @T_SCP_PLAN
        EXEC PR_SCP_OPT_ENG_EE_INPUT_BUCKET             @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD
        EXEC PR_SCP_OPT_ENG_EE_INPUT_ASSIGN_MODEL_LIST  @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD               -- NLF / BOM 정보 처리 추가 고민???    
        -- EXEC PR_SCP_OPT_ENG_EE_INPUT_MODEL_LIST         @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD               -- NLF / BOM 정보 처리 추가 고민???    
        EXEC PR_SCP_OPT_ENG_EE_INPUT_RESOURCE           @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD               -- 1차 수정 완료
        EXEC PR_SCP_OPT_ENG_EE_INPUT_EVERY_DAY_CAL      @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD               -- 1차 수정 완료
        EXEC PR_SCP_OPT_ENG_EE_INPUT_PARAMETER          @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD  
        EXEC PR_SCP_OPT_ENG_EE_INPUT_BOM_ELEC           @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD               -- 위치이동
        EXEC PR_SCP_OPT_ENG_EE_INPUT_DEMAND             @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD, @T_SCP_PLAN  -- 1차 수정 완료
        EXEC PR_SCP_OPT_ENG_EE_INPUT_BOM                @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD               -- 1차 수정 완료
        --EXEC PR_SCP_OPT_ENG_EE_INPUT_BOM_ELEC           @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD               -- 1차 수정 완료
        EXEC PR_SCP_OPT_ENG_EE_INPUT_INCOMING_STOCK     @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD               -- 1차 수정 : Cell Plant 재고를 전극으로 처리 필요
        EXEC PR_SCP_OPT_ENG_EE_INPUT_SCHEDULED_MOVE     @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD, @T_SCP_PLAN  -- 1차 수정 완료
        EXEC PR_SCP_OPT_ENG_EE_INPUT_ITEM_SITE          @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD               -- 1차 수정 완료
        EXEC PR_SCP_OPT_ENG_EE_INPUT_BOD                @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD, @T_SCP_PLAN  -- 1차 수정 완료
        EXEC PR_SCP_OPT_ENG_EE_INPUT_ROUTING_RESOURCE   @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD               -- 1차 수정 완료
        EXEC PR_SCP_OPT_ENG_EE_INPUT_ROUTING            @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD               -- 1차 수정 완료
        EXEC PR_SCP_OPT_ENG_EE_INPUT_ITEM_BOM_ROUTING   @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD, @T_SCP_PLAN  -- 1차 수정 완료
        EXEC PR_SCP_OPT_ENG_EE_INPUT_SITE_MOVE          @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD
		EXEC PR_SCP_OPT_ENG_EE_INPUT_SAFETY_STOCK       @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD               -- 1차 수정 완료
        EXEC PR_SCP_OPT_ENG_EE_INPUT_FROZEN_PLAN        @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD, @T_SCP_PLAN  -- 1차 수정 완료
		EXEC PR_SCP_OPT_ENG_EE_INPUT_HORIZON_CAL        @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD               -- 1차 수정 완료
        EXEC PR_SCP_OPT_ENG_EE_INPUT_AFTER_CORRECT      @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD               -- 1차 수정 완료
		------------------------------------------------------------------------
		-- 현재 미사용 Procedure
		------------------------------------------------------------------------
		--EXEC PR_SCP_OPT_ENG_EE_INPUT_COBY_PROD_ITEM @V_PLAN_ID
		------------------------------------------------------------------------
		-- EXEC PR_SCP_OPT_ENG_EE_INPUT_HISTORY : INPUT의 속도와 결과에 영향주지 않고 별도 실행시킬 방법????


    ------------------------------------------------------------------------
    -- INPUT END
    ------------------------------------------------------------------------
    --EXEC PR_SCP_OPT_ENG_LOG_STATUS_PROC 'U',@V_PLAN_ID,NULL,NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL
    ------------------------------------------------------------------------
    SELECT @V_DETAIL_END_DATE = GETDATE()
    ------------------------------------------------------------------------
	--EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,NULL,@V_DETAIL_END_DATE,NULL,'COMPLETED'
    ------------------------------------------------------------------------    
	END TRY

	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_EE_RUN_MAIN_PROC;
	------------------------------------------------------------------------
      -- ERROR LOG
	------------------------------------------------------------------------
        SET @V_MESSAGE_TEXT = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'ERROR',NULL,@V_MESSAGE_TEXT,NULL,@V_PLAN_ID
        ------------------------------------------------------------------------
        RAISERROR(@V_MESSAGE_TEXT, 16,1)
    END CATCH
	------------------------------------------------------------------------

	------------------------------------------------------------------------
    -- 종료 LOG
    ------------------------------------------------------------------------
    IF @V_MESSAGE_TEXT IS NULL 
    ------------------------------------------------------------------------
	    EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'END',NULL,NULL,NULL,@V_PLAN_ID
    ------------------------------------------------------------------------
  END;
