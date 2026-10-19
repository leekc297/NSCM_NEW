
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_INPUT_BOM]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.07.07 Philsu Park: Initial Release
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_INPUT_BOM';
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
     PLANT_SITE_ID       NVARCHAR(50)
    ,PARENT_ITEM_ID      NVARCHAR(50)
    ,STAGE               NVARCHAR(50)
    ,CHILD_ITEM_ID       NVARCHAR(50)
    ,CHILD_STAGE         NVARCHAR(50)
    ,MATERIAL_CLASS_ID   NVARCHAR(50)
    ,CHILD_QTY           NUMERIC(20,10)
    )
    --DECLARE @BOM_TEMP TABLE(
    --                        PLAN_ID             NVARCHAR(50)
    --                       ,BOM_ID              NVARCHAR(50)
    --                       ,OP_SEQ              INT
    --                       ,MATERIAL_CLASS_ID   NVARCHAR(50)
    --                       ,MATERIAL_BUFFER_ID  NVARCHAR(50)
    --                       ,PRIORITY            INT
    --                       ,CONSUME_QUANTITY    NUMERIC(20,10)
    --                       ,ATTRIBUTE1          NVARCHAR(50)
    --                       ,ATTRIBUTE2          NVARCHAR(50)
    --                       ,ATTRIBUTE3          NVARCHAR(50)
    --                       ,ATTRIBUTE14         NVARCHAR(50)
    --                       ,ATTRIBUTE15         NVARCHAR(50)
    --                       )
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

        ------------------------------------------------------------------------
        --TEST용 07주차 고정
        ------------------------------------------------------------------------
        --SELECT @P_PLAN_NAME = '20250210'; -- 당주 월요일 YYYYMMDD
        --SELECT @D_PLAN_NAME = CONVERT(DATETIME, @P_PLAN_NAME) ;

        /* IF OBJECT_ID('TEMPDB..#PACK_BOM_LIST') IS NOT NULL
            BEGIN 
                DROP TABLE  #PACK_BOM_LIST;
            END;

        SELECT A.*
                , B.SCP_PLAN_YN 
                , I.FLOW_ID
                , IC.FLOW_ID AS CHILD_FLOW_ID
                , CASE WHEN A.ALT_ID IS NULL AND ISNULL(IC.ITEM_CLASS, '') = 'ES0901' 
                    THEN ROW_NUMBER()OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PARENT_ITEM_ID ORDER BY A.CHILD_ITEM_ID) 
                ELSE NULL END AS R_NUM
                , CASE WHEN A.ALT_ID IS NULL AND ISNULL(IC.ITEM_CLASS, '') = 'ES0901' 
                    THEN COUNT(ITM.ITEM_ID)OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PARENT_ITEM_ID) 
                ELSE NULL END AS CNT
        INTO   #PACK_BOM_LIST
        FROM   SCM_MST_BOM_ENG_SN A WITH (NOLOCK)
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
        LEFT OUTER JOIN SCM_MST_ITEM_SN ITM WITH (NOLOCK)
            ON  A.COMPANY_ID     = ITM.COMPANY_ID
            AND A.DIVISION_ID    = ITM.DIVISION_ID
            AND A.SITE_ID        = ITM.SITE_ID
            AND A.CHILD_ITEM_ID  = ITM.ITEM_ID
            AND ITM.ACTIVE_FLAG  = 'Y'
            AND ITM.ITEM_CLASS   = 'ES0901'
        LEFT OUTER JOIN SCM_MST_ALTER_BOM_V B WITH(NOLOCK)
            ON  A.DIVISION_ID    = B.DIVISION_ID
            AND A.SITE_ID        = B.SITE_ID
            AND A.PLANT_ID       = B.PLANT_ID
            AND A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
            AND A.CHILD_ITEM_ID  = B.CHILD_ITEM_ID
        WHERE  1=1
        AND    A.DIVISION_ID  = @V_DIVISION_ID
        AND    @V_DIVISION_ID <> '40' -- 소형은 CELL Demand 만 처리하므로 Pack BOM 필요 없음
        AND    ISNULL(I.FLOW_ID, '')    != ''
        AND    I.FLOW_ID                != '-'
        AND    A.CHILD_QTY              >  0
        AND    A.EFF_END_DATE           >  @D_PLAN_NAME  -- PLAN NAME 일자에 유효한 BOM
        AND    @P_PLAN_NAME  <  CONVERT(VARCHAR(8),A.EFF_END_DATE,112)
        AND    A.ACTIVE_FLAG  = 'Y'
        AND   (A.ALT_ID IS NULL 
                OR (A.ALT_ID IS NOT NULL AND B.SCP_PLAN_YN IS NULL AND ISNULL(A.ALT_PRIORITY, 1) = 1) 
                OR (A.ALT_ID IS NOT NULL AND B.SCP_PLAN_YN IS NOT NULL AND B.SCP_PLAN_YN = 'Y'))
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
        ; */
        ------------------------------------------------------------------------
        -- DATA Insert
        ------------------------------------------------------------------------
        --바로 INSERT하면 속도가 느림
        INSERT INTO @BOM_TEMP(
                              PLANT_SITE_ID    
                             ,PARENT_ITEM_ID   
                             ,STAGE            
                             ,CHILD_ITEM_ID    
                             ,CHILD_STAGE      
                             ,MATERIAL_CLASS_ID
                             ,CHILD_QTY        
                            )
        ------------------------------------------------------------------------
        -- 1. BOM : CHAR, EOL
        ------------------------------------------------------------------------
        SELECT    S.SCM_SITE_ID AS PLANT_SITE_ID
                , A.MODEL_ID    AS PARENT_ITEM_ID
                , CASE  WHEN B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1' AND A.MODEL_ID <> A.CHILD_ITEM_ID THEN 'CHAR'
                        WHEN B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1' AND A.MODEL_ID  = A.CHILD_ITEM_ID THEN 'EOL'
                        END     AS STAGE
                , A.CHILD_ITEM_ID
                , CASE WHEN B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1' AND A.MODEL_ID <> A.CHILD_ITEM_ID THEN 'EOL'
                        WHEN B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1' AND A.MODEL_ID  = A.CHILD_ITEM_ID THEN 'A_DEGAS'
                END             AS CHILD_STAGE
                , CASE WHEN B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1' AND A.MODEL_ID <> A.CHILD_ITEM_ID THEN 'EOL'
                        WHEN B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1' AND A.MODEL_ID  = A.CHILD_ITEM_ID THEN 'A_DEGAS'
                END             AS MATERIAL_CLASS_ID
                , A.ACCUMULATED_CHILD_QTY AS CHILD_QTY   
        --SELECT A.*, B.ATTRIBUTE8, B.OPERATION_GROUP
        FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A WITH(NOLOCK)
        LEFT JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                        --, * 
                    FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                    WHERE  DIVISION_ID = @V_DIVISION_ID
                    AND    OPERATION_GROUP IN ('A')  -- Cell BOM
                   ) B
        ON    A.MODEL_ID    = B.ITEM_ID
        AND   A.DIVISION_ID = B.DIVISION_ID 
            ------------------------------------------------------------------------
            INNER JOIN (SELECT * FROM SCM_MST_SITE S WITH(NOLOCK) 
            			WHERE  1=1
            			AND    S.DIVISION_ID     = @V_DIVISION_ID
            			AND    S.SITE_TYPE       = 'PLANT'
            			AND    S.OPERATION_GROUP IN ('A')
            			AND    S.OSP_YN         <> 'Y'
            			AND    S.VALID_YN        = 'Y'
                       ) S
            ON    A.DIVISION_ID     = S.DIVISION_ID
            AND   A.PLANT_ID        = S.PLANT_ID 
            AND   B.OPERATION_GROUP = S.OPERATION_GROUP 
            ------------------------------------------------------------------------
        WHERE 1=1
        AND A.DIVISION_ID = @V_DIVISION_ID
        AND A.OPERATION_GROUP_ID IN ('A')
        AND (
              (B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1') -- CELL CP -> CELL CA  /  CELL CA -> CELL CA
            )
        AND A.EFF_END_DATE >= @D_PLAN_NAME
        /************************* 
        대상 프로젝트 ITEM 필터링 
        *************************/
        AND (S.SCM_SITE_ID + A.MODEL_ID)
        				IN (SELECT DISTINCT SCM_SITE_ID + ITEM_ID 
        					FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
        					WHERE   PLAN_ID = @V_PLAN_ID
        					)
        UNION 
        ------------------------------------------------------------------------
        -- 2. BOM : B_DEGAS(EOL과 동일레벨이므로 STAGE만 변경.)
        ------------------------------------------------------------------------
        SELECT    S.SCM_SITE_ID             AS PLANT_SITE_ID
                , A.MODEL_ID                AS PARENT_ITEM_ID
                , 'A_DEGAS'                 AS STAGE
                , A.CHILD_ITEM_ID           AS CHILD_ITEM_ID
                , 'B_DEGAS'                 AS CHILD_STAGE
                , 'B_DEGAS'                 AS MATERIAL_CLASS_ID
                , A.ACCUMULATED_CHILD_QTY   AS CHILD_QTY   
        --SELECT A.*, B.ATTRIBUTE8, B.OPERATION_GROUP
        FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A WITH(NOLOCK)
        LEFT JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                        --, * 
                    FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                    WHERE  DIVISION_ID = @V_DIVISION_ID
                    AND    OPERATION_GROUP IN ('A')  -- Cell BOM
                   ) B
        ON    A.MODEL_ID    = B.ITEM_ID
        AND   A.DIVISION_ID = B.DIVISION_ID 
            ------------------------------------------------------------------------
            INNER JOIN (SELECT * FROM SCM_MST_SITE S WITH(NOLOCK) 
            			WHERE  1=1
            			AND    S.DIVISION_ID     = @V_DIVISION_ID
            			AND    S.SITE_TYPE       = 'PLANT'
            			AND    S.OPERATION_GROUP IN ('A')
            			AND    S.OSP_YN         <> 'Y'
            			AND    S.VALID_YN        = 'Y'
                       ) S
            ON    A.DIVISION_ID     = S.DIVISION_ID
            AND   A.PLANT_ID        = S.PLANT_ID 
            AND   B.OPERATION_GROUP = S.OPERATION_GROUP 
            ------------------------------------------------------------------------
        WHERE 1=1
        AND A.DIVISION_ID = @V_DIVISION_ID
        AND A.MODEL_ID  = A.CHILD_ITEM_ID
        AND A.OPERATION_GROUP_ID IN ('A')
        AND (
              (B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1') -- CELL CP -> CELL CA  /  CELL CA -> CELL CA
            )
        AND A.EFF_END_DATE >= @D_PLAN_NAME
        /************************* 
        대상 프로젝트 ITEM 필터링 
        *************************/
        AND (S.SCM_SITE_ID + A.MODEL_ID)
        				IN (SELECT DISTINCT SCM_SITE_ID + ITEM_ID 
        					FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
        					WHERE   PLAN_ID = @V_PLAN_ID
        					)
        UNION 
        ------------------------------------------------------------------------
        -- 2. BOM : A_DEGAS(EOL과 동일레벨이므로 STAGE만 변경.)
        ------------------------------------------------------------------------
        SELECT    S.SCM_SITE_ID             AS PLANT_SITE_ID
                , A.MODEL_ID                AS PARENT_ITEM_ID
                , 'B_DEGAS'                 AS STAGE
                , A.CHILD_ITEM_ID           AS CHILD_ITEM_ID
                , 'ASSY'                    AS CHILD_STAGE
                , 'ASSY'                    AS MATERIAL_CLASS_ID
                , A.ACCUMULATED_CHILD_QTY   AS CHILD_QTY   
        --SELECT A.*, B.ATTRIBUTE8, B.OPERATION_GROUP
        FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A WITH(NOLOCK)
        LEFT JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                        --, * 
                    FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                    WHERE  DIVISION_ID = @V_DIVISION_ID
                    AND    OPERATION_GROUP IN ('A')  -- Cell BOM
                   ) B
        ON    A.MODEL_ID    = B.ITEM_ID
        AND   A.DIVISION_ID = B.DIVISION_ID 
            ------------------------------------------------------------------------
            INNER JOIN (SELECT * FROM SCM_MST_SITE S WITH(NOLOCK) 
            			WHERE  1=1
            			AND    S.DIVISION_ID     = @V_DIVISION_ID
            			AND    S.SITE_TYPE       = 'PLANT'
            			AND    S.OPERATION_GROUP IN ('A')
            			AND    S.OSP_YN         <> 'Y'
            			AND    S.VALID_YN        = 'Y'
                       ) S
            ON    A.DIVISION_ID     = S.DIVISION_ID
            AND   A.PLANT_ID        = S.PLANT_ID 
            AND   B.OPERATION_GROUP = S.OPERATION_GROUP 
            ------------------------------------------------------------------------
        WHERE 1=1
        AND A.DIVISION_ID = @V_DIVISION_ID
        AND A.MODEL_ID  = A.CHILD_ITEM_ID
        AND A.OPERATION_GROUP_ID IN ('A')
        AND (
              (B.OPERATION_GROUP = 'A' AND A.CELL_TYPE = 'CA1') -- CELL CP -> CELL CA  /  CELL CA -> CELL CA
            )
        AND A.EFF_END_DATE >= @D_PLAN_NAME
        /************************* 
        대상 프로젝트 ITEM 필터링 
        *************************/
        AND (S.SCM_SITE_ID + A.MODEL_ID)
        				IN (SELECT DISTINCT SCM_SITE_ID + ITEM_ID 
        					FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
        					WHERE   PLAN_ID = @V_PLAN_ID
        					)
        UNION 
        ------------------------------------------------------------------------
        -- 3. BOM : ASSY 정의(STK 추가에 따른 반영)
        ------------------------------------------------------------------------
        SELECT    ST.SCM_SITE_ID            AS SCM_SITE_ID
                , A.PARENT_ITEM_ID          AS PARENT_ITEM_ID
                , 'ASSY'                    AS STAGE
                , A.CHILD_ITEM_ID           AS CHILD_ITEM_ID
                , 'STK'                     AS CHILD_STAGE
                , 'STK'                     AS MATERIAL_CLASS_ID
                , A.ACCUMULATED_CHILD_QTY   AS CHILD_QTY
        FROM    SCM_MST_BOM_EFFECTIVE_SN A WITH(NOLOCK)
        INNER JOIN SCM_ITEM_M_SN IM WITH(NOLOCK)
            ON  A.COMPANY_ID        = IM.COMPANY_ID
            AND A.DIVISION_ID       = IM.DIVISION_ID
            AND A.SITE_ID           = IM.SITE_ID
            AND A.PARENT_ITEM_ID    = IM.ITEM_ID
        INNER JOIN SCM_ITEM_M_SN ITM WITH(NOLOCK)
            ON  A.CHILD_COMPANY_ID  = ITM.COMPANY_ID
            AND A.CHILD_DIVISION_ID = ITM.DIVISION_ID
            AND A.CHILD_SITE_ID     = ITM.SITE_ID
            AND A.CHILD_ITEM_ID     = ITM.ITEM_ID
        INNER JOIN SCM_MST_SITE ST WITH(NOLOCK)
            ON  A.DIVISION_ID           = ST.DIVISION_ID
            AND A.PLANT_ID              = ST.PLANT_ID
            AND A.SITE_ID               = ST.SITE_ID
            AND IM.SCP_OPERATION_GROUP  = ST.OPERATION_GROUP
            AND ST.VALID_YN             = 'Y'
        WHERE   A.DIVISION_ID           = @V_DIVISION_ID
        AND     ITM.SCP_OPERATION_GROUP = 'A'
        AND     A.LEAF_LEVEL           IS NULL
        AND     A.EFF_END_DATE         >= @V_PLAN_START_YYYYMMDD
        AND     IM.SCP_FLOW_ID          = 'A9000'  -- ASSY
        AND     ITM.SCP_FLOW_ID         = 'A8000'  -- STK
        AND (ST.SCM_SITE_ID + A.CHILD_ITEM_ID)
                                                IN (SELECT DISTINCT SCM_SITE_ID + ITEM_ID 
                                                    FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                    WHERE   PLAN_ID = @V_PLAN_ID
                                                    )
        ------------------------------------------------------------------------
        --본테이블 INSERT
        --동편 서편 BOM을 각각 만들어주고, MODEL LIST를 걸어서 해당하지 않는 STAGE는 제거
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
                                    ,ATTRIBUTE4
                                    ,ATTRIBUTE13
                                    ,ATTRIBUTE14
                                    ,ATTRIBUTE15
                                   )
        SELECT @V_PLAN_ID
              ,BOM.PLANT_SITE_ID+'::'+BOM.PARENT_ITEM_ID+'::'+BOM.STAGE_BUFFER      AS BOM_ID
              ,0                                                                    AS OP_SEQ
              ,BOM.MATERIAL_CLASS_ID                                                AS MATERIAL_CLASS_ID
              ,BOM.PLANT_SITE_ID+'::'+BOM.CHILD_ITEM_ID+'::'+BOM.CHILD_STAGE_BUFFER AS MATERIAL_BUFFER_ID
              ,1                                                                    AS PRIORITY
              ,BOM.CHILD_QTY                                                        AS COMSUME_QUANTITY
              ,BOM.PLANT_SITE_ID                                                    AS ATTRIBUTE1
              ,BOM.PARENT_ITEM_ID                                                   AS ATTRIBUTE2
              ,BOM.STAGE                                                            AS ATTRIBUTE3
              ,BOM.STAGE_BUFFER                                                     AS ATTRIBUTE4
              ,BOM.CHILD_STAGE_BUFFER                                               AS ATTRIBUTE13
              ,BOM.CHILD_ITEM_ID                                                    AS ATTRIBUTE14
              ,BOM.CHILD_STAGE                                                      AS ATTRIBUTE15
        FROM(
            SELECT  PLANT_SITE_ID          AS PLANT_SITE_ID
                   ,PARENT_ITEM_ID         AS PARENT_ITEM_ID
                   ,STAGE+'@E'             AS STAGE_BUFFER
                   ,STAGE                  AS STAGE
                   ,CHILD_ITEM_ID          AS CHILD_ITEM_ID
                   ,CHILD_STAGE+'@E'       AS CHILD_STAGE_BUFFER
                   ,CHILD_STAGE            AS CHILD_STAGE
                   ,MATERIAL_CLASS_ID      AS MATERIAL_CLASS_ID
                   ,CHILD_QTY              AS CHILD_QTY
            FROM    @BOM_TEMP
            WHERE   STAGE != 'CHAR'
            UNION ALL
            SELECT  PLANT_SITE_ID          AS PLANT_SITE_ID
                   ,PARENT_ITEM_ID         AS PARENT_ITEM_ID
                   ,STAGE+'@W'             AS STAGE_BUFFER
                   ,STAGE                  AS STAGE
                   ,CHILD_ITEM_ID          AS CHILD_ITEM_ID
                   ,CHILD_STAGE+'@W'       AS CHILD_STAGE_BUFFER
                   ,CHILD_STAGE            AS CHILD_STAGE
                   ,MATERIAL_CLASS_ID      AS MATERIAL_CLASS_ID
                   ,CHILD_QTY              AS CHILD_QTY
            FROM    @BOM_TEMP
            WHERE   STAGE != 'CHAR'
            UNION ALL
            SELECT  PLANT_SITE_ID          AS PLANT_SITE_ID
                   ,PARENT_ITEM_ID         AS PARENT_ITEM_ID
                   ,STAGE                  AS STAGE_BUFFER
                   ,STAGE                  AS STAGE
                   ,CHILD_ITEM_ID          AS CHILD_ITEM_ID
                   ,CHILD_STAGE+'@E'       AS CHILD_STAGE_BUFFER
                   ,CHILD_STAGE            AS CHILD_STAGE
                   ,MATERIAL_CLASS_ID      AS MATERIAL_CLASS_ID
                   ,CHILD_QTY              AS CHILD_QTY
            FROM    @BOM_TEMP
            WHERE   STAGE = 'CHAR'
            UNION ALL
            SELECT  PLANT_SITE_ID          AS PLANT_SITE_ID
                   ,PARENT_ITEM_ID         AS PARENT_ITEM_ID
                   ,STAGE                  AS STAGE_BUFFER
                   ,STAGE                  AS STAGE
                   ,CHILD_ITEM_ID          AS CHILD_ITEM_ID
                   ,CHILD_STAGE+'@W'       AS CHILD_STAGE_BUFFER
                   ,CHILD_STAGE            AS CHILD_STAGE
                   ,MATERIAL_CLASS_ID      AS MATERIAL_CLASS_ID
                   ,CHILD_QTY              AS CHILD_QTY
            FROM    @BOM_TEMP
            WHERE   STAGE = 'CHAR'
        ) AS BOM
            INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN PML WITH(NOLOCK)
                ON  PML.PLAN_ID     = @V_PLAN_ID
                AND PML.SCM_SITE_ID = BOM.PLANT_SITE_ID
                AND PML.ITEM_ID     = BOM.PARENT_ITEM_ID
                AND PML.STAGE       = BOM.STAGE_BUFFER
            INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN CML WITH(NOLOCK)
                ON  CML.PLAN_ID     = @V_PLAN_ID
                AND CML.SCM_SITE_ID = BOM.PLANT_SITE_ID
                AND CML.ITEM_ID     = BOM.CHILD_ITEM_ID
                AND CML.STAGE       = BOM.CHILD_STAGE_BUFFER
        ------------------------------------------------------------------------
        -- 5. 대치 BOM 추가
        ------------------------------------------------------------------------
        UNION ALL
        SELECT  @V_PLAN_ID  AS PLAN_ID
               ,ATTRIBUTE1  AS BOM_ID
               ,ATTRIBUTE2  AS OP_SEQ
               ,ATTRIBUTE3  AS MATERIAL_CLASS_ID
               ,ATTRIBUTE4  AS MATERIAL_BUFFER_ID
               ,ATTRIBUTE5  AS PRIORITY
               ,ATTRIBUTE6  AS CONSUME_QUANTITY
               ,ATTRIBUTE7  AS SCM_SITE_ID
               ,ATTRIBUTE8  AS ITEM_ID
               ,ATTRIBUTE9  AS STAGE_BUFFER
               ,ATTRIBUTE9  AS STAGE
               ,ATTRIBUTE11 AS C_STAGE
               ,ATTRIBUTE10 AS C_ITEM_ID
               ,ATTRIBUTE11 AS C_STAGE_BUFFER
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        WHERE   1=1
        AND     LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_ALTERNATE_BOM'
        AND     VALID_YN    = 'Y'
        AND     SEGMENT2    = @V_DIVISION_ID
        AND     SEGMENT3    = @V_GROUP_ID

        ------------------------------------------------------------------------
        -- TRAY 제약을 위한 데이터 추가
        -- 2025-07-30 THK
        ------------------------------------------------------------------------  
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
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
                                      )
        SELECT BOM.PLAN_ID                                                                           AS PLAN_ID
              ,BOM.BOM_ID                                                                            AS BOM_ID
              ,1                                                                                     AS OP_SEQ
              ,'TRAY'                                                                                AS MATERIAL_CLASS_ID
              ,LU.SEGMENT4 +'::'+LU.SEGMENT5+'::'+LU.SEGMENT6+IIF(LU.SEGMENT3='','','@'+LU.SEGMENT3) AS MATERIAL_BUFFER_ID
              ,1                                                                                     AS PRIORITY
              ,1                                                                                     AS CONSUME_QUANTITY
              ,BOM.ATTRIBUTE1                                                                        AS ATTRIBUTE1
              ,BOM.ATTRIBUTE2                                                                        AS ATTRIBUTE2
              ,BOM.ATTRIBUTE3                                                                        AS ATTRIBUTE3
              ,BOM.ATTRIBUTE4                                                                        AS ATTRIBUTE4
              ,LU.SEGMENT6+IIF(LU.SEGMENT3='','','@'+LU.SEGMENT3)                                    AS ATTRIBUTE13
              ,LU.SEGMENT5                                                                           AS ATTRIBUTE14
              ,LU.SEGMENT6                                                                           AS ATTRIBUTE15
        FROM(
            SELECT  BOM.PLAN_ID
                   ,BOM.BOM_ID
                   ,BOM.ATTRIBUTE1
                   ,BOM.ATTRIBUTE2
                   ,BOM.ATTRIBUTE3
                   ,BOM.ATTRIBUTE4
            FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                    ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_TRAY'
                    AND LU.VALID_YN   = 'Y'
                    AND LU.SEGMENT1   = @V_DIVISION_ID
                    AND LU.SEGMENT2   = @V_GROUP_ID
                    AND LU.ATTRIBUTE2+IIF(LU.SEGMENT3='','','@'+LU.SEGMENT3) = BOM.ATTRIBUTE4
            WHERE BOM.PLAN_ID = @V_PLAN_ID
            GROUP BY BOM.PLAN_ID, BOM.BOM_ID, BOM.ATTRIBUTE1, BOM.ATTRIBUTE2, BOM.ATTRIBUTE3, BOM.ATTRIBUTE4
            ) BOM
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_TRAY'
                AND LU.VALID_YN   = 'Y'
                AND LU.SEGMENT1    = @V_DIVISION_ID
                AND LU.SEGMENT2    = @V_GROUP_ID
                AND BOM.ATTRIBUTE4 = LU.ATTRIBUTE2+IIF(LU.SEGMENT3='','','@'+LU.SEGMENT3)
            UNION ALL
            -- TRAY끼리의 연결을 위한 BOM 추가
            SELECT  @V_PLAN_ID                                                                       AS PLAN_ID
            ,LU.SEGMENT4 +'::'+LU.ATTRIBUTE3+'::'+LU.SEGMENT6+IIF(LU.SEGMENT3='','','@'+LU.SEGMENT3) AS BOM_ID
            ,0                                                                                       AS OP_SEQ
            ,'TRAY'                                                                                  AS MATERIAL_CLASS_ID
            ,LU.SEGMENT4 +'::'+SEGMENT5+'::'+LU.SEGMENT6+IIF(LU.SEGMENT3='','','@'+LU.SEGMENT3)      AS MATERIAL_BUFFER_ID
            ,1                                                                                       AS PRIORITY
            ,1                                                                                       AS CONSUME_QUANTITY
            ,LU.SEGMENT4                                                                             AS ATTRIBUTE1
            ,LU.ATTRIBUTE3                                                                           AS ATTRIBUTE2
            ,LU.SEGMENT6                                                                             AS ATTRIBUTE3
            ,LU.SEGMENT6+IIF(LU.SEGMENT3='','','@'+LU.SEGMENT3)                                      AS ATTRIBUTE4
            ,LU.SEGMENT6+IIF(LU.SEGMENT3='','','@'+LU.SEGMENT3)                                      AS ATTRIBUTE13
            ,SEGMENT5                                                                                AS ATTRIBUTE14
            ,SEGMENT6                                                                                AS ATTRIBUTE15
            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_TRAY'
            AND     LU.VALID_YN   = 'Y'
            AND     LU.SEGMENT1   = @V_DIVISION_ID
            AND     LU.SEGMENT2   = @V_GROUP_ID
            AND     LU.ATTRIBUTE3 != ''

        ------------------------------------------------------------------------
        -- 2nd OCV BOM 추가 -> C타입/20250901/김태현 선임
        -- LOOKUP에 Previous Stage 기준으로 BOM의 Child Stage가 동일한 값을 가져와서 단계를 추가해야 함
        ------------------------------------------------------------------------
        -- INSP -> EOL 추가
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
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
        )
        SELECT  BOM.PLAN_ID                                     AS PLAN_ID
               ,LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3 AS BOM_ID
               ,BOM.OP_SEQ                                      AS OP_SEQ
               ,LEFT(LU.ATTRIBUTE2,LEN(LU.ATTRIBUTE2)-2)        AS MATERIAL_CLASS_ID
               ,LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE2 AS MATERIAL_BUFFER_ID
               ,BOM.PRIORITY                                    AS PRIORITY
               ,BOM.CONSUME_QUANTITY                            AS CONSUME_QUANTITY
               ,LU.SEGMENT4                                     AS ATTRIBUTE1
               ,LU.SEGMENT5                                     AS ATTRIBUTE2
               ,LEFT(LU.ATTRIBUTE3,LEN(LU.ATTRIBUTE3)-2)        AS ATTRIBUTE3
               ,LU.ATTRIBUTE3                                   AS ATTRIBUTE4
               ,LU.ATTRIBUTE2                                   AS ATTRIBUTE13
               ,LU.SEGMENT5                                     AS ATTRIBUTE14
               ,LEFT(LU.ATTRIBUTE2,LEN(LU.ATTRIBUTE2)-2)        AS ATTRIBUTE15
        FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                AND LU.VALID_YN     = 'Y'
                AND LU.ATTRIBUTE1   = 'C'
                AND LU.SEGMENT2     = @V_DIVISION_ID
                AND LU.SEGMENT3     = @V_GROUP_ID
                AND BOM.ATTRIBUTE1  = LU.SEGMENT4
                AND BOM.ATTRIBUTE14 = LU.SEGMENT5
                AND BOM.ATTRIBUTE13 = LU.ATTRIBUTE2
        WHERE   1=1
        AND     BOM.PLAN_ID = @V_PLAN_ID
        GROUP BY BOM.PLAN_ID,LU.SEGMENT4,LU.SEGMENT5,LU.ATTRIBUTE3 ,BOM.OP_SEQ,LU.ATTRIBUTE2 ,BOM.PRIORITY,BOM.CONSUME_QUANTITY
        
        -- CHAR -> EOL에서 CHAR -> INSP로 수정
        UPDATE  BOM
        SET     BOM.MATERIAL_CLASS_ID  = LU.MATERIAL_CLASS_ID
               ,BOM.MATERIAL_BUFFER_ID = LU.MATERIAL_BUFFER_ID
               ,BOM.ATTRIBUTE13        = LU.ATTRIBUTE13
               ,BOM.ATTRIBUTE15        = LU.ATTRIBUTE15
        FROM    SCP_OPT_ENG_BOM_SN BOM
            INNER JOIN(
            SELECT  LEFT(LU.ATTRIBUTE3,LEN(LU.ATTRIBUTE3)-2)              AS MATERIAL_CLASS_ID
                   ,BOM.ATTRIBUTE1+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3    AS MATERIAL_BUFFER_ID
                   ,LU.ATTRIBUTE3                                         AS ATTRIBUTE13
                   ,LEFT(LU.ATTRIBUTE3,LEN(LU.ATTRIBUTE3)-2)              AS ATTRIBUTE15
                   ,BOM.PLAN_ID                                           AS PLAN_ID
                   ,BOM.BOM_ID                                            AS BOM_ID
                   ,BOM.MATERIAL_BUFFER_ID                                AS BOM_MATERIAL_BUFFER_ID
            FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                    ON  LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                    AND LU.VALID_YN     = 'Y'
                    AND LU.SEGMENT2     = @V_DIVISION_ID
                    AND LU.SEGMENT3     = @V_GROUP_ID
                    AND BOM.ATTRIBUTE1  = LU.SEGMENT4
                    AND LU.ATTRIBUTE1   = 'C'
                    AND BOM.ATTRIBUTE14 = LU.SEGMENT5
                    AND BOM.ATTRIBUTE13 = LU.ATTRIBUTE2
                    AND BOM.ATTRIBUTE4 != LU.ATTRIBUTE3
            WHERE   1=1
            AND     BOM.PLAN_ID = @V_PLAN_ID
            GROUP BY LU.ATTRIBUTE3,BOM.ATTRIBUTE1,LU.SEGMENT5,BOM.PLAN_ID,BOM.BOM_ID,BOM.MATERIAL_BUFFER_ID
            ) LU
                ON  BOM.PLAN_ID            = LU.PLAN_ID
                AND BOM.BOM_ID             = LU.BOM_ID
                AND BOM.MATERIAL_BUFFER_ID = LU.BOM_MATERIAL_BUFFER_ID



        OPTION(RECOMPILE)
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
