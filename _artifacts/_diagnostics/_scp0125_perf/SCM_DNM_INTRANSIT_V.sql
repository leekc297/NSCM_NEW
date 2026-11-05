SELECT
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
 * 2026.07.06   ZIONEX         [PJ202650304] NextSCM Migration
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
       A.RESULT_DATE
     , A.RESULT_TYPE
     , A.COMPANY_ID
     , A.DIVISION_ID
     , A.PLANT_ID
     , A.SHIPMENT_NO
     , A.PROJECT_CODE
     , A.ITEM_ID
     , A.PLANT_ISSUE_DATE
     , A.INCOTERMS
     , A.FINAL_INCOTERMS
     , A.FCST_TYPE
     , A.CUSTOMER_CODE
     , A.FINAL_SOLDTO_CODE
     , A.SHIPTO_CODE
     , A.FROM_SCM_SITE_ID
     , A.TO_SCM_SITE_ID
     , A.SITE_TYPE
     , A.DELIVERY_QTY
     , A.UOM
     , A.TRANSPORT_MODE
     , A.SHIPPING_DATE
     , A.POL
     , A.POL_ATD_DATE
     , A.POD
     , A.POD_ETA_DATE
     , A.POD_ATA_DATE
     , A.POD_ETD_DATE
     , A.POD_ATD_DATE
     , A.F_DEST_PORT_CODE
     , A.F_DEST_ETA_DATE
     , A.F_DEST_ATA_DATE
     /* VMI 전진검사 LT(scp_vmi_lt)를 ETA에 더함 */
     , CASE WHEN VALIDATE_CONVERSION(A.ETA_DATE AS DATE, 'YYYYMMDD') = 1
            THEN TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD') + NVL(B.LT_DAY, 0), 'YYYYMMDD')
            ELSE A.ETA_DATE
       END   AS ETA_DATE
     , A.ATTRIBUTE2   AS STORAGE_ID
  FROM ( /* 1-1. Intransit(GTS) : result_type = 'I' */
         SELECT A.RESULT_DATE
              , A.RESULT_TYPE
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.PLANT_ID
              , A.SHIPMENT_NO
              , A.PROJECT_CODE
              , A.ITEM_ID
              , A.PLANT_ISSUE_DATE
              , CASE WHEN A.FROM_SCM_SITE_ID = FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V', 'SCM_SITE_ID')
                      AND A.TO_SCM_SITE_ID = 'LGE_US_HZP' THEN 'DDP' ELSE A.INCOTERMS
                END   AS INCOTERMS
              , CASE WHEN A.FROM_SCM_SITE_ID = FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V', 'SCM_SITE_ID')
                      AND A.TO_SCM_SITE_ID = 'LGE_US_HZP' THEN 'DDP' ELSE A.FINAL_INCOTERMS
                END   AS FINAL_INCOTERMS
              , A.FCST_TYPE
              , A.CUSTOMER_CODE
              , A.FINAL_SOLDTO_CODE
              , A.SHIPTO_CODE
              , A.FROM_SCM_SITE_ID
              , A.TO_SCM_SITE_ID
              , B.SITE_TYPE
              , A.DELIVERY_QTY
              , A.UOM
              , A.TRANSPORT_MODE
              , A.SHIPPING_DATE
              , A.POL
              , A.POL_ATD_DATE
              , A.POD
              , A.POD_ETA_DATE
              , A.POD_ATA_DATE
              , A.POD_ETD_DATE
              , A.POD_ATD_DATE
              , A.F_DEST_PORT_CODE
              , A.F_DEST_ETA_DATE
              , A.F_DEST_ATA_DATE
              , CASE WHEN A.F_DEST_ETA_DATE IS NULL THEN
                          CASE WHEN C.ADD_AFTER_LT_TOTAL IS NULL THEN
                                    CASE WHEN D.ADD_AFTER_LT_TOTAL IS NULL
                                         THEN TO_CHAR(TO_DATE(A.RESULT_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD')
                                         ELSE TO_CHAR(TO_DATE(A.PLANT_ISSUE_DATE, 'YYYYMMDD') + D.ADD_AFTER_LT_TOTAL, 'YYYYMMDD')
                                    END
                               ELSE TO_CHAR(TO_DATE(A.PLANT_ISSUE_DATE, 'YYYYMMDD') + C.ADD_AFTER_LT_TOTAL, 'YYYYMMDD')
                          END
                     ELSE A.F_DEST_ETA_DATE
                END   AS ETA_DATE
              , A.ATTRIBUTE2
           FROM SCM_DNM_INTRANSIT_C   A
              , ( SELECT DIVISION_ID
                       , SCM_SITE_ID
                       , SITE_TYPE
                    FROM SCM_MST_SITE
                   WHERE SITE_TYPE IN ('PLANT', 'SALES')
                     AND VALID_YN = 'Y' )   B
              , SCP_MST_BOD_N_V   C
              , ( SELECT A.DIVISION_ID
                       , A.FROM_SITE
                       , A.TO_SITE
                       , A.TRANSPORT_MODE
                       , MAX(A.ADD_AFTER_LT_TOTAL)   AS ADD_AFTER_LT_TOTAL
                    FROM SCP_MST_BOD_N_V   A
                   WHERE A.BOD_VALID_YN = 'Y'
                   GROUP BY A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, A.TRANSPORT_MODE )   D
          WHERE B.DIVISION_ID = A.DIVISION_ID
            AND B.SCM_SITE_ID = A.TO_SCM_SITE_ID
            AND C.DIVISION_ID(+) = A.DIVISION_ID
            AND C.FROM_SITE(+) = A.FROM_SCM_SITE_ID
            AND C.TO_SITE(+) = A.TO_SCM_SITE_ID
            AND C.INCOTERMS(+) = A.FINAL_INCOTERMS
            AND C.TRANSPORT_MODE(+) = A.TRANSPORT_MODE
            AND C.BOD_VALID_YN(+) = 'Y'
            AND C.FROM_YYYYMMDD(+) <= A.PLANT_ISSUE_DATE
            AND C.TO_YYYYMMDD(+) >= A.PLANT_ISSUE_DATE
            AND D.DIVISION_ID(+) = A.DIVISION_ID
            AND D.FROM_SITE(+) = A.FROM_SCM_SITE_ID
            AND D.TO_SITE(+) = A.TO_SCM_SITE_ID
            AND D.TRANSPORT_MODE(+) = A.TRANSPORT_MODE
            AND A.RESULT_TYPE = 'I'
            AND A.VALID_YN = 'Y'
         UNION
         /* 1-3. 법인간 운송중 재고 : result_type = 'C' */
         SELECT A.RESULT_DATE
              , A.RESULT_TYPE
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.PLANT_ID
              , A.SHIPMENT_NO
              , A.PROJECT_CODE
              , A.ITEM_ID
              , A.PLANT_ISSUE_DATE
              , CASE WHEN A.FROM_SCM_SITE_ID = FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V', 'SCM_SITE_ID')
                      AND A.TO_SCM_SITE_ID = 'LGE_US_HZP' THEN 'DDP' ELSE A.INCOTERMS
                END   AS INCOTERMS
              , CASE WHEN A.FROM_SCM_SITE_ID = FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V', 'SCM_SITE_ID')
                      AND A.TO_SCM_SITE_ID = 'LGE_US_HZP' THEN 'DDP' ELSE A.FINAL_INCOTERMS
                END   AS FINAL_INCOTERMS
              , A.FCST_TYPE
              , A.CUSTOMER_CODE
              , A.FINAL_SOLDTO_CODE
              , A.SHIPTO_CODE
              , A.FROM_SCM_SITE_ID
              , A.TO_SCM_SITE_ID
              , B.SITE_TYPE
              , A.DELIVERY_QTY
              , A.UOM
              , A.TRANSPORT_MODE
              , A.SHIPPING_DATE
              , A.POL
              , A.POL_ATD_DATE
              , A.POD
              , A.POD_ETA_DATE
              , A.POD_ATA_DATE
              , A.POD_ETD_DATE
              , A.POD_ATD_DATE
              , A.F_DEST_PORT_CODE
              , A.F_DEST_ETA_DATE
              , A.F_DEST_ATA_DATE
              , CASE WHEN A.F_DEST_ETA_DATE IS NULL THEN
                          CASE WHEN C.ADD_AFTER_LT_TOTAL IS NULL THEN
                                    CASE WHEN D.ADD_AFTER_LT_TOTAL IS NULL
                                         THEN TO_CHAR(TO_DATE(A.RESULT_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD')
                                         ELSE TO_CHAR(TO_DATE(A.PLANT_ISSUE_DATE, 'YYYYMMDD') + D.ADD_AFTER_LT_TOTAL, 'YYYYMMDD')
                                    END
                               ELSE TO_CHAR(TO_DATE(A.PLANT_ISSUE_DATE, 'YYYYMMDD') + C.ADD_AFTER_LT_TOTAL, 'YYYYMMDD')
                          END
                     ELSE A.F_DEST_ETA_DATE
                END   AS ETA_DATE
              , A.ATTRIBUTE2
           FROM SCM_DNM_INTRANSIT_C   A
              , ( SELECT DIVISION_ID
                       , SCM_SITE_ID
                       , SITE_TYPE
                    FROM SCM_MST_SITE
                   WHERE VALID_YN = 'Y' )   B
              , SCP_MST_BOD_N_V   C
              , ( SELECT A.DIVISION_ID
                       , A.FROM_SITE
                       , A.TO_SITE
                       , A.TRANSPORT_MODE
                       , MAX(A.ADD_AFTER_LT_TOTAL)   AS ADD_AFTER_LT_TOTAL
                    FROM SCP_MST_BOD_N_V   A
                   WHERE A.BOD_VALID_YN = 'Y'
                   GROUP BY A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, A.TRANSPORT_MODE )   D
          WHERE B.DIVISION_ID = A.DIVISION_ID
            AND B.SCM_SITE_ID = A.TO_SCM_SITE_ID
            AND C.DIVISION_ID(+) = A.DIVISION_ID
            AND C.FROM_SITE(+) = A.FROM_SCM_SITE_ID
            AND C.TO_SITE(+) = A.TO_SCM_SITE_ID
            AND C.INCOTERMS(+) = A.FINAL_INCOTERMS
            AND C.TRANSPORT_MODE(+) = A.TRANSPORT_MODE
            AND C.BOD_VALID_YN(+) = 'Y'
            AND C.FROM_YYYYMMDD(+) <= A.PLANT_ISSUE_DATE
            AND C.TO_YYYYMMDD(+) >= A.PLANT_ISSUE_DATE
            AND D.DIVISION_ID(+) = A.DIVISION_ID
            AND D.FROM_SITE(+) = A.FROM_SCM_SITE_ID
            AND D.TO_SITE(+) = A.TO_SCM_SITE_ID
            AND D.TRANSPORT_MODE(+) = A.TRANSPORT_MODE
            AND A.RESULT_TYPE = 'C'
            AND A.VALID_YN = 'Y'
         UNION
         /* 1-4. VMI 정보 (SCM_MST_VMI_INT_SLOC 매핑) */
         SELECT A.CUTOFF_DATE   AS RESULT_DATE
              , 'V'   AS RESULT_TYPE
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.PLANT_ID
--            , TO_CHAR(ROW_NUMBER() OVER (ORDER BY A.PLANT_ID, A.ITEM_ID))   AS SHIPMENT_NO                    --  2026.10.07 AJS
              , TO_CHAR(ROW_NUMBER() OVER (PARTITION BY 'V' ORDER BY A.PLANT_ID, A.ITEM_ID))   AS SHIPMENT_NO   --  2026.10.07 AJS 번호 동일 · RESULT_TYPE 조건을 받아 VMI 갈래 생략
              , ''    AS PROJECT_CODE
              , A.ITEM_ID
              , ''    AS PLANT_ISSUE_DATE
              , 'DAP' AS INCOTERMS
              , 'DAP' AS FINAL_INCOTERMS
              , ''    AS FCST_TYPE
              , ''    AS CUSTOMER_CODE
              , ''    AS FINAL_SOLDTO_CODE
              , ''    AS SHIPTO_CODE
              , ( SELECT PLANT_SITE_ID
                    FROM ( SELECT SA.PLANT_SITE_ID
                             FROM SCM_MST_SITE_ITEM_PRIORITY   SA
                                , SCM_MST_SITE                 SB
                            WHERE SA.DIVISION_ID = SB.DIVISION_ID
                              AND SA.PLANT_SITE_ID = SB.SCM_SITE_ID
                              AND SA.ITEM_ID = A.ITEM_ID
                              AND SA.DIVISION_ID = A.DIVISION_ID
                              AND SA.PRIORITY = 1
                              AND SB.SITE_TYPE = 'PLANT'
                              AND SB.VALID_YN = 'Y'
                              AND SA.VALID_YN = 'Y'
                              AND SB.OPERATION_GROUP <> 'W'
                              AND TO_CHAR(SYSDATE, 'YYYYMMDD') BETWEEN SA.FROM_YYYYMMDD AND SA.TO_YYYYMMDD
                            ORDER BY SB.OSP_YN, SA.PRIORITY_SEQ DESC )
                   WHERE ROWNUM = 1 )   AS FROM_SCM_SITE_ID
              , B.SCM_SITE_ID   AS TO_SCM_SITE_ID
              , 'SALES'   AS SITE_TYPE
              , NVL(A.SCM_QTY, 0)   AS DELIVERY_QTY
              , A.QTY_UOM   AS UOM
              , 'TRK'   AS TRANSPORT_MODE
              , NULL  AS SHIPPING_DATE
              , NULL  AS POL
              , NULL  AS POL_ATD_DATE
              , NULL  AS POD
              , NULL  AS POD_ETA_DATE
              , NULL  AS POD_ATA_DATE
              , NULL  AS POD_ETD_DATE
              , NULL  AS POD_ATD_DATE
              , NULL  AS F_DEST_PORT_CODE
              , NULL  AS F_DEST_ETA_DATE
              , NULL  AS F_DEST_ATA_DATE
              , TO_CHAR(TO_DATE(A.CUTOFF_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD')   AS ETA_DATE
              , A.STORAGE_ID   AS ATTRIBUTE2
           FROM SCM_DNM_STOCK          A
              , SCM_MST_VMI_INT_SLOC   B
          WHERE A.DIVISION_ID = B.DIVISION_ID
            AND A.PLANT_ID = B.PLANT_ID
            AND A.STORAGE_ID = B.STORAGE_ID
            AND B.VALID_YN = 'Y' )   A
     , ( SELECT A.DIVISION_ID
              , A.SCM_SITE_ID
              , A.ITEM_ID
              , MAX(NVL(A.SCP_VMI_LT, 0))   AS LT_DAY
           FROM SCM_MST_SITE_ITEM             A
              , SCM_ADM_LOOKUP_MASTER_DETAIL  B
          WHERE A.DIVISION_ID = B.SEGMENT1
            AND A.SCM_SITE_ID = B.SEGMENT2
            AND B.LOOKUP_TYPE = 'VMI_LT_SITE'
            AND A.VALID_YN = 'Y'
            AND B.VALID_YN = 'Y'
          GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID )   B
 WHERE A.DIVISION_ID = B.DIVISION_ID(+)
   AND A.TO_SCM_SITE_ID = B.SCM_SITE_ID(+)
   AND A.ITEM_ID = B.ITEM_ID(+)
   AND A.PLANT_ID <> FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V', 'WarrantyPlant')
   AND ( A.FROM_SCM_SITE_ID IS NULL
      OR A.FROM_SCM_SITE_ID IN (SELECT SCM_SITE_ID
                                  FROM SCM_MST_SITE
                                 WHERE NVL(OPERATION_GROUP, '*') <> 'W') )