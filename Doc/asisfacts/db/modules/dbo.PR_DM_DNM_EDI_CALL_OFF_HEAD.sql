/*
 * Program ID   : PR_DM_DNM_EDI_CALL_OFF_HEAD
 * Description  : BMW EDI 정보 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 06. 1    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.12     Kim Jaejung	   PR_DM_DNM_EDI_CALL_OFF_SCHEDULE 프로시져 호출 로직 추가
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_DNM_EDI_CALL_OFF_HEAD]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_DNM_EDI_CALL_OFF_HEAD';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @n_history_seq		BIGINT;
	DECLARE @v_ifseqno     NVARCHAR(30); -- 누락된 전체 데이터 insert

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY	
      BEGIN
	    --BEGIN TRANSACTION
		-- 인터페이스 테이블 처리 ROW UPDATE
	    UPDATE xif_erp_edi_call_off_head_r_sn 
		SET    transfer_flag = 'P'
		WHERE  ISNULL(transfer_flag,'N') = 'N'

		-- 지나간 배치까지 적용하기 위해 Cursor 로 처리
		DECLARE CUR_EDI_CALL_OFF_HEAD CURSOR FOR
		  
		SELECT ifseqno
		FROM   xif_erp_edi_call_off_head_r_sn WITH(NOLOCK)
		WHERE  transfer_flag = 'P'
		GROUP BY ifseqno
		ORDER BY ifseqno ASC;

		/*
		-- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
		IF OBJECT_ID('dbo.dm_dnm_edi_call_off_head_temp$') IS NOT NULL 
		  DROP TABLE dm_dnm_edi_call_off_head_temp$

		SELECT * 
		INTO [dbo].dm_dnm_edi_call_off_head_temp$
		FROM [dbo].dm_dnm_edi_call_off_head WITH(NOLOCK);
		*/
		OPEN CUR_EDI_CALL_OFF_HEAD;
		FETCH NEXT FROM CUR_EDI_CALL_OFF_HEAD INTO @v_ifseqno ;

		WHILE (@@FETCH_STATUS = 0)
		  BEGIN
		 
		  MERGE INTO [dbo].[dm_dnm_edi_call_off_head] A		
		  USING (
		         SELECT    client
						  ,company_id
						  ,company_name
						  ,doc_identifiner
						  ,customer_doc_number
						  ,customer_doc_type
						  ,idoc_no
						  ,doc_issue_date
						  ,type_of_instruction
						  ,buyer
						  ,buyer_name
						  ,buyer_country_code
						  ,seller
						  ,seller_name
						  ,seller_country_code
						  ,ship_from
						  ,ship_from_name
						  ,ship_from_country_code
						  ,item_number
						  ,information_type
						  ,ship_to
						  ,ship_to_name
						  ,ship_to_country_code
						  ,unloading_point
						  ,unloading_point_name
						  ,customer_warehouse
						  ,customer_warehouse_name
						  ,consumption_point
						  ,consumption_point_name
						  ,bmw_plant_number
						  ,line_item_number
						  ,buyer_part_number
						  ,supplier_article_number
						  ,engineering_change_level
						  ,nael_number
						  ,item_short_description
						  ,general_information_number
						  ,purchase_order_numbe
						  ,purchase_order_item_number
						  ,current_call_off_number
						  ,current_call_off_date
						  ,pervious_call_off_number
						  ,previous_call_off_date
						  ,purchasing_contact_id
						  ,purchasing_contact_name
						  ,tel_number
						  ,fax_number
						  ,email_address
						  ,transport_method
						  ,backorder_qty
						  ,uom
						  ,cumulative_qty_received
						  ,cumulative_qty_start_date
						  ,cumulative_qty_ordered
						  ,cumulative_qty_start_date2
						  ,cumulative_qty_end_date
						  ,received_qty1
						  ,goods_receipt_date1
						  ,delivery_note_number1
						  ,delivery_item_number1
						  ,date_of_despatch1
						  ,received_qty2
						  ,goods_receipt_date2
						  ,delivery_note_number2
						  ,delivery_item_number2
						  ,date_of_despatch2
						  ,received_qty3
						  ,goods_receipt_date3
						  ,delivery_note_number3
						  ,delivery_item_number3
						  ,date_of_despatch3
				 FROM   xif_erp_edi_call_off_head_r_sn WITH(NOLOCK)
				 WHERE  ifseqno			   = @v_ifseqno	
				 AND    transfer_flag		   = 'P'

				) B
		  ON(     
					  A.client           	=  B.client
			      AND A.company_id			=  B.company_id
			      AND A.idoc_no			    =  B.idoc_no
				  AND A.doc_issue_date      =  B.doc_issue_date	
				  AND A.customer_doc_number =  B.customer_doc_number
				  AND A.item_number		    =  B.item_number		  
		    )
		  WHEN MATCHED THEN
		     UPDATE SET 
						 --A.client           		 =  B.client
						--,A.company_id           	 =  B.company_id
						 A.company_name         	 =  B.company_name
						,A.doc_identifiner      	 =  B.doc_identifiner
						--,A.customer_doc_number  	 =  B.customer_doc_number
						,A.customer_doc_type    	 =  B.customer_doc_type
						--,A.idoc_no         	   		 =  B.idoc_no
						--,A.doc_issue_date       	 =  B.doc_issue_date
						,A.type_of_instruction  	 =  B.type_of_instruction
						,A.buyer         	  		 =  B.buyer
						,A.buyer_name           	 =  B.buyer_name
						,A.buyer_country_code   	 =  B.buyer_country_code
						,A.seller         	   		 =  B.seller
						,A.seller_name          	 =  B.seller_name
						,A.seller_country_code  	 =  B.seller_country_code
						,A.ship_from            	 =  B.ship_from
						,A.ship_from_name       	 =  B.ship_from_name
						,A.ship_from_country_code    =  B.ship_from_country_code
						--,A.item_number         		 =  B.item_number
						,A.information_type          =  B.information_type
						,A.ship_to         			 =  B.ship_to
						,A.ship_to_name         	 =  B.ship_to_name
						,A.ship_to_country_code      =  B.ship_to_country_code
						,A.unloading_point         	 =  B.unloading_point
						,A.unloading_point_name      =  B.unloading_point_name
						,A.customer_warehouse        =  B.customer_warehouse
						,A.customer_warehouse_name   =  B.customer_warehouse_name
						,A.consumption_point         =  B.consumption_point
						,A.consumption_point_name    =  B.consumption_point_name
						,A.bmw_plant_number          =  B.bmw_plant_number
						,A.line_item_number          =  B.line_item_number
						,A.buyer_part_number         =  B.buyer_part_number
						,A.supplier_article_number   =  B.supplier_article_number
						,A.engineering_change_level  =  B.engineering_change_level
						,A.nael_number         		 =  B.nael_number
						,A.item_short_description    =  B.item_short_description
						,A.general_information_number=  B.general_information_number
						,A.purchase_order_numbe      =  B.purchase_order_numbe
						,A.purchase_order_item_number=  B.purchase_order_item_number
						,A.current_call_off_number   =  B.current_call_off_number
						,A.current_call_off_date     =  B.current_call_off_date
						,A.pervious_call_off_number  =  B.pervious_call_off_number
						,A.previous_call_off_date    =  B.previous_call_off_date
						,A.purchasing_contact_id     =  B.purchasing_contact_id
						,A.purchasing_contact_name   =  B.purchasing_contact_name
						,A.tel_number         		 =  B.tel_number
						,A.fax_number         		 =  B.fax_number
						,A.email_address         	 =  B.email_address
						,A.transport_method          =  B.transport_method
						,A.backorder_qty         	 =  B.backorder_qty
						,A.uom         				 =  B.uom
						,A.cumulative_qty_received   =  B.cumulative_qty_received
						,A.cumulative_qty_start_date =  B.cumulative_qty_start_date
						,A.cumulative_qty_ordered    =  B.cumulative_qty_ordered
						,A.cumulative_qty_start_date2=  B.cumulative_qty_start_date2
						,A.cumulative_qty_end_date   =  B.cumulative_qty_end_date
						,A.received_qty1         	 =  B.received_qty1
						,A.goods_receipt_date1       =  B.goods_receipt_date1
						,A.delivery_note_number1     =  B.delivery_note_number1
						,A.delivery_item_number1     =  B.delivery_item_number1
						,A.date_of_despatch1         =  B.date_of_despatch1
						,A.received_qty2         	 =  B.received_qty2
						,A.goods_receipt_date2       =  B.goods_receipt_date2
						,A.delivery_note_number2     =  B.delivery_note_number2
						,A.delivery_item_number2     =  B.delivery_item_number2
						,A.date_of_despatch2         =  B.date_of_despatch2
						,A.received_qty3         	 =  B.received_qty3
						,A.goods_receipt_date3       =  B.goods_receipt_date3
						,A.delivery_note_number3     =  B.delivery_note_number3
						,A.delivery_item_number3     =  B.delivery_item_number3
						,A.date_of_despatch3         =  B.date_of_despatch3 
					    ,A.valid_yn					 =  'Y'
					    ,A.last_updated_by			 =  @v_batch_user
                        ,A.last_update_date			 =  GETDATE()
					                
		  WHEN NOT MATCHED THEN
			 INSERT (  
						 client
			            ,company_id
						,company_name
						,doc_identifiner
						,customer_doc_number
						,customer_doc_type
						,idoc_no
						,doc_issue_date
						,type_of_instruction
						,buyer
						,buyer_name
						,buyer_country_code
						,seller
						,seller_name
						,seller_country_code
						,ship_from
						,ship_from_name
						,ship_from_country_code
						,item_number
						,information_type
						,ship_to
						,ship_to_name
						,ship_to_country_code
						,unloading_point
						,unloading_point_name
						,customer_warehouse
						,customer_warehouse_name
						,consumption_point
						,consumption_point_name
						,bmw_plant_number
						,line_item_number
						,buyer_part_number
						,supplier_article_number
						,engineering_change_level
						,nael_number
						,item_short_description
						,general_information_number
						,purchase_order_numbe
						,purchase_order_item_number
						,current_call_off_number
						,current_call_off_date
						,pervious_call_off_number
						,previous_call_off_date
						,purchasing_contact_id
						,purchasing_contact_name
						,tel_number
						,fax_number
						,email_address
						,transport_method
						,backorder_qty
						,uom
						,cumulative_qty_received
						,cumulative_qty_start_date
						,cumulative_qty_ordered
						,cumulative_qty_start_date2
						,cumulative_qty_end_date
						,received_qty1
						,goods_receipt_date1
						,delivery_note_number1
						,delivery_item_number1
						,date_of_despatch1
						,received_qty2
						,goods_receipt_date2
						,delivery_note_number2
						,delivery_item_number2
						,date_of_despatch2
						,received_qty3
						,goods_receipt_date3
						,delivery_note_number3
						,delivery_item_number3
						,date_of_despatch3
					    ,valid_yn
						,created_by
						,creation_date
						,last_updated_by
						,last_update_date
					)
			 VALUES (   
						 B.client
						,B.company_id
						,B.company_name
						,B.doc_identifiner
						,B.customer_doc_number
						,B.customer_doc_type
						,B.idoc_no
						,B.doc_issue_date
						,B.type_of_instruction
						,B.buyer
						,B.buyer_name
						,B.buyer_country_code
						,B.seller
						,B.seller_name
						,B.seller_country_code
						,B.ship_from
						,B.ship_from_name
						,B.ship_from_country_code
						,B.item_number
						,B.information_type
						,B.ship_to
						,B.ship_to_name
						,B.ship_to_country_code
						,B.unloading_point
						,B.unloading_point_name
						,B.customer_warehouse
						,B.customer_warehouse_name
						,B.consumption_point
						,B.consumption_point_name
						,B.bmw_plant_number
						,B.line_item_number
						,B.buyer_part_number
						,B.supplier_article_number
						,B.engineering_change_level
						,B.nael_number
						,B.item_short_description
						,B.general_information_number
						,B.purchase_order_numbe
						,B.purchase_order_item_number
						,B.current_call_off_number
						,B.current_call_off_date
						,B.pervious_call_off_number
						,B.previous_call_off_date
						,B.purchasing_contact_id
						,B.purchasing_contact_name
						,B.tel_number
						,B.fax_number
						,B.email_address
						,B.transport_method
						,B.backorder_qty
						,B.uom
						,B.cumulative_qty_received
						,B.cumulative_qty_start_date
						,B.cumulative_qty_ordered
						,B.cumulative_qty_start_date2
						,B.cumulative_qty_end_date
						,B.received_qty1
						,B.goods_receipt_date1
						,B.delivery_note_number1
						,B.delivery_item_number1
						,B.date_of_despatch1
						,B.received_qty2
						,B.goods_receipt_date2
						,B.delivery_note_number2
						,B.delivery_item_number2
						,B.date_of_despatch2
						,B.received_qty3
						,B.goods_receipt_date3
						,B.delivery_note_number3
						,B.delivery_item_number3
						,B.date_of_despatch3
					    ,'Y'
					   ,@v_batch_user   
					   ,GETDATE()
					   ,@v_batch_user
                       ,GETDATE()
					)
		;
		
		 -----------------------------------------------------------
              -- Merge LOG
              -----------------------------------------------------------
              SET @v_log_type = 'APPEND';
              SET @v_log_message = 'MERGE INTO dm_dnm_edi_call_off_head';
              SET @v_description = 'ifseqno = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		FETCH NEXT FROM CUR_EDI_CALL_OFF_HEAD INTO  @v_ifseqno
		END

		CLOSE CUR_EDI_CALL_OFF_HEAD;
		DEALLOCATE CUR_EDI_CALL_OFF_HEAD; 

		/*
		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리

		SET @n_history_seq = NEXT VALUE FOR SEQ1_dm_dnm_edi_call_off_head_H
			
			INSERT INTO [dbo].[dm_dnm_edi_call_off_head_h] (
			   history_seq
			  ,division_id
			  ,soldto_code
			  ,shipto_code
			  ,soldto_description
			  ,soldto_address
			  ,city -- 2018. 05. 23
			  ,soldto_country
			  ,soldto_region
			  ,soldto_region_name
			  ,soldto_city_name
			  ,shipto_description
			  ,shipto_address
			  ,shipto_country
			  ,shipto_region
			  ,shipto_region_name
			  ,shipto_city_name
			  ,valid_yn
			  ,creation_date
			  ,last_update_date
			  ,last_updated_by
			  ,created_by
			  ,history_creation_date		
		   )
			SELECT    @n_history_seq
					  ,A.*
					  ,@v_batch_user
					  ,@v_batch_user
					  ,GETDATE()
			FROM 
				  (
				 SELECT A.*,B.last_update_date FROM (
				 SELECT
					   division_id
					  ,soldto_code
					  ,shipto_code
					  ,soldto_description
					  ,soldto_address
					  ,city -- 2018. 05. 23
					  ,soldto_country
					  ,soldto_region
					  ,soldto_region_name
					  ,soldto_city_name
					  ,shipto_description
					  ,shipto_address
					  ,shipto_country
					  ,shipto_region
					  ,shipto_region_name
					  ,shipto_city_name
					  ,valid_yn
					  ,creation_date
				  FROM [dbo].[dm_dnm_edi_call_off_head_temp$]
				  EXCEPT
				  SELECT
					   division_id
					  ,soldto_code
					  ,shipto_code
					  ,soldto_description
					  ,soldto_address
					  ,city -- 2018. 05. 23
					  ,soldto_country
					  ,soldto_region
					  ,soldto_region_name
					  ,soldto_city_name
					  ,shipto_description
					  ,shipto_address
					  ,shipto_country
					  ,shipto_region
					  ,shipto_region_name
					  ,shipto_city_name
					  ,valid_yn
					  ,creation_date
				  FROM [dbo].[dm_dnm_edi_call_off_head]
				  ) A INNER JOIN [dbo].[dm_dnm_edi_call_off_head_temp$] B
				  ON  A.division_id = B.division_id
				  AND A.soldto_code = B.soldto_code
				  AND A.shipto_code = B.shipto_code

				  ) A

		DROP TABLE dm_dnm_edi_call_off_head_temp$;
				-- HISTORY LOG
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO dm_dnm_edi_call_off_head_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_batch_user, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		*/
		-- 처리 한 row 마킹
		UPDATE xif_erp_edi_call_off_head_r_sn 
		SET transfer_flag = 'Y' 
		WHERE transfer_flag = 'P';

		-- 순차적 호출을 위함. 2018.06.12
        EXEC PR_DM_DNM_EDI_CALL_OFF_SCHEDULE
		
        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;

      END;
    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
		  BEGIN
            ROLLBACK;
		  END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
