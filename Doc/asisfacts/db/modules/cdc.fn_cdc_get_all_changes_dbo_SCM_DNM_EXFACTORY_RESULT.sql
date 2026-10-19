
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCM_DNM_EXFACTORY_RESULT]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [COMPANY_ID], NULL as [DIVISION_ID], NULL as [SITE_ID], NULL as [PLANT_ID], NULL as [DOC_TYPE], NULL as [DOC_SEQ], NULL as [ORDER_NO], NULL as [ORDER_ITEM_SEQ], NULL as [DELIVERY_NO], NULL as [DELIVERY_ITEM_SEQ], NULL as [ITEM_ID], NULL as [ITEM_NAME], NULL as [EXFACTORY_STATUS], NULL as [PROJECT_CODE], NULL as [FROM_SCM_SITE_ID], NULL as [TO_SCM_SITE_ID], NULL as [PO_NO], NULL as [ORDER_QTY], NULL as [SOLDTO_CODE], NULL as [SOLDTO_NAME], NULL as [SHIPTO_NAME], NULL as [SHIPTO_CODE], NULL as [ORDER_TYPE_CODE], NULL as [ORDER_TYPE_NAME], NULL as [STORAGE_ID], NULL as [ORDER_CREATE_DATE], NULL as [DELIVERY_POSTING_DATE], NULL as [UOM], NULL as [EXFACTORY_QTY], NULL as [ON_BOARD_DATE], NULL as [ETD_DATE], NULL as [ETA_DATE], NULL as [ACTUAL_EXFACTORY_DATE], NULL as [SYSTEM_EXFACTORY_DATE], NULL as [EXFACTORY_DATE], NULL as [TRANSPORT_MODE], NULL as [INCOTERMS], NULL as [VALID_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [PLANT_ISSUE_DATE], NULL as [TRANSPORT_MODE_ERP], NULL as [ORIGIN_INCOTERMS], NULL as [ORIGIN_ITEM_ID], NULL as [SSP_TYPE], NULL as [CONFIRM_ID], NULL as [PLAN_EXFACTORY_DATE], NULL as [ACTUAL_DELIVERY_DATE], NULL as [INTRANSIT_DATE], NULL as [FACTORY_OUT_DATE], NULL as [CURRENCY_CODE], NULL as [NET_PRICE], NULL as [SALES_AMOUNT], NULL as [KRW_XRATE], NULL as [SALES_KRW_AMOUNT]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_EXFACTORY_RESULT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[DOC_TYPE], t.[DOC_SEQ], t.[ORDER_NO], t.[ORDER_ITEM_SEQ], t.[DELIVERY_NO], t.[DELIVERY_ITEM_SEQ], t.[ITEM_ID], t.[ITEM_NAME], t.[EXFACTORY_STATUS], t.[PROJECT_CODE], t.[FROM_SCM_SITE_ID], t.[TO_SCM_SITE_ID], t.[PO_NO], t.[ORDER_QTY], t.[SOLDTO_CODE], t.[SOLDTO_NAME], t.[SHIPTO_NAME], t.[SHIPTO_CODE], t.[ORDER_TYPE_CODE], t.[ORDER_TYPE_NAME], t.[STORAGE_ID], t.[ORDER_CREATE_DATE], t.[DELIVERY_POSTING_DATE], t.[UOM], t.[EXFACTORY_QTY], t.[ON_BOARD_DATE], t.[ETD_DATE], t.[ETA_DATE], t.[ACTUAL_EXFACTORY_DATE], t.[SYSTEM_EXFACTORY_DATE], t.[EXFACTORY_DATE], t.[TRANSPORT_MODE], t.[INCOTERMS], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[PLANT_ISSUE_DATE], t.[TRANSPORT_MODE_ERP], t.[ORIGIN_INCOTERMS], t.[ORIGIN_ITEM_ID], t.[SSP_TYPE], t.[CONFIRM_ID], t.[PLAN_EXFACTORY_DATE], t.[ACTUAL_DELIVERY_DATE], t.[INTRANSIT_DATE], t.[FACTORY_OUT_DATE], t.[CURRENCY_CODE], t.[NET_PRICE], t.[SALES_AMOUNT], t.[KRW_XRATE], t.[SALES_KRW_AMOUNT]
	from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_EXFACTORY_RESULT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[DOC_TYPE], t.[DOC_SEQ], t.[ORDER_NO], t.[ORDER_ITEM_SEQ], t.[DELIVERY_NO], t.[DELIVERY_ITEM_SEQ], t.[ITEM_ID], t.[ITEM_NAME], t.[EXFACTORY_STATUS], t.[PROJECT_CODE], t.[FROM_SCM_SITE_ID], t.[TO_SCM_SITE_ID], t.[PO_NO], t.[ORDER_QTY], t.[SOLDTO_CODE], t.[SOLDTO_NAME], t.[SHIPTO_NAME], t.[SHIPTO_CODE], t.[ORDER_TYPE_CODE], t.[ORDER_TYPE_NAME], t.[STORAGE_ID], t.[ORDER_CREATE_DATE], t.[DELIVERY_POSTING_DATE], t.[UOM], t.[EXFACTORY_QTY], t.[ON_BOARD_DATE], t.[ETD_DATE], t.[ETA_DATE], t.[ACTUAL_EXFACTORY_DATE], t.[SYSTEM_EXFACTORY_DATE], t.[EXFACTORY_DATE], t.[TRANSPORT_MODE], t.[INCOTERMS], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[PLANT_ISSUE_DATE], t.[TRANSPORT_MODE_ERP], t.[ORIGIN_INCOTERMS], t.[ORIGIN_ITEM_ID], t.[SSP_TYPE], t.[CONFIRM_ID], t.[PLAN_EXFACTORY_DATE], t.[ACTUAL_DELIVERY_DATE], t.[INTRANSIT_DATE], t.[FACTORY_OUT_DATE], t.[CURRENCY_CODE], t.[NET_PRICE], t.[SALES_AMOUNT], t.[KRW_XRATE], t.[SALES_KRW_AMOUNT]
	from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_EXFACTORY_RESULT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	