INSERT TH_UIS_ROLE_INSTANCE_RELATE (
              ROLE_ID, 
              INSTANCE_ID,
              COMPANY_ID,
              DIVISION_ID,
              SITE_ID,
              PLANT_ID,
              FACTORY_ID,
              PLAN_GROUP_ID,
              USE_AT_FLAG,
              INSERT_ID, 
              INSERT_DTTM
            )
            VALUES (
              @ROLE_ID, 
              ISNULL(@INSTANCE_ID,'-'),
              ISNULL(@COMPANY_ID,'-'),
              ISNULL(@DIVISION_ID,'-'),
              ISNULL(@SITE_ID,'-'),
              ISNULL(@PLANT_ID,'-'),
              ISNULL(@FACTORY_ID,'-'), 
              ISNULL(@PLAN_GROUP_ID,'-'), 
              CASE @USE_AT_FLAG WHEN 'True' THEN 'Y' WHEN 'Y' THEN 'Y' ELSE 'N' END,
              @USER_ID, 
              dbo.SYSDATE1()
            )