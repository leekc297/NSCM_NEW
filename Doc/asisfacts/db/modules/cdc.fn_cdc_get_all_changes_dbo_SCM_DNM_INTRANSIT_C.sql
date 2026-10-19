
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCM_DNM_INTRANSIT_C]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [RESULT_DATE], NULL as [RESULT_TYPE], NULL as [COMPANY_ID], NULL as [DIVISION_ID], NULL as [PLANT_ID], NULL as [SHIPMENT_NO], NULL as [PROJECT_CODE], NULL as [ITEM_ID], NULL as [PLANT_ISSUE_DATE], NULL as [INCOTERMS], NULL as [FCST_TYPE], NULL as [DOM_EXP], NULL as [CUSTOMER_CODE], NULL as [SHIPTO_CODE], NULL as [FROM_SCM_SITE_ID], NULL as [FROM_SITE_ITEM_MAPPING_YN], NULL as [TO_SCM_SITE_ID], NULL as [TO_SITE_ITEM_MAPPING_YN], NULL as [DELIVERY_QTY], NULL as [UOM], NULL as [TRANSPORT_MODE], NULL as [SHIPPING_DATE], NULL as [POL], NULL as [POL_ATD_DATE], NULL as [POD], NULL as [POD_ETA_DATE], NULL as [POD_ATA_DATE], NULL as [POD_ETD_DATE], NULL as [POD_ATD_DATE], NULL as [F_DEST_PORT_CODE], NULL as [F_DEST_ETA_DATE], NULL as [F_DEST_ATA_DATE], NULL as [VALID_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [FINAL_SOLDTO_CODE], NULL as [FINAL_SOLDTO_NAME], NULL as [FINAL_INCOTERMS]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_INTRANSIT_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[RESULT_DATE], t.[RESULT_TYPE], t.[COMPANY_ID], t.[DIVISION_ID], t.[PLANT_ID], t.[SHIPMENT_NO], t.[PROJECT_CODE], t.[ITEM_ID], t.[PLANT_ISSUE_DATE], t.[INCOTERMS], t.[FCST_TYPE], t.[DOM_EXP], t.[CUSTOMER_CODE], t.[SHIPTO_CODE], t.[FROM_SCM_SITE_ID], t.[FROM_SITE_ITEM_MAPPING_YN], t.[TO_SCM_SITE_ID], t.[TO_SITE_ITEM_MAPPING_YN], t.[DELIVERY_QTY], t.[UOM], t.[TRANSPORT_MODE], t.[SHIPPING_DATE], t.[POL], t.[POL_ATD_DATE], t.[POD], t.[POD_ETA_DATE], t.[POD_ATA_DATE], t.[POD_ETD_DATE], t.[POD_ATD_DATE], t.[F_DEST_PORT_CODE], t.[F_DEST_ETA_DATE], t.[F_DEST_ATA_DATE], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[FINAL_SOLDTO_CODE], t.[FINAL_SOLDTO_NAME], t.[FINAL_INCOTERMS]
	from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_INTRANSIT_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[RESULT_DATE], t.[RESULT_TYPE], t.[COMPANY_ID], t.[DIVISION_ID], t.[PLANT_ID], t.[SHIPMENT_NO], t.[PROJECT_CODE], t.[ITEM_ID], t.[PLANT_ISSUE_DATE], t.[INCOTERMS], t.[FCST_TYPE], t.[DOM_EXP], t.[CUSTOMER_CODE], t.[SHIPTO_CODE], t.[FROM_SCM_SITE_ID], t.[FROM_SITE_ITEM_MAPPING_YN], t.[TO_SCM_SITE_ID], t.[TO_SITE_ITEM_MAPPING_YN], t.[DELIVERY_QTY], t.[UOM], t.[TRANSPORT_MODE], t.[SHIPPING_DATE], t.[POL], t.[POL_ATD_DATE], t.[POD], t.[POD_ETA_DATE], t.[POD_ATA_DATE], t.[POD_ETD_DATE], t.[POD_ATD_DATE], t.[F_DEST_PORT_CODE], t.[F_DEST_ETA_DATE], t.[F_DEST_ATA_DATE], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[FINAL_SOLDTO_CODE], t.[FINAL_SOLDTO_NAME], t.[FINAL_INCOTERMS]
	from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_INTRANSIT_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	