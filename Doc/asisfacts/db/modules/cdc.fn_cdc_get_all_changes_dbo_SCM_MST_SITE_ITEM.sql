
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCM_MST_SITE_ITEM]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [PROJECT_CODE], NULL as [SCM_SITE_ID], NULL as [ITEM_ID], NULL as [CURRENCY], NULL as [CELL_PER_CAR], NULL as [CELL_PER_MODULE], NULL as [LIABILITY_PERIOD], NULL as [SALES_PLAN_ADJUST_YN], NULL as [ITEM_HRCY_ID], NULL as [VALID_YN], NULL as [BPMS_EXIST], NULL as [CUST_GROUP], NULL as [CUST_GROUP_DTL], NULL as [OWNER], NULL as [APPLICATION], NULL as [ROUTE], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [REPORT_GROUP1], NULL as [REPORT_GROUP2], NULL as [REPORT_GROUP3], NULL as [REPORT_GROUP4], NULL as [REPORT_GROUP5], NULL as [REPORT_GROUP6], NULL as [REPORT_GROUP7], NULL as [REPORT_GROUP8], NULL as [EDI_LT], NULL as [SCP_VMI_LT], NULL as [SALES_COMPANY], NULL as [SALES_PLANT], NULL as [PARTIAL_PLAN_YN], NULL as [CONSENSUS_MKT], NULL as [CONSENSUS_ESS], NULL as [CONSENSUS_SCM], NULL as [INVENTORY_DAY], NULL as [CHANGE_REASON], NULL as [ALT_SIM_YN], NULL as [DESCRIPTION], NULL as [PROJECT_INFO], NULL as [PROJECT_S_OP_REPORT], NULL as [CELL_S_OP_REPORT], NULL as [PRJ_OWNR_ID], NULL as [CRGE_ORG_NM], NULL as [CUST_ENG_NM]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SITE_ITEM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[PROJECT_CODE], t.[SCM_SITE_ID], t.[ITEM_ID], t.[CURRENCY], t.[CELL_PER_CAR], t.[CELL_PER_MODULE], t.[LIABILITY_PERIOD], t.[SALES_PLAN_ADJUST_YN], t.[ITEM_HRCY_ID], t.[VALID_YN], t.[BPMS_EXIST], t.[CUST_GROUP], t.[CUST_GROUP_DTL], t.[OWNER], t.[APPLICATION], t.[ROUTE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[REPORT_GROUP1], t.[REPORT_GROUP2], t.[REPORT_GROUP3], t.[REPORT_GROUP4], t.[REPORT_GROUP5], t.[REPORT_GROUP6], t.[REPORT_GROUP7], t.[REPORT_GROUP8], t.[EDI_LT], t.[SCP_VMI_LT], t.[SALES_COMPANY], t.[SALES_PLANT], t.[PARTIAL_PLAN_YN], t.[CONSENSUS_MKT], t.[CONSENSUS_ESS], t.[CONSENSUS_SCM], t.[INVENTORY_DAY], t.[CHANGE_REASON], t.[ALT_SIM_YN], t.[DESCRIPTION], t.[PROJECT_INFO], t.[PROJECT_S_OP_REPORT], t.[CELL_S_OP_REPORT], t.[PRJ_OWNR_ID], t.[CRGE_ORG_NM], t.[CUST_ENG_NM]
	from [cdc].[dbo_SCM_MST_SITE_ITEM_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SITE_ITEM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[PROJECT_CODE], t.[SCM_SITE_ID], t.[ITEM_ID], t.[CURRENCY], t.[CELL_PER_CAR], t.[CELL_PER_MODULE], t.[LIABILITY_PERIOD], t.[SALES_PLAN_ADJUST_YN], t.[ITEM_HRCY_ID], t.[VALID_YN], t.[BPMS_EXIST], t.[CUST_GROUP], t.[CUST_GROUP_DTL], t.[OWNER], t.[APPLICATION], t.[ROUTE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[REPORT_GROUP1], t.[REPORT_GROUP2], t.[REPORT_GROUP3], t.[REPORT_GROUP4], t.[REPORT_GROUP5], t.[REPORT_GROUP6], t.[REPORT_GROUP7], t.[REPORT_GROUP8], t.[EDI_LT], t.[SCP_VMI_LT], t.[SALES_COMPANY], t.[SALES_PLANT], t.[PARTIAL_PLAN_YN], t.[CONSENSUS_MKT], t.[CONSENSUS_ESS], t.[CONSENSUS_SCM], t.[INVENTORY_DAY], t.[CHANGE_REASON], t.[ALT_SIM_YN], t.[DESCRIPTION], t.[PROJECT_INFO], t.[PROJECT_S_OP_REPORT], t.[CELL_S_OP_REPORT], t.[PRJ_OWNR_ID], t.[CRGE_ORG_NM], t.[CUST_ENG_NM]
	from [cdc].[dbo_SCM_MST_SITE_ITEM_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SITE_ITEM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	