



CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_EE_INPUT_BOM]
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_EE_INPUT_BOM';
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
                           ,ATTRIBUTE13         NVARCHAR(50)
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
                            ,ATTRIBUTE13
                            ,ATTRIBUTE14
                            ,ATTRIBUTE15
        )
        SELECT @V_PLAN_ID
              ,PARENT_SITE_ID+'::'+PARENT_ITEM_ID+'::'+STAGE        AS BOM_ID
              ,0                                                    AS OP_SEQ
              ,CHILD_STAGE                                          AS MATERIAL_CLASS_ID
              ,CHILD_SITE_ID+'::'+CHILD_ITEM_ID+'::'+CHILD_STAGE    AS MATERIAL_BUFFER_ID
              ,1                                                    AS PRIORITY
              ,CHILD_QTY                                            AS COMSUME_QUANTITY
              ,PARENT_SITE_ID                                       AS ATTRIBUTE1
              ,PARENT_ITEM_ID                                       AS ATTRIBUTE2
              ,STAGE                                                AS ATTRIBUTE3
              ,CHILD_SITE_ID                                        AS ATTRIBUTE13
              ,CHILD_ITEM_ID                                        AS ATTRIBUTE14
              ,CHILD_STAGE                                          AS ATTRIBUTE15
        FROM(
               SELECT DISTINCT
                      ST.SCM_SITE_ID            AS PARENT_SITE_ID
                    , A.PARENT_ITEM_ID          AS PARENT_ITEM_ID
                    , 'NND'                     AS STAGE
                    , A.CHILD_ITEM_ID           AS CHILD_ITEM_ID
                    , S2.SCM_SITE_ID            AS CHILD_SITE_ID
                    , 'COATING'                 AS CHILD_STAGE
                    , A.CHILD_QTY/A.PARENT_QTY  AS CHILD_QTY
                FROM   SCM_MST_BOM_ENG_SN A WITH (NOLOCK)
                INNER JOIN #DIVISION DIV
                    ON  DIV.DIVISION_ID  = A.DIVISION_ID
                INNER JOIN SCM_MST_ITEM_SN I WITH (NOLOCK)
                    ON  A.COMPANY_ID     = I.COMPANY_ID
                    AND A.DIVISION_ID    = I.DIVISION_ID
                    AND A.SITE_ID        = I.SITE_ID
                    AND A.PARENT_ITEM_ID = I.ITEM_ID
                    AND I.ACTIVE_FLAG    = 'Y'
                INNER JOIN SCM_MST_ITEM_SN IC WITH (NOLOCK)
                    ON  A.COMPANY_ID     = IC.COMPANY_ID
                    AND A.DIVISION_ID    = IC.DIVISION_ID
                    AND A.SITE_ID        = IC.SITE_ID
                    AND A.CHILD_ITEM_ID  = IC.ITEM_ID
                    AND IC.ACTIVE_FLAG    = 'Y'
                INNER JOIN SCM_MST_SITE ST WITH(NOLOCK)
                    ON  ST.DIVISION_ID = A.DIVISION_ID
                    AND ST.SITE_ID      = A.SITE_ID
                    AND ST.COMPANY_ID   = A.COMPANY_ID
                    AND ST.PLANT_ID     = A.PLANT_ID
                    AND ST.VALID_YN     = 'Y'
                    AND ST.SITE_TYPE    = 'PLANT'
                    AND ST.OPERATION_GROUP  = I.SCP_OPERATION_GROUP
                INNER JOIN SCM_MST_SITE S2 WITH(NOLOCK)
                    ON  S2.DIVISION_ID = A.DIVISION_ID
                    AND S2.SITE_ID      = A.SITE_ID
                    AND S2.COMPANY_ID   = A.COMPANY_ID
                    AND S2.VALID_YN     = 'Y'
                    AND S2.SITE_TYPE    = 'PLANT'
                    AND S2.OPERATION_GROUP  = IC.SCP_OPERATION_GROUP
                LEFT OUTER JOIN SCM_MST_ALTER_BOM_V B WITH(NOLOCK)
                    ON  A.DIVISION_ID    = B.DIVISION_ID
                    AND A.SITE_ID        = B.SITE_ID
                    AND A.PLANT_ID       = B.PLANT_ID
                    AND A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
                    AND A.CHILD_ITEM_ID  = B.CHILD_ITEM_ID
                WHERE  1=1
                AND    I.FLOW_ID                = 'A5000'  -- Parent가 NND
                AND    A.CHILD_QTY              >  0
                AND    A.EFF_END_DATE           >  @D_PLAN_NAME  -- PLAN NAME 일자에 유효한 BOM
                AND    @P_PLAN_NAME             <  CONVERT(VARCHAR(8),A.EFF_END_DATE,112)
                AND    A.ACTIVE_FLAG  = 'Y'
                AND   (A.ALT_ID IS NULL 
                        OR (A.ALT_ID IS NOT NULL AND B.SCP_PLAN_YN IS NULL AND ISNULL(A.ALT_PRIORITY, 1) = 1) 
                        OR (A.ALT_ID IS NOT NULL AND B.SCP_PLAN_YN IS NOT NULL AND B.SCP_PLAN_YN = 'Y'))
                AND     EXISTS (SELECT  1
                                FROM    SCM_MST_PLANT_SN P WITH(NOLOCK)
                                WHERE   P.DIVISION_ID   = IC.DIVISION_ID
                                AND     P.COMPANY_ID    = IC.COMPANY_ID
                                AND     P.SITE_ID       = IC.SITE_ID
                                AND     P.PLANT_ID      = S2.PLANT_ID
                                AND     (P.PLANT_NAME LIKE 'GM1%' OR P.PLANT_NAME LIKE 'UC%' OR P.PLANT_ID = 'GM00')
                                )
                /************************* 
                대상 프로젝트 ITEM 필터링 
                *************************/
                AND (A.PARENT_ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
                                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                            WHERE   PLAN_ID = @V_PLAN_ID
                                            )
                    OR A.CHILD_ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
                                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                            WHERE   PLAN_ID = @V_PLAN_ID
                                            )
                    )
            ) A
            ;
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
                                    ,ATTRIBUTE13
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
              ,ATTRIBUTE13
              ,ATTRIBUTE14
              ,ATTRIBUTE15
        FROM @BOM_TEMP
        ------------------------------------------------------------------------
        -- 4. 2nd OCV BOM 추가 -> B 타입
        -- 2025.06.12 Philsu Park: Material Class 만들 때, PACK, MDLE 두종류가 있을 수 있어 Att2 값으로 반영.
        ------------------------------------------------------------------------
        UNION ALL
        SELECT  @V_PLAN_ID
               ,LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3 AS BOM_ID
               ,0                                               AS OP_SEQ
            --    ,'MDLE'                                          AS MATERIAL_CLASS_ID
               ,LU.ATTRIBUTE2                                   AS MATERIAL_CLASS_ID
               ,LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE2 AS MATERIAL_BUFFER_ID
               ,1                                               AS PRIORITY
               ,1                                               AS CONSUME_QUANTITY
               ,LU.SEGMENT4                                     AS ATTRIBUTE1
               ,LU.SEGMENT5                                     AS ATTRIBUTE2
               ,LU.ATTRIBUTE3                                   AS ATTRIBUTE3
               ,LU.SEGMENT4                                     AS ATTRIBUTE13
               ,LU.SEGMENT5                                     AS ATTRIBUTE14
               ,LU.ATTRIBUTE2                                   AS ATTRIBUTE15
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
        AND     VALID_YN    = 'Y'
        AND     ATTRIBUTE1  = 'B'
        AND     SEGMENT2    = @V_DIVISION_ID
        AND     SEGMENT3    = @V_GROUP_ID
        GROUP BY LU.SEGMENT4,LU.SEGMENT5,LU.ATTRIBUTE3,LU.ATTRIBUTE2
        ------------------------------------------------------------------------
        -- 2nd OCV BOM 추가 -> C타입 /20250901/김태현 선임 
        -- LOOKUP에 Previous Stage 기준으로 BOM의 Child Stage가 동일한 값을 가져와서 단계를 추가해야 함
        ------------------------------------------------------------------------
        -- INSP_COT -> COT 추가
        INSERT INTO SCP_OPT_ENG_BOM_SN(PLAN_ID
                                      ,BOM_ID
                                      ,OP_SEQ
                                      ,MATERIAL_CLASS_ID
                                      ,MATERIAL_BUFFER_ID
                                      ,PRIORITY
                                      ,CONSUME_QUANTITY
                                      ,ATTRIBUTE1
                                      ,ATTRIBUTE2
                                      ,ATTRIBUTE3
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
        )
        SELECT  BOM.PLAN_ID                                     AS PLAN_ID
               ,LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3 AS BOM_ID
               ,BOM.OP_SEQ                                      AS OP_SEQ
               ,LU.ATTRIBUTE2                                   AS MATERIAL_CLASS_ID
               ,LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE2 AS MATERIAL_BUFFER_ID
               ,BOM.PRIORITY                                    AS PRIORITY
               ,1                                               AS CONSUME_QUANTITY
               ,LU.SEGMENT4                                     AS ATTRIBUTE1
               ,LU.SEGMENT5                                     AS ATTRIBUTE2
               ,LU.ATTRIBUTE3                                   AS ATTRIBUTE3
               ,LU.SEGMENT4                                     AS ATTRIBUTE13
               ,LU.SEGMENT5                                     AS ATTRIBUTE14
               ,LU.ATTRIBUTE2                                   AS ATTRIBUTE15
        FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                AND LU.VALID_YN     = 'Y'
                AND LU.ATTRIBUTE1   = 'C'
                AND LU.SEGMENT2     = @V_DIVISION_ID
                AND LU.SEGMENT3     = @V_GROUP_ID
                AND BOM.ATTRIBUTE13  = LU.SEGMENT4
                AND BOM.ATTRIBUTE14 = LU.SEGMENT5
                AND BOM.ATTRIBUTE15 = LU.ATTRIBUTE2
        WHERE   1=1
        AND     BOM.PLAN_ID = @V_PLAN_ID
        GROUP BY BOM.PLAN_ID,LU.SEGMENT4,LU.SEGMENT5,LU.ATTRIBUTE3 ,BOM.OP_SEQ,LU.ATTRIBUTE2 ,BOM.PRIORITY,BOM.CONSUME_QUANTITY
        
        -- NND -> COT에서 NND -> INSP_COT로 수정
        UPDATE  BOM
        SET     BOM.MATERIAL_CLASS_ID  = LU.MATERIAL_CLASS_ID
               ,BOM.MATERIAL_BUFFER_ID = LU.MATERIAL_BUFFER_ID
               ,BOM.ATTRIBUTE13        = LU.ATTRIBUTE13
               ,BOM.ATTRIBUTE15        = LU.ATTRIBUTE15
               --,BOM.CONSUME_QUANTITY   = 1
        FROM    SCP_OPT_ENG_BOM_SN BOM
            INNER JOIN(
            SELECT  LU.ATTRIBUTE3                                           AS MATERIAL_CLASS_ID
                   ,BOM.ATTRIBUTE13+'::'+BOM.ATTRIBUTE14+'::'+LU.ATTRIBUTE3 AS MATERIAL_BUFFER_ID
                   ,BOM.ATTRIBUTE13                                         AS ATTRIBUTE13
                   ,LU.ATTRIBUTE3                                           AS ATTRIBUTE15
                   ,BOM.PLAN_ID                                             AS PLAN_ID
                   ,BOM.BOM_ID                                              AS BOM_ID
                   ,BOM.MATERIAL_BUFFER_ID                                  AS BOM_MATERIAL_BUFFER_ID
            FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                    ON  LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                    AND LU.VALID_YN     = 'Y'
                    AND LU.SEGMENT2     = @V_DIVISION_ID
                    AND LU.SEGMENT3     = @V_GROUP_ID
                    AND BOM.ATTRIBUTE13  = LU.SEGMENT4
                    AND LU.ATTRIBUTE1   = 'C'
                    AND BOM.ATTRIBUTE14 = LU.SEGMENT5
                    AND BOM.ATTRIBUTE15 = LU.ATTRIBUTE2
                    AND BOM.ATTRIBUTE3 != LU.ATTRIBUTE3
            WHERE   1=1
            AND     BOM.PLAN_ID = @V_PLAN_ID
            GROUP BY LU.ATTRIBUTE3,BOM.ATTRIBUTE13,BOM.ATTRIBUTE14,BOM.PLAN_ID,BOM.BOM_ID,BOM.MATERIAL_BUFFER_ID
            ) LU
                ON  BOM.PLAN_ID            = LU.PLAN_ID
                AND BOM.BOM_ID             = LU.BOM_ID
                AND BOM.MATERIAL_BUFFER_ID = LU.BOM_MATERIAL_BUFFER_ID

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
