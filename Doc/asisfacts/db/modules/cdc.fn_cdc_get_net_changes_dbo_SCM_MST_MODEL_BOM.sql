
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCM_MST_MODEL_BOM]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [COMPANY_ID], NULL as [DIVISION_ID], NULL as [SITE_ID], NULL as [PLANT_ID], NULL as [MODEL_ID], NULL as [PARENT_ITEM_ID], NULL as [CHILD_ITEM_ID], NULL as [CHILD_QTY], NULL as [CHILD_UOM], NULL as [ACCUMULATED_CHILD_QTY], NULL as [CONCATENATE_ITEM], NULL as [SORT_ORDER], NULL as [LEAF_LEVEL], NULL as [NLEVEL], NULL as [CHILD_COMPANY_ID], NULL as [CHILD_DIVISION_ID], NULL as [CHILD_SITE_ID], NULL as [CHILD_PLANT_ID], NULL as [ALT_ID], NULL as [ALT_PRIORITY], NULL as [ALT_RATE], NULL as [INSERT_ID], NULL as [INSERT_TIME], NULL as [UPDATE_ID], NULL as [UPDATE_TIME], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [ATTRIBUTE11], NULL as [ATTRIBUTE12], NULL as [ATTRIBUTE13], NULL as [ATTRIBUTE14], NULL as [ATTRIBUTE15], NULL as [CONCAT_ALT_PRIORITY], NULL as [COPY_ALT_PRIORITY], NULL as [SCP_PLAN_YN], NULL as [ENG_ALT_ID], NULL as [ENG_ALT_PRIORITY], NULL as [ORG_ALT_ID], NULL as [ORG_ALT_PRIORITY], NULL as [CHILD_SEQ]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_MODEL_BOM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_B76F395C
	    when 1 then __$operation
	    else
			case __$min_op_B76F395C 
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
		null as __$update_mask , [COMPANY_ID], [DIVISION_ID], [SITE_ID], [PLANT_ID], [MODEL_ID], [PARENT_ITEM_ID], [CHILD_ITEM_ID], [CHILD_QTY], [CHILD_UOM], [ACCUMULATED_CHILD_QTY], [CONCATENATE_ITEM], [SORT_ORDER], [LEAF_LEVEL], [NLEVEL], [CHILD_COMPANY_ID], [CHILD_DIVISION_ID], [CHILD_SITE_ID], [CHILD_PLANT_ID], [ALT_ID], [ALT_PRIORITY], [ALT_RATE], [INSERT_ID], [INSERT_TIME], [UPDATE_ID], [UPDATE_TIME], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [ATTRIBUTE11], [ATTRIBUTE12], [ATTRIBUTE13], [ATTRIBUTE14], [ATTRIBUTE15], [CONCAT_ALT_PRIORITY], [COPY_ALT_PRIORITY], [SCP_PLAN_YN], [ENG_ALT_ID], [ENG_ALT_PRIORITY], [ORG_ALT_ID], [ORG_ALT_PRIORITY], [CHILD_SEQ]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_B76F395C 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] c with (nolock)   
			where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MODEL_ID] = t.[MODEL_ID])  and (c.[CONCATENATE_ITEM] = t.[CONCATENATE_ITEM])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_B76F395C, __$count_B76F395C, t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[MODEL_ID], t.[PARENT_ITEM_ID], t.[CHILD_ITEM_ID], t.[CHILD_QTY], t.[CHILD_UOM], t.[ACCUMULATED_CHILD_QTY], t.[CONCATENATE_ITEM], t.[SORT_ORDER], t.[LEAF_LEVEL], t.[NLEVEL], t.[CHILD_COMPANY_ID], t.[CHILD_DIVISION_ID], t.[CHILD_SITE_ID], t.[CHILD_PLANT_ID], t.[ALT_ID], t.[ALT_PRIORITY], t.[ALT_RATE], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[CONCAT_ALT_PRIORITY], t.[COPY_ALT_PRIORITY], t.[SCP_PLAN_YN], t.[ENG_ALT_ID], t.[ENG_ALT_PRIORITY], t.[ORG_ALT_ID], t.[ORG_ALT_PRIORITY], t.[CHILD_SEQ] 
		from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] t with (nolock) inner join 
		(	select  r.[COMPANY_ID], r.[DIVISION_ID], r.[SITE_ID], r.[PLANT_ID], r.[MODEL_ID], r.[CONCATENATE_ITEM],
		    count(*) as __$count_B76F395C 
			from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[COMPANY_ID], r.[DIVISION_ID], r.[SITE_ID], r.[PLANT_ID], r.[MODEL_ID], r.[CONCATENATE_ITEM]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] c with (nolock) where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MODEL_ID] = t.[MODEL_ID])  and (c.[CONCATENATE_ITEM] = t.[CONCATENATE_ITEM])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[COMPANY_ID] = m.[COMPANY_ID]) and (t.[DIVISION_ID] = m.[DIVISION_ID])  and (t.[SITE_ID] = m.[SITE_ID])  and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[MODEL_ID] = m.[MODEL_ID])  and (t.[CONCATENATE_ITEM] = m.[CONCATENATE_ITEM])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_MODEL_BOM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] c with (nolock) 
							where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MODEL_ID] = t.[MODEL_ID])  and (c.[CONCATENATE_ITEM] = t.[CONCATENATE_ITEM])  )  
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
					[cdc].[dbo_SCM_MST_MODEL_BOM_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[COMPANY_ID] = mo.[COMPANY_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[SITE_ID] = mo.[SITE_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[MODEL_ID] = mo.[MODEL_ID])  and (t.[CONCATENATE_ITEM] = mo.[CONCATENATE_ITEM])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_B76F395C
	    when 1 then __$operation
	    else
			case __$min_op_B76F395C 
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
		case __$count_B76F395C
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_B76F395C 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [COMPANY_ID], [DIVISION_ID], [SITE_ID], [PLANT_ID], [MODEL_ID], [PARENT_ITEM_ID], [CHILD_ITEM_ID], [CHILD_QTY], [CHILD_UOM], [ACCUMULATED_CHILD_QTY], [CONCATENATE_ITEM], [SORT_ORDER], [LEAF_LEVEL], [NLEVEL], [CHILD_COMPANY_ID], [CHILD_DIVISION_ID], [CHILD_SITE_ID], [CHILD_PLANT_ID], [ALT_ID], [ALT_PRIORITY], [ALT_RATE], [INSERT_ID], [INSERT_TIME], [UPDATE_ID], [UPDATE_TIME], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [ATTRIBUTE11], [ATTRIBUTE12], [ATTRIBUTE13], [ATTRIBUTE14], [ATTRIBUTE15], [CONCAT_ALT_PRIORITY], [COPY_ALT_PRIORITY], [SCP_PLAN_YN], [ENG_ALT_ID], [ENG_ALT_PRIORITY], [ORG_ALT_ID], [ORG_ALT_PRIORITY], [CHILD_SEQ]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_B76F395C 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] c with (nolock)
			where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MODEL_ID] = t.[MODEL_ID])  and (c.[CONCATENATE_ITEM] = t.[CONCATENATE_ITEM])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_B76F395C, __$count_B76F395C, 
		m.__$update_mask , t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[MODEL_ID], t.[PARENT_ITEM_ID], t.[CHILD_ITEM_ID], t.[CHILD_QTY], t.[CHILD_UOM], t.[ACCUMULATED_CHILD_QTY], t.[CONCATENATE_ITEM], t.[SORT_ORDER], t.[LEAF_LEVEL], t.[NLEVEL], t.[CHILD_COMPANY_ID], t.[CHILD_DIVISION_ID], t.[CHILD_SITE_ID], t.[CHILD_PLANT_ID], t.[ALT_ID], t.[ALT_PRIORITY], t.[ALT_RATE], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[CONCAT_ALT_PRIORITY], t.[COPY_ALT_PRIORITY], t.[SCP_PLAN_YN], t.[ENG_ALT_ID], t.[ENG_ALT_PRIORITY], t.[ORG_ALT_ID], t.[ORG_ALT_PRIORITY], t.[CHILD_SEQ]
		from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] t with (nolock) inner join 
		(	select  r.[COMPANY_ID], r.[DIVISION_ID], r.[SITE_ID], r.[PLANT_ID], r.[MODEL_ID], r.[CONCATENATE_ITEM],
		    count(*) as __$count_B76F395C, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[COMPANY_ID], r.[DIVISION_ID], r.[SITE_ID], r.[PLANT_ID], r.[MODEL_ID], r.[CONCATENATE_ITEM]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] c with (nolock) where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MODEL_ID] = t.[MODEL_ID])  and (c.[CONCATENATE_ITEM] = t.[CONCATENATE_ITEM])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[COMPANY_ID] = m.[COMPANY_ID]) and (t.[DIVISION_ID] = m.[DIVISION_ID])  and (t.[SITE_ID] = m.[SITE_ID])  and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[MODEL_ID] = m.[MODEL_ID])  and (t.[CONCATENATE_ITEM] = m.[CONCATENATE_ITEM])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_MODEL_BOM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] c with (nolock)
							where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MODEL_ID] = t.[MODEL_ID])  and (c.[CONCATENATE_ITEM] = t.[CONCATENATE_ITEM])  )  
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
					[cdc].[dbo_SCM_MST_MODEL_BOM_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[COMPANY_ID] = mo.[COMPANY_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[SITE_ID] = mo.[SITE_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[MODEL_ID] = mo.[MODEL_ID])  and (t.[CONCATENATE_ITEM] = mo.[CONCATENATE_ITEM])  ) 
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
		null as __$update_mask , t.[COMPANY_ID], t.[DIVISION_ID], t.[SITE_ID], t.[PLANT_ID], t.[MODEL_ID], t.[PARENT_ITEM_ID], t.[CHILD_ITEM_ID], t.[CHILD_QTY], t.[CHILD_UOM], t.[ACCUMULATED_CHILD_QTY], t.[CONCATENATE_ITEM], t.[SORT_ORDER], t.[LEAF_LEVEL], t.[NLEVEL], t.[CHILD_COMPANY_ID], t.[CHILD_DIVISION_ID], t.[CHILD_SITE_ID], t.[CHILD_PLANT_ID], t.[ALT_ID], t.[ALT_PRIORITY], t.[ALT_RATE], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[ATTRIBUTE11], t.[ATTRIBUTE12], t.[ATTRIBUTE13], t.[ATTRIBUTE14], t.[ATTRIBUTE15], t.[CONCAT_ALT_PRIORITY], t.[COPY_ALT_PRIORITY], t.[SCP_PLAN_YN], t.[ENG_ALT_ID], t.[ENG_ALT_PRIORITY], t.[ORG_ALT_ID], t.[ORG_ALT_PRIORITY], t.[CHILD_SEQ]
		from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_MODEL_BOM', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] c with (nolock) where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MODEL_ID] = t.[MODEL_ID])  and (c.[CONCATENATE_ITEM] = t.[CONCATENATE_ITEM])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_MODEL_BOM_CT] c with (nolock)
							where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MODEL_ID] = t.[MODEL_ID])  and (c.[CONCATENATE_ITEM] = t.[CONCATENATE_ITEM])  )  
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
					[cdc].[dbo_SCM_MST_MODEL_BOM_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[COMPANY_ID] = mo.[COMPANY_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[SITE_ID] = mo.[SITE_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[MODEL_ID] = mo.[MODEL_ID])  and (t.[CONCATENATE_ITEM] = mo.[CONCATENATE_ITEM])  ) 
				group by
					mo.__$seqval
			)
	 