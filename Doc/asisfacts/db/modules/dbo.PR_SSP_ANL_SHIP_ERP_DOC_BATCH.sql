
/*
 * Program ID   : [PR_SSP_ANL_SHIP_ERP_DOC_BATCH]  
 * Description  : ERP 문서생성 수신 후 상태 UPDATE 
 * OutTable     :
 * Execute      : EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH @p_change_type @p_change_req_no
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.04.25   LJH         Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2022/03/21   KIMYONGHO   SSP_ANL_SHIP_ERP_DO 테이블 DO 생성 여부 로직 추가
 */

CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_ERP_DOC_BATCH]
--( 
     -- @p_change_type           NVARCHAR(1),  -- B: 변경확정,C: 변경요청, D: 변경 Reject 
     -- @p_change_req_no         NVARCHAR(30) 
	 -- , @p_debug       INT OUTPUT
--) 
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    SET     @v_batch_user = 'ssp_batch' ; -- @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_ANL_SHIP_ERP_DOC_BATCH';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'PR_SSP_ANL_SHIP_ERP_DOC_BATCH'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SHIP_CONFIRM INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';


    DECLARE @v_plan_start_yyyymmdd    NVARCHAR(8) = '';
	DECLARE @v_seq    INTEGER = 0;
	DECLARE @v_infseqno	nvarchar(14);	


	DECLARE @V_ERP_DO_STATUS		  NVARCHAR(1) = NULL;
	DECLARE @V_ERP_DO_NO			  NVARCHAR(10) = NULL;

	--CURSOR 선언 
	DECLARE @confirm_id VARCHAR(100), @doc_type VARCHAR(1), @doc_no VARCHAR(10), @item_no VARCHAR(6), @do_no VARCHAR(10);
	DECLARE @idx INT     SET     @idx = 0 

	DECLARE CUR_ERP_DOC CURSOR FOR   
			SELECT CONFIRM_ID 
			,      DOC_TYPE
			,      DOC_NO
			,      ITEM_NO
			,      DO_NO
			--,      DO_ITEM_NO
			FROM XIF_ERP_SHIP_DOC_R_SN WITH(NOLOCK) 
			WHERE TRANSFER_FLAG = 'P'
			ORDER BY IFSEQNO, TRANSFER_DATE ;

    BEGIN TRY
      BEGIN
        BEGIN TRAN TX_SH
		------------------------------------------------------------------------------------------------------------- 
		-- 3.SSP_ANL_SHIP_CONFIRM UPDATE : ERP 문서 수신 후 상태 및 DOC NO UPDATE SSP_ANL_SHIP_CONFIRM
		------------------------------------------------------------------------------------------------------------- 

		UPDATE XIF_ERP_SHIP_DOC_R_SN  
		SET    TRANSFER_FLAG = 'P'
		WHERE  TRANSFER_FLAG = 'N'   
		;


		OPEN CUR_ERP_DOC; 

		FETCH NEXT FROM CUR_ERP_DOC INTO @confirm_id , @doc_type , @doc_no , @item_no, @do_no

			WHILE(@@FETCH_STATUS = 0) 

			BEGIN; 
				SET @V_ERP_DO_STATUS = NULL;

				SELECT TOP 1 @V_ERP_DO_STATUS = 'C', @V_ERP_DO_NO = DO_NO
				FROM SSP_ANL_SHIP_ERP_DO (NOLOCK)
				WHERE 1=1  
				  AND CONFIRM_ID		= @confirm_id			 
				  AND DO_VALID_YN		= 'Y'
				;

				--업데이트 수행 ERP_SO_NO , ERP_SO_ITEM_NO,  ERP_DO_NO, ERP_STATUS 
				-- DOC_TYPE : A: SO 생성, B: SO 취소, C: DO 생성, D: DO 취소

				IF @doc_type IN ('A', 'B')
				BEGIN
					UPDATE SSP_ANL_SHIP_CONFIRM 
					SET    ERP_SO_NO      = CASE WHEN @doc_type = 'A' THEN @doc_no
					                             WHEN @doc_type = 'B' THEN NULL 
					                        ELSE ERP_SO_NO
											END
					,      ERP_SO_ITEM_NO = @item_no
					,      ERP_DO_NO      = CASE WHEN @doc_type = 'C' THEN @do_no 
					                             WHEN @doc_type = 'D' THEN CASE WHEN @V_ERP_DO_STATUS = 'C' THEN @V_ERP_DO_NO ELSE NULL END 		 
											ELSE  ERP_DO_NO
											END
					,      ERP_STATUS     = CASE WHEN @V_ERP_DO_STATUS = 'C' THEN @V_ERP_DO_STATUS ELSE @doc_type END 		
					WHERE  CONFIRM_ID     = @confirm_id
					;
				END
				ELSE IF @doc_type IN ('C', 'D')
				BEGIN
					UPDATE SSP_ANL_SHIP_CONFIRM 
					SET    ERP_SO_NO      = CASE WHEN @doc_type = 'C' THEN @doc_no
					                        ELSE ERP_SO_NO
											END
					,      ERP_SO_ITEM_NO = @item_no
					,      ERP_DO_NO      = CASE WHEN @doc_type = 'C' THEN @do_no 
					                             WHEN @doc_type = 'D' THEN CASE WHEN @V_ERP_DO_STATUS = 'C' THEN @V_ERP_DO_NO ELSE NULL END 		 
											ELSE  ERP_DO_NO
											END
					,      ERP_STATUS     = CASE WHEN @V_ERP_DO_STATUS = 'C' THEN @V_ERP_DO_STATUS ELSE @doc_type END 		
					WHERE  CONFIRM_ID     = @confirm_id
					;


				END

				FETCH NEXT FROM CUR_ERP_DOC INTO @confirm_id , @doc_type,  @doc_no, @item_no, @do_no ; 
	
			END; 

		CLOSE CUR_ERP_DOC; 
		DEALLOCATE CUR_ERP_DOC;


		UPDATE XIF_ERP_SHIP_DOC_R_SN  
			SET    TRANSFER_FLAG = 'Y'
			WHERE  TRANSFER_FLAG = 'P' 
			;

		-- IF data  삭제 (90일 이전 데이터 삭제) 
		DELETE 
		FROM  XIF_ERP_SHIP_DOC_R_SN 
		WHERE CREATION_DATE < GETDATE() - 90 
		;
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
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
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
