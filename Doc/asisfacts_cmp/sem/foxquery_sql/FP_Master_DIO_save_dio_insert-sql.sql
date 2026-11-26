BEGIN
		        BEGIN TRAN
		          MERGE INTO SCM_SYS_LOOKUP_VALUE A
		          USING (	  
				  
				  					SELECT 
									@DIVISION_ID AS DIVISION_ID,
  				                    @SITE_ID AS SITE_ID,
									@ITEM_ID AS ITEM_ID
					    ) B
		          ON 1=1
				  AND A.SEGMENT1 = B.DIVISION_ID
				  AND A.SEGMENT2 = B.SITE_ID 
				  AND A.SEGMENT3 = B.ITEM_ID
				  AND A.LOOKUP_TYPE_CODE = 'MATERIAL_DIO_DAY'
		          WHEN MATCHED THEN  
		            UPDATE SET SEGMENT4 = @DIO
		                 , modify_user_id = @USER_ID, modify_date = GETDATE()
		          WHEN NOT MATCHED THEN
		            INSERT (
		               SEGMENT1, SEGMENT2,SEGMENT3, SEGMENT4, 
					   SEGMENT5, LOOKUP_TYPE_CODE
		              ,modify_user_id, modify_date
		              ,create_user_id, create_date
		            )
		            VALUES (
		               @DIVISION_ID, @SITE_ID, @ITEM_ID,@DIO,
					   '-', 'MATERIAL_DIO_DAY',
					   @USER_ID, GetDate(),
					   @USER_ID, GetDate()
		            )
		          ;
		        
		        COMMIT;
		       
		        
		      END;