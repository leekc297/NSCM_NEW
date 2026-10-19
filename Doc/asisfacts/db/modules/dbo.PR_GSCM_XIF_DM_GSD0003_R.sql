
/*
 * Program ID   : PR_GSCM_XIF_DM_GSD0003_R
 * Description  : GERP Call Off 수신
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/05   HWYOON		   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[PR_GSCM_XIF_DM_GSD0003_R]
    @ZSDE1010T			AS DBO.ZSDE1010T       READONLY
	                            
AS

BEGIN

SET NOCOUNT ON;

        DECLARE @TRANSFER_DATE        DATETIME      = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';

        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_GSCM_XIF_DM_GSD0003_R';
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
               
			INSERT INTO [dbo].[XIF_ERP_EDI_CALL_OFF_HEAD_R_SN]
					   ( [CLIENT]
						,[IFSEQNO]
						,[COMPANY_ID]
						,[COMPANY_NAME]
						,[DOC_IDENTIFINER]
						,[CUSTOMER_DOC_NUMBER]
						,[CUSTOMER_DOC_TYPE]
						,[IDOC_NO]
						,[DOC_ISSUE_DATE]
						,[TYPE_OF_INSTRUCTION]
						,[BUYER]
						,[BUYER_NAME]
						,[BUYER_COUNTRY_CODE]
						,[SELLER]
						,[SELLER_NAME]
						,[SELLER_COUNTRY_CODE]
						,[SHIP_FROM]
						,[SHIP_FROM_NAME]
						,[SHIP_FROM_COUNTRY_CODE]
						,[ITEM_NUMBER]
						,[INFORMATION_TYPE]
						,[SHIP_TO]
						,[SHIP_TO_NAME]
						,[SHIP_TO_COUNTRY_CODE]
						,[UNLOADING_POINT]
						,[UNLOADING_POINT_NAME]
						,[CUSTOMER_WAREHOUSE]
						,[CUSTOMER_WAREHOUSE_NAME]
						,[CONSUMPTION_POINT]
						,[CONSUMPTION_POINT_NAME]
						,[BMW_PLANT_NUMBER]
						,[LINE_ITEM_NUMBER]
						,[BUYER_PART_NUMBER]
						,[SUPPLIER_ARTICLE_NUMBER]
						,[ENGINEERING_CHANGE_LEVEL]
						,[NAEL_NUMBER]
						,[ITEM_SHORT_DESCRIPTION]
						,[GENERAL_INFORMATION_NUMBER]
						,[PURCHASE_ORDER_NUMBE]
						,[PURCHASE_ORDER_ITEM_NUMBER]
						,[CURRENT_CALL_OFF_NUMBER]
						,[CURRENT_CALL_OFF_DATE]
						,[PERVIOUS_CALL_OFF_NUMBER]
						,[PREVIOUS_CALL_OFF_DATE]
						,[PURCHASING_CONTACT_ID]
						,[PURCHASING_CONTACT_NAME]
						,[TEL_NUMBER]
						,[FAX_NUMBER]
						,[EMAIL_ADDRESS]
						,[TRANSPORT_METHOD]
						,[BACKORDER_QTY]
						,[UOM]
						,[CUMULATIVE_QTY_RECEIVED]
						,[CUMULATIVE_QTY_START_DATE]
						,[CUMULATIVE_QTY_ORDERED]
						,[CUMULATIVE_QTY_START_DATE2]
						,[CUMULATIVE_QTY_END_DATE]
						,[RECEIVED_QTY1]
						,[GOODS_RECEIPT_DATE1]
						,[DELIVERY_NOTE_NUMBER1]
						,[DELIVERY_ITEM_NUMBER1]
						,[DATE_OF_DESPATCH1]
						,[RECEIVED_QTY2]
						,[GOODS_RECEIPT_DATE2]
						,[DELIVERY_NOTE_NUMBER2]
						,[DELIVERY_ITEM_NUMBER2]
						,[DATE_OF_DESPATCH2]
						,[RECEIVED_QTY3]
						,[GOODS_RECEIPT_DATE3]
						,[DELIVERY_NOTE_NUMBER3]
						,[DELIVERY_ITEM_NUMBER3]
						,[DATE_OF_DESPATCH3]
						,[TRANSACTION_FLAG]
						,[CREATE_USER_ID]
						,[CREATE_DATE]
						,[CREATE_TIME]
						,[UPDATE_USER_ID]
						,[UPDATE_DATE]
						,[UPDATE_TIME]
						,[TRANSFER_DATE]
						,[TRANSFER_FLAG]
					   )
				 SELECT MANDT
				       ,ZIFDOC_NO
					   ,BUKRS
					   ,BUTXT
					   ,ZDOCU_IDF
					   ,ZDOCU_NO
					   ,ZDOCU_TYP
					   ,DOCNUM
					   ,ZDOCISSUE_DAT
					   ,ZDTPFNCO_QUF1
					   ,ZBYPARTY_ID
					   ,ZBYPARTY_NAME
					   ,ZBYCOUNTRY_CODE
					   ,ZSEPARTY_ID
					   ,ZSEPARTY_NAME
					   ,ZSECOUNTRY_CODE
					   ,ZSFPARTY_ID
					   ,ZSFPARTY_NAME
					   ,ZSFCOUNTRY_CODE
					   ,ZSHIPTO_POS
					   ,ZPROINDC_CODE
					   ,ZSHIPTOPT_ID
					   ,ZPARTY_NAME
					   ,ZCOUNTRY_CODE
					   ,ZLOCNM_CODE
					   ,ZLOCATION_NM
					   ,ZLOCNM_CODE1
					   ,ZLOCATION_NM1
					   ,ZLOCNM_CODE2
					   ,ZLOCATION_NM2
					   ,ZPLANT_NO
					   ,ZLINEITM_ID
					   ,ZITEMNR_CUST
					   ,ZSPATICL_NO
					   ,ZSPATICL_NO1
					   ,ZSPATICL_NO2
					   ,ZARTICLE_DSC1
					   ,ZFREETEXT
					   ,ZPURORDER_NO
					   ,ZPOITEM_NO
					   ,ZCURCALLOFF_NO
					   ,ZCURCALOF_DATE
					   ,ZPRECALLOFF_NO
					   ,ZPRECALLOFF_DATE
					   ,ZCONTACT_ID
					   ,ZCONTACT_NM
					   ,ZCOMMADD_ID
					   ,ZCOMMADD_ID1
					   ,ZCOMMADD_ID2
					   ,ZTRSMNM_CODE
					   ,ZBACKORDER_QTY
					   ,ZUOM_CODE2
					   ,ZCUMLRECV_QTY
					   ,ZCUMQTYST_DATE1
					   ,ZCUMLORDER_QTY
					   ,ZCUMQTYST_DATE2
					   ,ZCUMQTYED_DATE3
					   ,ZRECEIVED_QTY
					   ,ZGDRECIEP_DATE
					   ,ZDLVNOTE_NO
					   ,ZLINEITEM_NO
					   ,ZDSPHRECV_DATE
					   ,ZRECEIVED_QTY1
					   ,ZGDRECIEP_DATE1
					   ,ZDLVNOTE_NO1
					   ,ZLINEITEM_NO1
					   ,ZDSPHRECV_DATE1
					   ,ZRECEIVED_QTY2
					   ,ZGDRECIEP_DATE2
					   ,ZDLVNOTE_NO2
					   ,ZLINEITEM_NO2
					   ,ZDSPHRECV_DATE2
					   ,ZPROCS_TY
					   ,ZIF_ERNAM
					   ,ZIF_ERDAT
					   ,ZIF_ERZET
					   ,ZIF_AENAM
					   ,ZIF_AEDAT
					   ,ZIF_AEZET
					   ,@TRANSFER_DATE
					   ,@TRANSFER_FLAG
				  FROM @ZSDE1010T ;
      
				-- HISTORY LOG    
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = 'TXN';
				SET @v_log_message = 'INSERT INTO XIF_ERP_EDI_CALL_OFF_HEAD_R_SN';
				SET @v_description = '@ZSDE1010T' 
				SET @d_event_date  = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

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






