
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCM_MST_PROJECT_SCHEDULE]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [PROJECT_CODE], NULL as [PROJECT_VER_SEQ], NULL as [CV_APP_PLAN_START_DATE], NULL as [CV_APP_PLAN_END_DATE], NULL as [CV_PLAN_START_DATE], NULL as [CV_PLAN_END_DATE], NULL as [CV_ACTUAL_START_DATE], NULL as [CV_ACTUAL_END_DATE], NULL as [DV_APP_PLAN_START_DATE], NULL as [DV_APP_PLAN_END_DATE], NULL as [DV_PLAN_START_DATE], NULL as [DV_PLAN_END_DATE], NULL as [DV_ACTUAL_START_DATE], NULL as [DV_ACTUAL_END_DATE], NULL as [PD_APP_PLAN_START_DATE], NULL as [PD_APP_PLAN_END_DATE], NULL as [PD_PLAN_START_DATE], NULL as [PD_PLAN_END_DATE], NULL as [PD_ACTUAL_START_DATE], NULL as [PD_ACTUAL_END_DATE], NULL as [PV_APP_PLAN_START_DATE], NULL as [PV_APP_PLAN_END_DATE], NULL as [PV_PLAN_START_DATE], NULL as [PV_PLAN_END_DATE], NULL as [PV_ACTUAL_START_DATE], NULL as [PV_ACTUAL_END_DATE], NULL as [VALID_YN], NULL as [CREATION_DATE], NULL as [CREATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [LAST_UPDATED_BY], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_PROJECT_SCHEDULE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_2AFF4816
	    when 1 then __$operation
	    else
			case __$min_op_2AFF4816 
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
		null as __$update_mask , [DIVISION_ID], [PROJECT_CODE], [PROJECT_VER_SEQ], [CV_APP_PLAN_START_DATE], [CV_APP_PLAN_END_DATE], [CV_PLAN_START_DATE], [CV_PLAN_END_DATE], [CV_ACTUAL_START_DATE], [CV_ACTUAL_END_DATE], [DV_APP_PLAN_START_DATE], [DV_APP_PLAN_END_DATE], [DV_PLAN_START_DATE], [DV_PLAN_END_DATE], [DV_ACTUAL_START_DATE], [DV_ACTUAL_END_DATE], [PD_APP_PLAN_START_DATE], [PD_APP_PLAN_END_DATE], [PD_PLAN_START_DATE], [PD_PLAN_END_DATE], [PD_ACTUAL_START_DATE], [PD_ACTUAL_END_DATE], [PV_APP_PLAN_START_DATE], [PV_APP_PLAN_END_DATE], [PV_PLAN_START_DATE], [PV_PLAN_END_DATE], [PV_ACTUAL_START_DATE], [PV_ACTUAL_END_DATE], [VALID_YN], [CREATION_DATE], [CREATED_BY], [LAST_UPDATE_DATE], [LAST_UPDATED_BY], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_2AFF4816 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] c with (nolock)   
			where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[PROJECT_VER_SEQ] = t.[PROJECT_VER_SEQ])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_2AFF4816, __$count_2AFF4816, t.[DIVISION_ID], t.[PROJECT_CODE], t.[PROJECT_VER_SEQ], t.[CV_APP_PLAN_START_DATE], t.[CV_APP_PLAN_END_DATE], t.[CV_PLAN_START_DATE], t.[CV_PLAN_END_DATE], t.[CV_ACTUAL_START_DATE], t.[CV_ACTUAL_END_DATE], t.[DV_APP_PLAN_START_DATE], t.[DV_APP_PLAN_END_DATE], t.[DV_PLAN_START_DATE], t.[DV_PLAN_END_DATE], t.[DV_ACTUAL_START_DATE], t.[DV_ACTUAL_END_DATE], t.[PD_APP_PLAN_START_DATE], t.[PD_APP_PLAN_END_DATE], t.[PD_PLAN_START_DATE], t.[PD_PLAN_END_DATE], t.[PD_ACTUAL_START_DATE], t.[PD_ACTUAL_END_DATE], t.[PV_APP_PLAN_START_DATE], t.[PV_APP_PLAN_END_DATE], t.[PV_PLAN_START_DATE], t.[PV_PLAN_END_DATE], t.[PV_ACTUAL_START_DATE], t.[PV_ACTUAL_END_DATE], t.[VALID_YN], t.[CREATION_DATE], t.[CREATED_BY], t.[LAST_UPDATE_DATE], t.[LAST_UPDATED_BY], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10] 
		from [cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] t with (nolock) inner join 
		(	select  r.[DIVISION_ID], r.[PROJECT_CODE], r.[PROJECT_VER_SEQ],
		    count(*) as __$count_2AFF4816 
			from [cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[DIVISION_ID], r.[PROJECT_CODE], r.[PROJECT_VER_SEQ]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[PROJECT_VER_SEQ] = t.[PROJECT_VER_SEQ])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[DIVISION_ID] = m.[DIVISION_ID]) and (t.[PROJECT_CODE] = m.[PROJECT_CODE])  and (t.[PROJECT_VER_SEQ] = m.[PROJECT_VER_SEQ])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_PROJECT_SCHEDULE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] c with (nolock) 
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[PROJECT_VER_SEQ] = t.[PROJECT_VER_SEQ])  )  
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
					[cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[PROJECT_CODE] = mo.[PROJECT_CODE])  and (t.[PROJECT_VER_SEQ] = mo.[PROJECT_VER_SEQ])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_2AFF4816
	    when 1 then __$operation
	    else
			case __$min_op_2AFF4816 
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
		case __$count_2AFF4816
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_2AFF4816 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [DIVISION_ID], [PROJECT_CODE], [PROJECT_VER_SEQ], [CV_APP_PLAN_START_DATE], [CV_APP_PLAN_END_DATE], [CV_PLAN_START_DATE], [CV_PLAN_END_DATE], [CV_ACTUAL_START_DATE], [CV_ACTUAL_END_DATE], [DV_APP_PLAN_START_DATE], [DV_APP_PLAN_END_DATE], [DV_PLAN_START_DATE], [DV_PLAN_END_DATE], [DV_ACTUAL_START_DATE], [DV_ACTUAL_END_DATE], [PD_APP_PLAN_START_DATE], [PD_APP_PLAN_END_DATE], [PD_PLAN_START_DATE], [PD_PLAN_END_DATE], [PD_ACTUAL_START_DATE], [PD_ACTUAL_END_DATE], [PV_APP_PLAN_START_DATE], [PV_APP_PLAN_END_DATE], [PV_PLAN_START_DATE], [PV_PLAN_END_DATE], [PV_ACTUAL_START_DATE], [PV_ACTUAL_END_DATE], [VALID_YN], [CREATION_DATE], [CREATED_BY], [LAST_UPDATE_DATE], [LAST_UPDATED_BY], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_2AFF4816 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] c with (nolock)
			where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[PROJECT_VER_SEQ] = t.[PROJECT_VER_SEQ])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_2AFF4816, __$count_2AFF4816, 
		m.__$update_mask , t.[DIVISION_ID], t.[PROJECT_CODE], t.[PROJECT_VER_SEQ], t.[CV_APP_PLAN_START_DATE], t.[CV_APP_PLAN_END_DATE], t.[CV_PLAN_START_DATE], t.[CV_PLAN_END_DATE], t.[CV_ACTUAL_START_DATE], t.[CV_ACTUAL_END_DATE], t.[DV_APP_PLAN_START_DATE], t.[DV_APP_PLAN_END_DATE], t.[DV_PLAN_START_DATE], t.[DV_PLAN_END_DATE], t.[DV_ACTUAL_START_DATE], t.[DV_ACTUAL_END_DATE], t.[PD_APP_PLAN_START_DATE], t.[PD_APP_PLAN_END_DATE], t.[PD_PLAN_START_DATE], t.[PD_PLAN_END_DATE], t.[PD_ACTUAL_START_DATE], t.[PD_ACTUAL_END_DATE], t.[PV_APP_PLAN_START_DATE], t.[PV_APP_PLAN_END_DATE], t.[PV_PLAN_START_DATE], t.[PV_PLAN_END_DATE], t.[PV_ACTUAL_START_DATE], t.[PV_ACTUAL_END_DATE], t.[VALID_YN], t.[CREATION_DATE], t.[CREATED_BY], t.[LAST_UPDATE_DATE], t.[LAST_UPDATED_BY], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] t with (nolock) inner join 
		(	select  r.[DIVISION_ID], r.[PROJECT_CODE], r.[PROJECT_VER_SEQ],
		    count(*) as __$count_2AFF4816, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[DIVISION_ID], r.[PROJECT_CODE], r.[PROJECT_VER_SEQ]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[PROJECT_VER_SEQ] = t.[PROJECT_VER_SEQ])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[DIVISION_ID] = m.[DIVISION_ID]) and (t.[PROJECT_CODE] = m.[PROJECT_CODE])  and (t.[PROJECT_VER_SEQ] = m.[PROJECT_VER_SEQ])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_PROJECT_SCHEDULE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] c with (nolock)
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[PROJECT_VER_SEQ] = t.[PROJECT_VER_SEQ])  )  
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
					[cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[PROJECT_CODE] = mo.[PROJECT_CODE])  and (t.[PROJECT_VER_SEQ] = mo.[PROJECT_VER_SEQ])  ) 
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
		null as __$update_mask , t.[DIVISION_ID], t.[PROJECT_CODE], t.[PROJECT_VER_SEQ], t.[CV_APP_PLAN_START_DATE], t.[CV_APP_PLAN_END_DATE], t.[CV_PLAN_START_DATE], t.[CV_PLAN_END_DATE], t.[CV_ACTUAL_START_DATE], t.[CV_ACTUAL_END_DATE], t.[DV_APP_PLAN_START_DATE], t.[DV_APP_PLAN_END_DATE], t.[DV_PLAN_START_DATE], t.[DV_PLAN_END_DATE], t.[DV_ACTUAL_START_DATE], t.[DV_ACTUAL_END_DATE], t.[PD_APP_PLAN_START_DATE], t.[PD_APP_PLAN_END_DATE], t.[PD_PLAN_START_DATE], t.[PD_PLAN_END_DATE], t.[PD_ACTUAL_START_DATE], t.[PD_ACTUAL_END_DATE], t.[PV_APP_PLAN_START_DATE], t.[PV_APP_PLAN_END_DATE], t.[PV_PLAN_START_DATE], t.[PV_PLAN_END_DATE], t.[PV_ACTUAL_START_DATE], t.[PV_ACTUAL_END_DATE], t.[VALID_YN], t.[CREATION_DATE], t.[CREATED_BY], t.[LAST_UPDATE_DATE], t.[LAST_UPDATED_BY], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_PROJECT_SCHEDULE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[PROJECT_VER_SEQ] = t.[PROJECT_VER_SEQ])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] c with (nolock)
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[PROJECT_VER_SEQ] = t.[PROJECT_VER_SEQ])  )  
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
					[cdc].[dbo_SCM_MST_PROJECT_SCHEDULE_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[PROJECT_CODE] = mo.[PROJECT_CODE])  and (t.[PROJECT_VER_SEQ] = mo.[PROJECT_VER_SEQ])  ) 
				group by
					mo.__$seqval
			)
	 