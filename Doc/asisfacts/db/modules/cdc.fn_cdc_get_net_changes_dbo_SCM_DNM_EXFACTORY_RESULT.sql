
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCM_DNM_EXFACTORY_RESULT]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [COMPANY_ID], NULL as [DIVISION_ID], NULL as [SITE_ID], NULL as [PLANT_ID], NULL as [DOC_TYPE], NULL as [DOC_SEQ], NULL as [ORDER_NO], NULL as [ORDER_ITEM_SEQ], NULL as [DELIVERY_NO], NULL as [DELIVERY_ITEM_SEQ], NULL as [ITEM_ID], NULL as [ITEM_NAME], NULL as [EXFACTORY_STATUS], NULL as [PROJECT_CODE], NULL as [FROM_SCM_SITE_ID], NULL as [TO_SCM_SITE_ID], NULL as [PO_NO], NULL as [ORDER_QTY], NULL as [SOLDTO_CODE], NULL as [SOLDTO_NAME], NULL as [SHIPTO_NAME], NULL as [SHIPTO_CODE], NULL as [ORDER_TYPE_CODE], NULL as [ORDER_TYPE_NAME], NULL as [STORAGE_ID], NULL as [ORDER_CREATE_DATE], NULL as [DELIVERY_POSTING_DATE], NULL as [UOM], NULL as [EXFACTORY_QTY], NULL as [ON_BOARD_DATE], NULL as [ETD_DATE], NULL as [ETA_DATE], NULL as [ACTUAL_EXFACTORY_DATE], NULL as [SYSTEM_EXFACTORY_DATE], NULL as [EXFACTORY_DATE], NULL as [TRANSPORT_MODE], NULL as [INCOTERMS], NULL as [VALID_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [PLANT_ISSUE_DATE], NULL as [TRANSPORT_MODE_ERP], NULL as [ORIGIN_INCOTERMS], NULL as [ORIGIN_ITEM_ID], NULL as [SSP_TYPE], NULL as [CONFIRM_ID], NULL as [PLAN_EXFACTORY_DATE], NULL as [ACTUAL_DELIVERY_DATE], NULL as [INTRANSIT_DATE], NULL as [FACTORY_OUT_DATE], NULL as [CURRENCY_CODE], NULL as [NET_PRICE], NULL as [SALES_AMOUNT], NULL as [KRW_XRATE], NULL as [SALES_KRW_AMOUNT]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_EXFACTORY_RESULT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_1011449A
	    when 1 then __$operation
	    else
			case __$min_op_1011449A 
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
		null as __$update_mask , [COMPANY_ID], [DIVISION_ID], [SITE_ID], [PLANT_ID], [DOC_TYPE], [DOC_SEQ], [ORDER_NO], [ORDER_ITEM_SEQ], [DELIVERY_NO], [DELIVERY_ITEM_SEQ], [ITEM_ID], [ITEM_NAME], [EXFACTORY_STATUS], [PROJECT_CODE], [FROM_SCM_SITE_ID], [TO_SCM_SITE_ID], [PO_NO], [ORDER_QTY], [SOLDTO_CODE], [SOLDTO_NAME], [SHIPTO_NAME], [SHIPTO_CODE], [ORDER_TYPE_CODE], [ORDER_TYPE_NAME], [STORAGE_ID], [ORDER_CREATE_DATE], [DELIVERY_POSTING_DATE], [UOM], [EXFACTORY_QTY], [ON_BOARD_DATE], [ETD_DATE], [ETA_DATE], [ACTUAL_EXFACTORY_DATE], [SYSTEM_EXFACTORY_DATE], [EXFACTORY_DATE], [TRANSPORT_MODE], [INCOTERMS], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [PLANT_ISSUE_DATE], [TRANSPORT_MODE_ERP], [ORIGIN_INCOTERMS], [ORIGIN_ITEM_ID], [SSP_TYPE], [CONFIRM_ID], [PLAN_EXFACTORY_DATE], [ACTUAL_DELIVERY_DATE], [INTRANSIT_DATE], [FACTORY_OUT_DATE], [CURRENCY_CODE], [NET_PRICE], [SALES_AMOUNT], [KRW_XRATE], [SALES_KRW_AMOUNT]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_1011449A 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] c with (nolock)   
			where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[DOC_TYPE] = t.[DOC_TYPE])  and (c.[DOC_SEQ] = t.[DOC_SEQ])  and (c.[ORDER_NO] = t.[ORDER_NO])  and (c.[ORDER_ITEM_SEQ] = t.[ORDER_ITEM_SEQ])  and (c.[DELIVERY_NO] = t.[DELIVERY_NO])  and (c.[DELIVERY_ITEM_SEQ] = t.[DELIVERY_ITEM_SEQ])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_1011449A, __$count_1011449A, t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[DOC_TYPE], t.[DOC_SEQ], t.[ORDER_NO], t.[ORDER_ITEM_SEQ], t.[DELIVERY_NO], t.[DELIVERY_ITEM_SEQ], t.[ITEM_ID], t.[ITEM_NAME], t.[EXFACTORY_STATUS], t.[PROJECT_CODE], t.[FROM_SCM_SITE_ID], t.[TO_SCM_SITE_ID], t.[PO_NO], t.[ORDER_QTY], t.[SOLDTO_CODE], t.[SOLDTO_NAME], t.[SHIPTO_NAME], t.[SHIPTO_CODE], t.[ORDER_TYPE_CODE], t.[ORDER_TYPE_NAME], t.[STORAGE_ID], t.[ORDER_CREATE_DATE], t.[DELIVERY_POSTING_DATE], t.[UOM], t.[EXFACTORY_QTY], t.[ON_BOARD_DATE], t.[ETD_DATE], t.[ETA_DATE], t.[ACTUAL_EXFACTORY_DATE], t.[SYSTEM_EXFACTORY_DATE], t.[EXFACTORY_DATE], t.[TRANSPORT_MODE], t.[INCOTERMS], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[PLANT_ISSUE_DATE], t.[TRANSPORT_MODE_ERP], t.[ORIGIN_INCOTERMS], t.[ORIGIN_ITEM_ID], t.[SSP_TYPE], t.[CONFIRM_ID], t.[PLAN_EXFACTORY_DATE], t.[ACTUAL_DELIVERY_DATE], t.[INTRANSIT_DATE], t.[FACTORY_OUT_DATE], t.[CURRENCY_CODE], t.[NET_PRICE], t.[SALES_AMOUNT], t.[KRW_XRATE], t.[SALES_KRW_AMOUNT] 
		from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] t with (nolock) inner join 
		(	select  r.[COMPANY_ID], r.[DIVISION_ID], r.[SITE_ID], r.[PLANT_ID], r.[DOC_TYPE], r.[DOC_SEQ], r.[ORDER_NO], r.[ORDER_ITEM_SEQ], r.[DELIVERY_NO], r.[DELIVERY_ITEM_SEQ], r.[ITEM_ID], r.[ORIGIN_ITEM_ID],
		    count(*) as __$count_1011449A 
			from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[COMPANY_ID], r.[DIVISION_ID], r.[SITE_ID], r.[PLANT_ID], r.[DOC_TYPE], r.[DOC_SEQ], r.[ORDER_NO], r.[ORDER_ITEM_SEQ], r.[DELIVERY_NO], r.[DELIVERY_ITEM_SEQ], r.[ITEM_ID], r.[ORIGIN_ITEM_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] c with (nolock) where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[DOC_TYPE] = t.[DOC_TYPE])  and (c.[DOC_SEQ] = t.[DOC_SEQ])  and (c.[ORDER_NO] = t.[ORDER_NO])  and (c.[ORDER_ITEM_SEQ] = t.[ORDER_ITEM_SEQ])  and (c.[DELIVERY_NO] = t.[DELIVERY_NO])  and (c.[DELIVERY_ITEM_SEQ] = t.[DELIVERY_ITEM_SEQ])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[COMPANY_ID] = m.[COMPANY_ID]) and (t.[DIVISION_ID] = m.[DIVISION_ID])  and (t.[SITE_ID] = m.[SITE_ID])  and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[DOC_TYPE] = m.[DOC_TYPE])  and (t.[DOC_SEQ] = m.[DOC_SEQ])  and (t.[ORDER_NO] = m.[ORDER_NO])  and (t.[ORDER_ITEM_SEQ] = m.[ORDER_ITEM_SEQ])  and (t.[DELIVERY_NO] = m.[DELIVERY_NO])  and (t.[DELIVERY_ITEM_SEQ] = m.[DELIVERY_ITEM_SEQ])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[ORIGIN_ITEM_ID] = m.[ORIGIN_ITEM_ID])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_EXFACTORY_RESULT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] c with (nolock) 
							where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[DOC_TYPE] = t.[DOC_TYPE])  and (c.[DOC_SEQ] = t.[DOC_SEQ])  and (c.[ORDER_NO] = t.[ORDER_NO])  and (c.[ORDER_ITEM_SEQ] = t.[ORDER_ITEM_SEQ])  and (c.[DELIVERY_NO] = t.[DELIVERY_NO])  and (c.[DELIVERY_ITEM_SEQ] = t.[DELIVERY_ITEM_SEQ])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  )  
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
					[cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[COMPANY_ID] = mo.[COMPANY_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[SITE_ID] = mo.[SITE_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[DOC_TYPE] = mo.[DOC_TYPE])  and (t.[DOC_SEQ] = mo.[DOC_SEQ])  and (t.[ORDER_NO] = mo.[ORDER_NO])  and (t.[ORDER_ITEM_SEQ] = mo.[ORDER_ITEM_SEQ])  and (t.[DELIVERY_NO] = mo.[DELIVERY_NO])  and (t.[DELIVERY_ITEM_SEQ] = mo.[DELIVERY_ITEM_SEQ])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[ORIGIN_ITEM_ID] = mo.[ORIGIN_ITEM_ID])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_1011449A
	    when 1 then __$operation
	    else
			case __$min_op_1011449A 
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
		case __$count_1011449A
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_1011449A 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [COMPANY_ID], [DIVISION_ID], [SITE_ID], [PLANT_ID], [DOC_TYPE], [DOC_SEQ], [ORDER_NO], [ORDER_ITEM_SEQ], [DELIVERY_NO], [DELIVERY_ITEM_SEQ], [ITEM_ID], [ITEM_NAME], [EXFACTORY_STATUS], [PROJECT_CODE], [FROM_SCM_SITE_ID], [TO_SCM_SITE_ID], [PO_NO], [ORDER_QTY], [SOLDTO_CODE], [SOLDTO_NAME], [SHIPTO_NAME], [SHIPTO_CODE], [ORDER_TYPE_CODE], [ORDER_TYPE_NAME], [STORAGE_ID], [ORDER_CREATE_DATE], [DELIVERY_POSTING_DATE], [UOM], [EXFACTORY_QTY], [ON_BOARD_DATE], [ETD_DATE], [ETA_DATE], [ACTUAL_EXFACTORY_DATE], [SYSTEM_EXFACTORY_DATE], [EXFACTORY_DATE], [TRANSPORT_MODE], [INCOTERMS], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [PLANT_ISSUE_DATE], [TRANSPORT_MODE_ERP], [ORIGIN_INCOTERMS], [ORIGIN_ITEM_ID], [SSP_TYPE], [CONFIRM_ID], [PLAN_EXFACTORY_DATE], [ACTUAL_DELIVERY_DATE], [INTRANSIT_DATE], [FACTORY_OUT_DATE], [CURRENCY_CODE], [NET_PRICE], [SALES_AMOUNT], [KRW_XRATE], [SALES_KRW_AMOUNT]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_1011449A 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] c with (nolock)
			where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[DOC_TYPE] = t.[DOC_TYPE])  and (c.[DOC_SEQ] = t.[DOC_SEQ])  and (c.[ORDER_NO] = t.[ORDER_NO])  and (c.[ORDER_ITEM_SEQ] = t.[ORDER_ITEM_SEQ])  and (c.[DELIVERY_NO] = t.[DELIVERY_NO])  and (c.[DELIVERY_ITEM_SEQ] = t.[DELIVERY_ITEM_SEQ])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_1011449A, __$count_1011449A, 
		m.__$update_mask , t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[DOC_TYPE], t.[DOC_SEQ], t.[ORDER_NO], t.[ORDER_ITEM_SEQ], t.[DELIVERY_NO], t.[DELIVERY_ITEM_SEQ], t.[ITEM_ID], t.[ITEM_NAME], t.[EXFACTORY_STATUS], t.[PROJECT_CODE], t.[FROM_SCM_SITE_ID], t.[TO_SCM_SITE_ID], t.[PO_NO], t.[ORDER_QTY], t.[SOLDTO_CODE], t.[SOLDTO_NAME], t.[SHIPTO_NAME], t.[SHIPTO_CODE], t.[ORDER_TYPE_CODE], t.[ORDER_TYPE_NAME], t.[STORAGE_ID], t.[ORDER_CREATE_DATE], t.[DELIVERY_POSTING_DATE], t.[UOM], t.[EXFACTORY_QTY], t.[ON_BOARD_DATE], t.[ETD_DATE], t.[ETA_DATE], t.[ACTUAL_EXFACTORY_DATE], t.[SYSTEM_EXFACTORY_DATE], t.[EXFACTORY_DATE], t.[TRANSPORT_MODE], t.[INCOTERMS], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[PLANT_ISSUE_DATE], t.[TRANSPORT_MODE_ERP], t.[ORIGIN_INCOTERMS], t.[ORIGIN_ITEM_ID], t.[SSP_TYPE], t.[CONFIRM_ID], t.[PLAN_EXFACTORY_DATE], t.[ACTUAL_DELIVERY_DATE], t.[INTRANSIT_DATE], t.[FACTORY_OUT_DATE], t.[CURRENCY_CODE], t.[NET_PRICE], t.[SALES_AMOUNT], t.[KRW_XRATE], t.[SALES_KRW_AMOUNT]
		from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] t with (nolock) inner join 
		(	select  r.[COMPANY_ID], r.[DIVISION_ID], r.[SITE_ID], r.[PLANT_ID], r.[DOC_TYPE], r.[DOC_SEQ], r.[ORDER_NO], r.[ORDER_ITEM_SEQ], r.[DELIVERY_NO], r.[DELIVERY_ITEM_SEQ], r.[ITEM_ID], r.[ORIGIN_ITEM_ID],
		    count(*) as __$count_1011449A, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[COMPANY_ID], r.[DIVISION_ID], r.[SITE_ID], r.[PLANT_ID], r.[DOC_TYPE], r.[DOC_SEQ], r.[ORDER_NO], r.[ORDER_ITEM_SEQ], r.[DELIVERY_NO], r.[DELIVERY_ITEM_SEQ], r.[ITEM_ID], r.[ORIGIN_ITEM_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] c with (nolock) where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[DOC_TYPE] = t.[DOC_TYPE])  and (c.[DOC_SEQ] = t.[DOC_SEQ])  and (c.[ORDER_NO] = t.[ORDER_NO])  and (c.[ORDER_ITEM_SEQ] = t.[ORDER_ITEM_SEQ])  and (c.[DELIVERY_NO] = t.[DELIVERY_NO])  and (c.[DELIVERY_ITEM_SEQ] = t.[DELIVERY_ITEM_SEQ])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[COMPANY_ID] = m.[COMPANY_ID]) and (t.[DIVISION_ID] = m.[DIVISION_ID])  and (t.[SITE_ID] = m.[SITE_ID])  and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[DOC_TYPE] = m.[DOC_TYPE])  and (t.[DOC_SEQ] = m.[DOC_SEQ])  and (t.[ORDER_NO] = m.[ORDER_NO])  and (t.[ORDER_ITEM_SEQ] = m.[ORDER_ITEM_SEQ])  and (t.[DELIVERY_NO] = m.[DELIVERY_NO])  and (t.[DELIVERY_ITEM_SEQ] = m.[DELIVERY_ITEM_SEQ])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[ORIGIN_ITEM_ID] = m.[ORIGIN_ITEM_ID])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_EXFACTORY_RESULT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] c with (nolock)
							where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[DOC_TYPE] = t.[DOC_TYPE])  and (c.[DOC_SEQ] = t.[DOC_SEQ])  and (c.[ORDER_NO] = t.[ORDER_NO])  and (c.[ORDER_ITEM_SEQ] = t.[ORDER_ITEM_SEQ])  and (c.[DELIVERY_NO] = t.[DELIVERY_NO])  and (c.[DELIVERY_ITEM_SEQ] = t.[DELIVERY_ITEM_SEQ])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  )  
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
					[cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[COMPANY_ID] = mo.[COMPANY_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[SITE_ID] = mo.[SITE_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[DOC_TYPE] = mo.[DOC_TYPE])  and (t.[DOC_SEQ] = mo.[DOC_SEQ])  and (t.[ORDER_NO] = mo.[ORDER_NO])  and (t.[ORDER_ITEM_SEQ] = mo.[ORDER_ITEM_SEQ])  and (t.[DELIVERY_NO] = mo.[DELIVERY_NO])  and (t.[DELIVERY_ITEM_SEQ] = mo.[DELIVERY_ITEM_SEQ])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[ORIGIN_ITEM_ID] = mo.[ORIGIN_ITEM_ID])  ) 
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
		null as __$update_mask , t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[DOC_TYPE], t.[DOC_SEQ], t.[ORDER_NO], t.[ORDER_ITEM_SEQ], t.[DELIVERY_NO], t.[DELIVERY_ITEM_SEQ], t.[ITEM_ID], t.[ITEM_NAME], t.[EXFACTORY_STATUS], t.[PROJECT_CODE], t.[FROM_SCM_SITE_ID], t.[TO_SCM_SITE_ID], t.[PO_NO], t.[ORDER_QTY], t.[SOLDTO_CODE], t.[SOLDTO_NAME], t.[SHIPTO_NAME], t.[SHIPTO_CODE], t.[ORDER_TYPE_CODE], t.[ORDER_TYPE_NAME], t.[STORAGE_ID], t.[ORDER_CREATE_DATE], t.[DELIVERY_POSTING_DATE], t.[UOM], t.[EXFACTORY_QTY], t.[ON_BOARD_DATE], t.[ETD_DATE], t.[ETA_DATE], t.[ACTUAL_EXFACTORY_DATE], t.[SYSTEM_EXFACTORY_DATE], t.[EXFACTORY_DATE], t.[TRANSPORT_MODE], t.[INCOTERMS], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[PLANT_ISSUE_DATE], t.[TRANSPORT_MODE_ERP], t.[ORIGIN_INCOTERMS], t.[ORIGIN_ITEM_ID], t.[SSP_TYPE], t.[CONFIRM_ID], t.[PLAN_EXFACTORY_DATE], t.[ACTUAL_DELIVERY_DATE], t.[INTRANSIT_DATE], t.[FACTORY_OUT_DATE], t.[CURRENCY_CODE], t.[NET_PRICE], t.[SALES_AMOUNT], t.[KRW_XRATE], t.[SALES_KRW_AMOUNT]
		from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_EXFACTORY_RESULT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] c with (nolock) where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[DOC_TYPE] = t.[DOC_TYPE])  and (c.[DOC_SEQ] = t.[DOC_SEQ])  and (c.[ORDER_NO] = t.[ORDER_NO])  and (c.[ORDER_ITEM_SEQ] = t.[ORDER_ITEM_SEQ])  and (c.[DELIVERY_NO] = t.[DELIVERY_NO])  and (c.[DELIVERY_ITEM_SEQ] = t.[DELIVERY_ITEM_SEQ])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] c with (nolock)
							where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[DOC_TYPE] = t.[DOC_TYPE])  and (c.[DOC_SEQ] = t.[DOC_SEQ])  and (c.[ORDER_NO] = t.[ORDER_NO])  and (c.[ORDER_ITEM_SEQ] = t.[ORDER_ITEM_SEQ])  and (c.[DELIVERY_NO] = t.[DELIVERY_NO])  and (c.[DELIVERY_ITEM_SEQ] = t.[DELIVERY_ITEM_SEQ])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  )  
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
					[cdc].[dbo_SCM_DNM_EXFACTORY_RESULT_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[COMPANY_ID] = mo.[COMPANY_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[SITE_ID] = mo.[SITE_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[DOC_TYPE] = mo.[DOC_TYPE])  and (t.[DOC_SEQ] = mo.[DOC_SEQ])  and (t.[ORDER_NO] = mo.[ORDER_NO])  and (t.[ORDER_ITEM_SEQ] = mo.[ORDER_ITEM_SEQ])  and (t.[DELIVERY_NO] = mo.[DELIVERY_NO])  and (t.[DELIVERY_ITEM_SEQ] = mo.[DELIVERY_ITEM_SEQ])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[ORIGIN_ITEM_ID] = mo.[ORIGIN_ITEM_ID])  ) 
				group by
					mo.__$seqval
			)
	 