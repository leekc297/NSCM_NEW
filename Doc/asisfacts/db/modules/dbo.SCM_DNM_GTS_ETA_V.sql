

CREATE VIEW [dbo].[SCM_DNM_GTS_ETA_V] AS
/*
 * Program ID   : SCM_DNM_GTS_ETA_V
 * Description  : GTS Tracking 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.01.28   KSG            Initial Release C20210203-000224 [SCM PI팀] GSCM시스템의 RTF정합성 향상을 위한 ETA 기준 반영 시간 변경 개선 건
 * 
 */
SELECT a.company_id  -- 20181204 company_id 추가
      ,a.shipment_no, a.incoterms
      ,a.shipping_date
      ,a.pol
      ,a.pol_atd_date
      ,a.pod
      ,a.pod_eta_date
      ,a.pod_ata_date
      ,a.pod_etd_date
      ,a.pod_atd_date
      ,a.f_dest_port_code
      ,a.f_dest_eta_date
      ,a.f_dest_ata_date
	  -- SCM_DNM_GTS_ETA_V 사용하는 곳에서 해당 정보의 Incoterms 기준으로 아래와 같은 로직으로 추가 처리되고 있음
      ,CASE WHEN ISNULL(l.segment3, '') = ''  THEN CASE WHEN ISNULL(a.f_dest_ata_date, '') = '' THEN a.f_dest_eta_date ELSE a.f_dest_ata_date END
              WHEN l.segment3  = 'A'            THEN ''
              WHEN l.segment3  = 'B'            THEN a.shipping_date
              -- 'C' : 1 순위 - pol_atd_date , 2순위 - shipping_date
              WHEN l.segment3  = 'C'            THEN CASE WHEN ISNULL(a.pol_atd_date, '') = '' THEN a.shipping_date ELSE a.pol_atd_date END
              -- 'D/E/F' : 1 순위 - f_dest_ata_date , 2순위 - f_dest_eta_date
              WHEN l.segment3  = 'D'            THEN CASE WHEN ISNULL(a.f_dest_ata_date, '') = '' THEN a.f_dest_eta_date ELSE a.f_dest_ata_date END
              WHEN l.segment3  = 'E'            THEN CASE WHEN ISNULL(a.f_dest_ata_date, '') = '' THEN a.f_dest_eta_date ELSE a.f_dest_ata_date END
              WHEN l.segment3  = 'F'            THEN CASE WHEN ISNULL(a.f_dest_ata_date, '') = '' THEN a.f_dest_eta_date ELSE a.f_dest_ata_date END
              ELSE                                   CASE WHEN ISNULL(a.f_dest_ata_date, '') = '' THEN a.f_dest_eta_date ELSE a.f_dest_ata_date END
      END AS f_dest_eta_date_sales
FROM (
      SELECT t.company_id  -- 20181204 company_id 추가
            ,t.shipment_no
            ,t.incoterms
            ,MAX(t.shipping_date) shipping_date
            ,MAX(t.pol) pol
            ,MAX(t.pol_atd_date) pol_atd_date
            ,MAX(t.pod) pod
            ,MAX(t.pod_eta_date) pod_eta_date
            ,MAX(t.pod_ata_date) pod_ata_date
            ,MAX(t.pod_etd_date) pod_etd_date
            ,MAX(t.pod_atd_date) pod_atd_date
            ,MAX(t.f_dest_port_code) f_dest_port_code
            ,MAX(t.f_dest_eta_date) f_dest_eta_date
            ,MAX(t.f_dest_ata_date) f_dest_ata_date
      FROM   scm_dnm_delivery_tracking t WITH(NOLOCK)
							 
      INNER JOIN (SELECT company_id, shipment_no, MAX(incoterms) AS incoterms
                  FROM   scm_dnm_delivery_tracking t WITH(NOLOCK)
                  GROUP BY company_id, shipment_no  -- 20181204 company_id 추가
                  ) tm
      ON  t.company_id  = tm.company_id
      AND t.shipment_no = tm.shipment_no
      AND t.incoterms   = tm.incoterms

      -- WHERE  len(t.pol_atd_date) > 0 -- ERP 와 같은 조건 처리(SAP 화면에서도 해당 데이터는 보이지 않음) -- 20210122 Delete
      GROUP BY t.company_id, t.shipment_no, t.incoterms  -- 20181204 company_id 추가
    ) a

LEFT OUTER JOIN (SELECT *
                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                WHERE  lookup_type = 'INCOTERMS'
                AND    valid_yn    = 'Y'
                ) l
ON  a.incoterms = l.segment1

