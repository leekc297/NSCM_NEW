



CREATE VIEW [dbo].[SCM_DNM_STOCK_WIP_HOLD_V_0908_ORG] AS
/*
 * Program ID   : SCM_DNM_STOCK_WIP_HOLD_V
 * Description  : 보류재고 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 2. 01  Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.10.30   KSG            WIP 재고에 QMS Holh 구분자 추가    
 *                                         wiphold_yn  qms_hold_yn
 *                             MES 홀드    Y           N
 *                             QMS 홀드    Y           Y
 *                             홀드 아님   N           N
 * 2020.04.06   KSG            [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 : Hold 재고
 *
 */
SELECT	 STOCK.SCM_SITE_ID
		,STOCK.company_id
		,STOCK.division_id
		,STOCK.site_id
		,STOCK.plant_id
		,STOCK.factory_id
		,STOCK.storage_id
		,DATEADD(DAY,-1,STOCK.cutoff_date) cutoff_date
		,STOCK.seq
		,STOCK.stock_type
		,STOCK.item_id
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
		,STOCK.wiphold_yn
		,STOCK.qms_hold_yn -- 20191030  추가
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
		,STOCK.unhold_exp_date -- 20191120 추가 MES Hold 해제 예정일
		,STOCK.mes_map_sloc    -- 20191120 추가 MES에 연계된 ERP 창고
		
		,STOCK.mes_hold_yn         -- 20200406 MES 내부적으로 Hold 여부 관리
		,STOCK.mes_unhold_date     -- 20200406 MES hold 실제 해제일
		,STOCK.qms_hold_date       -- 20200406 QMS Hold 일
		,STOCK.qms_unhold_exp_date -- 20200406 QMS Hold 해제 예정일
		,STOCK.qms_unhold_date     -- 20200406 QMS Hold 실제 해제일

FROM    (SELECT	dbo.FN_GET_SCM_SITE_ID_PLANT(dss.PLANT_ID,dbo.FN_GET_ITEM_OPERATION_GROUP(dss.DIVISION_ID,dss.ITEM_ID)) AS SCM_SITE_ID
               ,dss.*
		 FROM   scm_dnm_stock_sn dss WITH(NOLOCK)
		 WHERE  dss.stock_type   = 'WIP'
		 AND	dss.wiphold_yn   = 'Y'
		) STOCK
			   
