WITH M_TABLE AS (
					   		SELECT SEGMENT1     AS USER_ID  			
									, SEGMENT2     AS MENU_ID  			
									, SEGMENT3     AS MEA_ID 		  	         													
									, SEGMENT4     AS MEA_NAME													
									, SEGMENT5     AS MEA_VALUE          
									, ATTRIBUTE1   AS TYPE                   
									, ATTRIBUTE2   AS FLAG               
									, ATTRIBUTE3   AS ACTIVE_FLAG       
					     	FROM   	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
						    WHERE  	A.LOOKUP_TYPE_CODE = 'UI_AMEND_MEASURE'
						    AND     A.SEGMENT2 = @MENU_ID
						    AND 	A.ACTIVE_FLAG = 'Y'
			   )
			 SELECT * FROM (SELECT   ISNULL(A.MEA_ID, B.MEA_ID) MEA_ID
						,ISNULL(B.MEA_NAME, A.MEA_NAME) MEA_NAME
						,ISNULL(B.MEA_VALUE, A.MEA_VALUE) MEA_VALUE
						,ISNULL(B.TYPE, A.TYPE) TYPE
						,ISNULL(B.FLAG, A.FLAG) FLAG
						,A.MENU_ID
						,@USER_ID AS USER_ID
			FROM   M_TABLE A WITH(NOLOCK)
			LEFT OUTER JOIN (
			    SELECT *
			    FROM   TH_UIS_USER_AMEND_MEA_RELATE B WITH(NOLOCK)
			    WHERE  USER_ID = @USER_ID
			    AND    MENU_ID = @MENU_ID
			    AND    ACTIVE_FLAG = 'Y'
			) B
			ON    A.MENU_ID = B.MENU_ID
			AND   A.MEA_ID  = B.MEA_ID
			AND   A.TYPE 	= B.TYPE
			WHERE 1=1
			AND   A.ACTIVE_FLAG = 'Y') B
GROUP BY MEA_ID, MEA_NAME, MEA_VALUE, TYPE, FLAG, MENU_ID, USER_ID