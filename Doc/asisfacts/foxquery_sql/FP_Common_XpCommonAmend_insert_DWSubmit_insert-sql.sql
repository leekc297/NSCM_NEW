INSERT INTO FP_PROC_PARAMETER_H (
         CALL_SEQUENCE
        ,CONDITION_TYPE
        ,CONDITION_VALUE
        ,CONDITION_NUMERIC_VALUE
        ,INSERT_ID
        ,INSERT_TIME
        ,UPDATE_ID
        ,UPDATE_TIME
      )
      VALUES (
         @CALL_SEQUENCE
        ,@CONDITION_TYPE
        ,@CONDITION_VALUE
        ,@CONDITION_NUMERIC_VALUE
        ,@USER_ID
        ,GETDATE()
        ,@USER_ID
        ,GETDATE()
      )