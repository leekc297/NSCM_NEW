BEGIN
       delete from SCM_SYS_LOOKUP_VALUE
       WHERE LOOKUP_TYPE_CODE = 'UI_AMEND_MEASURE'
           AND SEGMENT2 = @MENU_ID
           AND SEGMENT3 = @MEA_ID
           AND ATTRIBUTE1 = @TYPE
       insert into SCM_SYS_LOOKUP_VALUE 
	    
	  (
         LOOKUP_TYPE_CODE--
         ,SEGMENT1
				,SEGMENT2
				,SEGMENT3
				,SEGMENT4
				,SEGMENT5

				,ACTIVE_FLAG--

        ,CREATE_USER_ID--
        ,CREATE_DATE--
        ,MODIFY_USER_ID--
        ,MODIFY_DATE--

        ,ATTRIBUTE1--
				,ATTRIBUTE2--
				,ATTRIBUTE3--
			) values (
        N'UI_AMEND_MEASURE'--
        
        ,N'-'--
        ,@MENU_ID--
        ,@MEA_ID--
        ,@MEA_NAME--
        ,N'true'--
        
        ,N'Y'--
        
        ,@USER_ID--
        ,dbo.SYSDATE1()--
        ,@USER_ID--
        ,dbo.SYSDATE1()--
        
        ,@TYPE--
        ,@FLAG--
        ,'Y'--
       )
END