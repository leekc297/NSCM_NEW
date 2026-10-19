
/*----------------------------------------------------------------------------------------------
* Date        	In Charge    	Description                                                         
*----------------------------------------------------------------------------------------------
* EVERY CALENDAR는 구간 내 VALUE가 매일 적용되고 HRIZON은 구간 내 총량으로 적용 됨. 
* 2025.08.18 	Philsu Park 	PACKING EQP Type 구분 추가
****************************************************************************************************/
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_EE_INPUT_HORIZON_CAL]
     @P_PLAN_ID     NVARCHAR(50)
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_EE_INPUT_HORIZON_CAL';
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
		-- PACKING EQUIPMENT CONSTRAINTS INSERT
        -- 2025.12.01 Minyong Lee : 5.20부 변경된 로직으로 주석처리
        --                          전극은 B타입만 사용 (EVERY_CAL)
		------------------------------------------------------------------------
		--INSERT INTO SCP_OPT_ENG_RESOURCE_HORIZON_CALENDAR_SN (
		--	   PLAN_ID
		--	  ,RESOURCE_ID
		--	  ,TYPE
		--	  ,START_DATE
		--	  ,END_DATE
		--	  ,VALUE
		--	  )
		--SELECT @V_PLAN_ID                      AS PLAN_ID
		--  ,FROM_SITE_ID+'::'+RESOURCE_NAME AS RESOURCE_ID
		--  ,'lower_limit'                   AS TYPE
		--  ,MIN(BASIS_YYYYMMDD)             AS START_DATE
		--  ,MAX(BASIS_YYYYMMDD)             AS END_DATE
		--  ,LOWER_VALUE                     AS VALUE
		--FROM(
		--	SELECT FROM_SITE_ID
		--		,RESOURCE_NAME
		--		,SUM(CONVERT(INT,LOWER_VALUE)) AS LOWER_VALUE
		--		,SUM(CONVERT(INT,UPPER_VALUE)) AS UPPER_VALUE
		--		,BASIS_YYYYMMDD
		--		,LV_SEQ                        AS LV_SEQ
		--	FROM(
		--		SELECT SEGMENT4                      AS FROM_SITE_ID
		--			  ,'PACKING_EQUIPMENT@'+SEGMENT5 AS RESOURCE_NAME
		--			  ,ATTRIBUTE4                    AS LOWER_VALUE
		--			  ,ATTRIBUTE5                    AS UPPER_VALUE
		--			  ,CAL.BASIS_YYYYMMDD            AS BASIS_YYYYMMDD
		--			  ,COUNT(*) OVER(PARTITION BY SEGMENT4, CAL.BASIS_YYYYMMDD) AS COUNT_VAL
		--			  ,LV.SEGMENT1                   AS LV_SEQ
		--		FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
		--			INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
		--			ON CAL.BASIS_YYYYMMDD BETWEEN LV.ATTRIBUTE2 AND CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE3),112)
		--		WHERE  LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
		--		AND    VALID_YN     = 'Y'
		--		AND    SEGMENT2     = @V_DIVISION_ID -- 전극 Division 변수
  --              AND    ATTRIBUTE8   = 'A'
		--		) PE
		--		GROUP BY FROM_SITE_ID, RESOURCE_NAME,  BASIS_YYYYMMDD, COUNT_VAL, LV_SEQ
		--				) CT
		--GROUP BY FROM_SITE_ID, RESOURCE_NAME, LOWER_VALUE, UPPER_VALUE, LV_SEQ
		--UNION ALL
		--SELECT @V_PLAN_ID                      AS PLAN_ID 
		--	  ,FROM_SITE_ID+'::'+RESOURCE_NAME AS RESOURCE_ID
		--	  ,'upper_limit'                   AS TYPE
		--	  ,MIN(BASIS_YYYYMMDD)             AS START_DATE
		--	  ,MAX(BASIS_YYYYMMDD)             AS END_DATE
		--	  ,UPPER_VALUE                     AS VALUE
		--FROM(
		--	SELECT FROM_SITE_ID
		--	,RESOURCE_NAME
		--	,SUM(CONVERT(INT,LOWER_VALUE)) AS LOWER_VALUE
		--	,SUM(CONVERT(INT,UPPER_VALUE)) AS UPPER_VALUE
		--	,BASIS_YYYYMMDD
		--	,LV_SEQ                        AS LV_SEQ
		--	FROM(
		--		SELECT SEGMENT4                      AS FROM_SITE_ID
		--			  ,'PACKING_EQUIPMENT@'+SEGMENT5 AS RESOURCE_NAME
		--			  ,ATTRIBUTE4                    AS LOWER_VALUE
		--			  ,ATTRIBUTE5                    AS UPPER_VALUE
		--			  ,CAL.BASIS_YYYYMMDD            AS BASIS_YYYYMMDD
		--			  ,COUNT(*) OVER(PARTITION BY SEGMENT4, CAL.BASIS_YYYYMMDD) AS COUNT_VAL
		--			  ,LV.SEGMENT1                   AS LV_SEQ
		--		FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
		--			INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
		--			ON CAL.BASIS_YYYYMMDD BETWEEN LV.ATTRIBUTE2 AND CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE3),112)
		--		WHERE  LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
		--		AND    VALID_YN     = 'Y'
		--		AND    SEGMENT2     = @V_DIVISION_ID -- 전극 Division 변수
  --              AND    ATTRIBUTE8   = 'A'
		--		) PE
		--		GROUP BY FROM_SITE_ID, RESOURCE_NAME,  BASIS_YYYYMMDD, COUNT_VAL, LV_SEQ
		--	) CT
		--GROUP BY FROM_SITE_ID, RESOURCE_NAME, LOWER_VALUE, UPPER_VALUE, LV_SEQ
		------------------------------------------------------------------------
		-- CAPA ALLOCATION CONSTRAINTS
		------------------------------------------------------------------------
        --UNION ALL
        --SELECT @V_PLAN_ID                     AS PLAN_ID
        --      ,CA.SITE_ID+'::'+CA.CNG_LINE_ID AS RESOURCE_ID
        --      ,'upper_limit'                  AS TYPE
        --      ,CA.EFF_START_DATE              AS START_DATE
        --      ,CA.EFF_END_DATE                AS END_DATE
        --      ,CASE WHEN CA.DIVISION_ID = '81' THEN 86400 * DATEDIFF(DAY,EFF_START_DATE,EFF_END_DATE) * CONVERT(FLOAT,CA.AUTO_RATIO)
        --            WHEN CA.DIVISION_ID = '82' THEN 86400 * DATEDIFF(DAY,EFF_START_DATE,EFF_END_DATE) * CONVERT(FLOAT,CA.ESS_RATIO)
        --       END AS VALUE
        --FROM(
        --    SELECT AL.SEGMENT3   AS SITE_ID
        --          ,AL.SEGMENT4   AS LINE_ID
        --          ,IIF(ALI.SEGMENT5 = '81',AL.SEGMENT4+'@Auto',AL.SEGMENT4+'@ESS') AS CNG_LINE_ID
        --          ,ALI.SEGMENT4  AS ITEM_ID
        --          ,ALI.SEGMENT5  AS DIVISION_ID
        --          ,AL.ATTRIBUTE1 AS AUTO_RATIO
        --          ,AL.ATTRIBUTE2 AS ESS_RATIO
        --          ,CASE WHEN AL.ATTRIBUTE3 >= @V_PLAN_START_YYYYMMDD THEN AL.ATTRIBUTE3 ELSE @V_PLAN_START_YYYYMMDD END EFF_START_DATE
        --          ,CASE WHEN AL.ATTRIBUTE4 <  @V_PLAN_END_YYYYMMDD   THEN CONVERT(NVARCHAR(8),DATEADD(DAY,1,AL.ATTRIBUTE4),112) ELSE @V_PLAN_END_YYYYMMDD END AS EFF_END_DATE
        --    FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL AL WITH(NOLOCK)
        --        INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL ALI WITH(NOLOCK)
        --            ON  AL.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CAPA_ALLOCATION'
        --            AND ALI.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CAPA_ALLOCATION_ITEM'
        --            AND AL.SEGMENT3 = ALI.SEGMENT2
        --            AND AL.SEGMENT4 = ALI.SEGMENT3
        --            AND AL.VALID_YN  = 'Y'
        --            AND ALI.VALID_YN = 'Y'
        --    ) CA
        --    INNER JOIN SCP_OPT_ENG_RESOURCE_SN RS WITH(NOLOCK)
        --        ON  CA.LINE_ID      = RS.RESOURCE_NAME
        --        AND CA.SITE_ID      = RS.SITE_ID
        --        AND RS.RESOURCE_TYPE = 'LINE'
        --        AND RS.PLAN_ID       = @V_PLAN_ID
        --GROUP BY CA.SITE_ID,CA.LINE_ID,CA.CNG_LINE_ID,CA.DIVISION_ID,CA.AUTO_RATIO,CA.ESS_RATIO,CA.EFF_START_DATE,CA.EFF_END_DATE

        --20251014/T.H.KIM/주말가동 최소화 B 타입 적용
        INSERT INTO SCP_OPT_ENG_RESOURCE_HORIZON_CALENDAR_SN (PLAN_ID
                                                             ,RESOURCE_ID
                                                             ,TYPE
                                                             ,START_DATE
                                                             ,END_DATE
                                                             ,VALUE
                                                             ,ATTRIBUTE1
                                                             ,ATTRIBUTE2
        )
        SELECT  @V_PLAN_ID                                                 AS PLAN_ID
               ,SEGMENT3+'::'+SEGMENT4                                     AS RESOURCE_ID
              ,'upper_limit'                                               AS TYPE
               ,CAL.BASIS_YYYYMMDD                                         AS START_DATE
               ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CAL.BASIS_YYYYMMDD),112) AS END_DATE
               ,SEGMENT6                                                   AS DAILY_VALUE
               ,SEGMENT3                                                   AS SCM_SITE_ID
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
        AND     LU.SEGMENT7    = 'B'
        AND     CAL.DAYOFWEEK IN('SAT','SUN')
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
