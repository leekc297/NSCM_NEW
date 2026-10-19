CREATE OR REPLACE PROCEDURE SCM_MGR."PR_GET_MENU_LIST_V2" (
    P_USER_ID   IN  VARCHAR2,
    DATA        OUT SYS_REFCURSOR
) IS
BEGIN
    -- PKG_NSCM_UI_COM_MENU.PR_GET_MENU_LIST 와 동일 + ROUTE_PATH (화면 모듈 경로) 추가
    OPEN DATA FOR
        SELECT  DISTINCT
                M.MNU_ID        AS MNU_ID
              , M.UPPR_MNU_ID   AS UPPR_MNU_ID
              , M.MNU_URL       AS MNU_URL
              , M.ROUTE_PATH    AS ROUTE_PATH
              , M.MNU_MSG_ID    AS MNU_MSG_ID
              , M.MNU_DESC      AS MNU_DESC
              , M.SORT_ORD      AS SORT_ORD
              , NVL2(B.MNU_ID, 'Y', 'N') AS BMK_YN
        FROM    SCM_ADM_MNU_M M
            INNER JOIN SCM_ADM_USER_GR_MNU_MPG_M GM
                ON  M.MNU_ID = GM.MNU_ID
            INNER JOIN SCM_ADM_USER_GR_MPG_M UG
                ON  GM.USER_GR_ID = UG.USER_GR_ID
            LEFT JOIN SCM_ADM_USER_BMK_M B
                ON  UG.USER_ID = B.USER_ID
                AND M.MNU_ID = B.MNU_ID
        WHERE   1=1
        AND     M.USE_YN  = 'Y'
        AND     UG.USE_YN = 'Y'
        AND 	GM.USE_YN= 'Y'
        AND     M.MNU_ID <> 'Popup'
        AND     M.MNU_ID NOT LIKE '%Popup'
        AND     M.MNU_TP_CD <> 'POPUP'
        AND     UG.USER_ID = P_USER_ID
        ORDER BY M.SORT_ORD ASC
        ;
END;
/
