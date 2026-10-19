




CREATE VIEW [dbo].[SCP_MST_BOD_N_V] AS
/*
 * Program ID   : SCP_MST_BOD_V
 * Description  : SCP BOD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.26   Kim SungGi     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.08   KSG            Z01 / Z02 별도 로직 적용 제외
 * 2018.07.18   KSG            To Site가 Plant 인 경우는 DIV 조건 제거
 * 2019.02.13   YHW            [CSR ID:3907873] SSP Distribution route/BOD상 'L/T TYPE'컬럼 추가요청
 * 2020.04.17   juhlee         [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선   
 *                               : lt_total_origin, ship_lt_total_origin 컬럼 추가 (incoterms와 관계없는 순수 물류 L/T) 
 * 2020.09.01   KSG            PJ20202001  LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : 법인간 거래 Incoterms 동기화
 * 2021.05.03   SEO			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - Before/After LT 추가
 * 2021.06.07   SEO			   PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
 */
-- To Site : SALES
SELECT b.division_id
     , b.BOD_ID
     , s.site_type AS bod_type
     , b.from_site
     , r.d_country   
     , r.d_port_code 
     , r.a_country   
     , r.a_port_code 
     , r.to_country  
     , r.to_city     
     , s.vmi_yn AS hub_sloc
     , b.to_site
     , b.incoterms
     , b.attribute1 AS ssp_incoterms -- 20200901 PJ20202001R  법인간 거래 Incoterms 동기화
     , r.transport_mode
     , b.route_id
     , b.priority
	 , dbo.FN_SCM_SYS_NVL(r.days_mon, 'N') AS days_mon
     , dbo.FN_SCM_SYS_NVL(r.days_tue, 'N') AS days_tue
     , dbo.FN_SCM_SYS_NVL(r.days_wed, 'N') AS days_wed
     , dbo.FN_SCM_SYS_NVL(r.days_thu, 'N') AS days_thu
     , dbo.FN_SCM_SYS_NVL(r.days_fri, 'N') AS days_fri
     , dbo.FN_SCM_SYS_NVL(r.days_sat, 'N') AS days_sat
     , dbo.FN_SCM_SYS_NVL(r.days_sun, 'N') AS days_sun
     , ISNULL(b.safety_stock, 0)           AS safety_stock
     , ISNULL(r.lt_departure_inland, 0)    AS lt_departure_inland
     , ISNULL(r.lt_wait_shipping, 0)       AS lt_wait_shipping
     , ISNULL(r.lt_voyage, 0)              AS lt_voyage
     , ISNULL(r.lt_lay_off_clearance, 0)   AS lt_lay_off_clearance
     , ISNULL(r.lt_arrival_inland, 0)      AS lt_arrival_inland
     , CASE WHEN ISNULL(l.segment3, '') = '' THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_before, 0) + ISNULL(b.lt_after, 0) 
            -- 2018. 06. 08 Z01 / Z02 별도 로직 적용 제외 : 재적용시 적용 LT는 확인 후 반영할 것
            --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z01' THEN 0                                -- 한국 Z01
            --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z02' THEN ISNULL(r.lt_departure_inland, 0) -- 한국 Z02
            --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z01' THEN ISNULL(r.lt_departure_inland, 0) -- 해외 Z01
            --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z02' THEN 0                                -- 해외 Z02
            WHEN l.segment3  = 'A'            THEN 0
            WHEN l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(b.lt_before, 0) 
            WHEN l.segment3  = 'C'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(b.lt_before, 0) 
            WHEN l.segment3  = 'D'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(b.lt_before, 0)  + ISNULL(b.lt_after, 0)
            WHEN l.segment3  = 'E'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(b.lt_before, 0)  + ISNULL(b.lt_after, 0) 
            WHEN l.segment3  = 'F'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_before, 0)  + ISNULL(b.lt_after, 0) 
            ELSE                                   ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_before, 0)  + ISNULL(b.lt_after, 0) 
       END AS lt_total	--2021.05.03 lt_before, lt_after 추가
     --20180402 추가 항차 LeadTime
     , ISNULL(CASE WHEN ISNULL(l.segment3, '') = '' THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(b.lt_before, 0)
                   -- 2018. 06. 08 Z01 / Z02 별도 로직 적용 제외
                   --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z01' THEN 0                                -- 한국 Z01
                   --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z02' THEN ISNULL(r.lt_departure_inland, 0) -- 한국 Z02
                   --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z01' THEN ISNULL(r.lt_departure_inland, 0) -- 해외 Z01
                   --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z02' THEN 0                                -- 해외 Z02
                   WHEN l.segment3  = 'A'            THEN 0
                   WHEN l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(b.lt_before, 0) 
                   ELSE                                   ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(b.lt_before, 0) 
               END, 0) AS ship_lt_total		--2021.05.03 lt_before 추가
     , b.valid_yn AS bod_valid_yn
     , r.valid_yn AS route_valid_yn
	 , r.lt_type
	 , ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)  AS lt_total_origin
     , ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) AS ship_lt_total_origin
	  -- 20200901 PJ20202001R  법인간 거래 Incoterms 동기화
     , CASE WHEN ISNULL(ssp_l.segment3, '') = ''  THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_after, 0)
            WHEN ssp_l.segment3  = 'A'            THEN 0
            WHEN ssp_l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0)
            WHEN ssp_l.segment3  = 'C'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)
            WHEN ssp_l.segment3  = 'D'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0)  + ISNULL(b.lt_after, 0)
            WHEN ssp_l.segment3  = 'E'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0)  + ISNULL(b.lt_after, 0)
            WHEN ssp_l.segment3  = 'F'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)  + ISNULL(b.lt_after, 0)
            ELSE                                       ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)  + ISNULL(b.lt_after, 0)
       END AS lt_total_ssp		--2021.05.03 lt_after 추가
     -- 20200901 PJ20202001R  법인간 거래 Incoterms 동기화
     , ISNULL(CASE WHEN ISNULL(ssp_l.segment3, '') = ''  THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)
                   WHEN ssp_l.segment3  = 'A'            THEN 0
                   WHEN ssp_l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0)
                   ELSE                                       ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) 
               END, 0) AS ship_lt_total_ssp

	 , b.lt_before as before_lt		--2021.05.03 추가
	 , b.lt_after as after_lt		--2021.05.03 추가
	 , CASE WHEN ISNULL(l.segment3, '') = '' THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) 
            -- 2018. 06. 08 Z01 / Z02 별도 로직 적용 제외 : 재적용시 적용 LT는 확인 후 반영할 것
            --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z01' THEN 0                                -- 한국 Z01
            --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z02' THEN ISNULL(r.lt_departure_inland, 0) -- 한국 Z02
            --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z01' THEN ISNULL(r.lt_departure_inland, 0) -- 해외 Z01
            --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z02' THEN 0                                -- 해외 Z02
            WHEN l.segment3  = 'A'            THEN 0
            WHEN l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0)
            WHEN l.segment3  = 'C'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)
            WHEN l.segment3  = 'D'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0)
            WHEN l.segment3  = 'E'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0)
            WHEN l.segment3  = 'F'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) 
            ELSE                                   ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) 
       END AS org_lt_total	--2021.05.03 추가 
     --20180402 추가 항차 LeadTime
     , ISNULL(CASE WHEN ISNULL(l.segment3, '') = '' THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)
                   -- 2018. 06. 08 Z01 / Z02 별도 로직 적용 제외
                   --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z01' THEN 0                                -- 한국 Z01
                   --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z02' THEN ISNULL(r.lt_departure_inland, 0) -- 한국 Z02
                   --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z01' THEN ISNULL(r.lt_departure_inland, 0) -- 해외 Z01
                   --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z02' THEN 0                                -- 해외 Z02
                   WHEN l.segment3  = 'A'            THEN 0
                   WHEN l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0)
                   ELSE                                   ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) 
               END, 0) AS org_ship_lt_total	--2021.05.03 추가 
	  -- 20200901 PJ20202001R  법인간 거래 Incoterms 동기화
     , CASE WHEN ISNULL(ssp_l.segment3, '') = ''  THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) 
            WHEN ssp_l.segment3  = 'A'            THEN 0
            WHEN ssp_l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0)
            WHEN ssp_l.segment3  = 'C'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)
            WHEN ssp_l.segment3  = 'D'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0)
            WHEN ssp_l.segment3  = 'E'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0)
            WHEN ssp_l.segment3  = 'F'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) 
            ELSE                                       ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) 
       END AS org_lt_total_ssp	--2021.05.03 추가 
     , CASE WHEN ISNULL(l.segment3, '') = '' THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_after, 0) 
			WHEN l.segment3  = 'A'            THEN 0
            WHEN l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0) 
            WHEN l.segment3  = 'C'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) 
            WHEN l.segment3  = 'D'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(b.lt_after, 0)
            WHEN l.segment3  = 'E'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(b.lt_after, 0)
            WHEN l.segment3  = 'F'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_after, 0)
            ELSE                                   ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_after, 0)
       END AS add_after_lt_total	    --2021.05.03 추가 
	 , l.segment3						--2021.05.03 추가 
	 , ssp_l.segment3 AS ssp_segment3	--2021.05.03 추가 
	 , b.attribute2 as from_yyyymmdd	--2021.06.07 추가
	 , b.attribute3 as to_yyyymmdd		--2021.06.07 추가

FROM   (select b.*
			, IIF(ISNUMERIC(ISNULL(b.attribute4,0))=1, CONVERT(INT,ISNULL(b.attribute4,0)), 0)	as lt_before	--2021.05.03 lt_before, 0:문자열, 1:순수한 숫자
			, IIF(ISNUMERIC(ISNULL(b.attribute5,0))=1, CONVERT(INT,ISNULL(b.attribute5,0)), 0)	as lt_after		--2021.05.03 lt_after, 0:문자열, 1:순수한 숫자
		from scp_mst_bod b WITH(NOLOCK) ) as b
       INNER JOIN scp_mst_distribution_route r WITH(NOLOCK)
       ON  b.route_id = r.route_id
       --AND b.valid_yn = 'Y'
       --AND r.valid_yn = 'Y'
       INNER JOIN scm_mst_site fs WITH(NOLOCK)
       ON  b.division_id = fs.division_id
       AND b.from_site   = fs.scm_site_id
       INNER JOIN scm_mst_site s WITH(NOLOCK)
       ON  b.division_id = s.division_id
       AND b.to_site     = s.scm_site_id
       AND s.site_type   = 'SALES'
       LEFT OUTER JOIN (SELECT *
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                        WHERE  lookup_type = 'INCOTERMS'
						AND    valid_yn    = 'Y'
					   ) l
       ON  b.incoterms = l.segment1
	   -- 20200901 PJ20202001R  법인간 거래 Incoterms 동기화
       LEFT OUTER JOIN (SELECT *
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                        WHERE  lookup_type = 'INCOTERMS'
						AND    valid_yn    = 'Y'
					   ) ssp_l
       ON  b.attribute1 = ssp_l.segment1
UNION
-- To Site : PLANT
SELECT b.division_id
     , b.BOD_ID
     , s.site_type AS bod_type
     , b.from_site
     , r.d_country   
     , r.d_port_code 
     , r.a_country   
     , r.a_port_code 
     , r.to_country  
     , r.to_city     
     , s.vmi_yn AS hub_sloc
     , b.to_site
     , b.incoterms
     , b.attribute1 AS ssp_incoterms -- 20200901 PJ20202001R  법인간 거래 Incoterms 동기화
     , r.transport_mode
     , b.route_id
     , b.priority
	 , dbo.FN_SCM_SYS_NVL(r.days_mon, 'N') AS days_mon
     , dbo.FN_SCM_SYS_NVL(r.days_tue, 'N') AS days_tue
     , dbo.FN_SCM_SYS_NVL(r.days_wed, 'N') AS days_wed
     , dbo.FN_SCM_SYS_NVL(r.days_thu, 'N') AS days_thu
     , dbo.FN_SCM_SYS_NVL(r.days_fri, 'N') AS days_fri
     , dbo.FN_SCM_SYS_NVL(r.days_sat, 'N') AS days_sat
     , dbo.FN_SCM_SYS_NVL(r.days_sun, 'N') AS days_sun
     , ISNULL(b.safety_stock, 0)           AS safety_stock
     , ISNULL(r.lt_departure_inland, 0)    AS lt_departure_inland
     , ISNULL(r.lt_wait_shipping, 0)       AS lt_wait_shipping
     , ISNULL(r.lt_voyage, 0)              AS lt_voyage
     , ISNULL(r.lt_lay_off_clearance, 0)   AS lt_lay_off_clearance
     , ISNULL(r.lt_arrival_inland, 0)      AS lt_arrival_inland
     , CASE WHEN ISNULL(l.segment3, '') = '' THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_before, 0) + ISNULL(b.lt_after, 0) 
            -- 2018. 06. 08 Z01 / Z02 별도 로직 적용 제외 : 재적용시 적용 LT는 확인 후 반영할 것
            --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z01' THEN 0                                -- 한국 Z01
            --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z02' THEN ISNULL(r.lt_departure_inland, 0) -- 한국 Z02
            --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z01' THEN ISNULL(r.lt_departure_inland, 0) -- 해외 Z01
            --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z02' THEN 0                                -- 해외 Z02
            WHEN l.segment3  = 'A'            THEN 0
            WHEN l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0)+ ISNULL(b.lt_before, 0)
            WHEN l.segment3  = 'C'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)+ ISNULL(b.lt_before, 0)
            WHEN l.segment3  = 'D'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(b.lt_before, 0) + ISNULL(b.lt_after, 0) 
            WHEN l.segment3  = 'E'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(b.lt_before, 0) + ISNULL(b.lt_after, 0) 
            WHEN l.segment3  = 'F'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_before, 0) + ISNULL(b.lt_after, 0) 
            ELSE                                   ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_before, 0) + ISNULL(b.lt_after, 0) 
       END AS lt_total		--2021.05.03 lt_before, lt_after 추가
     --20180402 추가 항차 LeadTime
     , ISNULL(CASE WHEN ISNULL(l.segment3, '') = '' THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(b.lt_before, 0)
                   -- 2018. 06. 08 Z01 / Z02 별도 로직 적용 제외
                   --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z01' THEN 0                                -- 한국 Z01
                   --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z02' THEN ISNULL(r.lt_departure_inland, 0) -- 한국 Z02
                   --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z01' THEN ISNULL(r.lt_departure_inland, 0) -- 해외 Z01
                   --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z02' THEN 0                                -- 해외 Z02
                   WHEN l.segment3  = 'A'            THEN 0
                   WHEN l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(b.lt_before, 0)
                   ELSE                                   ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(b.lt_before, 0)
               END, 0) AS ship_lt_total		--2021.05.03 lt_before 추가
     , b.valid_yn AS bod_valid_yn
     , r.valid_yn AS route_valid_yn
	 , r.lt_type
	 , ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)  AS lt_total_origin
     , ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) AS ship_lt_total_origin
	  -- 20200901 PJ20202001R  법인간 거래 Incoterms 동기화
     , CASE WHEN ISNULL(ssp_l.segment3, '') = ''  THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_after, 0)
            WHEN ssp_l.segment3  = 'A'            THEN 0
            WHEN ssp_l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0)
            WHEN ssp_l.segment3  = 'C'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)
            WHEN ssp_l.segment3  = 'D'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(b.lt_after, 0)
            WHEN ssp_l.segment3  = 'E'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(b.lt_after, 0)
            WHEN ssp_l.segment3  = 'F'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_after, 0)
            ELSE                                       ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_after, 0)
       END AS lt_total_ssp		--2021.05.03 lt_after 추가
     -- 20200901 PJ20202001R  법인간 거래 Incoterms 동기화
     , ISNULL(CASE WHEN ISNULL(ssp_l.segment3, '') = ''  THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)
                   WHEN ssp_l.segment3  = 'A'            THEN 0
                   WHEN ssp_l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0)
                   ELSE                                       ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) 
               END, 0) AS ship_lt_total_ssp
	 , b.lt_before as before_lt		--2021.05.03 추가
	 , b.lt_after as after_lt		--2021.05.03 추가
     , CASE WHEN ISNULL(l.segment3, '') = '' THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) 
            -- 2018. 06. 08 Z01 / Z02 별도 로직 적용 제외 : 재적용시 적용 LT는 확인 후 반영할 것
            --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z01' THEN 0                                -- 한국 Z01
            --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z02' THEN ISNULL(r.lt_departure_inland, 0) -- 한국 Z02
            --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z01' THEN ISNULL(r.lt_departure_inland, 0) -- 해외 Z01
            --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z02' THEN 0                                -- 해외 Z02
            WHEN l.segment3  = 'A'            THEN 0
            WHEN l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0)
            WHEN l.segment3  = 'C'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)
            WHEN l.segment3  = 'D'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0)
            WHEN l.segment3  = 'E'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0)
            WHEN l.segment3  = 'F'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) 
            ELSE                                   ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) 
       END AS org_lt_total	--2021.05.03 추가
     --20180402 추가 항차 LeadTime
     , ISNULL(CASE WHEN ISNULL(l.segment3, '') = '' THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)
                   -- 2018. 06. 08 Z01 / Z02 별도 로직 적용 제외
                   --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z01' THEN 0                                -- 한국 Z01
                   --WHEN fs.site_id  = 'A001' AND l.segment1 = 'Z02' THEN ISNULL(r.lt_departure_inland, 0) -- 한국 Z02
                   --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z01' THEN ISNULL(r.lt_departure_inland, 0) -- 해외 Z01
                   --WHEN fs.site_id <> 'A001' AND l.segment1 = 'Z02' THEN 0                                -- 해외 Z02
                   WHEN l.segment3  = 'A'            THEN 0
                   WHEN l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0)
                   ELSE                                   ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) 
               END, 0) AS org_ship_lt_total	--2021.05.03 추가
	  -- 20200901 PJ20202001R  법인간 거래 Incoterms 동기화
     , CASE WHEN ISNULL(ssp_l.segment3, '') = ''  THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) 
            WHEN ssp_l.segment3  = 'A'            THEN 0
            WHEN ssp_l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0)
            WHEN ssp_l.segment3  = 'C'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)
            WHEN ssp_l.segment3  = 'D'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0)
            WHEN ssp_l.segment3  = 'E'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0)
            WHEN ssp_l.segment3  = 'F'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) 
            ELSE                                       ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) 
       END AS org_lt_total_ssp	--2021.05.03 추가

     , CASE WHEN ISNULL(l.segment3, '') = '' THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_after, 0) 
			WHEN l.segment3  = 'A'            THEN 0
            WHEN l.segment3  = 'B'            THEN ISNULL(r.lt_departure_inland, 0)
            WHEN l.segment3  = 'C'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)
            WHEN l.segment3  = 'D'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(b.lt_after, 0)
            WHEN l.segment3  = 'E'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(b.lt_after, 0)
            WHEN l.segment3  = 'F'            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_after, 0)
            ELSE                                   ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0) + ISNULL(b.lt_after, 0)
       END AS add_after_lt_total	--2021.05.03 추가
	 , l.segment3						--2021.05.03 추가 
	 , ssp_l.segment3 as ssp_segment3	--2021.05.03 추가 
	 , b.attribute2 as from_yyyymmdd	--2021.06.07 추가
	 , b.attribute3 as to_yyyymmdd		--2021.06.07 추가
FROM   (select b.*
			, IIF(ISNUMERIC(ISNULL(b.attribute4,0))=1, CONVERT(INT,ISNULL(b.attribute4,0)), 0)	as lt_before	--2021.05.03 lt_before, 0:문자열, 1:순수한 숫자
			, IIF(ISNUMERIC(ISNULL(b.attribute5,0))=1, CONVERT(INT,ISNULL(b.attribute5,0)), 0)	as lt_after		--2021.05.03 lt_after, 0:문자열, 1:순수한 숫자
		from scp_mst_bod b WITH(NOLOCK) ) as b
       INNER JOIN scp_mst_distribution_route r WITH(NOLOCK)
       ON  b.route_id = r.route_id
       --AND b.valid_yn = 'Y'
       --AND r.valid_yn = 'Y'
       INNER JOIN scm_mst_site fs WITH(NOLOCK)
       ON  b.division_id = fs.division_id
       AND b.from_site   = fs.scm_site_id
	   -- 2018.07.18 To Site가 Plant 인 경우는 DIV 조건 제거
       INNER JOIN scm_mst_site s WITH(NOLOCK)
       ON  b.to_site     = s.scm_site_id
       AND s.site_type   = 'PLANT'
       LEFT OUTER JOIN (SELECT *
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                        WHERE  lookup_type = 'INCOTERMS'
						AND    valid_yn    = 'Y'
					   ) l
       ON  b.incoterms = l.segment1
	   -- 20200901 PJ20202001R  법인간 거래 Incoterms 동기화
       LEFT OUTER JOIN (SELECT *
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                        WHERE  lookup_type = 'INCOTERMS'
						AND    valid_yn    = 'Y'
					   ) ssp_l
       ON  b.attribute1 = ssp_l.segment1

