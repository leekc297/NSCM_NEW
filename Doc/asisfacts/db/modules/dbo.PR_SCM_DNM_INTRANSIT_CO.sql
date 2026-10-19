
CREATE PROCEDURE [dbo].[PR_SCM_DNM_INTRANSIT_CO]
AS
/*
 * Program ID   : PR_SCM_DNM_INTRANSIT_CO
 * Description  : 법인간 운송중 재고 정보 I/F 
 * Program History
 * 
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.09.18   Kim Jihye      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020.03.04   KSG            C20200227-000175  CNA법인-고객사(HLGP) 간 운송중 재고 반영건
 * 2020.05.19   KSG            C20200519-000150 VMI-in Request CIP조건 입력 시 출하 계획이 D조건으로 생성되는 시스템 수정 요청드립니다 : ESS인 경우 VMI 라도 'DAP' 처리 안 함
 * 2020.10.07   KSG            PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ERP
 *                                신규 컬럼 추가 : final_soldto_code / final_soldto_name / final_incoterms
 *                                     Detail 은 컬럼만 존재하고 실제 정보 IF 대상 아님(ERP 의견)
 *                                Site Mapping 수정
 * 2020.10.22   KSG            C20201021-000289  [SCM PI팀] G260/G540 : 법인간 재고 판매법인용 To Site Mapping 추가
 * 2020.10.28   KSG            ESS인 VMI : 'DAP' 처리
 * 2022.01.21   KSG            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : SSP 정보를 사용한 Site Mapping
 * 2022.04.25   KSG            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division 추가
 * 2022.08.12   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 : I/F에서 DO_NO / DO_ITEM_SEQ 로 추가 수신함에 따른 대응조치 (DO_NO / DO_ITEM_SEQ 추가)
 * 2023/03/23	hrkim		   [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 */
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- LOG 용 변수 설정
  DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
  DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_INTRANSIT_CO';
  DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
  DECLARE @n_log_count    INTEGER = 0;
  DECLARE @v_log_message  NVARCHAR(1000);
  DECLARE @v_description  NVARCHAR(500);
  DECLARE @d_event_date   DATETIME;
  DECLARE @v_ifseqno      NVARCHAR(30); 

  -- 시작 LOG
  SET @v_log_type    = 'START';
  SET @v_log_message = '########## Start of procedure ##########';
  SET @v_description = '';
  SET @d_event_date  = SYSDATETIME();

  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  BEGIN TRY
    BEGIN

	  /*===================================== 인터페이스 대상 =====================================*/	  
      UPDATE xif_erp_intransit_co_summary_r_sn 
      SET    transfer_flag = 'P'
      WHERE  transfer_flag = 'N';

      UPDATE xif_erp_intransit_co_detail_r_sn 
      SET    transfer_flag = 'P'
      WHERE  transfer_flag = 'N';

      -------------------------------------------------------------------------
	  -- 20220425 PJ20216891 : GM JV 가상 Division 추가
	  -- 처리대상 Temp Table 생성
	  -------------------------------------------------------------------------
      IF OBJECT_ID('dbo.xif_erp_intransit_co_summary_r_sn_temp$') IS NOT NULL DROP TABLE xif_erp_intransit_co_summary_r_sn_temp$
      IF OBJECT_ID('dbo.xif_erp_intransit_co_detail_r_sn_temp$') IS NOT NULL DROP TABLE xif_erp_intransit_co_detail_r_sn_temp$

      SELECT * 
      INTO   xif_erp_intransit_co_summary_r_sn_temp$
      FROM   xif_erp_intransit_co_summary_r_sn WITH(NOLOCK)
	  WHERE  transfer_flag = 'P'

      SELECT * 
      INTO   xif_erp_intransit_co_detail_r_sn_temp$
      FROM   xif_erp_intransit_co_detail_r_sn WITH(NOLOCK)
	  WHERE  transfer_flag = 'P'
	 
	  -- GM JV : division Size 변경
      ALTER TABLE xif_erp_intransit_co_summary_r_sn_temp$ ALTER COLUMN division_id NVARCHAR(10) NULL;
	 
	  -- GM JV : division Size 변경
      ALTER TABLE xif_erp_intransit_co_detail_r_sn_temp$ ALTER COLUMN division_id NVARCHAR(10) NULL;


	  -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - HM JV 가상 사업부 추가 반영
      IF OBJECT_ID('dbo.JV_PLANT$') IS NOT NULL DROP TABLE JV_PLANT$; 

	    SELECT JP.SEGMENT1		AS DIVISION_ID
			  ,JP.SEGMENT3		AS COMPANY_ID
			  ,MAX(JP.SEGMENT4)	AS DIVISION_ID_JV
		 INTO JV_PLANT$
		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL JP WITH(NOLOCK)
		WHERE 1=1
		  AND JP.LOOKUP_TYPE = 'JV_PLANT'
		  AND JP.VALID_YN = 'Y'
		GROUP BY JP.SEGMENT1
				,JP.SEGMENT3

	  UPDATE TGT 
	     SET TGT.DIVISION_ID = JP.DIVISION_ID_JV
	    FROM xif_erp_intransit_co_summary_r_sn_temp$ TGT
			INNER JOIN JV_PLANT$ JP WITH(NOLOCK)
				    ON JP.DIVISION_ID = TGT.DIVISION_ID
				   AND JP.COMPANY_ID  = TGT.COMPANY_ID_SALES

	  UPDATE TGT 
	     SET TGT.DIVISION_ID = JP.DIVISION_ID_JV
	    FROM xif_erp_intransit_co_detail_r_sn_temp$ TGT
			INNER JOIN JV_PLANT$ JP WITH(NOLOCK)
				    ON JP.DIVISION_ID = TGT.DIVISION_ID
				   AND JP.COMPANY_ID  = TGT.COMPANY_ID_SALES		   

      -------------------------------------------------------------------------
	  -- NERP 구코드 -> 신코드 변경
      -------------------------------------------------------------------------

		UPDATE xif_erp_intransit_co_summary_r_sn_temp$ 
		   SET xif_erp_intransit_co_summary_r_sn_temp$.company_id_purch	= CASE WHEN ISNULL(B.NEW_VALUE1, '') = '' THEN a.company_id_purch
		                                                                       ELSE B.NEW_VALUE1
																		  END 
		 FROM  xif_erp_intransit_co_summary_r_sn_temp$ AS A, 
			  (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER  with (nolock)  WHERE CODETYPE = 'company_id' and attribute5 = '1ST') AS B
		WHERE  A.company_id_purch	= B.OLD_VALUE1

		UPDATE xif_erp_intransit_co_summary_r_sn_temp$ 
		   SET xif_erp_intransit_co_summary_r_sn_temp$.company_id_sales	= CASE WHEN ISNULL(B.NEW_VALUE1, '') = '' THEN a.company_id_sales
		                                                                       ELSE B.NEW_VALUE1
																		  END
		 FROM  xif_erp_intransit_co_summary_r_sn_temp$ AS A, 
			  (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER  with (nolock)  WHERE CODETYPE = 'company_id' and attribute5 = '1ST') AS B
		WHERE  A.company_id_sales	= B.OLD_VALUE1

		UPDATE xif_erp_intransit_co_summary_r_sn_temp$ 
		   SET xif_erp_intransit_co_summary_r_sn_temp$.plant_id_purch	= CASE WHEN ISNULL(B.NEW_VALUE1, '') = '' THEN a.plant_id_purch
		                                                                       ELSE B.NEW_VALUE1
																		  END
		 FROM  xif_erp_intransit_co_summary_r_sn_temp$ AS A, 
			  (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER  with (nolock)  WHERE CODETYPE = 'plant_id' and attribute5 = '1ST') AS B
		WHERE  A.plant_id_purch	= B.OLD_VALUE1
		
		-------------------------------------------------------------------------------------------------------------------------------------------------

		UPDATE xif_erp_intransit_co_detail_r_sn_temp$ 
		   SET xif_erp_intransit_co_detail_r_sn_temp$.company_id_purch	= CASE WHEN ISNULL(B.NEW_VALUE1, '') = '' THEN a.company_id_purch
		                                                                       ELSE B.NEW_VALUE1
																		  END
		 FROM  xif_erp_intransit_co_detail_r_sn_temp$ AS A, 
			  (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER  with (nolock)  WHERE CODETYPE = 'company_id' and attribute5 = '1ST') AS B
		WHERE  A.company_id_purch	= B.OLD_VALUE1

		UPDATE xif_erp_intransit_co_detail_r_sn_temp$ 
		   SET xif_erp_intransit_co_detail_r_sn_temp$.company_id_sales	= CASE WHEN ISNULL(B.NEW_VALUE1, '') = '' THEN a.company_id_sales
		                                                                       ELSE B.NEW_VALUE1
																		  END
		 FROM  xif_erp_intransit_co_detail_r_sn_temp$ AS A, 
			  (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER  with (nolock)  WHERE CODETYPE = 'company_id' and attribute5 = '1ST') AS B
		WHERE  A.company_id_sales	= B.OLD_VALUE1

		UPDATE xif_erp_intransit_co_detail_r_sn_temp$ 
		   SET xif_erp_intransit_co_detail_r_sn_temp$.plant_id	=CASE WHEN ISNULL(B.NEW_VALUE1, '') = '' THEN a.plant_id
		                                                                       ELSE B.NEW_VALUE1
																		  END
		 FROM  xif_erp_intransit_co_detail_r_sn_temp$ AS A, 
			  (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER  with (nolock)  WHERE CODETYPE = 'plant_id' and attribute5 = '1ST') AS B
		WHERE  A.plant_id	= B.OLD_VALUE1

      -------------------------------------------------------------------------
	  -- NERP 신코드 -> 구코드 변경
      -------------------------------------------------------------------------

		UPDATE xif_erp_intransit_co_summary_r_sn_temp$ 
		   SET xif_erp_intransit_co_summary_r_sn_temp$.company_id_purch	= CASE WHEN ISNULL(B.OLD_VALUE1, '') = '' THEN a.company_id_purch
		                                                                       ELSE B.OLD_VALUE1
																		  END 
		 FROM  xif_erp_intransit_co_summary_r_sn_temp$ AS A, 
			  (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER  with (nolock)  WHERE CODETYPE = 'company_id' and attribute5 <> '1ST') AS B
		WHERE  A.company_id_purch	= B.NEW_VALUE1

		UPDATE xif_erp_intransit_co_summary_r_sn_temp$ 
		   SET xif_erp_intransit_co_summary_r_sn_temp$.company_id_sales	= CASE WHEN ISNULL(B.OLD_VALUE1, '') = '' THEN a.company_id_sales
		                                                                       ELSE B.OLD_VALUE1
																		  END
		 FROM  xif_erp_intransit_co_summary_r_sn_temp$ AS A, 
			  (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER  with (nolock)  WHERE CODETYPE = 'company_id' and attribute5 <> '1ST') AS B
		WHERE  A.company_id_sales	= B.NEW_VALUE1

		UPDATE xif_erp_intransit_co_summary_r_sn_temp$ 
		   SET xif_erp_intransit_co_summary_r_sn_temp$.plant_id_purch	= CASE WHEN ISNULL(B.OLD_VALUE1, '') = '' THEN a.plant_id_purch
		                                                                       ELSE B.OLD_VALUE1
																		  END
		 FROM  xif_erp_intransit_co_summary_r_sn_temp$ AS A, 
			  (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER  with (nolock)  WHERE CODETYPE = 'plant_id' and attribute5 <> '1ST') AS B
		WHERE  A.plant_id_purch	= B.NEW_VALUE1
		
		-------------------------------------------------------------------------------------------------------------------------------------------------

		UPDATE xif_erp_intransit_co_detail_r_sn_temp$ 
		   SET xif_erp_intransit_co_detail_r_sn_temp$.company_id_purch	= CASE WHEN ISNULL(B.OLD_VALUE1, '') = '' THEN a.company_id_purch
		                                                                       ELSE B.OLD_VALUE1
																		  END
		 FROM  xif_erp_intransit_co_detail_r_sn_temp$ AS A, 
			  (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER  with (nolock)  WHERE CODETYPE = 'company_id' and attribute5 <> '1ST') AS B
		WHERE  A.company_id_purch	= B.NEW_VALUE1

		UPDATE xif_erp_intransit_co_detail_r_sn_temp$ 
		   SET xif_erp_intransit_co_detail_r_sn_temp$.company_id_sales	= CASE WHEN ISNULL(B.OLD_VALUE1, '') = '' THEN a.company_id_sales
		                                                                       ELSE B.OLD_VALUE1
																		  END
		 FROM  xif_erp_intransit_co_detail_r_sn_temp$ AS A, 
			  (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER  with (nolock)  WHERE CODETYPE = 'company_id' and attribute5 <> '1ST') AS B
		WHERE  A.company_id_sales	= B.NEW_VALUE1

		UPDATE xif_erp_intransit_co_detail_r_sn_temp$ 
		   SET xif_erp_intransit_co_detail_r_sn_temp$.plant_id	=CASE WHEN ISNULL(B.OLD_VALUE1, '') = '' THEN a.plant_id
		                                                                       ELSE B.OLD_VALUE1
																		  END
		 FROM  xif_erp_intransit_co_detail_r_sn_temp$ AS A, 
			  (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER  with (nolock)  WHERE CODETYPE = 'plant_id' and attribute5 <> '1ST') AS B
		WHERE  A.plant_id	= B.NEW_VALUE1

	  -------------------------------------------------------------------------
	  
	  /*===================================== Summary =====================================*/	
	  -- 기존 미착 재고 N 처리
	  UPDATE scm_dnm_intransit_co_summary
	  SET    valid_yn         = 'N'
	        ,last_update_date = GETDATE()
			,last_updated_by  = @v_batch_user
	  WHERE  valid_yn         = 'Y'
	  AND    company_id_purch IN (SELECT distinct company_id_purch
	                              FROM   xif_erp_intransit_co_summary_r_sn_temp$ -- 20220425 PJ20216891 : GM JV 가상 Division 추가 xif_erp_intransit_co_summary_r_sn
								  WHERE  transfer_flag = 'P');

	  -- 본 Table 에 반영
      DECLARE cur_summary CURSOR FOR
        SELECT ifseqno
        FROM   xif_erp_intransit_co_summary_r_sn_temp$ WITH(NOLOCK) -- 20220425 PJ20216891 : GM JV 가상 Division 추가 xif_erp_intransit_co_summary_r_sn
        WHERE  transfer_flag = 'P'
        GROUP BY ifseqno
        ORDER BY ifseqno ASC;

      OPEN cur_summary;
      FETCH NEXT FROM cur_summary INTO @v_ifseqno ;
     
      WHILE (@@FETCH_STATUS = 0)        
        BEGIN
      
          MERGE INTO scm_dnm_intransit_co_summary cs
          USING (SELECT  division_id
                        ,company_id_purch
                        ,company_id_sales
                        ,plant_id_purch
                        ,po_no
                        ,po_item_seq
                        ,'' AS from_scm_site_id
                        ,'' AS to_scm_site_id
                        ,DBO.FN_GET_PACKER_PLAN_ITEM_ID(division_id, item_id) AS item_id
                        ,item_id                                              AS origin_item_id
                        ,item_name
                        ,uom                        
						,ISNULL(po_qty, 0)        AS po_qty
                        ,ISNULL(gi_qty, 0)        AS gi_qty
                        ,ISNULL(gr_qty, 0)        AS gr_qty
                        ,ISNULL(intransit_qty, 0) AS intransit_qty
                        ,incoterms						
                        ,DBO.FN_GET_TRANSPORT_MODE_ERP(transport_mode) AS transport_mode
						,transport_mode                                AS transport_mode_erp
                        ,CASE WHEN ISDATE(purch_proof_date) = 1   THEN purch_proof_date   ELSE NULL END AS purch_proof_date                        
						,CASE WHEN ISDATE(plant_issue_date) = 1   THEN plant_issue_date   ELSE NULL END AS plant_issue_date
                        ,CASE WHEN ISDATE(sales_posting_date) = 1 THEN sales_posting_date ELSE NULL END AS sales_posting_date
                        ,CASE WHEN ISDATE(on_board_date) = 1      THEN on_board_date      ELSE NULL END AS on_board_date
                        ,CASE WHEN ISDATE(etd_date) = 1           THEN etd_date           ELSE NULL END AS etd_date
                        ,CASE WHEN ISDATE(eta_date) = 1           THEN eta_date           ELSE NULL END AS eta_date
                        ,attribute1 -- C20200227-000175 : sold-to 판매처
                        ,attribute2 -- C20200227-000175 : sold-to name 판매처명
                        ,attribute3 -- C20200227-000175 : ship-to 인도처
                        ,attribute4 -- C20200227-000175 : ship-to name 인도처명
                        -- 20201007 PJ20202001  신규 컬럼 추가
                        ,final_soldto_code, final_soldto_name, final_incoterms
                 FROM   xif_erp_intransit_co_summary_r_sn_temp$ csr WITH(NOLOCK) -- 20220425 PJ20216891 : GM JV 가상 Division 추가 xif_erp_intransit_co_summary_r_sn
                 WHERE  ifseqno       = @v_ifseqno
                 AND    transfer_flag = 'P') csr
          ON     cs.division_id       = csr.division_id
		  AND    cs.company_id_purch  = csr.company_id_purch
		  AND    cs.company_id_sales  = csr.company_id_sales
		  AND    cs.plant_id_purch    = csr.plant_id_purch
		  AND    cs.po_no             = csr.po_no
		  AND    cs.po_item_seq       = csr.po_item_seq
		  AND    cs.origin_item_id    = csr.origin_item_id
         
          WHEN MATCHED THEN
          
          UPDATE 
          SET    cs.from_scm_site_id   = csr.from_scm_site_id
		        ,cs.to_scm_site_id     = csr.to_scm_site_id
				,cs.item_id            = csr.item_id
				,cs.item_name          = csr.item_name
				,cs.uom                = csr.uom
				,cs.po_qty             = csr.po_qty
				,cs.gi_qty             = csr.gi_qty
				,cs.gr_qty             = csr.gr_qty
				,cs.intransit_qty      = csr.intransit_qty
				,cs.incoterms          = csr.incoterms
				,cs.transport_mode     = csr.transport_mode
				,cs.transport_mode_erp = csr.transport_mode_erp
				,cs.purch_proof_date   = csr.purch_proof_date
				,cs.plant_issue_date   = csr.plant_issue_date
				,cs.sales_posting_date = csr.sales_posting_date
				,cs.on_board_date      = csr.on_board_date
				,cs.etd_date           = csr.etd_date
				,cs.eta_date           = csr.eta_date
				,cs.valid_yn           = 'Y'
                ,cs.last_updated_by    = @v_batch_user
                ,cs.last_update_date   = GETDATE()		
                ,cs.attribute1         = csr.attribute1 -- C20200227-000175 : sold-to 판매처
                ,cs.attribute2         = csr.attribute2 -- C20200227-000175 : sold-to name 판매처명
                ,cs.attribute3         = csr.attribute3 -- C20200227-000175 : ship-to 인도처
                ,cs.attribute4         = csr.attribute4 -- C20200227-000175 : ship-to name 인도처명
                -- 20201007 PJ20202001  신규 컬럼 추가
				,cs.final_soldto_code  = csr.final_soldto_code
				,cs.final_soldto_name  = csr.final_soldto_name
				,cs.final_incoterms    = csr.final_incoterms
          WHEN NOT MATCHED THEN

          INSERT (division_id
                 ,company_id_purch
                 ,company_id_sales
                 ,plant_id_purch
                 ,po_no
                 ,po_item_seq
                 ,from_scm_site_id
                 ,to_scm_site_id
                 ,item_id
                 ,origin_item_id
                 ,item_name
                 ,uom                        
				 ,po_qty
                 ,gi_qty
                 ,gr_qty
                 ,intransit_qty
                 ,incoterms
                 ,transport_mode
                 ,transport_mode_erp
                 ,purch_proof_date                        
			 	 ,plant_issue_date
                 ,sales_posting_date
                 ,on_board_date
                 ,etd_date
                 ,eta_date
                 ,valid_yn
                 ,created_by
                 ,creation_date
                 ,last_updated_by
                 ,last_update_date         
                 ,attribute1 -- C20200227-000175 : sold-to 판매처
                 ,attribute2 -- C20200227-000175 : sold-to name 판매처명
                 ,attribute3 -- C20200227-000175 : ship-to 인도처
                 ,attribute4 -- C20200227-000175 : ship-to name 인도처명
                 -- 20201007 PJ20202001  신규 컬럼 추가
                 ,final_soldto_code, final_soldto_name, final_incoterms              
                 )
          VALUES (csr.division_id
                 ,csr.company_id_purch
                 ,csr.company_id_sales
                 ,csr.plant_id_purch
                 ,csr.po_no
                 ,csr.po_item_seq
                 ,csr.from_scm_site_id
                 ,csr.to_scm_site_id
                 ,csr.item_id
                 ,csr.origin_item_id
                 ,csr.item_name
                 ,csr.uom                        
				 ,csr.po_qty
                 ,csr.gi_qty
                 ,csr.gr_qty
                 ,csr.intransit_qty
                 ,csr.incoterms
                 ,csr.transport_mode
                 ,csr.transport_mode_erp
                 ,csr.purch_proof_date                        
			 	 ,csr.plant_issue_date
                 ,csr.sales_posting_date
                 ,csr.on_board_date
                 ,csr.etd_date
                 ,csr.eta_date
                 ,'Y'
                 ,@v_batch_user
                 ,GETDATE()
                 ,@v_batch_user
                 ,GETDATE() 
                 ,csr.attribute1 -- C20200227-000175 : sold-to 판매처
                 ,csr.attribute2 -- C20200227-000175 : sold-to name 판매처명
                 ,csr.attribute3 -- C20200227-000175 : ship-to 인도처
                 ,csr.attribute4 -- C20200227-000175 : ship-to name 인도처명
                 -- 20201007 PJ20202001  신규 컬럼 추가
                 ,csr.final_soldto_code, csr.final_soldto_name, csr.final_incoterms    
                 )
          ;

          -----------------------------------------------------------
          -- Merge LOG
          -----------------------------------------------------------
          SET @n_log_count = @@ROWCOUNT;
          SET @v_log_type = 'APPEND';
          SET @v_log_message = 'MERGE INTO scm_dnm_intransit_co_summary';
          SET @v_description = 'ifseqno = ' + @v_ifseqno;
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
          -----------------------------------------------------------
    
          FETCH NEXT FROM cur_summary INTO  @v_ifseqno
        END
    
      CLOSE cur_summary;
      DEALLOCATE cur_summary;


	  /*===================================== Detail =====================================*/
	  -- 기존 미착 재고 N 처리
	  UPDATE scm_dnm_intransit_co_detail
	  SET    valid_yn         = 'N'
	        ,last_update_date = GETDATE()
			,last_updated_by  = @v_batch_user
	  WHERE  valid_yn         = 'Y'
	  AND    company_id_purch IN (SELECT distinct company_id_purch
	                              FROM   xif_erp_intransit_co_detail_r_sn_temp$ -- 20220425 PJ20216891 : GM JV 가상 Division 추가 xif_erp_intransit_co_detail_r_sn
								  WHERE  transfer_flag = 'P');

	  -- 본 Table 에 반영
      DECLARE cur_detail CURSOR FOR
        SELECT ifseqno
        FROM   xif_erp_intransit_co_detail_r_sn_temp$ WITH(NOLOCK) -- 20220425 PJ20216891 : GM JV 가상 Division 추가 xif_erp_intransit_co_detail_r_sn
        WHERE  transfer_flag = 'P'
        GROUP BY ifseqno
        ORDER BY ifseqno ASC;

      OPEN cur_detail;
      FETCH NEXT FROM cur_detail INTO @v_ifseqno ;
     
      WHILE (@@FETCH_STATUS = 0)        
        BEGIN
      
          MERGE INTO scm_dnm_intransit_co_detail cs
          USING (SELECT  division_id
                        ,doc_type
                        ,company_id_purch
                        ,company_id_sales
                        ,po_no
                        ,po_item_seq
                        ,order_no
                        ,order_item_seq
                        ,shipment_no                        
						,mat_doc_id
						,mat_doc_item
                        ,plant_id
                        ,DBO.FN_GET_PACKER_PLAN_ITEM_ID(division_id, item_id) AS item_id
                        ,item_id                                              AS origin_item_id
                        ,item_name
                        ,uom                        
                        ,ISNULL(qty, 0) AS qty
                        ,ISNULL(outbound_qty, 0) outbound_qty
                        ,incoterms
                        ,DBO.FN_GET_TRANSPORT_MODE_ERP(transport_mode) AS transport_mode
						,transport_mode                                AS transport_mode_erp
						,CASE WHEN ISDATE(doc_posting_date) = 1   THEN doc_posting_date   ELSE NULL END AS doc_posting_date
                        ,CASE WHEN ISDATE(plant_issue_date) = 1   THEN plant_issue_date   ELSE NULL END AS plant_issue_date
                        ,CASE WHEN ISDATE(sales_posting_date) = 1 THEN sales_posting_date ELSE NULL END AS sales_posting_date
                        ,CASE WHEN ISDATE(on_board_date) = 1      THEN on_board_date      ELSE NULL END AS on_board_date
                        ,CASE WHEN ISDATE(etd_date) = 1           THEN etd_date           ELSE NULL END AS etd_date
                        ,CASE WHEN ISDATE(eta_date) = 1           THEN eta_date           ELSE NULL END AS eta_date
                        ,attribute1 -- C20200227-000175 : sold-to 판매처
                        ,attribute2 -- C20200227-000175 : sold-to name 판매처명
                        ,attribute3 -- C20200227-000175 : ship-to 인도처
                        ,attribute4 -- C20200227-000175 : ship-to name 인도처명
                        -- 20201007 PJ20202001  신규 컬럼 추가
                        ,final_soldto_code, final_soldto_name, final_incoterms
                        ,IIF(ISNULL(do_no, '') = '', '-', do_no) do_no, IIF(ISNULL(do_item_seq, '') = '', '-', do_item_seq) do_item_seq
                 FROM   xif_erp_intransit_co_detail_r_sn_temp$ cdr WITH(NOLOCK) -- 20220425 PJ20216891 : GM JV 가상 Division 추가 xif_erp_intransit_co_detail_r_sn
                 WHERE  ifseqno       = @v_ifseqno
                 AND    transfer_flag = 'P') cdr
          ON     cs.division_id             = cdr.division_id
		  AND    cs.doc_type                = cdr.doc_type
		  AND    cs.company_id_purch        = cdr.company_id_purch
		  AND    cs.company_id_sales        = cdr.company_id_sales
		  AND    cs.po_no                   = cdr.po_no
		  AND    cs.po_item_seq             = cdr.po_item_seq
		  AND    cs.order_no                = cdr.order_no
		  AND    cs.order_item_seq          = cdr.order_item_seq
		  AND    cs.shipment_no             = cdr.shipment_no
		  AND    cs.mat_doc_id              = cdr.mat_doc_id
		  AND    cs.mat_doc_item            = cdr.mat_doc_item
		  AND    cs.origin_item_id          = cdr.origin_item_id
		  AND    cs.do_no                   = cdr.do_no
		  AND    cs.do_item_seq             = cdr.do_item_seq
         
          WHEN MATCHED THEN
          
          UPDATE 
          SET    cs.plant_id           = cdr.plant_id
		        ,cs.item_id            = cdr.item_id
		        ,cs.item_name          = cdr.item_name
				,cs.uom                = cdr.uom
				,cs.qty                = cdr.qty
				,cs.outbound_qty       = cdr.outbound_qty
				,cs.incoterms          = cdr.incoterms
				,cs.transport_mode     = cdr.transport_mode
				,cs.transport_mode_erp = cdr.transport_mode_erp				
				,cs.doc_posting_date   = cdr.doc_posting_date
				,cs.plant_issue_date   = cdr.plant_issue_date
				,cs.sales_posting_date = cdr.sales_posting_date
				,cs.on_board_date      = cdr.on_board_date
				,cs.etd_date           = cdr.etd_date
				,cs.eta_date           = cdr.eta_date
				,cs.valid_yn           = 'Y'
                ,cs.last_updated_by    = @v_batch_user
                ,cs.last_update_date   = GETDATE()		
                ,cs.attribute1         = cdr.attribute1 -- C20200227-000175 : sold-to 판매처
                ,cs.attribute2         = cdr.attribute2 -- C20200227-000175 : sold-to name 판매처명
                ,cs.attribute3         = cdr.attribute3 -- C20200227-000175 : ship-to 인도처
                ,cs.attribute4         = cdr.attribute4 -- C20200227-000175 : ship-to name 인도처명
                -- 20201007 PJ20202001  신규 컬럼 추가
				,cs.final_soldto_code  = cdr.final_soldto_code
				,cs.final_soldto_name  = cdr.final_soldto_name
				,cs.final_incoterms    = cdr.final_incoterms
		        ,cs.do_no              = cdr.do_no
		        ,cs.do_item_seq        = cdr.do_item_seq
          WHEN NOT MATCHED THEN

          INSERT (division_id
                 ,doc_type
                 ,company_id_purch
                 ,company_id_sales
                 ,po_no
                 ,po_item_seq
                 ,order_no
                 ,order_item_seq
                 ,shipment_no
				 ,mat_doc_id
				 ,mat_doc_item
                 ,plant_id
                 ,item_id
                 ,origin_item_id
                 ,item_name
                 ,uom 
                 ,qty
                 ,outbound_qty
                 ,incoterms
                 ,transport_mode
				 ,transport_mode_erp
				 ,doc_posting_date
                 ,plant_issue_date
                 ,sales_posting_date
                 ,on_board_date
                 ,etd_date
                 ,eta_date
                 ,valid_yn
                 ,created_by
                 ,creation_date
                 ,last_updated_by
                 ,last_update_date              
                 ,attribute1 -- C20200227-000175 : sold-to 판매처
                 ,attribute2 -- C20200227-000175 : sold-to name 판매처명
                 ,attribute3 -- C20200227-000175 : ship-to 인도처
                 ,attribute4 -- C20200227-000175 : ship-to name 인도처명
                 -- 20201007 PJ20202001  신규 컬럼 추가
                 ,final_soldto_code, final_soldto_name, final_incoterms
                 ,do_no, do_item_seq
                 )
          VALUES (cdr.division_id
                 ,cdr.doc_type
                 ,cdr.company_id_purch
                 ,cdr.company_id_sales
                 ,cdr.po_no
                 ,cdr.po_item_seq
                 ,cdr.order_no
                 ,cdr.order_item_seq
                 ,cdr.shipment_no
				 ,cdr.mat_doc_id
				 ,cdr.mat_doc_item
                 ,cdr.plant_id
                 ,cdr.item_id
                 ,cdr.origin_item_id
                 ,cdr.item_name
                 ,cdr.uom 
                 ,cdr.qty
                 ,cdr.outbound_qty
                 ,cdr.incoterms
                 ,cdr.transport_mode
				 ,cdr.transport_mode_erp
				 ,cdr.doc_posting_date
                 ,cdr.plant_issue_date
                 ,cdr.sales_posting_date
                 ,cdr.on_board_date
                 ,cdr.etd_date
                 ,cdr.eta_date                 
                 ,'Y'
                 ,@v_batch_user
                 ,GETDATE()
                 ,@v_batch_user
                 ,GETDATE() 
                 ,cdr.attribute1 -- C20200227-000175 : sold-to 판매처
                 ,cdr.attribute2 -- C20200227-000175 : sold-to name 판매처명
                 ,cdr.attribute3 -- C20200227-000175 : ship-to 인도처
                 ,cdr.attribute4 -- C20200227-000175 : ship-to name 인도처명
                 -- 20201007 PJ20202001  신규 컬럼 추가
                 ,cdr.final_soldto_code, cdr.final_soldto_name, cdr.final_incoterms
                 ,cdr.do_no, cdr.do_item_seq
                 )
          ;

          -----------------------------------------------------------
          -- Merge LOG
          -----------------------------------------------------------
          SET @n_log_count = @@ROWCOUNT;
          SET @v_log_type = 'APPEND';
          SET @v_log_message = 'MERGE INTO scm_dnm_intransit_co_detail';
          SET @v_description = 'ifseqno = ' + @v_ifseqno;
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
          -----------------------------------------------------------
    
          FETCH NEXT FROM cur_detail INTO  @v_ifseqno
        END
    
      CLOSE cur_detail;
      DEALLOCATE cur_detail;   

	  /*--------------------------------------------------------------------
	  -- 2023.03.13 PI 요청으로 임시 처리 : ERP 정리 후 원복 예정
	  -- 집계 시 Ship no 0026038982, MAT_DOC_ID 4080176156 건을 예외로 제외 
	  --------------------------------------------------------------------*/
	  DELETE scm_dnm_intransit_co_detail
      WHERE  shipment_no = '0026038982'
      AND    MAT_DOC_ID = '4080176156';

      	  
      /*======20220121 PJ20216891 SSP 정보를 사용한 From/To Site Mapping : START===========================*/
      UPDATE scm_dnm_intransit_co_summary
      SET    from_scm_site_id = c.from_site 
           , to_scm_site_id   = c.to_site 
           , attribute5       = c.confirm_id 
      FROM   scm_dnm_intransit_co_summary cs WITH(NOLOCK)
	  
      INNER JOIN  (SELECT  cd.division_id
                    ,cd.company_id_purch
	                ,cd.company_id_sales
	                ,cd.po_no
	                ,cd.po_item_seq
	                ,cd.origin_item_id
	                ,MAX(cd.order_no) AS order_no
	                ,MAX(cd.order_item_seq) AS order_item_seq
					,DBO.FN_GET_ITEM_OPERATION_GROUP(cd.division_id,cd.origin_item_id) operation_group
             FROM   scm_dnm_intransit_co_detail cd WITH(NOLOCK)
             WHERE  cd.doc_type = 'GI'
			 AND    cd.valid_yn = 'Y'
             GROUP BY cd.division_id
                     ,cd.company_id_purch
	                 ,cd.company_id_sales
          	         ,cd.po_no
	       	         ,cd.po_item_seq
	       	         ,cd.origin_item_id
  	                 ,cd.doc_type) cd
      ON     cs.division_id      = cd.division_id
      AND    cs.company_id_purch = cd.company_id_purch
      AND    cs.company_id_sales = cd.company_id_sales
      AND    cs.po_no            = cd.po_no
      AND    cs.po_item_seq      = cd.po_item_seq
      AND    cs.origin_item_id   = cd.origin_item_id

      INNER JOIN (SELECT  DISTINCT division_id, order_no, LTRIM( RTRIM( STR(CONVERT(INT, CONVERT(NUMERIC, order_item_seq))) ))   order_item_seq, origin_item_id, plant_id
                         ,confirm_id, FROM_SCM_SITE_ID, TO_SCM_SITE_ID
                  FROM   scm_dnm_exfactory_result a WITH(NOLOCK)
                  WHERE isnull(confirm_id, '') <> ''
                  ) B
      ON     cd.division_id    = B.division_id
	  AND    cd.order_no       LIKE '%' + B.order_no
	  AND    cd.order_item_seq LIKE '%' + B.order_item_seq
      AND    cd.origin_item_id =          B.origin_item_id
	  
      INNER JOIN 
	       ( 
	        SELECT sc.division_id, sc.confirm_id, fcst_type, MAX(sc.from_site) from_site, MAX(ISNULL(md.segment1, sc.to_site)) to_site
            FROM   ssp_anl_ship_confirm sc WITH (NOLOCK)

                   LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                   ON   sc.division_id = md.segment3
                   AND  sc.to_site     = md.segment2
                   AND  md.lookup_type = 'AS_SITE_PLANT'
                   AND  md.valid_yn    = 'Y'

            WHERE  1=1
            --AND    fcst_type IN ('WS', 'WSF', 'AS', 'ASF')
            GROUP BY sc.division_id, sc.confirm_id, fcst_type
           ) c
      ON     b.division_id = c.division_id
      AND    b.confirm_id  = c.confirm_id
	  
      WHERE  ISNULL(cs.from_scm_site_id, '') = ''
	  OR     ISNULL(cs.to_scm_site_id, '')   = '';
      	  
      /*======20220121 PJ20216891 SSP 정보를 사용한 From/To Site Mapping : END===========================*/   
      
      /*===================================== From Site Mapping =====================================*/
      	  
      /*======20220121 PJ20216891 SSP 정보를 사용한 From/To Site Mapping : START===========================*/

	  -- 1. po_no 를사용한 From Site Mapping
      UPDATE scm_dnm_intransit_co_summary
      SET    from_scm_site_id = B.from_site 
	        ,plant_id_sales   = IIF(s.osp_yn = 'Y', s.logistic_plant_id, s.plant_id) 
      FROM   scm_dnm_intransit_co_summary cs WITH(NOLOCK)

      INNER JOIN 
	       ( 
	        SELECT sc.division_id, sc.erp_so_no, MAX(sc.from_site) from_site
            FROM   ssp_anl_ship_confirm sc WITH (NOLOCK)
            WHERE  1=1
            AND    fcst_type IN ('WS', 'WSF', 'AS', 'ASF')
            GROUP BY sc.division_id, sc.erp_so_no
           ) b 
      ON     cs.division_id = b.division_id
      AND    cs.po_no       = b.erp_so_no	  

      LEFT OUTER JOIN scm_mst_site s WITH(NOLOCK)
      ON     s.division_id = b.division_id
      AND    s.scm_site_id = b.from_site

      WHERE  ISNULL(cs.from_scm_site_id, '') = '';	  

      /*======20220121 SSP 정보를 사용한 From/To Site Mapping : END===========================*/

	  UPDATE scm_dnm_intransit_co_summary
	  SET    from_scm_site_id = ISNULL(ms.scm_site_id, -- 1. Plant 에 Site 가 하나인 경우
	                            ISNULL(es.scm_site_id, -- 2. 전극이 Cell Plant 에서 출하되는 경우 (A040, G451)
								DBO.FN_GET_SCM_SITE_ID_PLANT(cd.plant_id, cd.operation_group))) -- 3. Operation Group 에 따라 Site Mapping
	        ,plant_id_sales   = cd.plant_id
			,last_update_date = GETDATE()
	  FROM   scm_dnm_intransit_co_summary cs WITH(NOLOCK)
      JOIN  (SELECT  cd.division_id
                    ,cd.company_id_purch
	                ,cd.company_id_sales
	                ,cd.po_no
	                ,cd.po_item_seq
	                ,cd.origin_item_id
	                ,cd.doc_type
	                ,MAX(cd.plant_id) plant_id
					,DBO.FN_GET_ITEM_OPERATION_GROUP(cd.division_id,cd.origin_item_id) operation_group
             FROM   scm_dnm_intransit_co_detail cd WITH(NOLOCK)
             WHERE  cd.doc_type = 'GI'
			 AND    cd.valid_yn = 'Y'
             GROUP BY cd.division_id
                     ,cd.company_id_purch
	                 ,cd.company_id_sales
          	         ,cd.po_no
	       	         ,cd.po_item_seq
	       	         ,cd.origin_item_id
  	                 ,cd.doc_type) cd
      ON     cs.division_id      = cd.division_id
      AND    cs.company_id_purch = cd.company_id_purch
      AND    cs.company_id_sales = cd.company_id_sales
      AND    cs.po_no            = cd.po_no
      AND    cs.po_item_seq      = cd.po_item_seq
      AND    cs.origin_item_id   = cd.origin_item_id
      LEFT JOIN -- Plant 에 Site 가 하나인 경우
            (SELECT division_id
	               ,plant_id
                   ,max(scm_site_id) AS scm_site_id
             FROM   scm_mst_site
             WHERE  site_type = 'PLANT'
	         AND    osp_yn    = 'N'
             AND    valid_yn  = 'Y'
             GROUP BY division_id
			         ,plant_id
             HAVING count(distinct scm_site_id) = 1) ms
      ON     cd.division_id = ms.division_id
      AND    cd.plant_id    = ms.plant_id
      LEFT JOIN -- 전극이 Cell Plant 에서 출하되는 경우 (A040, G451)
            (SELECT segment1 AS plant_id
                   ,segment2 AS scm_site_id
             FROM   scm_adm_lookup_master_detail A WITH(NOLOCK) 
             WHERE  lookup_type  = 'ELECTRODE_SHIP_SITE' 
             AND    valid_yn     = 'Y' 
             AND    segment3     = '*') es
      ON     cd.plant_id         = es.plant_id
      AND    cd.operation_group  = 'E'
	  WHERE  cs.valid_yn         = 'Y'
	  AND    ISNULL(cs.from_scm_site_id, '') = ''
      ;

	  /*===================================== To Site Mapping =====================================*/
      	  
      /*======20220121 PJ20216891 SSP 정보를 사용한 To Site Mapping : START===========================*/

	  -- 1. po_no 를사용한 To Site Mapping
      UPDATE scm_dnm_intransit_co_summary
      SET    to_scm_site_id = B.to_site 
      FROM   scm_dnm_intransit_co_summary cs WITH(NOLOCK)
      INNER JOIN 
	       ( 
	        SELECT sc.division_id, sc.erp_so_no, MAX(ISNULL(md.segment1, sc.to_site)) AS to_site
                 FROM   ssp_anl_ship_confirm sc WITH (NOLOCK)

                      LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                      ON   sc.division_id = md.segment3
                      AND  sc.to_site     = md.segment2
                      AND  md.lookup_type = 'AS_SITE_PLANT'
                      AND  md.valid_yn    = 'Y'

                 WHERE  1=1
                 AND    fcst_type IN ('WS', 'WSF', 'AS', 'ASF')
				 GROUP BY sc.division_id, sc.erp_so_no
           ) b 
      ON    cs.division_id = b.division_id
      AND   cs.po_no       = b.erp_so_no
      WHERE ISNULL(cs.to_scm_site_id, '') = '';

      /*======20220121 SSP 정보를 사용한 To Site Mapping : END===========================*/
	  -----------------------------------------------------------------------------
	  -- C20200227-000175 : START
	  -- 1. Sold to / Ship to 를 이용한 To Site Mapping : Soldto가 Company ID 이므로 실제로는 Shipto 기준으로 적용될 것임
      --   20201007 PJ20202001 final_soldto_code 정보 사용하여 Site Mapping 처리
	  -----------------------------------------------------------------------------	  
      -- 1-1. OSP To Site Mapping : Soldto, Shipto 가 동일한 경우 Mapping
      UPDATE scm_dnm_intransit_co_summary
      SET    to_scm_site_id   =  B.scm_site_id
            ,last_update_date = GETDATE()
			,last_updated_by  = '1-1. Sold/Ship OSP To Site Mapping'
      FROM   scm_dnm_intransit_co_summary cs WITH(NOLOCK)
      JOIN  (SELECT  sc.division_id
                    ,sc.soldto_code
                    ,sc.shipto_code
                    ,MAX(sc.scm_site_id) scm_site_id 
             FROM   scm_mst_site_customer sc WITH(NOLOCK)
			 JOIN   scm_mst_site ms
			 ON     sc.division_id = ms.division_id
			 AND    sc.scm_site_id = ms.scm_site_id
             WHERE  sc.valid_yn  = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'PLANT'
			 AND    ms.osp_yn    = 'Y'
             GROUP BY sc.division_id
                     ,sc.soldto_code
                     ,sc.shipto_code
             HAVING count(distinct sc.scm_site_id) = 1 -- 2018.06.01   Kim Jihye
             ) B
      ON     B.division_id =  cs.division_id
      AND    B.soldto_code =  [dbo].[FN_SCM_SYS_NVL](cs.final_soldto_code, cs.attribute1)  --  20201007 PJ20202001  cs.attribute1
      AND    B.shipto_code =  cs.attribute3
      WHERE  cs.valid_yn         = 'Y'
      AND    LEN(cs.attribute3) != 4
	  AND    ISNULL(cs.to_scm_site_id, '') = ''
	  ;

      -- 1-2. To Site Mapping : Soldto, Shipto 가 동일한 경우 Mapping - Sales Site
      UPDATE scm_dnm_intransit_co_summary
      SET    to_scm_site_id   =  B.scm_site_id
            ,last_update_date = GETDATE()
			,last_updated_by  = '1-2. Sold/Ship To Site Mapping'
      FROM   scm_dnm_intransit_co_summary cs WITH(NOLOCK)
      JOIN  (SELECT  sc.division_id
                    ,sc.soldto_code
                    ,sc.shipto_code
                    ,MAX(sc.scm_site_id) scm_site_id 
             FROM   scm_mst_site_customer sc WITH(NOLOCK)
			 JOIN   scm_mst_site ms
			 ON     sc.division_id = ms.division_id
			 AND    sc.scm_site_id = ms.scm_site_id
             WHERE  sc.valid_yn  = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'SALES'
             GROUP BY sc.division_id
                     ,sc.soldto_code
                     ,sc.shipto_code
             HAVING count(distinct sc.scm_site_id) = 1 -- 2018.06.01   Kim Jihye
             ) B
      ON     B.division_id =  cs.division_id
      AND    B.soldto_code =  [dbo].[FN_SCM_SYS_NVL](cs.final_soldto_code, cs.attribute1)  --  20201007 PJ20202001  cs.attribute1
      AND    B.shipto_code =  cs.attribute3
      WHERE  cs.valid_yn         = 'Y'
      AND    LEN(cs.attribute3) != 4
	  AND    ISNULL(cs.to_scm_site_id, '') = ''
	  ;

      -- 1-3. OSP To Site Mapping : shipto code 기준으로 to site id가 한건만 있으면 그 site로 mapping
      UPDATE scm_dnm_intransit_co_summary
      SET    to_scm_site_id = cus.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '1-3. Ship OSP To Site Mapping'
      FROM   scm_dnm_intransit_co_summary cs  WITH(NOLOCK)
      JOIN  (SELECT  cus.division_id
                    ,cus.shipto_code
                    ,max(cus.scm_site_id) scm_site_id
             FROM   scm_mst_site_customer cus  WITH(NOLOCK)
			 JOIN   scm_mst_site ms WITH(NOLOCK)
			 ON     cus.division_id = ms.division_id
			 AND    cus.scm_site_id = ms.scm_site_id
             WHERE  cus.valid_yn = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'PLANT'
			 AND    ms.osp_yn    = 'Y'
             GROUP BY cus.division_id, cus.shipto_code
             HAVING   count(distinct cus.scm_site_id) = 1) cus
      ON     cs.division_id = cus.division_id
      AND    cs.attribute3  = cus.shipto_code
      WHERE  cs.valid_yn         = 'Y'
      AND    LEN(cs.attribute3) != 4
	  AND    ISNULL(cs.to_scm_site_id, '') = ''
	  ;

      -- 1-4. To Site Mapping : shipto code 기준으로 to site id가 한건만 있으면 그 site로 mapping - Sales Site
      UPDATE scm_dnm_intransit_co_summary
      SET    to_scm_site_id = cus.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '1-4. Ship To Site Mapping'
      FROM   scm_dnm_intransit_co_summary cs  WITH(NOLOCK)
      JOIN  (SELECT  cus.division_id
                    ,cus.shipto_code
                    ,max(cus.scm_site_id) scm_site_id
             FROM   scm_mst_site_customer cus  WITH(NOLOCK)
			 JOIN   scm_mst_site ms WITH(NOLOCK)
			 ON     cus.division_id = ms.division_id
			 AND    cus.scm_site_id = ms.scm_site_id
             WHERE  cus.valid_yn = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'SALES'
             GROUP BY cus.division_id, cus.shipto_code
             HAVING   count(distinct cus.scm_site_id) = 1) cus
      ON     cs.division_id = cus.division_id
      AND    cs.attribute3  = cus.shipto_code
      WHERE  cs.valid_yn         = 'Y'
      AND    LEN(cs.attribute3) != 4
	  AND    ISNULL(cs.to_scm_site_id, '') = ''
	  ;
	  
	  -----------------------------------------------------------------------------
	  -- C20200227-000175 : END
	  -----------------------------------------------------------------------------	  
	  
	  -----------------------------------------------------------------------------
	  -- 2. To Plant 를 이용한 To Site Mapping
	  --   .  Plant 에 Site 가 하나인 경우 >> 전극 Item 인 경우 Cell 사이트로, 그 외는 Pack 사이트
	  -----------------------------------------------------------------------------
      UPDATE scm_dnm_intransit_co_summary
	  SET    to_scm_site_id = ISNULL(ms.scm_site_id,                          -- 1. Plant 에 Site 가 하나인 경우
	                          DBO.FN_GET_SCM_SITE_ID_PLANT(cs.plant_id_purch, -- 2. 전극인 경우 Cell 사이트로, 그 외는 Pack 사이트
			                                               CASE DBO.FN_GET_ITEM_OPERATION_GROUP (cs.division_id, cs.item_id) 
							                               WHEN 'E' THEN 'A'
                                                           ELSE 'P' END))
	        ,last_update_date = GETDATE()
			,last_updated_by  = '2. To Plant Site Mapping'  
      FROM   scm_dnm_intransit_co_summary cs WITH(NOLOCK)
      LEFT JOIN -- Plant 에 Site 가 하나인 경우
            (SELECT division_id
	               ,plant_id
                   ,max(scm_site_id) scm_site_id
             FROM   scm_mst_site
             WHERE  site_type = 'PLANT'
	         AND    osp_yn    = 'N'
             AND    valid_yn  = 'Y'
             GROUP BY division_id, plant_id
             HAVING count(distinct scm_site_id) = 1) ms
      ON     cs.division_id    = ms.division_id
      AND    cs.plant_id_purch = ms.plant_id
	  WHERE  cs.valid_yn = 'Y'
	  AND    ISNULL(cs.to_scm_site_id, '') = ''
      ;
	  
	  -----------------------------------------------------------------------------
	  -- 3. Sold to / Ship to 를 이용한 판매법인 To Site Mapping : 20201022 C20201021-000289 추가
	  --    Lookup_type = 'SALES_PLANT'에 해당하는 Shipto_code 대상
	  -----------------------------------------------------------------------------
	  
      -- 3-1. To Site Mapping : Soldto, Shipto 가 동일한 경우 Mapping - Sales Site
      UPDATE scm_dnm_intransit_co_summary
      SET    to_scm_site_id   =  B.scm_site_id
            ,last_update_date = GETDATE()
			,last_updated_by  = '3-1. Sold/Ship To Site Mapping'
      FROM   scm_dnm_intransit_co_summary cs WITH(NOLOCK)
      JOIN  (SELECT  sc.division_id
                    ,sc.soldto_code
                    ,sc.shipto_code
                    ,MAX(sc.scm_site_id) scm_site_id 
             FROM   scm_mst_site_customer sc WITH(NOLOCK)
			 JOIN   scm_mst_site ms
			 ON     sc.division_id = ms.division_id
			 AND    sc.scm_site_id = ms.scm_site_id
             WHERE  sc.valid_yn  = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'SALES'
             GROUP BY sc.division_id
                     ,sc.soldto_code
                     ,sc.shipto_code
             HAVING count(distinct sc.scm_site_id) = 1 -- 2018.06.01   Kim Jihye
             ) B
      ON     B.division_id =  cs.division_id
      AND    B.soldto_code =  [dbo].[FN_SCM_SYS_NVL](cs.final_soldto_code, cs.attribute1)  --  20201007 PJ20202001  cs.attribute1
      AND    B.shipto_code =  cs.attribute3
      WHERE  cs.valid_yn   = 'Y'
      AND    cs.attribute3 IN (
                               SELECT segment1
                               FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
                               WHERE  lookup_type = 'SALES_PLANT' 
                               AND    valid_yn    = 'Y'
                              )
	  AND   ISNULL(cs.to_scm_site_id, '') = '' -- 2번 Update 시 NULL 처리 가능하여 ISNULL로 처리함
	  ;

      -- 3-2. To Site Mapping : shipto code 기준으로 to site id가 한건만 있으면 그 site로 mapping - Sales Site
      UPDATE scm_dnm_intransit_co_summary
      SET    to_scm_site_id = cus.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '3-2. Ship To Site Mapping'
      FROM   scm_dnm_intransit_co_summary cs  WITH(NOLOCK)
      JOIN  (SELECT  cus.division_id
                    ,cus.shipto_code
                    ,max(cus.scm_site_id) scm_site_id
             FROM   scm_mst_site_customer cus  WITH(NOLOCK)
			 JOIN   scm_mst_site ms WITH(NOLOCK)
			 ON     cus.division_id = ms.division_id
			 AND    cus.scm_site_id = ms.scm_site_id
             WHERE  cus.valid_yn = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'SALES'
             GROUP BY cus.division_id, cus.shipto_code
             HAVING   count(distinct cus.scm_site_id) = 1) cus
      ON     cs.division_id = cus.division_id
      AND    cs.attribute3  = cus.shipto_code
      WHERE  cs.valid_yn   = 'Y'
      AND    cs.attribute3 IN (
                               SELECT segment1
                               FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
                               WHERE  lookup_type = 'SALES_PLANT' 
                               AND    valid_yn    = 'Y'
                              )
	  AND   ISNULL(cs.to_scm_site_id, '') = '' -- 2번 Update 시 NULL 처리 가능하여 ISNULL로 처리함
	  ;
	  	  
	  -----------------------------------------------------------------------------
	  -- 4. To_site 가 vmi 인 경우 incoterms 는 DAP 로 변경
	  -----------------------------------------------------------------------------
	  UPDATE scm_dnm_intransit_co_summary
      SET    incoterms        = 'DAP'                 
            ,final_incoterms  = 'DAP'  -- 20201007 PJ20202001  신규 컬럼 추가
            ,last_update_date = getdate()
	  FROM   scm_dnm_intransit_co_summary cs with(nolock)
	  JOIN   scm_mst_site ms with(nolock)
	  ON     cs.to_scm_site_id = ms.scm_site_id
	  WHERE  cs.valid_yn     = 'Y'
	  AND    ms.vmi_yn       = 'Y'
	  AND    ms.valid_yn     = 'Y'      
	  --AND    ms.division_id <> '82'  -- 20201028 ESS 'DAP' 처리 --  C20200519-000150 20200519 [PI 합의] ESS인 경우 VMI 라도 'DAP' 처리 안 함
	  ;
	  
      -- 20220121 PJ20216891 to_site 가 AS 인 경우 incoterms 는 DAP 로 변경
	  UPDATE scm_dnm_intransit_co_summary
      SET    incoterms        = 'DAP'                 
            ,final_incoterms  = 'DAP'  -- 20201007 PJ20202001  신규 컬럼 추가
            ,last_update_date = getdate()
	  FROM   scm_dnm_intransit_co_summary cs with(nolock)
	  JOIN   scm_mst_site ms with(nolock)
	  ON     cs.to_scm_site_id = ms.scm_site_id
	  WHERE  cs.valid_yn        = 'Y'
	  AND    ms.operation_group = 'W'
	  AND    ms.valid_yn        = 'Y'     

	  /*===================================== Exfactory Date Update =====================================*/

	  UPDATE scm_dnm_intransit_co_summary
	  SET    exfactory_date = ISNULL(cs.plant_issue_date, cd.doc_posting_date)
	        ,last_update_date = GETDATE()
      FROM  scm_dnm_intransit_co_summary cs WITH(NOLOCK)
      JOIN  (SELECT  cd.division_id
                    ,cd.company_id_purch
	                ,cd.company_id_sales
	                ,cd.po_no
	                ,cd.po_item_seq
	                ,cd.origin_item_id
	                ,cd.doc_type
					,MAX(cd.doc_posting_date) doc_posting_date
             FROM   scm_dnm_intransit_co_detail cd WITH(NOLOCK)
             WHERE  cd.doc_type = 'GI'
			 AND    cd.valid_yn = 'Y'
             GROUP BY cd.division_id
                     ,cd.company_id_purch
	                 ,cd.company_id_sales
          	         ,cd.po_no
	       	         ,cd.po_item_seq
	       	         ,cd.origin_item_id
  	                 ,cd.doc_type) cd
      ON     cs.division_id      = cd.division_id
      AND    cs.company_id_purch = cd.company_id_purch
      AND    cs.company_id_sales = cd.company_id_sales
      AND    cs.po_no            = cd.po_no
      AND    cs.po_item_seq      = cd.po_item_seq
      AND    cs.origin_item_id   = cd.origin_item_id
	  WHERE  cs.valid_yn       = 'Y'
	  AND    cs.exfactory_date IS NULL
	  ;

      -- 처리 한 row 마킹
      UPDATE xif_erp_intransit_co_summary_r_sn 
      SET    transfer_flag = 'Y' 
      WHERE  transfer_flag = 'P'
	  ;

	  UPDATE xif_erp_intransit_co_detail_r_sn 
      SET    transfer_flag = 'Y' 
      WHERE  transfer_flag = 'P'
	  ;

      IF OBJECT_ID('dbo.xif_erp_intransit_co_summary_r_sn_temp$') IS NOT NULL DROP TABLE xif_erp_intransit_co_summary_r_sn_temp$
      IF OBJECT_ID('dbo.xif_erp_intransit_co_detail_r_sn_temp$') IS NOT NULL DROP TABLE xif_erp_intransit_co_detail_r_sn_temp$

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
