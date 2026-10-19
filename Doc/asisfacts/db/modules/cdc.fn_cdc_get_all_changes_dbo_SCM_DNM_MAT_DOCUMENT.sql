
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCM_DNM_MAT_DOCUMENT]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [MAT_DOC_ID], NULL as [MAT_DOC_YEAR], NULL as [MAT_DOC_ITEM], NULL as [TRADE_TYPE], NULL as [DOC_TYPE], NULL as [DOC_PROOF_DATE], NULL as [DOC_POSTING_DATE], NULL as [DOC_INPUT_DATE], NULL as [INPUT_DATE], NULL as [USER_NAME], NULL as [MOVEMENT_TYPE], NULL as [ITEM_ID], NULL as [PLANT_ID], NULL as [STORAGE_ID], NULL as [BATCH_ID], NULL as [INVENTORY_TYPE], NULL as [INDICATOR], NULL as [SPECIAL_STOCK_INDICATOR], NULL as [SPECIAL_STOCK_INDICATOR_NAME], NULL as [VENDOR_CODE], NULL as [CUSTOMER_CODE], NULL as [CURRENCY], NULL as [MAT_AMOUNT], NULL as [MAT_QTY], NULL as [UOM], NULL as [INPUT_QTY], NULL as [INPUT_UOM], NULL as [COMPANY_ID], NULL as [IO_ITEM_ID], NULL as [IO_PLANT_ID], NULL as [IO_STORAGE_ID], NULL as [IO_BATCH_ID], NULL as [VALID_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_MAT_DOCUMENT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[MAT_DOC_ID], t.[MAT_DOC_YEAR], t.[MAT_DOC_ITEM], t.[TRADE_TYPE], t.[DOC_TYPE], t.[DOC_PROOF_DATE], t.[DOC_POSTING_DATE], t.[DOC_INPUT_DATE], t.[INPUT_DATE], t.[USER_NAME], t.[MOVEMENT_TYPE], t.[ITEM_ID], t.[PLANT_ID], t.[STORAGE_ID], t.[BATCH_ID], t.[INVENTORY_TYPE], t.[INDICATOR], t.[SPECIAL_STOCK_INDICATOR], t.[SPECIAL_STOCK_INDICATOR_NAME], t.[VENDOR_CODE], t.[CUSTOMER_CODE], t.[CURRENCY], t.[MAT_AMOUNT], t.[MAT_QTY], t.[UOM], t.[INPUT_QTY], t.[INPUT_UOM], t.[COMPANY_ID], t.[IO_ITEM_ID], t.[IO_PLANT_ID], t.[IO_STORAGE_ID], t.[IO_BATCH_ID], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
	from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_MAT_DOCUMENT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[MAT_DOC_ID], t.[MAT_DOC_YEAR], t.[MAT_DOC_ITEM], t.[TRADE_TYPE], t.[DOC_TYPE], t.[DOC_PROOF_DATE], t.[DOC_POSTING_DATE], t.[DOC_INPUT_DATE], t.[INPUT_DATE], t.[USER_NAME], t.[MOVEMENT_TYPE], t.[ITEM_ID], t.[PLANT_ID], t.[STORAGE_ID], t.[BATCH_ID], t.[INVENTORY_TYPE], t.[INDICATOR], t.[SPECIAL_STOCK_INDICATOR], t.[SPECIAL_STOCK_INDICATOR_NAME], t.[VENDOR_CODE], t.[CUSTOMER_CODE], t.[CURRENCY], t.[MAT_AMOUNT], t.[MAT_QTY], t.[UOM], t.[INPUT_QTY], t.[INPUT_UOM], t.[COMPANY_ID], t.[IO_ITEM_ID], t.[IO_PLANT_ID], t.[IO_STORAGE_ID], t.[IO_BATCH_ID], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
	from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_MAT_DOCUMENT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	