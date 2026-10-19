

/*----------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                         
*----------------------------------------------------------------------------------------------
* EVERY CALENDAR는 구간 내 VALUE가 매일 적용되고 HRIZON은 구간 내 총량으로 적용 됨. 
****************************************************************************************************/
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_EE_INPUT_EVERY_DAY_CAL]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.05 Y.S.H Initial Release
    -- 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영.
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
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_EE_INPUT_EVERY_DAY_CAL';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    DECLARE @V_SCP_PLAN_DATE        NVARCHAR(8);
    DECLARE @V_SCP_PLAN_TYPE        NVARCHAR(100);
    DECLARE @V_PROD_FROZEN          INT;
    DECLARE @V_PROD_FROZEN_END      NVARCHAR(8);
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @EV_CAL_TEMP TABLE(
                               PLAN_ID        NVARCHAR(50)
                              ,RESOURCE_ID    NVARCHAR(100)
                              ,[TYPE]         NVARCHAR(100)
                              ,[START_DATE]   NVARCHAR(20)
                              ,END_DATE       NVARCHAR(20)
                              ,DAILY_VALUE    NVARCHAR(20)
                              ,CALENDAR_LEVEL NVARCHAR(20)
                              ,SITE_ID        NVARCHAR(100)
                              ,ITEM_ID        NVARCHAR(100)
                              ,LINE_ID        NVARCHAR(100)
                              )

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
        -- 2025.05.14 Philsu Park: Fixed Plan 존재 시 0값 반영을 위한 변수 할당.
        ------------------------------------------------------------------------
        -- Plan Type Check.
        SELECT    @V_SCP_PLAN_DATE = A.PLAN_START_YYYYMMDD
                , @V_SCP_PLAN_TYPE = A.PLAN_TYPE
        FROM  (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
                    , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_TYPE_ORDER DESC, PLAN_SEQ DESC ) AS PLAN_RANK
                FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
                -- 전극 Division 에 해당하는 사업부 확인
                WHERE  DIVISION_ID          = @V_DIVISION_ID -- Division 변수
                AND    PLAN_START_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -14, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 전주 월요일 YYYYMMDD
                AND    PLAN_START_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD,  -7, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 당주 월요일 YYYYMMDD
                ) A   
        WHERE PLAN_RANK = 1

        -- PR_SCP_OPT_ENG_INPUT_ITEM_BOM_ROUTING 에서 동일 정보 사용
        SELECT  @V_PROD_FROZEN = SEGMENT4
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
        WHERE   LOOKUP_TYPE = 'SCP_OPT_PROD_FROZEN'
        AND     VALID_YN    = 'Y'
        AND     SEGMENT1    = @V_DIVISION_ID
        AND     SEGMENT2    = @V_GROUP_ID
        AND     SEGMENT3    = @V_SCP_PLAN_TYPE 
        ;

        SET @V_PROD_FROZEN_END = CONVERT(CHAR(8), DATEADD(DD, ISNULL(@V_PROD_FROZEN, 0), @V_SCP_PLAN_DATE ), 112) -- Prod Frozen 다음 일자 정보
        ;
        ------------------------------------------------------------------------
        -- TEMP Data Insert
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

        INSERT INTO @EV_CAL_TEMP
        SELECT @V_PLAN_ID                 AS PLAN_ID
              ,SITE_ID+'::'+RESOURCE_NAME AS RESOURCE_ID
              ,TYPE                       AS TYPE          
              ,START_DATE                 AS START_DATE    
              ,END_DATE                   AS END_DATE      
              ,DAILY_VALUE                AS DAILY_VALUE   
              ,CALENDAR_LEVEL             AS CALENDAR_LEVEL
              ,SITE_ID                    AS SITE_ID
              ,ITEM_ID                    AS ITEM_ID
              ,LINE_ID                    AS LINE_ID
        FROM(
            ------------------------------------------------------------------------
            -- Add PLANT AND MODEL(L1) DATA
            ------------------------------------------------------------------------
            SELECT PLANT_SITE_ID AS SITE_ID
            	, ITEM_ID		 AS RESOURCE_NAME
            	, 'upper_limit'  AS TYPE
            	, ''			 AS START_DATE
            	, ''			 AS END_DATE
            	, DAILY_CAPA_QTY AS DAILY_VALUE
            	, 'L1'			 AS CALENDAR_LEVEL
                , ITEM_ID        AS ITEM_ID
                , NULL           AS LINE_ID
            FROM SCP_MST_OUTSOURCING_CAPA A WITH(NOLOCK)

			INNER JOIN #DIVISION D WITH(NOLOCK)
			ON A.DIVISION_ID = D.DIVISION_ID

            INNER JOIN SCP_OPT_ENG_RESOURCE_SN B WITH(NOLOCK) ON   B.PLAN_ID = @V_PLAN_ID
                                                           AND  CONCAT(A.PLANT_SITE_ID, '::', A.ITEM_ID) = B.RESOURCE_ID
            WHERE 1=1
            AND   VALID_YN = 'Y'
            ------------------------------------------------------------------------
            -- Add HOLIDAY(L5) DATA
            ------------------------------------------------------------------------
			UNION ALL
			/* -- BLOCKED 2025.10.30 jongykim2: Capa - No Work
			SELECT   SMD.SEGMENT2											AS SITE
					,ER.RESOURCE_NAME										AS RESOURCE_NAME
					,'upper_limit'											AS TYPE
					,SMD.SEGMENT5											AS START_DATE
					,CONVERT(VARCHAR(8),DATEADD(DAY, 1, SMD.SEGMENT5), 112) AS END_DATE
					,86400 - CONVERT(FLOAT,SMD.ATTRIBUTE1)    				AS DAILY_VALUE
					, 'L5'													AS CALENDAR_LEVEL
                    ,ER.ATTRIBUTE2                                          AS ITEM_ID
                    ,ER.ATTRIBUTE15                                         AS LINE_ID
			FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL  SMD WITH(NOLOCK)
					INNER JOIN SCP_OPT_ENG_RESOURCE_SN ER WITH(NOLOCk) 
						ON  ER.PLAN_ID		 = @V_PLAN_ID
						AND ER.RESOURCE_TYPE = 'LINE'
						AND ER.RESOURCE_NAME   = SMD.SEGMENT3
			WHERE	SMD.LOOKUP_TYPE = 'SCP_OPT_MASTER_NOWORK2_TEMP'
			--AND		SMD.ATTRIBUTE1	> 0
			AND     CONVERT(NUMERIC,SMD.ATTRIBUTE1)	> 0
			AND		SMD.SEGMENT1	= @V_DIVISION_ID -- 전극 Division 'EE'
			AND		SMD.SEGMENT5	BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
			AND     SMD.VALID_YN	= 'Y' */
			-- START 2025.10.30 jongykim2: Capa - No Work
            -- 2025.11.11 Minyong Lee : UI 테이블 LINE_TYPE 컬럼 추가
			SELECT	 ER.SITE_ID  												AS SITE_ID
				    ,CONCAT(SOW.LINE_ID, SOW.LINE_TYPE)							AS RESOURCE_NAME
					,'upper_limit'												AS TYPE
					,SOW.NO_WORK_DATE											AS START_DATE
					,CONVERT(VARCHAR(8),DATEADD(DAY, 1, SOW.NO_WORK_DATE), 112)	AS END_DATE
					,86400 - CONVERT(FLOAT,SOW.OFF_TIME)                        AS DAILY_VALUE
					, 'L5'														AS CALENDAR_LEVEL
					,''															AS ITEM_ID
					,CONCAT(SOW.LINE_ID, SOW.LINE_TYPE)         				AS LINE_ID
			FROM	(
                    SELECT  DIVISION_ID     AS DIVISION_ID
                          , LINE_ID         AS LINE_ID
                          , CASE
                                WHEN LINE_TYPE = 'Anode'   THEN '@A'
                                WHEN LINE_TYPE = 'Cathode' THEN '@C'
                                ELSE ''
                            END             AS LINE_TYPE
                          , NO_WORK_DATE    AS NO_WORK_DATE
                          , OFF_TIME        AS OFF_TIME
                    FROM    SCP_OPMZ_NO_WORK WITH(NOLOCK)
                    WHERE   1=1
                    AND     DIVISION_ID = 'EE_UC'--@V_DIVISION_ID
                    AND     VALID_YN = 'Y'
                    ) SOW
				INNER JOIN SCP_OPT_ENG_RESOURCE_SN ER WITH(NOLOCk) 
					ON  ER.PLAN_ID		 = @V_PLAN_ID
					AND ER.RESOURCE_TYPE = 'LINE'
					AND ER.RESOURCE_NAME   = CONCAT(SOW.LINE_ID, SOW.LINE_TYPE)
				--INNER JOIN ( SELECT DISTINCT DIVISION_ID, OPERATION_ID, OPERATION_GROUP 
				--			FROM   SCM_MST_OPERATION_FLOW_V WITH(NOLOCK) ) OP
				--	ON SOW.DIVISION_ID   = OP.DIVISION_ID
				--	AND SOW.OPERATION_ID = OP.OPERATION_ID
				--INNER JOIN SCM_MST_SITE C WITH(NOLOCK)
				--	ON     SOW.DIVISION_ID        = C.DIVISION_ID
				--	AND    SOW.PLANT_ID           = C.PLANT_ID
				--	AND    OP.OPERATION_GROUP     = C.OPERATION_GROUP
				--	AND    C.VALID_YN             = 'Y'
			WHERE 1=1
			AND   SOW.OFF_TIME		> 0
			AND	  SOW.NO_WORK_DATE	BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
			-- END 2025.10.30 jongykim2: Capa - No Work

             ) AS A
        ------------------------------------------------------------------------
        -- Add LINE(L0) DATA
        -- 인원 제약일 때 인원 수 만큼 UPPER LIMIT에 곱셈
        ------------------------------------------------------------------------
        UNION ALL
        SELECT RS.PLAN_ID                                      AS PLAN_ID
              ,RS.RESOURCE_ID                                  AS RESOURCE_ID
              ,'upper_limit'                                   AS TYPE
              ,@V_PLAN_START_YYYYMMDD                          AS START_DATE
              ,@V_PLAN_END_YYYYMMDD                            AS END_DATE
              ,CONVERT(NVARCHAR,86400*ISNULL(LU.ATTRIBUTE2,1)) AS DAILY_VALUE
              ,'L0'                                            AS CALENDAR_LEVEL
              ,RS.SITE_ID                                      AS SITE_ID
              ,RS.ATTRIBUTE2                                   AS ITEM_ID
              ,RS.ATTRIBUTE15                                  AS LINE_ID
        FROM  SCP_OPT_ENG_RESOURCE_SN RS WITH(NOLOCK)
            LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_LINE_PERSONNEL'
                AND VALID_YN = 'Y'
                AND SEGMENT2 = @V_DIVISION_ID
                AND RS.ATTRIBUTE15 = SEGMENT5
        WHERE RS.RESOURCE_TYPE = 'LINE'
          AND RS.PLAN_ID       = @V_PLAN_ID
        GROUP BY RS.PLAN_ID,RS.RESOURCE_ID,LU.ATTRIBUTE2,RS.SITE_ID,RS.ATTRIBUTE2,RS.ATTRIBUTE15

        ------------------------------------------------------------------------
        -- Add LINE(L0) DATA
        ------------------------------------------------------------------------
        UNION ALL
        SELECT PLAN_ID                AS PLAN_ID
              ,RESOURCE_ID            AS RESOURCE_ID
              ,'lower_limit'          AS TYPE
              ,@V_PLAN_START_YYYYMMDD AS START_DATE
              ,@V_PLAN_END_YYYYMMDD   AS END_DATE
              ,'0'                    AS DAILY_VALUE
              ,'L0'                   AS CALENDAR_LEVEL
              ,SITE_ID                AS SITE_ID
              ,ATTRIBUTE2             AS ITEM_ID
              ,ATTRIBUTE15            AS LINE_ID
        FROM  SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
        WHERE RESOURCE_TYPE = 'LINE'
          AND PLAN_ID       = @V_PLAN_ID
        ------------------------------------------------------------------------
        -- Add Production Equalization Constraint
        ------------------------------------------------------------------------
        UNION ALL
        SELECT PLAN_ID                                                                   AS PLAN_ID    
              ,RESOURCE_ID                                                               AS RESOURCE_ID
              ,TYPE                                                                      AS TYPE       
              ,IIF(START_DATE<=@V_PLAN_START_YYYYMMDD,@V_PLAN_START_YYYYMMDD,START_DATE) AS START_DATE
              ,IIF(END_DATE<=@V_PLAN_END_YYYYMMDD,END_DATE,@V_PLAN_END_YYYYMMDD)         AS END_DATE
              ,DAILY_VALUE                                                               AS DAILY_VALUE
              ,CALENDAR_LEVEL                                                            AS CALENDAR_LEVEL
              ,SITE_ID                                                                   AS SITE_ID
              ,ITEM_ID                                                                   AS ITEM_ID
              ,LINE_ID                                                                   AS LINE_ID
        FROM(
            SELECT @V_PLAN_ID                                             AS PLAN_ID
                  ,LU.SEGMENT3 +'::'+ LU.SEGMENT4                         AS RESOURCE_ID
                  ,'lower_limit'                                          AS TYPE
                  ,LU.ATTRIBUTE1                                          AS START_DATE
                  ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,LU.ATTRIBUTE2),112)  AS END_DATE
                  ,86400*CONVERT(INT,LU.SEGMENT5)/100                     AS DAILY_VALUE
                  ,'L3'                                                   AS CALENDAR_LEVEL
                  ,LU.SEGMENT3                                            AS SITE_ID
                  ,NULL                                                   AS ITEM_ID
                  ,LU.SEGMENT4                                            AS LINE_ID
            FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                INNER JOIN SCP_OPT_ENG_RESOURCE_SN RS WITH(NOLOCK)
                    ON  RS.PLAN_ID = @V_PLAN_ID
                    AND LU.SEGMENT3+'::'+LU.SEGMENT4 = RS.RESOURCE_ID
            WHERE 1=1
            AND LU.LOOKUP_TYPE = 'SCP_OPT_ENG_MIN_OPERATION'
            AND LU.SEGMENT2 = @V_DIVISION_ID -- 전극 Division 'EE'
		    AND LU.VALID_YN	= 'Y'
        ) MO



        ------------------------------------------------------------------------
        -- Data Insert Start
        -- 주석처리 된 부분 인원 제약 반영할 때 같이 반영 필요 -> 전극 테스트 때문에 반영하지 않음/20250422/김태현 선임
        ------------------------------------------------------------------------
        INSERT INTO @EV_CAL_TEMP
        --INSERT INTO SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN( -- 인원 제약까지 반영하여 한번에 INSERT
        --       PLAN_ID                                      -- 인원 제약까지 반영하여 한번에 INSERT
        --      ,RESOURCE_ID                                  -- 인원 제약까지 반영하여 한번에 INSERT
        --      ,[TYPE]                                       -- 인원 제약까지 반영하여 한번에 INSERT
        --      ,[START_DATE]                                 -- 인원 제약까지 반영하여 한번에 INSERT
        --      ,END_DATE                                     -- 인원 제약까지 반영하여 한번에 INSERT
        --      ,DAILY_VALUE                                  -- 인원 제약까지 반영하여 한번에 INSERT
        --      ,CALENDAR_LEVEL                               -- 인원 제약까지 반영하여 한번에 INSERT
        --      ,ATTRIBUTE1                                   -- 인원 제약까지 반영하여 한번에 INSERT
        --      ,ATTRIBUTE2                                   -- 인원 제약까지 반영하여 한번에 INSERT
        --      ,ATTRIBUTE15                                  -- 인원 제약까지 반영하여 한번에 INSERT
        --     )                                              -- 인원 제약까지 반영하여 한번에 INSERT
        SELECT PLAN_ID                                      -- 인원 제약까지 반영하여 한번에 INSERT
              ,RESOURCE_ID                                  -- 인원 제약까지 반영하여 한번에 INSERT
              ,TYPE                                         -- 인원 제약까지 반영하여 한번에 INSERT
              ,START_DATE                                   -- 인원 제약까지 반영하여 한번에 INSERT
              ,END_DATE                                     -- 인원 제약까지 반영하여 한번에 INSERT
              ,DAILY_VALUE                                  -- 인원 제약까지 반영하여 한번에 INSERT
              ,CALENDAR_LEVEL                               -- 인원 제약까지 반영하여 한번에 INSERT
              ,SITE_ID                                      -- 인원 제약까지 반영하여 한번에 INSERT
              ,ITEM_ID                                      -- 인원 제약까지 반영하여 한번에 INSERT
              ,LINE_ID                                      -- 인원 제약까지 반영하여 한번에 INSERT
        FROM @EV_CAL_TEMP                                   -- 인원 제약까지 반영하여 한번에 INSERT
        UNION ALL                                           -- 인원 제약까지 반영하여 한번에 INSERT
        ------------------------------------------------------------------------
        -- Add Minimize weekend operations Constraint
        ------------------------------------------------------------------------
        --SELECT @V_PLAN_ID    AS PLAN_ID
        --      ,RESOURCE_ID   AS RESOURCE_ID
        --      ,'lower_limit' AS TYPE
        --      ,YYYYMMDD      AS START_DATE
        --      ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,YYYYMMDD),112) AS END_DATE
        --      ,WORK_TIME     AS DAILY_VALUE
        --      ,'L4'          AS CALENDAR_LEVEL
        --      ,A.SITE_ID     AS SITE_ID
        --      ,NULL          AS ITEM_ID
        --      ,A.LINE_ID     AS LINE_ID
        --FROM(
        --            SELECT DISTINCT SITE_ID, LINE_ID, RESOURCE_ID
        --            FROM @EV_CAL_TEMP
        --) A
        --CROSS JOIN (
        --            SELECT  BASIS_YYYYMMDD AS YYYYMMDD
        --                   ,SEGMENT3       AS DAY
        --                   ,SEGMENT4       AS WORK_TIME
        --            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        --                INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK) 
        --                ON  LU.SEGMENT3 = CAL.DAYOFWEEK
        --                AND CAL.BASIS_YYYYMMDD >= @V_PLAN_START_YYYYMMDD
        --                AND CAL.BASIS_YYYYMMDD < @V_PLAN_END_YYYYMMDD
        --            WHERE 1=1
        --            AND     LOOKUP_TYPE = 'SCP_OPT_ENG_MIN_WEEKEND'
        --            AND     SEGMENT2 = @V_DIVISION_ID -- 전극 Division 'EE'
        --            AND     SEGMENT4 !=0
        --            AND     LU.VALID_YN = 'Y'
        --) B
        ------------------------------------------------------------------------
        -- 주말 가동 최소화 LINE대로 적용으로 변경/태원 책임님 요청사항/20250612/김태현 선임
        ------------------------------------------------------------------------
        SELECT  @V_PLAN_ID                                                 AS PLAN_ID
               ,SEGMENT3+'::'+SEGMENT4                                     AS RESOURCE_ID
              ,'lower_limit'                                               AS TYPE
               ,CAL.BASIS_YYYYMMDD                                         AS START_DATE
               ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CAL.BASIS_YYYYMMDD),112) AS END_DATE
               ,SEGMENT6                                                   AS DAILY_VALUE
               ,'L4'                                                       AS CALENDAR_LEVEL
               ,SEGMENT3                                                   AS SCM_SITE_ID
               ,NULL                                                       AS ITEM_ID
               ,SEGMENT4                                                   AS LINE_ID
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK) 
                ON  1=1
                AND LU.SEGMENT5 = CAL.DAYOFWEEK
                AND CAL.BASIS_YYYYMMDD >= @V_PLAN_START_YYYYMMDD
                AND CAL.BASIS_YYYYMMDD <  @V_PLAN_END_YYYYMMDD
        WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_MIN_WEEKEND_NEW'
        AND     LU.VALID_YN    = 'Y'
        AND     LU.SEGMENT1    = @V_DIVISION_ID
        AND     LU.SEGMENT2    = @V_GROUP_ID
        AND     LU.SEGMENT7    = 'A'
		
        UNION ALL
        SELECT @V_PLAN_ID                     AS PLAN_ID
              ,SCM_SITE_ID+'::'+RESOURCE_NAME AS RESOURCE_ID
              ,'upper_limit'                  AS TYPE
              ,START_DATE                     AS START_DATE
              ,END_DATE						  AS END_DATE
              ,MAX_CAPA                       AS DAILY_VALUE
              ,'L2'                           AS CALENDAR_LEVEL
              ,SCM_SITE_ID                    AS SITE_ID
              ,NULL                           AS ITEM_ID
              ,NULL                           AS LINE_ID
        FROM(
            /*SELECT  SEGMENT3   AS SCM_SITE_ID
                   ,SEGMENT4   AS STORAGE_ID
                   ,SEGMENT5   AS STAGE
                   ,SEGMENT4 AS RESOURCE_NAME
                   ,GREATEST(ISNULL(ATTRIBUTE2,@V_PLAN_START_YYYYMMDD), @V_PLAN_START_YYYYMMDD) AS START_DATE
                   ,LEAST(ISNULL(CONVERT(VARCHAR(8),DATEADD(DAY, 1, ATTRIBUTE3), 112),@V_PLAN_END_YYYYMMDD), @V_PLAN_END_YYYYMMDD) AS END_DATE
                   ,ATTRIBUTE4 AS MAX_CAPA
            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SL_CAPA'
            AND     LU.SEGMENT2     = @V_DIVISION_ID
            AND     LU.VALID_YN = 'Y'*/-- BLOCKED 2025.12.04 jongykim2: Warehouse Capacity
            -- ADDED 2025.12.04 jongykim2: Warehouse Capacity
            SELECT T.SCM_SITE_ID AS SCM_SITE_ID
                 , T.WH_NM       AS STORAGE_ID
                 , T.STAGE       AS STAGE
                 , T.WH_NM       AS RESOURCE_NAME
                 , IIF(T.FROM_YYYYMMDD < @V_PLAN_START_YYYYMMDD, @V_PLAN_START_YYYYMMDD,T.FROM_YYYYMMDD) AS START_DATE
                 , IIF(CONVERT(NVARCHAR(8),DATEADD(DAY, 1, T.TO_YYYYMMDD), 112) > @V_PLAN_END_YYYYMMDD, @V_PLAN_END_YYYYMMDD
                      ,CONVERT(NVARCHAR(8),DATEADD(DAY, 1, T.TO_YYYYMMDD), 112)) AS END_DATE
                 , CONVERT(NVARCHAR(100),T.MAX_CAPA) AS MAX_CAPA
            FROM   SCP_OPMZ_WAREHOUSE_CAPACITY T WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
            ON     T.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
            WHERE  T.DIVISION_ID     = @V_DIVISION_ID
            AND    PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
            AND    T.VALID_YN        = 'Y'
            AND    PG.VALID_YN       = 'Y'
            AND    T.TO_YYYYMMDD >= @V_PLAN_START_YYYYMMDD
            AND    T.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
            ) CP
			-- 
        UNION ALL
        SELECT @V_PLAN_ID                     AS PLAN_ID
              ,SCM_SITE_ID+'::'+RESOURCE_NAME AS RESOURCE_ID
              ,'upper_limit'                  AS TYPE
              ,START_DATE                     AS START_DATE
              ,END_DATE						  AS END_DATE
              ,'999999999'                    AS DAILY_VALUE
              ,'L1'                           AS CALENDAR_LEVEL
              ,SCM_SITE_ID                    AS SITE_ID
              ,NULL                           AS ITEM_ID
              ,NULL                           AS LINE_ID
        FROM(
            /*SELECT  SEGMENT3   AS SCM_SITE_ID
                   ,SEGMENT4   AS STORAGE_ID
                   ,SEGMENT5   AS STAGE
                   ,SEGMENT4   AS RESOURCE_NAME
                   ,@V_PLAN_START_YYYYMMDD AS START_DATE
                   ,@V_PLAN_END_YYYYMMDD   AS END_DATE
                   ,ATTRIBUTE4 AS MAX_CAPA
            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SL_CAPA'
            AND     LU.SEGMENT2     = @V_DIVISION_ID
            AND     LU.VALID_YN = 'Y'*/-- BLOCKED 2025.12.04 jongykim2: Warehouse Capacity
            -- ADDED 2025.12.04 jongykim2: Warehouse Capacity
            SELECT T.SCM_SITE_ID AS SCM_SITE_ID
                 , T.WH_NM       AS STORAGE_ID
                 , T.STAGE       AS STAGE
                 , T.WH_NM       AS RESOURCE_NAME
                 , @V_PLAN_START_YYYYMMDD AS START_DATE
                 , @V_PLAN_END_YYYYMMDD AS END_DATE
                 , T.MAX_CAPA    AS MAX_CAPA
            FROM   SCP_OPMZ_WAREHOUSE_CAPACITY T WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
            ON     T.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
            WHERE  T.DIVISION_ID     = @V_DIVISION_ID
            AND    PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
            AND    T.VALID_YN        = 'Y'
            AND    PG.VALID_YN       = 'Y'
            AND    T.TO_YYYYMMDD >= @V_PLAN_START_YYYYMMDD
            AND    T.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
            ) CP

        ------------------------------------------------------------------------
        -- 인원 제약 반영
        -- 주석처리 된 부분 인원 제약 반영할 때 같이 반영 필요 -> 전극 테스트 때문에 반영하지 않음/20250422/김태현 선임
        ------------------------------------------------------------------------
        INSERT INTO @EV_CAL_TEMP
        SELECT  ECT.PLAN_ID                                     AS PLAN_ID
               ,LP.SEGMENT3+'::'+LP.SEGMENT5                    AS RESOURCE_ID
               ,ECT.TYPE                                        AS TYPE
               ,MIN(ECT.START_DATE)                             AS SATRT_DATE
               ,MAX(ECT.END_DATE)                               AS END_DATE
               --,CONVERT(INT,MAX(ECT.DAILY_VALUE))*LP.ATTRIBUTE2 AS DAILY_VALUE -- blocked, type error
               ,CONVERT(INT,MAX(CONVERT(NUMERIC(18,10),ECT.DAILY_VALUE)))*LP.ATTRIBUTE2 AS DAILY_VALUE
               ,ECT.CALENDAR_LEVEL                              AS CALENDAR_LEVEL
               ,LP.SEGMENT3                                     AS SITE_ID
               ,NULL                                            AS ITEM_ID
               ,SEGMENT5                                        AS LINE_ID
        FROM    @EV_CAL_TEMP ECT
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LP WITH(NOLOCK)
                ON  LP.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_LINE_PERSONNEL'
                AND LP.SEGMENT2 = @V_DIVISION_ID
                AND ECT.SITE_ID = LP.SEGMENT3
                AND ECT.LINE_ID = LP.SEGMENT4
                AND LP.VALID_YN = 'Y'
        WHERE   ECT.CALENDAR_LEVEL = 'L3'
        GROUP BY ECT.PLAN_ID, LP.SEGMENT3, LP.SEGMENT5, ECT.TYPE, ECT.CALENDAR_LEVEL, LP.ATTRIBUTE2
        UNION ALL
        SELECT  ECT.PLAN_ID                                     AS PLAN_ID
               ,LP.SEGMENT3+'::'+LP.SEGMENT5                    AS RESOURCE_ID
               ,ECT.TYPE                                        AS TYPE
               ,ECT.START_DATE                                  AS SATRT_DATE
               ,ECT.END_DATE                                    AS END_DATE
               --,AVG(CONVERT(INT,ECT.DAILY_VALUE))*LP.ATTRIBUTE2 AS DAILY_VALUE -- blocked, type error
               ,AVG(CONVERT(INT,CONVERT(NUMERIC(18,10),ECT.DAILY_VALUE)))*LP.ATTRIBUTE2 AS DAILY_VALUE
               ,ECT.CALENDAR_LEVEL                              AS CALENDAR_LEVEL
               ,LP.SEGMENT3                                     AS SITE_ID
               ,NULL                                            AS ITEM_ID
               ,SEGMENT5                                        AS LINE_ID
        FROM    @EV_CAL_TEMP ECT
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LP WITH(NOLOCK)
                ON  LP.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_LINE_PERSONNEL'
                AND LP.SEGMENT2 = @V_DIVISION_ID
                AND ECT.SITE_ID = LP.SEGMENT3
                AND ECT.LINE_ID = LP.SEGMENT4
                AND LP.VALID_YN = 'Y'
        WHERE   ECT.CALENDAR_LEVEL = 'L4'
        GROUP BY ECT.PLAN_ID, LP.SEGMENT3, LP.SEGMENT5, ECT.TYPE, ECT.START_DATE, ECT.END_DATE, ECT.CALENDAR_LEVEL, LP.ATTRIBUTE2
        UNION ALL
        ------------------------------------------------------------------------------------------------------------------------------------------------
        -- 2025.06.11 Philsu Park: DAILY_VALUE 계산 시 TYPE CASTING 에러 발생 방지를 위한 수정.
        ------------------------------------------------------------------------------------------------------------------------------------------------
        SELECT  ECT.PLAN_ID                                     AS PLAN_ID
               ,LP.SEGMENT3+'::'+LP.SEGMENT5                    AS RESOURCE_ID
               ,ECT.TYPE                                        AS TYPE
               ,ECT.START_DATE                                  AS SATRT_DATE
               ,ECT.END_DATE                                    AS END_DATE
               ,CONVERT(NUMERIC(18, 4), CONVERT(NUMERIC(20, 10),MAX(ECT.DAILY_VALUE))*LP.ATTRIBUTE2) AS DAILY_VALUE
               ,ECT.CALENDAR_LEVEL                              AS CALENDAR_LEVEL
               ,LP.SEGMENT3                                     AS SITE_ID
               ,NULL                                            AS ITEM_ID
               ,SEGMENT5                                        AS LINE_ID
        FROM    @EV_CAL_TEMP ECT
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LP WITH(NOLOCK)
                ON  LP.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_LINE_PERSONNEL'
                AND LP.SEGMENT2 = @V_DIVISION_ID
                AND ECT.SITE_ID = LP.SEGMENT3
                AND ECT.LINE_ID = LP.SEGMENT4
                AND LP.VALID_YN = 'Y'
        WHERE   ECT.CALENDAR_LEVEL = 'L5'
        GROUP BY ECT.PLAN_ID, LP.SEGMENT3, LP.SEGMENT5, ECT.TYPE, ECT.START_DATE, ECT.END_DATE, ECT.CALENDAR_LEVEL, LP.ATTRIBUTE2
        ------------------------------------------------------------------------
        -- 2025.05.15 Philsu Park
        -- Frozen 이후 Fix 로 입력된 구간에 대해 L6로 제약 추가.
        -- 2025.05.20 Philsu Park: GROUP_ID 조건 추가.
        ------------------------------------------------------------------------
        UNION ALL
        SELECT	 @V_PLAN_ID                                     AS PLAN_ID
                ,CONCAT(LVF.SEGMENT5, '::', LVF.ATTRIBUTE1)	    AS RESOURCE_ID
                ,'upper_limit'                                  AS TYPE
                , LVF.ATTRIBUTE3                                AS START_DATE
                , CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATETIME, LVF.ATTRIBUTE3)), 112) AS END_DATE
                , '0'                                           AS DAILY_VALUE
                , 'L6'                                          AS CALENDAR_LEVEL
                ,LVF.SEGMENT5   AS SITE_ID
                ,NULL           AS ITEM_ID -- 기존 데이터들 전부 NULL이길래 일단 NULL로 유지.
                ,LVF.ATTRIBUTE1 AS LINE_ID
        FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL LVF WITH(NOLOCK)
        INNER JOIN ( 
                    SELECT A.*
                    FROM   SCM_MST_SITE A WITH (NOLOCK)
                    INNER JOIN #DIVISION D WITH(NOLOCK)
                        ON A.DIVISION_ID    = D.DIVISION_ID
                    WHERE  1=1--A.DIVISION_ID        = @V_DIVISION_ID 
                    AND    A.SITE_TYPE          = 'PLANT'
                    AND    A.VALID_YN           = 'Y'	
                    AND    A.OPERATION_GROUP    IN ('A', 'E')
                    ) MSE
            ON   LVF.SEGMENT5 = MSE.SCM_SITE_ID 
        INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN F   -- 2025.05.16 Philsu Park: Stage 단위 Frozen 구분 적용 / 2025.09.22 김태현 : Frozen Master 테이블로 대체
            ON  1=1
			AND F.PLAN_ID = @V_PLAN_ID
			AND CASE WHEN LVF.SEGMENT4 = 'A5000'    THEN 'NND'
                     WHEN LVF.SEGMENT4 = 'E2000'    THEN 'COATING'
                     END = F.STAGE
            AND LVF.ATTRIBUTE3 >= F.FROZEN_END_DATE
        WHERE	LVF.LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
        AND     LVF.SEGMENT3    = @V_GROUP_ID           -- GROUP_ID 제약조건 추가
        --AND		LVF.ATTRIBUTE3 >= @V_PROD_FROZEN_END    -- Frozen 구간 이후 FIX 만 적용
        AND		LVF.ATTRIBUTE3  <  @V_PLAN_END_YYYYMMDD
        AND     LVF.VALID_YN    = 'Y'
        AND     LVF.ATTRIBUTE1 IN ( SELECT DISTINCT ATTRIBUTE15
                                    FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                    WHERE   PLAN_ID         = @V_PLAN_ID
                                    AND     RESOURCE_TYPE   = 'LINE'
                                    )
        AND     CONCAT(LVF.SEGMENT5, LVF.ATTRIBUTE2)
                               IN ( SELECT DISTINCT CONCAT(SCM_SITE_ID,ITEM_ID)
                                    FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                    WHERE  PLAN_ID = @V_PLAN_ID
                                    )
        GROUP BY CONCAT(LVF.SEGMENT5, '::', LVF.ATTRIBUTE1), LVF.ATTRIBUTE3, LVF.SEGMENT5, LVF.ATTRIBUTE1
        ;
        ------------------------------------------------------------------------
        -- 본 테이블 반영
        -- 주석처리 된 부분 인원 제약 반영할 때 같이 반영 필요 -> 전극 테스트 때문에 반영하지 않음/20250422/김태현 선임
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN( -- 인원 제약까지 반영하여 한번에 INSERT
               PLAN_ID                                      -- 인원 제약까지 반영하여 한번에 INSERT
              ,RESOURCE_ID                                  -- 인원 제약까지 반영하여 한번에 INSERT
              ,[TYPE]                                       -- 인원 제약까지 반영하여 한번에 INSERT
              ,[START_DATE]                                 -- 인원 제약까지 반영하여 한번에 INSERT
              ,END_DATE                                     -- 인원 제약까지 반영하여 한번에 INSERT
              ,DAILY_VALUE                                  -- 인원 제약까지 반영하여 한번에 INSERT
              ,CALENDAR_LEVEL                               -- 인원 제약까지 반영하여 한번에 INSERT
              ,ATTRIBUTE1                                   -- 인원 제약까지 반영하여 한번에 INSERT
              ,ATTRIBUTE2                                   -- 인원 제약까지 반영하여 한번에 INSERT
              ,ATTRIBUTE15                                  -- 인원 제약까지 반영하여 한번에 INSERT
             )                                              -- 인원 제약까지 반영하여 한번에 INSERT
            SELECT PLAN_ID                                      -- 인원 제약까지 반영하여 한번에 INSERT
                ,RESOURCE_ID                                  -- 인원 제약까지 반영하여 한번에 INSERT
                ,TYPE                                         -- 인원 제약까지 반영하여 한번에 INSERT
                ,START_DATE                                   -- 인원 제약까지 반영하여 한번에 INSERT
                ,END_DATE                                     -- 인원 제약까지 반영하여 한번에 INSERT
                --,DAILY_VALUE                                  -- 인원 제약까지 반영하여 한번에 INSERT -- BLOCKED jongykim2, DUP에러 회피
                ,CONVERT(NVARCHAR(100), CONVERT(FLOAT, DAILY_VALUE)) AS DAILY_VALUE -- ADDED jongykim2, DUP에러 회피
                ,CALENDAR_LEVEL                               -- 인원 제약까지 반영하여 한번에 INSERT
                ,SITE_ID                                      -- 인원 제약까지 반영하여 한번에 INSERT
                ,ITEM_ID                                      -- 인원 제약까지 반영하여 한번에 INSERT
                ,LINE_ID                                      -- 인원 제약까지 반영하여 한번에 INSERT
            FROM @EV_CAL_TEMP                                   -- 인원 제약까지 반영하여 한번에 INSERT
            --GROUP BY PLAN_ID, RESOURCE_ID, TYPE, START_DATE, END_DATE, DAILY_VALUE, CALENDAR_LEVEL, SITE_ID, ITEM_ID, LINE_ID -- BLOCKED jongykim2, DUP에러 회피
            GROUP BY PLAN_ID, RESOURCE_ID, TYPE, START_DATE, END_DATE, CONVERT(NVARCHAR(100), CONVERT(FLOAT, DAILY_VALUE)), CALENDAR_LEVEL, SITE_ID, ITEM_ID, LINE_ID -- ADDED jongykim2, DUP에러 회피
        ;

        ------------------------------------------------------------------------
        -- 2025.07.02 Philsu Park
        -- 생산 가동률 업데이트. Line 정보 존재하는 upper_limit 제약 일괄.
        ------------------------------------------------------------------------
        -- START 2025.10.27 jongykim2: Capa - Utilization Rate
        WITH UTIL_RT AS (
            SELECT RT.DIVISION_ID
                 , RT.PLANT_ID
                 , RT.LINE_ID
                 , RT.OPERATION_ID
                 , CASE
                       WHEN LEFT(RT.OPERATION_ID, 1) = 'E' THEN 'E' ELSE 'A'
                   END AS OPERATION_GROUP
                 , RT.FROM_DATE
                 , RT.TO_DATE
                 , RT.UTIL_RT ---- NUMERIC
                 , RT.VALID_YN
            --select rt.*
            FROM   SCP_OPMZ_UTIL_RT RT WITH(NOLOCK)
            WHERE  1 = 1
            AND    RT.DIVISION_ID = @V_DIVISION_ID
            AND    RT.VALID_YN = 'Y'
        ), OP_RATE AS (
            SELECT MS.SCM_SITE_ID AS SITE_ID
                 , RT.LINE_ID
                 , RT.FROM_DATE AS FROM_YYYYMMDD
                 , RT.TO_DATE AS TO_YYYYMMDD
                 , RT.UTIL_RT/100.0 AS PROD_RATIO
            FROM   UTIL_RT RT WITH(NOLOCK)
            INNER JOIN (
                SELECT @V_DIVISION_ID ELEC_DIVISION_ID
                     , T.DIVISION_ID
                FROM   #DIVISION T WITH(NOLOCK)
               ) AS D
            ON     D.ELEC_DIVISION_ID = RT.DIVISION_ID
            INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
            ON     MS.DIVISION_ID = D.DIVISION_ID
            AND    MS.PLANT_ID = RT.PLANT_ID
            AND    MS.OPERATION_GROUP = RT.OPERATION_GROUP
            WHERE  MS.SITE_TYPE = 'PLANT'
            AND    MS.VALID_YN  = 'Y'
        )
        UPDATE  CAL
        SET     CAL.DAILY_VALUE = CONVERT(NVARCHAR, ROUND(ISNULL(OP.PROD_RATIO, 1) * CONVERT(FLOAT, CAL.DAILY_VALUE), 0))
            ,   UPDATE_ID = 'OP_RATE_UPDATE'
            ,   UPDATE_TIME = CURRENT_TIMESTAMP
        FROM    SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN CAL
        LEFT OUTER JOIN OP_RATE OP
            ON  OP.SITE_ID          = CAL.ATTRIBUTE1
            AND OP.LINE_ID          = CAL.ATTRIBUTE15
            AND OP.FROM_YYYYMMDD   <= CAL.START_DATE
            AND OP.TO_YYYYMMDD     >= CAL.START_DATE
            AND OP.FROM_YYYYMMDD   <= CAL.END_DATE
            AND OP.TO_YYYYMMDD     >= CAL.END_DATE
        WHERE   CAL.PLAN_ID = @V_PLAN_ID
        AND     CAL.TYPE    = 'upper_limit'
        ;
        -- END 2025.10.27 jongykim2: Capa - Utilization Rate
		/* -- BLOCKED 2025.10.27 jongykim2: Capa - Utilization Rate
        WITH OP_RATE AS 
                (
                    SELECT    SEGMENT3                      AS SITE_ID
                            , SEGMENT4                      AS LINE_ID
                            , ATTRIBUTE1                    AS FROM_YYYYMMDD
                            , ATTRIBUTE2                    AS TO_YYYYMMDD
                            , CONVERT(FLOAT, SEGMENT5)/100    AS PROD_RATIO
                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL
                    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_OPERATION_RATE'
                    AND     VALID_YN    = 'Y'
                    AND     SEGMENT2    = @V_DIVISION_ID
                )
        UPDATE  CAL
        SET     CAL.DAILY_VALUE = CONVERT(NVARCHAR, ROUND(ISNULL(OP.PROD_RATIO, 1) * CONVERT(FLOAT, CAL.DAILY_VALUE), 0))
            ,   UPDATE_ID = 'OP_RATE_UPDATE'
            ,   UPDATE_TIME = CURRENT_TIMESTAMP
        FROM    SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN CAL
        LEFT OUTER JOIN OP_RATE OP
            ON  OP.SITE_ID          = CAL.ATTRIBUTE1
            AND OP.LINE_ID          = CAL.ATTRIBUTE15
            AND OP.FROM_YYYYMMDD   <= CAL.START_DATE
            AND OP.TO_YYYYMMDD     >= CAL.START_DATE
            AND OP.FROM_YYYYMMDD   <= CAL.END_DATE
            AND OP.TO_YYYYMMDD     >= CAL.END_DATE
        WHERE   CAL.PLAN_ID = @V_PLAN_ID
        AND     CAL.TYPE    = 'upper_limit'
        ; */
        ------------------------------------------------------------------------
        -- UPDATE END.
        ------------------------------------------------------------------------

        -- 2026.05.29 Minyong Lee : EVERYCAL ATTRIBUTE13에 비조업 description 추가 - 소형 시나리오 플래닝 대응 건
        UPDATE REC
        SET    REC.ATTRIBUTE12 = IIF(NW.[DESC]='', NULL, NW.[DESC])
             , REC.ATTRIBUTE13 = IIF(NW.ATTRIBUTE2='', NULL, NW.ATTRIBUTE2) -- 2026.09.10 Minyong Lee : [E20260910-001258] 최적화 Input에 비조업 Desc 정보 추가 요청
        FROM   SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN REC WITH(NOLOCK)
            LEFT JOIN (
                SELECT  * 
                FROM    SCP_OPMZ_NO_WORK WITH(NOLOCK) 
                WHERE   1=1
                AND     DIVISION_ID = @V_DIVISION_ID
            ) NW
                ON  REC.ATTRIBUTE15 = NW.LINE_ID
                AND REC.START_DATE = NW.NO_WORK_DATE
        WHERE   REC.PLAN_ID = @V_PLAN_ID
        AND     REC.TYPE = 'upper_limit'
        AND     REC.CALENDAR_LEVEL = 'L5'

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
