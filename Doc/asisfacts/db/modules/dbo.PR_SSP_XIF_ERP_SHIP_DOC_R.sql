
/*
 * Program ID   : PR_SSP_XIF_ERP_SHIP_DOC_R
 * Description  : 출하계획 수신
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/30   PJS            Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2022/03/01   SSP Pjt.       ERP Doc Update
 * 2022/03/21   KIMYONGHO      인터페이스 항목 추가    ( 발행된 문서에 대한 수량, Shipment id 변경 여부 확인 필요)
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_ERP_SHIP_DOC_R]
     @I_IFGB         AS NVARCHAR(1)
    ,@ZSDESSP_0020S  AS DBO.ZSDESSP_0020S       READONLY
AS
BEGIN

SET NOCOUNT ON;

		-- LOG 용 변수 설정
		DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_ERP_SHIP_DOC_R';
		DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @n_log_count    INTEGER = 0;
		DECLARE @v_log_message  NVARCHAR(1000);
		DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
		DECLARE @v_table_id     NVARCHAR(150) = N'XIF_ERP_SHIP_DOC_R_SN'; -- ▶ 테이블 필수
		DECLARE @d_event_date   DATETIME;

		DECLARE @IFSEQNO				NVARCHAR(14)	= '';
        DECLARE @TRANSFER_DATE			DATETIME        = GETDATE();    
        DECLARE @TRANSFER_FLAG			NVARCHAR(50)	= 'N';

        DECLARE @E_TYPE					NVARCHAR(50)	= N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE				NVARCHAR(100)	= N'SUCCESS';
		DECLARE @v_batch_user           nvarchar(50)	= N'ssp_batch';

		

		DECLARE @XIF_ERP_SHIP_DOC_R		TABLE
		(
			[IFSEQNO]					[nchar](14) NOT NULL,
			[CONFIRM_ID]				[nvarchar](20) NOT NULL,
			[DOC_TYPE]					[nvarchar](1) NULL,
			[DOC_NO]					[nvarchar](10) NULL,
			[ITEM_NO]					[nvarchar](6) NULL,
			--인터페이스 항목 추가--
			[SO_ITEM_QTY]				[numeric](20, 10) NULL,
			[DO_NO]						[nvarchar](10) NULL,
			[DO_ITEM_NO]				[nvarchar](6) NULL,
			[DO_ITEM_QTY]				[numeric](20, 10) NULL,
			[SHIPMENT_NO]				[nvarchar](10) NULL,
			[ATTRIBUTE1]				[nvarchar](150) NULL,
			[ATTRIBUTE2]				[nvarchar](150) NULL,
			[ATTRIBUTE3]				[nvarchar](150) NULL,
			[ATTRIBUTE4]				[nvarchar](150) NULL,
			[ATTRIBUTE5]				[nvarchar](150) NULL,
			[ATTRIBUTE6]				[nvarchar](150) NULL,
			[ATTRIBUTE7]				[nvarchar](150) NULL,
			[ATTRIBUTE8]				[nvarchar](150) NULL,
			[ATTRIBUTE9]				[nvarchar](150) NULL,
			[ATTRIBUTE10]				[nvarchar](150) NULL,
			-- 추가 끝 --
			[TRANSFER_FLAG]				[nvarchar](1) NULL,
			[TRANSFER_DATE]				[datetime] NULL,
			[CREATED_BY]				[nvarchar](150) NULL,
			[CREATION_DATE]				[datetime] NULL,
			[LAST_UPDATED_BY]			[nvarchar](150) NULL,
			[LAST_UPDATE_DATE]			[datetime] NULL
		)

		-- 시작 LOG
		SET @v_log_type = N'START';
		SET @v_log_message = N'########## Start of procedure ##########';
		SET @v_description = @v_program_name + ':' + N' PR_SSP_XIF_ERP_SHIP_DOC_R';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
								  ,@p_log_type      =@v_log_type
								  ,@p_log_count     =@n_log_count 
								  ,@p_log_message   =@v_log_message 
								  ,@p_description   =@v_description 
								  ,@p_event_date    =@d_event_date 
								  ,@p_user_id       =@v_batch_user
                              ;

		-- PK IFSEQNO 생성
		--SELECT @IFSEQNO = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss')
		SELECT @IFSEQNO = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '000000'+ CONVERT(nvarchar,NEXT VALUE FOR DBO.SEQ1_XIF_ERP_IFSEQNO) ,6)

        BEGIN TRY
			--BEGIN TRAN
               
			INSERT INTO @XIF_ERP_SHIP_DOC_R
					   ([IFSEQNO]
					   ,[CONFIRM_ID]
					   ,[DOC_TYPE]
					   ,[DOC_NO]
					   ,[ITEM_NO]
					   ,[SO_ITEM_QTY]
					   ,[DO_NO]		
					   ,[DO_ITEM_NO]
					   ,[DO_ITEM_QTY]
					   ,[SHIPMENT_NO]
					   ,[ATTRIBUTE1]
					   ,[ATTRIBUTE2]
					   ,[ATTRIBUTE3]
					   ,[ATTRIBUTE4]
					   ,[ATTRIBUTE5]
					   ,[ATTRIBUTE6]
					   ,[ATTRIBUTE7]
					   ,[ATTRIBUTE8]
					   ,[ATTRIBUTE9]
					   ,[ATTRIBUTE10]
					   ,[TRANSFER_FLAG]
					   ,[TRANSFER_DATE]
					   ,[CREATED_BY]
					   ,[CREATION_DATE]
					   ,[LAST_UPDATED_BY]
					   ,[LAST_UPDATE_DATE]
					   )
				 SELECT @IFSEQNO
				       ,CONFIRM_ID
					   ,@I_IFGB
					   ,VBELN
					   ,POSNR
					   ,KWMENG
					   ,VBELN1
					   ,POSNR1
					   ,LFIMG
					   ,TKNUM
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
					   ,@TRANSFER_FLAG	AS TRANSFER_FLAG
					   ,@TRANSFER_DATE	AS TRANSFER_DATE
					   ,'interface'		AS CREATED_BY
					   ,@TRANSFER_DATE	AS CREATION_DATE
					   ,'interface'		AS LAST_UPDATED_BY
					   ,@TRANSFER_DATE	AS LAST_UPDATE_DATE
				   FROM @ZSDESSP_0020S ;


			INSERT INTO [dbo].[XIF_ERP_SHIP_DOC_R_SN]
					   ([IFSEQNO]
					   ,[CONFIRM_ID]
					   ,[DOC_TYPE]
					   ,[DOC_NO]
					   ,[ITEM_NO]
					   ,[SO_ITEM_QTY]
					   ,[DO_NO]		
					   ,[DO_ITEM_NO]
					   ,[DO_ITEM_QTY]
					   ,[SHIPMENT_NO]
					   ,[ATTRIBUTE1]
					   ,[ATTRIBUTE2]
					   ,[ATTRIBUTE3]
					   ,[ATTRIBUTE4]
					   ,[ATTRIBUTE5]
					   ,[ATTRIBUTE6]
					   ,[ATTRIBUTE7]
					   ,[ATTRIBUTE8]
					   ,[ATTRIBUTE9]
					   ,[ATTRIBUTE10]
					   ,[TRANSFER_FLAG]
					   ,[TRANSFER_DATE]
					   ,[CREATED_BY]
					   ,[CREATION_DATE]
					   ,[LAST_UPDATED_BY]
					   ,[LAST_UPDATE_DATE]
					   )
				 SELECT
					    [IFSEQNO]
					   ,[CONFIRM_ID]
					   ,[DOC_TYPE]
					   ,[DOC_NO]
					   ,[ITEM_NO]
					   ,[SO_ITEM_QTY]
					   ,[DO_NO]		
					   ,[DO_ITEM_NO]
					   ,[DO_ITEM_QTY]
					   ,[SHIPMENT_NO]
					   ,[ATTRIBUTE1]
					   ,[ATTRIBUTE2]
					   ,[ATTRIBUTE3]
					   ,[ATTRIBUTE4]
					   ,[ATTRIBUTE5]
					   ,[ATTRIBUTE6]
					   ,[ATTRIBUTE7]
					   ,[ATTRIBUTE8]
					   ,[ATTRIBUTE9]
					   ,[ATTRIBUTE10]
					   ,[TRANSFER_FLAG]
					   ,[TRANSFER_DATE]
					   ,[CREATED_BY]
					   ,[CREATION_DATE]
					   ,[LAST_UPDATED_BY]
					   ,[LAST_UPDATE_DATE]
			       FROM @XIF_ERP_SHIP_DOC_R  
				   ;

			IF @I_IFGB IN ('A', 'B')  --SO 
			BEGIN
				MERGE INTO [dbo].[SSP_ANL_SHIP_ERP_SO] AS M
				USING @XIF_ERP_SHIP_DOC_R AS T
				   ON M.[CONFIRM_ID]		= T.[CONFIRM_ID]	
				  AND M.[SO_NO]			    = T.[DOC_NO]	
				  AND M.[SO_ITEM_NO]        = T.[ITEM_NO]
				WHEN MATCHED THEN
					UPDATE 
					   SET [SO_ITEM_QTY]        = T.[SO_ITEM_QTY]
					      ,[SO_VALID_YN]        = CASE WHEN @I_IFGB = 'A' THEN 'Y' ELSE 'N' END
						  ,LAST_UPDATED_BY		= @v_batch_user
						  ,LAST_UPDATE_DATE		= GETDATE()	
					      ,[ATTRIBUTE1]         = T.[ATTRIBUTE1]     
					      ,[ATTRIBUTE2]			= T.[ATTRIBUTE2]		
					      ,[ATTRIBUTE3]			= T.[ATTRIBUTE3]		
					      ,[ATTRIBUTE4]			= T.[ATTRIBUTE4]		
					      ,[ATTRIBUTE5]			= T.[ATTRIBUTE5]		
					      ,[ATTRIBUTE6]			= T.[ATTRIBUTE6]		
					      ,[ATTRIBUTE7]			= T.[ATTRIBUTE7]		
					      ,[ATTRIBUTE8]			= T.[ATTRIBUTE8]		
					      ,[ATTRIBUTE9]			= T.[ATTRIBUTE9]		
					      ,[ATTRIBUTE10] 		= T.[ATTRIBUTE10] 	
				WHEN NOT MATCHED THEN
					INSERT 	
						  ([CONFIRM_ID]
						  ,[SO_NO]
						  ,[SO_ITEM_NO]
						  ,[SO_ITEM_QTY]
						  ,[SO_VALID_YN]
						  ,[CREATED_BY]
						  ,[CREATION_DATE]
						  ,[LAST_UPDATED_BY]
						  ,[LAST_UPDATE_DATE]
					      ,[ATTRIBUTE1]
					      ,[ATTRIBUTE2]
					      ,[ATTRIBUTE3]
					      ,[ATTRIBUTE4]
					      ,[ATTRIBUTE5]
					      ,[ATTRIBUTE6]
					      ,[ATTRIBUTE7]
					      ,[ATTRIBUTE8]
					      ,[ATTRIBUTE9]
					      ,[ATTRIBUTE10]
						  )
				    VALUES 
						  (T.[CONFIRM_ID]
						  ,T.[DOC_NO]
						  ,T.[ITEM_NO]
						  ,T.[SO_ITEM_QTY]
						  ,CASE WHEN @I_IFGB = 'A' THEN 'Y' ELSE 'N' END
						  ,@v_batch_user      
						  ,GETDATE()          
						  ,@v_batch_user      
						  ,GETDATE()  
					      ,T.[ATTRIBUTE1]
					      ,T.[ATTRIBUTE2]
					      ,T.[ATTRIBUTE3]
					      ,T.[ATTRIBUTE4]
					      ,T.[ATTRIBUTE5]
					      ,T.[ATTRIBUTE6]
					      ,T.[ATTRIBUTE7]
					      ,T.[ATTRIBUTE8]
					      ,T.[ATTRIBUTE9]
					      ,T.[ATTRIBUTE10]
						  );

			END
			ELSE IF @I_IFGB IN ('C', 'D') --DO 
			BEGIN
				MERGE INTO [dbo].[SSP_ANL_SHIP_ERP_DO] AS M
				USING @XIF_ERP_SHIP_DOC_R AS T
				   ON M.[CONFIRM_ID]		= T.[CONFIRM_ID]	
				  AND M.[SO_NO]			    = T.[DOC_NO]	
				  AND M.[SO_ITEM_NO]        = T.[ITEM_NO]
				  AND M.[DO_NO]				= T.[DO_NO]	
				  AND M.[DO_ITEM_NO]        = T.[DO_ITEM_NO]
				WHEN MATCHED THEN
					UPDATE 
					   SET [DO_ITEM_QTY]        = T.[DO_ITEM_QTY]
					      ,[DO_VALID_YN]		= CASE WHEN @I_IFGB = 'C' THEN 'Y' ELSE 'N' END
						  ,[SHIPMENT_NO]        = T.[SHIPMENT_NO]
						  ,[LAST_UPDATED_BY]	= @v_batch_user
						  ,[LAST_UPDATE_DATE]	= GETDATE()	
					      ,[ATTRIBUTE1]         = T.[ATTRIBUTE1]     
					      ,[ATTRIBUTE2]			= T.[ATTRIBUTE2]		
					      ,[ATTRIBUTE3]			= T.[ATTRIBUTE3]		
					      ,[ATTRIBUTE4]			= T.[ATTRIBUTE4]		
					      ,[ATTRIBUTE5]			= T.[ATTRIBUTE5]		
					      ,[ATTRIBUTE6]			= T.[ATTRIBUTE6]		
					      ,[ATTRIBUTE7]			= T.[ATTRIBUTE7]		
					      ,[ATTRIBUTE8]			= T.[ATTRIBUTE8]		
					      ,[ATTRIBUTE9]			= T.[ATTRIBUTE9]		
					      ,[ATTRIBUTE10] 		= T.[ATTRIBUTE10] 
				WHEN NOT MATCHED THEN
					INSERT 	
						  ([CONFIRM_ID]
						  ,SO_NO
						  ,SO_ITEM_NO
						  ,[DO_NO]
						  ,[DO_ITEM_NO]
						  ,[DO_ITEM_QTY]
						  ,[DO_VALID_YN]
						  ,[SHIPMENT_NO]
						  ,[CREATED_BY]
						  ,[CREATION_DATE]
						  ,[LAST_UPDATED_BY]
						  ,[LAST_UPDATE_DATE]
					      ,[ATTRIBUTE1]
					      ,[ATTRIBUTE2]
					      ,[ATTRIBUTE3]
					      ,[ATTRIBUTE4]
					      ,[ATTRIBUTE5]
					      ,[ATTRIBUTE6]
					      ,[ATTRIBUTE7]
					      ,[ATTRIBUTE8]
					      ,[ATTRIBUTE9]
					      ,[ATTRIBUTE10]
						  )
				    VALUES 
						  (T.[CONFIRM_ID]
						  ,T.DOC_NO
						  ,T.ITEM_NO
						  ,T.[DO_NO]
						  ,T.[DO_ITEM_NO]
						  ,T.[DO_ITEM_QTY]
						  ,CASE WHEN @I_IFGB = 'C' THEN 'Y' ELSE 'N' END
						  ,T.[SHIPMENT_NO]
						  ,@v_batch_user      
						  ,GETDATE()          
						  ,@v_batch_user      
						  ,GETDATE() 
					      ,T.[ATTRIBUTE1]
					      ,T.[ATTRIBUTE2]
					      ,T.[ATTRIBUTE3]
					      ,T.[ATTRIBUTE4]
					      ,T.[ATTRIBUTE5]
					      ,T.[ATTRIBUTE6]
					      ,T.[ATTRIBUTE7]
					      ,T.[ATTRIBUTE8]
					      ,T.[ATTRIBUTE9]
					      ,T.[ATTRIBUTE10]						  
						  );

				-- SSP_ANL_SHIP_ERP_SO 테이블에 없을 경우 Insert : 3자거래, 4자거래 대응
				MERGE INTO [dbo].[SSP_ANL_SHIP_ERP_SO] AS M
				USING @XIF_ERP_SHIP_DOC_R AS T
				   ON M.[CONFIRM_ID]		= T.[CONFIRM_ID]	
				  AND M.[SO_NO]			    = T.[DOC_NO]	
				  AND M.[SO_ITEM_NO]        = T.[ITEM_NO]
				WHEN NOT MATCHED THEN
					INSERT 	
						  ([CONFIRM_ID]
						  ,[SO_NO]
						  ,[SO_ITEM_NO]
						  ,[SO_ITEM_QTY]
						  ,[SO_VALID_YN]
						  ,[CREATED_BY]
						  ,[CREATION_DATE]
						  ,[LAST_UPDATED_BY]
						  ,[LAST_UPDATE_DATE]
					      ,[ATTRIBUTE1]
					      ,[ATTRIBUTE2]
					      ,[ATTRIBUTE3]
					      ,[ATTRIBUTE4]
					      ,[ATTRIBUTE5]
					      ,[ATTRIBUTE6]
					      ,[ATTRIBUTE7]
					      ,[ATTRIBUTE8]
					      ,[ATTRIBUTE9]
					      ,[ATTRIBUTE10]
						  )
				    VALUES 
						  (T.[CONFIRM_ID]
						  ,T.[DOC_NO]
						  ,T.[ITEM_NO]
						  ,T.[SO_ITEM_QTY]
						  ,'Y' 
						  ,@v_batch_user      
						  ,GETDATE()          
						  ,@v_batch_user      
						  ,GETDATE()      
					      ,T.[ATTRIBUTE1]
					      ,T.[ATTRIBUTE2]
					      ,T.[ATTRIBUTE3]
					      ,T.[ATTRIBUTE4]
					      ,T.[ATTRIBUTE5]
					      ,T.[ATTRIBUTE6]
					      ,T.[ATTRIBUTE7]
					      ,T.[ATTRIBUTE8]
					      ,T.[ATTRIBUTE9]
					      ,T.[ATTRIBUTE10]							  
						  );
			END

			--COMMIT TRAN;
        END TRY

        BEGIN CATCH
			--ROLLBACK TRAN;

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

			--PRINT ERROR_MESSAGE();
			SET @E_TYPE = 'E';
			SET @E_MESSAGE = ERROR_MESSAGE();
        END CATCH 
		

		-- 종료 LOG
		SET @v_log_type = N'END';
		SET @v_log_message = N'########## END of procedure ##########';
		SET @v_description = NULL;
		SET @d_event_date = SYSDATETIME()  ;
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
								  ,@p_log_type      =@v_log_type
								  ,@p_log_count     =@n_log_count 
								  ,@p_log_message   =@v_log_message 
								  ,@p_description   =@v_description 
								  ,@p_event_date    =@d_event_date 
								  ,@p_user_id       =@v_batch_user
								  ;

        SELECT @E_TYPE AS E_TYPE, @E_MESSAGE AS E_MESSAGE

        SET NOCOUNT OFF

END


