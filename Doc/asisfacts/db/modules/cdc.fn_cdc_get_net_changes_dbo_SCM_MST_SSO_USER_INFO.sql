
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCM_MST_SSO_USER_INFO]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [USER_ID], NULL as [USER_NAME], NULL as [USER_NAME_EN], NULL as [DEPT_ID], NULL as [JOB_CODE], NULL as [JOB_NAME], NULL as [COMPANY_ID], NULL as [WORKING_CODE], NULL as [WORKING_NAME], NULL as [SSO_LOCATE], NULL as [ACTIVE_FLAG], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [Attribute1], NULL as [Attribute2], NULL as [Attribute3], NULL as [Attribute4], NULL as [Attribute5], NULL as [Attribute6], NULL as [Attribute7], NULL as [Attribute8], NULL as [Attribute9], NULL as [Attribute10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SSO_USER_INFO', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_8F1E9A4D
	    when 1 then __$operation
	    else
			case __$min_op_8F1E9A4D 
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
		null as __$update_mask , [USER_ID], [USER_NAME], [USER_NAME_EN], [DEPT_ID], [JOB_CODE], [JOB_NAME], [COMPANY_ID], [WORKING_CODE], [WORKING_NAME], [SSO_LOCATE], [ACTIVE_FLAG], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [Attribute1], [Attribute2], [Attribute3], [Attribute4], [Attribute5], [Attribute6], [Attribute7], [Attribute8], [Attribute9], [Attribute10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_8F1E9A4D 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] c with (nolock)   
			where  ( (c.[USER_ID] = t.[USER_ID]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_8F1E9A4D, __$count_8F1E9A4D, t.[USER_ID], t.[USER_NAME], t.[USER_NAME_EN], t.[DEPT_ID], t.[JOB_CODE], t.[JOB_NAME], t.[COMPANY_ID], t.[WORKING_CODE], t.[WORKING_NAME], t.[SSO_LOCATE], t.[ACTIVE_FLAG], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[Attribute1], t.[Attribute2], t.[Attribute3], t.[Attribute4], t.[Attribute5], t.[Attribute6], t.[Attribute7], t.[Attribute8], t.[Attribute9], t.[Attribute10] 
		from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] t with (nolock) inner join 
		(	select  r.[USER_ID],
		    count(*) as __$count_8F1E9A4D 
			from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[USER_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] c with (nolock) where  ( (c.[USER_ID] = t.[USER_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[USER_ID] = m.[USER_ID]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SSO_USER_INFO', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] c with (nolock) 
							where  ( (c.[USER_ID] = t.[USER_ID]) )  
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
					[cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[USER_ID] = mo.[USER_ID]) ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_8F1E9A4D
	    when 1 then __$operation
	    else
			case __$min_op_8F1E9A4D 
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
		case __$count_8F1E9A4D
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_8F1E9A4D 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [USER_ID], [USER_NAME], [USER_NAME_EN], [DEPT_ID], [JOB_CODE], [JOB_NAME], [COMPANY_ID], [WORKING_CODE], [WORKING_NAME], [SSO_LOCATE], [ACTIVE_FLAG], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [Attribute1], [Attribute2], [Attribute3], [Attribute4], [Attribute5], [Attribute6], [Attribute7], [Attribute8], [Attribute9], [Attribute10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_8F1E9A4D 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] c with (nolock)
			where  ( (c.[USER_ID] = t.[USER_ID]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_8F1E9A4D, __$count_8F1E9A4D, 
		m.__$update_mask , t.[USER_ID], t.[USER_NAME], t.[USER_NAME_EN], t.[DEPT_ID], t.[JOB_CODE], t.[JOB_NAME], t.[COMPANY_ID], t.[WORKING_CODE], t.[WORKING_NAME], t.[SSO_LOCATE], t.[ACTIVE_FLAG], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[Attribute1], t.[Attribute2], t.[Attribute3], t.[Attribute4], t.[Attribute5], t.[Attribute6], t.[Attribute7], t.[Attribute8], t.[Attribute9], t.[Attribute10]
		from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] t with (nolock) inner join 
		(	select  r.[USER_ID],
		    count(*) as __$count_8F1E9A4D, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[USER_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] c with (nolock) where  ( (c.[USER_ID] = t.[USER_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[USER_ID] = m.[USER_ID]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SSO_USER_INFO', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] c with (nolock)
							where  ( (c.[USER_ID] = t.[USER_ID]) )  
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
					[cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[USER_ID] = mo.[USER_ID]) ) 
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
		null as __$update_mask , t.[USER_ID], t.[USER_NAME], t.[USER_NAME_EN], t.[DEPT_ID], t.[JOB_CODE], t.[JOB_NAME], t.[COMPANY_ID], t.[WORKING_CODE], t.[WORKING_NAME], t.[SSO_LOCATE], t.[ACTIVE_FLAG], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[Attribute1], t.[Attribute2], t.[Attribute3], t.[Attribute4], t.[Attribute5], t.[Attribute6], t.[Attribute7], t.[Attribute8], t.[Attribute9], t.[Attribute10]
		from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SSO_USER_INFO', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] c with (nolock) where  ( (c.[USER_ID] = t.[USER_ID]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] c with (nolock)
							where  ( (c.[USER_ID] = t.[USER_ID]) )  
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
					[cdc].[dbo_SCM_MST_SSO_USER_INFO_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[USER_ID] = mo.[USER_ID]) ) 
				group by
					mo.__$seqval
			)
	 