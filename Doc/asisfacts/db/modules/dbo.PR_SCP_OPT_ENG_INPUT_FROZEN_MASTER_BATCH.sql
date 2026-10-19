CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_INPUT_FROZEN_MASTER_BATCH]
     @P_PLAN_ID     NVARCHAR(50)
AS 
BEGIN
    --2025.02.14 Taehyun Initial Release
    ------------------------------------------------------------------------  
    -- Procedure 기본조건.
    ------------------------------------------------------------------------
    SET XACT_ABORT ON;
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    ------------------------------------------------------------------------  
    
    ------------------------------------------------------------------------
    -- Set Param for Log
    ------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_INPUT_FROZEN_MASTER_BATCH';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE         DATETIME;
    DECLARE @V_DIVISION_ID         NVARCHAR(100)
    DECLARE @V_GROUP_ID            NVARCHAR(100)
    DECLARE @V_PLAN_START_YYYYMMDD NVARCHAR(50)
    DECLARE @V_SCP_PLAN_DATE       NVARCHAR(8)
    DECLARE @V_SCP_PLAN_TYPE       NVARCHAR(20)
    DECLARE @V_SCP_PLAN_SEQ        NVARCHAR(8)
    DECLARE @V_PROD_FROZEN         INT
    DECLARE @V_PLAN_EXEC_TYPE      NVARCHAR(10)
    DECLARE @V_SHIP_SCP_PLAN_DATE  NVARCHAR(8)
    DECLARE @V_SHIP_SCP_PLAN_TYPE  NVARCHAR(20)
    DECLARE @V_SHIP_SCP_PLAN_SEQ   NVARCHAR(8)

    DECLARE @PROD_FROZEN TABLE(
      STAGE                 NVARCHAR(100)
    , FROZEN_START_YYYYMMDD NVARCHAR(8)
    , FROZEN_END_YYYYMMDD   NVARCHAR(8)
    , FROZEN_DAYS           NVARCHAR(50)
    )

    DECLARE @SHIP_FROZEN TABLE(
      STAGE                 NVARCHAR(100)
    , FROZEN_START_YYYYMMDD NVARCHAR(8)
    , FROZEN_END_YYYYMMDD   NVARCHAR(8)
    , FROZEN_DAYS           NVARCHAR(50)
    )
    ------------------------------------------------------------------------ 
    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
    ------------------------------------------------------------------------
    EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

    ------------------------------------------------------------------------    
    BEGIN TRY

        -- 이전에 있던 PLAN_ID 정보는 삭제
        DELETE FROM SCP_OPT_ENG_FROZEN_MASTER_SN   
        WHERE PLAN_ID = @V_PLAN_ID
        ------------------------------------------------------------------------ 
        --PLAN 기본 정보 생성
        ------------------------------------------------------------------------
        SELECT  @V_DIVISION_ID         = A.DIVISION_ID
               ,@V_GROUP_ID           = A.PLAN_GROUP_ID
               ,@V_PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
               ,@V_PLAN_EXEC_TYPE      = A.PLAN_EXEC_TYPE
               --,@V_PLAN_END_YYYYMMDD   = A.PLAN_END_YYYYMMDD
        FROM(
             SELECT  DIVISION_ID             AS DIVISION_ID
                    ,DIVISION_ID + '_' + PLAN_TYPE_CODE          AS PLAN_GROUP_ID
                    ,PLAN_START_YYYYMMDD     AS PLAN_START_YYYYMMDD
                    ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,PLAN_END_YYYYMMDD),112) AS PLAN_END_YYYYMMDD
                    ,'BATCH'                AS PLAN_EXEC_TYPE
--                    ,'MANUAL'                AS PLAN_EXEC_TYPE
             FROM    SCP_OPT_ENG_SCP_PLAN_ID_M_SN WITH(NOLOCK)
             WHERE   1=1
             AND     PLAN_ID = @V_PLAN_ID
            ) A
        ------------------------------------------------------------------------ 
        /* 그룹키는 메인 SP와 동일하게 {사업부}_{계획타입}으로 조합.
                   PLAN_TYPE_CODE는 계획타입 코드이므로 계획그룹키로 직접 사용할 수 없다. */
        IF @V_PLAN_EXEC_TYPE = 'BATCH' AND @V_GROUP_ID IN ('PR','MA','FN')
            SET @V_GROUP_ID = @V_DIVISION_ID + '_' + @V_GROUP_ID;

        --FROZEN MASTER 정보 생성
        ------------------------------------------------------------------------
        IF @V_DIVISION_ID != 'EE' 
            BEGIN
                ------------------------------------------------------------------------ 
                /* 그룹키는 메인 SP와 동일하게 {사업부}_{계획타입}으로 조합.
                   PLAN_TYPE_CODE는 계획타입 코드이므로 계획그룹키로 직접 사용할 수 없다. */
        IF @V_PLAN_EXEC_TYPE = 'BATCH' AND @V_GROUP_ID IN ('PR','MA','FN')
            SET @V_GROUP_ID = @V_DIVISION_ID + '_' + @V_GROUP_ID;

        --FROZEN MASTER 정보 생성
                ------------------------------------------------------------------------
                IF @V_PLAN_EXEC_TYPE = 'BATCH'
                    BEGIN
                        SELECT @V_SCP_PLAN_DATE   = A.PLAN_START_YYYYMMDD 
                              ,@V_SCP_PLAN_TYPE   = A.PLAN_TYPE_CODE 
                              ,@V_SCP_PLAN_SEQ    = 1 --A.PLAN_SEQ 
                        FROM  SCP_OPT_ENG_SCP_PLAN_ID_M_SN A WITH(NOLOCK)
                        WHERE PLAN_ID = @V_PLAN_ID

                        SELECT @V_SHIP_SCP_PLAN_DATE = A.PLAN_START_YYYYMMDD 
                              ,@V_SHIP_SCP_PLAN_TYPE = A.PLAN_TYPE_CODE 
                              ,@V_SHIP_SCP_PLAN_SEQ  = 1 --A.PLAN_SEQ 
                        FROM  SCP_OPT_ENG_SCP_PLAN_ID_M_SN A WITH(NOLOCK)
                        WHERE PLAN_ID = @V_PLAN_ID
                        
                        ------------------------------------------------------------------------ 
                        -- FROZEN 기간 Batch 정보 생성 
                        ------------------------------------------------------------------------
                        INSERT INTO @PROD_FROZEN
                        SELECT   STAGE            AS STAGE
                                ,@V_SCP_PLAN_DATE AS FROZEN_START_YYYYMMDD
                                ,CONVERT(CHAR(8), DATEADD(DD, 364, @V_SCP_PLAN_DATE ), 112) AS FROZEN_END_YYYYMMDD
                                ,365              AS FROZEN_DAYS
                        FROM    (
                                 SELECT 'ASSY'    AS STAGE   UNION ALL
                                 SELECT 'MDLE'    AS STAGE   UNION ALL
                                 SELECT 'PACK'    AS STAGE
                                ) ST  
                        WHERE   1=1
                        
                        
                        INSERT INTO @SHIP_FROZEN
                        SELECT   'SHIP'           AS STAGE
                                ,@V_SCP_PLAN_DATE AS FROZEN_START_YYYYMMDD
                                ,CONVERT(CHAR(8), DATEADD(DD, 364, @V_SCP_PLAN_DATE ), 112) AS FROZEN_END_YYYYMMDD
                                ,365         AS FROZEN_DAYS
                        
                    END
            END


        ------------------------------------------------------------------------ 
        --DATA Insert
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_FROZEN_MASTER_SN(
                                                 PLAN_ID
                                                ,DIVISION_ID
                                                ,FROZEN_TYPE
                                                ,SYS_DIVS_CD
                                                ,PLAN_TYPE
                                                ,PLAN_SEQ
                                                ,PLAN_YYYYMMDD
                                                ,STAGE
                                                ,FROZEN_START_DATE
                                                ,FROZEN_END_DATE
                                                ,FROZEN_DAYS
                                                ,ATTRIBUTE1 
                                                )
        ----------------------생산 FROZEN----------------------
        -- BATCH/조립/SCP/PACK&MDLE&ASSY
        SELECT  @V_PLAN_ID            AS PLAN_ID
               ,@V_DIVISION_ID        AS DIVISION_ID
               ,'PROD'                AS FROZEN_TYPE
               ,'SCP'                 AS SYS_DIVS_CD
               ,@V_SCP_PLAN_TYPE      AS PLAN_TYPE
               ,@V_SCP_PLAN_SEQ       AS PLAN_SEQ
               ,@V_SCP_PLAN_DATE      AS PLAN_YYYYMMDD
               ,STAGE                 AS STAGE
               ,FROZEN_START_YYYYMMDD AS FROZEN_START_DATE
               ,FROZEN_END_YYYYMMDD   AS FROZEN_END_DATE
               ,FROZEN_DAYS           AS FROZEN_DAY
               ,@V_PLAN_EXEC_TYPE     AS ATTRIBUTE1
        FROM    @PROD_FROZEN
        WHERE   1=1
        AND     FROZEN_START_YYYYMMDD IS NOT NULL
        AND     FROZEN_END_YYYYMMDD   IS NOT NULL
        AND     FROZEN_DAYS           IS NOT NULL
        ----------------------생산 FROZEN END----------------------
        ----------------------출하 FROZEN START----------------------
        -- BATCH/조립/SCP
        UNION ALL
        SELECT  @V_PLAN_ID            AS PLAN_ID
               ,@V_DIVISION_ID        AS DIVISION_ID
               ,'SHIP'                AS FROZEN_TYPE
               ,'SCP'                 AS SYS_DIVS_CD
               ,@V_SHIP_SCP_PLAN_TYPE AS PLAN_TYPE
               ,@V_SHIP_SCP_PLAN_SEQ  AS PLAN_SEQ
               ,@V_SHIP_SCP_PLAN_DATE AS PLAN_YYYYMMDD
               ,STAGE                 AS STAGE
               ,FROZEN_START_YYYYMMDD AS FROZEN_START_DATE
               ,FROZEN_END_YYYYMMDD   AS FROZEN_END_DATE
               ,FROZEN_DAYS           AS FROZEN_DAY
               ,@V_PLAN_EXEC_TYPE     AS ATTRIBUTE1
        FROM    @SHIP_FROZEN
        WHERE   1=1
        AND     FROZEN_START_YYYYMMDD IS NOT NULL
        AND     FROZEN_END_YYYYMMDD   IS NOT NULL
        AND     FROZEN_DAYS           IS NOT NULL
        ----------------------출하 FROZEN END----------------------
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
        SELECT @V_DETAIL_DATE = GETDATE()
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,@V_DETAIL_DATE,NULL,@V_MESSAGE_TEXT,'ERROR'
        ------------------------------------------------------------------------
        RAISERROR(@V_PROGRAM_NAME, 16,1)
        ------------------------------------------------------------------------
    END CATCH
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- 종료 LOG
    ------------------------------------------------------------------------
    IF @V_MESSAGE_TEXT IS NULL 
    ------------------------------------------------------------------------
    BEGIN
        EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'END',NULL,NULL,NULL,@V_PLAN_ID
        EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL
    END
    ------------------------------------------------------------------------
  END;
