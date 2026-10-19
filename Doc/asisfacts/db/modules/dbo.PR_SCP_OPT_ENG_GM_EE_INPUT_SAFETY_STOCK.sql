

CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_EE_INPUT_SAFETY_STOCK]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.07 Taehyun Initial Release
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_EE_INPUT_SAFETY_STOCK';
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
    DECLARE @V_CATHODE_PLAN_ID   NVARCHAR(50);
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

		IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
		BEGIN 
			DROP TABLE  #DIVISION;
		END;

		SELECT DIVISION_ID 
		INTO #DIVISION
		FROM SCM_MST_DIVISION WITH(NOLOCK)
		WHERE  VALID_YN = 'Y'
		AND    ATTRIBUTE3 <> 'EE'
		AND    ATTRIBUTE4 = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID) 
		;

		----------------------------------------------------------
		-- 1. 특정 Stage 전 구간 L0 / 0 처리 : COATING, ELEC_POST, BIZ
        -- 2025.05.13 Philsu Park: max_cover_day L0 생성 제외.(주석처리)
        -- 2025.05.30 Philsu Park: max_cover_day L0 활성화(주석 제거 - 신성재 책임님 요청)
        -- 2025.07.10 Philsu Park: COATING은 max_cover_day 제외 (권순지 책임님 요청)
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
		-- AND   (STAGE IN ('COATING', 'ELEC_POST')
        AND   (STAGE IN ('ELEC_POST')
			OR STAGE LIKE '%BIZ%'
			  ) 

		----------------------------------------------------------
		-- 2. Lookup에 Stage 별 등록 확인 후 수정 처리 필요
        -- 2025.06.24 Philsu Park: BIZ Stage 도 max cover 반영될 수 있게 ROUTING Join 조건을 Outer로 변경.
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
			SELECT CP.SCM_SITE_ID   AS SCM_SITE_ID
				  ,CP.ITEM_ID        AS ITEM_ID
				  ,CP.STAGE          AS STAGE
				  ,'max_cover_day'   AS TYPE
				  ,CP.EFF_START_DATE AS START_DATE
				  ,CP.EFF_END_DATE   AS END_DATE
				  ,CP.VALUE          AS TEMP_VALUE
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
				--ON      1=1 --LV.SEGMENT2 = SMS.DIVISION_ID
				--AND     LV.SEGMENT3 = SMS.SCM_SITE_ID

				--INNER JOIN #DIVISION D WITH(NOLOCK)
				--ON SMS.DIVISION_ID = D.DIVISION_ID

				--WHERE   LV.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PRECEDE'
				--AND     LV.VALID_YN    = 'Y'
				--AND     LV.SEGMENT2    = @V_DIVISION_ID

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
                        ON CV.SCM_SITE_ID = SMS.SCM_SITE_ID
                    INNER JOIN #DIVISION D WITH(NOLOCK)
                        ON SMS.DIVISION_ID = D.DIVISION_ID
                    LEFT OUTER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                        ON CV.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                WHERE   1=1
                AND     CV.VALUE_TYPE   = 'MAX'
                AND     CV.VALID_YN     = 'Y'
                AND     CV.DIVISION_ID  = @V_DIVISION_ID
                AND     CV.TO_YYYYMMDD   >= @V_PLAN_START_YYYYMMDD
                AND     CV.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
                AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
				) AS CP
			WHERE 1=1
			) CP
            LEFT OUTER JOIN ( SELECT DISTINCT PLAN_ID,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3 
                            FROM SCP_OPT_ENG_ROUTING_SN WITH(NOLOCK) 
                            WHERE PLAN_ID = @V_PLAN_ID
                        ) RT
                ON  RT.PLAN_ID      = @V_PLAN_ID
                AND CP.SCM_SITE_ID  = RT.ATTRIBUTE1
                AND CP.ITEM_ID      = RT.ATTRIBUTE2
                AND CP.STAGE        = RT.ATTRIBUTE3
            INNER JOIN  SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
                ON  SIS.PLAN_ID     = @V_PLAN_ID
                AND CP.SCM_SITE_ID = SIS.SITE_ID
                AND CP.ITEM_ID      = SIS.ITEM_ID
                AND CP.STAGE        = SIS.ATTRIBUTE3
		----------------------------------------------------------
		-- 3) Min Cover Day : Lookup 그대로 등록
        -- 2025.05.13 Philsu Park: Target_Biz의 Buffer_Id 채번룰 및 Lookup Join조건 수정
        -- Target_Biz의 BUffer_Id: Site::Item::Stage@Incoterms@Project
        -- 2025.05.13 Philsu Park: ATT1, 2 조건 수정
        -- 2025.11.04 Minyong Lee : Lookup -> UI 전환 (cover_day)
        -- 2025.11.25 Minyong Lee : 
        --      - ROUTING JOIN이 있다면 그대로 유지
        --      - ITEM_SITE JOIN이 없다면 INNER JOIN 추가
        --      - Sales Site Incoterms 구분 없이 STAGE 기준 JOIN
        --      - ITEM_SITE의 BUFFER_ID 그대로 사용
		----------------------------------------------------------
        --UNION ALL
		--SELECT	 @V_PLAN_ID										AS PLAN_ID
		--		,LV.SEGMENT3+'::'+LV.SEGMENT4+'::'+LV.SEGMENT5+IIF(SIS.ATTRIBUTE1 IS NULL ,'','@'+SIS.ATTRIBUTE1)+IIF(SIS.ATTRIBUTE2 IS NULL ,'','@'+SIS.ATTRIBUTE2)	AS BUFFER_ID
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
  --               AND LV.SEGMENT5 = SIS.ATTRIBUTE3 -- Type 기준으로만 Join 처리.
  --              --  AND LV.SEGMENT5 = SIS.ATTRIBUTE3 + IIF(SIS.ATTRIBUTE1 IS NULL ,'','@'+SIS.ATTRIBUTE1)
		--WHERE   LV.LOOKUP_TYPE	= 'SCP_OPT_ENG_CONST_SAFETY_STOCK'
		--AND     LV.VALID_YN		= 'Y'
		--AND     LV.SEGMENT2		= @V_DIVISION_ID
  --      AND     LV.ATTRIBUTE1   > @V_PLAN_START_YYYYMMDD -- +1일이 되지 않아서 등호 제거
  --      AND     LV.ATTRIBUTE2   < @V_PLAN_END_YYYYMMDD   --END DATE가 하루 추가된 날짜이기 때문에, 등호 제거

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
        AND     CV.VALUE_TYPE    = 'MIN'
        AND     CV.VALID_YN		 = 'Y'
        AND     CV.DIVISION_ID	 = @V_DIVISION_ID
        AND     CV.TO_YYYYMMDD   >= @V_PLAN_START_YYYYMMDD
        AND     CV.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
        AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID

		----------------------------------------------------------
		-- 4) Min Cover Qty : Lookup 그대로 등록
		-- 2025.05.09 Philsu Park: Target_Biz의 Buffer_Id 채번룰 및 Lookup Join조건 수정
        -- Target_Biz의 BUffer_Id: Site::Item::Stage@Incoterms@Project
        -- 2025.05.13 Philsu Park: ATT1, 2 조건 수정
        -- 2025.05.13 Philsu Park: ATT1, 2 조건 수정(Start ~ End 보다 룩업 등록구간이 큰 경우 계획구간만큼 생성.)
        -- 2025.11.04 Minyong Lee : Lookup -> UI 전환 (stock_qty)
        -- 2025.11.25 Minyong Lee : 
        --      - ROUTING JOIN이 있다면 그대로 유지
        --      - ITEM_SITE JOIN이 없다면 INNER JOIN 추가
        --      - Sales Site Incoterms 구분 없이 STAGE 기준 JOIN
        --      - ITEM_SITE의 BUFFER_ID 그대로 사용
		----------------------------------------------------------
        --UNION ALL
		--SELECT	 @V_PLAN_ID										AS PLAN_ID
  --              ,LV.SEGMENT3+'::'+LV.SEGMENT4+'::'+LV.SEGMENT5+IIF(SIS.ATTRIBUTE1 IS NULL ,'','@'+SIS.ATTRIBUTE1)+IIF(SIS.ATTRIBUTE2 IS NULL ,'','@'+SIS.ATTRIBUTE2) AS BUFFER_ID
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
  --               AND LV.SEGMENT5 = SIS.ATTRIBUTE3
		--WHERE   LV.LOOKUP_TYPE	= 'SCP_OPT_ENG_CONST_SAFETY_STOCK_QTY'
		--AND     LV.VALID_YN		= 'Y'
		--AND     LV.SEGMENT2		= @V_DIVISION_ID  
  --      AND     GREATEST(LV.ATTRIBUTE1, @V_PLAN_START_YYYYMMDD) >= @V_PLAN_START_YYYYMMDD
  --      AND     LEAST(LV.ATTRIBUTE2, @V_PLAN_END_YYYYMMDD)      <= @V_PLAN_END_YYYYMMDD
  --      AND     LV.ATTRIBUTE4 = @V_GROUP_ID

        UNION ALL
        SELECT  @V_PLAN_ID									AS PLAN_ID
              , SIS.BUFFER_ID                               AS BUFFER_ID
              , 'min_stock_qty'								AS TYPE 
              , CASE
                    WHEN SQ.FROM_YYYYMMDD <= @V_PLAN_START_YYYYMMDD THEN @V_PLAN_START_YYYYMMDD
			        ELSE SQ.FROM_YYYYMMDD
		        END AS START_DATE
              , CASE
                    WHEN IIF(SQ.TO_YYYYMMDD<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,SQ.TO_YYYYMMDD),112),SQ.TO_YYYYMMDD) >= @V_PLAN_END_YYYYMMDD THEN @V_PLAN_END_YYYYMMDD
         	        ELSE IIF(SQ.TO_YYYYMMDD<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,SQ.TO_YYYYMMDD),112),SQ.TO_YYYYMMDD)
       	        END AS END_DATE
              , SQ.APL_QTY									AS VALUE
              , 'L1'                                        AS CALENDAR_LEVEL
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
        AND     SQ.TO_YYYYMMDD >= @V_PLAN_START_YYYYMMDD
        AND     SQ.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
        AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID

        --------------------------------------------------------------------------------------------------------------------
        -- 2025.05.09 Philsu Park
		-- 5) Min Stock Qty : EE, 음극인 경우, 양극 Plan Output의 매주 월요일 COATING BOH를 min_stock_qty 로 활용.
        -- 2025.07.09 Philsu Park: 음극 소요량 산출 시 수율비중 추가 반영.
		--------------------------------------------------------------------------------------------------------------------
        IF (@V_DIVISION_ID = 'EE_UC' AND RIGHT(@V_PLAN_ID, 2) = '_A')
            BEGIN
                SELECT @V_CATHODE_PLAN_ID = CONCAT(SUBSTRING(@V_PLAN_ID, 1, LEN(@V_PLAN_ID) - 2), '_C');

                WITH YIELD_MST AS ( 
                        SELECT    LU.SEGMENT4 AS ITEM_ID
                                , LU.SEGMENT5 AS MONTH
                                , MAX(IIF(RIGHT(LU.SEGMENT2, 1) = 'E', CONVERT(NUMERIC(20, 4), ATTRIBUTE1), NULL)) AS POST_YIELD
                                , MAX(IIF(RIGHT(LU.SEGMENT2, 1) = 'A', CONVERT(NUMERIC(20, 4), ATTRIBUTE1), NULL)) AS ASSY_YIELD
                        FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                        WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_MASTER_YIELD'
                        AND    LU.VALID_YN    = 'Y'
                        AND    LU.SEGMENT1    = @V_DIVISION_ID
                        AND    LU.SEGMENT5 BETWEEN SUBSTRING(@V_PLAN_START_YYYYMMDD, 1, 6) AND SUBSTRING(@V_PLAN_END_YYYYMMDD, 1, 6)
                        GROUP BY LU.SEGMENT4, LU.SEGMENT5 )
                    , CATHODE_BOM AS (   
                        SELECT    AD.CHILD_ITEM_ID  AS ANODE_ITEM_ID
                                , CD.CHILD_ITEM_ID  AS CHATHODE_ITEM_ID
                                , AD.USAGE/CD.USAGE AS CAL_USAGE        -- ANODE 소요량/CATHODE 소요량
                        FROM (  SELECT  PARENT_ITEM_ID,CHILD_ITEM_ID,USAGE
                                FROM    SCP_MST_BOM_ELEC WITH(NOLOCK)
                                WHERE   PARENT_ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                                            FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                            WHERE  PLAN_ID = @V_CATHODE_PLAN_ID  -- !!나중에 양극 Plan Id 로 바꿔치기 필요.
                                                            )
                                AND     SCP_YN          = 'Y'
                                AND     ELECTRODE_TYPE  = 'ANODE'
                                ) AD
                        INNER JOIN (    SELECT  PARENT_ITEM_ID,CHILD_ITEM_ID,USAGE
                                        FROM    SCP_MST_BOM_ELEC WITH(NOLOCK)
                                        WHERE   PARENT_ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                                                    FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                                    WHERE  PLAN_ID = @V_CATHODE_PLAN_ID  -- !!나중에 양극 Plan Id 로 바꿔치기 필요.
                                                                    )
                                        AND     SCP_YN = 'Y'
                                        AND     ELECTRODE_TYPE = 'CATHODE'
                                    ) CD
                                ON AD.PARENT_ITEM_ID = CD.PARENT_ITEM_ID
                        GROUP BY AD.CHILD_ITEM_ID,CD.CHILD_ITEM_ID,AD.USAGE,CD.USAGE )
                INSERT INTO SCP_OPT_ENG_SAFETY_STOCK_SN
                    (
                        PLAN_ID
                        , BUFFER_ID
                        , [TYPE]
                        , [START_DATE]
                        , END_DATE
                        , [VALUE]
                        , CALENDAR_LEVEL
                    )
                    --------------------------------------------------------------
                    -- value : boh_qty값을 음극/양극 사용비율을 반영하여 값을 지정한다.
                    -- 2025.05.14 Philsu Park: Buffer_ID를 음극기준으로 바꿔줘야됨. ITEM_ID를 REPLACE처리.
                    --                         + Model List 제약조건 추가. + 음극 소요량 산식 변경.
                    -- 2025.06.13 Philsu Park: NVARCHAR convertion error 방지를 위한 NVACHAR -> FLOAT -> NUMERIC 형태로 컨버전.
                    -- 2025.07.09 Philsu Park: 소요량 * ELEC_POST 수율비중 * ASSY 수율비중
                    --------------------------------------------------------------
                    SELECT    @V_PLAN_ID                                                AS PLAN_ID
                            , REPLACE(S.BUFFER, S.ITEM, BOM.ANODE_ITEM_ID)              AS BUFFER_ID
                            , 'min_stock_qty'                                           AS [TYPE]
                            , S.DATE                                                    AS [START_DATE]
                            , CONVERT(NVARCHAR, DATEADD(DAY, 1, CM.BASIS_DATE), 112)    AS END_DATE
                            -- , TRY_CONVERT(NUMERIC(20,10), TRY_CONVERT(FLOAT, S.QTY)) * BOM.CAL_USAGE            AS [VALUE]
                            , ROUND(TRY_CONVERT(NUMERIC(20,10), TRY_CONVERT(FLOAT, S.QTY))
                                    * BOM.CAL_USAGE
                                    * ISNULL(CYD.POST_YIELD, 1)/ISNULL(AYD.POST_YIELD, 1)
                                    * ISNULL(CYD.ASSY_YIELD, 1)/ISNULL(AYD.ASSY_YIELD, 1), 4) AS [VALUE]
                            , 'L5'                                                      AS CALENDAR_LEVEL
                    FROM    SCP_OPT_ENG_OUT_PLAN_RESULT_SN S WITH(NOLOCK)
                    INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)       -- 월요일 조건 걸기 위해 Calendar Join.
                        ON  CM.BASIS_YYYYMMDD   = S.DATE     -- Bucket Start 날짜 기준으로..
                    INNER JOIN CATHODE_BOM BOM WITH(NOLOCK)
                        ON  S.ITEM                          = BOM.CHATHODE_ITEM_ID
                    LEFT OUTER JOIN YIELD_MST CYD
                        ON  S.ITEM          = CYD.ITEM_ID
                        AND CM.BASIS_YYYYMM = CYD.MONTH
                    LEFT OUTER JOIN YIELD_MST AYD
                        ON  BOM.ANODE_ITEM_ID   = AYD.ITEM_ID
                        AND CM.BASIS_YYYYMM     = AYD.MONTH
                    WHERE   S.PLAN_ID                       = @V_CATHODE_PLAN_ID    -- 실제로는 양극 PLAN_ID 가 들어가야 함.
                    AND     S.TYPE                          = 'BOH'                     -- Output Result에서 BOH만 가져와야 함.
                    AND     RIGHT(S.BUFFER, 7)              = 'COATING'                 -- COATING BUFFER
                    AND     CM.DAYOFWEEK                    = 'MON'                     -- 월요일 새벽 BOH를 사용.
                    AND     TRY_CONVERT(NUMERIC(20,10), TRY_CONVERT(FLOAT, S.QTY))  > 0                         -- 재고수량 > 0 값만 사용
                    AND     CONCAT(S.SITE, BOM.ANODE_ITEM_ID)   IN (SELECT DISTINCT CONCAT (SCM_SITE_ID, ITEM_ID)
                                                                    FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                                    WHERE  PLAN_ID = @V_PLAN_ID
                                                                    )
                    
                    UNION 
                    --------------------------------------------------------------
                    -- 전체 기간에 대해 default 값 0을 설정 : L0
                    -- 2025.06.13 Philsu Park: NVARCHAR convertion error 방지를 위한 NVACHAR -> FLOAT -> NUMERIC 형태로 컨버전.
                    --------------------------------------------------------------
                    SELECT    @V_PLAN_ID                                        AS PLAN_ID
                            , REPLACE(S.BUFFER, S.ITEM, BOM.ANODE_ITEM_ID)      AS BUFFER_ID
                            , 'min_stock_qty'                                   AS [TYPE]
                            , @V_PLAN_START_YYYYMMDD                            AS [START_DATE]
                            , @V_PLAN_END_YYYYMMDD                              AS END_DATE
                            , '0'                                               AS [VALUE]
                            , 'L0'                                              AS CALENDAR_LEVEL
                    FROM    SCP_OPT_ENG_OUT_PLAN_RESULT_SN S WITH(NOLOCK)
                    INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)       -- 월요일 조건 걸기 위해 Calendar Join.
                        ON  CM.BASIS_YYYYMMDD   = S.DATE     -- Bucket Start 날짜 기준으로..
                    INNER JOIN CATHODE_BOM BOM WITH(NOLOCK)
                        ON  S.ITEM                          = BOM.CHATHODE_ITEM_ID
                    WHERE   S.PLAN_ID                       = @V_CATHODE_PLAN_ID        -- 실제로는 양극 PLAN_ID 가 들어가야 함.
                    AND     S.TYPE                          = 'BOH'                     -- Output Result에서 BOH만 가져와야 함.
                    AND     RIGHT(S.BUFFER, 7)              = 'COATING'                 -- COATING BUFFER
                    AND     CM.DAYOFWEEK                    = 'MON'                     -- 월요일 새벽 BOH를 사용.
                    AND     TRY_CONVERT(NUMERIC(20,10), TRY_CONVERT(FLOAT, S.QTY))  > 0                         -- 재고수량 > 0 값만 사용
                    AND     CONCAT(S.SITE, BOM.ANODE_ITEM_ID)   IN (SELECT DISTINCT CONCAT (SCM_SITE_ID, ITEM_ID)
                                                                    FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                                    WHERE  PLAN_ID = @V_PLAN_ID
                                                                    )
                ;
            END;
        
        ----------------------------------------------------------
        -- 2025.07.08 Philsu Park: Max_Stock_Qty 추가
		-- 6) Max_Stock_Qty : PRECEDE_QTY Lookup 정보 기반 등록.
        -- 2025.11.04 Minyong Lee : Lookup -> UI 전환 (stock_qty)
        -- 2025.11.25 Minyong Lee : 
        --      - ROUTING JOIN이 있다면 그대로 유지
        --      - ITEM_SITE JOIN이 없다면 INNER JOIN 추가
        --      - Sales Site Incoterms 구분 없이 STAGE 기준 JOIN
        --      - ITEM_SITE의 BUFFER_ID 그대로 사용
		----------------------------------------------------------
        --INSERT INTO SCP_OPT_ENG_SAFETY_STOCK_SN
        --            (
        --                PLAN_ID
        --                , BUFFER_ID
        --                , [TYPE]
        --                , [START_DATE]
        --                , END_DATE
        --                , [VALUE]
        --                , CALENDAR_LEVEL
        --            )
        --    SELECT	 @V_PLAN_ID										AS PLAN_ID
        --            ,LV.SEGMENT3+'::'+LV.SEGMENT4+'::'+LV.SEGMENT5+IIF(SIS.ATTRIBUTE1 IS NULL ,'','@'+SIS.ATTRIBUTE1)+IIF(SIS.ATTRIBUTE2 IS NULL ,'','@'+SIS.ATTRIBUTE2) AS BUFFER_ID
        --            ,'max_stock_qty'								AS [TYPE]
        --            ,CASE WHEN LV.ATTRIBUTE1 <= @V_PLAN_START_YYYYMMDD THEN @V_PLAN_START_YYYYMMDD
        --                  ELSE LV.ATTRIBUTE1
        --              END                                           AS [START_DATE]
        --            ,CASE WHEN IIF(LV.ATTRIBUTE2<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE2),112),LV.ATTRIBUTE2) >= @V_PLAN_END_YYYYMMDD THEN @V_PLAN_END_YYYYMMDD
        --                  ELSE IIF(LV.ATTRIBUTE2<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE2),112),LV.ATTRIBUTE2)
        --              END                                           AS END_DATE
        --            ,LV.ATTRIBUTE3									AS [VALUE]
        --            ,'L1'                                           AS CALENDAR_LEVEL
        --    FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
        --    LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
        --        ON  LV.SEGMENT3 = SIS.SITE_ID
        --        AND LV.SEGMENT4 = SIS.ITEM_ID
        --        AND SIS.PLAN_ID = @V_PLAN_ID
        --        AND LV.SEGMENT5 = SIS.ATTRIBUTE3
        --    WHERE   LV.LOOKUP_TYPE	= 'SCP_OPT_ENG_CONST_PRECEDE_QTY'
        --    AND     LV.VALID_YN		= 'Y'
        --    AND     LV.SEGMENT2		= @V_DIVISION_ID
        --    AND     GREATEST(LV.ATTRIBUTE1, @V_PLAN_START_YYYYMMDD) >= @V_PLAN_START_YYYYMMDD
        --    AND     LEAST(LV.ATTRIBUTE2, @V_PLAN_END_YYYYMMDD)      <= @V_PLAN_END_YYYYMMDD

            INSERT INTO SCP_OPT_ENG_SAFETY_STOCK_SN
                    (
                        PLAN_ID
                        , BUFFER_ID
                        , [TYPE]
                        , [START_DATE]
                        , END_DATE
                        , [VALUE]
                        , CALENDAR_LEVEL
                    )
            SELECT  @V_PLAN_ID										AS PLAN_ID
                  , SIS.BUFFER_ID                                   AS BUFFER_ID
                  , 'max_stock_qty'								    AS [TYPE]
                  , CASE
                        WHEN SQ.FROM_YYYYMMDD <= @V_PLAN_START_YYYYMMDD THEN @V_PLAN_START_YYYYMMDD
                        ELSE SQ.FROM_YYYYMMDD
                    END                                             AS [START_DATE]
                  , CASE
                        WHEN IIF(SQ.TO_YYYYMMDD<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,SQ.TO_YYYYMMDD),112),SQ.TO_YYYYMMDD) >= @V_PLAN_END_YYYYMMDD THEN @V_PLAN_END_YYYYMMDD
                        ELSE IIF(SQ.TO_YYYYMMDD<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,SQ.TO_YYYYMMDD),112),SQ.TO_YYYYMMDD)
                    END                                             AS END_DATE
                  , SQ.APL_QTY									    AS [VALUE]
                  , 'L1'                                            AS CALENDAR_LEVEL
            FROM    SCP_OPMZ_SAFETY_STOCK SQ WITH(NOLOCK)
                INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
                    ON  SIS.PLAN_ID     = @V_PLAN_ID
                    AND SQ.SCM_SITE_ID  = SIS.SITE_ID
                    AND SQ.ITEM_ID      = SIS.ITEM_ID
                    AND SQ.STAGE        = SIS.ATTRIBUTE3
                LEFT OUTER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                    ON SQ.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
            WHERE   1=1
            AND     SQ.VALUE_TYPE   = 'MAX'
            AND     SQ.VALID_YN		= 'Y'
            AND     SQ.TO_YYYYMMDD  >= @V_PLAN_START_YYYYMMDD
            AND     SQ.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
            AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID

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
