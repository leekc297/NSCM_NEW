
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCM_MST_LOCATION_H]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [HISTORY_SEQ], NULL as [LOCATION_SEQ], NULL as [DIVISION_ID], NULL as [LOCATION_CODE], NULL as [LOCATION_DESCRIPTION], NULL as [SCM_SITE_ID], NULL as [PLANT_ID], NULL as [FACTORY_ID], NULL as [OPERATION_ID], NULL as [STORAGE_ID], NULL as [ELECTRODE_TYPE], NULL as [VALID_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [HISTORY_CREATION_DATE]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_LOCATION_H', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_D771ACE5
	    when 1 then __$operation
	    else
			case __$min_op_D771ACE5 
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
		null as __$update_mask , [HISTORY_SEQ], [LOCATION_SEQ], [DIVISION_ID], [LOCATION_CODE], [LOCATION_DESCRIPTION], [SCM_SITE_ID], [PLANT_ID], [FACTORY_ID], [OPERATION_ID], [STORAGE_ID], [ELECTRODE_TYPE], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [HISTORY_CREATION_DATE]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_D771ACE5 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_LOCATION_H_CT] c with (nolock)   
			where  ( (c.[HISTORY_SEQ] = t.[HISTORY_SEQ]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_D771ACE5, __$count_D771ACE5, t.[HISTORY_SEQ], t.[LOCATION_SEQ], t.[DIVISION_ID], t.[LOCATION_CODE], t.[LOCATION_DESCRIPTION], t.[SCM_SITE_ID], t.[PLANT_ID], t.[FACTORY_ID], t.[OPERATION_ID], t.[STORAGE_ID], t.[ELECTRODE_TYPE], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[HISTORY_CREATION_DATE] 
		from [cdc].[dbo_SCM_MST_LOCATION_H_CT] t with (nolock) inner join 
		(	select  r.[HISTORY_SEQ],
		    count(*) as __$count_D771ACE5 
			from [cdc].[dbo_SCM_MST_LOCATION_H_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[HISTORY_SEQ]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_LOCATION_H_CT] c with (nolock) where  ( (c.[HISTORY_SEQ] = t.[HISTORY_SEQ]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[HISTORY_SEQ] = m.[HISTORY_SEQ]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_LOCATION_H', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_LOCATION_H_CT] c with (nolock) 
							where  ( (c.[HISTORY_SEQ] = t.[HISTORY_SEQ]) )  
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
					[cdc].[dbo_SCM_MST_LOCATION_H_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[HISTORY_SEQ] = mo.[HISTORY_SEQ]) ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_D771ACE5
	    when 1 then __$operation
	    else
			case __$min_op_D771ACE5 
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
		case __$count_D771ACE5
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_D771ACE5 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [HISTORY_SEQ], [LOCATION_SEQ], [DIVISION_ID], [LOCATION_CODE], [LOCATION_DESCRIPTION], [SCM_SITE_ID], [PLANT_ID], [FACTORY_ID], [OPERATION_ID], [STORAGE_ID], [ELECTRODE_TYPE], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [HISTORY_CREATION_DATE]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_D771ACE5 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_LOCATION_H_CT] c with (nolock)
			where  ( (c.[HISTORY_SEQ] = t.[HISTORY_SEQ]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_D771ACE5, __$count_D771ACE5, 
		m.__$update_mask , t.[HISTORY_SEQ], t.[LOCATION_SEQ], t.[DIVISION_ID], t.[LOCATION_CODE], t.[LOCATION_DESCRIPTION], t.[SCM_SITE_ID], t.[PLANT_ID], t.[FACTORY_ID], t.[OPERATION_ID], t.[STORAGE_ID], t.[ELECTRODE_TYPE], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[HISTORY_CREATION_DATE]
		from [cdc].[dbo_SCM_MST_LOCATION_H_CT] t with (nolock) inner join 
		(	select  r.[HISTORY_SEQ],
		    count(*) as __$count_D771ACE5, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCM_MST_LOCATION_H_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[HISTORY_SEQ]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_LOCATION_H_CT] c with (nolock) where  ( (c.[HISTORY_SEQ] = t.[HISTORY_SEQ]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[HISTORY_SEQ] = m.[HISTORY_SEQ]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_LOCATION_H', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_LOCATION_H_CT] c with (nolock)
							where  ( (c.[HISTORY_SEQ] = t.[HISTORY_SEQ]) )  
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
					[cdc].[dbo_SCM_MST_LOCATION_H_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[HISTORY_SEQ] = mo.[HISTORY_SEQ]) ) 
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
		null as __$update_mask , t.[HISTORY_SEQ], t.[LOCATION_SEQ], t.[DIVISION_ID], t.[LOCATION_CODE], t.[LOCATION_DESCRIPTION], t.[SCM_SITE_ID], t.[PLANT_ID], t.[FACTORY_ID], t.[OPERATION_ID], t.[STORAGE_ID], t.[ELECTRODE_TYPE], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[HISTORY_CREATION_DATE]
		from [cdc].[dbo_SCM_MST_LOCATION_H_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_LOCATION_H', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_LOCATION_H_CT] c with (nolock) where  ( (c.[HISTORY_SEQ] = t.[HISTORY_SEQ]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_LOCATION_H_CT] c with (nolock)
							where  ( (c.[HISTORY_SEQ] = t.[HISTORY_SEQ]) )  
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
					[cdc].[dbo_SCM_MST_LOCATION_H_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[HISTORY_SEQ] = mo.[HISTORY_SEQ]) ) 
				group by
					mo.__$seqval
			)
	 