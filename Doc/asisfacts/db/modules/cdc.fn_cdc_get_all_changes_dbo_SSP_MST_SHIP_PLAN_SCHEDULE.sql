
	create function [cdc].[fn_cdc_get_all_changes_dbo_SSP_MST_SHIP_PLAN_SCHEDULE]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [COMPANY_ID], NULL as [PLAN_START_YYYYMMDD], NULL as [ERP_STOCK_CUTOFF_YN], NULL as [OWMS_STOCK_CUTOFF_YN], NULL as [CURRENT_PLAN_DATE_YN], NULL as [PLAN_CUTOFF_CREATE_YN], NULL as [PLAN_CUTOFF_CREATE_DATE], NULL as [CONFIRM_CREATE_YN], NULL as [CONFIRM_CREATE_DATE], NULL as [FP_TARGET_SEND_YN], NULL as [FP_TARGET_SEND_DATE], NULL as [CREATION_DATE], NULL as [CREATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [LAST_UPDATED_BY], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_MST_SHIP_PLAN_SCHEDULE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[COMPANY_ID], t.[PLAN_START_YYYYMMDD], t.[ERP_STOCK_CUTOFF_YN], t.[OWMS_STOCK_CUTOFF_YN], t.[CURRENT_PLAN_DATE_YN], t.[PLAN_CUTOFF_CREATE_YN], t.[PLAN_CUTOFF_CREATE_DATE], t.[CONFIRM_CREATE_YN], t.[CONFIRM_CREATE_DATE], t.[FP_TARGET_SEND_YN], t.[FP_TARGET_SEND_DATE], t.[CREATION_DATE], t.[CREATED_BY], t.[LAST_UPDATE_DATE], t.[LAST_UPDATED_BY], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
	from [cdc].[dbo_SSP_MST_SHIP_PLAN_SCHEDULE_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_MST_SHIP_PLAN_SCHEDULE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[COMPANY_ID], t.[PLAN_START_YYYYMMDD], t.[ERP_STOCK_CUTOFF_YN], t.[OWMS_STOCK_CUTOFF_YN], t.[CURRENT_PLAN_DATE_YN], t.[PLAN_CUTOFF_CREATE_YN], t.[PLAN_CUTOFF_CREATE_DATE], t.[CONFIRM_CREATE_YN], t.[CONFIRM_CREATE_DATE], t.[FP_TARGET_SEND_YN], t.[FP_TARGET_SEND_DATE], t.[CREATION_DATE], t.[CREATED_BY], t.[LAST_UPDATE_DATE], t.[LAST_UPDATED_BY], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
	from [cdc].[dbo_SSP_MST_SHIP_PLAN_SCHEDULE_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_MST_SHIP_PLAN_SCHEDULE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	