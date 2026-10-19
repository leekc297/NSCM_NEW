CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_LOG_DTL_PROC]
      @P_LOG_TYPE      NVARCHAR(50)
    , @P_PLAN_ID	   NVARCHAR(50)
    , @P_PROGRESS_CODE NVARCHAR(30)
    , @P_PROGRESS_TEXT NVARCHAR(1000)
    , @P_PROGRESS_RATE NUMERIC(20,0)
    , @P_START_DATE	   DATETIME
    , @P_END_DATE	   DATETIME
    , @P_MESSAGE_TEXT  NVARCHAR(MAX)
    , @P_STATUS_CODE   NVARCHAR(40)
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
	--BEGIN TRANSACTION PR_SCP_OPT_ENG_LOG_DTL_PROC;
	------------------------------------------------------------------------  
	BEGIN TRY
        
	------------------------------------------------------------------------  
	IF @P_LOG_TYPE = 'I'
    ------------------------------------------------------------------------  
    -- Log Insert Start
    ------------------------------------------------------------------------
	    INSERT INTO SCP_OPT_ENG_ENGINE_RUN_STATUS_DETAIL_SN
		(PLAN_ID
        ,PROGRESS_CODE
        ,PROGRESS_TEXT
        ,PROGRESS_RATE
        ,START_DATE
        ,END_DATE
        ,MESSAGE_TEXT
        ,STATUS_CODE
		,INSERT_ID
        ,INSERT_TIME
        ,UPDATE_ID
        ,UPDATE_TIME
		)
        SELECT @P_PLAN_ID
              ,LV.SEGMENT2     AS PROGRESS_CODE
              ,LV.ATTRIBUTE1   AS PROGRESS_TEXT
              ,0               AS PROGRESS_RATE
              ,NULL            AS START_DATE
              ,NULL            AS END_DATE
              ,NULL            AS MESSAGE_TEXT
              ,NULL            AS STATUS_CODE
              ,'SYSTEM'        AS INSERT_ID
              ,GETDATE()       AS INSERT_TIME
              ,'SYSTEM'        AS UPDATE_ID
              ,GETDATE()       AS UPDATE_TIME
          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
         WHERE LOOKUP_TYPE = 'SCP_OPT_ENG_RUN_STATUS'
         AND   VALID_YN    = 'Y'
    ------------------------------------------------------------------------    
    ELSE -- UPDATE
    ------------------------------------------------------------------------
		UPDATE SCP_OPT_ENG_ENGINE_RUN_STATUS_DETAIL_SN
		SET    PROGRESS_TEXT = IIF(@P_PROGRESS_TEXT IS NULL, PROGRESS_TEXT   , @P_PROGRESS_TEXT  )
             , PROGRESS_RATE = IIF(@P_PROGRESS_RATE IS NULL, PROGRESS_RATE   , @P_PROGRESS_RATE  )
             , START_DATE	 = IIF(@P_START_DATE	IS NULL, START_DATE	     , @P_START_DATE     )
             , END_DATE		 = IIF(@P_END_DATE		IS NULL, END_DATE		 , @P_END_DATE       )
             , MESSAGE_TEXT	 = IIF(@P_MESSAGE_TEXT	IS NULL, MESSAGE_TEXT	 , @P_MESSAGE_TEXT   )
             , STATUS_CODE	 = IIF(@P_STATUS_CODE	IS NULL, STATUS_CODE	 , @P_STATUS_CODE    )
	     WHERE PLAN_ID       = @P_PLAN_ID
		   AND PROGRESS_CODE = @P_PROGRESS_CODE
    ------------------------------------------------------------------------
	--COMMIT TRANSACTION;
    ------------------------------------------------------------------------
	END TRY
	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_LOG_DTL_PROC;
	------------------------------------------------------------------------
    END CATCH
	------------------------------------------------------------------------
	
  END;
