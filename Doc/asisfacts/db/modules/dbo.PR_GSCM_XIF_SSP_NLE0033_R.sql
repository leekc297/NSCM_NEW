


/*
 * Program ID   : NERP_PR_GSCM_XIF_SSP_NLE0033_R
 * Description  : GERP Call Off Schedule 수신
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/24   ygkim		   Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2021.04.30   SSP Pjt.       SSP_KPI_ATR_AIR_TRANSPORT_RATE.attribute1에 ISOYYYYWW 값 적용
 * 2024.10.24   KHJ            NERP_SSP
 */

CREATE PROCEDURE [dbo].[PR_GSCM_XIF_SSP_NLE0033_R]
    @NSDESSP_0140S			AS DBO.NSDESSP_0140S       READONLY
	                            
AS

BEGIN

SET NOCOUNT ON;

        DECLARE @TRANSFER_DATE        DATETIME      = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';
	
        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_GSCM_XIF_SSP_NLE0033_R';
		DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @n_log_count    INTEGER = 0;
		DECLARE @v_log_message  NVARCHAR(1000);
		DECLARE @v_description  NVARCHAR(500);
		DECLARE @d_event_date   DATETIME;
		DECLARE @v_ifseqno      NVARCHAR(30); 
		DECLARE @n_history_seq  BIGINT;

		-- 시작 LOG
		SET @v_log_type    = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date  = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        BEGIN TRY
			BEGIN TRAN
				
				--[XIF_ERP_ATR_R_SN] INSERT
				INSERT INTO [dbo].[XIF_ERP_ATR_R_SN]
						   ( [IFSEQNO]
							,[DIVISION_ID]
							,[PLANT_ID]
							,[FROM_SITE]
							,[TO_SITE]
							,[ITEM_ID]
							,[YYYYMMDD]
							,[TOTAL_COST]
							,[AIR_COST]
							,[CURRENCY_CODE]							
							,[TRANSFER_DATE]
							,[TRANSFER_FLAG]
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
					 SELECT CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_XIF_ERP_ATR_R),6)
							,SPART
							,WERKS
							,FSITE
							,TSITE
							,MATNR
							,BUDAT						
							,WRBTR_TOT
							,WRBTR_AIR
							,WAERK
							,@TRANSFER_DATE
							,@TRANSFER_FLAG
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
					  FROM @NSDESSP_0140S ;
				 
				 --SSP_KPI_ATR_AIR_TRANSPORT_RATE DELETE
				 DELETE a FROM SSP_KPI_ATR_AIR_TRANSPORT_RATE a 
				 WHERE EXISTS(SELECT 1 FROM XIF_ERP_ATR_R_SN b WITH(NOLOCK)
							  WHERE b.YYYYMMDD = a.YYYYMMDD
								and b.TRANSFER_FLAG  = 'N'
								);
/* INF-R 적용 전 
				 --SSP_KPI_ATR_AIR_TRANSPORT_RATE INSERT
				 INSERT INTO SSP_KPI_ATR_AIR_TRANSPORT_RATE(
							 DIVISION_ID
							,PLANT_ID
							,OPERATION_GROUP
							,FROM_SITE
							,TO_SITE
							,ITEM_ID
							,YYYYMMDD
							,YYYYMM
							,WEEK_NAME
							,TOTAL_COST
							,AIR_COST
							,CURRENCY_CODE
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
					SELECT 
						 E.DIVISION_ID                  AS DIVISION_ID
						,E.PLANT_ID                     AS PLANT_ID 
						,ISNULL(FS.OPERATION_GROUP,'X') AS OPERATION_GROUP  
						,E.FROM_SITE                    AS FROM_SITE 
						,E.TO_SITE                      AS TO_SITE
						,E.ITEM_ID                      AS ITEM_ID
						,E.YYYYMMDD                     AS YYYYMMDD 
						,SUBSTRING(E.YYYYMMDD ,1,6)     AS YYYYMM
						,C.WEEK_NAME                    AS WEEK_NAME
						,SUM(E.TOTAL_COST)              AS TOTAL_COST
						,SUM(E.AIR_COST)                AS AIR_COST
						,E.CURRENCY_CODE                AS CURRENCY_CODE 
						,'ERP_I/F'                      AS CREATED_BY
						,GETDATE()                      AS CREATION_DATE
						,'ERP_I/F'                      AS LAST_UPDATED_BY
						,GETDATE()                      AS LAST_UPDATE_DATE
						,C.ISO_YYYYWW                   AS ATTRIBUTE1
						,MAX(E.ATTRIBUTE2)              AS ATTRIBUTE2 
						,MAX(E.ATTRIBUTE3)              AS ATTRIBUTE3 
						,MAX(E.ATTRIBUTE4)              AS ATTRIBUTE4 
						,MAX(E.ATTRIBUTE5)              AS ATTRIBUTE5 
						,MAX(E.ATTRIBUTE6)              AS ATTRIBUTE6 
						,MAX(E.ATTRIBUTE7)              AS ATTRIBUTE7 
						,MAX(E.ATTRIBUTE8)              AS ATTRIBUTE8 
						,MAX(E.ATTRIBUTE9)              AS ATTRIBUTE9 
						,MAX(E.ATTRIBUTE10)             AS ATTRIBUTE10
				FROM XIF_ERP_ATR_R_SN E WITH(NOLOCK) 
					JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
					ON C.BASIS_YYYYMMDD  = E.YYYYMMDD 
					LEFT JOIN SCM_KPI_ITEM_V FS WITH(NOLOCK)  
					ON FS.DIVISION_ID  =  E.DIVISION_ID  
					AND FS.ITEM_ID  = E.ITEM_ID   
               WHERE TRANSFER_FLAG  = 'N'
			   GROUP BY  E.DIVISION_ID               
						,E.PLANT_ID                  
						,FS.OPERATION_GROUP    
						,E.FROM_SITE          
						,E.TO_SITE          
						,E.ITEM_ID          
						,E.YYYYMMDD     
						,C.WEEK_NAME                
						,E.CURRENCY_CODE 
						,C.ISO_YYYYWW
				;
*/
/* INF-R 적용 후 */
				 --SSP_KPI_ATR_AIR_TRANSPORT_RATE INSERT
				 INSERT INTO SSP_KPI_ATR_AIR_TRANSPORT_RATE(
							 DIVISION_ID
							,PLANT_ID
							,OPERATION_GROUP
							,FROM_SITE
							,TO_SITE
							,ITEM_ID
							,YYYYMMDD
							,YYYYMM
							,WEEK_NAME
							,TOTAL_COST
							,AIR_COST
							,CURRENCY_CODE
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
					SELECT 
						 E.DIVISION_ID                  AS DIVISION_ID
						,E.PLANT_ID                     AS PLANT_ID 
						,ISNULL(FS.OPERATION_GROUP,'X') AS OPERATION_GROUP  
						,E.FROM_SITE                    AS FROM_SITE 
						,E.TO_SITE                      AS TO_SITE
						,E.ITEM_ID                      AS ITEM_ID
						,E.YYYYMMDD                     AS YYYYMMDD 
						,SUBSTRING(E.YYYYMMDD ,1,6)     AS YYYYMM
						,C.WEEK_NAME                    AS WEEK_NAME
						,SUM(E.TOTAL_COST)              AS TOTAL_COST
						,SUM(E.AIR_COST)                AS AIR_COST
						,E.CURRENCY_CODE                AS CURRENCY_CODE 
						,'ERP_I/F'                      AS CREATED_BY
						,GETDATE()                      AS CREATION_DATE
						,'ERP_I/F'                      AS LAST_UPDATED_BY
						,GETDATE()                      AS LAST_UPDATE_DATE
						,C.ISO_YYYYWW                   AS ATTRIBUTE1
						,MAX(E.ATTRIBUTE2)              AS ATTRIBUTE2 
						,MAX(E.ATTRIBUTE3)              AS ATTRIBUTE3 
						,MAX(E.ATTRIBUTE4)              AS ATTRIBUTE4 
						,MAX(E.ATTRIBUTE5)              AS ATTRIBUTE5 
						,MAX(E.ATTRIBUTE6)              AS ATTRIBUTE6 
						,MAX(E.ATTRIBUTE7)              AS ATTRIBUTE7 
						,MAX(E.ATTRIBUTE8)              AS ATTRIBUTE8 
						,MAX(E.ATTRIBUTE9)              AS ATTRIBUTE9 
						,MAX(E.ATTRIBUTE10)             AS ATTRIBUTE10
				FROM (
						SELECT A.DIVISION_ID
							 , ISNULL(X1.NEW_VALUE1, A.PLANT_ID) AS PLANT_ID
							 , ISNULL(X2.NEW_VALUE1, A.FROM_SITE) AS FROM_SITE
							 , ISNULL(X3.NEW_VALUE1, A.TO_SITE) AS TO_SITE
							 , A.ITEM_ID, A.YYYYMMDD, A.TOTAL_COST, A.AIR_COST, A.CURRENCY_CODE, A.TRANSFER_FLAG
							 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
							 , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
						FROM XIF_ERP_ATR_R_SN A WITH(NOLOCK) 
						LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
						ON  X1.CODETYPE = 'PLANT_ID'
						AND A.PLANT_ID = X1.OLD_VALUE1 
						LEFT OUTER JOIN  NERP_CONV_MASTER X2 WITH(NOLOCK)
						ON  X2.CODETYPE = 'PLANT_ID'
						AND A.FROM_SITE = X2.OLD_VALUE1 
						LEFT OUTER JOIN  NERP_CONV_MASTER X3 WITH(NOLOCK)
						ON  X3.CODETYPE = 'VENDOR_ID'
						AND A.TO_SITE = X3.OLD_VALUE1  	
					 ) E 
					JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
					ON C.BASIS_YYYYMMDD  = E.YYYYMMDD 
					LEFT JOIN SCM_KPI_ITEM_V FS WITH(NOLOCK)  
					ON FS.DIVISION_ID  =  E.DIVISION_ID  
					AND FS.ITEM_ID  = E.ITEM_ID   
               WHERE TRANSFER_FLAG  = 'N'
			   GROUP BY  E.DIVISION_ID               
						,E.PLANT_ID                  
						,FS.OPERATION_GROUP    
						,E.FROM_SITE          
						,E.TO_SITE          
						,E.ITEM_ID          
						,E.YYYYMMDD     
						,C.WEEK_NAME                
						,E.CURRENCY_CODE 
						,C.ISO_YYYYWW
				;

				UPDATE XIF_ERP_ATR_R_SN
				  SET TRANSFER_FLAG = 'Y'
				WHERE TRANSFER_FLAG  = 'N'
				;
      
				-- HISTORY LOG    
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = 'TXN';
				SET @v_log_message = 'INSERT INTO XIF_ERP_ATR_R_SN';
				SET @v_description = '@NSDESSP_0140S' 
				SET @d_event_date  = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

				-- IF data  삭제 (90일 이전 데이터 삭제) 
				DELETE 
				FROM XIF_ERP_ATR_R_SN
				WHERE TRANSFER_DATE < GETDATE() - 90 
				;

			COMMIT TRAN;
        END TRY

        BEGIN CATCH
               ROLLBACK TRAN;
               --PRINT ERROR_MESSAGE();
               SET @E_TYPE = 'E';
               SET @E_MESSAGE = ERROR_MESSAGE();

				-- ERROR LOG
				SET @v_log_type    = 'ERROR';
				SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
				SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));
				SET @d_event_date  = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END CATCH      

		-- 종료 LOG
		SET @v_log_type    = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        SELECT @E_TYPE AS E_TYPE, @E_MESSAGE AS E_MESSAGE

        SET NOCOUNT OFF

END
