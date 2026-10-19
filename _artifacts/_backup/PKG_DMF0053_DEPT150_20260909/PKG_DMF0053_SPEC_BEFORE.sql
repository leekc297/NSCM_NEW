PACKAGE         PKG_DMF0053 AS

    -- 그리드 머리글(기간 컬럼) 조회.
    --   사용자별 컬럼 설정(SCM_MST_TITLESET_USER 구분값 'C')이 있으면 그것을, 없으면 컬럼 메타의
    --   DEFAULT_FLAG='Y' 를 쓴다. 여기에 달력에서 만든 기간 컬럼(D_/W_/M_)을 붙여 돌려준다.
    --   본문 프로시저와 달리 사업부 조건이 걸려 있다 — 40 은 14 · 81 계열 20 · 82 는 18.
    PROCEDURE P_DMF0053_GET_SPREAD_TITLE
    (
        P_START_YYYYMMDD    IN  VARCHAR2,
        P_END_YYYYMMDD      IN  VARCHAR2,
        P_CREATED_BY        IN  VARCHAR2,
        P_DIVISION_ID       IN  VARCHAR2,
        P_BUCKET            IN  VARCHAR2,
        P_USER_ID           IN  VARCHAR2,
        P_MENU_ID           IN  VARCHAR2,

        O_RC1               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );


    -- 본문(그리드 데이터) 조회.
    --   원장 DM_PLN_CUST_FCST_H 를 조회조건으로 추리고, 사용자가 고른 Measure 로 펼친 뒤
    --   기간(D_/W_/M_)으로 피벗해 돌려준다. 결과셋 3개다.
    --     O_RC1 : 피벗된 본문
    --     O_RC2 : 오늘의 ISO 주차와 기준일
    --     O_RC3 : 화면이 그대로 적용할 정렬 문자열
    PROCEDURE P_DMF0053_GET_CUST_FCST_WATERFALL
    (
        P_DIVISION_ID       IN  VARCHAR2,
        P_DEPT_ID           IN  VARCHAR2,
        P_END_CUSTOMER      IN  VARCHAR2,
        P_SCM_SITE_ID       IN  VARCHAR2,
        P_PROJECT_CODE      IN  VARCHAR2,
        P_ITEM_ID           IN  VARCHAR2,
        P_ITEM_TYPE         IN  VARCHAR2,
        P_FROM_YYYYMMDD     IN  VARCHAR2,
        P_TO_YYYYMMDD       IN  VARCHAR2,
        P_CREATED_BY        IN  VARCHAR2,
        P_PLANT_SITE_ID     IN  VARCHAR2,
        P_BIZ_TYPE          IN  VARCHAR2,
        P_OWNER             IN  VARCHAR2,
        P_BUCKET            IN  VARCHAR2,
        P_USER_DEPT_ID      IN  VARCHAR2,   /* AS-IS 도 본문에서 쓰지 않는다 */
        P_GROUP_ID          IN  VARCHAR2,   /* AS-IS 도 본문에서 쓰지 않는다 */
        P_VERSION_NO        IN  VARCHAR2,   /* AS-IS 도 본문에서 쓰지 않는다 */
        P_FROM_CREATEDATE   IN  VARCHAR2,
        P_TO_CREATEDATE     IN  VARCHAR2,
        P_USER_ID           IN  VARCHAR2,
        P_MENU_ID           IN  VARCHAR2,

        O_RC1               OUT SYS_REFCURSOR,
        O_RC2               OUT SYS_REFCURSOR,
        O_RC3               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

END PKG_DMF0053;