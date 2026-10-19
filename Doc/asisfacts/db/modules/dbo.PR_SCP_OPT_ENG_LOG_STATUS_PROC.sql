CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_LOG_STATUS_PROC]
     @P_LOG_TYPE        NVARCHAR(50)
    ,@P_PLAN_ID         NVARCHAR(50)
    ,@P_PROGRESS_STATUS	NVARCHAR(80)
    ,@P_INPUT_START	    NVARCHAR(1)
    ,@P_INPUT_END	    NVARCHAR(1)
    ,@P_ENGINE_START	NVARCHAR(1)
    ,@P_ENGINE_END	    NVARCHAR(1)
    ,@P_OUTPUT_START	NVARCHAR(1)
    ,@P_OUTPUT_END	    NVARCHAR(1)
    ,@P_STOP_FLAG	    NVARCHAR(1)
    ,@P_SERVER_NAME	    NVARCHAR(80)
    ,@P_DESCRIPTION	    NVARCHAR(200)
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
	-- Transaction (START)
	------------------------------------------------------------------------  
	BEGIN TRANSACTION PR_SCP_OPT_ENG_LOG_STATUS_PROC;
	------------------------------------------------------------------------
	BEGIN TRY
    ------------------------------------------------------------------------  
    -- Log Insert
    ------------------------------------------------------------------------
    IF @P_LOG_TYPE = 'I'  
    ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_ENGINE_RUN_STATUS_SN
        (PLAN_ID
        ,PROGRESS_STATUS
        ,INPUT_START
        ,INPUT_END
        ,ENGINE_START
        ,ENGINE_END
        ,OUTPUT_START
        ,OUTPUT_END
        ,STOP_FLAG
        ,SERVER_NAME
        ,DESCRIPTION
        ,INSERT_ID
        ,INSERT_TIME
        ,UPDATE_ID
        ,UPDATE_TIME)
     VALUES
        (@p_plan_id
        ,'N'
        ,'N'
        ,'N'
        ,'N'
        ,'N'
        ,'N'
        ,'N'
        ,'N'
        ,NULL
        ,NULL
        ,'SYSTEM'
        ,GETDATE()
        ,'SYSTEM'
        ,GETDATE())
    ------------------------------------------------------------------------    
    ELSE -- UPDATE
    ------------------------------------------------------------------------
        UPDATE SCP_OPT_ENG_ENGINE_RUN_STATUS_SN
        SET   PROGRESS_STATUS   = IIF(@P_PROGRESS_STATUS    IS NULL, PROGRESS_STATUS    ,@P_PROGRESS_STATUS )
             ,INPUT_START       = IIF(@P_INPUT_START        IS NULL, INPUT_START        ,@P_INPUT_START     )
             ,INPUT_END         = IIF(@P_INPUT_END          IS NULL, INPUT_END          ,@P_INPUT_END       )
             ,ENGINE_START      = IIF(@P_ENGINE_START       IS NULL, ENGINE_START       ,@P_ENGINE_START    )
             ,ENGINE_END        = IIF(@P_ENGINE_END         IS NULL, ENGINE_END         ,@P_ENGINE_END      )
             ,OUTPUT_START      = IIF(@P_OUTPUT_START       IS NULL, OUTPUT_START       ,@P_OUTPUT_START    )
             ,OUTPUT_END        = IIF(@P_OUTPUT_END         IS NULL, OUTPUT_END         ,@P_OUTPUT_END      )
             ,STOP_FLAG         = IIF(@P_STOP_FLAG          IS NULL, STOP_FLAG          ,@P_STOP_FLAG       )
             ,SERVER_NAME       = IIF(@P_SERVER_NAME        IS NULL, SERVER_NAME        ,@P_SERVER_NAME     )
             ,DESCRIPTION       = IIF(@P_DESCRIPTION        IS NULL, DESCRIPTION        ,@P_DESCRIPTION     )
             ,UPDATE_TIME       = GETDATE()
        WHERE PLAN_ID = @P_PLAN_ID

		COMMIT TRANSACTION;
	END TRY

	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	ROLLBACK TRANSACTION PR_SCP_OPT_ENG_LOG_STATUS_PROC;
	------------------------------------------------------------------------
    -- LOGGING
	------------------------------------------------------------------------  
    END CATCH
	------------------------------------------------------------------------

  END;
