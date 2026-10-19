
/*
 * Program ID   : PR_SCM_DNM_INTRANSIT_CO_PUR
 * Description  : 법인간 운송중 재고 정보 기준 최종 GR 정보 미수신 대응용 가상 GR 정보 생성
 * Program History
 * 
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.11.29   KSG            Initial Release [PJ20230692] LGES SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 미착 해제 시 최종 GR 정보 미수신 대응용 가상 GR 정보 생성
 * 2024.06.09   vadabi3        NERP - 특정 Company 별도 처리 개선
 * 2024.10.22   vadabi3        NERP - Temp Table 수정
 * 2024.10.28   vadabi3        NERP - 개발 DB 적용
 ----------------------------------------------------------------------------------------------------
 */
CREATE PROCEDURE [dbo].[PR_SCM_DNM_INTRANSIT_CO_PUR]
AS

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- LOG 용 변수 설정
  DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
  DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_INTRANSIT_CO_PUR';
  DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
  DECLARE @n_log_count    INTEGER = 0;
  DECLARE @v_log_message  NVARCHAR(1000);
  DECLARE @v_description  NVARCHAR(500);
  DECLARE @d_event_date   DATETIME;
  DECLARE @v_ifseqno      NVARCHAR(30);
   
	-- NERP 매핑코드
	DECLARE @v_COMPANY_SALES NVARCHAR(8);
	DECLARE @v_ESOC NVARCHAR(8);

	-- 20241028 B100->C100 (HQ00 -> HQ00) 적용 필요한가?
	-- 20241028 B100->C100 (STH05 -> HQ00) 적용 필요한가?
	SELECT @v_COMPANY_SALES = dbo.FN_GET_LOOKUP_VALUE('PR_SCM_DNM_INTRANSIT_CO_PUR', 'COMPANY_SALES')  
	SELECT @v_ESOC			= dbo.FN_GET_LOOKUP_VALUE('PR_SCM_DNM_INTRANSIT_CO_PUR', 'ESOC')  


  -- 시작 LOG
  SET @v_log_type    = 'START';
  SET @v_log_message = '########## Start of procedure ##########';
  SET @v_description = '';
  SET @d_event_date  = SYSDATETIME();

  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  BEGIN TRY
    BEGIN

      IF OBJECT_ID('dbo.scm_dnm_intransit_co_summary_temp$') IS NOT NULL DROP TABLE scm_dnm_intransit_co_summary_temp$
      IF OBJECT_ID('dbo.scm_dnm_intransit_co_summary_temp_n$') IS NOT NULL DROP TABLE scm_dnm_intransit_co_summary_temp_n$
      IF OBJECT_ID('dbo.scm_dnm_intransit_co_summary_temp_y$') IS NOT NULL DROP TABLE scm_dnm_intransit_co_summary_temp_y$
      IF OBJECT_ID('dbo.scm_dnm_intransit_co_detail_calc_temp$') IS NOT NULL DROP TABLE scm_dnm_intransit_co_detail_calc_temp$

      -------------------------------------------------------------------------
	  -- 1. 최근 2일 이내에 생성된 Summary 정보 Temp 생성 : Valid 여부 상관 없음
	  -------------------------------------------------------------------------
      SELECT cs.division_id, cs.company_id_purch, cs.company_id_sales, cs.po_no, cs.po_item_seq, cs.origin_item_id, MAX(valid_yn) AS valid_yn
           , SUM(po_qty) AS po_qty, SUM(gi_qty) AS gi_qty, SUM(gr_qty) AS gr_qty, SUM(intransit_qty) AS intransit_qty
      INTO   scm_dnm_intransit_co_summary_temp$
      FROM   scm_dnm_intransit_co_summary cs WITH(NOLOCK)
      WHERE  last_update_date >= DATEADD(DD, -2, GETDATE()) 
      GROUP BY cs.division_id, cs.company_id_purch, cs.company_id_sales, cs.po_no, cs.po_item_seq, cs.origin_item_id
      
	  -----------------------------------------------------------
      -- Append LOG
      -----------------------------------------------------------
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'APPEND';
      SET @v_log_message = N'Summary Temp Insert';
      SET @v_description = N'Summary Temp Insert';
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  
      -------------------------------------------------------------------------
	  -- 2. Detail 에서 1번의 정보에 해당하는 PO 의 mat_doc_id = 'ADD_GR' 정보 삭제
	  -------------------------------------------------------------------------
	  DELETE scm_dnm_intransit_co_detail
	  WHERE  division_id + ':' + company_id_purch 
           + ':' + CASE WHEN company_id_sales = @v_COMPANY_SALES THEN @v_ESOC ELSE company_id_sales END 
           + ':' + po_no + ':' + po_item_seq + ':' + origin_item_id
	     IN (SELECT cs.division_id + ':' + cs.company_id_purch + ':' + cs.company_id_sales + ':' + cs.po_no + ':' + cs.po_item_seq + ':' + cs.origin_item_id
             FROM   scm_dnm_intransit_co_summary_temp$ cs WITH(NOLOCK)
             WHERE  1=1
            )             
	  AND     doc_type   = 'GR'
	  AND     mat_doc_id LIKE 'ADD_GR%'
	  ;
	        
	  -----------------------------------------------------------
      -- Append LOG
      -----------------------------------------------------------
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'APPEND';
      SET @v_log_message = N'Delete ADD_GR';
      SET @v_description = N'Delete ADD_GR';
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  
      -------------------------------------------------------------------------
	  -- 3. 1번에서 Valid_yn = 'N' 이고 Detail 에 GR 이 없는 경우
      --  선적 즉시 입고로 간주하여 CO Detail 의 GI 일자 기준으로 GR 정보 생성 : mat_doc_id = 'ADD_GR'
	  -------------------------------------------------------------------------
	  SELECT cs.*
      INTO   scm_dnm_intransit_co_summary_temp_n$
      FROM   scm_dnm_intransit_co_summary_temp$ cs WITH(NOLOCK) 
		 		
      LEFT OUTER JOIN (SELECT CASE WHEN company_id_sales = @v_COMPANY_SALES THEN @v_ESOC
                                          ELSE company_id_sales
                                     END company_id_sales_conv
                            , * 
                       FROM   scm_dnm_intransit_co_detail cd WITH(NOLOCK) 
                       WHERE  doc_type = 'GR'
                      ) cd
      ON  cs.division_id      = cd.division_id
      AND cs.company_id_purch = cd.company_id_purch
      AND cs.company_id_sales = cd.company_id_sales_conv --company_id_sales
      AND cs.po_no            = cd.po_no
      AND cs.po_item_seq      = cd.po_item_seq
      AND cs.origin_item_id   = cd.origin_item_id

      WHERE  cs.valid_yn = 'N'
      AND    ISNULL(cd.division_id, '') = ''; -- Detail 에 GR 이 없는 경우

	  -- CO Detail 의 GI 정보 기준으로 GR 정보 생성 : mat_doc_id = 'ADD_GR'
	  INSERT INTO scm_dnm_intransit_co_detail 
	             ( division_id
                 , doc_type
                 , company_id_purch
                 , company_id_sales
                 , po_no, po_item_seq, order_no, order_item_seq, shipment_no
				 , mat_doc_id
				 , mat_doc_item, plant_id, item_id, origin_item_id, item_name, uom 
                 , qty, outbound_qty, incoterms, transport_mode, transport_mode_erp
				 , doc_posting_date, plant_issue_date, sales_posting_date, on_board_date, etd_date, eta_date, valid_yn
                 , created_by, creation_date, last_updated_by, last_update_date              
                 ,attribute1 -- sold-to 판매처
                 ,attribute2 -- sold-to name 판매처명
                 ,attribute3 -- ship-to 인도처
                 ,attribute4 --ship-to name 인도처명
                 ,final_soldto_code, final_soldto_name, final_incoterms, do_no, do_item_seq
                 )
      SELECT       cd.division_id
                 , 'GR' AS doc_type
                 , cd.company_id_purch
                 , cd.company_id_sales_conv AS company_id_sales
                 , cd.po_no, cd.po_item_seq, cd.order_no, cd.order_item_seq, cd.shipment_no
				 , 'ADD_GR::' + mat_doc_id AS mat_doc_id
				 , cd.mat_doc_item, cd.plant_id, cd.item_id, cd.origin_item_id, cd.item_name, cd.uom 
                 , cd.qty, cd.outbound_qty, cd.incoterms, cd.transport_mode, cd.transport_mode_erp
				 , cd.doc_posting_date, cd.plant_issue_date, cd.sales_posting_date, cd.on_board_date, cd.etd_date, cd.eta_date, cd.valid_yn
                 , 'ADD GR'  created_by, GETDATE() creation_date, 'ADD GR'  last_updated_by, GETDATE() last_update_date              
                 ,cd.attribute1 -- sold-to 판매처
                 ,cd.attribute2 -- sold-to name 판매처명
                 ,cd.attribute3 -- ship-to 인도처
                 ,cd.attribute4 --ship-to name 인도처명
                 ,cd.final_soldto_code, cd.final_soldto_name, cd.final_incoterms, cd.do_no, cd.do_item_seq
      FROM   (SELECT CASE WHEN company_id_sales = @v_COMPANY_SALES THEN @v_ESOC
                          ELSE company_id_sales
                     END company_id_sales_conv
                    , * 
              FROM   scm_dnm_intransit_co_detail cd WITH(NOLOCK) 
              WHERE  doc_type = 'GI'
             ) cd 
      INNER JOIN scm_dnm_intransit_co_summary_temp_n$ cs WITH(NOLOCK) 
      ON  cs.division_id      = cd.division_id
      AND cs.company_id_purch = cd.company_id_purch
      AND cs.company_id_sales = cd.company_id_sales_conv
      AND cs.po_no            = cd.po_no
      AND cs.po_item_seq      = cd.po_item_seq
      AND cs.origin_item_id   = cd.origin_item_id
      
	  -----------------------------------------------------------
      -- Append LOG
      -----------------------------------------------------------
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'APPEND';
      SET @v_log_message = N'Summary Valid N, Detail No GR';
      SET @v_description = N'Summary Valid N, Detail No GR';
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  
      -------------------------------------------------------------------------
	  -- 4. 1번에서 Valid_yn = 'N' 이고 Detail 에 GR 이 있는 경우
      --  미착에서 제외되어 최종 GR 정보는 미수신되므로 Detail 에서 (SUM(GI Qty) - SUM(GR Qty)) 만큼 최종 수신 일자 이전일 GR 로 추가 생성 : mat_doc_id = 'ADD_GR' 
      --  => 초기 정보 수신 이후 정보가 변경되어 오는 경우가 있어 CO Summary의 valid_yn = 'N’ 처리 된 경우 PO/Item_id/mat_doc_id 기준으로 MAX(last_update_date)인 건만 처리해야 함 ????
	  -------------------------------------------------------------------------
	  SELECT cs.division_id, cs.company_id_purch, cs.company_id_sales, cs.po_no, cs.po_item_seq, cs.origin_item_id, cs.valid_yn
           , SUM(cs.po_qty) AS po_qty, SUM(cs.gi_qty) AS gi_qty, SUM(cs.gr_qty) AS gr_qty, SUM(cs.intransit_qty) AS intransit_qty
		   , SUM(cd.qty) AS cd_gr_qty
      INTO   scm_dnm_intransit_co_summary_temp_y$
      FROM   scm_dnm_intransit_co_summary_temp$ cs WITH(NOLOCK) 
		 		
      LEFT OUTER JOIN (SELECT CASE WHEN company_id_sales = @v_COMPANY_SALES THEN @v_ESOC
                                          ELSE company_id_sales
                                     END company_id_sales_conv
                            , * 
                       FROM   scm_dnm_intransit_co_detail cd WITH(NOLOCK) 
                       WHERE  doc_type = 'GR'
                      ) cd
      ON  cs.division_id      = cd.division_id
      AND cs.company_id_purch = cd.company_id_purch
      AND cs.company_id_sales = cd.company_id_sales_conv --company_id_sales
      AND cs.po_no            = cd.po_no
      AND cs.po_item_seq      = cd.po_item_seq
      AND cs.origin_item_id   = cd.origin_item_id

      WHERE  cs.valid_yn = 'N'
      AND    ISNULL(cd.division_id, '') <> '' -- Detail 에 GR 이 있는 경우
      GROUP BY cs.division_id, cs.company_id_purch, cs.company_id_sales, cs.po_no, cs.po_item_seq, cs.origin_item_id, cs.valid_yn
      ;

	  -- 아래 정보의 GI 중 MAX 값 기준으로 GR_ADD 정보 하나 생성할 것
      SELECT cs.division_id, cs.company_id_purch, cs.company_id_sales, cs.po_no, cs.po_item_seq, cs.origin_item_id, cs.valid_yn
           , cs.po_qty, cs.gi_qty, cs.gr_qty, cs.intransit_qty
		   , cd_gi.gi_qty AS sum_gi_qty, cs.cd_gr_qty AS sum_gr_qty
		   , cd_gi.gi_qty - cs.cd_gr_qty AS calc_gr_qty
      INTO   scm_dnm_intransit_co_detail_calc_temp$
      FROM   scm_dnm_intransit_co_summary_temp_y$ cs WITH(NOLOCK) 
	  INNER JOIN (SELECT CASE WHEN company_id_sales = @v_COMPANY_SALES THEN @v_ESOC
                          ELSE company_id_sales
                     END company_id_sales_conv
                    , cd.division_id
                    , cd.company_id_purch
                    , cd.po_no
                    , cd.po_item_seq
                    , cd.origin_item_id
                    , SUM(cd.qty) AS gi_qty
              FROM   scm_dnm_intransit_co_detail cd WITH(NOLOCK) 
              WHERE  doc_type = 'GI'
              GROUP BY CASE WHEN company_id_sales = @v_COMPANY_SALES THEN @v_ESOC
                          ELSE company_id_sales
                     END 
                    , cd.division_id
                    , cd.company_id_purch
                    , cd.po_no
                    , cd.po_item_seq
                    , cd.origin_item_id
             ) cd_gi
      ON  cs.division_id      = cd_gi.division_id
      AND cs.company_id_purch = cd_gi.company_id_purch
      AND cs.company_id_sales = cd_gi.company_id_sales_conv
      AND cs.po_no            = cd_gi.po_no
      AND cs.po_item_seq      = cd_gi.po_item_seq
      AND cs.origin_item_id   = cd_gi.origin_item_id

      WHERE cd_gi.gi_qty > cs.cd_gr_qty 

	  -- CO Detail 에서 (SUM(GI Qty) - SUM(GR Qty)) 만큼 최종 수신 일자 이전일 GR 로 추가 생성 : mat_doc_id = 'ADD_GR'
	  INSERT INTO scm_dnm_intransit_co_detail 
	             ( division_id
                 , doc_type
                 , company_id_purch
                 , company_id_sales
                 , po_no, po_item_seq, order_no, order_item_seq, shipment_no
				 , mat_doc_id
				 , mat_doc_item, plant_id, item_id, origin_item_id, item_name, uom 
                 , qty, outbound_qty, incoterms, transport_mode, transport_mode_erp
				 , doc_posting_date, plant_issue_date, sales_posting_date, on_board_date, etd_date, eta_date, valid_yn
                 , created_by, creation_date, last_updated_by, last_update_date              
                 ,attribute1 -- sold-to 판매처
                 ,attribute2 -- sold-to name 판매처명
                 ,attribute3 -- ship-to 인도처
                 ,attribute4 --ship-to name 인도처명
                 ,final_soldto_code, final_soldto_name, final_incoterms, do_no, do_item_seq
                 )
      SELECT       cd_gr.division_id
                 , 'GR' AS doc_type
                 , cd_gr.company_id_purch
                 , cd_gr.company_id_sales_conv AS company_id_sales
                 , cd_gr.po_no, cd_gr.po_item_seq, cd_gr.order_no, cd_gr.order_item_seq, cd_gr.shipment_no
				 , 'ADD_GR::' + cd_gr.mat_doc_id AS mat_doc_id
				 , cd_gr.mat_doc_item, cd_gr.plant_id, cd_gr.item_id, cd_gr.origin_item_id, cd_gr.item_name, cd_gr.uom 
                 , cdc.calc_gr_qty AS qty
                 , cdc.calc_gr_qty AS outbound_qty
                 , cd_gr.incoterms, cd_gr.transport_mode, cd_gr.transport_mode_erp
				 , cd_gr.doc_posting_date, cd_gr.plant_issue_date, cd_gr.sales_posting_date, cd_gr.on_board_date, cd_gr.etd_date, cd_gr.eta_date, cd_gr.valid_yn
                 , 'ADD GR2'  created_by, GETDATE() creation_date, 'ADD GR2'  last_updated_by, GETDATE() last_update_date              
                 ,cd_gr.attribute1 -- sold-to 판매처
                 ,cd_gr.attribute2 -- sold-to name 판매처명
                 ,cd_gr.attribute3 -- ship-to 인도처
                 ,cd_gr.attribute4 --ship-to name 인도처명
                 ,cd_gr.final_soldto_code, cd_gr.final_soldto_name, cd_gr.final_incoterms, cd_gr.do_no, cd_gr.do_item_seq
      FROM   scm_dnm_intransit_co_detail_calc_temp$ cdc WITH(NOLOCK) 
	  INNER JOIN (SELECT CASE WHEN company_id_sales = @v_COMPANY_SALES THEN @v_ESOC
                          ELSE company_id_sales
                     END company_id_sales_conv
					, ROW_NUMBER() OVER (PARTITION BY division_id,company_id_purch, company_id_sales, po_no, po_item_seq, origin_item_id
                                         ORDER BY mat_doc_id, sales_posting_date, last_update_date
                                        ) AS row_num      
                    , cd.*      
              FROM   scm_dnm_intransit_co_detail cd WITH(NOLOCK) 
              WHERE  doc_type = 'GR'
             ) cd_gr
      ON  cdc.division_id      = cd_gr.division_id
      AND cdc.company_id_purch = cd_gr.company_id_purch
      AND cdc.company_id_sales = cd_gr.company_id_sales_conv
      AND cdc.po_no            = cd_gr.po_no
      AND cdc.po_item_seq      = cd_gr.po_item_seq
      AND cdc.origin_item_id   = cd_gr.origin_item_id
      
      WHERE  1=1
      AND    cd_gr.row_num = 1
	  ;
	  
	  -----------------------------------------------------------
      -- Append LOG
      -----------------------------------------------------------
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'APPEND';
      SET @v_log_message = N'Summary Valid N, Detail GR';
      SET @v_description = N'Summary Valid N, Detail GR';
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  	  
       -----------------------------------------------------------
       -- Temp Drop
       -----------------------------------------------------------
      IF OBJECT_ID('dbo.scm_dnm_intransit_co_summary_temp$') IS NOT NULL DROP TABLE scm_dnm_intransit_co_summary_temp$
      IF OBJECT_ID('dbo.scm_dnm_intransit_co_summary_temp_n$') IS NOT NULL DROP TABLE scm_dnm_intransit_co_summary_temp_n$
      IF OBJECT_ID('dbo.scm_dnm_intransit_co_summary_temp_y$') IS NOT NULL DROP TABLE scm_dnm_intransit_co_summary_temp_y$
      IF OBJECT_ID('dbo.scm_dnm_intransit_co_detail_calc_temp$') IS NOT NULL DROP TABLE scm_dnm_intransit_co_detail_calc_temp$

      SET @n_log_count = @@ROWCOUNT;

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
    SET @v_log_type    = 'ERROR';
    SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
    SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  END CATCH;

  -- 종료 LOG
  SET @v_log_type    = 'END';
  SET @v_log_message = '########## END of procedure ##########';
  SET @v_description = '';
  SET @d_event_date  = SYSDATETIME();
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END;
