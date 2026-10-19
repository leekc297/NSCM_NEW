



CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_EE_INPUT_BOM]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.12 Taehyun Initial Release
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_EE_INPUT_BOM';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE       DATETIME;
    DECLARE @P_PLAN_NAME         NVARCHAR(8);
    DECLARE @D_PLAN_NAME         DATETIME;
    DECLARE @CHK_BOM_BATCH       NVARCHAR(100);

    --속도 개선용
    DECLARE @BOM_TEMP TABLE(
                            PLAN_ID             NVARCHAR(50)
                           ,BOM_ID              NVARCHAR(50)
                           ,OP_SEQ              INT
                           ,MATERIAL_CLASS_ID   NVARCHAR(50)
                           ,MATERIAL_BUFFER_ID  NVARCHAR(50)
                           ,PRIORITY            INT
                           ,CONSUME_QUANTITY    NUMERIC(20,10)
                           ,ATTRIBUTE1          NVARCHAR(50)
                           ,ATTRIBUTE2          NVARCHAR(50)
                           ,ATTRIBUTE3          NVARCHAR(50)
                           ,ATTRIBUTE14         NVARCHAR(50)
                           ,ATTRIBUTE15         NVARCHAR(50)
                           )
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
        -- CHECK BOM BATCH 
        ------------------------------------------------------------------------
        SELECT  TOP 1 @CHK_BOM_BATCH = LOG_TYPE
        FROM    scm_sys_log_batch WITH(NOLOCK) 
        WHERE   1=1
        AND     PROGRAM_NAME = 'PR_SCP_MST_ALTER_BOM_BATCH'
        ORDER BY LAST_UPDATE_DATE DESC

        IF @CHK_BOM_BATCH = 'START'
        BEGIN
            RAISERROR('BOM batch program is processing',15,1)
        END

        ------------------------------------------------------------------------
        -- SET Param
        ------------------------------------------------------------------------
        SELECT @P_PLAN_NAME = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
        SELECT @D_PLAN_NAME = CONVERT(DATETIME, @P_PLAN_NAME) ;

		IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
		BEGIN 
			DROP TABLE  #DIVISION;
		END;

		SELECT DIVISION_ID 
		INTO #DIVISION
		FROM SCM_MST_DIVISION WITH(NOLOCK)
		WHERE  VALID_YN = 'Y'
		AND    ATTRIBUTE3 <> 'EE'
		AND    ATTRIBUTE4 = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID) -- 전극 Division 변수
		;

        ------------------------------------------------------------------------
        -- DATA Insert
        ------------------------------------------------------------------------
        --바로 INSERT하면 속도가 느림
        INSERT INTO @BOM_TEMP(
                             PLAN_ID           
                            ,BOM_ID            
                            ,OP_SEQ            
                            ,MATERIAL_CLASS_ID 
                            ,MATERIAL_BUFFER_ID
                            ,PRIORITY          
                            ,CONSUME_QUANTITY  
                            ,ATTRIBUTE1        
                            ,ATTRIBUTE2        
                            ,ATTRIBUTE3        
                            ,ATTRIBUTE14       
                            ,ATTRIBUTE15       
        )
        SELECT @V_PLAN_ID
              ,PLANT_SITE_ID+'::'+PARENT_ITEM_ID+'::'+STAGE      AS BOM_ID
              ,0                                                 AS OP_SEQ
              ,CHILD_STAGE                                       AS MATERIAL_CLASS_ID
              ,PLANT_SITE_ID+'::'+CHILD_ITEM_ID+'::'+CHILD_STAGE AS MATERIAL_BUFFER_ID
              ,1                                                 AS PRIORITY
              ,CHILD_QTY                                         AS COMSUME_QUANTITY
              ,PLANT_SITE_ID                                     AS ATTRIBUTE1
              ,PARENT_ITEM_ID                                    AS ATTRIBUTE2
              ,STAGE                                             AS ATTRIBUTE3
              ,CHILD_ITEM_ID                                     AS ATTRIBUTE14
              ,CHILD_STAGE                                       AS ATTRIBUTE15
        FROM(
            SELECT DISTINCT A.SCM_SITE_ID AS PLANT_SITE_ID
                          , A.ITEM_ID     AS PARENT_ITEM_ID
                          , 'ELEC_POST'   AS  STAGE
            			  , A.ITEM_ID     AS CHILD_ITEM_ID
            			  , 'COATING'     AS CHILD_STAGE
            			  , 1             AS CHILD_QTY   
            FROM SCP_OPT_ENG_MODEL_LIST_N_SN A WITH(NOLOCK)			
                 
                INNER JOIN (SELECT DISTINCT FS.DIVISION_ID, FS.PLANT_SITE_ID, FS.ITEM_ID
				            FROM   SCM_MST_SITE_ITEM_PRIORITY FS WITH (NOLOCK) 

							INNER JOIN #DIVISION D WITH(NOLOCK)
							ON FS.DIVISION_ID = D.DIVISION_ID
                 
							INNER JOIN SCM_MST_SITE S WITH (NOLOCK) 
							ON  FS.DIVISION_ID   = S.DIVISION_ID
							AND FS.PLANT_SITE_ID = S.SCM_SITE_ID
							AND S.SITE_TYPE      = 'PLANT'
							AND S.VALID_YN       = 'Y'
							AND S.OPERATION_GROUP IN ('E') 

							WHERE  FS.TO_YYYYMMDD >= @V_PLAN_START_YYYYMMDD
						   ) FS
                ON  1=1
                AND A.SCM_SITE_ID   = FS.PLANT_SITE_ID
                AND A.ITEM_ID       = FS.ITEM_ID

            WHERE 1=1
            AND   A.PLAN_ID = @V_PLAN_ID
			--AND   A.STAGE   = 'COATING'

            ) A
        ------------------------------------------------------------------------
        --본테이블 INSERT
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_BOM_SN( PLAN_ID
                                    ,BOM_ID
                                    ,OP_SEQ
                                    ,MATERIAL_CLASS_ID
                                    ,MATERIAL_BUFFER_ID
                                    ,PRIORITY
                                    ,CONSUME_QUANTITY
                                    ,ATTRIBUTE1
                                    ,ATTRIBUTE2
                                    ,ATTRIBUTE3
                                    ,ATTRIBUTE14
                                    ,ATTRIBUTE15
                                   )
        SELECT PLAN_ID
              ,BOM_ID
              ,OP_SEQ
              ,MATERIAL_CLASS_ID
              ,MATERIAL_BUFFER_ID
              ,PRIORITY
              ,CONSUME_QUANTITY
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE14
              ,ATTRIBUTE15
        FROM @BOM_TEMP
        OPTION(RECOMPILE)
		
		IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
		BEGIN 
			DROP TABLE  #DIVISION;
		END;

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
