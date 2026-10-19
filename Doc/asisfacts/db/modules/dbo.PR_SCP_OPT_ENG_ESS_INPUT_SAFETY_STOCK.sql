
CREATE   PROCEDURE [dbo].[PR_SCP_OPT_ENG_ESS_INPUT_SAFETY_STOCK]
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_ESS_INPUT_SAFETY_STOCK';
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
    DECLARE @V_BASE_MODE        NVARCHAR(20); -- SCP_OPT_ENG_BASE : COST 인 Plan Group 만 LD 적용
    DECLARE @V_SALESPRICE_SHORT_TERM   INT;            -- 근거리 기준(일), PSD 포함
    DECLARE @V_SALESPRICE_WEIGHT       NUMERIC(20,10); -- 근거리 가중치(%)
    DECLARE @V_PW_FIRST_YYYYMMDD       NVARCHAR(8);    -- PSD가 속한 partial week 첫날짜 (판가 조회 기준일)
    DECLARE @V_SHORT_TERM_END_YYYYMMDD NVARCHAR(8);    -- 근거리 구간 종료일(미만)

    -- 2026.09.15 Minyong Lee : [E20260812-000909] [ESS] Supply > OPT Plan > Plan Control 의 Create Plan ID 팝업 변경 요청드립니다
    DECLARE @V_PARAMETER_ID        NVARCHAR(20)  = (SELECT TOP 1 ISNULL(OPMZ_PRAM_TP_CD, @V_GROUP_ID)
                                                    FROM SCP_OPMZ_PLAN_M 
                                                    WHERE OPMZ_PLAN_ID = @V_PLAN_ID)

    PRINT 'SAFETY_STOCK - PLAN_GROUP: ' + @V_GROUP_ID + ' & PARAMETER: ' + @V_PARAMETER_ID
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
		--AND   (STAGE IN ('ASSY', 'ASY_AGING', 'SUBMDLE')
		AND   (STAGE IN ('ASSY', 'ASY_AGING', 'LINK', 'PACK', 'RACK','CHAR' )
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
                        ON  CV.DIVISION_ID = SMS.DIVISION_ID
                        AND CV.SCM_SITE_ID = SMS.SCM_SITE_ID
                    LEFT OUTER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                        ON CV.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                WHERE   1=1
                AND     CV.VALUE_TYPE   = 'MAX'
                AND     CV.VALID_YN     = 'Y'
                AND     CV.DIVISION_ID  = @V_DIVISION_ID
                AND     CV.TO_YYYYMMDD   >= @V_PLAN_START_YYYYMMDD
                AND     CV.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
                AND     CV.STAGE = 'CHAR'
                AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
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
			    	AND CP.SCM_SITE_ID = RT.ATTRIBUTE1
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
                        ON  CV.DIVISION_ID = SMS.DIVISION_ID
                        AND CV.SCM_SITE_ID = SMS.SCM_SITE_ID
                    LEFT OUTER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                        ON CV.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                WHERE   1=1
                AND     CV.VALUE_TYPE   = 'MAX'
                AND     CV.VALID_YN     = 'Y'
                AND     CV.DIVISION_ID  = @V_DIVISION_ID
                AND     CV.TO_YYYYMMDD   >= @V_PLAN_START_YYYYMMDD
                AND     CV.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
                AND     CV.STAGE <> 'CHAR'
                AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
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
         	  , SIS.BUFFER_ID                               AS BUFFER_ID
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
        FROM    SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY CV WITH(NOLOCK) -- (MIN)
            INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
                    ON  SIS.PLAN_ID = @V_PLAN_ID
                    AND CV.SCM_SITE_ID = SIS.SITE_ID
                    AND CV.ITEM_ID = SIS.ITEM_ID
                    AND CV.STAGE = SIS.ATTRIBUTE3
            LEFT OUTER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                ON CV.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
        WHERE   1=1
        AND     CV.VALUE_TYPE = 'MIN'
        AND     CV.VALID_YN		 = 'Y'
        AND     CV.DIVISION_ID	 = @V_DIVISION_ID           
        AND     CV.TO_YYYYMMDD   >= @V_PLAN_START_YYYYMMDD
        AND     CV.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
        AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID

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
		      , SIS.BUFFER_ID	                                AS BUFFER_ID
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
              , 'L1'                                            AS CALENDAR_LEVEL
        FROM    SCP_OPMZ_SAFETY_STOCK SQ WITH(NOLOCK)
            INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
                ON  SIS.PLAN_ID = @V_PLAN_ID
                AND SQ.SCM_SITE_ID = SIS.SITE_ID
                AND SQ.ITEM_ID = SIS.ITEM_ID
                AND SQ.STAGE = SIS.ATTRIBUTE3
            LEFT OUTER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                ON SQ.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
        WHERE   1=1
        AND     SQ.VALUE_TYPE   = 'MIN'
        AND     SQ.VALID_YN		= 'Y'
        AND     SQ.DIVISION_ID	= @V_DIVISION_ID  
        AND     SQ.TO_YYYYMMDD  >= @V_PLAN_START_YYYYMMDD
        AND     SQ.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
        AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID

		----------------------------------------------------------
        -- 2026.08.06 Minyong Lee : [E20260728-000450] [ODS]비용기반 계획수립을 위한 input 데이터 생성
		-- 생산원가 cost_cal 인풋 생성
        --  - IBR에서 USER_ATTB1('PCC'+BUFFER_ID)이 세팅된 버퍼 대상 (RUN_MAIN에서 IBR 선행 실행됨)
        --  - L0 : 전 계획구간 VALUE 0
        --  - L5 : 전 계획구간 VALUE = LOOKUP(SCP_OPT_ENG_PROD_COST)의 COST(ATTRIBUTE2)
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
        SELECT  @V_PLAN_ID              AS PLAN_ID
               ,PCC.PCC_BUFFER_ID       AS BUFFER_ID
               ,'cost_cal'              AS TYPE
               ,@V_PLAN_START_YYYYMMDD  AS START_DATE
               ,@V_PLAN_END_YYYYMMDD    AS END_DATE
               ,LV.VALUE                AS VALUE
               ,LV.CALENDAR_LEVEL       AS CALENDAR_LEVEL
        FROM(
            -- IBR에 PCC 세팅된 버퍼의 SITE/ITEM 복원
            SELECT  DISTINCT
                    IBR.USER_ATTB1  AS PCC_BUFFER_ID
                   ,SIS.SITE_ID     AS SCM_SITE_ID
                   ,SIS.ITEM_ID     AS ITEM_ID
            FROM    SCP_OPT_ENG_ITEM_BOM_ROUTING_SN IBR WITH(NOLOCK)
                INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
                    ON  SIS.PLAN_ID   = @V_PLAN_ID
                    AND SIS.BUFFER_ID = IBR.BUFFER_ID
            WHERE   IBR.PLAN_ID = @V_PLAN_ID
            AND     IBR.USER_ATTB1 LIKE 'PCC%'
            ) PCC
            INNER JOIN (
                    SELECT  SEGMENT2 AS SCM_SITE_ID
                           ,SEGMENT3 AS ITEM_ID
                           ,MAX(TRY_CAST(ATTRIBUTE2 AS NUMERIC(20,10))) AS COST -- 동일 SITE+ITEM 중복 등록 대비
                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_COST'
                    AND     VALID_YN    = 'Y'
                    AND     SEGMENT1    = @V_DIVISION_ID
                    GROUP BY SEGMENT2, SEGMENT3
                    ) LU
                ON  LU.SCM_SITE_ID = PCC.SCM_SITE_ID
                AND LU.ITEM_ID     = PCC.ITEM_ID
            CROSS APPLY (VALUES (CAST(0 AS NUMERIC(20,10)), 'L0')   -- 전 구간 비용 0
                               ,(LU.COST                  , 'L5')   -- 전 구간 룩업 원가
                        ) LV(VALUE, CALENDAR_LEVEL)
        ;

		----------------------------------------------------------
        -- 2026.08.07 Minyong Lee : [E20260728-000450] [ODS]비용기반 계획수립을 위한 input 데이터 생성
		-- LD(지체상금) cost_cal 인풋 생성
        --  - L5 = 구간별 벌금(PSD/PED 구간 밖 제외) / L0 = 전 계획구간 0
		----------------------------------------------------------
        SELECT  @V_BASE_MODE = MAX(ATTRIBUTE1)
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_BASE'
        AND     VALID_YN    = 'Y'
        AND     SEGMENT1    = @V_DIVISION_ID
        AND     SEGMENT2    = @V_PARAMETER_ID
        ;

        IF ISNULL(@V_BASE_MODE, '') = 'COST'
        BEGIN
            IF OBJECT_ID('TEMPDB..#LD_SS') IS NOT NULL DROP TABLE #LD_SS;

            SELECT  'BCC' + LD.PROJECT + '::' + IMW.ITEM_ID + '::' + LD.LOT_SEQ AS BCC_BUFFER_ID
                   ,CASE WHEN LD.LD_START_YYYYMMDD <= @V_PLAN_START_YYYYMMDD THEN @V_PLAN_START_YYYYMMDD
                         ELSE LD.LD_START_YYYYMMDD
                    END AS START_DATE
                   ,CASE WHEN LD.LD_END_YYYYMMDD >= @V_PLAN_END_YYYYMMDD THEN @V_PLAN_END_YYYYMMDD
                         ELSE LD.LD_END_YYYYMMDD
                    END AS END_DATE
                   ,CASE WHEN UPPER(LD.UNIT) = 'MWH' THEN LD.COST * IMW.MWH ELSE LD.COST END AS VALUE
            INTO    #LD_SS
            FROM (
                  -- 계약 LOT x 벌금구간 => LD 적용구간
                  SELECT  LDI.PROJECT
                        , LDI.LOT_SEQ
                        , LDC.UNIT
                        , LDC.COST
                        , CONVERT(NVARCHAR(8), DATEADD(DAY, LDC.START_DAYS, LDI.END_DATE), 112) AS LD_START_YYYYMMDD
                        , CONVERT(NVARCHAR(8), DATEADD(DAY, LDC.END_DAYS + 1, LDI.END_DATE), 112) AS LD_END_YYYYMMDD -- 2026.08.07 Minyong Lee : 룩업(이상/이하) -> 인풋(이상/미만) 기준 변환(+1일)
                  FROM (
                        SELECT  SEGMENT2 AS PROJECT
                              , SEGMENT4 AS LOT_SEQ
                              , SEGMENT6 AS END_DATE
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_LD_CONTRACT_INFO'
                        AND     VALID_YN    = 'Y'
                        AND     SEGMENT1    = @V_DIVISION_ID
                       ) LDI
                      INNER JOIN (
                        SELECT  SEGMENT2 AS PROJECT
                              , SEGMENT3 AS UNIT
                              , TRY_CAST(SEGMENT4 AS INT) AS START_DAYS
                              , TRY_CAST(IIF(SEGMENT5 = '-', '99999', SEGMENT5) AS INT) AS END_DAYS -- '-' = 무한
                              , TRY_CAST(SEGMENT6 AS NUMERIC(20,10)) AS COST
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_LD_COST'
                        AND     VALID_YN    = 'Y'
                        AND     SEGMENT1    = @V_DIVISION_ID
                       ) LDC
                          ON  LDI.PROJECT = LDC.PROJECT
                 ) LD
                INNER JOIN (
                      -- 현 PLAN 수요의 PROJECT 별 아이템(12자리) + MWh 환산값
                      SELECT  DE.PROJECT
                            , DE.ITEM_ID
                            , M.MWH
                      FROM (
                            SELECT  DISTINCT
                                    ATTRIBUTE5           AS PROJECT
                                  , LEFT(ATTRIBUTE2, 12) AS ITEM_ID
                            FROM    SCP_OPT_ENG_DEMAND_ORIGIN_SN WITH(NOLOCK)
                            WHERE   PLAN_ID = @V_PLAN_ID
                           ) DE
                          LEFT JOIN (
                            SELECT  LEFT(ITEM_ID, 12) AS ITEM_ID
                                  , MAX(TRY_CAST(ENERGE AS NUMERIC(20,4))) / 1000000 AS MWH -- Wh -> MWh (FLOAT 사용 시 부동소수점 오차 발생하여 NUMERIC 사용)
                            FROM    SCM_ITEM_M_SN WITH(NOLOCK)
                            WHERE   ACTIVE_FLAG = 'Y'
                            AND     ITEM_ID LIKE 'ET%'
                            GROUP BY LEFT(ITEM_ID, 12)
                           ) M
                              ON  DE.ITEM_ID = M.ITEM_ID
                     ) IMW
                    ON  LD.PROJECT = IMW.PROJECT
            WHERE   (UPPER(LD.UNIT) = 'EA' OR (UPPER(LD.UNIT) = 'MWH' AND IMW.MWH IS NOT NULL))
            AND     LD.LD_START_YYYYMMDD <  @V_PLAN_END_YYYYMMDD   -- 계획구간 밖 구간 제외
            AND     LD.LD_END_YYYYMMDD   >  @V_PLAN_START_YYYYMMDD
            ;

            INSERT INTO SCP_OPT_ENG_SAFETY_STOCK_SN(
                        PLAN_ID
                       ,BUFFER_ID
                       ,TYPE
                       ,START_DATE
                       ,END_DATE
                       ,VALUE
                       ,CALENDAR_LEVEL
                       )
            -- L5 : LOT x 벌금구간별 벌금
            SELECT  @V_PLAN_ID, BCC_BUFFER_ID, 'cost_cal', START_DATE, END_DATE, VALUE, 'L5'
            FROM    #LD_SS
            UNION ALL
            -- L0 : 버퍼별 전 계획구간 0
            SELECT  DISTINCT
                    @V_PLAN_ID, BCC_BUFFER_ID, 'cost_cal', @V_PLAN_START_YYYYMMDD, CONVERT(NVARCHAR(8), DATEADD(DAY, 1, @V_PLAN_END_YYYYMMDD), 112), 0, 'L0'
            FROM    #LD_SS
            ;

            IF OBJECT_ID('TEMPDB..#LD_SS') IS NOT NULL DROP TABLE #LD_SS;
        END

		----------------------------------------------------------
        -- 2026.08.21 Minyong Lee : [E20260728-000450] [ODS]비용기반 계획수립을 위한 input 데이터 생성
        -- 2026.08.21 Minyong Lee : [E20260819-000658] [ODS] 비용기반 계획 수립을 위한 ODS개발요청(+추가건 매출최대화)
        ----------------------------------------------------------
        SELECT  @V_SALESPRICE_SHORT_TERM = TRY_CAST(ATTRIBUTE1 AS INT)
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE   LOOKUP_TYPE = 'SCP_OPT_COST_BASE_CONFIG'
        AND     VALID_YN    = 'Y'
        AND     SEGMENT1    = @V_DIVISION_ID
        AND     SEGMENT2    = 'SALESPRICE_SHORT_TERM'
        ;

        SELECT  @V_SALESPRICE_WEIGHT = TRY_CAST(ATTRIBUTE1 AS NUMERIC(20,10))
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE   LOOKUP_TYPE = 'SCP_OPT_COST_BASE_CONFIG'
        AND     VALID_YN    = 'Y'
        AND     SEGMENT1    = @V_DIVISION_ID
        AND     SEGMENT2    = 'SALESPRICE_SHORT_TERM_WEIGHT'
        ;

        SET @V_SALESPRICE_SHORT_TERM = ISNULL(@V_SALESPRICE_SHORT_TERM, 0);
        SET @V_SALESPRICE_WEIGHT     = ISNULL(@V_SALESPRICE_WEIGHT, 0);

        BEGIN
            -- PSD가 속한 partial week 첫날짜 (판가 조회 기준일)
            SELECT  @V_PW_FIRST_YYYYMMDD = MIN(C2.BASIS_YYYYMMDD)
            FROM    SCM_SYS_CALENDAR_M C1 WITH(NOLOCK)
                INNER JOIN SCM_SYS_CALENDAR_M C2 WITH(NOLOCK)
                    ON  C2.BASIS_YYYYMM      = C1.BASIS_YYYYMM
                    AND C2.PARTIAL_WEEK_NAME = C1.PARTIAL_WEEK_NAME
            WHERE   C1.BASIS_YYYYMMDD = @V_PLAN_START_YYYYMMDD
            ;

            -- 근거리 구간 종료일(미만) : PSD + N일 (N=0이면 PSD와 동일 -> 근거리 구간 없음 / PED 초과 시 PED로 클리핑)
            SET @V_SHORT_TERM_END_YYYYMMDD = CONVERT(NVARCHAR(8), DATEADD(DAY, @V_SALESPRICE_SHORT_TERM, @V_PLAN_START_YYYYMMDD), 112);
            IF @V_SHORT_TERM_END_YYYYMMDD > @V_PLAN_END_YYYYMMDD
                SET @V_SHORT_TERM_END_YYYYMMDD = @V_PLAN_END_YYYYMMDD;

            -- SPC 버퍼별 기준 판가
            -- (그룹 수요 버퍼는 'D_' 원본 역참조로 변종 아이템 복원 후 판가 조회, 버퍼 내 변종 판가 상이 시 MAX)
            IF OBJECT_ID('TEMPDB..#SPC') IS NOT NULL DROP TABLE #SPC;

            SELECT  DM.USER_ATTB7   AS SPC_BUFFER_ID
                  , MAX(FP.PRICE)   AS PRICE  -- 판가 미존재 버퍼는 NULL -> L5 미생성
            INTO    #SPC
            FROM    SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                LEFT JOIN SCP_OPT_ENG_DEMAND_SN ORG WITH(NOLOCK)
                    ON  ORG.PLAN_ID    = @V_PLAN_ID
                    AND ORG.DEMAND_ID  = 'D_' + DM.DEMAND_ID
                    AND DM.ATTRIBUTE12 = 'DEMAND_GROUP'
                LEFT JOIN (
                        SELECT  SCM_SITE_ID, PROJECT_CODE, ITEM_ID, MAX(PRICE) AS PRICE -- 동일 키 중복(INCOTERMS/FCST_TYPE 상이 등) 대비
                        FROM    SCM_MST_FUTURE_PRICE WITH(NOLOCK)
                        WHERE   DIVISION_ID = @V_DIVISION_ID
                        AND     MEASURE     = 'USD' -- USD 단일 통화 전제
                        AND     YYYYMMDD    = @V_PW_FIRST_YYYYMMDD
                        GROUP BY SCM_SITE_ID, PROJECT_CODE, ITEM_ID
                        ) FP
                    ON  FP.SCM_SITE_ID  = DM.ATTRIBUTE1 -- SCM_SITE_ID
                    AND FP.ITEM_ID      = ISNULL(ORG.ATTRIBUTE2, DM.ATTRIBUTE2) -- 그룹 수요는 원본 아이템, 일반 수요는 자기 아이템
                    AND FP.PROJECT_CODE = DM.ATTRIBUTE5 -- PROJECT_CODE
            WHERE   DM.PLAN_ID = @V_PLAN_ID
            AND     DM.USER_ATTB7 LIKE 'SPC%'
            GROUP BY DM.USER_ATTB7
            ;

            INSERT INTO SCP_OPT_ENG_SAFETY_STOCK_SN(
                        PLAN_ID
                       ,BUFFER_ID
                       ,TYPE
                       ,START_DATE
                       ,END_DATE
                       ,VALUE
                       ,CALENDAR_LEVEL
                       )
            -- L0 : 전 계획구간 0 (판가 유무 무관)
            SELECT  @V_PLAN_ID, SPC_BUFFER_ID, 'cost_cal', @V_PLAN_START_YYYYMMDD, @V_PLAN_END_YYYYMMDD, 0, 'L0'
            FROM    #SPC
            UNION ALL
            -- L5 근거리 : [PSD, PSD+N일) = 판가 * (1 + 가중치/100). N=0(=SHORT_TERM_END가 PSD와 동일)이면 구간이 없어 미생성
            SELECT  @V_PLAN_ID, SPC_BUFFER_ID, 'cost_cal', @V_PLAN_START_YYYYMMDD, @V_SHORT_TERM_END_YYYYMMDD
                  , CAST(PRICE * (1 + (@V_SALESPRICE_WEIGHT / 100.0)) AS NUMERIC(20,3)), 'L5'
            FROM    #SPC
            WHERE   PRICE IS NOT NULL
            AND     @V_SHORT_TERM_END_YYYYMMDD > @V_PLAN_START_YYYYMMDD
            UNION ALL
            -- L5 원거리 : [PSD+N일, PED) = 판가. 근거리 구간이 없으면(N=0) 전체 [PSD, PED) 판가 단일
            SELECT  @V_PLAN_ID, SPC_BUFFER_ID, 'cost_cal', @V_SHORT_TERM_END_YYYYMMDD, @V_PLAN_END_YYYYMMDD, PRICE, 'L5'
            FROM    #SPC
            WHERE   PRICE IS NOT NULL
            AND     @V_SHORT_TERM_END_YYYYMMDD < @V_PLAN_END_YYYYMMDD
            ;

            IF OBJECT_ID('TEMPDB..#SPC') IS NOT NULL DROP TABLE #SPC;
        END

		------------------------------------------------------------------------
		-- Data Insert End
		------------------------------------------------------------------------
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
