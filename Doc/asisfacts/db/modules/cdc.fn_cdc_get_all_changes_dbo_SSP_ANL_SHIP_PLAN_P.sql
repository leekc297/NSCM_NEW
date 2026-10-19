
	create function [cdc].[fn_cdc_get_all_changes_dbo_SSP_ANL_SHIP_PLAN_P]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [PLAN_START_YYYYMMDD], NULL as [FROM_SITE], NULL as [ITEM_ID], NULL as [MEASURE], NULL as [YYYYMMDD], NULL as [BOD_ID], NULL as [SHIPTO_CODE], NULL as [PROJECT_CODE], NULL as [FCST_TYPE], NULL as [REQUEST_ID], NULL as [QTY], NULL as [FCST_ETD_DATE], NULL as [FCST_ETA_DATE], NULL as [ETD_DATE], NULL as [ETA_DATE], NULL as [CONFIRM_FLAG], NULL as [CONFIRM_ID], NULL as [REQUESTOR], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_ANL_SHIP_PLAN_P', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[FROM_SITE], t.[ITEM_ID], t.[MEASURE], t.[YYYYMMDD], t.[BOD_ID], t.[SHIPTO_CODE], t.[PROJECT_CODE], t.[FCST_TYPE], t.[REQUEST_ID], t.[QTY], t.[FCST_ETD_DATE], t.[FCST_ETA_DATE], t.[ETD_DATE], t.[ETA_DATE], t.[CONFIRM_FLAG], t.[CONFIRM_ID], t.[REQUESTOR], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
	from [cdc].[dbo_SSP_ANL_SHIP_PLAN_P_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_ANL_SHIP_PLAN_P', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[FROM_SITE], t.[ITEM_ID], t.[MEASURE], t.[YYYYMMDD], t.[BOD_ID], t.[SHIPTO_CODE], t.[PROJECT_CODE], t.[FCST_TYPE], t.[REQUEST_ID], t.[QTY], t.[FCST_ETD_DATE], t.[FCST_ETA_DATE], t.[ETD_DATE], t.[ETA_DATE], t.[CONFIRM_FLAG], t.[CONFIRM_ID], t.[REQUESTOR], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
	from [cdc].[dbo_SSP_ANL_SHIP_PLAN_P_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_ANL_SHIP_PLAN_P', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	