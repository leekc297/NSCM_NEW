select a.instance_id, a.operation_id
             ,a.active_flag	as 	ACTIVE_FLAG																			   
             ,a.insert_id, a.update_id																				   
             ,a.insert_time,a.update_time															   
             ,a.attribute1 as ATTRIBUTE1,a.attribute2 as ATTRIBUTE2,a.attribute3 as ATTRIBUTE3,a.attribute4 as ATTRIBUTE4,a.attribute5 as ATTRIBUTE5	
             ,a.attribute6 as ATTRIBUTE6 ,a.attribute7 as ATTRIBUTE7,a.attribute8 as ATTRIBUTE8,a.attribute9 as ATTRIBUTE9,a.attribute10 as ATTRIBUTE10	
             ,a.attribute11 as ATTRIBUTE11,a.attribute12 as ATTRIBUTE12,a.attribute13 as ATTRIBUTE13,a.attribute14 as ATTRIBUTE14,a.attribute15  as ATTRIBUTE15	
             
                FROM    FP_INSTANCE_ITEM_SETUP_ATTR_TYPE_M a WITH(NOLOCK)        
                
			       LEFT OUTER JOIN (                            
                  SELECT DISTINCT R.INSTANCE_ID, R.OPERATION_ID 
                  FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) 
                  WHERE  R.USER_ID   = @USER_ID 
                  AND    R.SAVE_FLAG = 'Y'                
             ) R 
             ON   A.INSTANCE_ID = R.INSTANCE_ID   
             AND  A.OPERATION_ID = R.OPERATION_ID 
                
                WHERE 1=1
                AND ISNULL(A.INSTANCE_ID,'') <> ''
                AND (A.INSTANCE_ID = ISNULL(@INSTANCE_ID,'') OR ISNULL(@INSTANCE_ID,'') = '')
                AND (A.OPERATION_ID = ISNULL(@OPERATION_ID,'') OR ISNULL(@OPERATION_ID,'') = '')