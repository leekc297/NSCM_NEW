



CREATE VIEW [dbo].[SCM_DNM_INTRANSIT_DW_V] AS
/*
 * Program ID   : SCM_DNM_INTRANSIT_DW_V
 * Description  : 해상재고 : DW용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.28   KSG            Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 2023.04.03	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 
 */

  SELECT V.result_date
       , V.result_type
       , V.company_id
       -- 2023.04.01 HM JV, CASE WHEN DIVISION_ID = '81_UC' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
	   , D.ATTRIBUTE3	AS DIVISION_ID -- HM JV 가상 사업부 추가 대응
       , V.plant_id 
       , V.shipment_no
       , V.project_code
       , V.item_id
       , V.plant_issue_date
       , V.incoterms
       , V.final_incoterms
       , V.fcst_type
       , V.customer_code
       , V.final_soldto_code
       , V.shipto_code
       , V.from_scm_site_id
       , V.to_scm_site_id
       , V.site_type
       , V.delivery_qty
       , V.uom
       , V.transport_mode 
       , V.shipping_date
       , V.pol
       , V.pol_atd_date 
       , V.pod
       , V.pod_eta_date
       , V.pod_ata_date
       , V.pod_etd_date
       , V.pod_atd_date 
       , V.f_dest_port_code
       , V.f_dest_eta_date
       , V.f_dest_ata_date 
       , V.eta_date  
	   , V.DIVISION_ID AS SCM_DIVISION_ID
  FROM  SCM_DNM_INTRANSIT_V V WITH(NOLOCK)
		 INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)  -- HM JV 가상 사업부 추가 대응
				 ON D.DIVISION_ID = V.DIVISION_ID 
				AND D.VALID_YN	  = 'Y'
  ;

