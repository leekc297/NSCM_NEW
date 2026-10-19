DELETE FROM TH_UIS_ROLE_INSTANCE_RELATE
            WHERE	 ROLE_ID       = @ROLE_ID
            AND    INSTANCE_ID   = @INSTANCE_ID
            AND    COMPANY_ID    = @COMPANY_ID
            AND    DIVISION_ID   = @DIVISION_ID
            AND    SITE_ID       = @SITE_ID
            AND    PLANT_ID      = @PLANT_ID
            AND    FACTORY_ID    = @FACTORY_ID
            AND    PLAN_GROUP_ID = @PLAN_GROUP_ID