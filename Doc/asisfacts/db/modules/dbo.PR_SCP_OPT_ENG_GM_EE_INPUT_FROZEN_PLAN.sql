



CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_EE_INPUT_FROZEN_PLAN]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
    ,@T_SCP_PLAN            optTableType_SCP_PLAN READONLY
AS 
BEGIN
    --2025.02.14 Taehyun Initial Release
    -- 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영.
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_EE_INPUT_FROZEN_PLAN';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE       DATETIME;
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_PROD_FROZEN         INT;
    DECLARE @V_PROD_FROZEN_END     NVARCHAR(8); -- Prod Frozen 다음 일자 정보
    DECLARE @V_SYS_DIVS_CD       NVARCHAR(8)
    DECLARE @V_PROD_FP_FRZ_TYPE  NVARCHAR(20)

	-- 임시 : 아래 변수 수정 처리 필요
    DECLARE @V_SCP_PLAN_TYPE    NVARCHAR(200);
    DECLARE @V_SCP_PLAN_DATE    NVARCHAR(200);
    DECLARE @V_SCP_PLAN_SEQ    NVARCHAR(200);
    DECLARE @V_CURRENT_YYYYMMDD NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(CURRENT_TIMESTAMP, 'MON')), 112);

    DECLARE @PROD_FROZEN_TEMP TABLE(
     SCM_SITE_ID NVARCHAR(20)
    ,ITEM_ID     NVARCHAR(50)
    ,STAGE       NVARCHAR(10)
    ,LINE_ID     NVARCHAR(20)
    ,PLAN_DATE   NVARCHAR(8)
    ,PLAN_IN_QTY NUMERIC(20,10)
    ,SOURCE_CHK  NVARCHAR(50)
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
        -- Data Insert Start
        ------------------------------------------------------------------------
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
		
	    -- 전극 Plan Type 확인
		--SELECT @V_SCP_PLAN_DATE = A.PLAN_START_YYYYMMDD
		--     , @V_SCP_PLAN_TYPE = A.PLAN_TYPE
		--     , @V_SCP_PLAN_SEQ  = A.PLAN_SEQ
  --      FROM  (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
		--            , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_TYPE_ORDER DESC, PLAN_SEQ DESC ) AS PLAN_RANK
  --             FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
		--	   -- 전극 Division 에 해당하는 사업부 확인
  --             WHERE  DIVISION_ID          = @V_DIVISION_ID -- 전극 Division 변수
  --             AND    PLAN_START_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -14, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 전주 월요일 YYYYMMDD
  --             AND    PLAN_START_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD,  -7, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 당주 월요일 YYYYMMDD
  --            ) A   
  --      WHERE PLAN_RANK = 1 

        
        ------------------------------------------------------------------------
        -- 2025.06.23 김태현 : Frozen Master 정보 활용
        ------------------------------------------------------------------------
        SELECT  @V_SYS_DIVS_CD      = SYS_DIVS_CD
               ,@V_SCP_PLAN_TYPE    = PLAN_TYPE
               ,@V_SCP_PLAN_DATE    = PLAN_YYYYMMDD
               ,@V_SCP_PLAN_SEQ     = PLAN_SEQ
               ,@V_PROD_FP_FRZ_TYPE = PLAN_TYPE
        FROM    (SELECT  TOP 1 SYS_DIVS_CD
                              ,PLAN_TYPE
                              ,PLAN_YYYYMMDD
                              ,PLAN_SEQ
                 FROM    SCP_OPT_ENG_FROZEN_MASTER_SN WITH(NOLOCK)
                 WHERE   1=1
                 AND     PLAN_ID     = @V_PLAN_ID
                 AND     DIVISION_ID = @V_DIVISION_ID
                 AND     FROZEN_TYPE = 'PROD'
                ) A

		IF @V_SYS_DIVS_CD = 'FP' AND @V_PROD_FP_FRZ_TYPE = 'Latest FP Plan'
            BEGIN 
                INSERT INTO SCP_OPT_ENG_FROZEN_PLAN_SN(
                                                        PLAN_ID
                                                    ,FROZEN_ID
                                                    ,ROUTING_BOM_MAPPING_ID
                                                    ,OP_SEQ
                                                    ,RESOURCE_ID
                                                    ,QUANTITY
                                                    ,EFFECTIVE_DATE
                                                    ,ATTRIBUTE1
                                                    ,ATTRIBUTE2
                                                    ,ATTRIBUTE3
                                                    ,ATTRIBUTE13
                                                    ,ATTRIBUTE14
                                                    ,ATTRIBUTE15
                                                    )
                    SELECT  @V_PLAN_ID                                                      AS PLAN_ID
                        ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+LINE_ID+'::'+PLAN_DATE AS FROZEN_ID
                        ,'RB'+B.ROUTING_ID                                               AS ROUTING_BOM_MAPPING_ID
                        ,0                                                               AS OP_SEQ
                        ,SCM_SITE_ID+'::'+LINE_ID                                        AS RESOURCE_ID
                        ,QTY                                                             AS QUANTITY
                        ,PLAN_DATE                                                       AS EFFECTIVE_DATE
                        ,SCM_SITE_ID                                                     AS SITE_ID
                        ,ITEM_ID                                                         AS ITEM_ID    
                        ,STAGE                                                           AS STAGE      
                        ,SOURCE_CHK                                                      AS SOURCE_CHK
                        ,LINE_ID                                                         AS LINE_ID    
                        ,PLAN_MONTH                                                      AS PLAN_MONTH 
                    FROM(
                        SELECT  SCM_SITE_ID       AS SCM_SITE_ID
                            ,ITEM_ID           AS ITEM_ID
                            ,STAGE             AS STAGE
                            ,LINE_ID           AS LINE_ID
                            ,PLAN_DATE         AS PLAN_DATE
                            ,LEFT(PLAN_DATE,6) AS PLAN_MONTH
                            ,SUM(PLAN_IN_QTY)  AS QTY
                            ,SOURCE_CHK            AS SOURCE_CHK
                        FROM(
                                SELECT    V.SCM_SITE_ID AS SCM_SITE_ID
                                        , V.ITEM_ID     AS ITEM_ID
                                        --, 'COATING'     AS STAGE
										, CASE WHEN V.OPERATION_ID = 'A5000' THEN 'NND' ELSE 'COATING' END  AS STAGE
                                        --, V.LINE_ID     AS LINE_ID
										, V.LINE_ID + CASE WHEN V.OPERATION_ID = 'A5000' AND V.ELECTRODE_TYPE = 'Anode' THEN '@A' 
														   WHEN V.OPERATION_ID = 'A5000' AND V.ELECTRODE_TYPE = 'Cathode' THEN '@C'
														   ELSE '' END  AS LINE_ID
                                        , V.PLAN_DATE   AS PLAN_DATE
                                        , SUM(V.PLAN_QTY)    AS PLAN_IN_QTY  -- AFTER_CORRECT에서  수율 먹여서 투입수량으로 변경.
                                        , 'FP_RELEASE_PLAN' AS SOURCE_CHK
                                FROM    (SELECT 
                                                M.SCM_SITE_ID
                                                , ISNULL(FI.PACKER_PLAN_ITEM_ID, R.ITEM_ID) AS ITEM_ID --2018.06.29
                                                , R.LINE_ID
                                                , CONVERT(NVARCHAR, R.PLAN_DATE, 112)       AS PLAN_DATE
                                                , R.PLAN_QTY          -- OUT 수량
                                                /* Input 생성 시 미사용 컬럼 주석처리.
                                                , r.top_item_id 
                                                , r.item_id origin_item_id --2018.06.29
                                                , r.company_id
                                                , r.division_id
                                                , r.site_id
                                                , r.fp_production_type  -- 2025.05.13 양산 및 샘플, 테스트 등등.. 나중에 조건 걸어야 될 수도 있음.
                                                , r.plant_id
                                                , r.factory_id  
                                                , r.operation_id
                                                , r.location    
                                                , r.market
                                                , r.electrode_type
                                                -- IN 수량
                                                , CASE WHEN r.plan_in_qty <= 0 THEN r.plan_qty
                                                    ELSE r.plan_in_qty
                                                END plan_in_qty
                                                , r.equipment_id */
												, R.OPERATION_ID
												, R.ELECTRODE_TYPE
                                        FROM DBO.SCM_DNM_FP_RELEASE_PLAN_V_SN R WITH(NOLOCK)
                                        LEFT JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)--2018.06.29
                                            ON  R.DIVISION_ID   = FI.DIVISION_ID
                                            AND R.ITEM_ID       = FI.ITEM_ID
                                        OUTER APPLY (
                                                    SELECT TOP 1 ISNULL(I.SCP_OPERATION_GROUP,'') AS SCP_OPERATION_GROUP
                                                        FROM DBO.SCM_MST_ITEM_SN              I WITH(NOLOCK)
                                                    WHERE 1=1
                                                        AND I.DIVISION_ID          = R.DIVISION_ID
                                                        AND I.ITEM_ID              = R.ITEM_ID
                                                    ) AS OG
                                        OUTER APPLY (
                                                    SELECT TOP 1 ISNULL(I.SCM_SITE_ID,'') AS SCM_SITE_ID
                                                        FROM DBO.SCM_MST_SITE             I WITH(NOLOCK)
                                                    WHERE 1 = 1
                                                        AND I.PLANT_ID             = R.PLANT_ID
                                                        AND I.OPERATION_GROUP      = OG.SCP_OPERATION_GROUP
                                                        AND I.SITE_TYPE            = 'PLANT'
                                                        AND I.VALID_YN             = 'Y'
                                                    ) AS M
                                        ) V
                                    INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                                        ON  FM.FROZEN_TYPE = 'PROD'
                                        AND FM.STAGE = IIF(V.OPERATION_ID = 'A5000','NND','COATING')
                                        AND FM.PLAN_ID = @V_PLAN_ID
                                WHERE   1=1
                                AND     V.PLAN_QTY      > 0
                                --AND     V.PLAN_DATE    >= @V_PLAN_START_YYYYMMDD  -- @V_START_YYYYMMDD
                                AND     V.PLAN_DATE    >= FROZEN_START_DATE  -- @V_START_YYYYMMDD
                                AND     V.PLAN_DATE     < FROZEN_END_DATE  -- @V_FROZEN_END_YYYYMMDD
                                AND     CONCAT(V.SCM_SITE_ID, V.ITEM_ID)   IN ( SELECT DISTINCT CONCAT (SCM_SITE_ID, ITEM_ID)
                                                                                FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                                                WHERE  PLAN_ID = @V_PLAN_ID
                                                                                )
                                AND     V.LINE_ID IN (  --SELECT DISTINCT ATTRIBUTE15 AS LINE_ID
														SELECT DISTINCT ATTRIBUTE14 AS LINE_ID
                                                        FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                                        WHERE   PLAN_ID         = @V_PLAN_ID
                                                        AND     RESOURCE_TYPE   = 'LINE'
                                                        )
								AND     V.OPERATION_ID IN ( 'A5000','E2000' )
                                GROUP BY  V.SCM_SITE_ID
                                        , V.ITEM_ID
                                        , V.LINE_ID
                                        , V.PLAN_DATE
										, V.OPERATION_ID
										, V.ELECTRODE_TYPE
                                ------------------------------------------------------------------------------------------------------
                                UNION ALL
                                ------------------------------------------------------------------------------------------------------
                                -- 2025.05.14 Philsu Park: Lookup Fix값 0 보다 큰 값만 들어가게 제약조건 추가.
                                -- 2025.05.20 Philsu Park: GROUP_ID 조건 추가.(두군데)
                                -- 2025.09.12 Philsu Park: Stage 구분 추가(GM 전극 생산 Stage 2군데)
                                ------------------------------------------------------------------------------------------------------
                                SELECT	 LVF.SEGMENT5	AS SCM_SITE_ID
                                        ,LVF.ATTRIBUTE2 AS ITEM_ID
                                        ,CASE WHEN LVF.SEGMENT4 = 'E2000' THEN 'COATING'
                                              WHEN LVF.SEGMENT4 = 'A5000' THEN 'NND'
                                              END AS STAGE
                                        ,LVF.ATTRIBUTE1 AS LINE_ID
                                        ,LVF.ATTRIBUTE3 AS PLAN_DATE
                                        ,LVF.ATTRIBUTE4 AS PLAN_IN_QTY
                                        ,'LOOKUP_PROD_FIX' AS SOURCE_CHK
                                FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL LVF WITH(NOLOCK)
                                        INNER JOIN ( 
                                                    SELECT A.*
                                                    FROM   SCM_MST_SITE A WITH (NOLOCK)

                                                    INNER JOIN #DIVISION D WITH(NOLOCK)
                                                    ON A.DIVISION_ID = D.DIVISION_ID

                                                    WHERE  1=1 -- A.DIVISION_ID = @V_DIVISION_ID 
                                                    AND    A.SITE_TYPE   = 'PLANT'
                                                    AND    A.VALID_YN    = 'Y'	
                                                    AND    A.OPERATION_GROUP IN ('A', 'E')
                                                    ) MSE
                                            ON   LVF.SEGMENT5 = MSE.SCM_SITE_ID
                                        INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                                            ON  FM.FROZEN_TYPE = 'PROD'
                                            AND FM.STAGE = IIF(LVF.SEGMENT4 = 'A5000','NND','COATING')
                                            AND FM.PLAN_ID = @V_PLAN_ID
                                WHERE	LVF.LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
                                AND     LVF.SEGMENT2    = @V_DIVISION_ID
                                AND     LVF.SEGMENT3    = @V_GROUP_ID           -- GROUP_ID 제약조건 추가
                                AND		LVF.ATTRIBUTE3 >= FM.FROZEN_END_DATE -- @V_PROD_FROZEN_END Frozen 구간 이후 FIX 만 적용
                                AND		LVF.ATTRIBUTE3 <  @V_PLAN_END_YYYYMMDD
                                AND     CONVERT(NUMERIC(30, 10), LVF.ATTRIBUTE4) > 0
                                AND     LVF.VALID_YN    = 'Y'
                                AND     LVF.ATTRIBUTE1 IN (SELECT DISTINCT ATTRIBUTE15
                                                            FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                                            WHERE   PLAN_ID = @V_PLAN_ID
                                                            AND     RESOURCE_TYPE = 'LINE'
                                                        )
                                /************************* 
                                대상 프로젝트 ITEM 필터링 
                                *************************/
                                AND CONCAT(LVF.SEGMENT5, LVF.ATTRIBUTE2) 
                                    IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
                                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE  PLAN_ID = @V_PLAN_ID
                                    )
                            ------------------------------------------------------------------------------------------------------
                        ) AA
                        GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, SOURCE_CHK
                    ) A
                    --ROUTING ID가 일 기준으로 변경되면서 ROUTING_RESOURCE로 JOIN 조건 변경/20250702/김태현 선임
                    --LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN B WITH(NOLOCK)
                    --ON  A.SCM_SITE_ID = B.ATTRIBUTE1
                    --AND A.ITEM_ID     = B.ATTRIBUTE2
                    --AND A.STAGE       = B.ATTRIBUTE3
                    --AND A.LINE_ID     = B.ATTRIBUTE14
                    --AND A.PLAN_MONTH  = B.ATTRIBUTE15
                    --AND B.PLAN_ID     = @V_PLAN_ID
                    LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN B WITH(NOLOCK)
                        ON  A.SCM_SITE_ID = B.ATTRIBUTE1
                        AND A.ITEM_ID     = B.ATTRIBUTE2
                        AND A.STAGE       = B.ATTRIBUTE3
                        AND A.LINE_ID     = B.ATTRIBUTE15
                        AND A.PLAN_DATE   >= B.START_DATE
                        AND A.PLAN_DATE   <  B.END_DATE
                        AND B.PLAN_ID     = @V_PLAN_ID
                    GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, B.ROUTING_ID, QTY, PLAN_MONTH, SOURCE_CHK 
            END
        IF @V_SYS_DIVS_CD = 'FP' AND @V_PROD_FP_FRZ_TYPE = 'CUT_OFF'
            BEGIN 
                INSERT INTO SCP_OPT_ENG_FROZEN_PLAN_SN(
                                                     PLAN_ID
                                                    ,FROZEN_ID
                                                    ,ROUTING_BOM_MAPPING_ID
                                                    ,OP_SEQ
                                                    ,RESOURCE_ID
                                                    ,QUANTITY
                                                    ,EFFECTIVE_DATE
                                                    ,ATTRIBUTE1
                                                    ,ATTRIBUTE2
                                                    ,ATTRIBUTE3
                                                    ,ATTRIBUTE13
                                                    ,ATTRIBUTE14
                                                    ,ATTRIBUTE15
                                                    )
                    SELECT  @V_PLAN_ID                                                      AS PLAN_ID
                        ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+LINE_ID+'::'+PLAN_DATE AS FROZEN_ID
                        ,'RB'+B.ROUTING_ID                                               AS ROUTING_BOM_MAPPING_ID
                        ,0                                                               AS OP_SEQ
                        ,SCM_SITE_ID+'::'+LINE_ID                                        AS RESOURCE_ID
                        ,QTY                                                             AS QUANTITY
                        ,PLAN_DATE                                                       AS EFFECTIVE_DATE
                        ,SCM_SITE_ID                                                     AS SITE_ID
                        ,ITEM_ID                                                         AS ITEM_ID    
                        ,STAGE                                                           AS STAGE      
                        ,SOURCE_CHK                                                      AS SOURCE_CHK
                        ,LINE_ID                                                         AS LINE_ID    
                        ,PLAN_MONTH                                                      AS PLAN_MONTH 
                    FROM(
                        SELECT  SCM_SITE_ID       AS SCM_SITE_ID
                            ,ITEM_ID           AS ITEM_ID
                            ,STAGE             AS STAGE
                            ,LINE_ID           AS LINE_ID
                            ,PLAN_DATE         AS PLAN_DATE
                            ,LEFT(PLAN_DATE,6) AS PLAN_MONTH
                            ,SUM(PLAN_IN_QTY)  AS QTY
                            ,SOURCE_CHK            AS SOURCE_CHK
                        FROM(
                                SELECT    V.SCM_SITE_ID AS SCM_SITE_ID
                                        , V.ITEM_ID     AS ITEM_ID
                                        --, 'COATING'     AS STAGE
										, CASE WHEN V.OPERATION_ID = 'A5000' THEN 'NND' ELSE 'COATING' END  AS STAGE
                                        --, V.LINE_ID     AS LINE_ID
										, V.LINE_ID + CASE WHEN V.OPERATION_ID = 'A5000' AND V.ELECTRODE_TYPE = 'Anode' THEN '@A' 
														   WHEN V.OPERATION_ID = 'A5000' AND V.ELECTRODE_TYPE = 'Cathode' THEN '@C'
														   ELSE '' END  AS LINE_ID
                                        , V.PLAN_DATE   AS PLAN_DATE
                                        , SUM(V.PLAN_QTY)    AS PLAN_IN_QTY  -- AFTER_CORRECT에서  수율 먹여서 투입수량으로 변경.
                                        , 'FP_RELEASE_PLAN' AS SOURCE_CHK
                                FROM    (SELECT 
                                                M.SCM_SITE_ID
                                                , ISNULL(FI.PACKER_PLAN_ITEM_ID, R.ITEM_ID) AS ITEM_ID --2018.06.29
                                                , R.LINE_ID
                                                , CONVERT(NVARCHAR, R.PLAN_DATE, 112)       AS PLAN_DATE
                                                , R.PLAN_QTY          -- OUT 수량
                                                /* Input 생성 시 미사용 컬럼 주석처리.
                                                , r.top_item_id 
                                                , r.item_id origin_item_id --2018.06.29
                                                , r.company_id
                                                , r.division_id
                                                , r.site_id
                                                , r.fp_production_type  -- 2025.05.13 양산 및 샘플, 테스트 등등.. 나중에 조건 걸어야 될 수도 있음.
                                                , r.plant_id
                                                , r.factory_id  
                                                , r.operation_id
                                                , r.location    
                                                , r.market
                                                , r.electrode_type
                                                -- IN 수량
                                                , CASE WHEN r.plan_in_qty <= 0 THEN r.plan_qty
                                                    ELSE r.plan_in_qty
                                                END plan_in_qty
                                                , r.equipment_id */
												, R.OPERATION_ID
												, R.ELECTRODE_TYPE
                                        FROM DBO.SCM_DNM_FP_RELEASE_PROD_PLAN_C R WITH(NOLOCK)
                                        LEFT JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)--2018.06.29
                                            ON  R.DIVISION_ID   = FI.DIVISION_ID
                                            AND R.ITEM_ID       = FI.ITEM_ID
                                        OUTER APPLY (
                                                    SELECT TOP 1 ISNULL(I.SCP_OPERATION_GROUP,'') AS SCP_OPERATION_GROUP
                                                        FROM DBO.SCM_MST_ITEM_SN              I WITH(NOLOCK)
                                                    WHERE 1=1
                                                        AND I.DIVISION_ID          = R.DIVISION_ID
                                                        AND I.ITEM_ID              = R.ITEM_ID
                                                    ) AS OG
                                        OUTER APPLY (
                                                    SELECT TOP 1 ISNULL(I.SCM_SITE_ID,'') AS SCM_SITE_ID
                                                        FROM DBO.SCM_MST_SITE             I WITH(NOLOCK)
                                                    WHERE 1 = 1
                                                        AND I.PLANT_ID             = R.PLANT_ID
                                                        AND I.OPERATION_GROUP      = OG.SCP_OPERATION_GROUP
                                                        AND I.SITE_TYPE            = 'PLANT'
                                                        AND I.VALID_YN             = 'Y'
                                                    ) AS M
                                            WHERE   R.YYYYMMDD = @V_SCP_PLAN_DATE
                                        ) V
                                    INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                                        ON  FM.FROZEN_TYPE = 'PROD'
                                        AND FM.STAGE = IIF(V.OPERATION_ID = 'A5000','NND','COATING')
                                        AND FM.PLAN_ID = @V_PLAN_ID
                                WHERE   1=1
                                AND     V.PLAN_QTY      > 0
                                --AND     V.PLAN_DATE    >= @V_PLAN_START_YYYYMMDD  -- @V_START_YYYYMMDD
                                AND     V.PLAN_DATE    >= FROZEN_START_DATE  -- @V_START_YYYYMMDD
                                AND     V.PLAN_DATE     < FROZEN_END_DATE  -- @V_FROZEN_END_YYYYMMDD
                                AND     CONCAT(V.SCM_SITE_ID, V.ITEM_ID)   IN ( SELECT DISTINCT CONCAT (SCM_SITE_ID, ITEM_ID)
                                                                                FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                                                WHERE  PLAN_ID = @V_PLAN_ID
                                                                                )
                                AND     V.LINE_ID IN (  --SELECT DISTINCT ATTRIBUTE15 AS LINE_ID
														SELECT DISTINCT ATTRIBUTE14 AS LINE_ID
                                                        FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                                        WHERE   PLAN_ID         = @V_PLAN_ID
                                                        AND     RESOURCE_TYPE   = 'LINE'
                                                        )
								AND     V.OPERATION_ID IN ( 'A5000','E2000' )
                                GROUP BY  V.SCM_SITE_ID
                                        , V.ITEM_ID
                                        , V.LINE_ID
                                        , V.PLAN_DATE
										, V.OPERATION_ID
										, V.ELECTRODE_TYPE
                                ------------------------------------------------------------------------------------------------------
                                UNION ALL
                                ------------------------------------------------------------------------------------------------------
                                -- 2025.05.14 Philsu Park: Lookup Fix값 0 보다 큰 값만 들어가게 제약조건 추가.
                                -- 2025.05.20 Philsu Park: GROUP_ID 조건 추가.(두군데)
                                -- 2025.09.12 Philsu Park: Stage 구분 추가(GM 전극 생산 Stage 2군데)
                                ------------------------------------------------------------------------------------------------------
                                SELECT	 LVF.SEGMENT5	AS SCM_SITE_ID
                                        ,LVF.ATTRIBUTE2 AS ITEM_ID
                                        ,CASE WHEN LVF.SEGMENT4 = 'E2000' THEN 'COATING'
                                              WHEN LVF.SEGMENT4 = 'A5000' THEN 'NND'
                                              END AS STAGE
                                        ,LVF.ATTRIBUTE1 AS LINE_ID
                                        ,LVF.ATTRIBUTE3 AS PLAN_DATE
                                        ,LVF.ATTRIBUTE4 AS PLAN_IN_QTY
                                        ,'LOOKUP_PROD_FIX' AS SOURCE_CHK
                                FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL LVF WITH(NOLOCK)
                                        INNER JOIN ( 
                                                    SELECT A.*
                                                    FROM   SCM_MST_SITE A WITH (NOLOCK)

                                                    INNER JOIN #DIVISION D WITH(NOLOCK)
                                                    ON A.DIVISION_ID = D.DIVISION_ID

                                                    WHERE  1=1 -- A.DIVISION_ID = @V_DIVISION_ID 
                                                    AND    A.SITE_TYPE   = 'PLANT'
                                                    AND    A.VALID_YN    = 'Y'	
                                                    AND    A.OPERATION_GROUP IN ('A', 'E')
                                                    ) MSE
                                            ON   LVF.SEGMENT5 = MSE.SCM_SITE_ID
                                        INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                                            ON  FM.FROZEN_TYPE = 'PROD'
                                            AND FM.STAGE = IIF(LVF.SEGMENT4 = 'A5000','NND','COATING')
                                            AND FM.PLAN_ID = @V_PLAN_ID
                                WHERE	LVF.LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
                                AND     LVF.SEGMENT2    = @V_DIVISION_ID
                                AND     LVF.SEGMENT3    = @V_GROUP_ID           -- GROUP_ID 제약조건 추가
                                AND		LVF.ATTRIBUTE3 >= FM.FROZEN_END_DATE -- @V_PROD_FROZEN_END Frozen 구간 이후 FIX 만 적용
                                AND		LVF.ATTRIBUTE3 <  @V_PLAN_END_YYYYMMDD
                                AND     CONVERT(NUMERIC(30, 10), LVF.ATTRIBUTE4) > 0
                                AND     LVF.VALID_YN    = 'Y'
                                AND     LVF.ATTRIBUTE1 IN (SELECT DISTINCT ATTRIBUTE15
                                                            FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                                            WHERE   PLAN_ID = @V_PLAN_ID
                                                            AND     RESOURCE_TYPE = 'LINE'
                                                        )
                                /************************* 
                                대상 프로젝트 ITEM 필터링 
                                *************************/
                                AND CONCAT(LVF.SEGMENT5, LVF.ATTRIBUTE2) 
                                    IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
                                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE  PLAN_ID = @V_PLAN_ID
                                    )
                            ------------------------------------------------------------------------------------------------------
                        ) AA
                        GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, SOURCE_CHK
                    ) A
                    --ROUTING ID가 일 기준으로 변경되면서 ROUTING_RESOURCE로 JOIN 조건 변경/20250702/김태현 선임
                    --LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN B WITH(NOLOCK)
                    --ON  A.SCM_SITE_ID = B.ATTRIBUTE1
                    --AND A.ITEM_ID     = B.ATTRIBUTE2
                    --AND A.STAGE       = B.ATTRIBUTE3
                    --AND A.LINE_ID     = B.ATTRIBUTE14
                    --AND A.PLAN_MONTH  = B.ATTRIBUTE15
                    --AND B.PLAN_ID     = @V_PLAN_ID
                    LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN B WITH(NOLOCK)
                        ON  A.SCM_SITE_ID = B.ATTRIBUTE1
                        AND A.ITEM_ID     = B.ATTRIBUTE2
                        AND A.STAGE       = B.ATTRIBUTE3
                        AND A.LINE_ID     = B.ATTRIBUTE15
                        AND A.PLAN_DATE   >= B.START_DATE
                        AND A.PLAN_DATE   <  B.END_DATE
                        AND B.PLAN_ID     = @V_PLAN_ID
                    GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, B.ROUTING_ID, QTY, PLAN_MONTH, SOURCE_CHK 
            END
        ELSE IF @V_SYS_DIVS_CD = 'SCP'
            BEGIN 
                INSERT INTO SCP_OPT_ENG_FROZEN_PLAN_SN(
                                                        PLAN_ID
                                                    ,FROZEN_ID
                                                    ,ROUTING_BOM_MAPPING_ID
                                                    ,OP_SEQ
                                                    ,RESOURCE_ID
                                                    ,QUANTITY
                                                    ,EFFECTIVE_DATE
                                                    ,ATTRIBUTE1
                                                    ,ATTRIBUTE2
                                                    ,ATTRIBUTE3
                                                    ,ATTRIBUTE13
                                                    ,ATTRIBUTE14
                                                    ,ATTRIBUTE15
                                                    )
                    SELECT  @V_PLAN_ID                                                      AS PLAN_ID
                        ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+LINE_ID+'::'+PLAN_DATE AS FROZEN_ID
                        ,'RB'+B.ROUTING_ID                                               AS ROUTING_BOM_MAPPING_ID
                        ,0                                                               AS OP_SEQ
                        ,SCM_SITE_ID+'::'+LINE_ID                                        AS RESOURCE_ID
                        ,QTY                                                             AS QUANTITY
                        ,PLAN_DATE                                                       AS EFFECTIVE_DATE
                        ,SCM_SITE_ID                                                     AS SITE_ID
                        ,ITEM_ID                                                         AS ITEM_ID    
                        ,STAGE                                                           AS STAGE      
                        ,SOURCE_CHK                                                      AS SOURCE_CHK
                        ,LINE_ID                                                         AS LINE_ID    
                        ,PLAN_MONTH                                                      AS PLAN_MONTH 
                    FROM(
                        SELECT  SCM_SITE_ID       AS SCM_SITE_ID
                            ,ITEM_ID           AS ITEM_ID
                            ,STAGE             AS STAGE
                            ,LINE_ID           AS LINE_ID
                            ,PLAN_DATE         AS PLAN_DATE
                            ,LEFT(PLAN_DATE,6) AS PLAN_MONTH
                            ,SUM(PLAN_IN_QTY)  AS QTY
                            ,SOURCE_CHK            AS SOURCE_CHK
                        FROM(
                                SELECT    A.SCM_SITE_ID
                                        , A.ITEM_ID
                                        , 'COATING' AS STAGE
                                        /* PLAN_DATE 투입계획으로 변환 필요 / FP내에공정별LT관리되나 데이터 전체 0으로 따로 로직 반영 안함 : AFTER 작업에서 수율 적용하여 IN Qty 로 Update함 */ 
                                        , A.LINE_ID
                                        , A.YYYYMMDD AS PLAN_DATE
                                        , A.QTY AS PLAN_IN_QTY
                                        , 'ANL_PRODUCTION_PLAN' AS SOURCE_CHK
                                FROM    SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)    

                                INNER JOIN ( 
                                            SELECT A.*
                                            FROM   SCM_MST_SITE A WITH (NOLOCK)

                                            INNER JOIN #DIVISION D WITH(NOLOCK)
                                            ON A.DIVISION_ID = D.DIVISION_ID

                                            WHERE  1=1 -- A.DIVISION_ID = @V_DIVISION_ID 
                                            AND    A.SITE_TYPE   = 'PLANT'
                                            AND    A.VALID_YN    = 'Y'	
                                            AND    A.OPERATION_GROUP = 'E'	
                                            ) MSE
                                ON   A.SCM_SITE_ID = MSE.SCM_SITE_ID 
                                    INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                                        ON  FM.FROZEN_TYPE = 'PROD'
                                        AND FM.STAGE = IIF(A.OPERATION_ID = 'A5000','NND','COATING')
                                        AND FM.PLAN_ID = @V_PLAN_ID
                                WHERE A.DIVISION_ID         = @V_DIVISION_ID
                                AND   A.PLAN_START_YYYYMMDD = @V_SCP_PLAN_DATE
                                AND   A.PLAN_TYPE           = @V_SCP_PLAN_TYPE 
                                AND   A.SEQ                 = @V_SCP_PLAN_SEQ  
                                AND   A.MEASURE             = 'PROD_PLAN_AMEND'
                                AND   A.OPERATION_ID        = 'E2000'
                                AND   A.QTY                >  0   
                                --AND   A.YYYYMMDD           >= @V_SCP_PLAN_DATE  
                                AND   A.YYYYMMDD           >= FM.FROZEN_START_DATE  
                                AND   A.YYYYMMDD           <  FM.FROZEN_END_DATE -- DATEADD(DD, ISNULL(@V_PROD_FROZEN, 0), @V_SCP_PLAN_DATE )
                                AND   A.LINE_ID IN (SELECT DISTINCT ATTRIBUTE15
                                                    FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                                    WHERE   PLAN_ID =@V_PLAN_ID
                                                    AND     RESOURCE_TYPE = 'LINE'
                                                    )
                                /************************* 
                                대상 프로젝트 ITEM 필터링 
                                *************************/
                                AND CONCAT(A.SCM_SITE_ID, A.ITEM_ID) 
                                    IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
                                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE  PLAN_ID = @V_PLAN_ID
                                    ) 
                                ------------------------------------------------------------------------------------------------------
                                UNION ALL
                                ------------------------------------------------------------------------------------------------------
                                -- 2025.05.14 Philsu Park: Lookup Fix값 0 보다 큰 값만 들어가게 제약조건 추가.
                                -- 2025.05.20 Philsu Park: Group_Id 조건 추가.(두군데)
                                ------------------------------------------------------------------------------------------------------
                                SELECT	 LVF.SEGMENT5	AS SCM_SITE_ID
                                        ,LVF.ATTRIBUTE2 AS ITEM_ID
                                        ,CASE WHEN LVF.SEGMENT4 = 'E2000' THEN 'COATING'
                                              WHEN LVF.SEGMENT4 = 'A5000' THEN 'NND'
                                              END AS STAGE
                                        ,LVF.ATTRIBUTE1 AS LINE_ID
                                        ,LVF.ATTRIBUTE3 AS PLAN_DATE
                                        ,LVF.ATTRIBUTE4 AS PLAN_IN_QTY
                                        ,'LOOKUP_PROD_FIX' AS SOURCE_CHK
                                FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL LVF WITH(NOLOCK)
                                        INNER JOIN ( 
                                                    SELECT A.*
                                                    FROM   SCM_MST_SITE A WITH (NOLOCK)

                                                    INNER JOIN #DIVISION D WITH(NOLOCK)
                                                    ON A.DIVISION_ID = D.DIVISION_ID

                                                    WHERE  1=1 -- A.DIVISION_ID = @V_DIVISION_ID 
                                                    AND    A.SITE_TYPE   = 'PLANT'
                                                    AND    A.VALID_YN    = 'Y'	
                                                    AND    A.OPERATION_GROUP IN ('A', 'E')
                                                    ) MSE
                                            ON   LVF.SEGMENT5 = MSE.SCM_SITE_ID 
                                    INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                                        ON  FM.FROZEN_TYPE = 'PROD'
                                        AND FM.STAGE = IIF(LVF.SEGMENT4 = 'A5000','NND','COATING')
                                        AND FM.PLAN_ID = @V_PLAN_ID
                                WHERE	LVF.LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
                                AND     LVF.SEGMENT3    = @V_GROUP_ID           -- GROUP_ID 제약조건 추가
                                AND		LVF.ATTRIBUTE3 >= FM.FROZEN_END_DATE -- @V_PROD_FROZEN_END Frozen 구간 이후 FIX 만 적용
                                AND		LVF.ATTRIBUTE3 <  @V_PLAN_END_YYYYMMDD
                                AND     CONVERT(NUMERIC(30, 10), LVF.ATTRIBUTE4) > 0
                                AND     LVF.VALID_YN    = 'Y'
                                AND     LVF.ATTRIBUTE1 IN (SELECT DISTINCT ATTRIBUTE15
                                                            FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                                            WHERE   PLAN_ID = @V_PLAN_ID
                                                            AND     RESOURCE_TYPE = 'LINE'
                                                        )
                                /************************* 
                                대상 프로젝트 ITEM 필터링 
                                *************************/
                                AND CONCAT(LVF.SEGMENT5, LVF.ATTRIBUTE2) 
                                    IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
                                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE  PLAN_ID = @V_PLAN_ID
                                    )
                            ------------------------------------------------------------------------------------------------------
                        ) AA
                        GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, SOURCE_CHK
                    ) A
                    --ROUTING ID가 일 기준으로 변경되면서 ROUTING_RESOURCE로 JOIN 조건 변경/20250702/김태현 선임
                    --LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN B WITH(NOLOCK)
                    --ON  A.SCM_SITE_ID = B.ATTRIBUTE1
                    --AND A.ITEM_ID     = B.ATTRIBUTE2
                    --AND A.STAGE       = B.ATTRIBUTE3
                    --AND A.LINE_ID     = B.ATTRIBUTE14
                    --AND A.PLAN_MONTH  = B.ATTRIBUTE15
                    --AND B.PLAN_ID     = @V_PLAN_ID
                    LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN B WITH(NOLOCK)
                        ON  A.SCM_SITE_ID = B.ATTRIBUTE1
                        AND A.ITEM_ID     = B.ATTRIBUTE2
                        AND A.STAGE       = B.ATTRIBUTE3
                        AND A.LINE_ID     = B.ATTRIBUTE15
                        AND A.PLAN_DATE   >= B.START_DATE
                        AND A.PLAN_DATE   <  B.END_DATE
                        AND B.PLAN_ID     = @V_PLAN_ID
                    GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, B.ROUTING_ID, QTY, PLAN_MONTH, SOURCE_CHK 
                    ;
            END

		------------------------------------------------------------------------
        -- 2025.10.16 Philsu Park: PROD FIX에 IDLE 등록된 대상을 Frozen Plan 에 추가
        ------------------------------------------------------------------------
		INSERT INTO SCP_OPT_ENG_FROZEN_PLAN_SN
			(
			 PLAN_ID
			,FROZEN_ID
			,ROUTING_BOM_MAPPING_ID
			,OP_SEQ
			,RESOURCE_ID
			,QUANTITY
			,EFFECTIVE_DATE
			,ATTRIBUTE1
			,ATTRIBUTE2
			,ATTRIBUTE3
			,ATTRIBUTE13
			,ATTRIBUTE14
			,ATTRIBUTE15
			)
			-- G671-A::ABA01@A::20260101	RBG671-A::IDLE::IDLE	0	G671-A::ABA01@A
			SELECT	  @V_PLAN_ID AS PLAN_ID
					, CONCAT(SCM_SITE_ID, '::', LINE_ID, '::', PLAN_DATE) AS FROZEN_ID
					, CONCAT('RB', SCM_SITE_ID, '::', ITEM_ID, '::', ITEM_ID) AS ROUTING_BOM_MAPPING_ID
					, 0 AS OP_SEQ
					, CONCAT(SCM_SITE_ID, '::', LINE_ID) AS RESOURCE_ID
					, PLAN_IN_QTY						AS QUANTITY
					, PLAN_DATE							AS EFFECTIVE_DATE
					, SCM_SITE_ID						AS ATTRIBUTE1
					, 'IDLE'							AS ATTRIBUTE2
					, 'IDLE'							AS ATTRIBUTE3
					, SOURCE_CHK						AS ATTRIBUTE13
					, LINE_ID							AS ATTRIBUTE14
					, LEFT(PLAN_DATE, 6)				AS ATTRIBUTE15
			FROM	( 
					SELECT	 LVF.SEGMENT5	AS SCM_SITE_ID
							,LVF.ATTRIBUTE2 AS ITEM_ID
							,CASE WHEN LVF.SEGMENT4 = 'E2000' THEN 'COATING'
									WHEN LVF.SEGMENT4 = 'A5000' THEN 'NND'
									END AS STAGE
							,LVF.ATTRIBUTE1 AS LINE_ID
							,LVF.ATTRIBUTE3 AS PLAN_DATE
							,LVF.ATTRIBUTE4 AS PLAN_IN_QTY
							,'LOOKUP_PROD_FIX' AS SOURCE_CHK
					FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL LVF WITH(NOLOCK)
					INNER JOIN ( 
								SELECT A.*
								FROM   SCM_MST_SITE A WITH (NOLOCK)
								INNER JOIN #DIVISION D WITH(NOLOCK)
									ON A.DIVISION_ID = D.DIVISION_ID
								WHERE  1=1 -- A.DIVISION_ID = @V_DIVISION_ID 
								AND    A.SITE_TYPE   = 'PLANT'
								AND    A.VALID_YN    = 'Y'	
								AND    A.OPERATION_GROUP IN ('A', 'E')
								) MSE
						ON   LVF.SEGMENT5 = MSE.SCM_SITE_ID
					INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
						ON  FM.FROZEN_TYPE = 'PROD'
						AND FM.STAGE = IIF(LVF.SEGMENT4 = 'A5000','NND','COATING')
						AND FM.PLAN_ID = @V_PLAN_ID
					WHERE	LVF.LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
					AND     LVF.SEGMENT2    = @V_DIVISION_ID
					AND     LVF.SEGMENT3    = @V_GROUP_ID           -- GROUP_ID 제약조건 추가
					AND		LVF.ATTRIBUTE3 >= FM.FROZEN_END_DATE -- @V_PROD_FROZEN_END Frozen 구간 이후 FIX 만 적용
					AND		LVF.ATTRIBUTE3 <  @V_PLAN_END_YYYYMMDD
					AND     CONVERT(NUMERIC(30, 10), LVF.ATTRIBUTE4) > 0
					AND     LVF.VALID_YN    = 'Y'
					AND 	LVF.ATTRIBUTE2 = 'IDLE'
					AND     LVF.ATTRIBUTE1 IN (SELECT DISTINCT ATTRIBUTE15
												FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
												WHERE   PLAN_ID = @V_PLAN_ID
												AND     RESOURCE_TYPE = 'LINE'
											)
					) LK
        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------

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
