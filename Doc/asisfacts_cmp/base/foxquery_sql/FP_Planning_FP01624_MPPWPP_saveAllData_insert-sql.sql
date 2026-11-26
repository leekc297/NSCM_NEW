BEGIN
      	MERGE INTO FP_MPP_WPP_BASE_PLAN_M AS A
        	USING (
          	      SELECT RTRIM(LTRIM(@MPP_WPP_PLAN_TYPE))        AS MPP_WPP_PLAN_TYPE
          	           , RTRIM(LTRIM(@COMPANY_ID))               AS COMPANY_ID
          	           , RTRIM(LTRIM(@DIVISION_ID))              AS DIVISION_ID
          	           , RTRIM(LTRIM(@SITE_ID))                  AS SITE_ID
          	           , RTRIM(LTRIM(@PLANT_ID))                 AS PLANT_ID
          	           , RTRIM(LTRIM(@FACTORY_ID))               AS FACTORY_ID
          	           , RTRIM(LTRIM(@LINE_ID))                  AS LINE_ID
          	           , RTRIM(LTRIM(@EQUIPMENT_ID))             AS EQUIPMENT_ID
          	           , RTRIM(LTRIM(@ITEM_ID))                  AS ITEM_ID
          	           {
          	              var sql="";
          	              var sDate = $data.PLAN_DATE;
          	              sql=", CONVERT(DATE,RTRIM(LTRIM('" + sDate + "')))  AS PLAN_DATE \r\n";
          	              sql;
          	           }
          	           , RTRIM(LTRIM(@PLAN_QTY))                 AS PLAN_QTY
        		    ) AS B
        	ON  A.MPP_WPP_PLAN_TYPE = B.MPP_WPP_PLAN_TYPE
        	AND A.FACTORY_ID        = B.FACTORY_ID
        	AND A.LINE_ID           = B.LINE_ID
        	AND A.EQUIPMENT_ID      = B.EQUIPMENT_ID
        	AND A.ITEM_ID           = B.ITEM_ID
        	AND A.PLAN_DATE         = B.PLAN_DATE
      	WHEN MATCHED THEN
      		UPDATE SET A.PLAN_QTY = B.PLAN_QTY
      		         , UPDATE_ID  = @USER_ID, UPDATE_TIME = dbo.SYSDATE1()
      	WHEN NOT MATCHED BY TARGET THEN
      		INSERT (
             MPP_WPP_PLAN_TYPE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
            ,LINE_ID, EQUIPMENT_ID, ITEM_ID
            ,PLAN_DATE, PLAN_QTY
          	,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
      		)
      		VALUES (
             B.MPP_WPP_PLAN_TYPE, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID
            ,B.LINE_ID, B.EQUIPMENT_ID, B.ITEM_ID
            ,B.PLAN_DATE, B.PLAN_QTY
        		,@USER_ID, dbo.SYSDATE1(), @USER_ID, dbo.SYSDATE1()
      		)
      		;
      	
      	INSERT INTO HIS_MPP_WPP_BASE_PLAN_M (
               MPP_WPP_PLAN_TYPE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
              ,LINE_ID, EQUIPMENT_ID, ITEM_ID
              ,PLAN_DATE, PLAN_QTY
            	,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
              ,JOB_USER_ID, JOB_TIME,JOB_TYPE
      	)
      	SELECT MPP_WPP_PLAN_TYPE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
              ,LINE_ID, EQUIPMENT_ID, ITEM_ID
              ,PLAN_DATE, PLAN_QTY
            	,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
           		,@USER_ID AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'EXCEL' AS JOB_TYPE
      	FROM   FP_MPP_WPP_BASE_PLAN_M A
      	WHERE  A.MPP_WPP_PLAN_TYPE = RTRIM(LTRIM(@MPP_WPP_PLAN_TYPE))
        AND    A.FACTORY_ID        = RTRIM(LTRIM(@FACTORY_ID))
        AND    A.LINE_ID           = RTRIM(LTRIM(@LINE_ID))
        AND    A.EQUIPMENT_ID      = RTRIM(LTRIM(@EQUIPMENT_ID))
        AND    A.ITEM_ID           = RTRIM(LTRIM(@ITEM_ID))
        {
          var sql="";
          var sDate = $data.PLAN_DATE;
          sql="AND    A.PLAN_DATE         = CONVERT(DATE,RTRIM(LTRIM('" + sDate + "'))) \r\n";
          sql;
        }
      	;
      	
      END;