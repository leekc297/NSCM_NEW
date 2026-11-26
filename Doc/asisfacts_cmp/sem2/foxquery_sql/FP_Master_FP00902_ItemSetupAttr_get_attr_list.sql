select a.instance_id, a.operation_id
             ,a.attribute_type as ATTRIBUTE_TYPE,a.attribute_list as ATTRIBUTE_LIST
             ,a.active_flag	as 	ACTIVE_FLAG							
             ,a.description as DESCRIPTION
             ,a.insert_id, a.update_id																				   
             ,a.insert_time,a.update_time															   
       from   FP_INSTANCE_ITEM_SETUP_ATTR_LIST_M   a WITH(NOLOCK)   																	
       where  1=1
       AND a.INSTANCE_ID = @INSTANCE_ID
       AND a.OPERATION_ID = @OPERATION_ID