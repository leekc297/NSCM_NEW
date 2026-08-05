-- PKG_DMF0068 정정본 (2026-07-29)
-- D1 PROJECT_INFO 빈문자열 비교 / D2 월 PIVOT 인용식별자 / D7 편집권한 뷰 LEFT 전환
-- + SAVE/DEL CLOB(JSON) 래퍼 신설 (기존 5 멤버 본문 무수정)
-- 적용: SQL*Plus 또는 _artifacts/_diagnostics 계열 실행기

CREATE OR REPLACE PACKAGE           "PKG_DMF0068" IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0068                                                                        */
/* Description : PKG_DMF0068                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.20  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0068_DEL_ORDERLIST
(
    P_DMF0068           IN T_DMF0068_TAB,

    O_RESULT_CURSOR     OUT SYS_REFCURSOR
);


PROCEDURE P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP
(
    P_START_YYYYMMDD    IN VARCHAR2,
    P_END_YYYYMMDD      IN VARCHAR2,
    --P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID       IN VARCHAR2,
    P_VERSION_TYPE      IN VARCHAR2,
    --P_VERSION_NO      IN VARCHAR2,
    P_DESCRIPTION       IN VARCHAR2,
    P_USER_ID           IN VARCHAR2,
    P_MENU_ID           IN VARCHAR2,

    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
);


PROCEDURE P_DMF0068_GET_LOOKUPPROJECT
(
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_USER_ID           IN VARCHAR2,
    P_MENU_ID           IN VARCHAR2,

    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0068_GET_ORDERLIST
(
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_FROMDT            IN  VARCHAR2,
    P_TODT              IN  VARCHAR2,
    P_USER_ID           IN VARCHAR2,
    P_MENU_ID           IN VARCHAR2,

    O_RC1               OUT SYS_REFCURSOR,
    O_RC2               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0068_SAVE_ORDERLIST
(
    P_DMF0068         IN  T_DMF0068_TAB,
    P_USER_ID         IN  VARCHAR2,
    P_DIVISION_ID     IN  VARCHAR2,
    P_VERSION_NO      IN  VARCHAR2,

    O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

FUNCTION F_COLLECTION_TO_JSON(p_collection IN T_DMF0068_TAB)
RETURN VARCHAR2;


--------------------------------------------------------------------------------
-- 2026-07-29 신설 : BE generic call-proc 은 컬렉션 타입 IN 을 바인딩할 수 없으므로
--                   CLOB(JSON) 을 받아 T_DMF0068_TAB 으로 변환한 뒤 기존 멤버에 위임한다.
--                   기존 멤버 본문은 1바이트도 변경하지 않는다.
--------------------------------------------------------------------------------
PROCEDURE P_DMF0068_SAVE_ORDERLIST_JSON
(
    P_DATA            IN  CLOB,
    P_USER_ID         IN  VARCHAR2,
    P_DIVISION_ID     IN  VARCHAR2,
    P_VERSION_NO      IN  VARCHAR2,

    O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0068_DEL_ORDERLIST_JSON
(
    P_DATA            IN  CLOB,

    O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

END PKG_DMF0068;
/
