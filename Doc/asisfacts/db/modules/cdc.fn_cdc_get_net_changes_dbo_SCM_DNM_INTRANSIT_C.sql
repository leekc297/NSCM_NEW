
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCM_DNM_INTRANSIT_C]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [RESULT_DATE], NULL as [RESULT_TYPE], NULL as [COMPANY_ID], NULL as [DIVISION_ID], NULL as [PLANT_ID], NULL as [SHIPMENT_NO], NULL as [PROJECT_CODE], NULL as [ITEM_ID], NULL as [PLANT_ISSUE_DATE], NULL as [INCOTERMS], NULL as [FCST_TYPE], NULL as [DOM_EXP], NULL as [CUSTOMER_CODE], NULL as [SHIPTO_CODE], NULL as [FROM_SCM_SITE_ID], NULL as [FROM_SITE_ITEM_MAPPING_YN], NULL as [TO_SCM_SITE_ID], NULL as [TO_SITE_ITEM_MAPPING_YN], NULL as [DELIVERY_QTY], NULL as [UOM], NULL as [TRANSPORT_MODE], NULL as [SHIPPING_DATE], NULL as [POL], NULL as [POL_ATD_DATE], NULL as [POD], NULL as [POD_ETA_DATE], NULL as [POD_ATA_DATE], NULL as [POD_ETD_DATE], NULL as [POD_ATD_DATE], NULL as [F_DEST_PORT_CODE], NULL as [F_DEST_ETA_DATE], NULL as [F_DEST_ATA_DATE], NULL as [VALID_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [FINAL_SOLDTO_CODE], NULL as [FINAL_SOLDTO_NAME], NULL as [FINAL_INCOTERMS]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_INTRANSIT_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_A44428BA
	    when 1 then __$operation
	    else
			case __$min_op_A44428BA 
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
		null as __$update_mask , [RESULT_DATE], [RESULT_TYPE], [COMPANY_ID], [DIVISION_ID], [PLANT_ID], [SHIPMENT_NO], [PROJECT_CODE], [ITEM_ID], [PLANT_ISSUE_DATE], [INCOTERMS], [FCST_TYPE], [DOM_EXP], [CUSTOMER_CODE], [SHIPTO_CODE], [FROM_SCM_SITE_ID], [FROM_SITE_ITEM_MAPPING_YN], [TO_SCM_SITE_ID], [TO_SITE_ITEM_MAPPING_YN], [DELIVERY_QTY], [UOM], [TRANSPORT_MODE], [SHIPPING_DATE], [POL], [POL_ATD_DATE], [POD], [POD_ETA_DATE], [POD_ATA_DATE], [POD_ETD_DATE], [POD_ATD_DATE], [F_DEST_PORT_CODE], [F_DEST_ETA_DATE], [F_DEST_ATA_DATE], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [FINAL_SOLDTO_CODE], [FINAL_SOLDTO_NAME], [FINAL_INCOTERMS]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_A44428BA 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] c with (nolock)   
			where  ( (c.[RESULT_DATE] = t.[RESULT_DATE]) and (c.[RESULT_TYPE] = t.[RESULT_TYPE])  and (c.[COMPANY_ID] = t.[COMPANY_ID])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[SHIPMENT_NO] = t.[SHIPMENT_NO])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[PLANT_ISSUE_DATE] = t.[PLANT_ISSUE_DATE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_A44428BA, __$count_A44428BA, t.[RESULT_DATE], t.[RESULT_TYPE], t.[COMPANY_ID], t.[DIVISION_ID], t.[PLANT_ID], t.[SHIPMENT_NO], t.[PROJECT_CODE], t.[ITEM_ID], t.[PLANT_ISSUE_DATE], t.[INCOTERMS], t.[FCST_TYPE], t.[DOM_EXP], t.[CUSTOMER_CODE], t.[SHIPTO_CODE], t.[FROM_SCM_SITE_ID], t.[FROM_SITE_ITEM_MAPPING_YN], t.[TO_SCM_SITE_ID], t.[TO_SITE_ITEM_MAPPING_YN], t.[DELIVERY_QTY], t.[UOM], t.[TRANSPORT_MODE], t.[SHIPPING_DATE], t.[POL], t.[POL_ATD_DATE], t.[POD], t.[POD_ETA_DATE], t.[POD_ATA_DATE], t.[POD_ETD_DATE], t.[POD_ATD_DATE], t.[F_DEST_PORT_CODE], t.[F_DEST_ETA_DATE], t.[F_DEST_ATA_DATE], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[FINAL_SOLDTO_CODE], t.[FINAL_SOLDTO_NAME], t.[FINAL_INCOTERMS] 
		from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] t with (nolock) inner join 
		(	select  r.[RESULT_DATE], r.[RESULT_TYPE], r.[COMPANY_ID], r.[DIVISION_ID], r.[PLANT_ID], r.[SHIPMENT_NO], r.[PROJECT_CODE], r.[ITEM_ID], r.[PLANT_ISSUE_DATE], r.[INCOTERMS], r.[FCST_TYPE],
		    count(*) as __$count_A44428BA 
			from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[RESULT_DATE], r.[RESULT_TYPE], r.[COMPANY_ID], r.[DIVISION_ID], r.[PLANT_ID], r.[SHIPMENT_NO], r.[PROJECT_CODE], r.[ITEM_ID], r.[PLANT_ISSUE_DATE], r.[INCOTERMS], r.[FCST_TYPE]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] c with (nolock) where  ( (c.[RESULT_DATE] = t.[RESULT_DATE]) and (c.[RESULT_TYPE] = t.[RESULT_TYPE])  and (c.[COMPANY_ID] = t.[COMPANY_ID])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[SHIPMENT_NO] = t.[SHIPMENT_NO])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[PLANT_ISSUE_DATE] = t.[PLANT_ISSUE_DATE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[RESULT_DATE] = m.[RESULT_DATE]) and (t.[RESULT_TYPE] = m.[RESULT_TYPE])  and (t.[COMPANY_ID] = m.[COMPANY_ID])  and (t.[DIVISION_ID] = m.[DIVISION_ID])  and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[SHIPMENT_NO] = m.[SHIPMENT_NO])  and (t.[PROJECT_CODE] = m.[PROJECT_CODE])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[PLANT_ISSUE_DATE] = m.[PLANT_ISSUE_DATE])  and (t.[INCOTERMS] = m.[INCOTERMS])  and (t.[FCST_TYPE] = m.[FCST_TYPE])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_INTRANSIT_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] c with (nolock) 
							where  ( (c.[RESULT_DATE] = t.[RESULT_DATE]) and (c.[RESULT_TYPE] = t.[RESULT_TYPE])  and (c.[COMPANY_ID] = t.[COMPANY_ID])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[SHIPMENT_NO] = t.[SHIPMENT_NO])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[PLANT_ISSUE_DATE] = t.[PLANT_ISSUE_DATE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  )  
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
					[cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[RESULT_DATE] = mo.[RESULT_DATE]) and (t.[RESULT_TYPE] = mo.[RESULT_TYPE])  and (t.[COMPANY_ID] = mo.[COMPANY_ID])  and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[SHIPMENT_NO] = mo.[SHIPMENT_NO])  and (t.[PROJECT_CODE] = mo.[PROJECT_CODE])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[PLANT_ISSUE_DATE] = mo.[PLANT_ISSUE_DATE])  and (t.[INCOTERMS] = mo.[INCOTERMS])  and (t.[FCST_TYPE] = mo.[FCST_TYPE])  ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_A44428BA
	    when 1 then __$operation
	    else
			case __$min_op_A44428BA 
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
		case __$count_A44428BA
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_A44428BA 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [RESULT_DATE], [RESULT_TYPE], [COMPANY_ID], [DIVISION_ID], [PLANT_ID], [SHIPMENT_NO], [PROJECT_CODE], [ITEM_ID], [PLANT_ISSUE_DATE], [INCOTERMS], [FCST_TYPE], [DOM_EXP], [CUSTOMER_CODE], [SHIPTO_CODE], [FROM_SCM_SITE_ID], [FROM_SITE_ITEM_MAPPING_YN], [TO_SCM_SITE_ID], [TO_SITE_ITEM_MAPPING_YN], [DELIVERY_QTY], [UOM], [TRANSPORT_MODE], [SHIPPING_DATE], [POL], [POL_ATD_DATE], [POD], [POD_ETA_DATE], [POD_ATA_DATE], [POD_ETD_DATE], [POD_ATD_DATE], [F_DEST_PORT_CODE], [F_DEST_ETA_DATE], [F_DEST_ATA_DATE], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [FINAL_SOLDTO_CODE], [FINAL_SOLDTO_NAME], [FINAL_INCOTERMS]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_A44428BA 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] c with (nolock)
			where  ( (c.[RESULT_DATE] = t.[RESULT_DATE]) and (c.[RESULT_TYPE] = t.[RESULT_TYPE])  and (c.[COMPANY_ID] = t.[COMPANY_ID])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[SHIPMENT_NO] = t.[SHIPMENT_NO])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[PLANT_ISSUE_DATE] = t.[PLANT_ISSUE_DATE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_A44428BA, __$count_A44428BA, 
		m.__$update_mask , t.[RESULT_DATE], t.[RESULT_TYPE], t.[COMPANY_ID], t.[DIVISION_ID], t.[PLANT_ID], t.[SHIPMENT_NO], t.[PROJECT_CODE], t.[ITEM_ID], t.[PLANT_ISSUE_DATE], t.[INCOTERMS], t.[FCST_TYPE], t.[DOM_EXP], t.[CUSTOMER_CODE], t.[SHIPTO_CODE], t.[FROM_SCM_SITE_ID], t.[FROM_SITE_ITEM_MAPPING_YN], t.[TO_SCM_SITE_ID], t.[TO_SITE_ITEM_MAPPING_YN], t.[DELIVERY_QTY], t.[UOM], t.[TRANSPORT_MODE], t.[SHIPPING_DATE], t.[POL], t.[POL_ATD_DATE], t.[POD], t.[POD_ETA_DATE], t.[POD_ATA_DATE], t.[POD_ETD_DATE], t.[POD_ATD_DATE], t.[F_DEST_PORT_CODE], t.[F_DEST_ETA_DATE], t.[F_DEST_ATA_DATE], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[FINAL_SOLDTO_CODE], t.[FINAL_SOLDTO_NAME], t.[FINAL_INCOTERMS]
		from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] t with (nolock) inner join 
		(	select  r.[RESULT_DATE], r.[RESULT_TYPE], r.[COMPANY_ID], r.[DIVISION_ID], r.[PLANT_ID], r.[SHIPMENT_NO], r.[PROJECT_CODE], r.[ITEM_ID], r.[PLANT_ISSUE_DATE], r.[INCOTERMS], r.[FCST_TYPE],
		    count(*) as __$count_A44428BA, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[RESULT_DATE], r.[RESULT_TYPE], r.[COMPANY_ID], r.[DIVISION_ID], r.[PLANT_ID], r.[SHIPMENT_NO], r.[PROJECT_CODE], r.[ITEM_ID], r.[PLANT_ISSUE_DATE], r.[INCOTERMS], r.[FCST_TYPE]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] c with (nolock) where  ( (c.[RESULT_DATE] = t.[RESULT_DATE]) and (c.[RESULT_TYPE] = t.[RESULT_TYPE])  and (c.[COMPANY_ID] = t.[COMPANY_ID])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[SHIPMENT_NO] = t.[SHIPMENT_NO])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[PLANT_ISSUE_DATE] = t.[PLANT_ISSUE_DATE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[RESULT_DATE] = m.[RESULT_DATE]) and (t.[RESULT_TYPE] = m.[RESULT_TYPE])  and (t.[COMPANY_ID] = m.[COMPANY_ID])  and (t.[DIVISION_ID] = m.[DIVISION_ID])  and (t.[PLANT_ID] = m.[PLANT_ID])  and (t.[SHIPMENT_NO] = m.[SHIPMENT_NO])  and (t.[PROJECT_CODE] = m.[PROJECT_CODE])  and (t.[ITEM_ID] = m.[ITEM_ID])  and (t.[PLANT_ISSUE_DATE] = m.[PLANT_ISSUE_DATE])  and (t.[INCOTERMS] = m.[INCOTERMS])  and (t.[FCST_TYPE] = m.[FCST_TYPE])  ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_INTRANSIT_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] c with (nolock)
							where  ( (c.[RESULT_DATE] = t.[RESULT_DATE]) and (c.[RESULT_TYPE] = t.[RESULT_TYPE])  and (c.[COMPANY_ID] = t.[COMPANY_ID])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[SHIPMENT_NO] = t.[SHIPMENT_NO])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[PLANT_ISSUE_DATE] = t.[PLANT_ISSUE_DATE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  )  
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
					[cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[RESULT_DATE] = mo.[RESULT_DATE]) and (t.[RESULT_TYPE] = mo.[RESULT_TYPE])  and (t.[COMPANY_ID] = mo.[COMPANY_ID])  and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[SHIPMENT_NO] = mo.[SHIPMENT_NO])  and (t.[PROJECT_CODE] = mo.[PROJECT_CODE])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[PLANT_ISSUE_DATE] = mo.[PLANT_ISSUE_DATE])  and (t.[INCOTERMS] = mo.[INCOTERMS])  and (t.[FCST_TYPE] = mo.[FCST_TYPE])  ) 
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
		null as __$update_mask , t.[RESULT_DATE], t.[RESULT_TYPE], t.[COMPANY_ID], t.[DIVISION_ID], t.[PLANT_ID], t.[SHIPMENT_NO], t.[PROJECT_CODE], t.[ITEM_ID], t.[PLANT_ISSUE_DATE], t.[INCOTERMS], t.[FCST_TYPE], t.[DOM_EXP], t.[CUSTOMER_CODE], t.[SHIPTO_CODE], t.[FROM_SCM_SITE_ID], t.[FROM_SITE_ITEM_MAPPING_YN], t.[TO_SCM_SITE_ID], t.[TO_SITE_ITEM_MAPPING_YN], t.[DELIVERY_QTY], t.[UOM], t.[TRANSPORT_MODE], t.[SHIPPING_DATE], t.[POL], t.[POL_ATD_DATE], t.[POD], t.[POD_ETA_DATE], t.[POD_ATA_DATE], t.[POD_ETD_DATE], t.[POD_ATD_DATE], t.[F_DEST_PORT_CODE], t.[F_DEST_ETA_DATE], t.[F_DEST_ATA_DATE], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[FINAL_SOLDTO_CODE], t.[FINAL_SOLDTO_NAME], t.[FINAL_INCOTERMS]
		from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_INTRANSIT_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] c with (nolock) where  ( (c.[RESULT_DATE] = t.[RESULT_DATE]) and (c.[RESULT_TYPE] = t.[RESULT_TYPE])  and (c.[COMPANY_ID] = t.[COMPANY_ID])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[SHIPMENT_NO] = t.[SHIPMENT_NO])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[PLANT_ISSUE_DATE] = t.[PLANT_ISSUE_DATE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] c with (nolock)
							where  ( (c.[RESULT_DATE] = t.[RESULT_DATE]) and (c.[RESULT_TYPE] = t.[RESULT_TYPE])  and (c.[COMPANY_ID] = t.[COMPANY_ID])  and (c.[DIVISION_ID] = t.[DIVISION_ID])  and (c.[PLANT_ID] = t.[PLANT_ID])  and (c.[SHIPMENT_NO] = t.[SHIPMENT_NO])  and (c.[PROJECT_CODE] = t.[PROJECT_CODE])  and (c.[ITEM_ID] = t.[ITEM_ID])  and (c.[PLANT_ISSUE_DATE] = t.[PLANT_ISSUE_DATE])  and (c.[INCOTERMS] = t.[INCOTERMS])  and (c.[FCST_TYPE] = t.[FCST_TYPE])  )  
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
					[cdc].[dbo_SCM_DNM_INTRANSIT_C_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[RESULT_DATE] = mo.[RESULT_DATE]) and (t.[RESULT_TYPE] = mo.[RESULT_TYPE])  and (t.[COMPANY_ID] = mo.[COMPANY_ID])  and (t.[DIVISION_ID] = mo.[DIVISION_ID])  and (t.[PLANT_ID] = mo.[PLANT_ID])  and (t.[SHIPMENT_NO] = mo.[SHIPMENT_NO])  and (t.[PROJECT_CODE] = mo.[PROJECT_CODE])  and (t.[ITEM_ID] = mo.[ITEM_ID])  and (t.[PLANT_ISSUE_DATE] = mo.[PLANT_ISSUE_DATE])  and (t.[INCOTERMS] = mo.[INCOTERMS])  and (t.[FCST_TYPE] = mo.[FCST_TYPE])  ) 
				group by
					mo.__$seqval
			)
	 