--BEGIN
		    --    BEGIN TRAN
		    
MERGE INTO SCM_MASTER_MANAGER_M X
USING (SELECT COMPANY_ID
            , DIVISION_ID
		    , SITE_ID
		    , PLANT_ID
		    , FACTORY_ID
		    , OPERATION_ID
		    , LINE_ID 
		    , ELECTRODE_TYPE
		    , LOSS_CODE
		    , USER_ID_1
		    , USER_ID_2
		    , USER_ID_3
		    , USER_ID_4
		    , USER_ID_5
		    , USER_ID_6
		    , USER_ID_7
		    , USER_ID_8
		    , USER_ID_9
		    , USER_ID_10
		 FROM "LN_SCM_DEV".[LGCE_SCMDEV].[DBO].TEMP_CAPA_PIC 
		 GROUP BY  COMPANY_ID
            , DIVISION_ID
		    , SITE_ID
		    , PLANT_ID
		    , FACTORY_ID
		    , OPERATION_ID
		    , LINE_ID 
		    , ELECTRODE_TYPE
		    , LOSS_CODE
		    , USER_ID_1
		    , USER_ID_2
		    , USER_ID_3
		    , USER_ID_4
		    , USER_ID_5
		    , USER_ID_6
		    , USER_ID_7
		    , USER_ID_8
		    , USER_ID_9
		    , USER_ID_10
	 ) A
	ON X.LINE_ID		= A.LINE_ID
   AND X.OPERATION_ID	= A.OPERATION_ID
   AND X.ELECTRODE_TYPE = A.ELECTRODE_TYPE
   AND X.LOSS_CODE		= A.LOSS_CODE

WHEN MATCHED THEN
	 UPDATE SET 
		     X.USER_ID_1	= A.USER_ID_1
		   , X.USER_ID_2	= A.USER_ID_2
		   , X.USER_ID_3	= A.USER_ID_3
		   , X.USER_ID_4	= A.USER_ID_4
		   , X.USER_ID_5	= A.USER_ID_5
		   , X.USER_ID_6	= A.USER_ID_6
		   , X.USER_ID_7	= A.USER_ID_7
		   , X.USER_ID_8	= A.USER_ID_8
		   , X.USER_ID_9	= A.USER_ID_9
		   , X.USER_ID_10	= A.USER_ID_10 
		   , UPDATE_ID		= @USER_ID
		   , UPDATE_TIME	= SYSDATETIME()

WHEN NOT MATCHED THEN
	INSERT 
		(    COMPANY_ID
           , DIVISION_ID
		   , SITE_ID
		   , PLANT_ID
		   , FACTORY_ID
		   , OPERATION_ID
		   , LINE_ID 
		   , ELECTRODE_TYPE
		   , LOSS_CODE
		   , USER_ID_1
		   , USER_ID_2
		   , USER_ID_3
		   , USER_ID_4
		   , USER_ID_5
		   , USER_ID_6
		   , USER_ID_7
		   , USER_ID_8
		   , USER_ID_9
		   , USER_ID_10
		   , INSERT_ID
		   , INSERT_TIME
		   , UPDATE_ID
		   , UPDATE_TIME
	) VALUES
	(
	         A.COMPANY_ID
           , A.DIVISION_ID
		   , A.SITE_ID
		   , A.PLANT_ID
		   , A.FACTORY_ID
		   , A.OPERATION_ID
		   , A.LINE_ID 
		   , A.ELECTRODE_TYPE
		   , A.LOSS_CODE
		   , A.USER_ID_1
		   , A.USER_ID_2
		   , A.USER_ID_3
		   , A.USER_ID_4
		   , A.USER_ID_5
		   , A.USER_ID_6
		   , A.USER_ID_7
		   , A.USER_ID_8
		   , A.USER_ID_9
		   , A.USER_ID_10
		   , @USER_ID
		   , SYSDATETIME()
		   , @USER_ID
		   , SYSDATETIME()
	)
	;
   		      --  COMMIT;
		     -- END;