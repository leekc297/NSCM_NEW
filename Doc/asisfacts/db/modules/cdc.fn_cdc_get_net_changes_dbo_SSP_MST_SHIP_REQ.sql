
	create function [cdc].[fn_cdc_get_net_changes_dbo_SSP_MST_SHIP_REQ]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [REQ_MST_ID], NULL as [DIVISION_ID], NULL as [PLAN_START_YYYYMMDD], NULL as [PLAN_TYPE], NULL as [SEQ], NULL as [REQ_START_DATE], NULL as [REQ_END_DATE], NULL as [REQ_IN_START_DATE], NULL as [REQ_IN_END_DATE], NULL as [CONFIRM_START_DATE], NULL as [CONFIRM_END_DATE], NULL as [CUTOFF_DATE], NULL as [CUTOFF_FLAG], NULL as [CUTOFF_CREATION_DATE], NULL as [CONFIRM_FLAG], NULL as [CONFIRM_DATE], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_MST_SHIP_REQ', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_9FA8A37A
	    when 1 then __$operation
	    else
			case __$min_op_9FA8A37A 
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
		null as __$update_mask , [REQ_MST_ID], [DIVISION_ID], [PLAN_START_YYYYMMDD], [PLAN_TYPE], [SEQ], [REQ_START_DATE], [REQ_END_DATE], [REQ_IN_START_DATE], [REQ_IN_END_DATE], [CONFIRM_START_DATE], [CONFIRM_END_DATE], [CUTOFF_DATE], [CUTOFF_FLAG], [CUTOFF_CREATION_DATE], [CONFIRM_FLAG], [CONFIRM_DATE], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_9FA8A37A 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SSP_MST_SHIP_REQ_CT] c with (nolock)   
			where  ( (c.[REQ_MST_ID] = t.[REQ_MST_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_9FA8A37A, __$count_9FA8A37A, t.[REQ_MST_ID], t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[REQ_START_DATE], t.[REQ_END_DATE], t.[REQ_IN_START_DATE], t.[REQ_IN_END_DATE], t.[CONFIRM_START_DATE], t.[CONFIRM_END_DATE], t.[CUTOFF_DATE], t.[CUTOFF_FLAG], t.[CUTOFF_CREATION_DATE], t.[CONFIRM_FLAG], t.[CONFIRM_DATE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10] 
		from [cdc].[dbo_SSP_MST_SHIP_REQ_CT] t with (nolock) inner join 
		(	select  r.[REQ_MST_ID], r.[DIVISION_ID],
		    count(*) as __$count_9FA8A37A 
			from [cdc].[dbo_SSP_MST_SHIP_REQ_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[REQ_MST_ID], r.[DIVISION_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SSP_MST_SHIP_REQ_CT] c with (nolock) where  ( (c.[REQ_MST_ID] = t.[REQ_MST_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[REQ_MST_ID] = m.[REQ_MST_ID]) and (t.[DIVISION_ID] = m.[DIVISION_ID])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_MST_SHIP_REQ', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SSP_MST_SHIP_REQ_CT] c with (nolock) 
							where  ( (c.[REQ_MST_ID] = t.[REQ_MST_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  )  
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
					[cdc].[dbo_SSP_MST_SHIP_REQ_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[REQ_MST_ID] = mo.[REQ_MST_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_9FA8A37A
	    when 1 then __$operation
	    else
			case __$min_op_9FA8A37A 
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
		case __$count_9FA8A37A
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_9FA8A37A 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [REQ_MST_ID], [DIVISION_ID], [PLAN_START_YYYYMMDD], [PLAN_TYPE], [SEQ], [REQ_START_DATE], [REQ_END_DATE], [REQ_IN_START_DATE], [REQ_IN_END_DATE], [CONFIRM_START_DATE], [CONFIRM_END_DATE], [CUTOFF_DATE], [CUTOFF_FLAG], [CUTOFF_CREATION_DATE], [CONFIRM_FLAG], [CONFIRM_DATE], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_9FA8A37A 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SSP_MST_SHIP_REQ_CT] c with (nolock)
			where  ( (c.[REQ_MST_ID] = t.[REQ_MST_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_9FA8A37A, __$count_9FA8A37A, 
		m.__$update_mask , t.[REQ_MST_ID], t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[REQ_START_DATE], t.[REQ_END_DATE], t.[REQ_IN_START_DATE], t.[REQ_IN_END_DATE], t.[CONFIRM_START_DATE], t.[CONFIRM_END_DATE], t.[CUTOFF_DATE], t.[CUTOFF_FLAG], t.[CUTOFF_CREATION_DATE], t.[CONFIRM_FLAG], t.[CONFIRM_DATE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_SSP_MST_SHIP_REQ_CT] t with (nolock) inner join 
		(	select  r.[REQ_MST_ID], r.[DIVISION_ID],
		    count(*) as __$count_9FA8A37A, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SSP_MST_SHIP_REQ_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[REQ_MST_ID], r.[DIVISION_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SSP_MST_SHIP_REQ_CT] c with (nolock) where  ( (c.[REQ_MST_ID] = t.[REQ_MST_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[REQ_MST_ID] = m.[REQ_MST_ID]) and (t.[DIVISION_ID] = m.[DIVISION_ID])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_MST_SHIP_REQ', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SSP_MST_SHIP_REQ_CT] c with (nolock)
							where  ( (c.[REQ_MST_ID] = t.[REQ_MST_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  )  
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
					[cdc].[dbo_SSP_MST_SHIP_REQ_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[REQ_MST_ID] = mo.[REQ_MST_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  ) 
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
		null as __$update_mask , t.[REQ_MST_ID], t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[REQ_START_DATE], t.[REQ_END_DATE], t.[REQ_IN_START_DATE], t.[REQ_IN_END_DATE], t.[CONFIRM_START_DATE], t.[CONFIRM_END_DATE], t.[CUTOFF_DATE], t.[CUTOFF_FLAG], t.[CUTOFF_CREATION_DATE], t.[CONFIRM_FLAG], t.[CONFIRM_DATE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_SSP_MST_SHIP_REQ_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_MST_SHIP_REQ', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SSP_MST_SHIP_REQ_CT] c with (nolock) where  ( (c.[REQ_MST_ID] = t.[REQ_MST_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SSP_MST_SHIP_REQ_CT] c with (nolock)
							where  ( (c.[REQ_MST_ID] = t.[REQ_MST_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  )  
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
					[cdc].[dbo_SSP_MST_SHIP_REQ_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[REQ_MST_ID] = mo.[REQ_MST_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  ) 
				group by
					mo.__$seqval
			)
	 