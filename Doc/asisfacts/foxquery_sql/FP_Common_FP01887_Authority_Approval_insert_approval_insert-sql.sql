UPDATE A SET
               APPROVAL_FLAG   = 'Y'
             , APPROVAL_ID     = @USER_ID
             , APPROVAL_TIME   = GETDATE()
             , DESCRIPTION     = @DESCRIPTION
        FROM   FP_AUTH_REQUEST_INFO_M A
        WHERE  A._SEQ          = @SEQ
        AND    A.DIVISION_ID   = @ORG_DIVISION_ID
        AND    A.PLANT_ID      = @ORG_PLANT_ID
        AND    A.INSTANCE_ID   = @ORG_INSTANCE_ID
        AND    A.FACTORY_ID    = @ORG_FACTORY_ID
        AND    A.PLAN_GROUP_ID = @ORG_PLAN_GROUP_ID
        ;

      -- instance authority
        UPDATE C SET
               USE_AT_FLAG = 'Y'
             , SAVE_FLAG   = (CASE WHEN @MENU_AUTHORITY_ID = 'PLANNER' THEN 'Y' WHEN @MENU_AUTHORITY_ID = 'VIEWER' THEN 'N' ELSE 'N' END)
             , UPDATE_ID   = @USER_ID
             , UPDATE_DTTM = GETDATE()
        FROM   TH_UIS_ROLE_INSTANCE_RELATE A, TH_UIS_ROLE_INSTANCE B, TH_UIS_USER_INSTANCE_RELATE C
        WHERE  A.ROLE_ID = B.ROLE_ID
        AND    A.ROLE_ID = C.ROLE_ID
        AND    B.APPROVAL_EXCEPTION_FLAG = 'Y'
        AND    A.INSTANCE_ID   = @ORG_INSTANCE_ID
        AND    A.DIVISION_ID   = @ORG_DIVISION_ID
        AND    A.PLANT_ID      = @ORG_PLANT_ID
        AND    A.FACTORY_ID    = @ORG_FACTORY_ID
        AND    A.PLAN_GROUP_ID = @ORG_PLAN_GROUP_ID
        AND    C.USER_ID       = @NEW_USER_ID
        ;

        INSERT INTO TH_UIS_USER_INSTANCE_RELATE (
            USER_ID, ROLE_ID, USE_AT_FLAG
          , INSERT_ID, INSERT_DTTM
          , UPDATE_ID, UPDATE_DTTM
          , SAVE_FLAG
        )
        SELECT A.USER_ID, (
                 SELECT MAX(A.ROLE_ID)
                 FROM   TH_UIS_ROLE_INSTANCE_RELATE A, TH_UIS_ROLE_INSTANCE B
                 WHERE  A.ROLE_ID = B.ROLE_ID
                 AND    B.APPROVAL_EXCEPTION_FLAG = 'Y'
                  AND    A.INSTANCE_ID   = @ORG_INSTANCE_ID
                  AND    A.DIVISION_ID   = @ORG_DIVISION_ID
                  AND    A.PLANT_ID      = @ORG_PLANT_ID
                  AND    A.FACTORY_ID    = @ORG_FACTORY_ID
                  AND    A.PLAN_GROUP_ID = @ORG_PLAN_GROUP_ID
              ) AS ROLE_ID
              , 'Y' AS USE_AT_FLAG
              , @USER_ID AS INSERT_ID
              , GETDATE() AS INSER_DTTM
              , NULL AS UPDATE_ID
              , NULL AS UPDATE_DTTM
              , A.SAVE_FLAG
        FROM (
          SELECT @ORG_INSTANCE_ID AS INSTANCE_ID, @ORG_DIVISION_ID AS DIVISION_ID, @ORG_PLANT_ID AS PLANT_ID, @ORG_FACTORY_ID AS FACTORY_ID, @ORG_PLAN_GROUP_ID AS PLAN_GROUP_ID, @NEW_USER_ID AS USER_ID
               , (CASE WHEN @MENU_AUTHORITY_ID = 'PLANNER' THEN 'Y' WHEN @MENU_AUTHORITY_ID = 'VIEWER' THEN 'N' ELSE 'N' END) AS SAVE_FLAG
        ) A
        WHERE NOT EXISTS (
          SELECT 1
          FROM   TH_UIS_ROLE_INSTANCE_RELATE AA, TH_UIS_ROLE_INSTANCE BB, TH_UIS_USER_INSTANCE_RELATE CC
          WHERE  AA.ROLE_ID = BB.ROLE_ID
          AND    AA.ROLE_ID = CC.ROLE_ID
          AND    BB.APPROVAL_EXCEPTION_FLAG = 'Y'
          AND    AA.INSTANCE_ID   = A.INSTANCE_ID
          AND    AA.DIVISION_ID   = A.DIVISION_ID
          AND    AA.PLANT_ID      = A.PLANT_ID
          AND    AA.FACTORY_ID    = A.FACTORY_ID
          AND    AA.PLAN_GROUP_ID = A.PLAN_GROUP_ID
          AND    CC.USER_ID       = A.USER_ID	
        )
        ;