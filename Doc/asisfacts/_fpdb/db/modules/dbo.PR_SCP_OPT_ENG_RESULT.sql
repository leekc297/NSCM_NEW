
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_RESULT]
     @P_FP_PLAN_ID      NVARCHAR(50)
    ,@P_PLAN_ID         NVARCHAR(50)
    ,@P_RESULT_TYPE     NVARCHAR(50)
AS 
BEGIN

    SET ARITHABORT ON;
    SET ANSI_NULLS ON;
    SET QUOTED_IDENTIFIER ON;
	SET NOCOUNT ON;

	-------------------------------------------------------------------------------------
	-- SET Parameter
	-------------------------------------------------------------------------------------
    DECLARE @V_PLAN_ID          NVARCHAR(50) = @P_PLAN_ID;
    DECLARE @V_FP_PLAN_ID       NVARCHAR(50) = @P_FP_PLAN_ID;
    DECLARE @V_RESULT_TYPE      NVARCHAR(50) = @P_RESULT_TYPE;

    DECLARE @V_PLAN_START_YYYYMMDD NVARCHAR(8)
    DECLARE @V_PLAN_END_YYYYMMDD   NVARCHAR(8)
    DECLARE @V_DIVISION_ID         NVARCHAR(50)
    DECLARE @V_PLAN_GROUP_ID       NVARCHAR(8)

	DECLARE @V_PLAN_START_MONTH_DAY NVARCHAR(8)

	DECLARE @MAX_TUESDAY NVARCHAR(8)
	DECLARE @V_DM_MAX_VERSION NVARCHAR(50)
    DECLARE @P_PLAN_NAME         NVARCHAR(8) 
    DECLARE @D_PLAN_NAME         DATETIME 
	DECLARE @V_DEMAND_CUTOFF_DAY NVARCHAR(8)
    DECLARE @V_TODAY  NVARCHAR(8) = CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 112);
    -------------------------------------------------------------------------------------
    -- 쿼리 속도 개선을 위한 임시테이블 생성 
    DECLARE @OPERATION_TEMP TABLE(
     DIVISION_ID  NVARCHAR(100)
    ,PLAN_GROUP   NVARCHAR(100)
    ,STAGE        NVARCHAR(100)
    ,OPERATION_ID NVARCHAR(100)
    )
    -- 쿼리 속도 개선을 위한 임시테이블 생성 
    DECLARE @OPERATION_TEMP_RESULT TABLE(
     DIVISION_ID  NVARCHAR(100)
    ,PLAN_GROUP   NVARCHAR(100)
    ,STAGE        NVARCHAR(100)
    ,OPERATION_ID NVARCHAR(100)
    )
	-------------------------------------------------------------------------------------
	DECLARE @DIVISION TABLE(
     DIVISION_ID  NVARCHAR(100)
    )
	-------------------------------------------------------------------------------------
	DECLARE @RESULT_TEMP TABLE(
     TYPE				NVARCHAR(100)
    ,SCM_SITE_ID		NVARCHAR(100)
    ,ITEM_ID			NVARCHAR(100)
    ,STAGE				NVARCHAR(100)
    ,PRODUCTION_DATE	NVARCHAR(100)
    ,LINE_ID			NVARCHAR(100)
    ,QTY				NUMERIC(20,10)
    ,OPERATION_ID		NVARCHAR(100)
    ,FROM_SITE			NVARCHAR(100)
    ,TO_SITE			NVARCHAR(100)
    ,BOD_ID				NVARCHAR(100)
    ,TRANSPORT_MODE		NVARCHAR(100)
    ,INCOTERMS			NVARCHAR(100)
    ,DEPARTURE_DATE		NVARCHAR(100)
    ,ARRIVAL_DATE		NVARCHAR(100)
    ,ELECTRODE_TYPE     NVARCHAR(100)
    ,LINE_SIDE          NVARCHAR(100) -- ADDED 2025.10.29 jongykim2: LINE_SITE
	,WORKING_DAY		NUMERIC(20,10)
    )
	-------------------------------------------------------------------------------------
	DECLARE @RESULT_HEADER TABLE(
		 HEADER_KEY			NVARCHAR(200)
		,OPERATION			NVARCHAR(200)
		,MODEL				NVARCHAR(200)			
		,ITEM_ID			NVARCHAR(200)
		,NICK_NAME			NVARCHAR(200)
		,PLANT_SITE			NVARCHAR(200)
		,SALES_SITE			NVARCHAR(200)
		,FCST_Type			NVARCHAR(200)
		,Attr1				NVARCHAR(200)
		,Attr2				NVARCHAR(200)
		,LINE_GROUP			NVARCHAR(200)
		,LINE				NVARCHAR(200)
		,ELECTRODE_TYPE		NVARCHAR(200)
		)
	-------------------------------------------------------------------------------------
	DECLARE @NUM TABLE(
		 NUM			NUMERIC(20,10)
		)
	-------------------------------------------------------------------------------------
	DECLARE @DAILY_CAPA TABLE(
		 OPERATION_ID		NVARCHAR(200)
		,LINE_ID			NVARCHAR(200)
		,ITEM_ID			NVARCHAR(200)			
		,PLAN_YYYYMM		NVARCHAR(200)
		,DAILY_QTY			NVARCHAR(200)
		)
	-------------------------------------------------------------------------------------
	DECLARE @OUT_ITEM TABLE(
		 TYPE				NVARCHAR(200)
		,ITEM_ID			NVARCHAR(200)	
		)
    -------------------------------------------------------------------------------------
	-- Set Planning Info
	-------------------------------------------------------------------------------------
	SELECT  @V_PLAN_START_YYYYMMDD  = PLAN_START_DATE
           ,@V_PLAN_END_YYYYMMDD    = PLAN_END_DATE
           ,@V_DIVISION_ID          = ATTRIBUTE1
           ,@V_PLAN_GROUP_ID        = ATTRIBUTE2
		--    ,@V_PLAN_START_MONTH_DAY = CONVERT(NVARCHAR, DATEADD(DAY, 1- DAY(CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),112)
           ,@V_PLAN_START_MONTH_DAY =  CONVERT(NVARCHAR, DATEADD(MONTH, -1, DATEADD(DAY, 1- DAY(CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD))),112)
    FROM    SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
    WHERE   PLAN_ID = @V_PLAN_ID

	-------------------------------------------------------------------------------------
	-- Set Operation Map
	-------------------------------------------------------------------------------------
    INSERT INTO @OPERATION_TEMP
    SELECT	 SEGMENT1 AS DIVISION_ID
    		,SEGMENT2 AS PLAN_GROUP
    		,SEGMENT3 AS STAGE
    		,SEGMENT5 AS OPERATION_ID
    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LV WITH(NOLOCK)
    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_STAGE_OPERATION_MAP' 
    AND     SEGMENT1    = @V_DIVISION_ID
    AND     SEGMENT2    = @V_PLAN_GROUP_ID
    AND     VALID_YN    = 'Y'

    -------------------------------------------------------------------------------------
	-- Set Operation Map RESULT
	-------------------------------------------------------------------------------------
    INSERT INTO @OPERATION_TEMP_RESULT
    SELECT	 SEGMENT1 AS DIVISION_ID
    		,SEGMENT2 AS PLAN_GROUP
    		,SEGMENT3 AS STAGE
    		,SEGMENT5 AS OPERATION_ID
    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LV WITH(NOLOCK)
    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_STAGE_OPERATION_MAP' 
    AND     SEGMENT1    = @V_DIVISION_ID
    AND     SEGMENT2    = @V_PLAN_GROUP_ID
    AND     VALID_YN    = 'Y'
    -- UNION ALL
    -- SELECT  '81_UC'
    --         , 'GM1_A'
    --         , 'DEGAS'
    --         , 'F4000'


	-------------------------------------------------------------------------------------
	-- Set Division for Elec Plan
	-------------------------------------------------------------------------------------
	INSERT INTO  @DIVISION
	SELECT DIVISION_ID 
	FROM   SCM_MST_DIVISION_SN WITH(NOLOCK)
	WHERE  VALID_YN = 'Y'
	AND    ATTRIBUTE3 <> 'EE'
	AND    ATTRIBUTE4 = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION_SN WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID )
	;
	
	-------------------------------------------------------------------------------------
	-- Set Version info fo FCST
	-------------------------------------------------------------------------------------
	SELECT  @MAX_TUESDAY = MAX(BASIS_YYYYMMDD)
    FROM    SCM_SYS_CALENDAR_M_SN WITH(NOLOCK) 
    WHERE   BASIS_YYYYMMDD <= CONVERT(NVARCHAR(8),GETDATE(),112)
    AND     DAYOFWEEK = 'TUE'

    SELECT @P_PLAN_NAME          = @V_PLAN_START_YYYYMMDD;
    SELECT @D_PLAN_NAME          = CONVERT(DATETIME, @P_PLAN_NAME);
    SELECT @V_DEMAND_CUTOFF_DAY  = ISNULL(MAX(P.CUTOFF_YYYYMMDD),@MAX_TUESDAY)
                                    FROM   DM_PLN_NET_DEMAND_SN P WITH(NOLOCK)
                                    WHERE  P.DIVISION_ID      = @V_DIVISION_ID 
                                    AND    P.CUTOFF_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -3, @D_PLAN_NAME), 112)
                                    AND    P.CUTOFF_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, +6, @D_PLAN_NAME), 112)
    
    SELECT  @V_DM_MAX_VERSION = MAX(P.VERSION_NO)
    FROM    DM_PLN_NET_DEMAND_SN P WITH(NOLOCK)
    WHERE   P.DIVISION_ID      = @V_DIVISION_ID 
    AND     P.CUTOFF_YYYYMMDD  = @V_DEMAND_CUTOFF_DAY

	
	-------------------------------------------------------------------------------------
	-- Set Division for Elec Plan
	-------------------------------------------------------------------------------------
	INSERT INTO  @NUM
	SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5  UNION ALL
	SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
	;
	
	-------------------------------------------------------------------------------------
	-- Set Daily CAPA
    -- 2025.09.10 Philsu Park: 룩업의 Tact Time 값 Numeric으로 Type Casting.
    -- 2025.09.12 Philsu Park: Engine Input 기반으로 출처 변경
    -- 2025.09.15 Philsu Park: 수율 역산 처리(Load_Per 값 자체가 수율 먹은채로 엔진 수행되고 있어서)
	-------------------------------------------------------------------------------------
	INSERT INTO @DAILY_CAPA
    SELECT    LK.SEGMENT5       AS OPERATION_ID
            , IIF(@V_DIVISION_ID LIKE 'EE%', R.ATTRIBUTE13, R.ATTRIBUTE15)     AS LINE_ID
            , R.ATTRIBUTE2      AS ITEM_ID
            , R.ATTRIBUTE14     AS PLAN_YYYYMM
            --, 86400/R.LOAD_PER  AS DAILY_QTY
            --, 86400/(MAX(R.LOAD_PER)/MAX(RT.YIELD))  AS DAILY_QTY
            , IIF(MAX(RT.YIELD)=0,0, 86400/(MAX(R.LOAD_PER)/MAX(RT.YIELD))) AS DAILY_QTY
    FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN R WITH(NOLOCK)
    INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LK WITH(NOLOCK)
        ON  LK.LOOKUP_TYPE  = 'SCP_OPT_ENG_STAGE_OPERATION_MAP' 
        AND LK.SEGMENT1     = @V_DIVISION_ID
        AND LK.SEGMENT2     = @V_PLAN_GROUP_ID
        AND LK.VALID_YN     = 'Y'
        AND LK.SEGMENT3     = R.ATTRIBUTE3
    LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN RT
        ON  R.PLAN_ID    = RT.PLAN_ID
        AND R.ROUTING_ID = RT.ROUTING_ID
        AND R.OP_SEQ	 = RT.OP_SEQ
    LEFT OUTER JOIN (
                    SELECT  ATTRIBUTE3 AS STAGE
                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LU WITH(NOLOCK)
                    WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                    AND     LU.SEGMENT2    = @V_DIVISION_ID
                    AND     LU.SEGMENT3    = @V_PLAN_GROUP_ID
                    AND     LU.VALID_YN    = 'Y'
                    GROUP BY ATTRIBUTE3
                   ) OCV
        ON  LK.SEGMENT3 = OCV.STAGE
    WHERE   R.PLAN_ID           = @V_PLAN_ID
    AND     R.RESOURCE_CLASS_ID = 'LINE'
    AND     OCV.STAGE IS NULL -- 2nd OCV STAGE는 대상이 아님
    GROUP BY LK.SEGMENT5, IIF(@V_DIVISION_ID LIKE 'EE%', R.ATTRIBUTE13, R.ATTRIBUTE15), R.ATTRIBUTE2, R.ATTRIBUTE14
    ;
    -- GROUP BY  LK.SEGMENT5 
    --         , R.ATTRIBUTE15
    --         , R.ATTRIBUTE2
    --         , R.ATTRIBUTE14
	/* SELECT    LK.SEGMENT5   AS OPERATION_ID
			, LK.ATTRIBUTE1 AS LINE_ID
			--, CASE WHEN LK.SEGMENT5 = 'A5000' THEN LEFT(LK.ATTRIBUTE1, CHARINDEX('@',LK.ATTRIBUTE1)-1)
			--       ELSE LK.ATTRIBUTE1 END AS LINE_ID
			, LK.ATTRIBUTE2 AS ITEM_ID
			, LK.ATTRIBUTE3 AS PLAN_YYYYMM
			, MAX(86400.0/CONVERT(NUMERIC(20,10), LK.ATTRIBUTE4))   AS DAILY_QTY
	FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LK WITH(NOLOCK)
	WHERE   LK.LOOKUP_TYPE  = 'SCP_OPT_MASTER_CAPA_TEMP'
	AND     LK.VALID_YN     = 'Y'
	AND     LK.SEGMENT2     = @V_DIVISION_ID
	GROUP BY LK.SEGMENT5, LK.ATTRIBUTE1, LK.ATTRIBUTE2, LK.ATTRIBUTE3  */

    -------------------------------------------------------------------------------------
    IF OBJECT_ID('TEMPDB..#CONVERT_USAGE') IS NOT NULL
    -------------------------------------------------------------------------------------
        BEGIN 
            DROP TABLE  #CONVERT_USAGE;
        END;
        
    -------------------------------------------------------------------------------------
    -- Elec to Cell 환산 #1: 81_UC 기준 1개건 말고는 전부 소요량 일치하므로 max로 사용
        SELECT  *
        INTO    #CONVERT_USAGE
        FROM ( 
                SELECT  B.CHILD_ITEM_ID, MAX(B.USAGE) MAX_USAGE
                FROM    SCP_MST_BOM_ELEC_SN B WITH(NOLOCK)
                INNER JOIN @DIVISION DIV
                    ON  B.DIVISION_ID = DIV.DIVISION_ID
                WHERE   B.SCP_YN        = 'Y'
                -- AND     B.DIVISION_ID   = '81_UC'
                GROUP BY B.CHILD_ITEM_ID
                UNION ALL
                SELECT  MM.CHILD_ITEM_ID, MAX(MM.ACCUM_CHILD_QTY) AS MAX_USAGE
                FROM ( 
                        SELECT  A.MODEL_ID, A.CHILD_ITEM_ID, SUM(A.ACCUMULATED_CHILD_QTY) ACCUM_CHILD_QTY
                        FROM    SCM_MODEL_COMP_EFFECTIVE_DATE A WITH(NOLOCK) --SCM_MODEL_COMP_EFFECTIVE_DATE
                        INNER JOIN @DIVISION DIV
                            ON  A.DIVISION_ID = DIV.DIVISION_ID
                        INNER JOIN SCM_ITEM_M IC WITH (NOLOCK)
                            ON  A.COMPANY_ID     = IC.COMPANY_ID
                            AND A.DIVISION_ID    = IC.DIVISION_ID
                            AND A.SITE_ID        = IC.SITE_ID
                            AND A.CHILD_ITEM_ID  = IC.ITEM_ID
                            AND IC.ACTIVE_FLAG    = 'Y'
                        LEFT OUTER JOIN SCM_MST_ALTER_BOM_V_SN ABM WITH(NOLOCK)  --SCM_MST_ALTER_BOM_V
                            ON  A.DIVISION_ID    = ABM.DIVISION_ID
                            AND A.SITE_ID        = ABM.SITE_ID
                            AND A.PLANT_ID       = ABM.PLANT_ID
                            AND A.PARENT_ITEM_ID = ABM.PARENT_ITEM_ID
                            AND A.CHILD_ITEM_ID  = ABM.CHILD_ITEM_ID
                        WHERE   1=1
                        -- AND     A.DIVISION_ID = '81_UC'
                        AND     ISNULL(A.PARENT_ITEM_ID, '*') != '*'
                        AND     A.EFF_END_DATE > CONVERT(DATE, @V_PLAN_START_YYYYMMDD, 112)
                        AND     IC.FLOW_ID LIKE 'A5000%'  -- NND
                        AND   (A.ALT_ID IS NULL 
                                OR (A.ALT_ID IS NOT NULL AND ABM.SCP_PLAN_YN IS NULL AND ISNULL(A.ALT_PRIORITY, 'N') = 'Y')
                                OR (A.ALT_ID IS NOT NULL AND ABM.SCP_PLAN_YN IS NOT NULL AND ABM.SCP_PLAN_YN = 'Y'))
                        GROUP BY A.MODEL_ID, A.CHILD_ITEM_ID
                        ) MM
                GROUP BY CHILD_ITEM_ID
                ) TT
            ;

	-------------------------------------------------------------------------------------
	IF @V_RESULT_TYPE IN ('ALL', 'BUF', 'ITEM')
	-------------------------------------------------------------------------------------
	BEGIN
	-------------------------------------------------------------------------------------
	-- PRODUCTION RESULT
	-------------------------------------------------------------------------------------
	PRINT 'Prod Result Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	INSERT INTO @RESULT_TEMP
	-------------------------------------------------------------------------------------
	/*SELECT  'PRODUCTION_RESULT'						AS TYPE
		  ,SMS.SCM_SITE_ID							AS SCM_SITE_ID
		  ,PRLT.ITEM_ID								AS ITEM_ID
		  ,OT.STAGE									AS STAGE
		  ,CONVERT(NVARCHAR,PRLT.PLAN_DATE,112)		AS PRODUCTION_DATE
		  ,PRLT.LINE_ID								AS LINE_ID
		  ,SUM(PRLT.PLAN_QTY)						AS QTY
		  ,PRLT.OPERATION_ID						AS OPEARATION_ID
		  ,''										AS FROM_SITE
		  ,''										AS TO_SITE
		  ,''										AS BOD_ID
		  ,''										AS TRANSPORT_MODE
		  ,''										AS INCOTERMS
		  ,''										AS DEPARTURE_DATE
		  ,''										AS ARRIVAL_DATE
	FROM    IF_FP_RELEASE_PLAN_V PRLT WITH(NOLOCK)
			LEFT OUTER JOIN @OPERATION_TEMP OT
				ON PRLT.OPERATION_ID = OT.OPERATION_ID
			INNER JOIN @DIVISION DIV 
				ON PRLT.DIVISION_ID = DIV.DIVISION_ID
			LEFT OUTER JOIN SY_SCM_MST_SITE SMS WITH(NOLOCK)
				ON  PRLT.DIVISION_ID = SMS.DIVISION_ID
				AND PRLT.PLANT_ID    = SMS.PLANT_ID
	WHERE   1=1
	AND     PRLT.PLAN_QTY            >  0   
	AND     PRLT.PLAN_DATE           >= @V_PLAN_START_MONTH_DAY
	AND     PRLT.PLAN_DATE           <  @V_PLAN_START_YYYYMMDD
	AND     PRLT.ITEM_ID             IN (SELECT DISTINCT ITEM_ID
		                                FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
		                                WHERE  PLAN_ID = @V_PLAN_ID
		                                )
	AND     PRLT.LINE_ID IN (SELECT DISTINCT ATTRIBUTE15
							FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
							WHERE   PLAN_ID			= @V_PLAN_ID
							AND     RESOURCE_TYPE	= 'LINE'
							)
	GROUP BY SMS.SCM_SITE_ID, PRLT.ITEM_ID, OT.STAGE, PRLT.PLAN_DATE, PRLT.LINE_ID, PRLT.OPERATION_ID	
	*/
	-- VIEW의 실적구간이 아닌 UI 실적으로 대체
	SELECT  'PRODUCTION_RESULT'						AS TYPE
		  ,SMS.SCM_SITE_ID							AS SCM_SITE_ID
		  ,PRLT.ITEM_ID								AS ITEM_ID
		  ,OT.STAGE									AS STAGE
		  ,CONVERT(NVARCHAR,PRLT.PLAN_DATE,112)		AS PRODUCTION_DATE
		  ,PRLT.LINE_ID								AS LINE_ID
          ,SUM(ISNULL(PRLT.QTY, 0))                 AS QTY
		--   ,SUM(ISNULL(PRLT.QTY_LANE,0) + ISNULL(PRLT.DFCT_QTY2,0) + ISNULL(PRLT.YIELD_LOSS_QTY,0) + ISNULL(PRLT.PRDT_REQ_QTY2,0))  AS QTY
		  ,PRLT.OPERATION_ID						AS OPEARATION_ID
		  ,''										AS FROM_SITE
		  ,''										AS TO_SITE
		  ,''										AS BOD_ID
		  ,''										AS TRANSPORT_MODE
		  ,''										AS INCOTERMS
		  ,''										AS DEPARTURE_DATE
		  ,''										AS ARRIVAL_DATE
          ,'-'                                      AS ELECTRODE_TYPE
		  ,''                                       AS LINE_SIDE -- ADDED 2025.10.29 jongykim2: LINE_SIDE
		  ,NULL 									AS WORKING_DAY
	FROM   SCM_DAILY_PRODUCT_RESULT_H PRLT WITH(NOLOCK)
		INNER JOIN @OPERATION_TEMP_RESULT OT
			ON PRLT.OPERATION_ID = OT.OPERATION_ID
			AND OT.STAGE NOT LIKE '%INSP%'
		INNER JOIN @DIVISION DIV 
			ON PRLT.DIVISION_ID = DIV.DIVISION_ID
		LEFT OUTER JOIN SY_SCM_MST_SITE SMS WITH(NOLOCK)
			ON  PRLT.DIVISION_ID = SMS.DIVISION_ID
			AND PRLT.PLANT_ID    = SMS.PLANT_ID
	WHERE   1=1
	AND     PRLT.PLAN_DATE           >= @V_PLAN_START_MONTH_DAY
	AND     PRLT.PLAN_DATE           <  @V_PLAN_START_YYYYMMDD
	AND     PRLT.ITEM_ID             IN (SELECT DISTINCT ITEM_ID
		                                FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
		                                WHERE  PLAN_ID = @V_PLAN_ID
		                                )
    AND     PRLT.PRODUCTION_TYPE = 'MASS' -- Added 2025-11-27 jongykim2
	GROUP BY SMS.SCM_SITE_ID, PRLT.ITEM_ID, OT.STAGE, PRLT.PLAN_DATE, PRLT.LINE_ID, PRLT.OPERATION_ID	
	-------------------------------------------------------------------------------------
	PRINT 'Prod Result End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	PRINT 'Prod Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	
    -------------------------------------------------------------------------------------
    -- PRODUCTION PLAN
    -------------------------------------------------------------------------------------
    IF @V_RESULT_TYPE IN ('ALL', 'ITEM')
        BEGIN
            INSERT INTO @RESULT_TEMP
            -------------------------------------------------------------------------------------
			-- INSP STAGE는 RESOURCE와 JOIN되면서 FILTER 됨
            -- 2025.09.17 Philsu Park: 특정 공정 정수화 처리.
			-------------------------------------------------------------------------------------
                SELECT 'PRODUCTION_PLAN'        AS TYPE
                    ,PLN.SITE_ID				AS SITE_ID
                    ,PLN.ITEM_ID				AS ITEM_ID
                    ,PLN.STAGE				    AS STAGE
                    ,PLN.PRODUCTION_DATE		AS PRODUCTION_DATE
                    ,PLN.LINE_ID				AS LINE_ID
                    ,CASE WHEN LV.OPERATION_ID IN ('A8000', 'F6000', 'A9000') THEN PLN.QTY ELSE PLN.QTY END AS QTY
                    ,LV.OPERATION_ID			AS OPEARATION_ID
                    ,''						AS FROM_SITE
                    ,''						AS TO_SITE
                    ,''						AS BOD_ID
                    ,''						AS TRANSPORT_MODE
                    ,''						AS INCOTERMS
                    ,''						AS DEPARTURE_DATE
                    ,''						AS ARRIVAL_DATE
                    ,'-'                    AS ELECTRODE_TYPE
                    ,''                     AS LINE_SIDE -- ADDED 2025.10.29 jongykim2: LINE_SIDE
					,NULL					AS WORKING_DAY
                FROM(
                    SELECT   OP.SITE_ID										AS SITE_ID
                            ,OP.ITEM_ID										AS ITEM_ID
                            ,OP.GRADE										AS GRADE
                            ,OP.START_DATE									AS PRODUCTION_DATE
                            -- ,ISNULL(RE.ATTRIBUTE14, RE.ATTRIBUTE15			AS LINE_ID
                            -- ,IBR.LINE_ID                                 AS LINE_ID
                            ,IBR.LINE_ORG                                 AS LINE_ID
                            ,SIS.STAGE                                      AS STAGE
                            --,LV.OPERATION_ID								AS OPERATION_ID
                            ,SUM(CONVERT(NUMERIC(20,10), CONVERT(FLOAT, OP.OUT_QTY)))		AS QTY
                        FROM SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN OP WITH(NOLOCK) 
                        INNER JOIN ( 
                                SELECT  B.ROUTING_BOM_MAPPING_ID
                                        , IIF(CHARINDEX('@', R.ATTRIBUTE15) > 0, LEFT(R.ATTRIBUTE15, CHARINDEX('@', R.ATTRIBUTE15)-1), R.ATTRIBUTE15) AS LINE_ORG
                                        ,  R.ATTRIBUTE15 AS LINE_ID
                                FROM    SCP_OPT_ENG_ITEM_BOM_ROUTING_SN B WITH(NOLOCK)
                                INNER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN R WITH(NOLOCK)
                                    ON  R.PLAN_ID           = B.PLAN_ID
                                    AND R.ROUTING_ID        = B.ROUTING_ID
                                    AND R.RESOURCE_CLASS_ID = 'LINE'
                                    --  AND    R.OP_SEQ = 0
                                WHERE   B.PLAN_ID = @V_PLAN_ID
                                AND     R.RESOURCE_ID IS NOT NULL
                            ) IBR
                            ON  OP.ROUTING_BOM_MAPPING_ID = IBR.ROUTING_BOM_MAPPING_ID
                        INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
                            ON  OP.PLAN_ID = SIS.PLAN_ID
                            AND OP.PRODUCED_BUFFER_ID = SIS.BUFFER_ID
                        WHERE OP.PLAN_ID = @V_PLAN_ID
                        GROUP BY OP.SITE_ID, OP.ITEM_ID, OP.GRADE, OP.START_DATE, IBR.LINE_ORG, SIS.STAGE
                        --,LV.OPERATION_ID
                        ) PLN
                        LEFT OUTER JOIN @OPERATION_TEMP LV
                            ON  @V_DIVISION_ID   = LV.DIVISION_ID -- DIVISION
                            AND @V_PLAN_GROUP_ID = LV.PLAN_GROUP -- PLAN GR
                            AND PLN.STAGE	     = LV.STAGE 
        END
    ELSE IF @V_RESULT_TYPE = 'BUF'
        BEGIN 
            INSERT INTO @RESULT_TEMP
            -------------------------------------------------------------------------------------
                SELECT 'PRODUCTION_PLAN'        AS TYPE
                    ,PLN.SITE_ID				AS SITE_ID
                    ,PLN.ITEM_ID				AS ITEM_ID
                    ,LV.STAGE					AS STAGE
                    ,PLN.PRODUCTION_DATE		AS PRODUCTION_DATE
                    ,PLN.LINE_ID				AS LINE_ID
                    ,CASE WHEN PLN.OPERATION_ID IN ('A8000', 'F6000', 'A9000') THEN PLN.QTY ELSE PLN.QTY END AS QTY
                    ,PLN.OPERATION_ID			AS OPEARATION_ID
                    ,''						AS FROM_SITE
                    ,''						AS TO_SITE
                    ,''						AS BOD_ID
                    ,''						AS TRANSPORT_MODE
                    ,''						AS INCOTERMS
                    ,''						AS DEPARTURE_DATE
                    ,''						AS ARRIVAL_DATE
                    ,PLN.ELECTRODE_TYPE     AS ELECTRODE_TYPE
                    ,''                     AS LINE_SIDE -- ADDED 2025.10.29 jongykim2: LINE_SIDE
					,PLN.WORKING_DAY		AS WORKING_DAY
                FROM(
                        SELECT 	  ST.SCM_SITE_ID 	AS SITE_ID
                                , XLS.ITEM_ID		AS ITEM_ID
                                , XLS.OPERATION_ID	AS OPERATION_ID
                                , CONVERT(NVARCHAR, XLS.PLAN_DATE, 112) AS PRODUCTION_DATE
                                , XLS.LINE_ID		AS LINE_ID
                                , XLS.ELECTRODE_TYPE AS ELECTRODE_TYPE
                                , SUM(XLS.QTY) 		AS QTY
								, MAX(WORKING_DAY)	AS WORKING_DAY
                        FROM   BUF_AMEND_PLAN_R_XLS XLS WITH(NOLOCK)
                        INNER JOIN SY_SCM_MST_SITE ST WITH(NOLOCK)
                            ON 	ST.COMPANY_ID 		= XLS.COMPANY_ID
                            AND ST.SITE_ID 			= XLS.SITE_ID
                            AND ST.PLANT_ID			= XLS.PLANT_ID
                            AND ST.OPERATION_GROUP 	= IIF(LEFT(XLS.OPERATION_ID, 1) = 'F', 'A', LEFT(XLS.OPERATION_ID, 1))
                            AND ST.VALID_YN 		= 'Y'
                        WHERE   EXISTS (
                                        SELECT  1 
                                        FROM    SCM_FP_PLAN_H AS X WITH(NOLOCK)
                                        WHERE   X.INTG_PLAN_ID  = @V_FP_PLAN_ID
                                        AND     X.INSTANCE_ID   = XLS.INSTANCE_ID
                                        AND     X.PLAN_ID       = XLS.FP_PLAN_ID
                                        )
                        GROUP BY ST.SCM_SITE_ID
                                , XLS.ITEM_ID
                                , XLS.OPERATION_ID
                                , CONVERT(NVARCHAR, XLS.PLAN_DATE, 112)
                                , XLS.LINE_ID
                                , XLS.ELECTRODE_TYPE
                        HAVING SUM(XLS.QTY) > 0
                        ) PLN
                        INNER JOIN (SELECT	 SEGMENT3 AS STAGE
                                            ,SEGMENT5 AS OPERATION_ID
                                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LV WITH(NOLOCK)
                                    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_STAGE_OPERATION_MAP' 
                                    AND     SEGMENT1    = @V_DIVISION_ID
                                    AND     SEGMENT2    = @V_PLAN_GROUP_ID
                                    AND     VALID_YN    = 'Y') LV
                            ON  PLN.OPERATION_ID = LV.OPERATION_ID
                        LEFT OUTER JOIN (
                                        SELECT  ATTRIBUTE3 AS STAGE
                                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LU WITH(NOLOCK)
                                        WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                        AND     LU.SEGMENT2    = @V_DIVISION_ID
                                        AND     LU.SEGMENT3    = @V_PLAN_GROUP_ID
                                        AND     LU.VALID_YN    = 'Y'
                                        GROUP BY ATTRIBUTE3
                                       ) OCV
                            ON  LV.STAGE= OCV.STAGE
                WHERE 1=1
                AND     OCV.STAGE IS NULL -- 2nd OCV STAGE는 대상이 아님
    END
	-------------------------------------------------------------------------------------
	PRINT 'Prod Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120);
	-------------------------------------------------------------------------------------
	PRINT 'Daily Capa Start : '+ CONVERT(NVARCHAR,GETDATE(), 120);
	-------------------------------------------------------------------------------------
	-- DAILY_CAPA
	-------------------------------------------------------------------------------------
    IF @V_RESULT_TYPE IN('ALL','BUF')
        BEGIN
            -------------------------------------------------------------------------------------
            -- 일자 별 DAILY CAPA 추가
            -------------------------------------------------------------------------------------
            /*INSERT INTO @RESULT_TEMP
            -------------------------------------------------------------------------------------
            SELECT  'DAILY_CAPA'                 AS TYPE
                   ,RR.SCM_SITE_ID               AS SCM_SITE_ID
                   ,RR.ITEM_ID                   AS ITEM_ID
                   ,RR.STAGE                     AS STAGE
                   ,RR.LP_YYYYMMDD               AS LP_YYYYMMDD
                   ,RR.LINE_ID                   AS LINE_ID
                   ,86400/(RR.LOAD_PER/RT.YIELD) AS DAILY_QTY
                   ,LK.SEGMENT5                  AS OPERATION_ID
                   ,''                           AS FROM_SITE		 
                   ,''                           AS TO_SITE		
                   ,''                           AS BOD_ID			
                   ,''                           AS TRANSPORT_MODE	
                   ,''                           AS INCOTERMS		
                   ,''                           AS DEPARTURE_DATE	
                   ,''                           AS ARRIVAL_DATE	
                   ,'-'                          AS ELECTRODE_TYPE 
            FROM(      
                 SELECT  R.ROUTING_ID       AS ROUTING_ID
                        ,R.ATTRIBUTE1       AS SCM_SITE_ID
                        ,R.ATTRIBUTE15      AS LINE_ID
                        ,R.ATTRIBUTE2       AS ITEM_ID
                        ,R.ATTRIBUTE3       AS STAGE
                        ,R.OP_SEQ           AS OP_SEQ
                        ,R.PLAN_ID          AS PLAN_ID
                        ,LOAD_PER           AS LOAD_PER
                        ,CAL.BASIS_YYYYMMDD AS LP_YYYYMMDD
                 FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN R WITH(NOLOCK)
                     RIGHT OUTER JOIN SCM_SYS_CALENDAR_M_SN CAL WITH(NOLOCK)
                         ON  CAL.BASIS_YYYYMMDD >= R.START_DATE
                         AND CAL.BASIS_YYYYMMDD < R.END_DATE
                 WHERE   PLAN_ID = @V_PLAN_ID
                 AND RESOURCE_CLASS_ID = 'LINE'
                 ) RR
                INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LK WITH(NOLOCK)
                    ON  LK.LOOKUP_TYPE  = 'SCP_OPT_ENG_STAGE_OPERATION_MAP' 
                    AND LK.SEGMENT1     = @V_DIVISION_ID
                    AND LK.SEGMENT2     = @V_PLAN_GROUP_ID
                    AND LK.VALID_YN     = 'Y'
                    AND LK.SEGMENT3     = RR.STAGE
                LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN RT
                    ON  RR.PLAN_ID    = RT.PLAN_ID
                    AND RR.ROUTING_ID = RT.ROUTING_ID
                    AND RR.OP_SEQ	  = RT.OP_SEQ
                LEFT OUTER JOIN (
                                SELECT  ATTRIBUTE3 AS STAGE
                                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LU WITH(NOLOCK)
                                WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                AND     LU.SEGMENT2    = @V_DIVISION_ID
                                AND     LU.SEGMENT3    = @V_PLAN_GROUP_ID
                                AND     LU.VALID_YN    = 'Y'
                                GROUP BY ATTRIBUTE3
                               ) OCV
                    ON  LK.SEGMENT3 = OCV.STAGE
                WHERE   OCV.STAGE IS NULL -- 2nd OCV STAGE는 대상이 아님*/
			-------------------------------------------------------------------------------------
            -- 월별로 변경 DAILY CAPA 추가
            -------------------------------------------------------------------------------------
            INSERT INTO @RESULT_TEMP
            -------------------------------------------------------------------------------------
			SELECT    'DAILY_CAPA'                                  AS TYPE
			        , R.ATTRIBUTE1							        AS SCM_SITE_ID
					, R.ATTRIBUTE2							        AS ITEM_ID
					 ,R.ATTRIBUTE3							        AS STAGE
					, R.ATTRIBUTE14							        AS PLAN_YYYYMM
					, R.ATTRIBUTE15							        AS LINE_ID
					, IIF(MAX(RT.YIELD)=0,0, 86400/(MAX(R.LOAD_PER)/MAX(RT.YIELD))) AS DAILY_QTY
					, LK.SEGMENT5				                    AS OPERATION_ID
					,''										        AS FROM_SITE		 
					,''										        AS TO_SITE		
					,''										        AS BOD_ID			
					,''										        AS TRANSPORT_MODE	
					,''										        AS INCOTERMS		
					,''										        AS DEPARTURE_DATE	
					,''										        AS ARRIVAL_DATE	
					,'-'									        AS ELECTRODE_TYPE 
					,''                                               AS LINE_SIDE -- ADDED 2025.10.29 jongykim2: LINE_SIDE
					,NULL 											AS WORKING_DAY
			FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN R WITH(NOLOCK)
			INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LK WITH(NOLOCK)
				ON  LK.LOOKUP_TYPE  = 'SCP_OPT_ENG_STAGE_OPERATION_MAP' 
				AND LK.SEGMENT1     = @V_DIVISION_ID
				AND LK.SEGMENT2     = @V_PLAN_GROUP_ID
				AND LK.VALID_YN     = 'Y'
				AND LK.SEGMENT3     = R.ATTRIBUTE3
			LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN RT
				ON  R.PLAN_ID    = RT.PLAN_ID
				AND R.ROUTING_ID = RT.ROUTING_ID
				AND R.OP_SEQ	 = RT.OP_SEQ
			LEFT OUTER JOIN (
							SELECT  ATTRIBUTE3 AS STAGE
							FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LU WITH(NOLOCK)
							WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
							AND     LU.SEGMENT2    = @V_DIVISION_ID
							AND     LU.SEGMENT3    = @V_PLAN_GROUP_ID
							AND     LU.VALID_YN    = 'Y'
							GROUP BY ATTRIBUTE3
						   ) OCV
				ON  LK.SEGMENT3 = OCV.STAGE
			WHERE   R.PLAN_ID           = @V_PLAN_ID
			AND     R.RESOURCE_CLASS_ID = 'LINE'
			AND     OCV.STAGE IS NULL -- 2nd OCV STAGE는 대상이 아님
			GROUP BY LK.SEGMENT5, R.ATTRIBUTE1,R.ATTRIBUTE3,R.ATTRIBUTE15, R.ATTRIBUTE2, R.ATTRIBUTE14
			-------------------------------------------------------------------------------------
        END


	-------------------------------------------------------------------------------------
	PRINT 'Daily Capa End : '+ CONVERT(NVARCHAR,GETDATE(), 120);
	-------------------------------------------------------------------------------------


	PRINT 'Ship Result Start : '+ CONVERT(NVARCHAR,GETDATE(), 120);
	-------------------------------------------------------------------------------------
	-- SHIPMENT RESULT
	-------------------------------------------------------------------------------------
	WITH BOD_INFO AS (
        SELECT    ATTRIBUTE1 		AS FROM_SITE
                , ATTRIBUTE2 		AS ITEM_ID
                , MAX(ATTRIBUTE3) 	AS STAGE
                , ATTRIBUTE4 		AS TO_SITE
                , ATTRIBUTE6		AS INCOTERMS
                , TRANSPORT_MODE AS TRANSPORT_MODE
                , ATTRIBUTE7 AS BOD_ID
        FROM 	SCP_OPT_ENG_BOD_SN B WITH(NOLOCK)
        WHERE 	B.PLAN_ID = @V_PLAN_ID
        GROUP BY ATTRIBUTE1
                , ATTRIBUTE2
                , ATTRIBUTE4
                , ATTRIBUTE6
                , TRANSPORT_MODE
                , ATTRIBUTE7
        )
    INSERT INTO @RESULT_TEMP
	-------------------------------------------------------------------------------------
        SELECT  'SHIPMENT_RESULT' 			    AS TYPE
                , E.FROM_SCM_SITE_ID		    AS SCM_SITE_ID
                , E.ITEM_ID					    AS ITEM_ID
                , BOD.STAGE					    AS STAGE
                , '' 						    AS PROUCTION_DATE
                , ''						    AS LINE_ID
                , SUM(E.EXFACTORY_QTY)          AS RESULT_QTY 
                , '' 						    AS OPERATION_ID
                , E.FROM_SCM_SITE_ID 		    AS FROM_SITE
                , E.TO_SCM_SITE_ID			    AS TO_SITE
                , BOD.bod_id 				    AS BOD_ID
                , E.TRANSPORT_MODE			    AS TRANSPORT_MODE
                , E.INCOTERMS				    AS INCOTERMS
                , E.EXFACTORY_DATE              AS DEPARTURE_DATE
                , E.ACTUAL_DELIVERY_DATE	    AS ARRIVAL_DATE
                , '-'						    AS ELECTRODE_TYPE
                , ''                            AS LINE_SIDE -- ADDED 2025.10.29 jongykim2: LINE_SIDE
				, NULL 							AS WORKING_DAY
            FROM SY_SCM_DNM_EXFACTORY_RESULT E WITH(NOLOCK)
            INNER JOIN @DIVISION DIV
                ON  E.DIVISION_ID = DIV.DIVISION_ID
                JOIN SY_SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                    ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
                AND L.VALID_YN = 'Y'
                AND L.SEGMENT1    = E.SSP_TYPE
            JOIN SY_SCM_MST_SITE AS S WITH(NOLOCK)					 
                ON E.FROM_SCM_SITE_ID	= S.SCM_SITE_ID				 
                AND E.DIVISION_ID	= S.DIVISION_ID				 
                AND S.SITE_TYPE		= 'PLANT'					 				 
            JOIN SCM_ITEM_M AS T WITH(NOLOCK)				 
                ON E.ITEM_ID		= T.ITEM_ID					 
                AND E.DIVISION_ID	= T.DIVISION_ID				 
                AND S.COMPANY_ID		= T.COMPANY_ID				 
                AND T.ITEM_TYPE		NOT IN ('Q','R')
            LEFT OUTER JOIN BOD_INFO BOD
                ON 	BOD.FROM_SITE 		= E.FROM_SCM_SITE_ID
                AND BOD.TO_SITE			= E.TO_SCM_SITE_ID
                AND BOD.ITEM_ID			= E.ITEM_ID
                AND BOD.INCOTERMS 		= E.INCOTERMS
                AND BOD.TRANSPORT_MODE 	= E.TRANSPORT_MODE
            WHERE 1=1
            AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
            AND   E.CONFIRM_ID       LIKE 'C%'
            AND   E.EXFACTORY_DATE  >= @V_PLAN_START_MONTH_DAY
            AND   E.EXFACTORY_DATE   < @V_TODAY
            -- AND   E.DIVISION_ID      = @V_DIVISION_ID
            AND   E.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                WHERE  PLAN_ID = @V_PLAN_ID
                                )
            GROUP BY E.FROM_SCM_SITE_ID
                    , E.ITEM_ID
                    , BOD.STAGE
                    , E.FROM_SCM_SITE_ID
                    , E.TO_SCM_SITE_ID
                    , BOD.bod_id
                    , E.TRANSPORT_MODE
                    , E.INCOTERMS
                    , E.EXFACTORY_DATE
                    , E.ACTUAL_DELIVERY_DATE
            UNION ALL
            -- ERP 출하실적에서 CONFIRM_ID 없는 실적 
            SELECT  'SHIPMENT_RESULT' 					AS TYPE
                , E.FROM_SCM_SITE_ID                    AS FROM_SITE
                , E.ITEM_ID                             AS ITEM_ID
                , BOD.STAGE 							as Stage
                , '' 									AS PROUCTION_DATE
                , ''									AS LINE_ID
                , SUM(E.EXFACTORY_QTY)                 	AS RESULT_QTY
                , '' 				 					AS OPERATION_ID
                , E.FROM_SCM_SITE_ID 					AS FROM_SITE
                , ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID) AS TO_SITE
                , BOD.BOD_ID 							AS BOD_ID
                , E.TRANSPORT_MODE		  				AS TRANSPORT_MODE
                , E.INCOTERMS				  			AS INCOTERMS
                , E.EXFACTORY_DATE          			AS DEPARTURE_DATE
                , E.ACTUAL_DELIVERY_DATE				AS ARRIVAL_DATE
                , '-'									AS ELECTRODE_TYPE
                , ''                                    AS LINE_SIDE -- ADDED 2025.10.29 jongykim2: LINE_SIDE
				, NULL 									AS WORKING_DAY
            FROM SY_SCM_DNM_EXFACTORY_RESULT E WITH(NOLOCK)
            INNER JOIN @DIVISION DIV
                ON  E.DIVISION_ID = DIV.DIVISION_ID
            JOIN SY_SCM_MST_SITE AS S WITH(NOLOCK)					 
                ON E.FROM_SCM_SITE_ID	= S.SCM_SITE_ID				 
                AND E.DIVISION_ID	= S.DIVISION_ID				 
                AND S.SITE_TYPE		= 'PLANT'					 				 
            JOIN SCM_ITEM_M AS T WITH(NOLOCK)				 
                ON E.ITEM_ID		= T.ITEM_ID					 
                AND E.DIVISION_ID	= T.DIVISION_ID				 
                AND S.COMPANY_ID		= T.COMPANY_ID				 
                AND T.ITEM_TYPE		NOT IN ('Q','R')
            JOIN  SCP_MST_FINAL_ITEM_SN F WITH(NOLOCK) -- SCP 대상 ITEM만 
                ON F.ITEM_ID = E.ITEM_ID 
                AND F.DIVISION_ID = E.DIVISION_ID
            JOIN   SY_SCM_MST_SITE FS WITH(NOLOCK)
                ON FS.SCM_SITE_ID = E.FROM_SCM_SITE_ID 
                AND FS.DIVISION_ID = E.DIVISION_ID 
                -- AND ISNULL(FS.OSP_YN,'N') <> 'Y' --- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN <> 'Y' 조건제외)
            -- 2020.09.18 김광희 책임 요청으로 주석처리
            -- 2021.04.15 김광희 책임 요청으로 주석해제
            JOIN SY_SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                ON L.LOOKUP_TYPE = 'ERP_ORDER_TYPE' -- LOOKUP에 등록된 ORDER_TYPE만 대상으로 함 
                AND L.VALID_YN = 'Y'
                AND L.SEGMENT1    = E.ORDER_TYPE_CODE 	
            LEFT OUTER JOIN SY_SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK)
                ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
                AND L3.SEGMENT1    = E.DIVISION_ID 
                AND L3.SEGMENT2    = E.SOLDTO_CODE
                AND L3.SEGMENT3    = E.SHIPTO_CODE
            LEFT OUTER JOIN BOD_INFO BOD
                ON 	BOD.FROM_SITE 		= E.FROM_SCM_SITE_ID
                AND BOD.TO_SITE			= ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID)
                AND BOD.ITEM_ID			= E.ITEM_ID
                AND BOD.INCOTERMS 		= E.INCOTERMS
                AND BOD.TRANSPORT_MODE 	= E.TRANSPORT_MODE
            WHERE 1=1
            AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
            AND   ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
            AND   E.EXFACTORY_DATE  >= @V_PLAN_START_MONTH_DAY
            AND   E.EXFACTORY_DATE   < @V_TODAY
            -- AND   E.DIVISION_ID      = @V_DIVISION_ID
            --[C20210330-000402]
            --AND   E.FROM_SCM_SITE_ID IS NOT NULL 
            --AND   E.TO_SCM_SITE_ID IS NOT NULL 
            AND   E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외 
            --[C20200403-000062]
            AND   E.STORAGE_ID NOT IN ( SELECT SEGMENT1 
                                        FROM SY_SCM_ADM_LOOKUP_MASTER_DETAIL 
                                        WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
                                        AND VALID_YN = 'Y'
                                        )	-- 사외 창고 제외 LOOKUP 관리
            --AND   E.ORDER_TYPE_CODE  IN ('ZEF','ZEFC','ZEML','ZEMM','ZEX','ZFD','ZFR','ZKB','ZMM','ZOR','ZFDC','ZKM') -- 해당 ORDER_TYPE만 대상으로 함 
            AND   E.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                WHERE  PLAN_ID = @V_PLAN_ID
                                )
            GROUP BY E.FROM_SCM_SITE_ID
                    , E.ITEM_ID
                    , BOD.STAGE
                    , E.FROM_SCM_SITE_ID
                    , E.TRANSPORT_MODE
                    , E.INCOTERMS
                    , E.EXFACTORY_DATE
                    , E.ACTUAL_DELIVERY_DATE
                    , ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID) 
                    , BOD.BOD_ID
        ;
	/* SELECT 'SHIPMENT_RESULT'					AS TYPE
	      ,SSP.FROM_SITE						AS SCM_SITE_ID
		  ,SSP.ITEM_ID							AS ITEM_ID
		  ,SIS.STAGE							AS STAGE
		  ,''									AS PRODUCTION_dATE
		  ,''									AS LINE_ID
		  ,SUM(SSP.QTY)							AS QTY
		  ,''									AS OPERATION_ID
		  ,SSP.FROM_SITE						AS FROM_SITE
		  ,SSP.TO_SITE							AS TO_SITE
		  ,SSP.BOD_ID							AS BOD_ID
		  ,SSP.TRANSPORT_MODE					AS TRANSPORT_MODE
		  ,SSP.INCOTERMS						AS INCOTERMS
		  ,SSP.YYYYMMDD							AS DEPARTURE_DATE
		  ,CONVERT(NVARCHAR,SSP.ETA_DATE,112)	AS ARRIVAL_DATE
          ,'-'                                  AS ELECTRODE_TYPE
	FROM   SCM_DNM_SSP_PLAN_V_SN SSP WITH(NOLOCK)
		   INNER JOIN @DIVISION DIV 
			   ON SSP.DIVISION_ID = DIV.DIVISION_ID
		   LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
			   ON   PLAN_ID = @V_PLAN_ID
			   AND  SIS.SITE_ID = SSP.FROM_SITE
			   AND  SIS.ITEM_ID = SSP.ITEM_ID
	WHERE  SSP.YYYYMMDD		>= @V_PLAN_START_MONTH_DAY
	--AND    SSP.YYYYMMDD     <  @V_PLAN_START_YYYYMMDD
	AND    SSP.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
							FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
							WHERE  PLAN_ID = @V_PLAN_ID
							)
	GROUP BY SSP.FROM_SITE, SSP.ITEM_ID, SIS.STAGE, SSP.FROM_SITE, SSP.TO_SITE, SSP.BOD_ID, SSP.TRANSPORT_MODE, SSP.INCOTERMS, SSP.YYYYMMDD, SSP.ETA_DATE */
	-------------------------------------------------------------------------------------
	PRINT 'Ship Result End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	PRINT 'Ship Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	-- SHIPMENT PLAN
	-------------------------------------------------------------------------------------
    IF @V_RESULT_TYPE IN ('ALL', 'ITEM')
        BEGIN 
            INSERT INTO @RESULT_TEMP
            -------------------------------------------------------------------------------------
                SELECT 'SHIPMENT_PLAN'					        AS TYPE
                    ,SITE_ID							        AS SITE_ID
                    ,ITEM_ID							        AS ITEM_ID
                    ,STAGE								        AS STAGE
                    ,''									        AS PRODUCTION_dATE
                    ,''									        AS LINE_ID
                    --,SUM(CONVERT(NUMERIC(30,10), QTY))          AS QTY -- blocked 2025-11-05, 자릿수 초과에 따른 형변환 에러
                    ,SUM(CONVERT(NUMERIC(20,10), CONVERT(FLOAT, QTY))) AS QTY -- added 2025-11-05
                    ,''									        AS OPERATION_ID
                    ,FROM_SITE							        AS FROM_SITE
                    ,TO_SITE							        AS TO_SITE	
                    ,BOD_ID								        AS BOD_ID
                    ,TRANSPORT_MODE						        AS TRANSPORT_MODE
                    ,INCOTERMS							        AS INCOTERMS
                    ,DEPARTURE_DATE						        AS DEPARTURE_DATE
                    ,ARRIVAL_DATE						        AS ARRIVAL_DATE
                    ,'-'                                        AS ELECTRODE_TYPE
                    ,''                                         AS LINE_SIDE -- ADDED 2025.10.29 jongykim2: LINE_SIDE
					,NULL 										AS WORKING_DAY
                FROM(
                    SELECT   FS.SITE_ID         AS SITE_ID
                            ,OS.ITEM_ID         AS ITEM_ID
                            ,FS.STAGE			AS STAGE
                            ,OS.FROM_SITE_ID    AS FROM_SITE
                            ,OS.TO_SITE_ID      AS TO_SITE
                            ,OS.TRANSPORT_MODE  AS TRANSPORT_MODE
                            ,BOD.ATTRIBUTE7     AS BOD_ID
                            ,BOD.ATTRIBUTE6     AS INCOTERMS
                            ,OS.DEPARTURE_DATE  AS DEPARTURE_DATE 
                            ,OS.ARRIVAL_DATE    AS ARRIVAL_DATE 
                            ,OS.QTY             AS QTY
                    FROM SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN  OS WITH(NOLOCK)
                    INNER JOIN @DIVISION DIV
                        ON  1=1
                    INNER JOIN SY_SCM_MST_SITE ST WITH(NOLOCK)
                        ON  ST.DIVISION_ID = DIV.DIVISION_ID
                        and ST.SCM_SITE_ID = OS.TO_SITE_ID
                    INNER JOIN (
                                SELECT    PLAN_ID
                                        , FROM_BUFFER_ID
                                        , TO_BUFFER_ID
                                        , TRANSPORT_MODE
                                        , ATTRIBUTE3
                                        , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                                FROM    SCP_OPT_ENG_BOD_SN WITH(NOLOCK)
                                WHERE   PLAN_ID         = @V_PLAN_ID
                                AND     ATTRIBUTE8      = 'SALES'  -- CELLBIZ -> DEMAND GR로 보내는 출하는 제외
                                AND     ATTRIBUTE7     <> 'DUMMY' -- CELLBIZ -> DEMAND GR로 보내는 출하는 제외
                                AND     TRANSPORT_MODE != 'PALLET'
                                GROUP BY  PLAN_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, ATTRIBUTE3, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                                ) BOD
                        ON  OS.PLAN_ID          = BOD.PLAN_ID
                        AND OS.FROM_BUFFER_ID   = BOD.FROM_BUFFER_ID
                        AND OS.TO_BUFFER_ID     = BOD.TO_BUFFER_ID
                        AND OS.TRANSPORT_MODE   = BOD.TRANSPORT_MODE
                    INNER JOIN SCP_OPT_ENG_PLAN_MASTER_SN PM WITH(NOLOCK)
                        ON  OS.PLAN_ID = PM.PLAN_ID
                    INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN FS WITH(NOLOCK)
                        ON  OS.PLAN_ID       = FS.PLAN_ID
                        AND OS.FROM_BUFFER_ID = FS.BUFFER_ID
                    INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN TS WITH(NOLOCK)
                        ON  OS.PLAN_ID      = TS.PLAN_ID
                        AND OS.TO_BUFFER_ID = TS.BUFFER_ID
                    LEFT OUTER JOIN (
                                        SELECT  BUFFER_ID, ATTRIBUTE8 AS FCST_TYPE
                                        FROM    SCP_OPT_ENG_DEMAND_SN TS WITH(NOLOCK)
                                        WHERE   PLAN_ID = @V_PLAN_ID
                                        GROUP BY BUFFER_ID, ATTRIBUTE8
                                    ) DM
                        ON  OS.TO_BUFFER_ID = DM.BUFFER_ID
                    WHERE 1=1
                    --AND BOD.ATTRIBUTE8 = 'PLANT'  --SALES는 FG에 넣고 PLANT만 SEMI에 넣으면 됨.
                    AND OS.PLAN_ID = @V_PLAN_ID
                    /* FROM SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN  OS WITH(NOLOCK)
                        --INNER JOIN SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK) 
						LEFT OUTER JOIN SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK) 
                            ON  BOD.PLAN_ID = @V_PLAN_ID
                            AND OS.BOD_ID   = BOD.BOD_ID
							AND BOD.TRANSPORT_MODE <> 'PALLET'
                        INNER JOIN SCP_OPT_ENG_PLAN_MASTER_SN PM WITH(NOLOCK)
                            ON  OS.PLAN_ID = PM.PLAN_ID
                        INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN FS WITH(NOLOCK)
                            ON  OS.PLAN_ID       = FS.PLAN_ID
                            AND OS.FROM_BUFFER_ID = FS.BUFFER_ID
                        INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN TS WITH(NOLOCK)
                            ON  OS.PLAN_ID      = TS.PLAN_ID
                            AND OS.TO_BUFFER_ID = TS.BUFFER_ID
                    WHERE 1=1
                    AND OS.PLAN_ID = @V_PLAN_ID */
                ) A 
                WHERE 1=1
                --AND   BOD_ID IS NOT NULL
                GROUP BY SITE_ID, ITEM_ID, STAGE, FROM_SITE, TO_SITE, BOD_ID, TRANSPORT_MODE, INCOTERMS ,DEPARTURE_DATE ,ARRIVAL_DATE
        END
    ELSE IF @V_RESULT_TYPE = 'BUF'
        BEGIN
            INSERT INTO @RESULT_TEMP
            -------------------------------------------------------------------------------------
                SELECT 'SHIPMENT_PLAN'						AS TYPE
                        ,SITE_ID							AS SITE_ID
                        ,ITEM_ID							AS ITEM_ID
                        ,STAGE								AS STAGE
                        ,''									AS PRODUCTION_dATE
                        ,''									AS LINE_ID
                        ,SUM(CONVERT(NUMERIC(30,10), QTY))	AS QTY
                        ,''									AS OPERATION_ID
                        ,FROM_SITE							AS FROM_SITE
                        ,TO_SITE							AS TO_SITE	
                        ,BOD_ID								AS BOD_ID
                        ,TRANSPORT_MODE						AS TRANSPORT_MODE
                        ,INCOTERMS							AS INCOTERMS
                        ,DEPARTURE_DATE						AS DEPARTURE_DATE
                        ,ARRIVAL_DATE						AS ARRIVAL_DATE
                        ,'-'                                AS ELECTRODE_TYPE
                        ,''                                 AS LINE_SIDE -- ADDED 2025.10.29 jongykim2: LINE_SIDE
						,NULL								AS WORKING_DAY
                    FROM(
                        SELECT    PLANT_SITE_ID     AS SITE_ID
                                , ITEM_ID			AS ITEM_ID
                                , ATTRIBUTE2 		AS STAGE
                                , PLANT_SITE_ID 	AS FROM_SITE
                                , SCM_SITE_ID 		AS TO_SITE
                                , TRANSPORT_MODE    AS TRANSPORT_MODE
                                , BOD_ID			AS BOD_ID
                                , INCOTERMS			AS INCOTERMS
                                , YYYYMMDD 			AS DEPARTURE_DATE
                                , YYYYMMDD 			AS ARRIVAL_DATE
                                , QTY 				AS QTY
                        FROM 	BUF_AMEND_PLAN_SSP_R_XLS R WITH(NOLOCK)
                        WHERE   ISNULL(ATTRIBUTE2, '') != ''
                    ) A 
                    WHERE 1=1
                    AND   BOD_ID IS NOT NULL
                    AND    A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
							FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
							WHERE  PLAN_ID = @V_PLAN_ID
							)
                    GROUP BY SITE_ID, ITEM_ID, STAGE, FROM_SITE, TO_SITE, BOD_ID, TRANSPORT_MODE, INCOTERMS ,DEPARTURE_DATE ,ARRIVAL_DATE
        END
	-------------------------------------------------------------------------------------
	PRINT 'Ship Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	PRINT 'MKTFCST Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	-- MKTFCST PLAN
	-- 2025.10.23 Philsu Park: MKT Fcst를 UI 기준 MKT Fcst(R+P) 와 동일하게 적용.(실적 + 계획)
	-------------------------------------------------------------------------------------
	INSERT INTO @RESULT_TEMP
	-------------------------------------------------------------------------------------
	SELECT 'MKTFCST'		AS TYPE
	      ,A.SCM_SITE_ID	AS SCM_SITE_ID
		  ,A.ITEM_ID		AS ITEM_ID
		  ,SIS.STAGE		AS STAGE 
		  ,A.YYYYMMDD		AS PRODUCTION_DATE
		  ,''				AS LINE_ID
		  ,SUM(A.QTY)		AS QTY
		  ,''				AS OPERATION_ID
		  ,''				AS FROM_SITE
		  ,''				AS TO_STE
		  ,''				AS BOD_ID
		  ,''				AS TRANSPORT_MODE
		  ,A.INCOTERMS		AS INCOTERMS
		  ,''				AS DEPARTURE_DATE
		  ,''				AS ARRIVAL_DATE
          ,'-'              AS ELECTRODE_TYPE
		  ,''               AS LINE_SIDE -- ADDED 2025.10.29 jongykim2: LINE_SIDE
		  ,NULL				AS WORKING_DAY
	-- START 2025.10.27 jongykim2: 실직 + 최적화 계획 Demand 기준 적용
	FROM (  SELECT F.SCM_SITE_ID
			     , F.ITEM_ID
			     , F.INCOTERMS
			     , F.YYYYMMDD
			     , F.QTY
			FROM   SY_DM_PLN_MKT_FCST_RESULT F WITH(NOLOCK)
			INNER JOIN @DIVISION DIV
				ON DIV.DIVISION_ID = F.DIVISION_ID
			WHERE  F.MEASURE       = 'RTF_SYS_RP'
			AND    F.YYYYMMDD     >= @V_PLAN_START_MONTH_DAY
			AND    F.YYYYMMDD     <  @V_PLAN_START_YYYYMMDD
			AND    F.QTY          >  0
			UNION ALL
			SELECT F.ATTRIBUTE1 AS SCM_SITE_ID
			     , F.ATTRIBUTE2 AS ITEM_ID
				 , F.ATTRIBUTE4 AS INCOTERMS
				 , F.DUE_DATE AS YYYYMMDD
				 , F.QUANTITY AS QTY
			--FROM   SCP_OPT_ENG_DEMAND_SN F WITH(NOLOCK) -- BLOCKED 2025.10.31 jongykim2
            FROM   SCP_OPT_ENG_DEMAND_ORIGIN_SN F WITH(NOLOCK) -- ADDED 2025.10.31 jongykim2
			WHERE  1 = 1
			AND    F.PLAN_ID     = @V_PLAN_ID
			AND    F.DUE_DATE   >= @V_PLAN_START_YYYYMMDD
			AND    F.DUE_DATE   <  @V_PLAN_END_YYYYMMDD
			AND    F.QUANTITY   >  0
			) A -- END 2025.10.27 jongykim2: 
	/* -- BLOCKED 2025.10.27 jongykim2
	FROM DM_PLN_NET_DEMAND_SN A WITH (NOLOCK)
		 LEFT JOIN ( SELECT   SEGMENT2   AS DIVISION_ID
							, SEGMENT3   AS SCM_SITE_ID
							, SEGMENT4   AS ITEM_ID
							, SEGMENT5   AS GROUP_ID
							, CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
								ELSE ATTRIBUTE2
							END AS START_DATE  -- PLAN 제외 시작일자
							, CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
								ELSE ATTRIBUTE3
							END AS END_DATE  -- PLAN 제외 끝일자
					FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LV WITH(NOLOCK)
					WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
					AND    VALID_YN    = 'Y'
					AND    SEGMENT2    = @V_DIVISION_ID
					AND    SEGMENT5    = @V_PLAN_GROUP_ID
					) DE
			  ON  A.SCM_SITE_ID   = DE.SCM_SITE_ID
			  AND A.ITEM_ID       = DE.ITEM_ID */
          LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
			  ON   PLAN_ID = @V_PLAN_ID
			  AND  SIS.SITE_ID = A.SCM_SITE_ID
			  AND  SIS.ITEM_ID = A.ITEM_ID
    ------------------------------------------------------------------------
        WHERE 1=1
        /* -- BLOCKED 2025.10.27 jongykim2
        AND A.CUTOFF_YYYYMMDD   =  @V_DEMAND_CUTOFF_DAY
        AND A.VERSION_NO        =  @V_DM_MAX_VERSION
        AND A.ATTRIBUTE1        >= @V_PLAN_START_YYYYMMDD
        AND A.ATTRIBUTE1        <  @V_PLAN_END_YYYYMMDD */
        AND A.QTY               >  0
        /* -- BLOCKED 2025.10.27 jongykim2
        AND (ISNULL(DE.ITEM_ID, '') = ''
            OR (ISNULL(DE.ITEM_ID, '') <> '' AND (A.ATTRIBUTE1 < DE.START_DATE OR A.ATTRIBUTE1 > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
            ) */
        AND  A.ITEM_ID IN (SELECT DISTINCT ITEM_ID 
							FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
						 WHERE   PLAN_ID = @V_PLAN_ID
							)
		GROUP BY  A.SCM_SITE_ID, A.ITEM_ID, SIS.STAGE, A.YYYYMMDD, A.INCOTERMS
	-------------------------------------------------------------------------------------
	PRINT 'MKTFCST Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	PRINT 'INVENTORY Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	-- INVENTORY
	-------------------------------------------------------------------------------------
	INSERT INTO @RESULT_TEMP
	-------------------------------------------------------------------------------------
	SELECT 'INVENTORY'		                                                 	AS TYPE
	       ,ATTRIBUTE1		                                                 	AS SCM_SITE_ID
			,CASE WHEN ATTRIBUTE3 = 'TRAY' THEN BUFFER_ID ELSE ATTRIBUTE2 END	AS ITEM_ID
		   ,ATTRIBUTE3		                                                 	AS STAGE
		   ,EFFECTIVE_DATE                                                   	AS PRODUCTION_DATE
		   ,CASE WHEN EIS.TYPE LIKE '%_HOLD' THEN 'HOLD_Y' ELSE 'HOLD_N' END 	AS LINE_ID
		   ,SUM(QUANTITY)                                                    	AS QTY
		   ,LV.OPERATION_ID                                                  	AS OPERATION_ID
		   ,''				                                                 	AS FROM_SITE
		   ,''				                                                 	AS TO_SITE
		   ,''				                                                 	AS BOD_ID
		   ,''				                                                 	AS TRANSPRT_MODE
		   ,''				                                                 	AS INCOTERMS 
		   ,''				                                                 	AS DEPARTURE_DATE
		   ,''				                                                 	AS ARRIVAL_DATE
           ,'-'                                                              	AS ELECTRODE_TYPE
		   ,ISNULL(dbo.SCM_ARR_SPL_VAL(EIS.ATTRIBUTE6, '@', 2),'')            AS LINE_SIDE -- ADDED 2025.10.29 jongykim2: LINE_SIDE
		   ,NULL 																AS WORKING_DAY
	FROM   SCP_OPT_ENG_INCOMING_STOCK_SN EIS WITH(NOLOCK)
			LEFT OUTER JOIN @OPERATION_TEMP LV
				ON  @V_DIVISION_ID   = LV.DIVISION_ID -- DIVISION
				AND @V_PLAN_GROUP_ID = LV.PLAN_GROUP -- PLAN GR
				AND EIS.ATTRIBUTE3	 = LV.STAGE 
	WHERE  PLAN_ID		= @V_PLAN_ID
	AND    ATTRIBUTE3	NOT IN ( 'MATERIAL_CONST','-'  )
	GROUP BY ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3,BUFFER_ID, EFFECTIVE_DATE, EIS.TYPE, LV.OPERATION_ID, ISNULL(dbo.SCM_ARR_SPL_VAL(EIS.ATTRIBUTE6, '@', 2),'') -- ADDED 2025.10.29 jongykim2: LINE_SIDE
	-------------------------------------------------------------------------------------
	PRINT 'INVENTORY Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	/*
	PRINT 'TACT_TIME Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	-- TACT_TIME
	-------------------------------------------------------------------------------------
	INSERT INTO @RESULT_TEMP
	-------------------------------------------------------------------------------------
	SELECT   DISTINCT 
	         'TACT_TIME'		AS TYPE 
			,ERR.ATTRIBUTE1		AS SCM_SITE_ID
			,ERR.ATTRIBUTE2		AS ITEM_ID
			,ERR.ATTRIBUTE3		AS STAGE
			,ERR.ATTRIBUTE14	AS PRODUCTION_DATE
			,ERR.ATTRIBUTE15	AS LINE_ID
			,ERR.LOAD_PER		AS QTY
			,LV.OPERATION_ID	AS OPERATION_ID
			,''					AS FROM_SITE
			,''					AS TO_SITE
			,''					AS BOD_ID
			,''					AS TRANSPRT_MODE
			,''					AS INCOTERMS 
			,''					AS DEPARTURE_DATE
			,''					AS ARRIVAL_DATE
            ,'-'                AS ELECTRODE_TYPE
	FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN ERR WITH(NOLOCK)
			LEFT OUTER JOIN @OPERATION_TEMP LV
				ON  @V_DIVISION_ID   = LV.DIVISION_ID
				AND @V_PLAN_GROUP_ID = LV.PLAN_GROUP
				AND ERR.ATTRIBUTE3	 = LV.STAGE 
	WHERE  ERR.PLAN_ID			 = @V_PLAN_ID
	AND    ERR.RESOURCE_CLASS_ID = 'LINE'
	-------------------------------------------------------------------------------------
	PRINT 'TACT_TIME Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	*/
	PRINT 'YIELD Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	-- YIELD
	-------------------------------------------------------------------------------------
	INSERT INTO @RESULT_TEMP
	-------------------------------------------------------------------------------------
	SELECT  DISTINCT 
			 'YIELD'			AS TYPE 
			,ER.ATTRIBUTE1		AS SCM_SITE_ID
			,ER.ATTRIBUTE2		AS ITEM_ID
			,ER.ATTRIBUTE3		AS STAGE
			,ER.ATTRIBUTE15		AS PRODUCTION_DATE
			,ER.ATTRIBUTE14		AS LINE_ID
			,ER.YIELD			AS QTY
			,LV.OPERATION_ID	AS OPERATION_ID
			,''					AS FROM_SITE
			,''					AS TO_SITE
			,''					AS BOD_ID
			,''					AS TRANSPRT_MODE
			,''					AS INCOTERMS 
			,''					AS DEPARTURE_DATE
			,''					AS ARRIVAL_DATE
            ,'-'                AS ELECTRODE_TYPE
			,''                 AS LINE_SIDE -- ADDED 2025.10.29 jongykim2: LINE_SIDE
			,NULL 				AS WORKING_DAY
	FROM   SCP_OPT_ENG_ROUTING_SN ER WITH(NOLOCK)
		   LEFT OUTER JOIN @OPERATION_TEMP LV
				ON  @V_DIVISION_ID   = LV.DIVISION_ID 
				AND @V_PLAN_GROUP_ID = LV.PLAN_GROUP
				AND ER.ATTRIBUTE3	 = LV.STAGE 
	WHERE  ER.PLAN_ID     = @V_PLAN_ID
	AND    ER.ATTRIBUTE3  NOT IN ( 'MATERIAL_CONST','TRAY','-'  )
    AND    ER.YIELD       > 0 -- added 2025-11-20 jongykim2
    AND   (ER.ATTRIBUTE3 != 'ASSY' OR NOT (ER.ATTRIBUTE3 = 'ASSY' AND ER.OP_SEQ = 1)) -- Added 2025-12-08 jongykim2, TRAY 제약용 ASSY 건 제외
	-------------------------------------------------------------------------------------
	PRINT 'YIELD Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	PRINT 'WORKING DAY Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	-- WORKING DAY
    -- 2025.10.14 Philsu Park: BUF인 경우 셀 환산 수량을 역산해서 계산.
	-------------------------------------------------------------------------------------
	INSERT INTO @RESULT_TEMP
	-------------------------------------------------------------------------------------
	SELECT   'WORKING_DAY'	
			,TEMP.SCM_SITE_ID
			,TEMP.ITEM_ID
			,TEMP.STAGE	
			,TEMP.PRODUCTION_DATE
			,TEMP.LINE_ID
			-- ,TEMP.QTY / CAPA.DAILY_QTY
            -- ,IIF(@V_RESULT_TYPE = 'BUF', (TEMP.QTY * ISNULL(USG.MAX_USAGE, 1)) / CAPA.DAILY_QTY, TEMP.QTY / CAPA.DAILY_QTY)
			--,IIF(@V_RESULT_TYPE = 'BUF', TEMP.WORKING_DAY, TEMP.QTY / CAPA.DAILY_QTY)
            ,IIF(@V_RESULT_TYPE = 'BUF', TEMP.WORKING_DAY, IIF(CONVERT(NUMERIC(20,10), CONVERT(FLOAT, CAPA.DAILY_QTY)) = 0,0, TEMP.QTY / CAPA.DAILY_QTY))
			,TEMP.OPERATION_ID
			,TEMP.FROM_SITE
			,TEMP.TO_SITE
			,TEMP.BOD_ID
			,TEMP.TRANSPORT_MODE
			,TEMP.INCOTERMS
	        ,TEMP.DEPARTURE_DATE
		    ,TEMP.ARRIVAL_DATE
            ,TEMP.ELECTRODE_TYPE
			,TEMP.LINE_SIDE
			,NULL					AS WORKING_DAY
	FROM   @RESULT_TEMP  TEMP
    LEFT OUTER JOIN @DAILY_CAPA CAPA
        ON  CAPA.OPERATION_ID	= TEMP.OPERATION_ID
        AND CAPA.LINE_ID		= TEMP.LINE_ID
        AND CAPA.ITEM_ID		= TEMP.ITEM_ID
        AND CAPA.PLAN_YYYYMM	= SUBSTRING(TEMP.PRODUCTION_DATE,1,6)
    LEFT OUTER JOIN #CONVERT_USAGE USG
        ON  CAPA.ITEM_ID = USG.CHILD_ITEM_ID
	WHERE 1=1
	AND   TYPE = 'PRODUCTION_PLAN'
	-------------------------------------------------------------------------------------
	PRINT 'WORKING DAY Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
	-------------------------------------------------------------------------------------
	

    -------------------------------------------------------------------------------------
	-- Update Qty to Cell.
    -- 2025.10.14 Philsu Park: BUF 인 경우에는 이미 환산된 수량이므로 BUF 아닌 경우에만 UPDATE.
	-------------------------------------------------------------------------------------
    IF @V_PLAN_GROUP_ID = 'GM1_E' --AND @V_RESULT_TYPE != 'BUF'
	BEGIN
		WITH BOM_ELEC AS 
                (
                    -- Elec to Cell 환산 #1: 81_UC 기준 1개건 말고는 전부 소요량 일치하므로 max로 사용
                    SELECT  B.CHILD_ITEM_ID, MAX(B.USAGE) MAX_USAGE
                    FROM    SCP_MST_BOM_ELEC_SN B WITH(NOLOCK)
                    INNER JOIN @DIVISION DIV
                        ON  B.DIVISION_ID = DIV.DIVISION_ID
                    WHERE   B.SCP_YN        = 'Y'
                    -- AND     B.DIVISION_ID   = '81_UC'
                    GROUP BY B.CHILD_ITEM_ID
                )
		UPDATE	RS
		SET 	RS.QTY = RS.QTY / BOM.MAX_USAGE
		FROM 	@RESULT_TEMP RS
		INNER JOIN BOM_ELEC BOM
			ON 	RS.ITEM_ID = BOM.CHILD_ITEM_ID
		WHERE 	1=1
		--AND 	RS.STAGE = 'COATING'
        -- AND     @V_RESULT_TYPE != 'BUF'
		AND 	RS.STAGE IN ( 'COATING','INSP_COT' )
		AND 	((@V_RESULT_TYPE != 'BUF' AND RS.TYPE IN ('PRODUCTION_RESULT', 'PRODUCTION_PLAN', 'SHIPMENT_PLAN', 'SHIPMENT_RESULT', 'INVENTORY','DAILY_CAPA'))
                OR (@V_RESULT_TYPE = 'BUF' AND RS.TYPE IN ('PRODUCTION_RESULT', 'SHIPMENT_RESULT', 'INVENTORY','DAILY_CAPA'))
            )
		;


		IF OBJECT_ID('TEMPDB..#BOM_NND') IS NOT NULL
            BEGIN 
                DROP TABLE  #BOM_NND;
            END;

            SELECT  MM.CHILD_ITEM_ID, MAX(MM.ACCUM_CHILD_QTY) AS MAX_USAGE
            INTO    #BOM_NND
            FROM ( 
                    SELECT  A.MODEL_ID, A.CHILD_ITEM_ID, SUM(A.ACCUMULATED_CHILD_QTY) ACCUM_CHILD_QTY
                    FROM    SCM_MODEL_COMP_EFFECTIVE_DATE A WITH(NOLOCK) --SCM_MODEL_COMP_EFFECTIVE_DATE
                    INNER JOIN @DIVISION DIV
                        ON  A.DIVISION_ID = DIV.DIVISION_ID
                    INNER JOIN SCM_ITEM_M IC WITH (NOLOCK)
                        ON  A.COMPANY_ID     = IC.COMPANY_ID
                        AND A.DIVISION_ID    = IC.DIVISION_ID
                        AND A.SITE_ID        = IC.SITE_ID
                        AND A.CHILD_ITEM_ID  = IC.ITEM_ID
                        AND IC.ACTIVE_FLAG    = 'Y'
                    LEFT OUTER JOIN SCM_MST_ALTER_BOM_V_SN ABM WITH(NOLOCK)  --SCM_MST_ALTER_BOM_V
                        ON  A.DIVISION_ID    = ABM.DIVISION_ID
                        AND A.SITE_ID        = ABM.SITE_ID
                        AND A.PLANT_ID       = ABM.PLANT_ID
                        AND A.PARENT_ITEM_ID = ABM.PARENT_ITEM_ID
                        AND A.CHILD_ITEM_ID  = ABM.CHILD_ITEM_ID
                    WHERE   1=1
                    -- AND     A.DIVISION_ID = '81_UC'
                    AND     ISNULL(A.PARENT_ITEM_ID, '*') != '*'
                    AND     A.EFF_END_DATE > CONVERT(DATE, @V_PLAN_START_YYYYMMDD, 112)
                    AND     IC.FLOW_ID LIKE 'A5000%'  -- NND
                    AND   (A.ALT_ID IS NULL 
                            OR (A.ALT_ID IS NOT NULL AND ABM.SCP_PLAN_YN IS NULL AND ISNULL(A.ALT_PRIORITY, 'N') = 'Y')
                            OR (A.ALT_ID IS NOT NULL AND ABM.SCP_PLAN_YN IS NOT NULL AND ABM.SCP_PLAN_YN = 'Y'))
                    GROUP BY A.MODEL_ID, A.CHILD_ITEM_ID
                    ) MM
            GROUP BY CHILD_ITEM_ID
            ;

		
            UPDATE	RS
            SET 	RS.QTY = RS.QTY / BOM.MAX_USAGE
            FROM 	@RESULT_TEMP RS
            INNER JOIN #BOM_NND BOM
                ON  RS.ITEM_ID = BOM.CHILD_ITEM_ID
            WHERE 	1=1
            --AND 	RS.STAGE = 'NND'
            -- AND     @V_RESULT_TYPE != 'BUF'
            AND     RS.STAGE IN ( 'NND', 'INSP_NND' )
            AND 	((@V_RESULT_TYPE != 'BUF' AND RS.TYPE IN ('PRODUCTION_RESULT', 'PRODUCTION_PLAN', 'SHIPMENT_PLAN', 'SHIPMENT_RESULT', 'INVENTORY','DAILY_CAPA'))
                OR (@V_RESULT_TYPE = 'BUF' AND RS.TYPE IN ('PRODUCTION_RESULT', 'SHIPMENT_RESULT', 'INVENTORY','DAILY_CAPA'))
            )
            ;

        -------------------------------------------------------------------------------------
		-- E2000 ELECTRODE_TYPE 표기
		-------------------------------------------------------------------------------------
		WITH LINE AS (	SELECT LINE_ID, ELECTRODE_TYPE
						FROM   SCM_LINE_M A WITH(NOLOCK)
						       INNER JOIN @DIVISION D 
							       ON A.DIVISION_ID = D.DIVISION_ID
						WHERE  OPERATION_ID = 'E2000'
						)
		UPDATE H
		SET    H.ELECTRODE_TYPE = ISNULL(L.ELECTRODE_TYPE, IIF(H.ITEM_ID LIKE 'ANPA%', 'Anode', 'Cathode'))
		FROM   @RESULT_TEMP    H
        LEFT OUTER JOIN LINE   L
            ON H.LINE_ID = L.LINE_ID
		WHERE  H.OPERATION_ID IN ('E2000', 'A5000')
		;

        -------------------------------------------------------------------------------------
		-- A5000 인 경우 하위 전극 ITEM을 SALES SITE에 표기, LINE명에서 @이후 제거, ELECTRODE_TYPE 표기
		-------------------------------------------------------------------------------------
		WITH BOM_T AS (	SELECT ATTRIBUTE2  AS PARENT_ITEM_ID
		                     , ATTRIBUTE14 AS CHILD_ITEM_ID
						FROM   SCP_OPT_ENG_BOM_SN WITH(NOLOCK)
						WHERE  PLAN_ID     = @V_PLAN_ID )
		UPDATE  H
		SET      
                H.LINE_ID          = CASE WHEN CHARINDEX('@',H.LINE_ID) > 0 THEN LEFT(H.LINE_ID, CHARINDEX('@',H.LINE_ID)-1) ELSE H.LINE_ID END
                -- ,H.ELECTRODE_TYPE   = CASE WHEN CHARINDEX('@',H.LINE_ID) > 0 THEN CASE WHEN SUBSTRING(H.LINE_ID , CHARINDEX('@',H.LINE_ID)+1,1) = 'C' THEN 'Cathode' 
                --                                                                     WHEN SUBSTRING(H.LINE_ID , CHARINDEX('@',H.LINE_ID)+1,1) = 'A' THEN 'Anode' ELSE '-' END
                --                                                             ELSE H.ELECTRODE_TYPE END
		FROM   @RESULT_TEMP    H
        INNER JOIN BOM_T  T
            ON H.ITEM_ID = T.PARENT_ITEM_ID
		WHERE  H.OPERATION_ID = 'A5000'
		;

	END
	
	-------------------------------------------------------------------------------------
	-- NND인 경우 SHIPMENT 관련 정보는 조회하지 않는다
	-------------------------------------------------------------------------------------
	DELETE FROM @RESULT_TEMP WHERE TYPE LIKE '%SHIPMENT%' AND STAGE LIKE '%NND%'	

/* 키 정보 관련 
1. Raw_A, Raw_E 시트 : Keys 열 수식 -> 쿼리에서 컬럼 추가
Raw_A 시트 : KEYS 컬럼의 구성(맨왼쪽에 추가)  : OPERATION_ID  & ITEM_ID & LINE_ID & IF(OR(TYPE = "SHIPMENT_RESULT",TYPE = "SHIPMENT_PLAN"),DEPARTURE_DATE,PRODUCTION_DATE) & TYPE
Raw_E 시트 : KEYS 컬럼의 구성(맨왼쪽에 추가)  : OPERATION_ID  & ITEM_ID & LINE_ID &  IF(TYPE = "INVENTORY", "", ELECTRODE_TYPE) & IF(OR(TYPE = "SHIPMENT_RESULT",TYPE = "SHIPMENT_PLAN"),DEPARTURE_DATE,PRODUCTION_DATE) & TYPE
참고 :  Raw_A 시트 와 Raw_E 시트 차이점 : IF(TYPE = "INVENTORY", "", ELECTRODE_TYPE) & <---이 부분만다름
*/

	-------------------------------------------------------------------------------------
	-- 2025.09.19/THKIM/정수화 진행
	-------------------------------------------------------------------------------------
    IF @V_RESULT_TYPE IN ('ALL')
    BEGIN
        UPDATE  @RESULT_TEMP
        SET     QTY = ROUND(QTY,0)
        --WHERE   TYPE IN('PRODUCTION_PLAN', 'SHIPMENT_PLAN', 'INVENTORY','DAILY_CAPA') -- blocked
        WHERE   TYPE IN('PRODUCTION_PLAN', 'SHIPMENT_PLAN', 'INVENTORY') -- added
    END
    ELSE IF @V_RESULT_TYPE IN ('BUF')
    BEGIN
        UPDATE  @RESULT_TEMP
        SET     QTY = ROUND(QTY,0)
        --WHERE   TYPE IN('INVENTORY','DAILY_CAPA') -- blocked
        WHERE   TYPE IN('INVENTORY') -- added
    END
	-------------------------------------------------------------------------------------
	-- Final Select
	-------------------------------------------------------------------------------------
    IF @V_RESULT_TYPE IN ('ALL', 'BUF')
        BEGIN 
            SELECT   CASE WHEN @V_PLAN_GROUP_ID = 'GM1_A' THEN CONCAT(OPERATION_ID, ITEM_ID, LINE_ID, IIF(TYPE LIKE 'SHIPMENT%', DEPARTURE_DATE, PRODUCTION_DATE), TYPE) 
                        WHEN @V_PLAN_GROUP_ID = 'GM1_E' THEN CONCAT(OPERATION_ID, ITEM_ID, LINE_ID, IIF(TYPE = 'INVENTORY', '', ELECTRODE_TYPE),IIF(TYPE LIKE 'SHIPMENT%', DEPARTURE_DATE, PRODUCTION_DATE), TYPE) 
                        END AS KEYS
                    ,TYPE			
                    ,SCM_SITE_ID	
                    ,ITEM_ID		
                    ,STAGE			
                    ,PRODUCTION_DATE
                    ,LINE_ID		
                    ,QTY			
                    ,OPERATION_ID	
                    ,FROM_SITE		
                    ,TO_SITE		
                    ,BOD_ID			
                    ,TRANSPORT_MODE	
                    ,INCOTERMS		
                    ,DEPARTURE_DATE	
                    ,ARRIVAL_DATE
                    ,ELECTRODE_TYPE
                    ,CASE
                         WHEN LINE_SIDE = 'E' THEN 'EAST'
						 WHEN LINE_SIDE = 'W' THEN 'WEST'
						 ELSE LINE_SIDE
                     END AS LINE_SIDE -- ADDED 2025.10.29 jongykim2: LINE_SIDE
                    ,WORKING_DAY -- added 2025.11.05
            FROM   @RESULT_TEMP
        END
    ELSE IF @V_RESULT_TYPE IN ('ITEM')
        BEGIN
            SELECT  DISTINCT TYPE, ITEM_ID
            FROM    @RESULT_TEMP RS
            WHERE   RS.TYPE IN ('PRODUCTION_RESULT', 'PRODUCTION_PLAN', 'SHIPMENT_PLAN', 'SHIPMENT_RESULT', 'INVENTORY')
        END
    ;

	--SELECT   CASE WHEN @V_PLAN_GROUP_ID = 'GM1_A' THEN CONCAT(OPERATION_ID, ITEM_ID, LINE_ID, IIF(TYPE LIKE 'SHIPMENT%', DEPARTURE_DATE, PRODUCTION_DATE), TYPE) 
 --                 WHEN @V_PLAN_GROUP_ID = 'GM1_E' THEN CONCAT(OPERATION_ID, ITEM_ID, LINE_ID, IIF(TYPE = 'INVENTORY', '', ELECTRODE_TYPE),IIF(TYPE LIKE 'SHIPMENT%', DEPARTURE_DATE, PRODUCTION_DATE), TYPE) 
 --                  END AS KEYS
 --           ,TYPE			
	--		,SCM_SITE_ID	
	--		,ITEM_ID		
	--		,STAGE			
	--		,PRODUCTION_DATE
	--		,LINE_ID		
	--		,QTY			
	--		,OPERATION_ID	
	--		,FROM_SITE		
	--		,TO_SITE		
	--		,BOD_ID			
	--		,TRANSPORT_MODE	
	--		,INCOTERMS		
	--        ,DEPARTURE_DATE	
	--	    ,ARRIVAL_DATE
 --           ,ELECTRODE_TYPE
	--FROM   @RESULT_TEMP
 --   WHERE  TYPE NOT IN('PRODUCTION_PLAN','SHIPMENT_PLAN')
 --   UNION ALL
 --   -- PRODUCTION PLAN 날짜 펼쳐서 계획 값 없는 날은 0으로 입력
	--SELECT   CASE WHEN @V_PLAN_GROUP_ID = 'GM1_A' THEN CONCAT(PP.OPERATION_ID, PP.ITEM_ID, PP.LINE_ID, IIF(PP.TYPE LIKE 'SHIPMENT%', RT.DEPARTURE_DATE, PP.BASIS_YYYYMMDD), PP.TYPE) 
 --                 WHEN @V_PLAN_GROUP_ID = 'GM1_E' THEN CONCAT(PP.OPERATION_ID, PP.ITEM_ID, PP.LINE_ID, IIF(PP.TYPE = 'INVENTORY', '',PP. ELECTRODE_TYPE),IIF(PP.TYPE LIKE 'SHIPMENT%', RT.DEPARTURE_DATE, RT.PRODUCTION_DATE), PP.TYPE) 
 --                  END AS KEYS
 --           ,PP.TYPE			
	--		,PP.SCM_SITE_ID	
	--		,PP.ITEM_ID		
	--		,PP.STAGE			
	--		,PP.BASIS_YYYYMMDD
	--		,PP.LINE_ID		
	--		,IIF(PP.BASIS_YYYYMMDD = RT.PRODUCTION_DATE, RT.QTY,PP.QTY) AS QTY			
	--		,PP.OPERATION_ID	
	--		,'' AS FROM_SITE		
	--		,'' AS TO_SITE		
	--		,'' AS BOD_ID			
	--		,'' AS TRANSPORT_MODE	
	--		,'' AS INCOTERMS		
	--        ,'' AS DEPARTURE_DATE	
	--	    ,'' AS ARRIVAL_DATE
 --           ,PP.ELECTRODE_TYPE
 --   FROM(
 --       SELECT TYPE
 --             ,SCM_SITE_ID
 --             ,ITEM_ID
 --             ,STAGE
 --             ,LINE_ID
 --             ,QTY
 --             ,OPERATION_ID
 --             ,ELECTRODE_TYPE
 --             ,BASIS_YYYYMMDD
 --       FROM(
 --           SELECT  DISTINCT 'PRODUCTION_PLAN' AS TYPE
 --                  ,SCM_SITE_ID
 --                  ,ITEM_ID
 --                  ,STAGE
 --                  ,LINE_ID
 --                  ,0 AS QTY
 --                  ,OPERATION_ID
 --                  ,'-' AS ELECTRODE_TYPE
 --   	    FROM    @RESULT_TEMP
 --           WHERE   TYPE = 'DAILY_CAPA'
 --           ) PP
 --           CROSS APPLY(
 --                   SELECT BASIS_YYYYMMDD
 --                   FROM SCM_SYS_CALENDAR_M_SN CAL WITH(NOLOCK)
 --                   WHERE CAL.BASIS_YYYYMMDD >= @V_PLAN_START_YYYYMMDD
 --                   AND CAL.BASIS_YYYYMMDD <  @V_PLAN_END_YYYYMMDD
 --                   ) CAL
 --           ) PP
 --   LEFT OUTER JOIN @RESULT_TEMP RT
 --       ON  PP.TYPE           = RT.TYPE
 --       AND PP.SCM_SITE_ID    = RT.SCM_SITE_ID
 --       AND PP.ITEM_ID        = RT.ITEM_ID       
 --       AND PP.STAGE          = RT.STAGE         
 --       AND PP.LINE_ID        = RT.LINE_ID       
 --       AND PP.OPERATION_ID   = RT.OPERATION_ID  
 --       AND PP.ELECTRODE_TYPE = RT.ELECTRODE_TYPE
 --       AND PP.BASIS_YYYYMMDD = RT.PRODUCTION_DATE
 --   UNION ALL
 --   -- SHIPMENT PLAN 날짜 펼쳐서 계획 값 없는 날은 0으로 입력
	--SELECT   CASE WHEN @V_PLAN_GROUP_ID = 'GM1_A' THEN CONCAT(RT.OPERATION_ID, SP.ITEM_ID, RT.LINE_ID, IIF(SP.TYPE LIKE 'SHIPMENT%', SP.BASIS_YYYYMMDD, RT.PRODUCTION_DATE), SP.TYPE) 
 --                 WHEN @V_PLAN_GROUP_ID = 'GM1_E' THEN CONCAT(RT.OPERATION_ID, SP.ITEM_ID, RT.LINE_ID, IIF(SP.TYPE = 'INVENTORY', '',SP. ELECTRODE_TYPE),IIF(SP.TYPE LIKE 'SHIPMENT%', SP.BASIS_YYYYMMDD, RT.PRODUCTION_DATE), SP.TYPE) 
 --                  END AS KEYS
 --           ,SP.TYPE			
	--		,SP.SCM_SITE_ID	
	--		,SP.ITEM_ID		
	--		,SP.STAGE			
	--		,'' AS PRODUCTION_DATE
	--		,'' AS LINE_ID		
	--		,IIF(SP.BASIS_YYYYMMDD = RT.DEPARTURE_DATE, RT.QTY,SP.QTY) AS QTY			
	--		,'' AS OPERATION_ID	
	--		,SP.FROM_SITE		
	--		,SP.TO_SITE		
	--		,SP.BOD_ID			
	--		,SP.TRANSPORT_MODE	
	--		,SP.INCOTERMS		
	--        ,SP.BASIS_YYYYMMDD AS DEPARTURE_DATE
	--	    ,SP.BASIS_YYYYMMDD AS ARRIVAL_DATE
 --           ,SP.ELECTRODE_TYPE
 --   FROM(
 --       SELECT TYPE
 --             ,SCM_SITE_ID
 --             ,ITEM_ID
 --             ,STAGE
 --             ,QTY
 --             ,FROM_SITE
 --             ,TO_SITE
 --             ,BOD_ID
 --             ,TRANSPORT_MODE
 --             ,INCOTERMS
 --             ,ELECTRODE_TYPE
 --             ,BASIS_YYYYMMDD
 --       FROM(
 --           SELECT  DISTINCT TYPE
 --                  ,SCM_SITE_ID
 --                  ,ITEM_ID
 --                  ,STAGE
 --                  ,0 AS QTY
 --                  ,FROM_SITE
 --                  ,TO_SITE
 --                  ,BOD_ID
 --                  ,TRANSPORT_MODE
 --                  ,INCOTERMS
 --                  ,ELECTRODE_TYPE
 --   	    FROM    @RESULT_TEMP
 --           WHERE   TYPE = 'SHIPMENT_PLAN'
 --           ) PP
 --           CROSS APPLY(
 --                   SELECT BASIS_YYYYMMDD
 --                   FROM SCM_SYS_CALENDAR_M_SN CAL WITH(NOLOCK)
 --                   WHERE CAL.BASIS_YYYYMMDD >= @V_PLAN_START_YYYYMMDD
 --                   AND CAL.BASIS_YYYYMMDD <  @V_PLAN_END_YYYYMMDD
 --                   ) CAL
 --       ) SP
 --   LEFT OUTER JOIN @RESULT_TEMP RT
 --       ON  SP.TYPE           = RT.TYPE
 --       AND SP.SCM_SITE_ID    = RT.SCM_SITE_ID
 --       AND SP.ITEM_ID        = RT.ITEM_ID       
 --       AND SP.STAGE          = RT.STAGE         
 --       AND SP.FROM_SITE      = RT.FROM_SITE     
 --       AND SP.TO_SITE        = RT.TO_SITE       
 --       AND SP.BOD_ID         = RT.BOD_ID        
 --       AND SP.TRANSPORT_MODE = RT.TRANSPORT_MODE
 --       AND SP.INCOTERMS      = RT.INCOTERMS     
 --       AND SP.ELECTRODE_TYPE = RT.ELECTRODE_TYPE
 --       AND SP.BASIS_YYYYMMDD = RT.DEPARTURE_DATE

	-------------------------------------------------------------------------------------
	END
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	ELSE IF @V_RESULT_TYPE = 'HEADER'   
	-------------------------------------------------------------------------------------
	BEGIN
	-------------------------------------------------------------------------------------

        -- START 2025-11-21 jongykim2: GM 조립 HEADER 틀고정 분리
        IF OBJECT_ID('TEMPDB..#STAGE_OPERATION') IS NOT NULL
        BEGIN 
            DROP TABLE  #STAGE_OPERATION;
        END;

        -- SET STAGE-OPERATION, HEADER KEY에 해당하는 OPERATION_ID 매핑
        WITH UT AS (
            SELECT LU.SEGMENT1 AS DIVISION_ID
                 , LU.SEGMENT2 AS PLAN_GROUP_ID
                 --, IIF(LU.SEGMENT5='F6000', 'EOL', 'STK') AS HEADER_KEY
                 , CAST(IIF(LU.SEGMENT5='F6000', 'EOL', 'STK') AS NVARCHAR(50)) AS HEADER_KEY
                 , LU.SEGMENT3 AS STAGE
                 , LU.SEGMENT5 AS OPERATION_ID
            FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN  LU WITH(NOLOCK)
                LEFT OUTER JOIN (
                                SELECT  LU.SEGMENT2 AS DIVISION_ID
                                      , LU.SEGMENT3 AS PLAN_GROUP_ID
                                      , LU.ATTRIBUTE3 AS STAGE
                                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LU WITH(NOLOCK)
                                WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                AND     LU.VALID_YN    = 'Y'
                                GROUP BY LU.SEGMENT2, LU.SEGMENT3, LU.ATTRIBUTE3
                               ) OCV
            ON     LU.SEGMENT1 = OCV.DIVISION_ID
            AND    LU.SEGMENT2 = OCV.PLAN_GROUP_ID
            AND    LU.SEGMENT3 = OCV.STAGE
            WHERE  1 = 1
            AND    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_STAGE_OPERATION_MAP'
            AND    LU.VALID_YN = 'Y'
            AND    LU.SEGMENT1 = @V_DIVISION_ID
            AND    LU.SEGMENT2 = @V_PLAN_GROUP_ID
            AND    OCV.STAGE IS NULL -- 2nd OCV STAGE
            AND    NOT LU.SEGMENT3 = 'DEGAS'
        )
        SELECT *
        INTO   #STAGE_OPERATION
        FROM   UT T
        ;
        --SELECT * FROM #STAGE_OPERATION T WITH(NOLOCK)

        INSERT INTO #STAGE_OPERATION
        SELECT T.DIVISION_ID
             , T.PLAN_GROUP_ID
             , CAST(N'ASSY' AS NVARCHAR(50)) AS HEADER_KEY
             , T.STAGE
             , T.OPERATION_ID
        FROM   #STAGE_OPERATION T
        WHERE  HEADER_KEY   = 'STK'
        AND    STAGE        = 'ASSY'
        AND    OPERATION_ID = 'A9000'

        IF OBJECT_ID('TEMPDB..#ENG_BOM_T') IS NOT NULL
        BEGIN 
            DROP TABLE  #ENG_BOM_T;
        END;

        --SELECT * FROM #STAGE_OPERATION T WITH(NOLOCK)

        -- 순수 모-자품목 기준 BOM 전개용 전처리
        SELECT DISTINCT
               C.PLAN_ID
             , C.ATTRIBUTE1  AS SCM_SITE_ID
             , C.ATTRIBUTE2  AS PARENT_ITEM_ID
             , C.ATTRIBUTE14 AS CHILD_ITEM_ID
             , C.ATTRIBUTE14 AS ITEM_ID
             , C.ATTRIBUTE15 AS STAGE
        INTO   #ENG_BOM_T
        FROM   SCP_OPT_ENG_BOM_SN C WITH(NOLOCK)
        INNER JOIN #STAGE_OPERATION P WITH(NOLOCK)
        ON     P.STAGE = C.ATTRIBUTE15
        WHERE  1 = 1
        AND    C.PLAN_ID = @V_PLAN_ID
        AND    C.MATERIAL_CLASS_ID IN ('ASSY', 'CHAR', 'STK')
        ;

        IF OBJECT_ID('TEMPDB..#ENG_BOM_ALL_T') IS NOT NULL
        BEGIN 
            DROP TABLE  #ENG_BOM_ALL_T;
        END;

        -- BOM EXPLOSION
        WITH BOM_Explode AS (
            SELECT DISTINCT
                   P.PLAN_ID
                 , P.ATTRIBUTE1 AS SCM_SITE_ID
                 , P.ATTRIBUTE2 AS PARENT_ITEM_ID
                 , P.ATTRIBUTE14 AS CHILD_ITEM_ID
                 , 1 AS LEVEL
                 , CAST(P.ATTRIBUTE2 + '>' + P.ATTRIBUTE14 AS NVARCHAR(MAX)) AS PATH
                 , CAST(N'ASSY' AS NVARCHAR(50))  AS STAGE
            FROM   SCP_OPT_ENG_BOM_SN P WITH(NOLOCK)
            WHERE  P.PLAN_ID    = @V_PLAN_ID
            AND    P.ATTRIBUTE3 = 'CHAR'
            UNION ALL
            SELECT C.PLAN_ID
                 , C.SCM_SITE_ID
                 , C.PARENT_ITEM_ID
                 , C.CHILD_ITEM_ID
                 , E.LEVEL + 1   AS LEVEL
                 , CAST(E.PATH + '>' + C.CHILD_ITEM_ID AS NVARCHAR(MAX)) AS PATH
                 , CAST(C.STAGE AS NVARCHAR(50)) AS STAGE
            FROM   #ENG_BOM_T C WITH(NOLOCK)
            INNER JOIN BOM_Explode E
            ON     C.PLAN_ID        = E.PLAN_ID
            AND    C.PARENT_ITEM_ID = E.CHILD_ITEM_ID
            AND    E.PATH NOT LIKE '%' + C.CHILD_ITEM_ID + '%'
        )
        SELECT T.PLAN_ID
             , T.SCM_SITE_ID
             , dbo.SCM_ARR_SPL_VAL(T.PATH, '>', 1) AS MODEL_ID
             , T.PARENT_ITEM_ID
             , T.CHILD_ITEM_ID
             , T.STAGE
             , T.LEVEL
        INTO   #ENG_BOM_ALL_T
        FROM BOM_Explode T
        OPTION (MAXRECURSION 0);
        --SELECT * FROM #ENG_BOM_ALL_T T WITH(NOLOCK) ORDER BY T.PLAN_ID, T.MODEL_ID, T.LEVEL

        -- HEADER TEMPLATE: Lookup -> Load header Template
        IF OBJECT_ID('TEMPDB..#HEADER_TEMPLATE') IS NOT NULL
        BEGIN 
            DROP TABLE  #HEADER_TEMPLATE;
        END;
        
        SELECT T.SEGMENT2 AS HEADER_KEY
             , T.SEGMENT3 AS OPERATION
             , T.ATTRIBUTE1 AS ELECTRODE_TYPE
             , T.ATTRIBUTE2 AS ATTR2
             , T.ATTRIBUTE3 AS LINE_GROUP
             , T.ATTRIBUTE4 AS LINE
             , T.ATTRIBUTE5 AS ELECTRODE_TYPE_CD
             , RIGHT('000' + CAST(T.DISPLAY_SEQ AS VARCHAR(3)), 3) AS SORT_ORD
        INTO   #HEADER_TEMPLATE
        FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN T WITH(NOLOCK) -- PK: LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, SEGMENT6, SEGMENT7, SEGMENT8, SEGMENT9, SEGMENT10
        WHERE  1 = 1
        AND    T.LOOKUP_TYPE = 'SCP_OPT_GM_EXCL_HEADER_TEMPLATE'
        AND    T.VALID_YN    = 'Y'
        --AND    T.SEGMENT2    NOT IN ('EOL', 'ASSY') -- 가변 STAGE 제외
        ;

        IF OBJECT_ID('TEMPDB..#RESULT_HEADER') IS NOT NULL
        BEGIN 
            DROP TABLE  #RESULT_HEADER;
        END;

        -- STK A9000, A8000 틀고정
        WITH T AS (
            SELECT T.SCM_SITE_ID
                 , T.MODEL_ID
                 , T.CHILD_ITEM_ID
                 , T.STAGE
            FROM   #ENG_BOM_ALL_T T WITH(NOLOCK)
            WHERE  1 = 1
        ), HEADER_TEMPLATE AS (
            SELECT *
            FROM   #HEADER_TEMPLATE HT
            WHERE  1 = 1
            AND    HT.HEADER_KEY  = 'STK'
            AND    HT.OPERATION   IN ('A8000', 'A9000')
        )
        SELECT P.HEADER_KEY
             , T.MODEL_ID AS MODEL
             , P.OPERATION_ID AS OPERATION
             , T.CHILD_ITEM_ID AS ITEM_ID
             , SIM.NICK_NAME
             , T.SCM_SITE_ID AS PLANT_SITE
             , CAST('' AS NVARCHAR(50)) AS SALES_SITE
             , CAST(N'Mass' AS NVARCHAR(50)) AS FCST_TYPE
             , CAST('' AS NVARCHAR(50)) AS ELECTRODE_TYPE
             , H.ATTR2
             , H.LINE_GROUP
             , H.LINE
             , H.ELECTRODE_TYPE_CD
             , H.SORT_ORD
        INTO   #RESULT_HEADER
        FROM   T
        INNER JOIN #STAGE_OPERATION P WITH(NOLOCK)
        ON     P.STAGE = T.STAGE
        INNER JOIN HEADER_TEMPLATE H
        ON     H.HEADER_KEY = P.HEADER_KEY
        AND    H.OPERATION  = P.OPERATION_ID
        LEFT OUTER JOIN (SELECT	STM.ITEM_ID, STM.APPLIED_MODEL, STM.NICK_NAME 
                         FROM   SCM_ITEM_M STM WITH(NOLOCK)
                         INNER JOIN @DIVISION DIV
                         ON     STM.DIVISION_ID = DIV.DIVISION_ID 
                        ) SIM
        ON     T.MODEL_ID = SIM.ITEM_ID 
        ORDER BY T.MODEL_ID, H.SORT_ORD
        ;
        --SELECT * FROM #RESULT_HEADER T WITH(NOLOCK);

        -- STK A5000 Cathode/Anode 틀고정 품목수에 따른 레코드 가변
        WITH HEADER_TEMPLATE AS (
            SELECT *
            FROM   #HEADER_TEMPLATE HT
            WHERE  1 = 1
            AND    HT.HEADER_KEY = 'STK'
            AND    HT.OPERATION  = 'A5000'
        ), NND AS (
            SELECT DISTINCT 
                   SBS.MATERIAL_CLASS_ID   AS HEADER_KEY
                  ,'A5000'          AS OPERATION
                  ,SIM.APPLIED_MODEL      AS MODEL
                  ,MSTBOM.CHILD_ITEM_ID   AS ITEM_ID
                  ,SIM.NICK_NAME        AS NICK_NAME
                  ,SBS.ATTRIBUTE1       AS PLANT_SITE
                  ,''             AS SALES_SITE
                  ,'Mass'           AS FCST_Type
                  ,''             AS Attr1
                  ,''             AS Attr2
                  ,''             AS LINE_GROUP
                  ,'ALL'            AS LINE 
                  ,SUBSTRING(MSTBOM.CHILD_ITEM_ID,4,1)  AS ELECTRODE_TYPE_CD
            FROM   SCP_OPT_ENG_BOM_SN SBS WITH(NOLOCK)
                LEFT OUTER JOIN @OPERATION_TEMP LV
                  ON  @V_DIVISION_ID     = LV.DIVISION_ID -- DIVISION
                  AND @V_PLAN_GROUP_ID   = LV.PLAN_GROUP -- PLAN GR
                  AND SBS.ATTRIBUTE3     = LV.STAGE 
                LEFT OUTER JOIN ( SELECT  STM.ITEM_ID, STM.APPLIED_MODEL, STM.NICK_NAME 
                          FROM  SCM_ITEM_M STM WITH(NOLOCK)
                              INNER JOIN @DIVISION DIV
                              ON  STM.DIVISION_ID = DIV.DIVISION_ID 
                        ) SIM
                  ON  SBS.ATTRIBUTE2 = SIM.ITEM_ID
                LEFT OUTER JOIN (   SELECT  SBM1.PARENT_ITEM_ID, SBM2.CHILD_ITEM_ID
                          FROM  SCM_BOM_M SBM1 WITH(NOLOCK)
                              INNER JOIN @DIVISION DIV
                                ON  SBM1.DIVISION_ID = DIV.DIVISION_ID
                              INNER JOIN SCM_BOM_M SBM2  WITH(NOLOCK)
                                ON  SBM1.DIVISION_ID = SBM2.DIVISION_ID
                                AND SBM1.CHILD_ITEM_ID = SBM2.PARENT_ITEM_ID
                                AND SBM2.EFF_END_DATE >= GETDATE()
                              INNER JOIN SCM_ITEM_M SIM2 WITH(NOLOCK)
                                ON  SBM2.DIVISION_ID    = SIM2.DIVISION_ID
                                AND SBM2.CHILD_ITEM_ID  = SIM2.ITEM_ID
                                AND SIM2.ITEM_TYPE <> 'R'
                          WHERE   SBM1.EFF_END_DATE >= GETDATE()
                        ) MSTBOM
                  ON MSTBOM.PARENT_ITEM_ID = SBS.ATTRIBUTE14
            WHERE  SBS.PLAN_ID   = @V_PLAN_ID
            AND    SBS.MATERIAL_CLASS_ID = 'STK'

        )
        INSERT INTO #RESULT_HEADER
        SELECT A.HEADER_KEY
             , A.MODEL
             , A.OPERATION
             , A.ITEM_ID
             , A.NICK_NAME
             , A.PLANT_SITE
             , A.SALES_SITE
             , A.FCST_Type
             , C.ELECTRODE_TYPE
             , C.ATTR2
             , C.LINE_GROUP
             , C.LINE
             , C.ELECTRODE_TYPE_CD
             , C.SORT_ORD
        FROM   NND A
        INNER JOIN HEADER_TEMPLATE C
        ON     C.HEADER_KEY = A.HEADER_KEY
        AND    C.OPERATION = A.OPERATION
        AND    C.ELECTRODE_TYPE_CD = A.ELECTRODE_TYPE_CD
        ;

        -- ASSY, EOL 품목수에 따른 레코드 가변
        WITH HEADER_TEMPLATE AS (
            SELECT *
            FROM   #HEADER_TEMPLATE HT
            WHERE  1 = 1
            AND    HT.HEADER_KEY IN ('EOL', 'ASSY')
        ), EOL_ASSY AS (
		    SELECT	 DISTINCT 
				     SRS.ATTRIBUTE3				AS HEADER_KEY
				    ,SIM.APPLIED_MODEL			AS MODEL
				    ,LV.OPERATION_ID			AS OPERATION
				    ,SRS.ATTRIBUTE2				AS ITEM_ID
				    ,SIM.NICK_NAME				AS NICK_NAME
				    ,SRS.ATTRIBUTE1				AS PLANT_SITE
                    ,''							AS SALES_SITE
				    ,'Mass'						AS FCST_Type
		    FROM	SCP_OPT_ENG_ROUTING_RESOURCE_SN SRS WITH(NOLOCK)
				    LEFT OUTER JOIN @OPERATION_TEMP LV
					    ON  @V_DIVISION_ID   = LV.DIVISION_ID -- DIVISION
					    AND @V_PLAN_GROUP_ID = LV.PLAN_GROUP -- PLAN GR
					    AND SRS.ATTRIBUTE3	     = LV.STAGE 
				    LEFT OUTER JOIN (	SELECT	STM.ITEM_ID, STM.APPLIED_MODEL, STM.NICK_NAME 
									    FROM	SCM_ITEM_M STM WITH(NOLOCK)
											    INNER JOIN @DIVISION DIV
											    ON	STM.DIVISION_ID = DIV.DIVISION_ID 
								    ) SIM
					    ON  SRS.ATTRIBUTE2 = SIM.ITEM_ID 
				    LEFT OUTER JOIN (	SELECT DISTINCT PLAN_ID, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE15, RESOURCE_ID
									    FROM   SCP_OPT_ENG_ROUTING_RESOURCE_SN SRS2 WITH(NOLOCK)
									    WHERE  SRS2.PLAN_ID   = @V_PLAN_ID
									    AND    SRS2.RESOURCE_CLASS_ID = 'LINE'
									    AND    SRS2.ATTRIBUTE3 NOT IN ( 'IDLE_EQ' ) ) SRS2
					    ON  SRS.PLAN_ID		= SRS2.PLAN_ID
					    AND SRS.ATTRIBUTE3	= SRS2.ATTRIBUTE3
                        --START 2025-11-21, jongykim2
                        AND @V_DIVISION_ID  = '81_UC' 
                        --END 2025-11-21, jongykim2
                        /* blocked 2025-11-21 jongykim2
                        AND (@V_DIVISION_ID != 'EE_UC' 
                            OR (@V_DIVISION_ID = 'EE_UC' 
                            AND RIGHT(SRS.ATTRIBUTE15, 1) = RIGHT(SRS2.ATTRIBUTE15, 1))
                            ) */
		    WHERE  SRS.PLAN_ID   = @V_PLAN_ID
		    AND    SRS.RESOURCE_CLASS_ID = 'LINE'
		    AND    SRS.ATTRIBUTE3 NOT IN ( 'IDLE_EQ' )
            AND    SRS.ATTRIBUTE3 IN ('ASSY', 'EOL')
        )
        INSERT INTO #RESULT_HEADER
        SELECT A.HEADER_KEY
             , A.MODEL
             , A.OPERATION
             , A.ITEM_ID
             , A.NICK_NAME
             , A.PLANT_SITE
             , A.SALES_SITE
             , A.FCST_Type
             , C.ELECTRODE_TYPE
             , C.ATTR2
             , C.LINE_GROUP
             , C.LINE
             , C.ELECTRODE_TYPE_CD
             , C.SORT_ORD
        FROM   EOL_ASSY A
        INNER JOIN HEADER_TEMPLATE C
        ON     C.HEADER_KEY = A.HEADER_KEY
        AND    C.OPERATION = A.OPERATION
        ;

        -- COATING, NND 품목수에 따른 레코드 가변
        WITH HEADER_TEMPLATE AS (
            SELECT *
            FROM   #HEADER_TEMPLATE HT
            WHERE  1 = 1
            AND    HT.HEADER_KEY IN ('COATING', 'NND')
        ), EOL_ASSY AS (
		    SELECT	 DISTINCT 
				     SRS.ATTRIBUTE3				AS HEADER_KEY
				    ,SIM.APPLIED_MODEL			AS MODEL
				    ,LV.OPERATION_ID			AS OPERATION
				    ,SRS.ATTRIBUTE2				AS ITEM_ID
				    ,SIM.NICK_NAME				AS NICK_NAME
				    ,SRS.ATTRIBUTE1				AS PLANT_SITE
                    ,''							AS SALES_SITE
				    ,'Mass'						AS FCST_Type
                    ,CASE WHEN SRS.ATTRIBUTE3 = 'COATING' THEN SUBSTRING(SRS.ATTRIBUTE2,4,1) ELSE '' END  AS ELECTRODE_TYPE_CD
		    FROM	SCP_OPT_ENG_ROUTING_RESOURCE_SN SRS WITH(NOLOCK)
				    LEFT OUTER JOIN @OPERATION_TEMP LV
					    ON  @V_DIVISION_ID   = LV.DIVISION_ID -- DIVISION
					    AND @V_PLAN_GROUP_ID = LV.PLAN_GROUP -- PLAN GR
					    AND SRS.ATTRIBUTE3	     = LV.STAGE 
				    LEFT OUTER JOIN (	SELECT	STM.ITEM_ID, STM.APPLIED_MODEL, STM.NICK_NAME 
									    FROM	SCM_ITEM_M STM WITH(NOLOCK)
											    INNER JOIN @DIVISION DIV
											    ON	STM.DIVISION_ID = DIV.DIVISION_ID 
								    ) SIM
					    ON  SRS.ATTRIBUTE2 = SIM.ITEM_ID 
				    LEFT OUTER JOIN (	SELECT DISTINCT PLAN_ID, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE15, RESOURCE_ID
									    FROM   SCP_OPT_ENG_ROUTING_RESOURCE_SN SRS2 WITH(NOLOCK)
									    WHERE  SRS2.PLAN_ID   = @V_PLAN_ID
									    AND    SRS2.RESOURCE_CLASS_ID = 'LINE'
									    AND    SRS2.ATTRIBUTE3 NOT IN ( 'IDLE_EQ' ) ) SRS2
					    ON  SRS.PLAN_ID		= SRS2.PLAN_ID
					    AND SRS.ATTRIBUTE3	= SRS2.ATTRIBUTE3
                        --START 2025-11-21, jongykim2
                        AND @V_DIVISION_ID = 'EE_UC'
                        AND RIGHT(SRS.ATTRIBUTE15, 1) = RIGHT(SRS2.ATTRIBUTE15, 1)
                        --END 2025-11-21, jongykim2
                        /* blocked 2025-11-21 jongykim2
                        AND (@V_DIVISION_ID != 'EE_UC' 
                            OR (@V_DIVISION_ID = 'EE_UC' 
                            AND RIGHT(SRS.ATTRIBUTE15, 1) = RIGHT(SRS2.ATTRIBUTE15, 1))
                            ) */
		    WHERE  SRS.PLAN_ID   = @V_PLAN_ID
		    AND    SRS.RESOURCE_CLASS_ID = 'LINE'
		    AND    SRS.ATTRIBUTE3 NOT IN ( 'IDLE_EQ' )
            AND    SRS.ATTRIBUTE3 IN ('COATING', 'NND')
        )
        INSERT INTO #RESULT_HEADER
        SELECT A.HEADER_KEY
             , A.MODEL
             , A.OPERATION
             , A.ITEM_ID
             , A.NICK_NAME
             , A.PLANT_SITE
             , A.SALES_SITE
             , A.FCST_Type
             , C.ELECTRODE_TYPE
             , C.ATTR2
             , C.LINE_GROUP
             , C.LINE
             , C.ELECTRODE_TYPE_CD
             , C.SORT_ORD
        FROM   EOL_ASSY A
        INNER JOIN HEADER_TEMPLATE C
        ON     C.HEADER_KEY = A.HEADER_KEY
        AND    C.OPERATION = A.OPERATION
        AND    C.ELECTRODE_TYPE_CD = A.ELECTRODE_TYPE_CD
        ;

        --SELECT * FROM #RESULT_HEADER T WITH(NOLOCK) ORDER BY HEADER_KEY, MODEL

		-------------------------------------------------------------------------------------
		-- E2000인 경우 상위 NND ITEM을 SALES SITE에 표기
		-------------------------------------------------------------------------------------
		WITH BOM_T AS (	SELECT ATTRIBUTE2  AS PARENT_ITEM_ID
		                     , ATTRIBUTE14 AS CHILD_ITEM_ID
						FROM   SCP_OPT_ENG_BOM_SN WITH(NOLOCK)
						WHERE  PLAN_ID     = @V_PLAN_ID )
		UPDATE H
		SET    H.SALES_SITE = T.PARENT_ITEM_ID
		FROM   #RESULT_HEADER    H
		       INNER JOIN BOM_T  T
			   ON H.ITEM_ID = T.CHILD_ITEM_ID
		WHERE  H.OPERATION = 'E2000'
		;

		-------------------------------------------------------------------------------------
		-- A5000 인 경우 하위 전극 ITEM을 SALES SITE에 표기, LINE명에서 @이후 제거, ELECTRODE_TYPE 표기
		-------------------------------------------------------------------------------------
		WITH BOM_T AS (	SELECT ATTRIBUTE2  AS PARENT_ITEM_ID
		                     , ATTRIBUTE14 AS CHILD_ITEM_ID
						FROM   SCP_OPT_ENG_BOM_SN WITH(NOLOCK)
						WHERE  PLAN_ID     = @V_PLAN_ID )
		UPDATE H
		SET    H.SALES_SITE = T.CHILD_ITEM_ID
		FROM   #RESULT_HEADER    H
        LEFT OUTER JOIN BOM_T  T
            ON H.ITEM_ID = T.PARENT_ITEM_ID
		WHERE  H.OPERATION = 'A5000'
        AND    H.HEADER_KEY = 'NND'
        AND    @V_DIVISION_ID  = 'EE_UC' -- Added 2025-11-21 jongykim2
		;

        INSERT INTO @OUT_ITEM
        EXEC PR_SCP_OPT_ENG_RESULT @P_FP_PLAN_ID, @P_PLAN_ID, 'ITEM'
        ;

        IF ( SELECT COUNT(*) FROM @OUT_ITEM ) = 0
            BEGIN 
                INSERT INTO  @OUT_ITEM
                SELECT DISTINCT TYPE, ITEM
                FROM   SCP_OPT_ENG_OUT_PLAN_RESULT_SN WITH(NOLOCK) 
                WHERE  PLAN_ID = @V_PLAN_ID
                AND    TYPE IN ( 'P_IN','P_OUT' )
            END;
--계획에 없는데 왜 나와요? 라고 문의시 아래 확인
--SELECT * FROM @OUT_ITEM

        DELETE  HD
        FROM    #RESULT_HEADER HD
		WHERE 	NOT EXISTS (
							SELECT	1
							FROM 	(	
									SELECT	 HEADER_KEY
											,NICK_NAME
									FROM 	#RESULT_HEADER
									WHERE 	ITEM_ID IN ( SELECT T.ITEM_ID FROM @OUT_ITEM T )
									GROUP BY HEADER_KEY, NICK_NAME
									) ITM
							WHERE   ITM.HEADER_KEY = HD.HEADER_KEY
							AND 	ITM.NICK_NAME = HD.NICK_NAME
							)
        -- END 2025-11-21 jongykim2

		INSERT INTO @RESULT_HEADER
		-------------------------------------------------------------------------------------
		SELECT HEADER_KEY, OPERATION, MODEL, ITEM_ID, NICK_NAME, PLANT_SITE, SALES_SITE, FCST_Type, Attr1, Attr2, LINE_GROUP, LINE, ELECTRODE_TYPE
		FROM (
				-------------------------------------------------------------------------------------
				SELECT	 DISTINCT 
						 SRS.ATTRIBUTE3				AS HEADER_KEY
						,LV.OPERATION_ID			AS OPERATION
						,SIM.APPLIED_MODEL			AS MODEL
						,SRS.ATTRIBUTE2				AS ITEM_ID
						,SIM.NICK_NAME				AS NICK_NAME
						,SRS.ATTRIBUTE1				AS PLANT_SITE
						,''							AS SALES_SITE
						,'Mass'						AS FCST_Type
						,''							AS Attr1
						,''							AS Attr2
						,CASE WHEN SRS2.RESOURCE_ID LIKE '%@E' THEN 'EAST'
							  WHEN SRS2.RESOURCE_ID LIKE '%@W' THEN 'WEST'
							  ELSE ''
							  END					AS LINE_GROUP
					   ,SRS2.ATTRIBUTE15			AS LINE
					   ,''							AS ELECTRODE_TYPE	
				FROM	SCP_OPT_ENG_ROUTING_RESOURCE_SN SRS WITH(NOLOCK)
						LEFT OUTER JOIN @OPERATION_TEMP LV
							ON  @V_DIVISION_ID   = LV.DIVISION_ID -- DIVISION
							AND @V_PLAN_GROUP_ID = LV.PLAN_GROUP -- PLAN GR
							AND SRS.ATTRIBUTE3	     = LV.STAGE 
						LEFT OUTER JOIN (	SELECT	STM.ITEM_ID, STM.APPLIED_MODEL, STM.NICK_NAME 
											FROM	SCM_ITEM_M STM WITH(NOLOCK)
													INNER JOIN @DIVISION DIV
													ON	STM.DIVISION_ID = DIV.DIVISION_ID 
										) SIM
							ON  SRS.ATTRIBUTE2 = SIM.ITEM_ID 
						LEFT OUTER JOIN (	SELECT DISTINCT PLAN_ID, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE15, RESOURCE_ID
											FROM   SCP_OPT_ENG_ROUTING_RESOURCE_SN SRS2 WITH(NOLOCK)
											WHERE  SRS2.PLAN_ID   = @V_PLAN_ID
											AND    SRS2.RESOURCE_CLASS_ID = 'LINE'
											AND    SRS2.ATTRIBUTE3 NOT IN ( 'IDLE_EQ' ) ) SRS2
							ON  SRS.PLAN_ID		= SRS2.PLAN_ID
							AND SRS.ATTRIBUTE3	= SRS2.ATTRIBUTE3
                            AND (@V_DIVISION_ID != 'EE_UC' 
                                OR (@V_DIVISION_ID = 'EE_UC' 
                                AND RIGHT(SRS.ATTRIBUTE15, 1) = RIGHT(SRS2.ATTRIBUTE15, 1))
                                )
				WHERE  SRS.PLAN_ID   = @V_PLAN_ID
				AND    SRS.RESOURCE_CLASS_ID = 'LINE'
				AND    SRS.ATTRIBUTE3 NOT IN ( 'IDLE_EQ' )
                AND    1 = 2 -- Added 2025-11-26 jongykim2
				-------------------------------------------------------------------------------------
				UNION ALL
				-------------------------------------------------------------------------------------
				-- STK 기준 BOM 1Level 상위 ASSY ITEM연결
				-------------------------------------------------------------------------------------
				SELECT  DISTINCT 
						 SBS.MATERIAL_CLASS_ID		AS HEADER_KEY
						,LV.OPERATION_ID			AS OPERATION
						,SIM.APPLIED_MODEL			AS MODEL
						,SBS.ATTRIBUTE2				AS ITEM_ID
						,SIM.NICK_NAME				AS NICK_NAME
						,SBS.ATTRIBUTE1				AS PLANT_SITE
						,''							AS SALES_SITE
						,'Mass'						AS FCST_Type
						,''							AS Attr1
						,''							AS Attr2
						,''							AS LINE_GROUP
					   ,'ALL'						AS LINE 
					   ,''							AS ELECTRODE_TYPE	
				FROM   SCP_OPT_ENG_BOM_SN SBS WITH(NOLOCK)
						LEFT OUTER JOIN @OPERATION_TEMP LV
							ON  @V_DIVISION_ID   = LV.DIVISION_ID -- DIVISION
							AND @V_PLAN_GROUP_ID = LV.PLAN_GROUP -- PLAN GR
							AND SBS.ATTRIBUTE3	 = LV.STAGE 
						LEFT OUTER JOIN (	SELECT	STM.ITEM_ID, STM.APPLIED_MODEL, STM.NICK_NAME 
											FROM	SCM_ITEM_M STM WITH(NOLOCK)
													INNER JOIN @DIVISION DIV
													ON	STM.DIVISION_ID = DIV.DIVISION_ID 
										) SIM
							ON  SBS.ATTRIBUTE2 = SIM.ITEM_ID 
				WHERE  SBS.PLAN_ID   = @V_PLAN_ID
				AND    SBS.MATERIAL_CLASS_ID = 'STK'
                AND    1 = 2 -- Added 2025-11-26 jongykim2
				-------------------------------------------------------------------------------------
				UNION ALL
				-------------------------------------------------------------------------------------
				-- STK 기준 BOM 2 Level 하위 NND ITEM연결
				-------------------------------------------------------------------------------------
				SELECT  DISTINCT 
						 SBS.MATERIAL_CLASS_ID		AS HEADER_KEY
						,'A5000'					AS OPERATION
						,SIM.APPLIED_MODEL			AS MODEL
						,MSTBOM.CHILD_ITEM_ID		AS ITEM_ID
						,SIM.NICK_NAME				AS NICK_NAME
						,SBS.ATTRIBUTE1				AS PLANT_SITE
						,''							AS SALES_SITE
						,'Mass'						AS FCST_Type
						,''							AS Attr1
						,''							AS Attr2
						,''							AS LINE_GROUP
					   ,'ALL'						AS LINE 
					   ,''							AS ELECTRODE_TYPE	
				FROM   SCP_OPT_ENG_BOM_SN SBS WITH(NOLOCK)
						LEFT OUTER JOIN @OPERATION_TEMP LV
							ON  @V_DIVISION_ID     = LV.DIVISION_ID -- DIVISION
							AND @V_PLAN_GROUP_ID   = LV.PLAN_GROUP -- PLAN GR
							AND SBS.ATTRIBUTE3	   = LV.STAGE 
						LEFT OUTER JOIN (	SELECT	STM.ITEM_ID, STM.APPLIED_MODEL, STM.NICK_NAME 
											FROM	SCM_ITEM_M STM WITH(NOLOCK)
													INNER JOIN @DIVISION DIV
													ON	STM.DIVISION_ID = DIV.DIVISION_ID 
										) SIM
							ON  SBS.ATTRIBUTE2 = SIM.ITEM_ID
						LEFT OUTER JOIN (   SELECT	SBM1.PARENT_ITEM_ID, SBM2.CHILD_ITEM_ID
											FROM	SCM_BOM_M SBM1 WITH(NOLOCK)
													INNER JOIN @DIVISION DIV
														ON	SBM1.DIVISION_ID = DIV.DIVISION_ID
													INNER JOIN SCM_BOM_M SBM2  WITH(NOLOCK)
														ON	SBM1.DIVISION_ID = SBM2.DIVISION_ID
														AND	SBM1.CHILD_ITEM_ID = SBM2.PARENT_ITEM_ID
														AND	SBM2.EFF_END_DATE >= GETDATE()
													INNER JOIN SCM_ITEM_M SIM2 WITH(NOLOCK)
														ON	SBM2.DIVISION_ID    = SIM2.DIVISION_ID
														AND	SBM2.CHILD_ITEM_ID  = SIM2.ITEM_ID
														AND SIM2.ITEM_TYPE <> 'R'
											WHERE   SBM1.EFF_END_DATE >= GETDATE()
										) MSTBOM
							ON MSTBOM.PARENT_ITEM_ID = SBS.ATTRIBUTE14
				WHERE  SBS.PLAN_ID   = @V_PLAN_ID
				AND    SBS.MATERIAL_CLASS_ID = 'STK'
                AND    1 = 2 -- Added 2025-11-26 jongykim2
				-------------------------------------------------------------------------------------
		) FINAL;
	 -- 정렬 순서는 Simulator에서도 연계하여 설정하므로, 절대 임의 변경하지 말 것!!!!!
	 --ORDER BY CASE	WHEN HEADER_KEY = 'COATING' THEN 1
		--			WHEN HEADER_KEY = 'NND'		THEN 2 
		--			WHEN HEADER_KEY = 'STK'		THEN 3 
		--			WHEN HEADER_KEY = 'ASSY'	THEN 4 
		--			WHEN HEADER_KEY = 'EOL'		THEN 5 END 
	 --      , MODEL, OPERATION DESC, ITEM_ID, NICK_NAME, PLANT_SITE, SALES_SITE, FCST_Type, Attr1, Attr2, LINE_GROUP DESC, LINE

		
		-------------------------------------------------------------------------------------
		-- E2000인 경우 상위 NND ITEM을 SALES SITE에 표기
		-------------------------------------------------------------------------------------
		WITH BOM_T AS (	SELECT ATTRIBUTE2  AS PARENT_ITEM_ID
		                     , ATTRIBUTE14 AS CHILD_ITEM_ID
						FROM   SCP_OPT_ENG_BOM_SN WITH(NOLOCK)
						WHERE  PLAN_ID     = @V_PLAN_ID )
		UPDATE H
		SET    H.SALES_SITE = T.PARENT_ITEM_ID
		FROM   @RESULT_HEADER    H
		       INNER JOIN BOM_T  T
			   ON H.ITEM_ID = T.CHILD_ITEM_ID
		WHERE  H.OPERATION = 'E2000'
        AND    1 = 2 -- Added 2025-11-26 jongykim2
		;

		-------------------------------------------------------------------------------------
		-- A5000 인 경우 하위 전극 ITEM을 SALES SITE에 표기, LINE명에서 @이후 제거, ELECTRODE_TYPE 표기
		-------------------------------------------------------------------------------------
		WITH BOM_T AS (	SELECT ATTRIBUTE2  AS PARENT_ITEM_ID
		                     , ATTRIBUTE14 AS CHILD_ITEM_ID
						FROM   SCP_OPT_ENG_BOM_SN WITH(NOLOCK)
						WHERE  PLAN_ID     = @V_PLAN_ID )
		UPDATE H
		SET    H.SALES_SITE = T.CHILD_ITEM_ID
		      ,H.LINE       = IIF(CHARINDEX('@',H.LINE) > 0, LEFT(H.LINE, CHARINDEX('@',H.LINE)-1), H.LINE)
			  ,H.ELECTRODE_TYPE = CASE WHEN H.ITEM_ID LIKE 'ANPA%' THEN 'Anode' ELSE 'Cathode' END
		FROM   @RESULT_HEADER    H
        LEFT OUTER JOIN BOM_T  T
            ON H.ITEM_ID = T.PARENT_ITEM_ID
		WHERE  H.OPERATION = 'A5000'
        AND    1 = 2 -- Added 2025-11-26 jongykim2
		;

		-------------------------------------------------------------------------------------
		-- E2000 ELECTRODE_TYPE 표기
        -- 2025.09.23 Philsu Park: E2000 EQUIPMENT_ID(설비정보) 추가
		-------------------------------------------------------------------------------------
		WITH LINE AS (	SELECT A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, IIF(A.OPERATION_ID = 'E2000', EQ.EQUIPMENT_ID, '-') AS EQUIPMENT_ID
						FROM   SCM_LINE_M A WITH(NOLOCK)
                        INNER JOIN @DIVISION D 
                            ON A.DIVISION_ID = D.DIVISION_ID
                        LEFT OUTER JOIN SCM_EQUIPMENT_M EQ WITH(NOLOCK)
                            ON  EQ.COMPANY_ID       = A.COMPANY_ID
                            AND EQ.DIVISION_ID      = A.DIVISION_ID
                            AND EQ.SITE_ID          = A.SITE_ID
                            AND EQ.PLANT_ID         = A.PLANT_ID
                            AND EQ.FACTORY_ID       = A.FACTORY_ID
                            AND EQ.OPERATION_ID     = A.OPERATION_ID
                            AND EQ.LINE_ID          = A.LINE_ID
                            AND EQ.ACTIVE_FLAG      = 'Y'
                            AND EQ.EQUIPMENT_TYPE   = 'M'
                            AND EQ.OPERATION_ID     = 'E2000'
						WHERE   A.OPERATION_ID  = 'E2000'
                        AND     A.ACTIVE_FLAG   = 'Y'
						)
		UPDATE  H
		SET       H.ELECTRODE_TYPE = L.ELECTRODE_TYPE
                , H.LINE_GROUP = ISNULL(L.EQUIPMENT_ID, '-')
		FROM   @RESULT_HEADER    H
		       INNER JOIN LINE   L
			   ON H.LINE = L.LINE_ID
		WHERE  H.OPERATION = 'E2000'
        AND    1 = 2 -- Added 2025-11-26 jongykim2
		;

		-------------------------------------------------------------------------------------
		-- STK 전체 1 SET 추가 생성 for Simulator 수식 처리
		-------------------------------------------------------------------------------------
		INSERT INTO @RESULT_HEADER	    
		SELECT HEADER_KEY 
			  ,OPERATION
			  ,MODEL
			  ,ITEM_ID
			  ,NICK_NAME
			  ,PLANT_SITE
			  ,SALES_SITE
			  ,FCST_Type
			  ,Attr1
			  ,Attr2
			  ,LINE_GROUP
			  ,LINE
			  ,ELECTRODE_TYPE
		FROM   ( SELECT  HEADER_KEY
						,OPERATION
						,MODEL
						,ITEM_ID
						,NICK_NAME
						,PLANT_SITE
						,SALES_SITE
						,FCST_Type
						--, '2ND' AS Attr1 -- FOR SORT
						--,Attr2
						, Attr1 -- FOR SORT
						,'2ND' AS Attr2
						,LINE_GROUP
						,LINE
						,''		AS ELECTRODE_TYPE
				 FROM   @RESULT_HEADER RLT
				 WHERE  OPERATION = 'A8000' ) RLT
        WHERE    1 = 2 -- Added 2025-11-26 jongykim2

		-------------------------------------------------------------------------------------
		-- STK 전체 라인 없이 5행 추가 for Simulator 수식 처리
		------------------------------------------------------------------------------------- 
		INSERT INTO @RESULT_HEADER
		SELECT	 RLT.HEADER_KEY
				,RLT.OPERATION
				,RLT.MODEL
				,RLT.ITEM_ID
				,RLT.NICK_NAME
				,RLT.PLANT_SITE
				,RLT.SALES_SITE
				,RLT.FCST_Type
				,RLT.Attr1
				,RLT.Attr2
				,RLT.LINE_GROUP
				,RLT.LINE
				,RLT.ELECTRODE_TYPE
		FROM   ( SELECT DISTINCT 
		                HEADER_KEY
					   ,OPERATION
					   ,MODEL
					   ,ITEM_ID
					   ,NICK_NAME
					   ,PLANT_SITE
					   ,SALES_SITE
					   ,FCST_Type
					  --,''		AS Attr1
					   --,Attr2
					   ,Attr1
					   ,''		AS Attr2
					   ,''		AS LINE_GROUP
					   ,'ALL'	AS LINE
					   ,''		AS ELECTRODE_TYPE
				 FROM   @RESULT_HEADER RLT
				 WHERE  OPERATION = 'A8000' ) RLT
			   CROSS JOIN ( SELECT NUM FROM @NUM NUM WHERE NUM <= 5 ) AS NUM
        WHERE    1 = 2 -- Added 2025-11-26 jongykim2

		-------------------------------------------------------------------------------------
		-- STK에 추가한 NND를 3행 추가 for Simulator 수식 처리
		------------------------------------------------------------------------------------- 
		INSERT INTO @RESULT_HEADER
		SELECT	 RLT.HEADER_KEY
				,RLT.OPERATION
				,RLT.MODEL
				,RLT.ITEM_ID
				,RLT.NICK_NAME
				,RLT.PLANT_SITE
				,RLT.SALES_SITE
				,RLT.FCST_Type
				,RLT.Attr1
				,RLT.Attr2
				,RLT.LINE_GROUP
				,RLT.LINE
				,''  AS ELECTRODE_TYPE
		FROM   ( SELECT DISTINCT HEADER_KEY, MODEL, OPERATION, ITEM_ID, NICK_NAME, PLANT_SITE, SALES_SITE, FCST_Type, '' AS Attr1, Attr2, '' AS LINE_GROUP, 'ALL' AS LINE
				 FROM   @RESULT_HEADER RLT
				 WHERE  HEADER_KEY = 'STK'
				 AND    OPERATION = 'A5000') RLT
			   CROSS JOIN ( SELECT NUM FROM @NUM NUM WHERE NUM <= 3 ) AS NUM
        WHERE    1 = 2 -- Added 2025-11-26 jongykim2
        ;

		-------------------------------------------------------------------------------------
		-- 실제 계획결과 없는 행 삭제
		------------------------------------------------------------------------------------- 
        /* -- BLOCKED 2025-11-27 jongykim2
        INSERT INTO @OUT_ITEM
        EXEC PR_SCP_OPT_ENG_RESULT @P_FP_PLAN_ID, @P_PLAN_ID, 'ITEM'
        ;

        IF ( SELECT COUNT(*) FROM @OUT_ITEM ) = 0
            BEGIN 
                INSERT INTO  @OUT_ITEM
                SELECT DISTINCT TYPE, ITEM
                FROM   SCP_OPT_ENG_OUT_PLAN_RESULT_SN WITH(NOLOCK) 
                WHERE  PLAN_ID = @V_PLAN_ID
                AND    TYPE IN ( 'P_IN','P_OUT' )
            END; */
		/* INSERT INTO  @OUT_ITEM
		SELECT DISTINCT TYPE, ITEM
		FROM   SCP_OPT_ENG_OUT_PLAN_RESULT_SN WITH(NOLOCK) 
		WHERE  PLAN_ID = @V_PLAN_ID
		AND    TYPE IN ( 'P_IN','P_OUT' ) */
		-------------------------------------------------------------------------------------
        -- A8000이 없으면 A5000과 A9000도 같이 삭제하기 위해 로직 변경/20250917/THKIM
        -- 2025.10.15 Philsu Park: NICK 단위로 넣고 빼기 때문에 살릴 NICK을 식별해서 NOT EXISTS 로 로직 변경.
        /* -- BLOCKED 2025-11-27 jongykim2
        DELETE  HD
        FROM    @RESULT_HEADER HD
		WHERE 	NOT EXISTS (
							SELECT	1
							FROM 	(	
									SELECT	 HEADER_KEY
											,NICK_NAME
									FROM 	@RESULT_HEADER
									WHERE 	ITEM_ID IN ( SELECT T.ITEM_ID FROM @OUT_ITEM T )
									GROUP BY HEADER_KEY, NICK_NAME
									) ITM
							WHERE   ITM.HEADER_KEY = HD.HEADER_KEY
							AND 	ITM.NICK_NAME = HD.NICK_NAME
							) */
        /* DELETE  HD
        FROM    @RESULT_HEADER HD
            INNER JOIN(
                      SELECT HEADER_KEY
                            ,NICK_NAME
                      FROM @RESULT_HEADER
                      WHERE (CASE WHEN HEADER_KEY = 'STK' AND OPERATION IN ('A5000','A9000') THEN MODEL   -- 임의생성한 STK의 A5000/A9000은 모델로 판단
						     ELSE ITEM_ID END  ) NOT IN ( SELECT T.ITEM_ID FROM @OUT_ITEM T )
                      GROUP BY HEADER_KEY, NICK_NAME
                      ) HN
                ON  HD.HEADER_KEY = HN.HEADER_KEY
                AND HD.NICK_NAME  = HN.NICK_NAME */
                
		--DELETE HD  FROM @RESULT_HEADER HD
  --      WHERE  (CASE	WHEN HD.HEADER_KEY = 'STK' AND HD.OPERATION IN ( 'A5000','A9000') THEN HD.MODEL   -- 임의생성한 STK의 A5000/A9000은 모델로 판단
		--				ELSE HD.ITEM_ID END  )
		--		NOT IN ( SELECT T.ITEM_ID FROM @OUT_ITEM T )
        /* WHERE NOT EXISTS ( SELECT 2
                             FROM @OUT_ITEM T
                             WHERE T.ITEM_ID = CASE	WHEN HD.HEADER_KEY = 'STK' AND HD.OPERATION IN ( 'A5000','A9000') THEN HD.MODEL   -- 임의생성한 STK의 A5000/A9000은 모델로 판단
						                            ELSE HD.ITEM_ID END
                            ) */
		-------------------------------------------------------------------------------------

		-------------------------------------------------------------------------------------
		-- 최종 조회
		------------------------------------------------------------------------------------- 
        WITH FNL AS (
        SELECT T.*
                , CASE
                    WHEN T.OPERATION = 'F6000' THEN 'C'
                    WHEN T.OPERATION = 'A5000' THEN 'B'+(CASE WHEN T.ELECTRODE_TYPE_CD = 'C' THEN 'A' ELSE 'X' END)+T.ITEM_ID
                    ELSE 'A'
                END AS PFIX_ORD
        FROM   #RESULT_HEADER T
        WHERE  1 = 1
        )
        SELECT F.HEADER_KEY
             , F.MODEL
             , F.OPERATION
             , F.ITEM_ID
             , F.NICK_NAME
             , F.PLANT_SITE
             , F.SALES_SITE
             , F.FCST_TYPE
             , F.ELECTRODE_TYPE
             , F.ATTR2
             , F.LINE_GROUP
             , F.LINE
        FROM   FNL F
        --ORDER BY F.MODEL, F.PFIX_ORD+F.SORT_ORD
        ORDER BY CASE WHEN HEADER_KEY = 'COATING' THEN 1
                      WHEN HEADER_KEY = 'NND'   THEN 2 
                      WHEN HEADER_KEY = 'STK'   THEN 3 
                      WHEN HEADER_KEY = 'ASSY'  THEN 4 
                      WHEN HEADER_KEY = 'EOL'   THEN 5 END 
               , MODEL, OPERATION DESC, ITEM_ID DESC, NICK_NAME, PLANT_SITE, SALES_SITE, FCST_Type, Attr2
               , CASE WHEN LINE_GROUP = '' THEN 99 WHEN LINE_GROUP LIKE 'W%' THEN 90 WHEN LINE_GROUP LIKE 'E%' THEN 80 ELSE 10 END DESC
          --    , CASE WHEN LINE_GROUP = '' THEN 'Z' ELSE LINE_GROUP END DESC
               , LINE, ELECTRODE_TYPE DESC;		
        /*
        SELECT  HEADER_KEY
			   ,MODEL
			   ,OPERATION
			   ,ITEM_ID
			   ,NICK_NAME
			   ,PLANT_SITE
			   ,SALES_SITE
			   ,FCST_Type
			   ,ELECTRODE_TYPE
			   --,Attr1
			   ,Attr2
			   ,LINE_GROUP
			   ,LINE
            --    ,CASE WHEN LINE_GROUP = '' THEN 99 WHEN LINE_GROUP LIKE 'W%' THEN 90 WHEN LINE_GROUP LIKE 'E%' THEN 80 ELSE 10 END AS LINE_GROUP_SORT
		FROM   @RESULT_HEADER
		WHERE  1=1
		 -- 정렬 순서는 Simulator에서도 연계하여 설정하므로, 절대 임의 변경하지 말 것!!!!!
		 ORDER BY CASE	WHEN HEADER_KEY = 'COATING' THEN 1
						WHEN HEADER_KEY = 'NND'		THEN 2 
						WHEN HEADER_KEY = 'STK'		THEN 3 
						WHEN HEADER_KEY = 'ASSY'	THEN 4 
						WHEN HEADER_KEY = 'EOL'		THEN 5 END 
			   , MODEL, OPERATION DESC, ITEM_ID DESC, NICK_NAME, PLANT_SITE, SALES_SITE, FCST_Type, Attr1, Attr2
               , CASE WHEN LINE_GROUP = '' THEN 99 WHEN LINE_GROUP LIKE 'W%' THEN 90 WHEN LINE_GROUP LIKE 'E%' THEN 80 ELSE 10 END DESC
			--    , CASE WHEN LINE_GROUP = '' THEN 'Z' ELSE LINE_GROUP END DESC
			   , LINE, ELECTRODE_TYPE DESC; */

	-------------------------------------------------------------------------------------
	END
	-------------------------------------------------------------------------------------

  END;
