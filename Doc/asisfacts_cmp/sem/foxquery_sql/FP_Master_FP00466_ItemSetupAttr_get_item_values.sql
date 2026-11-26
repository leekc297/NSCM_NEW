select distinct a.instance_id,lk.segment2 as instance_name, a.operation_id, a.item_id
             ,a.active_flag	as 	ACTIVE_FLAG																			   
             ,a.insert_id, a.update_id																				   
             ,a.insert_time,a.update_time															   
             ,a.attribute1 as ATTRIBUTE1,a.attribute2 as ATTRIBUTE2,a.attribute3 as ATTRIBUTE3,a.attribute4 as ATTRIBUTE4,a.attribute5 as ATTRIBUTE5	
             ,a.attribute6 as ATTRIBUTE6 ,a.attribute7 as ATTRIBUTE7,a.attribute8 as ATTRIBUTE8,a.attribute9 as ATTRIBUTE9,a.attribute10 as ATTRIBUTE10	
             ,a.attribute11 as ATTRIBUTE11,a.attribute12 as ATTRIBUTE12,a.attribute13 as ATTRIBUTE13,a.attribute14 as ATTRIBUTE14,a.attribute15  as ATTRIBUTE15	
       from   FP_INSTANCE_ITEM_SETUP_ATTR_VALUE_M   a WITH(NOLOCK)   	
	   	   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE LK WITH(NOLOCK)
ON 1=1
AND LK.LOOKUP_TYPE_CODE='INSTANCE_ID'
AND A.INSTANCE_ID = LK.SEGMENT1
       where  1=1
       AND a.INSTANCE_ID = @INSTANCE_ID
       AND a.OPERATION_ID = @OPERATION_ID