
	create function [cdc].[fn_cdc_get_net_changes_dbo_SCM_MST_SITE_ITEM_H]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [HISTORY_SEQ], NULL as [PROJECT_CODE], NULL as [SCM_SITE_ID], NULL as [ITEM_ID], NULL as [CURRENCY], NULL as [CELL_PER_CAR], NULL as [CELL_PER_MODULE], NULL as [LIABILITY_PERIOD], NULL as [SALES_PLAN_ADJUST_YN], NULL as [ITEM_HRCY_ID], NULL as [VALID_YN], NULL as [BPMS_EXIST], NULL as [CUST_GROUP], NULL as [CUST_GROUP_DTL], NULL as [OWNER], NULL as [APPLICATION], NULL as [ROUTE], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [HISTORY_CREATION_DATE], NULL as [REPORT_GROUP1], NULL as [REPORT_GROUP2], NULL as [REPORT_GROUP3], NULL as [REPORT_GROUP4], NULL as [REPORT_GROUP5], NULL as [REPORT_GROUP6], NULL as [REPORT_GROUP7], NULL as [REPORT_GROUP8], NULL as [EDI_LT], NULL as [SCP_VMI_LT], NULL as [SALES_COMPANY], NULL as [SALES_PLANT], NULL as [PARTIAL_PLAN_YN], NULL as [CONSENSUS_MKT], NULL as [CONSENSUS_ESS], NULL as [CONSENSUS_SCM], NULL as [INVENTORY_DAY], NULL as [CHANGE_REASON], NULL as [ALT_SIM_YN], NULL as [DESCRIPTION], NULL as [PROJECT_INFO], NULL as [PROJECT_S_OP_REPORT], NULL as [CELL_S_OP_REPORT], NULL as [PRJ_OWNR_ID], NULL as [CRGE_ORG_NM], NULL as [CUST_ENG_NM]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SITE_ITEM_H', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_1217B96A
	    when 1 then __$operation
	    else
			case __$min_op_1217B96A 
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
		null as __$update_mask , [DIVISION_ID], [HISTORY_SEQ], [PROJECT_CODE], [SCM_SITE_ID], [ITEM_ID], [CURRENCY], [CELL_PER_CAR], [CELL_PER_MODULE], [LIABILITY_PERIOD], [SALES_PLAN_ADJUST_YN], [ITEM_HRCY_ID], [VALID_YN], [BPMS_EXIST], [CUST_GROUP], [CUST_GROUP_DTL], [OWNER], [APPLICATION], [ROUTE], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [HISTORY_CREATION_DATE], [REPORT_GROUP1], [REPORT_GROUP2], [REPORT_GROUP3], [REPORT_GROUP4], [REPORT_GROUP5], [REPORT_GROUP6], [REPORT_GROUP7], [REPORT_GROUP8], [EDI_LT], [SCP_VMI_LT], [SALES_COMPANY], [SALES_PLANT], [PARTIAL_PLAN_YN], [CONSENSUS_MKT], [CONSENSUS_ESS], [CONSENSUS_SCM], [INVENTORY_DAY], [CHANGE_REASON], [ALT_SIM_YN], [DESCRIPTION], [PROJECT_INFO], [PROJECT_S_OP_REPORT], [CELL_S_OP_REPORT], [PRJ_OWNR_ID], [CRGE_ORG_NM], [CUST_ENG_NM]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_1217B96A 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] c with (nolock)   
			where  ( (c.[HISTORY_SEQ] = t.[HISTORY_SEQ]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_1217B96A, __$count_1217B96A, t.[DIVISION_ID], t.[HISTORY_SEQ], t.[PROJECT_CODE], t.[SCM_SITE_ID], t.[ITEM_ID], t.[CURRENCY], t.[CELL_PER_CAR], t.[CELL_PER_MODULE], t.[LIABILITY_PERIOD], t.[SALES_PLAN_ADJUST_YN], t.[ITEM_HRCY_ID], t.[VALID_YN], t.[BPMS_EXIST], t.[CUST_GROUP], t.[CUST_GROUP_DTL], t.[OWNER], t.[APPLICATION], t.[ROUTE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[HISTORY_CREATION_DATE], t.[REPORT_GROUP1], t.[REPORT_GROUP2], t.[REPORT_GROUP3], t.[REPORT_GROUP4], t.[REPORT_GROUP5], t.[REPORT_GROUP6], t.[REPORT_GROUP7], t.[REPORT_GROUP8], t.[EDI_LT], t.[SCP_VMI_LT], t.[SALES_COMPANY], t.[SALES_PLANT], t.[PARTIAL_PLAN_YN], t.[CONSENSUS_MKT], t.[CONSENSUS_ESS], t.[CONSENSUS_SCM], t.[INVENTORY_DAY], t.[CHANGE_REASON], t.[ALT_SIM_YN], t.[DESCRIPTION], t.[PROJECT_INFO], t.[PROJECT_S_OP_REPORT], t.[CELL_S_OP_REPORT], t.[PRJ_OWNR_ID], t.[CRGE_ORG_NM], t.[CUST_ENG_NM] 
		from [cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] t with (nolock) inner join 
		(	select  r.[HISTORY_SEQ],
		    count(*) as __$count_1217B96A 
			from [cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[HISTORY_SEQ]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] c with (nolock) where  ( (c.[HISTORY_SEQ] = t.[HISTORY_SEQ]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[HISTORY_SEQ] = m.[HISTORY_SEQ]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SITE_ITEM_H', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] c with (nolock) 
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
					[cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] as mo with (nolock)
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
	    case __$count_1217B96A
	    when 1 then __$operation
	    else
			case __$min_op_1217B96A 
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
		case __$count_1217B96A
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_1217B96A 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [DIVISION_ID], [HISTORY_SEQ], [PROJECT_CODE], [SCM_SITE_ID], [ITEM_ID], [CURRENCY], [CELL_PER_CAR], [CELL_PER_MODULE], [LIABILITY_PERIOD], [SALES_PLAN_ADJUST_YN], [ITEM_HRCY_ID], [VALID_YN], [BPMS_EXIST], [CUST_GROUP], [CUST_GROUP_DTL], [OWNER], [APPLICATION], [ROUTE], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10], [HISTORY_CREATION_DATE], [REPORT_GROUP1], [REPORT_GROUP2], [REPORT_GROUP3], [REPORT_GROUP4], [REPORT_GROUP5], [REPORT_GROUP6], [REPORT_GROUP7], [REPORT_GROUP8], [EDI_LT], [SCP_VMI_LT], [SALES_COMPANY], [SALES_PLANT], [PARTIAL_PLAN_YN], [CONSENSUS_MKT], [CONSENSUS_ESS], [CONSENSUS_SCM], [INVENTORY_DAY], [CHANGE_REASON], [ALT_SIM_YN], [DESCRIPTION], [PROJECT_INFO], [PROJECT_S_OP_REPORT], [CELL_S_OP_REPORT], [PRJ_OWNR_ID], [CRGE_ORG_NM], [CUST_ENG_NM]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_1217B96A 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] c with (nolock)
			where  ( (c.[HISTORY_SEQ] = t.[HISTORY_SEQ]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_1217B96A, __$count_1217B96A, 
		m.__$update_mask , t.[DIVISION_ID], t.[HISTORY_SEQ], t.[PROJECT_CODE], t.[SCM_SITE_ID], t.[ITEM_ID], t.[CURRENCY], t.[CELL_PER_CAR], t.[CELL_PER_MODULE], t.[LIABILITY_PERIOD], t.[SALES_PLAN_ADJUST_YN], t.[ITEM_HRCY_ID], t.[VALID_YN], t.[BPMS_EXIST], t.[CUST_GROUP], t.[CUST_GROUP_DTL], t.[OWNER], t.[APPLICATION], t.[ROUTE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[HISTORY_CREATION_DATE], t.[REPORT_GROUP1], t.[REPORT_GROUP2], t.[REPORT_GROUP3], t.[REPORT_GROUP4], t.[REPORT_GROUP5], t.[REPORT_GROUP6], t.[REPORT_GROUP7], t.[REPORT_GROUP8], t.[EDI_LT], t.[SCP_VMI_LT], t.[SALES_COMPANY], t.[SALES_PLANT], t.[PARTIAL_PLAN_YN], t.[CONSENSUS_MKT], t.[CONSENSUS_ESS], t.[CONSENSUS_SCM], t.[INVENTORY_DAY], t.[CHANGE_REASON], t.[ALT_SIM_YN], t.[DESCRIPTION], t.[PROJECT_INFO], t.[PROJECT_S_OP_REPORT], t.[CELL_S_OP_REPORT], t.[PRJ_OWNR_ID], t.[CRGE_ORG_NM], t.[CUST_ENG_NM]
		from [cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] t with (nolock) inner join 
		(	select  r.[HISTORY_SEQ],
		    count(*) as __$count_1217B96A, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[HISTORY_SEQ]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] c with (nolock) where  ( (c.[HISTORY_SEQ] = t.[HISTORY_SEQ]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[HISTORY_SEQ] = m.[HISTORY_SEQ]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SITE_ITEM_H', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] c with (nolock)
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
					[cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] as mo with (nolock)
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
		null as __$update_mask , t.[DIVISION_ID], t.[HISTORY_SEQ], t.[PROJECT_CODE], t.[SCM_SITE_ID], t.[ITEM_ID], t.[CURRENCY], t.[CELL_PER_CAR], t.[CELL_PER_MODULE], t.[LIABILITY_PERIOD], t.[SALES_PLAN_ADJUST_YN], t.[ITEM_HRCY_ID], t.[VALID_YN], t.[BPMS_EXIST], t.[CUST_GROUP], t.[CUST_GROUP_DTL], t.[OWNER], t.[APPLICATION], t.[ROUTE], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[HISTORY_CREATION_DATE], t.[REPORT_GROUP1], t.[REPORT_GROUP2], t.[REPORT_GROUP3], t.[REPORT_GROUP4], t.[REPORT_GROUP5], t.[REPORT_GROUP6], t.[REPORT_GROUP7], t.[REPORT_GROUP8], t.[EDI_LT], t.[SCP_VMI_LT], t.[SALES_COMPANY], t.[SALES_PLANT], t.[PARTIAL_PLAN_YN], t.[CONSENSUS_MKT], t.[CONSENSUS_ESS], t.[CONSENSUS_SCM], t.[INVENTORY_DAY], t.[CHANGE_REASON], t.[ALT_SIM_YN], t.[DESCRIPTION], t.[PROJECT_INFO], t.[PROJECT_S_OP_REPORT], t.[CELL_S_OP_REPORT], t.[PRJ_OWNR_ID], t.[CRGE_ORG_NM], t.[CUST_ENG_NM]
		from [cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_SITE_ITEM_H', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] c with (nolock) where  ( (c.[HISTORY_SEQ] = t.[HISTORY_SEQ]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] c with (nolock)
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
					[cdc].[dbo_SCM_MST_SITE_ITEM_H_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[HISTORY_SEQ] = mo.[HISTORY_SEQ]) ) 
				group by
					mo.__$seqval
			)
	 