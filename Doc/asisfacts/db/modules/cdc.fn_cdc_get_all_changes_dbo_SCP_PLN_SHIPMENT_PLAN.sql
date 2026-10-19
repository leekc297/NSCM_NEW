
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCP_PLN_SHIPMENT_PLAN]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [MASTER_ID], NULL as [PLAN_ID], NULL as [OUT_VERSION_ID], NULL as [DIVISION_ID], NULL as [PLAN_START_YYYYMMDD], NULL as [PLAN_TYPE], NULL as [SEQ], NULL as [OPERATION_GROUP], NULL as [PROJECT_CODE], NULL as [ITEM_ID], NULL as [TO_SITE], NULL as [INCOTERMS], NULL as [FCST_TYPE], NULL as [DOM_EXP], NULL as [FROM_SITE], NULL as [BOD_ID], NULL as [MEASURE], NULL as [LPST], NULL as [EPST], NULL as [YYYYMMDD], NULL as [OPERATION_QTY], NULL as [ALLOCATION_QTY], NULL as [COMPLETE_QTY], NULL as [ORDER_ID], NULL as [START_TIME], NULL as [END_TIME], NULL as [ENG_DEMAND_ID], NULL as [ORG_DEMAND_ID], NULL as [POL], NULL as [POD], NULL as [TRANSPORT_MODE], NULL as [DEMAND_TYPE], NULL as [ASSIGN_TYPE], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [ATTRIBUTE11], NULL as [ATTRIBUTE12], NULL as [ATTRIBUTE13], NULL as [ATTRIBUTE14], NULL as [ATTRIBUTE15], NULL as [SEMI_YN], NULL as [ORIGIN_TO_DIVISION_ID], NULL as [ORIGIN_FROM_DIVISION_ID], NULL as [ELECTRODE_TYPE]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_PLN_SHIPMENT_PLAN', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[MASTER_ID], t.[PLAN_ID], t.[OUT_VERSION_ID], t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[OPERATION_GROUP], t.[PROJECT_CODE], t.[ITEM_ID], t.[TO_SITE], t.[INCOTERMS], t.[FCST_TYPE], t.[DOM_EXP], t.[FROM_SITE], t.[BOD_ID], t.[MEASURE], t.[LPST], t.[EPST], t.[YYYYMMDD], t.[OPERATION_QTY], t.[ALLOCATION_QTY], t.[COMPLETE_QTY], t.[ORDER_ID], t.[START_TIME], t.[END_TIME], t.[ENG_DEMAND_ID], t.[ORG_DEMAND_ID], t.[POL], t.[POD], t.[TRANSPORT_MODE], t.[DEMAND_TYPE], t.[ASSIGN_TYPE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[SEMI_YN], t.[ORIGIN_TO_DIVISION_ID], t.[ORIGIN_FROM_DIVISION_ID], t.[ELECTRODE_TYPE]
	from [cdc].[dbo_SCP_PLN_SHIPMENT_PLAN_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_PLN_SHIPMENT_PLAN', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[MASTER_ID], t.[PLAN_ID], t.[OUT_VERSION_ID], t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[OPERATION_GROUP], t.[PROJECT_CODE], t.[ITEM_ID], t.[TO_SITE], t.[INCOTERMS], t.[FCST_TYPE], t.[DOM_EXP], t.[FROM_SITE], t.[BOD_ID], t.[MEASURE], t.[LPST], t.[EPST], t.[YYYYMMDD], t.[OPERATION_QTY], t.[ALLOCATION_QTY], t.[COMPLETE_QTY], t.[ORDER_ID], t.[START_TIME], t.[END_TIME], t.[ENG_DEMAND_ID], t.[ORG_DEMAND_ID], t.[POL], t.[POD], t.[TRANSPORT_MODE], t.[DEMAND_TYPE], t.[ASSIGN_TYPE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[SEMI_YN], t.[ORIGIN_TO_DIVISION_ID], t.[ORIGIN_FROM_DIVISION_ID], t.[ELECTRODE_TYPE]
	from [cdc].[dbo_SCP_PLN_SHIPMENT_PLAN_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_PLN_SHIPMENT_PLAN', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	