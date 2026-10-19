

/*  
 * Program ID   : PR_SCP_OPMZ_PLAN_CTRL_ACTV_M
 * Description  : 매주초 Plan Control 대상 Activity 데이터를 일괄 생성한다. 
 *
 *				 - Source : SCP_OPMZ_PLAN_GR_ACTV_M
 *				 - Target : SCP_OPMZ_PLAN_CTRL_ACTV_M
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2025.04.25	hrkim		PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release 
 *
 */  

CREATE PROCEDURE [dbo].[PR_SCP_OPMZ_PLAN_CTRL_ACTV_M] 
	 @P_PLAN_START_YYYYMMDD	NVARCHAR(8)		=  NULL
	,@P_DIVISION_ID			NVARCHAR(50)	=  NULL
	,@P_OPMZ_PRS_ID			NVARCHAR(50)	=  NULL
	,@P_OPMZ_PLAN_GR_ID		NVARCHAR(50)	=  NULL
AS

BEGIN

-- procedure body -- start 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	DECLARE @V_PLAN_START_YYYYMMDD	NVARCHAR(8)		= @P_PLAN_START_YYYYMMDD;
	DECLARE @V_DIVISION_ID			NVARCHAR(50)	= @P_DIVISION_ID;
	DECLARE @V_OPMZ_PRS_ID			NVARCHAR(50)	= @P_OPMZ_PRS_ID;
	DECLARE @V_OPMZ_PLAN_GR_ID		NVARCHAR(50)	= @P_OPMZ_PLAN_GR_ID;

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_OPMZ_PLAN_CTRL_ACTV_M'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

	BEGIN TRY
	  BEGIN

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '##### Start of procedure #####';     
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

	------- Begin Tran : =======================================================================================
	  BEGIN TRAN   --- transaction 시작  

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'기 등록 데이터 삭제 - SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M ' 
		----------------------------------------------------------------------------------------------------------
		DELETE AR -- SELECT *  
		  FROM  SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M AR WITH(NOLOCK)	-- PLAN_START_YYYYMMDD, OPMZ_PRS_CD, OPMZ_PLAN_GR_ID, OPMZ_ACTV_CD
				INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)	-- OPMZ_PLAN_GR_ID
						ON PG.OPMZ_PLAN_GR_ID = AR.OPMZ_PLAN_GR_ID
		 WHERE 1=1
		   AND AR.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
		   AND AR.OPMZ_PRS_CD			= CASE WHEN ISNULL(@V_OPMZ_PRS_ID, 'Z') = 'Z'		THEN AR.OPMZ_PRS_CD		ELSE @V_OPMZ_PRS_ID		END 
		   AND AR.OPMZ_PLAN_GR_ID		= CASE WHEN ISNULL(@V_OPMZ_PLAN_GR_ID, 'Z') = 'Z'	THEN AR.OPMZ_PLAN_GR_ID ELSE @V_OPMZ_PLAN_GR_ID END 
		   AND PG.DIVISION_ID			= CASE WHEN ISNULL(@V_DIVISION_ID, 'Z') = 'Z'		THEN PG.DIVISION_ID		ELSE @V_DIVISION_ID		END 


		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'Activity 수행 데이터 삭제 - SCP_OPMZ_PLAN_CTRL_ACTV_M ' 
		----------------------------------------------------------------------------------------------------------
		DELETE AD -- SELECT *  
		  FROM  SCP_OPMZ_PLAN_CTRL_ACTV_M AD WITH(NOLOCK)		-- PLAN_START_YYYYMMDD, OPMZ_PRS_CD, OPMZ_PLAN_GR_ID, OPMZ_ACTV_CD, OPMZ_PLAN_ID
				INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)	-- OPMZ_PLAN_GR_ID
						ON PG.OPMZ_PLAN_GR_ID = AD.OPMZ_PLAN_GR_ID
		 WHERE 1=1
		   AND AD.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
		   AND AD.OPMZ_PRS_CD			= CASE WHEN ISNULL(@V_OPMZ_PRS_ID, 'Z') = 'Z'		THEN AD.OPMZ_PRS_CD		ELSE @V_OPMZ_PRS_ID		END 
		   AND AD.OPMZ_PLAN_GR_ID		= CASE WHEN ISNULL(@V_OPMZ_PLAN_GR_ID, 'Z') = 'Z'	THEN AD.OPMZ_PLAN_GR_ID ELSE @V_OPMZ_PLAN_GR_ID END 
		   AND PG.DIVISION_ID			= CASE WHEN ISNULL(@V_DIVISION_ID, 'Z') = 'Z'		THEN PG.DIVISION_ID		ELSE @V_DIVISION_ID		END 


		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'최적화 활동 데이터 생성 대상 추출 ' 
		----------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_OPMZ_PLAN_CTRL_ACTV_M
		(
		 plan_start_yyyymmdd
		,OPMZ_PRS_CD
		,OPMZ_PLAN_GR_ID
		,OPMZ_ACTV_CD
		,OPMZ_ACTV_SEQ
		,CREATED_BY
		,CREATION_DATE
		,LAST_UPDATED_BY
		,LAST_UPDATE_DATE 
		)
		SELECT  @V_PLAN_START_YYYYMMDD		AS PLAN_START_YYYYMMDD
				,PA.OPMZ_PRS_CD
				,PA.OPMZ_PLAN_GR_ID
				,PA.OPMZ_ACTV_CD
				,PA.OPMZ_ACTV_SEQ
				,@v_batch_user				AS CREATED_BY
				,GETDATE()					AS CREATION_DATE
				,@v_batch_user				AS LAST_UPDATED_BY
				,GETDATE()					AS LAST_UPDATE_DATE 
		  FROM  SCP_OPMZ_PLAN_GR_ACTV_M PA WITH(NOLOCK)			-- OPMZ_PRS_CD, OPMZ_PLAN_GR_ID, OPMZ_ACTV_CD
				INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)	-- OPMZ_PLAN_GR_ID
						ON PG.OPMZ_PLAN_GR_ID = PA.OPMZ_PLAN_GR_ID
		 WHERE 1=1
		   AND PA.VALID_YN			= 'Y'
		   AND PA.OPMZ_PRS_CD		= CASE WHEN ISNULL(@V_OPMZ_PRS_ID, 'Z') = 'Z'		THEN PA.OPMZ_PRS_CD		ELSE @V_OPMZ_PRS_ID		END 
		   AND PA.OPMZ_PLAN_GR_ID	= CASE WHEN ISNULL(@V_OPMZ_PLAN_GR_ID, 'Z') = 'Z'	THEN PA.OPMZ_PLAN_GR_ID ELSE @V_OPMZ_PLAN_GR_ID END 
		   AND PG.DIVISION_ID		= CASE WHEN ISNULL(@V_DIVISION_ID, 'Z') = 'Z'		THEN PG.DIVISION_ID		ELSE @V_DIVISION_ID		END 

	  COMMIT TRAN ;  --- transaction 종료  
	------- End Tran : ==========================================================================================================

		-----------------------------------------
		------ 임시테이블 정리
		---------------------------------------------


	  END			    
	END TRY

	BEGIN CATCH                  
		if (xact_state() <> 0) ROLLBACK TRAN; 

		-- ERROR LOG                  
		SET @v_log_type = N'ERROR';                  
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
		SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
		SET @d_event_date = SYSDATETIME();                  
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name                  
		                          ,@p_log_type      = @v_log_type                  
		                          ,@p_log_count     = @n_log_count                   
		                          ,@p_log_message   = @v_log_message                   
		                          ,@p_description   = @v_description                   
		                          ,@p_event_date    = @d_event_date                   
		                          ,@p_user_id       = @v_batch_user                  
		                          ;                  
		PRINT @v_log_message      + ' : ' + @v_description ;  
		RETURN -1;    
		
    END CATCH;   

    SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
    -- 종료 LOG                  
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'##### END of procedure #####';                  
    SET @v_description = N'['  + @v_exec_time + ']';  ;            
    SET @d_event_date = SYSDATETIME()  ;                 
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
	PRINT @v_log_message      + ' : ' + @v_description ;          
	RETURN 1;    

END
