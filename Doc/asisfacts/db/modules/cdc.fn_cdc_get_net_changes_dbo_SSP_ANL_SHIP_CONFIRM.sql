
	create function [cdc].[fn_cdc_get_net_changes_dbo_SSP_ANL_SHIP_CONFIRM]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [CONFIRM_ID], NULL as [CHANGE_TYPE], NULL as [SHIPMENT_STATUS], NULL as [DIVISION_ID], NULL as [PLAN_START_YYYYMMDD], NULL as [PLAN_TYPE], NULL as [SEQ], NULL as [ITEM_ID], NULL as [FROM_SITE], NULL as [TO_SITE], NULL as [YYYYMMDD], NULL as [PLANNED_QTY], NULL as [QTY], NULL as [BOD_ID], NULL as [ROUTE_ID], NULL as [BIZ_TYPE], NULL as [PROJECT_CODE], NULL as [FCST_TYPE], NULL as [FCST_ETD_DATE], NULL as [FCST_ETA_DATE], NULL as [ETD_DATE], NULL as [ETA_DATE], NULL as [INCOTERMS], NULL as [TRANSPORT_MODE], NULL as [D_COUNTRY], NULL as [D_PORT_CODE], NULL as [A_COUNTRY], NULL as [A_PORT_CODE], NULL as [CUSTOMER_LT], NULL as [TO_COUNTRY], NULL as [TO_CITY], NULL as [FROM_SITE_TYPE], NULL as [FROM_SITE_PLANT_ID], NULL as [FROM_SITE_VENDOR_ID], NULL as [FROM_SITE_SOLDTO_CODE], NULL as [FROM_SITE_SHIPTO_CODE], NULL as [FROM_SITE_COMPANY_ID], NULL as [TO_SITE_TYPE], NULL as [TO_SITE_PLANT_ID], NULL as [TO_SITE_VENDOR_ID], NULL as [TO_SITE_SOLDTO_CODE], NULL as [TO_SITE_SHIPTO_CODE], NULL as [TO_SITE_COMPANY_ID], NULL as [CHANGE_REQ_NO], NULL as [ERP_SO_NO], NULL as [ERP_SO_ITEM_NO], NULL as [ERP_DO_NO], NULL as [ERP_STATUS], NULL as [ELECTRODE_YN], NULL as [ELECTRODE_TYPE], NULL as [ORIGIN_FROM_DIVISION_ID], NULL as [ORIGIN_TO_DIVISION_ID], NULL as [PACKAGE_TYPE_CODE], NULL as [FACTORY_ID], NULL as [REQUESTOR], NULL as [BEFORE_QTY], NULL as [REMARKS], NULL as [REMARKS2], NULL as [REMARKS3], NULL as [CHECK_NEED_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [PACKAGE_QTY], NULL as [DOM_EXP], NULL as [ERP_ATTR1], NULL as [ERP_ATTR2], NULL as [ERP_ATTR3], NULL as [ERP_ATTR4], NULL as [ERP_ATTR5]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_ANL_SHIP_CONFIRM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_5B2A0DAA
	    when 1 then __$operation
	    else
			case __$min_op_5B2A0DAA 
				when 2 then 2
				when 4 then
				case __$operation
					when 1 then 1
					else 4
					end
				else
				case __$operation
					when 2 then 4
					when 4 then 4
					else 1
					end
			end
		end as __$operation,
		null as __$update_mask , [CONFIRM_ID], [CHANGE_TYPE], [SHIPMENT_STATUS], [DIVISION_ID], [PLAN_START_YYYYMMDD], [PLAN_TYPE], [SEQ], [ITEM_ID], [FROM_SITE], [TO_SITE], [YYYYMMDD], [PLANNED_QTY], [QTY], [BOD_ID], [ROUTE_ID], [BIZ_TYPE], [PROJECT_CODE], [FCST_TYPE], [FCST_ETD_DATE], [FCST_ETA_DATE], [ETD_DATE], [ETA_DATE], [INCOTERMS], [TRANSPORT_MODE], [D_COUNTRY], [D_PORT_CODE], [A_COUNTRY], [A_PORT_CODE], [CUSTOMER_LT], [TO_COUNTRY], [TO_CITY], [FROM_SITE_TYPE], [FROM_SITE_PLANT_ID], [FROM_SITE_VENDOR_ID], [FROM_SITE_SOLDTO_CODE], [FROM_SITE_SHIPTO_CODE], [FROM_SITE_COMPANY_ID], [TO_SITE_TYPE], [TO_SITE_PLANT_ID], [TO_SITE_VENDOR_ID], [TO_SITE_SOLDTO_CODE], [TO_SITE_SHIPTO_CODE], [TO_SITE_COMPANY_ID], [CHANGE_REQ_NO], [ERP_SO_NO], [ERP_SO_ITEM_NO], [ERP_DO_NO], [ERP_STATUS], [ELECTRODE_YN], [ELECTRODE_TYPE], [ORIGIN_FROM_DIVISION_ID], [ORIGIN_TO_DIVISION_ID], [PACKAGE_TYPE_CODE], [FACTORY_ID], [REQUESTOR], [BEFORE_QTY], [REMARKS], [REMARKS2], [REMARKS3], [CHECK_NEED_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [PACKAGE_QTY], [DOM_EXP], [ERP_ATTR1], [ERP_ATTR2], [ERP_ATTR3], [ERP_ATTR4], [ERP_ATTR5]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_5B2A0DAA 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] c with (nolock)   
			where  ( (c.[CONFIRM_ID] = t.[CONFIRM_ID]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_5B2A0DAA, __$count_5B2A0DAA, t.[CONFIRM_ID], t.[CHANGE_TYPE], t.[SHIPMENT_STATUS], t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[ITEM_ID], t.[FROM_SITE], t.[TO_SITE], t.[YYYYMMDD], t.[PLANNED_QTY], t.[QTY], t.[BOD_ID], t.[ROUTE_ID], t.[BIZ_TYPE], t.[PROJECT_CODE], t.[FCST_TYPE], t.[FCST_ETD_DATE], t.[FCST_ETA_DATE], t.[ETD_DATE], t.[ETA_DATE], t.[INCOTERMS], t.[TRANSPORT_MODE], t.[D_COUNTRY], t.[D_PORT_CODE], t.[A_COUNTRY], t.[A_PORT_CODE], t.[CUSTOMER_LT], t.[TO_COUNTRY], t.[TO_CITY], t.[FROM_SITE_TYPE], t.[FROM_SITE_PLANT_ID], t.[FROM_SITE_VENDOR_ID], t.[FROM_SITE_SOLDTO_CODE], t.[FROM_SITE_SHIPTO_CODE], t.[FROM_SITE_COMPANY_ID], t.[TO_SITE_TYPE], t.[TO_SITE_PLANT_ID], t.[TO_SITE_VENDOR_ID], t.[TO_SITE_SOLDTO_CODE], t.[TO_SITE_SHIPTO_CODE], t.[TO_SITE_COMPANY_ID], t.[CHANGE_REQ_NO], t.[ERP_SO_NO], t.[ERP_SO_ITEM_NO], t.[ERP_DO_NO], t.[ERP_STATUS], t.[ELECTRODE_YN], t.[ELECTRODE_TYPE], t.[ORIGIN_FROM_DIVISION_ID], t.[ORIGIN_TO_DIVISION_ID], t.[PACKAGE_TYPE_CODE], t.[FACTORY_ID], t.[REQUESTOR], t.[BEFORE_QTY], t.[REMARKS], t.[REMARKS2], t.[REMARKS3], t.[CHECK_NEED_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[PACKAGE_QTY], t.[DOM_EXP], t.[ERP_ATTR1], t.[ERP_ATTR2], t.[ERP_ATTR3], t.[ERP_ATTR4], t.[ERP_ATTR5] 
		from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] t with (nolock) inner join 
		(	select  r.[CONFIRM_ID],
		    count(*) as __$count_5B2A0DAA 
			from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[CONFIRM_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] c with (nolock) where  ( (c.[CONFIRM_ID] = t.[CONFIRM_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[CONFIRM_ID] = m.[CONFIRM_ID]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_ANL_SHIP_CONFIRM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] c with (nolock) 
							where  ( (c.[CONFIRM_ID] = t.[CONFIRM_ID]) )  
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$start_lsn, c.__$command_id, c.__$seqval
						 ) 
	 			   )
	 			 )
	 			) 
			and t.__$operation = (
				select
					max(mo.__$operation)
				from
					[cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[CONFIRM_ID] = mo.[CONFIRM_ID]) ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_5B2A0DAA
	    when 1 then __$operation
	    else
			case __$min_op_5B2A0DAA 
				when 2 then 2
				when 4 then
				case __$operation
					when 1 then 1
					else 4
					end
				else
				case __$operation
					when 2 then 4
					when 4 then 4
					else 1
					end
			end
		end as __$operation,
		case __$count_5B2A0DAA
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_5B2A0DAA 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [CONFIRM_ID], [CHANGE_TYPE], [SHIPMENT_STATUS], [DIVISION_ID], [PLAN_START_YYYYMMDD], [PLAN_TYPE], [SEQ], [ITEM_ID], [FROM_SITE], [TO_SITE], [YYYYMMDD], [PLANNED_QTY], [QTY], [BOD_ID], [ROUTE_ID], [BIZ_TYPE], [PROJECT_CODE], [FCST_TYPE], [FCST_ETD_DATE], [FCST_ETA_DATE], [ETD_DATE], [ETA_DATE], [INCOTERMS], [TRANSPORT_MODE], [D_COUNTRY], [D_PORT_CODE], [A_COUNTRY], [A_PORT_CODE], [CUSTOMER_LT], [TO_COUNTRY], [TO_CITY], [FROM_SITE_TYPE], [FROM_SITE_PLANT_ID], [FROM_SITE_VENDOR_ID], [FROM_SITE_SOLDTO_CODE], [FROM_SITE_SHIPTO_CODE], [FROM_SITE_COMPANY_ID], [TO_SITE_TYPE], [TO_SITE_PLANT_ID], [TO_SITE_VENDOR_ID], [TO_SITE_SOLDTO_CODE], [TO_SITE_SHIPTO_CODE], [TO_SITE_COMPANY_ID], [CHANGE_REQ_NO], [ERP_SO_NO], [ERP_SO_ITEM_NO], [ERP_DO_NO], [ERP_STATUS], [ELECTRODE_YN], [ELECTRODE_TYPE], [ORIGIN_FROM_DIVISION_ID], [ORIGIN_TO_DIVISION_ID], [PACKAGE_TYPE_CODE], [FACTORY_ID], [REQUESTOR], [BEFORE_QTY], [REMARKS], [REMARKS2], [REMARKS3], [CHECK_NEED_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [PACKAGE_QTY], [DOM_EXP], [ERP_ATTR1], [ERP_ATTR2], [ERP_ATTR3], [ERP_ATTR4], [ERP_ATTR5]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_5B2A0DAA 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] c with (nolock)
			where  ( (c.[CONFIRM_ID] = t.[CONFIRM_ID]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_5B2A0DAA, __$count_5B2A0DAA, 
		m.__$update_mask , t.[CONFIRM_ID], t.[CHANGE_TYPE], t.[SHIPMENT_STATUS], t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[ITEM_ID], t.[FROM_SITE], t.[TO_SITE], t.[YYYYMMDD], t.[PLANNED_QTY], t.[QTY], t.[BOD_ID], t.[ROUTE_ID], t.[BIZ_TYPE], t.[PROJECT_CODE], t.[FCST_TYPE], t.[FCST_ETD_DATE], t.[FCST_ETA_DATE], t.[ETD_DATE], t.[ETA_DATE], t.[INCOTERMS], t.[TRANSPORT_MODE], t.[D_COUNTRY], t.[D_PORT_CODE], t.[A_COUNTRY], t.[A_PORT_CODE], t.[CUSTOMER_LT], t.[TO_COUNTRY], t.[TO_CITY], t.[FROM_SITE_TYPE], t.[FROM_SITE_PLANT_ID], t.[FROM_SITE_VENDOR_ID], t.[FROM_SITE_SOLDTO_CODE], t.[FROM_SITE_SHIPTO_CODE], t.[FROM_SITE_COMPANY_ID], t.[TO_SITE_TYPE], t.[TO_SITE_PLANT_ID], t.[TO_SITE_VENDOR_ID], t.[TO_SITE_SOLDTO_CODE], t.[TO_SITE_SHIPTO_CODE], t.[TO_SITE_COMPANY_ID], t.[CHANGE_REQ_NO], t.[ERP_SO_NO], t.[ERP_SO_ITEM_NO], t.[ERP_DO_NO], t.[ERP_STATUS], t.[ELECTRODE_YN], t.[ELECTRODE_TYPE], t.[ORIGIN_FROM_DIVISION_ID], t.[ORIGIN_TO_DIVISION_ID], t.[PACKAGE_TYPE_CODE], t.[FACTORY_ID], t.[REQUESTOR], t.[BEFORE_QTY], t.[REMARKS], t.[REMARKS2], t.[REMARKS3], t.[CHECK_NEED_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[PACKAGE_QTY], t.[DOM_EXP], t.[ERP_ATTR1], t.[ERP_ATTR2], t.[ERP_ATTR3], t.[ERP_ATTR4], t.[ERP_ATTR5]
		from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] t with (nolock) inner join 
		(	select  r.[CONFIRM_ID],
		    count(*) as __$count_5B2A0DAA, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[CONFIRM_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] c with (nolock) where  ( (c.[CONFIRM_ID] = t.[CONFIRM_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[CONFIRM_ID] = m.[CONFIRM_ID]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_ANL_SHIP_CONFIRM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] c with (nolock)
							where  ( (c.[CONFIRM_ID] = t.[CONFIRM_ID]) )  
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$start_lsn, c.__$command_id, c.__$seqval
						 ) 
	 			   )
	 			 )
	 			) 
			and t.__$operation = (
				select
					max(mo.__$operation)
				from
					[cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[CONFIRM_ID] = mo.[CONFIRM_ID]) ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
		select t.__$start_lsn as __$start_lsn,
		case t.__$operation
			when 1 then 1
			else 5
		end as __$operation,
		null as __$update_mask , t.[CONFIRM_ID], t.[CHANGE_TYPE], t.[SHIPMENT_STATUS], t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[ITEM_ID], t.[FROM_SITE], t.[TO_SITE], t.[YYYYMMDD], t.[PLANNED_QTY], t.[QTY], t.[BOD_ID], t.[ROUTE_ID], t.[BIZ_TYPE], t.[PROJECT_CODE], t.[FCST_TYPE], t.[FCST_ETD_DATE], t.[FCST_ETA_DATE], t.[ETD_DATE], t.[ETA_DATE], t.[INCOTERMS], t.[TRANSPORT_MODE], t.[D_COUNTRY], t.[D_PORT_CODE], t.[A_COUNTRY], t.[A_PORT_CODE], t.[CUSTOMER_LT], t.[TO_COUNTRY], t.[TO_CITY], t.[FROM_SITE_TYPE], t.[FROM_SITE_PLANT_ID], t.[FROM_SITE_VENDOR_ID], t.[FROM_SITE_SOLDTO_CODE], t.[FROM_SITE_SHIPTO_CODE], t.[FROM_SITE_COMPANY_ID], t.[TO_SITE_TYPE], t.[TO_SITE_PLANT_ID], t.[TO_SITE_VENDOR_ID], t.[TO_SITE_SOLDTO_CODE], t.[TO_SITE_SHIPTO_CODE], t.[TO_SITE_COMPANY_ID], t.[CHANGE_REQ_NO], t.[ERP_SO_NO], t.[ERP_SO_ITEM_NO], t.[ERP_DO_NO], t.[ERP_STATUS], t.[ELECTRODE_YN], t.[ELECTRODE_TYPE], t.[ORIGIN_FROM_DIVISION_ID], t.[ORIGIN_TO_DIVISION_ID], t.[PACKAGE_TYPE_CODE], t.[FACTORY_ID], t.[REQUESTOR], t.[BEFORE_QTY], t.[REMARKS], t.[REMARKS2], t.[REMARKS3], t.[CHECK_NEED_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[PACKAGE_QTY], t.[DOM_EXP], t.[ERP_ATTR1], t.[ERP_ATTR2], t.[ERP_ATTR3], t.[ERP_ATTR4], t.[ERP_ATTR5]
		from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_ANL_SHIP_CONFIRM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] c with (nolock) where  ( (c.[CONFIRM_ID] = t.[CONFIRM_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] c with (nolock)
							where  ( (c.[CONFIRM_ID] = t.[CONFIRM_ID]) )  
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$start_lsn, c.__$command_id, c.__$seqval
						 ) 
	 				)
	 			 )
	 			)
			and t.__$operation = (
				select
					max(mo.__$operation)
				from
					[cdc].[dbo_SSP_ANL_SHIP_CONFIRM_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[CONFIRM_ID] = mo.[CONFIRM_ID]) ) 
				group by
					mo.__$seqval
			)
	 