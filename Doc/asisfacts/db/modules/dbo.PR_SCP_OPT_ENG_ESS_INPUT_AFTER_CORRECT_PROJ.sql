
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_ESS_INPUT_AFTER_CORRECT_PROJ]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
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
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_ESS_INPUT_AFTER_CORRECT_PROJ';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;

    -- 2026.09.15 Minyong Lee : [E20260812-000909] [ESS] Supply > OPT Plan > Plan Control 의 Create Plan ID 팝업 변경 요청드립니다
    DECLARE @V_PARAMETER_ID        NVARCHAR(20)  = (SELECT TOP 1 ISNULL(OPMZ_PRAM_TP_CD, @V_GROUP_ID)
                                                    FROM SCP_OPMZ_PLAN_M 
                                                    WHERE OPMZ_PLAN_ID = @V_PLAN_ID)

    PRINT 'AFTER_CORRECT_PROJ - PLAN_GROUP: ' + @V_GROUP_ID + ' & PARAMETER: ' + @V_PARAMETER_ID
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_PLAN_START_YYYYMM NVARCHAR(6);
    DECLARE @V_PLAN_END_YYYYMM   NVARCHAR(6);

    DECLARE @CHK TABLE(
        INPUT nvarchar(200) NOT NULL,
        CHK nvarchar(200) NOT NULL
    )

    DECLARE @DG_TEMP TABLE(
        SEGMENT3    NVARCHAR(200)
      , SEGMENT4    NVARCHAR(200)
      , SEGMENT5    NVARCHAR(200)
    )

    DECLARE @RR_TEMP TABLE(
     PLAN_ID             NVARCHAR(50)
    ,ROUTING_ID          NVARCHAR(200)
    ,OP_SEQ              NUMERIC(20,0)
    ,RESOURCE_CLASS_ID   NVARCHAR(200)
    ,RESOURCE_ID         NVARCHAR(100)
    ,LOAD_PER            NUMERIC(20,10)
    ,PRIORITY            NUMERIC(20,0)
    ,SETUP_GROUP_ID      NVARCHAR(200)
    ,CONTAINER_CATEGORY  NVARCHAR(100)
    ,CONTAINER_SIZE      NUMERIC(20,0)
    ,ATTRIBUTE1          NVARCHAR(150)
    ,ATTRIBUTE2          NVARCHAR(150)
    ,ATTRIBUTE3          NVARCHAR(150)
    ,ATTRIBUTE15         NVARCHAR(150)
    )

    DECLARE @V_PEG_TYPE     NVARCHAR(1);
    DECLARE @V_NEW_PRIO_YN  NVARCHAR(1);
    DECLARE @V_BASE_MODE    NVARCHAR(20);
    DECLARE @V_DMD_PRIO_YN  NVARCHAR(1);


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
        -- Get Plan Mater Info
        ------------------------------------------------------------------------
        SELECT @V_PLAN_START_YYYYMM = LEFT(PLAN_START_DATE,6)
              ,@V_PLAN_END_YYYYMM   = LEFT(PLAN_END_DATE,6)
        FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        WHERE  PLAN_ID = @V_PLAN_ID

        SELECT  @V_PEG_TYPE = MAX(SEGMENT3)
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_RTF_PEGGING'
        AND     SEGMENT1    = @V_DIVISION_ID
        AND     SEGMENT2    = @V_GROUP_ID
        AND     VALID_YN    = 'Y'
        ;

        SELECT  @V_DMD_PRIO_YN = CASE WHEN COUNT(*) > 0 THEN 'Y' ELSE 'N' END
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_PRIORITY'
        AND     SEGMENT1    = @V_DIVISION_ID
        AND     SEGMENT2    = @V_GROUP_ID
        AND     VALID_YN    = 'Y'
        ;

        SET     @V_NEW_PRIO_YN = CASE WHEN @V_PEG_TYPE IS NOT NULL OR @V_DMD_PRIO_YN = 'Y' THEN 'Y' ELSE 'N' END;

        ----------------------------------------------------------------------------
        -- 2026.08.07 Minyong Lee : [E20260728-000450] [ODS]비용기반 계획수립을 위한 input 데이터 생성
        --   미설정/PRIORITY : 기존 RTF Pegging 로직 / COST : LD Netting 로직 (상호배제)
        ----------------------------------------------------------------------------
        SELECT @V_BASE_MODE = MAX(ATTRIBUTE1)
        FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_BASE'
        AND    SEGMENT1    = @V_DIVISION_ID
        AND    SEGMENT2    = @V_PARAMETER_ID
        AND    VALID_YN    = 'Y'
        ;

        ------------------------------------------------------------------------
        -- 0. DEMAND GROUP
        ------------------------------------------------------------------------
        INSERT INTO @DG_TEMP (
            SEGMENT3
          , SEGMENT4
          , SEGMENT5
        )
        SELECT  DISTINCT SEGMENT3, SEGMENT4, SEGMENT5
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE   1=1
        AND     LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
        AND     SEGMENT2    = @V_DIVISION_ID
        --AND     ATTRIBUTE3  = @V_GROUP_ID -- 2026.08.24 Minyong Lee : ESS DEMAND_GROUP 룩업 Key에서 PLAN_GROUP 제외 (권순지 책임님 요청)
        AND     VALID_YN    = 'Y'
        AND     ATTRIBUTE5  = 'Y'

        ------------------------------------------------------------------------
        -- 1. DEMAND
        ------------------------------------------------------------------------
        UPDATE  D
        SET     D.DEMAND_ID = REPLACE(D.DEMAND_ID, 'LINKBIZ', 'PROJBIZ')
              , D.BUFFER_ID = REPLACE(D.BUFFER_ID, 'LINKBIZ', 'PROJBIZ')
              , D.DEMAND_GROUP = REPLACE(D.DEMAND_GROUP, 'LINKBIZ', 'PROJBIZ')
              , D.PRIORITY_GROUP = CASE 
                    WHEN @V_NEW_PRIO_YN = 'Y' AND ISNULL(@V_BASE_MODE, '') <> 'COST'
                        THEN REPLACE(D.PRIORITY_GROUP, 'LINKBIZ', 'PROJBIZ')
                    ELSE 'PROJBIZ' 
                END
              , D.ATTRIBUTE3 = 'PROJBIZ'
              , D.UPDATE_ID = @V_PROGRAM_NAME
              , D.UPDATE_TIME = GETDATE()
        FROM    SCP_OPT_ENG_DEMAND_SN D
            INNER JOIN @DG_TEMP DG
                ON  D.ATTRIBUTE2 = DG.SEGMENT4
        WHERE   1=1
        AND     PLAN_ID = @V_PLAN_ID
        AND     ATTRIBUTE3 = 'LINKBIZ'

        ------------------------------------------------------------------------
        -- 2. ITEM_SITE
        ------------------------------------------------------------------------
        -- 2.1 PROJECT DEMAND BUFFER
        UPDATE  ITS
        SET     ITS.BUFFER_ID = ITS.SITE_ID+'::'+ITS.ITEM_ID+'::PROJBIZ@'+ATTRIBUTE1+'@'+ATTRIBUTE2
              , ITS.STAGE = 'PROJBIZ'
              , ITS.UPDATE_ID = @V_PROGRAM_NAME
              , ITS.UPDATE_TIME = GETDATE()
        FROM    SCP_OPT_ENG_ITEM_SITE_SN AS ITS
            INNER JOIN (
                SELECT DISTINCT SEGMENT4
                FROM @DG_TEMP
            ) DG
                ON  1=1
                AND ITEM_ID = DG.SEGMENT4
        WHERE   1=1
        AND     ITS.PLAN_ID = @V_PLAN_ID
        AND     ITS.ATTRIBUTE3 = 'LINKBIZ'

        -- 2.2 PRODUCTION BUFFER
        INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN (
            PLAN_ID
          , BUFFER_ID
          , SITE_ID
          , ITEM_ID
          , GRADE
          , ITEM_CLASS_ID
          , STAGE
          , SETUP_GROUP_ID
          , ATTRIBUTE1
          , ATTRIBUTE2
          , ATTRIBUTE3
          , INSERT_ID
          , INSERT_TIME
          , UPDATE_ID
          , UPDATE_TIME
        )
        SELECT  ITS.PLAN_ID
              , ITS.SITE_ID+'::'+DG.SEGMENT5+'||'+DG.SEGMENT3+'::PROJECT'   AS BUFFER_ID
              , ITS.SITE_ID                                                 AS SITE_ID
              , DG.SEGMENT5+'||'+DG.SEGMENT3                                AS ITEM_ID
              , ITS.GRADE                                                   AS GRADE
              , 'PRODUCTION'                                                AS ITEM_CLASS_ID
              , 'PROJECT'                                                   AS STAGE
              , DG.SEGMENT5+'||'+ISNULL(LU.GRP,'-')                         AS SETUP_GROUP_ID
              , ATTRIBUTE1                                                  AS ATTRIBUTE1
              , ATTRIBUTE2                                                  AS ATTRIBUTE2
              , ATTRIBUTE3                                                  AS ATTRIBUTE3
              , @V_PROGRAM_NAME                                             AS INSERT_ID
              , GETDATE()                                                   AS INSERT_TIME
              , @V_PROGRAM_NAME                                             AS UPDATE_ID
              , GETDATE()                                                   AS UPDATE_TIME
        FROM    SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
            INNER JOIN @DG_TEMP DG
                ON  1=1
                AND DG.SEGMENT3 = ITS.ITEM_ID
                AND DG.SEGMENT5 = ITS.ATTRIBUTE2
            -- 2026.09.10 Minyong Lee : [E20260827-001489] [ODS] Project 공정의 Setup_group_id 생성방법 변경요청 드립니다
            INNER JOIN (
                    SELECT  SEGMENT1   AS SFX
                          , ATTRIBUTE1 AS GRP
                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SETUP_PROJ'
                    AND     VALID_YN = 'Y'
                ) LU
                ON  RIGHT(DG.SEGMENT3, 3) = LU.SFX
        WHERE   1=1
        AND     ITS.PLAN_ID = @V_PLAN_ID
        AND     ITS.ATTRIBUTE3 = 'LINKBIZ'
        AND     ITS.ITEM_CLASS_ID = 'DEMAND'

        -- 2.2 MATERIAL BUFFER
        UPDATE  ITS
        SET     ITEM_CLASS_ID = 'MATERIAL'
              , UPDATE_ID = @V_PROGRAM_NAME
              , UPDATE_TIME = GETDATE()
        FROM    SCP_OPT_ENG_ITEM_SITE_SN ITS
            INNER JOIN @DG_TEMP DG
                ON  ITS.ITEM_ID = DG.SEGMENT3
                AND ITS.ATTRIBUTE2 = DG.SEGMENT5
        WHERE   1=1
        AND     ITS.PLAN_ID = @V_PLAN_ID
        AND     ITS.STAGE = 'LINKBIZ'
        AND     ITS.ITEM_CLASS_ID = 'DEMAND'

        ------------------------------------------------------------------------
        -- 3. BOD
        ------------------------------------------------------------------------
        DELETE  B
        FROM    SCP_OPT_ENG_BOD_SN B
            INNER JOIN (
                SELECT DISTINCT SEGMENT4
                FROM @DG_TEMP
            ) DG
                ON  DG.SEGMENT4 = B.ATTRIBUTE5
        WHERE   1=1
        AND     B.PLAN_ID = @V_PLAN_ID 
        AND     B.ATTRIBUTE3 = 'LINKBIZ'

        INSERT INTO SCP_OPT_ENG_BOD_SN (
            PLAN_ID
          , BOD_ID
          , FROM_BUFFER_ID
          , TO_BUFFER_ID
          , TRANSPORT_MODE
          , PRIORITY
          , EFF_START_DATE
          , EFF_END_DATE
          , DEFAULT_LEAD_TIME
          , SUNDAY_LEAD_TIME
          , MONDAY_LEAD_TIME
          , TUESDAY_LEAD_TIME
          , WEDNESDAY_LEAD_TIME
          , THURSDAY_LEAD_TIME
          , FRIDAY_LEAD_TIME
          , SATURDAY_LEAD_TIME
          , INSERT_ID
          , INSERT_TIME
          , UPDATE_ID
          , UPDATE_TIME
        )
        SELECT  ITS.PLAN_ID                     AS PLAN_ID
              , ITS2.BUFFER_ID+ITS.BUFFER_ID    AS BOD_ID
              , ITS2.BUFFER_ID                  AS FROM_BUFFER_ID
              , ITS.BUFFER_ID                   AS TO_BUFFER_ID
              , 'TRK'                           AS TRANSPORT_MODE
              , 1                               AS PRIORITY
              , @V_PLAN_START_YYYYMMDD          AS EFF_START_DATE
              , @V_PLAN_END_YYYYMMDD            AS EFF_END_DATE
              , 0                               AS DEFAULT_LEAD_TIME
              , 0                               AS SUNDAY_LEAD_TIME
              , 0                               AS MONDAY_LEAD_TIME
              , 0                               AS TUESDAY_LEAD_TIME
              , 0                               AS WEDNESDAY_LEAD_TIME
              , 0                               AS THURSDAY_LEAD_TIME
              , 0                               AS FRIDAY_LEAD_TIME
              , 0                               AS SATURDAY_LEAD_TIME
              , @V_PROGRAM_NAME                 AS INSERT_ID
              , GETDATE()                       AS INSERT_TIME
              , @V_PROGRAM_NAME                 AS UPDATE_ID
              , GETDATE()                       AS UPDATE_TIME
        FROM    SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK) 
            INNER JOIN @DG_TEMP DG
                ON  ITS.ITEM_ID = SEGMENT4
            INNER JOIN (
                SELECT  BUFFER_ID, ITEM_ID
                FROM    SCP_OPT_ENG_ITEM_SITE_SN WITH(NOLOCK)
                WHERE   1=1
                AND     PLAN_ID = @V_PLAN_ID 
                AND     STAGE = 'PROJECT'
            ) ITS2
                ON  ITS2.ITEM_ID = SEGMENT5+'||'+SEGMENT3
        WHERE   1=1
        AND     ITS.PLAN_ID = @V_PLAN_ID 
        AND     ITS.STAGE = 'PROJBIZ'

        ------------------------------------------------------------------------
        -- 4. RESOURCE
        -- 2026.09.17 Minyong Lee : [E20260914-000347] [ODS] Project 공정의 Resource ID 생성기준 변경요청드립니다
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_RESOURCE_SN (
            PLAN_ID
          , RESOURCE_ID
          , RESOURCE_NAME
          , SITE_ID
          , STAGE
          , RESOURCE_TYPE
          , GROUP_SETUP_CONTROL_CODE
          , ITEM_SETUP_CONTROL_CODE
          , EVERY_UPPER_CONTROL_CODE
          , EVERY_LOWER_CONTROL_CODE
          , ATTRIBUTE1
          , ATTRIBUTE3
          , ATTRIBUTE5
          , ATTRIBUTE15
          , INSERT_ID
          , INSERT_TIME
          , UPDATE_ID
          , UPDATE_TIME
        )
        SELECT  DISTINCT 
                R.PLAN_ID
              , ITS.SITE_ID+'::RES||'+DG.SEGMENT5       AS RESOURCE_ID
              , 'RES||'+DG.SEGMENT5                     AS RESOURCE_NAME
              , ITS.SITE_ID                             AS SITE_ID
              , 'PROJECT'                               AS STAGE
              , R.RESOURCE_TYPE                         AS RESOURCE_TYPE
              , 'PROJECT'                               AS GROUP_SETUP_CONTROL_CODE	
              , 'PROJECT'                               AS ITEM_SETUP_CONTROL_CODE	
              , R.EVERY_UPPER_CONTROL_CODE	            AS EVERY_UPPER_CONTROL_CODE
              , R.EVERY_LOWER_CONTROL_CODE	            AS EVERY_LOWER_CONTROL_CODE
              , ITS.SITE_ID                             AS ATTRIBUTE1
              , 'PROJECT'                               AS ATTRIBUTE3
              , DG.SEGMENT5                             AS ATTRIBUTE5
              , 'RES||'+DG.SEGMENT5                     AS ATTRIBUTE15
              , @V_PROGRAM_NAME                         AS INSERT_ID
              , GETDATE()                               AS INSERT_TIME
              , @V_PROGRAM_NAME                         AS UPDATE_ID
              , GETDATE()                               AS UPDATE_TIME
        FROM    SCP_OPT_ENG_RESOURCE_SN R WITH(NOLOCK)
            -- 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응
            INNER JOIN  (
                SELECT DISTINCT LINE_ID, ITEM_ID
                FROM    SCP_MST_TACT_TIME_OSP WITH(NOLOCK)
                WHERE   1=1
                AND     DIVISION_ID = @V_DIVISION_ID
                AND     VALID_YN    = 'Y'
                UNION ALL
                SELECT DISTINCT LINE_ID, ITEM_ID 
                FROM    SCP_OPMZ_DDLY_CAPA WITH(NOLOCK)
                WHERE   1=1
                AND     DIVISION_ID = @V_DIVISION_ID
                AND     VALID_YN = 'Y'
            ) TT
                ON  1=1
                AND R.RESOURCE_NAME = TT.LINE_ID

            INNER JOIN  @DG_TEMP DG
                ON  TT.ITEM_ID = DG.SEGMENT3

            INNER JOIN (
                SELECT  DISTINCT SITE_ID, ITEM_ID
                FROM    SCP_OPT_ENG_ITEM_SITE_SN WITH(NOLOCK)
                WHERE   PLAN_ID = @V_PLAN_ID
            ) ITS
                ON  ITS.ITEM_ID = DG.SEGMENT4
        WHERE   1=1
        AND     R.PLAN_ID = @V_PLAN_ID
        AND     R.STAGE = 'LINK'

        ------------------------------------------------------------------------
        -- 5. RESOURCE_EVERY_CAL
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN (
            PLAN_ID
          , RESOURCE_ID
          , TYPE
          , START_DATE
          , END_DATE
          , DAILY_VALUE
          , CALENDAR_LEVEL
          , INSERT_ID
          , INSERT_TIME
          , UPDATE_ID
          , UPDATE_TIME
        )
        SELECT  @V_PLAN_ID                                                  AS PLAN_ID
              , R.RESOURCE_ID                                               AS RESOURCE_ID
              , 'upper_limit'                                               AS TYPE
              , @V_PLAN_START_YYYYMMDD                                      AS START_DATE
              , @V_PLAN_END_YYYYMMDD                                        AS END_DATE
              , 86400                                                       AS DAILY_VALUE
              , 'L0'                                                        AS CALENDAR_LEVEL 
              , @V_PROGRAM_NAME                                             AS INSERT_ID
              , GETDATE()                                                   AS INSERT_TIME
              , @V_PROGRAM_NAME                                             AS UPDATE_ID
              , GETDATE()                                                   AS UPDATE_TIME
        FROM    SCP_OPT_ENG_RESOURCE_SN R WITH(NOLOCK) 
        WHERE   1=1
        AND     R.PLAN_ID = @V_PLAN_ID
        AND     R.STAGE = 'PROJECT'

        ------------------------------------------------------------------------
        -- 6. BOM
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_BOM_SN (
            PLAN_ID
          , BOM_ID
          , OP_SEQ
          , MATERIAL_CLASS_ID
          , MATERIAL_BUFFER_ID
          , PRIORITY
          , CONSUME_QUANTITY
          , ATTRIBUTE1
          , ATTRIBUTE2
          , ATTRIBUTE3
          , ATTRIBUTE14
          , ATTRIBUTE15
          , INSERT_ID
          , INSERT_TIME
          , UPDATE_ID
          , UPDATE_TIME
        )
        SELECT  @V_PLAN_ID              AS PLAN_ID
              , ITS.BUFFER_ID          AS BOM_ID
              , 0                       AS OP_SEQ
              , ITS2.STAGE              AS MATERIAL_CLASS_ID
              , ITS2.BUFFER_ID          AS MATERIAL_BUFFER_ID
              , 1                       AS PRIORITY
              , 1                       AS CONSUME_QUANTITY
              , ITS.SITE_ID            AS ATTRIBUTE1
              , ITS.ITEM_ID            AS ATTRIBUTE2
              , ITS.STAGE              AS ATTRIBUTE3
              , ITS2.ITEM_ID            AS ATTRIBUTE14
              , ITS2.STAGE              AS ATTRIBUTE15
              , @V_PROGRAM_NAME         AS INSERT_ID
              , GETDATE()               AS INSERT_TIME
              , @V_PROGRAM_NAME         AS UPDATE_ID
              , GETDATE()               AS UPDATE_TIME
        FROM    @DG_TEMP DG
            INNER JOIN (
                SELECT  BUFFER_ID, SITE_ID, ITEM_ID, STAGE
                FROM    SCP_OPT_ENG_ITEM_SITE_SN
                WHERE   1=1
                AND     PLAN_ID = @V_PLAN_ID
                AND     ITEM_CLASS_ID = 'PRODUCTION'
                AND     STAGE = 'PROJECT'
            ) ITS
                ON  ITS.ITEM_ID = DG.SEGMENT5+'||'+DG.SEGMENT3
            INNER JOIN (
                SELECT  BUFFER_ID, ITEM_ID, STAGE, ATTRIBUTE2
                FROM    SCP_OPT_ENG_ITEM_SITE_SN
                WHERE   1=1
                AND     PLAN_ID = @V_PLAN_ID
                AND     ITEM_CLASS_ID = 'MATERIAL'
                AND     STAGE = 'LINKBIZ'
            ) ITS2
                ON  ITS2.ITEM_ID = DG.SEGMENT3
                AND ITS2.ATTRIBUTE2 = DG.SEGMENT5

        ------------------------------------------------------------------------
        -- 7. ROUTING_RESOURCE
        ------------------------------------------------------------------------
        INSERT INTO @RR_TEMP (
            PLAN_ID
            , ROUTING_ID
            , OP_SEQ
            , RESOURCE_CLASS_ID
            , RESOURCE_ID
            , LOAD_PER
            , PRIORITY
            , SETUP_GROUP_ID
            , CONTAINER_CATEGORY
            , CONTAINER_SIZE    
            , ATTRIBUTE1
            , ATTRIBUTE2
            , ATTRIBUTE3
            , ATTRIBUTE15
        )
        SELECT  R.PLAN_ID                                                                               AS PLAN_ID
              , R.ATTRIBUTE1+'::'+DG.SEGMENT5+'||'+DG.SEGMENT3+'::'+R.ATTRIBUTE3+'::'+R.ATTRIBUTE15     AS ROUTING_ID
              , 0                                                                                       AS OP_SEQ
              , 'LINE'                                                                                  AS RESOURCE_CLASS_ID
              , R.RESOURCE_ID                                                                           AS RESOURCE_ID
              , 1                                                                                       AS LOAD_PER
              , 1                                                                                       AS PRIORITY
              , DG.SEGMENT5+'||'+ISNULL(LU.GRP,'-')                                                     AS SETUP_GROUP_ID
              , NULL                                                                                    AS CONTAINTER_CATEGORY
              , NULL                                                                                    AS CONTAINTER_SIZE
              , R.ATTRIBUTE1                                                                            AS ATTRIBUTE1
              , DG.SEGMENT5+'||'+DG.SEGMENT3                                                            AS ATTRIBUTE2
              , R.ATTRIBUTE3                                                                            AS ATTRIBUTE3
              , R.ATTRIBUTE15                                                                           AS ATTRIBUTE15
        FROM    SCP_OPT_ENG_RESOURCE_SN R WITH(NOLOCK)
            -- 2026.09.17 Minyong Lee : [E20260914-000347] [ODS] Project 공정의 Resource ID 생성기준 변경요청드립니다
            INNER JOIN @DG_TEMP DG
                ON  R.ATTRIBUTE5 = DG.SEGMENT5
            INNER JOIN (
                SELECT  DISTINCT SITE_ID, ITEM_ID
                FROM    SCP_OPT_ENG_ITEM_SITE_SN WITH(NOLOCK)
                WHERE   PLAN_ID = @V_PLAN_ID
            ) ITS
                ON  ITS.ITEM_ID = DG.SEGMENT4
            -- 2026.09.10 Minyong Lee : [E20260827-001489] [ODS] Project 공정의 Setup_group_id 생성방법 변경요청 드립니다
            INNER JOIN (
                    SELECT  SEGMENT1   AS SFX
                          , ATTRIBUTE1 AS GRP
                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SETUP_PROJ'
                    AND     VALID_YN = 'Y'
                ) LU
                ON  RIGHT(DG.SEGMENT3, 3) = LU.SFX
        WHERE   1=1
        AND     R.PLAN_ID = @V_PLAN_ID
        AND     R.STAGE = 'PROJECT'

        -- 2026.09.10 Minyong Lee : [E20260827-001749] [ODS] ESS 엔진수행 속도개선 및 정수화를 위한 요청건
        UPDATE  A
        SET     A.CONTAINER_CATEGORY = A.ATTRIBUTE3
              , A.CONTAINER_SIZE = 1
        FROM    @RR_TEMP A
            INNER JOIN (
                SELECT  SEGMENT3 AS STAGE
                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CONVERT_TO_INT'
                AND     SEGMENT1 = @V_DIVISION_ID
                AND     SEGMENT2 = @V_GROUP_ID
                AND     SEGMENT3 = 'PROJECT'
                AND     VALID_YN = 'Y'
            ) AS B
               ON A.ATTRIBUTE3 = B.STAGE
        ;

        INSERT INTO SCP_OPT_ENG_ROUTING_RESOURCE_SN (
            PLAN_ID
          , ROUTING_ID
          , OP_SEQ
          , RESOURCE_CLASS_ID
          , RESOURCE_ID
          , LOAD_PER
          , PRIORITY
          , START_DATE
          , END_DATE
          , SETUP_GROUP_ID
          , CONTAINER_CATEGORY
          , CONTAINER_SIZE
          , ATTRIBUTE1
          , ATTRIBUTE2
          , ATTRIBUTE3
          , ATTRIBUTE14
          , ATTRIBUTE15
          , INSERT_ID
          , INSERT_TIME
          , UPDATE_ID
          , UPDATE_TIME
        )
        SELECT  RR.PLAN_ID
              , RR.ROUTING_ID+'::'+MIN(CM.BASIS_YYYYMMDD)                                                   AS ROUTING_ID
              , RR.OP_SEQ                                                                                   AS OP_SEQ
              , RR.RESOURCE_CLASS_ID                                                                        AS RESOURCE_CLASS_ID
              , RR.RESOURCE_ID                                                                              AS RESOURCE_ID
              , RR.LOAD_PER                                                                                 AS LOAD_PER
              , RR.PRIORITY                                                                                 AS PRIORITY
              , MIN(CM.BASIS_YYYYMMDD)                                                                      AS START_DATE
              , CONVERT(NVARCHAR(8), DATEADD(DAY, 1, CONVERT(DATETIME, MAX(CM.BASIS_YYYYMMDD))), 112)       AS END_DATE
              , RR.SETUP_GROUP_ID                                                                           AS SETUP_GROUP_ID
              , RR.CONTAINER_CATEGORY                                                                       AS CONTAINER_CATEGORY
              , RR.CONTAINER_SIZE                                                                           AS CONTAINER_SIZE
              , RR.ATTRIBUTE1                                                                               AS ATTRIBUTE1
              , RR.ATTRIBUTE2                                                                               AS ATTRIBUTE2
              , RR.ATTRIBUTE3                                                                               AS ATTRIBUTE3
              , CM.BASIS_YYYYMM                                                                             AS ATTRIBUTE14
              , RR.ATTRIBUTE15                                                                              AS ATTRIBUTE15
              , @V_PROGRAM_NAME                                                                             AS INSERT_ID
              , GETDATE()                                                                                   AS INSERT_TIME
              , @V_PROGRAM_NAME                                                                             AS UPDATE_ID
              , GETDATE()                                                                                   AS UPDATE_TIME
        FROM    @RR_TEMP RR
            INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK) 
                ON  1=1
                AND CM.BASIS_YYYYMMDD >= @V_PLAN_START_YYYYMMDD
                AND CM.BASIS_YYYYMMDD <  @V_PLAN_END_YYYYMMDD
        GROUP BY CM.BASIS_YYYYMM
               , RR.PLAN_ID
               , RR.ROUTING_ID
               , RR.OP_SEQ
               , RR.RESOURCE_CLASS_ID
               , RR.RESOURCE_ID
               , RR.LOAD_PER
               , RR.PRIORITY
               , RR.SETUP_GROUP_ID
               , RR.CONTAINER_CATEGORY
               , RR.CONTAINER_SIZE    
               , RR.ATTRIBUTE1
               , RR.ATTRIBUTE2
               , RR.ATTRIBUTE3
               , RR.ATTRIBUTE15

        ------------------------------------------------------------------------
        -- 8. ROUTING
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_ROUTING_SN (
            PLAN_ID
          , ROUTING_ID
          , OP_SEQ
          , LEAD_TIME
          , YIELD
          , ATTRIBUTE1
          , ATTRIBUTE2
          , ATTRIBUTE3
          , ATTRIBUTE14
          , ATTRIBUTE15
          , INSERT_ID
          , INSERT_TIME
          , UPDATE_ID
          , UPDATE_TIME
        )
        SELECT  RR.PLAN_ID
              , RR.ROUTING_ID+'::'+MIN(CM.BASIS_YYYYMMDD)                                                   AS ROUTING_ID
              , RR.OP_SEQ                                                                                   AS OP_SEQ 
              , 0                                                                                           AS LEAD_TIME
              , 1                                                                                           AS YIELD
              , RR.ATTRIBUTE1                                                                               AS ATTRIBUTE1
              , RR.ATTRIBUTE2                                                                               AS ATTRIBUTE2
              , RR.ATTRIBUTE3                                                                               AS ATTRIBUTE3
              , RR.ATTRIBUTE15                                                                              AS ATTRIBUTE14
              , CM.BASIS_YYYYMM                                                                             AS ATTRIBUTE15
              , @V_PROGRAM_NAME                                                                             AS INSERT_ID
              , GETDATE()                                                                                   AS INSERT_TIME
              , @V_PROGRAM_NAME                                                                             AS UPDATE_ID
              , GETDATE()                                                                                   AS UPDATE_TIME
        FROM    @RR_TEMP RR
            INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK) 
                ON  1=1
                AND CM.BASIS_YYYYMMDD >= @V_PLAN_START_YYYYMMDD
                AND CM.BASIS_YYYYMMDD <  @V_PLAN_END_YYYYMMDD
        GROUP BY CM.BASIS_YYYYMM
               , RR.PLAN_ID
               , RR.ROUTING_ID
               , RR.OP_SEQ
               , RR.ATTRIBUTE1
               , RR.ATTRIBUTE2
               , RR.ATTRIBUTE3
               , RR.ATTRIBUTE15

        ------------------------------------------------------------------------
        -- 9. IBR
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_ITEM_BOM_ROUTING_SN (
            PLAN_ID
          , ROUTING_BOM_MAPPING_ID
          , BUFFER_ID
          , ROUTING_ID
          , BOM_ID
          , EFF_START_DATE
          , EFF_END_DATE
          , PRIORITY
          , INSERT_ID
          , INSERT_TIME
          , UPDATE_ID
          , UPDATE_TIME
        )
        SELECT  ITS.PLAN_ID             AS PLAN_ID
              , 'RB'+RR.ROUTING_ID      AS ROUTING_BOM_MAPPING_ID
              , ITS.BUFFER_ID           AS BUFFER_ID
              , RR.ROUTING_ID           AS ROUTING_ID
              , ITS.BUFFER_ID           AS BOM_ID
              , RR.START_DATE           AS EFF_START_DATE
              , RR.END_DATE             AS EFF_END_DATE
              , 1                       AS PRIORITY
              , @V_PROGRAM_NAME         AS INSERT_ID
              , GETDATE()               AS INSERT_TIME
              , @V_PROGRAM_NAME         AS UPDATE_ID
              , GETDATE()               AS UPDATE_TIME
        FROM    SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
            INNER JOIN (
                SELECT  ROUTING_ID
                      , START_DATE
                      , END_DATE
                      , ATTRIBUTE1
                      , ATTRIBUTE2
                      , ATTRIBUTE3
                FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN WITH(NOLOCK)
                WHERE   1=1
                AND     PLAN_ID = @V_PLAN_ID
                AND     ATTRIBUTE3 = 'PROJECT'
            ) RR
                ON  1=1
                AND RR.ATTRIBUTE1 = ITS.SITE_ID
                AND RR.ATTRIBUTE2 = ITS.ITEM_ID
                AND RR.ATTRIBUTE3 = ITS.STAGE
        WHERE   ITS.PLAN_ID = @V_PLAN_ID
        AND     ITS.STAGE = 'PROJECT'

	END TRY
	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_ESS_RUN_MAIN_PROC;
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
