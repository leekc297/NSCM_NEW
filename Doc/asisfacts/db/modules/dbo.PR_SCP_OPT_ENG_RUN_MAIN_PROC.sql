

CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_RUN_MAIN_PROC]
     @P_PLAN_ID     NVARCHAR(50)
AS 
BEGIN
    --2025.02.05 Y.S.H Initial Release
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
    DECLARE @V_PROGRAM_NAME       NVARCHAR(150) = 'PR_SCP_OPT_ENG_RUN_MAIN_PROC';
    DECLARE @V_PLAN_ID            NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT       NVARCHAR(1000);
    DECLARE @V_DETAIL_START_DATE  DATETIME;
    DECLARE @V_DETAIL_END_DATE    DATETIME;
    ------------------------------------------------------------------------  
    DECLARE @V_DIVISION_ID         NVARCHAR(20);
    DECLARE @V_GROUP_ID            NVARCHAR(20);
    DECLARE @V_PLAN_START_YYYYMMDD NVARCHAR(8);
    DECLARE @V_PLAN_END_YYYYMMDD   NVARCHAR(8);

    DECLARE @V_SCP_PLAN_DATE   NVARCHAR(8);
    DECLARE @V_SCP_PLAN_TYPE   NVARCHAR(8);
    DECLARE @V_SHIP_PLAN_SEQ    NVARCHAR(8);

	------------------------------------------------------------------------
    -- LOG DELETE
    -- 2025.05.21 Philsu Park: Status, Status Detail은 서버 프로그램에서 처리하기 때문에 로그 생성 및 기존 실행로그 삭제 하는 부분 주석처리.
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
       
        SELECT @V_SCP_PLAN_DATE   = A.PLAN_START_YYYYMMDD 
              ,@V_SCP_PLAN_TYPE   = A.PLAN_TYPE 
              ,@V_SHIP_PLAN_SEQ    = A.PLAN_SEQ 
        FROM  (SELECT TOP 1 DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
               FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
               WHERE  DIVISION_ID          = @V_DIVISION_ID
               AND    PLAN_START_YYYYMMDD  = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 해당 주 월요일 YYYYMMDD
               ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC
              ) A  


        -- PLAN_ID 별 LOOKUP SETTING 확인을 위한 조치 /선웅 선임님 요청/20250514/김태현 선임
        DELETE FROM SCP_OPT_ENG_LOOKUP_SN WHERE PLAN_ID =@V_PLAN_ID

        INSERT INTO SCP_OPT_ENG_LOOKUP_SN (PLAN_ID,LOOKUP_TYPE,SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,SEGMENT5,SEGMENT6,SEGMENT7,SEGMENT8,SEGMENT9,SEGMENT10,DISPLAY_SEQ,VALID_YN,DESCRIPTION,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7
                                          ,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15)
        SELECT @V_PLAN_ID,LOOKUP_TYPE,SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,SEGMENT5,SEGMENT6,SEGMENT7,SEGMENT8,SEGMENT9,SEGMENT10,DISPLAY_SEQ,VALID_YN,DESCRIPTION,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7
              ,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
        FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

        -- 2025.06.19 TAEHYUN KIM:FROZEN MASTER 관리
        EXEC PR_SCP_OPT_ENG_INPUT_FROZEN_MASTER     @V_PLAN_ID
        -- 2025.05.30 Philsu Park: Model List Line Assign 기준으로 호출.
        -- 2025.06.11 Philsu Park: 재고 전환 Procedure 추가.
        EXEC PR_SCP_OPT_ENG_INPUT_DELETE_PROC         @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD
        EXEC PR_SCP_OPT_ENG_INPUT_PLAN_MASTER         @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD
        EXEC PR_SCP_OPT_ENG_INPUT_BUCKET              @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD
        EXEC PR_SCP_OPT_ENG_INPUT_ASSIGN_MODEL_LIST   @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD       
        --EXEC PR_SCP_OPT_ENG_INPUT_MODEL_LIST         @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD       
        EXEC PR_SCP_OPT_ENG_INPUT_RESOURCE            @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD
        EXEC PR_SCP_OPT_ENG_INPUT_EVERY_DAY_CAL       @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD  
        EXEC PR_SCP_OPT_ENG_INPUT_PARAMETER           @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD
        EXEC PR_SCP_OPT_ENG_INPUT_DEMAND              @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD
        EXEC PR_SCP_OPT_ENG_INPUT_BOM                 @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD 
        EXEC PR_SCP_OPT_ENG_INPUT_INCOMING_STOCK      @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD 
        EXEC PR_SCP_OPT_ENG_INPUT_STOCK_SWITCHING     @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD 
        EXEC PR_SCP_OPT_ENG_INPUT_SCHEDULED_MOVE      @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD
        EXEC PR_SCP_OPT_ENG_INPUT_ITEM_SITE           @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD 
        EXEC PR_SCP_OPT_ENG_INPUT_BOD                 @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD
        EXEC PR_SCP_OPT_ENG_INPUT_ROUTING_RESOURCE    @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD
        EXEC PR_SCP_OPT_ENG_INPUT_ROUTING             @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD 
        EXEC PR_SCP_OPT_ENG_INPUT_COBY_PROD_ITEM      @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD 
        EXEC PR_SCP_OPT_ENG_INPUT_ITEM_BOM_ROUTING    @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD
		EXEC PR_SCP_OPT_ENG_INPUT_SAFETY_STOCK        @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD 
        EXEC PR_SCP_OPT_ENG_INPUT_FROZEN_PLAN         @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD
		EXEC PR_SCP_OPT_ENG_INPUT_HORIZON_CAL         @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD 
        EXEC PR_SCP_OPT_ENG_INPUT_AFTER_CORRECT       @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD 
		------------------------------------------------------------------------





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
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC;
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
