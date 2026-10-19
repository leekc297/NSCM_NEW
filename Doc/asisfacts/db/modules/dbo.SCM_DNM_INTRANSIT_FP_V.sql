






CREATE VIEW [dbo].[SCM_DNM_INTRANSIT_FP_V] AS
/*
 * Program ID   : SCM_DNM_INTRANSIT_FP_V
 * Description  : 해상재고 정보 : FP용
                  * 운송중 재고 정보 : ERP Intransit 전체 / 공장(PLANT) 도착 확인용

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.07.21   KSG            Initial Release : C20200715-000034 [요청]운송중 재고 데이터 생성 요청의 건
 * 2020.10.06   KSG            PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ERP
 *                                추가 컬럼 정보 생성 FINAL_SOLDTO_CODE / FINAL_INCOTERMS
 * 2021.01.29   KSG            C20210128-000556 [SCM PI팀] SCP시스템의 운송중 재고 정합성을 위한 GTS Tracking정보 UPdate로직 변경의 건
 * 2021.05.03   SEO			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - lt_total -> add_after_lt_total 변경
 * 2021.07.07   sclee          PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 참조뷰 변경 및 조인조건 추가
 * 2022.01.25   KSG            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - f dest eta 재정의
 * 2024.02.21   vadabi3        NERP - Warranty Plant 제외, 특정 Plant 별도 처리 개선
                                   -- A002 -- Warranty Plant 제외
 ----------------------------------------------------------------------------------------------------
 SELECT * FROM      SCM_DNM_INTRANSIT_FP_V WHERE RESULT_DATE = '20240408' and company_id = 'HQ00' and PLANT_ID = 'HQ07'
 SELECT * FROM OLD_SCM_DNM_INTRANSIT_FP_V WHERE RESULT_DATE = '20240408' and company_id = 'HQ00' and PLANT_ID = 'HQ07'

 */

  SELECT inv.result_date
       , inv.result_type
       , inv.company_id
       , inv.division_id
       , inv.plant_id 
       , inv.shipment_no
       , inv.project_code
       , inv.item_id
       , inv.plant_issue_date
       , inv.incoterms
       , inv.fcst_type
       , inv.customer_code
       , inv.shipto_code
       , inv.from_scm_site_id
       , inv.to_scm_site_id
       , s.site_type
       , inv.delivery_qty
       , inv.uom
       , inv.transport_mode 
       , inv.shipping_date
       , inv.pol
       , inv.pol_atd_date 
       , inv.pod
       , inv.pod_eta_date
       , inv.pod_ata_date
       , inv.pod_etd_date
       , inv.pod_atd_date 
       , inv.f_dest_port_code
       , inv.f_dest_eta_date
       , inv.f_dest_ata_date 
	   --  From/To/Tr Mode/Incoterms 가 맞는 BOD가 없는 경우 : From/To/Tr Mode 기준 MAX(LT) 적용
       --  BOD 없는 경우 당일 일자 적용
       --, dbo.FN_SCM_SYS_NVL( inv.f_dest_eta_date
       --                    , IIF( bod.lt_total IS NULL
       --                         , IIF( bod2.lt_total IS NULL
       --                              , CONVERT(NVARCHAR(8), DATEADD(d, 1, CONVERT(DATETIME, inv.result_date)), 112)
       --                              , CONVERT(NVARCHAR(8), DATEADD(d, bod2.lt_total, inv.plant_issue_date), 112)
       --                              )
       --                         , CONVERT(NVARCHAR(8), DATEADD(d, bod.lt_total, inv.plant_issue_date), 112)
       --                         )
       --                    ) AS eta_date
       , dbo.FN_SCM_SYS_NVL( inv.f_dest_eta_date
                           , IIF( bod.add_after_lt_total IS NULL
                                , IIF( bod2.add_after_lt_total IS NULL
                                     , CONVERT(NVARCHAR(8), DATEADD(d, 1, CONVERT(DATETIME, inv.result_date)), 112)
                                     , CONVERT(NVARCHAR(8), DATEADD(d, bod2.add_after_lt_total, inv.plant_issue_date), 112)
                                     )
                                , CONVERT(NVARCHAR(8), DATEADD(d, bod.add_after_lt_total, inv.plant_issue_date), 112)
                                )
                           ) AS eta_date	--2021.05.03 lt_total -> add_after_lt_total
       -- 20201006 PJ20202001 컬럼 추가
       , inv.final_incoterms
       , inv.final_soldto_code

  FROM  
        (  
         -----------------------------------------------------------
		-- 1-1. Intransit(GTS) : [ERP Intransit + GTS Update]
        --              법인출발 - PLANT도착 : FOB 반영
        -----------------------------------------------------------		
		SELECT  B.result_date
		       ,B.result_type
			   ,B.company_id
			   ,B.division_id    
			   ,B.plant_id 
			   ,B.shipment_no   
			   ,B.project_code		
			   ,B.item_id    
			   ,B.incoterms
			   ,B.final_incoterms  -- 20201006 PJ20202001 컬럼 추가

			   ,MAX([dbo].[FN_SCM_SYS_NVL](dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', B.distribution_channel), 'E')) AS dom_exp
			   ,MAX(B.customer_code)     AS customer_code
			   ,MAX(B.final_soldto_code) AS final_soldto_code -- 20201006 PJ20202001 컬럼 추가
			   ,MAX(B.shipto_code)       AS shipto_code
			   ,MAX(B.from_scm_site_id)  AS from_scm_site_id
			   ,MAX(B.to_scm_site_id)    AS to_scm_site_id
			   ,SUM(B.delivery_qty)      AS delivery_qty 
			   ,MAX(B.uom)               AS uom
			   ,MAX(B.transport_mode)    AS transport_mode
			   ,B.plant_issue_date		
			   ,B.fcst_type
			   ,MAX(B.shipping_date)    AS shipping_date
			   ,MAX(B.pol)              AS pol
			   ,MAX(B.pol_atd_date)     AS pol_atd_date
			   ,MAX(B.pod)              AS pod
			   ,MAX(B.pod_eta_date)     AS pod_eta_date
			   ,MAX(B.pod_ata_date)     AS pod_ata_date
			   ,MAX(B.pod_etd_date)     AS pod_etd_date
			   ,MAX(B.pod_atd_date)     AS pod_atd_date
			   ,MAX(B.f_dest_port_code) AS f_dest_port_code
			   ,MAX(B.f_dest_eta_date)  AS f_dest_eta_date
			   ,MAX(B.f_dest_ata_date)  AS f_dest_ata_date
			   ,MAX(B.storage_id)       AS storage_id -- 20200218  Storage ID 추가
		FROM   ( SELECT  CONVERT(CHAR(8),getdate()-1, 112) AS result_date
						,CONVERT(CHAR(8),getdate()-1-90, 112) AS cal_date -- 2018.09.20
						,'I' AS result_type    
						,di.company_id    
						,di.division_id 
						,di.plant_id    
						,di.shipment_no   
						,di.project_code	
						,di.item_id   
						,di.incoterms   
						,di.distribution_channel
						,di.customer_code
						,di.shipto_code   
						,di.from_scm_site_id   
						,di.from_site_item_mapping_yn   
						,di.to_scm_site_id
						,di.to_site_item_mapping_yn   
						,di.delivery_qty   
						,di.uom   
						,di.transport_mode
						,di.plant_issue_date   
						,fcst_type   
						,dt.shipping_date   
						,dt.pol
						,dt.pol_atd_date   
						,dt.pod   
						,dt.pod_eta_date   
						,dt.pod_ata_date   
						,dt.pod_etd_date
						,dt.pod_atd_date   
						,dt.f_dest_port_code   
						-- 20210129  C20210128-000556
						--,dt.f_dest_eta_date 
						--,CASE WHEN ISNULL(s.site_type, 'SALES') = 'SALES' THEN dt.f_dest_eta_date_sales
						--      ELSE dt.f_dest_eta_date 
						-- END  f_dest_eta_date  
						-- 20220125 PJ20216891 : f dest eta 재정의
                       ,CASE WHEN ISNULL(l.segment3, '') = ''  THEN CASE WHEN ISNULL(dt.f_dest_ata_date, '') = '' THEN dt.f_dest_eta_date ELSE dt.f_dest_ata_date END

                             WHEN ISNULL(s.site_type, 'SALES') = 'SALES' AND l.segment3  = 'A' THEN ''
                             WHEN ISNULL(s.site_type, 'SALES') = 'SALES' AND l.segment3  = 'B' THEN dt.shipping_date
                             -- 'C' : 1 순위 - pol_atd_date , 2순위 - shipping_date
                             WHEN ISNULL(s.site_type, 'SALES') = 'SALES' AND l.segment3  = 'C' THEN CASE WHEN ISNULL(dt.pol_atd_date, '') = '' THEN dt.shipping_date ELSE dt.pol_atd_date END
                             -- 'D/E/F' : 1 순위 - f_dest_ata_date , 2순위 - f_dest_eta_date
                             WHEN ISNULL(s.site_type, 'SALES') = 'SALES' AND l.segment3  = 'D' THEN CASE WHEN ISNULL(dt.f_dest_ata_date, '') = '' THEN dt.f_dest_eta_date ELSE dt.f_dest_ata_date END
                             WHEN ISNULL(s.site_type, 'SALES') = 'SALES' AND l.segment3  = 'E' THEN CASE WHEN ISNULL(dt.f_dest_ata_date, '') = '' THEN dt.f_dest_eta_date ELSE dt.f_dest_ata_date END
                             WHEN ISNULL(s.site_type, 'SALES') = 'SALES' AND l.segment3  = 'F' THEN CASE WHEN ISNULL(dt.f_dest_ata_date, '') = '' THEN dt.f_dest_eta_date ELSE dt.f_dest_ata_date END

                             ELSE CASE WHEN ISNULL(dt.f_dest_ata_date, '') = '' THEN dt.f_dest_eta_date ELSE dt.f_dest_ata_date END
                        END AS f_dest_eta_date

						,dt.f_dest_ata_date
						,di.order_type_code -- 2018.09.20
						,di.storage_id  -- 20200218  Storage ID 추가
                         -- 20201006 PJ20202001 컬럼 추가
                        ,[dbo].[FN_SCM_SYS_NVL](di.final_incoterms, di.incoterms)       AS final_incoterms
                        ,[dbo].[FN_SCM_SYS_NVL](di.final_soldto_code, di.customer_code) AS final_soldto_code
				FROM    scm_dnm_intransit di WITH(NOLOCK)
				
				-- 20210129  C20210128-000556
				LEFT OUTER JOIN scm_mst_site s WITH(NOLOCK)
				ON  di.division_id    = s.division_id
				AND di.to_scm_site_id = s.scm_site_id

				-- 20210129  C20210128-000556 f_dest_eta_date 로 사용할 컬럼 변경
				LEFT OUTER JOIN SCM_DNM_GTS_ETA_V dt WITH(NOLOCK)
                /*
					    (SELECT  t.company_id  -- 20181204 company_id 추가
						        ,t.shipment_no
						 	    ,max(t.shipping_date) shipping_date
							    ,max(t.pol) pol
							    ,max(t.pol_atd_date) pol_atd_date
							    ,max(t.pod) pod
							    ,max(t.pod_eta_date) pod_eta_date
							    ,max(t.pod_ata_date) pod_ata_date
							    ,max(t.pod_etd_date) pod_etd_date
							    ,max(t.pod_atd_date) pod_atd_date
							    ,max(t.f_dest_port_code) f_dest_port_code
							    ,max(t.f_dest_eta_date) f_dest_eta_date
							    ,max(t.f_dest_ata_date) f_dest_ata_date
						 FROM   scm_dnm_delivery_tracking t WITH(NOLOCK)
						 --WHERE  len(t.pol_atd_date) > 0 -- ERP 와 같은 조건 처리(SAP 화면에서도 해당 데이터는 보이지 않음)
						 GROUP BY t.company_id, t.shipment_no  -- 20181204 company_id 추가
						) dt
				*/
				ON     di.company_id  = dt.company_id -- 20181204 company_id 추가
				AND    di.shipment_no = dt.shipment_no

				LEFT OUTER JOIN (SELECT *
                                 FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                 WHERE  lookup_type = 'INCOTERMS'
                                 AND    valid_yn    = 'Y'
				                ) l
				ON  ISNULL(di.final_incoterms, di.incoterms)  = l.segment1

				WHERE  isnull(di.sales_posting_date, '') = ''
				AND    di.shipment_no > char(0)
			   ) B
				
				WHERE  (b.order_type_code != 'ZEML'	OR  (ISNULL(b.f_dest_ata_date, '') = '' -- 2018.09.20
				                                         AND b.plant_issue_date >= cal_date))

				GROUP BY	B.result_date   ,B.result_type    ,B.company_id    ,B.division_id      ,B.plant_id 
						   ,B.shipment_no   ,B.project_code	  ,B.item_id       ,B.plant_issue_date ,B.incoterms 
						   ,B.fcst_type     ,B.final_incoterms

       ) inv   

               INNER JOIN ( SELECT division_id, scm_site_id, site_type
                            FROM   dbo.scm_mst_site WITH (NOLOCK) 
                            WHERE  site_type  IN ('PLANT') -- To가 PLANT 인 경우 반영
                            AND    valid_yn    = 'Y') s
               ON   inv.division_id             = s.division_id
               AND  inv.to_scm_site_id          = s.scm_site_id

               --LEFT JOIN  scp_mst_bod_v bod WITH (NOLOCK)
               LEFT JOIN  scp_mst_bod_n_v bod WITH (NOLOCK) -- 20210707 PJ20209643 scp_mst_bod_v 에서 scp_mst_bod_n_v로 변경
               ON    bod.division_id    = inv.division_id
               AND   bod.from_site      = inv.from_scm_site_id
               AND   bod.to_site        = inv.to_scm_site_id
               AND   bod.incoterms      = inv.final_incoterms  -- inv.incoterms 20201006 PJ20202001 변경
               AND   bod.transport_mode = inv.transport_mode
               AND   bod.bod_valid_yn   = 'Y'
			   AND   bod.from_yyyymmdd  <= inv.plant_issue_date -- 20210707 PJ20209643 추가
			   AND   bod.to_yyyymmdd  >= inv.plant_issue_date -- 20210707 PJ20209643 추가
			   -- From/To/Tr Mode 가 맞는 경우의 MAX(LT)
               LEFT JOIN (SELECT A.division_id, A.from_site, A.to_site, A.transport_mode
							   --, MAX(lt_total) lt_total
							   , MAX(add_after_lt_total) add_after_lt_total	--2021.05.03 lt_total -> add_after_lt_total
						  --FROM   scp_mst_bod_v A WITH (NOLOCK)
                          FROM   scp_mst_bod_n_v A WITH (NOLOCK) -- 20210707 PJ20209643 scp_mst_bod_v 에서 scp_mst_bod_n_v로 변경
						  WHERE  A.bod_valid_yn    = 'Y'
						  GROUP BY A.division_id, A.from_site,A.to_site, A.transport_mode
						 ) bod2 
               ON    bod2.division_id    = inv.division_id
               AND   bod2.from_site      = inv.from_scm_site_id
               AND   bod2.to_site        = inv.to_scm_site_id
               AND   bod2.transport_mode = inv.transport_mode

   WHERE inv.plant_id <> (  -- A002 -- Warranty Plant 제외
							SELECT SEGMENT2
							 FROM SCM_CODE_LOOKUP_VALUE 
							WHERE LOOKUP_TYPE_CODE = 'SCM_DNM_INTRANSIT_FP_V' 
							  AND SEGMENT1 = 'WarrantyPlant' 
							  AND ACTIVE_FLAG = 'Y'
							)

   ;


