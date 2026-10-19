CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_RUN_MAIN_PROC_BATCH]
     @P_PLAN_ID     NVARCHAR(50)
AS
BEGIN
    ------------------------------------------------------------------------
    -- Procedure 기본조건.
    ------------------------------------------------------------------------
    SET XACT_ABORT ON;
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET ANSI_WARNINGS OFF;
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- Set Parameter
    ------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME       NVARCHAR(150) = 'PR_SCP_OPT_ENG_RUN_MAIN_PROC_BATCH';
    DECLARE @V_PLAN_ID            NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT       NVARCHAR(1000);
    DECLARE @V_DETAIL_START_DATE  DATETIME;
    DECLARE @V_DETAIL_END_DATE    DATETIME;
    ------------------------------------------------------------------------
    DECLARE @V_DIVISION_ID         NVARCHAR(20);
    DECLARE @V_GROUP_ID            NVARCHAR(20);

    DECLARE @V_PLAN_TYPE           NVARCHAR(8);      -- 계획타입 (PR/MA/FN)

    DECLARE @V_PLAN_START_YYYYMMDD NVARCHAR(8);
    DECLARE @V_PLAN_END_YYYYMMDD   NVARCHAR(8);

    DECLARE @V_SEP_POS             INT;              -- PLAN_ID 첫 '_' 위치(날짜 구분자)
    DECLARE @V_PLAN_BASE_YMD       NVARCHAR(8);      -- 계획수립일자 (PLAN_ID 접두)

    DECLARE @V_SCP_PLAN_DATE   NVARCHAR(8);
    DECLARE @V_SCP_PLAN_TYPE   NVARCHAR(8);
    DECLARE @V_SHIP_PLAN_SEQ   NVARCHAR(8);

    ------------------------------------------------------------------------
    -- LOG DELETE
    ------------------------------------------------------------------------
    DELETE FROM SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N_SN   WHERE PLAN_ID = @V_PLAN_ID
    -- Step 1. ENGINE_RUN_STATUS 생성
    EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

    ------------------------------------------------------------------------
    BEGIN TRY
    ------------------------------------------------------------------------
    SELECT @V_DETAIL_START_DATE = GETDATE()

        --====================================================================
        --Batch PLAN_ID Rule :
        --    PLAN_ID = {계획수립일자}_{DIVISION_ID}_{PLAN_TYPE}   예) 20260819_40_PR
        --                                                              20260819_81_UC_FN
        --====================================================================

        SELECT  @V_DIVISION_ID         = DIVISION_ID
               ,@V_PLAN_TYPE           = PLAN_TYPE_CODE
               ,@V_PLAN_START_YYYYMMDD = PLAN_START_YYYYMMDD
               ,@V_PLAN_END_YYYYMMDD   = CONVERT(NVARCHAR(8), DATEADD(DAY, 1, PLAN_END_YYYYMMDD), 112)  -- PET는 exclusive(종료일 미포함)이므로 +1일 보정
        FROM    SCP_OPT_ENG_SCP_PLAN_ID_M_SN WITH(NOLOCK)
        WHERE   PLAN_ID = @V_PLAN_ID;

        --====================================================================
        -- 2026.08.19 JCH : 계획그룹키 조합 변경
        --   @V_GROUP_ID = {DIVISION_ID}_{PLAN_TYPE}   예) 81_FN, 40_PR, 81_UC_MA
        --   PLAN_TYPE_CODE는 계획그룹명이 아니므로 그대로 쓰면 그룹키 기준 LOOKUP 조회가 0건이 됨.
        --   이 그룹키 기준으로 LOOKUP 기준정보(BUCKETS/GOALS/OBJECTIVES/PHASES 등) 사전 등록 필요.
        --   계획 대상은 사업부 전체이며, 계획그룹키는 LOOKUP 기준정보 조회 용도로만 사용한다.
        --====================================================================
        SET @V_GROUP_ID = @V_DIVISION_ID + '_' + @V_PLAN_TYPE;

        --====================================================================
        -- PLAN_ID 형식 검증 : {계획수립일자}_{DIVISION_ID}_{PLAN_TYPE} 조합 일치 확인
        --====================================================================
        IF @V_DIVISION_ID IS NOT NULL
        BEGIN
            IF CHARINDEX('_', @V_PLAN_ID) = 0
            BEGIN
                SET @V_MESSAGE_TEXT = N'PLAN_ID 형식 오류. {계획수립일자}_{DIVISION_ID}_{PLAN_TYPE} 이어야 함. 입력=' + @V_PLAN_ID;
                RAISERROR(@V_MESSAGE_TEXT, 16, 1);
            END

            SET @V_SEP_POS         = CHARINDEX('_', @V_PLAN_ID);                       -- 첫 '_' = 날짜 구분자
            SET @V_PLAN_BASE_YMD   = LEFT(@V_PLAN_ID, @V_SEP_POS - 1);

            IF @V_PLAN_ID <> (@V_PLAN_BASE_YMD + '_' + @V_DIVISION_ID + '_' + @V_PLAN_TYPE)
            BEGIN
                SET @V_MESSAGE_TEXT = N'PLAN_ID 와 등록내용 불일치. PLAN_ID=' + @V_PLAN_ID
                                      + N' / 등록 DIVISION=' + @V_DIVISION_ID + N', TYPE=' + @V_PLAN_TYPE
                                      + N' → 기대값=' + @V_PLAN_BASE_YMD + '_' + @V_DIVISION_ID + '_' + @V_PLAN_TYPE;
                RAISERROR(@V_MESSAGE_TEXT, 16, 1);
            END

            IF ISDATE(@V_PLAN_BASE_YMD) = 0
            BEGIN
                SET @V_MESSAGE_TEXT = N'계획수립일자 부분이 날짜가 아님. 입력=' + @V_PLAN_BASE_YMD;
                RAISERROR(@V_MESSAGE_TEXT, 16, 1);
            END
        END

        IF @V_PLAN_TYPE IS NOT NULL AND @V_PLAN_TYPE NOT IN ('PR','MA','FN')
        BEGIN
            SET @V_MESSAGE_TEXT = N'지원하지 않는 계획타입. PR/MA/FN 만 허용. 입력=' + @V_PLAN_TYPE;
            RAISERROR(@V_MESSAGE_TEXT, 16, 1);
        END

        --====================================================================
        -- 계획ID 미등록 시 즉시 오류 처리 (미등록 상태로 진행하면 전체 INPUT이 0건으로 생성됨)
        --====================================================================
        IF @V_PLAN_START_YYYYMMDD IS NULL OR @V_PLAN_END_YYYYMMDD IS NULL
        BEGIN
            SET @V_MESSAGE_TEXT = N'계획ID 미등록. OPTENG_SCP.dbo.SCP_OPT_ENG_SCP_PLAN_ID_M 에 먼저 등록할 것. PLAN_ID='
                                  + @V_PLAN_ID + N', DIVISION=' + @V_DIVISION_ID;
            RAISERROR(@V_MESSAGE_TEXT, 16, 1);
        END

        IF @V_PLAN_START_YYYYMMDD >= @V_PLAN_END_YYYYMMDD
        BEGIN
            SET @V_MESSAGE_TEXT = N'계획기간 오류. START=' + @V_PLAN_START_YYYYMMDD + N' END(excl)=' + @V_PLAN_END_YYYYMMDD;
            RAISERROR(@V_MESSAGE_TEXT, 16, 1);
        END

        --====================================================================
        -- 2026.08.19 JCH : SCP 버전은 PLAN_ID가 지정한 계획타입으로 고정
        --====================================================================
        SELECT @V_SCP_PLAN_DATE  = A.PLAN_START_YYYYMMDD
              ,@V_SCP_PLAN_TYPE  = A.PLAN_TYPE_CODE
              ,@V_SHIP_PLAN_SEQ  = 1 --A.PLAN_SEQ
        FROM  SCP_OPT_ENG_SCP_PLAN_ID_M_SN A
        WHERE PLAN_ID =  @V_PLAN_ID
        ;

        IF @V_SCP_PLAN_DATE IS NULL
        BEGIN
            -- SCP 버전이 없어도 엔진 입력 생성은 가능하므로 경고만 남기고 진행
            SET @V_MESSAGE_TEXT = N'[WARN] 해당 주차 SCP 버전 없음. DIVISION=' + @V_DIVISION_ID
                                  + N', TYPE=' + @V_PLAN_TYPE + N', PLAN_START=' + @V_PLAN_START_YYYYMMDD;
            EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'WARN',NULL,@V_MESSAGE_TEXT,NULL,@V_PLAN_ID
            SET @V_MESSAGE_TEXT = NULL;   -- 종료 LOG 분기에 영향 주지 않도록 초기화
        END

        --====================================================================
        -- PLAN_ID별 LOOKUP 스냅샷 생성
        --====================================================================
        DELETE FROM SCP_OPT_ENG_LOOKUP_SN WHERE PLAN_ID = @V_PLAN_ID

        INSERT INTO SCP_OPT_ENG_LOOKUP_SN (PLAN_ID,LOOKUP_TYPE,SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,SEGMENT5,SEGMENT6,SEGMENT7,SEGMENT8,SEGMENT9,SEGMENT10,DISPLAY_SEQ,VALID_YN,DESCRIPTION,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7
                                          ,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15)
        SELECT @V_PLAN_ID,LOOKUP_TYPE,SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,SEGMENT5,SEGMENT6,SEGMENT7,SEGMENT8,SEGMENT9,SEGMENT10,DISPLAY_SEQ,VALID_YN,DESCRIPTION,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7
              ,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
        FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

        --====================================================================
        -- INPUT 빌더 호출 (호출 순서는 PR_SCP_OPT_ENG_RUN_MAIN_PROC 기준)
        --    FROZEN_MASTER는 파라미터가 @P_PLAN_ID 1개이고 DELETE_PROC이 대상테이블을
        --    지우지 않으므로 반드시 DELETE_PROC보다 먼저 호출한다.
        --====================================================================
        EXEC PR_SCP_OPT_ENG_INPUT_FROZEN_MASTER_BATCH  @V_PLAN_ID --

        EXEC PR_SCP_OPT_ENG_INPUT_DELETE_PROC_BATCH        @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_PLAN_MASTER_BATCH        @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_BUCKET_BATCH             @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_ASSIGN_MODEL_LIST_BATCH  @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_RESOURCE_BATCH           @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_EVERY_DAY_CAL_BATCH      @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_DEMAND_BATCH             @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_BOM_BATCH                @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_INCOMING_STOCK_BATCH     @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_STOCK_SWITCHING_BATCH    @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_SCHEDULED_MOVE_BATCH     @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_ITEM_SITE_BATCH          @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_BOD_BATCH                @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_ROUTING_RESOURCE_BATCH   @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_ROUTING_BATCH            @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
--        EXEC PR_SCP_OPT_ENG_INPUT_COBY_PROD_ITEM_BATCH     @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD  -- 유효 event 없어서 호출 제외 처리
        EXEC PR_SCP_OPT_ENG_INPUT_ITEM_BOM_ROUTING_BATCH   @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        -------추가 필요 EXEC PR_SCP_OPT_ENG_INPUT_SITE_MOVE                @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD
        EXEC PR_SCP_OPT_ENG_INPUT_SAFETY_STOCK_BATCH       @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_FROZEN_PLAN_BATCH        @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_HORIZON_CAL_BATCH        @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--
        EXEC PR_SCP_OPT_ENG_INPUT_AFTER_CORRECT_BATCH      @V_PLAN_ID, @V_DIVISION_ID, @V_GROUP_ID, @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD--

        ------------------------------------------------------------------------
        -- INPUT END
        ------------------------------------------------------------------------
        SELECT @V_DETAIL_END_DATE = GETDATE()
    ------------------------------------------------------------------------
    END TRY

    ------------------------------------------------------------------------
    BEGIN CATCH
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
        EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'END',NULL,NULL,NULL,@V_PLAN_ID
    ------------------------------------------------------------------------
END;
