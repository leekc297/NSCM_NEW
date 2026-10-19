
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCM_MST_ITEM_CLASS_M]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [CLASS_ID], NULL as [CLASS_NAME], NULL as [ITEM_TYPE], NULL as [PROCESS_GROUP], NULL as [PROCESS_DETAIL], NULL as [LEVEL], NULL as [LEVEL_1_CODE], NULL as [LEVEL_1_NAME], NULL as [LEVEL_1_ID], NULL as [LEVEL_2_CODE], NULL as [LEVEL_2_NAME], NULL as [LEVEL_2_ID], NULL as [LEVEL_3_CODE], NULL as [LEVEL_3_NAME], NULL as [LEVEL_3_ID], NULL as [LEVEL_4_CODE], NULL as [LEVEL_4_NAME], NULL as [LEVEL_4_ID], NULL as [USE_FLAG], NULL as [INSERT_ID], NULL as [INSERT_TIME], NULL as [UPDATE_ID], NULL as [UPDATE_TIME], NULL as [MODEL_ATTRIBUTE], NULL as [MODEL_ATTRIBUTE_SEQ], NULL as [SKIP_ROUTE_FLAG], NULL as [DEFAULT_OPERATION_ID], NULL as [SCP_FLOW_ID], NULL as [SCP_OPERATION_GROUP], NULL as [SCP_OPERATION_GROUP_ID], NULL as [LEVEL_5_CODE], NULL as [LEVEL_5_NAME], NULL as [LEVEL_5_ID], NULL as [LEVEL_6_CODE], NULL as [LEVEL_6_NAME], NULL as [LEVEL_6_ID], NULL as [CELL_TYPE], NULL as [TCO_CELL_YN], NULL as [SCP_EXC_YN]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_ITEM_CLASS_M', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[CLASS_ID], t.[CLASS_NAME], t.[ITEM_TYPE], t.[PROCESS_GROUP], t.[PROCESS_DETAIL], t.[LEVEL], t.[LEVEL_1_CODE], t.[LEVEL_1_NAME], t.[LEVEL_1_ID], t.[LEVEL_2_CODE], t.[LEVEL_2_NAME], t.[LEVEL_2_ID], t.[LEVEL_3_CODE], t.[LEVEL_3_NAME], t.[LEVEL_3_ID], t.[LEVEL_4_CODE], t.[LEVEL_4_NAME], t.[LEVEL_4_ID], t.[USE_FLAG], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[MODEL_ATTRIBUTE], t.[MODEL_ATTRIBUTE_SEQ], t.[SKIP_ROUTE_FLAG], t.[DEFAULT_OPERATION_ID], t.[SCP_FLOW_ID], t.[SCP_OPERATION_GROUP], t.[SCP_OPERATION_GROUP_ID], t.[LEVEL_5_CODE], t.[LEVEL_5_NAME], t.[LEVEL_5_ID], t.[LEVEL_6_CODE], t.[LEVEL_6_NAME], t.[LEVEL_6_ID], t.[CELL_TYPE], t.[TCO_CELL_YN], t.[SCP_EXC_YN]
	from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_ITEM_CLASS_M', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[CLASS_ID], t.[CLASS_NAME], t.[ITEM_TYPE], t.[PROCESS_GROUP], t.[PROCESS_DETAIL], t.[LEVEL], t.[LEVEL_1_CODE], t.[LEVEL_1_NAME], t.[LEVEL_1_ID], t.[LEVEL_2_CODE], t.[LEVEL_2_NAME], t.[LEVEL_2_ID], t.[LEVEL_3_CODE], t.[LEVEL_3_NAME], t.[LEVEL_3_ID], t.[LEVEL_4_CODE], t.[LEVEL_4_NAME], t.[LEVEL_4_ID], t.[USE_FLAG], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[MODEL_ATTRIBUTE], t.[MODEL_ATTRIBUTE_SEQ], t.[SKIP_ROUTE_FLAG], t.[DEFAULT_OPERATION_ID], t.[SCP_FLOW_ID], t.[SCP_OPERATION_GROUP], t.[SCP_OPERATION_GROUP_ID], t.[LEVEL_5_CODE], t.[LEVEL_5_NAME], t.[LEVEL_5_ID], t.[LEVEL_6_CODE], t.[LEVEL_6_NAME], t.[LEVEL_6_ID], t.[CELL_TYPE], t.[TCO_CELL_YN], t.[SCP_EXC_YN]
	from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_ITEM_CLASS_M', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	