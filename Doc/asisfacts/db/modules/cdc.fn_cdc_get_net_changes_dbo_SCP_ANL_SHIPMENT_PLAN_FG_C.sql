
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCP_ANL_SHIPMENT_PLAN_FG_C]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [VERSION_NO], NULL as [CUTOFF_DATE], NULL as [PLAN_START_YYYYMMDD], NULL as [PLAN_TYPE], NULL as [SEQ], NULL as [BIZ_TYPE], NULL as [PROJECT_CODE], NULL as [ITEM_ID], NULL as [TO_SITE], NULL as [INCOTERMS], NULL as [FROM_SITE], NULL as [BOD_ID], NULL as [MEASURE], NULL as [YYYYMMDD], NULL as [QTY], NULL as [PROJECT_NAME], NULL as [BIZ_TYPE_NAME], NULL as [NICK_NAME], NULL as [TO_SITE_NAME], NULL as [FROM_SITE_NAME], NULL as [SOLDTO_DESCRIPTION], NULL as [SHIPTO_DESCRIPTION], NULL as [ORIGIN_TO_DIVISION_ID], NULL as [ORIGIN_FROM_DIVISION_ID], NULL as [ELECTRODE_TYPE], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_SHIPMENT_PLAN_FG_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_6342AE2E
	    when 1 then __$operation
	    else
			case __$min_op_6342AE2E 
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
		null as __$update_mask , [DIVISION_ID], [VERSION_NO], [CUTOFF_DATE], [PLAN_START_YYYYMMDD], [PLAN_TYPE], [SEQ], [BIZ_TYPE], [PROJECT_CODE], [ITEM_ID], [TO_SITE], [INCOTERMS], [FROM_SITE], [BOD_ID], [MEASURE], [YYYYMMDD], [QTY], [PROJECT_NAME], [BIZ_TYPE_NAME], [NICK_NAME], [TO_SITE_NAME], [FROM_SITE_NAME], [SOLDTO_DESCRIPTION], [SHIPTO_DESCRIPTION], [ORIGIN_TO_DIVISION_ID], [ORIGIN_FROM_DIVISION_ID], [ELECTRODE_TYPE], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_6342AE2E 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] c with (nolock)   
			where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[VERSION_NO] = t.[VERSION_NO])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[BIZ_TYPE] = t.[BIZ_TYPE])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[BOD_ID] = t.[BOD_ID])  and (c.[MEASURE] = t.[MEASURE])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_6342AE2E, __$count_6342AE2E, t.[DIVISION_ID], t.[VERSION_NO], t.[CUTOFF_DATE], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[BIZ_TYPE], t.[PROJECT_CODE], t.[ITEM_ID], t.[TO_SITE], t.[INCOTERMS], t.[FROM_SITE], t.[BOD_ID], t.[MEASURE], t.[YYYYMMDD], t.[QTY], t.[PROJECT_NAME], t.[BIZ_TYPE_NAME], t.[NICK_NAME], t.[TO_SITE_NAME], t.[FROM_SITE_NAME], t.[SOLDTO_DESCRIPTION], t.[SHIPTO_DESCRIPTION], t.[ORIGIN_TO_DIVISION_ID], t.[ORIGIN_FROM_DIVISION_ID], t.[ELECTRODE_TYPE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10] 
		from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] t with (nolock) inner join 
		(	select  r.[DIVISION_ID], r.[VERSION_NO], r.[CUTOFF_DATE], r.[BIZ_TYPE], r.[PROJECT_CODE], r.[ITEM_ID], r.[TO_SITE], r.[INCOTERMS], r.[FROM_SITE], r.[BOD_ID], r.[MEASURE], r.[YYYYMMDD],
		    count(*) as __$count_6342AE2E 
			from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[DIVISION_ID], r.[VERSION_NO], r.[CUTOFF_DATE], r.[BIZ_TYPE], r.[PROJECT_CODE], r.[ITEM_ID], r.[TO_SITE], r.[INCOTERMS], r.[FROM_SITE], r.[BOD_ID], r.[MEASURE], r.[YYYYMMDD]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[VERSION_NO] = t.[VERSION_NO])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[BIZ_TYPE] = t.[BIZ_TYPE])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[BOD_ID] = t.[BOD_ID])  and (c.[MEASURE] = t.[MEASURE])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[DIVISION_ID] = m.[DIVISION_ID]) and (t.[VERSION_NO] = m.[VERSION_NO])  and (t.[CUTOFF_DATE] = m.[CUTOFF_DATE])  and (t.[BIZ_TYPE] = m.[BIZ_TYPE])  and (t.[PROJECT_CODE] = m.[PROJECT_CODE])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[TO_SITE] = m.[TO_SITE])  and (t.[INCOTERMS] = m.[INCOTERMS])  and (t.[FROM_SITE] = m.[FROM_SITE])  and (t.[BOD_ID] = m.[BOD_ID])  and (t.[MEASURE] = m.[MEASURE])  and (t.[YYYYMMDD] = m.[YYYYMMDD])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_SHIPMENT_PLAN_FG_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] c with (nolock) 
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[VERSION_NO] = t.[VERSION_NO])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[BIZ_TYPE] = t.[BIZ_TYPE])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[BOD_ID] = t.[BOD_ID])  and (c.[MEASURE] = t.[MEASURE])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
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
					[cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[VERSION_NO] = mo.[VERSION_NO])  and (t.[CUTOFF_DATE] = mo.[CUTOFF_DATE])  and (t.[BIZ_TYPE] = mo.[BIZ_TYPE])  and (t.[PROJECT_CODE] = mo.[PROJECT_CODE])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[TO_SITE] = mo.[TO_SITE])  and (t.[INCOTERMS] = mo.[INCOTERMS])  and (t.[FROM_SITE] = mo.[FROM_SITE])  and (t.[BOD_ID] = mo.[BOD_ID])  and (t.[MEASURE] = mo.[MEASURE])  and (t.[YYYYMMDD] = mo.[YYYYMMDD])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_6342AE2E
	    when 1 then __$operation
	    else
			case __$min_op_6342AE2E 
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
		case __$count_6342AE2E
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_6342AE2E 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [DIVISION_ID], [VERSION_NO], [CUTOFF_DATE], [PLAN_START_YYYYMMDD], [PLAN_TYPE], [SEQ], [BIZ_TYPE], [PROJECT_CODE], [ITEM_ID], [TO_SITE], [INCOTERMS], [FROM_SITE], [BOD_ID], [MEASURE], [YYYYMMDD], [QTY], [PROJECT_NAME], [BIZ_TYPE_NAME], [NICK_NAME], [TO_SITE_NAME], [FROM_SITE_NAME], [SOLDTO_DESCRIPTION], [SHIPTO_DESCRIPTION], [ORIGIN_TO_DIVISION_ID], [ORIGIN_FROM_DIVISION_ID], [ELECTRODE_TYPE], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_6342AE2E 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] c with (nolock)
			where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[VERSION_NO] = t.[VERSION_NO])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[BIZ_TYPE] = t.[BIZ_TYPE])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[BOD_ID] = t.[BOD_ID])  and (c.[MEASURE] = t.[MEASURE])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_6342AE2E, __$count_6342AE2E, 
		m.__$update_mask , t.[DIVISION_ID], t.[VERSION_NO], t.[CUTOFF_DATE], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[BIZ_TYPE], t.[PROJECT_CODE], t.[ITEM_ID], t.[TO_SITE], t.[INCOTERMS], t.[FROM_SITE], t.[BOD_ID], t.[MEASURE], t.[YYYYMMDD], t.[QTY], t.[PROJECT_NAME], t.[BIZ_TYPE_NAME], t.[NICK_NAME], t.[TO_SITE_NAME], t.[FROM_SITE_NAME], t.[SOLDTO_DESCRIPTION], t.[SHIPTO_DESCRIPTION], t.[ORIGIN_TO_DIVISION_ID], t.[ORIGIN_FROM_DIVISION_ID], t.[ELECTRODE_TYPE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] t with (nolock) inner join 
		(	select  r.[DIVISION_ID], r.[VERSION_NO], r.[CUTOFF_DATE], r.[BIZ_TYPE], r.[PROJECT_CODE], r.[ITEM_ID], r.[TO_SITE], r.[INCOTERMS], r.[FROM_SITE], r.[BOD_ID], r.[MEASURE], r.[YYYYMMDD],
		    count(*) as __$count_6342AE2E, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[DIVISION_ID], r.[VERSION_NO], r.[CUTOFF_DATE], r.[BIZ_TYPE], r.[PROJECT_CODE], r.[ITEM_ID], r.[TO_SITE], r.[INCOTERMS], r.[FROM_SITE], r.[BOD_ID], r.[MEASURE], r.[YYYYMMDD]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[VERSION_NO] = t.[VERSION_NO])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[BIZ_TYPE] = t.[BIZ_TYPE])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[BOD_ID] = t.[BOD_ID])  and (c.[MEASURE] = t.[MEASURE])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[DIVISION_ID] = m.[DIVISION_ID]) and (t.[VERSION_NO] = m.[VERSION_NO])  and (t.[CUTOFF_DATE] = m.[CUTOFF_DATE])  and (t.[BIZ_TYPE] = m.[BIZ_TYPE])  and (t.[PROJECT_CODE] = m.[PROJECT_CODE])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[TO_SITE] = m.[TO_SITE])  and (t.[INCOTERMS] = m.[INCOTERMS])  and (t.[FROM_SITE] = m.[FROM_SITE])  and (t.[BOD_ID] = m.[BOD_ID])  and (t.[MEASURE] = m.[MEASURE])  and (t.[YYYYMMDD] = m.[YYYYMMDD])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_SHIPMENT_PLAN_FG_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] c with (nolock)
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[VERSION_NO] = t.[VERSION_NO])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[BIZ_TYPE] = t.[BIZ_TYPE])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[BOD_ID] = t.[BOD_ID])  and (c.[MEASURE] = t.[MEASURE])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
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
					[cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[VERSION_NO] = mo.[VERSION_NO])  and (t.[CUTOFF_DATE] = mo.[CUTOFF_DATE])  and (t.[BIZ_TYPE] = mo.[BIZ_TYPE])  and (t.[PROJECT_CODE] = mo.[PROJECT_CODE])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[TO_SITE] = mo.[TO_SITE])  and (t.[INCOTERMS] = mo.[INCOTERMS])  and (t.[FROM_SITE] = mo.[FROM_SITE])  and (t.[BOD_ID] = mo.[BOD_ID])  and (t.[MEASURE] = mo.[MEASURE])  and (t.[YYYYMMDD] = mo.[YYYYMMDD])  ) 
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
		null as __$update_mask , t.[DIVISION_ID], t.[VERSION_NO], t.[CUTOFF_DATE], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[BIZ_TYPE], t.[PROJECT_CODE], t.[ITEM_ID], t.[TO_SITE], t.[INCOTERMS], t.[FROM_SITE], t.[BOD_ID], t.[MEASURE], t.[YYYYMMDD], t.[QTY], t.[PROJECT_NAME], t.[BIZ_TYPE_NAME], t.[NICK_NAME], t.[TO_SITE_NAME], t.[FROM_SITE_NAME], t.[SOLDTO_DESCRIPTION], t.[SHIPTO_DESCRIPTION], t.[ORIGIN_TO_DIVISION_ID], t.[ORIGIN_FROM_DIVISION_ID], t.[ELECTRODE_TYPE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
		from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_SHIPMENT_PLAN_FG_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[VERSION_NO] = t.[VERSION_NO])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[BIZ_TYPE] = t.[BIZ_TYPE])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[BOD_ID] = t.[BOD_ID])  and (c.[MEASURE] = t.[MEASURE])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] c with (nolock)
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[VERSION_NO] = t.[VERSION_NO])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[BIZ_TYPE] = t.[BIZ_TYPE])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[BOD_ID] = t.[BOD_ID])  and (c.[MEASURE] = t.[MEASURE])  and (c.[YYYYMMDD] = t.[YYYYMMDD])  )  
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
					[cdc].[dbo_SCP_ANL_SHIPMENT_PLAN_FG_C_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[VERSION_NO] = mo.[VERSION_NO])  and (t.[CUTOFF_DATE] = mo.[CUTOFF_DATE])  and (t.[BIZ_TYPE] = mo.[BIZ_TYPE])  and (t.[PROJECT_CODE] = mo.[PROJECT_CODE])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[TO_SITE] = mo.[TO_SITE])  and (t.[INCOTERMS] = mo.[INCOTERMS])  and (t.[FROM_SITE] = mo.[FROM_SITE])  and (t.[BOD_ID] = mo.[BOD_ID])  and (t.[MEASURE] = mo.[MEASURE])  and (t.[YYYYMMDD] = mo.[YYYYMMDD])  ) 
				group by
					mo.__$seqval
			)
	 