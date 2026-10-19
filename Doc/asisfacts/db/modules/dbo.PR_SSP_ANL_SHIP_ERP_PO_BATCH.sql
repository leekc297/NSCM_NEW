



/*
 * Program ID   : [PR_SSP_ANL_SHIP_ERP_PO_BATCH]  
 * Description  : PO 수신 정보 처리
 * OutTable     : 
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021-05-06	KIMYONGHO	   최초작성
 * 2024-10-01   KHJ            NERP_SSP
 */

CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_ERP_PO_BATCH]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
--    SET     @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_ANL_SHIP_ERP_PO_BATCH';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_ANL_ESS_PO'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_ANL_ESS_PO INSERT LOGIC';
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
		UPDATE XIF_ERP_PO_INFO_R_SN 
		SET    PROC_FLAG             = 'P'
		WHERE  ISNULL(PROC_FLAG,'N') = 'N'
		;

		--CURSOR 선언 
		DECLARE @if_seq VARCHAR(MAX)

		DECLARE CUR_ESS_PO_R CURSOR FOR

		SELECT IF_SEQ
		FROM   XIF_ERP_PO_INFO_R_SN WITH(NOLOCK) 
		WHERE  PROC_FLAG = 'P'
		ORDER BY IF_SEQ
		;

		OPEN CUR_ESS_PO_R; 

		FETCH NEXT FROM CUR_ESS_PO_R INTO @if_seq

		
		WHILE(@@FETCH_STATUS = 0) 

		BEGIN

/* INF-R 적용 이전 
		--print @if_seq;
		MERGE INTO SSP_ANL_ESS_PO C
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
				,X.ERP_PO_STATUS
				,X.ERP_PO_MESSAGE
				,X.VENDOE_CODE
				,X.VENDOR_NAME
				,X.PO_CREATED_DATE
				,X.PO_END_FLAG
				,X.PO_YYYYMMDD
				,X.PO_QTY
				,X.UOM
				,X.PO_CREATE_BY
				,X.PO_CREATE_DATE
				,X.PO_UPDATE_BY
				,X.PO_UPDATE_DATE
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
			   FROM XIF_ERP_PO_INFO_R_SN X WITH(NOLOCK) 
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
		SET C.ERP_PO_STATUS = N.ERP_PO_STATUS
		  , C.VENDOR_CODE	= N.VENDOE_CODE
		  , C.VENDOR_NAME	= N.VENDOR_NAME
		  , C.PO_CREATED_DATE = N.PO_CREATED_DATE
		  , C.PO_END_FLAG	= N.PO_END_FLAG
		  , C.YYYYMMDD		= N.PO_YYYYMMDD
		  , C.PO_QTY		= N.PO_QTY
		  , C.UOM			= N.UOM
		  , C.CREATED_BY	= N.PO_CREATE_BY
		  , C.CREATION_DATE = N.PO_CREATE_DATE
		  , C.LAST_UPDATED_BY = N.PO_UPDATE_BY
		  , C.LAST_UPDATE_DATE = N.PO_UPDATE_DATE
		  , C.ATTRIBUTE1 = N.ATTRIBUTE1
		  , C.ATTRIBUTE2 = N.ATTRIBUTE2
		  , C.ATTRIBUTE3 = N.ATTRIBUTE3
		  , C.ATTRIBUTE4 = N.ATTRIBUTE4
		  , C.ATTRIBUTE5 = N.ATTRIBUTE5
		  , C.ATTRIBUTE6 = N.ATTRIBUTE6
		  , C.ATTRIBUTE7 = N.ATTRIBUTE7
		  , C.ATTRIBUTE8 = N.ATTRIBUTE8
		  , C.ATTRIBUTE9 = N.ATTRIBUTE9
		  , C.ATTRIBUTE10 = N.ATTRIBUTE10
		WHEN NOT MATCHED THEN
		INSERT ( PR_NO
				,PO_NO
				,PO_ITEM_SEQ
				,PO_ITEM_ID
				,ERP_PO_STATUS
				,VENDOR_CODE
				,VENDOR_NAME
				,PO_CREATED_dATE
				,PO_END_FLAG
				,YYYYMMDD
				,PO_QTY
				,UOM
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
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
			   )
		 VALUES (
				 N.PR_NO
				,N.PO_NO
				,N.PO_ITEM_SEQ
				,N.PO_ITEM_ID
				,N.ERP_PO_STATUS
				,N.VENDOE_CODE
				,N.VENDOR_NAME
				,N.PO_CREATED_dATE
				,N.PO_END_FLAG
				,N.PO_YYYYMMDD   
				,N.PO_QTY    
				,N.UOM   
				,N.PO_CREATE_BY
				,N.PO_CREATE_DATE
				,N.PO_UPDATE_BY
				,N.PO_UPDATE_DATE
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
		 );
*/
/* INF-R 적용 이후*/
		MERGE INTO SSP_ANL_ESS_PO C
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
				,X.ERP_PO_STATUS
				,X.ERP_PO_MESSAGE
				,ISNULL (X1.NEW_VALUE1 , X.VENDOE_CODE) AS VENDOE_CODE
				,X.VENDOR_NAME
				,X.PO_CREATED_DATE
				,X.PO_END_FLAG
				,X.PO_YYYYMMDD
				,X.PO_QTY
				,X.UOM
				,X.PO_CREATE_BY
				,X.PO_CREATE_DATE
				,X.PO_UPDATE_BY
				,X.PO_UPDATE_DATE
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
			   FROM XIF_ERP_PO_INFO_R_SN X WITH(NOLOCK) 
				LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
				ON  X1.CODETYPE = 'VENDOR_ID'
				AND X.VENDOE_CODE = X1.OLD_VALUE1
				AND X.ATTRIBUTE5 = '1ST'
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
		SET C.ERP_PO_STATUS = N.ERP_PO_STATUS
		  , C.VENDOR_CODE	= N.VENDOE_CODE
		  , C.VENDOR_NAME	= N.VENDOR_NAME
		  , C.PO_CREATED_DATE = N.PO_CREATED_DATE
		  , C.PO_END_FLAG	= N.PO_END_FLAG
		  , C.YYYYMMDD		= N.PO_YYYYMMDD
		  , C.PO_QTY		= N.PO_QTY
		  , C.UOM			= N.UOM
		  , C.CREATED_BY	= N.PO_CREATE_BY
		  , C.CREATION_DATE = N.PO_CREATE_DATE
		  , C.LAST_UPDATED_BY = N.PO_UPDATE_BY
		  , C.LAST_UPDATE_DATE = N.PO_UPDATE_DATE
		  , C.ATTRIBUTE1 = N.ATTRIBUTE1
		  , C.ATTRIBUTE2 = N.ATTRIBUTE2
		  , C.ATTRIBUTE3 = N.ATTRIBUTE3
		  , C.ATTRIBUTE4 = N.ATTRIBUTE4
		  , C.ATTRIBUTE5 = N.ATTRIBUTE5
		  , C.ATTRIBUTE6 = N.ATTRIBUTE6
		  , C.ATTRIBUTE7 = N.ATTRIBUTE7
		  , C.ATTRIBUTE8 = N.ATTRIBUTE8
		  , C.ATTRIBUTE9 = N.ATTRIBUTE9
		  , C.ATTRIBUTE10 = N.ATTRIBUTE10
		WHEN NOT MATCHED THEN
		INSERT ( PR_NO
				,PO_NO
				,PO_ITEM_SEQ
				,PO_ITEM_ID
				,ERP_PO_STATUS
				,VENDOR_CODE
				,VENDOR_NAME
				,PO_CREATED_dATE
				,PO_END_FLAG
				,YYYYMMDD
				,PO_QTY
				,UOM
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
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
			   )
		 VALUES (
				 N.PR_NO
				,N.PO_NO
				,N.PO_ITEM_SEQ
				,N.PO_ITEM_ID
				,N.ERP_PO_STATUS
				,N.VENDOE_CODE
				,N.VENDOR_NAME
				,N.PO_CREATED_dATE
				,N.PO_END_FLAG
				,N.PO_YYYYMMDD   
				,N.PO_QTY    
				,N.UOM   
				,N.PO_CREATE_BY
				,N.PO_CREATE_DATE
				,N.PO_UPDATE_BY
				,N.PO_UPDATE_DATE
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
		 );


		FETCH NEXT FROM CUR_ESS_PO_R INTO @if_seq; 
	
		END; 

		CLOSE CUR_ESS_PO_R; 
		DEALLOCATE CUR_ESS_PO_R;

		-- 인터페이스 테이블 처리 완료 UPDATE
		UPDATE XIF_ERP_PO_INFO_R_SN 
		SET    PROC_FLAG             = 'Y'
		,      PROC_DATE             = GETDATE()   
		,      PROC_MSG              = 'S'
		WHERE  ISNULL(PROC_FLAG,'N') = 'P'
		;


		-- IF data  삭제 (30일 이전 데이터 삭제) 
		DELETE  
		FROM  XIF_ERP_PO_INFO_R_SN 
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

			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_ESS_PO_R')
				BEGIN
				   CLOSE CUR_ESS_PO_R ;
				   DEALLOCATE CUR_ESS_PO_R ;
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


