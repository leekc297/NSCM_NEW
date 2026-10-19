INSERT INTO BUF_ELECTRODE_POST_PLAN_H (
					         INSTANCE_ID
									, FP_PLAN_ID
									, COMPANY_ID
									, DIVISION_ID
									, SITE_ID
									, PLANT_ID
									, FACTORY_ID
									, ELECTRODE_TYPE
									, PRODUCTION_TYPE
									, ITEM_ID
									, NP_ITEM_ID
									, ATTR_TYPE
									, CATEGORY
									, PLAN_DATE
									, IN_QTY 
									, OUT_QTY
									, IN_JR_QTY 
									, OUT_JR_QTY
									, ATTB_4
					        		, JOB_SAVE_SEQ
					        		, JOB_USER_ID, JOB_TIME, JOB_TYPE, JOB_ORDER
					      )
					      VALUES (
					         UPPER(RTRIM(LTRIM(@INSTANCE_ID))), UPPER(RTRIM(LTRIM(@FP_PLAN_ID))), UPPER(RTRIM(LTRIM(@COMPANY_ID))), UPPER(RTRIM(LTRIM(@DIVISION_ID)))
					        ,UPPER(RTRIM(LTRIM(@SITE_ID))), UPPER(RTRIM(LTRIM(@PLANT_ID))), UPPER(RTRIM(LTRIM(@FACTORY_ID)))
					        ,UPPER(RTRIM(LTRIM(@ELECTRODE_TYPE))), UPPER(RTRIM(LTRIM(@PRODUCTION_TYPE)))
					        ,UPPER(RTRIM(LTRIM(@ITEM_ID))), UPPER(RTRIM(LTRIM(@NP_ITEM_ID))), UPPER(RTRIM(LTRIM(@ATTR_TYPE)))
					        ,UPPER(RTRIM(LTRIM(@CATEGORY_ID)))
					        ,CONVERT(DATE, RTRIM(LTRIM(@PLAN_DATE)))
					        ,RTRIM(LTRIM(@IN_QTY)), RTRIM(LTRIM(@OUT_QTY))
					        ,RTRIM(LTRIM(@IN_JR_QTY)), RTRIM(LTRIM(@OUT_JR_QTY))
					        ,UPPER(RTRIM(LTRIM(@MOVING_FACTORY)))
					        ,@NEW_SEQ
					        ,@USER_ID, dbo.SYSDATE1(), '-', @JOB_ORDER
					      )