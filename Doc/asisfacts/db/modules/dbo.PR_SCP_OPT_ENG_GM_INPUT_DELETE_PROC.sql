
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_INPUT_DELETE_PROC]
     @P_PLAN_ID             NVARCHAR(50)
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
    DECLARE @V_PROGRAM_NAME NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_INPUT_DELETE_PROC';
    DECLARE @V_PLAN_ID      NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE  DATETIME;
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
    -- DELETE START FOR MAIN
    ------------------------------------------------------------------------
        DELETE FROM SCP_OPT_ENG_PLAN_MASTER_SN               WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_BOD_SN                       WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_BOM_SN                       WHERE PLAN_ID = @P_PLAN_ID
		DELETE FROM SCP_OPT_ENG_BOM_ELEC_SN			         WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_ITEM_SITE_SN                 WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_ROUTING_SN                   WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_ITEM_BOM_ROUTING_SN          WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_RESOURCE_SN                  WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_ROUTING_RESOURCE_SN          WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN   WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_INCOMING_STOCK_SN            WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_DEMAND_SN                    WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_BUCKETS_SN                   WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_COBY_PROD_ITEM_SN            WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_FROZEN_PLAN_SN               WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_GOALS_SN                     WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_OBJECTIVES_SN                WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_OBJECTIVE_GOAL_MAPPING_SN    WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_PHASES_SN                    WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_RESOURCE_HORIZON_CALENDAR_SN WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_SAFETY_STOCK_SN              WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN            WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_MODEL_LIST_N_SN              WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_INCOMING_STOCK_XTR_SN        WHERE PLAN_ID = @P_PLAN_ID
    ------------------------------------------------------------------------
    -- DELETE START FOR HISTORY
    ------------------------------------------------------------------------
        DELETE FROM SCP_OPT_ENG_PLAN_MASTER_H_SN               WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_BOD_H_SN                       WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_BOM_H_SN                       WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_ITEM_SITE_H_SN                 WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_ROUTING_H_SN                   WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_ITEM_BOM_ROUTING_H_SN          WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_RESOURCE_H_SN                  WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_ROUTING_RESOURCE_H_SN          WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_H_SN   WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_INCOMING_STOCK_H_SN            WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_DEMAND_H_SN                    WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_BUCKETS_H_SN                   WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_COBY_PROD_ITEM_H_SN            WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_FROZEN_PLAN_H_SN               WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_GOALS_H_SN                     WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_OBJECTIVES_H_SN                WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_OBJECTIVE_GOAL_MAPPING_H_SN    WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_PHASES_H_SN                    WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_RESOURCE_HORIZON_CALENDAR_H_SN WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_SAFETY_STOCK_H_SN              WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_SCHEDULED_MOVE_H_SN            WHERE PLAN_ID = @P_PLAN_ID
        DELETE FROM SCP_OPT_ENG_MODEL_LIST_N_H_SN              WHERE PLAN_ID = @P_PLAN_ID
    ------------------------------------------------------------------------
    -- DELETE END
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
