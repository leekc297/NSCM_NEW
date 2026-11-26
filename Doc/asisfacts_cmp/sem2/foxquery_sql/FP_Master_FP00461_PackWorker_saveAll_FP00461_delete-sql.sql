BEGIN
								
								INSERT INTO HIS_PACK_WORKER_M
								(COMPANY_ID
								 ,DIVISION_ID
								 ,SITE_ID
								 ,PLANT_ID
								 ,FACTORY_ID
								 ,ITEM_ID
								 ,OPERATION_ID
								 ,LINE_ID
								 ,WORKER_QTY
								 ,INSERT_ID
								 ,INSERT_TIME
								 ,UPDATE_ID
								 ,UPDATE_TIME
								 ,JOB_USER_ID, JOB_TIME, JOB_TYPE)
								SELECT COMPANY_ID
								 ,DIVISION_ID
								 ,SITE_ID
								 ,PLANT_ID
								 ,FACTORY_ID
								 ,ITEM_ID
								 ,OPERATION_ID
								 ,LINE_ID
								 ,WORKER_QTY
								 ,INSERT_ID
								 ,INSERT_TIME
								 ,UPDATE_ID
								 ,UPDATE_TIME
								 ,@USER_ID, dbo.SYSDATE1(), 'DELETE'
								FROM SCM_PACK_WORKER_M(NOLOCK)
								WHERE COMPANY_ID = @COMPANY_ID
								AND   DIVISION_ID = @DIVISION_ID
								AND   SITE_ID = @SITE_ID
								AND   PLANT_ID = @PLANT_ID
								AND   FACTORY_ID = @FACTORY_ID
								AND   OPERATION_ID = @OPERATION_ID
								AND   LINE_ID = @LINE_ID
								AND   ITEM_ID = @ITEM_ID
								;
								
								DELETE FROM SCM_PACK_WORKER_M
								WHERE COMPANY_ID = @COMPANY_ID
								AND   DIVISION_ID = @DIVISION_ID
								AND   SITE_ID = @SITE_ID
								AND   PLANT_ID = @PLANT_ID
								AND   FACTORY_ID = @FACTORY_ID
								AND   OPERATION_ID = @OPERATION_ID
								AND   LINE_ID = @LINE_ID
								AND   ITEM_ID = @ITEM_ID
								;
								
								END;