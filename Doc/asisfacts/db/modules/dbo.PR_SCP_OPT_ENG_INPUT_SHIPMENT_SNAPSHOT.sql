

--EXEC PR_SCP_OPT_ENG_INPUT_SHIPMENT_SNAPSHOT 'PLAN_ID_001'
/*==============================================================================================================================
 * PROJECT                  :   LGES2025-002845 - Module/Pack Biz, 전극계획 최적화 엔진 적용을 위한 ODS 개발
 * STORED PROCEDURE NAME    :   PR_SCP_OPT_ENG_INPUT_SHIPMENT_SNAPSHOT
 * DESCRIPTION              :   최적화 엔진 Input용 출하계획 Snapshot 생성.
                                수행 시점 기준 동 주차내 최신 출하계획 SEMI 정보를 가져와 SNAPSHOT 으로 생성한다.
                                중복 수행 시, 동일 주차 기 생성된 스냅샷 정보는 삭제하고 다시 생성한다.
 * PROGRAM HISTORY
 *==============================================================================================================================
 *  DATE        IN CHARGE			DESCRIPTION
 *==============================================================================================================================
 *  2025.05.07  Philsu Park         Initial Release.
 *  2025.09.03  Philsu Park         Plan_Group을 Parameter로 추가 입력받아 해당하는 Operation_Id 단위로 삭제 후 스냅샷 생성.
==============================================================================================================================*/
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_INPUT_SHIPMENT_SNAPSHOT]
     @P_PLAN_ID             NVARCHAR(50)
    ,@P_DIVISION_ID         NVARCHAR(20)
    -- ,@V_GROUP_ID            NVARCHAR(20)
    ,@P_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@P_PLAN_GR_ID          NVARCHAR(50)
    -- ,@P_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    /*------------------------------------------------------------------------  
    --
    
    --
	------------------------------------------------------------------------*/
    
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- Set Param for Log
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_INPUT_SHIPMENT_SNAPSHOT';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE       DATETIME;
    DECLARE @V_OPERATION_ID      NVARCHAR(50);
    
    ------------------------------------------------------------------------
    -- Plan Version 찾아서 담는 변수.
    ------------------------------------------------------------------------
    DECLARE @V_SCP_PLAN_DATE    NVARCHAR(8);
    DECLARE @V_SCP_PLAN_TYPE    NVARCHAR(20);
    DECLARE @V_SCP_PLAN_SEQ     INT;

    -- Find Variables for Latest Shipment Plan Semi.
    SELECT   @V_SCP_PLAN_DATE   = A.PLAN_START_YYYYMMDD
            ,@V_SCP_PLAN_TYPE   = A.PLAN_TYPE
            ,@V_SCP_PLAN_SEQ    = A.PLAN_SEQ
    FROM  (SELECT TOP 1 DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
            FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
            WHERE  DIVISION_ID          = @P_DIVISION_ID
            AND    PLAN_START_YYYYMMDD  = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(@P_PLAN_START_YYYYMMDD, 'MON')), 112) -- 해당 주 월요일 YYYYMMDD
            ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC
            ) A

    ------------------------------------------------------------------------ 
    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
	------------------------------------------------------------------------
	-- EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

    SELECT  @V_OPERATION_ID = MAX(T.OPERATION_ID)
    FROM    SCP_OPMZ_PLAN_GR_LINE_M T WITH(NOLOCK)
    INNER JOIN SCP_OPMZ_PLAN_GR_M GR WITH(NOLOCK)
        ON  T.OPMZ_PLAN_GR_ID       = GR.OPMZ_PLAN_GR_ID
    WHERE   1=1
    AND     GR.DIVISION_ID          = @P_DIVISION_ID
    AND     GR.OPMZ_PLAN_GR_ID      = @P_PLAN_GR_ID
    AND     T.VALID_YN              = 'Y'
    AND     T.OPERATION_ID       LIKE 'A%'
    ;
    -- PRINT ('STEP00 Shipment Semi Op.: ')
    -- PRINT (@V_OPERATION_ID);

    ------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
	--BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------  
	BEGIN TRY
    ------------------------------------------------------------------------
    -- 1. Delete same DIVISION_ID, PLAN_START_YYYYMMDD data from snapshot table.
    -- 2. Insert snapshot.
    ------------------------------------------------------------------------
        --Delete.
        BEGIN
            DELETE  A
            FROM    SCP_OPT_ENG_SHIPMENT_PLAN_SEMI_SNAPSHOT_SN A
            INNER JOIN ( 
                        SELECT  DIVISION_ID, ITEM_ID, MAX(SCP_FLOW_ID) AS OPERATION_ID
                        FROM    SCM_ITEM_M_SN WITH(NOLOCK)
                        WHERE   SCP_FLOW_ID IS NOT NULL
                        GROUP BY DIVISION_ID, ITEM_ID
                        ) ITM
                ON  A.DIVISION_ID   = ITM.DIVISION_ID
                AND A.ITEM_ID       = ITM.ITEM_ID
            WHERE   A.DIVISION_ID           = @P_DIVISION_ID
            AND     A.PLAN_START_YYYYMMDD   = @V_SCP_PLAN_DATE
            AND     ITM.OPERATION_ID        = @V_OPERATION_ID
        END
        
        --Insert snapshot.
        BEGIN 
            INSERT INTO SCP_OPT_ENG_SHIPMENT_PLAN_SEMI_SNAPSHOT_SN
                ( DIVISION_ID
                , PLAN_START_YYYYMMDD
                , PLAN_TYPE
                , SEQ
                , OPERATION_GROUP
                , ITEM_ID
                , FROM_SITE
                , BOD_ID
                , MEASURE
                , YYYYMMDD
                , TO_SITE
                , QTY
                , ORIGIN_FROM_DIVISION_ID
                , ORIGIN_TO_DIVISION_ID
                , ELECTRODE_TYPE
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE
                , ATTRIBUTE1
                , ATTRIBUTE2
                , ATTRIBUTE3
                , ATTRIBUTE4
                , ATTRIBUTE5
                , ATTRIBUTE6
                , ATTRIBUTE7
                , ATTRIBUTE8
                , ATTRIBUTE9
                , ATTRIBUTE10)
            SELECT A.DIVISION_ID
                , A.PLAN_START_YYYYMMDD
                , A.PLAN_TYPE
                , A.SEQ
                , A.OPERATION_GROUP
                , A.ITEM_ID
                , A.FROM_SITE
                , A.BOD_ID
                , A.MEASURE
                , A.YYYYMMDD
                , A.TO_SITE
                , A.QTY
                , A.ORIGIN_FROM_DIVISION_ID
                , A.ORIGIN_TO_DIVISION_ID
                , A.ELECTRODE_TYPE
                , 'SCP_OPT_ENG'
                , CURRENT_TIMESTAMP
                , A.LAST_UPDATED_BY
                , A.LAST_UPDATE_DATE
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
            FROM SCP_ANL_SHIPMENT_PLAN_SEMI A WITH(NOLOCK)
            ------------------------------------------------------------------------
            INNER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID
                        FROM   SCM_MST_SITE WITH(NOLOCK)
                        WHERE  DIVISION_ID     = @P_DIVISION_ID
                        AND    SITE_TYPE       = 'PLANT'
                        AND    OPERATION_GROUP = 'A' -- 소형은 Cell 출하를 CEll Biz 용 Demand 만 처리
                        AND    VALID_YN        = 'Y'
                        ) B
                ON  A.FROM_SITE     = B.SCM_SITE_ID
                AND A.DIVISION_ID   = B.DIVISION_ID
            ------------------------------------------------------------------------
            INNER JOIN SCP_MST_BOD_N_V BOD WITH (NOLOCK)
                ON  A.DIVISION_ID   = BOD.DIVISION_ID
                AND A.BOD_ID        = BOD.BOD_ID
            INNER JOIN ( 
                        SELECT  DIVISION_ID, ITEM_ID, MAX(SCP_FLOW_ID) AS OPERATION_ID
                        FROM    SCM_ITEM_M_SN WITH(NOLOCK)
                        WHERE   SCP_FLOW_ID IS NOT NULL
                        GROUP BY DIVISION_ID, ITEM_ID
                        ) ITM
                ON  A.DIVISION_ID   = ITM.DIVISION_ID
                AND A.ITEM_ID       = ITM.ITEM_ID
            WHERE   A.DIVISION_ID           = @P_DIVISION_ID
            AND     A.PLAN_START_YYYYMMDD   = @V_SCP_PLAN_DATE
            AND     A.PLAN_TYPE             = @V_SCP_PLAN_TYPE
            AND     A.SEQ                   = @V_SCP_PLAN_SEQ
            AND     A.MEASURE               = 'SHIP_PLAN_AMEND'
            AND     A.QTY                   > 0
            AND     A.YYYYMMDD             >= @V_SCP_PLAN_DATE
            AND     ITM.OPERATION_ID        = @V_OPERATION_ID
            -- AND     A.YYYYMMDD              < @P_PLAN_END_YYYYMMDD
        END;
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
        -- EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'ERROR',NULL,@V_MESSAGE_TEXT,NULL,@V_PLAN_ID
        ------------------------------------------------------------------------
        SELECT @V_DETAIL_DATE = GETDATE()
        ------------------------------------------------------------------------
        -- EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,@V_DETAIL_DATE,NULL,@V_MESSAGE_TEXT,'ERROR'
        ------------------------------------------------------------------------
        RAISERROR(@V_PROGRAM_NAME, 16,1)
        ------------------------------------------------------------------------
    END CATCH
	------------------------------------------------------------------------

	------------------------------------------------------------------------
    -- 종료 LOG
    ------------------------------------------------------------------------
    /* IF @V_MESSAGE_TEXT IS NULL 
    ------------------------------------------------------------------------
    BEGIN
	    EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'END',NULL,NULL,NULL,@V_PLAN_ID
        EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL
    END */
    ------------------------------------------------------------------------
  END;
