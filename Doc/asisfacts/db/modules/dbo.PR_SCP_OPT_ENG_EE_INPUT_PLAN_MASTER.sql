


CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_EE_INPUT_PLAN_MASTER]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
    ,@T_SCP_PLAN            optTableType_SCP_PLAN READONLY
AS 
BEGIN
    --2025.02.05 Y.S.H Initial Release
	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- Set Prameter
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_EE_INPUT_PLAN_MASTER';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;

    DECLARE @V_SCP_PLAN_TYPE    NVARCHAR(200);
    DECLARE @V_SCP_PLAN_DATE    NVARCHAR(200);
    DECLARE @V_SCP_PLAN_SEQ    NVARCHAR(200);
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
	    -- 전극 Plan Type 확인
		SELECT @V_SCP_PLAN_DATE = A.PLAN_START_YYYYMMDD
		     , @V_SCP_PLAN_TYPE = A.PLAN_TYPE
		     , @V_SCP_PLAN_SEQ  = A.PLAN_SEQ
        FROM  (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
		            , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID ORDER BY PLAN_TYPE_ORDER DESC , PLAN_SEQ DESC) AS PLAN_RANK
               FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
			   -- 전극 Division 에 해당하는 사업부 확인
               WHERE  DIVISION_ID          = @V_DIVISION_ID -- 전극 Division 변수
               AND    PLAN_START_YYYYMMDD  = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 해당 주 월요일 YYYYMMDD
              ) A   
        WHERE PLAN_RANK = 1 

    ------------------------------------------------------------------------
    -- INPUT START
    ------------------------------------------------------------------------
    --INSERT INTO SCP_OPT_ENG_PLAN_MASTER_SN (PLAN_ID,PLAN_START_DATE,PLAN_END_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE15)
    --SELECT  @V_PLAN_ID
    --       ,PLAN_START_YYYYMMDD
    --       ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,PLAN_END_YYYYMMDD),112) AS PLAN_END_YYYYMMDD
    --       ,DIVISION_ID
    --       ,PLAN_TYPE_CODE
    --       ,@V_SCP_PLAN_DATE+','+@V_SCP_PLAN_TYPE+','+@V_SCP_PLAN_SEQ -- SCP 전극 기준 Plan 정보
    --FROM    SCP_OPT_ENG_SCP_PLAN_ID_M_SN WITH(NOLOCK)
    --WHERE   1=1
    --AND     PLAN_ID = @V_PLAN_ID



    --INSERT INTO SCP_OPT_ENG_PLAN_MASTER_SN (PLAN_ID,PLAN_START_DATE,PLAN_END_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE15)
    --SELECT  @V_PLAN_ID
    --       ,PLAN_START_YYYYMMDD
    --       ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,PLAN_END_YYYYMMDD),112) AS PLAN_END_YYYYMMDD
    --       ,PM.DIVISION_ID
    --       ,PGM.OPMZ_PLAN_GR_NAME 
    --       ,@V_SCP_PLAN_DATE+','+@V_SCP_PLAN_TYPE+','+@V_SCP_PLAN_SEQ 
    --FROM     SCP_OPMZ_PLAN_M PM WITH(NOLOCK)
    --    INNER JOIN SCP_OPMZ_PLAN_GR_M PGM WITH(NOLOCK)
    --        ON PM.OPMZ_PLAN_GR_ID = PGM.OPMZ_PLAN_GR_ID
    --WHERE   PM.OPMZ_PLAN_ID = @V_PLAN_ID


    INSERT INTO SCP_OPT_ENG_PLAN_MASTER_SN (PLAN_ID,PLAN_START_DATE,PLAN_END_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE15)
    SELECT @V_PLAN_ID
    ,PLAN_START_YYYYMMDD
    ,PLAN_END_YYYYMMDD
    ,DIVISION_ID
    ,PLAN_GROUP_ID
    ,@V_SCP_PLAN_DATE+','+@V_SCP_PLAN_TYPE+','+@V_SCP_PLAN_SEQ 
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

    ------------------------------------------------------------------------
    -- INPUT END
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
