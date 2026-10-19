BEGIN
      MERGE INTO SCM_SYS_LOOKUP_VALUE AS A
	  USING (SELECT 'UI_AMEND_MEASURE' AS LOOKUP_TYPE_CODE,
	  @MENU_ID AS SEGMENT2,
	  @MEA_ID AS SEGMENT3,
	  @TYPE AS ATTRIBUTE1) AS C
	  ON A.LOOKUP_TYPE_CODE = C.LOOKUP_TYPE_CODE
	  AND A.SEGMENT2 = C.SEGMENT2
	  AND A.SEGMENT3 = C.SEGMENT3
	  AND A.ATTRIBUTE1 = C.ATTRIBUTE1
	  WHEN NOT MATCHED THEN
       insert
	    
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
       );
END