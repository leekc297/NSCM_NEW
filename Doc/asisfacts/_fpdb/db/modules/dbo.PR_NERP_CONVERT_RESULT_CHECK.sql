-- =============================================
-- Author:		 chkim.68
-- Create date:  2024-02-08
-- Description: NERP를 위해 기존 룩업 테이블에 NERP 대상 데이터를 일괄 업데이트
-- 기존 룩업 데이터에 NERP의 데이터값을 추가
-- 변환 결과 확인
-- =============================================
create PROCEDURE [dbo].[PR_NERP_CONVERT_RESULT_CHECK]
AS
BEGIN
	-- Result Check Batch 
-- company_id
select count(*),'EXC_ITEM_LINE_ASSIGN_ERP','COMPANY_ID' from EXC_ITEM_LINE_ASSIGN_ERP A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_ADDITIONAL_DEMAND_DETAIL_M','COMPANY_ID' from FP_ADDITIONAL_DEMAND_DETAIL_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AGING_STOCK_TO_PLAN_PEGGING_R','COMPANY_ID' from FP_AGING_STOCK_TO_PLAN_PEGGING_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_CUTOFF_BOH_H','COMPANY_ID' from FP_AMEND_CUTOFF_BOH_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_CUTOFF_BOH_R','COMPANY_ID' from FP_AMEND_CUTOFF_BOH_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_BOH_H','COMPANY_ID' from FP_AMEND_DAILY_BOH_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_BOH_R','COMPANY_ID' from FP_AMEND_DAILY_BOH_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_BOR_H','COMPANY_ID' from FP_AMEND_DAILY_BOR_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_BOR_R','COMPANY_ID' from FP_AMEND_DAILY_BOR_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_CAPA_H','COMPANY_ID' from FP_AMEND_DAILY_CAPA_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_CAPA_R','COMPANY_ID' from FP_AMEND_DAILY_CAPA_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_PLAN_H','COMPANY_ID' from FP_AMEND_DAILY_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_PLAN_R','COMPANY_ID' from FP_AMEND_DAILY_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_SALES_H','COMPANY_ID' from FP_AMEND_DAILY_SALES_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_SALES_PMIX_H','COMPANY_ID' from FP_AMEND_DAILY_SALES_PMIX_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_SALES_PMIX_R','COMPANY_ID' from FP_AMEND_DAILY_SALES_PMIX_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_SALES_R','COMPANY_ID' from FP_AMEND_DAILY_SALES_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_UTIL_H','COMPANY_ID' from FP_AMEND_DAILY_UTIL_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_UTIL_R','COMPANY_ID' from FP_AMEND_DAILY_UTIL_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_ELEC_TO_ASSY_PLAN_R','COMPANY_ID' from FP_AMEND_ELEC_TO_ASSY_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_FORM_LEAD_TIME_M','COMPANY_ID' from FP_AMEND_FORM_LEAD_TIME_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_IN_LEAD_TIME_R','COMPANY_ID' from FP_AMEND_IN_LEAD_TIME_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_LOB_PLAN_R','COMPANY_ID' from FP_AMEND_LOB_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_LOB_PSI_CATEGORY_R','COMPANY_ID' from FP_AMEND_LOB_PSI_CATEGORY_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_LOB_PSI_H','COMPANY_ID' from FP_AMEND_LOB_PSI_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_LOB_PSI_R','COMPANY_ID' from FP_AMEND_LOB_PSI_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_LOB_PSI_ROLLBACK_R','COMPANY_ID' from FP_AMEND_LOB_PSI_ROLLBACK_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_MEMO_M','COMPANY_ID' from FP_AMEND_MEMO_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --

select count(*),'FP_AMEND_PLAN_CELL_BOR_H','COMPANY_ID' from FP_AMEND_PLAN_CELL_BOR_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_CELL_BOR_R','COMPANY_ID' from FP_AMEND_PLAN_CELL_BOR_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_CELL_H','COMPANY_ID' from FP_AMEND_PLAN_CELL_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_CELL_R','COMPANY_ID' from FP_AMEND_PLAN_CELL_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_CELL_SALES_H','COMPANY_ID' from FP_AMEND_PLAN_CELL_SALES_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_CELL_SALES_R','COMPANY_ID' from FP_AMEND_PLAN_CELL_SALES_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_CELL_UTIL_H','COMPANY_ID' from FP_AMEND_PLAN_CELL_UTIL_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_CELL_UTIL_R','COMPANY_ID' from FP_AMEND_PLAN_CELL_UTIL_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_FORM_H','COMPANY_ID' from FP_AMEND_PLAN_FORM_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_FORM_R','COMPANY_ID' from FP_AMEND_PLAN_FORM_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_FORM_ROLLBACK_R','COMPANY_ID' from FP_AMEND_PLAN_FORM_ROLLBACK_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_FORM_UTIL_H','COMPANY_ID' from FP_AMEND_PLAN_FORM_UTIL_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_FORM_UTIL_R','COMPANY_ID' from FP_AMEND_PLAN_FORM_UTIL_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_P_FORM_BOH_R','COMPANY_ID' from FP_AMEND_PLAN_P_FORM_BOH_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_P_FORM_R','COMPANY_ID' from FP_AMEND_PLAN_P_FORM_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_BOR_H','COMPANY_ID' from FP_AMEND_PLAN_PACK_BOR_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_BOR_R','COMPANY_ID' from FP_AMEND_PLAN_PACK_BOR_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_H','COMPANY_ID' from FP_AMEND_PLAN_PACK_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_R','COMPANY_ID' from FP_AMEND_PLAN_PACK_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_SALES_H','COMPANY_ID' from FP_AMEND_PLAN_PACK_SALES_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_SALES_R','COMPANY_ID' from FP_AMEND_PLAN_PACK_SALES_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_UTIL_H','COMPANY_ID' from FP_AMEND_PLAN_PACK_UTIL_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_UTIL_R','COMPANY_ID' from FP_AMEND_PLAN_PACK_UTIL_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_POST_BOR_R','COMPANY_ID' from FP_AMEND_PLAN_POST_BOR_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_POST_CAPA_R','COMPANY_ID' from FP_AMEND_PLAN_POST_CAPA_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_POST_FORM_R','COMPANY_ID' from FP_AMEND_PLAN_POST_FORM_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_POST_FORM_ROLLBACK_R','COMPANY_ID' from FP_AMEND_PLAN_POST_FORM_ROLLBACK_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_POST_H','COMPANY_ID' from FP_AMEND_PLAN_POST_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_POST_R','COMPANY_ID' from FP_AMEND_PLAN_POST_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_POST_UTIL_R','COMPANY_ID' from FP_AMEND_PLAN_POST_UTIL_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_R','COMPANY_ID' from FP_AMEND_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_SETUP_COLOR_M','COMPANY_ID' from FP_AMEND_SETUP_COLOR_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_SIM_CELL_PACK_H','COMPANY_ID' from FP_AMEND_SIM_CELL_PACK_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_SIM_CELL_PACK_R','COMPANY_ID' from FP_AMEND_SIM_CELL_PACK_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_ASSIGN_ASSY_ELECTRODE_R','COMPANY_ID' from FP_ASSIGN_ASSY_ELECTRODE_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --

select count(*),'FP_CELL_DELIVERY_PLAN_FIX_H','COMPANY_ID' from FP_CELL_DELIVERY_PLAN_FIX_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_CELL_DELIVERY_PLAN_H','COMPANY_ID' from FP_CELL_DELIVERY_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_CELL_INHOUSE_PLAN_H','COMPANY_ID' from FP_CELL_INHOUSE_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_CELL_MOVE_PLAN_H','COMPANY_ID' from FP_CELL_MOVE_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_CELL_MOVE_PLAN_MES_SEND_H','COMPANY_ID' from FP_CELL_MOVE_PLAN_MES_SEND_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_DEMAND_INSTANCE_PLAN_H','COMPANY_ID' from FP_DAILY_DEMAND_INSTANCE_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_DEMAND_INSTANCE_PLAN_H','COMPANY_ID' from FP_DAILY_DEMAND_INSTANCE_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_DEMAND_OFFSET_H','COMPANY_ID' from FP_DAILY_DEMAND_OFFSET_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_DEMAND_PMIX_PLAN_H','COMPANY_ID' from FP_DAILY_DEMAND_PMIX_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_DEMAND_PMIX_PLAN_H','COMPANY_ID' from FP_DAILY_DEMAND_PMIX_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_DEMAND_SHIPMENT_ELEC_H','COMPANY_ID' from FP_DAILY_DEMAND_SHIPMENT_ELEC_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_DEMAND_SHIPMENT_ELEC_H','COMPANY_ID' from FP_DAILY_DEMAND_SHIPMENT_ELEC_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_INSTANCE_DEMAND_H','COMPANY_ID' from FP_DAILY_INSTANCE_DEMAND_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_INSTANCE_DEMAND_H','COMPANY_ID' from FP_DAILY_INSTANCE_DEMAND_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_INSTANCE_ORDER_STATUS','COMPANY_ID' from FP_DAILY_INSTANCE_ORDER_STATUS A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_INSTANCE_STOCK_H','COMPANY_ID' from FP_DAILY_INSTANCE_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_NET_DEMAND_H','COMPANY_ID' from FP_DAILY_NET_DEMAND_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_NET_DEMAND_H','COMPANY_ID' from FP_DAILY_NET_DEMAND_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_PRODUCTIOIN_PLAN_H','COMPANY_ID' from FP_DAILY_PRODUCTIOIN_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_PRODUCTIOIN_PLAN_H_KIMCD_1027','COMPANY_ID' from FP_DAILY_PRODUCTIOIN_PLAN_H_KIMCD_1027 A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_PRODUCTION_PLAN_CUTOFF_H','COMPANY_ID' from FP_DAILY_PRODUCTION_PLAN_CUTOFF_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_PRODUCTION_PLAN_DW_H','COMPANY_ID' from FP_DAILY_PRODUCTION_PLAN_DW_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_PRODUCTION_PLAN_R','COMPANY_ID' from FP_DAILY_PRODUCTION_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_PRODUCTION_PLAN_ROLLBACK_R','COMPANY_ID' from FP_DAILY_PRODUCTION_PLAN_ROLLBACK_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_PRODUCTION_PLAN_WORKER_R','COMPANY_ID' from FP_DAILY_PRODUCTION_PLAN_WORKER_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_SHIFT_PROD_PLAN_H','COMPANY_ID' from FP_DAILY_SHIFT_PROD_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DEMAND_FULFILLMENT_R','COMPANY_ID' from FP_DEMAND_FULFILLMENT_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DEMAND_PACK_REQUIRE_CELL_H','COMPANY_ID' from FP_DEMAND_PACK_REQUIRE_CELL_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_DEMAND_PACK_REQUIRE_FIX','COMPANY_ID' from FP_DEMAND_PACK_REQUIRE_FIX A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --


select count(*),'FP_ELECTRODE_POST_PLAN_H','COMPANY_ID' from FP_ELECTRODE_POST_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_ERP_PRODUCTION_PLAN_H','COMPANY_ID' from FP_ERP_PRODUCTION_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_ERP_PRODUCTION_PLAN_H','COMPANY_ID' from FP_ERP_PRODUCTION_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_ERP_PRODUCTION_PLAN_M','COMPANY_ID' from FP_ERP_PRODUCTION_PLAN_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_ERP_PRODUCTION_PLAN_M','COMPANY_ID' from FP_ERP_PRODUCTION_PLAN_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_ERP_WORK_ORDER_STATUS_H','COMPANY_ID' from FP_ERP_WORK_ORDER_STATUS_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_FORM_IN_LINE_M','COMPANY_ID' from FP_FORM_IN_LINE_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_FORM_SHIPMENT_PSI_UI','COMPANY_ID' from FP_FORM_SHIPMENT_PSI_UI A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_FORM_TRAY_ASSIGN_UI','COMPANY_ID' from FP_FORM_TRAY_ASSIGN_UI A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_FORMATION_PSI_UI','COMPANY_ID' from FP_FORMATION_PSI_UI A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_FORMATION_SHORTER_LT_M','COMPANY_ID' from FP_FORMATION_SHORTER_LT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_INHOUSE_REQUEST_BOH_R','COMPANY_ID' from FP_INHOUSE_REQUEST_BOH_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_ITEM_CELL_EXCHANGE_M','COMPANY_ID' from FP_ITEM_CELL_EXCHANGE_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_ITEM_EQUIP_RESULT_HIS','COMPANY_ID' from FP_ITEM_EQUIP_RESULT_HIS A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_KPI_DAILY_PRODUCTION_PLAN_H','COMPANY_ID' from FP_KPI_DAILY_PRODUCTION_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_KPI_RAW_DATA_R','COMPANY_ID' from FP_KPI_RAW_DATA_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_KPI_RESULT_R','COMPANY_ID' from FP_KPI_RESULT_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_LINE_BOM_PRIORITY_M','COMPANY_ID' from FP_LINE_BOM_PRIORITY_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_LOSS_H','COMPANY_ID' from FP_LOSS_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MANUAL_WORK_ORDER_H','COMPANY_ID' from FP_MANUAL_WORK_ORDER_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MASTER_VALIDATION_H','COMPANY_ID' from FP_MASTER_VALIDATION_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MATERIAL_PLAN_R','COMPANY_ID' from FP_MATERIAL_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MES_CELL_SHIPMENT_H','COMPANY_ID' from FP_MES_CELL_SHIPMENT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MES_PRODUCTION_PLAN_M','COMPANY_ID' from FP_MES_PRODUCTION_PLAN_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MES_PRODUCTION_PLAN_M','COMPANY_ID' from FP_MES_PRODUCTION_PLAN_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MES_WORK_ORDER_STATUS_H','COMPANY_ID' from FP_MES_WORK_ORDER_STATUS_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MODEL_LOT_M','COMPANY_ID' from FP_MODEL_LOT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MODEL_LOT_M_20230804','COMPANY_ID' from FP_MODEL_LOT_M_20230804 A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MODEL_LOT_M_20240308','COMPANY_ID' from FP_MODEL_LOT_M_20240308 A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MOVE_PLAN_R','COMPANY_ID' from FP_MOVE_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MPP_WPP_BASE_PLAN_H','COMPANY_ID' from FP_MPP_WPP_BASE_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MPP_WPP_BASE_PLAN_M','COMPANY_ID' from FP_MPP_WPP_BASE_PLAN_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MRP_BOM_PRIORITY_M','COMPANY_ID' from FP_MRP_BOM_PRIORITY_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MRP_CUTOFF_SUPPLY_H','COMPANY_ID' from FP_MRP_CUTOFF_SUPPLY_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_MRP_INTRANSIT_H','COMPANY_ID' from FP_MRP_INTRANSIT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --


select count(*),'FP_NEW_PLANED_ORDER_R','COMPANY_ID' from FP_NEW_PLANED_ORDER_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_ORDER_PEGGING_R','COMPANY_ID' from FP_ORDER_PEGGING_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_ORDER_TRACKING_DEMEND_R','COMPANY_ID' from FP_ORDER_TRACKING_DEMEND_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_ORDER_TRACKING_R','COMPANY_ID' from FP_ORDER_TRACKING_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_ORDER_TRACKING_WO_R','COMPANY_ID' from FP_ORDER_TRACKING_WO_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_ORDER_TRACKING_WO_R_ORG','COMPANY_ID' from FP_ORDER_TRACKING_WO_R_ORG A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_OS_REPORT_R','COMPANY_ID' from FP_OS_REPORT_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PACK_ALT_MATERIAL_DEFINIT','COMPANY_ID' from FP_PACK_ALT_MATERIAL_DEFINIT A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PACK_ALT_MATERIAL_ITEM','COMPANY_ID' from FP_PACK_ALT_MATERIAL_ITEM A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PACK_NEW_ALT_ID','COMPANY_ID' from FP_PACK_NEW_ALT_ID A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PANCAKE_INVENTORY_BALANCE_M_R','COMPANY_ID' from FP_PANCAKE_INVENTORY_BALANCE_M_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PANCAKE_INVENTORY_BALANCE_S_R','COMPANY_ID' from FP_PANCAKE_INVENTORY_BALANCE_S_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PANCAKE_SHIPMENT_PLAN_R','COMPANY_ID' from FP_PANCAKE_SHIPMENT_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PDS_VERSION_M','COMPANY_ID' from FP_PDS_VERSION_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PLAN_BOM_EXCEPT_H','COMPANY_ID' from FP_PLAN_BOM_EXCEPT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PLAN_BOM_M','COMPANY_ID' from FP_PLAN_BOM_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PLAN_FORM_ADDITIONAL_INFO','COMPANY_ID' from FP_PLAN_FORM_ADDITIONAL_INFO A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PLAN_GROUP_M','COMPANY_ID' from FP_PLAN_GROUP_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PLAN_UTILIZATION_R','COMPANY_ID' from FP_PLAN_UTILIZATION_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --

select count(*),'FP_PROBLEM_REPORT_R','COMPANY_ID' from FP_PROBLEM_REPORT_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PROD_VERSION_APPLY_DATE_M','COMPANY_ID' from FP_PROD_VERSION_APPLY_DATE_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PROD_VERSION_M','COMPANY_ID' from FP_PROD_VERSION_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_BATCH_H','COMPANY_ID' from FP_PRODUCTION_PLAN_BATCH_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_CHANGE_R','COMPANY_ID' from FP_PRODUCTION_PLAN_CHANGE_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_CHANGE_R','COMPANY_ID' from FP_PRODUCTION_PLAN_CHANGE_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R','COMPANY_ID' from FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R','COMPANY_ID' from FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_EQUIPMENT_EPOST_R','COMPANY_ID' from FP_PRODUCTION_PLAN_EQUIPMENT_EPOST_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_EQUIPMENT_R','COMPANY_ID' from FP_PRODUCTION_PLAN_EQUIPMENT_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_EQUIPMENT_R','COMPANY_ID' from FP_PRODUCTION_PLAN_EQUIPMENT_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_FACTORY_R','COMPANY_ID' from FP_PRODUCTION_PLAN_FACTORY_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_FACTORY_R','COMPANY_ID' from FP_PRODUCTION_PLAN_FACTORY_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_GROUP_R','COMPANY_ID' from FP_PRODUCTION_PLAN_GROUP_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_GROUP_R','COMPANY_ID' from FP_PRODUCTION_PLAN_GROUP_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_PACKER_R','COMPANY_ID' from FP_PRODUCTION_PLAN_PACKER_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_R','COMPANY_ID' from FP_PRODUCTION_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_R','COMPANY_ID' from FP_PRODUCTION_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_PSI_R','COMPANY_ID' from FP_PSI_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_RESULT_TACT_H','COMPANY_ID' from FP_RESULT_TACT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_SCM_IN_TRANSIT_H','COMPANY_ID' from FP_SCM_IN_TRANSIT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_SCM_IN_TRANSIT_H','COMPANY_ID' from FP_SCM_IN_TRANSIT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_SCM_IN_TRANSIT_H','COMPANY_ID' from FP_SCM_IN_TRANSIT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_SCP_CHANGE_MEMO_M','COMPANY_ID' from FP_SCP_CHANGE_MEMO_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_SHIPMENT_PLAN_H','COMPANY_ID' from FP_SHIPMENT_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_SHIPMENT_PLAN_H','COMPANY_ID' from FP_SHIPMENT_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_SHIPMENT_PLAN_WPP_H','COMPANY_ID' from FP_SHIPMENT_PLAN_WPP_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_SHIPMENT_PLAN_WPP_H','COMPANY_ID' from FP_SHIPMENT_PLAN_WPP_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_SIM_MATERIAL_PACK_H','COMPANY_ID' from FP_SIM_MATERIAL_PACK_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_SIM_MATERIAL_PACK_R','COMPANY_ID' from FP_SIM_MATERIAL_PACK_R A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_SSP_STOCK_BACKUP_H','COMPANY_ID' from FP_SSP_STOCK_BACKUP_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_USER_LINE_GROUP_M','COMPANY_ID' from FP_USER_LINE_GROUP_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_DETAIL_H','COMPANY_ID' from FP_WEEKLY_DEMAND_DETAIL_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_DETAIL_H','COMPANY_ID' from FP_WEEKLY_DEMAND_DETAIL_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H','COMPANY_ID' from FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_PRODUCT_H','COMPANY_ID' from FP_WEEKLY_DEMAND_PRODUCT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_PRODUCT_MOBILE_COATER_H','COMPANY_ID' from FP_WEEKLY_DEMAND_PRODUCT_MOBILE_COATER_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_PRODUCT_MOBILE_H','COMPANY_ID' from FP_WEEKLY_DEMAND_PRODUCT_MOBILE_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_PRODUCT_PDS_H','COMPANY_ID' from FP_WEEKLY_DEMAND_PRODUCT_PDS_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_PRODUCT_SRS_H','COMPANY_ID' from FP_WEEKLY_DEMAND_PRODUCT_SRS_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_PRODUCT_TEST_H','COMPANY_ID' from FP_WEEKLY_DEMAND_PRODUCT_TEST_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H','COMPANY_ID' from FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H','COMPANY_ID' from FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H','COMPANY_ID' from FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_SHIPMENT_H','COMPANY_ID' from FP_WEEKLY_DEMAND_SHIPMENT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_SHIPMENT_H','COMPANY_ID' from FP_WEEKLY_DEMAND_SHIPMENT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_SHIPMENT_SCP_H','COMPANY_ID' from FP_WEEKLY_DEMAND_SHIPMENT_SCP_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_SHIPMENT_SCP_H','COMPANY_ID' from FP_WEEKLY_DEMAND_SHIPMENT_SCP_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_AGING_ITEM_FLOW_M','COMPANY_ID' from SCM_AGING_ITEM_FLOW_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_AGING_STOCK_H','COMPANY_ID' from SCM_AGING_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_AGING_STOCK_H_20231104','COMPANY_ID' from SCM_AGING_STOCK_H_20231104 A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_AGING_STOCK_HOLD_M','COMPANY_ID' from SCM_AGING_STOCK_HOLD_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_AGING_TRAY_STOCK_H','COMPANY_ID' from SCM_AGING_TRAY_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_AGING_TRAY_STOCK_H_20231104','COMPANY_ID' from SCM_AGING_TRAY_STOCK_H_20231104 A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_AS_MATERIAL_DOCUMENT_H','COMPANY_ID' from SCM_AS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_AS_MATERIAL_DOCUMENT_H','COMPANY_ID' from SCM_AS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_AS_MATERIAL_DOCUMENT_H','COMPANY_ID' from SCM_AS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_AS_MATERIAL_DOCUMENT_H','COMPANY_ID' from SCM_AS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_BASE_STOCK_H','COMPANY_ID' from SCM_BASE_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_BATCH_M','COMPANY_ID' from SCM_BATCH_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_BOD_EXCEPT_M','COMPANY_ID' from SCM_BOD_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_BOD_M','COMPANY_ID' from SCM_BOD_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_BOD_PATTERN_M','COMPANY_ID' from SCM_BOD_PATTERN_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_BOM_FOR_RES_SHARE_M','COMPANY_ID' from SCM_BOM_FOR_RES_SHARE_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_BOM_M','COMPANY_ID' from SCM_BOM_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_CAPA_MAIL_SEND_H','COMPANY_ID' from SCM_CAPA_MAIL_SEND_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --

select count(*),'SCM_COMPANY_M','COMPANY_ID' from SCM_COMPANY_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_COMPANY_M','COMPANY_NAME' from SCM_COMPANY_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_NAME = B.OLD_VALUE1 --
select count(*),'SCM_DAILY_CAPACITY_EXCEPT_M','COMPANY_ID' from SCM_DAILY_CAPACITY_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_DAILY_CAPACITY_M','COMPANY_ID' from SCM_DAILY_CAPACITY_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_DAILY_PRODUCT_RESULT_H','COMPANY_ID' from SCM_DAILY_PRODUCT_RESULT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_DEMAND_INFO_H','COMPANY_ID' from SCM_DEMAND_INFO_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_DIVISION_M','COMPANY_ID' from SCM_DIVISION_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_DW_SHIPPING_H','COMPANY_ID' from SCM_DW_SHIPPING_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_EQUIPMENT_EXCEPT_M','COMPANY_ID' from SCM_EQUIPMENT_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_EQUIPMENT_M','COMPANY_ID' from SCM_EQUIPMENT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_FACTORY_CALENDAR_M','COMPANY_ID' from SCM_FACTORY_CALENDAR_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_FACTORY_M','COMPANY_ID' from SCM_FACTORY_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_FACTORY_M','COMPANY_ID' from SCM_FACTORY_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_MATERIAL_DOCUMENT_H','COMPANY_ID' from SCM_FCS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_MATERIAL_DOCUMENT_H','COMPANY_ID' from SCM_FCS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_MATERIAL_DOCUMENT_H','COMPANY_ID' from SCM_FCS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_MATERIAL_DOCUMENT_H','COMPANY_ID' from SCM_FCS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_TRAY_M','COMPANY_ID' from SCM_FCS_TRAY_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_TRAY_MODEL_M','COMPANY_ID' from SCM_FCS_TRAY_MODEL_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_FORMATION_YIELD_M','COMPANY_ID' from SCM_FORMATION_YIELD_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --

select count(*),'SCM_GROUP_CELL_M','COMPANY_ID' from SCM_GROUP_CELL_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_INTRANSIT_H','COMPANY_ID' from SCM_INTRANSIT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_INTRANSIT_H','COMPANY_ID' from SCM_INTRANSIT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_INTRANSIT_H','COMPANY_ID' from SCM_INTRANSIT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_BOD_EXCEPT_M','COMPANY_ID' from SCM_ITEM_BOD_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_BOD_M','COMPANY_ID' from SCM_ITEM_BOD_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_CONV_CALC_M','COMPANY_ID' from SCM_ITEM_CONV_CALC_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_CONV_CALC_USE_M','COMPANY_ID' from SCM_ITEM_CONV_CALC_USE_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_EQUIP_RATE_BATCH_M','COMPANY_ID' from SCM_ITEM_EQUIP_RATE_BATCH_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_EQUIPMENT_ASSIGN_EXCEPT_M','COMPANY_ID' from SCM_ITEM_EQUIPMENT_ASSIGN_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_FLOW_EXCEPT_M','COMPANY_ID' from SCM_ITEM_FLOW_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_FLOW_M','COMPANY_ID' from SCM_ITEM_FLOW_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_FOIL_M','COMPANY_ID' from SCM_ITEM_FOIL_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LANE_EXCEPT_M','COMPANY_ID' from SCM_ITEM_LANE_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LANE_M','COMPANY_ID' from SCM_ITEM_LANE_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LINE_ASSIGN_ERP','COMPANY_ID' from SCM_ITEM_LINE_ASSIGN_ERP A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LINE_ASSIGN_EXCEPT_M','COMPANY_ID' from SCM_ITEM_LINE_ASSIGN_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LINE_ASSIGN_EXCEPT_UI_M','COMPANY_ID' from SCM_ITEM_LINE_ASSIGN_EXCEPT_UI_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LINE_ASSIGN_M','COMPANY_ID' from SCM_ITEM_LINE_ASSIGN_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LINE_ASSIGN_UI_M','COMPANY_ID' from SCM_ITEM_LINE_ASSIGN_UI_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LINE_ASSIGN_VER_H','COMPANY_ID' from SCM_ITEM_LINE_ASSIGN_VER_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_M','COMPANY_ID' from SCM_ITEM_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_M_BACKUP','COMPANY_ID' from SCM_ITEM_M_BACKUP A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_SETUP_GROUP_M','COMPANY_ID' from SCM_ITEM_SETUP_GROUP_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_SETUP_GROUP_M_FOOTPRINT_BK','COMPANY_ID' from SCM_ITEM_SETUP_GROUP_M_FOOTPRINT_BK A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_LINE_ASSIGN_EXCT_VER_H','COMPANY_ID' from SCM_LINE_ASSIGN_EXCT_VER_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_LINE_CALENDAR_M','COMPANY_ID' from SCM_LINE_CALENDAR_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_LINE_LOSS_M','COMPANY_ID' from SCM_LINE_LOSS_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_LINE_M','COMPANY_ID' from SCM_LINE_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_LINE_SETUP_GROUP_M','COMPANY_ID' from SCM_LINE_SETUP_GROUP_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_LOSS_CALENDAR_M','COMPANY_ID' from SCM_LOSS_CALENDAR_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_LOSS_M','COMPANY_ID' from SCM_LOSS_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_LOSS_REPORT_VER_H','COMPANY_ID' from SCM_LOSS_REPORT_VER_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_LOSS_VER_H','COMPANY_ID' from SCM_LOSS_VER_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --

select count(*),'SCM_MASTER_MANAGER_M','COMPANY_ID' from SCM_MASTER_MANAGER_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MASTER_MANAGER_VER_H','COMPANY_ID' from SCM_MASTER_MANAGER_VER_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MATERIAL_GR_PLAN_H','COMPANY_ID' from SCM_MATERIAL_GR_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MATERIAL_RATIO_M','COMPANY_ID' from SCM_MATERIAL_RATIO_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MES_RT_STOCK_H','COMPANY_ID' from SCM_MES_RT_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MMD_ITEM_ROUTE_TEMP','COMPANY_ID' from SCM_MMD_ITEM_ROUTE_TEMP A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MMD_ITEM_ROUTE_TEMP','COMPANY_ID' from SCM_MMD_ITEM_ROUTE_TEMP A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MMD_ITEM_ROUTE_TEMP','COMPANY_ID' from SCM_MMD_ITEM_ROUTE_TEMP A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MMD_LINE_M','COMPANY_ID' from SCM_MMD_LINE_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --




select count(*),'SCM_MMD_ROUTEPATH_M','COMPANY_ID' from SCM_MMD_ROUTEPATH_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MMD_SHIPTO_M','SHIPTO_COMPANY_CODE' from SCM_MMD_SHIPTO_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.SHIPTO_COMPANY_CODE = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_BOM_M','COMPANY_ID' from SCM_MODEL_BOM_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP','COMPANY_ID' from SCM_MODEL_COMP A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_EFFECTIVE_DATE','CHILD_COMPANY_ID' from SCM_MODEL_COMP_EFFECTIVE_DATE A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.CHILD_COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_EFFECTIVE_DATE','CHILD_COMPANY_ID' from SCM_MODEL_COMP_EFFECTIVE_DATE A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.CHILD_COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_EFFECTIVE_DATE','COMPANY_ID' from SCM_MODEL_COMP_EFFECTIVE_DATE A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_EFFECTIVE_DATE','COMPANY_ID' from SCM_MODEL_COMP_EFFECTIVE_DATE A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_TEMP','CHILD_COMPANY_ID' from SCM_MODEL_COMP_TEMP A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.CHILD_COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_TEMP','CHILD_COMPANY_ID' from SCM_MODEL_COMP_TEMP A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.CHILD_COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_TEMP','COMPANY_ID' from SCM_MODEL_COMP_TEMP A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_TEMP','COMPANY_ID' from SCM_MODEL_COMP_TEMP A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_M','COMPANY_ID' from SCM_MODEL_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_MARKET_M','COMPANY_ID' from SCM_MODEL_MARKET_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_MODEL_TEMP','COMPANY_ID' from SCM_MODEL_MODEL_TEMP A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_ROUTING_M','COMPANY_ID' from SCM_MODEL_ROUTING_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_OFF_CALENDAR_LINE_M','COMPANY_ID' from SCM_OFF_CALENDAR_LINE_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_OFF_CALENDAR_M','COMPANY_ID' from SCM_OFF_CALENDAR_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_OFF_CATEGORY_M','COMPANY_ID' from SCM_OFF_CATEGORY_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_OFF_PATTERN_M','COMPANY_ID' from SCM_OFF_PATTERN_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_OFF_TYPE_M','COMPANY_ID' from SCM_OFF_TYPE_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_OPERATION_FLOW_M','COMPANY_ID' from SCM_OPERATION_FLOW_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_OPERATION_M','COMPANY_ID' from SCM_OPERATION_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_OPERATION_MOVE_M','COMPANY_ID' from SCM_OPERATION_MOVE_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ORDER_STATUS_H','COMPANY_ID' from SCM_ORDER_STATUS_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_PACK_WORKER_LIMIT_M','COMPANY_ID' from SCM_PACK_WORKER_LIMIT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_PACK_WORKER_M','COMPANY_ID' from SCM_PACK_WORKER_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_PACKER_PO_H','COMPANY_ID' from SCM_PACKER_PO_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_PACKER_PROD_RESULT_H','COMPANY_ID' from SCM_PACKER_PROD_RESULT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_PLANT_M','COMPANY_ID' from SCM_PLANT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_PLANT_M','COMPANY_ID' from SCM_PLANT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_PLANT_M','COMPANY_ID' from SCM_PLANT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_PLM_WO_TACT_TIME_M','COMPANY_ID' from SCM_PLM_WO_TACT_TIME_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_PRODUCT_RESULT_H','COMPANY_ID' from SCM_PRODUCT_RESULT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_PSEUDO_DIVISION_M','COMPANY_ID' from SCM_PSEUDO_DIVISION_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_ROLL_WAREHOUSE_M','COMPANY_ID' from SCM_ROLL_WAREHOUSE_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_SETUP_CONDITION_M','COMPANY_ID' from SCM_SETUP_CONDITION_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_SETUP_CONDITION_M_FOOTPRINT_BK','COMPANY_ID' from SCM_SETUP_CONDITION_M_FOOTPRINT_BK A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_SETUP_MATRIX_M','COMPANY_ID' from SCM_SETUP_MATRIX_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_SETUP_MATRIX_M_FOOTPRINT_BK','COMPANY_ID' from SCM_SETUP_MATRIX_M_FOOTPRINT_BK A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_SHIPMENT_M','COMPANY_ID' from SCM_SHIPMENT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_SHIPMENT_M','COMPANY_ID' from SCM_SHIPMENT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_SHIPPING_RESULT_H','COMPANY_ID' from SCM_SHIPPING_RESULT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_SHIPPING_RESULT_H','COMPANY_ID' from SCM_SHIPPING_RESULT_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_SHOP_M','COMPANY_ID' from SCM_SHOP_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_SITE_M','COMPANY_ID' from SCM_SITE_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_SLOC_M','COMPANY_ID' from SCM_SLOC_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_SLOC_M','COMPANY_ID' from SCM_SLOC_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_SLURRY_RATE_H','COMPANY_ID' from SCM_SLURRY_RATE_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_SLURRY_SOLID_RATE','COMPANY_ID' from SCM_SLURRY_SOLID_RATE A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_STOCK_H','COMPANY_ID' from SCM_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_STOCK_H','COMPANY_ID' from SCM_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_STOCK_H_TEMP','COMPANY_ID' from SCM_STOCK_H_TEMP A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --


select count(*),'SCM_TACT_TIME_EXCEPT_M','COMPANY_ID' from SCM_TACT_TIME_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_TACT_TIME_EXCEPT_UI_M','COMPANY_ID' from SCM_TACT_TIME_EXCEPT_UI_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_TACT_TIME_EXCT_VER_H','COMPANY_ID' from SCM_TACT_TIME_EXCT_VER_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_TACT_TIME_M','COMPANY_ID' from SCM_TACT_TIME_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_TACT_TIME_UI_M','COMPANY_ID' from SCM_TACT_TIME_UI_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_TACT_TIME_VER_H','COMPANY_ID' from SCM_TACT_TIME_VER_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_UTILIZATION_EXCEPT_M','COMPANY_ID' from SCM_UTILIZATION_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_UTILIZATION_M','COMPANY_ID' from SCM_UTILIZATION_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_WIP_LEVEL_CELL_M','COMPANY_ID' from SCM_WIP_LEVEL_CELL_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_WORK_CAL_VER_H','COMPANY_ID' from SCM_WORK_CAL_VER_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_WORK_CALENDAR_M','COMPANY_ID' from SCM_WORK_CALENDAR_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_WORK_CENTER_M','COMPANY_ID' from SCM_WORK_CENTER_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_WORK_TYPE_M','COMPANY_ID' from SCM_WORK_TYPE_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_WORK_TYPE_OFF_M','COMPANY_ID' from SCM_WORK_TYPE_OFF_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_YIELD_EXCEPT_M','COMPANY_ID' from SCM_YIELD_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_YIELD_EXCEPT_UI_M','COMPANY_ID' from SCM_YIELD_EXCEPT_UI_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_YIELD_EXCT_VER_H','COMPANY_ID' from SCM_YIELD_EXCT_VER_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_YIELD_M','COMPANY_ID' from SCM_YIELD_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_YIELD_UI_M','COMPANY_ID' from SCM_YIELD_UI_M A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'SCM_YIELD_VER_H','COMPANY_ID' from SCM_YIELD_VER_H A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'TH_MST_INSTANCE_FLOW_POST','COMPANY_ID' from TH_MST_INSTANCE_FLOW_POST A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'TH_MST_INSTANCE_LINE_POST','COMPANY_ID' from TH_MST_INSTANCE_LINE_POST A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'TH_MST_SCM_ORDER_STATUS_POST','COMPANY_ID' from TH_MST_SCM_ORDER_STATUS_POST A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'TH_UIS_MENU','COMPANY' from TH_UIS_MENU A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY = B.OLD_VALUE1 --
select count(*),'TH_UIS_MENU_FILTER','COMPANY' from TH_UIS_MENU_FILTER A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY = B.OLD_VALUE1 --
select count(*),'TH_UIS_MY_MENU','COMPANY' from TH_UIS_MY_MENU A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY = B.OLD_VALUE1 --
select count(*),'TH_UIS_PAGE_INFO','COMPANY' from TH_UIS_PAGE_INFO A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY = B.OLD_VALUE1 --
select count(*),'TH_UIS_ROLE_FACTORY_RELATE','COMPANY_ID' from TH_UIS_ROLE_FACTORY_RELATE A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'TH_UIS_ROLE_INSTANCE_RELATE','COMPANY_ID' from TH_UIS_ROLE_INSTANCE_RELATE A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'TH_UIS_SHOP_GROUP','COMPANY' from TH_UIS_SHOP_GROUP A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY = B.OLD_VALUE1 --
select count(*),'TH_UIS_SHOP_GROUP_SHOP_RELATE','COMPANY' from TH_UIS_SHOP_GROUP_SHOP_RELATE A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY = B.OLD_VALUE1 --
select count(*),'TH_UIS_TRAN_LOG','COMPANY' from TH_UIS_TRAN_LOG A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY = B.OLD_VALUE1 --
select count(*),'TH_UIS_TREE','COMPANY' from TH_UIS_TREE A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY = B.OLD_VALUE1 --
select count(*),'TH_UIS_USER_AMEND_RELATE','COMPANY_ID' from TH_UIS_USER_AMEND_RELATE A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY_ID = B.OLD_VALUE1 --
select count(*),'TH_UIS_USER_DETAIL','COMPANY' from TH_UIS_USER_DETAIL A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY = B.OLD_VALUE1 --
select count(*),'TH_UIS_USER_DETAIL_HIS','COMPANY' from TH_UIS_USER_DETAIL_HIS A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY = B.OLD_VALUE1 --
select count(*),'TH_UIS_USER_LOG','COMPANY' from TH_UIS_USER_LOG A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY = B.OLD_VALUE1 --
select count(*),'TH_UIS_USER_SHOP_GROUP_RELATE','COMPANY' from TH_UIS_USER_SHOP_GROUP_RELATE A,   (select * from NERP_CONV_MASTER where codetype='company_id' and ATTRIBUTE5='1st') B   where A.COMPANY = B.OLD_VALUE1 --

-- plant_id

select count(*),'EXC_ITEM_LINE_ASSIGN_ERP','PLANT_ID' from EXC_ITEM_LINE_ASSIGN_ERP A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_ADDITIONAL_DEMAND_DETAIL_M','PLANT_ID' from FP_ADDITIONAL_DEMAND_DETAIL_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AGING_STOCK_TO_PLAN_PEGGING_R','PLANT_ID' from FP_AGING_STOCK_TO_PLAN_PEGGING_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_CUTOFF_BOH_H','PLANT_ID' from FP_AMEND_CUTOFF_BOH_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_CUTOFF_BOH_R','PLANT_ID' from FP_AMEND_CUTOFF_BOH_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_BOH_H','PLANT_ID' from FP_AMEND_DAILY_BOH_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_BOH_R','PLANT_ID' from FP_AMEND_DAILY_BOH_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_BOR_H','PLANT_ID' from FP_AMEND_DAILY_BOR_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_BOR_R','PLANT_ID' from FP_AMEND_DAILY_BOR_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_CAPA_H','PLANT_ID' from FP_AMEND_DAILY_CAPA_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_CAPA_R','PLANT_ID' from FP_AMEND_DAILY_CAPA_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_PLAN_H','PLANT_ID' from FP_AMEND_DAILY_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_PLAN_R','PLANT_ID' from FP_AMEND_DAILY_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_SALES_H','PLANT_ID' from FP_AMEND_DAILY_SALES_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_SALES_PMIX_H','PLANT_ID' from FP_AMEND_DAILY_SALES_PMIX_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_SALES_PMIX_R','PLANT_ID' from FP_AMEND_DAILY_SALES_PMIX_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_SALES_R','PLANT_ID' from FP_AMEND_DAILY_SALES_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_UTIL_H','PLANT_ID' from FP_AMEND_DAILY_UTIL_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_DAILY_UTIL_R','PLANT_ID' from FP_AMEND_DAILY_UTIL_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_ELEC_TO_ASSY_PLAN_R','PLANT_ID' from FP_AMEND_ELEC_TO_ASSY_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_FORM_LEAD_TIME_M','PLANT_ID' from FP_AMEND_FORM_LEAD_TIME_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_IN_LEAD_TIME_R','PLANT_ID' from FP_AMEND_IN_LEAD_TIME_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_LOB_PLAN_R','PLANT_ID' from FP_AMEND_LOB_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --




select count(*),'FP_AMEND_MEMO_M','PLANT_ID' from FP_AMEND_MEMO_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --

select count(*),'FP_AMEND_PLAN_CELL_BOR_H','PLANT_ID' from FP_AMEND_PLAN_CELL_BOR_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_CELL_BOR_R','PLANT_ID' from FP_AMEND_PLAN_CELL_BOR_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_CELL_H','PLANT_ID' from FP_AMEND_PLAN_CELL_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_CELL_R','PLANT_ID' from FP_AMEND_PLAN_CELL_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_CELL_SALES_H','PLANT_ID' from FP_AMEND_PLAN_CELL_SALES_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_CELL_SALES_R','PLANT_ID' from FP_AMEND_PLAN_CELL_SALES_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_CELL_UTIL_H','PLANT_ID' from FP_AMEND_PLAN_CELL_UTIL_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_CELL_UTIL_R','PLANT_ID' from FP_AMEND_PLAN_CELL_UTIL_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_FORM_H','PLANT_ID' from FP_AMEND_PLAN_FORM_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_FORM_R','PLANT_ID' from FP_AMEND_PLAN_FORM_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_FORM_ROLLBACK_R','PLANT_ID' from FP_AMEND_PLAN_FORM_ROLLBACK_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_FORM_UTIL_H','PLANT_ID' from FP_AMEND_PLAN_FORM_UTIL_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_FORM_UTIL_R','PLANT_ID' from FP_AMEND_PLAN_FORM_UTIL_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_P_FORM_BOH_R','PLANT_ID' from FP_AMEND_PLAN_P_FORM_BOH_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_P_FORM_R','PLANT_ID' from FP_AMEND_PLAN_P_FORM_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_BOR_H','PLANT_ID' from FP_AMEND_PLAN_PACK_BOR_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_BOR_R','PLANT_ID' from FP_AMEND_PLAN_PACK_BOR_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_H','PLANT_ID' from FP_AMEND_PLAN_PACK_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_R','PLANT_ID' from FP_AMEND_PLAN_PACK_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_SALES_H','PLANT_ID' from FP_AMEND_PLAN_PACK_SALES_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_SALES_R','PLANT_ID' from FP_AMEND_PLAN_PACK_SALES_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_UTIL_H','PLANT_ID' from FP_AMEND_PLAN_PACK_UTIL_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_PACK_UTIL_R','PLANT_ID' from FP_AMEND_PLAN_PACK_UTIL_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_POST_BOR_R','PLANT_ID' from FP_AMEND_PLAN_POST_BOR_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_POST_CAPA_R','PLANT_ID' from FP_AMEND_PLAN_POST_CAPA_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_POST_FORM_R','PLANT_ID' from FP_AMEND_PLAN_POST_FORM_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_POST_FORM_ROLLBACK_R','PLANT_ID' from FP_AMEND_PLAN_POST_FORM_ROLLBACK_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_POST_H','PLANT_ID' from FP_AMEND_PLAN_POST_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_POST_R','PLANT_ID' from FP_AMEND_PLAN_POST_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_POST_UTIL_R','PLANT_ID' from FP_AMEND_PLAN_POST_UTIL_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_PLAN_R','PLANT_ID' from FP_AMEND_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_SETUP_COLOR_M','PLANT_ID' from FP_AMEND_SETUP_COLOR_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_SIM_CELL_PACK_H','PLANT_ID' from FP_AMEND_SIM_CELL_PACK_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_AMEND_SIM_CELL_PACK_R','PLANT_ID' from FP_AMEND_SIM_CELL_PACK_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --

select count(*),'FP_AUTH_REQUEST_INFO_M','PLANT_ID' from FP_AUTH_REQUEST_INFO_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_CELL_DELIVERY_PLAN_FIX_H','PLANT_ID' from FP_CELL_DELIVERY_PLAN_FIX_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_CELL_DELIVERY_PLAN_H','PLANT_ID' from FP_CELL_DELIVERY_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_CELL_INHOUSE_PLAN_H','PLANT_ID' from FP_CELL_INHOUSE_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_CELL_MOVE_PLAN_H','PLANT_ID' from FP_CELL_MOVE_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_CELL_MOVE_PLAN_MES_SEND_H','PLANT_ID' from FP_CELL_MOVE_PLAN_MES_SEND_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_DEMAND_INSTANCE_PLAN_H','PLANT_ID' from FP_DAILY_DEMAND_INSTANCE_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_DEMAND_INSTANCE_PLAN_H','TO_PLANT_ID' from FP_DAILY_DEMAND_INSTANCE_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.TO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_DEMAND_OFFSET_H','PLANT_ID' from FP_DAILY_DEMAND_OFFSET_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_DEMAND_PMIX_PLAN_H','PLANT_ID' from FP_DAILY_DEMAND_PMIX_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_DEMAND_PMIX_PLAN_H','TO_PLANT_ID' from FP_DAILY_DEMAND_PMIX_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.TO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_DEMAND_SHIPMENT_ELEC_H','PLANT_ID' from FP_DAILY_DEMAND_SHIPMENT_ELEC_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_DEMAND_SHIPMENT_ELEC_H','TO_PLANT_ID' from FP_DAILY_DEMAND_SHIPMENT_ELEC_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.TO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_INSTANCE_DEMAND_H','PLANT_ID' from FP_DAILY_INSTANCE_DEMAND_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_INSTANCE_DEMAND_H','TO_PLANT_ID' from FP_DAILY_INSTANCE_DEMAND_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.TO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_INSTANCE_ORDER_STATUS','PLANT_ID' from FP_DAILY_INSTANCE_ORDER_STATUS A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_INSTANCE_STOCK_H','PLANT_ID' from FP_DAILY_INSTANCE_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_NET_DEMAND_H','PLANT_ID' from FP_DAILY_NET_DEMAND_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_NET_DEMAND_H','TO_PLANT_ID' from FP_DAILY_NET_DEMAND_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.TO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_PRODUCTIOIN_PLAN_H','PLANT_ID' from FP_DAILY_PRODUCTIOIN_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_PRODUCTIOIN_PLAN_H_KIMCD_1027','PLANT_ID' from FP_DAILY_PRODUCTIOIN_PLAN_H_KIMCD_1027 A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_PRODUCTION_PLAN_CUTOFF_H','PLANT_ID' from FP_DAILY_PRODUCTION_PLAN_CUTOFF_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_PRODUCTION_PLAN_DW_H','PLANT_ID' from FP_DAILY_PRODUCTION_PLAN_DW_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_PRODUCTION_PLAN_R','PLANT_ID' from FP_DAILY_PRODUCTION_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_PRODUCTION_PLAN_ROLLBACK_R','PLANT_ID' from FP_DAILY_PRODUCTION_PLAN_ROLLBACK_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_PRODUCTION_PLAN_WORKER_R','PLANT_ID' from FP_DAILY_PRODUCTION_PLAN_WORKER_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DAILY_SHIFT_PROD_PLAN_H','PLANT_ID' from FP_DAILY_SHIFT_PROD_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DEMAND_FULFILLMENT_R','PLANT_ID' from FP_DEMAND_FULFILLMENT_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DEMAND_PACK_REQUIRE_CELL_H','PLANT_ID' from FP_DEMAND_PACK_REQUIRE_CELL_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DEMAND_PACK_REQUIRE_FIX','PLANT_ID' from FP_DEMAND_PACK_REQUIRE_FIX A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DW_LOSS_M','PLANT_ID' from FP_DW_LOSS_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_DW_LOSS_M_20240108','PLANT_ID' from FP_DW_LOSS_M_20240108 A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_ELECTRODE_POST_PLAN_H','PLANT_ID' from FP_ELECTRODE_POST_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_ERP_PRODUCTION_PLAN_H','PLANT_ID' from FP_ERP_PRODUCTION_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_ERP_PRODUCTION_PLAN_H','SLIT_PLANT_ID' from FP_ERP_PRODUCTION_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.SLIT_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_ERP_PRODUCTION_PLAN_M','PLANT_ID' from FP_ERP_PRODUCTION_PLAN_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_ERP_PRODUCTION_PLAN_M','SLIT_PLANT_ID' from FP_ERP_PRODUCTION_PLAN_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.SLIT_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_ERP_WORK_ORDER_STATUS_H','PLANT_ID' from FP_ERP_WORK_ORDER_STATUS_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_FORM_IN_LINE_M','PLANT_ID' from FP_FORM_IN_LINE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_FORM_SHIPMENT_PSI_UI','PLANT_ID' from FP_FORM_SHIPMENT_PSI_UI A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_FORM_TRAY_ASSIGN_UI','PLANT_ID' from FP_FORM_TRAY_ASSIGN_UI A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_FORMATION_PSI_UI','PLANT_ID' from FP_FORMATION_PSI_UI A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_FORMATION_SHORTER_LT_M','PLANT_ID' from FP_FORMATION_SHORTER_LT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_INHOUSE_REQUEST_BOH_R','PLANT_ID' from FP_INHOUSE_REQUEST_BOH_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_ITEM_CELL_EXCHANGE_M','PLANT_ID' from FP_ITEM_CELL_EXCHANGE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_ITEM_EQUIP_RESULT_HIS','PLANT_ID' from FP_ITEM_EQUIP_RESULT_HIS A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_KPI_DAILY_PRODUCTION_PLAN_H','PLANT_ID' from FP_KPI_DAILY_PRODUCTION_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_KPI_RAW_DATA_R','PLANT_ID' from FP_KPI_RAW_DATA_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_KPI_RESULT_R','PLANT_ID' from FP_KPI_RESULT_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_LINE_BOM_PRIORITY_M','PLANT_ID' from FP_LINE_BOM_PRIORITY_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_LOSS_H','PLANT_ID' from FP_LOSS_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MANUAL_WORK_ORDER_H','PLANT_ID' from FP_MANUAL_WORK_ORDER_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MASTER_VALIDATION_H','PLANT_ID' from FP_MASTER_VALIDATION_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MATERIAL_PLAN_R','PLANT_ID' from FP_MATERIAL_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MES_CELL_SHIPMENT_H','PLANT_ID' from FP_MES_CELL_SHIPMENT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MES_PRODUCTION_PLAN_M','PLANT_ID' from FP_MES_PRODUCTION_PLAN_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MES_PRODUCTION_PLAN_M','SLIT_PLANT_ID' from FP_MES_PRODUCTION_PLAN_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.SLIT_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MES_WORK_ORDER_STATUS_H','PLANT_ID' from FP_MES_WORK_ORDER_STATUS_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MODEL_LOT_M','PLANT_ID' from FP_MODEL_LOT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MODEL_LOT_M_20230804','PLANT_ID' from FP_MODEL_LOT_M_20230804 A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MODEL_LOT_M_20240308','PLANT_ID' from FP_MODEL_LOT_M_20240308 A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MOVE_PLAN_R','PLANT_ID' from FP_MOVE_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MPP_WPP_BASE_PLAN_H','PLANT_ID' from FP_MPP_WPP_BASE_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MPP_WPP_BASE_PLAN_M','PLANT_ID' from FP_MPP_WPP_BASE_PLAN_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MRP_BOM_PRIORITY_M','PLANT_ID' from FP_MRP_BOM_PRIORITY_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MRP_CUTOFF_SUPPLY_H','PLANT_ID' from FP_MRP_CUTOFF_SUPPLY_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MRP_INTRANSIT_H','PLANT_ID' from FP_MRP_INTRANSIT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MRP_SUM_PROCURE_ITEM_M','OTHER_PLANT_ID' from FP_MRP_SUM_PROCURE_ITEM_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.OTHER_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_MRP_SUM_PROCURE_ITEM_M','PLANT_ID' from FP_MRP_SUM_PROCURE_ITEM_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_NEW_PLANED_ORDER_R','PLANT_ID' from FP_NEW_PLANED_ORDER_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_ORDER_PEGGING_R','PLANT_ID' from FP_ORDER_PEGGING_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_ORDER_TRACKING_DEMEND_R','PLANT_ID' from FP_ORDER_TRACKING_DEMEND_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_ORDER_TRACKING_R','PLANT_ID' from FP_ORDER_TRACKING_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_ORDER_TRACKING_WO_R','PLANT_ID' from FP_ORDER_TRACKING_WO_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_ORDER_TRACKING_WO_R_ORG','PLANT_ID' from FP_ORDER_TRACKING_WO_R_ORG A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_OS_REPORT_R','PLANT_ID' from FP_OS_REPORT_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PACK_ALT_MATERIAL_DEFINIT','PLANT_ID' from FP_PACK_ALT_MATERIAL_DEFINIT A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PACK_ALT_MATERIAL_ITEM','PLANT_ID' from FP_PACK_ALT_MATERIAL_ITEM A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PACK_NEW_ALT_ID','PLANT_ID' from FP_PACK_NEW_ALT_ID A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PANCAKE_INVENTORY_BALANCE_M_R','PLANT_ID' from FP_PANCAKE_INVENTORY_BALANCE_M_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PANCAKE_INVENTORY_BALANCE_S_R','PLANT_ID' from FP_PANCAKE_INVENTORY_BALANCE_S_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PANCAKE_SHIPMENT_PLAN_R','PLANT_ID' from FP_PANCAKE_SHIPMENT_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PDS_VERSION_M','PLANT_ID' from FP_PDS_VERSION_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PLAN_BOM_EXCEPT_H','PLANT_ID' from FP_PLAN_BOM_EXCEPT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PLAN_BOM_M','PLANT_ID' from FP_PLAN_BOM_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PLAN_FORM_ADDITIONAL_INFO','PLANT_ID' from FP_PLAN_FORM_ADDITIONAL_INFO A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PLAN_GROUP_M','PLANT_ID' from FP_PLAN_GROUP_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PLAN_UTILIZATION_R','PLANT_ID' from FP_PLAN_UTILIZATION_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --

select count(*),'FP_PROBLEM_REPORT_R','PROBLEM_PLANT' from FP_PROBLEM_REPORT_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PROBLEM_PLANT = B.OLD_VALUE1 --
select count(*),'FP_PROD_VERSION_APPLY_DATE_M','PLANT_ID' from FP_PROD_VERSION_APPLY_DATE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PROD_VERSION_M','PLANT_ID' from FP_PROD_VERSION_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_BATCH_H','PLANT_ID' from FP_PRODUCTION_PLAN_BATCH_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_CHANGE_R','PLANT_ID' from FP_PRODUCTION_PLAN_CHANGE_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_CHANGE_R','SLIT_PLANT_ID' from FP_PRODUCTION_PLAN_CHANGE_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.SLIT_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R','PLANT_ID' from FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R','SLIT_PLANT_ID' from FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.SLIT_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_EQUIPMENT_EPOST_R','PLANT_ID' from FP_PRODUCTION_PLAN_EQUIPMENT_EPOST_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_EQUIPMENT_R','PLANT_ID' from FP_PRODUCTION_PLAN_EQUIPMENT_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_EQUIPMENT_R','SLIT_PLANT_ID' from FP_PRODUCTION_PLAN_EQUIPMENT_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.SLIT_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_FACTORY_R','PLANT_ID' from FP_PRODUCTION_PLAN_FACTORY_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_FACTORY_R','SLIT_PLANT_ID' from FP_PRODUCTION_PLAN_FACTORY_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.SLIT_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_GROUP_R','PLANT_ID' from FP_PRODUCTION_PLAN_GROUP_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_GROUP_R','SLIT_PLANT_ID' from FP_PRODUCTION_PLAN_GROUP_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.SLIT_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_PACKER_R','PLANT_ID' from FP_PRODUCTION_PLAN_PACKER_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_R','PLANT_ID' from FP_PRODUCTION_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_PRODUCTION_PLAN_R','SLIT_PLANT_ID' from FP_PRODUCTION_PLAN_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.SLIT_PLANT_ID = B.OLD_VALUE1 --

select count(*),'FP_RESULT_TACT_H','PLANT_ID' from FP_RESULT_TACT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_SCM_IN_TRANSIT_H','FROM_PLANT_ID' from FP_SCM_IN_TRANSIT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.FROM_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_SCM_IN_TRANSIT_H','PLANT_ID' from FP_SCM_IN_TRANSIT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_SCM_IN_TRANSIT_H','PLANT_ISSUE_DATE' from FP_SCM_IN_TRANSIT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ISSUE_DATE = B.OLD_VALUE1 --
select count(*),'FP_SCP_CHANGE_MEMO_M','PLANT_ID' from FP_SCP_CHANGE_MEMO_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_SHIPMENT_PLAN_H','PLANT_ID' from FP_SHIPMENT_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_SHIPMENT_PLAN_H','TO_PLANT_ID' from FP_SHIPMENT_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.TO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_SHIPMENT_PLAN_WPP_H','PLANT_ID' from FP_SHIPMENT_PLAN_WPP_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_SHIPMENT_PLAN_WPP_H','TO_PLANT_ID' from FP_SHIPMENT_PLAN_WPP_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.TO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_SIM_MATERIAL_PACK_H','PLANT_ID' from FP_SIM_MATERIAL_PACK_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_SIM_MATERIAL_PACK_R','PLANT_ID' from FP_SIM_MATERIAL_PACK_R A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_SSP_STOCK_BACKUP_H','PLANT_ID' from FP_SSP_STOCK_BACKUP_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_USER_LINE_GROUP_M','PLANT_ID' from FP_USER_LINE_GROUP_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_DETAIL_H','PLANT_ID' from FP_WEEKLY_DEMAND_DETAIL_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_DETAIL_H','TO_PLANT_ID' from FP_WEEKLY_DEMAND_DETAIL_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.TO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H','PLANT_ID' from FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_PRODUCT_H','PLANT_ID' from FP_WEEKLY_DEMAND_PRODUCT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_PRODUCT_MOBILE_COATER_H','PLANT_ID' from FP_WEEKLY_DEMAND_PRODUCT_MOBILE_COATER_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_PRODUCT_MOBILE_H','PLANT_ID' from FP_WEEKLY_DEMAND_PRODUCT_MOBILE_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_PRODUCT_PDS_H','PLANT_ID' from FP_WEEKLY_DEMAND_PRODUCT_PDS_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_PRODUCT_SRS_H','PLANT_ID' from FP_WEEKLY_DEMAND_PRODUCT_SRS_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_PRODUCT_TEST_H','PLANT_ID' from FP_WEEKLY_DEMAND_PRODUCT_TEST_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H','PLANT_ID' from FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H','PLANT_ID' from FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H','TO_PLANT_ID' from FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.TO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_SHIPMENT_H','PLANT_ID' from FP_WEEKLY_DEMAND_SHIPMENT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_SHIPMENT_H','TO_PLANT_ID' from FP_WEEKLY_DEMAND_SHIPMENT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.TO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_SHIPMENT_SCP_H','PLANT_ID' from FP_WEEKLY_DEMAND_SHIPMENT_SCP_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'FP_WEEKLY_DEMAND_SHIPMENT_SCP_H','TO_PLANT_ID' from FP_WEEKLY_DEMAND_SHIPMENT_SCP_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.TO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_AGING_ITEM_FLOW_M','PLANT_ID' from SCM_AGING_ITEM_FLOW_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_AGING_STOCK_H','PLANT_ID' from SCM_AGING_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_AGING_STOCK_H_20231104','PLANT_ID' from SCM_AGING_STOCK_H_20231104 A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_AGING_STOCK_HOLD_M','PLANT_ID' from SCM_AGING_STOCK_HOLD_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_AGING_TRAY_STOCK_H','PLANT_ID' from SCM_AGING_TRAY_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_AGING_TRAY_STOCK_H_20231104','PLANT_ID' from SCM_AGING_TRAY_STOCK_H_20231104 A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_AS_MATERIAL_DOCUMENT_H','IO_PLANT_ID' from SCM_AS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.IO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_AS_MATERIAL_DOCUMENT_H','IO_PLANT_ID' from SCM_AS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.IO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_AS_MATERIAL_DOCUMENT_H','PLANT_ID' from SCM_AS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_AS_MATERIAL_DOCUMENT_H','PLANT_ID' from SCM_AS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_BASE_STOCK_H','PLANT_ID' from SCM_BASE_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_BATCH_M','PLANT_ID' from SCM_BATCH_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_BOD_EXCEPT_M','PLANT_ID' from SCM_BOD_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_BOD_M','PLANT_ID' from SCM_BOD_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_BOD_PATTERN_M','PLANT_ID' from SCM_BOD_PATTERN_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_BOM_FOR_RES_SHARE_M','PLANT_ID' from SCM_BOM_FOR_RES_SHARE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_BOM_M','PLANT_ID' from SCM_BOM_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_CAPA_MAIL_SEND_H','PLANT_ID' from SCM_CAPA_MAIL_SEND_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_CODE_LOOKUP_VALUE','PLANT_ID' from SCM_CODE_LOOKUP_VALUE A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --


select count(*),'SCM_DAILY_CAPACITY_EXCEPT_M','PLANT_ID' from SCM_DAILY_CAPACITY_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_DAILY_CAPACITY_M','PLANT_ID' from SCM_DAILY_CAPACITY_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_DAILY_PRODUCT_RESULT_H','PLANT_ID' from SCM_DAILY_PRODUCT_RESULT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_DEMAND_INFO_H','PLANT_ID' from SCM_DEMAND_INFO_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --

select count(*),'SCM_DW_SHIPPING_H','PLANT_ID' from SCM_DW_SHIPPING_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_EQUIPMENT_EXCEPT_M','PLANT_ID' from SCM_EQUIPMENT_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_EQUIPMENT_M','PLANT_ID' from SCM_EQUIPMENT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_FACTORY_CALENDAR_M','PLANT_ID' from SCM_FACTORY_CALENDAR_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_FACTORY_M','MES_PLANT_ID' from SCM_FACTORY_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.MES_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_FACTORY_M','PLANT_ID' from SCM_FACTORY_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_MATERIAL_DOCUMENT_H','IO_PLANT_ID' from SCM_FCS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.IO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_MATERIAL_DOCUMENT_H','IO_PLANT_ID' from SCM_FCS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.IO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_MATERIAL_DOCUMENT_H','PLANT_ID' from SCM_FCS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_MATERIAL_DOCUMENT_H','PLANT_ID' from SCM_FCS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_TRAY_M','PLANT_ID' from SCM_FCS_TRAY_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_TRAY_MODEL_M','PLANT_ID' from SCM_FCS_TRAY_MODEL_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_FORMATION_YIELD_M','PLANT_ID' from SCM_FORMATION_YIELD_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_FP_NOTCHED_PANCAKE_REPORT','PLANT_ID' from SCM_FP_NOTCHED_PANCAKE_REPORT A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_GROUP_CELL_M','PLANT_ID' from SCM_GROUP_CELL_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_INTRANSIT_H','FROM_PLANT_ID' from SCM_INTRANSIT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.FROM_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_INTRANSIT_H','PLANT_ID' from SCM_INTRANSIT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_INTRANSIT_H','TO_PLANT_ID' from SCM_INTRANSIT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.TO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_BOD_EXCEPT_M','PLANT_ID' from SCM_ITEM_BOD_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_BOD_M','PLANT_ID' from SCM_ITEM_BOD_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_CONV_CALC_M','PLANT_ID' from SCM_ITEM_CONV_CALC_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_CONV_CALC_USE_M','PLANT_ID' from SCM_ITEM_CONV_CALC_USE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_EQUIP_RATE_BATCH_M','PLANT_ID' from SCM_ITEM_EQUIP_RATE_BATCH_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_EQUIPMENT_ASSIGN_EXCEPT_M','PLANT_ID' from SCM_ITEM_EQUIPMENT_ASSIGN_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_FLOW_EXCEPT_M','PLANT_ID' from SCM_ITEM_FLOW_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_FLOW_M','PLANT_ID' from SCM_ITEM_FLOW_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_FOIL_M','PLANT_ID' from SCM_ITEM_FOIL_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LANE_EXCEPT_M','PLANT_ID' from SCM_ITEM_LANE_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LANE_M','PLANT_ID' from SCM_ITEM_LANE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LINE_ASSIGN_ERP','PLANT_ID' from SCM_ITEM_LINE_ASSIGN_ERP A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LINE_ASSIGN_EXCEPT_M','PLANT_ID' from SCM_ITEM_LINE_ASSIGN_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LINE_ASSIGN_EXCEPT_UI_M','PLANT_ID' from SCM_ITEM_LINE_ASSIGN_EXCEPT_UI_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LINE_ASSIGN_M','PLANT_ID' from SCM_ITEM_LINE_ASSIGN_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LINE_ASSIGN_UI_M','PLANT_ID' from SCM_ITEM_LINE_ASSIGN_UI_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ITEM_LINE_ASSIGN_VER_H','PLANT_ID' from SCM_ITEM_LINE_ASSIGN_VER_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --




select count(*),'SCM_LINE_ASSIGN_EXCT_VER_H','PLANT_ID' from SCM_LINE_ASSIGN_EXCT_VER_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_LINE_CALENDAR_M','PLANT_ID' from SCM_LINE_CALENDAR_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_LINE_LOSS_M','PLANT_ID' from SCM_LINE_LOSS_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_LINE_M','PLANT_ID' from SCM_LINE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_LINE_SETUP_GROUP_M','PLANT_ID' from SCM_LINE_SETUP_GROUP_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_LOSS_CALENDAR_M','PLANT_ID' from SCM_LOSS_CALENDAR_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_LOSS_M','PLANT_ID' from SCM_LOSS_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_LOSS_REPORT_VER_H','PLANT_ID' from SCM_LOSS_REPORT_VER_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_LOSS_VER_H','PLANT_ID' from SCM_LOSS_VER_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MANUAL_WO_CREATE','SLITING_PLANT' from SCM_MANUAL_WO_CREATE A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.SLITING_PLANT = B.OLD_VALUE1 --
select count(*),'SCM_MASTER_MANAGER_M','PLANT_ID' from SCM_MASTER_MANAGER_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MASTER_MANAGER_VER_H','PLANT_ID' from SCM_MASTER_MANAGER_VER_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MATERIAL_GR_PLAN_H','PLANT_ID' from SCM_MATERIAL_GR_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MATERIAL_RATIO_M','PLANT_ID' from SCM_MATERIAL_RATIO_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MES_RT_STOCK_H','PLANT_ID' from SCM_MES_RT_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MMD_ITEM_ROUTE_TEMP','MMD_PLANT_ID' from SCM_MMD_ITEM_ROUTE_TEMP A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.MMD_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MMD_ITEM_ROUTE_TEMP','PARENT_PLANT_ID' from SCM_MMD_ITEM_ROUTE_TEMP A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PARENT_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MMD_ITEM_ROUTE_TEMP','PLANT_ID' from SCM_MMD_ITEM_ROUTE_TEMP A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MMD_LINE_M','PLANT_ID' from SCM_MMD_LINE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MMD_MODEL_ROUTE_M','MMD_PLANT_ID' from SCM_MMD_MODEL_ROUTE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.MMD_PLANT_ID = B.OLD_VALUE1 --




select count(*),'SCM_MMD_SHIPTO_M','PLANT_ID' from SCM_MMD_SHIPTO_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_BOM_M','PLANT_ID' from SCM_MODEL_BOM_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP','PLANT_ID' from SCM_MODEL_COMP A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_EFFECTIVE_DATE','CHILD_PLANT_ID' from SCM_MODEL_COMP_EFFECTIVE_DATE A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.CHILD_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_EFFECTIVE_DATE','PLANT_ID' from SCM_MODEL_COMP_EFFECTIVE_DATE A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_EFFECTIVE_DATE','CHILD_PLANT_ID' from SCM_MODEL_COMP_EFFECTIVE_DATE A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.CHILD_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_EFFECTIVE_DATE','PLANT_ID' from SCM_MODEL_COMP_EFFECTIVE_DATE A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_TEMP','CHILD_PLANT_ID' from SCM_MODEL_COMP_TEMP A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.CHILD_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_TEMP','PLANT_ID' from SCM_MODEL_COMP_TEMP A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_TEMP','CHILD_PLANT_ID' from SCM_MODEL_COMP_TEMP A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.CHILD_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_MODEL_COMP_TEMP','PLANT_ID' from SCM_MODEL_COMP_TEMP A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --


select count(*),'SCM_MODEL_MODEL_TEMP','PLANT_ID' from SCM_MODEL_MODEL_TEMP A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --

select count(*),'SCM_OFF_CALENDAR_LINE_M','PLANT_ID' from SCM_OFF_CALENDAR_LINE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_OFF_CALENDAR_M','PLANT_ID' from SCM_OFF_CALENDAR_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_OFF_CATEGORY_M','PLANT_ID' from SCM_OFF_CATEGORY_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_OFF_PATTERN_M','PLANT_ID' from SCM_OFF_PATTERN_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_OFF_TYPE_M','PLANT_ID' from SCM_OFF_TYPE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --


select count(*),'SCM_OPERATION_MOVE_M','PLANT_ID' from SCM_OPERATION_MOVE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ORDER_STATUS_H','PLANT_ID' from SCM_ORDER_STATUS_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_PACK_WORKER_LIMIT_M','PLANT_ID' from SCM_PACK_WORKER_LIMIT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_PACK_WORKER_M','PLANT_ID' from SCM_PACK_WORKER_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_PACKER_PO_H','PLANT_ID' from SCM_PACKER_PO_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_PACKER_PROD_RESULT_H','PLANT_ID' from SCM_PACKER_PROD_RESULT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_PLANT_M','PLANT_ID' from SCM_PLANT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_PLANT_M','PLANT_NAME' from SCM_PLANT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_NAME = B.OLD_VALUE1 --
select count(*),'SCM_PLANT_M','PLANT_TYPE' from SCM_PLANT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_TYPE = B.OLD_VALUE1 --
select count(*),'SCM_PLM_WO_TACT_TIME_M','PLANT_ID' from SCM_PLM_WO_TACT_TIME_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_PRODUCT_RESULT_H','PLANT_ID' from SCM_PRODUCT_RESULT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_PSEUDO_DIVISION_M','PLANT_ID' from SCM_PSEUDO_DIVISION_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_ROLL_WAREHOUSE_M','PLANT_ID' from SCM_ROLL_WAREHOUSE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_SETUP_CONDITION_M','PLANT_ID' from SCM_SETUP_CONDITION_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_SETUP_CONDITION_M_FOOTPRINT_BK','PLANT_ID' from SCM_SETUP_CONDITION_M_FOOTPRINT_BK A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_SETUP_MATRIX_M','PLANT_ID' from SCM_SETUP_MATRIX_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_SETUP_MATRIX_M_FOOTPRINT_BK','PLANT_ID' from SCM_SETUP_MATRIX_M_FOOTPRINT_BK A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_SHIPMENT_M','PLANT_ID' from SCM_SHIPMENT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_SHIPMENT_M','TO_PLANT_ID' from SCM_SHIPMENT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.TO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_SHIPPING_RESULT_H','PLANT_ID' from SCM_SHIPPING_RESULT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_SHIPPING_RESULT_H','TO_PLANT_ID' from SCM_SHIPPING_RESULT_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.TO_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_SHOP_M','PLANT_ID' from SCM_SHOP_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --

select count(*),'SCM_SLOC_M','PLANT_ID' from SCM_SLOC_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_SLOC_M','PLANT_ID' from SCM_SLOC_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_SLURRY_RATE_H','PLANT_ID' from SCM_SLURRY_RATE_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_SLURRY_SOLID_RATE','PLANT_ID' from SCM_SLURRY_SOLID_RATE A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_STOCK_H','FROM_PLANT_ID' from SCM_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.FROM_PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_STOCK_H','PLANT_ID' from SCM_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_STOCK_H_TEMP','PLANT_ID' from SCM_STOCK_H_TEMP A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_SYS_LOOKUP_TYPE_M','PLANT_ID' from SCM_SYS_LOOKUP_TYPE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_SYS_LOOKUP_VALUE','PLANT_ID' from SCM_SYS_LOOKUP_VALUE A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_TACT_TIME_EXCEPT_M','PLANT_ID' from SCM_TACT_TIME_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_TACT_TIME_EXCEPT_UI_M','PLANT_ID' from SCM_TACT_TIME_EXCEPT_UI_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_TACT_TIME_EXCT_VER_H','PLANT_ID' from SCM_TACT_TIME_EXCT_VER_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_TACT_TIME_M','PLANT_ID' from SCM_TACT_TIME_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_TACT_TIME_UI_M','PLANT_ID' from SCM_TACT_TIME_UI_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_TACT_TIME_VER_H','PLANT_ID' from SCM_TACT_TIME_VER_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_UTILIZATION_EXCEPT_M','PLANT_ID' from SCM_UTILIZATION_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_UTILIZATION_M','PLANT_ID' from SCM_UTILIZATION_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_WIP_LEVEL_CELL_M','PLANT_ID' from SCM_WIP_LEVEL_CELL_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_WORK_CAL_VER_H','PLANT_ID' from SCM_WORK_CAL_VER_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_WORK_CALENDAR_M','PLANT_ID' from SCM_WORK_CALENDAR_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_WORK_CENTER_M','PLANT_ID' from SCM_WORK_CENTER_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_WORK_TYPE_M','PLANT_ID' from SCM_WORK_TYPE_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_WORK_TYPE_OFF_M','PLANT_ID' from SCM_WORK_TYPE_OFF_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_YIELD_EXCEPT_M','PLANT_ID' from SCM_YIELD_EXCEPT_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_YIELD_EXCEPT_UI_M','PLANT_ID' from SCM_YIELD_EXCEPT_UI_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_YIELD_EXCT_VER_H','PLANT_ID' from SCM_YIELD_EXCT_VER_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_YIELD_M','PLANT_ID' from SCM_YIELD_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_YIELD_UI_M','PLANT_ID' from SCM_YIELD_UI_M A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'SCM_YIELD_VER_H','PLANT_ID' from SCM_YIELD_VER_H A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'TH_MST_INSTANCE_FLOW_POST','PLANT_ID' from TH_MST_INSTANCE_FLOW_POST A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'TH_MST_INSTANCE_LINE_POST','PLANT_ID' from TH_MST_INSTANCE_LINE_POST A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'TH_MST_SCM_ORDER_STATUS_POST','PLANT_ID' from TH_MST_SCM_ORDER_STATUS_POST A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'TH_UIS_MENU','PLANT' from TH_UIS_MENU A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT = B.OLD_VALUE1 --
select count(*),'TH_UIS_MENU_FILTER','PLANT' from TH_UIS_MENU_FILTER A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT = B.OLD_VALUE1 --
select count(*),'TH_UIS_MY_MENU','PLANT' from TH_UIS_MY_MENU A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT = B.OLD_VALUE1 --
select count(*),'TH_UIS_PAGE_INFO','PLANT' from TH_UIS_PAGE_INFO A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT = B.OLD_VALUE1 --
select count(*),'TH_UIS_ROLE_FACTORY_RELATE','PLANT_ID' from TH_UIS_ROLE_FACTORY_RELATE A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'TH_UIS_ROLE_INSTANCE_RELATE','PLANT_ID' from TH_UIS_ROLE_INSTANCE_RELATE A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --


select count(*),'TH_UIS_TRAN_LOG','PLANT' from TH_UIS_TRAN_LOG A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT = B.OLD_VALUE1 --
select count(*),'TH_UIS_TREE','PLANT' from TH_UIS_TREE A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT = B.OLD_VALUE1 --
select count(*),'TH_UIS_USER_AMEND_RELATE','PLANT_ID' from TH_UIS_USER_AMEND_RELATE A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT_ID = B.OLD_VALUE1 --
select count(*),'TH_UIS_USER_DETAIL','PLANT' from TH_UIS_USER_DETAIL A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT = B.OLD_VALUE1 --
select count(*),'TH_UIS_USER_DETAIL_HIS','PLANT' from TH_UIS_USER_DETAIL_HIS A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT = B.OLD_VALUE1 --
select count(*),'TH_UIS_USER_LOG','PLANT' from TH_UIS_USER_LOG A,   (select * from NERP_CONV_MASTER where codetype='plant_id' and ATTRIBUTE5='1st') B   where A.PLANT = B.OLD_VALUE1 --

-- 

































































select count(*),'FP_CELL_DELIVERY_PLAN_FIX_H','STORAGE_ID' from FP_CELL_DELIVERY_PLAN_FIX_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --
select count(*),'FP_CELL_DELIVERY_PLAN_H','STORAGE_ID' from FP_CELL_DELIVERY_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --
select count(*),'FP_CELL_INHOUSE_PLAN_H','STORAGE_ID' from FP_CELL_INHOUSE_PLAN_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --




select count(*),'FP_DAILY_DEMAND_OFFSET_H','STORAGE_ID' from FP_DAILY_DEMAND_OFFSET_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --



















select count(*),'FP_DEMAND_PACK_REQUIRE_CELL_H','STORAGE_ID' from FP_DEMAND_PACK_REQUIRE_CELL_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --
select count(*),'FP_DEMAND_PACK_REQUIRE_FIX','STORAGE_ID' from FP_DEMAND_PACK_REQUIRE_FIX A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --



































select count(*),'FP_MRP_CUTOFF_SUPPLY_H','STORAGE_ID' from FP_MRP_CUTOFF_SUPPLY_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --













































































select count(*),'SCM_AS_MATERIAL_DOCUMENT_H','IO_STORAGE_ID' from SCM_AS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.IO_STORAGE_ID = B.OLD_VALUE1 --
select count(*),'SCM_AS_MATERIAL_DOCUMENT_H','STORAGE_ID' from SCM_AS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --
select count(*),'SCM_AS_MATERIAL_DOCUMENT_H','IO_STORAGE_ID' from SCM_AS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.IO_STORAGE_ID = B.OLD_VALUE1 --
select count(*),'SCM_AS_MATERIAL_DOCUMENT_H','STORAGE_ID' from SCM_AS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --






















select count(*),'SCM_FCS_MATERIAL_DOCUMENT_H','IO_STORAGE_ID' from SCM_FCS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.IO_STORAGE_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_MATERIAL_DOCUMENT_H','STORAGE_ID' from SCM_FCS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_MATERIAL_DOCUMENT_H','IO_STORAGE_ID' from SCM_FCS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.IO_STORAGE_ID = B.OLD_VALUE1 --
select count(*),'SCM_FCS_MATERIAL_DOCUMENT_H','STORAGE_ID' from SCM_FCS_MATERIAL_DOCUMENT_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --











































select count(*),'SCM_MES_RT_STOCK_H','STORAGE_ID' from SCM_MES_RT_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --





select count(*),'SCM_MMD_PRDT_WH_M','EMPTY_CST_STORAGE_QTY' from SCM_MMD_PRDT_WH_M A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.EMPTY_CST_STORAGE_QTY = B.OLD_VALUE1 --
select count(*),'SCM_MMD_PRDT_WH_M','EMPTY_SKID_STORAGE_MIN_QTY' from SCM_MMD_PRDT_WH_M A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.EMPTY_SKID_STORAGE_MIN_QTY = B.OLD_VALUE1 --
select count(*),'SCM_MMD_PRDT_WH_M','RTN_STORAGE_QTY' from SCM_MMD_PRDT_WH_M A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.RTN_STORAGE_QTY = B.OLD_VALUE1 --














































select count(*),'SCM_SLOC_M','STORAGE_DESCRIPTION' from SCM_SLOC_M A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_DESCRIPTION = B.OLD_VALUE1 --
select count(*),'SCM_SLOC_M','STORAGE_ID' from SCM_SLOC_M A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --


select count(*),'SCM_STOCK_H','STORAGE_ID' from SCM_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --
select count(*),'SCM_STOCK_H','STORAGE_ID' from SCM_STOCK_H A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --
select count(*),'SCM_STOCK_H_TEMP','STORAGE_ID' from SCM_STOCK_H_TEMP A,   (select * from NERP_CONV_MASTER where codetype='storage_id' and ATTRIBUTE5='1st') B   where A.STORAGE_ID = B.OLD_VALUE1 --












END

