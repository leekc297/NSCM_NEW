/*----------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                         
*----------------------------------------------------------------------------------------------
* EVERY CALENDAR는 구간 내 VALUE가 매일 적용되고 HRIZON은 구간 내 총량으로 적용 됨. 
****************************************************************************************************/
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_INPUT_HORIZON_CAL_BATCH]
     @P_PLAN_ID     NVARCHAR(50)
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_INPUT_HORIZON_CAL_BATCH';
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
                    AND     1=1 /* 배치는 계획그룹 필터 미적용(사업부 전체 대상) */
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
                    AND     1=1 /* 배치는 계획그룹 필터 미적용(사업부 전체 대상) */
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
                    AND     1=1 /* 배치는 계획그룹 필터 미적용(사업부 전체 대상) */
                    AND     GRP.FROM_DATE        < @V_PLAN_END_YYYYMMDD
                    AND     GRP.TO_DATE          >= @V_PLAN_START_YYYYMMDD
                    ) CT
        ;
 
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
