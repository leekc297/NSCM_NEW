CREATE OR REPLACE PROCEDURE SCM_MGR."PR_GET_MENU_LIST_V2" (
    P_USER_ID   IN  VARCHAR2,
    DATA        OUT SYS_REFCURSOR
) IS
BEGIN
    -- PKG_NSCM_UI_COM_MENU.PR_GET_MENU_LIST 와 동일 + ROUTE_PATH (화면 모듈 경로) 추가
    --[E20260915-MENUEMPTY] 하위에 실제 사용 화면이 없는 폴더(MENU)는 반환하지 않는다 (사용자 지시 2026-09-15:
    --  "실제 사용하지 않는 메뉴는 대상에서 원천 배제 / 하위에 실제 메뉴가 없으면 메뉴 TREE 도 보이지 않도록").
    --  권한 판정(그룹 매핑·USE_YN·POPUP 제외)은 종전과 동일하고, 폴더 노출 조건만 추가했다.
    OPEN DATA FOR
        WITH AUTH_MNU AS (
            -- ① 사용자 권한 메뉴 = 기존 조건 그대로 (그룹 매핑 · USE_YN · POPUP 제외)
            SELECT  DISTINCT
                    M.MNU_ID
                  , M.UPPR_MNU_ID
                  , M.MNU_URL
                  , M.ROUTE_PATH
                  , M.MNU_MSG_ID
                  , M.MNU_DESC
                  , M.SORT_ORD
                  , M.MNU_TP_CD
            FROM    SCM_ADM_MNU_M M
                INNER JOIN SCM_ADM_USER_GR_MNU_MPG_M GM
                    ON  M.MNU_ID = GM.MNU_ID
                INNER JOIN SCM_ADM_USER_GR_MPG_M UG
                    ON  GM.USER_GR_ID = UG.USER_GR_ID
            WHERE   1=1
            AND     M.USE_YN  = 'Y'
            AND     UG.USE_YN = 'Y'
            AND     GM.USE_YN = 'Y'
            AND     M.MNU_ID <> 'Popup'
            AND     M.MNU_ID NOT LIKE '%Popup'
            AND     M.MNU_TP_CD <> 'POPUP'
            AND     UG.USER_ID = P_USER_ID
        )
        , USED_FOLDER AS (
            -- ② [E20260915-MENUEMPTY] 실제 사용 화면(권한 SCREEN)의 상위 폴더 체인 전체.
            --    이 체인에 없는 폴더 = 하위에 쓸 수 있는 화면이 없는 폴더 → 메뉴 트리에서 원천 배제.
            --    (예: 그룹에 Admin/System 폴더만 매핑되고 하위 화면 매핑이 0 → Admin 트리 전체 미노출)
            SELECT  DISTINCT P.MNU_ID
            FROM    SCM_ADM_MNU_M P
            START WITH P.MNU_ID IN (SELECT A.UPPR_MNU_ID FROM AUTH_MNU A WHERE A.MNU_TP_CD = 'SCREEN')
            CONNECT BY NOCYCLE P.MNU_ID = PRIOR P.UPPR_MNU_ID
        )
        SELECT  A.MNU_ID        AS MNU_ID
              , A.UPPR_MNU_ID   AS UPPR_MNU_ID
              , A.MNU_URL       AS MNU_URL
              , A.ROUTE_PATH    AS ROUTE_PATH
              , A.MNU_MSG_ID    AS MNU_MSG_ID
              , A.MNU_DESC      AS MNU_DESC
              , A.SORT_ORD      AS SORT_ORD
              , NVL2(B.MNU_ID, 'Y', 'N') AS BMK_YN
        FROM    AUTH_MNU A
            LEFT JOIN SCM_ADM_USER_BMK_M B
                ON  B.USER_ID = P_USER_ID
                AND B.MNU_ID  = A.MNU_ID
        WHERE   A.MNU_TP_CD <> 'MENU'
        OR      A.MNU_ID IN (SELECT F.MNU_ID FROM USED_FOLDER F)
        ORDER BY A.SORT_ORD ASC
        ;
END;
/
