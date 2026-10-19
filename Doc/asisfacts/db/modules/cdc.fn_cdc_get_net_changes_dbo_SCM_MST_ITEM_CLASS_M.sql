
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCM_MST_ITEM_CLASS_M]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [CLASS_ID], NULL as [CLASS_NAME], NULL as [ITEM_TYPE], NULL as [PROCESS_GROUP], NULL as [PROCESS_DETAIL], NULL as [LEVEL], NULL as [LEVEL_1_CODE], NULL as [LEVEL_1_NAME], NULL as [LEVEL_1_ID], NULL as [LEVEL_2_CODE], NULL as [LEVEL_2_NAME], NULL as [LEVEL_2_ID], NULL as [LEVEL_3_CODE], NULL as [LEVEL_3_NAME], NULL as [LEVEL_3_ID], NULL as [LEVEL_4_CODE], NULL as [LEVEL_4_NAME], NULL as [LEVEL_4_ID], NULL as [USE_FLAG], NULL as [INSERT_ID], NULL as [INSERT_TIME], NULL as [UPDATE_ID], NULL as [UPDATE_TIME], NULL as [MODEL_ATTRIBUTE], NULL as [MODEL_ATTRIBUTE_SEQ], NULL as [SKIP_ROUTE_FLAG], NULL as [DEFAULT_OPERATION_ID], NULL as [SCP_FLOW_ID], NULL as [SCP_OPERATION_GROUP], NULL as [SCP_OPERATION_GROUP_ID], NULL as [LEVEL_5_CODE], NULL as [LEVEL_5_NAME], NULL as [LEVEL_5_ID], NULL as [LEVEL_6_CODE], NULL as [LEVEL_6_NAME], NULL as [LEVEL_6_ID], NULL as [CELL_TYPE], NULL as [TCO_CELL_YN], NULL as [SCP_EXC_YN]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_ITEM_CLASS_M', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_767F81B4
	    when 1 then __$operation
	    else
			case __$min_op_767F81B4 
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
		null as __$update_mask , [CLASS_ID], [CLASS_NAME], [ITEM_TYPE], [PROCESS_GROUP], [PROCESS_DETAIL], [LEVEL], [LEVEL_1_CODE], [LEVEL_1_NAME], [LEVEL_1_ID], [LEVEL_2_CODE], [LEVEL_2_NAME], [LEVEL_2_ID], [LEVEL_3_CODE], [LEVEL_3_NAME], [LEVEL_3_ID], [LEVEL_4_CODE], [LEVEL_4_NAME], [LEVEL_4_ID], [USE_FLAG], [INSERT_ID], [INSERT_TIME], [UPDATE_ID], [UPDATE_TIME], [MODEL_ATTRIBUTE], [MODEL_ATTRIBUTE_SEQ], [SKIP_ROUTE_FLAG], [DEFAULT_OPERATION_ID], [SCP_FLOW_ID], [SCP_OPERATION_GROUP], [SCP_OPERATION_GROUP_ID], [LEVEL_5_CODE], [LEVEL_5_NAME], [LEVEL_5_ID], [LEVEL_6_CODE], [LEVEL_6_NAME], [LEVEL_6_ID], [CELL_TYPE], [TCO_CELL_YN], [SCP_EXC_YN]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_767F81B4 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] c with (nolock)   
			where  ( (c.[CLASS_ID] = t.[CLASS_ID]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_767F81B4, __$count_767F81B4, t.[CLASS_ID], t.[CLASS_NAME], t.[ITEM_TYPE], t.[PROCESS_GROUP], t.[PROCESS_DETAIL], t.[LEVEL], t.[LEVEL_1_CODE], t.[LEVEL_1_NAME], t.[LEVEL_1_ID], t.[LEVEL_2_CODE], t.[LEVEL_2_NAME], t.[LEVEL_2_ID], t.[LEVEL_3_CODE], t.[LEVEL_3_NAME], t.[LEVEL_3_ID], t.[LEVEL_4_CODE], t.[LEVEL_4_NAME], t.[LEVEL_4_ID], t.[USE_FLAG], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[MODEL_ATTRIBUTE], t.[MODEL_ATTRIBUTE_SEQ], t.[SKIP_ROUTE_FLAG], t.[DEFAULT_OPERATION_ID], t.[SCP_FLOW_ID], t.[SCP_OPERATION_GROUP], t.[SCP_OPERATION_GROUP_ID], t.[LEVEL_5_CODE], t.[LEVEL_5_NAME], t.[LEVEL_5_ID], t.[LEVEL_6_CODE], t.[LEVEL_6_NAME], t.[LEVEL_6_ID], t.[CELL_TYPE], t.[TCO_CELL_YN], t.[SCP_EXC_YN] 
		from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] t with (nolock) inner join 
		(	select  r.[CLASS_ID],
		    count(*) as __$count_767F81B4 
			from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[CLASS_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] c with (nolock) where  ( (c.[CLASS_ID] = t.[CLASS_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[CLASS_ID] = m.[CLASS_ID]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_ITEM_CLASS_M', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] c with (nolock) 
							where  ( (c.[CLASS_ID] = t.[CLASS_ID]) )  
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
					[cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[CLASS_ID] = mo.[CLASS_ID]) ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_767F81B4
	    when 1 then __$operation
	    else
			case __$min_op_767F81B4 
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
		case __$count_767F81B4
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_767F81B4 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [CLASS_ID], [CLASS_NAME], [ITEM_TYPE], [PROCESS_GROUP], [PROCESS_DETAIL], [LEVEL], [LEVEL_1_CODE], [LEVEL_1_NAME], [LEVEL_1_ID], [LEVEL_2_CODE], [LEVEL_2_NAME], [LEVEL_2_ID], [LEVEL_3_CODE], [LEVEL_3_NAME], [LEVEL_3_ID], [LEVEL_4_CODE], [LEVEL_4_NAME], [LEVEL_4_ID], [USE_FLAG], [INSERT_ID], [INSERT_TIME], [UPDATE_ID], [UPDATE_TIME], [MODEL_ATTRIBUTE], [MODEL_ATTRIBUTE_SEQ], [SKIP_ROUTE_FLAG], [DEFAULT_OPERATION_ID], [SCP_FLOW_ID], [SCP_OPERATION_GROUP], [SCP_OPERATION_GROUP_ID], [LEVEL_5_CODE], [LEVEL_5_NAME], [LEVEL_5_ID], [LEVEL_6_CODE], [LEVEL_6_NAME], [LEVEL_6_ID], [CELL_TYPE], [TCO_CELL_YN], [SCP_EXC_YN]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_767F81B4 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] c with (nolock)
			where  ( (c.[CLASS_ID] = t.[CLASS_ID]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_767F81B4, __$count_767F81B4, 
		m.__$update_mask , t.[CLASS_ID], t.[CLASS_NAME], t.[ITEM_TYPE], t.[PROCESS_GROUP], t.[PROCESS_DETAIL], t.[LEVEL], t.[LEVEL_1_CODE], t.[LEVEL_1_NAME], t.[LEVEL_1_ID], t.[LEVEL_2_CODE], t.[LEVEL_2_NAME], t.[LEVEL_2_ID], t.[LEVEL_3_CODE], t.[LEVEL_3_NAME], t.[LEVEL_3_ID], t.[LEVEL_4_CODE], t.[LEVEL_4_NAME], t.[LEVEL_4_ID], t.[USE_FLAG], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[MODEL_ATTRIBUTE], t.[MODEL_ATTRIBUTE_SEQ], t.[SKIP_ROUTE_FLAG], t.[DEFAULT_OPERATION_ID], t.[SCP_FLOW_ID], t.[SCP_OPERATION_GROUP], t.[SCP_OPERATION_GROUP_ID], t.[LEVEL_5_CODE], t.[LEVEL_5_NAME], t.[LEVEL_5_ID], t.[LEVEL_6_CODE], t.[LEVEL_6_NAME], t.[LEVEL_6_ID], t.[CELL_TYPE], t.[TCO_CELL_YN], t.[SCP_EXC_YN]
		from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] t with (nolock) inner join 
		(	select  r.[CLASS_ID],
		    count(*) as __$count_767F81B4, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[CLASS_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] c with (nolock) where  ( (c.[CLASS_ID] = t.[CLASS_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[CLASS_ID] = m.[CLASS_ID]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_ITEM_CLASS_M', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] c with (nolock)
							where  ( (c.[CLASS_ID] = t.[CLASS_ID]) )  
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
					[cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[CLASS_ID] = mo.[CLASS_ID]) ) 
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
		null as __$update_mask , t.[CLASS_ID], t.[CLASS_NAME], t.[ITEM_TYPE], t.[PROCESS_GROUP], t.[PROCESS_DETAIL], t.[LEVEL], t.[LEVEL_1_CODE], t.[LEVEL_1_NAME], t.[LEVEL_1_ID], t.[LEVEL_2_CODE], t.[LEVEL_2_NAME], t.[LEVEL_2_ID], t.[LEVEL_3_CODE], t.[LEVEL_3_NAME], t.[LEVEL_3_ID], t.[LEVEL_4_CODE], t.[LEVEL_4_NAME], t.[LEVEL_4_ID], t.[USE_FLAG], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[MODEL_ATTRIBUTE], t.[MODEL_ATTRIBUTE_SEQ], t.[SKIP_ROUTE_FLAG], t.[DEFAULT_OPERATION_ID], t.[SCP_FLOW_ID], t.[SCP_OPERATION_GROUP], t.[SCP_OPERATION_GROUP_ID], t.[LEVEL_5_CODE], t.[LEVEL_5_NAME], t.[LEVEL_5_ID], t.[LEVEL_6_CODE], t.[LEVEL_6_NAME], t.[LEVEL_6_ID], t.[CELL_TYPE], t.[TCO_CELL_YN], t.[SCP_EXC_YN]
		from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_ITEM_CLASS_M', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] c with (nolock) where  ( (c.[CLASS_ID] = t.[CLASS_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] c with (nolock)
							where  ( (c.[CLASS_ID] = t.[CLASS_ID]) )  
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
					[cdc].[dbo_SCM_MST_ITEM_CLASS_M_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[CLASS_ID] = mo.[CLASS_ID]) ) 
				group by
					mo.__$seqval
			)
	 