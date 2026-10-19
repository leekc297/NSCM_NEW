
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_INPUT_ROUTING_BATCH]
     @P_PLAN_ID             NVARCHAR(50)
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_INPUT_ROUTING_BATCH';
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

    DECLARE @BASE_DATA TABLE(
                              PLAN_ID   NVARCHAR(100)
                            , OP_SEQ    INT
                            , LEAD_TIME INT
                            , YIELD     NUMERIC(20,4)
                            , SITE_ID   NVARCHAR(100)
                            , ITEM_ID   NVARCHAR(100)
                            , STAGE     NVARCHAR(100)
                            , LINE_ID   NVARCHAR(100)
                            , MONTH     NVARCHAR(10)
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
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_ROUTING_SN   (PLAN_ID
                                    ,ROUTING_ID
                                    ,OP_SEQ
                                    ,LEAD_TIME
                                    ,YIELD
                                    ,ATTRIBUTE1
                                    ,ATTRIBUTE2
                                    ,ATTRIBUTE3
                                    ,ATTRIBUTE14
                                    ,ATTRIBUTE15
                                    )
        SELECT  @V_PLAN_ID
               ,BOM.SCM_SITE_ID+'::'+BOM.ITEM_ID+'::'+BOM.STAGE+'::'+ISNULL(RR.LINE_ID,'-')+'::'+ISNULL(RR.START_DATE,'-') AS ROUTING_ID
               ,CONVERT(NUMERIC(20,0),0)        AS OP_SEQ
               ,CONVERT(NUMERIC(20,0),0)        AS LEAD_TIME
               ,CONVERT(NUMERIC(20,4),MAX(ISNULL(SI.YIELD,1))) AS YIELD
               --,CONVERT(NUMERIC(20,4),ISNULL(SI.YIELD,1)) AS YIELD
               ,BOM.SCM_SITE_ID                 AS SITE_ID
               ,BOM.ITEM_ID                     AS ITEM_ID
               ,BOM.STAGE                       AS STAGE
               ,RR.LINE_ID                      AS LINE_ID
               ,RR.MONTH                        AS MONTH
        FROM(
            SELECT  BOM.ATTRIBUTE1 AS SCM_SITE_ID
                   ,BOM.ATTRIBUTE2 AS ITEM_ID
                   ,BOM.ATTRIBUTE3 AS STAGE
            FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
            WHERE   BOM.PLAN_ID = @V_PLAN_ID
            UNION ALL
            SELECT  BOM.ATTRIBUTE1 AS SCM_SITE_ID
                   ,BOM.ATTRIBUTE2 AS ITEM_ID
                   ,'ASSY'         AS STAGE
            FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
            WHERE   BOM.PLAN_ID = @V_PLAN_ID
            AND     BOM.ATTRIBUTE3 = 'ASY_AGING'
            ) BOM

			-- Tact Time (ROUTING_RESOURCE) 존재하는 정보
			INNER JOIN (
				SELECT  DISTINCT ATTRIBUTE1 AS SCM_SITE_ID, ATTRIBUTE2 AS ITEM_ID, ATTRIBUTE3 AS STAGE
				               , ATTRIBUTE14 AS MONTH, ATTRIBUTE15 AS LINE_ID, START_DATE AS START_DATE
				FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN WITH(NOLOCK)
				WHERE   1=1
				AND     PLAN_ID = @V_PLAN_ID
				AND     RESOURCE_CLASS_ID = 'LINE'
			 ) RR
            ON  BOM.SCM_SITE_ID = RR.SCM_SITE_ID
            AND BOM.ITEM_ID     = RR.ITEM_ID
            AND BOM.STAGE       = RR.STAGE
			
            INNER HASH JOIN SCM_MST_SITE_ITEM_PRIORITY PR WITH(NOLOCK)
            ON  PR.DIVISION_ID  = @V_DIVISION_ID
            AND PR.VALID_YN     = 'Y'
            AND BOM.ITEM_ID     = PR.ITEM_ID
            AND BOM.SCM_SITE_ID = PR.PLANT_SITE_ID
            AND PR.TO_YYYYMMDD >= @P_PLAN_NAME

            INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
            ON  PR.DIVISION_ID    = S.DIVISION_ID
            AND PR.PLANT_SITE_ID  = S.SCM_SITE_ID
            AND S.SITE_TYPE      = 'PLANT'
            AND S.VALID_YN       = 'Y'

			LEFT OUTER JOIN(
					/*ASSY */
					SELECT  PLANT_ID , LINE_ID, ITEM_ID, MONTH, 0 AS LT, YIELD
						  ,CASE WHEN OPERATION_ID IN ('A3000', 'A8210', 'A9000') THEN 'ASSY'
								WHEN OPERATION_ID IN ('P5500') THEN 'MDLE'
								WHEN OPERATION_ID IN ('P9500') THEN 'PACK'
						   END AS STAGE
					FROM    SCM_MST_YIELD_SN WITH(NOLOCK)
					WHERE   DIVISION_ID  = @V_DIVISION_ID
					AND     OPERATION_ID IN ('A3000', 'A8210', 'A9000', 'P5500', 'P9500')
					AND     MONTH BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
                ) SI
			ON  S.PLANT_ID  = SI.PLANT_ID
			AND BOM.ITEM_ID = SI.ITEM_ID
			AND BOM.STAGE   = SI.STAGE
			AND RR.LINE_ID  = SI.LINE_ID
			AND RR.MONTH    = SI.MONTH
			--AND (LINE_ID IN (SELECT DISTINCT ATTRIBUTE15
			--				FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
			--				WHERE   PLAN_ID =@V_PLAN_ID
			--				AND     RESOURCE_TYPE = 'LINE'
			--				)
			--	)

        WHERE 1=1
        GROUP BY BOM.SCM_SITE_ID, BOM.ITEM_ID, BOM.STAGE, RR.LINE_ID, RR.MONTH, RR.START_DATE
        --GROUP BY BOM.SCM_SITE_ID, BOM.ITEM_ID, BOM.STAGE, SI.LINE_ID, SI.MONTH, SI.LT, SI.YIELD

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
                   ,CONVERT(NUMERIC(20,0),ISNULL(SI.LT,0))    AS LEAD_TIME
                   ,CONVERT(NUMERIC(20,4),ISNULL(SI.YIELD,1)) AS YIELD
                   ,BOM.SCM_SITE_ID                           AS SITE_ID
                   ,BOM.ITEM_ID                               AS ITEM_ID
                   ,BOM.STAGE                                 AS STAGE
                   ,SI.LINE_ID                                AS LINE_ID
                   ,SI.MONTH                                  AS MONTH
                   ,IIF(FL.SCM_SITE_ID IS NOT NULL, 'Y','N')  AS FL_LOOKUP_YN
                   ,IIF(FY.SCM_SITE_ID IS NOT NULL, 'Y','N')  AS FY_LOOKUP_YN
            FROM(
                SELECT  BOM.ATTRIBUTE1 AS SCM_SITE_ID
                       ,BOM.ATTRIBUTE2 AS ITEM_ID
                       ,BOM.ATTRIBUTE3 AS STAGE
                       ,BOM.ATTRIBUTE14 AS CHILD_ITEM_ID
                FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                WHERE   BOM.PLAN_ID = @V_PLAN_ID
                AND     BOM.ATTRIBUTE3 NOT IN ('SUBMDLE')
                UNION ALL
                SELECT  BOM.ATTRIBUTE1 AS SCM_SITE_ID
                       ,BOM.ATTRIBUTE2 AS ITEM_ID
                       ,'ASSY'         AS STAGE
                       ,BOM.ATTRIBUTE14 AS CHILD_ITEM_ID
                FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                WHERE   BOM.PLAN_ID = @V_PLAN_ID
                AND     BOM.ATTRIBUTE3 = 'ASY_AGING'
                UNION ALL -- SUBMDLE 은 SCM_MST_SITE_ITEM_PRIORITY 가 없어 별도 처리
                SELECT  BOM.ATTRIBUTE1  AS SCM_SITE_ID
                       ,BOM.ATTRIBUTE14 AS ITEM_ID -- SUBMDLE ITEM_ID ( BOM 상으로는 CHILD_ITEM_ID 임)
                       ,'SUBMDLE'       AS STAGE
                       ,BOM.ATTRIBUTE2  AS CHILD_ITEM_ID -- 실제는 PACK/MDLE 인 PARENT_ITEM_ID 임
                FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                WHERE   BOM.PLAN_ID = @V_PLAN_ID
                AND     BOM.ATTRIBUTE15 = 'SUBMDLE' -- CHILD_STAGE
                ) BOM
		    	
                INNER JOIN SCM_MST_SITE_ITEM_PRIORITY PR WITH(NOLOCK)
                ON  PR.DIVISION_ID   = @V_DIVISION_ID
                AND PR.VALID_YN      = 'Y'
                AND PR.ITEM_ID       = (CASE WHEN BOM.STAGE = 'SUBMDLE' THEN BOM.CHILD_ITEM_ID ELSE BOM.ITEM_ID END)
                AND PR.PLANT_SITE_ID = BOM.SCM_SITE_ID
                AND PR.TO_YYYYMMDD  >= @P_PLAN_NAME

                INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
                ON  PR.DIVISION_ID    = S.DIVISION_ID
                AND PR.PLANT_SITE_ID  = S.SCM_SITE_ID
                AND S.SITE_TYPE      = 'PLANT'
                AND S.VALID_YN       = 'Y'

		    	LEFT OUTER JOIN(
		    			/* ASY_AGING */
		    			SELECT  SUBSTRING(PLANT_SITE_ID,1,4) AS PLANT_ID, NULL AS LINE_ID, ITEM_ID, NULL AS MONTH,  TOTAL_LT_FORMATION AS LT
		    				   ,1.0 AS YIELD, 'ASY_AGING' AS STAGE
		    			FROM    SCP_MST_FORMATION_V WITH(NOLOCK)
		    			WHERE   DIVISION_ID = @V_DIVISION_ID
		    			UNION ALL
		    			/* CHAR */
		    			SELECT  SUBSTRING(PLANT_SITE_ID,1,4) AS PLANT_ID, NULL AS LINE_ID, ITEM_ID, NULL AS MONTH,  0 AS LT
		    				   ,ISNULL(SSP_MODIFY_YIELD, FORMATION_TOTAL_YIELD) AS YIELD, 'CHAR' AS STAGE
		    			FROM    SCP_MST_FORMATION_V WITH(NOLOCK)
		    			WHERE   DIVISION_ID = @V_DIVISION_ID
		    			UNION ALL
		    			/* SUBMDLE */
		    			SELECT  SUBSTRING(SITE_ID,1,4) AS PLANT_ID, NULL AS LINE_ID, ITEM_ID, NULL AS MONTH,  0 AS LT
		    				   ,1.0 AS YIELD, STAGE AS STAGE
		    			FROM    SCP_OPT_ENG_ITEM_SITE_SN WITH(NOLOCK)
		    			WHERE   PLAN_ID = @V_PLAN_ID
						AND     STAGE   = 'SUBMDLE'
                    ) SI
		    	ON  S.PLANT_ID  = SI.PLANT_ID
		    	AND BOM.ITEM_ID = SI.ITEM_ID
		    	AND BOM.STAGE   = SI.STAGE

                LEFT OUTER JOIN(

                                -- 2025.12.03 Minyong Lee : Lookup -> UI 전환 (활성화 LT)
                                SELECT  F.PLANT_SITE_ID         AS SCM_SITE_ID
                                      , F.ITEM_ID               AS ITEM_ID
                                      , F.LT_FORMATION + ISNULL(F.ADD_LT_FORMATION, 0) AS LT
                                      , F.FORMATION_START_DATE  AS START_TIME
                                      , F.FORMATION_END_DATE    AS END_TIME
                                      , MDL.STAGE               AS STAGE
                                FROM    SCP_OPMZ_MST_FORMATION_EXCEPT_LT F WITH(NOLOCK)
                                    INNER JOIN  (
                                                SELECT  DISTINCT ITEM_ID, STAGE
                                                FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                WHERE   1=1
                                                AND     PLAN_ID = @V_PLAN_ID
                                                AND     STAGE   = 'ASY_AGING'
                                                ) MDL
                                        ON  F.ITEM_ID = MDL.ITEM_ID
                                WHERE   1=1
                                AND     F.DIVISION_ID = @V_DIVISION_ID

                ) FL
                    ON  BOM.SCM_SITE_ID = FL.SCM_SITE_ID
                    AND BOM.ITEM_ID     = FL.ITEM_ID
                    AND BOM.STAGE       = FL.STAGE
					
                LEFT OUTER JOIN(
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
               /* LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL OCV WITH(NOLOCK)
                    ON  OCV.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                    AND OCV.SEGMENT2    = @V_DIVISION_ID
--                    AND OCV.SEGMENT3    = @V_GROUP_ID
                    AND BOM.SCM_SITE_ID = OCV.SEGMENT4
                    AND BOM.ITEM_ID     = OCV.SEGMENT5
                    AND BOM.STAGE       = OCV.ATTRIBUTE3*/
                --LEFT OUTER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)	
                --    ON  CAL.BASIS_YYYYMMDD BETWEEN FL.START_TIME AND FL.END_TIME
            -- 비 라인 STAGE
            WHERE BOM.STAGE NOT IN (
		    						SELECT  DISTINCT ATTRIBUTE3
		    						FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN WITH(NOLOCK)
		    						WHERE   1=1
		    						AND     PLAN_ID = @V_PLAN_ID
		    						AND     RESOURCE_CLASS_ID = 'LINE'
		    					  ) 
--            AND   OCV.SEGMENT1 IS NULL
            GROUP BY BOM.SCM_SITE_ID, BOM.ITEM_ID, BOM.STAGE, SI.LINE_ID, SI.MONTH, SI.LT, SI.YIELD, FL.SCM_SITE_ID, FY.SCM_SITE_ID

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
                                        ,ATTRIBUTE14
                                        ,ATTRIBUTE15
                                        ,ATTRIBUTE12
                                        ,ATTRIBUTE13
                                        )
            -- 1. Fromation LT Look Up 정의 정보
            SELECT PLAN_ID
            ,SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+ISNULL(LINE_ID,'-')+'::'+ISNULL(MIN(YYYYMMDD),'-')
            ,OP_SEQ
            ,ISNULL(LOOKUP_LT,LEAD_TIME) AS LEAD_TIME
            ,YIELD
            ,SITE_ID
            ,ITEM_ID
            ,STAGE
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
                      ,BD1.LINE_ID
                      ,BD1.MONTH
                      ,BD1.LOOKUP_LT
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
                                          ,BD.LINE_ID
                                          ,BD.MONTH
                                          ,FL.LT AS LOOKUP_LT
                                          ,CAL.BASIS_YYYYMMDD
                                    FROM @BASE_DATA BD
                                        LEFT OUTER JOIN(
                                               --SELECT  SEGMENT3   AS SCM_SITE_ID
                                               --       ,SEGMENT5   AS ITEM_ID
                                               --       ,ATTRIBUTE2 AS LT
                                               --       ,ATTRIBUTE3 AS START_TIME
                                               --       ,ATTRIBUTE4 AS END_TIME
                                               --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                               --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_FORMATION_LT'
                                               --AND     SEGMENT2    = @V_DIVISION_ID
                                               --AND     VALID_YN    = 'Y'

                                                -- 2025.12.03 Minyong Lee : Lookup -> UI 전환 (활성화 LT)
                                                SELECT  F.PLANT_SITE_ID         AS SCM_SITE_ID
                                                      , F.ITEM_ID               AS ITEM_ID
                                                      , F.LT_FORMATION + ISNULL(F.ADD_LT_FORMATION, 0) AS LT
                                                      , F.FORMATION_START_DATE  AS START_TIME
                                                      , F.FORMATION_END_DATE    AS END_TIME
                                                      , MDL.STAGE               AS STAGE
                                                FROM    SCP_OPMZ_MST_FORMATION_EXCEPT_LT F WITH(NOLOCK)
                                                    INNER JOIN  (
                                                                SELECT  DISTINCT ITEM_ID, STAGE
                                                                FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                                WHERE   1=1
                                                                AND     PLAN_ID = @V_PLAN_ID
                                                                AND     STAGE   = 'ASY_AGING'
                                                                ) MDL
                                                        ON  F.ITEM_ID = MDL.ITEM_ID
                                                WHERE   1=1
                                                AND     F.DIVISION_ID = @V_DIVISION_ID
                                        ) FL
                                            ON  BD.SITE_ID = FL.SCM_SITE_ID
                                            AND BD.ITEM_ID = FL.ITEM_ID
                                            AND BD.STAGE   = 'ASY_AGING'
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
                      ,BD.LINE_ID
                      ,BD.MONTH
                      ,FL.LT AS LOOKUP_LT
                      ,CAL.BASIS_YYYYMMDD
                      ,'A_'+CONVERT(NVARCHAR(8),DATEADD(DAY,-ROW_NUMBER() OVER(PARTITION BY BD.SITE_ID, BD.ITEM_ID ORDER BY CAL.BASIS_YYYYMMDD),CAL.BASIS_YYYYMMDD),112) AS DIVIDE
                FROM @BASE_DATA BD
                    LEFT OUTER JOIN(
                           --SELECT  SEGMENT3   AS SCM_SITE_ID
                           --       ,SEGMENT5   AS ITEM_ID
                           --       ,ATTRIBUTE2 AS LT
                           --       ,ATTRIBUTE3 AS START_TIME
                           --       ,ATTRIBUTE4 AS END_TIME
                           --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                           --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_FORMATION_LT'
                           --AND     SEGMENT2    = @V_DIVISION_ID
                           --AND     VALID_YN    = 'Y'

                            -- 2025.12.03 Minyong Lee : Lookup -> UI 전환 (활성화 LT)
                            SELECT  F.PLANT_SITE_ID         AS SCM_SITE_ID
                                  , F.ITEM_ID               AS ITEM_ID
                                  , F.LT_FORMATION + ISNULL(F.ADD_LT_FORMATION, 0) AS LT
                                  , F.FORMATION_START_DATE  AS START_TIME
                                  , F.FORMATION_END_DATE    AS END_TIME
                                  , MDL.STAGE               AS STAGE
                            FROM    SCP_OPMZ_MST_FORMATION_EXCEPT_LT F WITH(NOLOCK)
                                INNER JOIN  (
                                            SELECT  DISTINCT ITEM_ID, STAGE
                                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                            WHERE   1=1
                                            AND     PLAN_ID = @V_PLAN_ID
                                            AND     STAGE   = 'ASY_AGING'
                                            ) MDL
                                    ON  F.ITEM_ID = MDL.ITEM_ID
                            WHERE   1=1
                            AND     F.DIVISION_ID = @V_DIVISION_ID

                    ) FL
                        ON  BD.SITE_ID = FL.SCM_SITE_ID
                        AND BD.ITEM_ID = FL.ITEM_ID
                        AND BD.STAGE   = 'ASY_AGING'
                    LEFT OUTER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)	
                        ON  CAL.BASIS_YYYYMMDD BETWEEN FL.START_TIME AND FL.END_TIME
                WHERE BD.FL_LOOKUP_YN = 'Y'
                ) FL
                WHERE YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD_V2
            GROUP BY PLAN_ID, OP_SEQ, LEAD_TIME, YIELD, SITE_ID, ITEM_ID, STAGE, LINE_ID, MONTH, LOOKUP_LT, DIVIDE
			
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
											   --AND     SEGMENT5    = 'CHAR'

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
									--AND     SEGMENT5    = 'CHAR'

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
            GROUP BY PLAN_ID, OP_SEQ, LEAD_TIME, YIELD, SITE_ID, ITEM_ID, STAGE, LINE_ID, MONTH, LOOKUP_YIELD, DIVIDE

            -- 3. LOOK UP에 등록되지 않은 데이터 INSERT
            UNION ALL
            SELECT PLAN_ID
                  ,SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+ISNULL(LINE_ID,'-')+'::'+ISNULL(MONTH,'-')
                  ,OP_SEQ
                  ,LEAD_TIME AS LEAD_TIME
                  ,YIELD
                  ,SITE_ID
                  ,ITEM_ID
                  ,STAGE
                  ,LINE_ID
                  ,MONTH
                  ,NULL AS MIN
                  ,NULL AS MAX
            FROM @BASE_DATA WHERE (FL_LOOKUP_YN ='N' AND FY_LOOKUP_YN ='N')


        -- PRINT N'STEP 4:: 전진검사/2nd OCV UNION ALL 한 번에 INSERT ' + CONVERT(NVARCHAR, SYSDATETIME(), 114);
        ------------------------------------------------------------------------
        -- 3. SECOND OCV 제약 적용
        -- 전진검사/2nd OCV UNION ALL 한 번에 INSERT -> TYPE A/B로 나뉘어있음
        ------------------------------------------------------------------------
    /*    INSERT INTO SCP_OPT_ENG_ROUTING_SN   (PLAN_ID
                                    ,ROUTING_ID
                                    ,OP_SEQ
                                    ,LEAD_TIME
                                    ,YIELD
                                    ,ATTRIBUTE1
                                    ,ATTRIBUTE2
                                    ,ATTRIBUTE3
                                    )
        -- 전진 검사용 데이터 추가
        SELECT @V_PLAN_ID
              ,LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3+'::-::-'               AS ROUTING_ID
              ,LU.ATTRIBUTE5                                                          AS OP_SEQ
              ,LU.ATTRIBUTE6                                                          AS LEAD_TIME
              ,LU.ATTRIBUTE7                                                          AS YIELD
              ,LU.SEGMENT4                                                            AS ATTRIBUTE1
              ,LU.SEGMENT5                                                            AS ATTRIBUTE2
              ,LU.ATTRIBUTE3                                                          AS ATTRIBUTE3
        FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
        AND     LU.VALID_YN    = 'Y'
        AND     LU.SEGMENT2    = @V_DIVISION_ID
        AND     LU.ATTRIBUTE1  = 'A'
        AND     LU.SEGMENT3    = @V_GROUP_ID
        -- 2nd OCV 데이터 추가
        UNION ALL
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
                  ,LU.ATTRIBUTE3                                            AS ATTRIBUTE3
            FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                LEFT OUTER JOIN (
                                SELECT  LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3+'::-::-' AS ROUTING_ID
                                       ,MIN(LU.ATTRIBUTE5)                                       AS OP_SEQ
                                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                AND     VALID_YN    = 'Y'
                                AND     SEGMENT2    = @V_DIVISION_ID
                                AND     ATTRIBUTE1  = 'B'
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
                                AND     ATTRIBUTE1  = 'B'
                                AND     SEGMENT3    = @V_GROUP_ID
                                GROUP BY LU.SEGMENT4,LU.SEGMENT5,LU.ATTRIBUTE3
                                ) MAX_OP
                    ON  LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3+'::-::-' = MAX_OP.ROUTING_ID
                    AND LU.ATTRIBUTE5 = MAX_OP.OP_SEQ
            WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
            AND     LU.VALID_YN    = 'Y'
            AND     LU.SEGMENT2    = @V_DIVISION_ID
            AND     LU.ATTRIBUTE1  = 'B'
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
                  ,LU.ATTRIBUTE3                                                          AS ATTRIBUTE3
            FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
            AND     LU.VALID_YN    = 'Y'
            AND     LU.SEGMENT2    = @V_DIVISION_ID
            AND     LU.ATTRIBUTE1  = 'B'
            AND     LU.SEGMENT3    = @V_GROUP_ID
            AND     LU.ATTRIBUTE4  = '2'
            ;*/

        ------------------------------------------------------------------------
        -- T.H.KIM/20251016/CHAR의 경우 BOM상 ASSY 제품의 YIELD를 CHAR YIELD를 입력. -> 상현 책임님 요청사항
        ------------------------------------------------------------------------
        UPDATE RT
        SET RT.YIELD = A.SSP_MODIFY_YIELD
        FROM SCP_OPT_ENG_ROUTING_SN RT
            INNER JOIN (
                        SELECT AI.PLAN_ID
                              ,AI.ROUTING_ID
                              ,MF.SSP_MODIFY_YIELD
                        FROM(
                            SELECT RT.PLAN_ID
                                  ,RT.ROUTING_ID   AS ROUTING_ID
                                  ,RT.ATTRIBUTE1   AS SCM_SITE_ID
                                  ,RT.ATTRIBUTE2   AS CHAR_ITEM_ID
                                  ,BOM.ATTRIBUTE14 AS ASSY_ITEM_ID
                            FROM SCP_OPT_ENG_ROUTING_SN RT WITH(NOLOCK)
                                INNER JOIN SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                                    ON  RT.PLAN_ID = BOM.PLAN_ID
                                    AND RT.ATTRIBUTE2  = BOM.ATTRIBUTE2
                                    AND BOM.ATTRIBUTE3 = 'CHAR'
                            WHERE RT.PLAN_ID = @V_PLAN_ID
                            ) AI
                            INNER JOIN SCP_MST_FORMATION_V MF WITH(NOLOCK)
                                ON  DIVISION_ID     = '40'
                                AND AI.SCM_SITE_ID  = MF.PLANT_SITE_ID
                                AND AI.ASSY_ITEM_ID = MF.ITEM_ID
                        ) A
                ON  RT.PLAN_ID = A.PLAN_ID
                AND RT.ROUTING_ID = A.ROUTING_ID
        WHERE RT.PLAN_ID= @V_PLAN_ID
        ------------------------------------------------------------------------
        -- FROZEN 구간에 대해서는 YIELD를 1로 고정 -> 입력한 FROZEN 수량대로 나오게 하기위해서/20250912/THKIM
        ------------------------------------------------------------------------
        UPDATE  RT
        SET     RT.YIELD = 1
        FROM    SCP_OPT_ENG_ROUTING_SN RT WITH(NOLOCK)
            INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                ON  RT.PLAN_ID    = FM.PLAN_ID 
                AND RT.ATTRIBUTE3 = FM.STAGE
            INNER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN RR WITH(NOLOCK)
                ON  RT.PLAN_ID    = RR.PLAN_ID
                AND RT.ROUTING_ID = RR.ROUTING_ID
        WHERE   1=1
        AND     RT.PLAN_ID = @V_PLAN_ID
        AND     RR.END_DATE <= FM.FROZEN_END_DATE

        ------------------------------------------------------------------------
        -- 3. 전진검사 ROUTING 추가, 전진검사 B타입은 사용하지 않음
        ------------------------------------------------------------------------
        --INSERT INTO SCP_OPT_ENG_ROUTING_SN(PLAN_ID
        --                               ,ROUTING_ID
        --                               ,OP_SEQ
        --                               ,LEAD_TIME
        --                               ,YIELD
        --                               ,ATTRIBUTE1
        --                               ,ATTRIBUTE2
        --                               ,ATTRIBUTE3
        --                               ,ATTRIBUTE14
        --                               ,ATTRIBUTE15
        --                               )
        --SELECT  RT.PLAN_ID     AS PLAN_ID
        --       ,RT.ROUTING_ID  AS ROUTING_ID
        --       ,'1'            AS OP_SEQ
        --       ,LU.ATTRIBUTE7  AS LEAD_TIME
        --       ,LU.ATTRIBUTE8  AS YIELD
        --       ,RT.ATTRIBUTE1  AS ATTRIBUTE1 
        --       ,RT.ATTRIBUTE2  AS ATTRIBUTE2 
        --       ,RT.ATTRIBUTE3  AS ATTRIBUTE3 
        --       ,RT.ATTRIBUTE14 AS ATTRIBUTE14
        --       ,RT.ATTRIBUTE15 AS ATTRIBUTE15
        --FROM    SCP_OPT_ENG_ROUTING_SN RT WITH(NOLOCK)
        --    INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        --        ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_FORWARD_INSPECTION'
        --        AND LU.SEGMENT3    = @V_DIVISION_ID
        --        AND LU.SEGMENT2    = @V_GROUP_ID
        --        AND LU.SEGMENT4    = 'B'
        --        AND LU.VALID_YN    = 'Y'
        --        AND RT.ATTRIBUTE1  = LU.ATTRIBUTE1
        --        AND RT.ATTRIBUTE2  = LU.SEGMENT5
        --        AND RT.ATTRIBUTE3  = LU.ATTRIBUTE2
        --        AND RT.ATTRIBUTE15 BETWEEN LEFT(LU.ATTRIBUTE5,6) AND LEFT(LU.ATTRIBUTE6,6)
        --WHERE   1=1
        --AND     PLAN_ID = @V_PLAN_ID

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
