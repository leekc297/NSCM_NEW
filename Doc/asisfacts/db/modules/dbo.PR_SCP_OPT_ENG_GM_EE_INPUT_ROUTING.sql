


CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_EE_INPUT_ROUTING]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.12 Taehyun Initial Release
    -- 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영.
	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------ROU
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- Set Param for Log
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_EE_INPUT_ROUTING';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE       DATETIME;
    DECLARE @P_PLAN_NAME         NVARCHAR(8);
    DECLARE @D_PLAN_NAME         DATETIME;
    DECLARE @V_PLAN_START_YYYYMM NVARCHAR(8);
    DECLARE @V_PLAN_END_YYYYMM   NVARCHAR(8);
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
        SELECT @P_PLAN_NAME = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 해당 주 월요일 YYYYMMDD
        SELECT @D_PLAN_NAME = CONVERT(DATETIME, @P_PLAN_NAME) ;
        
        SELECT @V_PLAN_START_YYYYMM = CONVERT(NVARCHAR(6),PLAN_START_DATE,112)
              ,@V_PLAN_END_YYYYMM   = CONVERT(NVARCHAR(6),PLAN_END_DATE,112)
        FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        WHERE  PLAN_ID = @P_PLAN_ID
         
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
        ------------------------------------------------------------------------
        -- 1. Line 정보 Insert
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_ROUTING_SN(PLAN_ID
                                       ,ROUTING_ID
                                       ,OP_SEQ
                                       ,LEAD_TIME
                                       ,YIELD
                                       ,ATTRIBUTE1
                                       ,ATTRIBUTE2
                                       ,ATTRIBUTE3
                                       ,ATTRIBUTE13
                                       ,ATTRIBUTE14
                                       ,ATTRIBUTE15
                                       )
        SELECT  @V_PLAN_ID
               ,BOM.SCM_SITE_ID+'::'+BOM.ITEM_ID+'::'+BOM.STAGE+'::'+ISNULL(RR.LINE_ID,'-')+'::'+ISNULL(RR.START_DATE,'-') AS ROUTING_ID
               ,CONVERT(NUMERIC(20,0),0)        AS OP_SEQ
               ,MAX(CONVERT(NUMERIC(20,0),ISNULL(LT1.LT, LT2.LT))) AS LEAD_TIME
            --    ,CONVERT(NUMERIC(20,0),0)        AS LEAD_TIME
               ,CONVERT(NUMERIC(20,4),MAX(ISNULL(SI.YIELD,1))) AS YIELD
               --,CONVERT(NUMERIC(20,4),ISNULL(SI.YIELD,1)) AS YIELD
               ,BOM.SCM_SITE_ID                 AS SITE_ID
               ,BOM.ITEM_ID                     AS ITEM_ID
               ,BOM.STAGE                       AS STAGE
               ,RR.LINE_ID_ORG                  AS LINE_ID_ORG
               ,RR.LINE_ID                      AS LINE_ID
               ,RR.MONTH                        AS MONTH
        FROM(
            SELECT  BOM.ATTRIBUTE1 AS SCM_SITE_ID
                   ,BOM.ATTRIBUTE2 AS ITEM_ID
                   ,BOM.ATTRIBUTE3 AS STAGE
            FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
            WHERE   BOM.PLAN_ID = @V_PLAN_ID
            UNION ALL
            SELECT  BOM.ATTRIBUTE13 AS SCM_SITE_ID
                   ,BOM.ATTRIBUTE14 AS ITEM_ID
                   ,BOM.ATTRIBUTE15 AS STAGE
            FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
            WHERE   BOM.PLAN_ID = @V_PLAN_ID
            AND     BOM.ATTRIBUTE3 = 'NND'
            -- 2ND OCV "C" TYPE이 들어오면서 BOM추가
            UNION ALL
            SELECT  BOM.ATTRIBUTE13 AS SCM_SITE_ID
                   ,BOM.ATTRIBUTE14 AS ITEM_ID
                   ,BOM.ATTRIBUTE15 AS STAGE
            FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
            WHERE   BOM.PLAN_ID = @V_PLAN_ID
            AND     BOM.ATTRIBUTE3 = 'INSP_COT'
            ) BOM

			-- Tact Time (ROUTING_RESOURCE) 존재하는 정보
			INNER JOIN (
				SELECT  DISTINCT ATTRIBUTE1 AS SCM_SITE_ID, ATTRIBUTE2 AS ITEM_ID, ATTRIBUTE3 AS STAGE
				               , ATTRIBUTE14 AS MONTH, ATTRIBUTE15 AS LINE_ID,ATTRIBUTE13 AS LINE_ID_ORG , START_DATE AS START_DATE
				FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN WITH(NOLOCK)
				WHERE   1=1
				AND     PLAN_ID = @V_PLAN_ID
				AND     RESOURCE_CLASS_ID = 'LINE'
			 ) RR
                ON  BOM.SCM_SITE_ID = RR.SCM_SITE_ID
                AND BOM.ITEM_ID     = RR.ITEM_ID
                AND BOM.STAGE       = RR.STAGE
            INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
                ON  1=1
                AND BOM.SCM_SITE_ID  = S.SCM_SITE_ID
                AND S.SITE_TYPE      = 'PLANT'
                AND S.VALID_YN       = 'Y'

           INNER JOIN SCM_MST_ITEM_LINE_ASSIGN_SN LA WITH(NOLOCK)
                ON  1=1
                AND LA.ACTIVE_FLAG = 'Y'
                AND LA.PLANT_ID = S.PLANT_ID
                AND LA.ITEM_ID  = BOM.ITEM_ID
                AND LA.MONTH >= LEFT(@P_PLAN_NAME,6)
            
			INNER JOIN #DIVISION D WITH(NOLOCK)
			    ON  LA.DIVISION_ID = D.DIVISION_ID

			LEFT OUTER JOIN(
					SELECT  Y.PLANT_ID, Y.LINE_ID, Y.ITEM_ID, Y.MONTH, 0 AS LT
                            , IIF(ISNULL(Y.YIELD, 1)=0, 1, Y.YIELD) AS YIELD
						  ,CASE WHEN Y.OPERATION_ID = 'E2000' THEN 'COATING'
                                WHEN Y.OPERATION_ID = 'A5000' THEN 'NND'
                           END AS STAGE
					FROM    SCM_MST_YIELD_SN Y WITH(NOLOCK)
					INNER JOIN #DIVISION D WITH(NOLOCK)
					ON Y.DIVISION_ID = D.DIVISION_ID

					WHERE   1=1 -- DIVISION_ID  = @V_DIVISION_ID
					AND     Y.OPERATION_ID IN ('E2000','A5000')
					AND     Y.MONTH BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
                ) SI
			ON  S.PLANT_ID     = SI.PLANT_ID
			AND BOM.ITEM_ID    = SI.ITEM_ID
			AND BOM.STAGE      = SI.STAGE
			AND RR.LINE_ID_ORG = SI.LINE_ID
			AND RR.MONTH       = SI.MONTH
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
        /************************* 
        대상 프로젝트 ITEM 필터링 
        *************************/
		AND CONCAT(BOM.SCM_SITE_ID, BOM.ITEM_ID) 
			IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
				FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
				WHERE  PLAN_ID = @V_PLAN_ID
				) 
        GROUP BY BOM.SCM_SITE_ID, BOM.ITEM_ID, BOM.STAGE, RR.LINE_ID, RR.MONTH, RR.START_DATE, RR.LINE_ID_ORG





        ------------------------------------------------------------------------
        -- LINE FULL LOADING 제약이 있으면 DINAMIC RAMP UP 적용을 위해 IDLE 데이터 추가
        -- 2025-07-29 THK
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
        SELECT  @V_PLAN_ID              AS PLAN_ID
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
                                          )
        SELECT  @V_PLAN_ID                    AS PLAN_ID
               ,SEGMENT3+'::IDLE_EQ::IDLE_EQ' AS ROUTING_ID
               ,0                             AS OP_SEQ
               ,0                             AS LEAD_TIME
               ,1                             AS YIELD
               ,SEGMENT3                      AS ATTRIBUTE1
               ,'IDLE_EQ'                     AS ATTRIBUTE2
               ,'IDLE_EQ'                     AS ATTRIBUTE3
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK) 
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_EQ'
        AND     SEGMENT1    = @V_DIVISION_ID
        AND     SEGMENT2    = @V_GROUP_ID
        AND     LU.VALID_YN = 'Y'

        ------------------------------------------------------------------------
        -- SECOND OCV 제약 적용
        -- 전진검사/2nd OCV UNION ALL 한 번에 INSERT -> TYPE A/B로 나뉘어있음
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_ROUTING_SN (PLAN_ID
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
                            AND     ATTRIBUTE1  IN( 'B','C')
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
                            AND     ATTRIBUTE1  IN( 'B','C')
                            AND     SEGMENT3    = @V_GROUP_ID
                            GROUP BY LU.SEGMENT4,LU.SEGMENT5,LU.ATTRIBUTE3
                            ) MAX_OP
                ON  LU.SEGMENT4+'::'+LU.SEGMENT5+'::'+LU.ATTRIBUTE3+'::-::-' = MAX_OP.ROUTING_ID
                AND LU.ATTRIBUTE5 = MAX_OP.OP_SEQ
        WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
        AND     LU.VALID_YN    = 'Y'
        AND     LU.SEGMENT2    = @V_DIVISION_ID
        AND     LU.ATTRIBUTE1  IN( 'B','C')
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
        AND     LU.ATTRIBUTE1  IN( 'B','C')
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
               ,'OCV_DUMMY'                          AS ATTRIBUTE11
        FROM    SCP_OPT_ENG_ROUTING_SN RT WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  RT.ATTRIBUTE1  = LU.SEGMENT4
                AND RT.ATTRIBUTE2  = LU.SEGMENT5
                AND RT.ATTRIBUTE3  = LU.ATTRIBUTE3
                AND RT.OP_SEQ      = LU.ATTRIBUTE5
            --HOLD BOH가있는 경우만 FROM_DAYS 이후에 2nd OCV를 적용, 나머지는 PSD부터 적용
            INNER JOIN (
                       SELECT  ST.ATTRIBUTE1 AS SCM_SITE_ID
                              ,ST.ATTRIBUTE2 AS ITEM_ID
                       FROM    SCP_OPT_ENG_INCOMING_STOCK_SN ST WITH(NOLOCK)
                           INNER JOIN(
                                      SELECT  SEGMENT4 AS SCM_SITE_ID
                                             ,SEGMENT5 AS ITEM_ID
                                      FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                      WHERE   1=1
                                      AND     LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                      AND     VALID_YN    = 'Y'
                                      AND     SEGMENT2    = @V_DIVISION_ID
                                      AND     SEGMENT3    = @V_GROUP_ID
                                      GROUP BY SEGMENT4, SEGMENT5
                                      ) LU
                               ON  ST.ATTRIBUTE1 = LU.SCM_SITE_ID
                               AND ST.ATTRIBUTE2 = LU.ITEM_ID
                       WHERE   ST.PLAN_ID = @V_PLAN_ID
                       AND     ST.TYPE           = 'WH_HOLD'
                       GROUP BY ST.ATTRIBUTE1, ST.ATTRIBUTE2
                       ) HS
                ON  RT.ATTRIBUTE1 = HS.SCM_SITE_ID
                AND RT.ATTRIBUTE2 = HS.ITEM_ID
        WHERE   RT.PLAN_ID     = @V_PLAN_ID
        AND     LU.SEGMENT2    = @V_DIVISION_ID
        AND     LU.SEGMENT3    = @V_GROUP_ID
        AND     LU.VALID_YN    = 'Y'
        AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
        AND     RT.OP_SEQ      = 0
        AND     IIF(LU.ATTRIBUTE10 = '' OR LU.ATTRIBUTE10 IS NULL , 0, LU.ATTRIBUTE10) > 0 -- 적용 일자가 있는 데이터만 신규로 추가
        AND     LU.ATTRIBUTE1  IN( 'B','C')
        --GROUP BY BOM.SCM_SITE_ID, BOM.ITEM_ID, BOM.STAGE, SI.LINE_ID, SI.MONTH, SI.LT, SI.YIELD

        ------------------------------------------------------------------------
        -- 2. 비 Line 정보 Insert
        ------------------------------------------------------------------------
  --      INSERT INTO SCP_OPT_ENG_ROUTING_SN(PLAN_ID
  --                                     ,ROUTING_ID
  --                                     ,OP_SEQ
  --                                     ,LEAD_TIME
  --                                     ,YIELD
  --                                     ,ATTRIBUTE1
  --                                     ,ATTRIBUTE2
  --                                     ,ATTRIBUTE3
  --                                     ,ATTRIBUTE14
  --                                     ,ATTRIBUTE15
  --                                     )
  --      SELECT  @V_PLAN_ID
  --             ,BOM.SCM_SITE_ID+'::'+BOM.ITEM_ID+'::'+BOM.STAGE+'::'+ISNULL(SI.LINE_ID,'-')+'::'+ISNULL(SI.MONTH+'01','-') AS ROUTING_ID
  --             ,CONVERT(NUMERIC(20,0),0)        AS OP_SEQ
  --             ,CONVERT(NUMERIC(20,0),ISNULL(LT.LT,0))    AS LEAD_TIME
  --             ,CONVERT(NUMERIC(20,4),ISNULL(SI.YIELD,1)) AS YIELD
  --             ,BOM.SCM_SITE_ID                 AS SITE_ID
  --             ,BOM.ITEM_ID                     AS ITEM_ID
  --             ,BOM.STAGE                       AS STAGE
  --             ,SI.LINE_ID                      AS LINE_ID
  --             ,SI.MONTH                        AS MONTH
  --      FROM(
  --          SELECT  BOM.ATTRIBUTE1 AS SCM_SITE_ID
  --                 ,BOM.ATTRIBUTE2 AS ITEM_ID
  --                 ,BOM.ATTRIBUTE3 AS STAGE
  --          FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
  --          WHERE   BOM.PLAN_ID = @V_PLAN_ID
  --          UNION ALL
  --          SELECT  BOM.ATTRIBUTE1 AS SCM_SITE_ID
  --                 ,BOM.ATTRIBUTE2 AS ITEM_ID
  --                 ,'COATING'      AS STAGE
  --          FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
  --          WHERE   BOM.PLAN_ID = @V_PLAN_ID
  --          AND     BOM.ATTRIBUTE3 = 'ELEC_POST'
  --          ) BOM
			
  --          INNER JOIN SCM_MST_SITE_ITEM_PRIORITY PR WITH(NOLOCK)
  --          ON  1=1 --PR.DIVISION_ID  = @V_DIVISION_ID
  --          AND PR.VALID_YN     = 'Y'
  --          AND BOM.ITEM_ID     = PR.ITEM_ID
  --          AND BOM.SCM_SITE_ID = PR.PLANT_SITE_ID
  --          AND PR.TO_YYYYMMDD >= @P_PLAN_NAME

		--	INNER JOIN #DIVISION D WITH(NOLOCK)
		--	ON  PR.DIVISION_ID = D.DIVISION_ID

  --          INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
  --          ON  PR.DIVISION_ID    = S.DIVISION_ID
  --          AND PR.PLANT_SITE_ID  = S.SCM_SITE_ID
  --          AND S.SITE_TYPE      = 'PLANT'
  --          AND S.VALID_YN       = 'Y'
			
		--	LEFT OUTER JOIN(
		--			/*ELEC_POST(전극 후공정) 수율 : LOOKUP 정보 */
		--			SELECT LU.SEGMENT2 AS SCM_SITE_ID
		--			     , NULL AS LINE_ID
		--				 , LU.SEGMENT4 AS ITEM_ID
		--				 , LU.SEGMENT5 AS MONTH
		--				 , 0 AS LT
		--				 , MAX(LU.ATTRIBUTE1) AS YIELD
		--				 ,'ELEC_POST'   AS STAGE
						 
		--			FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
  --                  WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_MASTER_YIELD'
		--			AND    LU.VALID_YN    = 'Y'
  --                  AND    LU.SEGMENT1    = @V_DIVISION_ID
		--			AND    LU.SEGMENT5 BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
		--			GROUP BY LU.SEGMENT2, LU.SEGMENT4, LU.SEGMENT5
  --              ) SI
		--	ON  S.SCM_SITE_ID = SI.SCM_SITE_ID
		--	AND BOM.ITEM_ID   = SI.ITEM_ID
		--	AND BOM.STAGE     = SI.STAGE
  --          --LT 별도 적용/신성재 책임님 요청사항/20250529/김태현 선임
		--	LEFT OUTER JOIN(
		--			        SELECT SEGMENT4   AS SCM_SITE_ID
  --                                ,SEGMENT5   AS STAGE
  --                                ,ATTRIBUTE1 AS LT
		--			        FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
  --                          WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_ELEC_OPERATION_LT'
		--			        AND    LU.VALID_YN    = 'Y'
  --                          AND    LU.SEGMENT2    = @V_DIVISION_ID
  --                          AND    LU.SEGMENT3    = @V_GROUP_ID
  --              ) LT
  --              ON  S.SCM_SITE_ID = LT.SCM_SITE_ID
  --              AND BOM.STAGE     = LT.STAGE
  --      -- 비 라인 STAGE
  --      WHERE BOM.STAGE NOT IN (
		--						SELECT  DISTINCT ATTRIBUTE3
		--						FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN WITH(NOLOCK)
		--						WHERE   1=1
		--						AND     PLAN_ID = @V_PLAN_ID
		--						AND     RESOURCE_CLASS_ID = 'LINE'
		--					  ) 
  --      /************************* 
  --      대상 프로젝트 ITEM 필터링 
  --      *************************/
		--AND CONCAT(BOM.SCM_SITE_ID, BOM.ITEM_ID) 
		--	IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
		--		FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
		--		WHERE  PLAN_ID = @V_PLAN_ID
		--		) 
  --      GROUP BY BOM.SCM_SITE_ID, BOM.ITEM_ID, BOM.STAGE, SI.LINE_ID, SI.MONTH, LT.LT, SI.YIELD
		


        ------------------------------------------------------------------------
        -- DATA Insert
        -- 비율 별 CAPA 할당 제약
        ------------------------------------------------------------------------
        --INSERT INTO SCP_OPT_ENG_ROUTING_SN(
        --                                  PLAN_ID
        --                                 ,ROUTING_ID
        --                                 ,OP_SEQ
        --                                 ,LEAD_TIME
        --                                 ,YIELD
        --                                 ,ATTRIBUTE1
        --                                 ,ATTRIBUTE2
        --                                 ,ATTRIBUTE3
        --                                 ,ATTRIBUTE14
        --                                 ,ATTRIBUTE15
        --                                 )
        --SELECT RO.PLAN_ID     AS PLAN_ID
        --      ,AL.SITE_ID+'::'+AL.ITEM_ID+'::'+RO.ATTRIBUTE3+'::'+AL.CNG_LINE_ID+'::'+RO.ATTRIBUTE15 AS ROUTING_ID
        --      ,RO.OP_SEQ      AS OP_SEQ
        --      ,RO.LEAD_TIME   AS LEAD_TIME
        --      ,RO.YIELD       AS YIELD
        --      ,AL.SITE_ID     AS ATTRIBUTE1
        --      ,AL.ITEM_ID     AS ATTRIBUTE2
        --      ,RO.ATTRIBUTE3  AS ATTRIBUTE3
        --      ,AL.CNG_LINE_ID AS ATTRIBUTE14
        --      ,RO.ATTRIBUTE15 AS ATTRIBUTE15
        --FROM SCP_OPT_ENG_ROUTING_SN RO WITH(NOLOCK)  
        --    INNER JOIN (
        --                SELECT AL.SEGMENT3   AS SITE_ID
        --                      ,AL.SEGMENT4   AS LINE_ID
        --                      ,IIF(ALI.SEGMENT5 = '81',AL.SEGMENT4+'@Auto',AL.SEGMENT4+'@ESS') AS CNG_LINE_ID
        --                      ,ALI.SEGMENT4  AS ITEM_ID
        --                      ,ALI.SEGMENT5  AS DEVISION_ID
        --                      ,AL.ATTRIBUTE1 AS AUTO_RATIO
        --                      ,AL.ATTRIBUTE2 AS ESS_RATIO
        --                      ,AL.ATTRIBUTE3 AS EFF_START_DATE
        --                      ,AL.ATTRIBUTE4 AS EFF_END_DATE
        --                FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL AL WITH(NOLOCK)
        --                    INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL ALI WITH(NOLOCK)
        --                        ON  AL.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CAPA_ALLOCATION'
        --                        AND ALI.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CAPA_ALLOCATION_ITEM'
        --                        AND AL.SEGMENT3 = ALI.SEGMENT2
        --                        AND AL.SEGMENT4 = ALI.SEGMENT3
        --                        AND AL.VALID_YN  = 'Y'
        --                        AND ALI.VALID_YN = 'Y'
        --                ) AL
        --        ON  1=1
        --        AND RO.ATTRIBUTE1 = AL.SITE_ID
        --        AND RO.ATTRIBUTE2 = AL.ITEM_ID
        --WHERE 1=1
        --AND RO.PLAN_ID    = @V_PLAN_ID
        --AND RO.ATTRIBUTE3 = 'COATING'
        --AND RO.ATTRIBUTE15 BETWEEN AL.EFF_START_DATE AND AL.EFF_END_DATE
            --INNER JOIN SCP_OPT_ENG_RESOURCE_SN RS WITH(NOLOCK)
            --    ON  AL.LINE_ID      = RS.RESOURCE_NAME
            --    AND AL.SITE_ID      = RS.SITE_ID
            --    AND RS.RESOURCE_TYPE = 'LINE'
            --    AND RS.PLAN_ID       = @V_PLAN_ID


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
