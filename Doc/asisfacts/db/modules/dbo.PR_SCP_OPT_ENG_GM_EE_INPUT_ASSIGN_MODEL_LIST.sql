
/*----------------------------------------------------------------------------------------------
* Date          In Charge       Description                                                         
*----------------------------------------------------------------------------------------------
* 2025.07.22    Philsu Park     Initial Release
****************************************************************************************************/
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_EE_INPUT_ASSIGN_MODEL_LIST]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.05.28 Philsu Park Initial Release.
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
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_EE_INPUT_ASSIGN_MODEL_LIST';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_PLAN_START_YYYYMM   NVARCHAR(6) = LEFT(@V_PLAN_START_YYYYMMDD, 6);
    DECLARE @V_PLAN_END_YYYYMM     NVARCHAR(6) = LEFT(@V_PLAN_END_YYYYMMDD, 6);
    
    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
	------------------------------------------------------------------------
	EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

    ------------------------------------------------------------------------  	
	-- Set Param For Find latest demand version.
	------------------------------------------------------------------------  
    /* SELECT  @V_MAX_TUESDAY = MAX(BASIS_YYYYMMDD)
    FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK) 
    WHERE   BASIS_YYYYMMDD <= CONVERT(NVARCHAR(8),GETDATE(),112)
    AND     DAYOFWEEK       = 'TUE'
    ; */

    /* SELECT @D_PLAN_NAME          = CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD) ;
    SELECT @V_DEMAND_CUTOFF_DAY  = ISNULL(MAX(P.CUTOFF_YYYYMMDD),@V_MAX_TUESDAY)
                                    FROM   DM_PLN_NET_DEMAND P WITH(NOLOCK)
                                    WHERE  P.DIVISION_ID      = @V_DIVISION_ID 
                                    AND    P.CUTOFF_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -3, @D_PLAN_NAME), 112) -- 월요일 기준 최근 3일 이내									
                                    AND    P.CUTOFF_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, +6, @D_PLAN_NAME), 112) -- 해당 주차 일요일 이전
    ------------------------------------------------------------------------
    SELECT  @V_DM_MAX_VERSION = MAX(P.VERSION_NO)
    FROM    DM_PLN_NET_DEMAND P WITH(NOLOCK)
    WHERE   P.DIVISION_ID      = @V_DIVISION_ID
    AND     P.CUTOFF_YYYYMMDD  = @V_DEMAND_CUTOFF_DAY
    ; */

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

        IF OBJECT_ID('TEMPDB..#MODEL_LIST') IS NOT NULL
            BEGIN 
                DROP TABLE  #MODEL_LIST;
            END;

        ------------------------------------------------------------------------
        -- Origin Division
        ------------------------------------------------------------------------
        SELECT  DIVISION_ID
		INTO    #DIVISION
		FROM    SCM_MST_DIVISION WITH(NOLOCK)
		WHERE  VALID_YN     = 'Y'
		AND    ATTRIBUTE3  <> 'EE'
		AND    ATTRIBUTE4   = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID) -- 전극 Division 변수
		;

		


        ------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------
		-- 1. STAGE: STK
        -- STK는 룩업 ITEM 정보 기반으로 1레벨 하위 BOM 에서 찾아옴.
        ------------------------------------------------------------------------
        /* SELECT    @V_PLAN_ID            AS PLAN_ID
                , ST.SCM_SITE_ID        AS SCM_SITE_ID
                , BOM.CHILD_ITEM_ID     AS ITEM_ID
                , CONCAT('STK', '@', LK.LINE_SIDE) AS ITEM_STAGE
                , 'STK'                 AS ORG_STAGE
                , BOM.DIVISION_ID       AS DIVISION_ID
                , BOM.PLANT_ID          AS PLANT_ID
        INTO    #STK_MODEL_LIST
        FROM    SCM_MST_BOM_ENG_SN BOM WITH(NOLOCK)
        INNER JOIN SCM_ITEM_M_SN SIM
            ON  1=1
            AND BOM.COMPANY_ID  = SIM.COMPANY_ID
            AND BOM.DIVISION_ID = SIM.DIVISION_ID
            AND BOM.SITE_ID 	= SIM.SITE_ID
            AND BOM.CHILD_ITEM_ID = SIM.ITEM_ID
            AND SIM.ACTIVE_FLAG = 'Y'
        INNER JOIN SCM_MST_SITE ST WITH(NOLOCK)
            ON  BOM.DIVISION_ID         = ST.DIVISION_ID
            AND BOM.PLANT_ID            = ST.PLANT_ID
            AND BOM.SITE_ID             = ST.SITE_ID
            AND ST.OPERATION_GROUP      = 'A'  -- 조립만.
            AND ST.VALID_YN             = 'Y'
        INNER JOIN (SELECT    SEGMENT3 AS SCM_SITE_ID
                            , SEGMENT4 AS ITEM_ID
                            , SEGMENT5 AS LINE_SIDE
                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                    WHERE   LOOKUP_TYPE  = 'SCP_OPT_ENG_GM_ITEM'
                    AND     VALID_YN     = 'Y'
                    AND     SEGMENT1     = @V_DIVISION_ID
                    AND     SEGMENT2     = @V_GROUP_ID
                    ) LK
            ON  ST.SCM_SITE_ID      = LK.SCM_SITE_ID
            AND BOM.PARENT_ITEM_ID  = LK.ITEM_ID
        LEFT OUTER JOIN SCM_MST_ALTER_BOM_V B WITH(NOLOCK)
            ON  BOM.DIVISION_ID    = B.DIVISION_ID
            AND BOM.SITE_ID        = B.SITE_ID
            AND BOM.PLANT_ID       = B.PLANT_ID
            AND BOM.PARENT_ITEM_ID = B.PARENT_ITEM_ID
            AND BOM.CHILD_ITEM_ID  = B.CHILD_ITEM_ID
        WHERE   BOM.DIVISION_ID     = @V_DIVISION_ID
        AND     BOM.EFF_END_DATE   >= @V_PLAN_START_YYYYMMDD
        AND     SIM.FLOW_ID         = 'A8000'  -- STK
        AND     BOM.CHILD_QTY       >  0
        AND     BOM.ACTIVE_FLAG     = 'Y'
        AND    (BOM.ALT_ID IS NULL 
                OR (BOM.ALT_ID IS NOT NULL AND B.SCP_PLAN_YN IS NULL AND ISNULL(BOM.ALT_PRIORITY, 1) = 1)
                OR (BOM.ALT_ID IS NOT NULL AND B.SCP_PLAN_YN IS NOT NULL AND B.SCP_PLAN_YN = 'Y'))
        ; */
        ------------------------------------------------------------------------
		-- 2. STAGE: ASSY
        -- ASSY는 FLOW_ID 기준으로 LINE_ASSIGN에서 추출.
        ------------------------------------------------------------------------
        --1. GROUP에 해당하는 전극 ITEM 추출.
        WITH PLAN_GROUP AS (
                    SELECT    GR.OPMZ_PLAN_GR_NAME  AS PLAN_GROUP_NAME
                            , T.OPMZ_PLAN_GR_ID     AS PLAN_GROUP_ID
                            , T.LINE_ID             AS LINE_ID
                            , T.OPERATION_ID        AS OPERATION_ID
                            , T.FACTORY_ID          AS FACTORY_ID
                            , T.PLANT_ID            AS PLANT_ID
                            , T.ITEM_ID             AS ITEM_ID
                    FROM    SCP_OPMZ_PLAN_GR_LINE_M T WITH(NOLOCK)
                    INNER JOIN SCP_OPMZ_PLAN_GR_M GR WITH(NOLOCK)
                        ON  T.OPMZ_PLAN_GR_ID       = GR.OPMZ_PLAN_GR_ID
                    WHERE   GR.OPMZ_PLAN_GR_NAME    = @V_GROUP_ID
                    AND     T.VALID_YN              = 'Y'
            )
        -- 위 정의된 라인 기준으로 Item List 추출.
        -- STAGE: ASSY, ASY_AGING 동일 기준으로 생성.
        SELECT    @V_PLAN_ID            AS PLAN_ID
                , ST.SCM_SITE_ID        AS SCM_SITE_ID
                , ILA.ITEM_ID           AS ITEM_ID
                , CASE WHEN ILA.OPERATION_ID = 'E2000' THEN 'COATING'   -- COATING
                       WHEN ILA.OPERATION_ID = 'A5000' THEN 'NND'       -- NOTCHING AND DRYING
                       WHEN ILA.OPERATION_ID = 'A7000' THEN 'TARGETBIZ'  -- LAMI, HALF LAMI
                  ELSE '-' END          AS STAGE
                , ILA.PLANT_ID          AS PLANT_ID
                , ILA.OPERATION_ID      AS OPERATION_ID
        INTO    #MODEL_LIST
        FROM    SCM_MST_ITEM_LINE_ASSIGN_SN ILA WITH(NOLOCK)
        INNER JOIN #DIVISION DIV
            ON  ILA.DIVISION_ID = DIV.DIVISION_ID
        INNER JOIN PLAN_GROUP GRP
            ON  ILA.LINE_ID         = GRP.LINE_ID
            AND ILA.OPERATION_ID    = GRP.OPERATION_ID
            AND ILA.FACTORY_ID      = GRP.FACTORY_ID
            AND ILA.PLANT_ID        = GRP.PLANT_ID
            AND ILA.ITEM_ID         = IIF(GRP.ITEM_ID='-', ILA.ITEM_ID, GRP.ITEM_ID)  -- ITEM 명시 안되어있으면 ASSIGN 전체.
        INNER  JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)
            ON  1=1
            AND ILA.COMPANY_ID  = SIM.COMPANY_ID
            AND ILA.DIVISION_ID = SIM.DIVISION_ID
            AND ILA.SITE_ID 	= SIM.SITE_ID
            AND ILA.ITEM_ID 	= SIM.ITEM_ID
            AND SIM.ACTIVE_FLAG = 'Y'
        LEFT OUTER JOIN SCM_MST_SITE ST WITH(NOLOCK)
            ON  ILA.DIVISION_ID         = ST.DIVISION_ID
            AND ILA.PLANT_ID            = ST.PLANT_ID
            AND ILA.SITE_ID             = ST.SITE_ID
            AND ST.OPERATION_GROUP     IN ('A', 'E')
            AND ST.VALID_YN             = 'Y'
            AND ST.OPERATION_GROUP      = SIM.SCP_OPERATION_GROUP -- added 2025-01-01 jongykim2
        WHERE   1=1
        AND     ILA.MONTH         BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
        AND     ILA.ACTIVE_FLAG         = 'Y'
        AND     ILA.PRIORITY           <> 9                       -- 신재욱 책임님 요청. 9순위 제외
        GROUP BY  ST.SCM_SITE_ID
                , ILA.ITEM_ID
                , ILA.OPERATION_ID
                , ILA.PLANT_ID
        ;
        
		-----------------------------------------------------
		-- 6. 최종 Model List INSERT : 중복 제외를 위해 UNION 적용
		-----------------------------------------------------
        INSERT INTO SCP_OPT_ENG_MODEL_LIST_N_SN
              (PLAN_ID
              ,SCM_SITE_ID
              ,ITEM_ID
              ,STAGE
              ,ATTRIBUTE1
              )
        -- STK Model
        SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, STAGE, OPERATION_ID
        FROM    #MODEL_LIST STK WITH(NOLOCK)
        
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
