BEGIN
						
					        BEGIN TRAN
					        
					          	MERGE INTO FP_SIM_MATERIAL_PACK_R AS TGT
								USING ( SELECT    @INSTANCE_ID AS INSTANCE_ID, @SIM_PLAN_ID AS SIM_PLAN_ID, @COMPANY_ID AS COMPANY_ID, @DIVISION_ID AS DIVISION_ID, @SITE_ID AS SITE_ID, @PLANT_ID AS PLANT_ID
												, @FACTORY_ID AS FACTORY_ID, @OPERATION_ID AS OPERATION_ID, @LINE_ID AS LINE_ID, @PRODUCTION_TYPE AS PRODUCTION_TYPE
												, @MODEL_ID AS MODEL_ID, @ITEM_ID AS ITEM_ID, @CATEGORY_ID AS CATEGORY_ID 
												, CONVERT(DATE, @PLAN_DATE) AS PLAN_DATE
												, @SIM_QTY AS SIM_QTY 
												, @USER_ID AS INSERT_ID, GETDATE() AS INSERT_DTTM, @USER_ID AS UPDATE_ID, GETDATE() AS UPDATE_DTTM
												) AS  SRC
								ON ( TGT.INSTANCE_ID 		= SRC.INSTANCE_ID
								     AND TGT.SIM_PLAN_ID 	= SRC.SIM_PLAN_ID
								     AND TGT.COMPANY_ID 	= SRC.COMPANY_ID
								     AND TGT.DIVISION_ID 	= SRC.DIVISION_ID
								     AND TGT.SITE_ID 		= SRC.SITE_ID
								     AND TGT.PLANT_ID 		= SRC.PLANT_ID
								     AND TGT.FACTORY_ID 	= SRC.FACTORY_ID
								     AND TGT.OPERATION_ID 	= SRC.OPERATION_ID
								     AND TGT.LINE_ID 		= SRC.LINE_ID
								     AND TGT.PRODUCTION_TYPE = SRC.PRODUCTION_TYPE
								     AND TGT.MODEL_ID 		= SRC.MODEL_ID
								     AND TGT.ITEM_ID 		= SRC.ITEM_ID
								     AND TGT.CATEGORY_ID 	= SRC.CATEGORY_ID
								     AND TGT.PLAN_DATE 		= SRC.PLAN_DATE )
								WHEN MATCHED THEN
								  UPDATE SET TGT.SIM_QTY 		= SRC.SIM_QTY,
								  			 TGT.ATTB_05 		= 'Y',
								             TGT.UPDATE_ID 		= SRC.UPDATE_ID,
								             TGT.UPDATE_DTTM 	= SRC.UPDATE_DTTM
								WHEN NOT MATCHED THEN
								  INSERT (INSTANCE_ID,
								          SIM_PLAN_ID,
								          COMPANY_ID,
								          DIVISION_ID,
								          SITE_ID,
								          PLANT_ID,
								          FACTORY_ID,
								          OPERATION_ID,
								          LINE_ID,
								          PRODUCTION_TYPE,
								          MODEL_ID,
								          ITEM_ID,
								          CATEGORY_ID,
								          PLAN_DATE,
								          SIM_QTY,
								          PACK_MODEL_PLAN_ID ,
								          ATTB_05,
								          INSERT_ID,
								          INSERT_DTTM,
								          UPDATE_ID,
								          UPDATE_DTTM)
								  VALUES (SRC.INSTANCE_ID,
								          SRC.SIM_PLAN_ID,
								          SRC.COMPANY_ID,
								          SRC.DIVISION_ID,
								          SRC.SITE_ID,
								          SRC.PLANT_ID,
								          SRC.FACTORY_ID,
								          SRC.OPERATION_ID,
								          SRC.LINE_ID,
								          SRC.PRODUCTION_TYPE,
								          SRC.MODEL_ID,
								          SRC.ITEM_ID,
								          SRC.CATEGORY_ID,
								          SRC.PLAN_DATE,
								          SRC.SIM_QTY,
								          SRC.ITEM_ID+'_'+SRC.LINE_ID+'_'+SRC.PRODUCTION_TYPE+'_'+@PLAN_DATE,
								          'Y',
								          SRC.INSERT_ID,
								          SRC.INSERT_DTTM,
								          SRC.UPDATE_ID,
								          SRC.UPDATE_DTTM)
					          ;
					        
					        COMMIT;
					        
					        BEGIN TRAN
					            INSERT INTO HIS_SIM_MATERIAL_PACK_R (
										INSTANCE_ID,
										SIM_PLAN_ID,
										COMPANY_ID,
										DIVISION_ID,
										SITE_ID,
										PLANT_ID,
										FACTORY_ID,
										OPERATION_ID,
										LINE_ID,
										PRODUCTION_TYPE,
										MODEL_ID,
										ITEM_ID,
										CATEGORY_ID,
										PLAN_DATE,
										SIM_IN_QTY,
										SIM_QTY,
										PLAN_IN_QTY ,
										PLAN_QTY ,
										CELL_SIM_QTY ,
										MATERIAL_QTY ,
										AVAILABLE_QTY ,
										YIELD ,
										TOTAL_YIELD ,
										BOM_RATE ,
										TOP_LINE_ID ,
										PACK_MODEL_PLAN_ID ,
										ALT_ID ,
										ALT_PRIORITY ,
										ATTB_01 ,
										ATTB_02 ,
										ATTB_03 ,
										ATTB_04 ,
										ATTB_05 ,
										INSERT_ID,
										INSERT_DTTM,
										UPDATE_ID,
										UPDATE_DTTM
					                   ,JOB_USER_ID, JOB_TIME, JOB_TYPE
					            )
					            SELECT  INSTANCE_ID,
										SIM_PLAN_ID,
										COMPANY_ID,
										DIVISION_ID,
										SITE_ID,
										PLANT_ID,
										FACTORY_ID,
										OPERATION_ID,
										LINE_ID,
										PRODUCTION_TYPE,
										MODEL_ID,
										ITEM_ID,
										CATEGORY_ID,
										PLAN_DATE,
										SIM_IN_QTY,
										SIM_QTY,
										PLAN_IN_QTY ,
										PLAN_QTY ,
										CELL_SIM_QTY ,
										MATERIAL_QTY ,
										AVAILABLE_QTY ,
										YIELD ,
										TOTAL_YIELD ,
										BOM_RATE ,
										TOP_LINE_ID ,
										PACK_MODEL_PLAN_ID ,
										ALT_ID ,
										ALT_PRIORITY ,
										ATTB_01 ,
										ATTB_02 ,
										ATTB_03 ,
										ATTB_04 ,
										ATTB_05 ,
										INSERT_ID,
										INSERT_DTTM,
										UPDATE_ID,
										UPDATE_DTTM
					                   ,@USER_ID AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'UPDATE' AS JOB_TYPE
					            FROM   FP_SIM_MATERIAL_PACK_R A WITH(NOLOCK)
					            WHERE  1=1
				            	 AND A.INSTANCE_ID 	= @INSTANCE_ID
							     AND A.SIM_PLAN_ID 	= @SIM_PLAN_ID
							     AND A.COMPANY_ID 	= @COMPANY_ID
							     AND A.DIVISION_ID 	= @DIVISION_ID
							     AND A.SITE_ID 		= @SITE_ID
							     AND A.PLANT_ID 	= @PLANT_ID
							     AND A.FACTORY_ID 	= @FACTORY_ID
							     AND A.OPERATION_ID = @OPERATION_ID
							     AND A.LINE_ID 		= @LINE_ID
							     AND A.PRODUCTION_TYPE = @PRODUCTION_TYPE
							     AND A.MODEL_ID 	= @MODEL_ID
							     AND A.ITEM_ID 		= @ITEM_ID
							     AND A.CATEGORY_ID 	= @CATEGORY_ID
							     AND A.PLAN_DATE 	= CONVERT(DATE,@PLAN_DATE)
								;
					          
					        COMMIT;
					        
					        BEGIN TRAN
					        
					        	UPDATE	FP_SIM_PLAN_H
								SET		PLAN_TYPE = 'RE-SIM'
									  , UPDATE_ID = @USER_ID
									  , UPDATE_DTTM = dbo.FN_SITE_TIME(@SITE_ID)
								WHERE	1 = 1
								AND		PROGRAM_TYPE = 'PACK_SIMUL'
								AND		INSTANCE_ID = @INSTANCE_ID
								AND		SIM_PLAN_ID = @SIM_PLAN_ID
					        
					        COMMIT;
					        
					        
					END;