;WITH USER_SHOP (INSTANCE_ID, OPERATION_ID) AS (            
                SELECT DISTINCT B.INSTANCE_ID, B.OPERATION_ID
                FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)            
                WHERE  1=1                                           
                AND    B.INSTANCE_ID   = @INSTANCE_ID
                AND    B.OPERATION_ID   = @OPERATION_ID
                AND    B.USER_ID   = @USER_ID
                AND	   B.SAVE_FLAG = 'Y'                           
            )                              
SELECT DISTINCT V.INSTANCE_ID, V.OPERATION_ID, A.ITEM_ID,A.ITEM_NAME FROM SCM_ITEM_M A WITH(NOLOCK) 
INNER JOIN FP_INSTANCE_LINE_V V WITH(NOLOCK)
ON 1=1
AND A.ACTIVE_FLAG = 'Y'
AND A.COMPANY_ID = V.COMPANY_ID
AND A.DIVISION_ID = V.DIVISION_ID
AND V.INSTANCE_ID = @INSTANCE_ID
AND V.OPERATION_ID = @OPERATION_ID
       AND   EXISTS (                             
                                SELECT INSTANCE_ID FROM USER_SHOP   
                                WHERE INSTANCE_ID = V.INSTANCE_ID 
                                AND OPERATION_ID  = V.OPERATION_ID
                               )    
                               AND (ISNULL(@ITEM_NAME,'')='' OR A.ITEM_ID LIKE '%' + ISNULL(@ITEM_NAME,'') + '%')