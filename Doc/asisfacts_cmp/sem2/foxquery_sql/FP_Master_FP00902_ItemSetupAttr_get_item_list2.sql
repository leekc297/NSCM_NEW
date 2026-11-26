select a.instance_id, a.operation_id
             ,a.active_flag	as 	ACTIVE_FLAG																			   
             ,a.insert_id, a.update_id																				   
             ,a.insert_time,a.update_time															   
             ,a.attribute1 as ATTRIBUTE1,a.attribute2 as ATTRIBUTE2,a.attribute3 as ATTRIBUTE3,a.attribute4 as ATTRIBUTE4,a.attribute5 as ATTRIBUTE5	
             ,a.attribute6 as ATTRIBUTE6 ,a.attribute7 as ATTRIBUTE7,a.attribute8 as ATTRIBUTE8,a.attribute9 as ATTRIBUTE9,a.attribute10 as ATTRIBUTE10	
             ,a.attribute11 as ATTRIBUTE11,a.attribute12 as ATTRIBUTE12,a.attribute13 as ATTRIBUTE13,a.attribute14 as ATTRIBUTE14,a.attribute15  as ATTRIBUTE15	
             
                FROM    FP_INSTANCE_ITEM_SETUP_ATTR_TYPE_M a WITH(NOLOCK)     
                       where  1=1
       AND a.INSTANCE_ID = @INSTANCE_ID
       AND a.OPERATION_ID = @OPERATION_ID