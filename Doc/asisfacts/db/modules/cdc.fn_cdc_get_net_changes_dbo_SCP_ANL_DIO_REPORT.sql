
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCP_ANL_DIO_REPORT]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [PLAN_START_YYYYMMDD], NULL as [PLAN_TYPE], NULL as [SEQ], NULL as [ITEM_ID], NULL as [NICK_NAME], NULL as [PLANT_ID], NULL as [FROM_SITE], NULL as [CUTOFF_FLAG], NULL as [FROM_SITE_DESCRIPTION], NULL as [OPERATION_GROUP], NULL as [TO_SITE], NULL as [CELL_PLANT_SITE], NULL as [TO_BOH_QTY], NULL as [BOD_ID], NULL as [TRANSPORT_MODE_LINE], NULL as [MEASURE], NULL as [SHIP_PLAN_QTY], NULL as [END_CUSTOMER], NULL as [PRODUCTION_TYPE], NULL as [EXTRA_SPEC], NULL as [CELL_ITEM_ID], NULL as [BIZ_TYPE], NULL as [INCOTERMS], NULL as [CELL_AGING_LT], NULL as [CELL_EOL_SHIPPING_LOT], NULL as [PACK_INCOMMING], NULL as [PACK_OPERATION_LT], NULL as [SHIPMENT_CELL_INSPECTION_LOAD], NULL as [SHIPMENT_CELL_INSPECTION_WAITING], NULL as [SHIPMENT_PACK_INSPECTION_LOAD], NULL as [SHIPMENT_PACK_INSPECTION_WAITING], NULL as [DNI_CELL_DEPARTURE_DAYS], NULL as [DNI_CELL_DEPARTURE_INLAND], NULL as [DNI_CELL_WAITING_FOR_SHIPPING], NULL as [DNI_CELL_VOYAGE], NULL as [DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE], NULL as [DNI_CELL_ARRIVAL_INLAND], NULL as [DNI_PACK_DEPARTURE_DAYS], NULL as [DNI_PACK_DEPARTURE_INLAND], NULL as [DNI_PACK_WAITING_FOR_SHIPPING], NULL as [DNI_PACK_VOYAGE], NULL as [DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE], NULL as [DNI_PACK_ARRIVAL_INLAND], NULL as [PRE_INSPECTION_CELL], NULL as [PRE_INSPECTION_PACK], NULL as [VMI_CELL], NULL as [VMI_PACK], NULL as [FOREIGN_CORP], NULL as [RACK_BIZ], NULL as [DEPARTURE_INTRANSIT_VMI], NULL as [SAFETY_STOCK_CELL], NULL as [SAFETY_STOCK_PACK], NULL as [OTHER_STOCK_CELL], NULL as [OTHER_STOCK_PACK], NULL as [PRODUCTION_CYCLE_CELL], NULL as [PRODUCTION_CYCLE_PACK], NULL as [STANDARD_DIO], NULL as [ASSEMBLY_QTY], NULL as [ASSEMBLY_TYPE_RATIO], NULL as [ASSEMBLY_TOTAL_RATIO], NULL as [WEIGHT_DIO], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [SHIP_PLAN_WEIGHT], NULL as [VER], NULL as [SHIPMENT_CELL_SUM], NULL as [SHIPMENT_PACK_SUM], NULL as [SHIPMENT_SUM]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_DIO_REPORT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_A1A08862
	    when 1 then __$operation
	    else
			case __$min_op_A1A08862 
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
		null as __$update_mask , [DIVISION_ID], [PLAN_START_YYYYMMDD], [PLAN_TYPE], [SEQ], [ITEM_ID], [NICK_NAME], [PLANT_ID], [FROM_SITE], [CUTOFF_FLAG], [FROM_SITE_DESCRIPTION], [OPERATION_GROUP], [TO_SITE], [CELL_PLANT_SITE], [TO_BOH_QTY], [BOD_ID], [TRANSPORT_MODE_LINE], [MEASURE], [SHIP_PLAN_QTY], [END_CUSTOMER], [PRODUCTION_TYPE], [EXTRA_SPEC], [CELL_ITEM_ID], [BIZ_TYPE], [INCOTERMS], [CELL_AGING_LT], [CELL_EOL_SHIPPING_LOT], [PACK_INCOMMING], [PACK_OPERATION_LT], [SHIPMENT_CELL_INSPECTION_LOAD], [SHIPMENT_CELL_INSPECTION_WAITING], [SHIPMENT_PACK_INSPECTION_LOAD], [SHIPMENT_PACK_INSPECTION_WAITING], [DNI_CELL_DEPARTURE_DAYS], [DNI_CELL_DEPARTURE_INLAND], [DNI_CELL_WAITING_FOR_SHIPPING], [DNI_CELL_VOYAGE], [DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE], [DNI_CELL_ARRIVAL_INLAND], [DNI_PACK_DEPARTURE_DAYS], [DNI_PACK_DEPARTURE_INLAND], [DNI_PACK_WAITING_FOR_SHIPPING], [DNI_PACK_VOYAGE], [DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE], [DNI_PACK_ARRIVAL_INLAND], [PRE_INSPECTION_CELL], [PRE_INSPECTION_PACK], [VMI_CELL], [VMI_PACK], [FOREIGN_CORP], [RACK_BIZ], [DEPARTURE_INTRANSIT_VMI], [SAFETY_STOCK_CELL], [SAFETY_STOCK_PACK], [OTHER_STOCK_CELL], [OTHER_STOCK_PACK], [PRODUCTION_CYCLE_CELL], [PRODUCTION_CYCLE_PACK], [STANDARD_DIO], [ASSEMBLY_QTY], [ASSEMBLY_TYPE_RATIO], [ASSEMBLY_TOTAL_RATIO], [WEIGHT_DIO], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [SHIP_PLAN_WEIGHT], [VER], [SHIPMENT_CELL_SUM], [SHIPMENT_PACK_SUM], [SHIPMENT_SUM]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_A1A08862 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCP_ANL_DIO_REPORT_CT] c with (nolock)   
			where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLAN_START_YYYYMMDD] = t.[PLAN_START_YYYYMMDD])  and (c.[PLAN_TYPE] = t.[PLAN_TYPE])  and (c.[SEQ] = t.[SEQ])  and (c.[VER] = t.[VER])  and (c.[NICK_NAME] = t.[NICK_NAME])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[END_CUSTOMER] = t.[END_CUSTOMER])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[CELL_ITEM_ID] = t.[CELL_ITEM_ID])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_A1A08862, __$count_A1A08862, t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[ITEM_ID], t.[NICK_NAME], t.[PLANT_ID], t.[FROM_SITE], t.[CUTOFF_FLAG], t.[FROM_SITE_DESCRIPTION], t.[OPERATION_GROUP], t.[TO_SITE], t.[CELL_PLANT_SITE], t.[TO_BOH_QTY], t.[BOD_ID], t.[TRANSPORT_MODE_LINE], t.[MEASURE], t.[SHIP_PLAN_QTY], t.[END_CUSTOMER], t.[PRODUCTION_TYPE], t.[EXTRA_SPEC], t.[CELL_ITEM_ID], t.[BIZ_TYPE], t.[INCOTERMS], t.[CELL_AGING_LT], t.[CELL_EOL_SHIPPING_LOT], t.[PACK_INCOMMING], t.[PACK_OPERATION_LT], t.[SHIPMENT_CELL_INSPECTION_LOAD], t.[SHIPMENT_CELL_INSPECTION_WAITING], t.[SHIPMENT_PACK_INSPECTION_LOAD], t.[SHIPMENT_PACK_INSPECTION_WAITING], t.[DNI_CELL_DEPARTURE_DAYS], t.[DNI_CELL_DEPARTURE_INLAND], t.[DNI_CELL_WAITING_FOR_SHIPPING], t.[DNI_CELL_VOYAGE], t.[DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE], t.[DNI_CELL_ARRIVAL_INLAND], t.[DNI_PACK_DEPARTURE_DAYS], t.[DNI_PACK_DEPARTURE_INLAND], t.[DNI_PACK_WAITING_FOR_SHIPPING], t.[DNI_PACK_VOYAGE], t.[DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE], t.[DNI_PACK_ARRIVAL_INLAND], t.[PRE_INSPECTION_CELL], t.[PRE_INSPECTION_PACK], t.[VMI_CELL], t.[VMI_PACK], t.[FOREIGN_CORP], t.[RACK_BIZ], t.[DEPARTURE_INTRANSIT_VMI], t.[SAFETY_STOCK_CELL], t.[SAFETY_STOCK_PACK], t.[OTHER_STOCK_CELL], t.[OTHER_STOCK_PACK], t.[PRODUCTION_CYCLE_CELL], t.[PRODUCTION_CYCLE_PACK], t.[STANDARD_DIO], t.[ASSEMBLY_QTY], t.[ASSEMBLY_TYPE_RATIO], t.[ASSEMBLY_TOTAL_RATIO], t.[WEIGHT_DIO], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[SHIP_PLAN_WEIGHT], t.[VER], t.[SHIPMENT_CELL_SUM], t.[SHIPMENT_PACK_SUM], t.[SHIPMENT_SUM] 
		from [cdc].[dbo_SCP_ANL_DIO_REPORT_CT] t with (nolock) inner join 
		(	select  r.[DIVISION_ID], r.[PLAN_START_YYYYMMDD], r.[PLAN_TYPE], r.[SEQ], r.[VER], r.[NICK_NAME], r.[PLANT_ID], r.[FROM_SITE], r.[TO_SITE], r.[END_CUSTOMER], r.[ITEM_ID], r.[CELL_ITEM_ID],
		    count(*) as __$count_A1A08862 
			from [cdc].[dbo_SCP_ANL_DIO_REPORT_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[DIVISION_ID], r.[PLAN_START_YYYYMMDD], r.[PLAN_TYPE], r.[SEQ], r.[VER], r.[NICK_NAME], r.[PLANT_ID], r.[FROM_SITE], r.[TO_SITE], r.[END_CUSTOMER], r.[ITEM_ID], r.[CELL_ITEM_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_ANL_DIO_REPORT_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLAN_START_YYYYMMDD] = t.[PLAN_START_YYYYMMDD])  and (c.[PLAN_TYPE] = t.[PLAN_TYPE])  and (c.[SEQ] = t.[SEQ])  and (c.[VER] = t.[VER])  and (c.[NICK_NAME] = t.[NICK_NAME])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[END_CUSTOMER] = t.[END_CUSTOMER])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[CELL_ITEM_ID] = t.[CELL_ITEM_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[DIVISION_ID] = m.[DIVISION_ID]) and (t.[PLAN_START_YYYYMMDD] = m.[PLAN_START_YYYYMMDD])  and (t.[PLAN_TYPE] = m.[PLAN_TYPE])  and (t.[SEQ] = m.[SEQ])  and (t.[VER] = m.[VER])  and (t.[NICK_NAME] = m.[NICK_NAME])  and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[FROM_SITE] = m.[FROM_SITE])  and (t.[TO_SITE] = m.[TO_SITE])  and (t.[END_CUSTOMER] = m.[END_CUSTOMER])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[CELL_ITEM_ID] = m.[CELL_ITEM_ID])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_DIO_REPORT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_ANL_DIO_REPORT_CT] c with (nolock) 
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLAN_START_YYYYMMDD] = t.[PLAN_START_YYYYMMDD])  and (c.[PLAN_TYPE] = t.[PLAN_TYPE])  and (c.[SEQ] = t.[SEQ])  and (c.[VER] = t.[VER])  and (c.[NICK_NAME] = t.[NICK_NAME])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[END_CUSTOMER] = t.[END_CUSTOMER])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[CELL_ITEM_ID] = t.[CELL_ITEM_ID])  )  
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
					[cdc].[dbo_SCP_ANL_DIO_REPORT_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[PLAN_START_YYYYMMDD] = mo.[PLAN_START_YYYYMMDD])  and (t.[PLAN_TYPE] = mo.[PLAN_TYPE])  and (t.[SEQ] = mo.[SEQ])  and (t.[VER] = mo.[VER])  and (t.[NICK_NAME] = mo.[NICK_NAME])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[FROM_SITE] = mo.[FROM_SITE])  and (t.[TO_SITE] = mo.[TO_SITE])  and (t.[END_CUSTOMER] = mo.[END_CUSTOMER])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[CELL_ITEM_ID] = mo.[CELL_ITEM_ID])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_A1A08862
	    when 1 then __$operation
	    else
			case __$min_op_A1A08862 
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
		case __$count_A1A08862
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_A1A08862 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [DIVISION_ID], [PLAN_START_YYYYMMDD], [PLAN_TYPE], [SEQ], [ITEM_ID], [NICK_NAME], [PLANT_ID], [FROM_SITE], [CUTOFF_FLAG], [FROM_SITE_DESCRIPTION], [OPERATION_GROUP], [TO_SITE], [CELL_PLANT_SITE], [TO_BOH_QTY], [BOD_ID], [TRANSPORT_MODE_LINE], [MEASURE], [SHIP_PLAN_QTY], [END_CUSTOMER], [PRODUCTION_TYPE], [EXTRA_SPEC], [CELL_ITEM_ID], [BIZ_TYPE], [INCOTERMS], [CELL_AGING_LT], [CELL_EOL_SHIPPING_LOT], [PACK_INCOMMING], [PACK_OPERATION_LT], [SHIPMENT_CELL_INSPECTION_LOAD], [SHIPMENT_CELL_INSPECTION_WAITING], [SHIPMENT_PACK_INSPECTION_LOAD], [SHIPMENT_PACK_INSPECTION_WAITING], [DNI_CELL_DEPARTURE_DAYS], [DNI_CELL_DEPARTURE_INLAND], [DNI_CELL_WAITING_FOR_SHIPPING], [DNI_CELL_VOYAGE], [DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE], [DNI_CELL_ARRIVAL_INLAND], [DNI_PACK_DEPARTURE_DAYS], [DNI_PACK_DEPARTURE_INLAND], [DNI_PACK_WAITING_FOR_SHIPPING], [DNI_PACK_VOYAGE], [DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE], [DNI_PACK_ARRIVAL_INLAND], [PRE_INSPECTION_CELL], [PRE_INSPECTION_PACK], [VMI_CELL], [VMI_PACK], [FOREIGN_CORP], [RACK_BIZ], [DEPARTURE_INTRANSIT_VMI], [SAFETY_STOCK_CELL], [SAFETY_STOCK_PACK], [OTHER_STOCK_CELL], [OTHER_STOCK_PACK], [PRODUCTION_CYCLE_CELL], [PRODUCTION_CYCLE_PACK], [STANDARD_DIO], [ASSEMBLY_QTY], [ASSEMBLY_TYPE_RATIO], [ASSEMBLY_TOTAL_RATIO], [WEIGHT_DIO], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [SHIP_PLAN_WEIGHT], [VER], [SHIPMENT_CELL_SUM], [SHIPMENT_PACK_SUM], [SHIPMENT_SUM]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_A1A08862 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCP_ANL_DIO_REPORT_CT] c with (nolock)
			where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLAN_START_YYYYMMDD] = t.[PLAN_START_YYYYMMDD])  and (c.[PLAN_TYPE] = t.[PLAN_TYPE])  and (c.[SEQ] = t.[SEQ])  and (c.[VER] = t.[VER])  and (c.[NICK_NAME] = t.[NICK_NAME])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[END_CUSTOMER] = t.[END_CUSTOMER])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[CELL_ITEM_ID] = t.[CELL_ITEM_ID])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_A1A08862, __$count_A1A08862, 
		m.__$update_mask , t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[ITEM_ID], t.[NICK_NAME], t.[PLANT_ID], t.[FROM_SITE], t.[CUTOFF_FLAG], t.[FROM_SITE_DESCRIPTION], t.[OPERATION_GROUP], t.[TO_SITE], t.[CELL_PLANT_SITE], t.[TO_BOH_QTY], t.[BOD_ID], t.[TRANSPORT_MODE_LINE], t.[MEASURE], t.[SHIP_PLAN_QTY], t.[END_CUSTOMER], t.[PRODUCTION_TYPE], t.[EXTRA_SPEC], t.[CELL_ITEM_ID], t.[BIZ_TYPE], t.[INCOTERMS], t.[CELL_AGING_LT], t.[CELL_EOL_SHIPPING_LOT], t.[PACK_INCOMMING], t.[PACK_OPERATION_LT], t.[SHIPMENT_CELL_INSPECTION_LOAD], t.[SHIPMENT_CELL_INSPECTION_WAITING], t.[SHIPMENT_PACK_INSPECTION_LOAD], t.[SHIPMENT_PACK_INSPECTION_WAITING], t.[DNI_CELL_DEPARTURE_DAYS], t.[DNI_CELL_DEPARTURE_INLAND], t.[DNI_CELL_WAITING_FOR_SHIPPING], t.[DNI_CELL_VOYAGE], t.[DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE], t.[DNI_CELL_ARRIVAL_INLAND], t.[DNI_PACK_DEPARTURE_DAYS], t.[DNI_PACK_DEPARTURE_INLAND], t.[DNI_PACK_WAITING_FOR_SHIPPING], t.[DNI_PACK_VOYAGE], t.[DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE], t.[DNI_PACK_ARRIVAL_INLAND], t.[PRE_INSPECTION_CELL], t.[PRE_INSPECTION_PACK], t.[VMI_CELL], t.[VMI_PACK], t.[FOREIGN_CORP], t.[RACK_BIZ], t.[DEPARTURE_INTRANSIT_VMI], t.[SAFETY_STOCK_CELL], t.[SAFETY_STOCK_PACK], t.[OTHER_STOCK_CELL], t.[OTHER_STOCK_PACK], t.[PRODUCTION_CYCLE_CELL], t.[PRODUCTION_CYCLE_PACK], t.[STANDARD_DIO], t.[ASSEMBLY_QTY], t.[ASSEMBLY_TYPE_RATIO], t.[ASSEMBLY_TOTAL_RATIO], t.[WEIGHT_DIO], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[SHIP_PLAN_WEIGHT], t.[VER], t.[SHIPMENT_CELL_SUM], t.[SHIPMENT_PACK_SUM], t.[SHIPMENT_SUM]
		from [cdc].[dbo_SCP_ANL_DIO_REPORT_CT] t with (nolock) inner join 
		(	select  r.[DIVISION_ID], r.[PLAN_START_YYYYMMDD], r.[PLAN_TYPE], r.[SEQ], r.[VER], r.[NICK_NAME], r.[PLANT_ID], r.[FROM_SITE], r.[TO_SITE], r.[END_CUSTOMER], r.[ITEM_ID], r.[CELL_ITEM_ID],
		    count(*) as __$count_A1A08862, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCP_ANL_DIO_REPORT_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[DIVISION_ID], r.[PLAN_START_YYYYMMDD], r.[PLAN_TYPE], r.[SEQ], r.[VER], r.[NICK_NAME], r.[PLANT_ID], r.[FROM_SITE], r.[TO_SITE], r.[END_CUSTOMER], r.[ITEM_ID], r.[CELL_ITEM_ID]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_ANL_DIO_REPORT_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLAN_START_YYYYMMDD] = t.[PLAN_START_YYYYMMDD])  and (c.[PLAN_TYPE] = t.[PLAN_TYPE])  and (c.[SEQ] = t.[SEQ])  and (c.[VER] = t.[VER])  and (c.[NICK_NAME] = t.[NICK_NAME])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[END_CUSTOMER] = t.[END_CUSTOMER])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[CELL_ITEM_ID] = t.[CELL_ITEM_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[DIVISION_ID] = m.[DIVISION_ID]) and (t.[PLAN_START_YYYYMMDD] = m.[PLAN_START_YYYYMMDD])  and (t.[PLAN_TYPE] = m.[PLAN_TYPE])  and (t.[SEQ] = m.[SEQ])  and (t.[VER] = m.[VER])  and (t.[NICK_NAME] = m.[NICK_NAME])  and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[FROM_SITE] = m.[FROM_SITE])  and (t.[TO_SITE] = m.[TO_SITE])  and (t.[END_CUSTOMER] = m.[END_CUSTOMER])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[CELL_ITEM_ID] = m.[CELL_ITEM_ID])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_DIO_REPORT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_ANL_DIO_REPORT_CT] c with (nolock)
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLAN_START_YYYYMMDD] = t.[PLAN_START_YYYYMMDD])  and (c.[PLAN_TYPE] = t.[PLAN_TYPE])  and (c.[SEQ] = t.[SEQ])  and (c.[VER] = t.[VER])  and (c.[NICK_NAME] = t.[NICK_NAME])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[END_CUSTOMER] = t.[END_CUSTOMER])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[CELL_ITEM_ID] = t.[CELL_ITEM_ID])  )  
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
					[cdc].[dbo_SCP_ANL_DIO_REPORT_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[PLAN_START_YYYYMMDD] = mo.[PLAN_START_YYYYMMDD])  and (t.[PLAN_TYPE] = mo.[PLAN_TYPE])  and (t.[SEQ] = mo.[SEQ])  and (t.[VER] = mo.[VER])  and (t.[NICK_NAME] = mo.[NICK_NAME])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[FROM_SITE] = mo.[FROM_SITE])  and (t.[TO_SITE] = mo.[TO_SITE])  and (t.[END_CUSTOMER] = mo.[END_CUSTOMER])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[CELL_ITEM_ID] = mo.[CELL_ITEM_ID])  ) 
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
		null as __$update_mask , t.[DIVISION_ID], t.[PLAN_START_YYYYMMDD], t.[PLAN_TYPE], t.[SEQ], t.[ITEM_ID], t.[NICK_NAME], t.[PLANT_ID], t.[FROM_SITE], t.[CUTOFF_FLAG], t.[FROM_SITE_DESCRIPTION], t.[OPERATION_GROUP], t.[TO_SITE], t.[CELL_PLANT_SITE], t.[TO_BOH_QTY], t.[BOD_ID], t.[TRANSPORT_MODE_LINE], t.[MEASURE], t.[SHIP_PLAN_QTY], t.[END_CUSTOMER], t.[PRODUCTION_TYPE], t.[EXTRA_SPEC], t.[CELL_ITEM_ID], t.[BIZ_TYPE], t.[INCOTERMS], t.[CELL_AGING_LT], t.[CELL_EOL_SHIPPING_LOT], t.[PACK_INCOMMING], t.[PACK_OPERATION_LT], t.[SHIPMENT_CELL_INSPECTION_LOAD], t.[SHIPMENT_CELL_INSPECTION_WAITING], t.[SHIPMENT_PACK_INSPECTION_LOAD], t.[SHIPMENT_PACK_INSPECTION_WAITING], t.[DNI_CELL_DEPARTURE_DAYS], t.[DNI_CELL_DEPARTURE_INLAND], t.[DNI_CELL_WAITING_FOR_SHIPPING], t.[DNI_CELL_VOYAGE], t.[DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE], t.[DNI_CELL_ARRIVAL_INLAND], t.[DNI_PACK_DEPARTURE_DAYS], t.[DNI_PACK_DEPARTURE_INLAND], t.[DNI_PACK_WAITING_FOR_SHIPPING], t.[DNI_PACK_VOYAGE], t.[DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE], t.[DNI_PACK_ARRIVAL_INLAND], t.[PRE_INSPECTION_CELL], t.[PRE_INSPECTION_PACK], t.[VMI_CELL], t.[VMI_PACK], t.[FOREIGN_CORP], t.[RACK_BIZ], t.[DEPARTURE_INTRANSIT_VMI], t.[SAFETY_STOCK_CELL], t.[SAFETY_STOCK_PACK], t.[OTHER_STOCK_CELL], t.[OTHER_STOCK_PACK], t.[PRODUCTION_CYCLE_CELL], t.[PRODUCTION_CYCLE_PACK], t.[STANDARD_DIO], t.[ASSEMBLY_QTY], t.[ASSEMBLY_TYPE_RATIO], t.[ASSEMBLY_TOTAL_RATIO], t.[WEIGHT_DIO], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[SHIP_PLAN_WEIGHT], t.[VER], t.[SHIPMENT_CELL_SUM], t.[SHIPMENT_PACK_SUM], t.[SHIPMENT_SUM]
		from [cdc].[dbo_SCP_ANL_DIO_REPORT_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_DIO_REPORT', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCP_ANL_DIO_REPORT_CT] c with (nolock) where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLAN_START_YYYYMMDD] = t.[PLAN_START_YYYYMMDD])  and (c.[PLAN_TYPE] = t.[PLAN_TYPE])  and (c.[SEQ] = t.[SEQ])  and (c.[VER] = t.[VER])  and (c.[NICK_NAME] = t.[NICK_NAME])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[END_CUSTOMER] = t.[END_CUSTOMER])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[CELL_ITEM_ID] = t.[CELL_ITEM_ID])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCP_ANL_DIO_REPORT_CT] c with (nolock)
							where  ( (c.[DIVISION_ID] = t.[DIVISION_ID]) and (c.[PLAN_START_YYYYMMDD] = t.[PLAN_START_YYYYMMDD])  and (c.[PLAN_TYPE] = t.[PLAN_TYPE])  and (c.[SEQ] = t.[SEQ])  and (c.[VER] = t.[VER])  and (c.[NICK_NAME] = t.[NICK_NAME])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[FROM_SITE] = t.[FROM_SITE])  and (c.[TO_SITE] = t.[TO_SITE])  and (c.[END_CUSTOMER] = t.[END_CUSTOMER])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[CELL_ITEM_ID] = t.[CELL_ITEM_ID])  )  
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
					[cdc].[dbo_SCP_ANL_DIO_REPORT_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[DIVISION_ID] = mo.[DIVISION_ID]) and (t.[PLAN_START_YYYYMMDD] = mo.[PLAN_START_YYYYMMDD])  and (t.[PLAN_TYPE] = mo.[PLAN_TYPE])  and (t.[SEQ] = mo.[SEQ])  and (t.[VER] = mo.[VER])  and (t.[NICK_NAME] = mo.[NICK_NAME])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[FROM_SITE] = mo.[FROM_SITE])  and (t.[TO_SITE] = mo.[TO_SITE])  and (t.[END_CUSTOMER] = mo.[END_CUSTOMER])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[CELL_ITEM_ID] = mo.[CELL_ITEM_ID])  ) 
				group by
					mo.__$seqval
			)
	 