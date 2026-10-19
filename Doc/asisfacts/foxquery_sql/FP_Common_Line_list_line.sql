SELECT  A.COMPANY_ID AS COMPANY_ID,  A.DIVISION_ID AS DIVISION_ID,   A.SITE_ID AS SITE_ID         
   , A.PLANT_ID   AS PLANT_ID, A.FACTORY_ID AS FACTORY_ID, A.OPERATION_ID AS OPERATION_ID          
   , A.LINE_ID AS LINE_ID, A.LINE_NAME AS LINE_NAME, A.LINE_SETUP_GROUP_ID AS LINE_SETUP_GROUP_ID  
   , A.ELECTRODE_TYPE AS ELECTRODE_TYPE,  A.LINE_TYPE AS LINE_TYPE                                 
   , A.LINE_TYPE_NAME AS LINE_TYPE_NAME, A.MODEL_TYPE AS LINE_MODEL_TYPE                           
   , ( CASE WHEN A.LINE_ATTR_1 = '-' THEN 'Normal' ELSE A.LINE_ATTR_1 END ) AS LINE_ATTRIBUTE1 
   , A.LOCATION AS LINE_LOCATION, A.ACTIVE_FLAG AS ACTIVE_FLAG,      A.DESCRIPTION AS DESCRIPTION  
   , A.SCP_LINE_ID AS SCP_LINE_ID,A.MES_LINE_ID AS MES_LINE_ID, A.WORK_CENTER_ID AS WORK_CENTER_ID,   A.PROD_VERSION_TYPE As PROD_VERSION_TYPE                      
   ,( SELECT COUNT(*) FROM SCM_EQUIPMENT_M T(NOLOCK)                                               
      WHERE T.COMPANY_ID     = A.COMPANY_ID   AND  T.DIVISION_ID    = A.DIVISION_ID                
         AND   T.SITE_ID     = A.SITE_ID      AND  T.PLANT_ID       = A.PLANT_ID                   
         AND   T.FACTORY_ID  = A.FACTORY_ID   AND  T.OPERATION_ID   = A.OPERATION_ID               
         AND   T.LINE_ID     = A.LINE_ID      AND  T.ELECTRODE_TYPE = A.ELECTRODE_TYPE             
         AND   T.ACTIVE_FLAG = 'Y'          AND  T.EQUIPMENT_TYPE = 'M'                        
     ) AS EQUIPMENT_COUNT                                                                          
	  , '' AS MESSAGE_ID, CASE WHEN R.FACTORY_ID IS NULL THEN 'N' ELSE 'Y' END EDIT_YN          
   , A.TOP_LINE_ID AS ORG_LINE_ID,  A.UPDATE_ID AS UPDATE_ID                                       
	  , A.UPDATE_TIME AS UPDATE_TIME                                                                  
	FROM  SCM_LINE_M A WITH(NOLOCK)                                                                   
     LEFT OUTER JOIN (                                                                             
          SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID         
          FROM    FP_USER_ROLE_INFO_V R WITH(NOLOCK)		
          WHERE   R.USER_ID	    = 'chkim.68' 	
          AND     R.SAVE_FLAG	= 'Y'					
		) R                                                 
		ON  1=1                                             
		AND A.COMPANY_ID    = R.COMPANY_ID                  
		AND A.DIVISION_ID   = R.DIVISION_ID                 
		AND A.SITE_ID       = R.SITE_ID                     
		AND A.PLANT_ID      = R.PLANT_ID                    
		AND A.FACTORY_ID    = R.FACTORY_ID                  
	, SCM_OPERATION_M B WITH(NOLOCK)  ,FP_INSTANCE_FACTORY_M M WITH(NOLOCK)                      
	WHERE 1=1
            AND A.ACTIVE_FLAG = N'Y' 
	AND (A.DIVISION_ID  = @DIVISION_ID OR ISNULL(@DIVISION_ID,'') = '') 
            AND (A.SITE_ID = @SITE_ID OR ISNULL(@SITE_ID,'') = '') 
            AND (A.PLANT_ID = @PLANT_ID OR ISNULL(@PLANT_ID,'') = '')
	AND A.FACTORY_ID    = M.FACTORY_ID                   
	AND (M.INSTANCE_ID = @INSTANCE_ID OR ISNULL(@INSTANCE_ID,'') = '')
	AND   A.SITE_ID       = B.SITE_ID                       
            AND A.COMPANY_ID    = B.COMPANY_ID                   
	AND   A.DIVISION_ID   = B.DIVISION_ID                   
	AND   A.OPERATION_ID  = B.OPERATION_ID                  
	AND  ( B.WO_FLAG = 'Y' OR B.MO_FLAG = 'Y' )     
AND EXISTS (                                                                                  
                SELECT 1                                                                        
                FROM   FP_USER_ROLE_INFO_V C WITH(NOLOCK)                                       
                WHERE  A.COMPANY_ID  = C.COMPANY_ID  AND A.DIVISION_ID = C.DIVISION_ID          
                  AND  A.SITE_ID     = C.SITE_ID     AND A.PLANT_ID    = C.PLANT_ID             
                  AND  A.FACTORY_ID  = C.FACTORY_ID  AND C.USER_ID     = @USER_ID    
            )              
	ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID