
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCM_MST_MODEL_BOM]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [COMPANY_ID], NULL as [DIVISION_ID], NULL as [SITE_ID], NULL as [PLANT_ID], NULL as [MODEL_ID], NULL as [PARENT_ITEM_ID], NULL as [CHILD_ITEM_ID], NULL as [CHILD_QTY], NULL as [CHILD_UOM], NULL as [ACCUMULATED_CHILD_QTY], NULL as [CONCATENATE_ITEM], NULL as [SORT_ORDER], NULL as [LEAF_LEVEL], NULL as [NLEVEL], NULL as [CHILD_COMPANY_ID], NULL as [CHILD_DIVISION_ID], NULL as [CHILD_SITE_ID], NULL as [CHILD_PLANT_ID], NULL as [ALT_ID], NULL as [ALT_PRIORITY], NULL as [ALT_RATE], NULL as [INSERT_ID], NULL as [INSERT_TIME], NULL as [UPDATE_ID], NULL as [UPDATE_TIME], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [ATTRIBUTE11], NULL as [ATTRIBUTE12], NULL as [ATTRIBUTE13], NULL as [ATTRIBUTE14], NULL as [ATTRIBUTE15], NULL as [CONCAT_ALT_PRIORITY], NULL as [COPY_ALT_PRIORITY], NULL as [SCP_PLAN_YN], NULL as [ENG_ALT_ID], NULL as [ENG_ALT_PRIORITY], NULL as [ORG_ALT_ID], NULL as [ORG_ALT_PRIORITY], NULL as [CHILD_SEQ]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_MODEL_BOM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[MODEL_ID], t.[PARENT_ITEM_ID], t.[CHILD_ITEM_ID], t.[CHILD_QTY], t.[CHILD_UOM], t.[ACCUMULATED_CHILD_QTY], t.[CONCATENATE_ITEM], t.[SORT_ORDER], t.[LEAF_LEVEL], t.[NLEVEL], t.[CHILD_COMPANY_ID], t.[CHILD_DIVISION_ID], t.[CHILD_SITE_ID], t.[CHILD_PLANT_ID], t.[ALT_ID], t.[ALT_PRIORITY], t.[ALT_RATE], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[CONCAT_ALT_PRIORITY], t.[COPY_ALT_PRIORITY], t.[SCP_PLAN_YN], t.[ENG_ALT_ID], t.[ENG_ALT_PRIORITY], t.[ORG_ALT_ID], t.[ORG_ALT_PRIORITY], t.[CHILD_SEQ]
	from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_MODEL_BOM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[MODEL_ID], t.[PARENT_ITEM_ID], t.[CHILD_ITEM_ID], t.[CHILD_QTY], t.[CHILD_UOM], t.[ACCUMULATED_CHILD_QTY], t.[CONCATENATE_ITEM], t.[SORT_ORDER], t.[LEAF_LEVEL], t.[NLEVEL], t.[CHILD_COMPANY_ID], t.[CHILD_DIVISION_ID], t.[CHILD_SITE_ID], t.[CHILD_PLANT_ID], t.[ALT_ID], t.[ALT_PRIORITY], t.[ALT_RATE], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[CONCAT_ALT_PRIORITY], t.[COPY_ALT_PRIORITY], t.[SCP_PLAN_YN], t.[ENG_ALT_ID], t.[ENG_ALT_PRIORITY], t.[ORG_ALT_ID], t.[ORG_ALT_PRIORITY], t.[CHILD_SEQ]
	from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_MODEL_BOM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	