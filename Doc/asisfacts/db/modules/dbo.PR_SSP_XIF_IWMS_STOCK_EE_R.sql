
/*
 * Program ID   : [PR_SSP_XIF_IWMS_STOCK_EE_R]  
 * Description  : IWMS 재고 정보 I/F 수신 반영(Every 1 Hour) 
 * OutTable     : XIF_IWMS_STOCK_EE_R_SN --> SSP_DNM_IWMS_STOCK_EE 
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.05.11   LJH         Initial Release [PJ20199555]공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 
 * 2021.03.03   KBK         데이터 수신 체크 로직 추가
 * 2024.06.10   jilee       SSP_DNM_IWMS_STOCK_EE data  삭제 (3개월  이전 데이터 삭제) 
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_IWMS_STOCK_EE_R]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
--    SET     @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_IWMS_STOCK_EE_R';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_DNM_IWMS_STOCK_EE'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_DNM_IWMS_STOCK_EE INSERT LOGIC';
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

	-- DECLARE @v_master_if_seq  NVARCHAR(MAX) = '';
	DECLARE @v_count          INT  = 0 ;
    DECLARE @v_cnt            INT  = 0 ;

    BEGIN TRY
      BEGIN
       BEGIN TRAN TX_SH

		DECLARE @stock_cnt INTEGER, 
			    @company_id VARCHAR(30),  
				@group_seq VARCHAR(30)

		DECLARE @idx INT     SET     @idx = 0  
 

		-- COMPANY 별 I/F 건수와 전송 대상 건수 체크 : 2021.02,04
		DECLARE CUR_IWMS_STOCK CURSOR FOR  
		SELECT SUM(A.CHECK_CNT) AS STOCK_CNT
		     , A.COMPANY_ID
		     , A.GROUP_SEQ
		FROM   (
				SELECT CASE WHEN B.IF_CNT = 0 THEN 0
							WHEN B.IF_CNT IS NULL THEN 1
						ELSE 
							CASE WHEN A.IF_CNT <> B.IF_CNT THEN 1
							ELSE 0 END 
						END   AS CHECK_CNT
						, A.COMPANY_ID
						, A.COMPANY_ID + SUBSTRING(A.GROUP_SEQ, 1, 8)  AS GROUP_SEQ
				FROM   (
						SELECT A.ATTRIBUTE5  AS COMPANY_ID
							 --, A.ATTRIBUTE7  AS GROUP_SEQ
							 , CONVERT(CHAR(8), GETDATE(), 112)  AS GROUP_SEQ
							 , COUNT(*)  AS IF_CNT
						FROM   XIF_IWMS_STOCK_EE_R_SN  A WITH(NOLOCK)
						WHERE  1 = 1
						AND    ISNULL(A.PROC_FLAG,'N') = 'N'
						AND    A.IF_SEQ LIKE '%' + CONVERT(CHAR(6), GETDATE(), 12) + '%'
						AND    CONVERT(CHAR(8), A.IF_RCV_DATE, 112) = CONVERT(CHAR(8), GETDATE(), 112)
						GROUP BY A.ATTRIBUTE5
							   --, A.ATTRIBUTE7
						) A
						LEFT OUTER JOIN (
						SELECT A.COMPANY_ID, A.GROUP_SEQ, SUM(IF_CNT) AS IF_CNT
						FROM   (
								SELECT A.ATTRIBUTE5  AS COMPANY_ID
									 --, A.ATTRIBUTE7  AS GROUP_SEQ
									 , CONVERT(CHAR(8), GETDATE(), 112)  AS GROUP_SEQ
									 , CONVERT(INT, A.ATTRIBUTE6)  AS IF_CNT
								FROM   XIF_IWMS_STOCK_EE_R_SN  A WITH(NOLOCK)
								WHERE  1 = 1
								AND    ISNULL(A.PROC_FLAG,'N') = 'N'
								AND    A.IF_SEQ LIKE '%' + CONVERT(CHAR(6), GETDATE(), 12) + '%'
								AND    CONVERT(CHAR(8), A.IF_RCV_DATE, 112) = CONVERT(CHAR(8), GETDATE(), 112)
								GROUP BY A.ATTRIBUTE5
										, A.ATTRIBUTE6
										--, A.ATTRIBUTE7
								) A
						WHERE  1 = 1
						GROUP BY A.COMPANY_ID
							   , A.GROUP_SEQ
						) B
						ON   A.COMPANY_ID = B.COMPANY_ID
						AND  A.GROUP_SEQ  = B.GROUP_SEQ
				WHERE  1 = 1
			   ) A
		WHERE  1 = 1
		GROUP BY A.COMPANY_ID, A.GROUP_SEQ
		;

		OPEN CUR_IWMS_STOCK; 

		FETCH NEXT FROM CUR_IWMS_STOCK INTO @stock_cnt, 
			                            @company_id,
										@group_seq

		WHILE(@@FETCH_STATUS = 0) 
		BEGIN

			-- COMPANY별 수행여부 체크
			SELECT @v_count = COUNT(*)
			FROM   SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
			WHERE  1 = 1
			AND    A.LOOKUP_TYPE = 'IF_STOCK_CHECK'
			AND    A.SEGMENT1 = 'PLAN_EE'
			AND    A.SEGMENT2 = 'IWMS'
			AND    A.SEGMENT3 = 'EE'
			AND    A.SEGMENT4 = @company_id
			AND    A.SEGMENT5 = CONVERT(CHAR(8), GETDATE(), 112)
			AND    A.ATTRIBUTE1 = 'Y'
			;

			IF @stock_cnt = 0 AND @v_count = 0
			BEGIN
				UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
				SET    SEGMENT5 = CONVERT(CHAR(8), GETDATE(), 112)
						, ATTRIBUTE1 = 'N'
				WHERE  1 = 1
				AND    LOOKUP_TYPE = 'IF_STOCK_CHECK'
				AND    SEGMENT1 = 'PLAN_EE'
				AND    SEGMENT2 = 'IWMS'
				AND    SEGMENT3 = 'EE'
				AND    SEGMENT4 = @company_id
				--AND    SEGMENT5 = CONVERT(CHAR(8), GETDATE(), 112)
				--AND    ATTRIBUTE1 = 'N'
				;

				--CURSOR 선언 
				DECLARE @if_seq VARCHAR(MAX)
 

				DECLARE CUR_IWMS_R CURSOR FOR  
				SELECT IF_SEQ
				FROM   XIF_IWMS_STOCK_EE_R_SN WITH(NOLOCK) 
				WHERE  ISNULL(PROC_FLAG,'N') = 'N' 
				AND    ATTRIBUTE5 = @company_id
				AND    ATTRIBUTE6 <> '0'
				ORDER BY IF_SEQ
				;


				OPEN CUR_IWMS_R; 

				FETCH NEXT FROM CUR_IWMS_R INTO @if_seq

				WHILE(@@FETCH_STATUS = 0) 

				BEGIN

					-- 인터페이스 테이블 처리 ROW UPDATE
					UPDATE XIF_IWMS_STOCK_EE_R_SN 
					SET    PROC_FLAG             = 'P'
					WHERE  ISNULL(PROC_FLAG,'N') = 'N'
					AND    IF_SEQ = @if_seq
					AND    ATTRIBUTE5 = @company_id
					;  

					MERGE INTO SSP_DNM_IWMS_STOCK_EE M
					USING
					(
					SELECT
					 S.DIVISION_ID         AS DIVISION_ID      
					,S.COMPANY_ID          AS COMPANY_ID       
					,S.SCM_SITE_ID         AS FROM_SITE        
					,CONVERT(CHAR(8), CONVERT(DATETIME, X.ATTRIBUTE8) + 1, 112) AS YYYYMMDD         
					,X.ITEM_ID             AS ITEM_ID          
					,X.PALLET_ID           AS PALLET_ID        
					,X.LOT_ID              AS LOT_ID           
					,X.PLANT_ID            AS PLANT_ID         
					,X.GOOD_RECEIVE_DATE   AS GOOD_RECEIVE_DATE
					,X.STOCK_QTY           AS STOCK_QTY        
					,X.EXPIRATION_DATE     AS EXPIRATION_DATE  
					,X.ELECTRODE_VERSION   AS ELECTRODE_VERSION
					,X.HOLD                AS HOLD             
					,X.HOLD_DATE           AS HOLD_DATE        
					,X.STORAGE             AS STORAGE          
					,X.ERP_SLOC_ID         AS ERP_SLOC_ID     
					,X.STOCK_TYPE          AS STOCK_TYPE       
					,X.BL_NO               AS BL_NO            
					,X.PO_NO               AS PO_NO            
					,X.PACKING_STATUS      AS PACKING_STATUS   
					,X.IF_ID               AS CREATED_BY       
					,X.CREATION_DATE       AS CREATION_DATE    
					,X.IF_ID               AS LAST_UPDATED_BY  
					,X.IF_RCV_DATE         AS LAST_UPDATE_DATE 
					,X.ATTRIBUTE1          AS ATTRIBUTE1       
					,X.ATTRIBUTE2          AS ATTRIBUTE2       
					,X.ATTRIBUTE3          AS ATTRIBUTE3       
					,X.ATTRIBUTE4          AS ATTRIBUTE4       
					,X.ATTRIBUTE5          AS ATTRIBUTE5       
					,X.ATTRIBUTE6          AS ATTRIBUTE6       
					,X.ATTRIBUTE7          AS ATTRIBUTE7       
					,X.ATTRIBUTE8          AS ATTRIBUTE8       
					,X.ATTRIBUTE9          AS ATTRIBUTE9       
					,X.ATTRIBUTE10         AS ATTRIBUTE10      
					FROM XIF_IWMS_STOCK_EE_R_SN X WITH(NOLOCK) 
						JOIN SCM_MST_SITE S WITH(NOLOCK) 
							ON S.PLANT_ID = X.PLANT_ID 
						   AND S.SITE_TYPE = 'PLANT'
						   AND S.OPERATION_GROUP = 'A'
						   AND S.OSP_YN = 'N'
					WHERE ISNULL(X.PROC_FLAG,'N') = 'P' 
					AND   X.IF_SEQ = @if_seq
					) F
					 ON F.DIVISION_ID   = M.DIVISION_ID       
					AND F.COMPANY_ID    = M.COMPANY_ID       
					AND F.FROM_SITE     = M.FROM_SITE      
					AND F.YYYYMMDD      = M.YYYYMMDD         
					AND F.PLANT_ID      = M.PLANT_ID         
					AND F.LOT_ID        = M.LOT_ID            
					AND F.ITEM_ID       = M.ITEM_ID         
					WHEN MATCHED THEN
					UPDATE
					SET
					  M.GOOD_RECEIVE_DATE = F.GOOD_RECEIVE_DATE
					, M.STOCK_QTY         = F.STOCK_QTY        
					, M.EXPIRATION_DATE   = F.EXPIRATION_DATE  
					, M.ELECTRODE_VERSION = F.ELECTRODE_VERSION
					, M.HOLD              = F.HOLD             
					, M.HOLD_DATE         = F.HOLD_DATE        
					, M.STORAGE           = F.STORAGE          
					, M.ERP_SLOC_ID       = F.ERP_SLOC_ID     
					, M.STOCK_TYPE        = F.STOCK_TYPE       
					, M.BL_NO             = F.BL_NO            
					, M.PO_NO             = F.PO_NO            
					, M.PACKING_STATUS    = F.PACKING_STATUS   
					, M.CREATED_BY        = F.CREATED_BY       
					, M.CREATION_DATE     = F.CREATION_DATE    
					, M.LAST_UPDATED_BY   = F.LAST_UPDATED_BY  
					, M.LAST_UPDATE_DATE  = F.LAST_UPDATE_DATE 
					, M.ATTRIBUTE1        = F.ATTRIBUTE1       
					, M.ATTRIBUTE2        = F.ATTRIBUTE2       
					, M.ATTRIBUTE3        = F.ATTRIBUTE3       
					, M.ATTRIBUTE4        = F.ATTRIBUTE4       
					, M.ATTRIBUTE5        = F.ATTRIBUTE5       
					, M.ATTRIBUTE6        = F.ATTRIBUTE6       
					, M.ATTRIBUTE7        = F.ATTRIBUTE7       
					, M.ATTRIBUTE8        = F.ATTRIBUTE8       
					, M.ATTRIBUTE9        = F.ATTRIBUTE9       
					, M.ATTRIBUTE10       = F.ATTRIBUTE10    
					WHEN NOT MATCHED THEN INSERT (
					 DIVISION_ID
					,COMPANY_ID
					,FROM_SITE
					,YYYYMMDD
					,ITEM_ID
					,PALLET_ID
					,LOT_ID
					,PLANT_ID
					,GOOD_RECEIVE_DATE
					,STOCK_QTY
					,EXPIRATION_DATE
					,ELECTRODE_VERSION
					,HOLD
					,HOLD_DATE
					,STORAGE
					,ERP_SLOC_ID
					,STOCK_TYPE
					,BL_NO
					,PO_NO
					,PACKING_STATUS
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
					 F.DIVISION_ID
					,F.COMPANY_ID
					,F.FROM_SITE
					,F.YYYYMMDD
					,F.ITEM_ID
					,F.PALLET_ID
					,F.LOT_ID
					,F.PLANT_ID
					,F.GOOD_RECEIVE_DATE
					,F.STOCK_QTY
					,F.EXPIRATION_DATE
					,F.ELECTRODE_VERSION
					,F.HOLD
					,F.HOLD_DATE
					,F.STORAGE
					,F.ERP_SLOC_ID
					,F.STOCK_TYPE
					,F.BL_NO
					,F.PO_NO
					,F.PACKING_STATUS
					,F.CREATED_BY
					,F.CREATION_DATE
					,F.LAST_UPDATED_BY
					,F.LAST_UPDATE_DATE
					,F.ATTRIBUTE1
					,F.ATTRIBUTE2
					,F.ATTRIBUTE3
					,F.ATTRIBUTE4
					,F.ATTRIBUTE5
					,F.ATTRIBUTE6
					,F.ATTRIBUTE7
					,F.ATTRIBUTE8
					,F.ATTRIBUTE9
					,F.ATTRIBUTE10
					)
					;

					FETCH NEXT FROM CUR_IWMS_R INTO @if_seq  ; 

				END ;

				CLOSE CUR_IWMS_R; 
				DEALLOCATE CUR_IWMS_R;

				-- 인터페이스 테이블 처리 완료 UPDATE
				UPDATE XIF_IWMS_STOCK_EE_R_SN 
				SET    PROC_FLAG             = 'Y'
				,      PROC_DATE             = GETDATE()   
				,      PROC_MSG              = 'S'
				WHERE  ISNULL(PROC_FLAG,'N') = 'P'
				--AND    IF_SEQ = @if_seq
				AND    ATTRIBUTE5 = @company_id
				;  


				UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
				SET    SEGMENT5 = CONVERT(CHAR(8), GETDATE(), 112)
					 , ATTRIBUTE1 = 'Y'
					 , LAST_UPDATED_BY = @v_batch_user
					 , LAST_UPDATE_DATE = GETDATE()
				WHERE  1 = 1
				AND    LOOKUP_TYPE = 'IF_STOCK_CHECK'
				AND    SEGMENT1 = 'PLAN_EE'
				AND    SEGMENT2 = 'IWMS'
				AND    SEGMENT3 = 'EE'
				AND    SEGMENT4 = @company_id
				--AND    SEGMENT5 = CONVERT(CHAR(8), GETDATE(), 112)
				AND    ATTRIBUTE1 = 'N'
				;

			END;

			FETCH NEXT FROM CUR_IWMS_STOCK INTO @stock_cnt, 
											@company_id,
											@group_seq
		END;

		CLOSE CUR_IWMS_STOCK; 
		DEALLOCATE CUR_IWMS_STOCK;

		-- IF data  삭제 (3일 이전 데이터 삭제) 
		DELETE 
		FROM  XIF_IWMS_STOCK_EE_R_SN 
		WHERE IF_RCV_DATE < GETDATE() - 100
		;

		-- data  삭제 (3개월  이전 데이터 삭제) 
		DELETE 
		  FROM SSP_DNM_IWMS_STOCK_EE
		 WHERE YYYYMMDD < CONVERT(VARCHAR, DATEADD(M, -3, GETDATE()) ,112)
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

			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_IWMS_STOCK')
				BEGIN
				   CLOSE CUR_IWMS_STOCK ;
				   DEALLOCATE CUR_IWMS_STOCK ;
				END

			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_IWMS_R')
				BEGIN
				   CLOSE CUR_IWMS_R ;
				   DEALLOCATE CUR_IWMS_R ;
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
