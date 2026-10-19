
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCM_MST_SSO_USER_INFO]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [USER_ID], NULL as [USER_NAME], NULL as [USER_NAME_EN], NULL as [DEPT_ID], NULL as [JOB_CODE], NULL as [JOB_NAME], NULL as [COMPANY_ID], NULL as [WORKING_CODE], NULL as [WORKING_NAME], NULL as [SSO_LOCATE], NULL as [ACTIVE_FLAG], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [Attribute1], NULL as [Attribute2], NULL as [Attribute3], NULL as [Attribute4], NULL as [Attribute5], NULL as [Attribute6], NULL as [Attribute7], NULL as [Attribute8], NULL as [Attribute9], NULL as [Attribute10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SSO_USER_INFO', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[USER_ID], t.[USER_NAME], t.[USER_NAME_EN], t.[DEPT_ID], t.[JOB_CODE], t.[JOB_NAME], t.[COMPANY_ID], t.[WORKING_CODE], t.[WORKING_NAME], t.[SSO_LOCATE], t.[ACTIVE_FLAG], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[Attribute1], t.[Attribute2], t.[Attribute3], t.[Attribute4], t.[Attribute5], t.[Attribute6], t.[Attribute7], t.[Attribute8], t.[Attribute9], t.[Attribute10]
	from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SSO_USER_INFO', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[USER_ID], t.[USER_NAME], t.[USER_NAME_EN], t.[DEPT_ID], t.[JOB_CODE], t.[JOB_NAME], t.[COMPANY_ID], t.[WORKING_CODE], t.[WORKING_NAME], t.[SSO_LOCATE], t.[ACTIVE_FLAG], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[Attribute1], t.[Attribute2], t.[Attribute3], t.[Attribute4], t.[Attribute5], t.[Attribute6], t.[Attribute7], t.[Attribute8], t.[Attribute9], t.[Attribute10]
	from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SSO_USER_INFO', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	