
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCM_MST_BOD]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [BOD_ID], NULL as [BOD_TYPE], NULL as [FROM_SITE], NULL as [POL], NULL as [POD], NULL as [HUB_SLOC], NULL as [TO_SITE], NULL as [INCOTERMS], NULL as [TRANSPORT_MODE], NULL as [PRIORITY], NULL as [PERIOD_SHIPSCH_MON], NULL as [PERIOD_SHIPSCH_TUE], NULL as [PERIOD_SHIPSCH_WED], NULL as [PERIOD_SHIPSCH_THU], NULL as [PERIOD_SHIPSCH_FRI], NULL as [PERIOD_SHIPSCH_SAT], NULL as [PERIOD_SHIPSCH_SUN], NULL as [FREIGHT_FORWARDER], NULL as [SAFETY_STOCK], NULL as [PERIOD1_LT], NULL as [POL_CLEARANCE_LT], NULL as [PERIOD2_LT], NULL as [POD_CLEARANCE_LT], NULL as [PERIOD3_LT], NULL as [CUSTOMER_LT], NULL as [VALID_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_BOD', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_FA289602
	    when 1 then __$operation
	    else
			case __$min_op_FA289602 
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
		null as __$update_mask , [DIVISION_ID], [BOD_ID], [BOD_TYPE], [FROM_SITE], [POL], [POD], [HUB_SLOC], [TO_SITE], [INCOTERMS], [TRANSPORT_MODE], [PRIORITY], [PERIOD_SHIPSCH_MON], [PERIOD_SHIPSCH_TUE], [PERIOD_SHIPSCH_WED], [PERIOD_SHIPSCH_THU], [PERIOD_SHIPSCH_FRI], [PERIOD_SHIPSCH_SAT], [PERIOD_SHIPSCH_SUN], [FREIGHT_FORWARDER], [SAFETY_STOCK], [PERIOD1_LT], [POL_CLEARANCE_LT], [PERIOD2_LT], [POD_CLEARANCE_LT], [PERIOD3_LT], [CUSTOMER_LT], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_FA289602 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_BOD_CT] c with (nolock)   
			where  ( (c.[BOD_ID] = t.[BOD_ID]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_FA289602, __$count_FA289602, t.[DIVISION_ID], t.[BOD_ID], t.[BOD_TYPE], t.[FROM_SITE], t.[POL], t.[POD], t.[HUB_SLOC], t.[TO_SITE], t.[INCOTERMS], t.[TRANSPORT_MODE], t.[PRIORITY], t.[PERIOD_SHIPSCH_MON], t.[PERIOD_SHIPSCH_TUE], t.[PERIOD_SHIPSCH_WED], t.[PERIOD_SHIPSCH_THU], t.[PERIOD_SHIPSCH_FRI], t.[PERIOD_SHIPSCH_SAT], t.[PERIOD_SHIPSCH_SUN], t.[FREIGHT_FORWARDER], t.[SAFETY_STOCK], t.[PERIOD1_LT], t.[POL_CLEARANCE_LT], t.[PERIOD2_LT], t.[POD_CLEARANCE_LT], t.[PERIOD3_LT], t.[CUSTOMER_LT], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10] 
		from [cdc].[dbo_SCM_MST_BOD_CT] t with (nolock) inner join 
		(	select  r.[BOD_ID],
		    count(*) as __$count_FA289602 
			from [cdc].[dbo_SCM_MST_BOD_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[BOD_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_BOD_CT] c with (nolock) where  ( (c.[BOD_ID] = t.[BOD_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[BOD_ID] = m.[BOD_ID]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_BOD', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_BOD_CT] c with (nolock) 
							where  ( (c.[BOD_ID] = t.[BOD_ID]) )  
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
					[cdc].[dbo_SCM_MST_BOD_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[BOD_ID] = mo.[BOD_ID]) ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_FA289602
	    when 1 then __$operation
	    else
			case __$min_op_FA289602 
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
		case __$count_FA289602
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_FA289602 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [DIVISION_ID], [BOD_ID], [BOD_TYPE], [FROM_SITE], [POL], [POD], [HUB_SLOC], [TO_SITE], [INCOTERMS], [TRANSPORT_MODE], [PRIORITY], [PERIOD_SHIPSCH_MON], [PERIOD_SHIPSCH_TUE], [PERIOD_SHIPSCH_WED], [PERIOD_SHIPSCH_THU], [PERIOD_SHIPSCH_FRI], [PERIOD_SHIPSCH_SAT], [PERIOD_SHIPSCH_SUN], [FREIGHT_FORWARDER], [SAFETY_STOCK], [PERIOD1_LT], [POL_CLEARANCE_LT], [PERIOD2_LT], [POD_CLEARANCE_LT], [PERIOD3_LT], [CUSTOMER_LT], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_FA289602 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_BOD_CT] c with (nolock)
			where  ( (c.[BOD_ID] = t.[BOD_ID]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_FA289602, __$count_FA289602, 
		m.__$update_mask , t.[DIVISION_ID], t.[BOD_ID], t.[BOD_TYPE], t.[FROM_SITE], t.[POL], t.[POD], t.[HUB_SLOC], t.[TO_SITE], t.[INCOTERMS], t.[TRANSPORT_MODE], t.[PRIORITY], t.[PERIOD_SHIPSCH_MON], t.[PERIOD_SHIPSCH_TUE], t.[PERIOD_SHIPSCH_WED], t.[PERIOD_SHIPSCH_THU], t.[PERIOD_SHIPSCH_FRI], t.[PERIOD_SHIPSCH_SAT], t.[PERIOD_SHIPSCH_SUN], t.[FREIGHT_FORWARDER], t.[SAFETY_STOCK], t.[PERIOD1_LT], t.[POL_CLEARANCE_LT], t.[PERIOD2_LT], t.[POD_CLEARANCE_LT], t.[PERIOD3_LT], t.[CUSTOMER_LT], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_SCM_MST_BOD_CT] t with (nolock) inner join 
		(	select  r.[BOD_ID],
		    count(*) as __$count_FA289602, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCM_MST_BOD_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[BOD_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_BOD_CT] c with (nolock) where  ( (c.[BOD_ID] = t.[BOD_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[BOD_ID] = m.[BOD_ID]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_BOD', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_BOD_CT] c with (nolock)
							where  ( (c.[BOD_ID] = t.[BOD_ID]) )  
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
					[cdc].[dbo_SCM_MST_BOD_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[BOD_ID] = mo.[BOD_ID]) ) 
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
		null as __$update_mask , t.[DIVISION_ID], t.[BOD_ID], t.[BOD_TYPE], t.[FROM_SITE], t.[POL], t.[POD], t.[HUB_SLOC], t.[TO_SITE], t.[INCOTERMS], t.[TRANSPORT_MODE], t.[PRIORITY], t.[PERIOD_SHIPSCH_MON], t.[PERIOD_SHIPSCH_TUE], t.[PERIOD_SHIPSCH_WED], t.[PERIOD_SHIPSCH_THU], t.[PERIOD_SHIPSCH_FRI], t.[PERIOD_SHIPSCH_SAT], t.[PERIOD_SHIPSCH_SUN], t.[FREIGHT_FORWARDER], t.[SAFETY_STOCK], t.[PERIOD1_LT], t.[POL_CLEARANCE_LT], t.[PERIOD2_LT], t.[POD_CLEARANCE_LT], t.[PERIOD3_LT], t.[CUSTOMER_LT], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_SCM_MST_BOD_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_BOD', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_BOD_CT] c with (nolock) where  ( (c.[BOD_ID] = t.[BOD_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_BOD_CT] c with (nolock)
							where  ( (c.[BOD_ID] = t.[BOD_ID]) )  
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
					[cdc].[dbo_SCM_MST_BOD_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[BOD_ID] = mo.[BOD_ID]) ) 
				group by
					mo.__$seqval
			)
	 