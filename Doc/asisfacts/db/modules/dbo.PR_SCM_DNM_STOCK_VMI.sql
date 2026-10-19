
/*
 * Program ID   : PR_SCM_DNM_STOCK_VMI
 * Description  : ERP VMI 입고일자별 재고 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.03.23   KSG            Initial Release [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
 * 2024/04/17   vadabi5		   NERP) AUART,VBELN_S -> BSART,EBELN
                               NERP) sales_doc_type,sales_doc_no -> PURCHASE_DOC_TYPE,PURCHASE_DOC_NO
 */

 



CREATE  PROCEDURE [dbo].[PR_SCM_DNM_STOCK_VMI]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_STOCK_VMI';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno     NVARCHAR(30); 
	DECLARE @n_history_seq	BIGINT;

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

	    -- 인터페이스 테이블 처리 ROW UPDATE
        UPDATE [dbo].[xif_erp_vmi_stock_r_sn]
	    SET    transfer_flag = 'P'
	    WHERE  ISNULL(transfer_flag,'N') = 'N';
	  
	    -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	    DECLARE CUR_STOCK_SALES CURSOR FOR
	    SELECT ifseqno 
	    FROM   [dbo].[xif_erp_vmi_stock_r_sn] WITH(NOLOCK)
	    WHERE  transfer_flag = 'P'
	    GROUP BY ifseqno
	    ORDER BY ifseqno ASC;
	  
		OPEN CUR_STOCK_SALES;
		FETCH NEXT FROM CUR_STOCK_SALES INTO @v_ifseqno ; 
		 
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			
            MERGE INTO scm_dnm_stock_vmi a
			USING (
                   SELECT /* PR_SCM_DNM_STOCK_VMI */ 
                          v.division_id
                        , v.plant_id
                        , v.storage_id
                        ,(SELECT MAX(scm_site_id) 
                          FROM   scm_mst_location WITH(NOLOCK)
                          WHERE  division_id =  v.division_id
                          AND    plant_id    =  v.plant_id
                          AND    storage_id  =  v.storage_id
                          AND    valid_yn = 'Y' 
                         ) AS scm_site_id
                        , dbo.FN_GET_PACKER_PLAN_ITEM_ID(v.division_id, v.origin_item_id) AS item_id
                        , v.origin_item_id
                        , v.PURCHASE_DOC_TYPE
                        , v.PURCHASE_DOC_NO
                        , v.sales_org
                        , v.distribution_channel
                        , v.shipment_no
                        , v.delivery_no
                        , v.qty
                        , v.uom
                        , v.ata_date
                        , v.base_date
                        , v.status_code                          
                   FROM  (
                          SELECT --spart AS division_id
                                 ISNULL((SELECT top 1 division_id
                                         FROM   scm_mst_site WITH(NOLOCK)
                                         WHERE  plant_id = werks), '') AS division_id
                               , ISNULL(werks, '')   AS plant_id
                               , ISNULL(lgort, '')   AS storage_id
                               , ISNULL(matnr, '')   AS origin_item_id
                               , ISNULL(BSART, '')   AS PURCHASE_DOC_TYPE
                               , ISNULL(EBELN, '')   AS PURCHASE_DOC_NO
                               , ISNULL(vkorg, '')   AS sales_org
                               , ISNULL(vtweg, '')   AS distribution_channel
                               , ISNULL(tknum, '')   AS shipment_no
                               , ISNULL(vbeln_d, '') AS delivery_no
                               , CONVERT(NUMERIC, ISNULL(invn_qty, '0')) AS qty
                               , ISNULL(unit, '')        AS uom

							   -- ATA 일자가 없으면 1. Base Date >> 2. 전일로 처리
                               , CASE WHEN ISDATE(act_in_date) = 1 THEN act_in_date
                                      ELSE ISNULL(base_dt, CONVERT(CHAR(8), GETDATE()-1, 112))
                                 END AS ata_date

                               , ISNULL(base_dt, '')     AS base_date
                               , ISNULL(status_cd, '')   AS status_code
                          FROM [dbo].[xif_erp_vmi_stock_r_sn]  WITH(NOLOCK)
                          WHERE ifseqno       = @v_ifseqno
                          AND   transfer_flag = 'P'
                         ) v              
                   WHERE  division_id                <> ''
                   AND    ISNULL(plant_id, '')       <> ''
                   AND    ISNULL(storage_id, '')     <> ''
                   AND    ISNULL(origin_item_id, '') <> ''
		          ) b
			ON (	   a.division_id          =  b.division_id
				   AND a.plant_id	          =  b.plant_id
				   AND a.storage_id           =  b.storage_id
				   AND a.origin_item_id       =  b.origin_item_id  
				   AND a.PURCHASE_DOC_TYPE    =  b.PURCHASE_DOC_TYPE  
				   AND a.PURCHASE_DOC_NO      =  b.PURCHASE_DOC_NO  
				   AND a.sales_org            =  b.sales_org  
				   AND a.distribution_channel =  b.distribution_channel  
				   AND a.shipment_no          =  b.shipment_no  
				   AND a.delivery_no          =  b.delivery_no  
				   AND a.base_date            =  b.base_date  
				   AND a.status_code          =  b.status_code  
			   )
			WHEN MATCHED THEN
				 UPDATE SET 			
							 a.scm_site_id			=  b.scm_site_id
							,a.item_id			    =  b.item_id 
							,a.qty				    =  b.qty
							,a.uom					=  b.uom
							,a.ata_date				=  b.ata_date
							,a.last_updated_by	    =  @v_batch_user
							,a.last_update_date	    =  GETDATE()
					                
			WHEN NOT MATCHED THEN
			INSERT (  
                    division_id
                  , plant_id
                  , storage_id
                  , scm_site_id
                  , item_id
                  , origin_item_id
                  , PURCHASE_DOC_TYPE
                  , PURCHASE_DOC_NO
                  , sales_org
                  , distribution_channel
                  , shipment_no
                  , delivery_no
                  , qty
                  , uom
                  , ata_date
                  , base_date
                  , status_code
                  , created_by
                  , creation_date
                  , last_updated_by
                  , last_update_date						  								
						)
			VALUES (   
                    b.division_id
                  , b.plant_id
                  , b.storage_id
                  , b.scm_site_id
                  , b.item_id
                  , b.origin_item_id
                  , b.PURCHASE_DOC_TYPE
                  , b.PURCHASE_DOC_NO
                  , b.sales_org
                  , b.distribution_channel
                  , b.shipment_no
                  , b.delivery_no
                  , b.qty
                  , b.uom
                  , b.ata_date
                  , b.base_date
                  , b.status_code
				  , @v_batch_user
				  , GETDATE()
				  , @v_batch_user
				  , GETDATE() 
			       )
			;

			SET @n_log_count = @n_log_count + @@ROWCOUNT;

			FETCH NEXT FROM CUR_STOCK_SALES INTO  @v_ifseqno
		
		END
		
		CLOSE CUR_STOCK_SALES;
		DEALLOCATE CUR_STOCK_SALES; 

		-----------------------------------------------------------
        -- INSERT LOG
        -----------------------------------------------------------
        --SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'APPEND';
        SET @v_log_message = 'INSERT INTO scm_dnm_stock_vmi';
        SET @v_description = 'ifseqno = ' + @v_ifseqno;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------
		
		-- 처리된 row 마킹
		UPDATE [dbo].[xif_erp_vmi_stock_r_sn] 
		SET    transfer_flag = 'Y' 
		WHERE  transfer_flag = 'P';

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
