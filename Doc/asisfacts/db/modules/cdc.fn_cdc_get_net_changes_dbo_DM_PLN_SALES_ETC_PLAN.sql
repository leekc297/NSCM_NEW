
	create function [cdc].[fn_cdc_get_net_changes_dbo_DM_PLN_SALES_ETC_PLAN]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [PROJECT_CODE], NULL as [SCM_SITE_ID], NULL as [ITEM_ID], NULL as [REMARK_TEXT], NULL as [DOM_EXP], NULL as [FCST_TYPE], NULL as [INCOTERMS], NULL as [MEASURE], NULL as [PLANT_SITE_ID], NULL as [YYYYMMDD], NULL as [CURRENCY], NULL as [QTY], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_DM_PLN_SALES_ETC_PLAN', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_392D9183
	    when 1 then __$operation
	    else
			case __$min_op_392D9183 
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
		null as __$update_mask , [DIVISION_ID], [PROJECT_CODE], [SCM_SITE_ID], [ITEM_ID], [REMARK_TEXT], [DOM_EXP], [FCST_TYPE], [INCOTERMS], [MEASURE], [PLANT_SITE_ID], [YYYYMMDD], [CURRENCY], [QTY], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_392D9183 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] c with (nolock)   
			where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[REMARK_TEXT] = t.[REMARK_TEXT])  and (c.[DOM_EXP] = t.[DOM_EXP])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[MEASURE] = t.[MEASURE])  and (c.[PLANT_SITE_ID] = t.[PLANT_SITE_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_392D9183, __$count_392D9183, t.[DIVISION_ID], t.[PROJECT_CODE], t.[SCM_SITE_ID], t.[ITEM_ID], t.[REMARK_TEXT], t.[DOM_EXP], t.[FCST_TYPE], t.[INCOTERMS], t.[MEASURE], t.[PLANT_SITE_ID], t.[YYYYMMDD], t.[CURRENCY], t.[QTY], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10] 
		from [cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] t with (nolock) inner join 
		(	select  r.[DIVISION_ID], r.[PROJECT_CODE], r.[SCM_SITE_ID], r.[ITEM_ID], r.[REMARK_TEXT], r.[DOM_EXP], r.[FCST_TYPE], r.[INCOTERMS], r.[MEASURE], r.[PLANT_SITE_ID], r.[YYYYMMDD],
		    count(*) as __$count_392D9183 
			from [cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[DIVISION_ID], r.[PROJECT_CODE], r.[SCM_SITE_ID], r.[ITEM_ID], r.[REMARK_TEXT], r.[DOM_EXP], r.[FCST_TYPE], r.[INCOTERMS], r.[MEASURE], r.[PLANT_SITE_ID], r.[YYYYMMDD]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[REMARK_TEXT] = t.[REMARK_TEXT])  and (c.[DOM_EXP] = t.[DOM_EXP])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[MEASURE] = t.[MEASURE])  and (c.[PLANT_SITE_ID] = t.[PLANT_SITE_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[DIVISION_ID] = m.[DIVISION_ID]) and (t.[PROJECT_CODE] = m.[PROJECT_CODE])  and (t.[SCM_SITE_ID] = m.[SCM_SITE_ID])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[REMARK_TEXT] = m.[REMARK_TEXT])  and (t.[DOM_EXP] = m.[DOM_EXP])  and (t.[FCST_TYPE] = m.[FCST_TYPE])  and (t.[INCOTERMS] = m.[INCOTERMS])  and (t.[MEASURE] = m.[MEASURE])  and (t.[PLANT_SITE_ID] = m.[PLANT_SITE_ID])  and (t.[YYYYMMDD] = m.[YYYYMMDD])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_DM_PLN_SALES_ETC_PLAN', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] c with (nolock) 
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[REMARK_TEXT] = t.[REMARK_TEXT])  and (c.[DOM_EXP] = t.[DOM_EXP])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[MEASURE] = t.[MEASURE])  and (c.[PLANT_SITE_ID] = t.[PLANT_SITE_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
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
					[cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[PROJECT_CODE] = mo.[PROJECT_CODE])  and (t.[SCM_SITE_ID] = mo.[SCM_SITE_ID])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[REMARK_TEXT] = mo.[REMARK_TEXT])  and (t.[DOM_EXP] = mo.[DOM_EXP])  and (t.[FCST_TYPE] = mo.[FCST_TYPE])  and (t.[INCOTERMS] = mo.[INCOTERMS])  and (t.[MEASURE] = mo.[MEASURE])  and (t.[PLANT_SITE_ID] = mo.[PLANT_SITE_ID])  and (t.[YYYYMMDD] = mo.[YYYYMMDD])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_392D9183
	    when 1 then __$operation
	    else
			case __$min_op_392D9183 
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
		case __$count_392D9183
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_392D9183 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [DIVISION_ID], [PROJECT_CODE], [SCM_SITE_ID], [ITEM_ID], [REMARK_TEXT], [DOM_EXP], [FCST_TYPE], [INCOTERMS], [MEASURE], [PLANT_SITE_ID], [YYYYMMDD], [CURRENCY], [QTY], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_392D9183 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] c with (nolock)
			where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[REMARK_TEXT] = t.[REMARK_TEXT])  and (c.[DOM_EXP] = t.[DOM_EXP])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[MEASURE] = t.[MEASURE])  and (c.[PLANT_SITE_ID] = t.[PLANT_SITE_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_392D9183, __$count_392D9183, 
		m.__$update_mask , t.[DIVISION_ID], t.[PROJECT_CODE], t.[SCM_SITE_ID], t.[ITEM_ID], t.[REMARK_TEXT], t.[DOM_EXP], t.[FCST_TYPE], t.[INCOTERMS], t.[MEASURE], t.[PLANT_SITE_ID], t.[YYYYMMDD], t.[CURRENCY], t.[QTY], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] t with (nolock) inner join 
		(	select  r.[DIVISION_ID], r.[PROJECT_CODE], r.[SCM_SITE_ID], r.[ITEM_ID], r.[REMARK_TEXT], r.[DOM_EXP], r.[FCST_TYPE], r.[INCOTERMS], r.[MEASURE], r.[PLANT_SITE_ID], r.[YYYYMMDD],
		    count(*) as __$count_392D9183, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[DIVISION_ID], r.[PROJECT_CODE], r.[SCM_SITE_ID], r.[ITEM_ID], r.[REMARK_TEXT], r.[DOM_EXP], r.[FCST_TYPE], r.[INCOTERMS], r.[MEASURE], r.[PLANT_SITE_ID], r.[YYYYMMDD]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[REMARK_TEXT] = t.[REMARK_TEXT])  and (c.[DOM_EXP] = t.[DOM_EXP])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[MEASURE] = t.[MEASURE])  and (c.[PLANT_SITE_ID] = t.[PLANT_SITE_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[DIVISION_ID] = m.[DIVISION_ID]) and (t.[PROJECT_CODE] = m.[PROJECT_CODE])  and (t.[SCM_SITE_ID] = m.[SCM_SITE_ID])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[REMARK_TEXT] = m.[REMARK_TEXT])  and (t.[DOM_EXP] = m.[DOM_EXP])  and (t.[FCST_TYPE] = m.[FCST_TYPE])  and (t.[INCOTERMS] = m.[INCOTERMS])  and (t.[MEASURE] = m.[MEASURE])  and (t.[PLANT_SITE_ID] = m.[PLANT_SITE_ID])  and (t.[YYYYMMDD] = m.[YYYYMMDD])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_DM_PLN_SALES_ETC_PLAN', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] c with (nolock)
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[REMARK_TEXT] = t.[REMARK_TEXT])  and (c.[DOM_EXP] = t.[DOM_EXP])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[MEASURE] = t.[MEASURE])  and (c.[PLANT_SITE_ID] = t.[PLANT_SITE_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
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
					[cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[PROJECT_CODE] = mo.[PROJECT_CODE])  and (t.[SCM_SITE_ID] = mo.[SCM_SITE_ID])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[REMARK_TEXT] = mo.[REMARK_TEXT])  and (t.[DOM_EXP] = mo.[DOM_EXP])  and (t.[FCST_TYPE] = mo.[FCST_TYPE])  and (t.[INCOTERMS] = mo.[INCOTERMS])  and (t.[MEASURE] = mo.[MEASURE])  and (t.[PLANT_SITE_ID] = mo.[PLANT_SITE_ID])  and (t.[YYYYMMDD] = mo.[YYYYMMDD])  ) 
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
		null as __$update_mask , t.[DIVISION_ID], t.[PROJECT_CODE], t.[SCM_SITE_ID], t.[ITEM_ID], t.[REMARK_TEXT], t.[DOM_EXP], t.[FCST_TYPE], t.[INCOTERMS], t.[MEASURE], t.[PLANT_SITE_ID], t.[YYYYMMDD], t.[CURRENCY], t.[QTY], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_DM_PLN_SALES_ETC_PLAN', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[REMARK_TEXT] = t.[REMARK_TEXT])  and (c.[DOM_EXP] = t.[DOM_EXP])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[MEASURE] = t.[MEASURE])  and (c.[PLANT_SITE_ID] = t.[PLANT_SITE_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] c with (nolock)
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[REMARK_TEXT] = t.[REMARK_TEXT])  and (c.[DOM_EXP] = t.[DOM_EXP])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[MEASURE] = t.[MEASURE])  and (c.[PLANT_SITE_ID] = t.[PLANT_SITE_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
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
					[cdc].[dbo_DM_PLN_SALES_ETC_PLAN_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[PROJECT_CODE] = mo.[PROJECT_CODE])  and (t.[SCM_SITE_ID] = mo.[SCM_SITE_ID])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[REMARK_TEXT] = mo.[REMARK_TEXT])  and (t.[DOM_EXP] = mo.[DOM_EXP])  and (t.[FCST_TYPE] = mo.[FCST_TYPE])  and (t.[INCOTERMS] = mo.[INCOTERMS])  and (t.[MEASURE] = mo.[MEASURE])  and (t.[PLANT_SITE_ID] = mo.[PLANT_SITE_ID])  and (t.[YYYYMMDD] = mo.[YYYYMMDD])  ) 
				group by
					mo.__$seqval
			)
	 