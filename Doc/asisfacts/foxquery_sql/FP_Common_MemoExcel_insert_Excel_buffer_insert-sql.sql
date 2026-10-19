BEGIN
							BEGIN TRAN
								INSERT INTO BUF_FP_AMEND_MEMO_VALIDATION (
									INSTANCE_ID
									, COMPANY_ID
									, DIVISION_ID
									, SITE_ID
									, PLANT_ID
									,FACTORY_ID
									,OPERATION_ID
									,LINE_ID
									,ELECTRODE_TYPE
									,PRODUCTION_TYPE
									, EQUIPMENT_ID
									,MARKET
									,TOP_ITEM_ID
									,ITEM_ID
									,PLAN_DATE
									,MEMO_TYPE
									,MEMO
									,ATTR1,ATTR2,ATTR3,ATTR4,ATTR5
									,insert_id, update_id
									,insert_time, update_time
									,GUID
								)
								VALUES (
									UPPER(RTRIM(LTRIM(@INSTANCE_ID)))
									, UPPER(RTRIM(LTRIM(@COMPANY_ID)))
									, UPPER(RTRIM(LTRIM(@DIVISION_ID)))
									, UPPER(RTRIM(LTRIM(@SITE_ID)))
									, UPPER(RTRIM(LTRIM(@PLANT_ID)))
									, UPPER(RTRIM(LTRIM(@FACTORY_ID)))
									, UPPER(RTRIM(LTRIM(@OPERATION_ID)))
									,UPPER(RTRIM(LTRIM(@LINE_ID)))
									,UPPER(RTRIM(LTRIM(@ELECTRODE_TYPE)))
									, UPPER(RTRIM(LTRIM(@PRODUCTION_TYPE)))
									,UPPER(RTRIM(LTRIM(@EQUIPMENT_ID)))
									, UPPER(RTRIM(LTRIM(@MARKET)))
									,UPPER(RTRIM(LTRIM(@TOP_ITEM_ID)))
									,UPPER(RTRIM(LTRIM(@ITEM_ID)))
									,CONVERT(DATE, RTRIM(LTRIM(@PLAN_DATE)))
									,UPPER(RTRIM(LTRIM(@MEMO_TYPE)))
									,UPPER(RTRIM(LTRIM(@MEMO)))
									,UPPER(RTRIM(LTRIM(@ATTR1)))
									,UPPER(RTRIM(LTRIM(@ATTR2)))
									,UPPER(RTRIM(LTRIM(@ATTR3)))
									,UPPER(RTRIM(LTRIM(@ATTR4)))
									,UPPER(RTRIM(LTRIM(@ATTR5)))
									,@USER_ID, @USER_ID
									,dbo.SYSDATE1(),dbo.SYSDATE1()
									,@GUID
								)
								;
							
							COMMIT;
						
						END;