SELECT DISTINCT A.ATTRIBUTE2 AS CODE_ID, A.SEGMENT2 AS CODE_NAME, A.SORT_ORDER
      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
      WHERE  A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
      AND    A.ACTIVE_FLAG = 'Y'
      @CTRL_DIVISION_LT
      @CTRL_KR_CELL
      --[AND	 A.SEGMENT1 = @DIVISION_ID]
      --{
	       -- var sql = "";
	      --  var sMst = $data.INSTANCE_ID;
	        
	     --   if(sMst == "KR_CELL") {
	     --     sql = "UNION ALL SELECT 'M/C' AS CODE_ID, 'M/C' AS CODE_NAME, '999' AS SORT_ORDER \r\n";
	     --   }
        
       -- 	sql;
      --}
      ORDER BY A.SORT_ORDER