

CREATE VIEW [dbo].[IF_FP_SCM_STOCK_V] AS
-- ================================================================================================
-- Program ID          : IF_FP_SCM_STOCK_V
--
-- Program Name        : IF_FP_SCM_STOCK_V Pancake PSI 형성용 SCP 반영 재고 조합
-- Param               :
-- Batch Period        : 
-- Description         : SCM의 SCM_DNM_STOCK_V 기반으로 사내 재고만 취합. WIP-MES 재고 전체와 SCP에 반영되는 
--                       ERP Inventory 정보 추출. Pancake의 PSI에 반영
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2019.08.30
-- Author              : kim choon dong
-- Version             : 2019-06-21 kimcd SCP에 적용되는 ERP 재고(단 공정 창고는 제외) + MES 재고
--                       2019-07-05 kimcd 창고 대상에서 scm_mst_location.location_code PANCAKE_INV 값으로 한정
--                       2019-08-30 kimcd ISNULL(dss.modify_fp_apply_wipqty,dss.qty2) scm qty를 수정 - 수정 재고 반영 요청에 따라
--                       2022-05-31 kimcd SCM_DNM_STOCK_V 와 동기화
-- ================================================================================================
SELECT   STOCK.scm_site_id 
		,STOCK.company_id
		,STOCK.division_id
		,STOCK.site_id
		,STOCK.plant_id
		,STOCK.factory_id
		,STOCK.storage_id
		,STOCK.cutoff_date 
		,STOCK.seq
		,STOCK.stock_type
		,STOCK.item_id
		,ISNULL(STOCK.scm_qty, 0) + ISNULL(STOCK.moving_qty, 0) + ISNULL(STOCK.defect_qty, 0) scm_qty -- 2018.08.07 이동중 재고(moving_qty) 추가, 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
		,ISNULL(STOCK.scm_qty, 0) /*+ ISNULL(STOCK.moving_qty, 0) 2022-05-31 kimcd 이동 중 수량 제거 */        ssp_qty -- 2019.01.15 SSP용 재고 컬럼 추가 : ERP 보류 재고 제외
		,STOCK.lane
		,STOCK.production_type
		,STOCK.available_date
		,STOCK.remain_lead_time
		,STOCK.holding_date
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
		,[LGCE_SCMDEV].[DBO].[FN_SCM_SYS_NVL](STOCK.wiphold_yn, 'N') wiphold_yn -- 2018. 05.11  Kim Jihye
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
		,STOCK.defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
FROM   ( ------------------------------
		 -- Storage 별 일반 재고 (ERP)
		 ------------------------------
		 SELECT [LGCE_SCMDEV].[DBO].[FN_SCM_SYS_NVL](site.SCM_SITE_ID, md.segment2)  AS SCM_SITE_ID
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
		       ,dss.item_id
			   ,dss.lane
			   ,dss.production_type
			   ,dss.available_date
			   ,dss.remain_lead_time
			   ,dss.holding_date
			   ,dss.qty
			   ,dss.qty_uom
			   ,dss.stock_status
			   ,dss.operation_id
			   ,dss.line_id
			   ,dss.outsourcing_flag
			   ,dss.outsourcing_factory
			   ,dss.description
			   ,dss.fp_apply_operation_id
			   ,dss.fp_apply_item_id
			   ,dss.fp_apply_wipqty
			   ,dss.wiphold_yn
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
		 FROM   DBO.SCM_STOCK_H dss WITH(NOLOCK)
		 LEFT JOIN (SELECT DISTINCT ms.company_id
						  ,ms.division_id
						  ,ms.site_id
						  ,ml.factory_id
						  ,ml.plant_id
						  ,ml.storage_id
						  ,ms.scm_site_id
						  ,ml.location_code -- 2019-07-05 kimcd 창고 대상에서 scm_mst_location.location_code PANCAKE_INV 값으로 한정
						  ,CASE ml.location_code WHEN 'CELL_OWMS' THEN 'A'
						                         WHEN 'PACK_OWMS' THEN 'P'
												 ELSE '%' END operation_group -- 2018.10.01
				    FROM   [LGCE_SCMDEV].[DBO].scm_mst_site ms WITH(NOLOCK)
				    JOIN   [LGCE_SCMDEV].[DBO].scm_mst_location ml WITH(NOLOCK)
				    ON     ms.division_id = ml.division_id
				    AND    ms.scm_site_id = ml.scm_site_id
				    WHERE  ms.valid_yn    = 'Y'
				    AND    ml.valid_yn    = 'Y'
					AND    ms.vmi_yn = CASE ms.division_id WHEN '40' THEN 'N' -- 2018.09.10
					                                       --WHEN '81' THEN 'N'  2022-05-31 kimcd SCM_DNM_STOCK_V와 동기화 -- 2018.10.05
														   ELSE ms.vmi_yn 
														   END 
					) site
		 ON     dss.company_id	= [LGCE_SCMDEV].[DBO].[FN_SCM_SYS_NVL](site.company_id, dss.company_id) -- 2018. 04.27  Kim Jihye
		 AND    dss.division_id = site.division_id
		 AND    dss.site_id		= [LGCE_SCMDEV].[DBO].[FN_SCM_SYS_NVL](site.site_id, dss.site_id) -- 2018. 04.27  Kim Jihye
		 AND    dss.plant_id	= site.plant_id
		 AND    dss.storage_id	= site.storage_id		 
		 AND    [LGCE_SCMDEV].[DBO].fn_get_item_operation_group(dss.division_id, dss.item_id) LIKE site.operation_group -- 2018.10.01
		 LEFT JOIN [LGCE_SCMDEV].[DBO].scm_adm_lookup_master_detail md WITH(NOLOCK) -- 2018. 04.10  Kim Jihye
		 ON     dss.plant_id    = md.segment1
		 AND    dss.storage_id  = md.segment3
		 AND    [LGCE_SCMDEV].dbo.fn_get_item_operation_group(dss.division_id, dss.item_id) = 'E'
		 AND    md.lookup_type  = 'ELECTRODE_SHIP_SITE'
		 AND    md.valid_yn     = 'Y'  
		 WHERE  dss.stock_type	= 'INVENTORY'
		 AND    dss.FACTORY_ID  = '-'   -- kimcd 공정 창고 제거
		 AND    [LGCE_SCMDEV].[DBO].[FN_SCM_SYS_NVL](site.SCM_SITE_ID, md.segment2) IS NOT NULL -- SCP Site로 반영
		 AND    site.location_code = 'PANCAKE_INV' -- 2019-07-05 kimcd 창고 대상에서 scm_mst_location.location_code PANCAKE_INV 값으로 한정
		 ------------------------------
		 -- WIP 재고 (MES)
		 ------------------------------
		 UNION ALL
		 SELECT  NULL AS scm_site_id
		       ,ISNULL(dss.modify_fp_apply_wipqty,dss.qty2) scm_qty -- 2019-08-30 kimcd 수정 재고 우선 반영 from 장현석
		       ,dss.company_id
			   ,dss.division_id
			   ,dss.site_id
			   ,dss.plant_id
			   ,dss.factory_id
			   ,dss.storage_id
			   ,dss.cutoff_date
			   ,dss.seq
			   ,dss.stock_type
		       ,dss.item_id
			   ,dss.lane
			   ,dss.production_type
			   ,dss.available_date
			   ,dss.remain_lead_time
			   ,dss.holding_date
			   ,dss.qty
			   ,dss.qty_uom
			   ,dss.stock_status
			   ,dss.operation_id
			   ,dss.line_id
			   ,dss.outsourcing_flag
			   ,dss.outsourcing_factory
			   ,dss.description
			   ,dss.fp_apply_operation_id
			   ,dss.fp_apply_item_id
			   ,dss.fp_apply_wipqty
			   ,dss.wiphold_yn
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
		 FROM   scm_stock_h dss WITH(NOLOCK)
		 WHERE  dss.stock_type	= 'WIP'
) STOCK

