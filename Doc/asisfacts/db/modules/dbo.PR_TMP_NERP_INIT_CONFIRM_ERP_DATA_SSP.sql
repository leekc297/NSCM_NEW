

/*
 * Program ID   : PR_TMP_NERP_INIT_CONFIRM_ERP_DATA_SSP
 * Description  : NERP Cut-Over기간 ERP S/O,D/O 초기화를 위한 임시 프로시저
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/11/28   jilee			NERP Cut-Over기간 ERP S/O,D/O 초기화를 위한 임시 프로시저
     
 */

CREATE PROCEDURE [dbo].[PR_TMP_NERP_INIT_CONFIRM_ERP_DATA_SSP]
	@p_confirm_id					NVARCHAR(MAX)

AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    SET     @v_batch_user = 'ssp_batch' ; -- @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_TMP_NERP_INIT_CONFIRM_ERP_DATA_SSP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_ANL_SHIP_CONFIRM'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_confirm_id			    NVARCHAR(MAX)
	DECLARE @v_chk						INT
	DECLARE @v_title					NVARCHAR(MAX) = ''
	DECLARE @v_remarks					NVARCHAR(MAX)
	DECLARE @v_remarks2					NVARCHAR(MAX)
	DECLARE @v_remarks3					NVARCHAR(MAX)

	DECLARE @v_chk_interval					INT
		
	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	SET @v_chk						= 0;
	SET @v_remarks					= NULL;
	SET @v_remarks2					= NULL;
	SET @v_remarks3					= NULL;

	-- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' ';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
  
    BEGIN TRY
      BEGIN
        BEGIN TRAN TX_SH
		------------------------------------------------------------------------------------------------------------- 
		-- 
		------------------------------------------------------------------------------------------------------------- 
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_confirm_id, @v_delimiter);
		WHILE LEN(@p_confirm_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN

			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_confirm_id	= dbo.SCM_ARR_SPL_VAL( @p_confirm_id,				@v_delimiter, @mst_loop_cnt );				
				
				UPDATE SSP_ANL_SHIP_CONFIRM 
					SET    ERP_SO_NO      = NULL
					,      ERP_SO_ITEM_NO = NULL
					,      ERP_DO_NO      = NULL
					,      ERP_STATUS     = NULL
					WHERE  CONFIRM_ID     = @v_confirm_id;
			END;

		END;--While End		
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT TRAN TX_SH;
          END;       


        -- TXN LOG
        SET @v_log_type = N'TXN';    -- ▶ 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INIT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date =  SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      

    END
    END TRY

    BEGIN CATCH
      IF @@TRANCOUNT > 0
        BEGIN
          ROLLBACK TRAN TX_SH

		  IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_ERP_DOC')
			BEGIN
				CLOSE CUR_ERP_DOC 
				DEALLOCATE CUR_ERP_DOC 
		END;


        END;
      


      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;
--      PRINT @@ERROR
      return -1
    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['++'][' + @v_exec_time + ']';  
    SET @d_event_date = SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
   
    return 1  

  END; 
