
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [COMPANY_ID], NULL as [DIVISION_ID], NULL as [SITE_ID], NULL as [PLANT_ID], NULL as [ITEM_ID], NULL as [RESULT_DATE], NULL as [ITEM_NAME], NULL as [CUSTOMER_CODE], NULL as [CUSTOMER_NAME], NULL as [QTY], NULL as [UOM], NULL as [SCM_SITE_ID], NULL as [VALID_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [ORIGIN_ITEM_ID], NULL as [FINAL_SOLDTO_CODE], NULL as [FINAL_SHIPTO_CODE], NULL as [SALES_ORDER_NO], NULL as [SALES_ORDER_SEQ], NULL as [FINAL_SOLDTO_NAME], NULL as [FINAL_SHIPTO_NAME]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[ITEM_ID], t.[RESULT_DATE], t.[ITEM_NAME], t.[CUSTOMER_CODE], t.[CUSTOMER_NAME], t.[QTY], t.[UOM], t.[SCM_SITE_ID], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ORIGIN_ITEM_ID], t.[FINAL_SOLDTO_CODE], t.[FINAL_SHIPTO_CODE], t.[SALES_ORDER_NO], t.[SALES_ORDER_SEQ], t.[FINAL_SOLDTO_NAME], t.[FINAL_SHIPTO_NAME]
	from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[ITEM_ID], t.[RESULT_DATE], t.[ITEM_NAME], t.[CUSTOMER_CODE], t.[CUSTOMER_NAME], t.[QTY], t.[UOM], t.[SCM_SITE_ID], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ORIGIN_ITEM_ID], t.[FINAL_SOLDTO_CODE], t.[FINAL_SHIPTO_CODE], t.[SALES_ORDER_NO], t.[SALES_ORDER_SEQ], t.[FINAL_SOLDTO_NAME], t.[FINAL_SHIPTO_NAME]
	from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	