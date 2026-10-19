
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCP_MST_DISTRIBUTION_ROUTE]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [ROUTE_ID], NULL as [FROM_COUNTRY], NULL as [FROM_CITY], NULL as [TRANSPORT_MODE], NULL as [PRIORITY], NULL as [DAYS_MON], NULL as [DAYS_TUE], NULL as [DAYS_WED], NULL as [DAYS_THU], NULL as [DAYS_FRI], NULL as [DAYS_SAT], NULL as [DAYS_SUN], NULL as [D_COUNTRY], NULL as [D_PORT_CODE], NULL as [D_PORT_NAME], NULL as [A_COUNTRY], NULL as [A_PORT_CODE], NULL as [A_PORT_NAME], NULL as [SHIPPING_COMPANY], NULL as [TO_COUNTRY], NULL as [TO_CITY], NULL as [SHIP_DOC_PREPARATION_DATE], NULL as [LT_DEPARTURE_INLAND], NULL as [LT_WAIT_SHIPPING], NULL as [LT_VOYAGE], NULL as [LT_LAY_OFF_CLEARANCE], NULL as [LT_ARRIVAL_INLAND], NULL as [VALID_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [LT_TYPE]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_DISTRIBUTION_ROUTE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_5EB07473
	    when 1 then __$operation
	    else
			case __$min_op_5EB07473 
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
		null as __$update_mask , [ROUTE_ID], [FROM_COUNTRY], [FROM_CITY], [TRANSPORT_MODE], [PRIORITY], [DAYS_MON], [DAYS_TUE], [DAYS_WED], [DAYS_THU], [DAYS_FRI], [DAYS_SAT], [DAYS_SUN], [D_COUNTRY], [D_PORT_CODE], [D_PORT_NAME], [A_COUNTRY], [A_PORT_CODE], [A_PORT_NAME], [SHIPPING_COMPANY], [TO_COUNTRY], [TO_CITY], [SHIP_DOC_PREPARATION_DATE], [LT_DEPARTURE_INLAND], [LT_WAIT_SHIPPING], [LT_VOYAGE], [LT_LAY_OFF_CLEARANCE], [LT_ARRIVAL_INLAND], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [LT_TYPE]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_5EB07473 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] c with (nolock)   
			where  ( (c.[ROUTE_ID] = t.[ROUTE_ID]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_5EB07473, __$count_5EB07473, t.[ROUTE_ID], t.[FROM_COUNTRY], t.[FROM_CITY], t.[TRANSPORT_MODE], t.[PRIORITY], t.[DAYS_MON], t.[DAYS_TUE], t.[DAYS_WED], t.[DAYS_THU], t.[DAYS_FRI], t.[DAYS_SAT], t.[DAYS_SUN], t.[D_COUNTRY], t.[D_PORT_CODE], t.[D_PORT_NAME], t.[A_COUNTRY], t.[A_PORT_CODE], t.[A_PORT_NAME], t.[SHIPPING_COMPANY], t.[TO_COUNTRY], t.[TO_CITY], t.[SHIP_DOC_PREPARATION_DATE], t.[LT_DEPARTURE_INLAND], t.[LT_WAIT_SHIPPING], t.[LT_VOYAGE], t.[LT_LAY_OFF_CLEARANCE], t.[LT_ARRIVAL_INLAND], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[LT_TYPE] 
		from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] t with (nolock) inner join 
		(	select  r.[ROUTE_ID],
		    count(*) as __$count_5EB07473 
			from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[ROUTE_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] c with (nolock) where  ( (c.[ROUTE_ID] = t.[ROUTE_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[ROUTE_ID] = m.[ROUTE_ID]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_DISTRIBUTION_ROUTE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] c with (nolock) 
							where  ( (c.[ROUTE_ID] = t.[ROUTE_ID]) )  
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
					[cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[ROUTE_ID] = mo.[ROUTE_ID]) ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_5EB07473
	    when 1 then __$operation
	    else
			case __$min_op_5EB07473 
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
		case __$count_5EB07473
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_5EB07473 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [ROUTE_ID], [FROM_COUNTRY], [FROM_CITY], [TRANSPORT_MODE], [PRIORITY], [DAYS_MON], [DAYS_TUE], [DAYS_WED], [DAYS_THU], [DAYS_FRI], [DAYS_SAT], [DAYS_SUN], [D_COUNTRY], [D_PORT_CODE], [D_PORT_NAME], [A_COUNTRY], [A_PORT_CODE], [A_PORT_NAME], [SHIPPING_COMPANY], [TO_COUNTRY], [TO_CITY], [SHIP_DOC_PREPARATION_DATE], [LT_DEPARTURE_INLAND], [LT_WAIT_SHIPPING], [LT_VOYAGE], [LT_LAY_OFF_CLEARANCE], [LT_ARRIVAL_INLAND], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [LT_TYPE]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_5EB07473 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] c with (nolock)
			where  ( (c.[ROUTE_ID] = t.[ROUTE_ID]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_5EB07473, __$count_5EB07473, 
		m.__$update_mask , t.[ROUTE_ID], t.[FROM_COUNTRY], t.[FROM_CITY], t.[TRANSPORT_MODE], t.[PRIORITY], t.[DAYS_MON], t.[DAYS_TUE], t.[DAYS_WED], t.[DAYS_THU], t.[DAYS_FRI], t.[DAYS_SAT], t.[DAYS_SUN], t.[D_COUNTRY], t.[D_PORT_CODE], t.[D_PORT_NAME], t.[A_COUNTRY], t.[A_PORT_CODE], t.[A_PORT_NAME], t.[SHIPPING_COMPANY], t.[TO_COUNTRY], t.[TO_CITY], t.[SHIP_DOC_PREPARATION_DATE], t.[LT_DEPARTURE_INLAND], t.[LT_WAIT_SHIPPING], t.[LT_VOYAGE], t.[LT_LAY_OFF_CLEARANCE], t.[LT_ARRIVAL_INLAND], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[LT_TYPE]
		from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] t with (nolock) inner join 
		(	select  r.[ROUTE_ID],
		    count(*) as __$count_5EB07473, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[ROUTE_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] c with (nolock) where  ( (c.[ROUTE_ID] = t.[ROUTE_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[ROUTE_ID] = m.[ROUTE_ID]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_DISTRIBUTION_ROUTE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] c with (nolock)
							where  ( (c.[ROUTE_ID] = t.[ROUTE_ID]) )  
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
					[cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[ROUTE_ID] = mo.[ROUTE_ID]) ) 
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
		null as __$update_mask , t.[ROUTE_ID], t.[FROM_COUNTRY], t.[FROM_CITY], t.[TRANSPORT_MODE], t.[PRIORITY], t.[DAYS_MON], t.[DAYS_TUE], t.[DAYS_WED], t.[DAYS_THU], t.[DAYS_FRI], t.[DAYS_SAT], t.[DAYS_SUN], t.[D_COUNTRY], t.[D_PORT_CODE], t.[D_PORT_NAME], t.[A_COUNTRY], t.[A_PORT_CODE], t.[A_PORT_NAME], t.[SHIPPING_COMPANY], t.[TO_COUNTRY], t.[TO_CITY], t.[SHIP_DOC_PREPARATION_DATE], t.[LT_DEPARTURE_INLAND], t.[LT_WAIT_SHIPPING], t.[LT_VOYAGE], t.[LT_LAY_OFF_CLEARANCE], t.[LT_ARRIVAL_INLAND], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[LT_TYPE]
		from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_DISTRIBUTION_ROUTE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] c with (nolock) where  ( (c.[ROUTE_ID] = t.[ROUTE_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] c with (nolock)
							where  ( (c.[ROUTE_ID] = t.[ROUTE_ID]) )  
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
					[cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[ROUTE_ID] = mo.[ROUTE_ID]) ) 
				group by
					mo.__$seqval
			)
	 