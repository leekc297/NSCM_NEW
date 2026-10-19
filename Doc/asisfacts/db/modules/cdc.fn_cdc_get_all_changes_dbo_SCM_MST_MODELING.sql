
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCM_MST_MODELING]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [MODELING_ID], NULL as [DIVISION_ID], NULL as [HOST_NAME], NULL as [ENTERPRISE], NULL as [ENGINE_ID], NULL as [PLAN_CYCLE], NULL as [SERVER_IP], NULL as [SERVER_ID], NULL as [SERVER_PASSWORD], NULL as [ENGINE_TYPE], NULL as [VALID_YN], NULL as [CREATION_DATE], NULL as [CREATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [LAST_UPDATED_BY], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [ATTRIBUTE11], NULL as [ATTRIBUTE12], NULL as [ATTRIBUTE13], NULL as [ATTRIBUTE14], NULL as [ATTRIBUTE15]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_MODELING', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[MODELING_ID], t.[DIVISION_ID], t.[HOST_NAME], t.[ENTERPRISE], t.[ENGINE_ID], t.[PLAN_CYCLE], t.[SERVER_IP], t.[SERVER_ID], t.[SERVER_PASSWORD], t.[ENGINE_TYPE], t.[VALID_YN], t.[CREATION_DATE], t.[CREATED_BY], t.[LAST_UPDATE_DATE], t.[LAST_UPDATED_BY], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15]
	from [cdc].[dbo_SCM_MST_MODELING_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_MODELING', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[MODELING_ID], t.[DIVISION_ID], t.[HOST_NAME], t.[ENTERPRISE], t.[ENGINE_ID], t.[PLAN_CYCLE], t.[SERVER_IP], t.[SERVER_ID], t.[SERVER_PASSWORD], t.[ENGINE_TYPE], t.[VALID_YN], t.[CREATION_DATE], t.[CREATED_BY], t.[LAST_UPDATE_DATE], t.[LAST_UPDATED_BY], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15]
	from [cdc].[dbo_SCM_MST_MODELING_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_MODELING', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	