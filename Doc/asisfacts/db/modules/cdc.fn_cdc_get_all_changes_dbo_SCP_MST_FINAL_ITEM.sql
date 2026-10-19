
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCP_MST_FINAL_ITEM]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [ITEM_ID], NULL as [NICK_NAME], NULL as [ITEM_CLASS], NULL as [OPERATION_GROUP], NULL as [OPERATION_GROUP_ID], NULL as [ELECTRODE_TYPE], NULL as [FLOW_ID], NULL as [DEMAND_GROUPING_DAYS], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [PACKER_PLAN_ITEM_ID], NULL as [TCO_CELL_YN], NULL as [CELL_TYPE_GROUP_CODE], NULL as [CELL_ITEM_ID], NULL as [CONVERT_QTY_CELL], NULL as [FCST_YN], NULL as [MIN_DUE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [GROUP_CODE1], NULL as [GROUP_CODE2], NULL as [GROUP_CODE3], NULL as [GROUP_CODE4], NULL as [GROUP_CODE5], NULL as [ATTRIBUTE11], NULL as [ATTRIBUTE12], NULL as [ATTRIBUTE13], NULL as [ATTRIBUTE14], NULL as [ATTRIBUTE15], NULL as [SALES_MODEL], NULL as [SALES_VALID_YN], NULL as [SALES_PRIORITY], NULL as [SALES_FROM_YYYYMMDD], NULL as [SALES_TO_YYYYMMDD], NULL as [LEVEL1_GROUP], NULL as [LEVEL2_CODE], NULL as [STATUS_PROTOTYPE], NULL as [STATUS_MASS], NULL as [STATUS_NEW], NULL as [CELL_CF], NULL as [END_CUSTOMER], NULL as [FINISHED_PRODUCT], NULL as [REMARK], NULL as [MKT_DEPT], NULL as [GROUP_CODE6], NULL as [GROUP_CODE7], NULL as [GROUP_CODE8], NULL as [GROUP_CODE9], NULL as [GROUP_CODE10], NULL as [SCP_EXTRA_SPEC], NULL as [REPLACEMENT]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_FINAL_ITEM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[ITEM_ID], t.[NICK_NAME], t.[ITEM_CLASS], t.[OPERATION_GROUP], t.[OPERATION_GROUP_ID], t.[ELECTRODE_TYPE], t.[FLOW_ID], t.[DEMAND_GROUPING_DAYS], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[PACKER_PLAN_ITEM_ID], t.[TCO_CELL_YN], t.[CELL_TYPE_GROUP_CODE], t.[CELL_ITEM_ID], t.[CONVERT_QTY_CELL], t.[FCST_YN], t.[MIN_DUE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[GROUP_CODE1], t.[GROUP_CODE2], t.[GROUP_CODE3], t.[GROUP_CODE4], t.[GROUP_CODE5], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[SALES_MODEL], t.[SALES_VALID_YN], t.[SALES_PRIORITY], t.[SALES_FROM_YYYYMMDD], t.[SALES_TO_YYYYMMDD], t.[LEVEL1_GROUP], t.[LEVEL2_CODE], t.[STATUS_PROTOTYPE], t.[STATUS_MASS], t.[STATUS_NEW], t.[CELL_CF], t.[END_CUSTOMER], t.[FINISHED_PRODUCT], t.[REMARK], t.[MKT_DEPT], t.[GROUP_CODE6], t.[GROUP_CODE7], t.[GROUP_CODE8], t.[GROUP_CODE9], t.[GROUP_CODE10], t.[SCP_EXTRA_SPEC], t.[REPLACEMENT]
	from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_FINAL_ITEM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[ITEM_ID], t.[NICK_NAME], t.[ITEM_CLASS], t.[OPERATION_GROUP], t.[OPERATION_GROUP_ID], t.[ELECTRODE_TYPE], t.[FLOW_ID], t.[DEMAND_GROUPING_DAYS], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[PACKER_PLAN_ITEM_ID], t.[TCO_CELL_YN], t.[CELL_TYPE_GROUP_CODE], t.[CELL_ITEM_ID], t.[CONVERT_QTY_CELL], t.[FCST_YN], t.[MIN_DUE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[GROUP_CODE1], t.[GROUP_CODE2], t.[GROUP_CODE3], t.[GROUP_CODE4], t.[GROUP_CODE5], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[SALES_MODEL], t.[SALES_VALID_YN], t.[SALES_PRIORITY], t.[SALES_FROM_YYYYMMDD], t.[SALES_TO_YYYYMMDD], t.[LEVEL1_GROUP], t.[LEVEL2_CODE], t.[STATUS_PROTOTYPE], t.[STATUS_MASS], t.[STATUS_NEW], t.[CELL_CF], t.[END_CUSTOMER], t.[FINISHED_PRODUCT], t.[REMARK], t.[MKT_DEPT], t.[GROUP_CODE6], t.[GROUP_CODE7], t.[GROUP_CODE8], t.[GROUP_CODE9], t.[GROUP_CODE10], t.[SCP_EXTRA_SPEC], t.[REPLACEMENT]
	from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_FINAL_ITEM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	