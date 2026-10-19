
	create function [cdc].[fn_cdc_get_net_changes_dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [PLANT_ID], NULL as [OPERATION_GROUP], NULL as [FROM_SITE], NULL as [TO_SITE], NULL as [ITEM_ID], NULL as [YYYYMMDD], NULL as [YYYYMM], NULL as [WEEK_NAME], NULL as [DO_QTY], NULL as [EXFACTORY_QTY], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_D915C0E4
	    when 1 then __$operation
	    else
			case __$min_op_D915C0E4 
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
		null as __$update_mask , [DIVISION_ID], [PLANT_ID], [OPERATION_GROUP], [FROM_SITE], [TO_SITE], [ITEM_ID], [YYYYMMDD], [YYYYMM], [WEEK_NAME], [DO_QTY], [EXFACTORY_QTY], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_D915C0E4 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] c with (nolock)   
			where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  and (c.[YYYYMM] = t.[YYYYMM])  and (c.[WEEK_NAME] = t.[WEEK_NAME])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_D915C0E4, __$count_D915C0E4, t.[DIVISION_ID], t.[PLANT_ID], t.[OPERATION_GROUP], t.[FROM_SITE], t.[TO_SITE], t.[ITEM_ID], t.[YYYYMMDD], t.[YYYYMM], t.[WEEK_NAME], t.[DO_QTY], t.[EXFACTORY_QTY], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10] 
		from [cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] t with (nolock) inner join 
		(	select  r.[DIVISION_ID], r.[PLANT_ID], r.[OPERATION_GROUP], r.[FROM_SITE], r.[TO_SITE], r.[ITEM_ID], r.[YYYYMMDD], r.[YYYYMM], r.[WEEK_NAME],
		    count(*) as __$count_D915C0E4 
			from [cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[DIVISION_ID], r.[PLANT_ID], r.[OPERATION_GROUP], r.[FROM_SITE], r.[TO_SITE], r.[ITEM_ID], r.[YYYYMMDD], r.[YYYYMM], r.[WEEK_NAME]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  and (c.[YYYYMM] = t.[YYYYMM])  and (c.[WEEK_NAME] = t.[WEEK_NAME])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[DIVISION_ID] = m.[DIVISION_ID]) and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[OPERATION_GROUP] = m.[OPERATION_GROUP])  and (t.[FROM_SITE] = m.[FROM_SITE])  and (t.[TO_SITE] = m.[TO_SITE])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[YYYYMMDD] = m.[YYYYMMDD])  and (t.[YYYYMM] = m.[YYYYMM])  and (t.[WEEK_NAME] = m.[WEEK_NAME])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] c with (nolock) 
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  and (c.[YYYYMM] = t.[YYYYMM])  and (c.[WEEK_NAME] = t.[WEEK_NAME])  )  
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
					[cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[OPERATION_GROUP] = mo.[OPERATION_GROUP])  and (t.[FROM_SITE] = mo.[FROM_SITE])  and (t.[TO_SITE] = mo.[TO_SITE])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[YYYYMMDD] = mo.[YYYYMMDD])  and (t.[YYYYMM] = mo.[YYYYMM])  and (t.[WEEK_NAME] = mo.[WEEK_NAME])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_D915C0E4
	    when 1 then __$operation
	    else
			case __$min_op_D915C0E4 
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
		case __$count_D915C0E4
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_D915C0E4 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [DIVISION_ID], [PLANT_ID], [OPERATION_GROUP], [FROM_SITE], [TO_SITE], [ITEM_ID], [YYYYMMDD], [YYYYMM], [WEEK_NAME], [DO_QTY], [EXFACTORY_QTY], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_D915C0E4 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] c with (nolock)
			where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  and (c.[YYYYMM] = t.[YYYYMM])  and (c.[WEEK_NAME] = t.[WEEK_NAME])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_D915C0E4, __$count_D915C0E4, 
		m.__$update_mask , t.[DIVISION_ID], t.[PLANT_ID], t.[OPERATION_GROUP], t.[FROM_SITE], t.[TO_SITE], t.[ITEM_ID], t.[YYYYMMDD], t.[YYYYMM], t.[WEEK_NAME], t.[DO_QTY], t.[EXFACTORY_QTY], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] t with (nolock) inner join 
		(	select  r.[DIVISION_ID], r.[PLANT_ID], r.[OPERATION_GROUP], r.[FROM_SITE], r.[TO_SITE], r.[ITEM_ID], r.[YYYYMMDD], r.[YYYYMM], r.[WEEK_NAME],
		    count(*) as __$count_D915C0E4, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[DIVISION_ID], r.[PLANT_ID], r.[OPERATION_GROUP], r.[FROM_SITE], r.[TO_SITE], r.[ITEM_ID], r.[YYYYMMDD], r.[YYYYMM], r.[WEEK_NAME]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  and (c.[YYYYMM] = t.[YYYYMM])  and (c.[WEEK_NAME] = t.[WEEK_NAME])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[DIVISION_ID] = m.[DIVISION_ID]) and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[OPERATION_GROUP] = m.[OPERATION_GROUP])  and (t.[FROM_SITE] = m.[FROM_SITE])  and (t.[TO_SITE] = m.[TO_SITE])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[YYYYMMDD] = m.[YYYYMMDD])  and (t.[YYYYMM] = m.[YYYYMM])  and (t.[WEEK_NAME] = m.[WEEK_NAME])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] c with (nolock)
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  and (c.[YYYYMM] = t.[YYYYMM])  and (c.[WEEK_NAME] = t.[WEEK_NAME])  )  
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
					[cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[OPERATION_GROUP] = mo.[OPERATION_GROUP])  and (t.[FROM_SITE] = mo.[FROM_SITE])  and (t.[TO_SITE] = mo.[TO_SITE])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[YYYYMMDD] = mo.[YYYYMMDD])  and (t.[YYYYMM] = mo.[YYYYMM])  and (t.[WEEK_NAME] = mo.[WEEK_NAME])  ) 
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
		null as __$update_mask , t.[DIVISION_ID], t.[PLANT_ID], t.[OPERATION_GROUP], t.[FROM_SITE], t.[TO_SITE], t.[ITEM_ID], t.[YYYYMMDD], t.[YYYYMM], t.[WEEK_NAME], t.[DO_QTY], t.[EXFACTORY_QTY], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  and (c.[YYYYMM] = t.[YYYYMM])  and (c.[WEEK_NAME] = t.[WEEK_NAME])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] c with (nolock)
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[OPERATION_GROUP] = t.[OPERATION_GROUP])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  and (c.[YYYYMM] = t.[YYYYMM])  and (c.[WEEK_NAME] = t.[WEEK_NAME])  )  
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
					[cdc].[dbo_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[OPERATION_GROUP] = mo.[OPERATION_GROUP])  and (t.[FROM_SITE] = mo.[FROM_SITE])  and (t.[TO_SITE] = mo.[TO_SITE])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[YYYYMMDD] = mo.[YYYYMMDD])  and (t.[YYYYMM] = mo.[YYYYMM])  and (t.[WEEK_NAME] = mo.[WEEK_NAME])  ) 
				group by
					mo.__$seqval
			)
	 