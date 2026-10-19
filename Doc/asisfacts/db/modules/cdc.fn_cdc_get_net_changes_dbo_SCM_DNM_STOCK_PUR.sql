
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCM_DNM_STOCK_PUR]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [COMPANY_ID], NULL as [DIVISION_ID], NULL as [SCM_SITE_ID], NULL as [SITE_ID], NULL as [PLANT_ID], NULL as [FACTORY_ID], NULL as [STORAGE_ID], NULL as [CUTOFF_DATE], NULL as [SEQ], NULL as [STOCK_TYPE], NULL as [ITEM_ID], NULL as [LANE], NULL as [PRODUCTION_TYPE], NULL as [AVAILABLE_DATE], NULL as [REMAIN_LEAD_TIME], NULL as [HOLDING_DATE], NULL as [QTY], NULL as [QTY_UOM], NULL as [STOCK_STATUS], NULL as [OPERATION_ID], NULL as [LINE_ID], NULL as [OUTSOURCING_FLAG], NULL as [OUTSOURCING_FACTORY], NULL as [DESCRIPTION], NULL as [FP_APPLY_OPERATION_ID], NULL as [FP_APPLY_ITEM_ID], NULL as [FP_APPLY_WIPQTY], NULL as [WIPHOLD_YN], NULL as [WIP_TYPE_CODE], NULL as [QTY2], NULL as [MODIFY_FP_APPLY_WIPQTY], NULL as [MODIFY_DESCRIPTION], NULL as [CAL_QTY], NULL as [FORMATION_REWORK_TYPE], NULL as [INSERT_ID], NULL as [INSERT_TIME], NULL as [UPDATE_ID], NULL as [UPDATE_TIME], NULL as [LOCATION], NULL as [RELEASE_DUE_DATE], NULL as [SHIP_AVAILABLE_DATE], NULL as [LONG_TERM_QTY], NULL as [MOVING_QTY], NULL as [CAPA_GRD_CODE], NULL as [VLTG_GRD_CODE], NULL as [RSST_GRD_CODE], NULL as [DEFECT_QTY]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_PUR', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_83B1CD1E
	    when 1 then __$operation
	    else
			case __$min_op_83B1CD1E 
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
		null as __$update_mask , [COMPANY_ID], [DIVISION_ID], [SCM_SITE_ID], [SITE_ID], [PLANT_ID], [FACTORY_ID], [STORAGE_ID], [CUTOFF_DATE], [SEQ], [STOCK_TYPE], [ITEM_ID], [LANE], [PRODUCTION_TYPE], [AVAILABLE_DATE], [REMAIN_LEAD_TIME], [HOLDING_DATE], [QTY], [QTY_UOM], [STOCK_STATUS], [OPERATION_ID], [LINE_ID], [OUTSOURCING_FLAG], [OUTSOURCING_FACTORY], [DESCRIPTION], [FP_APPLY_OPERATION_ID], [FP_APPLY_ITEM_ID], [FP_APPLY_WIPQTY], [WIPHOLD_YN], [WIP_TYPE_CODE], [QTY2], [MODIFY_FP_APPLY_WIPQTY], [MODIFY_DESCRIPTION], [CAL_QTY], [FORMATION_REWORK_TYPE], [INSERT_ID], [INSERT_TIME], [UPDATE_ID], [UPDATE_TIME], [LOCATION], [RELEASE_DUE_DATE], [SHIP_AVAILABLE_DATE], [LONG_TERM_QTY], [MOVING_QTY], [CAPA_GRD_CODE], [VLTG_GRD_CODE], [RSST_GRD_CODE], [DEFECT_QTY]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_83B1CD1E 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] c with (nolock)   
			where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FACTORY_ID] = t.[FACTORY_ID])  and (c.[STORAGE_ID] = t.[STORAGE_ID])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[SEQ] = t.[SEQ])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_83B1CD1E, __$count_83B1CD1E, t.[COMPANY_ID], t.[DIVISION_ID], t.[SCM_SITE_ID], t.[SITE_ID], t.[PLANT_ID], t.[FACTORY_ID], t.[STORAGE_ID], t.[CUTOFF_DATE], t.[SEQ], t.[STOCK_TYPE], t.[ITEM_ID], t.[LANE], t.[PRODUCTION_TYPE], t.[AVAILABLE_DATE], t.[REMAIN_LEAD_TIME], t.[HOLDING_DATE], t.[QTY], t.[QTY_UOM], t.[STOCK_STATUS], t.[OPERATION_ID], t.[LINE_ID], t.[OUTSOURCING_FLAG], t.[OUTSOURCING_FACTORY], t.[DESCRIPTION], t.[FP_APPLY_OPERATION_ID], t.[FP_APPLY_ITEM_ID], t.[FP_APPLY_WIPQTY], t.[WIPHOLD_YN], t.[WIP_TYPE_CODE], t.[QTY2], t.[MODIFY_FP_APPLY_WIPQTY], t.[MODIFY_DESCRIPTION], t.[CAL_QTY], t.[FORMATION_REWORK_TYPE], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[LOCATION], t.[RELEASE_DUE_DATE], t.[SHIP_AVAILABLE_DATE], t.[LONG_TERM_QTY], t.[MOVING_QTY], t.[CAPA_GRD_CODE], t.[VLTG_GRD_CODE], t.[RSST_GRD_CODE], t.[DEFECT_QTY] 
		from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] t with (nolock) inner join 
		(	select  r.[COMPANY_ID], r.[DIVISION_ID], r.[SCM_SITE_ID], r.[SITE_ID], r.[PLANT_ID], r.[FACTORY_ID], r.[STORAGE_ID], r.[CUTOFF_DATE], r.[SEQ],
		    count(*) as __$count_83B1CD1E 
			from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[COMPANY_ID], r.[DIVISION_ID], r.[SCM_SITE_ID], r.[SITE_ID], r.[PLANT_ID], r.[FACTORY_ID], r.[STORAGE_ID], r.[CUTOFF_DATE], r.[SEQ]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] c with (nolock) where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FACTORY_ID] = t.[FACTORY_ID])  and (c.[STORAGE_ID] = t.[STORAGE_ID])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[SEQ] = t.[SEQ])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[COMPANY_ID] = m.[COMPANY_ID]) and (t.[DIVISION_ID] = m.[DIVISION_ID])  and (t.[SCM_SITE_ID] = m.[SCM_SITE_ID])  and (t.[SITE_ID] = m.[SITE_ID])  and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[FACTORY_ID] = m.[FACTORY_ID])  and (t.[STORAGE_ID] = m.[STORAGE_ID])  and (t.[CUTOFF_DATE] = m.[CUTOFF_DATE])  and (t.[SEQ] = m.[SEQ])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_PUR', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] c with (nolock) 
							where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FACTORY_ID] = t.[FACTORY_ID])  and (c.[STORAGE_ID] = t.[STORAGE_ID])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[SEQ] = t.[SEQ])  )  
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
					[cdc].[dbo_SCM_DNM_STOCK_PUR_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[COMPANY_ID] = mo.[COMPANY_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[SCM_SITE_ID] = mo.[SCM_SITE_ID])  and (t.[SITE_ID] = mo.[SITE_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[FACTORY_ID] = mo.[FACTORY_ID])  and (t.[STORAGE_ID] = mo.[STORAGE_ID])  and (t.[CUTOFF_DATE] = mo.[CUTOFF_DATE])  and (t.[SEQ] = mo.[SEQ])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_83B1CD1E
	    when 1 then __$operation
	    else
			case __$min_op_83B1CD1E 
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
		case __$count_83B1CD1E
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_83B1CD1E 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [COMPANY_ID], [DIVISION_ID], [SCM_SITE_ID], [SITE_ID], [PLANT_ID], [FACTORY_ID], [STORAGE_ID], [CUTOFF_DATE], [SEQ], [STOCK_TYPE], [ITEM_ID], [LANE], [PRODUCTION_TYPE], [AVAILABLE_DATE], [REMAIN_LEAD_TIME], [HOLDING_DATE], [QTY], [QTY_UOM], [STOCK_STATUS], [OPERATION_ID], [LINE_ID], [OUTSOURCING_FLAG], [OUTSOURCING_FACTORY], [DESCRIPTION], [FP_APPLY_OPERATION_ID], [FP_APPLY_ITEM_ID], [FP_APPLY_WIPQTY], [WIPHOLD_YN], [WIP_TYPE_CODE], [QTY2], [MODIFY_FP_APPLY_WIPQTY], [MODIFY_DESCRIPTION], [CAL_QTY], [FORMATION_REWORK_TYPE], [INSERT_ID], [INSERT_TIME], [UPDATE_ID], [UPDATE_TIME], [LOCATION], [RELEASE_DUE_DATE], [SHIP_AVAILABLE_DATE], [LONG_TERM_QTY], [MOVING_QTY], [CAPA_GRD_CODE], [VLTG_GRD_CODE], [RSST_GRD_CODE], [DEFECT_QTY]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_83B1CD1E 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] c with (nolock)
			where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FACTORY_ID] = t.[FACTORY_ID])  and (c.[STORAGE_ID] = t.[STORAGE_ID])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[SEQ] = t.[SEQ])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_83B1CD1E, __$count_83B1CD1E, 
		m.__$update_mask , t.[COMPANY_ID], t.[DIVISION_ID], t.[SCM_SITE_ID], t.[SITE_ID], t.[PLANT_ID], t.[FACTORY_ID], t.[STORAGE_ID], t.[CUTOFF_DATE], t.[SEQ], t.[STOCK_TYPE], t.[ITEM_ID], t.[LANE], t.[PRODUCTION_TYPE], t.[AVAILABLE_DATE], t.[REMAIN_LEAD_TIME], t.[HOLDING_DATE], t.[QTY], t.[QTY_UOM], t.[STOCK_STATUS], t.[OPERATION_ID], t.[LINE_ID], t.[OUTSOURCING_FLAG], t.[OUTSOURCING_FACTORY], t.[DESCRIPTION], t.[FP_APPLY_OPERATION_ID], t.[FP_APPLY_ITEM_ID], t.[FP_APPLY_WIPQTY], t.[WIPHOLD_YN], t.[WIP_TYPE_CODE], t.[QTY2], t.[MODIFY_FP_APPLY_WIPQTY], t.[MODIFY_DESCRIPTION], t.[CAL_QTY], t.[FORMATION_REWORK_TYPE], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[LOCATION], t.[RELEASE_DUE_DATE], t.[SHIP_AVAILABLE_DATE], t.[LONG_TERM_QTY], t.[MOVING_QTY], t.[CAPA_GRD_CODE], t.[VLTG_GRD_CODE], t.[RSST_GRD_CODE], t.[DEFECT_QTY]
		from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] t with (nolock) inner join 
		(	select  r.[COMPANY_ID], r.[DIVISION_ID], r.[SCM_SITE_ID], r.[SITE_ID], r.[PLANT_ID], r.[FACTORY_ID], r.[STORAGE_ID], r.[CUTOFF_DATE], r.[SEQ],
		    count(*) as __$count_83B1CD1E, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[COMPANY_ID], r.[DIVISION_ID], r.[SCM_SITE_ID], r.[SITE_ID], r.[PLANT_ID], r.[FACTORY_ID], r.[STORAGE_ID], r.[CUTOFF_DATE], r.[SEQ]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] c with (nolock) where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FACTORY_ID] = t.[FACTORY_ID])  and (c.[STORAGE_ID] = t.[STORAGE_ID])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[SEQ] = t.[SEQ])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[COMPANY_ID] = m.[COMPANY_ID]) and (t.[DIVISION_ID] = m.[DIVISION_ID])  and (t.[SCM_SITE_ID] = m.[SCM_SITE_ID])  and (t.[SITE_ID] = m.[SITE_ID])  and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[FACTORY_ID] = m.[FACTORY_ID])  and (t.[STORAGE_ID] = m.[STORAGE_ID])  and (t.[CUTOFF_DATE] = m.[CUTOFF_DATE])  and (t.[SEQ] = m.[SEQ])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_PUR', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] c with (nolock)
							where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FACTORY_ID] = t.[FACTORY_ID])  and (c.[STORAGE_ID] = t.[STORAGE_ID])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[SEQ] = t.[SEQ])  )  
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
					[cdc].[dbo_SCM_DNM_STOCK_PUR_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[COMPANY_ID] = mo.[COMPANY_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[SCM_SITE_ID] = mo.[SCM_SITE_ID])  and (t.[SITE_ID] = mo.[SITE_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[FACTORY_ID] = mo.[FACTORY_ID])  and (t.[STORAGE_ID] = mo.[STORAGE_ID])  and (t.[CUTOFF_DATE] = mo.[CUTOFF_DATE])  and (t.[SEQ] = mo.[SEQ])  ) 
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
		null as __$update_mask , t.[COMPANY_ID], t.[DIVISION_ID], t.[SCM_SITE_ID], t.[SITE_ID], t.[PLANT_ID], t.[FACTORY_ID], t.[STORAGE_ID], t.[CUTOFF_DATE], t.[SEQ], t.[STOCK_TYPE], t.[ITEM_ID], t.[LANE], t.[PRODUCTION_TYPE], t.[AVAILABLE_DATE], t.[REMAIN_LEAD_TIME], t.[HOLDING_DATE], t.[QTY], t.[QTY_UOM], t.[STOCK_STATUS], t.[OPERATION_ID], t.[LINE_ID], t.[OUTSOURCING_FLAG], t.[OUTSOURCING_FACTORY], t.[DESCRIPTION], t.[FP_APPLY_OPERATION_ID], t.[FP_APPLY_ITEM_ID], t.[FP_APPLY_WIPQTY], t.[WIPHOLD_YN], t.[WIP_TYPE_CODE], t.[QTY2], t.[MODIFY_FP_APPLY_WIPQTY], t.[MODIFY_DESCRIPTION], t.[CAL_QTY], t.[FORMATION_REWORK_TYPE], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[LOCATION], t.[RELEASE_DUE_DATE], t.[SHIP_AVAILABLE_DATE], t.[LONG_TERM_QTY], t.[MOVING_QTY], t.[CAPA_GRD_CODE], t.[VLTG_GRD_CODE], t.[RSST_GRD_CODE], t.[DEFECT_QTY]
		from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_PUR', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] c with (nolock) where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FACTORY_ID] = t.[FACTORY_ID])  and (c.[STORAGE_ID] = t.[STORAGE_ID])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[SEQ] = t.[SEQ])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] c with (nolock)
							where  ( (c.[COMPANY_ID] = t.[COMPANY_ID]) and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[SCM_SITE_ID] = t.[SCM_SITE_ID])  and (c.[SITE_ID] = t.[SITE_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FACTORY_ID] = t.[FACTORY_ID])  and (c.[STORAGE_ID] = t.[STORAGE_ID])  and (c.[CUTOFF_DATE] = t.[CUTOFF_DATE])  and (c.[SEQ] = t.[SEQ])  )  
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
					[cdc].[dbo_SCM_DNM_STOCK_PUR_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[COMPANY_ID] = mo.[COMPANY_ID]) and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[SCM_SITE_ID] = mo.[SCM_SITE_ID])  and (t.[SITE_ID] = mo.[SITE_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[FACTORY_ID] = mo.[FACTORY_ID])  and (t.[STORAGE_ID] = mo.[STORAGE_ID])  and (t.[CUTOFF_DATE] = mo.[CUTOFF_DATE])  and (t.[SEQ] = mo.[SEQ])  ) 
				group by
					mo.__$seqval
			)
	 