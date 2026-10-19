
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCP_RPT_ELEC_PSI]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [ORG_DIVISION_ID], NULL as [PLAN_START_YYYYMMDD], NULL as [PSI], NULL as [ELEC_MODEL], NULL as [CELL_MODEL], NULL as [ELECTRODE_TYPE], NULL as [COMPANY_ID], NULL as [PLANT_ID], NULL as [FROM_SITE], NULL as [TO_SITE], NULL as [UNIT], NULL as [MEASURE], NULL as [VALUE1], NULL as [VALUE2], NULL as [YYYYMMDD], NULL as [QTY], NULL as [CREATION_SEQ], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [PLAN_TYPE]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_RPT_ELEC_PSI', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[ORG_DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PSI], t.[ELEC_MODEL], t.[CELL_MODEL], t.[ELECTRODE_TYPE], t.[COMPANY_ID], t.[PLANT_ID], t.[FROM_SITE], t.[TO_SITE], t.[UNIT], t.[MEASURE], t.[VALUE1], t.[VALUE2], t.[YYYYMMDD], t.[QTY], t.[CREATION_SEQ], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[PLAN_TYPE]
	from [cdc].[dbo_SCP_RPT_ELEC_PSI_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_RPT_ELEC_PSI', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[ORG_DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PSI], t.[ELEC_MODEL], t.[CELL_MODEL], t.[ELECTRODE_TYPE], t.[COMPANY_ID], t.[PLANT_ID], t.[FROM_SITE], t.[TO_SITE], t.[UNIT], t.[MEASURE], t.[VALUE1], t.[VALUE2], t.[YYYYMMDD], t.[QTY], t.[CREATION_SEQ], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[PLAN_TYPE]
	from [cdc].[dbo_SCP_RPT_ELEC_PSI_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_RPT_ELEC_PSI', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	