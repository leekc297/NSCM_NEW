
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCM_DNM_STOCK_VMI]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [PLANT_ID], NULL as [STORAGE_ID], NULL as [SCM_SITE_ID], NULL as [ITEM_ID], NULL as [ORIGIN_ITEM_ID], NULL as [SALES_DOC_TYPE], NULL as [SALES_DOC_NO], NULL as [SALES_ORG], NULL as [DISTRIBUTION_CHANNEL], NULL as [SHIPMENT_NO], NULL as [DELIVERY_NO], NULL as [QTY], NULL as [UOM], NULL as [ATA_DATE], NULL as [BASE_DATE], NULL as [STATUS_CODE], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [PURCHASE_DOC_TYPE], NULL as [PURCHASE_DOC_NO]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_VMI', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[PLANT_ID], t.[STORAGE_ID], t.[SCM_SITE_ID], t.[ITEM_ID], t.[ORIGIN_ITEM_ID], t.[SALES_DOC_TYPE], t.[SALES_DOC_NO], t.[SALES_ORG], t.[DISTRIBUTION_CHANNEL], t.[SHIPMENT_NO], t.[DELIVERY_NO], t.[QTY], t.[UOM], t.[ATA_DATE], t.[BASE_DATE], t.[STATUS_CODE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[PURCHASE_DOC_TYPE], t.[PURCHASE_DOC_NO]
	from [cdc].[dbo_SCM_DNM_STOCK_VMI_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_VMI', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[PLANT_ID], t.[STORAGE_ID], t.[SCM_SITE_ID], t.[ITEM_ID], t.[ORIGIN_ITEM_ID], t.[SALES_DOC_TYPE], t.[SALES_DOC_NO], t.[SALES_ORG], t.[DISTRIBUTION_CHANNEL], t.[SHIPMENT_NO], t.[DELIVERY_NO], t.[QTY], t.[UOM], t.[ATA_DATE], t.[BASE_DATE], t.[STATUS_CODE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[PURCHASE_DOC_TYPE], t.[PURCHASE_DOC_NO]
	from [cdc].[dbo_SCM_DNM_STOCK_VMI_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_VMI', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	