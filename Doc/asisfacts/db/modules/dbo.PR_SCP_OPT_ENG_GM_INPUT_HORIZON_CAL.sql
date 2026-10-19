
/*----------------------------------------------------------------------------------------------
* Date          In Charge       Description                                                         
*----------------------------------------------------------------------------------------------
* 2025.07.07    Philsu Park     Initial Release
* EVERY CALENDAR는 구간 내 VALUE가 매일 적용되고 HRIZON은 구간 내 총량으로 적용 됨. 
****************************************************************************************************/
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_INPUT_HORIZON_CAL]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_INPUT_HORIZON_CAL';
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
        ------------------------------------------------------------------------
        -- PACKING EQUIPMENT CONSTRAINTS INSERT
        -- 2025.05.21 Philsu Park: Packing EQP 구조 변경에 따른 쿼리 수정.
        -- 2025.05.22 Philsu Park: TO Date는 룩업입력된 날짜 + 1일
        -- 2025.07.24 Philsu Park: Plan Horizon 내에 해당하는 PACKING EQP 정보만 추출.
        ------------------------------------------------------------------------
        WITH MODEL_GROUP AS (
                    --SELECT    SEGMENT2                                  AS DIVISION
                    --        , SEGMENT3                                  AS PLAN_GROUP
                    --        , SEGMENT5                                  AS MODEL_GROUP
                    --        , GREATEST(@V_PLAN_START_YYYYMMDD, MIN(ATTRIBUTE4)) AS FROM_DATE
                    --        , LEAST(@V_PLAN_END_YYYYMMDD, CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE, MAX(ATTRIBUTE5), 112)), 112)) AS TO_DATE
                    --        , MIN(CONVERT(NUMERIC(20,10), ATTRIBUTE6))  AS LOWER_QTY
                    --        , MAX(CONVERT(NUMERIC(20,10), ATTRIBUTE7))  AS UPPER_QTY
                    --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
                    --WHERE   D.LOOKUP_TYPE   = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
                    --AND     D.VALID_YN      = 'Y'  -- ***!!!Valid Flag는 나중에 살려야됨!!!***
                    --AND     D.SEGMENT2      = @V_DIVISION_ID
                    --AND     D.SEGMENT3      = @V_GROUP_ID
                    --GROUP BY SEGMENT2, SEGMENT3, SEGMENT5

                    -- 2025.11.24 Minyong Lee : Lookup -> UI 전환 (Packing Equipment)
                    SELECT    CS.DIVISION_ID                                 AS DIVISION
                            , PG.OPMZ_PLAN_GR_NAME                           AS PLAN_GROUP
                            , CS.MDL_GR_NM                                   AS MODEL_GROUP
                            , GREATEST(@V_PLAN_START_YYYYMMDD, MIN(CS.FROM_YYYYMMDD))                           AS FROM_DATE
                            , LEAST(@V_PLAN_END_YYYYMMDD, CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE, MAX(CS.TO_YYYYMMDD), 112)), 112)) AS TO_DATE
                            , MIN(CONVERT(NUMERIC(20,10), CS.SIPM_MIN_QYT))  AS LOWER_QTY
                            , MAX(CONVERT(NUMERIC(20,10), CS.SIPM_MAX_QTY))  AS UPPER_QTY
                    FROM    SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY CS WITH(NOLOCK)
                        LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                            ON  CS.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                            AND PG.VALID_YN = 'Y'
                    WHERE   1=1
                    AND     CS.VALID_YN          = 'Y'
                    AND     CS.DIVISION_ID       = @V_DIVISION_ID
                    AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                    GROUP BY CS.DIVISION_ID, PG.OPMZ_PLAN_GR_NAME, CS.MDL_GR_NM
                )
        INSERT INTO SCP_OPT_ENG_RESOURCE_HORIZON_CALENDAR_SN (
            PLAN_ID
            ,RESOURCE_ID
            ,TYPE
            ,START_DATE
            ,END_DATE
            ,VALUE
            )
            SELECT   @V_PLAN_ID         AS PLAN_ID
                    ,RESOURCE_ID        AS RESOURCE_ID
                    ,'lower_limit'      AS TYPE
                    ,FROM_DATE          AS START_DATE
                    ,TO_DATE            AS END_DATE
                    ,LOWER_QTY          AS VALUE
            FROM   (
                    -- MODEL_GROUP 단위로 만들어주면 됨.
                    --SELECT    DISTINCT 
                    --        D.SEGMENT2                                  AS DIVISION
                    --        , D.SEGMENT3                                  AS PLAN_GROUP
                    --        -- , D.SEGMENT4                                  AS MODEL
                    --        , D.SEGMENT5                                  AS MODEL_GROUP
                    --        , D.ATTRIBUTE1                                AS FROM_SITE
                    --        , D.ATTRIBUTE2                                AS STAGE
                    --        , D.ATTRIBUTE3                                AS TO_SITE
                    --        , GRP.FROM_DATE                               AS FROM_DATE
                    --        , GRP.TO_DATE                                 AS TO_DATE
                    --        , GRP.LOWER_QTY                               AS LOWER_QTY
                    --        , GRP.UPPER_QTY                               AS UPPER_QTY
                    --        , CONCAT(D.ATTRIBUTE1, '::', 'PACKING_EQUIPMENT_', D.SEGMENT5, '@', D.ATTRIBUTE2, '::', D.ATTRIBUTE3) AS RESOURCE_ID
                    --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
                    --INNER JOIN MODEL_GROUP GRP
                    --    ON  GRP.DIVISION    = D.SEGMENT2
                    --    AND GRP.PLAN_GROUP  = D.SEGMENT3
                    --    AND GRP.MODEL_GROUP = D.SEGMENT5
                    --WHERE   D.LOOKUP_TYPE   = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
                    --AND     D.VALID_YN      = 'Y'
                    --AND     D.SEGMENT2      = @V_DIVISION_ID
                    --AND     D.SEGMENT3      = @V_GROUP_ID
                    --AND     GRP.FROM_DATE   < @V_PLAN_END_YYYYMMDD
                    --AND     GRP.TO_DATE    >= @V_PLAN_START_YYYYMMDD

                    -- 2025.11.24 Minyong Lee : Lookup -> UI 전환 (Packing Equipment)
                    SELECT    DISTINCT 
                              CS.DIVISION_ID                        AS DIVISION
                            , PG.OPMZ_PLAN_GR_NAME                  AS PLAN_GROUP
                            --, CS.ITEM_ID                            AS MODEL
                            , CS.MDL_GR_NM                          AS MODEL_GROUP
                            , CS.FROM_STE_ID                        AS FROM_SITE
                            , CS.STAGE                              AS STAGE
                            , CS.TO_STE_ID                          AS TO_SITE
                            , GRP.FROM_DATE                         AS FROM_DATE
                            , GRP.TO_DATE                           AS TO_DATE
                            , GRP.LOWER_QTY                         AS LOWER_QTY
                            , GRP.UPPER_QTY                         AS UPPER_QTY
                            , CONCAT(CS.FROM_STE_ID, '::', 'PACKING_EQUIPMENT_', CS.MDL_GR_NM, '@', CS.STAGE, '::', CS.TO_STE_ID) AS RESOURCE_ID
                    FROM    SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY CS WITH(NOLOCK)
                        LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                            ON  CS.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                            AND PG.VALID_YN = 'Y'
                        INNER JOIN MODEL_GROUP GRP
                            ON  GRP.DIVISION    = CS.DIVISION_ID
                            AND GRP.PLAN_GROUP  = PG.OPMZ_PLAN_GR_NAME
                            AND GRP.MODEL_GROUP = CS.MDL_GR_NM
                    WHERE   1=1
                    AND     CS.VALID_YN          = 'Y'
                    AND     CS.DIVISION_ID       = @V_DIVISION_ID
                    AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                    AND     GRP.FROM_DATE        < @V_PLAN_END_YYYYMMDD
                    AND     GRP.TO_DATE          >= @V_PLAN_START_YYYYMMDD
                    ) CT
            UNION ALL
            SELECT   @V_PLAN_ID         AS PLAN_ID
                    ,RESOURCE_ID        AS RESOURCE_ID
                    ,'upper_limit'      AS TYPE
                    ,FROM_DATE          AS START_DATE
                    ,TO_DATE            AS END_DATE
                    ,UPPER_QTY          AS VALUE
            FROM (
                    -- MODEL_GROUP 단위로 만들어주면 됨.
                    --SELECT    DISTINCT 
                    --        D.SEGMENT2                                  AS DIVISION
                    --        , D.SEGMENT3                                  AS PLAN_GROUP
                    --        -- , D.SEGMENT4                                  AS MODEL
                    --        , D.SEGMENT5                                  AS MODEL_GROUP
                    --        , D.ATTRIBUTE1                                AS FROM_SITE
                    --        , D.ATTRIBUTE2                                AS STAGE
                    --        , D.ATTRIBUTE3                                AS TO_SITE
                    --        , GRP.FROM_DATE                               AS FROM_DATE
                    --        , GRP.TO_DATE                                 AS TO_DATE
                    --        , GRP.LOWER_QTY                               AS LOWER_QTY
                    --        , GRP.UPPER_QTY                               AS UPPER_QTY
                    --        , CONCAT(D.ATTRIBUTE1, '::', 'PACKING_EQUIPMENT_', D.SEGMENT5, '@', D.ATTRIBUTE2, '::', D.ATTRIBUTE3) AS RESOURCE_ID
                    --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
                    --INNER JOIN MODEL_GROUP GRP
                    --    ON  GRP.DIVISION    = D.SEGMENT2
                    --    AND GRP.PLAN_GROUP  = D.SEGMENT3
                    --    AND GRP.MODEL_GROUP = D.SEGMENT5
                    --WHERE   D.LOOKUP_TYPE   = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
                    --AND     D.VALID_YN      = 'Y'
                    --AND     D.SEGMENT2      = @V_DIVISION_ID
                    --AND     D.SEGMENT3      = @V_GROUP_ID
                    --AND     GRP.FROM_DATE   < @V_PLAN_END_YYYYMMDD
                    --AND     GRP.TO_DATE    >= @V_PLAN_START_YYYYMMDD

                    -- 2025.11.24 Minyong Lee : Lookup -> UI 전환 (Packing Equipment)
                    SELECT    DISTINCT 
                              CS.DIVISION_ID                        AS DIVISION
                            , PG.OPMZ_PLAN_GR_NAME                  AS PLAN_GROUP
                            --, CS.ITEM_ID                            AS MODEL
                            , CS.MDL_GR_NM                          AS MODEL_GROUP
                            , CS.FROM_STE_ID                        AS FROM_SITE
                            , CS.STAGE                              AS STAGE
                            , CS.TO_STE_ID                          AS TO_SITE
                            , GRP.FROM_DATE                         AS FROM_DATE
                            , GRP.TO_DATE                           AS TO_DATE
                            , GRP.LOWER_QTY                         AS LOWER_QTY
                            , GRP.UPPER_QTY                         AS UPPER_QTY
                            , CONCAT(CS.FROM_STE_ID, '::', 'PACKING_EQUIPMENT_', CS.MDL_GR_NM, '@', CS.STAGE, '::', CS.TO_STE_ID) AS RESOURCE_ID
                    FROM    SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY CS WITH(NOLOCK)
                        LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                            ON  CS.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                            AND PG.VALID_YN = 'Y'
                        INNER JOIN MODEL_GROUP GRP
                            ON  GRP.DIVISION    = CS.DIVISION_ID
                            AND GRP.PLAN_GROUP  = PG.OPMZ_PLAN_GR_NAME
                            AND GRP.MODEL_GROUP = CS.MDL_GR_NM
                    WHERE   1=1
                    AND     CS.VALID_YN          = 'Y'
                    AND     CS.DIVISION_ID       = @V_DIVISION_ID
                    AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                    AND     GRP.FROM_DATE        < @V_PLAN_END_YYYYMMDD
                    AND     GRP.TO_DATE          >= @V_PLAN_START_YYYYMMDD
                    ) CT
        ;
    /* 
    -- 2025.05.21 Philsu Park: 기존 구문 주석 처리.
    INSERT INTO SCP_OPT_ENG_RESOURCE_HORIZON_CALENDAR_SN (
           PLAN_ID
          ,RESOURCE_ID
          ,TYPE
          ,START_DATE
          ,END_DATE
          ,VALUE
          )
    SELECT @V_PLAN_ID                      AS PLAN_ID
      ,FROM_SITE_ID+'::'+RESOURCE_NAME AS RESOURCE_ID
      ,'lower_limit'                   AS TYPE
      ,MIN(BASIS_YYYYMMDD)             AS START_DATE
      ,MAX(BASIS_YYYYMMDD)             AS END_DATE
      ,LOWER_VALUE                     AS VALUE
    FROM(
            SELECT FROM_SITE_ID
        ,RESOURCE_NAME
        ,SUM(CONVERT(INT,LOWER_VALUE)) AS LOWER_VALUE
        ,SUM(CONVERT(INT,UPPER_VALUE)) AS UPPER_VALUE
        ,BASIS_YYYYMMDD
        ,LV_SEQ                        AS LV_SEQ
        FROM(
            SELECT SEGMENT4                      AS FROM_SITE_ID
                  ,'PACKING_EQUIPMENT@'+SEGMENT5+'::'+ATTRIBUTE1 AS RESOURCE_NAME
                  ,ATTRIBUTE4                    AS LOWER_VALUE
                  ,ATTRIBUTE5                    AS UPPER_VALUE
                  ,CAL.BASIS_YYYYMMDD            AS BASIS_YYYYMMDD
                  ,COUNT(*) OVER(PARTITION BY SEGMENT4, CAL.BASIS_YYYYMMDD) AS COUNT_VAL
                  ,LV.SEGMENT1                   AS LV_SEQ
            FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                ON CAL.BASIS_YYYYMMDD BETWEEN LV.ATTRIBUTE2 AND CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE3),112)
            WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
            AND    VALID_YN    = 'Y'
            AND    SEGMENT2    = @V_DIVISION_ID
            ) PE
            GROUP BY FROM_SITE_ID, RESOURCE_NAME,  BASIS_YYYYMMDD, COUNT_VAL, LV_SEQ
                    ) CT
    GROUP BY FROM_SITE_ID, RESOURCE_NAME, LOWER_VALUE, UPPER_VALUE, LV_SEQ
    UNION ALL
    SELECT @V_PLAN_ID                      AS PLAN_ID 
          ,FROM_SITE_ID+'::'+RESOURCE_NAME AS RESOURCE_ID
          ,'upper_limit'                   AS TYPE
          ,MIN(BASIS_YYYYMMDD)             AS START_DATE
          ,MAX(BASIS_YYYYMMDD)             AS END_DATE
          ,UPPER_VALUE                     AS VALUE
    FROM(
        SELECT FROM_SITE_ID
        ,RESOURCE_NAME
        ,SUM(CONVERT(INT,LOWER_VALUE)) AS LOWER_VALUE
        ,SUM(CONVERT(INT,UPPER_VALUE)) AS UPPER_VALUE
        ,BASIS_YYYYMMDD
        ,LV_SEQ                        AS LV_SEQ
        FROM(
            SELECT SEGMENT4                      AS FROM_SITE_ID
                  ,'PACKING_EQUIPMENT@'+SEGMENT5+'::'+ATTRIBUTE1 AS RESOURCE_NAME
                  ,ATTRIBUTE4                    AS LOWER_VALUE
                  ,ATTRIBUTE5                    AS UPPER_VALUE
                  ,CAL.BASIS_YYYYMMDD            AS BASIS_YYYYMMDD
                  ,COUNT(*) OVER(PARTITION BY SEGMENT4, CAL.BASIS_YYYYMMDD) AS COUNT_VAL
                  ,LV.SEGMENT1                   AS LV_SEQ
            FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                ON CAL.BASIS_YYYYMMDD BETWEEN LV.ATTRIBUTE2 AND CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE3),112)
            WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
            AND    VALID_YN    = 'Y'
            AND    SEGMENT2    = @V_DIVISION_ID
            ) PE
            GROUP BY FROM_SITE_ID, RESOURCE_NAME,  BASIS_YYYYMMDD, COUNT_VAL, LV_SEQ
        ) CT
    GROUP BY FROM_SITE_ID, RESOURCE_NAME, LOWER_VALUE, UPPER_VALUE, LV_SEQ 
    */
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
