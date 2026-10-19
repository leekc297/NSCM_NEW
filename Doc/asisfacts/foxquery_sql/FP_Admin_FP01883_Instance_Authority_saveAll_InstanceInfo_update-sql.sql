UPDATE TH_UIS_ROLE_INSTANCE_RELATE SET
                   USE_AT_FLAG   = CASE @USE_AT_FLAG WHEN 'True' THEN 'Y' WHEN 'Y' THEN 'Y' ELSE 'N' END
                 , UPDATE_ID	   = @USER_ID
                 , UPDATE_DTTM   = dbo.SYSDATE1()
            WHERE	 ROLE_ID       = @ROLE_ID
            AND    INSTANCE_ID   = @INSTANCE_ID
            AND    COMPANY_ID    = @COMPANY_ID
            AND    DIVISION_ID   = @DIVISION_ID
            AND    SITE_ID       = @SITE_ID
            AND    PLANT_ID      = @PLANT_ID
            AND    FACTORY_ID    = @FACTORY_ID
            AND    PLAN_GROUP_ID = @PLAN_GROUP_ID