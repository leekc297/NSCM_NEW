BEGIN
		        BEGIN TRAN
		          MERGE INTO FP_AMEND_PIC_ALARM A
		          USING (	  
				  SELECT @PIC_REF as pic_ref, @P_user_id AS userID
					) B
					ON A.PIC_REF = B.PIC_REF AND A.USERID = B.USERID

		          WHEN MATCHED THEN
		            UPDATE SET EMAIL = @EMAIL
		                 , PHONE = @PHONE, DEPT_NAME=@DEPT_NAME,USER_NAME=@USER_NAME, INSERT_TIME =GETDATE()
		                 
		          WHEN NOT MATCHED THEN
		            INSERT (
		               PIC_REF
		              ,USERID
		              ,EMAIL
					  ,PHONE
					  ,DEPT_NAME
					  ,USER_NAME
					  ,INSERT_ID
					  ,INSERT_TIME

		            )
		            VALUES (
		               @PIC_REF
		              ,@P_USER_ID
		              ,@EMAIL
					  ,@PHONE
					  ,@DEPT_NAME
					  ,@USER_NAME
					  ,@USER_ID
					  ,GETDATE())		        
					  ;
		        COMMIT;
		        
		        BEGIN TRAN
		            INSERT INTO HIS_AMEND_PIC_ALARM (
		               PIC_REF
		              ,USERID
		              ,EMAIL
					  ,PHONE
					  ,DEPT_NAME
					  ,USER_NAME
					  ,INSERT_ID
					  ,INSERT_TIME
		            )
		            VALUES(  @PIC_REF
		              ,@P_USER_ID
		              ,@EMAIL
					  ,@PHONE
					  ,@DEPT_NAME
					  ,@USER_NAME
					  ,@USER_ID
					  ,GetDate()
					  )
		            
		          
		        COMMIT;
		        
		      END;