PROCEDURE           "PR_SCM_ADM_DEPT_CHANGED_AUTH_SYNC" 
/* ============================================================
 * Program ID   : PR_SCM_ADM_FP_AUTH_SYNC
 * Description  : FP 권한과 SCM 권한 동기화
 * Program History
 *------------------------------------------------------------
 *   Date         In Charge      Description
 *------------------------------------------------------------
 * 2023.03.20     FP Pjt.        FP 권한과 SCM 권한 동기화
 * 2023.04.24     FP Pjt.        EE 사업부 추가
 * 2026.07.06     ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    V_USER_ID       VARCHAR2(30 CHAR);    /* 사용자ID */
    V_USER_NAME     VARCHAR2(150 CHAR);   /* 사용자명 */
    V_REMAIN_DAY    VARCHAR2(30 CHAR);    /* 권한회수까지 남은 일수 */
    V_DBNAME        VARCHAR2(50 CHAR);

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_SCM_ADM_DEPT_CHANGED_AUTH_SYNC';
    V_LOG_TYPE      VARCHAR2(30 CHAR);    /* START/END/ERROR/... */
    N_LOG_COUNT     NUMBER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE;

    T_GROUP_ID      VARCHAR2(20 CHAR);
    T_DIVISION_ID   VARCHAR2(30 CHAR);
BEGIN

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* fp 권한 없는 scm 권한 delete */
    DELETE
/* 2026.09.30 AJS 수정 (START) */
--      FROM TB_FX_USERGROUPAUTHEXTENTION E
--     WHERE E.GROUPID IN ('FP Viewer', 'FP Planner')
--       AND E.CODE NOT LIKE 'EE%'
      FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M E
     WHERE E.USER_GR_ID IN ('FP Viewer', 'FP Planner')
       AND E.UNIT_ID NOT LIKE 'EE%'
/* 2026.09.30 AJS 수정 (END) */
       AND NOT EXISTS (SELECT 1
                         FROM TH_UIS_USER_INSTANCE_RELATE_SN UIR
                            , TH_UIS_ROLE_INSTANCE_SN RI
                            , TH_UIS_ROLE_INSTANCE_RELATE_SN RIR
                            , SCM_FACTORY_M_SN F
                        WHERE UIR.ROLE_ID = RI.ROLE_ID
                          AND RIR.ROLE_ID = RI.ROLE_ID
                          AND RIR.COMPANY_ID = F.COMPANY_ID
                          AND RIR.FACTORY_ID = F.FACTORY_ID
                          AND UIR.USE_AT_FLAG = 'Y'
                          AND RIR.USE_AT_FLAG = 'Y'
/* 2026.09.30 AJS 수정 (START) */
--                          AND UIR.USER_ID = E.USERID
--                          AND UIR.SAVE_FLAG = CASE WHEN E.GROUPID = 'FP Planner' THEN 'Y' ELSE 'N' END
--                          AND RIR.DIVISION_ID = E.CODE);
                          AND UIR.USER_ID = E.USER_ID
                          AND UIR.SAVE_FLAG = CASE WHEN E.USER_GR_ID = 'FP Planner' THEN 'Y' ELSE 'N' END
                          AND RIR.DIVISION_ID = E.UNIT_ID);
/* 2026.09.30 AJS 수정 (END) */

    /* EE 사업부 삭제 */
    DELETE
/* 2026.09.30 AJS 수정 (START) */
--      FROM TB_FX_USERGROUPAUTHEXTENTION E
--     WHERE E.GROUPID IN ('FP Viewer', 'FP Planner')
--       AND E.CODE LIKE 'EE%'
      FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M E
     WHERE E.USER_GR_ID IN ('FP Viewer', 'FP Planner')
       AND E.UNIT_ID LIKE 'EE%'
/* 2026.09.30 AJS 수정 (END) */
       AND NOT EXISTS (SELECT 1
                         FROM TH_UIS_USER_INSTANCE_RELATE_SN UIR
                            , TH_UIS_ROLE_INSTANCE_SN RI
                            , TH_UIS_ROLE_INSTANCE_RELATE_SN RIR
                            , SCM_FACTORY_M_SN F
                        WHERE UIR.ROLE_ID = RI.ROLE_ID
                          AND RIR.ROLE_ID = RI.ROLE_ID
                          AND RIR.COMPANY_ID = F.COMPANY_ID
                          AND RIR.FACTORY_ID = F.FACTORY_ID
                          AND UIR.USE_AT_FLAG = 'Y'
                          AND RIR.USE_AT_FLAG = 'Y'
                          AND F.SHOP_GROUP_ID = 'E'
/* 2026.09.30 AJS 수정 (START) */
--                          AND UIR.USER_ID = E.USERID
--                          AND UIR.SAVE_FLAG = CASE WHEN E.GROUPID = 'FP Planner' THEN 'Y' ELSE 'N' END
                          AND UIR.USER_ID = E.USER_ID
                          AND UIR.SAVE_FLAG = CASE WHEN E.USER_GR_ID = 'FP Planner' THEN 'Y' ELSE 'N' END
/* 2026.09.30 AJS 수정 (END) */
                          AND CASE WHEN F.SHOP_GROUP_ID = 'E' THEN (CASE WHEN F.DIVISION_ID IN ('40', '81', '82') THEN 'EE' ELSE 'EE' || SUBSTR(F.DIVISION_ID, 3, 3) END)
/* 2026.09.30 AJS 수정 (START) */
--                                   ELSE RIR.DIVISION_ID END = E.CODE);
                                   ELSE RIR.DIVISION_ID END = E.UNIT_ID);
/* 2026.09.30 AJS 수정 (END) */


/* 2026.09.30 AJS 수정 (START) */
--    UPDATE TB_FX_USERGROUPINFO UG
--       SET UG.USEYN          = 'N'
--         , UG.UPDATEUSERID   = 'scm_batch'
--         , UG.UPDATEDATETIME = SYSDATE
--     WHERE UG.GROUPID IN ('FP Viewer', 'FP Planner')
--       AND UG.USEYN = 'Y'
    UPDATE SCM_ADM_USER_GR_MPG_M UG
       SET UG.USE_YN         = 'N'
         , UG.LAST_UPDATED_BY   = 'scm_batch'
         , UG.LAST_UPDATE_DATE = SYSDATE
     WHERE UG.USER_GR_ID IN ('FP Viewer', 'FP Planner')
       AND UG.USE_YN = 'Y'
/* 2026.09.30 AJS 수정 (END) */
       AND NOT EXISTS (SELECT 1
/* 2026.09.30 AJS 수정 (START) */
--                         FROM TB_FX_USERGROUPAUTHEXTENTION X
--                        WHERE X.USERID = UG.USERID
--                          AND X.GROUPID = UG.GROUPID);
                         FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M X
                        WHERE X.USER_ID = UG.USER_ID
                          AND X.USER_GR_ID = UG.USER_GR_ID);
/* 2026.09.30 AJS 수정 (END) */


    UPDATE SCM_MST_AUTH_REQUEST R
       SET R.APPROVAL_RESULT  = 'REJECT'
         , R.REJECT_REASON    = 'DEPT_CHANGED_AUTH_DELETE'
         , R.LAST_UPDATED_BY  = 'scm_batch'
         , R.LAST_UPDATE_DATE = SYSDATE
     WHERE R.GROUP_ID IN ('FP Viewer', 'FP Planner')
       AND R.APPROVAL_RESULT != 'REJECT'
       AND NOT EXISTS (SELECT 1
                         FROM TH_UIS_USER_INSTANCE_RELATE_SN UIR
                            , TH_UIS_ROLE_INSTANCE_SN RI
                            , TH_UIS_ROLE_INSTANCE_RELATE_SN RIR
                        WHERE UIR.ROLE_ID = RI.ROLE_ID
                          AND RIR.ROLE_ID = RI.ROLE_ID
                          AND UIR.USE_AT_FLAG = 'Y'
                          AND RIR.USE_AT_FLAG = 'Y'
                          AND UIR.USER_ID = R.USER_ID
                          AND UIR.SAVE_FLAG = CASE WHEN R.GROUP_ID = 'FP Planner' THEN 'Y' ELSE 'N' END
                          AND RIR.DIVISION_ID = R.DIVISION_ID);

    /* fp권한 있는데 scm 권한 없을 경우 insert */

    INSERT
/* 2026.09.30 AJS 수정 (START) */
--      INTO TB_FX_USERGROUPAUTHEXTENTION
--         ( GROUPID
--         , USERID
--         , AUTHTYPE
--         , CODE
--         , PRNTCODE
--         , REGTUSERID
--         , REGTDATETIME
--         , UPDATEUSERID
--         , UPDATEDATETIME
--         , JV_PLANT_ID )
      INTO SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
         ( USER_GR_ID
         , USER_ID
         , UNIT_TP_CD
         , UNIT_ID
         , UPPR_UNIT_ID
         , EDIT_YN
         , USE_YN
         , CREATED_BY
         , CREATION_DATE
         , LAST_UPDATED_BY
         , LAST_UPDATE_DATE )
/* 2026.09.30 AJS 수정 (END) */
    SELECT X.GROUPID
         , X.USERID
         , 'D'
/* 2026.09.30 AJS 수정 (START) */
--         , X.CODE
--         , '-'
         , X.CODE
         , '/'
         , CASE WHEN UPPER(X.GROUPID) LIKE '%VIEWER%' THEN 'N' ELSE 'Y' END   /* EDIT_YN : TO-BE 신설 필수 칸 */
         , 'Y'   /* USE_YN : TO-BE 신설 필수 칸 */
/* 2026.09.30 AJS 수정 (END) */
         , 'scm_batch'
         , SYSDATE
         , 'scm_batch'
         , SYSDATE
/* 2026.09.30 AJS 수정 (START) */
--         , ''
/* 2026.09.30 AJS 수정 (END) */
      FROM (SELECT DISTINCT UIR.USER_ID AS USERID
                 , CASE WHEN UIR.SAVE_FLAG = 'Y' THEN 'FP Planner' ELSE 'FP Viewer' END AS GROUPID
                 , RIR.DIVISION_ID AS CODE
              FROM TH_UIS_USER_INSTANCE_RELATE_SN UIR
                 , TH_UIS_ROLE_INSTANCE_SN RI
                 , TH_UIS_ROLE_INSTANCE_RELATE_SN RIR
                 , SCM_FACTORY_M_SN F
             WHERE UIR.ROLE_ID = RI.ROLE_ID
               AND RIR.ROLE_ID = RI.ROLE_ID
               AND RIR.COMPANY_ID = F.COMPANY_ID
               AND RIR.FACTORY_ID = F.FACTORY_ID
               AND UIR.USE_AT_FLAG = 'Y'
               AND RIR.USE_AT_FLAG = 'Y') X
/* 2026.09.30 AJS 수정 (START) */
--         , TB_FX_USERGROUPINFO UG
--         , TB_FX_USERGROUPAUTHEXTENTION UGA
--     WHERE X.USERID = UG.USERID
--       AND X.GROUPID = UG.GROUPID
--       AND X.USERID = UGA.USERID(+)
--       AND X.GROUPID = UGA.GROUPID(+)
--       AND X.CODE = UGA.CODE(+)
--       AND UGA.GROUPID IS NULL;
         , SCM_ADM_USER_GR_MPG_M UG
         , SCM_ADM_USER_GR_UNIT_AUTH_MPG_M UGA
     WHERE X.USERID = UG.USER_ID
       AND X.GROUPID = UG.USER_GR_ID
       AND X.USERID = UGA.USER_ID(+)
       AND X.GROUPID = UGA.USER_GR_ID(+)
       AND X.CODE = UGA.UNIT_ID(+)
       AND UGA.USER_GR_ID IS NULL;
/* 2026.09.30 AJS 수정 (END) */

    /* EE 사업부 추가 */
    INSERT
/* 2026.09.30 AJS 수정 (START) */
--      INTO TB_FX_USERGROUPAUTHEXTENTION
--         ( GROUPID
--         , USERID
--         , AUTHTYPE
--         , CODE
--         , PRNTCODE
--         , REGTUSERID
--         , REGTDATETIME
--         , UPDATEUSERID
--         , UPDATEDATETIME
--         , JV_PLANT_ID )
      INTO SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
         ( USER_GR_ID
         , USER_ID
         , UNIT_TP_CD
         , UNIT_ID
         , UPPR_UNIT_ID
         , EDIT_YN
         , USE_YN
         , CREATED_BY
         , CREATION_DATE
         , LAST_UPDATED_BY
         , LAST_UPDATE_DATE )
/* 2026.09.30 AJS 수정 (END) */
    SELECT X.GROUPID
         , X.USERID
         , 'D'
/* 2026.09.30 AJS 수정 (START) */
--         , X.CODE
--         , '-'
         , X.CODE
         , '/'
         , CASE WHEN UPPER(X.GROUPID) LIKE '%VIEWER%' THEN 'N' ELSE 'Y' END   /* EDIT_YN : TO-BE 신설 필수 칸 */
         , 'Y'   /* USE_YN : TO-BE 신설 필수 칸 */
/* 2026.09.30 AJS 수정 (END) */
         , 'scm_batch'
         , SYSDATE
         , 'scm_batch'
         , SYSDATE
/* 2026.09.30 AJS 수정 (START) */
--         , ''
/* 2026.09.30 AJS 수정 (END) */
      FROM (SELECT DISTINCT UIR.USER_ID AS USERID
                 , CASE WHEN UIR.SAVE_FLAG = 'Y' THEN 'FP Planner' ELSE 'FP Viewer' END AS GROUPID
                 , CASE WHEN F.SHOP_GROUP_ID = 'E' THEN (CASE WHEN F.DIVISION_ID IN ('40', '81', '82') THEN 'EE' ELSE 'EE' || SUBSTR(F.DIVISION_ID, 3, 3) END)
                        ELSE RIR.DIVISION_ID END AS CODE
              FROM TH_UIS_USER_INSTANCE_RELATE_SN UIR
                 , TH_UIS_ROLE_INSTANCE_SN RI
                 , TH_UIS_ROLE_INSTANCE_RELATE_SN RIR
                 , SCM_FACTORY_M_SN F
             WHERE UIR.ROLE_ID = RI.ROLE_ID
               AND RIR.ROLE_ID = RI.ROLE_ID
               AND RIR.COMPANY_ID = F.COMPANY_ID
               AND RIR.FACTORY_ID = F.FACTORY_ID
               AND UIR.USE_AT_FLAG = 'Y'
               AND RIR.USE_AT_FLAG = 'Y'
               AND F.SHOP_GROUP_ID = 'E') X    /* 전극만 추가 */
/* 2026.09.30 AJS 수정 (START) */
--         , TB_FX_USERGROUPINFO UG
--         , TB_FX_USERGROUPAUTHEXTENTION UGA
--     WHERE X.USERID = UG.USERID
--       AND X.GROUPID = UG.GROUPID
--       AND X.USERID = UGA.USERID(+)
--       AND X.GROUPID = UGA.GROUPID(+)
--       AND X.CODE = UGA.CODE(+)
--       AND UGA.GROUPID IS NULL;
         , SCM_ADM_USER_GR_MPG_M UG
         , SCM_ADM_USER_GR_UNIT_AUTH_MPG_M UGA
     WHERE X.USERID = UG.USER_ID
       AND X.GROUPID = UG.USER_GR_ID
       AND X.USERID = UGA.USER_ID(+)
       AND X.GROUPID = UGA.USER_GR_ID(+)
       AND X.CODE = UGA.UNIT_ID(+)
       AND UGA.USER_GR_ID IS NULL;
/* 2026.09.30 AJS 수정 (END) */


/* 2026.09.30 AJS 수정 (START) */
--    UPDATE TB_FX_USERGROUPINFO UG
--       SET UG.USEYN          = 'Y'
--         , UG.UPDATEUSERID   = 'scm_batch'
--         , UG.UPDATEDATETIME = SYSDATE
--     WHERE UG.GROUPID IN ('FP Viewer', 'FP Planner')
--       AND UG.USEYN = 'N'
    UPDATE SCM_ADM_USER_GR_MPG_M UG
       SET UG.USE_YN         = 'Y'
         , UG.LAST_UPDATED_BY   = 'scm_batch'
         , UG.LAST_UPDATE_DATE = SYSDATE
     WHERE UG.USER_GR_ID IN ('FP Viewer', 'FP Planner')
       AND UG.USE_YN = 'N'
/* 2026.09.30 AJS 수정 (END) */
       AND EXISTS (SELECT 1
/* 2026.09.30 AJS 수정 (START) */
--                     FROM TB_FX_USERGROUPAUTHEXTENTION X
--                    WHERE X.USERID = UG.USERID
--                      AND X.GROUPID = UG.GROUPID);
                     FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M X
                    WHERE X.USER_ID = UG.USER_ID
                      AND X.USER_GR_ID = UG.USER_GR_ID);
/* 2026.09.30 AJS 수정 (END) */

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        /* SQLERRM 은 정적 INSERT VALUES 에 직접 쓰면 ORA-00984 → 변수에 먼저 담음 */
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := SUBSTR(V_PROGRAM_NAME || 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
        INSERT
          INTO SCM_SYS_LOG_BATCH
             ( PROGRAM_NAME
             , LOG_TYPE
             , LOG_COUNT
             , LOG_MESSAGE
             , DESCRIPTION
             , EVENT_DATE
             , CREATION_DATE
             , CREATED_BY
             , LAST_UPDATE_DATE
             , LAST_UPDATED_BY )
        VALUES ( V_PROGRAM_NAME
             , 'ERROR'
             , NULL
             , V_LOG_MESSAGE
             , V_DESCRIPTION
             , SYSDATE
             , SYSDATE
             , V_PROGRAM_NAME
             , SYSDATE
             , V_PROGRAM_NAME );
        COMMIT;
        /*         *   SELECT 'F' AS result_code;
         *   SELECT '[' + CONVERT(nvarchar(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE(); */
END;