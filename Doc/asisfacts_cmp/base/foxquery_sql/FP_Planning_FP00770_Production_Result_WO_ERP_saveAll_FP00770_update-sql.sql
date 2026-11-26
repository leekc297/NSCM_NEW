INSERT into BUF_ERP_WORK_ORDER_STATUS_H (
         COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
        ,CUTOFF_DATE, WORK_ORDER_ID, DEMAND_ID, PRODUCTION_TYPE
        ,ORDER_TYPE, ITEM_ID, TOP_ITEM_ID, OPERATION_ID
        ,LINE_ID, WORK_CENTER_ID, PLAN_DATE
        ,PLAN_START_TIME
        ,PLAN_END_TIME
        ,PLAN_QTY
        ,ACTUAL_START_TIME
        ,ACTUAL_END_TIME
        ,ACTUAL_QTY, ACTUAL_GOOD_QTY, ACTUAL_SCRAP_QTY, BOM_VERSION_ID, WO_STATUS
        ,JOB_USER_ID, JOB_TIME, JOB_TYPE, JOB_ORDER
      )
      VALUES (
         @COMPANY_ID, @DIVISION_ID, @SITE_ID, @PLANT_ID, @FACTORY_ID
        ,CONVERT(DATETIME, @CUTOFF_DATE), @WORK_ORDER_ID, @DEMAND_ID, @PRODUCTION_TYPE
        ,@ORDER_TYPE, @ITEM_ID, @TOP_ITEM_ID, @OPERATION_ID
        ,@LINE_ID, @WORK_CENTER_ID, CONVERT(DATETIME, @PLAN_DATE)
        ,convert(datetime, substring(@PLAN_START_TIME,1,4) + '-' + substring(@PLAN_START_TIME,5,2) + '-' + substring(@PLAN_START_TIME,7,2) + ' ' + substring(@PLAN_START_TIME,9,2) + ':' + substring(@PLAN_START_TIME,11,2) + ':' + substring(@PLAN_START_TIME,13,2))
        ,convert(datetime, substring(@PLAN_END_TIME,1,4) + '-' + substring(@PLAN_END_TIME,5,2) + '-' + substring(@PLAN_END_TIME,7,2) + ' ' + substring(@PLAN_END_TIME,9,2) + ':' + substring(@PLAN_END_TIME,11,2) + ':' + substring(@PLAN_END_TIME,13,2))
        ,@PLAN_QTY
        ,convert(datetime, substring(@ACTUAL_START_TIME,1,4) + '-' + substring(@ACTUAL_START_TIME,5,2) + '-' + substring(@ACTUAL_START_TIME,7,2) + ' ' + substring(@ACTUAL_START_TIME,9,2) + ':' + substring(@ACTUAL_START_TIME,11,2) + ':' + substring(@ACTUAL_START_TIME,13,2))
        ,convert(datetime, substring(@ACTUAL_END_TIME,1,4) + '-' + substring(@ACTUAL_END_TIME,5,2) + '-' + substring(@ACTUAL_END_TIME,7,2) + ' ' + substring(@ACTUAL_END_TIME,9,2) + ':' + substring(@ACTUAL_END_TIME,11,2) + ':' + substring(@ACTUAL_END_TIME,13,2))
        ,@ACTUAL_QTY, @ACTUAL_GOOD_QTY, @ACTUAL_SCRAP_QTY, @BOM_VERSION_ID, @WO_STATUS
        ,@USER_ID, dbo.SYSDATE1(), '-', @JOB_ORDER
      )