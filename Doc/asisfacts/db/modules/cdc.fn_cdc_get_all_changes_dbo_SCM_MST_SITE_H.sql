
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCM_MST_SITE_H]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [HISTORY_SEQ], NULL as [DIVISION_ID], NULL as [SCM_SITE_ID], NULL as [PLANT_ID], NULL as [OPERATION_GROUP], NULL as [SITE_DESCRIPTION], NULL as [SITE_TYPE], NULL as [CITY], NULL as [COUNTRY], NULL as [DEPT_ID], NULL as [VMI_YN], NULL as [VALID_YN], NULL as [NEW_YN], NULL as [SITE_HRCY_ID], NULL as [OSP_YN], NULL as [SHIP_FROZEN], NULL as [PROD_FROZEN], NULL as [END_CUSTOMER], NULL as [SOLDTO_CUSTOMER], NULL as [FP_PLAN_PERIOD], NULL as [BUILD_AHEAD], NULL as [LOGISTIC_PLANT_ID], NULL as [PACKER_ITEM_ID_SUFFIX], NULL as [HQ_VENDOR_CODE], NULL as [COMPANY_ID], NULL as [SITE_ID], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [HISTORY_CREATION_DATE]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SITE_H', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[HISTORY_SEQ], t.[DIVISION_ID], t.[SCM_SITE_ID], t.[PLANT_ID], t.[OPERATION_GROUP], t.[SITE_DESCRIPTION], t.[SITE_TYPE], t.[CITY], t.[COUNTRY], t.[DEPT_ID], t.[VMI_YN], t.[VALID_YN], t.[NEW_YN], t.[SITE_HRCY_ID], t.[OSP_YN], t.[SHIP_FROZEN], t.[PROD_FROZEN], t.[END_CUSTOMER], t.[SOLDTO_CUSTOMER], t.[FP_PLAN_PERIOD], t.[BUILD_AHEAD], t.[LOGISTIC_PLANT_ID], t.[PACKER_ITEM_ID_SUFFIX], t.[HQ_VENDOR_CODE], t.[COMPANY_ID], t.[SITE_ID], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[HISTORY_CREATION_DATE]
	from [cdc].[dbo_SCM_MST_SITE_H_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SITE_H', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[HISTORY_SEQ], t.[DIVISION_ID], t.[SCM_SITE_ID], t.[PLANT_ID], t.[OPERATION_GROUP], t.[SITE_DESCRIPTION], t.[SITE_TYPE], t.[CITY], t.[COUNTRY], t.[DEPT_ID], t.[VMI_YN], t.[VALID_YN], t.[NEW_YN], t.[SITE_HRCY_ID], t.[OSP_YN], t.[SHIP_FROZEN], t.[PROD_FROZEN], t.[END_CUSTOMER], t.[SOLDTO_CUSTOMER], t.[FP_PLAN_PERIOD], t.[BUILD_AHEAD], t.[LOGISTIC_PLANT_ID], t.[PACKER_ITEM_ID_SUFFIX], t.[HQ_VENDOR_CODE], t.[COMPANY_ID], t.[SITE_ID], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[HISTORY_CREATION_DATE]
	from [cdc].[dbo_SCM_MST_SITE_H_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SITE_H', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	