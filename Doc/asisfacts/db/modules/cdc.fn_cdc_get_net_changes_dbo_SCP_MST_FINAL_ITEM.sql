
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCP_MST_FINAL_ITEM]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [ITEM_ID], NULL as [NICK_NAME], NULL as [ITEM_CLASS], NULL as [OPERATION_GROUP], NULL as [OPERATION_GROUP_ID], NULL as [ELECTRODE_TYPE], NULL as [FLOW_ID], NULL as [DEMAND_GROUPING_DAYS], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [PACKER_PLAN_ITEM_ID], NULL as [TCO_CELL_YN], NULL as [CELL_TYPE_GROUP_CODE], NULL as [CELL_ITEM_ID], NULL as [CONVERT_QTY_CELL], NULL as [FCST_YN], NULL as [MIN_DUE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [GROUP_CODE1], NULL as [GROUP_CODE2], NULL as [GROUP_CODE3], NULL as [GROUP_CODE4], NULL as [GROUP_CODE5], NULL as [ATTRIBUTE11], NULL as [ATTRIBUTE12], NULL as [ATTRIBUTE13], NULL as [ATTRIBUTE14], NULL as [ATTRIBUTE15], NULL as [SALES_MODEL], NULL as [SALES_VALID_YN], NULL as [SALES_PRIORITY], NULL as [SALES_FROM_YYYYMMDD], NULL as [SALES_TO_YYYYMMDD], NULL as [LEVEL1_GROUP], NULL as [LEVEL2_CODE], NULL as [STATUS_PROTOTYPE], NULL as [STATUS_MASS], NULL as [STATUS_NEW], NULL as [CELL_CF], NULL as [END_CUSTOMER], NULL as [FINISHED_PRODUCT], NULL as [REMARK], NULL as [MKT_DEPT], NULL as [GROUP_CODE6], NULL as [GROUP_CODE7], NULL as [GROUP_CODE8], NULL as [GROUP_CODE9], NULL as [GROUP_CODE10], NULL as [SCP_EXTRA_SPEC], NULL as [REPLACEMENT]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_FINAL_ITEM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_33D0D317
	    when 1 then __$operation
	    else
			case __$min_op_33D0D317 
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
		null as __$update_mask , [DIVISION_ID], [ITEM_ID], [NICK_NAME], [ITEM_CLASS], [OPERATION_GROUP], [OPERATION_GROUP_ID], [ELECTRODE_TYPE], [FLOW_ID], [DEMAND_GROUPING_DAYS], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [PACKER_PLAN_ITEM_ID], [TCO_CELL_YN], [CELL_TYPE_GROUP_CODE], [CELL_ITEM_ID], [CONVERT_QTY_CELL], [FCST_YN], [MIN_DUE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [GROUP_CODE1], [GROUP_CODE2], [GROUP_CODE3], [GROUP_CODE4], [GROUP_CODE5], [ATTRIBUTE11], [ATTRIBUTE12], [ATTRIBUTE13], [ATTRIBUTE14], [ATTRIBUTE15], [SALES_MODEL], [SALES_VALID_YN], [SALES_PRIORITY], [SALES_FROM_YYYYMMDD], [SALES_TO_YYYYMMDD], [LEVEL1_GROUP], [LEVEL2_CODE], [STATUS_PROTOTYPE], [STATUS_MASS], [STATUS_NEW], [CELL_CF], [END_CUSTOMER], [FINISHED_PRODUCT], [REMARK], [MKT_DEPT], [GROUP_CODE6], [GROUP_CODE7], [GROUP_CODE8], [GROUP_CODE9], [GROUP_CODE10], [SCP_EXTRA_SPEC], [REPLACEMENT]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_33D0D317 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] c with (nolock)   
			where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[ITEM_ID] = t.[ITEM_ID])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_33D0D317, __$count_33D0D317, t.[DIVISION_ID], t.[ITEM_ID], t.[NICK_NAME], t.[ITEM_CLASS], t.[OPERATION_GROUP], t.[OPERATION_GROUP_ID], t.[ELECTRODE_TYPE], t.[FLOW_ID], t.[DEMAND_GROUPING_DAYS], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[PACKER_PLAN_ITEM_ID], t.[TCO_CELL_YN], t.[CELL_TYPE_GROUP_CODE], t.[CELL_ITEM_ID], t.[CONVERT_QTY_CELL], t.[FCST_YN], t.[MIN_DUE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[GROUP_CODE1], t.[GROUP_CODE2], t.[GROUP_CODE3], t.[GROUP_CODE4], t.[GROUP_CODE5], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[SALES_MODEL], t.[SALES_VALID_YN], t.[SALES_PRIORITY], t.[SALES_FROM_YYYYMMDD], t.[SALES_TO_YYYYMMDD], t.[LEVEL1_GROUP], t.[LEVEL2_CODE], t.[STATUS_PROTOTYPE], t.[STATUS_MASS], t.[STATUS_NEW], t.[CELL_CF], t.[END_CUSTOMER], t.[FINISHED_PRODUCT], t.[REMARK], t.[MKT_DEPT], t.[GROUP_CODE6], t.[GROUP_CODE7], t.[GROUP_CODE8], t.[GROUP_CODE9], t.[GROUP_CODE10], t.[SCP_EXTRA_SPEC], t.[REPLACEMENT] 
		from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] t with (nolock) inner join 
		(	select  r.[DIVISION_ID], r.[ITEM_ID],
		    count(*) as __$count_33D0D317 
			from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[DIVISION_ID], r.[ITEM_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[ITEM_ID] = t.[ITEM_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[DIVISION_ID] = m.[DIVISION_ID]) and (t.[ITEM_ID] = m.[ITEM_ID])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_FINAL_ITEM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] c with (nolock) 
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[ITEM_ID] = t.[ITEM_ID])  )  
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
					[cdc].[dbo_SCP_MST_FINAL_ITEM_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[ITEM_ID] = mo.[ITEM_ID])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_33D0D317
	    when 1 then __$operation
	    else
			case __$min_op_33D0D317 
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
		case __$count_33D0D317
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_33D0D317 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [DIVISION_ID], [ITEM_ID], [NICK_NAME], [ITEM_CLASS], [OPERATION_GROUP], [OPERATION_GROUP_ID], [ELECTRODE_TYPE], [FLOW_ID], [DEMAND_GROUPING_DAYS], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [PACKER_PLAN_ITEM_ID], [TCO_CELL_YN], [CELL_TYPE_GROUP_CODE], [CELL_ITEM_ID], [CONVERT_QTY_CELL], [FCST_YN], [MIN_DUE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [GROUP_CODE1], [GROUP_CODE2], [GROUP_CODE3], [GROUP_CODE4], [GROUP_CODE5], [ATTRIBUTE11], [ATTRIBUTE12], [ATTRIBUTE13], [ATTRIBUTE14], [ATTRIBUTE15], [SALES_MODEL], [SALES_VALID_YN], [SALES_PRIORITY], [SALES_FROM_YYYYMMDD], [SALES_TO_YYYYMMDD], [LEVEL1_GROUP], [LEVEL2_CODE], [STATUS_PROTOTYPE], [STATUS_MASS], [STATUS_NEW], [CELL_CF], [END_CUSTOMER], [FINISHED_PRODUCT], [REMARK], [MKT_DEPT], [GROUP_CODE6], [GROUP_CODE7], [GROUP_CODE8], [GROUP_CODE9], [GROUP_CODE10], [SCP_EXTRA_SPEC], [REPLACEMENT]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_33D0D317 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] c with (nolock)
			where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[ITEM_ID] = t.[ITEM_ID])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_33D0D317, __$count_33D0D317, 
		m.__$update_mask , t.[DIVISION_ID], t.[ITEM_ID], t.[NICK_NAME], t.[ITEM_CLASS], t.[OPERATION_GROUP], t.[OPERATION_GROUP_ID], t.[ELECTRODE_TYPE], t.[FLOW_ID], t.[DEMAND_GROUPING_DAYS], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[PACKER_PLAN_ITEM_ID], t.[TCO_CELL_YN], t.[CELL_TYPE_GROUP_CODE], t.[CELL_ITEM_ID], t.[CONVERT_QTY_CELL], t.[FCST_YN], t.[MIN_DUE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[GROUP_CODE1], t.[GROUP_CODE2], t.[GROUP_CODE3], t.[GROUP_CODE4], t.[GROUP_CODE5], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[SALES_MODEL], t.[SALES_VALID_YN], t.[SALES_PRIORITY], t.[SALES_FROM_YYYYMMDD], t.[SALES_TO_YYYYMMDD], t.[LEVEL1_GROUP], t.[LEVEL2_CODE], t.[STATUS_PROTOTYPE], t.[STATUS_MASS], t.[STATUS_NEW], t.[CELL_CF], t.[END_CUSTOMER], t.[FINISHED_PRODUCT], t.[REMARK], t.[MKT_DEPT], t.[GROUP_CODE6], t.[GROUP_CODE7], t.[GROUP_CODE8], t.[GROUP_CODE9], t.[GROUP_CODE10], t.[SCP_EXTRA_SPEC], t.[REPLACEMENT]
		from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] t with (nolock) inner join 
		(	select  r.[DIVISION_ID], r.[ITEM_ID],
		    count(*) as __$count_33D0D317, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[DIVISION_ID], r.[ITEM_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[ITEM_ID] = t.[ITEM_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[DIVISION_ID] = m.[DIVISION_ID]) and (t.[ITEM_ID] = m.[ITEM_ID])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_FINAL_ITEM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] c with (nolock)
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[ITEM_ID] = t.[ITEM_ID])  )  
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
					[cdc].[dbo_SCP_MST_FINAL_ITEM_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[ITEM_ID] = mo.[ITEM_ID])  ) 
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
		null as __$update_mask , t.[DIVISION_ID], t.[ITEM_ID], t.[NICK_NAME], t.[ITEM_CLASS], t.[OPERATION_GROUP], t.[OPERATION_GROUP_ID], t.[ELECTRODE_TYPE], t.[FLOW_ID], t.[DEMAND_GROUPING_DAYS], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[PACKER_PLAN_ITEM_ID], t.[TCO_CELL_YN], t.[CELL_TYPE_GROUP_CODE], t.[CELL_ITEM_ID], t.[CONVERT_QTY_CELL], t.[FCST_YN], t.[MIN_DUE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[GROUP_CODE1], t.[GROUP_CODE2], t.[GROUP_CODE3], t.[GROUP_CODE4], t.[GROUP_CODE5], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[SALES_MODEL], t.[SALES_VALID_YN], t.[SALES_PRIORITY], t.[SALES_FROM_YYYYMMDD], t.[SALES_TO_YYYYMMDD], t.[LEVEL1_GROUP], t.[LEVEL2_CODE], t.[STATUS_PROTOTYPE], t.[STATUS_MASS], t.[STATUS_NEW], t.[CELL_CF], t.[END_CUSTOMER], t.[FINISHED_PRODUCT], t.[REMARK], t.[MKT_DEPT], t.[GROUP_CODE6], t.[GROUP_CODE7], t.[GROUP_CODE8], t.[GROUP_CODE9], t.[GROUP_CODE10], t.[SCP_EXTRA_SPEC], t.[REPLACEMENT]
		from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_FINAL_ITEM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[ITEM_ID] = t.[ITEM_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_MST_FINAL_ITEM_CT] c with (nolock)
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[ITEM_ID] = t.[ITEM_ID])  )  
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
					[cdc].[dbo_SCP_MST_FINAL_ITEM_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[ITEM_ID] = mo.[ITEM_ID])  ) 
				group by
					mo.__$seqval
			)
	 