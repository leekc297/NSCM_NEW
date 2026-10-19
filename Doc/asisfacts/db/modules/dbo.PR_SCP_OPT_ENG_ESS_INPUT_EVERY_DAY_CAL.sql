

/*----------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                         
*----------------------------------------------------------------------------------------------
* EVERY CALENDAR는 구간 내 VALUE가 매일 적용되고 HRIZON은 구간 내 총량으로 적용 됨. 
****************************************************************************************************/
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_ESS_INPUT_EVERY_DAY_CAL]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.05 Y.S.H Initial Release
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
    DECLARE @V_PROGRAM_NAME         NVARCHAR(150) = 'PR_SCP_OPT_ENG_ESS_INPUT_EVERY_DAY_CAL';
    DECLARE @V_PLAN_ID              NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT         NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE          DATETIME;
    DECLARE @V_SCP_PLAN_DATE        NVARCHAR(8);
    DECLARE @V_SCP_PLAN_TYPE        NVARCHAR(100);
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
	BEGIN TRY

		-- START 2025.10.30 jongykim2: Capa - No Work
		IF OBJECT_ID('TEMPDB..#NOWORK_T') IS NOT NULL
		BEGIN 
			DROP TABLE  #NOWORK_T;
		END;

		SELECT	 C.SCM_SITE_ID												AS SITE
				,SOW.LINE_ID												AS RESOURCE_NAME
				,'upper_limit'												AS TYPE
				,SOW.NO_WORK_DATE											AS START_DATE
				,CONVERT(VARCHAR(8),DATEADD(DAY, 1, SOW.NO_WORK_DATE), 112)	AS END_DATE
				,86400 - CONVERT(FLOAT,SOW.OFF_TIME)                        AS DAILY_VALUE
				, 'L5'														AS CALENDAR_LEVEL
				,''															AS ITEM_ID
				,LINE_ID													AS LINE_ID
		INTO	#NOWORK_T
		FROM	SCP_OPMZ_NO_WORK SOW WITH(NOLOCK)
				INNER JOIN SCP_OPT_ENG_RESOURCE_SN ER WITH(NOLOCk) 
					ON  ER.PLAN_ID		 = @V_PLAN_ID
					AND ER.RESOURCE_TYPE = 'LINE'
					AND ER.RESOURCE_NAME   = SOW.LINE_ID
				INNER JOIN ( SELECT DISTINCT DIVISION_ID, OPERATION_ID, OPERATION_GROUP 
							FROM   SCM_MST_OPERATION_FLOW_V WITH(NOLOCK) ) OP
					ON SOW.DIVISION_ID   = OP.DIVISION_ID
					AND SOW.OPERATION_ID = OP.OPERATION_ID
				INNER JOIN SCM_MST_SITE C WITH(NOLOCK)
					ON     SOW.DIVISION_ID        = C.DIVISION_ID
					AND    SOW.PLANT_ID           = C.PLANT_ID
					AND    OP.OPERATION_GROUP     = C.OPERATION_GROUP
					AND    C.VALID_YN             = 'Y'
		WHERE 1=1
		AND   SOW.OFF_TIME		> 0
		AND   SOW.DIVISION_ID	= @V_DIVISION_ID
		AND	  SOW.NO_WORK_DATE	BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
		AND   SOW.VALID_YN		= 'Y'
		-- END 2025.10.30 jongykim2: Capa - No Work

        ------------------------------------------------------------------------
        -- TEMP Data Insert
        ------------------------------------------------------------------------

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
            INNER JOIN SCP_OPT_ENG_RESOURCE_SN B WITH(NOLOCK) ON   B.PLAN_ID = @V_PLAN_ID
                                                           AND  CONCAT(A.PLANT_SITE_ID, '::', A.ITEM_ID) = B.RESOURCE_ID
            WHERE 1=1
            AND	  DIVISION_ID = @V_DIVISION_ID
            AND   VALID_YN = 'Y'
            ------------------------------------------------------------------------
            -- Add HOLIDAY(L5) DATA
            ------------------------------------------------------------------------
			/* -- BLOCKED 2025.10.30 jongykim2: Capa - No Work
			UNION ALL
			------------------------------------------------------------------------
			SELECT   SMD.SEGMENT2											AS SITE
					,ER.RESOURCE_NAME										AS RESOURCE_NAME
					,'upper_limit'											AS TYPE
					,SMD.SEGMENT5											AS START_DATE
					,CONVERT(VARCHAR(8),DATEADD(DAY, 1, SMD.SEGMENT5), 112) AS END_DATE
					,86400 - CONVERT(FLOAT,SMD.ATTRIBUTE1)                  AS DAILY_VALUE
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
			AND		SMD.SEGMENT1	= @V_DIVISION_ID
			AND		SMD.SEGMENT5	BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
			AND     SMD.VALID_YN	= 'Y' */
            ------------------------------------------------------------------------
            -- Add HOLIDAY(L5) For 외주. 비조업 없이 가용시간만 분단위 입력이므로 가용시간을 L5로
            -- 2025.08.07 Philsu Park: 비조업 룩업에 입력된 SITE는 제외하는 조건 추가.
            ------------------------------------------------------------------------
			UNION ALL
			------------------------------------------------------------------------
			SELECT   SMW.PLANT_SITE_ID										AS SITE
					,ER.RESOURCE_NAME										AS RESOURCE_NAME
					,'upper_limit'											AS TYPE
					,SMW.YYYYMMDD											AS START_DATE
					,CONVERT(VARCHAR(8),DATEADD(DAY, 1, SMW.YYYYMMDD), 112) AS END_DATE
					,SMW.WORKING_TIME*60									AS DAILY_VALUE
					, 'L5'													AS CALENDAR_LEVEL
					,ER.ATTRIBUTE2                                          AS ITEM_ID
					,ER.ATTRIBUTE15                                         AS LINE_ID
			FROM	SCP_MST_WORKING_TIME			   SMW WITH(NOLOCK)
					INNER JOIN SCP_OPT_ENG_RESOURCE_SN ER  WITH(NOLOCk) 
						ON  ER.PLAN_ID		 = @V_PLAN_ID
						AND ER.RESOURCE_TYPE = 'LINE'
						AND ER.RESOURCE_NAME   = SMW.LINE_ID
						AND ER.SITE_ID		   = SMW.PLANT_SITE_ID
			WHERE	SMW.DIVISION_ID	= @V_DIVISION_ID
			AND		SMW.YYYYMMDD	BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
            AND     NOT EXISTS (-- ADDED 2025.10.30 jongykim2: Capa - No Work
								SELECT  1
								FROM    #NOWORK_T T
								WHERE   T.SITE = SMW.PLANT_SITE_ID
								/* -- BLOCKED 2025.10.30 jongykim2: Capa - No Work
								SELECT  1
                                FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                WHERE   LOOKUP_TYPE = 'SCP_OPT_MASTER_NOWORK2_TEMP'
                                AND     VALID_YN    = 'Y'
                                AND	    SEGMENT1	= @V_DIVISION_ID
                                AND	    SEGMENT5	BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
                                AND     SEGMENT2    = SMW.PLANT_SITE_ID
								*/
                                )
			-----------------------------------------------------------------------------------------
			-- START 2025.10.30 jongykim2: Capa - No Work, NOWORK LV -> UI TABLE로 대체
			-----------------------------------------------------------------------------------------
			UNION ALL
			SELECT T.SITE
				  ,T.RESOURCE_NAME
				  ,T.TYPE
				  ,T.START_DATE
				  ,T.END_DATE
				  ,T.DAILY_VALUE
				  ,T.CALENDAR_LEVEL
				  ,T.ITEM_ID
				  ,T.LINE_ID
			FROM   #NOWORK_T T
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
        SELECT PLAN_ID
              ,RESOURCE_ID
              ,'upper_limit'          AS TYPE
              ,@V_PLAN_START_YYYYMMDD AS START_DATE
              ,@V_PLAN_END_YYYYMMDD   AS END_DATE
              ,'86400'                AS DAILY_VALUE
              ,'L0'                   AS CALENDAR_LEVEL
              ,SITE_ID                AS SITE_ID
              ,ATTRIBUTE2             AS ITEM_ID
              ,ATTRIBUTE15            AS LINE_ID
        FROM  SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
        WHERE RESOURCE_TYPE = 'LINE'
          AND PLAN_ID       = @V_PLAN_ID
        ------------------------------------------------------------------------
        -- Add LINE(L0) DATA
        ------------------------------------------------------------------------
        UNION ALL
        SELECT PLAN_ID
              ,RESOURCE_ID
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
            AND LU.SEGMENT2 = @V_DIVISION_ID
		    AND LU.VALID_YN	= 'Y'
        ) MO

        ------------------------------------------------------------------------
        -- 생산 준비율 추가
        -- 비조업을 확인해야해서 따로 INSERT
        -- 2025.07.03 Philsu Park: 생산준비율은 엔진 수행일자 기준으로 읽어옴.
        ------------------------------------------------------------------------
        INSERT INTO @EV_CAL_TEMP
        SELECT @V_PLAN_ID                                               AS PLAN_ID
              ,BF.RESOURCE_ID                                           AS RESOURCE_ID
              ,'upper_limit'                                            AS TYPE
              ,BF.START_DATE                                            AS START_DATE
              ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,BF.START_DATE),112)    AS END_DATE
              ,CONVERT(INT, 86400*CW.PROD_READY_RATE/100)               AS DAILY_VALUE
              ,'L4'                                                     AS CALENDAR_LEVEL
              ,BF.SITE_ID                                               AS SITE_ID
              ,NULL                                                     AS ITEM_ID
              ,BF.LINE_ID                                               AS LINE_ID
        FROM(
            SELECT  BF.RESOURCE_ID
                   ,BF.SITE_ID
                   ,BF.LINE_ID
                   ,BF.START_DATE
            FROM(
                SELECT  RESOURCE_ID
                       ,SITE_ID
                       ,LINE_ID
                       ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,START_DATE),112) AS START_DATE
                FROM    @EV_CAL_TEMP
                WHERE   1=1
                AND     CALENDAR_LEVEL = 'L5'
                AND     TYPE           = 'upper_limit'
                AND     START_DATE     < @V_PLAN_END_YYYYMMDD --하루를 더 할 것이기 때문에 미만 조건이 필요함
                UNION ALL
                SELECT  RS.RESOURCE_ID
                       ,RS.SITE_ID
                       ,RS.RESOURCE_NAME
                       ,CAL.BASIS_YYYYMMDD
                FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                    CROSS APPLY SCP_OPT_ENG_RESOURCE_SN RS WITH(NOLOCK)
                WHERE   1=1
                AND     CAL.BASIS_YYYYMMDD >= @V_PLAN_START_YYYYMMDD
                AND     CAL.BASIS_YYYYMMDD <  @V_PLAN_END_YYYYMMDD
                AND     CAL.DAYOFWEEK_NO   IN(1,2)
                AND     RS.PLAN_ID = @V_PLAN_ID
                ) BF
                LEFT OUTER JOIN @EV_CAL_TEMP EV
                    ON  BF.RESOURCE_ID    = EV.RESOURCE_ID
                    AND BF.START_DATE     = EV.START_DATE
                    AND EV.CALENDAR_LEVEL = 'L5'
                    AND EV.TYPE           = 'upper_limit'
            --WHERE EV.RESOURCE_ID IS NOT NULL
            WHERE EV.RESOURCE_ID IS NULL
            ) BF
            INNER JOIN SCP_MST_CAPA_WORK CW WITH(NOLOCK)
                ON  1=1
                AND CW.MEASURE  = 'NO_WORK'
                AND CW.PROD_READY_RATE IS NOT NULL
                AND CW.LINE_ID  = BF.LINE_ID
                AND CW.YYYYMMDD = CONVERT(NVARCHAR, GETDATE(), 112) -- 엔진 수행일자 기준으로 반영.
                -- AND CW.YYYYMMDD = @V_PLAN_START_YYYYMMDD -- 생산 준비율은 날짜 별로 넣는게 아니라서 계획 일자 기준의 생산 준비율을 가져옴

        WHERE @V_DIVISION_ID = '40' --소형만
        ------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------
        INSERT INTO @EV_CAL_TEMP
        ------------------------------------------------------------------------
        -- Add Minimize weekend operations Constraint
        -- 2025.05.12 Philsu Park: upper_limit L2 제약 반영 시 Plan Start YMD 보다 작지 않고, Plan End YMD 보다 크지 않게 제약조건 추가.
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
        --            AND     SEGMENT2 = @V_DIVISION_ID
        --            AND     SEGMENT4 !=0
        --            AND     LU.VALID_YN = 'Y'
        --) B
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
        ------------------------------------------------------------------------
        -- 주말 가동 최소화 LINE대로 적용으로 변경/태원 책임님 요청사항/20250612/김태현 선임
        ------------------------------------------------------------------------
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
                 , @V_PLAN_END_YYYYMMDD   AS END_DATE
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
        -- 2025.08.29 YSH
        -- ESS 조립 운영가능 CONTAINER 제약 추가.
        -- 2025.09.03 Philsu Park: ITEM단위 LOT SIZE 적용 룩업으로 변경.
        ------------------------------------------------------------------------
        UNION ALL
        SELECT @V_PLAN_ID                     AS PLAN_ID
              ,SCM_SITE_ID+'::'+RESOURCE_NAME AS RESOURCE_ID
              ,'upper_limit'                  AS TYPE
              ,START_DATE                     AS START_DATE
              ,END_DATE						  AS END_DATE
              ,CNTR.DAILY_VALUE               AS DAILY_VALUE
              ,'L0'                           AS CALENDAR_LEVEL
              ,SCM_SITE_ID                    AS SITE_ID
              ,NULL                           AS ITEM_ID
              ,NULL                           AS LINE_ID
        FROM(
            SELECT  DISTINCT
                    SEGMENT6                AS SCM_SITE_ID
                   ,SEGMENT8                AS RESOURCE_NAME
                   ,@V_PLAN_START_YYYYMMDD  AS START_DATE
                   ,@V_PLAN_END_YYYYMMDD    AS END_DATE
                   ,ATTRIBUTE3              AS DAILY_VALUE
            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            WHERE   LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_SHIP_LOT_SIZE_NEW'
            AND     LU.SEGMENT1     = @V_DIVISION_ID
            AND     LU.SEGMENT2     = @V_GROUP_ID
            AND     LU.VALID_YN     = 'Y'
            AND     LU.SEGMENT3     = 'CON'  -- LOT TYPE이 CON만 대상.
            ) CNTR

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
        SELECT  ECT.PLAN_ID                                     AS PLAN_ID
               ,LP.SEGMENT3+'::'+LP.SEGMENT5                    AS RESOURCE_ID
               ,ECT.TYPE                                        AS TYPE
               ,ECT.START_DATE                                  AS SATRT_DATE
               ,ECT.END_DATE                                    AS END_DATE
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
        WHERE   ECT.CALENDAR_LEVEL = 'L5'
        GROUP BY ECT.PLAN_ID, LP.SEGMENT3, LP.SEGMENT5, ECT.TYPE, ECT.START_DATE, ECT.END_DATE, ECT.CALENDAR_LEVEL, LP.ATTRIBUTE2
        ------------------------------------------------------------------------
        -- 2025.05.14 Philsu Park: Lookup에 Fix 등록된 경우, Every Cal 에 L6 레벨 0으로 추가. 
        -- 2025.05.16 Philsu Park: Stage 단위 Frozen 구분 적용
        -- 2025.05.20 Philsu Park: GROUP_ID 조건 추가.
        -- 2025.09.12 Philsu Park: ESS STAGE 반영.
        ------------------------------------------------------------------------
        UNION ALL
        SELECT	  @V_PLAN_ID                                        AS PLAN_ID
                , CONCAT(LVF.SEGMENT5, '::', LVF.ATTRIBUTE1)        AS RESOURCE_ID
                , 'upper_limit'                                     AS TYPE
                , LVF.ATTRIBUTE3                                    AS START_DATE
                , CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATETIME, LVF.ATTRIBUTE3)), 112) AS END_DATE
                , '0'                                               AS DAILY_VALUE
                , 'L6'                                              AS CALENDAR_LEVEL
                ,LVF.SEGMENT5                                       AS SITE_ID
                ,NULL                                               AS ITEM_ID -- 기존 데이터들 전부 NULL이길래 일단 NULL로 유지.
                ,LVF.ATTRIBUTE1                                     AS LINE_ID
        FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL LVF WITH(NOLOCK)
        INNER JOIN ( 
                    SELECT *
                    FROM   SCM_MST_SITE  WITH(NOLOCK)
                    WHERE  DIVISION_ID = @V_DIVISION_ID
                    AND    SITE_TYPE   = 'PLANT'
                    AND    VALID_YN    = 'Y'
                    ) MSE
            ON   LVF.SEGMENT5 = MSE.SCM_SITE_ID
            AND ((MSE.DIVISION_ID  = '40' AND MSE.OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                OR  (MSE.DIVISION_ID <> '40' AND MSE.OPERATION_GROUP IN ('A', 'P') )
                )
        INNER JOIN (SELECT DISTINCT DIVISION_ID
                                    ,ITEM_ID
                                    ,OPERATION_GROUP
                                    ,OPERATION_GROUP_ID
                                    ,FLOW_ID
                                    ,ATTRIBUTE8
                    FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                    WHERE  DIVISION_ID = @V_DIVISION_ID
                    AND    OPERATION_GROUP IN ('A', 'P')  
                    ) FI
            ON    LVF.ATTRIBUTE2    = FI.ITEM_ID
            AND   LVF.SEGMENT2      = FI.DIVISION_ID
        INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN F   -- 2025.05.16 Philsu Park: Stage 단위 Frozen 구분 적용 / 2025.06.27 김태현 : Frozen Master 테이블로 대체
            ON  1=1
			AND F.PLAN_ID = @V_PLAN_ID
            AND F.FROZEN_TYPE = 'PROD' -- 2026.06.30 Minyong Lee : [E20260622-000207] [ODS] ESS Ship Frozen 설정시 Link 제외 기능
			AND CASE    WHEN FI.OPERATION_GROUP_ID = 'A'                                                            THEN 'ASSY'
                        WHEN FI.OPERATION_GROUP_ID = 'B' AND FI.FLOW_ID  = 'P9500'                                  THEN 'PACK'
                        WHEN FI.OPERATION_GROUP_ID = 'B' AND FI.FLOW_ID  = 'P5500'                                  THEN 'PACK'
                        WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID  = 'P9500'                                  THEN 'PACK'
                        WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID  = 'P5000'   AND FI.ITEM_ID NOT LIKE 'EP%'  THEN 'PACK'
                        WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID  = 'P5000'   AND FI.ITEM_ID LIKE 'EP%'      THEN 'PACK'
                        WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID  = 'R5500'                                  THEN 'RACK'
                        WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID  = 'P9500'                                  THEN 'LINK'
                        WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID  = 'PL500'                                  THEN 'LINK' -- 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응
                        WHEN MSE.OPERATION_GROUP   = 'A'                                                            THEN 'ASSY'
                         --WHEN MSE.OPERATION_GROUP = 'P' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE'
                        END = F.STAGE
            AND LVF.ATTRIBUTE3 >= F.FROZEN_END_DATE
        WHERE	LVF.LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
        AND     LVF.SEGMENT3    = @V_GROUP_ID           -- GROUP_ID 제약조건 추가
        -- AND     LVF.ATTRIBUTE3 >= @V_PROD_FROZEN_END    -- Frozen 구간 이후 FIX 만 적용
        AND     LVF.ATTRIBUTE3  < @V_PLAN_END_YYYYMMDD
        AND     LVF.VALID_YN    = 'Y'
        AND     LVF.ATTRIBUTE5 != 'Y'
        AND     LVF.ATTRIBUTE2 IN  (SELECT DISTINCT ITEM_ID
                                    FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                    WHERE  PLAN_ID = @V_PLAN_ID
                                    )
        AND     LVF.ATTRIBUTE1 IN ( SELECT  DISTINCT ATTRIBUTE15
                                    FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                    WHERE   PLAN_ID         = @V_PLAN_ID
                                    AND     RESOURCE_TYPE   = 'LINE'
                                    )
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
              ,DAILY_VALUE                                  -- 인원 제약까지 반영하여 한번에 INSERT
              ,CALENDAR_LEVEL                               -- 인원 제약까지 반영하여 한번에 INSERT
              ,SITE_ID                                      -- 인원 제약까지 반영하여 한번에 INSERT
              ,ITEM_ID                                      -- 인원 제약까지 반영하여 한번에 INSERT
              ,LINE_ID                                      -- 인원 제약까지 반영하여 한번에 INSERT
        FROM @EV_CAL_TEMP                                   -- 인원 제약까지 반영하여 한번에 INSERT
        GROUP BY PLAN_ID, RESOURCE_ID, TYPE, START_DATE, END_DATE, DAILY_VALUE, CALENDAR_LEVEL, SITE_ID, ITEM_ID, LINE_ID
        ;
        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- 2025.07.02 Philsu Park
        -- 생산 가동률 업데이트. Line 정보 존재하는 upper_limit 제약 일괄.
        ------------------------------------------------------------------------
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
        ;
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
