
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCM_MST_SITE]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [SCM_SITE_ID], NULL as [PLANT_ID], NULL as [OPERATION_GROUP], NULL as [SITE_DESCRIPTION], NULL as [SITE_TYPE], NULL as [CITY], NULL as [COUNTRY], NULL as [DEPT_ID], NULL as [VMI_YN], NULL as [VALID_YN], NULL as [NEW_YN], NULL as [SITE_HRCY_ID], NULL as [OSP_YN], NULL as [SHIP_FROZEN], NULL as [PROD_FROZEN], NULL as [END_CUSTOMER], NULL as [SOLDTO_CUSTOMER], NULL as [FP_PLAN_PERIOD], NULL as [BUILD_AHEAD], NULL as [LOGISTIC_PLANT_ID], NULL as [PACKER_ITEM_ID_SUFFIX], NULL as [HQ_VENDOR_CODE], NULL as [COMPANY_ID], NULL as [SITE_ID], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SITE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_6D210DD3
	    when 1 then __$operation
	    else
			case __$min_op_6D210DD3 
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
		null as __$update_mask , [DIVISION_ID], [SCM_SITE_ID], [PLANT_ID], [OPERATION_GROUP], [SITE_DESCRIPTION], [SITE_TYPE], [CITY], [COUNTRY], [DEPT_ID], [VMI_YN], [VALID_YN], [NEW_YN], [SITE_HRCY_ID], [OSP_YN], [SHIP_FROZEN], [PROD_FROZEN], [END_CUSTOMER], [SOLDTO_CUSTOMER], [FP_PLAN_PERIOD], [BUILD_AHEAD], [LOGISTIC_PLANT_ID], [PACKER_ITEM_ID_SUFFIX], [HQ_VENDOR_CODE], [COMPANY_ID], [SITE_ID], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_6D210DD3 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_SITE_CT] c with (nolock)   
			where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_6D210DD3, __$count_6D210DD3, t.[DIVISION_ID], t.[SCM_SITE_ID], t.[PLANT_ID], t.[OPERATION_GROUP], t.[SITE_DESCRIPTION], t.[SITE_TYPE], t.[CITY], t.[COUNTRY], t.[DEPT_ID], t.[VMI_YN], t.[VALID_YN], t.[NEW_YN], t.[SITE_HRCY_ID], t.[OSP_YN], t.[SHIP_FROZEN], t.[PROD_FROZEN], t.[END_CUSTOMER], t.[SOLDTO_CUSTOMER], t.[FP_PLAN_PERIOD], t.[BUILD_AHEAD], t.[LOGISTIC_PLANT_ID], t.[PACKER_ITEM_ID_SUFFIX], t.[HQ_VENDOR_CODE], t.[COMPANY_ID], t.[SITE_ID], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10] 
		from [cdc].[dbo_SCM_MST_SITE_CT] t with (nolock) inner join 
		(	select  r.[DIVISION_ID], r.[SCM_SITE_ID],
		    count(*) as __$count_6D210DD3 
			from [cdc].[dbo_SCM_MST_SITE_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[DIVISION_ID], r.[SCM_SITE_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_SITE_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[DIVISION_ID] = m.[DIVISION_ID]) and (t.[SCM_SITE_ID] = m.[SCM_SITE_ID])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SITE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_SITE_CT] c with (nolock) 
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  )  
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
					[cdc].[dbo_SCM_MST_SITE_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[SCM_SITE_ID] = mo.[SCM_SITE_ID])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_6D210DD3
	    when 1 then __$operation
	    else
			case __$min_op_6D210DD3 
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
		case __$count_6D210DD3
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_6D210DD3 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [DIVISION_ID], [SCM_SITE_ID], [PLANT_ID], [OPERATION_GROUP], [SITE_DESCRIPTION], [SITE_TYPE], [CITY], [COUNTRY], [DEPT_ID], [VMI_YN], [VALID_YN], [NEW_YN], [SITE_HRCY_ID], [OSP_YN], [SHIP_FROZEN], [PROD_FROZEN], [END_CUSTOMER], [SOLDTO_CUSTOMER], [FP_PLAN_PERIOD], [BUILD_AHEAD], [LOGISTIC_PLANT_ID], [PACKER_ITEM_ID_SUFFIX], [HQ_VENDOR_CODE], [COMPANY_ID], [SITE_ID], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_6D210DD3 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_SITE_CT] c with (nolock)
			where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_6D210DD3, __$count_6D210DD3, 
		m.__$update_mask , t.[DIVISION_ID], t.[SCM_SITE_ID], t.[PLANT_ID], t.[OPERATION_GROUP], t.[SITE_DESCRIPTION], t.[SITE_TYPE], t.[CITY], t.[COUNTRY], t.[DEPT_ID], t.[VMI_YN], t.[VALID_YN], t.[NEW_YN], t.[SITE_HRCY_ID], t.[OSP_YN], t.[SHIP_FROZEN], t.[PROD_FROZEN], t.[END_CUSTOMER], t.[SOLDTO_CUSTOMER], t.[FP_PLAN_PERIOD], t.[BUILD_AHEAD], t.[LOGISTIC_PLANT_ID], t.[PACKER_ITEM_ID_SUFFIX], t.[HQ_VENDOR_CODE], t.[COMPANY_ID], t.[SITE_ID], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_SCM_MST_SITE_CT] t with (nolock) inner join 
		(	select  r.[DIVISION_ID], r.[SCM_SITE_ID],
		    count(*) as __$count_6D210DD3, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCM_MST_SITE_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[DIVISION_ID], r.[SCM_SITE_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_SITE_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[DIVISION_ID] = m.[DIVISION_ID]) and (t.[SCM_SITE_ID] = m.[SCM_SITE_ID])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SITE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_SITE_CT] c with (nolock)
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  )  
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
					[cdc].[dbo_SCM_MST_SITE_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[SCM_SITE_ID] = mo.[SCM_SITE_ID])  ) 
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
		null as __$update_mask , t.[DIVISION_ID], t.[SCM_SITE_ID], t.[PLANT_ID], t.[OPERATION_GROUP], t.[SITE_DESCRIPTION], t.[SITE_TYPE], t.[CITY], t.[COUNTRY], t.[DEPT_ID], t.[VMI_YN], t.[VALID_YN], t.[NEW_YN], t.[SITE_HRCY_ID], t.[OSP_YN], t.[SHIP_FROZEN], t.[PROD_FROZEN], t.[END_CUSTOMER], t.[SOLDTO_CUSTOMER], t.[FP_PLAN_PERIOD], t.[BUILD_AHEAD], t.[LOGISTIC_PLANT_ID], t.[PACKER_ITEM_ID_SUFFIX], t.[HQ_VENDOR_CODE], t.[COMPANY_ID], t.[SITE_ID], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_SCM_MST_SITE_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SITE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_SITE_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_SITE_CT] c with (nolock)
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  )  
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
					[cdc].[dbo_SCM_MST_SITE_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[SCM_SITE_ID] = mo.[SCM_SITE_ID])  ) 
				group by
					mo.__$seqval
			)
	 