
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCP_ANL_SHIPMENT_PLAN_SEMI_C]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [VERSION_NO], NULL as [CUTOFF_DATE], NULL as [PLAN_START_YYYYMMDD], NULL as [PLAN_TYPE], NULL as [SEQ], NULL as [OPERATION_GROUP], NULL as [ITEM_ID], NULL as [FROM_SITE], NULL as [BOD_ID], NULL as [MEASURE], NULL as [YYYYMMDD], NULL as [TO_SITE], NULL as [QTY], NULL as [DIVISION_NAME], NULL as [OPERATION_GROUP_NAME], NULL as [NICK_NAME], NULL as [FROM_SITE_NAME], NULL as [TO_SITE_NAME], NULL as [ORIGIN_FROM_DIVISION_ID], NULL as [ORIGIN_TO_DIVISION_ID], NULL as [ELECTRODE_TYPE], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_SHIPMENT_PLAN_SEMI_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[VERSION_NO], t.[CUTOFF_DATE], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[OPERATION_GROUP], t.[ITEM_ID], t.[FROM_SITE], t.[BOD_ID], t.[MEASURE], t.[YYYYMMDD], t.[TO_SITE], t.[QTY], t.[DIVISION_NAME], t.[OPERATION_GROUP_NAME], t.[NICK_NAME], t.[FROM_SITE_NAME], t.[TO_SITE_NAME], t.[ORIGIN_FROM_DIVISION_ID], t.[ORIGIN_TO_DIVISION_ID], t.[ELECTRODE_TYPE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
	from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_SEMI_C_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_SHIPMENT_PLAN_SEMI_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[VERSION_NO], t.[CUTOFF_DATE], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[OPERATION_GROUP], t.[ITEM_ID], t.[FROM_SITE], t.[BOD_ID], t.[MEASURE], t.[YYYYMMDD], t.[TO_SITE], t.[QTY], t.[DIVISION_NAME], t.[OPERATION_GROUP_NAME], t.[NICK_NAME], t.[FROM_SITE_NAME], t.[TO_SITE_NAME], t.[ORIGIN_FROM_DIVISION_ID], t.[ORIGIN_TO_DIVISION_ID], t.[ELECTRODE_TYPE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
	from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_SEMI_C_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_SHIPMENT_PLAN_SEMI_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	