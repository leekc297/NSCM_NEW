
/*
 * Program ID   : PR_SSP_XIF_ERP_SHIP_PR_R
 * Description  : 출하계획 전송결과 UPDATE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/04/22   KIMYONGHO      신규추가
 * 2024/10/01   KHJ            NERP_SSP
 *
 */

CREATE  PROCEDURE [dbo].[PR_SSP_XIF_ERP_SHIP_PR_R]
	 @RETURN_FLAG		AS NVARCHAR(MAX)
	,@RETURN_MESSAGE	AS NVARCHAR(MAX)
    ,@TAB_DISP_MM0501	AS DBO.TAB_DISP_MM0501       READONLY	                            
AS

BEGIN

SET NOCOUNT ON;
		
		DECLARE @IF_SEQ				  NVARCHAR(50) = '';
        DECLARE @TRANSFER_DATE        DATETIME      = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'Y';


		DECLARE @DM_REQ_NO			  NVARCHAR(MAX);
		DECLARE @PLAN_START_YYYYMMDD  NVARCHAR(MAX);

        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

		-- NERP 매핑코드
		DECLARE @v_C100 NVARCHAR(10);
		SET @v_C100 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_XIF_ERP_SHIP_PR_R'  ,'ESOC' );	--C100

		-- PK IFSEQNO 생성

		select @IF_SEQ = 'OERP' + CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)
		--SELECT @IF_SEQ= CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '00000'+ CONVERT(VARCHAR,ISNULL(MAX(RIGHT(IFSEQNO,6)),0)+1 ) ,6)
		FROM XIF_ERP_SHIP_DOC_R_SN WITH(NOLOCK)
		--WHERE IFSEQNO LIKE CONVERT(CHAR(8),GETDATE(),112) +'%' ;


        BEGIN TRY
			BEGIN TRAN
				INSERT INTO [dbo].[XIF_ERP_PR_REQ_R_SN]
					   ([IF_SEQ]
					   ,[IF_TYPE]
					   ,[IF_ID]
					   ,[IF_RCV_DATE]
					   ,[PROC_DATE]
					   ,[PROC_MSG]
					   ,[IFSEQNO]
					   ,[DM_REQ_NO]
					   ,[PREQ_NO]
					   ,[PREQ_ITEM]
					   ,[STATUS]
					   ,[MESSAGE]				
					   )
				 SELECT @IF_SEQ
						,'I'
						,'OSCM_OERP_PR_REQ_S'
						,@TRANSFER_DATE
						,NULL				--PROC_DATE
						,NULL				--PROC_MSG
						,IFSEQNO
						,DM_REQ_NO
						,RTRIM(PREQ_NO)
						,PREQ_ITEM
						,STATUS
						,MESSAGE	
				  FROM @TAB_DISP_MM0501 ;

				IF @RETURN_FLAG = 'S'
					BEGIN
					UPDATE A
					   SET  PR_NO			= B.PREQ_NO
						  , ERP_PR_STATUS	= B.STATUS
						  , PR_CONFIRMED_BY = 'ssp_batch'
						  , PR_CONFIRM_DATE =  CONVERT(VARCHAR(8), CONVERT(DATETIME, GETDATE() ), 112) 
					  FROM SSP_ANL_ESS_PR  AS A WITH(NOLOCK) 
						
						INNER JOIN XIF_ERP_PR_REQ_S_SN AS C WITH(NOLOCK) 
						ON A.DM_REQ_NO	  = C.DM_REQ_NO
						AND A.PR_ITEM_ID	= C.PR_ITEM_ID					 

						INNER JOIN @TAB_DISP_MM0501	AS B
						ON  B.IFSEQNO    = C.IFSEQNO
						AND B.DM_REQ_NO	 = C.DM_REQ_NO  
						--AND RIGHT('00000'+ B.PREQ_ITEM,5)  = C.ATTRIBUTE1					-- XIF_ERP_PR_REQ_S_SN 테이블 ATTRIBUTE1 항목에 ERP I/F 용 PR_ITEM_SEQ 항목 입력 하였음.
						AND  B.PREQ_ITEM = C.ATTRIBUTE1					-- XIF_ERP_PR_REQ_S_SN 테이블 ATTRIBUTE1 항목에 ERP I/F 용 PR_ITEM_SEQ 항목 입력 하였음.
					  
					  WHERE 1=1
					  --AND C.PR_CONFIRM_DATE = CONVERT(VARCHAR(8), CONVERT(DATETIME, GETDATE() ), 112) 
					  ;
					END

				
				IF @RETURN_FLAG = 'S'
					BEGIN
						
						SELECT @DM_REQ_NO = A.DM_REQ_NO
						FROM (
							SELECT DISTINCT DM_REQ_NO
							FROM @TAB_DISP_MM0501
						) A
						;

						SELECT @PLAN_START_YYYYMMDD = ATTRIBUTE1 
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL AS X WITH(NOLOCK) 
						WHERE X.LOOKUP_TYPE	= 'SSP_ANL_ESS_PLAN'
						  AND X.SEGMENT1	= '82';


						UPDATE A
						   SET  ATTRIBUTE1 = 'Complete'
						  FROM SSP_ANL_ESS_PR  AS A WITH(NOLOCK) 
							--INNER JOIN @TAB_DISP_MM0501	AS B
							--ON A.DM_REQ_NO	  = B.DM_REQ_NO  
						  WHERE 1=1
						  AND A.DM_REQ_NO IN (SELECT DISTINCT DM_REQ_NO FROM @TAB_DISP_MM0501)
						  ;

						 UPDATE A
						 SET PR_CONFIRM_FLAG = 'Y'	 
						 FROM SSP_ANL_ESS_REQ AS A WITH(NOLOCK) 
						 WHERE 1=1
						  AND A.DM_REQ_NO IN (SELECT DISTINCT DM_REQ_NO FROM @TAB_DISP_MM0501)
						 ;

						 UPDATE A
						 SET PROC_FLAG = 'Y'
						 , PROC_DATE = GETDATE()					 
						 FROM XIF_ERP_PR_REQ_R_SN AS A WITH(NOLOCK) 
							INNER JOIN @TAB_DISP_MM0501	AS B
							ON A.IFSEQNO	  = B.IFSEQNO 
						;

						--EXEC [dbo].[PR_SSP_MAIL_SEND_PR_REQUEST] @PLAN_START_YYYYMMDD, 'C100', @DM_REQ_NO, 'KO', 76	 
					    EXEC [dbo].[PR_SSP_MAIL_SEND_PR_REQUEST] @PLAN_START_YYYYMMDD,  @v_C100, @DM_REQ_NO, 'KO', 76	 

					END
				ELSE
					BEGIN
					UPDATE A
					   SET  ATTRIBUTE1 = 'PR Create Fail'
					  FROM SSP_ANL_ESS_PR  AS A WITH(NOLOCK) 
						--INNER JOIN @TAB_DISP_MM0501	AS B
						--ON A.DM_REQ_NO	  = B.DM_REQ_NO  
					  WHERE 1=1					
					   AND A.DM_REQ_NO IN (SELECT DISTINCT DM_REQ_NO FROM @TAB_DISP_MM0501)
					  ;
					END

			 COMMIT TRAN;
        END TRY

        BEGIN CATCH
               ROLLBACK TRAN;
               --PRINT ERROR_MESSAGE();
               SET @E_TYPE = 'E';
               SET @E_MESSAGE = ERROR_MESSAGE();


			   INSERT INTO scm_sys_log_batch (program_name
										  ,log_type
										  ,log_count
										  ,log_message
										  ,description
										  ,event_date
										  ,creation_date
										  ,created_by
										  ,last_update_date
										  ,last_updated_by)
				VALUES (ERROR_PROCEDURE()
					   ,'ERROR'
					   ,NULL
					   ,ERROR_MESSAGE()
					   ,NULL
					   ,SYSDATETIME()
					   ,SYSDATETIME()
					   ,ERROR_PROCEDURE()
					   ,SYSDATETIME()
					   ,ERROR_PROCEDURE());

        END CATCH      

        SELECT @E_TYPE AS E_TYPE, @E_MESSAGE AS E_MESSAGE

        SET NOCOUNT OFF

END

