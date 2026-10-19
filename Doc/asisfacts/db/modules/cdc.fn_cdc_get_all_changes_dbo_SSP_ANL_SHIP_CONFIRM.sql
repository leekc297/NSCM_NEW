
	create function [cdc].[fn_cdc_get_all_changes_dbo_SSP_ANL_SHIP_CONFIRM]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [CONFIRM_ID], NULL as [CHANGE_TYPE], NULL as [SHIPMENT_STATUS], NULL as [DIVISION_ID], NULL as [PLAN_START_YYYYMMDD], NULL as [PLAN_TYPE], NULL as [SEQ], NULL as [ITEM_ID], NULL as [FROM_SITE], NULL as [TO_SITE], NULL as [YYYYMMDD], NULL as [PLANNED_QTY], NULL as [QTY], NULL as [BOD_ID], NULL as [ROUTE_ID], NULL as [BIZ_TYPE], NULL as [PROJECT_CODE], NULL as [FCST_TYPE], NULL as [FCST_ETD_DATE], NULL as [FCST_ETA_DATE], NULL as [ETD_DATE], NULL as [ETA_DATE], NULL as [INCOTERMS], NULL as [TRANSPORT_MODE], NULL as [D_COUNTRY], NULL as [D_PORT_CODE], NULL as [A_COUNTRY], NULL as [A_PORT_CODE], NULL as [CUSTOMER_LT], NULL as [TO_COUNTRY], NULL as [TO_CITY], NULL as [FROM_SITE_TYPE], NULL as [FROM_SITE_PLANT_ID], NULL as [FROM_SITE_VENDOR_ID], NULL as [FROM_SITE_SOLDTO_CODE], NULL as [FROM_SITE_SHIPTO_CODE], NULL as [FROM_SITE_COMPANY_ID], NULL as [TO_SITE_TYPE], NULL as [TO_SITE_PLANT_ID], NULL as [TO_SITE_VENDOR_ID], NULL as [TO_SITE_SOLDTO_CODE], NULL as [TO_SITE_SHIPTO_CODE], NULL as [TO_SITE_COMPANY_ID], NULL as [CHANGE_REQ_NO], NULL as [ERP_SO_NO], NULL as [ERP_SO_ITEM_NO], NULL as [ERP_DO_NO], NULL as [ERP_STATUS], NULL as [ELECTRODE_YN], NULL as [ELECTRODE_TYPE], NULL as [ORIGIN_FROM_DIVISION_ID], NULL as [ORIGIN_TO_DIVISION_ID], NULL as [PACKAGE_TYPE_CODE], NULL as [FACTORY_ID], NULL as [REQUESTOR], NULL as [BEFORE_QTY], NULL as [REMARKS], NULL as [REMARKS2], NULL as [REMARKS3], NULL as [CHECK_NEED_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [PACKAGE_QTY], NULL as [DOM_EXP], NULL as [ERP_ATTR1], NULL as [ERP_ATTR2], NULL as [ERP_ATTR3], NULL as [ERP_ATTR4], NULL as [ERP_ATTR5]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_ANL_SHIP_CONFIRM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[CONFIRM_ID], t.[CHANGE_TYPE], t.[SHIPMENT_STATUS], t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[ITEM_ID], t.[FROM_SITE], t.[TO_SITE], t.[YYYYMMDD], t.[PLANNED_QTY], t.[QTY], t.[BOD_ID], t.[ROUTE_ID], t.[BIZ_TYPE], t.[PROJECT_CODE], t.[FCST_TYPE], t.[FCST_ETD_DATE], t.[FCST_ETA_DATE], t.[ETD_DATE], t.[ETA_DATE], t.[INCOTERMS], t.[TRANSPORT_MODE], t.[D_COUNTRY], t.[D_PORT_CODE], t.[A_COUNTRY], t.[A_PORT_CODE], t.[CUSTOMER_LT], t.[TO_COUNTRY], t.[TO_CITY], t.[FROM_SITE_TYPE], t.[FROM_SITE_PLANT_ID], t.[FROM_SITE_VENDOR_ID], t.[FROM_SITE_SOLDTO_CODE], t.[FROM_SITE_SHIPTO_CODE], t.[FROM_SITE_COMPANY_ID], t.[TO_SITE_TYPE], t.[TO_SITE_PLANT_ID], t.[TO_SITE_VENDOR_ID], t.[TO_SITE_SOLDTO_CODE], t.[TO_SITE_SHIPTO_CODE], t.[TO_SITE_COMPANY_ID], t.[CHANGE_REQ_NO], t.[ERP_SO_NO], t.[ERP_SO_ITEM_NO], t.[ERP_DO_NO], t.[ERP_STATUS], t.[ELECTRODE_YN], t.[ELECTRODE_TYPE], t.[ORIGIN_FROM_DIVISION_ID], t.[ORIGIN_TO_DIVISION_ID], t.[PACKAGE_TYPE_CODE], t.[FACTORY_ID], t.[REQUESTOR], t.[BEFORE_QTY], t.[REMARKS], t.[REMARKS2], t.[REMARKS3], t.[CHECK_NEED_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[PACKAGE_QTY], t.[DOM_EXP], t.[ERP_ATTR1], t.[ERP_ATTR2], t.[ERP_ATTR3], t.[ERP_ATTR4], t.[ERP_ATTR5]
	from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_ANL_SHIP_CONFIRM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[CONFIRM_ID], t.[CHANGE_TYPE], t.[SHIPMENT_STATUS], t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[ITEM_ID], t.[FROM_SITE], t.[TO_SITE], t.[YYYYMMDD], t.[PLANNED_QTY], t.[QTY], t.[BOD_ID], t.[ROUTE_ID], t.[BIZ_TYPE], t.[PROJECT_CODE], t.[FCST_TYPE], t.[FCST_ETD_DATE], t.[FCST_ETA_DATE], t.[ETD_DATE], t.[ETA_DATE], t.[INCOTERMS], t.[TRANSPORT_MODE], t.[D_COUNTRY], t.[D_PORT_CODE], t.[A_COUNTRY], t.[A_PORT_CODE], t.[CUSTOMER_LT], t.[TO_COUNTRY], t.[TO_CITY], t.[FROM_SITE_TYPE], t.[FROM_SITE_PLANT_ID], t.[FROM_SITE_VENDOR_ID], t.[FROM_SITE_SOLDTO_CODE], t.[FROM_SITE_SHIPTO_CODE], t.[FROM_SITE_COMPANY_ID], t.[TO_SITE_TYPE], t.[TO_SITE_PLANT_ID], t.[TO_SITE_VENDOR_ID], t.[TO_SITE_SOLDTO_CODE], t.[TO_SITE_SHIPTO_CODE], t.[TO_SITE_COMPANY_ID], t.[CHANGE_REQ_NO], t.[ERP_SO_NO], t.[ERP_SO_ITEM_NO], t.[ERP_DO_NO], t.[ERP_STATUS], t.[ELECTRODE_YN], t.[ELECTRODE_TYPE], t.[ORIGIN_FROM_DIVISION_ID], t.[ORIGIN_TO_DIVISION_ID], t.[PACKAGE_TYPE_CODE], t.[FACTORY_ID], t.[REQUESTOR], t.[BEFORE_QTY], t.[REMARKS], t.[REMARKS2], t.[REMARKS3], t.[CHECK_NEED_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[PACKAGE_QTY], t.[DOM_EXP], t.[ERP_ATTR1], t.[ERP_ATTR2], t.[ERP_ATTR3], t.[ERP_ATTR4], t.[ERP_ATTR5]
	from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_ANL_SHIP_CONFIRM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	