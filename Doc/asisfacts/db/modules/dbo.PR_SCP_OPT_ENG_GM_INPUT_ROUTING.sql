

CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_INPUT_ROUTING]
     @P_PLAN_ID             NVARCHAR(50)
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_INPUT_ROUTING';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE          DATETIME;
    DECLARE @P_PLAN_NAME            NVARCHAR(8);
    DECLARE @D_PLAN_NAME            DATETIME;
    DECLARE @V_PLAN_START_YYYYMM    NVARCHAR(8);
    DECLARE @V_PLAN_END_YYYYMM      NVARCHAR(8);
    DECLARE @V_PLAN_END_YYYYMMDD_V2 NVARCHAR(8);
    DECLARE @V_TRAY_YN              NVARCHAR(1)

    DECLARE @BASE_DATA TABLE(
                              PLAN_ID      NVARCHAR(100)
                            , OP_SEQ       INT
                            , LEAD_TIME    INT
                            , YIELD        NUMERIC(20,4)
                            , SITE_ID      NVARCHAR(100)
                            , ITEM_ID      NVARCHAR(100)
                            , STAGE        NVARCHAR(100)
                            , STAGE_BUFFER NVARCHAR(100)
                            , LINE_ID      NVARCHAR(100)
                            , MONTH        NVARCHAR(10)
                            , FL_LOOKUP_YN NVARCHAR(100)
                            , FY_LOOKUP_YN NVARCHAR(100)
                            )
    ;
    
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
        -- Get Plan Mater Info
        ------------------------------------------------------------------------
        SELECT @V_DIVISION_ID       = ATTRIBUTE1 
              ,@V_GROUP_ID          = ATTRIBUTE2 
        FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        WHERE  PLAN_ID = @P_PLAN_ID
        ------------------------------------------------------------------------
        -- SET Param
        ------------------------------------------------------------------------
        SELECT @P_PLAN_NAME = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
        SELECT @D_PLAN_NAME = CONVERT(DATETIME, @P_PLAN_NAME) ;
        
        SELECT @V_PLAN_START_YYYYMM = CONVERT(NVARCHAR(6),PLAN_START_DATE,112)
              ,@V_PLAN_END_YYYYMM   = CONVERT(NVARCHAR(6),PLAN_END_DATE,112)
        FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        WHERE  PLAN_ID = @P_PLAN_ID
         
        --SELECT @V_PLAN_END_YYYYMMDD_V2 = PLAN_END_YYYYMMDD
        --FROM   SCP_OPT_ENG_SCP_PLAN_ID_M_SN WITH(NOLOCK)
        --WHERE  PLAN_ID = @V_PLAN_ID

        --SELECT @V_PLAN_END_YYYYMMDD_V2 = PLAN_END_YYYYMMDD
        --FROM   SCP_OPMZ_PLAN_M WITH(NOLOCK)
        --WHERE  OPMZ_PLAN_ID = @V_PLAN_ID

        SELECT  @V_PLAN_END_YYYYMMDD_V2 = PLAN_END_YYYYMMDD
        FROM(
             SELECT PLAN_END_YYYYMMDD
             FROM   SCP_OPT_ENG_SCP_PLAN_ID_M_SN WITH(NOLOCK)
             WHERE  PLAN_ID = @V_PLAN_ID
             UNION
             SELECT PLAN_END_YYYYMMDD
             FROM   SCP_OPMZ_PLAN_M WITH(NOLOCK)
             WHERE  OPMZ_PLAN_ID = @V_PLAN_ID
            ) A
        ;

        ------------------------------------------------------------------------
        -- DATA Insert
        ------------------------------------------------------------------------
        -- PRINT N'STEP 1:: Line 정보 Insert ' + CONVERT(NVARCHAR, SYSDATETIME(), 114);
        ------------------------------------------------------------------------
        -- 1. Line 정보 Insert
        -- 2025.09.10 Philsu Park: 공정 LT 추가반영. ITEM 단위로 찾고 없으면 Stage Default 한번 더 찾는다.
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_ROUTING_SN   (PLAN_ID
                                    ,ROUTING_ID
                                    ,OP_SEQ
                                    ,LEAD_TIME
                                    ,YIELD
                                    ,ATTRIBUTE1
                                    ,ATTRIBUTE2
                                    ,ATTRIBUTE3
                                    ,ATTRIBUTE4
                                    ,ATTRIBUTE14
                                    ,ATTRIBUTE15
                                    )
        SELECT  @V_PLAN_ID
               ,BOM.SCM_SITE_ID+'::'+BOM.ITEM_ID+'::'+BOM.STAGE_BUFFER+'::'+ISNULL(RR.LINE_ID,'-')+'::'+ISNULL(RR.START_DATE,'-') AS ROUTING_ID
               ,CONVERT(NUMERIC(20,0),0)        AS OP_SEQ
               ,MAX(CONVERT(NUMERIC(20,0),ISNULL(LT1.LT, LT2.LT))) AS LEAD_TIME
            --    ,CONVERT(NUMERIC(20,0),0)        AS LEAD_TIME
               ,CONVERT(NUMERIC(20,4),MAX(ISNULL(SI.YIELD,1))) AS YIELD
               ,BOM.SCM_SITE_ID                 AS SITE_ID
               ,BOM.ITEM_ID                     AS ITEM_ID
               ,BOM.STAGE                       AS STAGE
               ,BOM.STAGE_BUFFER                AS STAGE_BUFFER
               ,RR.LINE_ID                      AS LINE_ID
               ,RR.MONTH                        AS MONTH
        FROM(
            SELECT  BOM.ATTRIBUTE1 AS SCM_SITE_ID
                   ,BOM.ATTRIBUTE2 AS ITEM_ID
                   ,BOM.ATTRIBUTE4 AS STAGE_BUFFER
                   ,BOM.ATTRIBUTE3 AS STAGE
            FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
            WHERE   BOM.PLAN_ID = @V_PLAN_ID
            UNION ALL
            SELECT  BOM.ATTRIBUTE1  AS SCM_SITE_ID
                   ,BOM.ATTRIBUTE14 AS ITEM_ID
                   ,BOM.ATTRIBUTE13 AS STAGE_BUFFER
                   ,BOM.ATTRIBUTE15 AS STAGE       
            FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
            WHERE   BOM.PLAN_ID = @V_PLAN_ID
            AND     BOM.ATTRIBUTE3 = 'ASSY'
            ) BOM

			-- Tact Time (ROUTING_RESOURCE) 존재하는 정보
			INNER JOIN (
				SELECT  DISTINCT ATTRIBUTE1 AS SCM_SITE_ID, ATTRIBUTE2 AS ITEM_ID, ATTRIBUTE4 AS STAGE_BUFFER
				               , ATTRIBUTE14 AS MONTH, ATTRIBUTE15 AS LINE_ID, START_DATE AS START_DATE
				FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN WITH(NOLOCK)
				WHERE   1=1
				AND     PLAN_ID = @V_PLAN_ID
				AND     RESOURCE_CLASS_ID = 'LINE'
			 ) RR
            ON  BOM.SCM_SITE_ID  = RR.SCM_SITE_ID
            AND BOM.ITEM_ID      = RR.ITEM_ID
            AND BOM.STAGE_BUFFER = RR.STAGE_BUFFER
			
            --STK는 SCM_MST_SITE_ITEM_PRIORITY 정보가 없어서 주석처리
            --INNER HASH JOIN SCM_MST_SITE_ITEM_PRIORITY PR WITH(NOLOCK)
            --ON  PR.DIVISION_ID  = @V_DIVISION_ID
            --AND PR.VALID_YN     = 'Y'
            --AND BOM.ITEM_ID     = PR.ITEM_ID
            --AND BOM.SCM_SITE_ID = PR.PLANT_SITE_ID
            --AND PR.TO_YYYYMMDD >= @P_PLAN_NAME

            INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
            ON  @V_DIVISION_ID   = S.DIVISION_ID
            AND BOM.SCM_SITE_ID  = S.SCM_SITE_ID
            AND S.SITE_TYPE      = 'PLANT'
            AND S.VALID_YN       = 'Y'

			LEFT OUTER JOIN(
					/*ASSY */
					SELECT  MY.PLANT_ID , MY.LINE_ID, MY.ITEM_ID, MY.MONTH, 0 AS LT, MAX(MY.YIELD) AS YIELD
						  ,CASE WHEN MY.OPERATION_ID IN ('A8000') THEN 'STK'
								WHEN MY.OPERATION_ID IN ('A9000') THEN 'ASSY'
								WHEN MY.OPERATION_ID IN ('F6000') THEN 'EOL'
						   END AS STAGE
					FROM    SCM_MST_YIELD_SN MY WITH(NOLOCK)
                    INNER JOIN SCM_MST_SITE ST WITH(NOLOCK)
                        ON ST.DIVISION_ID       = MY.DIVISION_ID
                        AND ST.PLANT_ID         = MY.PLANT_ID
                        AND ST.SITE_ID          = MY.SITE_ID
                        AND ST.SITE_TYPE        = 'PLANT'
                        AND ST.VALID_YN         = 'Y'
                        AND ST.OPERATION_GROUP  = 'A'
                    INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                        ON  ML.PLAN_ID     = @V_PLAN_ID
                        AND ML.SCM_SITE_ID = ST.SCM_SITE_ID
                        AND ML.ITEM_ID     = MY.ITEM_ID
                        AND ML.ITEM_CLASS_ID = CASE WHEN MY.OPERATION_ID IN ('A8000') THEN 'STK'
                                                    WHEN MY.OPERATION_ID IN ('A9000') THEN 'ASSY'
                                                    WHEN MY.OPERATION_ID IN ('F6000') THEN 'EOL'
                                                END
					WHERE   MY.DIVISION_ID  = @V_DIVISION_ID
					AND     MY.OPERATION_ID IN ('A8000', 'A9000', 'F6000')
					AND     MY.MONTH BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
                    GROUP BY MY.PLANT_ID , MY.LINE_ID, MY.ITEM_ID, MY.MONTH, CASE WHEN MY.OPERATION_ID IN ('A8000') THEN 'STK'
                                                                                    WHEN MY.OPERATION_ID IN ('A9000') THEN 'ASSY'
                                                                                    WHEN MY.OPERATION_ID IN ('F6000') THEN 'EOL'
                                                                            END
                ) SI
			ON  S.PLANT_ID  = SI.PLANT_ID
			AND BOM.ITEM_ID = SI.ITEM_ID
			AND BOM.STAGE   = SI.STAGE
			AND RR.LINE_ID  = SI.LINE_ID
			AND RR.MONTH    = SI.MONTH
            LEFT OUTER JOIN ( 
                        SELECT   SEGMENT4   AS SCM_SITE_ID
                                ,SEGMENT5   AS STAGE
                                ,SEGMENT6   AS ITEM_ID
                                ,ATTRIBUTE1 AS LT
                        FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                        WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_ELEC_OPERATION_LT'
                        AND    LU.VALID_YN    = 'Y'
                        AND    LU.SEGMENT2    = @V_DIVISION_ID
                        AND    LU.SEGMENT3    = @V_GROUP_ID
                        AND    LU.SEGMENT6   != '-'
                            ) LT1
                ON  LT1.SCM_SITE_ID = BOM.SCM_SITE_ID
                AND LT1.STAGE       = BOM.STAGE
                AND LT1.ITEM_ID     = BOM.ITEM_ID
            LEFT OUTER JOIN ( 
                                SELECT   SEGMENT4   AS SCM_SITE_ID
                                        ,SEGMENT5   AS STAGE
                                        ,SEGMENT6   AS ITEM_ID
                                        ,ATTRIBUTE1 AS LT
                                FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_ELEC_OPERATION_LT'
                                AND    LU.VALID_YN    = 'Y'
                                AND    LU.SEGMENT2    = @V_DIVISION_ID
                                AND    LU.SEGMENT3    = @V_GROUP_ID
                                AND    LU.SEGMENT6    = '-'
                            ) LT2
                ON  LT2.SCM_SITE_ID = BOM.SCM_SITE_ID
                AND LT2.STAGE       = BOM.STAGE
        WHERE 1=1
        GROUP BY BOM.SCM_SITE_ID, BOM.ITEM_ID, BOM.STAGE,BOM.STAGE_BUFFER, RR.LINE_ID, RR.MONTH, RR.START_DATE



        -- PRINT N'STEP 2:: 비 Line 정보 Insert ' + CONVERT(NVARCHAR, SYSDATETIME(), 114);
        ------------------------------------------------------------------------
        -- 2. 비 Line 정보 Insert
        ------------------------------------------------------------------------
            ------------------------------------------------------------------------
            -- 2-1. BASE DATA INSERT 
            ------------------------------------------------------------------------
            INSERT INTO @BASE_DATA
            SELECT  @V_PLAN_ID                                AS PLAN_ID
                   ,CONVERT(NUMERIC(20,0),0)                  AS OP_SEQ
                --    ,CONVERT(NUMERIC(20,0),MAX(ISNULL(FL.LT,0)))    AS LEAD_TIME
                   ,MAX(CONVERT(NUMERIC(20,0),ISNULL(ISNULL(FL.LT, LT1.LT), LT2.LT))) AS LEAD_TIME
                   ,CONVERT(NUMERIC(20,4),MAX(ISNULL(FY.YIELD,1))) AS YIELD
                   ,BOM.SCM_SITE_ID                           AS SITE_ID
                   ,BOM.ITEM_ID                               AS ITEM_ID
                   ,BOM.STAGE                                 AS STAGE
                   ,BOM.STAGE_BUFFER                          AS STAGE_BUFFER
                   ,SI.LINE_ID                                AS LINE_ID
                   ,SI.MONTH                                  AS MONTH
                   ,IIF(FL.SCM_SITE_ID IS NOT NULL, 'Y','N')  AS FL_LOOKUP_YN
                   ,IIF(FY.SCM_SITE_ID IS NOT NULL, 'Y','N')  AS FY_LOOKUP_YN
            FROM(
                SELECT  BOM.ATTRIBUTE1 AS SCM_SITE_ID
                       ,BOM.ATTRIBUTE2 AS ITEM_ID
                       ,BOM.ATTRIBUTE3 AS STAGE
                       ,BOM.ATTRIBUTE4 AS STAGE_BUFFER
                FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                WHERE   BOM.PLAN_ID     = @V_PLAN_ID
                AND     BOM.ATTRIBUTE3 IN ('CHAR','B_DEGAS','A_DEGAS')
                ) BOM
		    	
                INNER JOIN SCM_MST_SITE_ITEM_PRIORITY PR WITH(NOLOCK)
                ON  PR.DIVISION_ID   = @V_DIVISION_ID
                AND PR.VALID_YN      = 'Y'
                AND PR.ITEM_ID       = BOM.ITEM_ID
                AND PR.PLANT_SITE_ID = BOM.SCM_SITE_ID
                AND PR.TO_YYYYMMDD  >= @P_PLAN_NAME

                INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
                ON  @V_DIVISION_ID   = S.DIVISION_ID
                AND BOM.SCM_SITE_ID  = S.SCM_SITE_ID
                AND S.SITE_TYPE      = 'PLANT'
                AND S.VALID_YN       = 'Y'
                --질문 : GM의 ASY_AGING도 SCP_MST_FORMATION_V 을 봐도 되는지
		    	LEFT OUTER JOIN(
                                SELECT SUBSTRING(FR.PLANT_SITE_ID,1,4)                        AS PLANT_ID
                                      ,NULL                                                   AS LINE_ID
                                      ,FR.ITEM_ID                                             AS ITEM_ID
                                      ,NULL                                                   AS MONTH
                                      ,FR.TOTAL_LT_FORMATION                                  AS LT
                                      ,ISNULL(FR.SSP_MODIFY_YIELD, FR.FORMATION_TOTAL_YIELD) AS YIELD
                                      ,ML.STAGE AS STAGE
                                FROM SCP_MST_FORMATION_V FR WITH(NOLOCK)
                                    INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                                        ON  ML.PLAN_ID = @V_PLAN_ID
                                        AND FR.PLANT_SITE_ID = ML.SCM_SITE_ID
                                        AND FR.ITEM_ID       = ML.ITEM_ID
                                WHERE FR.DIVISION_ID = @V_DIVISION_ID
                                GROUP BY SUBSTRING(FR.PLANT_SITE_ID,1,4), FR.ITEM_ID, FR.SSP_MODIFY_YIELD, FR.FORMATION_TOTAL_YIELD, ML.STAGE, FR.TOTAL_LT_FORMATION
                    ) SI
		    	ON  S.PLANT_ID  = SI.PLANT_ID
		    	AND BOM.ITEM_ID = SI.ITEM_ID
		    	AND BOM.STAGE   = SI.STAGE
                --질문 : GM의 ASY_AGING "SCP_OPT_ENG_CONST_FORMATION_LT" 을 보는지-> 정리 필요
                LEFT OUTER JOIN(
                                SELECT  FL.SEGMENT3   AS SCM_SITE_ID
                                       ,FL.SEGMENT5   AS ITEM_ID
                                       ,FL.ATTRIBUTE3 AS START_TIME
                                       ,FL.ATTRIBUTE4 AS END_TIME
                                       ,ML.STAGE      AS STAGE
                                       ,CASE WHEN ML.ITEM_CLASS_ID = 'B_DEGAS' THEN FL.ATTRIBUTE5
                                             WHEN ML.ITEM_CLASS_ID = 'A_DEGAS' THEN FL.ATTRIBUTE6
                                        END           AS LT
                                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL FL WITH(NOLOCK)
                                    INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                                        ON  ML.PLAN_ID  = @V_PLAN_ID
                                        AND FL.SEGMENT3 = ML.SCM_SITE_ID
                                        AND FL.SEGMENT5 = ML.ITEM_ID
                                WHERE   FL.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_FORMATION_LT'
                                AND     FL.SEGMENT2    = @V_DIVISION_ID
                                AND     FL.VALID_YN    = 'Y'
                                AND     ML.ITEM_CLASS_ID IN ('B_DEGAS', 'A_DEGAS')
                ) FL
                    ON  BOM.SCM_SITE_ID     = FL.SCM_SITE_ID
                    AND BOM.ITEM_ID         = FL.ITEM_ID
                    AND BOM.STAGE_BUFFER    = FL.STAGE
                LEFT OUTER JOIN(
          --                     SELECT  SEGMENT3   AS SCM_SITE_ID
          --                            ,SEGMENT4   AS ITEM_ID
          --                            ,ATTRIBUTE3 AS YIELD
          --                            ,ATTRIBUTE1 AS START_TIME
          --                            ,ATTRIBUTE2 AS END_TIME
          --                            ,SEGMENT5   AS STAGE
          --                     FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
          --                     WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_FORMATION_PERIOD_YIELD'
          --                     AND     SEGMENT2    = @V_DIVISION_ID
          --                     AND     VALID_YN    = 'Y'
							   --AND     SEGMENT5    IN('CHAR')

                                -- 2025.12.03 Minyong Lee : Lookup -> UI 전환 (활성화 YIELD)
                                SELECT  BOM.ATTRIBUTE1          AS SCM_SITE_ID
                                      , BOM.ATTRIBUTE2          AS ITEM_ID
                                      , F.FORMATION_TOTAL_YIELD AS YIELD
                                      , F.FORMATION_START_DATE  AS START_TIME
                                      , F.FORMATION_END_DATE    AS END_TIME
                                      , BOM.ATTRIBUTE3          AS STAGE
                                FROM    SCP_MST_FORMATION_EXCEPT F WITH(NOLOCK)
                                    INNER JOIN  (
                                                SELECT  *
                                                FROM    SCP_OPT_ENG_BOM_SN WITH(NOLOCK)
                                                WHERE   1=1
                                                AND     PLAN_ID = @V_PLAN_ID
                                                AND     ATTRIBUTE3 = 'CHAR'
                                                ) BOM
                                        ON  F.ITEM_ID   = BOM.ATTRIBUTE14
                                WHERE   1=1
                                AND     F.DIVISION_ID = @V_DIVISION_ID
                ) FY
                    ON  BOM.SCM_SITE_ID = FY.SCM_SITE_ID
                    AND BOM.ITEM_ID     = FY.ITEM_ID
                    AND BOM.STAGE       = FY.STAGE
                LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL OCV WITH(NOLOCK)
                    ON  OCV.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                    AND OCV.SEGMENT2    = @V_DIVISION_ID
                    AND OCV.SEGMENT3    = @V_GROUP_ID
                    AND BOM.SCM_SITE_ID = OCV.SEGMENT4
                    AND BOM.ITEM_ID     = OCV.SEGMENT5
                    AND BOM.STAGE       = OCV.ATTRIBUTE3
            LEFT OUTER JOIN ( 
                        SELECT   SEGMENT4   AS SCM_SITE_ID
                                ,SEGMENT5   AS STAGE
                                ,SEGMENT6   AS ITEM_ID
                                ,ATTRIBUTE1 AS LT
                        FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                        WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_ELEC_OPERATION_LT'
                        AND    LU.VALID_YN    = 'Y'
                        AND    LU.SEGMENT2    = @V_DIVISION_ID
                        AND    LU.SEGMENT3    = @V_GROUP_ID
                        AND    LU.SEGMENT6   != '-'
                            ) LT1
                ON  LT1.SCM_SITE_ID = BOM.SCM_SITE_ID
                AND LT1.STAGE       = BOM.STAGE
                AND LT1.ITEM_ID     = BOM.ITEM_ID
            LEFT OUTER JOIN ( 
                                SELECT   SEGMENT4   AS SCM_SITE_ID
                                        ,SEGMENT5   AS STAGE
                                        ,SEGMENT6   AS ITEM_ID
                                        ,ATTRIBUTE1 AS LT
                                FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_ELEC_OPERATION_LT'
                                AND    LU.VALID_YN    = 'Y'
                                AND    LU.SEGMENT2    = @V_DIVISION_ID
                                AND    LU.SEGMENT3    = @V_GROUP_ID
                                AND    LU.SEGMENT6    = '-'
                            ) LT2
                ON  LT2.SCM_SITE_ID = BOM.SCM_SITE_ID
                AND LT2.STAGE       = BOM.STAGE
            -- 비 라인 STAGE
            WHERE BOM.STAGE NOT IN (
		    						SELECT  DISTINCT ATTRIBUTE3
		    						FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN WITH(NOLOCK)
		    						WHERE   1=1
		    						AND     PLAN_ID = @V_PLAN_ID
		    						AND     RESOURCE_CLASS_ID = 'LINE'
		    					  ) 
            AND   OCV.SEGMENT1 IS NULL
            GROUP BY BOM.SCM_SITE_ID, BOM.ITEM_ID, BOM.STAGE, BOM.STAGE_BUFFER, SI.LINE_ID, SI.MONTH, FL.SCM_SITE_ID, FY.SCM_SITE_ID

            -- PRINT N'STEP 3:: LOOK UP에 정의된 데이터와 정의되지 않은 데이터 나눠서 INSERT ' + CONVERT(NVARCHAR, SYSDATETIME(), 114);
            ------------------------------------------------------------------------
            -- 2-2. LOOK UP에 정의된 데이터와 정의되지 않은 데이터 나눠서 INSERT
            ------------------------------------------------------------------------
            INSERT INTO SCP_OPT_ENG_ROUTING_SN   (PLAN_ID
                                        ,ROUTING_ID
                                        ,OP_SEQ
                                        ,LEAD_TIME
                                        ,YIELD
                                        ,ATTRIBUTE1
                                        ,ATTRIBUTE2
                                        ,ATTRIBUTE3
                                        ,ATTRIBUTE4
                                        ,ATTRIBUTE14
                                        ,ATTRIBUTE15
                                        ,ATTRIBUTE12
                                        ,ATTRIBUTE13
                                        )
            -- 1. Fromation LT Look Up 정의 정보
            SELECT PLAN_ID
            ,SITE_ID+'::'+ITEM_ID+'::'+STAGE_BUFFER+'::'+ISNULL(LINE_ID,'-')+'::'+ISNULL(MIN(YYYYMMDD),'-')
            ,OP_SEQ
            ,ISNULL(LOOKUP_LT,LEAD_TIME) AS LEAD_TIME
            ,YIELD
            ,SITE_ID
            ,ITEM_ID
            ,STAGE
            ,STAGE_BUFFER
            ,LINE_ID
            ,MONTH
            ,MIN(YYYYMMDD) AS MIN
            ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(YYYYMMDD)),112) AS MAX
            FROM(
                --LT LOOKUP에 정의되지 않은 날짜 GROUP
                SELECT BD1.PLAN_ID
                      ,BD1.OP_SEQ
                      ,BD1.LEAD_TIME
                      ,BD1.YIELD
                      ,BD1.SITE_ID
                      ,BD1.ITEM_ID
                      ,BD1.STAGE
                      ,BD1.STAGE_BUFFER
                      ,BD1.LINE_ID
                      ,BD1.MONTH
                      ,BD1.LOOKUP_LT
                      ,BD1.BASIS_YYYYMMDD AS YYYYMMDD
                      ,'B_'+CONVERT(NVARCHAR(8),DATEADD(DAY,-ROW_NUMBER() OVER(PARTITION BY BD1.SITE_ID, BD1.ITEM_ID, BD1.STAGE_BUFFER ORDER BY BD1.BASIS_YYYYMMDD),BD1.BASIS_YYYYMMDD),112) AS DIVIDE
                FROM(
                     SELECT BD.PLAN_ID
                           ,BD.OP_SEQ
                           ,BD.LEAD_TIME
                           ,BD.YIELD
                           ,BD.SITE_ID
                           ,BD.ITEM_ID
                           ,BD.STAGE
                           ,BD.STAGE_BUFFER
                           ,BD.LINE_ID
                           ,BD.MONTH
                           ,NULL AS LOOKUP_LT
                           ,CAL.BASIS_YYYYMMDD
                     FROM @BASE_DATA BD
                         LEFT OUTER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)	
                             ON  CAL.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD_V2
                     WHERE BD.FL_LOOKUP_YN = 'Y'
                     ) BD1
                    LEFT OUTER JOIN(
                                    SELECT BD.PLAN_ID
                                          ,BD.OP_SEQ
                                          ,BD.LEAD_TIME
                                          ,BD.YIELD
                                          ,BD.SITE_ID
                                          ,BD.ITEM_ID
                                          ,BD.STAGE
                                          ,BD.STAGE_BUFFER
                                          ,BD.LINE_ID
                                          ,BD.MONTH
                                          ,FL.LT AS LOOKUP_LT
                                          ,CAL.BASIS_YYYYMMDD
                                    FROM @BASE_DATA BD
                                    LEFT OUTER JOIN(
                                                    SELECT  FL.SEGMENT3   AS SCM_SITE_ID
                                                            ,FL.SEGMENT5   AS ITEM_ID
                                                            ,FL.ATTRIBUTE3 AS START_TIME
                                                            ,FL.ATTRIBUTE4 AS END_TIME
                                                            ,ML.STAGE      AS STAGE
                                                            ,CASE WHEN ML.ITEM_CLASS_ID = 'B_DEGAS' THEN FL.ATTRIBUTE5
                                                                    WHEN ML.ITEM_CLASS_ID = 'A_DEGAS' THEN FL.ATTRIBUTE6
                                                            END           AS LT
                                                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL FL WITH(NOLOCK)
                                                        INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                                                            ON  ML.PLAN_ID  = @V_PLAN_ID
                                                            AND FL.SEGMENT3 = ML.SCM_SITE_ID
                                                            AND FL.SEGMENT5 = ML.ITEM_ID
                                                    WHERE   FL.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_FORMATION_LT'
                                                    AND     FL.SEGMENT2    = @V_DIVISION_ID
                                                    AND     FL.VALID_YN    = 'Y'
                                                    AND     ML.ITEM_CLASS_ID IN ('A_DEGAS','B_DEGAS')
                                            ) FL
                                        ON  BD.SITE_ID      = FL.SCM_SITE_ID
                                        AND BD.ITEM_ID      = FL.ITEM_ID
                                        AND BD.STAGE_BUFFER = FL.STAGE
                                        AND BD.STAGE       IN ('A_DEGAS','B_DEGAS')
                                        LEFT OUTER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)	
                                            ON  CAL.BASIS_YYYYMMDD BETWEEN FL.START_TIME AND FL.END_TIME
                                    WHERE BD.FL_LOOKUP_YN = 'Y'
                                    )BD2
                        ON  BD1.PLAN_ID            = BD2.PLAN_ID           
                        AND BD1.OP_SEQ             = BD2.OP_SEQ            
                        AND BD1.LEAD_TIME          = BD2.LEAD_TIME         
                        AND BD1.YIELD              = BD2.YIELD             
                        AND BD1.SITE_ID            = BD2.SITE_ID           
                        AND BD1.ITEM_ID            = BD2.ITEM_ID           
                        AND BD1.STAGE              = BD2.STAGE             
                        AND BD1.STAGE_BUFFER       = BD2.STAGE_BUFFER
                        AND ISNULL(BD1.LINE_ID,'') = ISNULL(BD2.LINE_ID,'')
                        AND ISNULL(BD1.MONTH,'')   = ISNULL(BD2.MONTH,'')  
                        AND BD1.BASIS_YYYYMMDD     = BD2.BASIS_YYYYMMDD
                WHERE BD2.BASIS_YYYYMMDD IS NULL
                UNION ALL
                --LT LOOKUP에 정의된 날짜 GROUP
                SELECT BD.PLAN_ID
                      ,BD.OP_SEQ
                      ,BD.LEAD_TIME
                      ,BD.YIELD
                      ,BD.SITE_ID
                      ,BD.ITEM_ID
                      ,BD.STAGE
                      ,BD.STAGE_BUFFER
                      ,BD.LINE_ID
                      ,BD.MONTH
                      ,FL.LT AS LOOKUP_LT
                      ,CAL.BASIS_YYYYMMDD
                      ,'A_'+CONVERT(NVARCHAR(8),DATEADD(DAY,-ROW_NUMBER() OVER(PARTITION BY BD.SITE_ID, BD.ITEM_ID, BD.STAGE_BUFFER ORDER BY CAL.BASIS_YYYYMMDD),CAL.BASIS_YYYYMMDD),112) AS DIVIDE
                FROM @BASE_DATA BD
                    LEFT OUTER JOIN(
                                    SELECT  FL.SEGMENT3   AS SCM_SITE_ID
                                           ,FL.SEGMENT5   AS ITEM_ID
                                           ,FL.ATTRIBUTE3 AS START_TIME
                                           ,FL.ATTRIBUTE4 AS END_TIME
                                           ,ML.STAGE      AS STAGE
                                           ,CASE WHEN ML.ITEM_CLASS_ID = 'B_DEGAS' THEN FL.ATTRIBUTE5
                                                 WHEN ML.ITEM_CLASS_ID = 'A_DEGAS' THEN FL.ATTRIBUTE6
                                            END           AS LT
                                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL FL WITH(NOLOCK)
                                        INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                                            ON  ML.PLAN_ID  = @V_PLAN_ID
                                            AND FL.SEGMENT3 = ML.SCM_SITE_ID
                                            AND FL.SEGMENT5 = ML.ITEM_ID
                                    WHERE   FL.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_FORMATION_LT'
                                    AND     FL.SEGMENT2    = @V_DIVISION_ID
                                    AND     FL.VALID_YN    = 'Y'
                                    AND     ML.ITEM_CLASS_ID IN ('A_DEGAS','B_DEGAS')
                    ) FL
                        ON  BD.SITE_ID      = FL.SCM_SITE_ID
                        AND BD.ITEM_ID      = FL.ITEM_ID
                        AND BD.STAGE_BUFFER = FL.STAGE
                        AND BD.STAGE       IN ('A_DEGAS','B_DEGAS')
                    LEFT OUTER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)	
                        ON  CAL.BASIS_YYYYMMDD BETWEEN FL.START_TIME AND FL.END_TIME
                WHERE BD.FL_LOOKUP_YN = 'Y'
                ) FL
                WHERE YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD_V2
            GROUP BY PLAN_ID, OP_SEQ, LEAD_TIME, YIELD, SITE_ID, ITEM_ID, STAGE, STAGE_BUFFER, LINE_ID, MONTH, LOOKUP_LT, DIVIDE
			
            -- 2. CHAR YIELD Look Up 정의 정보
            UNION ALL
            SELECT PLAN_ID
            ,SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+ISNULL(LINE_ID,'-')+'::'+ISNULL(MIN(YYYYMMDD),'-')
            ,OP_SEQ
            ,LEAD_TIME
            ,ISNULL(LOOKUP_YIELD,YIELD) AS YIELD
            ,SITE_ID
            ,ITEM_ID
            ,STAGE
            ,STAGE_BUFFER
            ,LINE_ID
            ,MONTH
            ,MIN(YYYYMMDD) AS MIN
            ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(YYYYMMDD)),112) AS MAX
            FROM(
                --YIELD LOOKUP에 정의되지 않은 날짜 GROUP
                SELECT BD1.PLAN_ID
                      ,BD1.OP_SEQ
                      ,BD1.LEAD_TIME
                      ,BD1.YIELD
                      ,BD1.SITE_ID
                      ,BD1.ITEM_ID
                      ,BD1.STAGE
                      ,BD1.STAGE_BUFFER
                      ,BD1.LINE_ID
                      ,BD1.MONTH
                      ,BD1.LOOKUP_YIELD
                      ,BD1.BASIS_YYYYMMDD AS YYYYMMDD
                      ,'B_'+CONVERT(NVARCHAR(8),DATEADD(DAY,-ROW_NUMBER() OVER(PARTITION BY BD1.SITE_ID, BD1.ITEM_ID ORDER BY BD1.BASIS_YYYYMMDD),BD1.BASIS_YYYYMMDD),112) AS DIVIDE
                FROM(
                     SELECT BD.PLAN_ID
                           ,BD.OP_SEQ
                           ,BD.LEAD_TIME
                           ,BD.YIELD
                           ,BD.SITE_ID
                           ,BD.ITEM_ID
                           ,BD.STAGE
                           ,BD.STAGE_BUFFER
                           ,BD.LINE_ID
                           ,BD.MONTH
                           ,NULL AS LOOKUP_YIELD
                           ,CAL.BASIS_YYYYMMDD
                     FROM @BASE_DATA BD
                         LEFT OUTER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)	
                             ON  CAL.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD_V2
                     WHERE BD.FY_LOOKUP_YN = 'Y'
                     ) BD1
                    LEFT OUTER JOIN(
                                    SELECT BD.PLAN_ID
                                          ,BD.OP_SEQ
                                          ,BD.LEAD_TIME
                                          ,BD.YIELD
                                          ,BD.SITE_ID
                                          ,BD.ITEM_ID
                                          ,BD.STAGE
                                          ,BD.STAGE_BUFFER
                                          ,BD.LINE_ID
                                          ,BD.MONTH
                                          ,FY.YIELD AS LOOKUP_YIELD
                                          ,CAL.BASIS_YYYYMMDD
                                    FROM @BASE_DATA BD
                                        LEFT OUTER JOIN(
              --                                 SELECT  SEGMENT3   AS SCM_SITE_ID
													 -- ,SEGMENT4   AS ITEM_ID
													 -- ,ATTRIBUTE3 AS YIELD
													 -- ,ATTRIBUTE1 AS START_TIME
													 -- ,ATTRIBUTE2 AS END_TIME
													 -- ,SEGMENT5   AS STAGE
											   --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
											   --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_FORMATION_PERIOD_YIELD'
              --                                 AND     SEGMENT2    = @V_DIVISION_ID
              --                                 AND     VALID_YN    = 'Y'
											   --AND     SEGMENT5    IN('CHAR')

                                                -- 2025.12.03 Minyong Lee : Lookup -> UI 전환 (활성화 YIELD)
                                                SELECT  BOM.ATTRIBUTE1          AS SCM_SITE_ID
                                                      , BOM.ATTRIBUTE2          AS ITEM_ID
                                                      , F.FORMATION_TOTAL_YIELD AS YIELD
                                                      , F.FORMATION_START_DATE  AS START_TIME
                                                      , F.FORMATION_END_DATE    AS END_TIME
                                                      , BOM.ATTRIBUTE3          AS STAGE
                                                FROM    SCP_MST_FORMATION_EXCEPT F WITH(NOLOCK)
                                                    INNER JOIN  (
                                                                SELECT  *
                                                                FROM    SCP_OPT_ENG_BOM_SN WITH(NOLOCK)
                                                                WHERE   1=1
                                                                AND     PLAN_ID = @V_PLAN_ID
                                                                AND     ATTRIBUTE3 = 'CHAR'
                                                                ) BOM
                                                        ON  F.ITEM_ID   = BOM.ATTRIBUTE14
                                                WHERE   1=1
                                                AND     F.DIVISION_ID = @V_DIVISION_ID
                                        ) FY
                                            ON  BD.SITE_ID = FY.SCM_SITE_ID
                                            AND BD.ITEM_ID = FY.ITEM_ID
                                            AND BD.STAGE   = FY.STAGE
                                        LEFT OUTER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)	
                                            ON  CAL.BASIS_YYYYMMDD BETWEEN FY.START_TIME AND FY.END_TIME
                                    WHERE BD.FY_LOOKUP_YN = 'Y'
                                    )BD2
                        ON  BD1.PLAN_ID            = BD2.PLAN_ID           
                        AND BD1.OP_SEQ             = BD2.OP_SEQ            
                        AND BD1.LEAD_TIME          = BD2.LEAD_TIME         
                        AND BD1.YIELD              = BD2.YIELD             
                        AND BD1.SITE_ID            = BD2.SITE_ID           
                        AND BD1.ITEM_ID            = BD2.ITEM_ID           
                        AND BD1.STAGE              = BD2.STAGE             
                        AND BD1.STAGE_BUFFER       = BD2.STAGE_BUFFER             
                        AND ISNULL(BD1.LINE_ID,'') = ISNULL(BD2.LINE_ID,'')
                        AND ISNULL(BD1.MONTH,'')   = ISNULL(BD2.MONTH,'')  
                        AND BD1.BASIS_YYYYMMDD     = BD2.BASIS_YYYYMMDD
                WHERE BD2.BASIS_YYYYMMDD IS NULL
                UNION ALL
                --YIELD LOOKUP에 정의된 날짜 GROUP
                SELECT BD.PLAN_ID
                      ,BD.OP_SEQ
                      ,BD.LEAD_TIME
                      ,BD.YIELD
                      ,BD.SITE_ID
                      ,BD.ITEM_ID
                      ,BD.STAGE
                      ,BD.STAGE_BUFFER
                      ,BD.LINE_ID
                      ,BD.MONTH
                      ,FY.YIELD AS LOOKUP_YIELD
                      ,CAL.BASIS_YYYYMMDD
                      ,'A_'+CONVERT(NVARCHAR(8),DATEADD(DAY,-ROW_NUMBER() OVER(PARTITION BY BD.SITE_ID, BD.ITEM_ID ORDER BY CAL.BASIS_YYYYMMDD),CAL.BASIS_YYYYMMDD),112) AS DIVIDE
                FROM @BASE_DATA BD
                    LEFT OUTER JOIN(
         --                           SELECT  SEGMENT3   AS SCM_SITE_ID
									--		,SEGMENT4   AS ITEM_ID
									--		,ATTRIBUTE3 AS YIELD
									--		,ATTRIBUTE1 AS START_TIME
									--		,ATTRIBUTE2 AS END_TIME
									--		,SEGMENT5   AS STAGE
									--FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
									--WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_FORMATION_PERIOD_YIELD'
         --                           AND     SEGMENT2    = @V_DIVISION_ID
         --                           AND     VALID_YN    = 'Y'
									--AND     SEGMENT5    IN('CHAR')

                                    -- 2025.12.03 Minyong Lee : Lookup -> UI 전환 (활성화 YIELD)
                                    SELECT  BOM.ATTRIBUTE1          AS SCM_SITE_ID
                                          , BOM.ATTRIBUTE2          AS ITEM_ID
                                          , F.FORMATION_TOTAL_YIELD AS YIELD
                                          , F.FORMATION_START_DATE  AS START_TIME
                                          , F.FORMATION_END_DATE    AS END_TIME
                                          , BOM.ATTRIBUTE3          AS STAGE
                                    FROM    SCP_MST_FORMATION_EXCEPT F WITH(NOLOCK)
                                        INNER JOIN  (
                                                    SELECT  *
                                                    FROM    SCP_OPT_ENG_BOM_SN WITH(NOLOCK)
                                                    WHERE   1=1
                                                    AND     PLAN_ID = @V_PLAN_ID
                                                    AND     ATTRIBUTE3 = 'CHAR'
                                                    ) BOM
                                            ON  F.ITEM_ID   = BOM.ATTRIBUTE14
                                    WHERE   1=1
                                    AND     F.DIVISION_ID = @V_DIVISION_ID
                    ) FY
                        ON  BD.SITE_ID = FY.SCM_SITE_ID
                        AND BD.ITEM_ID = FY.ITEM_ID
                        AND BD.STAGE   = FY.STAGE
                    LEFT OUTER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)	
                        ON  CAL.BASIS_YYYYMMDD BETWEEN FY.START_TIME AND FY.END_TIME
                WHERE BD.FY_LOOKUP_YN = 'Y'
                ) FL
                WHERE YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD_V2
            GROUP BY PLAN_ID, OP_SEQ, LEAD_TIME, YIELD, SITE_ID, ITEM_ID, STAGE, STAGE_BUFFER, LINE_ID, MONTH, LOOKUP_YIELD, DIVIDE

            -- 3. LOOK UP에 등록되지 않은 데이터 INSERT
            UNION ALL
            SELECT PLAN_ID
                  ,SITE_ID+'::'+ITEM_ID+'::'+STAGE_BUFFER+'::'+ISNULL(LINE_ID,'-')+'::'+ISNULL(MONTH,'-')
                  ,OP_SEQ
                  ,LEAD_TIME AS LEAD_TIME
                  ,YIELD
                  ,SITE_ID
                  ,ITEM_ID
                  ,STAGE
                  ,STAGE_BUFFER
                  ,LINE_ID
                  ,MONTH
                  ,NULL AS MIN
                  ,NULL AS MAX
            FROM @BASE_DATA WHERE (FL_LOOKUP_YN ='N' AND FY_LOOKUP_YN ='N')

        ------------------------------------------------------------------------
        -- LINE FULL LOADING 제약이 있으면 DINAMIC RAMP UP 적용을 위해 IDLE 데이터 추가
        -- 2025-07-29 THK
        -- 2025.09.19 Philsu Park: Multi Stage 활성화 시 Key Error 방지
        ------------------------------------------------------------------------ 
        INSERT INTO SCP_OPT_ENG_ROUTING_SN(PLAN_ID
                                          ,ROUTING_ID
                                          ,OP_SEQ
                                          ,LEAD_TIME
                                          ,YIELD
                                          ,ATTRIBUTE1
                                          ,ATTRIBUTE2
                                          ,ATTRIBUTE3
                                          )
        SELECT  DISTINCT 
                @V_PLAN_ID              AS PLAN_ID
               ,SEGMENT3+'::IDLE::IDLE' AS ROUTING_ID
               ,0                       AS OP_SEQ
               ,0                       AS LEAD_TIME
               ,1                       AS YIELD
               ,SEGMENT3                AS ATTRIBUTE1
               ,'IDLE'                  AS ATTRIBUTE2
               ,'IDLE'                  AS ATTRIBUTE3
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK) 
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_LINE'
        AND     SEGMENT1    = @V_DIVISION_ID
        AND     SEGMENT2    = @V_GROUP_ID
        AND     LU.VALID_YN = 'Y'

        ------------------------------------------------------------------------
        -- EQUIPMENT FULL LOADING 제약이 있으면 DINAMIC RAMP UP 적용을 위해 IDLE 데이터 추가
        -- 2025-08-06 THK
        ------------------------------------------------------------------------ 
        INSERT INTO SCP_OPT_ENG_ROUTING_SN(PLAN_ID
                                          ,ROUTING_ID
                                          ,OP_SEQ
                                          ,LEAD_TIME
                                          ,YIELD
                                          ,ATTRIBUTE1
                                          ,ATTRIBUTE2
                                          ,ATTRIBUTE3
                                          ,ATTRIBUTE4
                                          )
        SELECT  @V_PLAN_ID                    AS PLAN_ID
               ,SEGMENT3+'::IDLE_EQ::IDLE_EQ' AS ROUTING_ID
               ,0                             AS OP_SEQ
               ,0                             AS LEAD_TIME
               ,1                             AS YIELD
               ,SEGMENT3                      AS ATTRIBUTE1
               ,'IDLE_EQ'                     AS ATTRIBUTE2
               ,'IDLE_EQ'                     AS ATTRIBUTE3
               ,'IDLE_EQ'                     AS ATTRIBUTE4
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK) 
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_EQ'
        AND     SEGMENT1    = @V_DIVISION_ID
        AND     SEGMENT2    = @V_GROUP_ID
        AND     LU.VALID_YN = 'Y'


        ------------------------------------------------------------------------
        -- TRAY 제약을 위한 데이터 추가
        -- 2025-07-30 THK
        ------------------------------------------------------------------------ 
        SELECT  @V_TRAY_YN = IIF(COUNT(*) >0,'Y','N')
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_GM_TRAY'
        AND     VALID_YN = 'Y'
        AND     SEGMENT1 = @V_DIVISION_ID
        AND     SEGMENT2 = @V_GROUP_ID
        

        INSERT INTO SCP_OPT_ENG_ROUTING_SN(PLAN_ID
                                          ,ROUTING_ID
                                          ,OP_SEQ
                                          ,LEAD_TIME
                                          ,YIELD
                                          ,ATTRIBUTE1
                                          ,ATTRIBUTE2
                                          ,ATTRIBUTE3
                                          ,ATTRIBUTE4
                                          ,ATTRIBUTE14
                                          ,ATTRIBUTE15
                                          )
        SELECT  PLAN_ID     AS PLAN_ID
               ,ROUTING_ID  AS ROUTING_ID
               ,1           AS OP_SEQ
               ,LEAD_TIME   AS LEAD_TIME
               ,1           AS YIELD
               ,ATTRIBUTE1  AS ATTRIBUTE1
               ,ATTRIBUTE2  AS ATTRIBUTE2
               ,ATTRIBUTE3  AS ATTRIBUTE3
               ,ATTRIBUTE4  AS ATTRIBUTE4
               ,ATTRIBUTE14 AS ATTRIBUTE14
               ,ATTRIBUTE15 AS ATTRIBUTE15
        FROM    SCP_OPT_ENG_ROUTING_SN WITH(NOLOCK)
        WHERE   PLAN_ID     = @V_PLAN_ID
        AND     ATTRIBUTE3  = 'ASSY'
        AND     @V_TRAY_YN  = 'Y'
        UNION ALL
        SELECT  @V_PLAN_ID                                                             AS PLAN_ID
               ,SEGMENT4 +'::'+SEGMENT5+'::'+SEGMENT6+IIF(SEGMENT3='','','@'+SEGMENT3) AS ROUTING_ID
               ,0                                                                      AS OP_SEQ
               ,0                                                                      AS LEAD_TIME
               ,1                                                                      AS YIELD
               ,SEGMENT4                                                               AS ATTRIBUTE1
               ,SEGMENT5                                                               AS ATTRIBUTE2
               ,SEGMENT6                                                               AS ATTRIBUTE3
               ,SEGMENT6+IIF(SEGMENT3='','','@'+SEGMENT3)                              AS ATTRIBUTE4
               ,NULL                                                                   AS ATTRIBUTE14
               ,NULL                                                                   AS ATTRIBUTE15
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_GM_TRAY'
        AND     VALID_YN = 'Y'
        AND     SEGMENT1 = @V_DIVISION_ID
        AND     SEGMENT2 = @V_GROUP_ID



        ------------------------------------------------------------------------
        -- 3. SECOND OCV 제약 적용
        -- 전진검사/2nd OCV UNION ALL 한 번에 INSERT -> TYPE A/B로 나뉘어있음
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_ROUTING_SN   (PLAN_ID
                                    ,ROUTING_ID
                                    ,OP_SEQ
                                    ,LEAD_TIME
                                    ,YIELD
                                    ,ATTRIBUTE1
                                    ,ATTRIBUTE2
                                    ,ATTRIBUTE3
                                    ,ATTRIBUTE4
                                    )
        SELECT @V_PLAN_ID
              ,LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3+'::-::-' AS ROUTING_ID
              ,LU.ATTRIBUTE5                                            AS OP_SEQ
              ,LU.ATTRIBUTE6                                            AS LEAD_TIME
              ,CASE WHEN MIN_OP.OP_SEQ IS NOT NULL THEN LU.ATTRIBUTE7
                    WHEN MAX_OP.OP_SEQ IS NOT NULL THEN '0' 
                    ELSE LU.ATTRIBUTE8 
               END                                                      AS YIELD
              ,LU.SEGMENT4                                              AS ATTRIBUTE1
              ,LU.SEGMENT5                                              AS ATTRIBUTE2
              ,LEFT(LU.ATTRIBUTE3,LEN(LU.ATTRIBUTE3)-2)                 AS ATTRIBUTE3
              ,LU.ATTRIBUTE3                                            AS ATTRIBUTE4
        FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            LEFT OUTER JOIN (
                            SELECT  LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3+'::-::-' AS ROUTING_ID
                                   ,MIN(LU.ATTRIBUTE5)                                       AS OP_SEQ
                            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                            WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                            AND     VALID_YN    = 'Y'
                            AND     SEGMENT2    = @V_DIVISION_ID
                            AND     ATTRIBUTE1  = 'C'
                            AND     SEGMENT3    = @V_GROUP_ID
                            GROUP BY LU.SEGMENT4,LU.SEGMENT5,LU.ATTRIBUTE3
                            ) MIN_OP
                ON  LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3+'::-::-' = MIN_OP.ROUTING_ID
                AND LU.ATTRIBUTE5 = MIN_OP.OP_SEQ
            LEFT OUTER JOIN (
                            SELECT  LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3+'::-::-' AS ROUTING_ID
                                   ,MAX(LU.ATTRIBUTE5)                                       AS OP_SEQ
                            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                            WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                            AND     VALID_YN    = 'Y'
                            AND     SEGMENT2    = @V_DIVISION_ID
                            AND     ATTRIBUTE1  = 'C'
                            AND     SEGMENT3    = @V_GROUP_ID
                            GROUP BY LU.SEGMENT4,LU.SEGMENT5,LU.ATTRIBUTE3
                            ) MAX_OP
                ON  LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3+'::-::-' = MAX_OP.ROUTING_ID
                AND LU.ATTRIBUTE5 = MAX_OP.OP_SEQ
        WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
        AND     LU.VALID_YN    = 'Y'
        AND     LU.SEGMENT2    = @V_DIVISION_ID
        AND     LU.ATTRIBUTE1  = 'C'
        AND     LU.SEGMENT3    = @V_GROUP_ID
        -- SUB_ROUTING
        UNION ALL
        SELECT @V_PLAN_ID
              ,LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3+'::-::-'+LU.ATTRIBUTE5 AS ROUTING_ID
              ,LU.ATTRIBUTE5                                                          AS OP_SEQ
              ,LU.ATTRIBUTE6                                                          AS LEAD_TIME
              ,LU.ATTRIBUTE7                                                          AS YIELD
              ,LU.SEGMENT4                                                            AS ATTRIBUTE1
              ,LU.SEGMENT5                                                            AS ATTRIBUTE2
              ,LEFT(LU.ATTRIBUTE3,LEN(LU.ATTRIBUTE3)-2)                               AS ATTRIBUTE3
              ,LU.ATTRIBUTE3                                                          AS ATTRIBUTE4
        FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
        AND     LU.VALID_YN    = 'Y'
        AND     LU.SEGMENT2    = @V_DIVISION_ID
        AND     LU.ATTRIBUTE1  = 'C'
        AND     LU.SEGMENT3    = @V_GROUP_ID
        AND     LU.ATTRIBUTE4  = '2'

        --2nd OCV 적용 구간이 필요한 경우 DUMMY ROUTING을 추가해줌 -> 2nd OCV 적용하지 않는 구간에 필요한 ROUTING
        INSERT INTO SCP_OPT_ENG_ROUTING_SN(
                                           PLAN_ID
                                          ,ROUTING_ID
                                          ,OP_SEQ    
                                          ,LEAD_TIME 
                                          ,YIELD     
                                          ,ATTRIBUTE1
                                          ,ATTRIBUTE2
                                          ,ATTRIBUTE3
                                          ,ATTRIBUTE4
                                          ,ATTRIBUTE11
                                          )
        SELECT  RT.PLAN_ID                           AS PLAN_ID
               ,RT.ROUTING_ID+@V_PLAN_START_YYYYMMDD AS ROUTING_ID
               ,RT.OP_SEQ                            AS OP_SEQ    
               ,RT.LEAD_TIME                         AS LEAD_TIME 
               ,RT.YIELD                             AS YIELD     
               ,RT.ATTRIBUTE1                        AS ATTRIBUTE1
               ,RT.ATTRIBUTE2                        AS ATTRIBUTE2
               ,RT.ATTRIBUTE3                        AS ATTRIBUTE3
               ,RT.ATTRIBUTE4                        AS ATTRIBUTE3
               ,'OCV_DUMMY'                          AS ATTRIBUTE11
        FROM    SCP_OPT_ENG_ROUTING_SN RT WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  RT.ATTRIBUTE1  = LU.SEGMENT4
                AND RT.ATTRIBUTE2  = LU.SEGMENT5
                AND RT.ATTRIBUTE4  = LU.ATTRIBUTE3
                AND RT.OP_SEQ      = LU.ATTRIBUTE5
        WHERE   RT.PLAN_ID     = @V_PLAN_ID
        AND     LU.SEGMENT2    = @V_DIVISION_ID
        AND     LU.SEGMENT3    = @V_GROUP_ID
        AND     LU.VALID_YN    = 'Y'
        AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
        AND     RT.OP_SEQ      = 0
        AND     IIF(LU.ATTRIBUTE10 = '' OR LU.ATTRIBUTE10 IS NULL , 0, LU.ATTRIBUTE10) > 0 -- 적용 일자가 있는 데이터만 신규로 추가
        AND     LU.ATTRIBUTE1  = 'C'

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
