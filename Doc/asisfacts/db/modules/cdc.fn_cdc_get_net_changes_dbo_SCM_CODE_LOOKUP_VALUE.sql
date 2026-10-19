
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCM_CODE_LOOKUP_VALUE]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [LOOKUP_TYPE_CODE], NULL as [SEGMENT1], NULL as [SEGMENT2], NULL as [SEGMENT3], NULL as [SEGMENT4], NULL as [SEGMENT5], NULL as [SORT_ORDER], NULL as [ACTIVE_FLAG], NULL as [VALUE_DESCRIPTION], NULL as [CREATE_USER_ID], NULL as [CREATE_DATE], NULL as [MODIFY_USER_ID], NULL as [MODIFY_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [ATTRIBUTE11], NULL as [ATTRIBUTE12], NULL as [ATTRIBUTE13], NULL as [ATTRIBUTE14], NULL as [ATTRIBUTE15], NULL as [PLANT_ID]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_CODE_LOOKUP_VALUE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_90373E92
	    when 1 then __$operation
	    else
			case __$min_op_90373E92 
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
		null as __$update_mask , [LOOKUP_TYPE_CODE], [SEGMENT1], [SEGMENT2], [SEGMENT3], [SEGMENT4], [SEGMENT5], [SORT_ORDER], [ACTIVE_FLAG], [VALUE_DESCRIPTION], [CREATE_USER_ID], [CREATE_DATE], [MODIFY_USER_ID], [MODIFY_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [ATTRIBUTE11], [ATTRIBUTE12], [ATTRIBUTE13], [ATTRIBUTE14], [ATTRIBUTE15], [PLANT_ID]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_90373E92 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] c with (nolock)   
			where  ( (c.[LOOKUP_TYPE_CODE] = t.[LOOKUP_TYPE_CODE]) and (c.[SEGMENT1] = t.[SEGMENT1])  and (c.[SEGMENT2] = t.[SEGMENT2])  and (c.[SEGMENT3] = t.[SEGMENT3])  and (c.[SEGMENT4] = t.[SEGMENT4])  and (c.[SEGMENT5] = t.[SEGMENT5])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_90373E92, __$count_90373E92, t.[LOOKUP_TYPE_CODE], t.[SEGMENT1], t.[SEGMENT2], t.[SEGMENT3], t.[SEGMENT4], t.[SEGMENT5], t.[SORT_ORDER], t.[ACTIVE_FLAG], t.[VALUE_DESCRIPTION], t.[CREATE_USER_ID], t.[CREATE_DATE], t.[MODIFY_USER_ID], t.[MODIFY_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[PLANT_ID] 
		from [cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] t with (nolock) inner join 
		(	select  r.[LOOKUP_TYPE_CODE], r.[SEGMENT1], r.[SEGMENT2], r.[SEGMENT3], r.[SEGMENT4], r.[SEGMENT5],
		    count(*) as __$count_90373E92 
			from [cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[LOOKUP_TYPE_CODE], r.[SEGMENT1], r.[SEGMENT2], r.[SEGMENT3], r.[SEGMENT4], r.[SEGMENT5]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] c with (nolock) where  ( (c.[LOOKUP_TYPE_CODE] = t.[LOOKUP_TYPE_CODE]) and (c.[SEGMENT1] = t.[SEGMENT1])  and (c.[SEGMENT2] = t.[SEGMENT2])  and (c.[SEGMENT3] = t.[SEGMENT3])  and (c.[SEGMENT4] = t.[SEGMENT4])  and (c.[SEGMENT5] = t.[SEGMENT5])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[LOOKUP_TYPE_CODE] = m.[LOOKUP_TYPE_CODE]) and (t.[SEGMENT1] = m.[SEGMENT1])  and (t.[SEGMENT2] = m.[SEGMENT2])  and (t.[SEGMENT3] = m.[SEGMENT3])  and (t.[SEGMENT4] = m.[SEGMENT4])  and (t.[SEGMENT5] = m.[SEGMENT5])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_CODE_LOOKUP_VALUE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] c with (nolock) 
							where  ( (c.[LOOKUP_TYPE_CODE] = t.[LOOKUP_TYPE_CODE]) and (c.[SEGMENT1] = t.[SEGMENT1])  and (c.[SEGMENT2] = t.[SEGMENT2])  and (c.[SEGMENT3] = t.[SEGMENT3])  and (c.[SEGMENT4] = t.[SEGMENT4])  and (c.[SEGMENT5] = t.[SEGMENT5])  )  
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
					[cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[LOOKUP_TYPE_CODE] = mo.[LOOKUP_TYPE_CODE]) and (t.[SEGMENT1] = mo.[SEGMENT1])  and (t.[SEGMENT2] = mo.[SEGMENT2])  and (t.[SEGMENT3] = mo.[SEGMENT3])  and (t.[SEGMENT4] = mo.[SEGMENT4])  and (t.[SEGMENT5] = mo.[SEGMENT5])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_90373E92
	    when 1 then __$operation
	    else
			case __$min_op_90373E92 
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
		case __$count_90373E92
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_90373E92 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [LOOKUP_TYPE_CODE], [SEGMENT1], [SEGMENT2], [SEGMENT3], [SEGMENT4], [SEGMENT5], [SORT_ORDER], [ACTIVE_FLAG], [VALUE_DESCRIPTION], [CREATE_USER_ID], [CREATE_DATE], [MODIFY_USER_ID], [MODIFY_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [ATTRIBUTE11], [ATTRIBUTE12], [ATTRIBUTE13], [ATTRIBUTE14], [ATTRIBUTE15], [PLANT_ID]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_90373E92 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] c with (nolock)
			where  ( (c.[LOOKUP_TYPE_CODE] = t.[LOOKUP_TYPE_CODE]) and (c.[SEGMENT1] = t.[SEGMENT1])  and (c.[SEGMENT2] = t.[SEGMENT2])  and (c.[SEGMENT3] = t.[SEGMENT3])  and (c.[SEGMENT4] = t.[SEGMENT4])  and (c.[SEGMENT5] = t.[SEGMENT5])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_90373E92, __$count_90373E92, 
		m.__$update_mask , t.[LOOKUP_TYPE_CODE], t.[SEGMENT1], t.[SEGMENT2], t.[SEGMENT3], t.[SEGMENT4], t.[SEGMENT5], t.[SORT_ORDER], t.[ACTIVE_FLAG], t.[VALUE_DESCRIPTION], t.[CREATE_USER_ID], t.[CREATE_DATE], t.[MODIFY_USER_ID], t.[MODIFY_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[PLANT_ID]
		from [cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] t with (nolock) inner join 
		(	select  r.[LOOKUP_TYPE_CODE], r.[SEGMENT1], r.[SEGMENT2], r.[SEGMENT3], r.[SEGMENT4], r.[SEGMENT5],
		    count(*) as __$count_90373E92, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[LOOKUP_TYPE_CODE], r.[SEGMENT1], r.[SEGMENT2], r.[SEGMENT3], r.[SEGMENT4], r.[SEGMENT5]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] c with (nolock) where  ( (c.[LOOKUP_TYPE_CODE] = t.[LOOKUP_TYPE_CODE]) and (c.[SEGMENT1] = t.[SEGMENT1])  and (c.[SEGMENT2] = t.[SEGMENT2])  and (c.[SEGMENT3] = t.[SEGMENT3])  and (c.[SEGMENT4] = t.[SEGMENT4])  and (c.[SEGMENT5] = t.[SEGMENT5])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[LOOKUP_TYPE_CODE] = m.[LOOKUP_TYPE_CODE]) and (t.[SEGMENT1] = m.[SEGMENT1])  and (t.[SEGMENT2] = m.[SEGMENT2])  and (t.[SEGMENT3] = m.[SEGMENT3])  and (t.[SEGMENT4] = m.[SEGMENT4])  and (t.[SEGMENT5] = m.[SEGMENT5])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_CODE_LOOKUP_VALUE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] c with (nolock)
							where  ( (c.[LOOKUP_TYPE_CODE] = t.[LOOKUP_TYPE_CODE]) and (c.[SEGMENT1] = t.[SEGMENT1])  and (c.[SEGMENT2] = t.[SEGMENT2])  and (c.[SEGMENT3] = t.[SEGMENT3])  and (c.[SEGMENT4] = t.[SEGMENT4])  and (c.[SEGMENT5] = t.[SEGMENT5])  )  
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
					[cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[LOOKUP_TYPE_CODE] = mo.[LOOKUP_TYPE_CODE]) and (t.[SEGMENT1] = mo.[SEGMENT1])  and (t.[SEGMENT2] = mo.[SEGMENT2])  and (t.[SEGMENT3] = mo.[SEGMENT3])  and (t.[SEGMENT4] = mo.[SEGMENT4])  and (t.[SEGMENT5] = mo.[SEGMENT5])  ) 
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
		null as __$update_mask , t.[LOOKUP_TYPE_CODE], t.[SEGMENT1], t.[SEGMENT2], t.[SEGMENT3], t.[SEGMENT4], t.[SEGMENT5], t.[SORT_ORDER], t.[ACTIVE_FLAG], t.[VALUE_DESCRIPTION], t.[CREATE_USER_ID], t.[CREATE_DATE], t.[MODIFY_USER_ID], t.[MODIFY_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[PLANT_ID]
		from [cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_CODE_LOOKUP_VALUE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] c with (nolock) where  ( (c.[LOOKUP_TYPE_CODE] = t.[LOOKUP_TYPE_CODE]) and (c.[SEGMENT1] = t.[SEGMENT1])  and (c.[SEGMENT2] = t.[SEGMENT2])  and (c.[SEGMENT3] = t.[SEGMENT3])  and (c.[SEGMENT4] = t.[SEGMENT4])  and (c.[SEGMENT5] = t.[SEGMENT5])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] c with (nolock)
							where  ( (c.[LOOKUP_TYPE_CODE] = t.[LOOKUP_TYPE_CODE]) and (c.[SEGMENT1] = t.[SEGMENT1])  and (c.[SEGMENT2] = t.[SEGMENT2])  and (c.[SEGMENT3] = t.[SEGMENT3])  and (c.[SEGMENT4] = t.[SEGMENT4])  and (c.[SEGMENT5] = t.[SEGMENT5])  )  
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
					[cdc].[dbo_SCM_CODE_LOOKUP_VALUE_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[LOOKUP_TYPE_CODE] = mo.[LOOKUP_TYPE_CODE]) and (t.[SEGMENT1] = mo.[SEGMENT1])  and (t.[SEGMENT2] = mo.[SEGMENT2])  and (t.[SEGMENT3] = mo.[SEGMENT3])  and (t.[SEGMENT4] = mo.[SEGMENT4])  and (t.[SEGMENT5] = mo.[SEGMENT5])  ) 
				group by
					mo.__$seqval
			)
	 