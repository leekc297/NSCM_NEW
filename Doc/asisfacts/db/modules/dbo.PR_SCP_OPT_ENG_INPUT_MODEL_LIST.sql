

CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_INPUT_MODEL_LIST]
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
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_INPUT_MODEL_LIST';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
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

		IF OBJECT_ID('TEMPDB..#MODEL_LIST') IS NOT NULL
		BEGIN 
			DROP TABLE  #MODEL_LIST;
		END;

		IF OBJECT_ID('TEMPDB..#SUBMDLE_LIST') IS NOT NULL
		BEGIN 
			DROP TABLE  #SUBMDLE_LIST;
		END;

		IF OBJECT_ID('TEMPDB..#CHAR_LIST') IS NOT NULL
		BEGIN 
			DROP TABLE  #CHAR_LIST;
		END;

		IF OBJECT_ID('TEMPDB..#ASY_AGING_LIST') IS NOT NULL
		BEGIN 
			DROP TABLE  #ASY_AGING_LIST;
		END;

        ------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------
		-----------------------------------------------------
		-- 1. LOOKUP 등록 Model : 실제 사용 시 STAGE 는 참고용으로만 사용할 것
		-----------------------------------------------------
        SELECT @P_PLAN_ID AS PLAN_ID
			  ,LV.SEGMENT1   AS DIVISION_ID
			  ,LV.SEGMENT2   AS SCM_SITE_ID
              ,LV.SEGMENT3   AS ITEM_ID
              ,LV.SEGMENT4   AS GROUP_ID
              ,LV.SEGMENT5   AS STAGE
              ,CASE WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500'        THEN 'PACK'
                    WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500'        THEN 'MDLE'
                    WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLE'
                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8  = 'CP'       THEN 'CHAR' 
                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP'       THEN 'ASY_AGING'
					ELSE '-'
			   END AS ITEM_STAGE
              ,ISNULL(S.PLANT_ID, LV.ATTRIBUTE2) AS PLANT_ID
		INTO #MODEL_LIST
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)

        LEFT JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                    FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                    WHERE  DIVISION_ID = @V_DIVISION_ID  
					AND   ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                        OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                            )
                    ) B
        ON    LV.SEGMENT1 = B.DIVISION_ID
        AND   LV.SEGMENT3 = B.ITEM_ID 

        LEFT JOIN SCM_MST_SITE S WITH (NOLOCK) 
        ON    S.DIVISION_ID = LV.SEGMENT1
        AND   S.SCM_SITE_ID = LV.SEGMENT2
        AND   S.SITE_TYPE   = 'PLANT'
        AND   S.VALID_YN    = 'Y'
		AND   ((S.DIVISION_ID  = '40' AND S.OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
            OR  (S.DIVISION_ID <> '40' AND S.OPERATION_GROUP IN ('A', 'P') )
                )

        WHERE   LV.LOOKUP_TYPE = 'SCP_OPT_ENG_MODEL_TEMP'
        AND     LV.VALID_YN    = 'Y'
        AND     LV.SEGMENT1    = @V_DIVISION_ID
        AND     LV.SEGMENT4    = @V_GROUP_ID
		
		-----------------------------------------------------
		-- 2-1. PACK/MDLE 하위의 SUBMDLE Model
		-----------------------------------------------------
		SELECT @P_PLAN_ID      AS PLAN_ID
			  ,A.DIVISION_ID   AS DIVISION_ID
			  ,M.SCM_SITE_ID   AS SCM_SITE_ID
              ,A.CHILD_ITEM_ID AS ITEM_ID
              ,M.GROUP_ID      AS GROUP_ID
              ,'SUBMDLE'       AS STAGE
              ,'SUBMDLE'       AS ITEM_STAGE
              ,A.PLANT_ID      AS PLANT_ID
		INTO #SUBMDLE_LIST
		FROM SCM_MST_ALTER_BOM_V A WITH(NOLOCK)
		INNER JOIN (SELECT *
					FROM   #MODEL_LIST
					WHERE  ITEM_STAGE in ('MDLE', 'PACK')
				   ) M

		ON  A.DIVISION_ID    = M.DIVISION_ID
		AND A.PLANT_ID       = M.PLANT_ID
		AND A.PARENT_ITEM_ID = M.ITEM_ID
		AND A.SCP_PLAN_YN    = 'Y'
		
        -----------------------------------------------------
		-- 2-2. 대치 없는 경우도 찾아야하기 때문에 한 번 더 INSERT
		-----------------------------------------------------
        INSERT INTO #SUBMDLE_LIST
		SELECT @P_PLAN_ID      AS PLAN_ID
			  ,A.DIVISION_ID   AS DIVISION_ID
			  ,M.SCM_SITE_ID   AS SCM_SITE_ID
              ,A.CHILD_ITEM_ID AS ITEM_ID
              ,M.GROUP_ID      AS GROUP_ID
              ,'SUBMDLE'       AS STAGE
              ,'SUBMDLE'       AS ITEM_STAGE
              ,A.PLANT_ID      AS PLANT_ID
		FROM SCM_MST_BOM_SN_V A WITH(NOLOCK)
		INNER JOIN (SELECT *
					FROM   #MODEL_LIST
					WHERE  ITEM_STAGE in ('MDLE', 'PACK')
				   ) M
		ON  A.DIVISION_ID    = M.DIVISION_ID
		AND A.PLANT_ID       = M.PLANT_ID
		AND A.PARENT_ITEM_ID = M.ITEM_ID
        AND NOT EXISTS ( SELECT 'X'
                         FROM   #SUBMDLE_LIST
                         WHERE  A.DIVISION_ID    = M.DIVISION_ID
		                    AND A.PLANT_ID       = M.PLANT_ID
		                    AND A.PARENT_ITEM_ID = M.ITEM_ID
		                    AND A.SCP_PLAN_YN    = 'Y' 
                       )
        GROUP BY A.DIVISION_ID,M.SCM_SITE_ID,A.CHILD_ITEM_ID,M.GROUP_ID,A.PLANT_ID
		-----------------------------------------------------
		-- 3. PACK/MDLE 기준 CHAR Model
		-----------------------------------------------------
		SELECT @P_PLAN_ID      AS PLAN_ID
			  ,A.DIVISION_ID   AS DIVISION_ID
			  ,M.SCM_SITE_ID   AS SCM_SITE_ID
              ,A.CHILD_ITEM_ID AS ITEM_ID
              ,M.GROUP_ID      AS GROUP_ID
              ,'CHAR'          AS STAGE
              ,'CHAR'          AS ITEM_STAGE
              ,A.PLANT_ID      AS PLANT_ID
		INTO #CHAR_LIST
		FROM SCM_MST_ALTER_BOM_V A WITH(NOLOCK)
		INNER JOIN #SUBMDLE_LIST M WITH(NOLOCK)

		ON  A.DIVISION_ID    = M.DIVISION_ID
		AND A.PLANT_ID       = M.PLANT_ID
		AND A.PARENT_ITEM_ID = M.ITEM_ID
		AND A.SCP_PLAN_YN    = 'Y'
		
		-----------------------------------------------------
		-- 4. CHAR 하위의 ASY_AGING Model
		-----------------------------------------------------
		SELECT @P_PLAN_ID      AS PLAN_ID
			  ,A.DIVISION_ID   AS DIVISION_ID
			  ,M.SCM_SITE_ID   AS SCM_SITE_ID
              ,A.ITEM_ID_ASSY  AS ITEM_ID
              ,M.GROUP_ID      AS GROUP_ID
              ,'ASY_AGING'     AS STAGE
              ,'ASY_AGING'     AS ITEM_STAGE
              ,A.PLANT_ID      AS PLANT_ID
		INTO #ASY_AGING_LIST
		FROM SCP_MST_CELL_PROD_ASSY_MAP A WITH(NOLOCK)
		INNER JOIN (SELECT *
					FROM   #MODEL_LIST
					WHERE  ITEM_STAGE in ('CHAR')
				   ) M

		ON  A.DIVISION_ID    = M.DIVISION_ID
		AND A.PLANT_ID       = M.PLANT_ID
		AND A.ITEM_ID_PROD   = M.ITEM_ID
		AND A.VALID_YN       = 'Y'
		AND A.CELL_TYPE      = 'CA1'

		-----------------------------------------------------
		-- 5. 최종 Model List INSERT : 중복 제외를 위해 UNION 적용
		-----------------------------------------------------
        INSERT INTO SCP_OPT_ENG_MODEL_LIST_N_SN
              (PLAN_ID
              ,SCM_SITE_ID
              ,ITEM_ID
              ,STAGE
              )
		-- 전체 등록 Model
        SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, STAGE
        FROM   #MODEL_LIST LV WITH(NOLOCK)

		-- PACK/MDLE 하위의 SUBMDLE
		UNION
		SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, STAGE
		FROM #SUBMDLE_LIST A WITH(NOLOCK)

		-- PACK/MDLE 기준 CHAR Model
		UNION
		SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, STAGE
		FROM #CHAR_LIST A WITH(NOLOCK)

		-- CHAR 하위의 ASY_AGING Model
		UNION
		SELECT PLAN_ID, SCM_SITE_ID, ITEM_ID, STAGE
		FROM #ASY_AGING_LIST A WITH(NOLOCK)

        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------

		IF OBJECT_ID('TEMPDB..#MODEL_LIST') IS NOT NULL
		BEGIN 
			DROP TABLE  #MODEL_LIST;
		END;

		IF OBJECT_ID('TEMPDB..#SUBMDLE_LIST') IS NOT NULL
		BEGIN 
			DROP TABLE  #SUBMDLE_LIST;
		END;

		IF OBJECT_ID('TEMPDB..#CHAR_LIST') IS NOT NULL
		BEGIN 
			DROP TABLE  #CHAR_LIST;
		END;
		IF OBJECT_ID('TEMPDB..#ASY_AGING_LIST') IS NOT NULL
		BEGIN 
			DROP TABLE  #ASY_AGING_LIST;
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
