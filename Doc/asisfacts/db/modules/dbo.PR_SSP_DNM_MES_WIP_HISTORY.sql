/***************************************************************************************************
 * Program ID   : PR_SSP_DNM_MES_WIP_HISTORY
 * Description  : [LGCE_FP_TR].[dbo].[SCM_MES_WIP_HISTORY_H] -> SSP_DNM_MES_WIP_HISTORY 1일 배치 적용 (10시)
 * OutTable     : 
 * Execute      : EXEC PR_SSP_DNM_MES_WIP_HISTORY
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 *   20210514   SSP Pjt.       Create
****************************************************************************************************/

CREATE PROCEDURE [dbo].[PR_SSP_DNM_MES_WIP_HISTORY] 
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user				NVARCHAR(150)	= N'ssp_batch';  

    DECLARE @v_program_name				NVARCHAR(150)	= N'PR_SSP_DNM_MES_WIP_HISTORY';
    DECLARE @v_log_type					NVARCHAR(30); 
    DECLARE @n_log_count				INTEGER = 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id					NVARCHAR(150)	= N'SSP_DNM_MES_WIP_HISTORY'; -- ▶ 테이블 필수
    DECLARE @d_event_date				DATETIME;

	DECLARE @dm_req_cnt					INT = 0;	
	DECLARE @v_division_id              NVARCHAR(10);
    DECLARE @v_dm_req_no				NVARCHAR(60)	= '';

    DECLARE @v_start_time				DATETIME		= SYSDATETIME();
    DECLARE @v_exec_time				NVARCHAR(10)	= '';

	DECLARE @v_cutoff_date              date;

	DECLARE @INX		INT	= 0;
    DECLARE @MAX_NUM	INT	= 0;

	DECLARE @TAB   TABLE
	(
	 --   TID						INT IDENTITY(1,1)	NOT NULL PRIMARY KEY,
	    [DIVISION_ID]		[nvarchar](10)		NOT NULL,
	    [FROM_SITE]			[nvarchar](30)		NOT NULL,
	    [ITEM_ID]			[nvarchar](50)		NOT NULL,
	    [LOT_ID]			[nvarchar](50)		NOT NULL,
		[YYYYMMDD]          [nvarchar](8)       NOT NULL,
	    [WIPQTY2_ED]		[numeric](20, 10)	NOT NULL
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

		INSERT INTO @TAB (
	           [DIVISION_ID]	
			  ,[FROM_SITE]		 
			  ,[ITEM_ID]		 
			  ,[LOT_ID]	
			  ,[YYYYMMDD]
			  ,[WIPQTY2_ED]	 
			  )
		SELECT 
			   F.DIVISION_ID
			 , S.SCM_SITE_ID AS FROM_SITE
			 , M.PRODID AS ITEM_ID
			 , SUBSTRING(M.ATTRIBUTE7,1,8) AS LOT_ID
			 , REPLACE(SUBSTRING(M.CALDATE,1,10), '-','') AS YYYYMMDD
			 , SUM(M.WIPQTY2_ED) AS WIPQTY2_ED
		  FROM [LGCE_FP_TR].[dbo].[SCM_MES_WIP_HISTORY_H] AS M with(nolock)
			   INNER JOIN SCM_MST_FACTORY_SN AS F with(nolock)
			ON M.ATTRIBUTE2		= F.FACTORY_ID
			   INNER JOIN SCM_MST_SITE AS S WITH(NOLOCK)
			ON F.PLANT_ID		= S.PLANT_ID
		   AND F.SHOP_GROUP_ID	= S.OPERATION_GROUP
		   AND S.SITE_TYPE		= 'PLANT'
		   AND VALID_YN			= 'Y'
		 WHERE M.ATTRIBUTE7 IS NOT NULL
		   AND M.PROCID			= 'A3000'
		   AND M.CALDATE		between substring(convert(varchar, getdate()-3, 120),1,10) + ' 00:00:00' and substring(convert(varchar, getdate(), 120),1,10) + ' 00:00:00'
		 GROUP BY 
			   F.DIVISION_ID
			 , S.SCM_SITE_ID
			 , M.PRODID
			 , M.CALDATE
			 , SUBSTRING(M.ATTRIBUTE7,1,8)


		----BEGIN TRAN TX_SH

		MERGE INTO [dbo].[SSP_DNM_MES_WIP_HISTORY] T
		USING @TAB AS S
		   ON T.[DIVISION_ID]			= S.[DIVISION_ID]	
		  AND T.[FROM_SITE]				= S.[FROM_SITE]		
		  AND T.[ITEM_ID]				= S.[ITEM_ID]	
		  AND T.[LOT_ID]				= S.[LOT_ID]
		  AND T.[YYYYMMDD]              = S.[YYYYMMDD]
		WHEN MATCHED THEN
			UPDATE 
			   SET T.[WIPQTY2_ED]			= S.[WIPQTY2_ED]	
		          ,T.LAST_UPDATED_BY		= @v_batch_user
			      ,T.LAST_UPDATE_DATE		= GETDATE()	
	    WHEN NOT MATCHED THEN
			INSERT (	
			  	   [DIVISION_ID]	
			  	  ,[FROM_SITE]		
			  	  ,[ITEM_ID]		
			  	  ,[LOT_ID]	
				  ,[YYYYMMDD]
			  	  ,[WIPQTY2_ED]	
	              ,[CREATED_BY]		    
	              ,[CREATION_DATE]		
	              ,[LAST_UPDATED_BY]	
	              ,[LAST_UPDATE_DATE]	
				  )
		   VALUES (
			  	   S.[DIVISION_ID]	
			  	  ,S.[FROM_SITE]		
			  	  ,S.[ITEM_ID]		
			  	  ,S.[LOT_ID]
				  ,S.[YYYYMMDD]
			  	  ,S.[WIPQTY2_ED]	
			      ,@v_batch_user      
			      ,GETDATE()          
			      ,@v_batch_user      
			      ,GETDATE()          
				  );


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

   
    RETURN 1 ;
END ;

