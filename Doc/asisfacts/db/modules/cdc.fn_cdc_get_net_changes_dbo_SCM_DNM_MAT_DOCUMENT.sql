
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCM_DNM_MAT_DOCUMENT]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [MAT_DOC_ID], NULL as [MAT_DOC_YEAR], NULL as [MAT_DOC_ITEM], NULL as [TRADE_TYPE], NULL as [DOC_TYPE], NULL as [DOC_PROOF_DATE], NULL as [DOC_POSTING_DATE], NULL as [DOC_INPUT_DATE], NULL as [INPUT_DATE], NULL as [USER_NAME], NULL as [MOVEMENT_TYPE], NULL as [ITEM_ID], NULL as [PLANT_ID], NULL as [STORAGE_ID], NULL as [BATCH_ID], NULL as [INVENTORY_TYPE], NULL as [INDICATOR], NULL as [SPECIAL_STOCK_INDICATOR], NULL as [SPECIAL_STOCK_INDICATOR_NAME], NULL as [VENDOR_CODE], NULL as [CUSTOMER_CODE], NULL as [CURRENCY], NULL as [MAT_AMOUNT], NULL as [MAT_QTY], NULL as [UOM], NULL as [INPUT_QTY], NULL as [INPUT_UOM], NULL as [COMPANY_ID], NULL as [IO_ITEM_ID], NULL as [IO_PLANT_ID], NULL as [IO_STORAGE_ID], NULL as [IO_BATCH_ID], NULL as [VALID_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_MAT_DOCUMENT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_84B39753
	    when 1 then __$operation
	    else
			case __$min_op_84B39753 
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
		null as __$update_mask , [MAT_DOC_ID], [MAT_DOC_YEAR], [MAT_DOC_ITEM], [TRADE_TYPE], [DOC_TYPE], [DOC_PROOF_DATE], [DOC_POSTING_DATE], [DOC_INPUT_DATE], [INPUT_DATE], [USER_NAME], [MOVEMENT_TYPE], [ITEM_ID], [PLANT_ID], [STORAGE_ID], [BATCH_ID], [INVENTORY_TYPE], [INDICATOR], [SPECIAL_STOCK_INDICATOR], [SPECIAL_STOCK_INDICATOR_NAME], [VENDOR_CODE], [CUSTOMER_CODE], [CURRENCY], [MAT_AMOUNT], [MAT_QTY], [UOM], [INPUT_QTY], [INPUT_UOM], [COMPANY_ID], [IO_ITEM_ID], [IO_PLANT_ID], [IO_STORAGE_ID], [IO_BATCH_ID], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_84B39753 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] c with (nolock)   
			where  ( (c.[MAT_DOC_ID] = t.[MAT_DOC_ID]) and (c.[MAT_DOC_YEAR] = t.[MAT_DOC_YEAR])  and (c.[MAT_DOC_ITEM] = t.[MAT_DOC_ITEM])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_84B39753, __$count_84B39753, t.[MAT_DOC_ID], t.[MAT_DOC_YEAR], t.[MAT_DOC_ITEM], t.[TRADE_TYPE], t.[DOC_TYPE], t.[DOC_PROOF_DATE], t.[DOC_POSTING_DATE], t.[DOC_INPUT_DATE], t.[INPUT_DATE], t.[USER_NAME], t.[MOVEMENT_TYPE], t.[ITEM_ID], t.[PLANT_ID], t.[STORAGE_ID], t.[BATCH_ID], t.[INVENTORY_TYPE], t.[INDICATOR], t.[SPECIAL_STOCK_INDICATOR], t.[SPECIAL_STOCK_INDICATOR_NAME], t.[VENDOR_CODE], t.[CUSTOMER_CODE], t.[CURRENCY], t.[MAT_AMOUNT], t.[MAT_QTY], t.[UOM], t.[INPUT_QTY], t.[INPUT_UOM], t.[COMPANY_ID], t.[IO_ITEM_ID], t.[IO_PLANT_ID], t.[IO_STORAGE_ID], t.[IO_BATCH_ID], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10] 
		from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] t with (nolock) inner join 
		(	select  r.[MAT_DOC_ID], r.[MAT_DOC_YEAR], r.[MAT_DOC_ITEM],
		    count(*) as __$count_84B39753 
			from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[MAT_DOC_ID], r.[MAT_DOC_YEAR], r.[MAT_DOC_ITEM]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] c with (nolock) where  ( (c.[MAT_DOC_ID] = t.[MAT_DOC_ID]) and (c.[MAT_DOC_YEAR] = t.[MAT_DOC_YEAR])  and (c.[MAT_DOC_ITEM] = t.[MAT_DOC_ITEM])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[MAT_DOC_ID] = m.[MAT_DOC_ID]) and (t.[MAT_DOC_YEAR] = m.[MAT_DOC_YEAR])  and (t.[MAT_DOC_ITEM] = m.[MAT_DOC_ITEM])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_MAT_DOCUMENT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] c with (nolock) 
							where  ( (c.[MAT_DOC_ID] = t.[MAT_DOC_ID]) and (c.[MAT_DOC_YEAR] = t.[MAT_DOC_YEAR])  and (c.[MAT_DOC_ITEM] = t.[MAT_DOC_ITEM])  )  
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
					[cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[MAT_DOC_ID] = mo.[MAT_DOC_ID]) and (t.[MAT_DOC_YEAR] = mo.[MAT_DOC_YEAR])  and (t.[MAT_DOC_ITEM] = mo.[MAT_DOC_ITEM])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_84B39753
	    when 1 then __$operation
	    else
			case __$min_op_84B39753 
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
		case __$count_84B39753
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_84B39753 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [MAT_DOC_ID], [MAT_DOC_YEAR], [MAT_DOC_ITEM], [TRADE_TYPE], [DOC_TYPE], [DOC_PROOF_DATE], [DOC_POSTING_DATE], [DOC_INPUT_DATE], [INPUT_DATE], [USER_NAME], [MOVEMENT_TYPE], [ITEM_ID], [PLANT_ID], [STORAGE_ID], [BATCH_ID], [INVENTORY_TYPE], [INDICATOR], [SPECIAL_STOCK_INDICATOR], [SPECIAL_STOCK_INDICATOR_NAME], [VENDOR_CODE], [CUSTOMER_CODE], [CURRENCY], [MAT_AMOUNT], [MAT_QTY], [UOM], [INPUT_QTY], [INPUT_UOM], [COMPANY_ID], [IO_ITEM_ID], [IO_PLANT_ID], [IO_STORAGE_ID], [IO_BATCH_ID], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_84B39753 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] c with (nolock)
			where  ( (c.[MAT_DOC_ID] = t.[MAT_DOC_ID]) and (c.[MAT_DOC_YEAR] = t.[MAT_DOC_YEAR])  and (c.[MAT_DOC_ITEM] = t.[MAT_DOC_ITEM])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_84B39753, __$count_84B39753, 
		m.__$update_mask , t.[MAT_DOC_ID], t.[MAT_DOC_YEAR], t.[MAT_DOC_ITEM], t.[TRADE_TYPE], t.[DOC_TYPE], t.[DOC_PROOF_DATE], t.[DOC_POSTING_DATE], t.[DOC_INPUT_DATE], t.[INPUT_DATE], t.[USER_NAME], t.[MOVEMENT_TYPE], t.[ITEM_ID], t.[PLANT_ID], t.[STORAGE_ID], t.[BATCH_ID], t.[INVENTORY_TYPE], t.[INDICATOR], t.[SPECIAL_STOCK_INDICATOR], t.[SPECIAL_STOCK_INDICATOR_NAME], t.[VENDOR_CODE], t.[CUSTOMER_CODE], t.[CURRENCY], t.[MAT_AMOUNT], t.[MAT_QTY], t.[UOM], t.[INPUT_QTY], t.[INPUT_UOM], t.[COMPANY_ID], t.[IO_ITEM_ID], t.[IO_PLANT_ID], t.[IO_STORAGE_ID], t.[IO_BATCH_ID], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] t with (nolock) inner join 
		(	select  r.[MAT_DOC_ID], r.[MAT_DOC_YEAR], r.[MAT_DOC_ITEM],
		    count(*) as __$count_84B39753, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[MAT_DOC_ID], r.[MAT_DOC_YEAR], r.[MAT_DOC_ITEM]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] c with (nolock) where  ( (c.[MAT_DOC_ID] = t.[MAT_DOC_ID]) and (c.[MAT_DOC_YEAR] = t.[MAT_DOC_YEAR])  and (c.[MAT_DOC_ITEM] = t.[MAT_DOC_ITEM])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[MAT_DOC_ID] = m.[MAT_DOC_ID]) and (t.[MAT_DOC_YEAR] = m.[MAT_DOC_YEAR])  and (t.[MAT_DOC_ITEM] = m.[MAT_DOC_ITEM])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_MAT_DOCUMENT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] c with (nolock)
							where  ( (c.[MAT_DOC_ID] = t.[MAT_DOC_ID]) and (c.[MAT_DOC_YEAR] = t.[MAT_DOC_YEAR])  and (c.[MAT_DOC_ITEM] = t.[MAT_DOC_ITEM])  )  
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
					[cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[MAT_DOC_ID] = mo.[MAT_DOC_ID]) and (t.[MAT_DOC_YEAR] = mo.[MAT_DOC_YEAR])  and (t.[MAT_DOC_ITEM] = mo.[MAT_DOC_ITEM])  ) 
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
		null as __$update_mask , t.[MAT_DOC_ID], t.[MAT_DOC_YEAR], t.[MAT_DOC_ITEM], t.[TRADE_TYPE], t.[DOC_TYPE], t.[DOC_PROOF_DATE], t.[DOC_POSTING_DATE], t.[DOC_INPUT_DATE], t.[INPUT_DATE], t.[USER_NAME], t.[MOVEMENT_TYPE], t.[ITEM_ID], t.[PLANT_ID], t.[STORAGE_ID], t.[BATCH_ID], t.[INVENTORY_TYPE], t.[INDICATOR], t.[SPECIAL_STOCK_INDICATOR], t.[SPECIAL_STOCK_INDICATOR_NAME], t.[VENDOR_CODE], t.[CUSTOMER_CODE], t.[CURRENCY], t.[MAT_AMOUNT], t.[MAT_QTY], t.[UOM], t.[INPUT_QTY], t.[INPUT_UOM], t.[COMPANY_ID], t.[IO_ITEM_ID], t.[IO_PLANT_ID], t.[IO_STORAGE_ID], t.[IO_BATCH_ID], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_MAT_DOCUMENT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] c with (nolock) where  ( (c.[MAT_DOC_ID] = t.[MAT_DOC_ID]) and (c.[MAT_DOC_YEAR] = t.[MAT_DOC_YEAR])  and (c.[MAT_DOC_ITEM] = t.[MAT_DOC_ITEM])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] c with (nolock)
							where  ( (c.[MAT_DOC_ID] = t.[MAT_DOC_ID]) and (c.[MAT_DOC_YEAR] = t.[MAT_DOC_YEAR])  and (c.[MAT_DOC_ITEM] = t.[MAT_DOC_ITEM])  )  
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
					[cdc].[dbo_SCM_DNM_MAT_DOCUMENT_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[MAT_DOC_ID] = mo.[MAT_DOC_ID]) and (t.[MAT_DOC_YEAR] = mo.[MAT_DOC_YEAR])  and (t.[MAT_DOC_ITEM] = mo.[MAT_DOC_ITEM])  ) 
				group by
					mo.__$seqval
			)
	 