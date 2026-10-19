


/*
 * Program ID   : [PR_SSP_ANL_SHIP_ERP_PO_IN_BATCH]  
 * Description  : PO IN 수신 정보 처리
 * OutTable     : 
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021-05-06	KIMYONGHO	   최초작성
 */

CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_ERP_PO_IN_BATCH]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
--    SET     @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_ANL_SHIP_ERP_PO_IN_BATCH';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_ANL_ESS_PO_IN'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_ANL_ESS_PO_IN INSERT LOGIC';
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

	DECLARE @v_count          INT  = 0 ;

    BEGIN TRY
      BEGIN
       BEGIN TRAN TX_SH

		-- 인터페이스 테이블 처리 ROW UPDATE
		UPDATE XIF_ERP_PO_INFO_IN_R_SN 
		SET    PROC_FLAG             = 'P'
		WHERE  ISNULL(PROC_FLAG,'N') = 'N'
		;

		--CURSOR 선언 
		DECLARE @if_seq VARCHAR(MAX)

		DECLARE CUR_ESS_PO_IN_R CURSOR FOR

		SELECT IF_SEQ
		FROM   XIF_ERP_PO_INFO_IN_R_SN WITH(NOLOCK) 
		WHERE  PROC_FLAG = 'P'
		ORDER BY IF_SEQ
		;

		OPEN CUR_ESS_PO_IN_R; 

		FETCH NEXT FROM CUR_ESS_PO_IN_R INTO @if_seq
		
		WHILE(@@FETCH_STATUS = 0) 

		BEGIN

		MERGE INTO SSP_ANL_ESS_PO_IN C
		USING
		(        
		       SELECT 
                 X.IF_SEQ
				,X.IF_TYPE
				,X.IF_RCV_DATE
				,X.PROC_DATE
				,X.PROC_MSG
				,X.IFSEQNO
				,X.PR_NO
				,X.PO_NO
				,X.PO_ITEM_SEQ
				,X.PO_ITEM_ID
				,X.PO_ITEM_DOC_NO
				,X.PO_ITEM_DOC_GUBUN
				,X.PO_ITEM_IN_DATE
				,X.PO_ITEM_IN_QTY
				,X.UOM
				,X.LFBNR
				,X.ATTRIBUTE1
				,X.ATTRIBUTE2
				,X.ATTRIBUTE3
				,X.ATTRIBUTE4
				,X.ATTRIBUTE5
				,X.ATTRIBUTE6
				,X.ATTRIBUTE7
				,X.ATTRIBUTE8
				,X.ATTRIBUTE9
				,X.ATTRIBUTE10
			   FROM XIF_ERP_PO_INFO_IN_R_SN X WITH(NOLOCK) 
			  WHERE 1=1 			
			  AND  PROC_FLAG	= 'P'
			  AND  IF_SEQ = @if_seq
		) N
		ON	 C.PR_NO		= N.PR_NO
		AND	 C.PO_NO		= N.PO_NO	
		--AND  C.PO_ITEM_SEQ	= N.PO_ITEM_SEQ
		AND  C.PO_ITEM_ID	= N.PO_ITEM_ID

		WHEN MATCHED THEN
		UPDATE
		SET C.PO_ITEM_DOC_NO	= N.PO_ITEM_DOC_NO
		  , C.PO_ITEM_DOC_GUBUN	= N.PO_ITEM_DOC_GUBUN
		  , C.PO_ITEM_IN_DATE	= N.PO_ITEM_IN_DATE
		  , C.PO_ITEM_IN_QTY	= N.PO_ITEM_IN_QTY
		  , C.UOM				= N.UOM
		  , C.LFBNR				= N.LFBNR
		  , C.ATTRIBUTE1		= N.ATTRIBUTE1
		  , C.ATTRIBUTE2		= N.ATTRIBUTE2
		  , C.ATTRIBUTE3		= N.ATTRIBUTE3
		  , C.ATTRIBUTE4		= N.ATTRIBUTE4
		  , C.ATTRIBUTE5		= N.ATTRIBUTE5
		  , C.ATTRIBUTE6		= N.ATTRIBUTE6
		  , C.ATTRIBUTE7		= N.ATTRIBUTE7
		  , C.ATTRIBUTE8		= N.ATTRIBUTE8
		  , C.ATTRIBUTE9		= N.ATTRIBUTE9
		  , C.ATTRIBUTE10		= N.ATTRIBUTE10
		  , C.LAST_UPDATED_BY	= @v_batch_user
		  , C.LAST_UPDATE_DATE	= getdate()
		WHEN NOT MATCHED THEN
		INSERT ( PR_NO
				,PO_NO
				,PO_ITEM_SEQ
				,PO_ITEM_ID
				,PO_ITEM_DOC_NO
				,PO_ITEM_DOC_GUBUN
				,PO_ITEM_IN_DATE
				,PO_ITEM_IN_QTY
				,UOM
				,LFBNR
				,ATTRIBUTE1
				,ATTRIBUTE2
				,ATTRIBUTE3
				,ATTRIBUTE4
				,ATTRIBUTE5
				,ATTRIBUTE6
				,ATTRIBUTE7
				,ATTRIBUTE8
				,ATTRIBUTE9
				,ATTRIBUTE10
				,[CREATED_BY]
				,[CREATION_DATE]
				,[LAST_UPDATED_BY]
				,[LAST_UPDATE_DATE]
			   )
		 VALUES (
				 N.PR_NO
				,N.PO_NO
				,N.PO_ITEM_SEQ
				,N.PO_ITEM_ID
				,N.PO_ITEM_DOC_NO
				,N.PO_ITEM_DOC_GUBUN
				,N.PO_ITEM_IN_DATE
				,N.PO_ITEM_IN_QTY
				,N.UOM
				,N.LFBNR   
				,N.ATTRIBUTE1
				,N.ATTRIBUTE2
				,N.ATTRIBUTE3
				,N.ATTRIBUTE4
				,N.ATTRIBUTE5
				,N.ATTRIBUTE6
				,N.ATTRIBUTE7
				,N.ATTRIBUTE8
				,N.ATTRIBUTE9
				,N.ATTRIBUTE10
				,@v_batch_user
				,getdate()
				,@v_batch_user
				,getdate()
		 );

		FETCH NEXT FROM CUR_ESS_PO_IN_R INTO @if_seq; 
	
		END; 

		CLOSE CUR_ESS_PO_IN_R; 
		DEALLOCATE CUR_ESS_PO_IN_R;

		-- 인터페이스 테이블 처리 완료 UPDATE
		UPDATE XIF_ERP_PO_INFO_IN_R_SN 
		SET    PROC_FLAG             = 'Y'
		,      PROC_DATE             = GETDATE()   
		,      PROC_MSG              = 'S'
		WHERE  ISNULL(PROC_FLAG,'N') = 'P'
		;


		-- IF data  삭제 (30일 이전 데이터 삭제) 
		DELETE  
		FROM  XIF_ERP_PO_INFO_IN_R_SN 
		WHERE IF_RCV_DATE < GETDATE() - 30
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
        SET @d_event_date = SYSDATETIME();

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

			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_ESS_PO_IN_R')
				BEGIN
				   CLOSE CUR_ESS_PO_IN_R ;
				   DEALLOCATE CUR_ESS_PO_IN_R ;
				END


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
    SET @v_description = N'['+@v_program_name+'][' + @v_exec_time + ']';  
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


