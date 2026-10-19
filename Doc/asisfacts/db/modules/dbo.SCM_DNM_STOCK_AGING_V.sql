







CREATE VIEW [dbo].[SCM_DNM_STOCK_AGING_V] AS
/*
 * Program ID   : SCM_DNM_STOCK_AGING_V
 * Description  : 활성화 재고
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 2. 06  Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018. 5. 11  Kim Jihye      Hold 재고 반영
 * 2018. 6. 28  Kim Jaejung    ship_available_date 컬럼 추가
 * 2018.06.29   Kim jaejung    소형 대표 ITEM_ID 로 실적 생성 로직 추가 (소형)
 * 2018.10.30   KSG            FP 테이블을 View 로 교체
 * 2019.01.30   juhlee	       operation_group, nick_name 컬럼 추가 
 * 2020.04.08   KSG            [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 : Hold 재고
 * 2025.09.15   kimcd          PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *                             SCP에 미 반영 품목의 재고를 SCP에 반영하는 품목으로 변경
 * 2025.11.04	hrkim		   [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 
 *								: FP 활성화 재고를 JV에서 ESS로 동기화. ESS 하위 조립품만 추출하여 동기화
 *								- 2025.12.23 가상 plant division '82' 조건 삭제 
 * 2025.12.15	ymh			   [E20251028-000588] MES F7200 / FCS E11 공정의 중복제거를 위해 FCS 제외공정룩업을 통해 E11제외처리
 * 2026.05.22	ymh			   E20260331-000738 82사업부 MA Plan 수행 시 속도지연
 */
WITH EXC_ASSY AS (SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SCP_EXC_ITEM_ID, CELL_ASSY_ITEM_ID
                  FROM   dbo.FN_GET_SCP_EXC_ITEM_ASSY_MAP (null) )
                  -- 2025.09.15 kimcd PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산. SCP 제외 대상 품목 -> Cell Assy로 전환 대상 정보 정리
SELECT  A.*
FROM   (SELECT sa.company_id
			  ,sa.division_id division_id
			  --,dbo.FN_GET_SCM_SITE_ID_PLANT(sa.PLANT_ID, dbo.FN_GET_ITEM_OPERATION_GROUP(sa.DIVISION_ID, RTRIM(LTRIM(sa.item_id)))) AS SCM_SITE_ID
			  -- [E20251028-000588] FCS 제외공정 반영관련 기존 로직 주석처리
			  --,dbo.FN_GET_SCM_SITE_ID_PLANT(sa.PLANT_ID, 'A') AS SCM_SITE_ID
			  -- [E20251028-000588] FCS 제외공정 반영관련 추가로직 시작
			  , CASE 
					WHEN FCS_EXCEPTION_OPERATION.OPERATION_ID IS NULL THEN dbo.FN_GET_SCM_SITE_ID_PLANT(sa.PLANT_ID, 'A') 
					ELSE NULL 
				END AS SCM_SITE_ID
			   -- [E20251028-000588] FCS 제외공정 반영관련 추가로직 끝
			  ,sa.site_id
			  ,sa.plant_id
			  ,sa.factory_id
			  ,sa.route_id
			  ,sa.line_id
			  ,DATEADD(DAY,-1,sa.cutoff_date) cutoff_date
			  ,sa.seq
			  -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 주석처리
			  --,[dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, RTRIM(LTRIM(ISNULL(EA.CELL_ASSY_ITEM_ID,sa.item_id)))) item_id --2018.06.29
			  -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 개선로직
			  , ISNULL(NULLIF(fi.packer_plan_item_id, ''), RTRIM(LTRIM(ISNULL(EA.CELL_ASSY_ITEM_ID,sa.item_id))))  as item_id
			   -- 2025.09.15 kimcd PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산. 품목을 CELL ASSY ITEM 우선
			  ,RTRIM(LTRIM(sa.item_id)) origin_item_id --2018.06.29
			  ,sa.production_type
			  ,sa.fcs_input_date

			  -- 20200408 가용일자 로직 변경  : MAX(AVAILABLE_DATE, UNHOLD_EXP_DATE) 로 변경
              ,CASE WHEN ISNULL(sa.aging_available_date, '1999-01-01') >= ISNULL(sa.unhold_exp_date, '1999-01-01') THEN sa.aging_available_date
                    ELSE sa.unhold_exp_date
               END available_date  
			  --,sa.aging_available_date AS available_date  -- 20181030 컬럼 변경 sa.available_date

			  ,sa.remain_lead_time
			  ,sa.holding_date
			  ,sa.input_qty
			  ,sa.qty
			  ,sa.qty_uom
			  ,sa.stock_status
			  ,sa.operation_id
			  ,sa.operation_seq
			  ,sa.op_start_time
			  ,sa.tray_op_status
			  ,sa.stock_type
			  -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 주석처리
			  --,[dbo].[FN_SCM_SYS_NVL](sa.wiphold_yn, 'N') wiphold_yn -- 2018. 5. 11  Kim Jihye
			  -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 개선로직
			  , ISNULL(NULLIF(sa.wiphold_yn, ''), 'N')  as wiphold_yn
			  ,sa.unhold_exp_date  -- 20181030 컬럼 추가
			  ,sa.special_yn  -- 20181030 컬럼 추가
			  ,sa.lot_id  -- 20181030 컬럼 추가
			  ,sa.ocv2_end_time  -- 20181030 컬럼 추가
			  ,sa.ship_available_date -- 2018. 6. 28
			  ,sa.before_degas  -- 20181030 컬럼 추가
			  ,sa.degas_end_date  -- 20181030 컬럼 추가
			  ,sa.insert_id
			  ,sa.insert_time
			  ,sa.update_id
			  ,sa.update_time
			  ,fi.operation_group  -- 20190130 컬럼 추가
			  ,fi.nick_name        -- 20190130 컬럼 추가
			  ,sa.aging_available_date
		FROM  SCM_DNM_STOCK_AGING_V_SN sa WITH(NOLOCK) -- 20181030 교체 SCM_DNM_STOCK_AGING_SN sa WITH(NOLOCK)		
		      LEFT JOIN EXC_ASSY  EA -- 2025.09.15 kimcd PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산. SCP 제외 대상 품목 -> Cell Assy로 전환 전환 JOIN
	              ON   SA.COMPANY_ID  = EA.COMPANY_ID
		          AND  SA.DIVISION_ID = EA.DIVISION_ID
				  AND  SA.SITE_ID     = EA.SITE_ID
				  AND  SA.PLANT_ID    = EA.PLANT_ID
				  AND  RTRIM(LTRIM(SA.ITEM_ID)) = EA.SCP_EXC_ITEM_ID
		      LEFT JOIN scp_mst_final_item fi --2018.06.29
	              ON   SA.DIVISION_ID = FI.DIVISION_ID
	              AND  RTRIM(LTRIM(ISNULL(EA.CELL_ASSY_ITEM_ID,sa.item_id))) = fi.item_id   -- 2025.09.15 kimcd PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산. 품목을 CELL ASSY ITEM 우선
			  -- 2025.12.12 CSR[E20251028-000588]  YMH 소형 MAF489266C10 PLANT내 재고 중복 CASE 
		      -- MES F7200 / FCS E11 공정의 중복제거를 위해 FCS 제외공정룩업을 통해 E11제외처리
			  LEFT OUTER JOIN 
			  (
					SELECT 
						SEGMENT1 AS OPERATION_ID
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL AS LMD WITH(NOLOCK)
					WHERE	LMD.LOOKUP_TYPE	= 'FCS_INVENTORY_EXCEPTION_OPERATION'
					AND		LMD.VALID_YN = 'Y'
					GROUP BY SEGMENT1 	
			  ) AS FCS_EXCEPTION_OPERATION
			  ON sa.OPERATION_ID = FCS_EXCEPTION_OPERATION.OPERATION_ID
        -- WHERE [dbo].[FN_SCM_SYS_NVL](wiphold_yn, 'N') = 'N' 2018. 5. 11  Kim Jihye
		-- 2018.04.30 ksg View에서는 전체 일자 정보 표시
        --AND   available_date >= cutoff_date
		-----------------------------------------------------------------------------------------------------
		--//## START - [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 line 재고 정보 추가
		-- 위의 본래의 쿼리 변경시 아래 가상 재고 추가를 위한 쿼리도 함께 수정 필요 
		-- 20251105 현재 가상 라인 매핑 전환 부분외에 모두 동일 
		-----------------------------------------------------------------------------------------------------
		UNION ALL
		SELECT MP.VL_COMPANY_ID										AS COMPANY_ID
			  ,MP.VL_DIVISION_ID									AS DIVISION_ID
			  
			  -- [E20251028-000588] FCS 제외공정 반영관련 기존 로직 주석처리
			  --,dbo.FN_GET_SCM_SITE_ID_PLANT(MP.VL_PLANT_ID, 'A')	AS SCM_SITE_ID
			  -- [E20251028-000588] FCS 제외공정 반영관련 추가로직 시작
			  , CASE 
					WHEN FCS_EXCEPTION_OPERATION.OPERATION_ID IS NULL THEN dbo.FN_GET_SCM_SITE_ID_PLANT(MP.VL_PLANT_ID, 'A')
					ELSE NULL 
				END AS SCM_SITE_ID
			   -- [E20251028-000588] FCS 제외공정 반영관련 추가로직 끝
			  ,MP.VL_SITE_ID										AS SITE_ID
			  ,MP.VL_PLANT_ID										AS PLANT_ID
			  ,MP.VL_FACTORY_ID										AS FACTORY_ID
			  ,sa.route_id
			  ,MP.VL_LINE_ID										AS LINE_ID
			  ,DATEADD(DAY,-1,sa.cutoff_date) cutoff_date
			  ,sa.seq
			  -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 주석처리
			  --,[dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, RTRIM(LTRIM(ISNULL(EA.CELL_ASSY_ITEM_ID,sa.item_id)))) item_id --2018.06.29
			  -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 개선로직
			  , ISNULL(NULLIF(fi.packer_plan_item_id, ''), RTRIM(LTRIM(ISNULL(EA.CELL_ASSY_ITEM_ID,sa.item_id))))  as item_id
			   -- 2025.09.15 kimcd PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산. 품목을 CELL ASSY ITEM 우선
			  ,RTRIM(LTRIM(sa.item_id)) origin_item_id --2018.06.29
			  ,sa.production_type
			  ,sa.fcs_input_date

			  -- 20200408 가용일자 로직 변경  : MAX(AVAILABLE_DATE, UNHOLD_EXP_DATE) 로 변경
              ,CASE WHEN ISNULL(sa.aging_available_date, '1999-01-01') >= ISNULL(sa.unhold_exp_date, '1999-01-01') THEN sa.aging_available_date
                    ELSE sa.unhold_exp_date
               END available_date  
			  --,sa.aging_available_date AS available_date  -- 20181030 컬럼 변경 sa.available_date

			  ,sa.remain_lead_time
			  ,sa.holding_date
			  ,sa.input_qty
			  ,sa.qty
			  ,sa.qty_uom
			  ,sa.stock_status
			  ,sa.operation_id
			  ,sa.operation_seq
			  ,sa.op_start_time
			  ,sa.tray_op_status
			  ,sa.stock_type
			  -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 주석처리
			  --,[dbo].[FN_SCM_SYS_NVL](sa.wiphold_yn, 'N') wiphold_yn -- 2018. 5. 11  Kim Jihye
			  -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 개선로직
			  , ISNULL(NULLIF(sa.wiphold_yn, ''), 'N')  as wiphold_yn
			  ,sa.unhold_exp_date  -- 20181030 컬럼 추가
			  ,sa.special_yn  -- 20181030 컬럼 추가
			  ,sa.lot_id  -- 20181030 컬럼 추가
			  ,sa.ocv2_end_time  -- 20181030 컬럼 추가
			  ,sa.ship_available_date -- 2018. 6. 28
			  ,sa.before_degas  -- 20181030 컬럼 추가
			  ,sa.degas_end_date  -- 20181030 컬럼 추가
			  ,sa.insert_id
			  ,sa.insert_time
			  ,sa.update_id
			  ,sa.update_time
			  ,fi.operation_group  -- 20190130 컬럼 추가
			  ,fi.nick_name        -- 20190130 컬럼 추가
			  ,sa.aging_available_date 
		FROM  SCM_DNM_STOCK_AGING_V_SN sa WITH(NOLOCK) -- 20181030 교체 SCM_DNM_STOCK_AGING_SN sa WITH(NOLOCK)
		      LEFT JOIN EXC_ASSY  EA -- 2025.09.15 kimcd PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산. SCP 제외 대상 품목 -> Cell Assy로 전환 전환 JOIN
	              ON   SA.COMPANY_ID  = EA.COMPANY_ID
		          AND  SA.DIVISION_ID = EA.DIVISION_ID
				  AND  SA.SITE_ID     = EA.SITE_ID
				  AND  SA.PLANT_ID    = EA.PLANT_ID
				  AND  RTRIM(LTRIM(SA.ITEM_ID)) = EA.SCP_EXC_ITEM_ID
		      LEFT JOIN scp_mst_final_item fi --2018.06.29
	              ON   SA.DIVISION_ID = FI.DIVISION_ID
	              AND  RTRIM(LTRIM(ISNULL(EA.CELL_ASSY_ITEM_ID,sa.item_id))) = fi.item_id   -- 2025.09.15 kimcd PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산. 품목을 CELL ASSY ITEM 우선
			  INNER JOIN FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP() MP -- JV Real Line / ESS Virtual Line 매핑 정보 반환 함수 
					  ON MP.RL_COMPANY_ID	= SA.COMPANY_ID
					 AND MP.RL_DIVISION_ID	= SA.DIVISION_ID
					 AND MP.RL_SITE_ID		= SA.SITE_ID
					 AND MP.RL_PLANT_ID		= SA.PLANT_ID
					 AND MP.RL_FACTORY_ID	= SA.FACTORY_ID
					 AND MP.RL_LINE_ID		= SA.LINE_ID
			  INNER JOIN SCM_MST_ITEM_SN VI WITH(NOLOCK)
					  -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 주석처리
					  -- ON VI.ITEM_ID				= [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, RTRIM(LTRIM(ISNULL(EA.CELL_ASSY_ITEM_ID, sa.item_id))))
					  -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 개선로직
					  ON VI.ITEM_ID				= ISNULL(NULLIF(fi.packer_plan_item_id, ''), RTRIM(LTRIM(ISNULL(EA.CELL_ASSY_ITEM_ID, sa.item_id))))
					 AND VI.COMPANY_ID			= MP.VL_COMPANY_ID
					 AND VI.DIVISION_ID			= MP.VL_DIVISION_ID
					 AND VI.SITE_ID				= MP.VL_SITE_ID
					 AND VI.SCP_OPERATION_GROUP = 'A'	-- Cell(조립)
			  -- 2025.12.12 CSR[E20251028-000588]  YMH 소형 MAF489266C10 PLANT내 재고 중복 CASE 
		      -- MES F7200 / FCS E11 공정의 중복제거를 위해 FCS 제외공정룩업을 통해 E11제외처리
			  LEFT OUTER JOIN 
			  (
					SELECT 
						SEGMENT1 AS OPERATION_ID
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL AS LMD WITH(NOLOCK)
					WHERE	LMD.LOOKUP_TYPE	= 'FCS_INVENTORY_EXCEPTION_OPERATION'
					AND		LMD.VALID_YN = 'Y'
					GROUP BY SEGMENT1 	
			  ) AS FCS_EXCEPTION_OPERATION
			  ON sa.OPERATION_ID = FCS_EXCEPTION_OPERATION.OPERATION_ID
		-----------------------------------------------------------------------------------------------------
		--//## END -   [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 line 재고 정보 추가 
		-----------------------------------------------------------------------------------------------------
       ) A
