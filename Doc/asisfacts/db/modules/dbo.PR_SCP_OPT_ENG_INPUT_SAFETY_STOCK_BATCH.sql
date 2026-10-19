--EXEC PR_SCP_OPT_ENG_INPUT_COBY_PROD_ITEM 'PLAN_ID_001'
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_INPUT_SAFETY_STOCK_BATCH]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.07 Taehyun Initial Release
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_INPUT_SAFETY_STOCK_BATCH';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE       DATETIME;
    DECLARE @P_PLAN_NAME         NVARCHAR(8) 
    DECLARE @D_PLAN_NAME         DATETIME 
    DECLARE @V_DEMAND_CUTOFF_DAY NVARCHAR(8) 
    DECLARE @V_DM_MAX_VERSION   NVARCHAR(200)

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

		----------------------------------------------------------
		-- 1. 특정 Stage 전 구간 L0 / 0 처리 : ASSY, ASY_AGING, BIZ, SUBMDLE
		----------------------------------------------------------
		INSERT INTO SCP_OPT_ENG_SAFETY_STOCK_SN(
					PLAN_ID
				   ,BUFFER_ID
				   ,TYPE
				   ,START_DATE
				   ,END_DATE
				   ,VALUE
				   ,CALENDAR_LEVEL
				   )
		SELECT @V_PLAN_ID                                         AS PLAN_ID
			  ,BUFFER_ID                                          AS BUFFER_ID
			  ,'max_cover_day'                                    AS TYPE
			  ,@V_PLAN_START_YYYYMMDD                             AS START_DATE
			  ,@V_PLAN_END_YYYYMMDD                               AS END_DATE
			  ,'0'                                                AS VALUE
			  ,'L0'                                               AS CALENDAR_LEVEL
		FROM   SCP_OPT_ENG_ITEM_SITE_SN WITH(NOLOCK) 
		WHERE  PLAN_ID = @V_PLAN_ID
		AND   (STAGE IN ('ASSY', 'ASY_AGING', 'SUBMDLE')
			OR STAGE LIKE '%BIZ%'
			  )

		----------------------------------------------------------
		-- 2. Lookup에 Stage 별 등록 확인 후 수정 처리 필요
		----------------------------------------------------------
		--  2.1) CHAR : 아래 참고하여 Formation LT 차감 처리
        -- 2025.11.04 Minyong Lee : Lookup -> UI 전환 (cover_day)
        -- 2025.11.25 Minyong Lee : 
        --      - ROUTING JOIN이 있다면 그대로 유지
        --      - ITEM_SITE JOIN이 없다면 INNER JOIN 추가
        --      - Sales Site Incoterms 구분 없이 STAGE 기준 JOIN
        --      - ITEM_SITE의 BUFFER_ID 그대로 사용
		----------------------------------------------------------
        UNION ALL
		SELECT @V_PLAN_ID                                         AS PLAN_ID
			  ,SIS.BUFFER_ID                                      AS BUFFER_ID
			  ,'max_cover_day'                                    AS TYPE

			  ,CASE WHEN CP.START_DATE <= @V_PLAN_START_YYYYMMDD THEN @V_PLAN_START_YYYYMMDD
			        ELSE CP.START_DATE
			   END AS START_DATE

			  ,CASE WHEN CP.END_DATE >= @V_PLAN_END_YYYYMMDD THEN @V_PLAN_END_YYYYMMDD
			        ELSE CP.END_DATE
			   END AS END_DATE

			  ,CP.TEMP_VALUE - CP.LEAD_TIME                       AS VALUE
			  ,'L1'                                               AS CALENDAR_LEVEL
		FROM(
			SELECT CP.SCM_SITE_ID   AS SCM_SITE_ID
				  ,CP.ITEM_ID        AS ITEM_ID
				  ,CP.STAGE          AS STAGE
				  ,'max_cover_day'   AS TYPE
				  ,CP.EFF_START_DATE AS START_DATE
				  ,CP.EFF_END_DATE   AS END_DATE
				  ,CP.VALUE          AS TEMP_VALUE
				  ,SUM(ISNULL(RT.LEAD_TIME, 0)) AS LEAD_TIME
			FROM(
				--SELECT LV.SEGMENT2     AS DIVISION
				--	  ,LV.SEGMENT3     AS SCM_SITE_ID
				--	  ,SMS.PLANT_ID    AS PLANT_ID
				--	  ,LV.SEGMENT4     AS ITEM_ID
				--	  ,LV.SEGMENT5     AS STAGE
				--	  ,LV.ATTRIBUTE1   AS EFF_START_DATE
				--	  ,IIF(LV.ATTRIBUTE2<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE2),112),LV.ATTRIBUTE2)   AS EFF_END_DATE
				--	  ,LV.ATTRIBUTE3   AS VALUE
				--FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
				--    INNER JOIN SCM_MST_SITE SMS WITH(NOLOCK) 
				--        ON      LV.SEGMENT2 = SMS.DIVISION_ID
				--        AND     LV.SEGMENT3 = SMS.SCM_SITE_ID
				--WHERE   LV.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PRECEDE'
				--AND     LV.VALID_YN    = 'Y'
				--AND     LV.SEGMENT2    = @V_DIVISION_ID
				--AND     LV.SEGMENT5    = 'CHAR'

                SELECT  CV.DIVISION_ID      AS DIVISION
	                  , CV.SCM_SITE_ID      AS SCM_SITE_ID
	                  , SMS.PLANT_ID        AS PLANT_ID
	                  , CV.ITEM_ID          AS ITEM_ID
	                  , CV.STAGE            AS STAGE
	                  , CV.FROM_YYYYMMDD    AS EFF_START_DATE
	                  , IIF(CV.TO_YYYYMMDD<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,CV.TO_YYYYMMDD),112),CV.TO_YYYYMMDD)   AS EFF_END_DATE
	                  , CV.TYPE_APPLY_DAY   AS VALUE
                FROM    SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY CV WITH(NOLOCK)
                    INNER JOIN SCM_MST_SITE SMS WITH(NOLOCK) 
                        ON  CV.DIVISION_ID  =   SMS.DIVISION_ID
                        AND CV.SCM_SITE_ID = SMS.SCM_SITE_ID
                    LEFT OUTER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                        ON CV.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                WHERE   1=1
                AND     CV.VALUE_TYPE   = 'MAX'
                AND     CV.VALID_YN     = 'Y'
                AND     CV.DIVISION_ID  = @V_DIVISION_ID  
                AND     CV.TO_YYYYMMDD   >= @V_PLAN_START_YYYYMMDD
                AND     CV.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
                AND     CV.STAGE        = 'CHAR'
                AND     ISNULL(CV.OPMZ_PLAN_GR_ID,'~') = (SELECT TOP 1 ISNULL(CV2.OPMZ_PLAN_GR_ID,'~')
                                                                      FROM   SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY CV2 WITH(NOLOCK)
                                                                      WHERE  CV2.VALID_YN = 'Y'
                                                                      AND    CV2.DIVISION_ID = CV.DIVISION_ID
                                                                      AND    CV2.SCM_SITE_ID = CV.SCM_SITE_ID
                                                                      AND    CV2.ITEM_ID = CV.ITEM_ID
                                                                      AND    ISNULL(CV2.STAGE,'-') = ISNULL(CV.STAGE,'-')
                                                                      AND    CV2.VALUE_TYPE = CV.VALUE_TYPE
                                                                      ORDER BY CV2.OPMZ_PLAN_GR_ID)
                                    /* 계획그룹 필터 미적용으로 업무키당 복수행이 조회될 수 있어 결과행 복제(PK위반) 방지. 선행안전재고(커버데이) 중복 방지 */
				) AS CP
				LEFT OUTER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V FIB WITH(NOLOCK)
					ON  CP.DIVISION = FIB.DIVISION_ID
					AND CP.PLANT_ID = FIB.PLANT_ID
					AND CP.ITEM_ID  = FIB.MODEL_ID
				LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN RT WITH(NOLOCK)
					ON  RT.PLAN_ID        = @V_PLAN_ID
					AND RT.ATTRIBUTE3     = 'ASY_AGING'
					AND CP.SCM_SITE_ID    = RT.ATTRIBUTE1
					AND FIB.CHILD_ITEM_ID = RT.ATTRIBUTE2
			WHERE RT.PLAN_ID IS NOT NULL
			GROUP BY CP.SCM_SITE_ID, CP.ITEM_ID, CP.STAGE, CP.EFF_START_DATE, CP.EFF_END_DATE, CP.VALUE
			) CP
            INNER JOIN ( SELECT DISTINCT PLAN_ID,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3 
                            FROM SCP_OPT_ENG_ROUTING_SN WITH(NOLOCK) 
                            WHERE PLAN_ID = @V_PLAN_ID
                        ) RT
			    ON  RT.PLAN_ID      = @V_PLAN_ID
			    AND CP.SCM_SITE_ID  = RT.ATTRIBUTE1
			    AND CP.ITEM_ID      = RT.ATTRIBUTE2
			    AND CP.STAGE        = RT.ATTRIBUTE3
            INNER JOIN  SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
                ON  SIS.PLAN_ID     = @V_PLAN_ID
                AND CP.SCM_SITE_ID  = SIS.SITE_ID
                AND CP.ITEM_ID      = SIS.ITEM_ID
                AND CP.STAGE        = SIS.ATTRIBUTE3
		----------------------------------------------------------
		-- 2.2) 나머지 Stage : Lokkup 그대로 등록
		-- 2025.05.21 Philsu Park: 전진검사 Type A Case 반영을 위해 아래와 같이 수정
        --                          Routing 정보가 있는 생산 Site + Sales Site이면서 Stage가 Biz가 아닌 대상
        -- 2025.06.09 Philsu Park: Sales Site BIZ까지 STAGE 제약 주지 않고 다 풀어줌.
        -- 2025.11.04 Minyong Lee : Lookup -> UI 전환 (cover_day)
        -- 2025.11.25 Minyong Lee : 
        --      - ROUTING JOIN이 있다면 그대로 유지
        --      - ITEM_SITE JOIN이 없다면 INNER JOIN 추가
        --      - Sales Site Incoterms 구분 없이 STAGE 기준 JOIN
        --      - ITEM_SITE의 BUFFER_ID 그대로 사용
		----------------------------------------------------------
        UNION ALL
		SELECT @V_PLAN_ID                                         AS PLAN_ID
			  ,SIS.BUFFER_ID                                      AS BUFFER_ID
			  ,'max_cover_day'                                    AS TYPE

			  ,CASE WHEN CP.START_DATE <= @V_PLAN_START_YYYYMMDD THEN @V_PLAN_START_YYYYMMDD
			        ELSE CP.START_DATE
			   END AS START_DATE

			  ,CASE WHEN CP.END_DATE >= @V_PLAN_END_YYYYMMDD THEN @V_PLAN_END_YYYYMMDD
			        ELSE CP.END_DATE
			   END AS END_DATE

			  ,CP.TEMP_VALUE                                      AS VALUE
			  ,'L1'                                               AS CALENDAR_LEVEL
		FROM(
			SELECT CP.SCM_SITE_ID      AS SCM_SITE_ID
				  ,CP.ITEM_ID           AS ITEM_ID
				  ,CP.STAGE             AS STAGE
				  ,'max_cover_day'      AS TYPE
				  ,CP.EFF_START_DATE    AS START_DATE
				  ,CP.EFF_END_DATE      AS END_DATE
				  ,CP.VALUE             AS TEMP_VALUE
                  ,CP.PLANT_ID          AS PLANT_ID
			FROM(
				--SELECT LV.SEGMENT2     AS DIVISION
				--	  ,LV.SEGMENT3     AS SCM_SITE_ID
				--	  ,SMS.PLANT_ID    AS PLANT_ID
				--	  ,LV.SEGMENT4     AS ITEM_ID
				--	  ,LV.SEGMENT5     AS STAGE
				--	  ,LV.ATTRIBUTE1   AS EFF_START_DATE
				--	  ,IIF(LV.ATTRIBUTE2<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE2),112),LV.ATTRIBUTE2)   AS EFF_END_DATE
				--	  ,LV.ATTRIBUTE3   AS VALUE
				--FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
				--INNER JOIN SCM_MST_SITE SMS WITH(NOLOCK) 
				--ON      LV.SEGMENT2 = SMS.DIVISION_ID
				--AND     LV.SEGMENT3 = SMS.SCM_SITE_ID
				--WHERE   LV.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PRECEDE'
				--AND     LV.VALID_YN    = 'Y'
				--AND     LV.SEGMENT2    = @V_DIVISION_ID
				--AND     LV.SEGMENT5   <> 'CHAR'

                SELECT  CV.DIVISION_ID      AS DIVISION
	                  , CV.SCM_SITE_ID      AS SCM_SITE_ID
	                  , SMS.PLANT_ID        AS PLANT_ID
	                  , CV.ITEM_ID          AS ITEM_ID
	                  , CV.STAGE            AS STAGE
	                  , CV.FROM_YYYYMMDD    AS EFF_START_DATE
	                  , IIF(CV.TO_YYYYMMDD<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,CV.TO_YYYYMMDD),112),CV.TO_YYYYMMDD)   AS EFF_END_DATE
	                  , CV.TYPE_APPLY_DAY   AS VALUE
                FROM    SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY CV WITH(NOLOCK)
                    INNER JOIN SCM_MST_SITE SMS WITH(NOLOCK) 
                        ON  CV.DIVISION_ID  =   SMS.DIVISION_ID
                        AND CV.SCM_SITE_ID  = SMS.SCM_SITE_ID
                    LEFT OUTER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                        ON CV.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                WHERE   1=1
                AND     CV.VALUE_TYPE   = 'MAX'
                AND     CV.VALID_YN     = 'Y'
                AND     CV.DIVISION_ID  = @V_DIVISION_ID  
                AND     CV.TO_YYYYMMDD   >= @V_PLAN_START_YYYYMMDD
                AND     CV.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
                AND     CV.STAGE        <> 'CHAR'
                AND     ISNULL(CV.OPMZ_PLAN_GR_ID,'~') = (SELECT TOP 1 ISNULL(CV2.OPMZ_PLAN_GR_ID,'~')
                                                                      FROM   SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY CV2 WITH(NOLOCK)
                                                                      WHERE  CV2.VALID_YN = 'Y'
                                                                      AND    CV2.DIVISION_ID = CV.DIVISION_ID
                                                                      AND    CV2.SCM_SITE_ID = CV.SCM_SITE_ID
                                                                      AND    CV2.ITEM_ID = CV.ITEM_ID
                                                                      AND    ISNULL(CV2.STAGE,'-') = ISNULL(CV.STAGE,'-')
                                                                      AND    CV2.VALUE_TYPE = CV.VALUE_TYPE
                                                                      ORDER BY CV2.OPMZ_PLAN_GR_ID)
                                    /* 계획그룹 필터 미적용으로 업무키당 복수행이 조회될 수 있어 결과행 복제(PK위반) 방지. 선행안전재고(커버데이) 중복 방지 */
				) AS CP
			WHERE 1=1
			) CP
            LEFT OUTER JOIN (   SELECT  DISTINCT PLAN_ID,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3 
                                FROM    SCP_OPT_ENG_ROUTING_SN WITH(NOLOCK) 
                                WHERE   PLAN_ID = @V_PLAN_ID
                            ) RT
                ON  RT.PLAN_ID      = @V_PLAN_ID
                AND CP.SCM_SITE_ID  = RT.ATTRIBUTE1
                AND CP.ITEM_ID      = RT.ATTRIBUTE2
                AND CP.STAGE        = RT.ATTRIBUTE3
            INNER JOIN  SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
                ON  SIS.PLAN_ID     = @V_PLAN_ID
                AND CP.SCM_SITE_ID  = SIS.SITE_ID
                AND CP.ITEM_ID      = SIS.ITEM_ID
                AND CP.STAGE        = SIS.ATTRIBUTE3
        /* AND ((CP.PLANT_ID IS NULL AND CP.STAGE NOT LIKE '%BIZ%') -- 2025.05.21 Philsu Park: Routing 정보가 있는 생산 Site + Sales Site이면서 Stage가 Biz가 아닌 대상
            OR RT.ATTRIBUTE1 IS NOT NULL) */

		----------------------------------------------------------
		-- 3) Min Cover Day : Lokkup 그대로 등록
        -- 2025.11.04 Minyong Lee : Lookup -> UI 전환 (cover_day)
        -- 2025.11.25 Minyong Lee : 
        --      - ROUTING JOIN이 있다면 그대로 유지
        --      - ITEM_SITE JOIN이 없다면 INNER JOIN 추가
        --      - Sales Site Incoterms 구분 없이 STAGE 기준 JOIN
        --      - ITEM_SITE의 BUFFER_ID 그대로 사용
		----------------------------------------------------------
        --UNION ALL
		--SELECT	 @V_PLAN_ID										AS PLAN_ID
		--		,LV.SEGMENT3+'::'+LV.SEGMENT4+'::'+LV.SEGMENT5+IIF(SIS.ATTRIBUTE2 IS NULL ,'','@'+SIS.ATTRIBUTE2) AS BUFFER_ID
		--		,'min_cover_day'								AS TYPE
		--	    ,CASE WHEN LV.ATTRIBUTE1 <= @V_PLAN_START_YYYYMMDD THEN @V_PLAN_START_YYYYMMDD
		--	          ELSE LV.ATTRIBUTE1
		--	     END AS START_DATE
		--	    ,CASE WHEN IIF(LV.ATTRIBUTE2<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE2),112),LV.ATTRIBUTE2) >= @V_PLAN_END_YYYYMMDD THEN @V_PLAN_END_YYYYMMDD
		--	          ELSE IIF(LV.ATTRIBUTE2<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE2),112),LV.ATTRIBUTE2)
		--	     END AS END_DATE
		--		,LV.ATTRIBUTE3									AS VALUE
		--		,'L1'                                           AS CALENDAR_LEVEL
		--FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
		--    INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
		--    	 ON  LV.SEGMENT3 = SIS.SITE_ID
		--    	 AND LV.SEGMENT4 = SIS.ITEM_ID
		--    	 AND SIS.PLAN_ID = @V_PLAN_ID
  --               AND LV.SEGMENT5 = SIS.ATTRIBUTE3 + IIF(SIS.ATTRIBUTE1 IS NULL ,'','@'+SIS.ATTRIBUTE1)
		--WHERE   LV.LOOKUP_TYPE	= 'SCP_OPT_ENG_CONST_SAFETY_STOCK'
		--AND     LV.VALID_YN		= 'Y'
		--AND     LV.SEGMENT2		= @V_DIVISION_ID
  --      AND     LV.ATTRIBUTE2 > @V_PLAN_START_YYYYMMDD -- +1일이 되지 않아서 등호 제거
  --      AND     LV.ATTRIBUTE1 < @V_PLAN_END_YYYYMMDD   --END DATE가 하루 추가된 날짜이기 때문에, 등호 제거

        UNION ALL
        SELECT	@V_PLAN_ID									AS PLAN_ID
	          , SIS.BUFFER_ID                           	AS BUFFER_ID
	          , 'min_cover_day'								AS TYPE
	          , CASE
                    WHEN CV.FROM_YYYYMMDD <= @V_PLAN_START_YYYYMMDD THEN @V_PLAN_START_YYYYMMDD
			        ELSE CV.FROM_YYYYMMDD
                END AS START_DATE
              , CASE
                    WHEN IIF(CV.TO_YYYYMMDD<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,CV.TO_YYYYMMDD),112),CV.TO_YYYYMMDD) >= @V_PLAN_END_YYYYMMDD THEN @V_PLAN_END_YYYYMMDD
                    ELSE IIF(CV.TO_YYYYMMDD<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,CV.TO_YYYYMMDD),112),CV.TO_YYYYMMDD)
                END AS END_DATE
              , CV.TYPE_APPLY_DAY							AS VALUE
              , 'L1'                                        AS CALENDAR_LEVEL
        FROM    SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY CV WITH(NOLOCK)
	        INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
		            ON  SIS.PLAN_ID     = @V_PLAN_ID
                    AND CV.SCM_SITE_ID  = SIS.SITE_ID
		            AND CV.ITEM_ID      = SIS.ITEM_ID
                    AND CV.STAGE        = SIS.ATTRIBUTE3
            LEFT OUTER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                ON CV.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
        WHERE   1=1
        AND     CV.VALUE_TYPE = 'MIN'
        AND     CV.VALID_YN		 = 'Y'
        AND     CV.DIVISION_ID	 = @V_DIVISION_ID
        AND     CV.TO_YYYYMMDD   >= @V_PLAN_START_YYYYMMDD
        AND     CV.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
        AND     ISNULL(CV.OPMZ_PLAN_GR_ID,'~') = (SELECT TOP 1 ISNULL(CV2.OPMZ_PLAN_GR_ID,'~')
                                                                      FROM   SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY CV2 WITH(NOLOCK)
                                                                      WHERE  CV2.VALID_YN = 'Y'
                                                                      AND    CV2.DIVISION_ID = CV.DIVISION_ID
                                                                      AND    CV2.SCM_SITE_ID = CV.SCM_SITE_ID
                                                                      AND    CV2.ITEM_ID = CV.ITEM_ID
                                                                      AND    ISNULL(CV2.STAGE,'-') = ISNULL(CV.STAGE,'-')
                                                                      AND    CV2.VALUE_TYPE = CV.VALUE_TYPE
                                                                      ORDER BY CV2.OPMZ_PLAN_GR_ID)
                                    /* 계획그룹 필터 미적용으로 업무키당 복수행이 조회될 수 있어 결과행 복제(PK위반) 방지. 선행안전재고(커버데이) 중복 방지 */

		----------------------------------------------------------
		-- 4) Min Cover Qty : Lookup 그대로 등록
        -- 2025.11.04 Minyong Lee : Lookup -> UI 전환 (stock_qty)
        -- 2025.11.25 Minyong Lee : 
        --      - ROUTING JOIN이 있다면 그대로 유지
        --      - ITEM_SITE JOIN이 없다면 INNER JOIN 추가
        --      - Sales Site Incoterms 구분 없이 STAGE 기준 JOIN
        --      - ITEM_SITE의 BUFFER_ID 그대로 사용
		----------------------------------------------------------
        --UNION ALL
		--SELECT	 @V_PLAN_ID										AS PLAN_ID
		--		,LV.SEGMENT3+'::'+LV.SEGMENT4+'::'+LV.SEGMENT5+IIF(SIS.ATTRIBUTE2 IS NULL ,'','@'+SIS.ATTRIBUTE2)	AS BUFFER_ID
		--		,'min_stock_qty'								AS TYPE 
		--	    ,CASE WHEN LV.ATTRIBUTE1 <= @V_PLAN_START_YYYYMMDD THEN @V_PLAN_START_YYYYMMDD
		--	          ELSE LV.ATTRIBUTE1
		--	     END AS START_DATE
                
		--	    ,CASE WHEN IIF(LV.ATTRIBUTE2<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE2),112),LV.ATTRIBUTE2) >= @V_PLAN_END_YYYYMMDD THEN @V_PLAN_END_YYYYMMDD
		--	          ELSE IIF(LV.ATTRIBUTE2<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE2),112),LV.ATTRIBUTE2)
		--	     END AS END_DATE
		--		,LV.ATTRIBUTE3									AS VALUE
		--		,'L1'                                           AS CALENDAR_LEVEL
		--FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
		--    LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
		--    	 ON  LV.SEGMENT3 = SIS.SITE_ID
		--    	 AND LV.SEGMENT4 = SIS.ITEM_ID
		--    	 AND SIS.PLAN_ID = @V_PLAN_ID
  --               AND LV.SEGMENT5 = SIS.ATTRIBUTE3 + IIF(SIS.ATTRIBUTE1 IS NULL ,'','@'+SIS.ATTRIBUTE1)
		--WHERE   LV.LOOKUP_TYPE	= 'SCP_OPT_ENG_CONST_SAFETY_STOCK_QTY'
		--AND     LV.VALID_YN		= 'Y'
		--AND     LV.SEGMENT2		= @V_DIVISION_ID
  --      AND     LV.ATTRIBUTE2 > @V_PLAN_START_YYYYMMDD -- +1일이 되지 않아서 등호 제거
  --      AND     LV.ATTRIBUTE1 < @V_PLAN_END_YYYYMMDD   --END DATE가 하루 추가된 날짜이기 때문에, 등호 제거
  --      AND     LV.ATTRIBUTE4 = @V_GROUP_ID

        UNION ALL
        SELECT  @V_PLAN_ID										AS PLAN_ID
              , SIS.BUFFER_ID                                   AS BUFFER_ID
              , 'min_stock_qty'								    AS TYPE 
              , CASE
                    WHEN SQ.FROM_YYYYMMDD <= @V_PLAN_START_YYYYMMDD THEN @V_PLAN_START_YYYYMMDD
			        ELSE SQ.FROM_YYYYMMDD
		        END AS START_DATE
              , CASE
                    WHEN IIF(SQ.TO_YYYYMMDD<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,SQ.TO_YYYYMMDD),112),SQ.TO_YYYYMMDD) >= @V_PLAN_END_YYYYMMDD THEN @V_PLAN_END_YYYYMMDD
         	        ELSE IIF(SQ.TO_YYYYMMDD<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,SQ.TO_YYYYMMDD),112),SQ.TO_YYYYMMDD)
       	        END AS END_DATE
              , SQ.APL_QTY									    AS VALUE
              , 'L1'                                           AS CALENDAR_LEVEL
        FROM    SCP_OPMZ_SAFETY_STOCK SQ WITH(NOLOCK)
            INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
                ON  SIS.PLAN_ID     = @V_PLAN_ID
                AND SQ.SCM_SITE_ID  = SIS.SITE_ID
                AND SQ.ITEM_ID      = SIS.ITEM_ID
                AND SQ.STAGE        = SIS.ATTRIBUTE3
            LEFT OUTER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                ON SQ.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
        WHERE   1=1
        AND     SQ.VALUE_TYPE   = 'MIN'
        AND     SQ.VALID_YN		= 'Y'
        AND     SQ.DIVISION_ID	= @V_DIVISION_ID
        AND     SQ.TO_YYYYMMDD  >= @V_PLAN_START_YYYYMMDD
        AND     SQ.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
        AND     ISNULL(SQ.OPMZ_PLAN_GR_ID,'~') = (SELECT TOP 1 ISNULL(SQ2.OPMZ_PLAN_GR_ID,'~')
                                                                      FROM   SCP_OPMZ_SAFETY_STOCK SQ2 WITH(NOLOCK)
                                                                      WHERE  SQ2.VALID_YN = 'Y'
                                                                      AND    SQ2.DIVISION_ID = SQ.DIVISION_ID
                                                                      AND    SQ2.SCM_SITE_ID = SQ.SCM_SITE_ID
                                                                      AND    SQ2.ITEM_ID = SQ.ITEM_ID
                                                                      AND    ISNULL(SQ2.STAGE,'-') = ISNULL(SQ.STAGE,'-')
                                                                      AND    SQ2.VALUE_TYPE = SQ.VALUE_TYPE
                                                                      ORDER BY SQ2.OPMZ_PLAN_GR_ID)
                                    /* 계획그룹 필터 미적용으로 업무키당 복수행이 조회될 수 있어 결과행 복제(PK위반) 방지. 안전재고 중복 방지 */

		------------------------------------------------------------------------
		-- Data Insert End
		------------------------------------------------------------------------
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
