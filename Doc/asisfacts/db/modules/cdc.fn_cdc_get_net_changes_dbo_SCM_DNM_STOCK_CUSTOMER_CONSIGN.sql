
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [COMPANY_ID], NULL as [DIVISION_ID], NULL as [SITE_ID], NULL as [PLANT_ID], NULL as [ITEM_ID], NULL as [RESULT_DATE], NULL as [ITEM_NAME], NULL as [CUSTOMER_CODE], NULL as [CUSTOMER_NAME], NULL as [QTY], NULL as [UOM], NULL as [SCM_SITE_ID], NULL as [VALID_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [ORIGIN_ITEM_ID], NULL as [FINAL_SOLDTO_CODE], NULL as [FINAL_SHIPTO_CODE], NULL as [SALES_ORDER_NO], NULL as [SALES_ORDER_SEQ], NULL as [FINAL_SOLDTO_NAME], NULL as [FINAL_SHIPTO_NAME]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_38EB5BD7
	    when 1 then __$operation
	    else
			case __$min_op_38EB5BD7 
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
		null as __$update_mask , [COMPANY_ID], [DIVISION_ID], [SITE_ID], [PLANT_ID], [ITEM_ID], [RESULT_DATE], [ITEM_NAME], [CUSTOMER_CODE], [CUSTOMER_NAME], [QTY], [UOM], [SCM_SITE_ID], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [ORIGIN_ITEM_ID], [FINAL_SOLDTO_CODE], [FINAL_SHIPTO_CODE], [SALES_ORDER_NO], [SALES_ORDER_SEQ], [FINAL_SOLDTO_NAME], [FINAL_SHIPTO_NAME]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_38EB5BD7 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] c with (nolock)   
			where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  and (c.[RESULT_DATE] = t.[RESULT_DATE])  and (c.[CUSTOMER_CODE] = t.[CUSTOMER_CODE])  and (c.[FINAL_SOLDTO_CODE] = t.[FINAL_SOLDTO_CODE])  and (c.[FINAL_SHIPTO_CODE] = t.[FINAL_SHIPTO_CODE])  and (c.[SALES_ORDER_NO] = t.[SALES_ORDER_NO])  and (c.[SALES_ORDER_SEQ] = t.[SALES_ORDER_SEQ])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_38EB5BD7, __$count_38EB5BD7, t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[ITEM_ID], t.[RESULT_DATE], t.[ITEM_NAME], t.[CUSTOMER_CODE], t.[CUSTOMER_NAME], t.[QTY], t.[UOM], t.[SCM_SITE_ID], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ORIGIN_ITEM_ID], t.[FINAL_SOLDTO_CODE], t.[FINAL_SHIPTO_CODE], t.[SALES_ORDER_NO], t.[SALES_ORDER_SEQ], t.[FINAL_SOLDTO_NAME], t.[FINAL_SHIPTO_NAME] 
		from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] t with (nolock) inner join 
		(	select  r.[COMPANY_ID], r.[DIVISION_ID], r.[PLANT_ID], r.[ITEM_ID], r.[ORIGIN_ITEM_ID], r.[RESULT_DATE], r.[CUSTOMER_CODE], r.[FINAL_SOLDTO_CODE], r.[FINAL_SHIPTO_CODE], r.[SALES_ORDER_NO], r.[SALES_ORDER_SEQ],
		    count(*) as __$count_38EB5BD7 
			from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[COMPANY_ID], r.[DIVISION_ID], r.[PLANT_ID], r.[ITEM_ID], r.[ORIGIN_ITEM_ID], r.[RESULT_DATE], r.[CUSTOMER_CODE], r.[FINAL_SOLDTO_CODE], r.[FINAL_SHIPTO_CODE], r.[SALES_ORDER_NO], r.[SALES_ORDER_SEQ]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] c with (nolock) where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  and (c.[RESULT_DATE] = t.[RESULT_DATE])  and (c.[CUSTOMER_CODE] = t.[CUSTOMER_CODE])  and (c.[FINAL_SOLDTO_CODE] = t.[FINAL_SOLDTO_CODE])  and (c.[FINAL_SHIPTO_CODE] = t.[FINAL_SHIPTO_CODE])  and (c.[SALES_ORDER_NO] = t.[SALES_ORDER_NO])  and (c.[SALES_ORDER_SEQ] = t.[SALES_ORDER_SEQ])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[COMPANY_ID] = m.[COMPANY_ID]) and (t.[DIVISION_ID] = m.[DIVISION_ID])  and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[ORIGIN_ITEM_ID] = m.[ORIGIN_ITEM_ID])  and (t.[RESULT_DATE] = m.[RESULT_DATE])  and (t.[CUSTOMER_CODE] = m.[CUSTOMER_CODE])  and (t.[FINAL_SOLDTO_CODE] = m.[FINAL_SOLDTO_CODE])  and (t.[FINAL_SHIPTO_CODE] = m.[FINAL_SHIPTO_CODE])  and (t.[SALES_ORDER_NO] = m.[SALES_ORDER_NO])  and (t.[SALES_ORDER_SEQ] = m.[SALES_ORDER_SEQ])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] c with (nolock) 
							where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  and (c.[RESULT_DATE] = t.[RESULT_DATE])  and (c.[CUSTOMER_CODE] = t.[CUSTOMER_CODE])  and (c.[FINAL_SOLDTO_CODE] = t.[FINAL_SOLDTO_CODE])  and (c.[FINAL_SHIPTO_CODE] = t.[FINAL_SHIPTO_CODE])  and (c.[SALES_ORDER_NO] = t.[SALES_ORDER_NO])  and (c.[SALES_ORDER_SEQ] = t.[SALES_ORDER_SEQ])  )  
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
					[cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[COMPANY_ID] = mo.[COMPANY_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[ORIGIN_ITEM_ID] = mo.[ORIGIN_ITEM_ID])  and (t.[RESULT_DATE] = mo.[RESULT_DATE])  and (t.[CUSTOMER_CODE] = mo.[CUSTOMER_CODE])  and (t.[FINAL_SOLDTO_CODE] = mo.[FINAL_SOLDTO_CODE])  and (t.[FINAL_SHIPTO_CODE] = mo.[FINAL_SHIPTO_CODE])  and (t.[SALES_ORDER_NO] = mo.[SALES_ORDER_NO])  and (t.[SALES_ORDER_SEQ] = mo.[SALES_ORDER_SEQ])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_38EB5BD7
	    when 1 then __$operation
	    else
			case __$min_op_38EB5BD7 
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
		case __$count_38EB5BD7
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_38EB5BD7 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [COMPANY_ID], [DIVISION_ID], [SITE_ID], [PLANT_ID], [ITEM_ID], [RESULT_DATE], [ITEM_NAME], [CUSTOMER_CODE], [CUSTOMER_NAME], [QTY], [UOM], [SCM_SITE_ID], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [ORIGIN_ITEM_ID], [FINAL_SOLDTO_CODE], [FINAL_SHIPTO_CODE], [SALES_ORDER_NO], [SALES_ORDER_SEQ], [FINAL_SOLDTO_NAME], [FINAL_SHIPTO_NAME]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_38EB5BD7 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] c with (nolock)
			where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  and (c.[RESULT_DATE] = t.[RESULT_DATE])  and (c.[CUSTOMER_CODE] = t.[CUSTOMER_CODE])  and (c.[FINAL_SOLDTO_CODE] = t.[FINAL_SOLDTO_CODE])  and (c.[FINAL_SHIPTO_CODE] = t.[FINAL_SHIPTO_CODE])  and (c.[SALES_ORDER_NO] = t.[SALES_ORDER_NO])  and (c.[SALES_ORDER_SEQ] = t.[SALES_ORDER_SEQ])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_38EB5BD7, __$count_38EB5BD7, 
		m.__$update_mask , t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[ITEM_ID], t.[RESULT_DATE], t.[ITEM_NAME], t.[CUSTOMER_CODE], t.[CUSTOMER_NAME], t.[QTY], t.[UOM], t.[SCM_SITE_ID], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ORIGIN_ITEM_ID], t.[FINAL_SOLDTO_CODE], t.[FINAL_SHIPTO_CODE], t.[SALES_ORDER_NO], t.[SALES_ORDER_SEQ], t.[FINAL_SOLDTO_NAME], t.[FINAL_SHIPTO_NAME]
		from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] t with (nolock) inner join 
		(	select  r.[COMPANY_ID], r.[DIVISION_ID], r.[PLANT_ID], r.[ITEM_ID], r.[ORIGIN_ITEM_ID], r.[RESULT_DATE], r.[CUSTOMER_CODE], r.[FINAL_SOLDTO_CODE], r.[FINAL_SHIPTO_CODE], r.[SALES_ORDER_NO], r.[SALES_ORDER_SEQ],
		    count(*) as __$count_38EB5BD7, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[COMPANY_ID], r.[DIVISION_ID], r.[PLANT_ID], r.[ITEM_ID], r.[ORIGIN_ITEM_ID], r.[RESULT_DATE], r.[CUSTOMER_CODE], r.[FINAL_SOLDTO_CODE], r.[FINAL_SHIPTO_CODE], r.[SALES_ORDER_NO], r.[SALES_ORDER_SEQ]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] c with (nolock) where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  and (c.[RESULT_DATE] = t.[RESULT_DATE])  and (c.[CUSTOMER_CODE] = t.[CUSTOMER_CODE])  and (c.[FINAL_SOLDTO_CODE] = t.[FINAL_SOLDTO_CODE])  and (c.[FINAL_SHIPTO_CODE] = t.[FINAL_SHIPTO_CODE])  and (c.[SALES_ORDER_NO] = t.[SALES_ORDER_NO])  and (c.[SALES_ORDER_SEQ] = t.[SALES_ORDER_SEQ])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[COMPANY_ID] = m.[COMPANY_ID]) and (t.[DIVISION_ID] = m.[DIVISION_ID])  and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[ORIGIN_ITEM_ID] = m.[ORIGIN_ITEM_ID])  and (t.[RESULT_DATE] = m.[RESULT_DATE])  and (t.[CUSTOMER_CODE] = m.[CUSTOMER_CODE])  and (t.[FINAL_SOLDTO_CODE] = m.[FINAL_SOLDTO_CODE])  and (t.[FINAL_SHIPTO_CODE] = m.[FINAL_SHIPTO_CODE])  and (t.[SALES_ORDER_NO] = m.[SALES_ORDER_NO])  and (t.[SALES_ORDER_SEQ] = m.[SALES_ORDER_SEQ])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] c with (nolock)
							where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  and (c.[RESULT_DATE] = t.[RESULT_DATE])  and (c.[CUSTOMER_CODE] = t.[CUSTOMER_CODE])  and (c.[FINAL_SOLDTO_CODE] = t.[FINAL_SOLDTO_CODE])  and (c.[FINAL_SHIPTO_CODE] = t.[FINAL_SHIPTO_CODE])  and (c.[SALES_ORDER_NO] = t.[SALES_ORDER_NO])  and (c.[SALES_ORDER_SEQ] = t.[SALES_ORDER_SEQ])  )  
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
					[cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[COMPANY_ID] = mo.[COMPANY_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[ORIGIN_ITEM_ID] = mo.[ORIGIN_ITEM_ID])  and (t.[RESULT_DATE] = mo.[RESULT_DATE])  and (t.[CUSTOMER_CODE] = mo.[CUSTOMER_CODE])  and (t.[FINAL_SOLDTO_CODE] = mo.[FINAL_SOLDTO_CODE])  and (t.[FINAL_SHIPTO_CODE] = mo.[FINAL_SHIPTO_CODE])  and (t.[SALES_ORDER_NO] = mo.[SALES_ORDER_NO])  and (t.[SALES_ORDER_SEQ] = mo.[SALES_ORDER_SEQ])  ) 
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
		null as __$update_mask , t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[ITEM_ID], t.[RESULT_DATE], t.[ITEM_NAME], t.[CUSTOMER_CODE], t.[CUSTOMER_NAME], t.[QTY], t.[UOM], t.[SCM_SITE_ID], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ORIGIN_ITEM_ID], t.[FINAL_SOLDTO_CODE], t.[FINAL_SHIPTO_CODE], t.[SALES_ORDER_NO], t.[SALES_ORDER_SEQ], t.[FINAL_SOLDTO_NAME], t.[FINAL_SHIPTO_NAME]
		from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] c with (nolock) where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  and (c.[RESULT_DATE] = t.[RESULT_DATE])  and (c.[CUSTOMER_CODE] = t.[CUSTOMER_CODE])  and (c.[FINAL_SOLDTO_CODE] = t.[FINAL_SOLDTO_CODE])  and (c.[FINAL_SHIPTO_CODE] = t.[FINAL_SHIPTO_CODE])  and (c.[SALES_ORDER_NO] = t.[SALES_ORDER_NO])  and (c.[SALES_ORDER_SEQ] = t.[SALES_ORDER_SEQ])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] c with (nolock)
							where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[ORIGIN_ITEM_ID] = t.[ORIGIN_ITEM_ID])  and (c.[RESULT_DATE] = t.[RESULT_DATE])  and (c.[CUSTOMER_CODE] = t.[CUSTOMER_CODE])  and (c.[FINAL_SOLDTO_CODE] = t.[FINAL_SOLDTO_CODE])  and (c.[FINAL_SHIPTO_CODE] = t.[FINAL_SHIPTO_CODE])  and (c.[SALES_ORDER_NO] = t.[SALES_ORDER_NO])  and (c.[SALES_ORDER_SEQ] = t.[SALES_ORDER_SEQ])  )  
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
					[cdc].[dbo_SCM_DNM_STOCK_CUSTOMER_CONSIGN_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[COMPANY_ID] = mo.[COMPANY_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[ORIGIN_ITEM_ID] = mo.[ORIGIN_ITEM_ID])  and (t.[RESULT_DATE] = mo.[RESULT_DATE])  and (t.[CUSTOMER_CODE] = mo.[CUSTOMER_CODE])  and (t.[FINAL_SOLDTO_CODE] = mo.[FINAL_SOLDTO_CODE])  and (t.[FINAL_SHIPTO_CODE] = mo.[FINAL_SHIPTO_CODE])  and (t.[SALES_ORDER_NO] = mo.[SALES_ORDER_NO])  and (t.[SALES_ORDER_SEQ] = mo.[SALES_ORDER_SEQ])  ) 
				group by
					mo.__$seqval
			)
	 