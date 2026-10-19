


/***************************************************************************************************
 * Program ID   : PR_SSP_ANL_ESS_REQ_NET
 * Description  : 
 * OutTable     : PR_SSP_ANL_ESS_REQ_NET
 * Execute      : EXEC PR_SSP_ANL_ESS_REQ_NET
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 *   20210317   SSP Pjt.       Create
 *   20241001   KHJ            NERP_SSP
****************************************************************************************************/

CREATE PROCEDURE [dbo].[PR_SSP_ANL_ESS_REQ_NET]
(
	 @p_dm_req_no                NVARCHAR(60)
    ,@p_division_id              NVARCHAR(10)
	,@r_error_msg                NVARCHAR(1000)  OUTPUT 
)
AS
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    --SET XACT_ABORT ON;
    --SET ANSI_WARNINGS OFF;
	SET ANSI_NULLS ON;
	SET ANSI_WARNINGS ON;

	-- LOG 용 변수 설정
    DECLARE @v_batch_user			    NVARCHAR(150)	= N'ssp_batch';
    DECLARE @v_program_name			    NVARCHAR(150)	= N'PR_SSP_ANL_ESS_REQ_NET';
    DECLARE @v_log_type				    NVARCHAR(30);	-- START/END/ERROR/...
    DECLARE @n_log_count			    INTEGER = 0;
    DECLARE @v_log_message			    NVARCHAR(1000);
    DECLARE @v_description			    NVARCHAR(500);      --상세설명
    DECLARE @v_table_id				    NVARCHAR(150)	= N'SSP_ANL_ESS_REQ_NET'; --테이블 필수
    DECLARE @d_event_date			    DATETIME;
    DECLARE @v_insert_cnt			    INTEGER = 0;
	DECLARE @v_insert_sum			    INTEGER = 0;
									    
	DECLARE @p_language				    NVARCHAR(10)	= 'KO';
	DECLARE @v_msp_check                NVARCHAR(3)		= '-';
	DECLARE @v_wsp_check                NVARCHAR(3)		= '-';
	DECLARE @v_from_yyyymmdd            NVARCHAR(8);
	DECLARE @v_to_yyyymmdd              NVARCHAR(8);
	DECLARE @v_plan_start_yyyymmdd      NVARCHAR(8);
	DECLARE @v_division_id              NVARCHAR(10);
	DECLARE @v_dm_req_no                NVARCHAR(60);
	DECLARE @v_storage_id               NVARCHAR(10)	= dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_ESS_REQ_NET'  ,'STORAGE_6006' )		--'6006';

	DECLARE @INX					    INT				= 0;
    DECLARE @MAX_NUM				    INT				= 0;

	DECLARE @TAB   TABLE
	(
	    TID							    INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		PLAN_START_YYYYMMDD             NVARCHAR(8),
		DIVISION_ID                     NVARCHAR(10),
		DM_REQ_NO                       NVARCHAR(60),
		ITEM_ID                         NVARCHAR(50),
		INV_QTY                         NUMERIC(20,10),
		REMAIN_QTY                      NUMERIC(20,10),
		PLAN_QTY                        NUMERIC(20,10)
	)

	DECLARE @PLAN_START_YYYYMMDD 		NVARCHAR(8);
	DECLARE @DIVISION_ID                NVARCHAR(10);
	DECLARE @DM_REQ_NO                  NVARCHAR(60);
	DECLARE @ITEM_ID                    NVARCHAR(50);
	DECLARE @PLAN_QTY                   NUMERIC(20,10);
	DECLARE @INV_QTY                    NUMERIC(20,10);
	DECLARE @REMAIN_QTY                 NUMERIC(20,10);
	DECLARE @INV_ALLO_QTY               NUMERIC(20,10);

    IF @p_division_id IS NULL
		SET @v_division_id = '82';
    ELSE
   	    SET @v_division_id =  @p_division_id ; 

	SELECT @v_plan_start_yyyymmdd = X.ATTRIBUTE1 
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL AS X WITH(NOLOCK) 
	 WHERE X.LOOKUP_TYPE	= 'SSP_ANL_ESS_PLAN'
	   AND X.SEGMENT1		= @v_division_id
	   AND X.VALID_YN		= 'Y'
	;

	SET @v_dm_req_no		= @p_dm_req_no

	INSERT INTO @TAB (
		   PLAN_START_YYYYMMDD
		  ,DIVISION_ID 
		  ,DM_REQ_NO
		  ,ITEM_ID  
		  ,PLAN_QTY
		  ,INV_QTY            
		  ,REMAIN_QTY         
		  )
	SELECT @v_plan_start_yyyymmdd
		  ,R.DIVISION_ID
		  ,R.DM_REQ_NO
		  ,R.ITEM_ID
		  ,R.PLAN_QTY
		  ,ISNULL(S.INV_QTY,0) AS INV_QTY
		  ,ISNULL(S.REMAIN_QTY,0) AS REMAIN_QTY
	  FROM SSP_ANL_ESS_REQ AS R WITH(NOLOCK)
		   LEFT OUTER JOIN SSP_ANL_ESS_STOCK AS S WITH(NOLOCK)
		ON R.DIVISION_ID			= S.DIVISION_ID
	   AND R.ITEM_ID				= S.ITEM_ID
	   AND S.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
	   AND S.STORAGE_ID				= @v_storage_id
	 WHERE R.DM_REQ_NO				= @v_dm_req_no
	 ORDER BY 
	       R.DIVISION_ID
		  ,R.DM_REQ_NO
		  ,R.ITEM_ID
		;

	SELECT @INX			= 1
	      ,@MAX_NUM		= COUNT(*)
	  FROM @TAB
	  
	IF @MAX_NUM = 0
	BEGIN
	    RETURN 0;
	END

	-----------------------------------------------------------
	-- START LOG
	-----------------------------------------------------------
    SET @v_log_type		= N'START';
    SET @v_log_message	= N'########## Start of procedure ##########';
    SET @v_description	= @v_program_name + ': ' + @v_table_id + N' INSERT LOGIC';  
    SET @d_event_date	= SYSDATETIME();

    EXEC PR_DM_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count
                              ,@p_log_message   = @v_log_message
                              ,@p_description   = @v_description
                              ,@p_event_date    = @d_event_date
                              ,@p_user_id       = @v_batch_user
    ;

    WHILE @INX <= @MAX_NUM
    BEGIN
		BEGIN TRY

			SELECT @PLAN_START_YYYYMMDD 	= PLAN_START_YYYYMMDD 
				  ,@DIVISION_ID				= DIVISION_ID 
				  ,@DM_REQ_NO				= DM_REQ_NO
				  ,@ITEM_ID             	= ITEM_ID 
				  ,@PLAN_QTY                = PLAN_QTY
				  ,@INV_QTY             	= INV_QTY             
				  ,@REMAIN_QTY          	= REMAIN_QTY          
			  FROM @TAB 
			 WHERE TID						= @INX
			

			IF @REMAIN_QTY >= @PLAN_QTY
			BEGIN
				SET @INV_ALLO_QTY	= CASE WHEN (@REMAIN_QTY - @PLAN_QTY) > @INV_QTY THEN @REMAIN_QTY - @INV_QTY ELSE @PLAN_QTY END
				SET @REMAIN_QTY		= @REMAIN_QTY - @INV_ALLO_QTY
			END
			ELSE 
			BEGIN
				SET @INV_ALLO_QTY	= @REMAIN_QTY
				SET @REMAIN_QTY		= 0
			END


			INSERT INTO [dbo].[SSP_ANL_ESS_REQ_NET] (
				   [PLAN_START_YYYYMMDD]
				  ,[DIVISION_ID]
				  ,[DM_REQ_NO]
				  ,[ITEM_ID]
				  ,[PLAN_QTY]
				  ,[INV_ALLO_QTY]
				  ,[CREATED_BY]
				  ,[CREATION_DATE]
				  ,[LAST_UPDATED_BY]
				  ,[LAST_UPDATE_DATE]
				  )
			VALUES (
				   @PLAN_START_YYYYMMDD
				  ,@DIVISION_ID   
				  ,@DM_REQ_NO     
				  ,@ITEM_ID       
				  ,@PLAN_QTY
				  ,@INV_ALLO_QTY
				  ,@v_batch_user
				  ,getdate()
				  ,@v_batch_user
				  ,getdate()
				  )

			UPDATE SSP_ANL_ESS_STOCK
			   SET REMAIN_QTY = @REMAIN_QTY
			 WHERE PLAN_START_YYYYMMDD	= @PLAN_START_YYYYMMDD
			   AND DIVISION_ID			= @DIVISION_ID
			   AND ITEM_ID				= @ITEM_ID
			   AND STORAGE_ID			= @v_storage_id
			   ;

			UPDATE [dbo].[SSP_ANL_ESS_REQ]
			   SET NET_YN = 'Y'
			 WHERE DM_REQ_NO			= @DM_REQ_NO
			   AND ITEM_ID				= @ITEM_ID
				;

				
			SET @v_insert_cnt = @@ROWCOUNT;
			SET @v_insert_sum = @v_insert_sum + @v_insert_cnt;

		END TRY

		BEGIN CATCH
 			-----------------------------------------------------------
			-- ERROR LOG
			-----------------------------------------------------------
			SET @v_log_type		= N'ERROR';
			SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			SET @v_description	= N'ERROR_LINE : ' + STR(ERROR_LINE());
			SET @d_event_date	= SYSDATETIME();

			EXEC PR_DM_SYS_LOG_BATCH  @p_program_name  = @v_program_name
									  ,@p_log_type      = @v_log_type
									  ,@p_log_count     = @n_log_count
									  ,@p_log_message   = @v_log_message
									  ,@p_description   = @v_description
									  ,@p_event_date    = @d_event_date
									  ,@p_user_id       = @v_batch_user
									  ;

 			SET @r_error_msg =  CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			RETURN -1

		END CATCH;

		SET @INX = @INX + 1


	END

 	-----------------------------------------------------------
	-- TXN LOG
	-----------------------------------------------------------
	SET @v_log_type		= N'TXN';    --로그타입
	SET @n_log_count	= @v_insert_cnt; -- @@ROWCOUNT;
	SET @v_log_message	= N'INSERT INTO '+ @v_table_id;
	SET @v_description	= N'Process Complete...' + ':' + CONVERT(CHAR(23) ,@d_event_date ,121) + ' [DIVISION]: ' + @DIVISION_ID ;
	SET @d_event_date	= SYSDATETIME();

	EXEC PR_DM_SYS_LOG_BATCH  @p_program_name  =@v_program_name
								,@p_log_type      =@v_log_type
								,@p_log_count     =@n_log_count
								,@p_log_message   =@v_log_message
								,@p_description   =@v_description
								,@p_event_date    =@d_event_date
								,@p_user_id       =@v_batch_user
								;

 	-----------------------------------------------------------
	-- END LOG
	-----------------------------------------------------------
    SET @v_log_type		= N'END';
    SET @v_log_message	= N'########## END of procedure ##########';
    SET @v_description	= N'';
    SET @d_event_date	= SYSDATETIME();

    EXEC PR_DM_SYS_LOG_BATCH  @p_program_name  = @v_program_name
							  ,@p_log_type      = @v_log_type
							  ,@p_log_count     = @v_insert_sum
							  ,@p_log_message   = @v_log_message
							  ,@p_description   = @v_description
							  ,@p_event_date    = @d_event_date
							  ,@p_user_id       = @v_batch_user
							  ;

 	SET @r_error_msg =  'OK';

    RETURN 1
END;
