

--EXEC PR_SCP_OPT_ENG_INPUT_COBY_PROD_ITEM 'PLAN_ID_001'
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_INPUT_COBY_PROD_ITEM]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.07 Taehyun Initial Release
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_INPUT_COBY_PROD_ITEM';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE       DATETIME;
    DECLARE @V_PLAN_START_DATE   NVARCHAR(8)
    DECLARE @V_PLAN_END_DATE     NVARCHAR(8)
    DECLARE @P_PLAN_NAME         NVARCHAR(8) 
    DECLARE @D_PLAN_NAME         DATETIME 
    DECLARE @V_DEMAND_CUTOFF_DAY NVARCHAR(8) 
    DECLARE @V_DM_MAX_VERSION   NVARCHAR(200)

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
    -- SECOND OCV CONSTRAINTS INSERT
    ------------------------------------------------------------------------
    INSERT INTO SCP_OPT_ENG_COBY_PROD_ITEM_SN(
                                              PLAN_ID
                                             ,MAIN_ROUTING_BOM_MAPPING_ID
                                             ,MAIN_OP_SEQ
                                             ,SUB_ROUTING_BOM_MAPPING_ID
                                             ,SUB_OP_SEQ
                                             ,SUB_PROD_QUANTITY
                                             )
    SELECT @V_PLAN_ID          AS PLAN_ID
          ,'RB'+RTO.ROUTING_ID AS MAIN_ROUTING_BOM_MAPPING_ID
          ,RTO.OP_SEQ          AS MAIN_OP_SEQ
          ,'RB'+RTA.ROUTING_ID AS SUB_ROUTING_BOM_MAPPING_ID
          ,RTA.OP_SEQ          AS SUB_OP_SEQ
          ,1                   AS SUB_PROD_QUANTITY
    FROM(
         SELECT RT.ROUTING_ID
               ,RT.OP_SEQ 
               ,SO.SCM_SITE_ID
               ,SO.ITEM_ID
               ,SO.STAGE
         FROM    SCP_OPT_ENG_ROUTING_SN RT WITH(NOLOCK) 
             INNER JOIN (
                         SELECT  SEGMENT2           AS DIVISION_ID
                                ,SEGMENT3           AS PLAN_GROUP
                                ,SEGMENT4           AS SCM_SITE_ID
                                ,SEGMENT5           AS ITEM_ID
                                ,ATTRIBUTE3         AS STAGE
                                ,ATTRIBUTE5         AS OP_SEQ
                                ,ATTRIBUTE6         AS LT
                                ,ATTRIBUTE7         AS YIELD
                                ,ATTRIBUTE8         AS FAIL_RATIO
                                ,ATTRIBUTE4         AS OCV_NUMBER
                         FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                         WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                         AND     SEGMENT2 = @V_DIVISION_ID
                         AND     SEGMENT3 = @V_GROUP_ID
                         ) SO
                 ON  RT.ATTRIBUTE1 = SO.SCM_SITE_ID
                 AND RT.ATTRIBUTE2 = SO.ITEM_ID
                 AND RT.ATTRIBUTE3 = SO.STAGE
         WHERE   PLAN_ID    = @V_PLAN_ID
         AND     RT.OP_SEQ !=0
         AND     RIGHT(RT.ROUTING_ID,2)!= CONVERT(NVARCHAR(2),RT.OP_SEQ)
         GROUP BY RT.ROUTING_ID, RT.OP_SEQ,SO.SCM_SITE_ID,SO.ITEM_ID,SO.STAGE
         )RTO
        INNER JOIN(
                   SELECT RT.ROUTING_ID
                         ,RT.OP_SEQ 
                         ,SO.SCM_SITE_ID
                         ,SO.ITEM_ID
                         ,SO.STAGE
                   FROM    SCP_OPT_ENG_ROUTING_SN RT WITH(NOLOCK) 
                       INNER JOIN (
                                   SELECT  SEGMENT2           AS DIVISION_ID
                                          ,SEGMENT3           AS PLAN_GROUP
                                          ,SEGMENT4           AS SCM_SITE_ID
                                          ,SEGMENT5           AS ITEM_ID
                                          ,ATTRIBUTE3         AS STAGE
                                          ,ATTRIBUTE5         AS OP_SEQ
                                          ,ATTRIBUTE6         AS LT
                                          ,ATTRIBUTE7         AS YIELD
                                          ,ATTRIBUTE8         AS FAIL_RATIO
                                          ,ATTRIBUTE4         AS OCV_NUMBER
                                   FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                   WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                   AND     SEGMENT2 = @V_DIVISION_ID
                                   AND     SEGMENT3 = @V_GROUP_ID
                                   ) SO
                           ON  RT.ATTRIBUTE1 = SO.SCM_SITE_ID
                           AND RT.ATTRIBUTE2 = SO.ITEM_ID
                           AND RT.ATTRIBUTE3 = SO.STAGE
                   WHERE   PLAN_ID    = @V_PLAN_ID
                   AND     RT.OP_SEQ != 0
                   AND     RIGHT(RT.ROUTING_ID,2) = CONVERT(NVARCHAR(2),RT.OP_SEQ)
                   GROUP BY RT.ROUTING_ID, RT.OP_SEQ,SO.SCM_SITE_ID,SO.ITEM_ID,SO.STAGE
                   ) RTA
            ON RTO.OP_SEQ = RTA.OP_SEQ
            AND RTO.SCM_SITE_ID = RTA.SCM_SITE_ID
            AND RTO.ITEM_ID     = RTA.ITEM_ID    
            AND RTO.STAGE       = RTA.STAGE  
    ------------------------------------------------------------------------
    -- Data Insert End
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
