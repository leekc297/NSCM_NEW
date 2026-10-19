












CREATE VIEW [dbo].[SCM_DNM_INTRANSIT_V] AS
/*
 * Program ID   : SCM_DNM_INTRANSIT_V
 * Description  : 해상재고 정보
                  * 운송중 재고 정보 생성 : 해상재고( I : GTS 있는 해상정보, 'S' : GTS 없는 정보, 'C' 법인간 해상재고)
				  
                     1-1. Intransit(GTS) : [ERP Intransit + GTS Update] : result_type = 'I'
					  - lookup_type = 'EXFACTORY_INTRANSIT_TARGET' 에 없는 Company 만 scm_dnm_intransit_c 에 정보 생성되어 있음
                        법인출발 - SALES도착 : FOB 반영
                        법인출발 - PLANT도착 : FOB 반영
						C20200401-000183 A040-A => LGE_US_HZP 이동인 경우 Incoterms 를 DDP 로 처리

                     1-2. Intransit(출하실적기반 : Non GTS) [ERP 출하실적 + BOD LT] : result_type = 'S'
					  - lookup_type = 'EXFACTORY_INTRANSIT_TARGET' 에 있는 Company 만 scm_dnm_intransit_c 에 정보 생성되어 있음
                        법인출발        - SALES도착        : FOB 제외
                        CNA/CNB법인출발 - HLGP_KR_CHU 도착 : FOB 만 반영 : exfactory_status(D20 : 공장출고) / incoterms를 'Z02'로 처리
                        CNA법인출발     - PLANT도착        : FOB 반영    : exfactory_status(D20 : 공장출고)

                     1-3. 법인간 운송중 재고 : [ERP 법인미착정보] : result_type = 'C'
                        C20200227-000175 : 오창/법인출발 - PLANT/SALES도착 : FOB 반영
						  OLD] 오창/법인출발 - PLANT도착 : FOB 반영
						C20200401-000183 A040-A => LGE_US_HZP 이동인 경우 Incoterms 를 DDP 로 처리

                     1-4. to site가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC Mapping 된 것
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.06.18   KSG            Initial Release 
 * 2019.09.24   KSG            항목 추가 : CNA/CNB법인출발 - HLGP_KR_CHU 도착
 * 2019.10.16   KSG            1-2 CNA/CNB법인출발 - HLGP_KR_CHU 도착 : exfactory_status(D20 : 공장출고) 만 반영
 * 2020.03.04   KSG            C20200227-000175  CNA법인-고객사(HLGP) 간 운송중 재고 반영건
 * 2020.03.13   KSG            C20200312-000110 CNA-HLGP 운송중 재고 누락건
 *                                법인간 운송 재고에서 To Site가 'HLGP_KR_CHU' 이면 Incoterms를 'Z02'로 처리
 * 2020.03.23   KSG            [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
 *                                VMI 전진 검사 LT 추가 적용 : SCM_MST_SITE_ITEM 테이블의 SCP_VMI_LT 값 만큼 ETA에 더해 줌
 * 2020.04.07   KSG            C20200401-000183 자동차 SCP, ACEN4065I-A1모델 운송중 재고의 RTF 반영 요청
 * 2020.10.06   KSG            PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ERP
 *                                추가 컬럼 정보 생성 FINAL_SOLDTO_CODE / FINAL_INCOTERMS
 * 2021.05.03   SEO			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - lt_total -> add_after_lt_total 변경
 * 2021.07.07   sclee          PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 참조뷰 변경 및 조인조건 추가
 * 2022.01.21   KSG            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : Stock_v -> Stock 테이블로 변경
 * 2022.02.17   KSG            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선
 *                                : result_type = 'S' 제외
 *                                : From Site가 AS인 경우 제외
 * 2022.06.28   hrkim          PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : storage_id 추가 
 *								  - 참조 컬럼 :  scm_dnm_intransit_c.attribute2
 * 2024.06.09   vadabi3        NERP - 특정 Company 별도 처리 개선
							   -- A040-A, A002
							   SELECT DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V','SCM_SITE_ID')
							   SELECT DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V','PLANT_ID')
 * 2025.03.20	kimcd		   [PJ20249548R] SCP역량 강화를 위한 기준정보PSI엔진 기능개선
 ----------------------------------------------------------------------------------------------------
 SELECT *
 FROM SCM_DNM_INTRANSIT_V
 where result_date = '20240221'
 and result_type = 'C'
 and company_id = 'G450'
 and division_id = '81'

 SELECT *
 FROM NERP_SCM_DNM_INTRANSIT_V
 where result_date = '20240221'
 and result_type = 'C'
 and company_id = 'G450'
 and division_id = '81'

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
       , inv.final_incoterms   -- 20201006 PJ20202001 컬럼 추가
       , inv.fcst_type
       , inv.customer_code
       , inv.final_soldto_code -- 20201006 PJ20202001 컬럼 추가
       , inv.shipto_code
       , inv.from_scm_site_id
       , inv.to_scm_site_id
       , inv.site_type
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
       -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
       --            VMI 전진 검사 LT 추가 적용 : SCM_MST_SITE_ITEM 테이블의 SCP_VMI_LT 값 만큼 ETA에 더해 줌
       , CASE WHEN ISDATE(inv.eta_date) = 1 THEN CONVERT(NVARCHAR(8), DATEADD(DAY, ISNULL(si.lt_day, 0), CONVERT(DATE, inv.eta_date)), 112)
              ELSE inv.eta_date
         END  eta_date
       , inv.attribute2 AS storage_id -- 20220628 storage_id 추가
  FROM  
        (  
         -----------------------------------------------------------
		-- 1-1. Intransit(GTS) : [ERP Intransit + GTS Update] : result_type = 'I'
        --              법인출발 - SALES도착 : FOB 반영
        --              법인출발 - PLANT도착 : FOB 반영
        -----------------------------------------------------------
		SELECT a.result_date
             , a.result_type
             , a.company_id
             , a.division_id
             , a.plant_id 
	         , a.shipment_no
             , a.project_code
             , a.item_id
             , a.plant_issue_date
             -- 20200407 C20200401-000183 A040-A => LGE_US_HZP 이동인 경우 Incoterms 를 DDP 로 처리
             --, a.incoterms 
             , CASE WHEN a.from_scm_site_id = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V','SCM_SITE_ID')
			         AND a.to_scm_site_id = 'LGE_US_HZP'  
			        THEN 'DDP'
                    ELSE a.incoterms
               END AS incoterms 

             -- 20201006 PJ20202001 컬럼 추가
             , CASE WHEN a.from_scm_site_id = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V','SCM_SITE_ID')
			         AND a.to_scm_site_id = 'LGE_US_HZP'  
			        THEN 'DDP'
                    ELSE a.final_incoterms
               END AS final_incoterms 

             , a.fcst_type 
	         , a.customer_code

             -- 20201006 PJ20202001 컬럼 추가
             , a.final_soldto_code

             , a.shipto_code
             , a.from_scm_site_id AS from_scm_site_id
             , a.to_scm_site_id   AS to_scm_site_id
			 , b.site_type
	         , a.delivery_qty
             , a.uom
             , a.transport_mode 
	         , a.shipping_date
             , a.pol
             , a.pol_atd_date 
	         , a.pod
             , a.pod_eta_date
             , a.pod_ata_date
             , a.pod_etd_date
             , a.pod_atd_date 
	         , a.f_dest_port_code
             , a.f_dest_eta_date
             , a.f_dest_ata_date 
			-- , a.eta_date -- 도착 예정일자 : NULL인 경우 BOD 이용하여 (plant_issue_date + LT) 로 반영
			 -- From/To/Tr Mode/Incoterms 가 맞는 BOD가 없는 경우 : From/To/Tr Mode 기준 MAX(LT) 적용
			 -- BOD 없는 경우 Plan 시작일자 적용
             --, dbo.FN_SCM_SYS_NVL( a.f_dest_eta_date
             --                     , IIF( bod.add_after_lt_total IS NULL
             --                           , IIF( bod2.add_after_lt_total IS NULL
             --                                , CONVERT(NVARCHAR(8), DATEADD(d, 1, CONVERT(DATETIME, a.result_date)), 112)
             --                                , CONVERT(NVARCHAR(8), DATEADD(d, bod2.add_after_lt_total, a.plant_issue_date), 112)
             --                               )
             --                           , CONVERT(NVARCHAR(8), DATEADD(d, bod.add_after_lt_total, a.plant_issue_date), 112)
             --                          )
             --                    )  AS eta_date		--2021.05.03 lt_total -> add_after_lt_total
             , CASE WHEN ISNULL(a.f_dest_eta_date, '') = '' THEN
                                    IIF( bod.add_after_lt_total IS NULL
                                        , IIF( bod2.add_after_lt_total IS NULL
                                             , CONVERT(NVARCHAR(8), DATEADD(d, 1, CONVERT(DATETIME, a.result_date)), 112)
                                             , CONVERT(NVARCHAR(8), DATEADD(d, bod2.add_after_lt_total, a.plant_issue_date), 112)
                                            )
                                        , CONVERT(NVARCHAR(8), DATEADD(d, bod.add_after_lt_total, a.plant_issue_date), 112)
                                       )
                    ELSE a.f_dest_eta_date
               END AS eta_date
              , a.attribute2  -- 20220628 storage_id 추가
               
		FROM   dbo.scm_dnm_intransit_c  a WITH (NOLOCK)

               INNER JOIN ( SELECT division_id, scm_site_id, site_type
                            FROM   dbo.scm_mst_site WITH (NOLOCK) 
                            WHERE  site_type  IN ('PLANT', 'SALES') -- To가 PLANT/SALES 인 경우 동시 반영
                            AND    valid_yn    = 'Y') b
               ON   a.division_id             = b.division_id
               AND  a.to_scm_site_id          = b.scm_site_id

			   LEFT JOIN  scp_mst_bod_n_v bod WITH (NOLOCK) -- 20210707 PJ20209643 scp_mst_bod_v 에서 scp_mst_bod_n_v로 변경
               ON    bod.division_id    = a.division_id
               AND   bod.from_site      = a.from_scm_site_id
               AND   bod.to_site        = a.to_scm_site_id
               AND   bod.incoterms      = a.final_incoterms -- a.incoterms  20201006 PJ20202001 변경
               AND   bod.transport_mode = a.transport_mode
               AND   bod.bod_valid_yn   = 'Y'

			   AND   bod.from_yyyymmdd <= a.plant_issue_date -- 20210707 PJ20209643 추가
			   AND   bod.to_yyyymmdd   >= a.plant_issue_date -- 20210707 PJ20209643 추가

			   -- From/To/Tr Mode 가 맞는 경우의 MAX(LT)
               LEFT JOIN (SELECT A.division_id, A.from_site, A.to_site, A.transport_mode
							   --, MAX(lt_total) lt_total
							   , MAX(add_after_lt_total) add_after_lt_total		--2021.05.03 lt_total -> add_after_lt_total
						  FROM   scp_mst_bod_n_v A WITH (NOLOCK) -- 20210707 PJ20209643 scp_mst_bod_v 에서 scp_mst_bod_n_v로 변경
						  WHERE  A.bod_valid_yn    = 'Y'
						  GROUP BY A.division_id, A.from_site,A.to_site, A.transport_mode
						 ) bod2 
               ON    bod2.division_id    = a.division_id
               AND   bod2.from_site      = a.from_scm_site_id
               AND   bod2.to_site        = a.to_scm_site_id
               AND   bod2.transport_mode = a.transport_mode

        WHERE  1=1
        AND    a.result_type            = 'I'
		--AND    a.final_incoterms             <> 'FOB' -- GTS : FOB 전체 반영
		AND    a.valid_yn               = 'Y'   -- 해상재고

		UNION
        -----------------------------------------------------------
		-- 1-3. 법인간 운송중 재고 : [ERP 법인미착정보] : result_type = 'C'
        --      C20200227-000175 : 오창/법인출발 - PLANT/SALES도착 : FOB 반영
		--			OLD] 오창/법인출발 - PLANT도착 : FOB 반영
        -----------------------------------------------------------
		SELECT a.result_date
             , a.result_type
             , a.company_id
             , a.division_id
             , a.plant_id 
	         , a.shipment_no
             , a.project_code
             , a.item_id
             , a.plant_issue_date
			 
             -- 20200313 C20200312-000110 법인간 운송 재고에서 To Site가 'HLGP_KR_CHU' 이면 Incoterms를 'Z02'로 처리
             -- 20200407 C20200401-000183 A040-A => LGE_US_HZP 이동인 경우 Incoterms 를 DDP 로 처리
             --, a.incoterms 
             , CASE WHEN a.from_scm_site_id = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V','SCM_SITE_ID')
			         AND a.to_scm_site_id = 'LGE_US_HZP'  
					 THEN 'DDP'
                    --WHEN                                   a.to_scm_site_id = 'HLGP_KR_CHU' THEN 'Z02'   --> 2022.10.25 로직 삭제
                    ELSE a.incoterms
               END AS incoterms 
			 
             -- 20201006 PJ20202001 컬럼 추가
             , CASE WHEN a.from_scm_site_id = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V','SCM_SITE_ID')
			         AND a.to_scm_site_id = 'LGE_US_HZP'  
			        THEN 'DDP'
                    --WHEN                                   a.to_scm_site_id = 'HLGP_KR_CHU' THEN 'Z02'   --> 2022.10.25 로직 삭제
                    ELSE a.final_incoterms
               END AS final_incoterms 

             , a.fcst_type 
	         , a.customer_code
             -- 20201006 PJ20202001 컬럼 추가
             , a.final_soldto_code

             , a.shipto_code
             , a.from_scm_site_id AS from_scm_site_id
             , a.to_scm_site_id   AS to_scm_site_id
			 , b.site_type
	         , a.delivery_qty
             , a.uom
             , a.transport_mode 
	         , a.shipping_date
             , a.pol
             , a.pol_atd_date 
	         , a.pod
             , a.pod_eta_date
             , a.pod_ata_date
             , a.pod_etd_date
             , a.pod_atd_date 
	         , a.f_dest_port_code
             , a.f_dest_eta_date
             , a.f_dest_ata_date 
			-- , a.eta_date -- 도착 예정일자 : NULL인 경우 BOD 이용하여 (plant_issue_date + LT) 로 반영
			 -- From/To/Tr Mode/Incoterms 가 맞는 BOD가 없는 경우 : From/To/Tr Mode 기준 MAX(LT) 적용
			 -- BOD 없는 경우 Plan 시작일자 적용
             --, dbo.FN_SCM_SYS_NVL( a.f_dest_eta_date
             --                     , IIF( bod.add_after_lt_total IS NULL
             --                           , IIF( bod2.add_after_lt_total IS NULL
             --                                , CONVERT(NVARCHAR(8), DATEADD(d, 1, CONVERT(DATETIME, a.result_date)), 112) 
             --                                , CONVERT(NVARCHAR(8), DATEADD(d, bod2.add_after_lt_total, a.plant_issue_date), 112)
             --                               )
             --                           , CONVERT(NVARCHAR(8), DATEADD(d, bod.add_after_lt_total, a.plant_issue_date), 112)
             --                          )
             --                    )  AS eta_date		--2021.05.03 lt_total -> add_after_lt_total
             , CASE WHEN ISNULL(a.f_dest_eta_date, '') = '' THEN
                                    IIF( bod.add_after_lt_total IS NULL
                                        , IIF( bod2.add_after_lt_total IS NULL
                                             , CONVERT(NVARCHAR(8), DATEADD(d, 1, CONVERT(DATETIME, a.result_date)), 112) 
                                             , CONVERT(NVARCHAR(8), DATEADD(d, bod2.add_after_lt_total, a.plant_issue_date), 112)
                                            )
                                        , CONVERT(NVARCHAR(8), DATEADD(d, bod.add_after_lt_total, a.plant_issue_date), 112)
                                       )
                    ELSE a.f_dest_eta_date
               END AS eta_date
              , a.attribute2  -- 20220628 storage_id 추가
		FROM   scm_dnm_intransit_c  a WITH (NOLOCK)

               INNER JOIN   ( SELECT division_id, scm_site_id, site_type
                                FROM   dbo.scm_mst_site WITH (NOLOCK) 
                                WHERE  1=1
                                --AND    site_type   = 'PLANT'  --  C20200227-000175 : SALES 도 반영
                                AND    valid_yn    = 'Y') b			
               ON   a.division_id             = b.division_id
               AND  a.to_scm_site_id          = b.scm_site_id

               LEFT JOIN  scp_mst_bod_n_v bod WITH (NOLOCK) -- 20210707 PJ20209643 scp_mst_bod_v 에서 scp_mst_bod_n_v로 변경
               ON    bod.division_id    = a.division_id
               AND   bod.from_site      = a.from_scm_site_id
               AND   bod.to_site        = a.to_scm_site_id
               AND   bod.incoterms      = a.final_incoterms -- a.incoterms  20201006 PJ20202001 변경
               AND   bod.transport_mode = a.transport_mode
               AND   bod.bod_valid_yn   = 'Y'

			   AND   bod.from_yyyymmdd <= a.plant_issue_date -- 20210707 PJ20209643 추가
			   AND   bod.to_yyyymmdd   >= a.plant_issue_date -- 20210707 PJ20209643 추가

			   -- From/To/Tr Mode 가 맞는 경우의 MAX(LT)
               LEFT JOIN (SELECT A.division_id, A.from_site, A.to_site, A.transport_mode
							   --, MAX(lt_total) lt_total
							   , MAX(add_after_lt_total) add_after_lt_total		--2021.05.03 lt_total -> add_after_lt_total
						  FROM   scp_mst_bod_n_v A WITH (NOLOCK) -- 20210707 PJ20209643 scp_mst_bod_v 에서 scp_mst_bod_n_v로 변경
						  WHERE  A.bod_valid_yn    = 'Y'
						  GROUP BY A.division_id, A.from_site,A.to_site, A.transport_mode
						 ) bod2 
               ON    bod2.division_id    = a.division_id
               AND   bod2.from_site      = a.from_scm_site_id
               AND   bod2.to_site        = a.to_scm_site_id
               AND   bod2.transport_mode = a.transport_mode

        WHERE  1=1
        AND    a.result_type            = 'C'
		--AND    a.final_incoterms             <> 'FOB' 
		AND    a.valid_yn               = 'Y'   -- 해상재고

		UNION
        -----------------------------------------------------------
		-- 1-4). to site가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC Mapping 된 것
        -----------------------------------------------------------
        -- 20220121  PJ20216891 Stock_v -> Stock 테이블로 변경
		--SELECT CONVERT(NVARCHAR(8), a.cutoff_date, 112)   AS result_date
		SELECT a.cutoff_date   AS result_date -- Stock 테이블은 YYYYMMDD 형태임
             , 'V'             AS result_type
             , a.company_id
             , a.division_id
             , a.plant_id 
			 , CONVERT(NVARCHAR(10), ROW_NUMBER() OVER (ORDER BY a.plant_id, a.item_id)) AS shipment_no
             , ''    AS project_code
             , a.item_id
             , ''    AS plant_issue_date
             , 'DAP' AS incoterms -- VMI 임
			 
             -- 20201006 PJ20202001 컬럼 추가
             , 'DAP' AS final_incoterms 
			 
             , ''    AS fcst_type
	         , ''    AS customer_code
             -- 20201006 PJ20202001 컬럼 추가
             , ''    AS final_soldto_code

             , ''    AS shipto_code
             -- , ''    AS from_scm_site_id
			 , ( SELECT TOP 1 MSI.PLANT_SITE_ID
		         FROM   SCM_MST_SITE_ITEM_PRIORITY   MSI WITH(NOLOCK)
		                INNER JOIN DBO.SCM_MST_SITE  I   WITH(NOLOCK)
			                ON  MSI.DIVISION_ID   = I.DIVISION_ID
							AND MSI.PLANT_SITE_ID = I.SCM_SITE_ID
		         WHERE  1=1
		         AND    MSI.ITEM_ID       = A.ITEM_ID
		         AND    MSI.DIVISION_ID   = A.DIVISION_ID
		         AND    MSI.PRIORITY      = 1
                 AND    I.SITE_TYPE       = 'PLANT'
                 AND    I.VALID_YN        = 'Y'
		         AND    MSI.VALID_YN      = 'Y'
				 AND    I.OPERATION_GROUP <> 'W'
                 AND    CONVERT(char(8), GETDATE(), 112) BETWEEN MSI.FROM_YYYYMMDD AND MSI.TO_YYYYMMDD
                 ORDER  BY I.OSP_YN, MSI.PRIORITY_SEQ DESC )  AS from_scm_site_id  --  2025.03.20	kimcd 생산지 기본 값 설정
             , ms.scm_site_id           AS to_scm_site_id
			 , 'SALES'                  AS site_type
	         , isnull(a.scm_qty, 0)     AS delivery_qty
             , a.qty_uom                AS uom
             , 'TRK'                    AS transport_mode 
	         , NULL  AS shipping_date
             , NULL  AS pol
             , NULL  AS pol_atd_date 
	         , NULL  AS pod
             , NULL  AS pod_eta_date
             , NULL  AS pod_ata_date
             , NULL  AS pod_etd_date
             , NULL  AS pod_atd_date 
	         , NULL  AS f_dest_port_code
             , NULL  AS f_dest_eta_date
             , NULL  AS f_dest_ata_date 
			             
             , CONVERT(NVARCHAR(8), DATEADD(d, 1, a.cutoff_date), 112)  AS eta_date -- Plan 시작일자로 처리	
			 , a.storage_id  AS attribute2	-- 20220628 storage_id 추가		   
        -- 20220121  PJ20216891 Stock_v -> Stock 테이블로 변경
		-- FROM   scm_dnm_stock_v  a WITH (NOLOCK)
		FROM   scm_dnm_stock  a WITH (NOLOCK)
               INNER JOIN   scm_mst_vmi_int_sloc ms with(nolock)
               ON    a.division_id = ms.division_id	
               AND   a.plant_id    = ms.plant_id
               AND   a.storage_id  = ms.storage_id
               AND   ms.valid_yn   = 'Y'

        WHERE  1=1

       ) inv   

         -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
         --            VMI 전진 검사 LT 추가 적용 : SCM_MST_SITE_ITEM 테이블의 SCP_VMI_LT 값 만큼 ETA에 더해 줌
         LEFT OUTER JOIN (SELECT s.division_id, s.scm_site_id, s.item_id
                               , MAX(ISNULL(s.scp_vmi_lt, 0)) AS lt_day
                          FROM   scm_mst_site_item s WITH(NOLOCK)
                                 INNER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)

                                 ON  s.division_id  = md.segment1
                                 AND s.scm_site_id  = md.segment2
                                 AND md.lookup_type = 'VMI_LT_SITE'
                                 AND s.valid_yn     = 'Y'
                                 AND md.valid_yn    = 'Y'

                          GROUP BY s.division_id, s.scm_site_id, s.item_id
                         ) si
         ON  inv.division_id    = si.division_id
         AND inv.to_scm_site_id = si.scm_site_id
         AND inv.item_id        = si.item_id

   WHERE 1=1
   --  20220217 PJ20216891  Warranty Plant 제외
   AND  inv.plant_id <> DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V','WarrantyPlant')
   AND  (   ISNULL(inv.from_scm_site_id, '') = ''
         OR inv.from_scm_site_id IN ( SELECT scm_site_id
                                      FROM   dbo.scm_mst_site WITH (NOLOCK) 
                                      WHERE  ISNULL(operation_group, '*') <> 'W'
                                    ) 
        )
   ;


