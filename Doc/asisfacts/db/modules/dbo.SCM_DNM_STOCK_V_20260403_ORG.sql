





CREATE VIEW [dbo].[SCM_DNM_STOCK_V_20260403_ORG] AS   
/*
 * Program ID   : SCM_DNM_STOCK_V
 * Description  : 재고 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.08   Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022.12.22 과거 이력 정리
 * 2018.08.10   Kim Jihye      외주 Packer Site 재고 로직 변경 (scm_mst_osp_sloc 에서 Packer Storage 관리)
 * 2020.09.09   KSG            C20200909-000178 [SCM PI팀 MES WIP 재고를 수신해서 FP에서 관리하는 공정, 계획 Point 기준으로 정보 변경 요청
 *                                'WIP' Type의 Item ID/Operation ID/qty 항목을 fp_apply 항목으로 변경
 *                                 item_id      => fp_apply_item_id
 *                                 qty2         => fp_apply_wipqty
 *                                 operation_id => fp_apply_operation_id
 * 2021.10.25   ksg            PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 : MEB
 *                             --> 2021.12.13 PI 요청으로 원복함
 * 2022.03.17   hrkim          PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : 자동차 사업부 VMI사이트도 재고 사용
 * 2022.04.25   KSG            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division 추가
 * 2022.07.29   KSG            PJ20216894 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase2 : WIP_SSP 제외(WIP 사용)
 * 2022.09.02   KSG            PJ20216894 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase2 : 'SSP_AS_DIV_SLOC'에 속한 Storage 는 'OWMS'재고에서 제외
 * 2022.12.01   KSG            PJ20216894 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase2 : stock_type = 'LOT_CONTROL' 추가
 * 2022.12.22   KSG            PJ20216894 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase2 : ERP의 Restricted 재고를 defect_qty 에 추가 적용
 * 2023.02.24   KSG            E20230223-000217 ERP 고객위탁재고 (Stock type : VMI) 데이터 SCM_SITE_ID 맵핑 Logic 개선 요청 건 : 자동차/ESS 고객위탁재고 (Stock type : VMI)의 SCM_SITE_ID 도 Lookup 상관없이 Mapping된 그대로 반영
 * 2023.03.28   KSG            E20230327-000187 [SCM물류PI팀] 재고 테이블 SCM_DNM_STOCK 개선 (GSCM 시스템의 재고 정합성 개선을 위한) : 재고 이전/특별 재고 관련 컬럼 추가
 * 2023.04.04   KSG            E20230327-000191 [SCM/물류PI팀] ERP 저장위치 반영시 가용/비가용 구분 적용 기능 추가 요청 (재고 정합성 개선을 위한)
 *                              'INVENTORY' 재고 중 CELL_INV_HOLD Location 인 경우 전부 HOLD 로 처리, 최종 cutoff_date 다음 일자에 가용으로 처리
 * 2023.04.04	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2024.04.01	KSG			   E20240325-000326 SSP → SCP oWMS stock 집계 시 보류재고 반영 : 'OWMS' 보류 재고 변경
 * 2024.06.10   KSG            PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : Stock OSP - 원산지 구분자 추가
 * 2024.06.29   vadabi3        NERP - 특정 PLANT, STORAGE 별도 처리 개선
------------------------------------------------------------------------------------------------------------------------
							-- 2024.06.29 Vadabi5 Storage 별 일반 재고 (ERP) : AS Plant 제외
							-- PLANT = G481
							SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WHERE LOOKUP_TYPE_CODE = 'SCM_DNM_STOCK_V' AND SEGMENT1 = 'PLANT'

							-- STORAGE = 510E
							SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WHERE LOOKUP_TYPE_CODE = 'SCM_DNM_STOCK_V' AND SEGMENT1 = 'SLOC'

							-- MODEL =  AMVCCCMAE-A1-D01
							SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WHERE LOOKUP_TYPE_CODE = 'SCM_DNM_STOCK_V' AND SEGMENT1 = 'MODEL'
 * 2025.01.14   kimcd          Z799 강제 설정. 임시 사용으로 2025년 1Q 내 소진 예상
 * 2025.09.01   hrkim		   PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
 *								- SCP Exclude Class 품목을 Cell Assy로 변환 조회
 * 2025.10.24	YMH			E20251021-000664 계획수립 주초재고 VMI 재고 설정 문의/누락 방지관련 Storage 별 일반 재고 (ERP) Company 관계 없이 반영하도록 로직 수정
 * 2025.11.04	hrkim		[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 
 *								: FP 활성화 재고를 JV에서 ESS로 동기화. ESS 하위 조립품만 추출하여 동기화
 *								-- 2025.12.23 가상 plant division '82' 조건 삭제 
 *===================================================================================================
 */

-- PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 조회 -- START 
WITH SCP_EXC_ITEM_ASSY_MAP AS (
	SELECT COMPANY_ID
	      ,DIVISION_ID
		  ,SITE_ID
		  ,PLANT_ID
		  ,SCP_EXC_ITEM_ID
		  ,CELL_ASSY_ITEM_ID
	 FROM DBO.FN_GET_SCP_EXC_ITEM_ASSY_MAP (NULL)
	WHERE 1=1 
)
-- PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 조회 -- END 
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--##### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : FP 재고를 JV에서 ESS로 동기화. 하위 반제품도 ESS에 포함된 품목만 추출하여 재고 정보 형성
------------------------------------------------------------------------------------------------------------------------------------------------------------------
, JV_REAL_ESS_VIRTUAL_SITE_MAP AS (
	SELECT MP.VP_COMPANY_ID
		  ,MP.VP_DIVISION_ID
		  ,MP.VP_SITE_ID
		  ,MP.VP_PLANT_ID
		  ,MP.VP_SCM_SITE_ID
		  ,MP.RP_COMPANY_ID
		  ,MP.RP_DIVISION_ID
		  ,MP.RP_SITE_ID
		  ,MP.RP_PLANT_ID
		  ,MP.RP_SCM_SITE_ID 
	 FROM FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP() MP
)
, JV_REAL_ESS_VIRTUAL_LINE_MAP AS (
	SELECT MP.VL_COMPANY_ID
		  ,MP.VL_DIVISION_ID
		  ,MP.VL_SITE_ID
		  ,MP.VL_PLANT_ID
		  ,MP.VL_FACTORY_ID
		  ,MP.VL_LINE_ID
		  ,MP.RL_COMPANY_ID
		  ,MP.RL_DIVISION_ID
		  ,MP.RL_SITE_ID
		  ,MP.RL_PLANT_ID
		  ,MP.RL_FACTORY_ID
		  ,MP.RL_LINE_ID
	 FROM FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP() MP
)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--##### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : FP 재고를 JV에서 ESS로 동기화. 하위 반제품도 ESS에 포함된 품목만 추출하여 재고 정보 형성
------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT   
        -- 20200406 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 : Hold 재고
        --   MES, QMS Hold = 'Y' 인데, MES/QMS Hold 예상해제일이 없는 대상은 가용 재고에서 제외 함 : 내부에서 available_date 설정함
		-- 20200521 C20200520-000161 : available_date 상관없이 Site 처리함
		 STOCK.scm_site_id             AS scm_site_id
		,CASE WHEN ISNULL(STOCK.company_id, '') = '' THEN '*' ELSE STOCK.company_id END AS company_id
		,STOCK.division_id
		,CASE WHEN ISNULL(STOCK.site_id, '')    = '' THEN '*' ELSE STOCK.site_id    END AS site_id
		,CASE WHEN ISNULL(STOCK.plant_id, '')   = '' THEN '*' ELSE STOCK.plant_id   END AS plant_id
		,CASE WHEN ISNULL(STOCK.factory_id, '') = '' THEN '*' ELSE STOCK.factory_id END AS factory_id
		,CASE WHEN ISNULL(STOCK.storage_id, '') = '' THEN '*' ELSE STOCK.storage_id END AS storage_id
		,DATEADD(DAY,-1,STOCK.cutoff_date) cutoff_date -- STOCK 내에서 전부 BOH 일자 기준으로 처리되어서 EOH 기준일자로 변경함
		,STOCK.seq
		,STOCK.stock_type

		-- 20181130 소형 대표 ITEM_ID 처리 조정
		-- PJ20257329 2025.09.01 변경전,STOCK.item_id
		,ISNULL(EX.CELL_ASSY_ITEM_ID, STOCK.item_id)	AS ITEM_ID -- PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 조회
		,STOCK.origin_item_id 
		
        -- 2018.03.08 우선순위 수정
		,ISNULL(STOCK.scm_qty, 0) + ISNULL(STOCK.moving_qty, 0) + ISNULL(STOCK.defect_qty, 0) AS scm_qty
		-- 2019.11.05 출하가능재고에서 moving_qty 제외 
		,ISNULL(STOCK.scm_qty, 0) AS ssp_qty 
		,STOCK.lane
		,STOCK.production_type
		
		-- 20200521 C20200520-000161 Hold인데 해제예상일이 없는 경우 Defalut 설정함
        --   자동차/ESS : M+24 에 가용재고로 인식 -> Plan 대상 구간 이후 일자로 처리 : Plan에는 사용 안 하나, Simulator의 BOH에는 표시
        --   소형 : M+6 에 가용재고로 인식 :현재 (당)월 + 6개월 에 해당하는 1일
        --          ex) 20200511 주차 : 11월 1일 / 20200525 주차 : 11월 1일 / 20200601 주차 : 12월 1일
		--,STOCK.available_date		
       ,CASE WHEN ISNULL(STOCK.wiphold_yn, 'N') = 'Y' AND ISNULL(STOCK.available_date, '') = '' AND  STOCK.division_id = '40'
                  --THEN DATEADD(MM, 6,  STOCK.cutoff_date-DAY(STOCK.cutoff_date)+1) 
                  THEN DATEADD(MM, 6, CONVERT(DATETIME, CONVERT(CHAR(6), STOCK.cutoff_date, 112)+'01')) 
             -- HM JV WHEN ISNULL(STOCK.wiphold_yn, 'N') = 'Y' AND ISNULL(STOCK.available_date, '') = '' AND  STOCK.division_id IN ('81', '82', '81_UC') -- 20220425 PJ20216891 : GM JV 가상 Division 추가
             WHEN ISNULL(STOCK.wiphold_yn, 'N') = 'Y' AND ISNULL(STOCK.available_date, '') = '' AND  DM.ATTRIBUTE3 IN ('81', '82')  -- HM JV 가상 사업부 추가 대응
                  --THEN DATEADD(MM, 24,  STOCK.cutoff_date-DAY(STOCK.cutoff_date)+1) 
                  THEN DATEADD(MM, 24, CONVERT(DATETIME, CONVERT(CHAR(6), STOCK.cutoff_date, 112)+'01')) 
             ELSE STOCK.available_date
        END available_date  

		,STOCK.remain_lead_time
		,STOCK.holding_date      -- MES Hold 작업일
		,STOCK.qty
		,STOCK.qty_uom
		,STOCK.stock_status
		,STOCK.operation_id
		,STOCK.line_id
		,STOCK.outsourcing_flag
		,STOCK.outsourcing_factory
		,STOCK.description
		,STOCK.fp_apply_operation_id
		,STOCK.fp_apply_item_id
		,STOCK.fp_apply_wipqty
		--,[dbo].[FN_SCM_SYS_NVL](STOCK.wiphold_yn, 'N') wiphold_yn -- 20180511  Kim Jihye
		--,[dbo].[FN_SCM_SYS_NVL](STOCK.qms_hold_yn, 'N') qms_hold_yn -- 20191030  추가 QMS Hold 여부 관리
        ,CASE WHEN ISNULL(STOCK.wiphold_yn, '') = '' THEN 'N'
              ELSE STOCK.wiphold_yn
         END wiphold_yn 
        ,CASE WHEN ISNULL(STOCK.qms_hold_yn, '') = '' THEN 'N'
              ELSE STOCK.qms_hold_yn
         END qms_hold_yn 
		,STOCK.wip_type_code
		,STOCK.qty2
		,STOCK.modify_fp_apply_wipqty
		,STOCK.modify_description
		,STOCK.cal_qty
		,STOCK.formation_rework_type
		,STOCK.insert_id
		,STOCK.insert_time
		,STOCK.update_id
		,STOCK.update_time
		,STOCK.location
		,STOCK.moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
		,STOCK.capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
		,STOCK.vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
		,STOCK.rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
		,STOCK.defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가 -- 20221222 defect_qty = defect_qty + restrict_qty
		,STOCK.unhold_exp_date -- 20191120 추가 MES Hold 해제 예정일
		,STOCK.mes_map_sloc    -- 20191120 추가 MES에 연계된 ERP 창고
		
		,STOCK.mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
		,STOCK.mes_unhold_date     -- 20200413 MES hold 실제 해제일
		,STOCK.qms_hold_date       -- 20200413 QMS Hold 일
		,STOCK.qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
		,STOCK.qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
		,STOCK.operation_id_org    -- 20210423 C20210422-000470 추가
		,STOCK.location_code       -- 20210618 C20210617-000105 : location_code 정보 추가
        -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		,STOCK.mes_item_id
		,STOCK.mes_operation_id
		,STOCK.from_sloc_id
		,STOCK.customer_id
		,STOCK.special_stock_indicator
		
FROM   ( ------------------------------
         -- 외주 Packer 재고
		 ------------------------------
         SELECT 
		        -- [CSR ID : 3972930] ESS 외주 Packer 재고 업로드 기능 추가건		 
		        CASE WHEN dss.division_id = '82' THEN NULL                       -- ESS(82) 사업부 'SUPPLY' 재고 사용 안 함
		             WHEN dss.division_id = '40' THEN NULL                       -- 소형(40) 사업부 'SUPPLY' 재고 사용 안 함
		             ELSE [dbo].[FN_SCM_SYS_NVL](ip.scm_site_id, ms.scm_site_id) -- 2018.08.16 TCO Cell 로직 반영
				END scm_site_id
		       ,qty2 AS scm_qty
               ,dss.company_id
			   ,dss.division_id
			   ,dss.site_id
			   ,dss.plant_id
			   ,dss.factory_id
			   ,dss.storage_id
			   ,dss.cutoff_date
			   ,dss.seq
			   ,dss.stock_type
	           -- 20181130 소형 대표 ITEM_ID 처리 조정
		       ,[dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id) AS item_id --2018.06.29
		       ,dss.item_id AS origin_item_id --2018.06.29
			   ,dss.lane
			   ,dss.production_type
			   -- 20200406 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 : Hold 재고
               --     MES, QMS Hold = 'Y' 인 경우, MAX (MES Hold 예상해제일, QMS Hold 예상해제일) 로 가용 일자 반영
			   ,CASE WHEN ISNULL(wiphold_yn, 'N') = 'N'                                                                                                THEN ISNULL(dss.available_date, DATEADD(DAY, -1, dss.cutoff_date))
                     WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '') = '' AND ISNULL(dss.qms_unhold_exp_date, '') = ''          THEN NULL
                     WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '1999-01-01') >= ISNULL(dss.qms_unhold_exp_date, '1999-01-01') THEN dss.unhold_exp_date
                     WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '1999-01-01') <  ISNULL(dss.qms_unhold_exp_date, '1999-01-01') THEN dss.qms_unhold_exp_date
                     ELSE dss.available_date
                END available_date  

			   ,dss.remain_lead_time
			   ,dss.holding_date
			   ,dss.qty
			   ,dss.qty_uom
			   ,dss.stock_status
			   ,dss.operation_id
			   ,dss.operation_id  AS operation_id_org  -- 20210423 C20210422-000470 추가
			   ,dss.line_id
			   ,dss.outsourcing_flag
			   ,dss.outsourcing_factory
			   ,dss.description
			   ,dss.fp_apply_operation_id
			   ,dss.fp_apply_item_id
			   ,dss.fp_apply_wipqty
			   ,dss.wiphold_yn
			   ,dss.qms_hold_yn   -- 20191030  추가
			   ,dss.wip_type_code
			   ,dss.qty2
			   ,dss.modify_fp_apply_wipqty
			   ,dss.modify_description
			   ,dss.cal_qty
			   ,dss.formation_rework_type
			   ,dss.insert_id
			   ,dss.insert_time
			   ,dss.update_id
			   ,dss.update_time
			   ,dss.location
			   ,dss.moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
			   ,dss.capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,dss.vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,dss.rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
               -- 20221222 ERP의 Restricted 재고를 defect_qty 에 추가 적용 : defect_qty = defect_qty + restrict_qty
			   ,ISNULL(dss.defect_qty, 0) + ISNULL(dss.restrict_qty, 0) AS defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
			   ,dss.unhold_exp_date -- 20191120 추가
			   ,dss.mes_map_sloc    -- 20191120 추가		
		       ,dss.mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
		       ,dss.mes_unhold_date     -- 20200413 MES hold 실제 해제일
		       ,dss.qms_hold_date       -- 20200413 QMS Hold 일
		       ,dss.qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
		       ,dss.qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
		       ,NULL AS location_code   -- 20210618 C20210617-000105 : location_code 정보 추가 : OSP 이므로 NULL 처리
               -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		       ,dss.mes_item_id
		       ,dss.mes_operation_id
		       ,dss.from_sloc_id
		       ,dss.customer_id
		       ,dss.special_stock_indicator
		 FROM   scm_dnm_stock_sn dss WITH(NOLOCK)

	     -- 20181130 소형 대표 ITEM_ID 처리 조정
         LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
         ON   dss.division_id = fi.division_id
         AND  dss.item_id     = fi.item_id 

		 LEFT JOIN scm_mst_site ms   WITH(NOLOCK)
		 ON    /*dss.company_id		    = ms.company_id -- 2018.09.17, Packer 재고 Company 관계 없이 반영하도록 로직 수정
		 AND  */dss.division_id		    = ms.division_id
		 --AND    dss.site_id			    = ms.site_id -- 2018.09.17, Packer 재고 Company 관계 없이 반영하도록 로직 수정
		 AND    (dss.outsourcing_factory = ms.plant_id
		 OR     DBO.FN_SCM_SYS_NVL(ms.hq_vendor_code, '-') like CONCAT('%', dss.outsourcing_factory,'%'))  -- 2018.09.14 소형 Packer 본사 재고 반영, 2018.09.18
		 AND    ms.valid_yn = 'Y'

		 -- 2018.08.16 TCO Cell 로직 반영
		 LEFT JOIN (SELECT ms.company_id
		                  ,ip.division_id
						  ,ms.plant_id
						  ,ms.site_id
						  ,ms.scm_site_id
						  ,ip.item_id
						  ,ip.from_yyyymmdd
						  ,ip.to_yyyymmdd
					FROM   scm_mst_site ms WITH(NOLOCK)
					JOIN   scm_mst_site_item_priority ip WITH(NOLOCK)					
					ON     ms.division_id = ip.division_id
					AND    ms.scm_site_id = ip.plant_site_id
					WHERE  ms.osp_yn   = 'Y'
					AND    ms.valid_yn = 'Y'					
					AND    ip.valid_yn = 'Y') ip
		 ON     /*dss.company_id		    = ip.company_id
		 AND  */dss.division_id		    = ip.division_id
		 AND    dss.site_id			    = ip.site_id
		 AND    dss.outsourcing_factory = ip.plant_id		
	     -- 20181130 소형 대표 ITEM_ID 처리 조정 
		 AND    [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id) = ip.item_id
		 --AND    dss.item_id             = ip.item_id
		 AND    (dss.cutoff_date BETWEEN ip.from_yyyymmdd AND ip.to_yyyymmdd)

		 WHERE  dss.stock_type			= 'SUPPLY'

		 ------------------------------
		 -- Storage 별 일반 재고 (ERP) : AS Plant 제외
		 ------------------------------
		 UNION ALL
		 SELECT 
		        --[dbo].[FN_SCM_SYS_NVL]([dbo].[FN_SCM_SYS_NVL](site.SCM_SITE_ID, md.segment2), packer.scm_site_id) scm_site_id -- 2018. 05.21  Kim Jihye 외주 Packer 출하 Site 재고 반영			
			   -- 20210714 SCM PI 요청으로 특정 창고/Item 재고 처리 : 510E 삭제 시 아래 From 절에서에서 site 부분도 수정 필요
			   --                                                     Stock Type = 'OWMS' 에서 강제로 처리 중인 부분도 수정 필요
			   --    모델 : AMVCCCMAE-A1-D01 / Plant : G481 / SLOC : 510E
			   --    특별 재고 제외 : ISNULL(dss.special_stock_indicator, '') <> '' 
                CASE WHEN dss.company_id  = 'WA00' AND dss.storage_id = 'Z799' THEN N'Ford_US_RDF'  -- 2025-01-14 kimcd Z799 강제 설정. 임시 사용으로 2025년 1Q 내 소진 예상
				     WHEN ISNULL(dss.special_stock_indicator, '') <> '' THEN NULL  -- 특별재고는 SCP에서 사용 안함
                     WHEN dss.plant_id = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','PLANT')
					  AND dss.storage_id = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','SLOC')
					  AND [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id) 
					    = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','MODEL')
				     THEN [dbo].[FN_SCM_SYS_NVL]([dbo].[FN_SCM_SYS_NVL](site.SCM_SITE_ID, md.segment2), packer.scm_site_id)
                     WHEN dss.plant_id = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','PLANT')
					  AND dss.storage_id = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','SLOC')
					  AND [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id) 
					   <> DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','MODEL')
					 THEN NULL
                     ELSE [dbo].[FN_SCM_SYS_NVL]([dbo].[FN_SCM_SYS_NVL](site.SCM_SITE_ID, md.segment2), packer.scm_site_id)  -- 2018. 05.21  Kim Jihye 외주 Packer 출하 Site 재고 반영
                      END scm_site_id 
		       ,qty2 AS scm_qty
		       ,dss.company_id
               ,dss.division_id
			   ,dss.site_id
			   ,dss.plant_id
			   ,dss.factory_id
			   ,dss.storage_id
			   ,dss.cutoff_date
			   ,dss.seq
               ,CASE WHEN ISNULL(dss.special_stock_indicator, '') <> '' THEN dss.stock_type + '_' + dss.special_stock_indicator -- 특별재고
                     ELSE dss.stock_type
                END stock_type 
			   --,dss.stock_type
	           -- 20181130 소형 대표 ITEM_ID 처리 조정
		       ,[dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id) AS item_id --2018.06.29
		       ,dss.item_id AS origin_item_id --2018.06.29
			   ,dss.lane
			   ,dss.production_type
			   -- 20200406 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 : Hold 재고
               --     MES, QMS Hold = 'Y' 인 경우, MAX (MES Hold 예상해제일, QMS Hold 예상해제일) 로 가용 일자 반영
			   -- 20230405 E20230327-000191 'INVENTORY' 재고 중 CELL_INV_HOLD Location 인 경우 전부 HOLD 로 처리, 최종 cutoff_date 다음 일자에 가용으로 처리
			   --                        상단에서 Cutoff_date는 (-1)일 처리하므로 available_date는 Cutoff_date 로 처리
			   --,CASE WHEN ISNULL(wiphold_yn, 'N') = 'N'                                                                                                THEN ISNULL(dss.available_date, DATEADD(DAY, -1, dss.cutoff_date))
			   ,CASE WHEN ISNULL(site.location_code, '') = 'CELL_INV_HOLD'                                                                             THEN dss.cutoff_date
			         WHEN ISNULL(wiphold_yn, 'N') = 'N'                                                                                                THEN ISNULL(dss.available_date, DATEADD(DAY, -1, dss.cutoff_date))
                     WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '') = '' AND ISNULL(dss.qms_unhold_exp_date, '') = ''          THEN NULL
                     WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '1999-01-01') >= ISNULL(dss.qms_unhold_exp_date, '1999-01-01') THEN dss.unhold_exp_date
                     WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '1999-01-01') <  ISNULL(dss.qms_unhold_exp_date, '1999-01-01') THEN dss.qms_unhold_exp_date
                     ELSE dss.available_date
                END available_date  

			   ,dss.remain_lead_time
			   ,dss.holding_date
			   ,dss.qty
			   ,dss.qty_uom
			   ,dss.stock_status
			   ,dss.operation_id
			   ,dss.operation_id  AS operation_id_org  -- 20210423 C20210422-000470 추가
			   ,dss.line_id
			   ,dss.outsourcing_flag
			   ,dss.outsourcing_factory
			   ,dss.description
			   ,dss.fp_apply_operation_id
			   ,dss.fp_apply_item_id
			   ,dss.fp_apply_wipqty
			   -- 20230405 E20230327-000191 'INVENTORY' 재고 중 CELL_INV_HOLD Location 인 경우 전부 HOLD 로 처리, 최종 cutoff_date 다음 일자에 가용으로 처리
			   ,CASE WHEN ISNULL(site.location_code, '') = 'CELL_INV_HOLD'  THEN 'Y'
                     ELSE dss.wiphold_yn
                END wiphold_yn
			   --,dss.wiphold_yn
			   ,dss.qms_hold_yn   -- 20191030  추가
			   ,dss.wip_type_code
			   ,dss.qty2
			   ,dss.modify_fp_apply_wipqty
			   ,dss.modify_description
			   ,dss.cal_qty
			   ,dss.formation_rework_type
			   ,dss.insert_id
			   ,dss.insert_time
			   ,dss.update_id
			   ,dss.update_time
			   ,dss.location
			   ,dss.moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
			   ,dss.capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,dss.vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,dss.rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
               -- 20221222 ERP의 Restricted 재고를 defect_qty 에 추가 적용 : defect_qty = defect_qty + restrict_qty
			   ,ISNULL(dss.defect_qty, 0) + ISNULL(dss.restrict_qty, 0) AS defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
			   ,dss.unhold_exp_date -- 20191120 추가
			   ,dss.mes_map_sloc    -- 20191120 추가
		       ,dss.mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
		       ,dss.mes_unhold_date     -- 20200413 MES hold 실제 해제일
		       ,dss.qms_hold_date       -- 20200413 QMS Hold 일
		       ,dss.qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
		       ,dss.qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
			   -- 20210618 C20210617-000105 : location_code 정보 추가 : scm_site_id와 연계
		       ,[dbo].[FN_SCM_SYS_NVL](site.location_code, NULL) AS location_code 
               -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		       ,dss.mes_item_id
		       ,dss.mes_operation_id
		       ,dss.from_sloc_id
		       ,dss.customer_id
		       ,dss.special_stock_indicator
		 FROM   scm_dnm_stock_sn dss WITH(NOLOCK)

	     -- 20181130 소형 대표 ITEM_ID 처리 조정
         LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
         ON   dss.division_id = fi.division_id
         AND  dss.item_id     = fi.item_id 

		 LEFT JOIN (SELECT DISTINCT ms.company_id
						  ,ms.division_id
						  ,ms.site_id
						  ,ml.factory_id
						  ,ml.plant_id
						  ,ml.storage_id
						  ,ms.scm_site_id
						  ,ml.location_code -- 20210611  PJ20209642 추가
						  ,CASE ml.location_code WHEN 'CELL_OWMS' THEN 'A'
						                         WHEN 'PACK_OWMS' THEN 'P'
												 ELSE '%' END operation_group -- 2018.10.01
				    FROM   scm_mst_site ms WITH(NOLOCK)
				    JOIN   scm_mst_location ml WITH(NOLOCK)
				    ON     ms.division_id = ml.division_id
				    AND    ms.scm_site_id = ml.scm_site_id
				    WHERE  ms.valid_yn    = 'Y'
				    AND    ml.valid_yn    = 'Y'
				    AND    ISNULL(ml.storage_id, '') <> '' -- 20210611  PJ20209642 추가
					-- 20210128 PJ20209642 'INVENTORY' 에서 PACK_OWMS/CELL_OWMS Location에 해당하는 정보는 Site Mapping에서 제외
					-- 20210714 SCM PI 요청으로 특정 창고/Item 재고 처리 : 510E 삭제 시 위에서 Scm_site_id 부분도 수정 필요
					--    모델 : AMVCCCMAE-A1-D01 / Plant : G481 / SLOC : 510E
					--AND    ml.location_code NOT IN ('CELL_OWMS', 'PACK_OWMS')
					-- 20240629 Plant : G481 / SLOC : 510E
					AND   (ml.location_code NOT IN ('CELL_OWMS', 'PACK_OWMS')
                           OR (    ml.plant_id   = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','PLANT')
						       AND ml.storage_id = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','SLOC')
							  )
                          )
					AND    ms.vmi_yn = CASE ms.division_id WHEN '40' THEN 'N' -- 2018.09.10
														   -- PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : 자동차 사업부 VMI사이트도 재고 사용
					                                       -- WHEN '81' THEN 'N' -- 2018.10.05
														   ELSE ms.vmi_yn 
														   END 
					) site
		 -- 20251024 YMH E20251021-000664 계획수립 주초재고 VMI 재고 설정 문의/누락 방지 관련 Company 관계 없이 반영하도록 로직 수정
		 ON     1 = 1 --dss.company_id	= [dbo].[FN_SCM_SYS_NVL](site.company_id, dss.company_id) -- 2018. 04.27  Kim Jihye
		 AND    dss.division_id = site.division_id
		 AND    dss.site_id		= [dbo].[FN_SCM_SYS_NVL](site.site_id, dss.site_id) -- 2018. 04.27  Kim Jihye
		 AND    dss.plant_id	= site.plant_id 
		 AND    dss.storage_id	= site.storage_id		 
	     -- 20181130 소형 대표 ITEM_ID 처리 조정
		 AND    dbo.fn_get_item_operation_group(dss.division_id, [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id)) LIKE site.operation_group -- 2018.10.01
		 -- 20210611 PJ20209642 'PANCAKE_INV' Location에 존재하는 Cell Item 재고는 제외함
		 AND    'Y' = CASE WHEN site.location_code = 'PANCAKE_INV' AND fi.operation_group = 'A' THEN 'N'
                           ELSE 'Y'
                      END 

		 LEFT JOIN scm_adm_lookup_master_detail md WITH(NOLOCK) -- 2018. 04.10  Kim Jihye
		 ON     dss.plant_id    = md.segment1
		 AND    dss.storage_id  = md.segment3
		 AND    dbo.fn_get_item_operation_group(dss.division_id, dss.item_id) = 'E'
		 AND    md.lookup_type  = 'ELECTRODE_SHIP_SITE'
		 AND    md.valid_yn     = 'Y'  

		 -- 2018.05.21  Kim Jihye 외주 Packer 출하 Site 재고 반영
		 -- 2018.08.10  Kim Jihye 외주 Packer Site 재고 로직 변경
		 LEFT JOIN (SELECT ip.division_id
						  ,os.plant_id
						  ,os.scm_site_id
						  ,os.storage_id
						  ,ip.item_id
						  ,ip.from_yyyymmdd
						  ,ip.to_yyyymmdd
					FROM   scm_mst_osp_sloc os WITH(NOLOCK)
					JOIN   scm_mst_site_item_priority ip WITH(NOLOCK)					
					ON     os.division_id = ip.division_id
					AND    os.scm_site_id = ip.plant_site_id
					WHERE  os.valid_yn = 'Y'					
					AND    ip.valid_yn = 'Y'
				  ) packer
		 ON     dss.division_id = packer.division_id
		 AND    dss.plant_id    = packer.plant_id
		 AND    dss.storage_id  = packer.storage_id		
	     -- 20181130 소형 대표 ITEM_ID 처리 조정 
		 AND    [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id) = packer.item_id
		 AND    (dss.cutoff_date BETWEEN packer.from_yyyymmdd AND packer.to_yyyymmdd)

		 WHERE  dss.stock_type	= 'INVENTORY'
		 -- 20210526 C20210520-000207 Non AS Plant Division ID
		 AND    dss.plant_id  NOT IN (SELECT DISTINCT plant_id
                                      FROM   scm_mst_plant_sn WITH(NOLOCK)
                                      WHERE  ISNULL(plant_type, 'Z') = 'SVC'
		                             )
		 
		 ------------------------------
		 -- Storage 별 일반 재고 (ERP) : AS Plant 
		 ------------------------------
		 UNION ALL
		 SELECT --site.SCM_SITE_ID AS scm_site_id
			   --    특별 재고 제외 : ISNULL(dss.special_stock_indicator, '') <> '' 
                CASE WHEN ISNULL(dss.special_stock_indicator, '') <> '' THEN NULL  -- 특별재고는 SCP에서 사용 안함
                     ELSE site.SCM_SITE_ID
                END scm_site_id 
		       ,qty2 AS scm_qty
		       ,dss.company_id
               -- 20210526 C20210520-000207 AS Plant Division ID
			   --,dss.division_id
			   ,ISNULL(foi.division_id, dss.division_id)  AS division_id

			   ,dss.site_id
			   ,dss.plant_id
			   ,dss.factory_id
			   ,dss.storage_id
			   ,dss.cutoff_date
			   ,dss.seq
               ,CASE WHEN ISNULL(dss.special_stock_indicator, '') <> '' THEN dss.stock_type + '_' + dss.special_stock_indicator -- 특별재고
                     ELSE dss.stock_type
                END stock_type 
			   --,dss.stock_type
	           -- 20181130 소형 대표 ITEM_ID 처리 조정
		       ,[dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id) AS item_id --2018.06.29
		       ,dss.item_id AS origin_item_id --2018.06.29
			   ,dss.lane
			   ,dss.production_type
			   -- 20200406 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 : Hold 재고
               --     MES, QMS Hold = 'Y' 인 경우, MAX (MES Hold 예상해제일, QMS Hold 예상해제일) 로 가용 일자 반영
			   ,CASE WHEN ISNULL(wiphold_yn, 'N') = 'N'                                                                                                THEN ISNULL(dss.available_date, DATEADD(DAY, -1, dss.cutoff_date))
                     WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '') = '' AND ISNULL(dss.qms_unhold_exp_date, '') = ''          THEN NULL
                     WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '1999-01-01') >= ISNULL(dss.qms_unhold_exp_date, '1999-01-01') THEN dss.unhold_exp_date
                     WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '1999-01-01') <  ISNULL(dss.qms_unhold_exp_date, '1999-01-01') THEN dss.qms_unhold_exp_date
                     ELSE dss.available_date
                END available_date  

			   ,dss.remain_lead_time
			   ,dss.holding_date
			   ,dss.qty
			   ,dss.qty_uom
			   ,dss.stock_status
			   ,dss.operation_id
			   ,dss.operation_id  AS operation_id_org  -- 20210423 C20210422-000470 추가
			   ,dss.line_id
			   ,dss.outsourcing_flag
			   ,dss.outsourcing_factory
			   ,dss.description
			   ,dss.fp_apply_operation_id
			   ,dss.fp_apply_item_id
			   ,dss.fp_apply_wipqty
			   ,dss.wiphold_yn
			   ,dss.qms_hold_yn   -- 20191030  추가
			   ,dss.wip_type_code
			   ,dss.qty2
			   ,dss.modify_fp_apply_wipqty
			   ,dss.modify_description
			   ,dss.cal_qty
			   ,dss.formation_rework_type
			   ,dss.insert_id
			   ,dss.insert_time
			   ,dss.update_id
			   ,dss.update_time
			   ,dss.location
			   ,dss.moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
			   ,dss.capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,dss.vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,dss.rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
               -- 20221222 ERP의 Restricted 재고를 defect_qty 에 추가 적용 : defect_qty = defect_qty + restrict_qty
			   ,ISNULL(dss.defect_qty, 0) + ISNULL(dss.restrict_qty, 0) AS defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
			   ,dss.unhold_exp_date -- 20191120 추가
			   ,dss.mes_map_sloc    -- 20191120 추가
		       ,dss.mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
		       ,dss.mes_unhold_date     -- 20200413 MES hold 실제 해제일
		       ,dss.qms_hold_date       -- 20200413 QMS Hold 일
		       ,dss.qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
		       ,dss.qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
		       ,NULL AS location_code   -- 20210618 C20210617-000105 : location_code 정보 추가  : AS 이므로 NULL 처리
               -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		       ,dss.mes_item_id
		       ,dss.mes_operation_id
		       ,dss.from_sloc_id
		       ,dss.customer_id
		       ,dss.special_stock_indicator
		 FROM   scm_dnm_stock_sn dss WITH(NOLOCK)

		 LEFT JOIN SCM_MST_FINAL_ITEM_ORIGIN_DIV_V foi WITH(NOLOCK)
         ON   dss.item_id     = foi.item_id 

	     -- 20181130 소형 대표 ITEM_ID 처리 조정
         LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
         ON   dss.division_id = fi.division_id
         AND  dss.item_id     = fi.item_id 

		 LEFT JOIN (
                    SELECT segment1 AS division_id
                         , segment2 AS scm_site_id
                         , segment3 AS plant_id
                         , segment4 AS storage_id
                    FROM   scm_adm_lookup_master_detail md WITH(NOLOCK) -- 2018. 04.10  Kim Jihye
                    WHERE  md.lookup_type = 'SSP_AS_DIV_SLOC'
                    AND    md.valid_yn    = 'Y'  
					) site
		 ON     foi.division_id = site.division_id
		 AND    dss.plant_id	= site.plant_id 
		 AND    dss.storage_id	= site.storage_id

		 WHERE  dss.stock_type	= 'INVENTORY'
		 -- 20210526 C20210520-000207 AS Plant Division ID
		 AND    dss.plant_id   IN (SELECT DISTINCT plant_id
                                   FROM   scm_mst_plant_sn WITH(NOLOCK)
                                   WHERE  ISNULL(plant_type, 'Z') = 'SVC'
		                          )
		 
		 ------------------------------
		 -- WIP 재고 (MES)
		 ------------------------------
		 UNION ALL
	     -- 20181130 소형 대표 ITEM_ID 처리 조정
		 SELECT 
		        -- 2018.10.11 공장간 이동중 재고 반영
		        -- 20200406 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 : Hold 재고
		        --   WIP 재고 : Lookup에 등록되지 않은 Operation_ID + (Lookup에 등록된 Operation_ID / plant_id / factory_id / mes_map_sloc)
			    -- 20200909 C20200909-000178 stock_type= 'WIP' 인 경우 fp apply 정보로 변경
                --CASE WHEN dss.stock_status = 'MOVING' AND dbo.fn_get_item_operation_group(dss.division_id, [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id)) = 'E'
                -- 20210712 PJ20209643 : 'WIP' 재고 에서 81/82의 B1000 재고 제외  / 40 : location_code = 'FORMATION_CHECK_PACKAGING' 제외
				--     20220725 => WIP_SSP 제외 : 20210712 PJ20209643 제외 건 다시 추가
                CASE WHEN dss.stock_status = 'MOVING' AND dbo.fn_get_item_operation_group(dss.division_id, [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.fp_apply_item_id)) = 'E'
                          THEN ms.scm_site_id
                     WHEN dss.division_id IN ('40') AND sl.scm_site_id IS NOT NULL AND sl.location_code = 'CELL_OWMS'
                          THEN NULL
                     WHEN sl.scm_site_id IS NOT NULL -- 20210128 PJ20209642 mes_map_sloc 컬럼의 정보를 사용하여 PACK_OWMS/CELL_OWMS Location 정보와 비교하여 Scm Site ID Mapping
                          THEN sl.scm_site_id
                     WHEN md2.segment2 IS NULL    -- Lookup에 등록되지 않은 Operation : 일반적인 경우
                          THEN site.scm_site_id
                     WHEN md.segment2 IS NOT NULL -- Lookup에 등록된 Operation / mes_map_sloc
                          THEN site.scm_site_id
					 ELSE NULL                    -- Lookup에 등록된 Operation / 등록되지 않은 mes_map_sloc : 재고로 잡지 않음
                END  scm_site_id 
           /* -- WIP_SSP 적용시 
                CASE WHEN dss.stock_status = 'MOVING' AND dbo.fn_get_item_operation_group(dss.division_id, [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.fp_apply_item_id)) = 'E'
                          THEN ms.scm_site_id
                     WHEN dss.division_id IN ('81', '82', '81_UC') AND dss.fp_apply_operation_id = 'B1000' -- 20220425 PJ20216891 : GM JV 가상 Division 추가
                          THEN NULL
                     WHEN dss.division_id IN ('40') AND sl.scm_site_id IS NOT NULL AND sl.location_code = 'CELL_OWMS'
                          THEN NULL
                     WHEN dss.division_id IN ('40') AND md2.segment2 IS NULL       AND site.location_code = 'FORMATION_CHECK_PACKAGING'
                          THEN NULL
                     WHEN dss.division_id IN ('40') AND md.segment2 IS NOT NULL    AND site.location_code = 'FORMATION_CHECK_PACKAGING'
                          THEN NULL
                     WHEN sl.scm_site_id IS NOT NULL -- 20210128 PJ20209642 mes_map_sloc 컬럼의 정보를 사용하여 PACK_OWMS/CELL_OWMS Location 정보와 비교하여 Scm Site ID Mapping
                          THEN sl.scm_site_id
                     WHEN md2.segment2 IS NULL    -- Lookup에 등록되지 않은 Operation : 일반적인 경우
                          THEN site.scm_site_id
                     WHEN md.segment2 IS NOT NULL -- Lookup에 등록된 Operation / mes_map_sloc
                          THEN site.scm_site_id
					 ELSE NULL                    -- Lookup에 등록된 Operation / 등록되지 않은 mes_map_sloc : 재고로 잡지 않음
                END  scm_site_id 
			*/

               -- 2020.02.03 scm_qty 를 전부 qty2 사용으로 변경
			   -- 20200909 C20200909-000178 stock_type= 'WIP' 인 경우 fp apply 정보로 변경 OLD) dss.qty2
		       ,dss.fp_apply_wipqty AS scm_qty

		       ,dss.company_id
			   ,dss.division_id
			   ,dss.site_id
			   ,dss.plant_id
			   ,dss.factory_id
			   ,dss.storage_id
			   ,dss.cutoff_date
			   ,dss.seq
			   ,dss.stock_type

	           -- 20181130 소형 대표 ITEM_ID 처리 조정
			   -- 20200909 C20200909-000178 stock_type= 'WIP' 인 경우 fp apply 정보로 변경 OLD) [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id) item_id --2018.06.29
		       ,[dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.fp_apply_item_id) AS item_id
			   -- 20200909 C20200909-000178 stock_type= 'WIP' 인 경우 fp apply 정보로 변경 OLD) dss.item_id AS origin_item_id
		       ,dss.fp_apply_item_id AS origin_item_id

			   ,dss.lane
			   ,dss.production_type
			   -- 20200406 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 : Hold 재고
               --     MES, QMS Hold = 'Y' 인 경우, MAX (MES Hold 예상해제일, QMS Hold 예상해제일) 로 가용 일자 반영
               -- 20211025 PJ20214997 MEB : P5200 인 경우 Available Date 적용 컬럼 변경  second_ocv_exp_date
                          --> 2021.12.13 PI 요청으로 원복함
			   --,CASE WHEN ISNULL(wiphold_yn, 'N') = 'N' AND ISNULL(dss.fp_apply_operation_id, '') <> 'P5200'  THEN ISNULL(dss.available_date, DATEADD(DAY, -1, dss.cutoff_date))
      --               -- Non Hold / P5200 이면서 Second OCV Date 가 없으면 바로 가용 처리
      --               WHEN ISNULL(wiphold_yn, 'N') = 'N' AND ISNULL(dss.fp_apply_operation_id, '')  = 'P5200'
      --                                                  AND ISNULL(dss.second_ocv_exp_date, '')    = ''       THEN ISNULL(dss.available_date, DATEADD(DAY, -1, dss.cutoff_date))
      --               -- Non Hold / P5200 이면서 Second OCV Date 가 존재하면 해당 일자에 가용 처리(Hold 처럼)
      --               WHEN ISNULL(wiphold_yn, 'N') = 'N' AND ISNULL(dss.fp_apply_operation_id, '')  = 'P5200'
      --                                                  AND ISNULL(dss.second_ocv_exp_date, '')   <> ''       THEN dss.second_ocv_exp_date
      --               -- Hold 처리는 기존과 같음
      --               WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '') = '' AND ISNULL(dss.qms_unhold_exp_date, '') = ''          THEN NULL
      --               WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '1999-01-01') >= ISNULL(dss.qms_unhold_exp_date, '1999-01-01') THEN dss.unhold_exp_date
      --               WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '1999-01-01') <  ISNULL(dss.qms_unhold_exp_date, '1999-01-01') THEN dss.qms_unhold_exp_date
      --               ELSE dss.available_date
      --          END available_date  

			   ,CASE WHEN ISNULL(wiphold_yn, 'N') = 'N'                                                                                                THEN ISNULL(dss.available_date, DATEADD(DAY, -1, dss.cutoff_date))
                     WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '') = '' AND ISNULL(dss.qms_unhold_exp_date, '') = ''          THEN NULL
                     WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '1999-01-01') >= ISNULL(dss.qms_unhold_exp_date, '1999-01-01') THEN dss.unhold_exp_date
                     WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '1999-01-01') <  ISNULL(dss.qms_unhold_exp_date, '1999-01-01') THEN dss.qms_unhold_exp_date
                     ELSE dss.available_date
                END available_date  

			   ,dss.remain_lead_time
			   ,dss.holding_date
			   ,dss.qty
			   ,dss.qty_uom
			   ,dss.stock_status
			   -- 20200909 C20200909-000178 stock_type= 'WIP' 인 경우 fp apply 정보로 변경 OLD) dss.operation_id
			   ,dss.fp_apply_operation_id AS operation_id
			   ,dss.operation_id          AS operation_id_org  -- 20210423 C20210422-000470 추가
			   ,dss.line_id
			   ,dss.outsourcing_flag
			   ,dss.outsourcing_factory
			   ,dss.description
			   ,dss.fp_apply_operation_id
			   ,dss.fp_apply_item_id
			   ,dss.fp_apply_wipqty
			   -- 20211025 PJ20214997 MEB : P5200 인 경우 Available Date 적용 컬럼 변경 
                          --> 2021.12.13 PI 요청으로 원복함
			   ,dss.wiphold_yn
    --           ,CASE WHEN ISNULL(wiphold_yn, 'N') = 'N' AND ISNULL(dss.fp_apply_operation_id, '')  = 'P5200'
    --                                                    AND ISNULL(dss.second_ocv_exp_date, '')   <> ''                 THEN 'Y' -- wip_type_code = 'INSP_PRE' 는 'Y' 로 처리
    --                 ELSE dss.wiphold_yn
				--END AS wiphold_yn

			   ,dss.qms_hold_yn   -- 20191030  추가

			   -- 20211025 PJ20214997 MEB : P5200 인 경우 Available Date 적용 컬럼 변경
                          --> 2021.12.13 PI 요청으로 원복함 
			   ,dss.wip_type_code
			   --,CASE WHEN ISNULL(wiphold_yn, 'N') = 'N' AND ISNULL(dss.fp_apply_operation_id, '') <> 'P5200'  THEN 'INSP_COM' -- MEB 가 아닌 건
      --               -- Non Hold / P5200 이면서 Second OCV Date 가 없으면 바로 가용 처리
      --               WHEN ISNULL(wiphold_yn, 'N') = 'N' AND ISNULL(dss.fp_apply_operation_id, '')  = 'P5200'
      --                                                  AND ISNULL(dss.second_ocv_exp_date, '')    = ''       THEN 'INSP_COM'
      --               -- Non Hold / P5200 이면서 Second OCV Date 가 존재하면 해당 일자에 가용 처리(Hold 처럼)
      --               WHEN ISNULL(wiphold_yn, 'N') = 'N' AND ISNULL(dss.fp_apply_operation_id, '')  = 'P5200'
      --                                                  AND ISNULL(dss.second_ocv_exp_date, '')   <> ''       THEN 'INSP_PRE' 
      --               -- Hold 처리는 기존과 같음
      --               WHEN ISNULL(wiphold_yn, 'N') = 'Y'                                                       THEN 'INSP_HOLD'
      --               ELSE 'INSP_COM'
      --          END wip_type_code  

			   ,dss.qty2
			   ,dss.modify_fp_apply_wipqty
			   ,dss.modify_description
			   ,dss.cal_qty
			   ,dss.formation_rework_type
			   ,dss.insert_id
			   ,dss.insert_time
			   ,dss.update_id
			   ,dss.update_time
			   ,dss.location
			   ,dss.moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
			   ,dss.capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,dss.vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,dss.rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
               -- 20221222 ERP의 Restricted 재고를 defect_qty 에 추가 적용 : defect_qty = defect_qty + restrict_qty
			   ,ISNULL(dss.defect_qty, 0) + ISNULL(dss.restrict_qty, 0) AS defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
			   ,dss.unhold_exp_date -- 20191120 추가
			   ,dss.mes_map_sloc    -- 20191120 추가
		       ,dss.mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
		       ,dss.mes_unhold_date     -- 20200413 MES hold 실제 해제일
		       ,dss.qms_hold_date       -- 20200413 QMS Hold 일
		       ,dss.qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
		       ,dss.qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
		       -- 20210618 C20210617-000105 : location_code 정보 추가 : scm_site_id와 연계
               ,CASE WHEN dss.stock_status = 'MOVING' AND dbo.fn_get_item_operation_group(dss.division_id, [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.fp_apply_item_id)) = 'E'
                          AND ms.operation_group = 'E'
                          THEN 'SLITTING'
                     WHEN sl.scm_site_id IS NOT NULL -- 20210128 PJ20209642 mes_map_sloc 컬럼의 정보를 사용하여 PACK_OWMS/CELL_OWMS Location 정보와 비교하여 Scm Site ID Mapping
                          THEN sl.location_code
                     WHEN md2.segment2 IS NULL    -- Lookup에 등록되지 않은 Operation : 일반적인 경우
                          THEN site.location_code
                     WHEN md.segment2 IS NOT NULL -- Lookup에 등록된 Operation / mes_map_sloc
                          THEN site.location_code
					 ELSE NULL                    -- Lookup에 등록된 Operation / 등록되지 않은 mes_map_sloc : 재고로 잡지 않음
                END  location_code 
               -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		       ,dss.mes_item_id
		       ,dss.mes_operation_id
		       ,dss.from_sloc_id
		       ,dss.customer_id
		       ,dss.special_stock_indicator

		 FROM   scm_dnm_stock_sn dss WITH(NOLOCK)

	     -- 20181130 소형 대표 ITEM_ID 처리 조정
         LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
         ON   dss.division_id      = fi.division_id
         AND  dss.fp_apply_item_id = fi.item_id  -- 20200909 C20200909-000178 stock_type= 'WIP' 인 경우 fp apply 정보로 변경 old) dss.item_id

		 LEFT JOIN (SELECT DISTINCT ms.company_id
					      ,ms.division_id
					      ,ms.site_id
					      ,ml.factory_id
					      ,ms.plant_id
					      ,ml.operation_id
					      ,ms.scm_site_id
						  ,ml.location_code
				    FROM   scm_mst_site ms WITH(NOLOCK)
				    JOIN   scm_mst_location ml WITH(NOLOCK)
				    ON     ms.division_id = ml.division_id
				    AND    ms.scm_site_id = ml.scm_site_id
				    WHERE  ms.valid_yn    = 'Y'
				    AND    ml.valid_yn    = 'Y'
				   ) site
		 ON     dss.company_id	= site.company_id
		 AND    dss.division_id	= site.division_id
		 AND    dss.site_id		= site.site_id
		 AND    dss.plant_id	= site.plant_id
		 AND    dss.factory_id	= site.factory_id
		 AND    dss.fp_apply_operation_id = site.operation_id  -- 20200909 C20200909-000178 stock_type= 'WIP' 인 경우 fp apply 정보로 변경 old) dss.operation_id

		 LEFT JOIN scm_mst_site ms WITH(NOLOCK)
		 ON     dss.division_id = ms.division_id
		 AND    dss.plant_id = ms.plant_id
		 AND    ms.site_type = 'PLANT'
		 AND    ms.valid_yn = 'Y'
		 AND    ms.operation_group IN ('E')

		 -- 20200406 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 : Hold 재고
		 -- Lookup에 등록된 Operation / mes_map_sloc / Plant / Factory 확인용
		 LEFT JOIN (SELECT DISTINCT segment2, segment3, segment4, segment5
                    FROM   scm_adm_lookup_master_detail WITH(NOLOCK)
                    WHERE  lookup_type = 'WIP_MES_MAP_SLOC'
		            AND    segment1    = 'WIP'
                    AND    valid_yn    = 'Y'
                  ) md
		 ON     dss.fp_apply_operation_id = md.segment2  -- 20200909 C20200909-000178 stock_type= 'WIP' 인 경우 fp apply 정보로 변경 old) dss.operation_id
		 AND    dss.mes_map_sloc = md.segment3
		 AND    dss.plant_id     = md.segment4
		 AND    dss.factory_id   = md.segment5

		 -- Lookup에 등록된 Operation / Plant / Factory 확인용
		 LEFT JOIN (SELECT DISTINCT segment2, segment4, segment5
                    FROM   scm_adm_lookup_master_detail WITH(NOLOCK)
                    WHERE  lookup_type = 'WIP_MES_MAP_SLOC'
		            AND    segment1    = 'WIP'
                    AND    valid_yn    = 'Y'
                  ) md2
		 ON     dss.fp_apply_operation_id = md2.segment2  -- 20200909 C20200909-000178 stock_type= 'WIP' 인 경우 fp apply 정보로 변경 old) dss.operation_id
		 AND    dss.plant_id     = md2.segment4
		 AND    dss.factory_id   = md2.segment5
		 
         -- 20210128 PJ20209642 'WIP' : 
         -- mes_map_sloc 컬럼의 정보를 사용하여 PACK_OWMS/CELL_OWMS Location 정보와 비교하여 Scm Site ID Mapping
		 LEFT JOIN (SELECT DISTINCT ms.company_id
						  ,ms.division_id
						  ,ms.site_id
						  ,ml.factory_id
						  ,ml.plant_id
						  ,ml.storage_id
						  ,ms.scm_site_id
						  ,ml.location_code
						  ,CASE ml.location_code WHEN 'CELL_OWMS' THEN 'A'
						                         WHEN 'PACK_OWMS' THEN 'P'
												 ELSE '%' END operation_group -- 2018.10.01
				    FROM   scm_mst_site ms WITH(NOLOCK)
				    JOIN   scm_mst_location ml WITH(NOLOCK)
				    ON     ms.division_id = ml.division_id
				    AND    ms.scm_site_id = ml.scm_site_id
				    WHERE  ms.valid_yn    = 'Y'
				    AND    ml.valid_yn    = 'Y'
					-- 'WIP' 에서 PACK_OWMS/CELL_OWMS Location에 해당하는 정보 Site Mapping
					AND    ml.location_code IN ('CELL_OWMS', 'PACK_OWMS')
					AND    ms.vmi_yn = CASE ms.division_id WHEN '40' THEN 'N' -- 2018.09.10
					                                       -- PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : 자동차 사업부 VMI사이트도 재고 사용
					                                       -- WHEN '81' THEN 'N' -- 2018.10.05
														   ELSE ms.vmi_yn 
														   END 
					) sl
		 ON     dss.company_id	 = [dbo].[FN_SCM_SYS_NVL](sl.company_id, dss.company_id) -- 2018. 04.27  Kim Jihye
		 AND    dss.division_id  = sl.division_id
		 AND    dss.site_id		 = [dbo].[FN_SCM_SYS_NVL](sl.site_id, dss.site_id) -- 2018. 04.27  Kim Jihye
		 AND    dss.plant_id	 = sl.plant_id 
         -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가 : from_sloc_id 가 존재하는 경우 from_sloc_id 로 비교
		 AND    CASE WHEN ISNULL(dss.from_sloc_id, '') <> '' THEN dss.from_sloc_id
                     ELSE dss.mes_map_sloc 
                END = sl.storage_id		 
		 --AND    dss.mes_map_sloc = sl.storage_id		 
	     -- 20181130 소형 대표 ITEM_ID 처리 조정
		 AND    dbo.fn_get_item_operation_group(dss.division_id, [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id)) LIKE sl.operation_group -- 2018.10.01

		 WHERE  dss.stock_type	= 'WIP'
		 -- AND	dss.wiphold_yn	= 'N' 2018. 05.11  Kim Jihye
		 
		 ------------------------------
		 -- WIP 재고 (MES : SSP) 
		 --   20210712 PJ20209643 : 'WIP' 재고 에서 81/82의 B1000 재고와 40의 location_code = 'FORMATION_CHECK_PACKAGING' 재고는 제외하고 MES 정보 사용
		 ------------------------------
  /* -- 20220729 WIP_SSP 제외 : WIP에서 처리 : START
		 UNION ALL
         SELECT 
		        ms.from_site AS scm_site_id 
		       ,SUM(ms.lot_qty) AS scm_qty   -- qty2 와 동일
			   ,ms.company_id AS company_id
			   ,ms.division_id AS division_id
			   ,ms.site_id AS site_id

			   ,ms.plant_id
		       ,ms.factory_id AS factory_id
			   ,ms.plant_id   AS storage_id
			   ,CONVERT(DATE, ms.yyyymmdd) AS cutoff_date  -- yyyymmdd가 BOH 기준임, 위에서 -1일해서 EOH 기준 일자로 처리됨
			   ,null seq
			   ,'WIP_SSP'  AS stock_type
		       ,ms.item_id AS item_id
		       ,ms.item_id AS origin_item_id
			   ,null lane
			   ,null production_type

			   ,ms.available_date AS available_date
				
			   ,null remain_lead_time
			   ,null holding_date
			   ,null qty
			   ,'EA' qty_uom
			   ,null stock_status
			   ,ms.operation_id AS operation_id
			   ,ms.operation_id AS operation_id_org  -- 20210423 C20210422-000470 추가
			   ,null line_id
			   ,'N' outsourcing_flag
			   ,null outsourcing_factory
			   ,null description
		 	   ,null fp_apply_operation_id
			   ,null fp_apply_item_id
			   ,null fp_apply_wipqty

			   ,ms.wiphold_yn  AS wiphold_yn 

			   ,null qms_hold_yn
			   ,null wip_type_code
			   ,SUM(ms.lot_qty) AS qty2  -- stock_type = 'WIP_SSP' 인 경우 scm_qty 와 동일
			   ,null modify_fp_apply_wipqty
			   ,null modify_description
			   ,null cal_qty
			   ,null formation_rework_type
			   ,MAX(ms.created_by) AS created_by
			   ,MAX(ms.creation_date) AS creation_date
			   ,MAX(ms.last_updated_by) AS last_updated_by
			   ,MAX(ms.last_update_date) AS last_update_date
			   ,null location
			   ,null moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
			   ,null capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
			   ,null unhold_exp_date -- 20191120 추가
			   ,null mes_map_sloc    -- 20191120 추가
		       ,'N'  mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
		       ,null mes_unhold_date     -- 20200413 MES hold 실제 해제일
		       ,null qms_hold_date       -- 20200413 QMS Hold 일
		       ,null qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
		       ,null qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
		       ,'FORMATION_CHECK_PACKAGING' AS location_code   -- 20210618 C20210617-000105 : location_code 정보 추가 : 내부 Plant / 외부 Plant 공급 가능함
               -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		       ,NULL mes_item_id
		       ,NULL mes_operation_id
		       ,NULL from_sloc_id
		       ,NULL customer_id
		       ,NULL special_stock_indicator
		 FROM  (
                -- 1. 81/82 : operation_id  = 'B1000'
                SELECT s.division_id, s.company_id, site.site_id, s.plant_id, s.factory_id, s.from_site, s.item_id, s.yyyymmdd, s.operation_id
                     , s.lot_qty
			         , s.hold_yn      AS wiphold_yn 
			         , s.hold_release AS available_date
			         , s.created_by, s.creation_date, s.last_updated_by, s.last_update_date
                FROM   scm_dnm_mes_stock s WITH(NOLOCK)
		 
		        INNER JOIN scm_mst_site site WITH(NOLOCK)
		        ON     s.division_id        = site.division_id
		        AND    s.from_site          = site.scm_site_id 
		        AND    s.division_id       IN ('81', '82', '81_UC') -- 20220425 PJ20216891 : GM JV 가상 Division 추가
		        AND    site.site_type       = 'PLANT'
		        AND    site.valid_yn        = 'Y'
		        AND    site.operation_group = 'A' -- Cell Site 만 처리함
                AND    s.operation_id       = 'B1000'

				UNION ALL
                -- 2. 40 : location_code = 'FORMATION_CHECK_PACKAGING'
                SELECT s.division_id, s.company_id, site.site_id, s.plant_id, s.factory_id, s.from_site, s.item_id, s.yyyymmdd, s.operation_id
                     , s.lot_qty
			         , s.hold_yn      AS wiphold_yn 
			         , s.hold_release AS available_date
			         , s.created_by, s.creation_date, s.last_updated_by, s.last_update_date
                FROM   scm_dnm_mes_stock s WITH(NOLOCK)

		        INNER JOIN (SELECT DISTINCT ms.company_id
					              ,ms.division_id
					              ,ms.site_id
			        		      ,ml.factory_id
					              ,ms.plant_id
					              ,ml.operation_id
					              ,ms.scm_site_id
						          ,ml.location_code
				            FROM   scm_mst_site ms WITH(NOLOCK)
				            JOIN   scm_mst_location ml WITH(NOLOCK)
				            ON     ms.division_id = ml.division_id
				            AND    ms.scm_site_id = ml.scm_site_id
				            WHERE  ms.valid_yn        = 'Y'
				            AND    ml.valid_yn        = 'Y'
		                    AND    ms.site_type       = 'PLANT'
		                    AND    ms.operation_group = 'A' -- Cell Site 만 처리함
				            AND    ml.location_code   = 'FORMATION_CHECK_PACKAGING'
				           ) site
		         ON     s.division_id	= site.division_id
		         AND    s.division_id  IN ('40')
		         AND    s.plant_id		= site.plant_id
		         AND    s.factory_id	= site.factory_id
		         AND    s.operation_id  = site.operation_id 
		         AND    s.from_site		= site.scm_site_id

               ) ms

		 WHERE  1=1

		 GROUP BY ms.division_id, ms.company_id, ms.site_id, ms.plant_id, ms.factory_id, ms.from_site, ms.item_id, ms.yyyymmdd, ms.operation_id
			    , ms.wiphold_yn, ms.available_date
 */ -- 20220729 WIP_SSP 제외 : WIP에서 처리 : END

		 ------------------------------
         -- 2021.01.27 20210128 PJ20209642 'OWMS' : 'OWMS' Type 생성 : SSP 에서 I/F 받는 OMWS 재고를 SCP 재고 View에 추가
         --                           PACK_OWMS/CELL_OWMS Location과 Storage_id 비교하여 Scm Site ID Mapping
		 -- attribute1 : 판정일 / attribute3 : PASS/FAIL / attribute4 : 검사예정일
		 -- Stock_status :   00 : 정상     / 10 : 미판정   / 20 : 반품보류 / 30 : 품질검사
         --                  40 : 품질HOLD / 50 : 취급불량 / 70 : 검사생략 / 80 : 검사합격 / 
         --                  91 : 1차 숙성검사 대기 / 92 : 1차 숙성검사 진행 / 93 : 2차 숙성검사 대기 / 94 : 2차 숙성검사 진행
		 -- 20240401 E20240325-000326 'OWMS' 보류 재고 변경
         --          OSP_LT 비대상 :  BLOCK_QTY >  0 이면 보류재고, SCM_QTY / QTY2 = BLOCK_QTY, WIPHOLD_YN = 'Y', AVAILABLE_DATE = SCP CUTOFFDATE + 1일, WIP_TYPE_CODE = 'INSP_COM'
         --                           BLOCK_QTY <= 0 이면 현재유지, SCM_QTY / QTY2 = STOCK_QTY, WIPHOLD_YN = 'N', AVAILABLE_DATE = N/A, WIP_TYPE_CODE = 'INSP_COM'
         --	         OSP_LT대상 -- 현재유지
		 ------------------------------
		 UNION ALL
		 SELECT 
               /*  전진검사 관련 추가 (PJ20214907) */
			    -- 모델 : AMVCCCMAE-A1-D01 / Plant : G481 / SLOC : 510E 정보는 사용 안 함 : 수정 시 '-- Storage 별 일반 재고 (ERP) : AS Plant 제외' 부분과 같이 수정 필요
				-- 20240629 하드코딩 변환
                CASE WHEN owm.plant_id   = (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WHERE LOOKUP_TYPE_CODE = 'SCM_DNM_STOCK_V' AND SEGMENT1 = 'PLANT')
				      AND owm.storage_id = (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WHERE LOOKUP_TYPE_CODE = 'SCM_DNM_STOCK_V' AND SEGMENT1 = 'SLOC')
					  AND owm.item_id    = (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WHERE LOOKUP_TYPE_CODE = 'SCM_DNM_STOCK_V' AND SEGMENT1 = 'MODEL')
					 THEN NULL					 
					 -- 20220902 'SSP_AS_DIV_SLOC'에속한 Storage 는 'OWMS'재고에서 제외
                     WHEN as_site.scm_site_id IS NOT NULL     THEN NULL
                     WHEN lt.item_id IS NULL                  THEN ISNULL(sl.scm_site_id, site.scm_site_id) -- 전진검사 비대상은 기존 유지
                     --WHEN ISNULL(owm.attribute3, '') = 'FAIL' THEN NULL -- 20211223 FAIL 은 Plan 마지막 일자 재고로 처리
                     ELSE ISNULL(sl.scm_site_id, site.scm_site_id) 
			    END AS scm_site_id
				
                /*  전진검사 관련 추가 (PJ20214907) */
		        -- 20240401 E20240325-000326 'OWMS' 보류 재고 변경
              /* ,CASE WHEN lt.item_id IS NULL                  THEN owm.stock_qty -- 전진검사 비대상은 기존 유지
                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status IN ('20', '40', '50') THEN owm.block_qty
                     ELSE owm.stock_qty 
			    END AS scm_qty*/
               ,CASE WHEN lt.item_id IS NULL AND ISNULL(owm.BLOCK_QTY, 0) <= 0 THEN owm.stock_qty -- 전진검사 비대상은 기존 유지 -- 20240328 E20240325-000326 LOCK_QTY <= 0 이면, 일반재고 : stock_qty
                     WHEN lt.item_id IS NULL AND ISNULL(owm.BLOCK_QTY, 0) >  0 THEN owm.BLOCK_QTY -- 전진검사 비대상은 기존 유지 -- 20240328 E20240325-000326 LOCK_QTY >  0 이면, 보류재고 : BLOCK_QTY
                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status IN ('20', '40', '50') THEN owm.block_qty
                     ELSE owm.stock_qty 
			    END AS scm_qty

			   -- 아래는 SSP가 사용하는 Qty
               --,owm.stock_qty -  CASE WHEN owm.plant_id = 'G182' THEN owm.block_qty
               --                       ELSE
               --                            CASE WHEN  owm.block_qty >= owm.long_qty THEN owm.block_qty
               --                                 WHEN  owm.block_qty <  owm.long_qty THEN owm.long_qty
               --                            END    
               --                  END AS scm_qty -- STOCK_QTY - MAX(BLOCK_QTY, LONG_QTY)

			   ,CASE WHEN ISNULL(sl.company_id, '') = '' THEN isnull(site.company_id, '-')
			         ELSE  sl.company_id  
				END AS company_id

			   ,owm.origin_from_division_id AS division_id
			   ,CASE WHEN ISNULL(sl.site_id, '') = '' THEN isnull(site.site_id, '-')
			         ELSE  sl.site_id  
				END AS site_id

			   ,owm.plant_id
		       ,CASE WHEN ISNULL(sl.factory_id, '') = '' THEN '-' ELSE sl.factory_id END AS factory_id
			   ,owm.storage_id
			   ,DATEADD(day,1,owm.cutoff_date) AS cutoff_date  -- cutoff_date가 EOH 기준이나 View 의 상단에서 -1일 처리하기 때문에 먼저 +1 함
			   ,null seq
			   ,'OWMS'   AS stock_type
		       ,owm.item_id AS item_id
		       ,owm.item_id AS origin_item_id
			   ,null lane
			   ,null production_type
			   
               /*  전진검사 관련 추가 (PJ20214907) */
		        -- 20240401 E20240325-000326 'OWMS' 보류 재고 변경
              /* ,CASE WHEN lt.item_id IS NULL                                 THEN DATEADD(day, 1, owm.cutoff_date) -- 전진검사 비대상은 기존 유지
			         -- 20211223 FAIL 은 Plan 마지막 일자 재고로 처리
                     WHEN ISNULL(owm.attribute3, '')     IN ('PASS') THEN DATEADD(day, 1, owm.cutoff_date)
                     WHEN ISNULL(owm.attribute3, '')     IN ('FAIL') THEN CONVERT(DATETIME, lt.horizon_end_date)

                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status = '70'                THEN DATEADD(day, 1, owm.cutoff_date)
                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status IN ('20', '40', '50') THEN CONVERT(DATETIME, lt.horizon_end_date)
                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.attribute4 IS NOT NULL             THEN CONVERT(DATETIME, owm.attribute4) 
                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.attribute4 IS NULL                 THEN DATEADD(day, 1, owm.cutoff_date)
                     ELSE DATEADD(day, 1, owm.cutoff_date) 
				END AS available_date*/
               ,CASE WHEN lt.item_id IS NULL AND ISNULL(owm.BLOCK_QTY, 0) <= 0 THEN DATEADD(day, 1, owm.cutoff_date) -- 전진검사 비대상은 기존 유지 -- 20240328 E20240325-000326 LOCK_QTY <= 0 이면, 일반재고 : WIPHOLD N 이므로 의미 없음
                     WHEN lt.item_id IS NULL AND ISNULL(owm.BLOCK_QTY, 0) >  0 THEN DATEADD(day, 1, owm.cutoff_date) -- 전진검사 비대상은 기존 유지 -- 20240328 E20240325-000326 LOCK_QTY >  0 이면, 보류재고 : SCP CUTOFFDATE + 1일
			         -- 20211223 FAIL 은 Plan 마지막 일자 재고로 처리
                     WHEN ISNULL(owm.attribute3, '')     IN ('PASS') THEN DATEADD(day, 1, owm.cutoff_date)
                     WHEN ISNULL(owm.attribute3, '')     IN ('FAIL') THEN CONVERT(DATETIME, lt.horizon_end_date)

                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status = '70'                THEN DATEADD(day, 1, owm.cutoff_date)
                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status IN ('20', '40', '50') THEN CONVERT(DATETIME, lt.horizon_end_date)
                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.attribute4 IS NOT NULL             THEN CONVERT(DATETIME, owm.attribute4) 
                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.attribute4 IS NULL                 THEN DATEADD(day, 1, owm.cutoff_date)
                     ELSE DATEADD(day, 1, owm.cutoff_date) 
				END AS available_date

			   ,null remain_lead_time
			   ,null holding_date
			   ,null qty
			   ,'EA' qty_uom
			   ,null stock_status
			   ,null operation_id
			   ,null operation_id_org  -- 20210423 C20210422-000470 추가
			   ,null line_id
			   ,'N' outsourcing_flag
			   ,null outsourcing_factory
			   ,null description
		 	   ,null fp_apply_operation_id
			   ,null fp_apply_item_id
			   ,null fp_apply_wipqty			   
			   
               /*  전진검사 관련 추가 (PJ20214907) */
		        -- 20240401 E20240325-000326 'OWMS' 보류 재고 변경
               /*,CASE WHEN lt.item_id IS NULL                                 THEN 'N' -- 전진검사 비대상은 기존 유지
			         -- 20211223 FAIL 은 Plan 마지막 일자 재고로 처리
                     WHEN ISNULL(owm.attribute3, '')     IN ('PASS') THEN 'N'
                     WHEN ISNULL(owm.attribute3, '')     IN ('FAIL') THEN 'Y'

                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status = '70'                THEN 'N'
                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status IN ('20', '40', '50') THEN 'Y'
                     ELSE 'Y'  -- wip_type_code = 'INSP_PRE' 는 'Y' 로 처리
				END AS wiphold_yn*/
               ,CASE WHEN lt.item_id IS NULL AND ISNULL(owm.BLOCK_QTY, 0) <= 0 THEN 'N' -- 전진검사 비대상은 기존 유지 -- 20240328 E20240325-000326 LOCK_QTY <= 0 이면, 일반재고 : N
                     WHEN lt.item_id IS NULL AND ISNULL(owm.BLOCK_QTY, 0) >  0 THEN 'Y' -- 전진검사 비대상은 기존 유지 -- 20240328 E20240325-000326 LOCK_QTY >  0 이면, 보류재고 : Y
			         -- 20211223 FAIL 은 Plan 마지막 일자 재고로 처리
                     WHEN ISNULL(owm.attribute3, '')     IN ('PASS') THEN 'N'
                     WHEN ISNULL(owm.attribute3, '')     IN ('FAIL') THEN 'Y'

                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status = '70'                THEN 'N'
                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status IN ('20', '40', '50') THEN 'Y'
                     ELSE 'Y'  -- wip_type_code = 'INSP_PRE' 는 'Y' 로 처리
				END AS wiphold_yn
			   ,'N' qms_hold_yn   -- 20191030  추가
			   
               /*  전진검사 관련 추가 (PJ20214907) */
		        -- 20240401 E20240325-000326 'OWMS' 보류 재고 변경
              /* ,CASE WHEN lt.item_id IS NULL                                 THEN 'INSP_COM' -- 전진검사 비대상은 기존 유지
			         -- 20211223 FAIL 은 Plan 마지막 일자 재고로 처리
                     WHEN ISNULL(owm.attribute3, '')     IN ('PASS') THEN 'INSP_COM' -- 검사완료
                     WHEN ISNULL(owm.attribute3, '')     IN ('FAIL') THEN 'INSP_HOLD' -- HOLD


                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status = '70'                THEN 'INSP_COM'  -- 검사완료
                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status IN ('20', '40', '50') THEN 'INSP_HOLD' -- HOLD
                     ELSE 'INSP_PRE'                                                                                                     -- 검사대기
				END AS wip_type_code*/
               ,CASE WHEN lt.item_id IS NULL AND ISNULL(owm.BLOCK_QTY, 0) <= 0 THEN 'INSP_COM' -- 전진검사 비대상은 기존 유지 -- 20240328 E20240325-000326 LOCK_QTY <= 0 이면, 일반재고
                     WHEN lt.item_id IS NULL AND ISNULL(owm.BLOCK_QTY, 0) >  0 THEN 'INSP_COM' -- 전진검사 비대상은 기존 유지 -- 20240328 E20240325-000326 LOCK_QTY >  0 이면, 보류재고
			         -- 20211223 FAIL 은 Plan 마지막 일자 재고로 처리
                     WHEN ISNULL(owm.attribute3, '')     IN ('PASS') THEN 'INSP_COM' -- 검사완료
                     WHEN ISNULL(owm.attribute3, '')     IN ('FAIL') THEN 'INSP_HOLD' -- HOLD


                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status = '70'                THEN 'INSP_COM'  -- 검사완료
                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status IN ('20', '40', '50') THEN 'INSP_HOLD' -- HOLD
                     ELSE 'INSP_PRE'                                                                                                     -- 검사대기
				END AS wip_type_code
			   
               /*  전진검사 관련 추가 (PJ20214907) */
			   --,owm.stock_qty AS qty2  -- stock_type = 'OWMS' 인 경우 scm_qty 와 동일
		       -- 20240401 E20240325-000326 'OWMS' 보류 재고 변경
               /*,CASE WHEN lt.item_id IS NULL                  THEN owm.stock_qty -- 전진검사 비대상은 기존 유지
                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status IN ('20', '40', '50') THEN owm.block_qty
                     ELSE owm.stock_qty 
				END AS qty2*/
               ,CASE WHEN lt.item_id IS NULL AND ISNULL(owm.BLOCK_QTY, 0) <= 0 THEN owm.stock_qty -- 전진검사 비대상은 기존 유지 -- 20240328 E20240325-000326 LOCK_QTY <= 0 이면, 일반재고 : stock_qty
                     WHEN lt.item_id IS NULL AND ISNULL(owm.BLOCK_QTY, 0) >  0 THEN owm.BLOCK_QTY -- 전진검사 비대상은 기존 유지 -- 20240328 E20240325-000326 LOCK_QTY >  0 이면, 보류재고 : BLOCK_QTY
                     WHEN ISNULL(owm.attribute3, '') NOT IN ('PASS', 'FAIL') AND owm.stock_status IN ('20', '40', '50') THEN owm.block_qty
                     ELSE owm.stock_qty 
			    END AS qty2

			   ,null modify_fp_apply_wipqty
			   ,null modify_description
			   ,null cal_qty
			   ,null formation_rework_type
			   ,owm.created_by
			   ,owm.creation_date
			   ,owm.last_updated_by
			   ,owm.last_update_date
			   ,null location
			   ,null moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
			   ,null capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
			   ,null unhold_exp_date -- 20191120 추가
			   ,null mes_map_sloc    -- 20191120 추가
		       ,'N'  mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
		       ,null mes_unhold_date     -- 20200413 MES hold 실제 해제일
		       ,null qms_hold_date       -- 20200413 QMS Hold 일
		       ,null qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
		       ,null qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
		       ,ISNULL(sl.location_code, NULL) AS location_code  -- 20210618 C20210617-000105 : location_code 정보 추가 : scm_site_id와 연계, SVC 인 경우 NULL 처리
               -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		       ,NULL mes_item_id
		       ,NULL mes_operation_id
		       ,NULL from_sloc_id
		       ,NULL customer_id
		       ,NULL special_stock_indicator
		 FROM   ssp_dnm_owms_stock owm WITH(NOLOCK)
		 		 		 	
         -- PACK_OWMS/CELL_OWMS Location 정보와 비교하여 Scm Site ID Mapping
		 LEFT JOIN (SELECT DISTINCT ms.company_id
						  ,ms.division_id
						  ,ms.site_id
						  ,ml.factory_id
						  ,ml.plant_id
						  ,ml.storage_id
						  ,ms.scm_site_id
						  ,ml.location_code
						  ,CASE ml.location_code WHEN 'CELL_OWMS' THEN 'A'
						                         WHEN 'PACK_OWMS' THEN 'P'
												 ELSE '%' END operation_group -- 2018.10.01
				    FROM   scm_mst_site ms WITH(NOLOCK)
				    JOIN   scm_mst_location ml WITH(NOLOCK)
				    ON     ms.division_id = ml.division_id
				    AND    ms.scm_site_id = ml.scm_site_id
				    WHERE  ms.valid_yn    = 'Y'
				    AND    ml.valid_yn    = 'Y'
					--PACK_OWMS/CELL_OWMS Location에 해당하는 정보 Site Mapping
					AND    ml.location_code IN ('CELL_OWMS', 'PACK_OWMS')
					AND    ms.vmi_yn = CASE ms.division_id WHEN '40' THEN 'N' -- 2018.09.10
					                                       -- PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : 자동차 사업부 VMI사이트도 재고 사용
					                                       -- WHEN '81' THEN 'N' -- 2018.10.05
														   ELSE ms.vmi_yn 
														   END 
					) sl
		 ON     owm.origin_from_division_id = sl.division_id
		 AND    owm.plant_id	            = sl.plant_id 
		 AND    owm.storage_id	            = sl.storage_id		 
	     -- 20181130 소형 대표 ITEM_ID 처리 조정
		 AND    dbo.fn_get_item_operation_group(owm.origin_from_division_id, owm.item_id) LIKE sl.operation_group 
		 
		 -- A002 반영
		 LEFT JOIN SCM_MST_SITE SITE WITH(NOLOCK)
		 ON     OWM.origin_from_division_id = SITE.DIVISION_ID
		 AND    OWM.PLANT_ID	            = SITE.PLANT_ID 
		 AND    SITE.OPERATION_GROUP        = 'W'
		 AND    SITE.SITE_TYPE              = 'PLANT'
		 AND    SITE.VALID_YN               = 'Y'
		 
         --전진검사 관련 추가 (PJ20214907)
		 LEFT JOIN (SELECT ms.division_id
                         , mo.scm_site_id
                         , mo.item_id
                         , mo.lt_operation
                         , isnull(mo.attribute1, 'N') attribute1
                         , mo.lt_day
                         , isnull(mp.horizon_end_date, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)) horizon_end_date
                    FROM scp_mst_operation_lt mo WITH(NOLOCK)

                    INNER JOIN scm_mst_site ms WITH(NOLOCK)
                    ON  mo.division_id  = ms.division_id
                    AND mo.scm_site_id  = ms.scm_site_id
                    AND mo.lt_operation = 'PRE_INSP'
                    AND ISNULL(mo.attribute1, 'N') = 'Y'  -- 전진검사 재고 LT 적용 대상

                    LEFT JOIN scm_mst_plan mp WITH(NOLOCK)
                    ON  mo.division_id = mp.division_id
                    AND mp.plan_name   = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
                    AND mp.plan_cycle  = 'WEEKLY' 
				  ) LT
		 ON     lt.division_id  = owm.origin_from_division_id
		 AND    lt.scm_site_id	= ISNULL(sl.scm_site_id, site.scm_site_id)
		 AND    lt.item_id      = owm.item_id
		 AND    lt.lt_operation = 'PRE_INSP'
		 AND    lt.attribute1   = 'Y'
		 
         -- 20220902 'SSP_AS_DIV_SLOC'에속한 Storage 는 'OWMS'재고에서 제외
		 LEFT JOIN (
                    SELECT segment1 AS division_id
                         , segment2 AS scm_site_id
                         , segment3 AS plant_id
                         , segment4 AS storage_id
                    FROM   scm_adm_lookup_master_detail md WITH(NOLOCK) -- 2018. 04.10  Kim Jihye
                    WHERE  md.lookup_type = 'SSP_AS_DIV_SLOC'
                    AND    md.valid_yn    = 'Y'  
					) as_site
		 ON     owm.origin_from_division_id = as_site.division_id
		 AND    owm.plant_id	            = as_site.plant_id 
		 AND    owm.storage_id	            = as_site.storage_id
		 
		 ------------------------------
		 -- 2018. 05.25  Kim Jihye VMI 재고 (고객 위탁 재고) 추가
		 ------------------------------
		 UNION ALL
		 SELECT -- 20210106 C20210105-000744 Consignment 재고의 Ship-To와 Sold-To 적용을 위한 재고 반영 로직 변경
				--     Sales Site를 Lookup Mapping 하지 않고 Ship-To와 Sold-To 기준으로 연동 함.
                -- 20210618 C20210617-000105 : location_code 정보 추가 : 소형인 경우 Consignment 재고의 Scm Site ID 사용
				-- 20230224 E20230223-000217 : 자동차/ESS 의 SCM_SITE_ID 도 Lookup 상관없이 Consignment 재고의 Scm Site ID 사용
		        cc.scm_site_id AS scm_site_id	
               --CASE WHEN cc.division_id          = '40' THEN cc.scm_site_id -- 소형인 경우 Consignment 재고의 Scm Site ID 사용
               --     WHEN ISNULL(md.segment2, '') = ''   THEN NULL           -- 소형외 lookup 에 없는 경우 NULL 처리
               --     ELSE cc.scm_site_id 
               --END AS scm_site_id

			   ,cc.qty AS scm_qty
			   ,cc.company_id
			   ,cc.division_id
			   ,cc.site_id
			   ,cc.plant_id
			   ,cc.customer_code factory_id
			   ,cc.customer_code storage_id
			   ,DATEADD(day,1,cc.result_date) cutoff_date  -- result_date가 EOH 기준이나 View 의 상단에서 -1일 처리하기 때문에 먼저 +1 함
			   ,null seq
			   ,'VMI' stock_type
	           -- 20181130 소형 대표 ITEM_ID 처리 조정
		       ,[dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, cc.item_id) item_id --2018.06.29
		       ,cc.item_id origin_item_id --2018.06.29
			   ,null lane
			   ,null production_type
			   ,DATEADD(day,1,cc.result_date) available_date -- cutoff_date 와 동일하게 처리
			   ,null remain_lead_time
			   ,null holding_date
			   ,null qty
			   ,cc.uom qty_uom
			   ,null stock_status
			   ,null operation_id
			   ,null operation_id_org  -- 20210423 C20210422-000470 추가
			   ,null line_id
			   ,'N' outsourcing_flag
			   ,null outsourcing_factory
			   ,null description
		 	   ,null fp_apply_operation_id
			   ,null fp_apply_item_id
			   ,null fp_apply_wipqty
			   ,'N' wiphold_yn
			   ,'N' qms_hold_yn   -- 20191030  추가
			   ,null wip_type_code
			   ,null qty2
			   ,null modify_fp_apply_wipqty
			   ,null modify_description
			   ,null cal_qty
			   ,null formation_rework_type
			   ,cc.created_by
			   ,cc.creation_date
			   ,cc.last_updated_by
			   ,cc.last_update_date
			   ,null location
			   ,null moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
			   ,null capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
			   ,null unhold_exp_date -- 20191120 추가
			   ,null mes_map_sloc    -- 20191120 추가
		       ,'N'  mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
		       ,null mes_unhold_date     -- 20200413 MES hold 실제 해제일
		       ,null qms_hold_date       -- 20200413 QMS Hold 일
		       ,null qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
		       ,null qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
		       ,NULL AS location_code    -- 20210618 C20210617-000105 : location_code 정보 추가 : SALES 이므로 NULL 처리
               -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		       ,NULL mes_item_id
		       ,NULL mes_operation_id
		       ,NULL from_sloc_id
		       ,NULL customer_id
		       ,NULL special_stock_indicator
         -- 2021.10.06 최초 생성과 다른 Shipto로 출하하여 음수재고 생성되는 경우 SUM 처리를 위하여 GROUP BY 처리함
		 --FROM   scm_dnm_stock_customer_consign cc WITH(NOLOCK)
		 FROM (SELECT c.division_id, c.scm_site_id, c.result_date, c.item_id
                     ,SUM(c.qty)           AS qty
                     ,MAX(c.company_id)    AS company_id
                     ,MAX(c.site_id)       AS site_id
                     ,MAX(c.plant_id)      AS plant_id
                     ,MAX(c.customer_code) AS customer_code
                     ,MAX(c.uom)           AS uom
                     ,MAX(c.created_by)       AS created_by
                     ,MAX(c.creation_date)    AS creation_date
                     ,MAX(c.last_updated_by)  AS last_updated_by
                     ,MAX(c.last_update_date) AS last_update_date
               FROM   scm_dnm_stock_customer_consign c WITH(NOLOCK)
               WHERE  1=1
               GROUp BY c.division_id, c.scm_site_id, c.result_date, c.item_id
              ) cc

	     -- 20181130 소형 대표 ITEM_ID 처리 조정
         LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
         ON   cc.division_id = fi.division_id
         AND  cc.item_id     = fi.item_id 

		 -- - 2021.01.06  C20210105-000744 
         -- 20210618 C20210617-000105 : 소형 제외를 위하여 LEFT JOIN 처리
		 -- 20230224 E20230223-000217 : 자동차/ESS 의 SCM_SITE_ID 도 Lookup 상관없이 Consignment 재고의 Scm Site ID 사용으로 Join 제외
		 --LEFT JOIN   scm_adm_lookup_master_detail md WITH(NOLOCK)
		 --ON     cc.scm_site_id = md.segment2
		 --AND    md.lookup_type = 'VMI_SCM_SITE'
		 --AND    md.valid_yn    = 'Y'
		 
		 ------------------------------
		 -- 20181124 5552(본사매입창고) 재고 추가
		 ------------------------------
		 UNION ALL		 
         SELECT dss.scm_site_id 
		       ,qty2 AS scm_qty
               ,dss.company_id
			   ,dss.division_id
			   ,dss.site_id
			   ,dss.plant_id
			   ,dss.factory_id
			   ,dss.storage_id
			   ,dss.cutoff_date
			   ,dss.seq
			   ,dss.stock_type
	           -- 20181130 소형 대표 ITEM_ID 처리 조정
		       ,[dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id) item_id --2018.06.29
		       ,dss.item_id origin_item_id --2018.06.29
			   ,dss.lane
			   ,dss.production_type
			   ,dss.available_date
			   ,dss.remain_lead_time
			   ,dss.holding_date
			   ,dss.qty
			   ,dss.qty_uom
			   ,dss.stock_status
			   ,dss.operation_id
			   ,dss.operation_id  AS operation_id_org  -- 20210423 C20210422-000470 추가
			   ,dss.line_id
			   ,dss.outsourcing_flag
			   ,dss.outsourcing_factory
			   ,dss.description
			   ,dss.fp_apply_operation_id
			   ,dss.fp_apply_item_id
			   ,dss.fp_apply_wipqty
			   ,dss.wiphold_yn
			   ,'N' qms_hold_yn   -- 20191030  추가 : 5525 창고 Stock 이므로 QMS Hold 없음
			   ,dss.wip_type_code
			   ,dss.qty2
			   ,dss.modify_fp_apply_wipqty
			   ,dss.modify_description
			   ,dss.cal_qty
			   ,dss.formation_rework_type
			   ,dss.insert_id
			   ,dss.insert_time
			   ,dss.update_id
			   ,dss.update_time
			   ,dss.location
			   ,dss.moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
			   ,dss.capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가													
			   ,dss.vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,dss.rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,dss.defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
			   ,null unhold_exp_date -- 20191120 추가
			   ,null mes_map_sloc    -- 20191120 추가
		       ,'N'  mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
		       ,null mes_unhold_date     -- 20200413 MES hold 실제 해제일
		       ,null qms_hold_date       -- 20200413 QMS Hold 일
		       ,null qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
		       ,null qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
		       ,NULL AS location_code   -- 20210618 C20210617-000105 : location_code 정보 추가 : SALES 이므로 NULL 처리
               -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		       ,NULL mes_item_id
		       ,NULL mes_operation_id
		       ,NULL from_sloc_id
		       ,NULL customer_id
		       ,NULL special_stock_indicator
		 FROM   scm_dnm_stock_pur dss WITH(NOLOCK)

	     -- 20181130 소형 대표 ITEM_ID 처리 조정
         LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
         ON   dss.division_id = fi.division_id
         AND  dss.item_id     = fi.item_id 
		 
		 ------------------------------
		 -- 2019.01.09  화면 Upload 재고 추가
		 ------------------------------
		 UNION ALL
		 SELECT so.scm_site_id
		       ,so.qty scm_qty
			   ,s.company_id
			   ,so.division_id
			   ,s.site_id
			   ,s.plant_id
			   ,s.plant_id factory_id
			   -- 20240610 PJ20244573 Stock OSP - 원산지 구분자 추가
			   ,so.attribute1 storage_id
			   --,s.plant_id storage_id
			   ,DATEADD(DAY, 1, CONVERT(DATE, so.yyyymmdd)) cutoff_date -- OSP는 yyyymmdd가 EOH 기준이나 View 의 상단에서 -1일 처리하기 때문에 먼저 +1 함
			   ,null seq
			   ,'UPLOAD' stock_type
	           -- 20181130 소형 대표 ITEM_ID 처리 조정
		       ,[dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, so.item_id) item_id --2018.06.29
		       ,so.item_id origin_item_id --2018.06.29
			   ,null lane
			   ,null production_type
			   ,DATEADD(DAY, 1, CONVERT(DATE, so.yyyymmdd)) available_date -- cutoff_date 와 동일하게 처리
			   ,null remain_lead_time
			   ,null holding_date
			   ,null qty
			   ,'EA' qty_uom
			   ,null stock_status
			   ,null operation_id
			   ,null operation_id_org  -- 20210423 C20210422-000470 추가
			   ,null line_id
			   ,'N' outsourcing_flag
			   ,null outsourcing_factory
			   ,null description
		 	   ,null fp_apply_operation_id
			   ,null fp_apply_item_id
			   ,null fp_apply_wipqty
			   ,'N' wiphold_yn
			   ,'N' qms_hold_yn   -- 20191030  추가
			   ,null wip_type_code
			   ,null qty2
			   ,null modify_fp_apply_wipqty
			   ,null modify_description
			   ,null cal_qty
			   ,null formation_rework_type
			   ,so.created_by        insert_id
			   ,so.creation_date     insert_time
			   ,so.last_updated_by   update_id
			   ,so.last_update_date  update_time
			   ,null location
			   ,null moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
			   ,null capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
			   ,null unhold_exp_date -- 20191120 추가
			   ,null mes_map_sloc    -- 20191120 추가
		       ,'N'  mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
		       ,null mes_unhold_date     -- 20200413 MES hold 실제 해제일
		       ,null qms_hold_date       -- 20200413 QMS Hold 일
		       ,null qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
		       ,null qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
		       ,NULL AS location_code   -- 20210618 C20210617-000105 : location_code 정보 추가 : OSP 이므로 NULL 처리
               -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		       ,NULL mes_item_id
		       ,NULL mes_operation_id
		       ,NULL from_sloc_id
		       ,NULL customer_id
		       ,NULL special_stock_indicator
		 FROM   scm_dnm_stock_osp so WITH(NOLOCK)

	     -- 20181130 소형 대표 ITEM_ID 처리 조정
         LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
         ON   so.division_id = fi.division_id
         AND  so.item_id     = fi.item_id 

	     -- Site
         INNER JOIN scm_mst_site s WITH(NOLOCK)
         ON   so.division_id = s.division_id
         AND  so.scm_site_id = s.scm_site_id 
		 AND  s.valid_yn     = 'Y'

		 -- 20200810 [Packer Visivility] 외주용 재고 조정
		 --  Packer Visivility 대상 Site 제외
         WHERE   1=1
         AND    NOT EXISTS (
                             SELECT *
                             FROM   scm_adm_lookup_master_detail md WITH(NOLOCK) -- 2018. 04.10  Kim Jihye
                             WHERE  md.lookup_type = 'PACKER_SCS'
                             AND    md.valid_yn    = 'Y'  
                             AND    md.segment1    = so.division_id
                             AND    md.segment2    = so.scm_site_id
                           )
		 
		 ------------------------------
		 -- 20200323  [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
		 -- VMI 전진 검사 대기 재고
		 ------------------------------
		 UNION ALL
		 SELECT v.scm_site_id
		       ,v.qty scm_qty
			   ,s.company_id
			   ,v.division_id
			   ,s.site_id
			   ,v.plant_id
			   ,v.plant_id factory_id
			   ,v.storage_id
			   ,DATEADD(DAY, 1, CONVERT(DATE, v.base_date)) cutoff_date -- base_date가 EOH 기준이나 View 의 상단에서 -1일 처리하기 때문에 먼저 +1 함
			   ,null seq
			   ,'VMI_LT' stock_type
	           -- 20181130 소형 대표 ITEM_ID 처리 조정
		       ,[dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, v.item_id) item_id --2018.06.29
		       ,v.item_id origin_item_id --2018.06.29
			   ,null lane
			   ,null production_type
			   
			   -- 입고일자에 보관 LT 추가 : ATA 일자가 없으면 (Base Date+1)로 처리
               , CASE WHEN ISDATE(v.ata_date) = 1 THEN DATEADD(DAY, ISNULL(si.lt_day, 0), CONVERT(DATE, v.ata_date))
                      ELSE DATEADD(DAY, 1, CONVERT(DATE, v.base_date))
                 END  available_date

			   ,ISNULL(si.lt_day, 0) AS remain_lead_time -- VMI 전진 검사 LT
			   
			   -- holding_date : 입고일자로 처리 : ATA 일자가 없으면 (Base Date+1)로 처리
               , CASE WHEN ISDATE(v.ata_date) = 1 THEN CONVERT(DATE, v.ata_date)
                      ELSE DATEADD(DAY, 1, CONVERT(DATE, v.base_date))
                 END  holding_date
			   ,null qty
			   ,'EA' qty_uom
			   ,null stock_status
			   ,null operation_id
			   ,null operation_id_org  -- 20210423 C20210422-000470 추가
			   ,null line_id
			   ,'N' outsourcing_flag
			   ,null outsourcing_factory
			   ,null description
		 	   ,null fp_apply_operation_id
			   ,null fp_apply_item_id
			   ,null fp_apply_wipqty
			   ,'Y' wiphold_yn    -- available_date 가 과거일 경우 Input 생성 시 Plan Name으로 처리
			   ,'N' qms_hold_yn   -- 20191030  추가
			   ,null wip_type_code
			   ,null qty2
			   ,null modify_fp_apply_wipqty
			   ,null modify_description
			   ,null cal_qty
			   ,null formation_rework_type
			   ,v.created_by
			   ,v.creation_date
			   ,v.last_updated_by
			   ,v.last_update_date
			   ,null location
			   ,null moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
			   ,null capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
			   ,null unhold_exp_date -- 20191120 추가
			   ,null mes_map_sloc    -- 20191120 추가
		       ,'N'  mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
		       ,null mes_unhold_date     -- 20200413 MES hold 실제 해제일
		       ,null qms_hold_date       -- 20200413 QMS Hold 일
		       ,null qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
		       ,null qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
		       ,NULL AS location_code   -- 20210618 C20210617-000105 : location_code 정보 추가 : SALES 이므로 NULL 처리
               -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		       ,NULL mes_item_id
		       ,NULL mes_operation_id
		       ,NULL from_sloc_id
		       ,NULL customer_id
		       ,NULL special_stock_indicator
		 FROM   scm_dnm_stock_vmi v WITH(NOLOCK)

         LEFT OUTER JOIN (SELECT division_id, scm_site_id, item_id
                               , MAX(ISNULL(scp_vmi_lt, 0)) AS lt_day
                          FROM   scm_mst_site_item WITH(NOLOCK)
                          WHERE  valid_yn = 'Y' 
                          GROUP BY division_id, scm_site_id, item_id
                         ) si
         ON  v.division_id  = si.division_id
         AND v.scm_site_id  = si.scm_site_id
         AND v.item_id      = si.item_id

	     -- 20181130 소형 대표 ITEM_ID 처리 조정
         LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
         ON   v.division_id = fi.division_id
         AND  v.item_id     = fi.item_id 

	     -- Site
         INNER JOIN scm_mst_site s WITH(NOLOCK)
         ON   v.division_id = s.division_id
         AND  v.scm_site_id = s.scm_site_id 
		 AND  s.valid_yn    = 'Y'

	     -- VMI LT 대상 Site
         INNER JOIN scm_adm_lookup_master_detail l WITH(NOLOCK)
         ON   l.segment1    = s.division_id
         AND  l.segment2    = s.scm_site_id 
		 AND  l.lookup_type = 'VMI_LT_SITE'
		 AND  l.valid_yn    = 'Y'
		 
		 ------------------------------
		 -- 20200810 [Packer Visivility] 외주용 재고 조정
		 ------------------------------
		 UNION ALL
		 SELECT ss.scm_site_id
		       ,ss.stock_qty scm_qty
			   ,s.company_id
			   ,ss.division_id
			   ,s.site_id
			   ,s.plant_id
			   ,s.plant_id  factory_id
			   ,s.plant_id  storage_id
			   ,DATEADD(DAY, 1, CONVERT(DATE, ss.cutoff_date)) cutoff_date -- cutoff_date가 EOH 기준이나 View 의 상단에서 -1일 처리하기 때문에 먼저 +1 함
			   ,null seq
			   ,'PACKER' stock_type
	           -- 20181130 소형 대표 ITEM_ID 처리 조정
		       ,[dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, ss.item_id) item_id --2018.06.29
		       ,ss.item_id origin_item_id --2018.06.29
			   ,null lane
			   ,null production_type			   
               ,DATEADD(DAY, 1, CONVERT(DATE, ss.cutoff_date)) available_date -- cutoff_date 와 동일하게 처리
			   ,null remain_lead_time
               ,null holding_date
			   ,null qty
			   ,'EA' qty_uom
			   ,null stock_status
			   ,null operation_id
			   ,null operation_id_org  -- 20210423 C20210422-000470 추가
			   ,null line_id
			   ,'N' outsourcing_flag
			   ,null outsourcing_factory
			   ,null description
		 	   ,null fp_apply_operation_id
			   ,null fp_apply_item_id
			   ,null fp_apply_wipqty
			   ,'N' wiphold_yn    -- available_date 가 과거일 경우 Input 생성 시 Plan Name으로 처리
			   ,'N' qms_hold_yn   -- 20191030  추가
			   ,null wip_type_code
			   ,null qty2
			   ,null modify_fp_apply_wipqty
			   ,null modify_description
			   ,null cal_qty
			   ,null formation_rework_type
			   ,ss.created_by
			   ,ss.creation_date
			   ,ss.last_updated_by
			   ,ss.last_update_date
			   ,null location
			   ,null moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
			   ,null capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
			   ,null unhold_exp_date -- 20191120 추가
			   ,null mes_map_sloc    -- 20191120 추가
		       ,'N'  mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
		       ,null mes_unhold_date     -- 20200413 MES hold 실제 해제일
		       ,null qms_hold_date       -- 20200413 QMS Hold 일
		       ,null qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
		       ,null qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
		       ,NULL AS location_code    -- 20210618 C20210617-000105 : location_code 정보 추가 : OSP 이므로 NULL 처리
               -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		       ,NULL mes_item_id
		       ,NULL mes_operation_id
		       ,NULL from_sloc_id
		       ,NULL customer_id
		       ,NULL special_stock_indicator
		 FROM   scm_dnm_scs_stock ss WITH(NOLOCK)

	     -- 20181130 소형 대표 ITEM_ID 처리 조정
         LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
         ON   ss.division_id = fi.division_id
         AND  ss.item_id     = fi.item_id 

	     -- Site
         INNER JOIN scm_mst_site s WITH(NOLOCK)
         ON   ss.division_id = s.division_id
         AND  ss.scm_site_id = s.scm_site_id 
		 AND  s.valid_yn    = 'Y'

	     -- Packer Visivility 대상 Site
         INNER JOIN scm_adm_lookup_master_detail l WITH(NOLOCK)
         ON   l.segment1    = s.division_id
         AND  l.segment2    = s.scm_site_id 
		 AND  l.lookup_type = 'PACKER_SCS'
		 AND  l.valid_yn    = 'Y'
		 
		 ------------------------------
		 -- 20221201 PJ20216894 stock_type = 'LOT_CONTROL' 추가
		 ------------------------------
	/*-- 20221215 임시 : PI 요청으로 제외 : START
		 UNION ALL
		 SELECT ss.scm_site_id
		       ,ss.qty scm_qty
			   ,s.company_id
			   ,ss.division_id
			   ,s.site_id
			   ,s.plant_id
			   ,s.plant_id  factory_id
			   ,s.plant_id  storage_id
			   ,DATEADD(DAY, 1, CONVERT(DATE, ss.cutoff_date)) cutoff_date -- cutoff_date가 EOH 기준이나 View 의 상단에서 -1일 처리하기 때문에 먼저 +1 함
			   ,null seq
			   ,'LOT_CONTROL' stock_type
		       ,ss.item_id     item_id --2018.06.29
		       ,ss.org_item_id origin_item_id --2018.06.29
			   ,null lane
			   ,null production_type			   
               ,CONVERT(DATE, ss.hold_end_date) available_date 
			   ,null remain_lead_time
               ,null holding_date
			   ,null qty
			   ,'EA' qty_uom
			   ,null stock_status
			   ,null operation_id
			   ,null operation_id_org  -- 20210423 C20210422-000470 추가
			   ,null line_id
			   ,'N' outsourcing_flag
			   ,null outsourcing_factory
			   ,null description
		 	   ,null fp_apply_operation_id
			   ,null fp_apply_item_id
			   ,null fp_apply_wipqty
			   ,'Y' wiphold_yn    -- available_date 가 과거일 경우 Input 생성 시 Plan Name으로 처리
			   ,'N' qms_hold_yn   -- 20191030  추가
			   ,null wip_type_code
			   ,null qty2
			   ,null modify_fp_apply_wipqty
			   ,null modify_description
			   ,null cal_qty
			   ,null formation_rework_type
			   ,ss.created_by
			   ,ss.creation_date
			   ,ss.last_updated_by
			   ,ss.last_update_date
			   ,null location
			   ,null moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
			   ,null capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
			   ,null defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
			   ,null unhold_exp_date -- 20191120 추가
			   ,null mes_map_sloc    -- 20191120 추가
		       ,'N'  mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
		       ,null mes_unhold_date     -- 20200413 MES hold 실제 해제일
		       ,null qms_hold_date       -- 20200413 QMS Hold 일
		       ,null qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
		       ,null qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
		       ,NULL AS location_code    -- 20210618 C20210617-000105 : location_code 정보 추가 : OSP 이므로 NULL 처리
               -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		       ,NULL mes_item_id
		       ,NULL mes_operation_id
		       ,NULL from_sloc_id
		       ,NULL customer_id
		       ,NULL special_stock_indicator
		 FROM   SCM_DNM_STOCK_LOT_CONTROL ss WITH(NOLOCK)
	     -- Site
         INNER JOIN scm_mst_site s WITH(NOLOCK)
         ON   ss.division_id = s.division_id
         AND  ss.scm_site_id = s.scm_site_id 
		 AND  s.valid_yn    = 'Y'
		 WHERE  1=1
		 AND    ss.DIR              = 'HOLD'
		 AND    ss.hold_start_date <= ss.cutoff_date -- Hold Start 예정일이 cutoff_date 또는 이전인 경우만 대상
	  */ -- 20221215 임시 : PI 요청으로 제외 : END

	--############################################################################################################################################
	-- Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : FP 활성화 재고를 JV에서 ESS로 동기화. ESS 하위 조립품만 추출하여 동기화
	--############################################################################################################################################
		 UNION ALL
		SELECT SM.VP_scm_site_id	AS SCM_SITE_ID
			  ,JV.scm_qty
			  ,SM.VP_company_id		AS COMPANY_ID
			  ,SM.VP_division_id	AS DIVISION_ID
			  ,SM.VP_site_id		AS SITE_ID
			  ,SM.VP_plant_id		AS PLANT_ID
			  ,LM.VL_factory_id		AS FACTORY_ID
			  ,JV.storage_id
			  ,JV.cutoff_date
			  ,JV.seq
			  ,JV.stock_type
			  ,JV.item_id
			  ,JV.origin_item_id
			  ,JV.lane
			  ,JV.production_type
			  ,JV.available_date
			  ,JV.remain_lead_time
			  ,JV.holding_date
			  ,JV.qty
			  ,JV.qty_uom
			  ,JV.stock_status
			  ,JV.operation_id
			  ,JV.operation_id_org
			  ,LM.VL_line_id		AS LINE_ID
			  ,JV.outsourcing_flag
			  ,JV.outsourcing_factory
			  ,JV.description
			  ,JV.fp_apply_operation_id
			  ,JV.fp_apply_item_id
			  ,JV.fp_apply_wipqty
			  ,JV.wiphold_yn
			  ,JV.qms_hold_yn
			  ,JV.wip_type_code
			  ,JV.qty2
			  ,JV.modify_fp_apply_wipqty
			  ,JV.modify_description
			  ,JV.cal_qty
			  ,JV.formation_rework_type
			  ,JV.insert_id
			  ,JV.insert_time
			  ,JV.update_id
			  ,JV.update_time
			  ,JV.location
			  ,JV.moving_qty
			  ,JV.capa_grd_code
			  ,JV.vltg_grd_code
			  ,JV.rsst_grd_code
			  ,JV.defect_qty
			  ,JV.unhold_exp_date
			  ,JV.mes_map_sloc
			  ,JV.mes_hold_yn
			  ,JV.mes_unhold_date
			  ,JV.qms_hold_date
			  ,JV.qms_unhold_exp_date
			  ,JV.qms_unhold_date
			  ,JV.location_code
			  ,JV.mes_item_id
			  ,JV.mes_operation_id
			  ,JV.from_sloc_id
			  ,JV.customer_id
			  ,JV.special_stock_indicator
		 FROM (
				 -------------------------------------------------------------------------------------------------
				 -- Storage 별 일반 재고 (ERP) : for ESS 가상
				 -- Storage 별 일반 재고 (ERP) 쿼리 변경시 아래 쿼리도 함께 수정 필요!!(20251105 현재 동일)
				 -------------------------------------------------------------------------------------------------
				 SELECT 
						CASE WHEN dss.company_id  = 'WA00' AND dss.storage_id = 'Z799' THEN N'Ford_US_RDF'  -- 2025-01-14 kimcd Z799 강제 설정. 임시 사용으로 2025년 1Q 내 소진 예상
							 WHEN ISNULL(dss.special_stock_indicator, '') <> '' THEN NULL  -- 특별재고는 SCP에서 사용 안함
							 WHEN dss.plant_id = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','PLANT')
							  AND dss.storage_id = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','SLOC')
							  AND [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id) 
								= DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','MODEL')
							 THEN [dbo].[FN_SCM_SYS_NVL]([dbo].[FN_SCM_SYS_NVL](site.SCM_SITE_ID, md.segment2), packer.scm_site_id)
							 WHEN dss.plant_id = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','PLANT')
							  AND dss.storage_id = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','SLOC')
							  AND [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id) 
							   <> DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','MODEL')
							 THEN NULL
							 ELSE [dbo].[FN_SCM_SYS_NVL]([dbo].[FN_SCM_SYS_NVL](site.SCM_SITE_ID, md.segment2), packer.scm_site_id)  -- 2018. 05.21  Kim Jihye 외주 Packer 출하 Site 재고 반영
							  END scm_site_id 
					   ,qty2 AS scm_qty
					   ,dss.company_id
					   ,dss.division_id
					   ,dss.site_id
					   ,dss.plant_id
					   ,dss.factory_id
					   ,dss.storage_id
					   ,dss.cutoff_date
					   ,dss.seq
					   ,CASE WHEN ISNULL(dss.special_stock_indicator, '') <> '' THEN dss.stock_type + '_' + dss.special_stock_indicator -- 특별재고
							 ELSE dss.stock_type
						END stock_type 
					   ,[dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id) AS item_id --2018.06.29
					   ,dss.item_id AS origin_item_id --2018.06.29
					   ,dss.lane
					   ,dss.production_type
					   ,CASE WHEN ISNULL(site.location_code, '') = 'CELL_INV_HOLD'                                                                             THEN dss.cutoff_date
							 WHEN ISNULL(wiphold_yn, 'N') = 'N'                                                                                                THEN ISNULL(dss.available_date, DATEADD(DAY, -1, dss.cutoff_date))
							 WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '') = '' AND ISNULL(dss.qms_unhold_exp_date, '') = ''          THEN NULL
							 WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '1999-01-01') >= ISNULL(dss.qms_unhold_exp_date, '1999-01-01') THEN dss.unhold_exp_date
							 WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '1999-01-01') <  ISNULL(dss.qms_unhold_exp_date, '1999-01-01') THEN dss.qms_unhold_exp_date
							 ELSE dss.available_date
						END available_date  

					   ,dss.remain_lead_time
					   ,dss.holding_date
					   ,dss.qty
					   ,dss.qty_uom
					   ,dss.stock_status
					   ,dss.operation_id
					   ,dss.operation_id  AS operation_id_org  -- 20210423 C20210422-000470 추가
					   ,dss.line_id
					   ,dss.outsourcing_flag
					   ,dss.outsourcing_factory
					   ,dss.description
					   ,dss.fp_apply_operation_id
					   ,dss.fp_apply_item_id
					   ,dss.fp_apply_wipqty
					   -- 20230405 E20230327-000191 'INVENTORY' 재고 중 CELL_INV_HOLD Location 인 경우 전부 HOLD 로 처리, 최종 cutoff_date 다음 일자에 가용으로 처리
					   ,CASE WHEN ISNULL(site.location_code, '') = 'CELL_INV_HOLD'  THEN 'Y'
							 ELSE dss.wiphold_yn
						END wiphold_yn
					   ,dss.qms_hold_yn   -- 20191030  추가
					   ,dss.wip_type_code
					   ,dss.qty2
					   ,dss.modify_fp_apply_wipqty
					   ,dss.modify_description
					   ,dss.cal_qty
					   ,dss.formation_rework_type
					   ,dss.insert_id
					   ,dss.insert_time
					   ,dss.update_id
					   ,dss.update_time
					   ,dss.location
					   ,dss.moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
					   ,dss.capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
					   ,dss.vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
					   ,dss.rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
					   ,ISNULL(dss.defect_qty, 0) + ISNULL(dss.restrict_qty, 0) AS defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
					   ,dss.unhold_exp_date -- 20191120 추가
					   ,dss.mes_map_sloc    -- 20191120 추가
					   ,dss.mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
					   ,dss.mes_unhold_date     -- 20200413 MES hold 실제 해제일
					   ,dss.qms_hold_date       -- 20200413 QMS Hold 일
					   ,dss.qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
					   ,dss.qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
					   ,[dbo].[FN_SCM_SYS_NVL](site.location_code, NULL) AS location_code 
					   ,dss.mes_item_id
					   ,dss.mes_operation_id
					   ,dss.from_sloc_id
					   ,dss.customer_id
					   ,dss.special_stock_indicator
				 FROM   scm_dnm_stock_sn dss WITH(NOLOCK)

				 -- 20181130 소형 대표 ITEM_ID 처리 조정
				 LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
				 ON   dss.division_id = fi.division_id
				 AND  dss.item_id     = fi.item_id 

				 LEFT JOIN (SELECT DISTINCT ms.company_id
								  ,ms.division_id
								  ,ms.site_id
								  ,ml.factory_id
								  ,ml.plant_id
								  ,ml.storage_id
								  ,ms.scm_site_id
								  ,ml.location_code -- 20210611  PJ20209642 추가
								  ,CASE ml.location_code WHEN 'CELL_OWMS' THEN 'A'
														 WHEN 'PACK_OWMS' THEN 'P'
														 ELSE '%' END operation_group -- 2018.10.01
							FROM   scm_mst_site ms WITH(NOLOCK)
							JOIN   scm_mst_location ml WITH(NOLOCK)
							ON     ms.division_id = ml.division_id
							AND    ms.scm_site_id = ml.scm_site_id
							WHERE  ms.valid_yn    = 'Y'
							AND    ml.valid_yn    = 'Y'
							AND    ISNULL(ml.storage_id, '') <> '' -- 20210611  PJ20209642 추가
							AND   (ml.location_code NOT IN ('CELL_OWMS', 'PACK_OWMS')
								   OR (    ml.plant_id   = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','PLANT')
									   AND ml.storage_id = DBO.FN_GET_LOOKUP_VALUE('SCM_DNM_STOCK_V','SLOC')
									  )
								  )
							AND    ms.vmi_yn = CASE ms.division_id WHEN '40' THEN 'N' -- 2018.09.10
																   -- PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : 자동차 사업부 VMI사이트도 재고 사용
																   -- WHEN '81' THEN 'N' -- 2018.10.05
																   ELSE ms.vmi_yn 
																   END 
							) site
				 -- 20251024 YMH E20251021-000664 계획수립 주초재고 VMI 재고 설정 문의/누락 방지 관련 Company 관계 없이 반영하도록 로직 수정
				 ON     1 = 1 --dss.company_id	= [dbo].[FN_SCM_SYS_NVL](site.company_id, dss.company_id) -- 2018. 04.27  Kim Jihye
				 AND    dss.division_id = site.division_id
				 AND    dss.site_id		= [dbo].[FN_SCM_SYS_NVL](site.site_id, dss.site_id) -- 2018. 04.27  Kim Jihye
				 AND    dss.plant_id	= site.plant_id 
				 AND    dss.storage_id	= site.storage_id		 
				 -- 20181130 소형 대표 ITEM_ID 처리 조정
				 AND    dbo.fn_get_item_operation_group(dss.division_id, [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id)) LIKE site.operation_group -- 2018.10.01
				 -- 20210611 PJ20209642 'PANCAKE_INV' Location에 존재하는 Cell Item 재고는 제외함
				 AND    'Y' = CASE WHEN site.location_code = 'PANCAKE_INV' AND fi.operation_group = 'A' THEN 'N'
								   ELSE 'Y'
							  END 

				 LEFT JOIN scm_adm_lookup_master_detail md WITH(NOLOCK) -- 2018. 04.10  Kim Jihye
				 ON     dss.plant_id    = md.segment1
				 AND    dss.storage_id  = md.segment3
				 AND    dbo.fn_get_item_operation_group(dss.division_id, dss.item_id) = 'E'
				 AND    md.lookup_type  = 'ELECTRODE_SHIP_SITE'
				 AND    md.valid_yn     = 'Y'  

				 -- 2018.05.21  Kim Jihye 외주 Packer 출하 Site 재고 반영
				 -- 2018.08.10  Kim Jihye 외주 Packer Site 재고 로직 변경
				 LEFT JOIN (SELECT ip.division_id
								  ,os.plant_id
								  ,os.scm_site_id
								  ,os.storage_id
								  ,ip.item_id
								  ,ip.from_yyyymmdd
								  ,ip.to_yyyymmdd
							FROM   scm_mst_osp_sloc os WITH(NOLOCK)
							JOIN   scm_mst_site_item_priority ip WITH(NOLOCK)					
							ON     os.division_id = ip.division_id
							AND    os.scm_site_id = ip.plant_site_id
							WHERE  os.valid_yn = 'Y'					
							AND    ip.valid_yn = 'Y'
						  ) packer
				 ON     dss.division_id = packer.division_id
				 AND    dss.plant_id    = packer.plant_id
				 AND    dss.storage_id  = packer.storage_id		
				 -- 20181130 소형 대표 ITEM_ID 처리 조정 
				 AND    [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id) = packer.item_id
				 AND    (dss.cutoff_date BETWEEN packer.from_yyyymmdd AND packer.to_yyyymmdd)

				 WHERE  dss.stock_type	= 'INVENTORY'
				 AND    dss.plant_id  NOT IN (SELECT DISTINCT plant_id
											  FROM   scm_mst_plant_sn WITH(NOLOCK)
											  WHERE  ISNULL(plant_type, 'Z') = 'SVC'
											 )
		 
				 -------------------------------------------------------------------------------------------------
				 -- Storage 별 일반 재고 (ERP) : for ESS 가상
				 -- WIP 재고 (MES) 쿼리 변경시 아래 쿼리도 함께 수정 필요!!(20251105 현재 동일)
				 -------------------------------------------------------------------------------------------------
				 UNION ALL
				 SELECT 
						CASE WHEN dss.stock_status = 'MOVING' AND dbo.fn_get_item_operation_group(dss.division_id, [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.fp_apply_item_id)) = 'E'
								  THEN ms.scm_site_id
							 WHEN dss.division_id IN ('40') AND sl.scm_site_id IS NOT NULL AND sl.location_code = 'CELL_OWMS'
								  THEN NULL
							 WHEN sl.scm_site_id IS NOT NULL -- 20210128 PJ20209642 mes_map_sloc 컬럼의 정보를 사용하여 PACK_OWMS/CELL_OWMS Location 정보와 비교하여 Scm Site ID Mapping
								  THEN sl.scm_site_id
							 WHEN md2.segment2 IS NULL    -- Lookup에 등록되지 않은 Operation : 일반적인 경우
								  THEN site.scm_site_id
							 WHEN md.segment2 IS NOT NULL -- Lookup에 등록된 Operation / mes_map_sloc
								  THEN site.scm_site_id
							 ELSE NULL                    -- Lookup에 등록된 Operation / 등록되지 않은 mes_map_sloc : 재고로 잡지 않음
						END  scm_site_id 
					   ,dss.fp_apply_wipqty AS scm_qty
					   ,dss.company_id
					   ,dss.division_id
					   ,dss.site_id
					   ,dss.plant_id
					   ,dss.factory_id
					   ,dss.storage_id
					   ,dss.cutoff_date
					   ,dss.seq
					   ,dss.stock_type
					   ,[dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.fp_apply_item_id) AS item_id
					   ,dss.fp_apply_item_id AS origin_item_id
					   ,dss.lane
					   ,dss.production_type
					   ,CASE WHEN ISNULL(wiphold_yn, 'N') = 'N'                                                                                                THEN ISNULL(dss.available_date, DATEADD(DAY, -1, dss.cutoff_date))
							 WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '') = '' AND ISNULL(dss.qms_unhold_exp_date, '') = ''          THEN NULL
							 WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '1999-01-01') >= ISNULL(dss.qms_unhold_exp_date, '1999-01-01') THEN dss.unhold_exp_date
							 WHEN ISNULL(wiphold_yn, 'N') = 'Y' AND ISNULL(dss.unhold_exp_date, '1999-01-01') <  ISNULL(dss.qms_unhold_exp_date, '1999-01-01') THEN dss.qms_unhold_exp_date
							 ELSE dss.available_date
						END available_date  

					   ,dss.remain_lead_time
					   ,dss.holding_date
					   ,dss.qty
					   ,dss.qty_uom
					   ,dss.stock_status
					   ,dss.fp_apply_operation_id AS operation_id
					   ,dss.operation_id          AS operation_id_org  -- 20210423 C20210422-000470 추가
					   ,dss.line_id
					   ,dss.outsourcing_flag
					   ,dss.outsourcing_factory
					   ,dss.description
					   ,dss.fp_apply_operation_id
					   ,dss.fp_apply_item_id
					   ,dss.fp_apply_wipqty
					   ,dss.wiphold_yn
					   ,dss.qms_hold_yn   -- 20191030  추가
					   ,dss.wip_type_code
					   ,dss.qty2
					   ,dss.modify_fp_apply_wipqty
					   ,dss.modify_description
					   ,dss.cal_qty
					   ,dss.formation_rework_type
					   ,dss.insert_id
					   ,dss.insert_time
					   ,dss.update_id
					   ,dss.update_time
					   ,dss.location
					   ,dss.moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
					   ,dss.capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
					   ,dss.vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
					   ,dss.rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
					   ,ISNULL(dss.defect_qty, 0) + ISNULL(dss.restrict_qty, 0) AS defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
					   ,dss.unhold_exp_date -- 20191120 추가
					   ,dss.mes_map_sloc    -- 20191120 추가
					   ,dss.mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
					   ,dss.mes_unhold_date     -- 20200413 MES hold 실제 해제일
					   ,dss.qms_hold_date       -- 20200413 QMS Hold 일
					   ,dss.qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
					   ,dss.qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
					   ,CASE WHEN dss.stock_status = 'MOVING' AND dbo.fn_get_item_operation_group(dss.division_id, [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.fp_apply_item_id)) = 'E'
								  AND ms.operation_group = 'E'
								  THEN 'SLITTING'
							 WHEN sl.scm_site_id IS NOT NULL -- 20210128 PJ20209642 mes_map_sloc 컬럼의 정보를 사용하여 PACK_OWMS/CELL_OWMS Location 정보와 비교하여 Scm Site ID Mapping
								  THEN sl.location_code
							 WHEN md2.segment2 IS NULL    -- Lookup에 등록되지 않은 Operation : 일반적인 경우
								  THEN site.location_code
							 WHEN md.segment2 IS NOT NULL -- Lookup에 등록된 Operation / mes_map_sloc
								  THEN site.location_code
							 ELSE NULL                    -- Lookup에 등록된 Operation / 등록되지 않은 mes_map_sloc : 재고로 잡지 않음
						END  location_code 
					   ,dss.mes_item_id
					   ,dss.mes_operation_id
					   ,dss.from_sloc_id
					   ,dss.customer_id
					   ,dss.special_stock_indicator
				 FROM   scm_dnm_stock_sn dss WITH(NOLOCK)
				 -- 20181130 소형 대표 ITEM_ID 처리 조정
				 LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
				 ON   dss.division_id      = fi.division_id
				 AND  dss.fp_apply_item_id = fi.item_id  -- 20200909 C20200909-000178 stock_type= 'WIP' 인 경우 fp apply 정보로 변경 old) dss.item_id
				 LEFT JOIN (SELECT DISTINCT ms.company_id
								  ,ms.division_id
								  ,ms.site_id
								  ,ml.factory_id
								  ,ms.plant_id
								  ,ml.operation_id
								  ,ms.scm_site_id
								  ,ml.location_code
							FROM   scm_mst_site ms WITH(NOLOCK)
							JOIN   scm_mst_location ml WITH(NOLOCK)
							ON     ms.division_id = ml.division_id
							AND    ms.scm_site_id = ml.scm_site_id
							WHERE  ms.valid_yn    = 'Y'
							AND    ml.valid_yn    = 'Y'
						   ) site
				 ON     dss.company_id	= site.company_id
				 AND    dss.division_id	= site.division_id
				 AND    dss.site_id		= site.site_id
				 AND    dss.plant_id	= site.plant_id
				 AND    dss.factory_id	= site.factory_id
				 AND    dss.fp_apply_operation_id = site.operation_id  -- 20200909 C20200909-000178 stock_type= 'WIP' 인 경우 fp apply 정보로 변경 old) dss.operation_id

				 LEFT JOIN scm_mst_site ms WITH(NOLOCK)
				 ON     dss.division_id = ms.division_id
				 AND    dss.plant_id = ms.plant_id
				 AND    ms.site_type = 'PLANT'
				 AND    ms.valid_yn = 'Y'
				 AND    ms.operation_group IN ('E')

				 -- 20200406 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 : Hold 재고
				 -- Lookup에 등록된 Operation / mes_map_sloc / Plant / Factory 확인용
				 LEFT JOIN (SELECT DISTINCT segment2, segment3, segment4, segment5
							FROM   scm_adm_lookup_master_detail WITH(NOLOCK)
							WHERE  lookup_type = 'WIP_MES_MAP_SLOC'
							AND    segment1    = 'WIP'
							AND    valid_yn    = 'Y'
						  ) md
				 ON     dss.fp_apply_operation_id = md.segment2  -- 20200909 C20200909-000178 stock_type= 'WIP' 인 경우 fp apply 정보로 변경 old) dss.operation_id
				 AND    dss.mes_map_sloc = md.segment3
				 AND    dss.plant_id     = md.segment4
				 AND    dss.factory_id   = md.segment5

				 -- Lookup에 등록된 Operation / Plant / Factory 확인용
				 LEFT JOIN (SELECT DISTINCT segment2, segment4, segment5
							FROM   scm_adm_lookup_master_detail WITH(NOLOCK)
							WHERE  lookup_type = 'WIP_MES_MAP_SLOC'
							AND    segment1    = 'WIP'
							AND    valid_yn    = 'Y'
						  ) md2
				 ON     dss.fp_apply_operation_id = md2.segment2  -- 20200909 C20200909-000178 stock_type= 'WIP' 인 경우 fp apply 정보로 변경 old) dss.operation_id
				 AND    dss.plant_id     = md2.segment4
				 AND    dss.factory_id   = md2.segment5
		 
				 -- 20210128 PJ20209642 'WIP' : 
				 -- mes_map_sloc 컬럼의 정보를 사용하여 PACK_OWMS/CELL_OWMS Location 정보와 비교하여 Scm Site ID Mapping
				 LEFT JOIN (SELECT DISTINCT ms.company_id
								  ,ms.division_id
								  ,ms.site_id
								  ,ml.factory_id
								  ,ml.plant_id
								  ,ml.storage_id
								  ,ms.scm_site_id
								  ,ml.location_code
								  ,CASE ml.location_code WHEN 'CELL_OWMS' THEN 'A'
														 WHEN 'PACK_OWMS' THEN 'P'
														 ELSE '%' END operation_group -- 2018.10.01
							FROM   scm_mst_site ms WITH(NOLOCK)
							JOIN   scm_mst_location ml WITH(NOLOCK)
							ON     ms.division_id = ml.division_id
							AND    ms.scm_site_id = ml.scm_site_id
							WHERE  ms.valid_yn    = 'Y'
							AND    ml.valid_yn    = 'Y'
							-- 'WIP' 에서 PACK_OWMS/CELL_OWMS Location에 해당하는 정보 Site Mapping
							AND    ml.location_code IN ('CELL_OWMS', 'PACK_OWMS')
							AND    ms.vmi_yn = CASE ms.division_id WHEN '40' THEN 'N' -- 2018.09.10
																   -- PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : 자동차 사업부 VMI사이트도 재고 사용
																   -- WHEN '81' THEN 'N' -- 2018.10.05
																   ELSE ms.vmi_yn 
																   END 
							) sl
				 ON     dss.company_id	 = [dbo].[FN_SCM_SYS_NVL](sl.company_id, dss.company_id) -- 2018. 04.27  Kim Jihye
				 AND    dss.division_id  = sl.division_id
				 AND    dss.site_id		 = [dbo].[FN_SCM_SYS_NVL](sl.site_id, dss.site_id) -- 2018. 04.27  Kim Jihye
				 AND    dss.plant_id	 = sl.plant_id 
				 -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가 : from_sloc_id 가 존재하는 경우 from_sloc_id 로 비교
				 AND    CASE WHEN ISNULL(dss.from_sloc_id, '') <> '' THEN dss.from_sloc_id
							 ELSE dss.mes_map_sloc 
						END = sl.storage_id		 
				 -- 20181130 소형 대표 ITEM_ID 처리 조정
				 AND    dbo.fn_get_item_operation_group(dss.division_id, [dbo].[FN_SCM_SYS_NVL](fi.packer_plan_item_id, dss.item_id)) LIKE sl.operation_group -- 2018.10.01

				 WHERE  dss.stock_type	= 'WIP'

			) JV 
			INNER JOIN JV_REAL_ESS_VIRTUAL_SITE_MAP SM
					ON SM.RP_COMPANY_ID		= JV.COMPANY_ID
				   AND SM.RP_DIVISION_ID	= JV.DIVISION_ID
				   AND SM.RP_SITE_ID		= JV.SITE_ID
				   AND SM.RP_PLANT_ID		= JV.PLANT_ID
				   AND SM.RP_SCM_SITE_ID	= JV.SCM_SITE_ID
			LEFT  JOIN JV_REAL_ESS_VIRTUAL_LINE_MAP LM
					ON LM.RL_COMPANY_ID		= JV.COMPANY_ID
				   AND LM.RL_DIVISION_ID	= JV.DIVISION_ID
				   AND LM.RL_SITE_ID		= JV.SITE_ID
				   AND LM.RL_PLANT_ID		= JV.PLANT_ID
				   AND LM.RL_FACTORY_ID		= JV.FACTORY_ID
				   AND LM.RL_LINE_ID		= JV.LINE_ID
		WHERE 1=1 
	--############################################################################################################################################
	-- End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : FP 활성화 재고를 JV에서 ESS로 동기화. ESS 하위 조립품만 추출하여 동기화
	--############################################################################################################################################

) STOCK
	-- HM JV 가상 사업부 추가 대응
	INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
			ON DM.DIVISION_ID = STOCK.DIVISION_ID
		   AND DM.VALID_YN    = 'Y'

	-- Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환
	LEFT  JOIN  SCP_EXC_ITEM_ASSY_MAP EX
			ON EX.COMPANY_ID		= STOCK.COMPANY_ID
		   AND EX.DIVISION_ID		= STOCK.DIVISION_ID
		   AND EX.SITE_ID			= STOCK.SITE_ID
		   AND EX.PLANT_ID			= STOCK.PLANT_ID
		   AND EX.SCP_EXC_ITEM_ID	= STOCK.ITEM_ID
	-- End   : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환

WHERE   1=1
------------------------------
-- 20200323  [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
-- Lookup('VMI_LT_SITE') 에 등록된 Site는'VMI_LT' 재고 외 다른 재고 사용 안 함
------------------------------
AND    (STOCK.stock_type = 'VMI_LT'
OR      NOT EXISTS (
                    SELECT *
                    FROM   scm_adm_lookup_master_detail md WITH(NOLOCK) -- 2018. 04.10  Kim Jihye
                    WHERE  md.lookup_type = 'VMI_LT_SITE'
                    AND    md.valid_yn    = 'Y'  
                    AND    md.segment1    = STOCK.division_id
                    AND    md.segment2    = ISNULL(STOCK.scm_site_id,'')
                   )
       )

-- 20181130 소형 대표 ITEM_ID 처리 조정
--LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
--ON   stock.division_id = fi.division_id
--AND  stock.item_id     = fi.item_id 

