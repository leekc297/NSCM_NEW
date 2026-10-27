
/* exec [dbo].[PR_XLS_GET_YIELD_PIVOT_IMSI] '통합플랜아이디', '데이터TYPE',  '시작일자' , '종료일자'
, '공정코드,공정코드,공정코드,공정코드'
,'cathode,cathode,cathode,cathode'
,'FP_EIM01_C,FP_EIM02_C,FP_EIM03_C,FP_EIM04_C'
,'APCCA3059A'
 */
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GET_PIVOT_DATA]
     @P_FP_PLAN_ID      NVARCHAR(50)
    ,@P_PLAN_ID         NVARCHAR(50)
    ,@P_PLAN_TYPE       NVARCHAR(50)
    ,@P_RESULT_TYPE     NVARCHAR(50)
    ,@P_FROM_YYYYMMDD   NVARCHAR(8)
    ,@P_TO_YYYYMMDD     NVARCHAR(8)
    ,@P_OPERATION_STR   NVARCHAR(MAX)
    ,@P_ELECTRODE_STR   NVARCHAR(MAX)
    ,@P_LINE_STR        NVARCHAR(MAX)
    ,@P_ITEM_ID         NVARCHAR(100)
AS 
BEGIN

    SET ARITHABORT ON;
    SET ANSI_NULLS ON;
    SET QUOTED_IDENTIFIER ON;
	SET NOCOUNT ON;

	-------------------------------------------------------------------------------------
	-- SET Parameter
	-------------------------------------------------------------------------------------
    DECLARE @V_PLAN_ID          NVARCHAR(50)    = @P_PLAN_ID;
    DECLARE @V_FP_PLAN_ID       NVARCHAR(50)    = @P_FP_PLAN_ID;
    DECLARE @V_PLAN_TYPE        NVARCHAR(50)    = @P_PLAN_TYPE;
    DECLARE @V_RESULT_TYPE      NVARCHAR(50)    = @P_RESULT_TYPE;
    DECLARE @V_FROM_YYYYMMDD    NVARCHAR(8)     = @P_FROM_YYYYMMDD;
    DECLARE @V_TO_YYYYMMDD      NVARCHAR(8)     = @P_TO_YYYYMMDD;
    DECLARE @V_OPERATION_STR    NVARCHAR(MAX)   = @P_OPERATION_STR;
    DECLARE @V_ELECTRODE_STR    NVARCHAR(MAX)   = @P_ELECTRODE_STR;
    DECLARE @V_LINE_STR         NVARCHAR(MAX)   = @P_LINE_STR;
    DECLARE @V_ITEM_ID          NVARCHAR(50)    = @P_ITEM_ID;
    DECLARE @COLUMNS            NVARCHAR(MAX);
    DECLARE @V_SQL              NVARCHAR(MAX);

    

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
    ,WORKING_DAY        NVARCHAR(100) -- added 2025-11-06
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
    ;

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
        ;

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
        ;


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
	-- Set Division for Elec Plan
	-------------------------------------------------------------------------------------
	INSERT INTO  @NUM
	SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5  UNION ALL
	SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
	;

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
	-- Set Daily CAPA
    -- 2025.09.10 Philsu Park: 룩업의 Tact Time 값 Numeric으로 Type Casting.
    -- 2025.09.12 Philsu Park: Engine Input 기반으로 출처 변경
    -- 2025.09.15 Philsu Park: 수율 역산 처리(Load_Per 값 자체가 수율 먹은채로 엔진 수행되고 있어서)
    -- 2025.09.30 Philsu Park: 조립/전극 각각 LINE_ID ATT값 구분.
	-------------------------------------------------------------------------------------
	INSERT INTO @DAILY_CAPA
        SELECT    LK.SEGMENT5       AS OPERATION_ID
                , IIF(@V_DIVISION_ID LIKE 'EE%', R.ATTRIBUTE13, R.ATTRIBUTE15)     AS LINE_ID
                , R.ATTRIBUTE2      AS ITEM_ID
                , R.ATTRIBUTE14     AS PLAN_YYYYMM
                -- , 86400/R.LOAD_PER  AS DAILY_QTY
                , IIF(MAX(RT.YIELD)=0,0, 86400/(MAX(R.LOAD_PER)/MAX(RT.YIELD)))  AS DAILY_QTY
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


    -- 공정, 전극구분, 라인 데이터를 임시 테이블에 삽입
    CREATE TABLE #ProcessTable (
        OPERATION_ID NVARCHAR(50),
        ELECTRODE_TYPE NVARCHAR(50),
        LINE_ID NVARCHAR(50)
    );

        
    WITH OPERATION AS (
            SELECT VALUE AS OPERATION_ID, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ROWNUM
            FROM dbo.fn_splitstring(@V_OPERATION_STR, ',')
        ),
        ELECTRODE AS (
            SELECT VALUE AS ELECTRODE_TYPE, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ROWNUM
            FROM dbo.fn_splitstring(@V_ELECTRODE_STR, ',')
        ),
        LINE AS (
            SELECT VALUE AS LINE_ID, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ROWNUM
            FROM dbo.fn_splitstring(@V_LINE_STR, ',')
        )

    -- RowNum을 기준으로 각 데이터를 순차적으로 매칭하여 삽입
    -- 2025.09.30 Philsu Park: Electrode Type은 E2000만 적용.
    -- 2025.10.01 Philsu Park: Electrode Type NND도 반영 필요.
    INSERT INTO #ProcessTable (OPERATION_ID, ELECTRODE_TYPE, LINE_ID)
    SELECT  P.OPERATION_ID, E.ELECTRODE_TYPE, L.LINE_ID
    FROM    OPERATION P
    INNER JOIN ELECTRODE E ON P.ROWNUM = E.ROWNUM
    INNER JOIN LINE      L ON P.ROWNUM = L.ROWNUM
    ;

    -- 기간 내 모든 일자를 열로 변환
    SELECT @COLUMNS = STRING_AGG(CAST(QUOTENAME(PRODUCTION_DATE) AS NVARCHAR(MAX)), ',') 
                        WITHIN GROUP ( ORDER BY PRODUCTION_DATE )
    FROM ( SELECT   DISTINCT BASIS_YYYYMMDD AS PRODUCTION_DATE 
            FROM    SCM_SYS_CALENDAR_M_SN CM WITH(NOLOCK)
            WHERE   BASIS_YYYYMMDD BETWEEN @V_FROM_YYYYMMDD AND @V_TO_YYYYMMDD
            ) AS AAA 
    ;

    SELECT  DISTINCT VALUE AS ITEM_ID
    INTO    #ITEM_LIST
    FROM    dbo.fn_splitstring(@V_ITEM_ID, ',')
    ;

    IF @V_PLAN_TYPE = 'PRODUCTION_RESULT'
        BEGIN
            -------------------------------------------------------------------------------------
            -- PRODUCTION RESULT
            -------------------------------------------------------------------------------------
            PRINT 'Prod Result Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
            -------------------------------------------------------------------------------------
            INSERT INTO @RESULT_TEMP
            -------------------------------------------------------------------------------------
            -- VIEW의 실적구간이 아닌 UI 실적으로 대체
            -- 2025.09.30 Philsu Park: 정수화, K 단위로 반영
            -- 2025.10.01 Philsu Park: 
                SELECT  'PRODUCTION_RESULT'						AS TYPE
                    ,SMS.SCM_SITE_ID							AS SCM_SITE_ID
                    ,PRLT.ITEM_ID								AS ITEM_ID
                    ,OT.STAGE									AS STAGE
                    ,CONVERT(NVARCHAR,PRLT.PLAN_DATE,112)		AS PRODUCTION_DATE
                    ,PRLT.LINE_ID								AS LINE_ID
                    ,SUM(ISNULL(PRLT.QTY, 0))                   AS QTY
                    -- ,ROUND(SUM(ISNULL(PRLT.QTY_LANE,0) + ISNULL(PRLT.DFCT_QTY2,0) + ISNULL(PRLT.YIELD_LOSS_QTY,0) + ISNULL(PRLT.PRDT_REQ_QTY2,0)), 0)/1000  AS QTY
                    ,PRLT.OPERATION_ID						AS OPEARATION_ID
                    ,''										AS FROM_SITE
                    ,''										AS TO_SITE
                    ,''										AS BOD_ID
                    ,''										AS TRANSPORT_MODE
                    ,''										AS INCOTERMS
                    ,''										AS DEPARTURE_DATE
                    ,''										AS ARRIVAL_DATE
                    ,'-'                                      AS ELECTRODE_TYPE
                    ,NULL                                   AS WORKING_DAY
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
                GROUP BY SMS.SCM_SITE_ID, PRLT.ITEM_ID, OT.STAGE, PRLT.PLAN_DATE, PRLT.LINE_ID, PRLT.OPERATION_ID	
            -------------------------------------------------------------------------------------
            PRINT 'Prod Result End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
            -------------------------------------------------------------------------------------
			-------------------------------------------------------------------------------------
			-- CELL 환산
			-------------------------------------------------------------------------------------
			IF @V_PLAN_GROUP_ID = 'GM1_E'
			-------------------------------------------------------------------------------------
			-- 2025.10.01 Philsu Park: Cell 환산 후 정수화, 1K 단위로 나눠줌.(신의호 부장님 요청)
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
				AND 	RS.STAGE IN ( 'COATING','INSP_COT' )
				AND 	RS.TYPE IN ('PRODUCTION_RESULT' )
				;
			-------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#BOM_NND') IS NOT NULL
			-------------------------------------------------------------------------------------
					BEGIN 
						DROP TABLE  #BOM_NND;
					END;
			-------------------------------------------------------------------------------------
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
			-------------------------------------------------------------------------------------
					UPDATE	RS
					SET 	RS.QTY = RS.QTY / BOM.MAX_USAGE
					FROM 	@RESULT_TEMP RS
					INNER JOIN #BOM_NND BOM
						ON  RS.ITEM_ID = BOM.CHILD_ITEM_ID
					WHERE 	1=1
					--AND 	RS.STAGE = 'NND'
					AND     RS.STAGE IN ( 'NND', 'INSP_NND' )
					AND 	RS.TYPE IN ('PRODUCTION_RESULT');
			-------------------------------------------------------------------------------------	
			END;
        END

    -------------------------------------------------------------------------------------
        -- 2025.10.01 Philsu Park: 수량 ROUND, 1/1000 처리.
        UPDATE	RS
        SET 	RS.QTY = ROUND(RS.QTY, 0)/1000
        FROM 	@RESULT_TEMP RS
        WHERE 	1=1
        AND 	RS.TYPE IN ('PRODUCTION_RESULT');
    -------------------------------------------------------------------------------------
	
	

    IF @V_PLAN_TYPE = 'WORKING_DAY'
        BEGIN
            -------------------------------------------------------------------------------------
            PRINT 'Prod Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
            -------------------------------------------------------------------------------------
            -- PRODUCTION PLAN
            -------------------------------------------------------------------------------------
            IF @V_RESULT_TYPE = 'ALL'
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
                            ,NULL                   AS WORKING_DAY -- added 2025-11-06
                        FROM(
                            SELECT   OP.SITE_ID										AS SITE_ID
                                    ,OP.ITEM_ID										AS ITEM_ID
                                    ,OP.GRADE										AS GRADE
                                    ,OP.START_DATE									AS PRODUCTION_DATE
                                    -- ,ISNULL(RE.ATTRIBUTE14, RE.ATTRIBUTE15			AS LINE_ID
                                    ,IBR.LINE_ID                                 AS LINE_ID
                                    ,SIS.STAGE                                      AS STAGE
                                    --,LV.OPERATION_ID								AS OPERATION_ID
                                    ,SUM(CONVERT(NUMERIC(20,10), OP.OUT_QTY))		AS QTY
                                FROM SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN OP WITH(NOLOCK) 
                                INNER JOIN ( 
                                        SELECT  B.ROUTING_BOM_MAPPING_ID
                                                , IIF(CHARINDEX('@', R.ATTRIBUTE15) > 0, LEFT(R.ATTRIBUTE15, CHARINDEX('@', R.ATTRIBUTE15)-1), R.ATTRIBUTE15) AS LINE_ORG
                                                --,  R.ATTRIBUTE15 AS LINE_ID
												,  ISNULL(R.ATTRIBUTE13, R.ATTRIBUTE15) AS LINE_ID
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
                                INNER JOIN #ITEM_LIST ITM
                                    ON ITM.ITEM_ID = OP.ITEM_ID
                                WHERE OP.PLAN_ID = @V_PLAN_ID
                                GROUP BY OP.SITE_ID, OP.ITEM_ID, OP.GRADE, OP.START_DATE, IBR.LINE_ID, SIS.STAGE
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
                        -- 2025.09.30 Philsu Park: Electrode_Type은 밑에서 E2000만 업데이트 해서 사용.
                        -- 2025.10.01 Philsu Park: Electrode_Type E2000, A5000 필요.
                        SELECT 'PRODUCTION_PLAN'        AS TYPE
                            ,PLN.SITE_ID				AS SITE_ID
                            ,PLN.ITEM_ID				AS ITEM_ID
                            ,LV.STAGE					AS STAGE
                            ,PLN.PRODUCTION_DATE		AS PRODUCTION_DATE
                            ,PLN.LINE_ID				AS LINE_ID
                            ,CASE WHEN PLN.OPERATION_ID IN ('A8000', 'F6000', 'A9000') THEN PLN.QTY ELSE PLN.QTY * ISNULL(CU.MAX_USAGE, 1) END AS QTY
                            -- ,CASE WHEN PLN.OPERATION_ID IN ('A8000', 'F6000', 'A9000') THEN PLN.QTY ELSE PLN.QTY END AS QTY
                            ,PLN.OPERATION_ID			AS OPEARATION_ID
                            ,''						AS FROM_SITE
                            ,''						AS TO_SITE
                            ,''						AS BOD_ID
                            ,''						AS TRANSPORT_MODE
                            ,''						AS INCOTERMS
                            ,''						AS DEPARTURE_DATE
                            ,''						AS ARRIVAL_DATE
                            ,'-'                    AS ELECTRODE_TYPE
                            ,PLN.WORKING_DAY        AS WORKING_DAY -- added 2025-11-06
                        FROM(
                                SELECT 	  ST.SCM_SITE_ID 	AS SITE_ID
                                        , XLS.ITEM_ID		AS ITEM_ID
                                        , XLS.OPERATION_ID	AS OPERATION_ID
                                        , CONVERT(NVARCHAR, XLS.PLAN_DATE, 112) AS PRODUCTION_DATE
                                        , XLS.LINE_ID		AS LINE_ID
                                        , XLS.ELECTRODE_TYPE AS ELECTRODE_TYPE
                                        , SUM(XLS.QTY) 		AS QTY
                                        , MAX(WORKING_DAY)	AS WORKING_DAY -- added 2025-11-06
                                FROM   BUF_AMEND_PLAN_R_XLS XLS WITH(NOLOCK)
                                INNER JOIN #ITEM_LIST ITM
                                    ON ITM.ITEM_ID = XLS.ITEM_ID
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
                                HAVING  SUM(XLS.QTY) > 0
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
                                LEFT OUTER JOIN #CONVERT_USAGE CU
                                    ON PLN.ITEM_ID = CU.CHILD_ITEM_ID
                        WHERE 1=1
                        AND     OCV.STAGE IS NULL -- 2nd OCV STAGE는 대상이 아님
                END
            -------------------------------------------------------------------------------------
            PRINT 'Prod Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120);
            -------------------------------------------------------------------------------------

            -------------------------------------------------------------------------------------
            -- PRINT 'Daily Capa Start : '+ CONVERT(NVARCHAR,GETDATE(), 120);
            -------------------------------------------------------------------------------------
            -- DAILY_CAPA
            -------------------------------------------------------------------------------------
            /* IF @V_RESULT_TYPE IN('ALL','BUF')
                BEGIN
                    -------------------------------------------------------------------------------------
                    -- 월별로 변경 DAILY CAPA 추가
                    -------------------------------------------------------------------------------------
                    INSERT INTO @RESULT_TEMP
                        -------------------------------------------------------------------------------------
                        SELECT    'DAILY_CAPA'                                    AS TYPE
                                , R.ATTRIBUTE1							          AS SCM_SITE_ID
                                , R.ATTRIBUTE2							          AS ITEM_ID
                                ,R.ATTRIBUTE3							          AS STAGE
                                , R.ATTRIBUTE14							          AS PLAN_YYYYMM
                                , R.ATTRIBUTE15							          AS LINE_ID
                                , 86400/(MAX(R.LOAD_PER)/MAX(RT.YIELD))           AS DAILY_QTY
                                , LK.SEGMENT5				                      AS OPERATION_ID
                                ,''										          AS FROM_SITE		 
                                ,''										          AS TO_SITE		
                                ,''										          AS BOD_ID			
                                ,''										          AS TRANSPORT_MODE	
                                ,''										          AS INCOTERMS		
                                ,''										          AS DEPARTURE_DATE	
                                ,''										          AS ARRIVAL_DATE	
                                ,'-'									          AS ELECTRODE_TYPE 
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
            */
            
            -------------------------------------------------------------------------------------
            PRINT 'WORKING DAY Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
            -------------------------------------------------------------------------------------
            -- WORKING DAY
            -------------------------------------------------------------------------------------
            INSERT INTO @RESULT_TEMP
            -------------------------------------------------------------------------------------
            SELECT   'WORKING_DAY'
                    ,TEMP.SCM_SITE_ID
                    ,TEMP.ITEM_ID
                    ,TEMP.STAGE
                    ,TEMP.PRODUCTION_DATE
                    ,TEMP.LINE_ID
                    --,TEMP.QTY / CAPA.DAILY_QTY -- reopen 2025-11-12: 수식고정 요청(신의호B)_BUF Table WORKING_DAY 컬럼 삭제예정
                    --,IIF(@V_RESULT_TYPE = 'BUF', TEMP.WORKING_DAY, IIF(CAPA.DAILY_QTY = '0','0', TEMP.QTY / CAPA.DAILY_QTY))
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
                    ,NULL					AS WORKING_DAY -- added 2025-11-06 
            FROM   @RESULT_TEMP  TEMP
            LEFT OUTER JOIN @DAILY_CAPA CAPA
                ON  CAPA.OPERATION_ID	= TEMP.OPERATION_ID
                AND CAPA.LINE_ID		= TEMP.LINE_ID
                AND CAPA.ITEM_ID		= TEMP.ITEM_ID
                AND CAPA.PLAN_YYYYMM	= SUBSTRING(TEMP.PRODUCTION_DATE,1,6)
            WHERE 1=1
            AND   TYPE = 'PRODUCTION_PLAN'
            -------------------------------------------------------------------------------------
            PRINT 'WORKING DAY Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
            -------------------------------------------------------------------------------------
        END
    ;
    
    -- 2025.10.01 Philsu Park: A5000은 Item_ID 기준으로 판정.
    WITH LINE AS (	SELECT A.LINE_ID, A.ELECTRODE_TYPE
                    FROM   SCM_LINE_M A WITH(NOLOCK)
                        INNER JOIN @DIVISION D 
                            ON A.DIVISION_ID = D.DIVISION_ID
                    WHERE  A.OPERATION_ID = 'E2000'
                    AND     A.ACTIVE_FLAG = 'Y'
                    )
    UPDATE H
    SET    H.ELECTRODE_TYPE = ISNULL(L.ELECTRODE_TYPE, IIF(H.ITEM_ID LIKE 'ANPA%', 'Anode', 'Cathode'))
    FROM   @RESULT_TEMP    H
    LEFT OUTER JOIN LINE   L
        ON H.LINE_ID = L.LINE_ID
    WHERE  H.OPERATION_ID IN ('E2000', 'A5000')
    ;

/* 키 정보 관련 
1. Raw_A, Raw_E 시트 : Keys 열 수식 -> 쿼리에서 컬럼 추가
Raw_A 시트 : KEYS 컬럼의 구성(맨왼쪽에 추가)  : OPERATION_ID  & ITEM_ID & LINE_ID & IF(OR(TYPE = "SHIPMENT_RESULT",TYPE = "SHIPMENT_PLAN"),DEPARTURE_DATE,PRODUCTION_DATE) & TYPE
Raw_E 시트 : KEYS 컬럼의 구성(맨왼쪽에 추가)  : OPERATION_ID  & ITEM_ID & LINE_ID &  IF(TYPE = "INVENTORY", "", ELECTRODE_TYPE) & IF(OR(TYPE = "SHIPMENT_RESULT",TYPE = "SHIPMENT_PLAN"),DEPARTURE_DATE,PRODUCTION_DATE) & TYPE
참고 :  Raw_A 시트 와 Raw_E 시트 차이점 : IF(TYPE = "INVENTORY", "", ELECTRODE_TYPE) & <---이 부분만다름
*/

	-------------------------------------------------------------------------------------
	-- 2025.09.19/THKIM/정수화 진행
	-------------------------------------------------------------------------------------
    /* IF @V_RESULT_TYPE IN ('ALL')
    BEGIN
        UPDATE  @RESULT_TEMP
        SET     QTY = ROUND(QTY,0)
        WHERE   TYPE IN('PRODUCTION_PLAN', 'SHIPMENT_PLAN', 'INVENTORY','DAILY_CAPA')
    END
    ELSE IF @V_RESULT_TYPE IN ('BUF')
    BEGIN
        UPDATE  @RESULT_TEMP
        SET     QTY = ROUND(QTY,0)
        WHERE   TYPE IN('INVENTORY','DAILY_CAPA')
    END */

    SELECT RS.*
    INTO #RESULT_TEMP
    FROM @RESULT_TEMP RS
    INNER JOIN  #ITEM_LIST ITM
        ON  RS.ITEM_ID = ITM.ITEM_ID
    WHERE RS.TYPE = @V_PLAN_TYPE
    ;

    -- select *
    -- FROM #RESULT_TEMP
    -- ;

    -- SELECT *
    -- FROM #RESULT_TEMP RS 
    -- INNER JOIN #ProcessTable PT
    --     ON  PT.OPERATION_ID     = RS.OPERATION_ID
    --     AND PT.ELECTRODE_TYPE   = RS.ELECTRODE_TYPE
    --     AND PT.LINE_ID          = RS.LINE_ID
    -- WHERE   TYPE    = @V_PLAN_TYPE
    -- AND     ITEM_ID = ( select iteM_id from #ITEM_LIST )
    -- ;

    SET @V_SQL = '
	SELECT 
        -- TYPE
        -- ,SCM_SITE_ID
        -- ,ITEM_ID
        -- ,STAGE
        -- ,PRODUCTION_DATE
        -- ,LINE_ID, 
        ' + @COLUMNS + '
	FROM (
            SELECT RS.TYPE, RS.SCM_SITE_ID,RS.ITEM_ID,RS.STAGE,RS.PRODUCTION_DATE,PT.LINE_ID,RS.QTY,PT.OPERATION_ID,RS.FROM_SITE,RS.TO_SITE,RS.BOD_ID,RS.TRANSPORT_MODE,RS.INCOTERMS,PT.ELECTRODE_TYPE
            FROM #ProcessTable PT
            LEFT OUTER JOIN #RESULT_TEMP RS
                ON  PT.OPERATION_ID     = RS.OPERATION_ID
                AND PT.ELECTRODE_TYPE   = RS.ELECTRODE_TYPE
                AND PT.LINE_ID          = RS.LINE_ID
            ) AS SourceTable
	PIVOT (
		SUM(QTY)
		FOR PRODUCTION_DATE IN (' + @COLUMNS + ')
	) AS PivotTable
    ORDER BY LINE_ID
	';

    PRINT @V_SQL;
		
	EXEC sp_executesql @V_SQL;
	-------------------------------------------------------------------------------------
	-- Final Select
	-------------------------------------------------------------------------------------
        /* SELECT   CASE WHEN @V_PLAN_GROUP_ID = 'GM1_A' THEN CONCAT(OPERATION_ID, ITEM_ID, LINE_ID, IIF(TYPE LIKE 'SHIPMENT%', DEPARTURE_DATE, PRODUCTION_DATE), TYPE) 
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
        FROM   @RESULT_TEMP
        WHERE  TYPE = @V_PLAN_TYPE */
    

	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
    END;
	
