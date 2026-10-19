




CREATE VIEW [dbo].[SCM_DNM_SSP_PLAN_V] AS
/*
 * Program ID   : SCM_DNM_SSP_PLAN_V
 * Description  : 재고 : DW용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.10.02   KSG            Initial Release : PJ20249346 LGES SCP 개선과제 이행 : SSP Confirm + SSP Request 정보 : SCP Plan Input용
 * 2025.03.26   kimcd          [PJ20249548R] SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 월요일 출하 실적으로 변경.
 *                             E20250217-000373 통합FP → SCP 출하계획 전송 시 월요일 출하실적 전송 요청
 * 2025.05.07   kimcd          [PJ2024A332] 독립적 Planning 체계 및 Master Validation UI 구축
 */
-- 1. SSP Confirm 정보
SELECT 'CFM' AS SSP_TYPE                                                                                                                                                                                                                                                                                      
 	, sc.division_id, sc.confirm_id, sc.from_site, sc.bod_id AS bod_id, sc.to_site AS to_site

    , sc.incoterms, sc.transport_mode
	, sc.change_type, sc.biz_type
    , sc.project_code, sc.fcst_type

    , sc.item_id
    , sc.yyyymmdd
    , IIF(ISNULL(sc.eta_date, '') = '', CONVERT(DATETIME, sc.yyyymmdd), sc.eta_date) AS eta_date
    , sc.qty
FROM   ssp_anl_ship_confirm sc WITH (NOLOCK)
WHERE  sc.division_id         = sc.division_id
AND    sc.qty                 > 0
AND    sc.yyyymmdd            >= CASE WHEN DATEPART(WEEKDAY, CONVERT(DATE, GETDATE() )) != '2' -- 월요일
                                       AND sc.division_id = '81_UC'
                                           THEN CONVERT(CHAR(8), DATEADD(DD, -6, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 화요일
                                           ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일
										   END
								 -- 2025.05.07   kimcd  [PJ2024A332] 독립적 Planning 체계 및 Master Validation UI 구축
                                 -- 2025.03.26   kimcd  [PJ20249548R] SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 조회 일자에 따라 조건 변경
AND    sc.change_type         = 'C'  --  20180716 추가

-- 2. SSP Request 정보
UNION ALL
SELECT 'REQ' AS SSP_TYPE                                                                                                                                                                                                                                                                                      
 	, tt0.DIVISION_ID,'-' AS CONFIRM_ID, tt0.PLANT_SITE_ID AS FROM_SITE, tt0.BOD_ID, tt0.SCM_SITE_ID AS TO_SITE
	
	, ISNULL(tt1.SSP_INCOTERMS, tt0.INCOTERMS)   AS INCOTERMS, tt0.TRANSPORT_MODE
	, '-' AS CHANGE_TYPE, FI.OPERATION_GROUP AS BIZ_TYPE
	, tt0.PROJECT_CODE, tt0.FCST_TYPE

 	, tt0.ITEM_ID
	, tt0.YYYYMMDD                                                                                                                                                               
 	, CONVERT(VARCHAR(8),CONVERT(DATETIME,[dbo].[FN_GET_SSP_ETA_DATE](tt0.DIVISION_ID, tt0.BOD_ID, tt0.YYYYMMDD) ,112), 112) AS ETA_DATE 
	, tt0.QTY 

FROM DM_PLN_SHIPMENT_REQ tt0 WITH(NOLOCK)                                                                                                                                                                                                                                                               
 	INNER JOIN  scp_mst_bod_n_v tt1 WITH(NOLOCK) ON tt0.DIVISION_ID = tt1.division_id  AND tt0.bod_id = tt1.bod_id                                                                                                                                                                                                                  
 	INNER JOIN SCM_MST_SITE tt2 WITH(NOLOCK)                                                                                                                                                                                                                  
 		ON tt0.DIVISION_ID = tt2.DIVISION_ID 
 		AND tt0.PLANT_SITE_ID = tt2.SCM_SITE_ID 
 		AND tt2.site_type		= 'PLANT' 
 		AND tt2.valid_yn		= 'Y' 
	LEFT OUTER JOIN SCM_MST_SITE FS  WITH(NOLOCK)
		ON  tt0.DIVISION_ID = FS.DIVISION_ID 
		AND tt0.PLANT_SITE_ID = FS.SCM_SITE_ID 
		AND FS.VALID_YN    = 'Y' 
	LEFT OUTER JOIN SCP_MST_FINAL_ITEM AS FI WITH(NOLOCK)				 
		ON FI.DIVISION_ID = tt0.DIVISION_ID					 
		AND FI.ITEM_ID	  = tt0.ITEM_ID	
	LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
		ON  tt0.DIVISION_ID = (CASE WHEN FI.OPERATION_GROUP = 'E' THEN E.DIVISION_ID ELSE  E.ASSY_DIVISION_ID END)
        AND tt0.PLANT_SITE_ID = (CASE WHEN FI.OPERATION_GROUP = 'E' THEN E.SCM_SITE_ID ELSE  E.ASSY_SCM_SITE_ID END)
		AND tt0.ITEM_ID       = E.ITEM_ID		
WHERE 1 = 1                                                                                                                                                                                                                                                                                 
AND  tt0.DIVISION_ID     = tt0.DIVISION_ID
AND  tt0.QTY            > 0
AND  tt0.yyyymmdd       >= CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 전주 월요일
-- 2025.03.26   kimcd  [PJ20249548R] SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 실적 조회 과정 추가 시작
--                     E20250217-000373 통합FP → SCP 출하계획 전송 시 월요일 출하실적 전송 요청
UNION ALL
 			SELECT 'CFM' AS SSP_TYPE
			    , E.DIVISION_ID             AS DIVISION_ID
			,       E.CONFIRM_ID  + '_ER'    AS CONFIRM_ID
			, E.FROM_SCM_SITE_ID AS FROM_SITE
			, B.BOD_ID AS BOD_ID --- 추가 필요
			,       E.TO_SCM_SITE_ID AS TO_SITE
			,       CASE WHEN mst.site_type = 'PLANT' THEN 'DAP'
											   ELSE ISNULL(E.INCOTERMS, '-')
										  END				  AS INCOTERMS
			,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
			, 'C' AS CHANGE_TYPE
			, F.OPERATION_GROUP AS BIZ_TYPE --- 추가 필요
			,  CASE WHEN ISNULL(E.PROJECT_CODE, '') = '' THEN '-' ELSE E.PROJECT_CODE END    AS PROJECT_CODE
			, '-' AS FCST_TYPE --- 없음
			,       E.ITEM_ID        AS ITEM_ID -- 20240627 E20240612-001030 실제 Item ID 로 조회
			,       E.EXFACTORY_DATE          AS YYYYMMDD

			--	, E.ETA_DATE AS ORG_ETA_DATE -----

			,	MAX( CASE WHEN ISNULL(E.ETA_DATE, '') ='' THEN	CONVERT(CHAR(8), DATEADD(DD, (ISNULL(b.lt_total, 0)),  CONVERT(DATETIME, E.EXFACTORY_DATE)), 112)
			         ELSE E.ETA_DATE
			    END ) AS ETA_DATE
			,       SUM(E.EXFACTORY_QTY )     AS QTY

			 
			FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
					ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
				AND L.VALID_YN = 'Y'
				AND L.SEGMENT1    = E.SSP_TYPE

				JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만 
				ON   F.ITEM_ID = E.ITEM_ID 
				AND  F.DIVISION_ID = E.DIVISION_ID

				JOIN scm_mst_site ms WITH(NOLOCK)
				   ON E.DIVISION_ID = ms.DIVISION_ID
				AND E.FROM_SCM_SITE_ID = ms.SCM_SITE_ID
				AND ms.OSP_YN = 'N'

				JOIN scm_mst_site mst WITH(NOLOCK)
				   ON E.DIVISION_ID = mst.DIVISION_ID
				AND E.TO_SCM_SITE_ID = mst.SCM_SITE_ID

				 JOIN scp_mst_bod_n_v b WITH(NOLOCK)  -- ,ISNULL(lt_total, 0) lt_sum
				 ON    b.division_id    = e.division_id
				 AND   b.from_site      = e.from_scm_site_id
				 AND   b.to_site        = e.to_scm_site_id
				 -- To Site가 PLANT 일 경우 LT 계산용 Incoterms는 'DAP'로 처리함
				 AND   b.incoterms      = CASE WHEN mst.site_type = 'PLANT' THEN 'DAP'
											   ELSE E.INCOTERMS
										  END
				 AND   b.transport_mode = e.transport_mode
				 AND   b.from_yyyymmdd <= e.EXFACTORY_DATE
				 AND   b.to_yyyymmdd   >= e.EXFACTORY_DATE
				 AND   b.bod_valid_yn = 'Y'

			WHERE 1=1
			AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
			AND   E.CONFIRM_ID LIKE 'C%'
			AND   E.EXFACTORY_DATE	>= convert(datetime, CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)) -- 전주 월요일
            AND   E.EXFACTORY_DATE   < CASE WHEN DATEPART(WEEKDAY, CONVERT(DATE, GETDATE() )) != '2' -- 월요일
                                       AND E.division_id = '81_UC'
                                           THEN CONVERT(CHAR(8), DATEADD(DD, -6, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 화요일
                                           ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일
										   END
								 -- 2025.05.07   kimcd  [PJ2024A332] 독립적 Planning 체계 및 Master Validation UI 구축

			GROUP BY E.DIVISION_ID 
			,        E.CONFIRM_ID
			, E.FROM_SCM_SITE_ID 
			, B.BOD_ID --- 추가 필요
			,        E.EXFACTORY_DATE
			,        E.TRANSPORT_MODE, F.OPERATION_GROUP
			,        E.INCOTERMS		
			--,		 E.ETA_DATE	
			,        E.PROJECT_CODE
			,        E.TO_SCM_SITE_ID  -- 20220316 수정
			,        E.ITEM_ID         -- 20240627 E20240612-001030 실제 Item ID 로 조회
			,mst.site_type
			-- 2022.06.09
			UNION ALL

			-- SCS (외주) 실적
			/*--------------------------------------------------------------------------
			 1. PR_SSP_XIF_SCS_SHIP_RSLT_SUM_R  // SCM_DNM_SCS_SHIP_RESULT  i/f 테이블			 
			   , ATTR_05		AS CNFM_ID   -- confirm_id
				, MAX(ATTR_04)  AS SHIP_TO
				, MAX(ATTR_08)  AS TRANS_MODE
				, MAX(ATTR_09)  AS INCOTERMS
			---------------------------------------------------------------------------*/
			SELECT      'CFM' AS SSP_TYPE
			    , E.DIVISION_ID             AS DIVISION_ID
				,       ISNULL(E.ATTRIBUTE5,'-') +'_SR' AS CONFIRM_ID
			, E.SCM_SITE_ID AS FROM_SITE
			, ISNULL(C.BOD_ID, B.BOD_ID) AS BOD_ID --- 추가 필요
				,       E.TO_SITE                 AS TO_SITE
				,       CASE WHEN mst.site_type = 'PLANT' THEN 'DAP'
											   ELSE ISNULL(C.INCOTERMS,'-')
										  END  AS INCOTERMS
				,       ISNULL(C.TRANSPORT_MODE,'-')  AS TRANSPORT_MODE
			, 'C' AS CHANGE_TYPE
			, F.OPERATION_GROUP AS BIZ_TYPE --- 추가 필요
			,  CASE WHEN ISNULL(C.PROJECT_CODE, '') = '' THEN '-' ELSE C.PROJECT_CODE END    AS PROJECT_CODE
			, '-' AS FCST_TYPE --- 없음
			    ,       E.ITEM_ID                 AS ITEM_ID -- 20240627 E20240612-001030 실제 Item ID 로 조회
				,       E.SHIP_DATE               AS YYYYMMDD

				--, C.ETA_DATE AS ORG_ETA_DATE -----

			,	MAX( CASE WHEN ISNULL(C.ETA_DATE, '') ='' THEN	CONVERT(CHAR(8), DATEADD(DD, (ISNULL(b.lt_total, 0)),  CONVERT(DATETIME, E.SHIP_DATE)), 112)
			         ELSE C.ETA_DATE
			    END)  AS ETA_DATE
				,       SUM(E.SHIP_QTY )          AS QTY

				  
			FROM SCM_DNM_SCS_SHIP_RESULT E WITH(NOLOCK)
				JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만 
				ON   F.ITEM_ID = E.ITEM_ID 
				AND  F.DIVISION_ID = E.DIVISION_ID
		
				JOIN SCM_MST_SITE FS WITH(NOLOCK)
				ON   FS.SCM_SITE_ID = E.SCM_SITE_ID 
				AND  FS.DIVISION_ID = E.DIVISION_ID
				AND  FS.OSP_YN = 'Y'

				--JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)  --2022-08-19
				LEFT JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
				ON   E.DIVISION_ID	   = C.DIVISION_ID
				AND  E.PACK_MODEL_CODE = C.ITEM_ID 
				AND  E.SCM_SITE_ID     = C.FROM_SITE
				AND  E.TO_SITE         = C.TO_SITE
				AND  E.ATTRIBUTE5      = C.CONFIRM_ID

				JOIN scm_mst_site mst WITH(NOLOCK)
				   ON E.DIVISION_ID = mst.DIVISION_ID
				AND E.TO_SITE = mst.SCM_SITE_ID

				 JOIN scp_mst_bod_n_v b WITH(NOLOCK)  -- ,ISNULL(lt_total, 0) lt_sum
				 ON    b.division_id    = e.division_id
				 AND   b.from_site      = e.scm_site_id
				 AND   b.to_site        = e.TO_SITE
				 -- To Site가 PLANT 일 경우 LT 계산용 Incoterms는 'DAP'로 처리함
				 AND   b.incoterms      = CASE WHEN mst.site_type = 'PLANT' THEN 'DAP'
											   ELSE C.INCOTERMS
										  END
				 AND   b.transport_mode = c.transport_mode
				 AND   b.from_yyyymmdd <= e.SHIP_DATE
				 AND   b.to_yyyymmdd   >= e.SHIP_DATE
				 AND   b.bod_valid_yn = 'Y'


			WHERE 1=1
				AND E.ATTRIBUTE5 LIKE 'C%'  -- confirm_id
				AND E.SHIP_DATE    >= convert(datetime, CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)) -- 전주 월요일
                AND E.SHIP_DATE     < CASE WHEN DATEPART(WEEKDAY, CONVERT(DATE, GETDATE() )) != '2' -- 월요일
                                       AND E.division_id = '81_UC'
                                           THEN CONVERT(CHAR(8), DATEADD(DD, -6, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 화요일
                                           ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일
										   END
								 -- 2025.05.07   kimcd  [PJ2024A332] 독립적 Planning 체계 및 Master Validation UI 구축

			GROUP BY 
					 E.DIVISION_ID
			,        E.ATTRIBUTE5, E.SCM_SITE_ID
			, ISNULL(C.BOD_ID, B.BOD_ID) --- 추가 필요
			,        E.SHIP_DATE
			,        E.TO_SITE
			,        C.TRANSPORT_MODE, F.OPERATION_GROUP
			,        C.INCOTERMS
			,        C.PROJECT_CODE
			--,        C.ETA_DATE
			,        E.ITEM_ID    -- 20240627 E20240612-001030 실제 Item ID 로 조회
			,mst.site_type
--                     E20250217-000373 통합FP → SCP 출하계획 전송 시 월요일 출하실적 전송 요청
-- 2025.03.26   kimcd  [PJ20249548R] SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 실적 조회 과정 추가 끝
;
