SELECT A.LINE_ID AS CODE
           , '(' + A.LINE_ID + ')' + CASE WHEN A.LINE_NAME = '' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END AS NAME
      FROM   SCM_LINE_M A WITH(NOLOCK)
      WHERE  EXISTS (
        	SELECT 1
        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)
        	WHERE  A.COMPANY_ID     = B.COMPANY_ID
        	AND    A.DIVISION_ID    = B.DIVISION_ID
        	AND    A.SITE_ID        = B.SITE_ID
        	AND    A.PLANT_ID       = B.PLANT_ID
        	AND    A.FACTORY_ID     = B.FACTORY_ID
        	AND    A.OPERATION_ID   = B.OPERATION_ID
        	AND    A.LINE_ID        = B.LINE_ID
        	AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        	AND    B.USER_ID     = @USER_ID
        	
        	@CTRL_SAVE_FLAG
	        --{
	    		--  var sql="";
	    		  
	    		--  if($data._SAVE_AUTH == "Y") 
	    		--  {
	    		--  		sql+="			AND    B.SAVE_FLAG = 'Y' \r\n";
	    		--  }
	    		  
	    		--  sql;
					--}
      )
  	  AND   A.ACTIVE_FLAG = 'Y'
      AND   EXISTS (
            SELECT 1 FROM (
              SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID
              FROM  SCM_FACTORY_M A WITH(NOLOCK)
              INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)
              ON    A.FACTORY_ID  = B.FACTORY_ID
              AND   B.ACTIVE_FLAG = 'Y'
              WHERE A.ACTIVE_FLAG = 'Y'
              @CTRL_INSTANCE_ID -- [AND B.INSTANCE_ID = @INSTANCE_ID]
            ) C
            WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID
      )
      @CTRL_COMPANY_ID --[and    A.COMPANY_ID=@COMPANY_ID]
      @CTRL_DIVISION_ID --[and    A.DIVISION_ID=@DIVISION_ID]
      @CTRL_SITE_ID --[and    A.SITE_ID=@SITE_ID]
	    @CTRL_PLANT_ID --[AND    A.PLANT_ID = @PLANT_ID]
      @CTRL_FACTORY_ID --[and    A.FACTORY_ID=@FACTORY_ID]
      @CTRL_LINE_ID --[and    A.LINE_ID=@LINE_ID]
      @CTRL_OPERATION_ID --[and    A.OPERATION_ID=@OPERATION_ID]
      
      @CTRL_DIVISION_LT --[and    A.DIVISION_ID=@DIVISION_ID]
      @CTRL_SITE_LT --[and    A.SITE_ID=@SITE_ID]
	    @CTRL_PLANT_LT --[AND    A.PLANT_ID = @PLANT_ID]
      @CTRL_FACTORY_LT --[and    A.FACTORY_ID=@FACTORY_ID]
      @CTRL_OPERATION_LT --[and    A.OPERATION_ID=@OPERATION_ID]
      
      @CTRL_AMEND_FLAG
      --{
      --	var sql = "";
     -- 	var sAmend = $data.AMEND_FLAG;
      --	
      --	if(sAmend != null && sAmend != "") {
      --      sql+="          AND EXISTS (\r\n";
      --      sql+="            SELECT 1 FROM SCM_OPERATION_M OP\r\n";
      --      sql+="            WHERE  A.COMPANY_ID   = OP.COMPANY_ID\r\n";
      --      sql+="            AND    A.DIVISION_ID  = OP.DIVISION_ID\r\n";
      --      sql+="            AND    A.SITE_ID      = OP.SITE_ID\r\n";
      --      sql+="            AND    A.OPERATION_ID = OP.OPERATION_ID\r\n";
      --      sql+="            AND    OP.AMEND_FLAG  = 'Y'\r\n";
      --    sql+="            )";
      --	}
      --	
      --	sql;
      --}
      @CTRL_INSTANCE_ID2
      --{
      --  var sql = "";
      --  var sInst = $data.INSTANCE_ID;
      --  
      --  if(sInst != "" && sInst != null) {
      --    sql+="AND EXISTS ( SELECT  1 \r\n";
      --    sql+="             FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)\r\n";
      --    sql+="   				   WHERE   LV1.LOOKUP_TYPE_CODE = 'INSTANCE_ID'\r\n";
      --    sql+="        		 AND     LV1.SEGMENT1         = '" + sInst + "'\r\n";
      --    sql+="        		 AND     LV1.ACTIVE_FLAG      = 'Y'\r\n";
     --     sql+="        		 AND     LV1.ATTRIBUTE1       = 'BUILDING'\r\n";
     --     sql+="        		 UNION ALL\r\n";
     --     sql+="        		 SELECT  1 \r\n";
     --     sql+="             FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK),\r\n";
      --    sql+="        		         SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)\r\n";
      --    sql+="        		 WHERE   LV1.LOOKUP_TYPE_CODE = 'INSTANCE_ID'\r\n";
      --    sql+="        		 AND 	   LV2.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'\r\n";
      --    sql+="        		 AND     LV1.SEGMENT1         = LV2.SEGMENT1\r\n";
      --    sql+="        		 AND     LV1.SEGMENT1         = '" + sInst + "'\r\n";
      --    sql+="        		 AND     LV1.ACTIVE_FLAG      = 'Y'\r\n";
      --    sql+="        		 AND     LV1.ATTRIBUTE1       = 'PLAN GROUP'\r\n";
      --    sql+="        		 AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) )\r\n";
      --  }
      --  
      --  sql;
      --}
      GROUP BY a.LINE_ID, a.LINE_NAME
      ORDER BY A.LINE_ID