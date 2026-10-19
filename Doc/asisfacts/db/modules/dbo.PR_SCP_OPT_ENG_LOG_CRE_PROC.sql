CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_LOG_CRE_PROC]
      @P_LOG_TYPE         NVARCHAR(50)
    , @P_SYSTEM_TYPE_CODE NVARCHAR(50)
    , @P_PLAN_ID		  NVARCHAR(50)
    , @P_PROGRAM_NAME	  NVARCHAR(100)
    , @P_STATUS_CODE	  NVARCHAR(30)
    , @P_SORT_ORDER_NO	  NVARCHAR(40)
    , @P_MESSAGE_TEXT	  NVARCHAR(1000)
    , @P_LOG_DATE		  DATETIME
    , @P_PARAMETER_VALUE  NVARCHAR(200)

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
	-- Set Prameter
	------------------------------------------------------------------------
    DECLARE @SORT_ORDER_NO NVARCHAR(150)
    DECLARE @PROGRESS_RATE NUMERIC(20,0)
    ------------------------------------------------------------------------  
	
	BEGIN TRY
    ------------------------------------------------------------------------
    -- Set Sort Order
    ------------------------------------------------------------------------
    SELECT @SORT_ORDER_NO = IIF(MAX(CONVERT(INT,SORT_ORDER_NO)) IS NULL, 1, MAX(CONVERT(INT,SORT_ORDER_NO)) +1 )
    FROM   SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N_SN
    WHERE  PLAN_ID = @P_PLAN_ID
    ;

    ------------------------------------------------------------------------
    -- Log Insert
    ------------------------------------------------------------------------
    IF @P_LOG_TYPE = 'I'  
    ------------------------------------------------------------------------
    BEGIN
        INSERT INTO SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N_SN
		(SYSTEM_TYPE_CODE
        ,PLAN_ID
        ,PROGRAM_NAME
        ,STATUS_CODE
        ,SORT_ORDER_NO
        ,MESSAGE_TEXT
        ,LOG_DATE
        ,PARAMETER_VALUE
        ,INSERT_ID
        ,INSERT_TIME
        ,UPDATE_ID
        ,UPDATE_TIME
		)
        VALUES
		(@P_SYSTEM_TYPE_CODE
		,@P_PLAN_ID		 
		,@P_PROGRAM_NAME	 
		,@P_STATUS_CODE	 
		,@SORT_ORDER_NO	 
		,@P_MESSAGE_TEXT	 
		,GETDATE()		 
		,@P_PARAMETER_VALUE 
		,'SYSTEM'
		,GETDATE()
		,'SYSTEM'
		,GETDATE()
		)
    END

    ------------------------------------------------------------------------
    IF @P_LOG_TYPE = 'I' AND @P_STATUS_CODE = 'END'
    ------------------------------------------------------------------------
    BEGIN
        ------------------------------------------------------------------------
        -- GET Progress Rate
        ------------------------------------------------------------------------
        SELECT @PROGRESS_RATE = CONVERT(INT,CONVERT(NUMERIC(20,2),COUNT(*))/21*100)
        FROM   SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N_SN WITH(NOLOCK)
        WHERE  SYSTEM_TYPE_CODE	= @P_SYSTEM_TYPE_CODE
        AND    PLAN_ID			= @P_PLAN_ID
        AND    STATUS_CODE      = 'END' 
        ------------------------------------------------------------------------
        -- Update Progress Rate
        ------------------------------------------------------------------------
        UPDATE SCP_OPT_ENG_ENGINE_RUN_STATUS_DETAIL_SN
        SET    PROGRESS_RATE    = @PROGRESS_RATE
        WHERE  PLAN_ID			= @P_PLAN_ID
        AND    PROGRESS_CODE    = IIF(@P_SYSTEM_TYPE_CODE = 'INPUT', 'STEP01','STEP04')
        ------------------------------------------------------------------------
    END
    ------------------------------------------------------------------------    
    IF @P_LOG_TYPE != 'I' -- UPDATE
    ------------------------------------------------------------------------
    BEGIN
	    UPDATE SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N_SN
		SET    STATUS_CODE     = IIF(@P_STATUS_CODE     IS NULL, STATUS_CODE     , @P_STATUS_CODE   )
		     , SORT_ORDER_NO   = IIF(@P_SORT_ORDER_NO   IS NULL, SORT_ORDER_NO   , @P_SORT_ORDER_NO  )
			 , MESSAGE_TEXT	   = IIF(@P_MESSAGE_TEXT    IS NULL, MESSAGE_TEXT    , @P_MESSAGE_TEXT   )
			 , LOG_DATE		   = IIF(@P_LOG_DATE        IS NULL, LOG_DATE        , @P_LOG_DATE       )
			 , PARAMETER_VALUE = IIF(@P_PARAMETER_VALUE IS NULL, PARAMETER_VALUE , @P_PARAMETER_VALUE)
			 , UPDATE_ID	   = 'SYSTEM'
			 , UPDATE_TIME	   = GETDATE()
	     WHERE SYSTEM_TYPE_CODE	= @P_SYSTEM_TYPE_CODE
           AND PLAN_ID			= @P_PLAN_ID
           AND PROGRAM_NAME     = @P_PROGRAM_NAME
    END
	END TRY
	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_LOG_CRE_PROC;
	------------------------------------------------------------------------  
	--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	
	------------------------------------------------------------------------
    END CATCH
	------------------------------------------------------------------------

	------------------------------------------------------------------------
  END;
