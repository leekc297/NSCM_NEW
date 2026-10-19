
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCP_ANL_MAT_SUPPLY]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [SCP_PLAN_START_YYYYMMDD], NULL as [MRP_PLAN_START_YYYYMMDD], NULL as [PSI], NULL as [MEASURE], NULL as [COMPANY], NULL as [DIVISION_ID], NULL as [ORIGIN_DIVISION_ID], NULL as [PLANT_ID], NULL as [MATERIAL], NULL as [OPERATION_GROUP], NULL as [OPERATION_ID], NULL as [ITEM_ID], NULL as [YYYYMMDD], NULL as [YYYYMM], NULL as [WEEK], NULL as [ISO_WEEK], NULL as [UOM], NULL as [NICKNAME], NULL as [SUPPLIER], NULL as [ITEM_CATEGORY], NULL as [QTY], NULL as [CELL_CF], NULL as [YIELD_RATE], NULL as [REMARK], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_MAT_SUPPLY', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_27536DD5
	    when 1 then __$operation
	    else
			case __$min_op_27536DD5 
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
		null as __$update_mask , [SCP_PLAN_START_YYYYMMDD], [MRP_PLAN_START_YYYYMMDD], [PSI], [MEASURE], [COMPANY], [DIVISION_ID], [ORIGIN_DIVISION_ID], [PLANT_ID], [MATERIAL], [OPERATION_GROUP], [OPERATION_ID], [ITEM_ID], [YYYYMMDD], [YYYYMM], [WEEK], [ISO_WEEK], [UOM], [NICKNAME], [SUPPLIER], [ITEM_CATEGORY], [QTY], [CELL_CF], [YIELD_RATE], [REMARK], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_27536DD5 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] c with (nolock)   
			where  ( (c.[SCP_PLAN_START_YYYYMMDD] = t.[SCP_PLAN_START_YYYYMMDD]) and (c.[MRP_PLAN_START_YYYYMMDD] = t.[MRP_PLAN_START_YYYYMMDD])  and (c.[PSI] = t.[PSI])  and (c.[MEASURE] = t.[MEASURE])  and (c.[COMPANY] = t.[COMPANY])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[ORIGIN_DIVISION_ID] = t.[ORIGIN_DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MATERIAL] = t.[MATERIAL])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[OPERATION_ID] = t.[OPERATION_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_27536DD5, __$count_27536DD5, t.[SCP_PLAN_START_YYYYMMDD], t.[MRP_PLAN_START_YYYYMMDD], t.[PSI], t.[MEASURE], t.[COMPANY], t.[DIVISION_ID], t.[ORIGIN_DIVISION_ID], t.[PLANT_ID], t.[MATERIAL], t.[OPERATION_GROUP], t.[OPERATION_ID], t.[ITEM_ID], t.[YYYYMMDD], t.[YYYYMM], t.[WEEK], t.[ISO_WEEK], t.[UOM], t.[NICKNAME], t.[SUPPLIER], t.[ITEM_CATEGORY], t.[QTY], t.[CELL_CF], t.[YIELD_RATE], t.[REMARK], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE] 
		from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] t with (nolock) inner join 
		(	select  r.[SCP_PLAN_START_YYYYMMDD], r.[MRP_PLAN_START_YYYYMMDD], r.[PSI], r.[MEASURE], r.[COMPANY], r.[DIVISION_ID], r.[ORIGIN_DIVISION_ID], r.[PLANT_ID], r.[MATERIAL], r.[OPERATION_GROUP], r.[OPERATION_ID], r.[ITEM_ID], r.[YYYYMMDD],
		    count(*) as __$count_27536DD5 
			from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[SCP_PLAN_START_YYYYMMDD], r.[MRP_PLAN_START_YYYYMMDD], r.[PSI], r.[MEASURE], r.[COMPANY], r.[DIVISION_ID], r.[ORIGIN_DIVISION_ID], r.[PLANT_ID], r.[MATERIAL], r.[OPERATION_GROUP], r.[OPERATION_ID], r.[ITEM_ID], r.[YYYYMMDD]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] c with (nolock) where  ( (c.[SCP_PLAN_START_YYYYMMDD] = t.[SCP_PLAN_START_YYYYMMDD]) and (c.[MRP_PLAN_START_YYYYMMDD] = t.[MRP_PLAN_START_YYYYMMDD])  and (c.[PSI] = t.[PSI])  and (c.[MEASURE] = t.[MEASURE])  and (c.[COMPANY] = t.[COMPANY])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[ORIGIN_DIVISION_ID] = t.[ORIGIN_DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MATERIAL] = t.[MATERIAL])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[OPERATION_ID] = t.[OPERATION_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[SCP_PLAN_START_YYYYMMDD] = m.[SCP_PLAN_START_YYYYMMDD]) and (t.[MRP_PLAN_START_YYYYMMDD] = m.[MRP_PLAN_START_YYYYMMDD])  and (t.[PSI] = m.[PSI])  and (t.[MEASURE] = m.[MEASURE])  and (t.[COMPANY] = m.[COMPANY])  and (t.[DIVISION_ID] = m.[DIVISION_ID])  and (t.[ORIGIN_DIVISION_ID] = m.[ORIGIN_DIVISION_ID])  and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[MATERIAL] = m.[MATERIAL])  and (t.[OPERATION_GROUP] = m.[OPERATION_GROUP])  and (t.[OPERATION_ID] = m.[OPERATION_ID])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[YYYYMMDD] = m.[YYYYMMDD])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_MAT_SUPPLY', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] c with (nolock) 
							where  ( (c.[SCP_PLAN_START_YYYYMMDD] = t.[SCP_PLAN_START_YYYYMMDD]) and (c.[MRP_PLAN_START_YYYYMMDD] = t.[MRP_PLAN_START_YYYYMMDD])  and (c.[PSI] = t.[PSI])  and (c.[MEASURE] = t.[MEASURE])  and (c.[COMPANY] = t.[COMPANY])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[ORIGIN_DIVISION_ID] = t.[ORIGIN_DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MATERIAL] = t.[MATERIAL])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[OPERATION_ID] = t.[OPERATION_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
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
					[cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[SCP_PLAN_START_YYYYMMDD] = mo.[SCP_PLAN_START_YYYYMMDD]) and (t.[MRP_PLAN_START_YYYYMMDD] = mo.[MRP_PLAN_START_YYYYMMDD])  and (t.[PSI] = mo.[PSI])  and (t.[MEASURE] = mo.[MEASURE])  and (t.[COMPANY] = mo.[COMPANY])  and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[ORIGIN_DIVISION_ID] = mo.[ORIGIN_DIVISION_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[MATERIAL] = mo.[MATERIAL])  and (t.[OPERATION_GROUP] = mo.[OPERATION_GROUP])  and (t.[OPERATION_ID] = mo.[OPERATION_ID])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[YYYYMMDD] = mo.[YYYYMMDD])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_27536DD5
	    when 1 then __$operation
	    else
			case __$min_op_27536DD5 
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
		case __$count_27536DD5
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_27536DD5 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [SCP_PLAN_START_YYYYMMDD], [MRP_PLAN_START_YYYYMMDD], [PSI], [MEASURE], [COMPANY], [DIVISION_ID], [ORIGIN_DIVISION_ID], [PLANT_ID], [MATERIAL], [OPERATION_GROUP], [OPERATION_ID], [ITEM_ID], [YYYYMMDD], [YYYYMM], [WEEK], [ISO_WEEK], [UOM], [NICKNAME], [SUPPLIER], [ITEM_CATEGORY], [QTY], [CELL_CF], [YIELD_RATE], [REMARK], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_27536DD5 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] c with (nolock)
			where  ( (c.[SCP_PLAN_START_YYYYMMDD] = t.[SCP_PLAN_START_YYYYMMDD]) and (c.[MRP_PLAN_START_YYYYMMDD] = t.[MRP_PLAN_START_YYYYMMDD])  and (c.[PSI] = t.[PSI])  and (c.[MEASURE] = t.[MEASURE])  and (c.[COMPANY] = t.[COMPANY])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[ORIGIN_DIVISION_ID] = t.[ORIGIN_DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MATERIAL] = t.[MATERIAL])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[OPERATION_ID] = t.[OPERATION_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_27536DD5, __$count_27536DD5, 
		m.__$update_mask , t.[SCP_PLAN_START_YYYYMMDD], t.[MRP_PLAN_START_YYYYMMDD], t.[PSI], t.[MEASURE], t.[COMPANY], t.[DIVISION_ID], t.[ORIGIN_DIVISION_ID], t.[PLANT_ID], t.[MATERIAL], t.[OPERATION_GROUP], t.[OPERATION_ID], t.[ITEM_ID], t.[YYYYMMDD], t.[YYYYMM], t.[WEEK], t.[ISO_WEEK], t.[UOM], t.[NICKNAME], t.[SUPPLIER], t.[ITEM_CATEGORY], t.[QTY], t.[CELL_CF], t.[YIELD_RATE], t.[REMARK], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE]
		from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] t with (nolock) inner join 
		(	select  r.[SCP_PLAN_START_YYYYMMDD], r.[MRP_PLAN_START_YYYYMMDD], r.[PSI], r.[MEASURE], r.[COMPANY], r.[DIVISION_ID], r.[ORIGIN_DIVISION_ID], r.[PLANT_ID], r.[MATERIAL], r.[OPERATION_GROUP], r.[OPERATION_ID], r.[ITEM_ID], r.[YYYYMMDD],
		    count(*) as __$count_27536DD5, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[SCP_PLAN_START_YYYYMMDD], r.[MRP_PLAN_START_YYYYMMDD], r.[PSI], r.[MEASURE], r.[COMPANY], r.[DIVISION_ID], r.[ORIGIN_DIVISION_ID], r.[PLANT_ID], r.[MATERIAL], r.[OPERATION_GROUP], r.[OPERATION_ID], r.[ITEM_ID], r.[YYYYMMDD]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] c with (nolock) where  ( (c.[SCP_PLAN_START_YYYYMMDD] = t.[SCP_PLAN_START_YYYYMMDD]) and (c.[MRP_PLAN_START_YYYYMMDD] = t.[MRP_PLAN_START_YYYYMMDD])  and (c.[PSI] = t.[PSI])  and (c.[MEASURE] = t.[MEASURE])  and (c.[COMPANY] = t.[COMPANY])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[ORIGIN_DIVISION_ID] = t.[ORIGIN_DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MATERIAL] = t.[MATERIAL])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[OPERATION_ID] = t.[OPERATION_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[SCP_PLAN_START_YYYYMMDD] = m.[SCP_PLAN_START_YYYYMMDD]) and (t.[MRP_PLAN_START_YYYYMMDD] = m.[MRP_PLAN_START_YYYYMMDD])  and (t.[PSI] = m.[PSI])  and (t.[MEASURE] = m.[MEASURE])  and (t.[COMPANY] = m.[COMPANY])  and (t.[DIVISION_ID] = m.[DIVISION_ID])  and (t.[ORIGIN_DIVISION_ID] = m.[ORIGIN_DIVISION_ID])  and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[MATERIAL] = m.[MATERIAL])  and (t.[OPERATION_GROUP] = m.[OPERATION_GROUP])  and (t.[OPERATION_ID] = m.[OPERATION_ID])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[YYYYMMDD] = m.[YYYYMMDD])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_MAT_SUPPLY', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] c with (nolock)
							where  ( (c.[SCP_PLAN_START_YYYYMMDD] = t.[SCP_PLAN_START_YYYYMMDD]) and (c.[MRP_PLAN_START_YYYYMMDD] = t.[MRP_PLAN_START_YYYYMMDD])  and (c.[PSI] = t.[PSI])  and (c.[MEASURE] = t.[MEASURE])  and (c.[COMPANY] = t.[COMPANY])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[ORIGIN_DIVISION_ID] = t.[ORIGIN_DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MATERIAL] = t.[MATERIAL])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[OPERATION_ID] = t.[OPERATION_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
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
					[cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[SCP_PLAN_START_YYYYMMDD] = mo.[SCP_PLAN_START_YYYYMMDD]) and (t.[MRP_PLAN_START_YYYYMMDD] = mo.[MRP_PLAN_START_YYYYMMDD])  and (t.[PSI] = mo.[PSI])  and (t.[MEASURE] = mo.[MEASURE])  and (t.[COMPANY] = mo.[COMPANY])  and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[ORIGIN_DIVISION_ID] = mo.[ORIGIN_DIVISION_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[MATERIAL] = mo.[MATERIAL])  and (t.[OPERATION_GROUP] = mo.[OPERATION_GROUP])  and (t.[OPERATION_ID] = mo.[OPERATION_ID])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[YYYYMMDD] = mo.[YYYYMMDD])  ) 
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
		null as __$update_mask , t.[SCP_PLAN_START_YYYYMMDD], t.[MRP_PLAN_START_YYYYMMDD], t.[PSI], t.[MEASURE], t.[COMPANY], t.[DIVISION_ID], t.[ORIGIN_DIVISION_ID], t.[PLANT_ID], t.[MATERIAL], t.[OPERATION_GROUP], t.[OPERATION_ID], t.[ITEM_ID], t.[YYYYMMDD], t.[YYYYMM], t.[WEEK], t.[ISO_WEEK], t.[UOM], t.[NICKNAME], t.[SUPPLIER], t.[ITEM_CATEGORY], t.[QTY], t.[CELL_CF], t.[YIELD_RATE], t.[REMARK], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE]
		from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_MAT_SUPPLY', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] c with (nolock) where  ( (c.[SCP_PLAN_START_YYYYMMDD] = t.[SCP_PLAN_START_YYYYMMDD]) and (c.[MRP_PLAN_START_YYYYMMDD] = t.[MRP_PLAN_START_YYYYMMDD])  and (c.[PSI] = t.[PSI])  and (c.[MEASURE] = t.[MEASURE])  and (c.[COMPANY] = t.[COMPANY])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[ORIGIN_DIVISION_ID] = t.[ORIGIN_DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MATERIAL] = t.[MATERIAL])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[OPERATION_ID] = t.[OPERATION_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] c with (nolock)
							where  ( (c.[SCP_PLAN_START_YYYYMMDD] = t.[SCP_PLAN_START_YYYYMMDD]) and (c.[MRP_PLAN_START_YYYYMMDD] = t.[MRP_PLAN_START_YYYYMMDD])  and (c.[PSI] = t.[PSI])  and (c.[MEASURE] = t.[MEASURE])  and (c.[COMPANY] = t.[COMPANY])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[ORIGIN_DIVISION_ID] = t.[ORIGIN_DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[MATERIAL] = t.[MATERIAL])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[OPERATION_ID] = t.[OPERATION_ID])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
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
					[cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[SCP_PLAN_START_YYYYMMDD] = mo.[SCP_PLAN_START_YYYYMMDD]) and (t.[MRP_PLAN_START_YYYYMMDD] = mo.[MRP_PLAN_START_YYYYMMDD])  and (t.[PSI] = mo.[PSI])  and (t.[MEASURE] = mo.[MEASURE])  and (t.[COMPANY] = mo.[COMPANY])  and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[ORIGIN_DIVISION_ID] = mo.[ORIGIN_DIVISION_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[MATERIAL] = mo.[MATERIAL])  and (t.[OPERATION_GROUP] = mo.[OPERATION_GROUP])  and (t.[OPERATION_ID] = mo.[OPERATION_ID])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[YYYYMMDD] = mo.[YYYYMMDD])  ) 
				group by
					mo.__$seqval
			)
	 