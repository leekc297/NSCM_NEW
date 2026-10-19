
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCP_ANL_BUSINESS_PLAN_RTF_DM]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [PLAN_ID], NULL as [SALES_SITE], NULL as [BIZ_TYPE], NULL as [CUST], NULL as [PROJECT], NULL as [PROJECT_DESC], NULL as [MODEL], NULL as [MODEL_CODE], NULL as [CELL_NICKNAME], NULL as [CELL_CODE], NULL as [ELECTRODE], NULL as [CELL], NULL as [PACK], NULL as [UNIT], NULL as [INCOTERMS], NULL as [MEASURE], NULL as [M1_QTY], NULL as [M2_QTY], NULL as [M3_QTY], NULL as [M4_QTY], NULL as [M5_QTY], NULL as [M6_QTY], NULL as [M7_QTY], NULL as [M8_QTY], NULL as [M9_QTY], NULL as [M10_QTY], NULL as [M11_QTY], NULL as [M12_QTY], NULL as [M13_QTY], NULL as [M14_QTY], NULL as [M15_QTY], NULL as [M16_QTY], NULL as [M17_QTY], NULL as [M18_QTY], NULL as [M19_QTY], NULL as [M20_QTY], NULL as [M21_QTY], NULL as [M22_QTY], NULL as [M23_QTY], NULL as [M24_QTY], NULL as [M25_QTY], NULL as [M26_QTY], NULL as [M27_QTY], NULL as [M28_QTY], NULL as [M29_QTY], NULL as [M30_QTY], NULL as [M31_QTY], NULL as [M32_QTY], NULL as [M33_QTY], NULL as [M34_QTY], NULL as [M35_QTY], NULL as [M36_QTY], NULL as [M37_QTY], NULL as [M38_QTY], NULL as [M39_QTY], NULL as [M40_QTY], NULL as [M41_QTY], NULL as [M42_QTY], NULL as [M43_QTY], NULL as [M44_QTY], NULL as [M45_QTY], NULL as [M46_QTY], NULL as [M47_QTY], NULL as [M48_QTY], NULL as [M49_QTY], NULL as [M50_QTY], NULL as [M51_QTY], NULL as [M52_QTY], NULL as [M53_QTY], NULL as [M54_QTY], NULL as [M55_QTY], NULL as [M56_QTY], NULL as [M57_QTY], NULL as [M58_QTY], NULL as [M59_QTY], NULL as [M60_QTY], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [KEYVALUE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [ATTRIBUTE11], NULL as [ATTRIBUTE12], NULL as [ATTRIBUTE13], NULL as [ATTRIBUTE14], NULL as [ATTRIBUTE15]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_BUSINESS_PLAN_RTF_DM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[PLAN_ID], t.[SALES_SITE], t.[BIZ_TYPE], t.[CUST], t.[PROJECT], t.[PROJECT_DESC], t.[MODEL], t.[MODEL_CODE], t.[CELL_NICKNAME], t.[CELL_CODE], t.[ELECTRODE], t.[CELL], t.[PACK], t.[UNIT], t.[INCOTERMS], t.[MEASURE], t.[M1_QTY], t.[M2_QTY], t.[M3_QTY], t.[M4_QTY], t.[M5_QTY], t.[M6_QTY], t.[M7_QTY], t.[M8_QTY], t.[M9_QTY], t.[M10_QTY], t.[M11_QTY], t.[M12_QTY], t.[M13_QTY], t.[M14_QTY], t.[M15_QTY], t.[M16_QTY], t.[M17_QTY], t.[M18_QTY], t.[M19_QTY], t.[M20_QTY], t.[M21_QTY], t.[M22_QTY], t.[M23_QTY], t.[M24_QTY], t.[M25_QTY], t.[M26_QTY], t.[M27_QTY], t.[M28_QTY], t.[M29_QTY], t.[M30_QTY], t.[M31_QTY], t.[M32_QTY], t.[M33_QTY], t.[M34_QTY], t.[M35_QTY], t.[M36_QTY], t.[M37_QTY], t.[M38_QTY], t.[M39_QTY], t.[M40_QTY], t.[M41_QTY], t.[M42_QTY], t.[M43_QTY], t.[M44_QTY], t.[M45_QTY], t.[M46_QTY], t.[M47_QTY], t.[M48_QTY], t.[M49_QTY], t.[M50_QTY], t.[M51_QTY], t.[M52_QTY], t.[M53_QTY], t.[M54_QTY], t.[M55_QTY], t.[M56_QTY], t.[M57_QTY], t.[M58_QTY], t.[M59_QTY], t.[M60_QTY], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[KEYVALUE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15]
	from [cdc].[dbo_SCP_ANL_BUSINESS_PLAN_RTF_DM_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_BUSINESS_PLAN_RTF_DM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[PLAN_ID], t.[SALES_SITE], t.[BIZ_TYPE], t.[CUST], t.[PROJECT], t.[PROJECT_DESC], t.[MODEL], t.[MODEL_CODE], t.[CELL_NICKNAME], t.[CELL_CODE], t.[ELECTRODE], t.[CELL], t.[PACK], t.[UNIT], t.[INCOTERMS], t.[MEASURE], t.[M1_QTY], t.[M2_QTY], t.[M3_QTY], t.[M4_QTY], t.[M5_QTY], t.[M6_QTY], t.[M7_QTY], t.[M8_QTY], t.[M9_QTY], t.[M10_QTY], t.[M11_QTY], t.[M12_QTY], t.[M13_QTY], t.[M14_QTY], t.[M15_QTY], t.[M16_QTY], t.[M17_QTY], t.[M18_QTY], t.[M19_QTY], t.[M20_QTY], t.[M21_QTY], t.[M22_QTY], t.[M23_QTY], t.[M24_QTY], t.[M25_QTY], t.[M26_QTY], t.[M27_QTY], t.[M28_QTY], t.[M29_QTY], t.[M30_QTY], t.[M31_QTY], t.[M32_QTY], t.[M33_QTY], t.[M34_QTY], t.[M35_QTY], t.[M36_QTY], t.[M37_QTY], t.[M38_QTY], t.[M39_QTY], t.[M40_QTY], t.[M41_QTY], t.[M42_QTY], t.[M43_QTY], t.[M44_QTY], t.[M45_QTY], t.[M46_QTY], t.[M47_QTY], t.[M48_QTY], t.[M49_QTY], t.[M50_QTY], t.[M51_QTY], t.[M52_QTY], t.[M53_QTY], t.[M54_QTY], t.[M55_QTY], t.[M56_QTY], t.[M57_QTY], t.[M58_QTY], t.[M59_QTY], t.[M60_QTY], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[KEYVALUE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15]
	from [cdc].[dbo_SCP_ANL_BUSINESS_PLAN_RTF_DM_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_BUSINESS_PLAN_RTF_DM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	