
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCP_MST_DIO]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [YYYYMM], NULL as [YYYYQ], NULL as [DIVISION_ID], NULL as [PLANT_ID], NULL as [ITEM_ID], NULL as [RMPH_DIV_CODE], NULL as [RMPH_DIV_NAME], NULL as [PLNT_AREA_DIV_CODE], NULL as [PLNT_AREA_DIV_NAME], NULL as [WKPC_GRP_CODE], NULL as [WKPC_GRP_NAME], NULL as [REP_CUST_CODE], NULL as [REP_CUST_NAME], NULL as [STK_MNG_MTRL_GRP_CODE], NULL as [STK_MNG_MTRL_GRP_NAME], NULL as [TOTAL_YN], NULL as [SEQ], NULL as [GRO_STD_DIO], NULL as [MIN_STD_DIO], NULL as [CYCL_STD_DIO], NULL as [TRNSP_STD_DIO], NULL as [WKPC_STD_DIO], NULL as [SFT_STD_DIO], NULL as [ETC_STD_DIO], NULL as [VMI_STD_DIO], NULL as [CHANGE_REASON], NULL as [DESCRIPTION], NULL as [DH_LOD_DATE], NULL as [DH_MDF_DATE], NULL as [created_by], NULL as [creation_date], NULL as [last_updated_by], NULL as [last_update_date]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_DIO', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[YYYYMM], t.[YYYYQ], t.[DIVISION_ID], t.[PLANT_ID], t.[ITEM_ID], t.[RMPH_DIV_CODE], t.[RMPH_DIV_NAME], t.[PLNT_AREA_DIV_CODE], t.[PLNT_AREA_DIV_NAME], t.[WKPC_GRP_CODE], t.[WKPC_GRP_NAME], t.[REP_CUST_CODE], t.[REP_CUST_NAME], t.[STK_MNG_MTRL_GRP_CODE], t.[STK_MNG_MTRL_GRP_NAME], t.[TOTAL_YN], t.[SEQ], t.[GRO_STD_DIO], t.[MIN_STD_DIO], t.[CYCL_STD_DIO], t.[TRNSP_STD_DIO], t.[WKPC_STD_DIO], t.[SFT_STD_DIO], t.[ETC_STD_DIO], t.[VMI_STD_DIO], t.[CHANGE_REASON], t.[DESCRIPTION], t.[DH_LOD_DATE], t.[DH_MDF_DATE], t.[created_by], t.[creation_date], t.[last_updated_by], t.[last_update_date]
	from [cdc].[dbo_SCP_MST_DIO_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_DIO', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[YYYYMM], t.[YYYYQ], t.[DIVISION_ID], t.[PLANT_ID], t.[ITEM_ID], t.[RMPH_DIV_CODE], t.[RMPH_DIV_NAME], t.[PLNT_AREA_DIV_CODE], t.[PLNT_AREA_DIV_NAME], t.[WKPC_GRP_CODE], t.[WKPC_GRP_NAME], t.[REP_CUST_CODE], t.[REP_CUST_NAME], t.[STK_MNG_MTRL_GRP_CODE], t.[STK_MNG_MTRL_GRP_NAME], t.[TOTAL_YN], t.[SEQ], t.[GRO_STD_DIO], t.[MIN_STD_DIO], t.[CYCL_STD_DIO], t.[TRNSP_STD_DIO], t.[WKPC_STD_DIO], t.[SFT_STD_DIO], t.[ETC_STD_DIO], t.[VMI_STD_DIO], t.[CHANGE_REASON], t.[DESCRIPTION], t.[DH_LOD_DATE], t.[DH_MDF_DATE], t.[created_by], t.[creation_date], t.[last_updated_by], t.[last_update_date]
	from [cdc].[dbo_SCP_MST_DIO_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_DIO', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	