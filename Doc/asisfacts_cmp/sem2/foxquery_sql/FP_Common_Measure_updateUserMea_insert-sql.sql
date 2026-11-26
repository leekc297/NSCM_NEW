BEGIN
      delete from TH_UIS_USER_AMEND_MEA_RELATE WHERE
USER_ID = @USER_ID AND MENU_ID = @MENU_ID AND MEA_ID = @MEA_ID
      insert into TH_UIS_USER_AMEND_MEA_RELATE (
         USER_ID
				,MENU_ID
				,MEA_ID
				,MEA_NAME
				,MEA_VALUE
				,TYPE
				,FLAG
				,ACTIVE_FLAG
				,INSERT_ID
				,INSERT_DTTM
				,UPDATE_ID
				,UPDATE_DTTM
      ) values (
         @USER_ID
        ,@MENU_ID
        ,@MEA_ID
        ,@MEA_NAME
        ,@MEA_VALUE
        ,@TYPE
        ,@FLAG
        ,'Y'
        ,@USER_ID
        ,dbo.SYSDATE1()
        ,@USER_ID
        ,dbo.SYSDATE1()
      )
 END