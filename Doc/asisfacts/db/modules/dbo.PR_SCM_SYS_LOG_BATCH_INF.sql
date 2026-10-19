
/*
 * Program ID   : PR_SCM_SYS_LOG_BATCH_INF
 * Description  : 인터페이스 데이터 건수 확인 프로시져
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 3. 26    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[PR_SCM_SYS_LOG_BATCH_INF]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_SYS_LOG_BATCH_INF';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno      NVARCHAR(30); 
	DECLARE @n_history_seq	BIGINT;
	DECLARE @n_inf_cnt      BIGINT;
	DECLARE @n_new_inf_cnt    BIGINT;
	DECLARE @n_before_target_cnt    BIGINT;
	DECLARE @n_after_target_cnt     BIGINT;
	DECLARE @n_update_target_cnt    BIGINT;
	DECLARE @n_create_target_cnt    BIGINT;
	DECLARE @n_same_target_inf_cnt    BIGINT;
	DECLARE @v_max_transfer_date  NVARCHAR(8);
	DECLARE @v_proc_name     NVARCHAR(100);
	DECLARE @v_table_name     NVARCHAR(100);
	DECLARE @v_inf_table_name     NVARCHAR(100);
	DECLARE @v_yyyymmdd  NVARCHAR(8);
	DECLARE @v_check_need_yn      NVARCHAR(100);
	DECLARE @sql    NVARCHAR(4000);
	DECLARE @out    NVARCHAR(100);
	DECLARE @p      NVARCHAR(100);

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
	   
      SET  @v_yyyymmdd			= CONVERT(CHAR(8),GETDATE(),112);
	  SET  @n_before_target_cnt = 0;
	  SET  @n_create_target_cnt = 0;
	  SET  @v_check_need_yn		= 'N';

	  -- 배치가 하루 한번인 녀석들로 cursor 생성
	  DECLARE CUR_CHECK_PROC CURSOR FOR
		SELECT segment1,segment2,segment3
		FROM   scm_adm_lookup_master_detail
		WHERE  lookup_type = 'SCM_SYS_LOG_BATCH_INF'
		AND    segment4 = '1'
		AND    valid_yn = 'Y';
	  
	  OPEN CUR_CHECK_PROC;
	  FETCH NEXT FROM CUR_CHECK_PROC INTO @v_proc_name , @v_table_name , @v_inf_table_name ;
		 
	  WHILE (@@FETCH_STATUS = 0)
	  BEGIN

	  -- 프로시져 별로 사용하는 본,I/F 테이블의 로우 수 조회 , 테이블명 동적 쿼리로 처리하기 위함.
		  SET @p	= '@out nvarchar(8) output';
		  IF ( @v_proc_name = 'PR_SCM_MST_PROJECT' OR @v_proc_name = 'PR_SCM_MST_PROJECT_ITEM' OR @v_proc_name = 'PR_SCM_MST_PROJECT_MODEL_QUANTITY' OR @v_proc_name = 'PR_SCM_MST_PROJECT_SCHEDULE' OR  @v_proc_name = 'PR_SCM_MST_PROJECT_DV_MASTER' OR @v_proc_name = 'PR_SCM_MST_COUNTRY_CITY_CITY' OR @v_proc_name = 'PR_SCM_MST_COUNTRY_CITY_COUNTRY' OR  @v_proc_name = 'PR_SCM_MST_CUST_SHORT_NAME')
			BEGIN
				SET @sql  = 'SELECT @out = CONVERT(CHAR(8),MAX(if_rcv_date),112) FROM ' + @v_inf_table_name +' WITH(NOLOCK)';
				EXEC sp_executesql @sql,@p, @out=@v_max_transfer_date output;	
			END;
		  ELSE
			BEGIN
				SET @sql  = 'SELECT @out = CONVERT(CHAR(8),MAX(transfer_date),112) FROM ' + @v_inf_table_name +' WITH(NOLOCK)';
				EXEC sp_executesql @sql,@p, @out=@v_max_transfer_date output;
			END;

		  

		  SET @p	= '@out int output';
		  SET @sql  = 'SELECT @out = COUNT(*) FROM ' + @v_inf_table_name;
		  IF ( @v_proc_name = 'PR_SCM_DNM_MAT_IMPORT_BL')
			 SET @sql  = @sql + ' WHERE bl_type !=''NB''';
		  EXEC sp_executesql @sql,@p, @out=@n_inf_cnt output;

		  SET @p	= '@out int output';
		  IF ( @v_proc_name = 'PR_SCM_MST_PROJECT' OR @v_proc_name = 'PR_SCM_MST_PROJECT_ITEM' OR @v_proc_name = 'PR_SCM_MST_PROJECT_MODEL_QUANTITY' OR @v_proc_name = 'PR_SCM_MST_PROJECT_SCHEDULE' OR  @v_proc_name = 'PR_SCM_MST_PROJECT_DV_MASTER' OR @v_proc_name = 'PR_SCM_MST_COUNTRY_CITY_CITY' OR @v_proc_name = 'PR_SCM_MST_COUNTRY_CITY_COUNTRY' OR  @v_proc_name = 'PR_SCM_MST_CUST_SHORT_NAME')
			BEGIN
				SET @sql  = 'SELECT @out = COUNT(*) FROM ' + @v_inf_table_name +' WITH(NOLOCK) WHERE if_rcv_date > CONVERT(CHAR(8),GETDATE(),112) ';	
				EXEC sp_executesql @sql,@p, @out=@n_new_inf_cnt output;	
			END;
		  ELSE
				SET @sql  = 'SELECT @out = COUNT(*) FROM ' + @v_inf_table_name +' WITH(NOLOCK) WHERE ifseqno = (SELECT MAX(ifseqno) FROM ' + @v_inf_table_name + ')';


		  IF ( @v_proc_name = 'PR_SCM_DNM_MAT_IMPORT_BL')
			 SET @sql  = @sql + ' AND bl_type !=''NB''';

		  EXEC sp_executesql @sql,@p, @out=@n_new_inf_cnt output;

		  SET @p	= '@out int output';
		  SET @sql  = 'SELECT @out = COUNT(*) FROM ' + @v_table_name +' WITH(NOLOCK)';
		  EXEC sp_executesql @sql,@p, @out=@n_after_target_cnt output;

		  SET @p	= '@out int output';
		  SET @sql  = 'SELECT @out = COUNT(*) FROM ' + @v_table_name +' WITH(NOLOCK) WHERE creation_date < CONVERT(CHAR(8),GETDATE(),112)';
		  EXEC sp_executesql @sql,@p, @out=@n_before_target_cnt output;

		  SET @p	= '@out int output';
		  SET @sql  = 'SELECT @out = COUNT(*) FROM ' + @v_table_name +' WITH(NOLOCK) WHERE creation_date > CONVERT(CHAR(8),GETDATE(),112)';
		  EXEC sp_executesql @sql,@p, @out=@n_create_target_cnt output;

		  SET @p	= '@out int output';
		  SET @sql  = 'SELECT @out = COUNT(*) FROM ' + @v_table_name +' WITH(NOLOCK) WHERE last_update_date > CONVERT(CHAR(8),GETDATE(),112)';
		  EXEC sp_executesql @sql,@p, @out=@n_update_target_cnt output;

		  -- 각 프로시져별로 추가적으로 필요한 로직 IF문으로 처리
		  IF ( @v_proc_name = 'PR_SCM_MST_VENDOR')
			BEGIN
				SELECT  @n_same_target_inf_cnt = COUNT(*) 
					FROM SCM_MST_VENDOR WITH(NOLOCK)
					WHERE company_id+vendor_code IN
						(SELECT company_Id+vendor_code FROM XIF_ERP_VENDOR_R_SN WITH(NOLOCK) WHERE ifseqno = (SELECT MAX(ifseqno) FROM XIF_ERP_VENDOR_R_SN WITH(NOLOCK))
					AND CREATION_DATE > CONVERT(CHAR(8),GETDATE(),112)
					GROUP BY company_Id+vendor_code);

					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_MST_SLOC')
			BEGIN
				SELECT @n_same_target_inf_cnt = COUNT(*) 
					FROM SCM_MST_SLOC WITH(NOLOCK)
					WHERE plant_id+storage_id in(
						SELECT plant_id+storage_id FROM XIF_ERP_SLOC_R_SN WITH(NOLOCK)
						WHERE ifseqno = (SELECT MAX(ifseqno) FROM XIF_ERP_SLOC_R_SN WITH(NOLOCK)))

					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_MST_CUSTOMER')
			BEGIN
				SELECT @n_same_target_inf_cnt = COUNT(*) 
				FROM SCM_MST_CUSTOMER WITH(NOLOCK)
				WHERE division_id+shipto_code in
						(SELECT division_id+customer_code 
						 FROM XIF_ERP_CUSTOMER_R_SN WITH(NOLOCK)
						 WHERE ifseqno = (SELECT max(ifseqno) FROM XIF_ERP_CUSTOMER_R_SN WITH(NOLOCK)))

					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		 ELSE IF ( @v_proc_name = 'PR_SCM_DNM_MAT_PO')
			BEGIN
				SELECT @n_same_target_inf_cnt = COUNT(*)
				FROM  dbo.SCM_DNM_MAT_PO WITH(NOLOCK)
				WHERE company_id+po_no+po_item_seq IN 
					(SELECT company_id+po_no+po_item_seq 
					 FROM xif_erp_mat_po_r_sn WITH(NOLOCK) WHERE ifseqno = (SELECT MAX(ifseqno) FROM XIF_ERP_MAT_PO_R_SN WITH(NOLOCK)) 
					 GROUP BY company_id,po_no,po_item_seq)

					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		 ELSE IF ( @v_proc_name = 'PR_SCM_DNM_DELIVERY_TRACKING')
			BEGIN
				SELECT @n_same_target_inf_cnt = COUNT(*) 
				FROM scm_dnm_delivery_tracking WITH(NOLOCK)
				WHERE shipment_no+container_no IN
					(SELECT shipment_no+container_no 
					 FROM xif_erp_delivery_tracking_r_sn WITH(NOLOCK) WHERE ifseqno = (select MAX(ifseqno) from XIF_ERP_DELIVERY_TRACKING_R_SN WITH(NOLOCK)))

					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_DNM_MAT_DOCUMENT')
			BEGIN
				SELECT @n_same_target_inf_cnt = COUNT(*) 
				FROM SCM_DNM_MAT_DOCUMENT WITH(NOLOCK)
				WHERE mat_doc_id+mat_doc_year+mat_doc_item IN
					(SELECT mat_doc_id+mat_doc_year+mat_doc_item 
					 FROM xif_erp_material_document_r_sn WITH(NOLOCK) WHERE ifseqno = (SELECT MAX(ifseqno) FROM XIF_ERP_MATERIAL_DOCUMENT_R_SN WITH(NOLOCK)))

					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_DNM_STOCK_CUSTOMER_CONSIGN')
			BEGIN
				SELECT @n_same_target_inf_cnt = COUNT(*) 
				FROM SCM_DNM_STOCK_CUSTOMER_CONSIGN WITH(NOLOCK)
				WHERE company_id+division_id+item_id+result_date+customer_code IN
					(SELECT company_id+division_id+item_id+result_date+customer_code 
					 FROM xif_erp_customer_consign_stock_r_sn WITH(NOLOCK) WHERE ifseqno = (SELECT MAX(ifseqno) FROM XIF_ERP_CUSTOMER_CONSIGN_STOCK_R_SN WITH(NOLOCK)));

					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_DNM_STOCK_SALES')
			BEGIN
				SELECT @n_same_target_inf_cnt = COUNT(*) 
				FROM SCM_DNM_STOCK_SALES WITH(NOLOCK)
				WHERE result_date+company_id+plant_id+storage_id+item_id IN
					 (SELECT result_date+company_id+plant_id+storage_id+item_id 
					  FROM XIF_ERP_SALES_STOCK_R_SN WITH(NOLOCK) WHERE ifseqno = (SELECT MAX(ifseqno) FROM XIF_ERP_SALES_STOCK_R_SN WITH(NOLOCK)));

					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  
		  ELSE IF ( @v_proc_name = 'PR_SCM_DNM_MAT_INBOUND_DO')
			BEGIN
				SELECT @n_same_target_inf_cnt = COUNT(*) 
				FROM SCM_DNM_MAT_INBOUND_DO WITH(NOLOCK)
				WHERE company_id+delivery_no+delivery_item_seq IN
					(SELECT company_id+delivery_no+delivery_item_seq FROM XIF_ERP_MAT_INBOUND_DO_R_SN WITH(NOLOCK) WHERE ifseqno = (SELECT MAX(ifseqno) from XIF_ERP_MAT_INBOUND_DO_R_SN WITH(NOLOCK)));

					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_DNM_MAT_IMPORT_BL')
			BEGIN
				SELECT @n_same_target_inf_cnt = COUNT(*) 
				FROM XIF_ERP_MAT_IMPORT_BL_R_SN WITH(NOLOCK)
				WHERE company_id+bl_type+bl_no+bl_item_seq IN
					(SELECT company_id+bl_type+bl_no+bl_item_seq 
					 FROM XIF_ERP_MAT_IMPORT_BL_R_SN WITH(NOLOCK) 
					 WHERE ifseqno = (SELECT MAX(ifseqno) FROM XIF_ERP_MAT_IMPORT_BL_R_SN WITH(NOLOCK)) AND bl_type !='NB')
					 AND bl_type !='NB';

					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_DNM_MAT_PO_RECEIPT')
			BEGIN
				SELECT @n_same_target_inf_cnt = COUNT(*) 
				FROM SCM_DNM_MAT_PO_RECEIPT
				WHERE company_id+mat_doc_id+mat_doc_year+mat_doc_item IN
					(SELECT company_id+mat_doc_id+mat_doc_year+mat_doc_item 
					 FROM XIF_ERP_MAT_PO_RECEIPT_R_SN WHERE ifseqno = (SELECT MAX(ifseqno) FROM XIF_ERP_MAT_PO_RECEIPT_R_SN));

					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_DNM_SALES_ORDER_REMAIN')
			BEGIN
				SELECT @n_same_target_inf_cnt = COUNT(*) 
				FROM scm_dnm_sales_order_remain
				WHERE order_no+order_item_seq+company_id+division_id+item_id+result_yyyymmdd IN
					(SELECT so_no+so_seq+company+division+item_id+trnf_date 
					 FROM XIF_ERP_SALES_ORDER_REMAIN_R_SN WHERE ifseqno = (SELECT MAX(ifseqno) FROM XIF_ERP_SALES_ORDER_REMAIN_R_SN));

					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_DNM_INTRANSIT')
			BEGIN
				SET  @n_same_target_inf_cnt = 0;

					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_DM_DNM_SALES_RESULT')
			BEGIN
				SET  @n_same_target_inf_cnt = 0;
					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_MST_DEPT_INFO')
			BEGIN
				SET  @n_same_target_inf_cnt = 0;
					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_MST_USER_INFO')
			BEGIN
				SET  @n_same_target_inf_cnt = 0;
					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_DNM_PACKER_PROD_RESULT')
			BEGIN
				SET  @n_same_target_inf_cnt = 0;
					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_DNM_PACKER_PURCHASE_ORDER')
			BEGIN
				SET  @n_same_target_inf_cnt = 0;
					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_DNM_EXFACTORY_RESULT')
			BEGIN
				SELECT @n_same_target_inf_cnt = COUNT(*) 
				FROM SCM_DNM_EXFACTORY_RESULT
				WHERE company_id+division_id+order_item_seq+plant_id+item_id+delivery_no+order_no+doc_type+doc_seq IN
					(SELECT company+division+so_item_seq+plant_id+item_id+delivery_no+so_no+doc_type+doc_seq 
					 FROM XIF_ERP_EXFACTORY_RESULT_R_SN WHERE ifseqno = (SELECT MAX(ifseqno) FROM XIF_ERP_EXFACTORY_RESULT_R_SN));

					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_MST_PROJECT' OR @v_proc_name = 'PR_SCM_MST_PROJECT_ITEM' OR @v_proc_name = 'PR_SCM_MST_PROJECT_MODEL_QUANTITY' OR @v_proc_name = 'PR_SCM_MST_PROJECT_SCHEDULE' OR  @v_proc_name = 'PR_SCM_MST_PROJECT_DV_MASTER')
			BEGIN		
				SET  @n_same_target_inf_cnt = 0;
					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;
		  ELSE IF ( @v_proc_name = 'PR_SCM_MST_COUNTRY_CITY_CITY' OR @v_proc_name = 'PR_SCM_MST_COUNTRY_CITY_COUNTRY' OR @v_proc_name = 'PR_SCM_MST_CUST_SHORT_NAME')
			BEGIN		
				SET  @n_same_target_inf_cnt = 0;
					IF (@n_after_target_cnt = @n_before_target_cnt + @n_create_target_cnt )
						SET @v_check_need_yn = 'N';
					ELSE 
						SET @v_check_need_yn = 'Y';
			END;


		  MERGE INTO [dbo].[SCM_SYS_LOG_BATCH_INF] A
		  USING ( 
				 SELECT  
					    @v_yyyymmdd yyyymmdd
					   ,@v_proc_name proc_name
					   ,@v_table_name table_name
					   ,@v_inf_table_name inf_table_name
					   ,@v_max_transfer_date max_transfer_date
					   ,@n_inf_cnt inf_cnt
					   ,@n_new_inf_cnt new_inf_cnt
					   ,@n_before_target_cnt before_target_cnt
					   ,@n_after_target_cnt after_target_cnt
					   ,@n_create_target_cnt create_target_cnt
					   ,@n_update_target_cnt update_target_cnt
					   ,@n_same_target_inf_cnt same_target_inf_cnt
					   ,@v_check_need_yn check_need_yn
				
				) B
		ON(
					  A.yyyymmdd			     =  B.yyyymmdd
				  AND A.PROGRAM_NAME			 =  B.proc_name
				  AND A.OUT_TABLE_NAME			 =  B.table_name
				  AND A.INF_TABLE_NAME		     =  B.inf_table_name
				  --AND A.INF_DATA_RESULT_DATE	 =  B.max_transfer_date
		   )

		WHEN MATCHED THEN
			 UPDATE SET  
					     A.INF_TABLE_COUNT			= B.inf_cnt
					    ,A.INF_COUNT				= B.new_inf_cnt
					    ,A.OUT_TABLE_COUNT_BEFORE   = B.before_target_cnt
						,A.OUT_TABLE_COUNT_AFTER    = B.after_target_cnt
					    ,A.OUT_COUNT_CREATE		    = B.create_target_cnt
					    ,A.OUT_COUNT_UPDATE		    = B.update_target_cnt
					    ,A.INF_OUT_SAME_COUNT	    = B.same_target_inf_cnt
                        ,A.check_need_yn			= B.check_need_yn               
					    ,A.last_updated_by			= @v_batch_user
                        ,A.last_update_date			= GETDATE()

										                
		WHEN NOT MATCHED THEN

		  INSERT 
			   (yyyymmdd
			   ,program_name
			   ,out_table_name
			   ,inf_table_name
			   ,inf_data_result_date
			   ,inf_table_count
			   ,inf_count
			   ,out_table_count_before
			   ,out_table_count_after
			   ,out_count_create
			   ,out_count_update
			   ,inf_out_same_count
			   ,check_need_yn
			   ,created_by
			   ,creation_date
			   ,last_updated_by
			   ,last_update_date
			   )
				VALUES
			   (@v_yyyymmdd
			   ,@v_proc_name
			   ,@v_table_name
			   ,@v_inf_table_name
			   ,@v_max_transfer_date
			   ,@n_inf_cnt
			   ,@n_new_inf_cnt
			   ,@n_before_target_cnt
			   ,@n_after_target_cnt
			   ,@n_create_target_cnt
			   ,@n_update_target_cnt
			   ,@n_same_target_inf_cnt
			   ,B.check_need_yn 
			   ,@v_batch_user
			   ,GETDATE()
			   ,@v_batch_user
			   ,GETDATE());

		FETCH NEXT FROM CUR_CHECK_PROC INTO @v_proc_name , @v_table_name , @v_inf_table_name 
		END
		
		CLOSE CUR_CHECK_PROC;
		DEALLOCATE CUR_CHECK_PROC; 
		
		IF @@TRANCOUNT > 0
		 BEGIN
			COMMIT WORK;
		 END;

		 END
    END TRY

    BEGIN CATCH
	  IF @@TRANCOUNT > 0 
        BEGIN
          ROLLBACK;
        END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));;
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
