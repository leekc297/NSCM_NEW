/***************************************************************************************************
 * Program ID   : PR_SSP_DNM_FORMATION_POST_CELL
 * Description  : SSP_FORMATION_POST_CELL_V 1시간 배치 적용
 * OutTable     : 
 * Execute      : EXEC PR_SSP_DNM_FORMATION_POST_CELL
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 *   20210526   SSP Pjt.       Create
****************************************************************************************************/

CREATE PROCEDURE [dbo].[PR_SSP_DNM_FORMATION_POST_CELL] 
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user				NVARCHAR(150)	= N'ssp_batch';  

    DECLARE @v_program_name				NVARCHAR(150)	= N'PR_SSP_DNM_FORMATION_POST_CELL';
    DECLARE @v_log_type					NVARCHAR(30); 
    DECLARE @n_log_count				INTEGER = 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id					NVARCHAR(150)	= N'SSP_DNM_FORMATION_POST_CELL'; -- ▶ 테이블 필수
    DECLARE @d_event_date				DATETIME;

	DECLARE @dm_req_cnt					INT = 0;	
	DECLARE @v_division_id              NVARCHAR(10);
    DECLARE @v_dm_req_no				NVARCHAR(60)	= '';

    DECLARE @v_start_time				DATETIME		= SYSDATETIME();
    DECLARE @v_exec_time				NVARCHAR(10)	= '';

	DECLARE @v_from_yyyymmdd  NVARCHAR(8)
	DECLARE @v_to_yyyymmdd    NVARCHAR(8)

	SET @v_from_yyyymmdd	= CONVERT(CHAR(8), getdate(), 112);
	SET @v_to_yyyymmdd		= CONVERT(CHAR(8), DATEADD(DD, 60, CONVERT(VARCHAR, @v_from_yyyymmdd, 121)), 112);

	DECLARE @INX		INT	= 0;
    DECLARE @MAX_NUM	INT	= 0;

	IF OBJECT_ID('tempdb..#TAB') IS NOT NULL	
		DROP TABLE #TAB;

	CREATE TABLE #TAB
	--DECLARE @TAB        TABLE
	(
	 --   TID						INT IDENTITY(1,1)	NOT NULL PRIMARY KEY,
		[DIVISION_ID]			[nvarchar](30)		NOT NULL INDEX VIX_TAB_01(DIVISION_ID, CELL_ITEM_ID, SCM_SITE_ID, LINE_ID, PLAN_DATE),
		[CELL_ITEM_ID]			[nvarchar](50)		NOT NULL,
		[SCM_SITE_ID]			[nvarchar](30)		NOT NULL,
		LINE_ID                 nvarchar(30)        not null,
		[PLAN_DATE]				[nvarchar](8)		NOT NULL,
		[PLAN_QTY]				[numeric](20, 10)	NULL
	)

    -- 시작 LOG
    SET @v_log_type		= N'START';
    SET @v_log_message	= N'########## Start of procedure ##########';
    SET @v_description	= @v_program_name + ': ' + @v_table_id + N' INSERT LOGIC';  
    SET @d_event_date	= SYSDATETIME();

    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;

    BEGIN TRY

		INSERT INTO #TAB (
	           [DIVISION_ID]	
			  ,[CELL_ITEM_ID]		
			  ,[SCM_SITE_ID]
			  ,LINE_ID
			  ,[PLAN_DATE]		
			  ,[PLAN_QTY]	
			  )
        SELECT FP.DIVISION_ID
			 , FP.CELL_ITEM_ID
			 , FP.SCM_SITE_ID	
			 , FP.LINE_ID
			 , FP.PLAN_DATE
			 , SUM(ISNULL(FP.PLAN_QTY, 0)) AS PLAN_QTY						
          FROM dbo.SSP_FORMATION_POST_CELL_V FP WITH(NOLOCK)
          --FROM dbo.SCM_FORMATION_POST_CELL_V_SN FP WITH(NOLOCK)
         WHERE FP.DIVISION_ID   = '40'
		   AND FP.PLAN_DATE		>= @v_from_yyyymmdd
		   AND FP.PLAN_DATE		<= @v_to_yyyymmdd
         GROUP BY
		       FP.DIVISION_ID
			  ,FP.CELL_ITEM_ID
			  ,FP.SCM_SITE_ID
			  ,FP.LINE_ID
			  ,FP.PLAN_DATE
		    ;

		----BEGIN TRAN TX_SH

		MERGE INTO [dbo].[SSP_DNM_FORMATION_POST_CELL] A
		USING #TAB AS B
		   ON A.[DIVISION_ID]			= B.[DIVISION_ID]	
		  AND A.[CELL_ITEM_ID]			= B.[CELL_ITEM_ID]		
		  AND A.[SCM_SITE_ID]			= B.[SCM_SITE_ID]	
		  AND A.LINE_ID                 = B.LINE_ID
		  AND A.[PLAN_DATE]				= B.[PLAN_DATE]		
		WHEN MATCHED THEN
			UPDATE 
			   SET [PLAN_QTY]           = B.[PLAN_QTY]
		          ,LAST_UPDATED_BY		= @v_batch_user
			      ,LAST_UPDATE_DATE		= GETDATE()	
	    WHEN NOT MATCHED THEN
			INSERT (	
			  	   [DIVISION_ID]	
			  	  ,[CELL_ITEM_ID]		
			  	  ,[SCM_SITE_ID]
				  ,LINE_ID
			  	  ,[PLAN_DATE]		
			  	  ,[PLAN_QTY]
			      ,[CREATED_BY]		
			      ,[CREATION_DATE]		
			      ,[LAST_UPDATED_BY]	
			      ,[LAST_UPDATE_DATE]	
				  )
		   VALUES (
			  	   B.[DIVISION_ID]	
			  	  ,B.[CELL_ITEM_ID]		
			  	  ,B.[SCM_SITE_ID]	
				  ,B.LINE_ID
			  	  ,B.[PLAN_DATE]		
			  	  ,B.[PLAN_QTY]
			      ,@v_batch_user      
			      ,GETDATE()          
			      ,@v_batch_user      
			      ,GETDATE()          
				  );

		DELETE T
		  FROM [dbo].[SSP_DNM_FORMATION_POST_CELL] AS T WITH(NOLOCK)
		       LEFT OUTER JOIN #TAB AS S
		    ON S.[DIVISION_ID]		= T.[DIVISION_ID]	
		   AND S.[CELL_ITEM_ID]		= T.[CELL_ITEM_ID]		
		   AND S.[SCM_SITE_ID]		= T.[SCM_SITE_ID]	
		   AND S.LINE_ID            = T.LINE_ID
		   AND S.[PLAN_DATE]		= T.[PLAN_DATE]		
		 WHERE S.DIVISION_ID IS NULL


		--COMMIT TRAN TX_SH;
		-----------------------------------------------------------
		-- 실행 Logic END --
		-----------------------------------------------------------

		-- TXN LOG
		SET @v_log_type		= N'TXN';    -- ▶ 로그타입
		SET @n_log_count	= @@ROWCOUNT;
		SET @v_log_message	= N'EXECUTE '+ @v_program_name;
		SET @v_description	= N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
		SET @d_event_date	= SYSDATETIME();

		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
								  ,@p_log_type      = @v_log_type
								  ,@p_log_count     = @n_log_count 
								  ,@p_log_message   = @v_log_message 
								  ,@p_description   = @v_description 
								  ,@p_event_date    = @d_event_date 
								  ,@p_user_id       = @v_batch_user
								  ;      



	END TRY

    BEGIN CATCH

	    --ROLLBACK TRAN TX_SH

		-- ERROR LOG
		SET @v_log_type		= N'ERROR';
		SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description	= @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date	= SYSDATETIME();

		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
								  ,@p_log_type      = @v_log_type
								  ,@p_log_count     = @n_log_count 
								  ,@p_log_message   = @v_log_message 
								  ,@p_description   = @v_description 
								  ,@p_event_date    = @d_event_date 
								  ,@p_user_id       = @v_batch_user
								  ;

		IF OBJECT_ID('tempdb..#TAB') IS NOT NULL	
			DROP TABLE #TAB;  

		RETURN -1
 
    END CATCH;



     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 

    -- 종료 LOG
    SET @v_log_type		= N'END';
    SET @v_log_message	= N'########## END of procedure ##########';
    SET @v_description	= N'['++'][' + @v_exec_time + ']';  
    SET @d_event_date	= SYSDATETIME()  ;

    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;

	IF OBJECT_ID('tempdb..#TAB') IS NOT NULL	
		DROP TABLE #TAB;   

    RETURN 1 ;
END ;

