-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_SSP0021 — 원복(사내 적용 전 원문)
CREATE OR REPLACE PACKAGE BODY PKG_SSP0021
IS
/*
 * Program ID   : PKG_SSP0021
 * Description  : SSP0021 Shipment Plan 화면 프로시저 패키지
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */

    PROCEDURE P_SSP0021_GET_SHIPMENT_DIVISION
    (
        PARAM1                  IN  VARCHAR2
       ,PARAM2                  IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_GET_SHIPMENT_DIVISION
 * Description  : DIVISION , COMPANY 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/07/15   khj79          DIVISION , COMPANY 정보
 * 2024/10/01   KHJ            NERP_SSP
 * 2026/03/19   강주용         [E20260206-001938] VP 권한 확장
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
        /* NERP 매핑코드 */
        V_G480          VARCHAR2(20);
        V_G670          VARCHAR2(20);
        V_G450          VARCHAR2(20);
        V_G630          VARCHAR2(20);
        V_AUTH_TYPE     VARCHAR2(100) := 'D';
    BEGIN

        V_G480 := FN_GET_LOOKUP_VALUE('SSP0021_GET_SHIPMENT_DIVISION', 'G480');
        V_G670 := FN_GET_LOOKUP_VALUE('SSP0021_GET_SHIPMENT_DIVISION', 'G670');
        V_G450 := FN_GET_LOOKUP_VALUE('SSP0021_GET_SHIPMENT_DIVISION', 'G450');
        V_G630 := FN_GET_LOOKUP_VALUE('SSP0021_GET_SHIPMENT_DIVISION', 'G630');

        IF (PARAM1 = 'JV Planner') THEN
            V_AUTH_TYPE := 'J';
        END IF;

        /* START [E20260206-001938] VP 권한 확장 */
        /* AS-IS 의 임시테이블 #returnTable 은 인라인 뷰로 대체 */
        OPEN O_RC1 FOR
            SELECT IA.CODE
                 , MAX(IA.NAME) AS NAME
                 , MAX(IA.ATTRIBUTE1) AS ATTRIBUTE1
              FROM (/* 일반권한 */
                    SELECT A.DIVISION_ID AS CODE
                         , A.DIVISION_ID || ' ' || MIN(A.DIVISION_NAME) AS NAME
                         , 1 AS ATTRIBUTE1                                  /* [E20260206-001938] VP 권한 확장 */
                      FROM SCM_MST_DIVISION A
                     /* 2026.09.30 AJS 수정 (START) */
--                     WHERE A.DIVISION_ID IN (SELECT XA.CODE
--                                               FROM TB_FX_USERGROUPAUTHEXTENTION XA
--                                              WHERE XA.GROUPID = PARAM1
--                                                AND XA.USERID = PARAM2
--                                                AND XA.AUTHTYPE = V_AUTH_TYPE)
                     WHERE A.DIVISION_ID IN (SELECT XA.UNIT_ID
                                               FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M XA
                                              /* WHERE XA.USER_GR_ID = PARAM1 */
                                              WHERE (XA.USER_GR_ID = PARAM1 OR (PARAM1 IS NULL AND XA.USER_GR_ID IN (SELECT SA.USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M SA WHERE SA.USER_ID = PARAM2 AND SA.USE_YN = 'Y')))   /* AJS 20261007 화면검증 */
                                                AND XA.USER_ID = PARAM2
                                                AND XA.UNIT_TP_CD = V_AUTH_TYPE)
                     /* 2026.09.30 AJS 수정 (END) */
                       AND A.DIVISION_ID <> '40'
                       AND A.ATTRIBUTE3 <> 'EE'
                       AND A.DIVISION_ID NOT IN ('81_UC')                   /* 포함하지 않을 DIVISION 지정, 조건은 알아서 변경할것 */
                     GROUP BY A.DIVISION_ID
                    UNION /* VP 추가 권한 */
                    SELECT A.DIVISION_ID AS CODE
                         , A.DIVISION_ID || ' ' || MIN(A.DIVISION_NAME) AS NAME
                         , 0 AS ATTRIBUTE1
                      FROM SCM_MST_DIVISION A
                     WHERE A.DIVISION_ID IN (SELECT XA.DIVISION_ID
                                               FROM SCM_MST_SITE XA
                                                  , SCM_MST_SITE XB
                                                  /* 2026.09.30 AJS 수정 (START) */
--                                                  , TB_FX_USERGROUPAUTHEXTENTION XC
                                                  , SCM_ADM_USER_GR_UNIT_AUTH_MPG_M XC
                                                  /* 2026.09.30 AJS 수정 (END) */
                                              WHERE XA.ATTRIBUTE9 = XB.SCM_SITE_ID
                                                /* 2026.09.30 AJS 수정 (START) */
--                                                AND XB.DIVISION_ID = XC.CODE
                                                AND XB.DIVISION_ID = XC.UNIT_ID
                                                /* 2026.09.30 AJS 수정 (END) */
                                                AND XB.SITE_TYPE = 'PLANT'
                                                /* 2026.09.30 AJS 수정 (START) */
--                                                AND XC.AUTHTYPE = V_AUTH_TYPE
--                                                AND XC.GROUPID = PARAM1
--                                                AND XC.USERID = PARAM2
                                                AND XC.UNIT_TP_CD = V_AUTH_TYPE
                                                /* AND XC.USER_GR_ID = PARAM1 */
                                                AND (XC.USER_GR_ID = PARAM1 OR (PARAM1 IS NULL AND XC.USER_GR_ID IN (SELECT SB.USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M SB WHERE SB.USER_ID = PARAM2 AND SB.USE_YN = 'Y')))   /* AJS 20261007 화면검증 */
                                                AND XC.USER_ID = PARAM2
                                                /* 2026.09.30 AJS 수정 (END) */
                                                AND XB.DIVISION_ID NOT IN ('81_UC')  /* 포함하지 않을 DIVISION 지정, 조건은 알아서 변경할것 */
                                                AND XB.DIVISION_ID <> '40')
                       AND A.DIVISION_ID NOT IN ('81_UC')                   /* 포함하지 않을 DIVISION 지정, 조건은 알아서 변경할것 */
                       AND A.DIVISION_ID <> '40'
                       AND A.ATTRIBUTE3 <> 'EE'
                     GROUP BY A.DIVISION_ID) IA
             GROUP BY IA.CODE
             ORDER BY CODE ASC;

        /* 일반 권한 */
        OPEN O_RC2 FOR
            SELECT IA.CODE
                 , IA.NAME
                 , IA.DIVISION_ID
              FROM (SELECT A.COMPANY_ID AS CODE
                         , B.SEGMENT2 AS NAME
                         , A.DIVISION_ID
                      FROM SCM_MST_SITE A
                         , SCM_ADM_LOOKUP_MASTER_DETAIL B
                     WHERE A.COMPANY_ID = B.SEGMENT1
                       AND B.LOOKUP_TYPE = 'COMPANY_DESC'
                       AND A.SITE_TYPE = 'PLANT'
                       /* AND S.COMPANY_ID NOT IN ('G480','G670') -- 포함하지 않을 COMPANY 지정, 조건은 알아서 변경할것 */
                       AND (A.COMPANY_ID <> V_G480
                        AND A.COMPANY_ID <> V_G670
                        /* AND S.COMPANY_ID != @v_G450 */
                        /* AND S.COMPANY_ID != @v_G630 */
                           )                                                /* 표시하고자 하는 COMPANY 지정 */
                       /* START [E20260206-001938] VP 권한 확장 */
                       AND A.DIVISION_ID IN (SELECT XA.DIVISION_ID
                                               FROM SCM_MST_DIVISION XA
                                              /* 2026.09.30 AJS 수정 (START) */
--                                              WHERE XA.DIVISION_ID IN (SELECT XB.CODE
--                                                                         FROM TB_FX_USERGROUPAUTHEXTENTION XB
--                                                                        WHERE XB.GROUPID = PARAM1
--                                                                          AND XB.USERID = PARAM2
--                                                                          AND XB.AUTHTYPE = V_AUTH_TYPE)
                                              WHERE XA.DIVISION_ID IN (SELECT XB.UNIT_ID
                                                                         FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M XB
                                                                        /* WHERE XB.USER_GR_ID = PARAM1 */
                                                                        WHERE (XB.USER_GR_ID = PARAM1 OR (PARAM1 IS NULL AND XB.USER_GR_ID IN (SELECT SC.USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M SC WHERE SC.USER_ID = PARAM2 AND SC.USE_YN = 'Y')))   /* AJS 20261007 화면검증 */
                                                                          AND XB.USER_ID = PARAM2
                                                                          AND XB.UNIT_TP_CD = V_AUTH_TYPE)
                                              /* 2026.09.30 AJS 수정 (END) */
                                                AND XA.DIVISION_ID <> '40'
                                                AND XA.ATTRIBUTE3 <> 'EE'
                                                AND XA.DIVISION_ID NOT IN ('81_UC'))
                     GROUP BY A.COMPANY_ID, B.SEGMENT2, A.DIVISION_ID
                    UNION /* VP 추가 권한 */
                    SELECT A.COMPANY_ID AS CODE
                         , B.SEGMENT2 AS NAME
                         , A.DIVISION_ID
                      FROM SCM_MST_SITE A
                         , SCM_ADM_LOOKUP_MASTER_DETAIL B
                     WHERE A.COMPANY_ID = B.SEGMENT1
                       AND B.LOOKUP_TYPE = 'COMPANY_DESC'
                       AND A.SITE_TYPE = 'PLANT'
                       AND (A.COMPANY_ID <> V_G480
                        AND A.COMPANY_ID <> V_G670)
                       AND A.ATTRIBUTE9 IN (SELECT XA.SCM_SITE_ID
                                              FROM SCM_MST_SITE XA
                                                 /* 2026.09.30 AJS 수정 (START) */
--                                                 , TB_FX_USERGROUPAUTHEXTENTION XB
--                                             WHERE XA.DIVISION_ID = XB.CODE
                                                 , SCM_ADM_USER_GR_UNIT_AUTH_MPG_M XB
                                             WHERE XA.DIVISION_ID = XB.UNIT_ID
                                                 /* 2026.09.30 AJS 수정 (END) */
                                               AND XA.SITE_TYPE = 'PLANT'
                                               /* 2026.09.30 AJS 수정 (START) */
--                                               AND XB.AUTHTYPE = V_AUTH_TYPE
--                                               AND XB.GROUPID = PARAM1
--                                               AND XB.USERID = PARAM2
                                               AND XB.UNIT_TP_CD = V_AUTH_TYPE
                                               /* AND XB.USER_GR_ID = PARAM1 */
                                               AND (XB.USER_GR_ID = PARAM1 OR (PARAM1 IS NULL AND XB.USER_GR_ID IN (SELECT SD.USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M SD WHERE SD.USER_ID = PARAM2 AND SD.USE_YN = 'Y')))   /* AJS 20261007 화면검증 */
                                               AND XB.USER_ID = PARAM2
                                               /* 2026.09.30 AJS 수정 (END) */
                                               AND XA.DIVISION_ID NOT IN ('81_UC')  /* 포함하지 않을 DIVISION 지정, 조건은 알아서 변경할것 */
                                               AND XA.DIVISION_ID <> '40'
                                               AND XA.COMPANY_ID <> 'MI00')
                     GROUP BY A.COMPANY_ID, B.SEGMENT2, A.DIVISION_ID) IA
             GROUP BY IA.CODE, IA.NAME, IA.DIVISION_ID;
        /* END [E20260206-001938] VP 권한 확장 */

    END P_SSP0021_GET_SHIPMENT_DIVISION;

    PROCEDURE P_SSP0021_GET_SHIPMENT_FROM_SITE
    (
        PARAM1                  IN  VARCHAR2
       ,PARAM2                  IN  VARCHAR2
       ,PARAM3                  IN  VARCHAR2
       ,PARAM4                  IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_GET_SHIPMENT_FROM_SITE
 * Description  : Company에 따른 From_Site Load
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/08/23   mcTheJ         신규작성
 * 2026/03/17   강주용         E20260206-001938 VP 권한 확장
 * 2026/09/03   강주용         [E20260831-000063] VILD_YN 적용
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
        V_AUTH_TYPE     VARCHAR2(100) := 'D';
    BEGIN

        IF (PARAM1 = 'JV Planner') THEN
            V_AUTH_TYPE := 'J';
        END IF;

        /* AS-IS 의 테이블 변수 @exception_company 는 NOT EXISTS 서브쿼리로 대체 */
        /* [NERP]COMPANY 예외적용--NERP (IT20250117A) */
        OPEN O_RC1 FOR
            SELECT IA.CODE
                 , IA.NAME
              FROM (SELECT A.SCM_SITE_ID AS CODE
                         , A.SITE_DESCRIPTION AS NAME
                      FROM SCM_MST_SITE A
                     WHERE A.SITE_TYPE = 'PLANT'
                       AND A.OPERATION_GROUP <> 'E'
                       AND (TRIM(PARAM1) IS NULL OR A.DIVISION_ID = PARAM1)
                       AND (TRIM(PARAM2) IS NULL OR A.COMPANY_ID = PARAM2)
                       AND NOT EXISTS (SELECT 1                             /* [NERP]COMPANY 예외적용--NERP (IT20250117A) */
                                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL XA
                                        WHERE XA.LOOKUP_TYPE = 'SSP_UI_EXCEPT_COMPANY'
                                          AND UPPER(XA.VALID_YN) = 'Y'
                                          AND PARAM2 = XA.SEGMENT1)
                       /* START CSR */
                       /* 2026.09.30 AJS 수정 (START) */
--                       AND A.DIVISION_ID IN (SELECT XA.CODE
--                                               FROM TB_FX_USERGROUPAUTHEXTENTION XA
--                                              WHERE XA.GROUPID = PARAM3
--                                                AND XA.USERID = PARAM4
--                                                AND XA.AUTHTYPE = V_AUTH_TYPE)
                       AND A.DIVISION_ID IN (SELECT XA.UNIT_ID
                                               FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M XA
                                              WHERE XA.USER_GR_ID = PARAM3
                                                AND XA.USER_ID = PARAM4
                                                AND XA.UNIT_TP_CD = V_AUTH_TYPE)
                       /* 2026.09.30 AJS 수정 (END) */
                       /* START [E20260831-000063] VILD_YN 적용 */
                       AND A.VALID_YN = 'Y'
                       /* END [E20260831-000063] VILD_YN 적용 */
                    UNION ALL
                    SELECT A.SCM_SITE_ID AS CODE
                         , A.SITE_DESCRIPTION AS NAME
                      FROM SCM_MST_SITE A
                     WHERE A.SITE_TYPE = 'PLANT'
                       AND A.OPERATION_GROUP <> 'E'
                       AND (TRIM(PARAM1) IS NULL OR A.DIVISION_ID = PARAM1)
                       AND (TRIM(PARAM2) IS NULL OR A.COMPANY_ID = PARAM2)
                       AND NOT EXISTS (SELECT 1                             /* [NERP]COMPANY 예외적용--NERP (IT20250117A) */
                                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL XA
                                        WHERE XA.LOOKUP_TYPE = 'SSP_UI_EXCEPT_COMPANY'
                                          AND UPPER(XA.VALID_YN) = 'Y'
                                          AND PARAM2 = XA.SEGMENT1)
                       AND A.ATTRIBUTE9 IN (SELECT XA.SCM_SITE_ID
                                              FROM SCM_MST_SITE XA
                                                 /* 2026.09.30 AJS 수정 (START) */
--                                                 , TB_FX_USERGROUPAUTHEXTENTION XB
--                                             WHERE XA.DIVISION_ID = XB.CODE
                                                 , SCM_ADM_USER_GR_UNIT_AUTH_MPG_M XB
                                             WHERE XA.DIVISION_ID = XB.UNIT_ID
                                                 /* 2026.09.30 AJS 수정 (END) */
                                               AND XA.SITE_TYPE = 'PLANT'
                                               /* 2026.09.30 AJS 수정 (START) */
--                                               AND XB.AUTHTYPE = V_AUTH_TYPE
--                                               AND XB.GROUPID = PARAM3
--                                               AND XB.USERID = PARAM4)
                                               AND XB.UNIT_TP_CD = V_AUTH_TYPE
                                               AND XB.USER_GR_ID = PARAM3
                                               AND XB.USER_ID = PARAM4)
                                               /* 2026.09.30 AJS 수정 (END) */
                       /* START [E20260831-000063] VILD_YN 적용 */
                       AND A.VALID_YN = 'Y'
                       /* END [E20260831-000063] VILD_YN 적용 */
                       ) IA
             GROUP BY IA.CODE, IA.NAME;

    END P_SSP0021_GET_SHIPMENT_FROM_SITE;

    PROCEDURE P_SSP0021_GET_SHIPMENT_STATUS
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_CONFIRM_ID            IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
       ,O_RC3                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_GET_SHIPMENT_STATUS
 * Description  : Shipment Change Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/12   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2020/07/15   khj79          ERP_STATUS 가 'C' 인 경우 수정 못하도록 추가
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
    BEGIN

        OPEN O_RC1 FOR
            SELECT CONFIRM_ID
              FROM SSP_ANL_SHIP_CONFIRM
             WHERE DIVISION_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(P_DIVISION_ID, '^')))
               AND CONFIRM_ID IN (SELECT COLUMN_VALUE
                                    FROM TABLE(STRING_SPLIT(P_CONFIRM_ID, '^')))
               AND SHIPMENT_STATUS <> 'C';

        OPEN O_RC2 FOR
            SELECT CONFIRM_ID
              FROM SSP_ANL_SHIP_CONFIRM
             WHERE DIVISION_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(P_DIVISION_ID, '^')))
               AND CONFIRM_ID IN (SELECT COLUMN_VALUE
                                    FROM TABLE(STRING_SPLIT(P_CONFIRM_ID, '^')))
               AND QTY = 0;

        OPEN O_RC3 FOR
            SELECT CONFIRM_ID
              FROM SSP_ANL_SHIP_CONFIRM
             WHERE DIVISION_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(P_DIVISION_ID, '^')))
               AND CONFIRM_ID IN (SELECT COLUMN_VALUE
                                    FROM TABLE(STRING_SPLIT(P_CONFIRM_ID, '^')))
               AND ERP_STATUS = 'C';

    END P_SSP0021_GET_SHIPMENT_STATUS;

    PROCEDURE P_SSP0021_GET_ERP_SO_NO_CNT
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_ERP_SO_NO             IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_GET_ERP_SO_NO_CNT
 * Description  : Shipment Change Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/12   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2024/06/04   jilee          UI 수량 표기 안되는 정보에 대한 제외 처리
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
    BEGIN

        OPEN O_RC1 FOR
            SELECT COUNT(*) AS CNT
              FROM SSP_ANL_SHIP_CONFIRM
             WHERE DIVISION_ID = P_DIVISION_ID
               AND ERP_SO_NO = P_ERP_SO_NO
               AND QTY <> 0;

    END P_SSP0021_GET_ERP_SO_NO_CNT;

    PROCEDURE P_SSP0021_GET_HOLD_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_PLAN_TYPE             IN  VARCHAR2
       ,P_SEQ                   IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_SEARCH_YN             IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_GET_HOLD_STOCK
 * Description  : 자동차 Shipment Plan
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/03/05   AYJ            Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
 * 2019/06/17   AYJ            조회 조건 추가(p_partLeaderChk, p_teamLeaderChk)
 * 2019/08/28   AYJ            조회 조건 추가(p_delegateeChk)
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
 * 2026.10.08   AJS          Model/Nickname 후속 : 후보 목록 비교 MEMBER OF → IN(TABLE) · Model 'ALL' 은 조건 없음 · 더블클릭 상세는 정확일치(원래 = 비교)
 */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
        V_PLAN_START_YYYYMMDD   VARCHAR2(8);
    BEGIN

        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치하는 품목을 먼저 고른다
           대상 품목 = 해당 사업부 품목 원장(코드 · 닉네임) + 입력값 그대로(기존 정확일치 유지) */
        IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT A.ITEM_ID
                      FROM SCM_MST_ITEM_SN A
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) B
                     WHERE B.COLUMN_VALUE IS NOT NULL
                       AND A.DIVISION_ID = P_DIVISION_ID
                       AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%'
                            OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%')
                    UNION
                    SELECT COLUMN_VALUE
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))
                     WHERE COLUMN_VALUE IS NOT NULL) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        V_PLAN_START_YYYYMMDD := TO_CHAR(TO_DATE(SUBSTR(REPLACE(P_PLAN_START_YYYYMMDD, '-', ''), 1, 8), 'YYYYMMDD'), 'YYYYMMDD');

        /* 1. 셀 더블클릭 - BLOCK_STOCK */
        IF P_SEARCH_YN = 'Y' THEN

            OPEN O_RC1 FOR
                SELECT A.HOLD_ID
                     , A.DIVISION_ID
                     , A.FROM_SITE
                     , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_NM
                     , A.ITEM_ID
                     , FN_GET_ITEM_NICKNAME((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.ITEM_ID) AS NICK_NAME
                     , TO_CHAR(FN_CHAR_TO_DATE(A.HOLD_YYYYMMDD), 'YYYY-MM-DD') AS HOLD_YYYYMMDD
                     , TO_CHAR(FN_CHAR_TO_DATE(A.RELEASE_YYYYMMDD), 'YYYY-MM-DD') AS RELEASE_YYYYMMDD
                     , A.HOLD_QTY
                     , A.REMARKS
                     /* AS-IS 는 문자 결합에 NULL 이 섞이면 전체가 NULL — 같은 결과가 되게 분기 */
                     /* 2026.09.30 AJS 수정 (START) */
--                     , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN B.USERNAME ELSE B.USERNAME_E END) IS NULL THEN NULL
--                            ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN B.USERNAME ELSE B.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                     , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN B.USER_NM ELSE B.USER_ENG_NM END) IS NULL THEN NULL
                            ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN B.USER_NM ELSE B.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                     /* 2026.09.30 AJS 수정 (END) */
                       END AS LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                  FROM SSP_ANL_HOLD_STOCK A
                     /* 2026.09.30 AJS 수정 (START) */
--                     , TB_FX_USER B
                     , SCM_ADM_USER_M B
                     /* 2026.09.30 AJS 수정 (END) */
                     , SSP_MST_MODEL_USER C
                 /* 2026.09.30 AJS 수정 (START) */
--                 WHERE B.USERID(+) = A.LAST_UPDATED_BY
--                   AND B.USEYN(+) = 'Y'
                 WHERE B.USER_ID(+) = A.LAST_UPDATED_BY
                   AND B.USE_YN(+) = 'Y'
                 /* 2026.09.30 AJS 수정 (END) */
                   AND C.DIVISION_ID(+) = A.DIVISION_ID
                   AND C.FROM_SITE(+) = A.FROM_SITE
                   AND C.ITEM_ID(+) = A.ITEM_ID
                   AND C.VALID_YN(+) = 'Y'
                   AND A.DIVISION_ID = P_DIVISION_ID
                   AND A.FROM_SITE = P_FROM_SITE
                   AND A.HOLD_YYYYMMDD <= V_PLAN_START_YYYYMMDD
                   AND A.RELEASE_YYYYMMDD >= V_PLAN_START_YYYYMMDD
                   AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE = P_PLAN_TYPE
                   AND A.SEQ = P_SEQ
--                 AND A.ITEM_ID = P_ITEM_ID   --  2026.10.07 AJS
                   /* AND A.ITEM_ID MEMBER OF V_ITEM_TAB   --  2026.10.07 AJS */
                   AND A.ITEM_ID = P_ITEM_ID   /* AJS 20261008 Model/Nickname */
                 GROUP BY A.HOLD_ID
                        , A.ITEM_ID
                        , FN_GET_ITEM_NICKNAME((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.ITEM_ID)
                        , A.DIVISION_ID
                        , A.FROM_SITE
                        , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-')
                        , A.HOLD_YYYYMMDD
                        , A.RELEASE_YYYYMMDD
                        , A.HOLD_QTY
                        , A.REMARKS
                        , A.LAST_UPDATE_DATE
                        , A.LAST_UPDATED_BY
                        /* 2026.09.30 AJS 수정 (START) */
--                        , B.USERNAME
--                        , B.USERNAME_E
                        , B.USER_NM
                        , B.USER_ENG_NM
                        /* 2026.09.30 AJS 수정 (END) */
                 ORDER BY A.HOLD_ID;

        /* 2. btnSearch */
        ELSE

            OPEN O_RC1 FOR
                SELECT A.HOLD_ID
                     , A.DIVISION_ID
                     , A.FROM_SITE
                     , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_NM
                     , A.ITEM_ID
                     , FN_GET_ITEM_NICKNAME((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.ITEM_ID) AS NICK_NAME
                     , TO_CHAR(FN_CHAR_TO_DATE(A.HOLD_YYYYMMDD), 'YYYY-MM-DD') AS HOLD_YYYYMMDD
                     , TO_CHAR(FN_CHAR_TO_DATE(A.RELEASE_YYYYMMDD), 'YYYY-MM-DD') AS RELEASE_YYYYMMDD
                     , A.HOLD_QTY
                     , A.REMARKS
                     /* 2026.09.30 AJS 수정 (START) */
--                     , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN B.USERNAME ELSE B.USERNAME_E END) IS NULL THEN NULL
--                            ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN B.USERNAME ELSE B.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                     , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN B.USER_NM ELSE B.USER_ENG_NM END) IS NULL THEN NULL
                            ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN B.USER_NM ELSE B.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                     /* 2026.09.30 AJS 수정 (END) */
                       END AS LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                  FROM SSP_ANL_HOLD_STOCK A
                     /* 2026.09.30 AJS 수정 (START) */
--                     , TB_FX_USER B
                     , SCM_ADM_USER_M B
                     /* 2026.09.30 AJS 수정 (END) */
                     , SSP_MST_MODEL_USER C
                 /* 2026.09.30 AJS 수정 (START) */
--                 WHERE B.USERID(+) = A.LAST_UPDATED_BY
--                   AND B.USEYN(+) = 'Y'
                 WHERE B.USER_ID(+) = A.LAST_UPDATED_BY
                   AND B.USE_YN(+) = 'Y'
                 /* 2026.09.30 AJS 수정 (END) */
                   AND C.DIVISION_ID(+) = A.DIVISION_ID
                   AND C.FROM_SITE(+) = A.FROM_SITE
                   AND C.ITEM_ID(+) = A.ITEM_ID
                   AND C.VALID_YN(+) = 'Y'
                   AND A.DIVISION_ID = P_DIVISION_ID
                   AND (TRIM(P_FROM_SITE) IS NULL
                    OR A.FROM_SITE IN (SELECT COLUMN_VALUE
                                         FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                   AND A.HOLD_YYYYMMDD <= V_PLAN_START_YYYYMMDD
                   AND A.RELEASE_YYYYMMDD >= V_PLAN_START_YYYYMMDD
                   AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE = P_PLAN_TYPE
                   AND A.SEQ = P_SEQ
                   AND (TRIM(P_ITEM_ID) IS NULL
                    OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                  OR A.ITEM_ID IN (SELECT COLUMN_VALUE
--                                     FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                    /* OR A.ITEM_ID MEMBER OF V_ITEM_TAB) */
                    OR A.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                     FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                 GROUP BY A.HOLD_ID
                        , A.ITEM_ID
                        , FN_GET_ITEM_NICKNAME((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.ITEM_ID)
                        , A.DIVISION_ID
                        , A.FROM_SITE
                        , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-')
                        , A.HOLD_YYYYMMDD
                        , A.RELEASE_YYYYMMDD
                        , A.HOLD_QTY
                        , A.REMARKS
                        , A.LAST_UPDATE_DATE
                        , A.LAST_UPDATED_BY
                        /* 2026.09.30 AJS 수정 (START) */
--                        , B.USERNAME
--                        , B.USERNAME_E
                        , B.USER_NM
                        , B.USER_ENG_NM
                        /* 2026.09.30 AJS 수정 (END) */
                 ORDER BY A.HOLD_ID;

        END IF;

    END P_SSP0021_GET_HOLD_STOCK;

    PROCEDURE P_SSP0021_GET_MES_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_DBL_FLAG              IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_GET_MES_STOCK
 * Description  : Shipment PSI(Small)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/09/15   mcTheJ         Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
 * 2019/09/16   mcTheJ         QMS_MES_Hold Case 수정
 * 2019/09/16   mcTheJ         TOTAL의 합은 RAW DATA의 SUM() -> ROW SUM이 아님
 * 2019/10/28   AYJ            컬럼명 변경 : AVAILABLE_STOCK - > OQC_COMPLETE, 컬럼 추가 : AVAILABLE_STOCK
 * 2022/02/16   SSP Pjt.       SSP_DNM_MES_STOCK_81_82 -> SSP_DNM_GMES_STOCK_81_82
 * 2023/09/01   jilee          반제품->제품 코드 변환 작업
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
 * 2026.10.08   AJS          Model/Nickname 후속 : 후보 목록 비교 MEMBER OF → IN(TABLE) · Model 'ALL' 은 조건 없음 · 더블클릭 상세는 정확일치(원래 = 비교)
 */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN

        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치하는 품목을 먼저 고른다
           대상 품목 = 해당 사업부 품목 원장(코드 · 닉네임) + 입력값 그대로(기존 정확일치 유지) */
        IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT A.ITEM_ID
                      FROM SCM_MST_ITEM_SN A
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) B
                     WHERE B.COLUMN_VALUE IS NOT NULL
                       AND A.DIVISION_ID = P_DIVISION_ID
                       AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%'
                            OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%')
                    UNION
                    SELECT COLUMN_VALUE
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))
                     WHERE COLUMN_VALUE IS NOT NULL) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* 더블클릭 - W/H Stock Detail */
        IF P_DBL_FLAG = 'Y' THEN

            OPEN O_RC1 FOR
                SELECT IA.ITEM_ID
                     , IA.NICK_NAME
                     , SUM(IA.OQC_INSP_REQUEST) AS OQC_INSP_REQUEST
                     , SUM(IA.BEFORE_OQC) AS BEFORE_OQC
                     , SUM(IA.OQC_NG) AS OQC_NG
                     , SUM(IA.QMS_MES_HOLD) AS QMS_MES_HOLD
                     , SUM(IA.OQC_COMPLETE) AS OQC_COMPLETE
                     /* (SUM(OQC_Insp_Request) + SUM(Before_OQC) + SUM(OQC_NG) + SUM(QMS_MES_Hold) + SUM(Available_Stock)) AS TOTAL */
                     , SUM(NVL(IA.TOTAL, 0)) AS TOTAL
                     , (SUM(NVL(IA.TOTAL, 0)) - SUM(IA.OQC_NG) - SUM(IA.QMS_MES_HOLD)) AS AVAILABLE_STOCK
                  FROM (SELECT ATTRIBUTE5 AS ITEM_ID                            /* jilee 230901 */
                             , PRJT_NAME AS NICK_NAME
                             , CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT = 'Inspection Request' THEN SUM(NVL(LOT_QTY, 0)) ELSE 0 END AS OQC_INSP_REQUEST
                             , CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT IS NULL THEN SUM(NVL(LOT_QTY, 0)) ELSE 0 END AS BEFORE_OQC
                             , CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT = 'N' THEN SUM(NVL(LOT_QTY, 0)) ELSE 0 END AS OQC_NG
                             , CASE WHEN AVAILABLE_YN = 'N' AND (QMS_HOLD_YN = 'Y' OR MES_HOLD_YN = 'Y') THEN SUM(NVL(LOT_QTY, 0)) ELSE 0 END AS QMS_MES_HOLD
                             , CASE WHEN AVAILABLE_YN = 'Y' THEN SUM(NVL(LOT_QTY, 0)) ELSE 0 END AS OQC_COMPLETE
                             , SUM(NVL(LOT_QTY, 0)) AS TOTAL
                          FROM SSP_DNM_GMES_STOCK_81_82
                         WHERE DIVISION_ID = P_DIVISION_ID
                           AND COMPANY_ID = P_COMPANY_ID
                           AND YYYYMMDD = P_PLAN_START_YYYYMMDD
--                         AND ATTRIBUTE5 = P_ITEM_ID                           /* jilee 23091 */   --  2026.10.07 AJS
--                           AND ATTRIBUTE5 MEMBER OF V_ITEM_TAB                           /* jilee 23091 */   --  2026.10.07 AJS
                           AND ATTRIBUTE5 = P_ITEM_ID                           /* jilee 23091 */   /* AJS 20261008 Model/Nickname */
                           /* AND ITEM_ID = @p_item_id */
                           AND (TRIM(P_FROM_SITE) IS NULL
                            OR FROM_SITE IN (SELECT COLUMN_VALUE
                                               FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                         GROUP BY ATTRIBUTE5, ITEM_ID, PRJT_NAME, AVAILABLE_YN, OQC_INSP_RESULT, MES_HOLD_YN, QMS_HOLD_YN) IA
                 GROUP BY IA.ITEM_ID, IA.NICK_NAME;

        /* 2. btnSearch */
        ELSE

            OPEN O_RC1 FOR
                SELECT IA.ITEM_ID
                     , IA.NICK_NAME
                     , SUM(IA.OQC_INSP_REQUEST) AS OQC_INSP_REQUEST
                     , SUM(IA.BEFORE_OQC) AS BEFORE_OQC
                     , SUM(IA.OQC_NG) AS OQC_NG
                     , SUM(IA.QMS_MES_HOLD) AS QMS_MES_HOLD
                     , SUM(IA.OQC_COMPLETE) AS OQC_COMPLETE
                     , SUM(NVL(IA.TOTAL, 0)) AS TOTAL
                     , (SUM(NVL(IA.TOTAL, 0)) - SUM(IA.OQC_NG) - SUM(IA.QMS_MES_HOLD)) AS AVAILABLE_STOCK
                  FROM (SELECT ATTRIBUTE5 AS ITEM_ID                            /* jilee 230901 */
                             , PRJT_NAME AS NICK_NAME
                             , CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT = 'Inspection Request' THEN SUM(NVL(LOT_QTY, 0)) ELSE 0 END AS OQC_INSP_REQUEST
                             , CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT IS NULL THEN SUM(NVL(LOT_QTY, 0)) ELSE 0 END AS BEFORE_OQC
                             , CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT = 'N' THEN SUM(NVL(LOT_QTY, 0)) ELSE 0 END AS OQC_NG
                             , CASE WHEN AVAILABLE_YN = 'N' AND (QMS_HOLD_YN = 'Y' OR MES_HOLD_YN = 'Y') THEN SUM(NVL(LOT_QTY, 0)) ELSE 0 END AS QMS_MES_HOLD
                             , CASE WHEN AVAILABLE_YN = 'Y' THEN SUM(NVL(LOT_QTY, 0)) ELSE 0 END AS OQC_COMPLETE
                             , SUM(NVL(LOT_QTY, 0)) AS TOTAL
                          FROM SSP_DNM_GMES_STOCK_81_82
                         WHERE DIVISION_ID = P_DIVISION_ID
                           AND COMPANY_ID = P_COMPANY_ID
                           AND YYYYMMDD = P_PLAN_START_YYYYMMDD
                           AND (TRIM(P_FROM_SITE) IS NULL
                            OR FROM_SITE IN (SELECT COLUMN_VALUE
                                               FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                           /* jilee 230901 */
                           AND (TRIM(P_ITEM_ID) IS NULL
                            OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                          OR ATTRIBUTE5 IN (SELECT COLUMN_VALUE
--                                              FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                            /* OR ATTRIBUTE5 MEMBER OF V_ITEM_TAB) */
                            OR ATTRIBUTE5 IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                              FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                           /* AND ((@p_item_id IS NULL OR @p_item_id ='')	OR ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ','))) */
                         GROUP BY ATTRIBUTE5, ITEM_ID, PRJT_NAME, AVAILABLE_YN, OQC_INSP_RESULT, MES_HOLD_YN, QMS_HOLD_YN) IA
                 GROUP BY IA.ITEM_ID, IA.NICK_NAME;

        END IF;

    END P_SSP0021_GET_MES_STOCK;

    PROCEDURE P_SSP0021_GET_MES_STOCK_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_BOX_ID                IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_DBL_FLAG              IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_GET_MES_STOCK_DETAIL
 * Description  : Shipment PSI(Small)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/09/15   mcTheJ         Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
 * 2019/10/28   AYJ            검색조건 추가 : BOXID
 * 2022/02/16   SSP Pjt.       SSP_DNM_MES_STOCK_81_82 -> SSP_DNM_GMES_STOCK_81_82
 * 2023/09/01   jilee          반제품->제품 코드 변환 작업
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
 * 2026.10.08   AJS          Model/Nickname 후속 : 후보 목록 비교 MEMBER OF → IN(TABLE) · Model 'ALL' 은 조건 없음 · 더블클릭 상세는 정확일치(원래 = 비교)
 */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN

        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치하는 품목을 먼저 고른다
           대상 품목 = 해당 사업부 품목 원장(코드 · 닉네임) + 입력값 그대로(기존 정확일치 유지) */
        IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT A.ITEM_ID
                      FROM SCM_MST_ITEM_SN A
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) B
                     WHERE B.COLUMN_VALUE IS NOT NULL
                       AND A.DIVISION_ID = P_DIVISION_ID
                       AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%'
                            OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%')
                    UNION
                    SELECT COLUMN_VALUE
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))
                     WHERE COLUMN_VALUE IS NOT NULL) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* 더블클릭 - W/H Stock Detail */
        IF P_DBL_FLAG = 'Y' THEN

            OPEN O_RC1 FOR
                SELECT BOXID
                     , ATTRIBUTE5 AS PRODID                                     /* jilee 0901 */
                     , PRJT_NAME
                     , AVAILABLE_YN
                     , OQC_INSP_RESULT
                     , LOTID
                     , NVL(LOT_QTY, 0) AS LOT_QTY
                     , CASE WHEN PROD_VALID_DATE = '-' OR PROD_VALID_DATE IS NULL THEN NULL ELSE TO_CHAR(FN_CHAR_TO_DATE(PROD_VALID_DATE), 'YYYY-MM-DD') END AS PROD_VALID_DATE
                     , CASE WHEN EXP_INSP_VALID_DATE = '-' OR EXP_INSP_VALID_DATE IS NULL THEN NULL ELSE TO_CHAR(FN_CHAR_TO_DATE(EXP_INSP_VALID_DATE), 'YYYY-MM-DD') END AS EXP_INSP_VALID_DATE
                     , MES_HOLD_YN
                     , QMS_HOLD_YN
                     , CASE WHEN MES_HOLD_RELEASE = '-' OR MES_HOLD_RELEASE IS NULL THEN NULL ELSE TO_CHAR(FN_CHAR_TO_DATE(MES_HOLD_RELEASE), 'YYYY-MM-DD') END AS MES_UNHOLD_SCHD_DATE
                     , CASE WHEN QMS_HOLD_RELEASE = '-' OR QMS_HOLD_RELEASE IS NULL THEN NULL ELSE TO_CHAR(FN_CHAR_TO_DATE(QMS_HOLD_RELEASE), 'YYYY-MM-DD') END AS QMS_UNHOLD_SCHD_DATE
                  FROM SSP_DNM_GMES_STOCK_81_82
                 WHERE DIVISION_ID = P_DIVISION_ID
                   AND COMPANY_ID = P_COMPANY_ID
                   AND YYYYMMDD = P_PLAN_START_YYYYMMDD
--                 AND ATTRIBUTE5 = P_ITEM_ID                                   /* jilee 0901 */   --  2026.10.07 AJS
--                   AND ATTRIBUTE5 MEMBER OF V_ITEM_TAB                                   /* jilee 0901 */   --  2026.10.07 AJS
                   AND ATTRIBUTE5 = P_ITEM_ID                                   /* jilee 0901 */   /* AJS 20261008 Model/Nickname */
                   /* AND ITEM_ID = @p_item_id */
                   AND (TRIM(P_FROM_SITE) IS NULL
                    OR FROM_SITE IN (SELECT COLUMN_VALUE
                                       FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))));

        /* 2. btnSearch */
        ELSE

            OPEN O_RC1 FOR
                SELECT BOXID
                     , ATTRIBUTE5 AS PRODID                                     /* jilee 0901 */
                     , PRJT_NAME
                     , AVAILABLE_YN
                     , OQC_INSP_RESULT
                     , LOTID
                     , NVL(LOT_QTY, 0) AS LOT_QTY
                     , CASE WHEN PROD_VALID_DATE = '-' OR PROD_VALID_DATE IS NULL THEN NULL ELSE TO_CHAR(FN_CHAR_TO_DATE(PROD_VALID_DATE), 'YYYY-MM-DD') END AS PROD_VALID_DATE
                     , CASE WHEN EXP_INSP_VALID_DATE = '-' OR EXP_INSP_VALID_DATE IS NULL THEN NULL ELSE TO_CHAR(FN_CHAR_TO_DATE(EXP_INSP_VALID_DATE), 'YYYY-MM-DD') END AS EXP_INSP_VALID_DATE
                     , MES_HOLD_YN
                     , QMS_HOLD_YN
                     , CASE WHEN MES_HOLD_RELEASE = '-' OR MES_HOLD_RELEASE IS NULL THEN NULL ELSE TO_CHAR(FN_CHAR_TO_DATE(MES_HOLD_RELEASE), 'YYYY-MM-DD') END AS MES_UNHOLD_SCHD_DATE
                     , CASE WHEN QMS_HOLD_RELEASE = '-' OR QMS_HOLD_RELEASE IS NULL THEN NULL ELSE TO_CHAR(FN_CHAR_TO_DATE(QMS_HOLD_RELEASE), 'YYYY-MM-DD') END AS QMS_UNHOLD_SCHD_DATE
                  FROM SSP_DNM_GMES_STOCK_81_82
                 WHERE DIVISION_ID = P_DIVISION_ID
                   AND COMPANY_ID = P_COMPANY_ID
                   AND YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND (TRIM(P_FROM_SITE) IS NULL
                    OR FROM_SITE IN (SELECT COLUMN_VALUE
                                       FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                   AND (TRIM(P_ITEM_ID) IS NULL
                    OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                  OR ATTRIBUTE5 IN (SELECT COLUMN_VALUE
--                                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                    /* OR ATTRIBUTE5 MEMBER OF V_ITEM_TAB) */
                    OR ATTRIBUTE5 IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                      FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (TRIM(P_BOX_ID) IS NULL
                    OR BOXID IN (SELECT COLUMN_VALUE
                                   FROM TABLE(STRING_SPLIT(P_BOX_ID, ','))));

        END IF;

    END P_SSP0021_GET_MES_STOCK_DETAIL;

    PROCEDURE P_SSP0021_GET_OWMS_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_DBL_FLAG              IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_GET_OWMS_DETAIL
 * Description  : 자동차 Shipment Plan
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/09/10   mcTheJ         Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
 * 2022.04.23   SSP Pjt.       C20220419-000607 / SSP~oWMS 사외창고 재고 I/F개선 요청
 * 2026.09.10   강주용         [E20260910-001263] Shipment Plan(Auto & ESS) 화면 하단 oWMS Detail 확인 요청
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
 * 2026.10.08   AJS          Model/Nickname 후속 : 후보 목록 비교 MEMBER OF → IN(TABLE) · Model 'ALL' 은 조건 없음 · 더블클릭 상세는 정확일치(원래 = 비교)
 */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
        V_BOH_YYYYMMDD      VARCHAR2(8);
    BEGIN

        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치하는 품목을 먼저 고른다
           대상 품목 = 해당 사업부 품목 원장(코드 · 닉네임) + 입력값 그대로(기존 정확일치 유지) */
        IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT A.ITEM_ID
                      FROM SCM_MST_ITEM_SN A
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) B
                     WHERE B.COLUMN_VALUE IS NOT NULL
                       AND A.DIVISION_ID = P_DIVISION_ID
                       AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%'
                            OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%')
                    UNION
                    SELECT COLUMN_VALUE
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))
                     WHERE COLUMN_VALUE IS NOT NULL) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        V_BOH_YYYYMMDD := TO_CHAR(TO_DATE(SUBSTR(REPLACE(P_PLAN_START_YYYYMMDD, '-', ''), 1, 8), 'YYYYMMDD') - 1, 'YYYYMMDD');   /* FROM -1일 */

        /* 더블클릭 - W/H Stock Detail */
        IF P_DBL_FLAG = 'Y' THEN

            OPEN O_RC1 FOR
                SELECT IA.*
                  FROM (SELECT A.DIVISION_ID
                             , A.ITEM_ID
                             , FN_GET_ITEM_NICKNAME((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.ITEM_ID) AS NICK_NAME
                             , A.GRADE
                             , A.CAPACITY_GRADE AS CAPA_GRADE
                             , A.SOC
                             , A.LOT_ID
                             , A.PALLET_ID
                             , A.STOCK_QTY
                             , A.AVAILABLE_QTY
                             , A.NON_QC_QTY AS UNDECIDED_QTY
                             , A.ALLOCATION_QTY
                             , A.BLOCK_QTY AS HOLD_QTY
                             , A.PACKING_QTY
                             , A.MOVING_QTY
                             , A.RCVLOC_QTY AS RECEIVING_QTY
                             , A.EXPIRATION_QTY
                             , A.LONG_QTY AS LONG_TERM_QTY
                             , A.PLANT_ID
                             , A.PACKING_STATUS
                             , A.STOCK_STATUS
                             , A.STORAGE_ID || ' ' || C.STORAGE_DESCRIPTION AS STORAGE_ID
                             , A.CUSTOMER_CODE
                             , A.CUSTOMER_NAME
                             /* START [E20260910-001263] Shipment Plan(Auto & ESS) 화면 하단 oWMS Detail 확인 요청 */
                             /* 원본,convert(nvarchar, convert(datetime,a.LOT_DATE,112), 23)  LOT_ISSUE_DATE */
                             , NVL(TO_CHAR(TO_DATE(A.LOT_DATE DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD'), 'YYYY-MM-DD'), A.LOT_DATE) AS LOT_ISSUE_DATE
                             /* END [E20260910-001263] Shipment Plan(Auto & ESS) 화면 하단 oWMS Detail 확인 요청 */
                          FROM SSP_ANL_OWMS_STOCK_C2 A
                             , SCM_ADM_LOOKUP_MASTER_DETAIL B
                             , SCM_MST_SLOC C
                             , SSP_MST_MODEL_USER D
                         WHERE B.LOOKUP_TYPE = 'OWMS_STOCK_STATUS'              /* C20220419-000607 */
                           AND B.VALID_YN = 'Y'
                           AND B.ATTRIBUTE1 = 'Y'
                           AND B.SEGMENT1 = A.STOCK_STATUS
                           AND C.DIVISION_ID(+) = (CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END)
                           AND C.STORAGE_ID(+) = A.STORAGE_ID
                           AND C.PLANT_ID(+) = A.PLANT_ID
                           AND D.DIVISION_ID(+) = A.DIVISION_ID
                           AND D.FROM_SITE(+) = A.FROM_SITE
                           AND D.ITEM_ID(+) = A.ITEM_ID
                           AND D.VALID_YN(+) = 'Y'
                           AND A.DIVISION_ID = P_DIVISION_ID
                           AND A.COMPANY_ID = P_COMPANY_ID
                           AND A.CUTOFF_DATE = V_BOH_YYYYMMDD
                           AND A.FROM_SITE = P_FROM_SITE
--                         AND A.ITEM_ID = P_ITEM_ID) IA   --  2026.10.07 AJS
                           /* AND A.ITEM_ID MEMBER OF V_ITEM_TAB) IA   --  2026.10.07 AJS */
                           AND A.ITEM_ID = P_ITEM_ID) IA   /* AJS 20261008 Model/Nickname */
                 ORDER BY IA.DIVISION_ID, IA.PLANT_ID, IA.STORAGE_ID, IA.ITEM_ID, IA.GRADE, IA.CAPA_GRADE, IA.SOC, IA.LOT_ID, IA.PALLET_ID;

        /* 2. btnSearch */
        ELSE

            OPEN O_RC1 FOR
                SELECT IA.*
                  FROM (SELECT A.DIVISION_ID
                             , A.ITEM_ID
                             , FN_GET_ITEM_NICKNAME((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.ITEM_ID) AS NICK_NAME
                             , A.GRADE
                             , A.CAPACITY_GRADE AS CAPA_GRADE
                             , A.SOC
                             , A.LOT_ID
                             , A.PALLET_ID
                             , A.STOCK_QTY
                             , A.AVAILABLE_QTY
                             , A.NON_QC_QTY AS UNDECIDED_QTY
                             , A.ALLOCATION_QTY
                             , A.BLOCK_QTY AS HOLD_QTY
                             , A.PACKING_QTY
                             , A.MOVING_QTY
                             , A.RCVLOC_QTY AS RECEIVING_QTY
                             , A.EXPIRATION_QTY
                             , A.LONG_QTY AS LONG_TERM_QTY
                             , A.PLANT_ID
                             , A.PACKING_STATUS
                             , A.STOCK_STATUS
                             , A.STORAGE_ID || ' ' || C.STORAGE_DESCRIPTION AS STORAGE_ID
                             , A.CUSTOMER_CODE
                             , A.CUSTOMER_NAME
                             /* START [E20260910-001263] Shipment Plan(Auto & ESS) 화면 하단 oWMS Detail 확인 요청 */
                             /* 원본,convert(nvarchar, convert(datetime,a.LOT_DATE,112), 23)  LOT_ISSUE_DATE */
                             , NVL(TO_CHAR(TO_DATE(A.LOT_DATE DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD'), 'YYYY-MM-DD'), A.LOT_DATE) AS LOT_ISSUE_DATE
                             /* END [E20260910-001263] Shipment Plan(Auto & ESS) 화면 하단 oWMS Detail 확인 요청 */
                          FROM SSP_ANL_OWMS_STOCK_C2 A
                             , SCM_ADM_LOOKUP_MASTER_DETAIL B
                             , SCM_MST_SLOC C
                             , SSP_MST_MODEL_USER D
                         WHERE B.LOOKUP_TYPE = 'OWMS_STOCK_STATUS'              /* C20220419-000607 */
                           AND B.VALID_YN = 'Y'
                           AND B.ATTRIBUTE1 = 'Y'
                           AND B.SEGMENT1 = A.STOCK_STATUS
                           AND C.DIVISION_ID(+) = (CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END)
                           AND C.STORAGE_ID(+) = A.STORAGE_ID
                           AND C.PLANT_ID(+) = A.PLANT_ID
                           AND D.DIVISION_ID(+) = A.DIVISION_ID
                           AND D.FROM_SITE(+) = A.FROM_SITE
                           AND D.ITEM_ID(+) = A.ITEM_ID
                           AND D.VALID_YN(+) = 'Y'
                           AND A.DIVISION_ID = P_DIVISION_ID
                           AND A.CUTOFF_DATE = V_BOH_YYYYMMDD
                           AND (TRIM(P_FROM_SITE) IS NULL
                            OR A.FROM_SITE IN (SELECT COLUMN_VALUE
                                                 FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                           AND (TRIM(P_ITEM_ID) IS NULL
                            OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                          OR A.ITEM_ID IN (SELECT COLUMN_VALUE
--                                             FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))) IA
                            /* OR A.ITEM_ID MEMBER OF V_ITEM_TAB)) IA */
                            OR A.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                             FROM TABLE(V_ITEM_TAB)))) IA   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                 ORDER BY IA.DIVISION_ID, IA.PLANT_ID, IA.STORAGE_ID, IA.ITEM_ID, IA.GRADE, IA.CAPA_GRADE, IA.SOC, IA.LOT_ID, IA.PALLET_ID;

        END IF;

    END P_SSP0021_GET_OWMS_DETAIL;

    PROCEDURE P_SSP0021_GET_STOCK_LOCATION_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_DBL_FLAG              IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_GET_STOCK_LOCATION_DETAIL
 * Description  : 자동차 Shipment Plan
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/09/06   mcThej         Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 * 2019/10/14   mcThej         Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT - NICK NAME 추가
 * 2019/10/15   juhlee         Pack 생산 창고 추가 CMA_BMA . 2019.10.15 (requested by 김광희)
 * 2020/01/29   KIMYONGHO      [C20200121-000352]  ESS Packer출하 적용
                                - [C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V)
 * 2021/05/27   KIMYONGHO      A/S PLANT ERP 재고 반영  수정
 * 2021/06/01   SSP Pjt.       AS ERP 재고 적용
 * 2021/06/14   SSP Pjt.       화면속도개선(SCM_DNM_STOCK_V -> SSP_DNM_STOCK_C)
 * 2023/09/11   jilee          반제품->제품코드 변환 작업
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
 * 2026.10.08   AJS          Model/Nickname 후속 : 후보 목록 비교 MEMBER OF → IN(TABLE) · Model 'ALL' 은 조건 없음 · 더블클릭 상세는 정확일치(원래 = 비교)
 */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
        V_BOH_YYYYMMDD      VARCHAR2(8);
        V_STOCK_YYYYMMDD    VARCHAR2(8);
        V_BOH_DATE          DATE;
        V_STOCK_DATE        DATE;
    BEGIN

        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치하는 품목을 먼저 고른다
           대상 품목 = 해당 사업부 품목 원장(코드 · 닉네임) + 입력값 그대로(기존 정확일치 유지) */
        IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT A.ITEM_ID
                      FROM SCM_MST_ITEM_SN A
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) B
                     WHERE B.COLUMN_VALUE IS NOT NULL
                       AND A.DIVISION_ID = P_DIVISION_ID
                       AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%'
                            OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%')
                    UNION
                    SELECT COLUMN_VALUE
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))
                     WHERE COLUMN_VALUE IS NOT NULL) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        V_BOH_YYYYMMDD := TO_CHAR(TO_DATE(SUBSTR(REPLACE(P_PLAN_START_YYYYMMDD, '-', ''), 1, 8), 'YYYYMMDD') - 1, 'YYYYMMDD');   /* FROM -1일 */
        V_STOCK_YYYYMMDD := TO_CHAR(TO_DATE(SUBSTR(REPLACE(P_PLAN_START_YYYYMMDD, '-', ''), 1, 8), 'YYYYMMDD') - 3, 'YYYYMMDD'); /* FROM -3일 */

        /* 재고 테이블의 CUTOFF_DATE 는 날짜 형이라 값 쪽을 날짜로 맞춘다(칸에는 함수 미사용) */
        V_BOH_DATE := TO_DATE(V_BOH_YYYYMMDD, 'YYYYMMDD');
        V_STOCK_DATE := TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD');

        IF P_DBL_FLAG = 'Y' THEN

            OPEN O_RC1 FOR
                SELECT IA.*
                  FROM (SELECT A.DIVISION_ID
                             , A.COMPANY_ID
                             , A.CUTOFF_DATE AS CUTOFF_DATE
                             , A.SCM_SITE_ID AS FROM_SITE
                             , A.PLANT_ID
                             /* jilee 230911 */
                             , NVL(A.ATTRIBUTE1, A.ITEM_ID) AS ITEM_ID
                             , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
                             , A.STOCK_TYPE
                             , A.STORAGE_ID
                             , NVL(B.STORAGE_DESCRIPTION, (SELECT SA.STORAGE_DESCRIPTION
                                                             FROM SCM_MST_SLOC SA
                                                            WHERE SA.PLANT_ID = A.PLANT_ID
                                                              AND SA.STORAGE_ID = A.STORAGE_ID
                                                              AND SA.VALID_YN = 'Y'
                                                              AND ROWNUM = 1)) AS STORAGE_DESCRIPTION
                             , NVL(A.SCM_QTY, 0) AS TOTAL_QTY
                             , NVL(A.SSP_QTY, 0) AS AVAILABLE_QTY
                             , A.DEFECT_QTY
                             , A.MOVING_QTY
                             , A.QTY_UOM
                             , NVL(A.WIPHOLD_YN, 'N') AS WIPHOLD_YN
                             , A.HOLDING_DATE
                             , A.AVAILABLE_DATE
                             , A.OUTSOURCING_FLAG
                             , A.OUTSOURCING_FACTORY
                          FROM SSP_DNM_STOCK_C A                                /* SCM_DNM_STOCK_V */
                             , SCM_MST_SLOC B
                             , (SELECT XA.DIVISION_ID
                                     , XA.SCM_SITE_ID
                                     , XA.PLANT_ID
                                     , XA.STORAGE_ID
                                     , XA.LOCATION_CODE
                                  FROM SSP_MST_LOCATION_V XA
                                     , SCM_MST_SITE XB
                                 WHERE XA.DIVISION_ID = XB.DIVISION_ID
                                   AND XA.SCM_SITE_ID = XB.SCM_SITE_ID
                                   AND XA.PLANT_ID = XB.PLANT_ID
                                   AND XB.DIVISION_ID = P_DIVISION_ID
                                   AND XB.COMPANY_ID = P_COMPANY_ID
                                   AND XB.VALID_YN = 'Y'
                                   AND XB.SITE_TYPE = 'PLANT'
                                   AND XA.VALID_YN = 'Y'
                                   AND XA.DIVISION_ID = P_DIVISION_ID
                                   AND XB.COMPANY_ID = P_COMPANY_ID
                                   AND XA.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING', 'CMA_BMA')
                                   AND (TRIM(P_FROM_SITE) IS NULL
                                    OR XA.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                            FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                                 GROUP BY XA.DIVISION_ID, XA.SCM_SITE_ID, XA.PLANT_ID, XA.STORAGE_ID, XA.LOCATION_CODE
                                UNION ALL
                                SELECT DISTINCT XA.SEGMENT1 AS DIVISION_ID
                                     , XA.SEGMENT2 AS SCM_SITE_ID
                                     , XA.SEGMENT3 AS PLANT_ID
                                     , XA.SEGMENT4 AS STORAGE_ID
                                     , 'AS' AS LOCATION_CODE
                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL XA
                                     , SCM_MST_SITE XB
                                 WHERE XA.SEGMENT1 = XB.DIVISION_ID
                                   AND XA.SEGMENT2 = XB.SCM_SITE_ID
                                   AND XA.SEGMENT3 = XB.PLANT_ID
                                   AND XA.LOOKUP_TYPE = 'SSP_AS_DIV_SLOC'
                                   AND XA.VALID_YN = 'Y'
                                   AND XB.DIVISION_ID = P_DIVISION_ID
                                   AND XB.COMPANY_ID = P_COMPANY_ID
                                   AND XB.VALID_YN = 'Y'
                                   AND XB.SITE_TYPE = 'PLANT'
                                   AND XA.SEGMENT1 = P_DIVISION_ID
                                   AND XB.COMPANY_ID = P_COMPANY_ID
                                   AND (TRIM(P_FROM_SITE) IS NULL
                                    OR XA.SEGMENT2 IN (SELECT COLUMN_VALUE
                                                         FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))) C
                         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                           AND B.PLANT_ID(+) = A.PLANT_ID
                           AND B.STORAGE_ID(+) = A.STORAGE_ID
                           AND A.DIVISION_ID = C.DIVISION_ID
                           AND A.STORAGE_ID = C.STORAGE_ID
                           AND A.PLANT_ID = C.PLANT_ID
                           AND A.SCM_SITE_ID = C.SCM_SITE_ID
                           AND C.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING', 'CMA_BMA', 'AS')
                           AND A.DIVISION_ID = P_DIVISION_ID
                           AND A.COMPANY_ID = P_COMPANY_ID
                           AND A.SCM_SITE_ID = P_FROM_SITE
--                         AND (A.ITEM_ID = P_ITEM_ID   --  2026.10.07 AJS
                           /* AND (A.ITEM_ID MEMBER OF V_ITEM_TAB   --  2026.10.07 AJS */
                           AND (A.ITEM_ID = P_ITEM_ID   /* AJS 20261008 Model/Nickname */
--                          OR A.ATTRIBUTE1 = P_ITEM_ID)   --  2026.10.07 AJS
                            /* OR A.ATTRIBUTE1 MEMBER OF V_ITEM_TAB)   --  2026.10.07 AJS */
                            OR A.ATTRIBUTE1 = P_ITEM_ID)   /* AJS 20261008 Model/Nickname */
                           AND A.CUTOFF_DATE = V_BOH_DATE
                           AND A.CUTOFF_DATE > V_STOCK_DATE                 /* 현재일 - 3 */
                           AND A.STOCK_TYPE = 'INVENTORY'
                        /* [C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V) */
                        UNION ALL
                        SELECT A.DIVISION_ID
                             , A.COMPANY_ID
                             , A.CUTOFF_DATE AS CUTOFF_DATE
                             , A.SCM_SITE_ID AS FROM_SITE
                             , A.PLANT_ID
                             , A.ITEM_ID
                             , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
                             , A.STOCK_TYPE
                             , A.STORAGE_ID
                             , B.STORAGE_DESCRIPTION
                             , NVL(A.SCM_QTY, 0) AS TOTAL_QTY
                             , NVL(A.SSP_QTY, 0) AS AVAILABLE_QTY
                             , A.DEFECT_QTY
                             , A.MOVING_QTY
                             , A.QTY_UOM
                             , NVL(A.WIPHOLD_YN, 'N') AS WIPHOLD_YN
                             , A.HOLDING_DATE
                             , A.AVAILABLE_DATE
                             , A.OUTSOURCING_FLAG
                             , A.OUTSOURCING_FACTORY
                          FROM SSP_DNM_ESS_PACKER_STOCK_V A
                             , SCM_MST_SLOC B
                         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                           AND B.PLANT_ID(+) = A.PLANT_ID
                           AND B.STORAGE_ID(+) = A.STORAGE_ID
                           AND A.DIVISION_ID = P_DIVISION_ID
                           AND A.COMPANY_ID = P_COMPANY_ID
                           AND A.SCM_SITE_ID = P_FROM_SITE
--                         AND A.ITEM_ID = P_ITEM_ID   --  2026.10.07 AJS
                           /* AND A.ITEM_ID MEMBER OF V_ITEM_TAB   --  2026.10.07 AJS */
                           AND A.ITEM_ID = P_ITEM_ID   /* AJS 20261008 Model/Nickname */
                           AND A.CUTOFF_DATE = V_BOH_DATE
                           AND A.CUTOFF_DATE > V_STOCK_DATE) IA            /* 현재일 - 3 */
                 ORDER BY IA.COMPANY_ID, IA.DIVISION_ID, IA.FROM_SITE, IA.PLANT_ID, IA.ITEM_ID, IA.STOCK_TYPE, IA.STORAGE_ID;

        ELSE

            OPEN O_RC1 FOR
                SELECT IA.*
                  FROM (SELECT A.DIVISION_ID
                             , A.COMPANY_ID
                             , A.CUTOFF_DATE AS CUTOFF_DATE
                             , A.SCM_SITE_ID AS FROM_SITE
                             , A.PLANT_ID
                             /* jilee 230911 */
                             , NVL(A.ATTRIBUTE1, A.ITEM_ID) AS ITEM_ID
                             , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
                             , A.STOCK_TYPE
                             , A.STORAGE_ID
                             , NVL(B.STORAGE_DESCRIPTION, (SELECT SA.STORAGE_DESCRIPTION
                                                             FROM SCM_MST_SLOC SA
                                                            WHERE SA.PLANT_ID = A.PLANT_ID
                                                              AND SA.STORAGE_ID = A.STORAGE_ID
                                                              AND SA.VALID_YN = 'Y'
                                                              AND ROWNUM = 1)) AS STORAGE_DESCRIPTION
                             , NVL(A.SCM_QTY, 0) AS TOTAL_QTY
                             , NVL(A.SSP_QTY, 0) AS AVAILABLE_QTY
                             , A.DEFECT_QTY
                             , A.MOVING_QTY
                             , A.QTY_UOM
                             , NVL(A.WIPHOLD_YN, 'N') AS WIPHOLD_YN
                             , A.HOLDING_DATE
                             , A.AVAILABLE_DATE
                             , A.OUTSOURCING_FLAG
                             , A.OUTSOURCING_FACTORY
                          FROM SSP_DNM_STOCK_C A                                /* SCM_DNM_STOCK_V */
                             , SCM_MST_SLOC B
                             , (SELECT XA.DIVISION_ID
                                     , XA.SCM_SITE_ID
                                     , XA.PLANT_ID
                                     , XA.STORAGE_ID
                                     , XA.LOCATION_CODE
                                  FROM SSP_MST_LOCATION_V XA
                                     , SCM_MST_SITE XB
                                 WHERE XA.DIVISION_ID = XB.DIVISION_ID
                                   AND XA.SCM_SITE_ID = XB.SCM_SITE_ID
                                   AND XA.PLANT_ID = XB.PLANT_ID
                                   AND XB.DIVISION_ID = P_DIVISION_ID
                                   AND XB.COMPANY_ID = P_COMPANY_ID
                                   AND XB.VALID_YN = 'Y'
                                   AND XB.SITE_TYPE = 'PLANT'
                                   AND XA.VALID_YN = 'Y'
                                   AND XA.DIVISION_ID = P_DIVISION_ID
                                   AND XB.COMPANY_ID = P_COMPANY_ID
                                   AND XA.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING', 'CMA_BMA')
                                   AND (TRIM(P_FROM_SITE) IS NULL
                                    OR XA.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                            FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                                 GROUP BY XA.DIVISION_ID, XA.SCM_SITE_ID, XA.PLANT_ID, XA.STORAGE_ID, XA.LOCATION_CODE
                                UNION ALL
                                SELECT DISTINCT XA.SEGMENT1 AS DIVISION_ID
                                     , XA.SEGMENT2 AS SCM_SITE_ID
                                     , XA.SEGMENT3 AS PLANT_ID
                                     , XA.SEGMENT4 AS STORAGE_ID
                                     , 'AS' AS LOCATION_CODE
                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL XA
                                     , SCM_MST_SITE XB
                                 WHERE XA.SEGMENT1 = XB.DIVISION_ID
                                   AND XA.SEGMENT2 = XB.SCM_SITE_ID
                                   AND XA.SEGMENT3 = XB.PLANT_ID
                                   AND XA.LOOKUP_TYPE = 'SSP_AS_DIV_SLOC'
                                   AND XA.VALID_YN = 'Y'
                                   AND XB.DIVISION_ID = P_DIVISION_ID
                                   AND XB.COMPANY_ID = P_COMPANY_ID
                                   AND XB.VALID_YN = 'Y'
                                   AND XB.SITE_TYPE = 'PLANT'
                                   AND XA.SEGMENT1 = P_DIVISION_ID
                                   AND XB.COMPANY_ID = P_COMPANY_ID
                                   AND (TRIM(P_FROM_SITE) IS NULL
                                    OR XA.SEGMENT2 IN (SELECT COLUMN_VALUE
                                                         FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))) C
                         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                           AND B.PLANT_ID(+) = A.PLANT_ID
                           AND B.STORAGE_ID(+) = A.STORAGE_ID
                           AND A.DIVISION_ID = C.DIVISION_ID
                           AND A.STORAGE_ID = C.STORAGE_ID
                           AND A.PLANT_ID = C.PLANT_ID
                           AND A.SCM_SITE_ID = C.SCM_SITE_ID
                           AND C.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING', 'CMA_BMA', 'AS')
                           AND A.DIVISION_ID = P_DIVISION_ID
                           AND A.COMPANY_ID = P_COMPANY_ID
                           AND (TRIM(P_FROM_SITE) IS NULL
                            OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                   FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                           AND (TRIM(P_ITEM_ID) IS NULL
                            OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                          OR A.ITEM_ID IN (SELECT COLUMN_VALUE
--                                             FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')))
                            /* OR A.ITEM_ID MEMBER OF V_ITEM_TAB */
                            OR A.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                             FROM TABLE(V_ITEM_TAB))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                          OR A.ATTRIBUTE1 IN (SELECT COLUMN_VALUE
--                                                FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                            /* OR A.ATTRIBUTE1 MEMBER OF V_ITEM_TAB) */
                            OR A.ATTRIBUTE1 IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                           AND A.CUTOFF_DATE = V_BOH_DATE
                           AND A.CUTOFF_DATE > V_STOCK_DATE                 /* 현재일 - 3 */
                           AND A.STOCK_TYPE = 'INVENTORY'
                        UNION ALL
                        SELECT A.DIVISION_ID
                             , A.COMPANY_ID
                             , A.CUTOFF_DATE AS CUTOFF_DATE
                             , A.SCM_SITE_ID AS FROM_SITE
                             , A.PLANT_ID
                             , A.ITEM_ID
                             , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
                             , A.STOCK_TYPE
                             , A.STORAGE_ID
                             , B.STORAGE_DESCRIPTION
                             , NVL(A.SCM_QTY, 0) AS TOTAL_QTY
                             , NVL(A.SSP_QTY, 0) AS AVAILABLE_QTY
                             , A.DEFECT_QTY
                             , A.MOVING_QTY
                             , A.QTY_UOM
                             , NVL(A.WIPHOLD_YN, 'N') AS WIPHOLD_YN
                             , A.HOLDING_DATE
                             , A.AVAILABLE_DATE
                             , A.OUTSOURCING_FLAG
                             , A.OUTSOURCING_FACTORY
                          FROM SSP_DNM_ESS_PACKER_STOCK_V A
                             , SCM_MST_SLOC B
                         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                           AND B.PLANT_ID(+) = A.PLANT_ID
                           AND B.STORAGE_ID(+) = A.STORAGE_ID
                           AND A.DIVISION_ID = P_DIVISION_ID
                           AND A.COMPANY_ID = P_COMPANY_ID
                           AND (TRIM(P_FROM_SITE) IS NULL
                            OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                   FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                           AND (TRIM(P_ITEM_ID) IS NULL
                            OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                          OR A.ITEM_ID IN (SELECT COLUMN_VALUE
--                                             FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                            /* OR A.ITEM_ID MEMBER OF V_ITEM_TAB) */
                            OR A.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                             FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                           AND A.CUTOFF_DATE = V_BOH_DATE
                           AND A.CUTOFF_DATE > V_STOCK_DATE) IA            /* 현재일 - 3 */
                 ORDER BY IA.COMPANY_ID, IA.DIVISION_ID, IA.FROM_SITE, IA.PLANT_ID, IA.ITEM_ID, IA.STOCK_TYPE, IA.STORAGE_ID;

        END IF;

    END P_SSP0021_GET_STOCK_LOCATION_DETAIL;

    PROCEDURE P_SSP0021_GET_SHIPMENT_RESULT
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_FROM_YYYYMMDD         IN  VARCHAR2
       ,P_TO_YYYYMMDD           IN  VARCHAR2
       ,P_TYPE                  IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_MYMODELCHK            IN  VARCHAR2
       ,P_PARTLEADERCHK         IN  VARCHAR2
       ,P_TEAMLEADERCHK         IN  VARCHAR2
       ,P_DELEGATEECHK          IN  VARCHAR2
       ,P_NONCHK                IN  VARCHAR2
       ,P_REAL_FLAG             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_GET_SHIPMENT_RESULT
 * Description  : Shipment Shipment Result
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/09/26   AYJ            [CSR ID:4037234] 출하계획 대비 실적 Report 개발
 * 2019/12/04   juhlee         [C20191205-000132]  OWMS 출하실적에 반품 내용 적용 ( SSP_DNM_SHIP_RESULT_OWMS_V)
 * 2020/01/21   juhlee         [C20200121-000352]  ESS Packer출하 적용
                                - [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN <> 'Y' 조건제외)
 * 2020/02/12   KIMYONGHO      [C20200218-000135]  SHIP_TYPE 컬럼추가 및  FROM_STIE, TO_SITE Display 변경 CDOE - > Discription
 * 2020.05.06   KIMYONGHO      [C20200403-000062] [GSCM PI] SSP 출하 실적 집계 중 사외 창고 제외 로직 추가 건
 * 2020.09.15   KIMYONGHO      PLAN_SSP 조회시 AND 조건 일부 변경
 * 2020.09.18   KIMYONGHO      ERP_ORDER_TYPE 주석 처리 Request by 김광희 책임
 * 2021.02.17   KIMYONGHO      실적 조회시 TRNSPORT_MODE, INCOTERMS, ERP_SO_NO, ETA_DATE, ETD_DATE ERP 실적 기준으로 조회 Request by 김광희 책임
 * 2021.04.05   KIMYONGHO      [C20210330-000402] Shipment Plan화면의 실적 조회시 Sales site Mapping 안되는건에 대해서도 전수 표시 요청
 * 2021.05.03   SSP Pjt.       ERP_ORDER_TYPE 주석 처리 해제 Request by 김광희 책임
 * 2021.11.15   KIMYONGHO      Confirm Data Plan Date 기준 조회 처리
 * 2024.06.27   jilee          PrjCode, FP BOM 1Level Child Qty 조회 컬럼 추가
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
 * 2026.10.08   AJS          Model/Nickname 후속 : 후보 목록 비교 MEMBER OF → IN(TABLE) · Model 'ALL' 은 조건 없음 · 같은 조건을 실적 원장 6곳에도 먼저 적용(후보 1,000건 이하 MEMBER OF · 초과 IN(TABLE))
 */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
        V_ITEM_SMALL_YN         VARCHAR2(1) := 'N';   /* AJS 20261008 Model/Nickname : 후보 1,000건 이하면 Y — 실적 원장 단계 MEMBER OF(인덱스 단계에서 거름) */
        V_ITEM_BIG_YN           VARCHAR2(1) := 'N';   /* AJS 20261008 Model/Nickname : 후보 1,000건 초과면 Y — 실적 원장 단계 IN(TABLE) */
        V_ITEM_BIG_TAB          T_STR_TAB := T_STR_TAB();   /* AJS 20261008 Model/Nickname : 후보가 많을 때만 후보 목록 */
    BEGIN

        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치하는 품목을 먼저 고른다
           대상 품목 = 해당 사업부 품목 원장(코드 · 닉네임) + 입력값 그대로(기존 정확일치 유지) */
        IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT A.ITEM_ID
                      FROM SCM_MST_ITEM_SN A
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) B
                     WHERE B.COLUMN_VALUE IS NOT NULL
                       AND A.DIVISION_ID = P_DIVISION_ID
                       AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%'
                            OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%')
                    UNION
                    SELECT COLUMN_VALUE
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))
                     WHERE COLUMN_VALUE IS NOT NULL) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* AJS 20261008 Model/Nickname : 후보 수에 따라 실적 원장 단계 비교 방식 선택(결과 동일) */
        IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN   /* AJS 20261008 Model/Nickname */
            IF V_ITEM_TAB.COUNT <= 1000 THEN   /* AJS 20261008 Model/Nickname */
                V_ITEM_SMALL_YN := 'Y';   /* AJS 20261008 Model/Nickname */
            ELSE   /* AJS 20261008 Model/Nickname */
                V_ITEM_BIG_YN := 'Y';   /* AJS 20261008 Model/Nickname */
                V_ITEM_BIG_TAB := V_ITEM_TAB;   /* AJS 20261008 Model/Nickname */
            END IF;   /* AJS 20261008 Model/Nickname */
        END IF;   /* AJS 20261008 Model/Nickname */

        OPEN O_RC1 FOR
            SELECT IA.DIVISION_ID
                 , B.COMPANY_ID AS COMPANY_ID
                 , C.SEGMENT2 AS TYPE
                 , IA.ERP_SO_NO
                 , IA.CONFIRM_ID
                 , IA.PROJECT_CODE
                 , IA.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(IA.DIVISION_ID, IA.ITEM_ID) AS NICK_NAME
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(IA.DIVISION_ID, IA.FROM_SITE), IA.FROM_SITE) AS FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(IA.DIVISION_ID, IA.TO_SITE), IA.TO_SITE) AS TO_SITE
                 , IA.END_CUSTOMER
                 , IA.QTY
                 , IA.CHILD_QTY
                 , TO_CHAR(TO_DATE(IA.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') AS YYYYMMDD
                 , IA.TRANSPORT_MODE
                 , IA.INCOTERMS
                 , TO_CHAR(TO_DATE(IA.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETD_DATE
                 , TO_CHAR(TO_DATE(IA.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETA_DATE
                 , IA.SHIP_TYPE
              FROM (/* CONFIRM_ID ,날짜동일한 기준으로 계획정보의 FROM, TO SITE기준으로 실적 집계 */
                    SELECT XA.DIVISION_ID AS DIVISION_ID
                         , 'E' AS TYPE
                         , XA.ERP_SO_NO AS ERP_SO_NO
                         , XA.CONFIRM_ID AS CONFIRM_ID
                         , XA.PROJECT_CODE AS PROJECT_CODE
                         , XA.ITEM_ID AS ITEM_ID
                         , XA.FROM_SITE AS FROM_SITE
                         , XA.TO_SITE AS TO_SITE
                         , NULL AS END_CUSTOMER
                         , CASE WHEN P_DIVISION_ID = '82' THEN MAX(XA.RESULT_QTY) ELSE SUM(XA.RESULT_QTY) END AS QTY
                         , CASE WHEN P_DIVISION_ID = '82' THEN MAX(XA.RESULT_QTY * XB.CHILD_QTY) ELSE SUM(XA.RESULT_QTY * XB.CHILD_QTY) END AS CHILD_QTY
                         , XA.YYYYMMDD AS YYYYMMDD
                         , XA.TRANSPORT_MODE AS TRANSPORT_MODE
                         , XA.INCOTERMS AS INCOTERMS
                         , XA.ETD_DATE AS ETD_DATE
                         , XA.ETA_DATE AS ETA_DATE
                         , NULL AS SHIP_TYPE
                      FROM (/* ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 */
                            SELECT SA.DIVISION_ID AS DIVISION_ID
                                 , SA.CONFIRM_ID AS CONFIRM_ID
                                 , SA.ORDER_NO AS ERP_SO_NO
                                 , SA.EXFACTORY_DATE AS YYYYMMDD
                                 , SA.TRANSPORT_MODE AS TRANSPORT_MODE
                                 , SA.INCOTERMS AS INCOTERMS
                                 , SA.ETA_DATE AS ETA_DATE
                                 , SA.ETD_DATE AS ETD_DATE
                                 , SA.FROM_SCM_SITE_ID AS FROM_SITE
                                 , SA.TO_SCM_SITE_ID AS TO_SITE
                                 , SA.ITEM_ID AS ITEM_ID
                                 , SA.PROJECT_CODE AS PROJECT_CODE
                                 , SUM(SA.EXFACTORY_QTY) AS RESULT_QTY
                              FROM SCM_DNM_EXFACTORY_RESULT SA
                                 , SCM_ADM_LOOKUP_MASTER_DETAIL SB
                                 , SCM_MST_SITE SC
                                 , SCM_MST_ITEM_SN SD
                             WHERE SB.LOOKUP_TYPE = 'ERP_SSP_TYPE'              /* LOOKUP에 등록된 공정만 */
                               AND SB.VALID_YN = 'Y'
                               AND SB.SEGMENT1 = SA.SSP_TYPE
                               AND SA.FROM_SCM_SITE_ID = SC.SCM_SITE_ID
                               AND SA.DIVISION_ID = SC.DIVISION_ID
                               AND SC.SITE_TYPE = 'PLANT'
                               AND SA.ITEM_ID = SD.ITEM_ID
                               AND SA.DIVISION_ID = SD.DIVISION_ID
                               AND SC.COMPANY_ID = SD.COMPANY_ID
                               AND SD.ITEM_TYPE NOT IN ('Q', 'R')
                               AND NVL(SA.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')    /* D90: DO삭제 , D10:DO생성 */
                               AND SA.CONFIRM_ID LIKE 'C%'
                               AND SA.EXFACTORY_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                               AND (V_ITEM_SMALL_YN = 'N'   /* AJS 20261008 Model/Nickname : 바깥 Model 조건을 실적 원장 단계에서 먼저 적용(결과 동일) — 후보가 적을 때 */
                                OR SA.ITEM_ID MEMBER OF V_ITEM_TAB)   /* AJS 20261008 Model/Nickname */
                               AND (V_ITEM_BIG_YN = 'N'   /* AJS 20261008 Model/Nickname : 후보가 많을 때 */
                                OR SA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                    FROM TABLE(V_ITEM_BIG_TAB)))   /* AJS 20261008 Model/Nickname */
                             GROUP BY SA.DIVISION_ID
                                    , SA.CONFIRM_ID
                                    , SA.ORDER_NO
                                    , SA.EXFACTORY_DATE
                                    , SA.TRANSPORT_MODE
                                    , SA.INCOTERMS
                                    , SA.ETA_DATE
                                    , SA.ETD_DATE
                                    , SA.FROM_SCM_SITE_ID
                                    , SA.TO_SCM_SITE_ID
                                    , SA.PROJECT_CODE
                                    , SA.ITEM_ID) XA
                         , (/* FP BOM 1Level Child Qty */
                            SELECT SA.DIVISION_ID
                                 , SA.MODEL_ID
                                 , SA.CHILD_QTY
                              FROM SCM_MODEL_COMP_TEMP_SN SA
                                 , SCM_ITEM_M_SN SB
                                 , SCM_ITEM_CLASS_M_SN SC
                             WHERE SA.CHILD_COMPANY_ID = SB.COMPANY_ID
                               AND SA.CHILD_DIVISION_ID = SB.DIVISION_ID
                               AND SA.CHILD_SITE_ID = SB.SITE_ID
                               AND SA.CHILD_ITEM_ID = SB.ITEM_ID
                               AND SB.ITEM_CLASS = SC.CLASS_ID
                               AND SC.USE_FLAG = 'Y'
                               AND SA.DIVISION_ID = P_DIVISION_ID
                               AND SA.ALT_PRIORITY = 'Y'
                               AND NVL(SB.ITEM_TYPE, 'H') IN ('P', 'Q', 'H')
                               AND SB.FLOW_ID LIKE 'P%'
                               /* AND (CT.MODEL_ID LIKE 'EH%' OR CT.MODEL_ID LIKE 'EM%' OR CT.MODEL_ID LIKE 'EP%' ) */
                               AND (SA.CHILD_ITEM_ID LIKE 'EH%' OR SA.CHILD_ITEM_ID LIKE 'EM%' OR SA.CHILD_ITEM_ID LIKE 'EP%')) XB
                     WHERE XB.DIVISION_ID(+) = XA.DIVISION_ID
                       AND XB.MODEL_ID(+) = XA.ITEM_ID
                     GROUP BY XA.DIVISION_ID
                            , XA.ERP_SO_NO
                            , XA.FROM_SITE
                            , XA.TO_SITE
                            , XA.PROJECT_CODE
                            , XA.ITEM_ID
                            , XA.TRANSPORT_MODE
                            , XA.INCOTERMS
                            , XA.ETD_DATE
                            , XA.ETA_DATE
                            , XA.YYYYMMDD
                            , XA.CONFIRM_ID
                            , XB.CHILD_QTY
                    UNION ALL
                    /* CONFIRM_ID 없는 실적 */
                    SELECT XA.DIVISION_ID AS DIVISION_ID
                         , 'E' AS TYPE
                         , XA.ERP_SO_NO AS ERP_SO_NO
                         , NULL AS CONFIRM_ID
                         , XA.PROJECT_CODE AS PROJECT_CODE
                         , XA.ITEM_ID AS ITEM_ID
                         , XA.FROM_SITE AS FROM_SITE
                         , XA.TO_SITE AS TO_SITE
                         , NULL AS END_CUSTOMER
                         , XA.QTY AS QTY
                         , XA.QTY * XB.CHILD_QTY AS CHILD_QTY
                         , XA.YYYYMMDD AS YYYYMMDD
                         , XA.TRANSPORT_MODE AS TRANSPORT_MODE
                         , XA.INCOTERMS AS INCOTERMS
                         , XA.ETD_DATE AS ETD_DATE
                         , XA.ETA_DATE AS ETA_DATE
                         , NULL AS SHIP_TYPE
                      FROM (/* ERP 출하실적에서 CONFIRM_ID 없는 실적 */
                            SELECT SA.DIVISION_ID AS DIVISION_ID
                                 , '-' AS CONFIRM_ID
                                 , SA.ORDER_NO AS ERP_SO_NO
                                 , SA.FROM_SCM_SITE_ID AS FROM_SITE
                                 , NVL(SG.SEGMENT4, SA.TO_SCM_SITE_ID) AS TO_SITE
                                 , SA.ITEM_ID AS ITEM_ID
                                 , SA.EXFACTORY_DATE AS YYYYMMDD
                                 , SA.TRANSPORT_MODE AS TRANSPORT_MODE
                                 , SA.INCOTERMS AS INCOTERMS
                                 , SA.ETA_DATE AS ETA_DATE
                                 , SA.ETD_DATE AS ETD_DATE
                                 , SA.PROJECT_CODE AS PROJECT_CODE
                                 , SUM(SA.EXFACTORY_QTY) AS QTY
                              FROM SCM_DNM_EXFACTORY_RESULT SA
                                 , SCM_MST_SITE SB
                                 , SCM_MST_ITEM_SN SC
                                 , SCP_MST_FINAL_ITEM SD
                                 , SCM_MST_SITE SE
                                 , SCM_ADM_LOOKUP_MASTER_DETAIL SF
                                 , SCM_ADM_LOOKUP_MASTER_DETAIL SG
                             WHERE SA.FROM_SCM_SITE_ID = SB.SCM_SITE_ID
                               AND SA.DIVISION_ID = SB.DIVISION_ID
                               AND SB.SITE_TYPE = 'PLANT'
                               AND SA.ITEM_ID = SC.ITEM_ID
                               AND SA.DIVISION_ID = SC.DIVISION_ID
                               AND SB.COMPANY_ID = SC.COMPANY_ID
                               AND SC.ITEM_TYPE NOT IN ('Q', 'R')
                               AND SD.ITEM_ID = SA.ITEM_ID                      /* SCP 대상 ITEM만 */
                               AND SD.DIVISION_ID = SA.DIVISION_ID
                               AND SE.SCM_SITE_ID = SA.FROM_SCM_SITE_ID
                               AND SE.DIVISION_ID = SA.DIVISION_ID
                               AND SF.LOOKUP_TYPE = 'ERP_ORDER_TYPE'            /* LOOKUP에 등록된 ORDER_TYPE만 대상으로 함 */
                               AND SF.VALID_YN = 'Y'
                               AND SF.SEGMENT1 = SA.ORDER_TYPE_CODE
                               AND SG.LOOKUP_TYPE(+) = 'SHIP_RESULT_TO_SITE_MAPPING'    /* SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE */
                               AND SG.SEGMENT1(+) = SA.DIVISION_ID
                               AND SG.SEGMENT2(+) = SA.SOLDTO_CODE
                               AND SG.SEGMENT3(+) = SA.SHIPTO_CODE
                               AND NVL(SA.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')    /* D90: DO삭제 , D10:DO생성 */
                               AND (SA.CONFIRM_ID IS NULL OR SA.CONFIRM_ID NOT LIKE 'C%')
                               AND SA.EXFACTORY_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                               AND (V_ITEM_SMALL_YN = 'N'   /* AJS 20261008 Model/Nickname : 바깥 Model 조건을 실적 원장 단계에서 먼저 적용(결과 동일) — 후보가 적을 때 */
                                OR SA.ITEM_ID MEMBER OF V_ITEM_TAB)   /* AJS 20261008 Model/Nickname */
                               AND (V_ITEM_BIG_YN = 'N'   /* AJS 20261008 Model/Nickname : 후보가 많을 때 */
                                OR SA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                    FROM TABLE(V_ITEM_BIG_TAB)))   /* AJS 20261008 Model/Nickname */
                               AND SA.STORAGE_ID NOT IN ('6000', '799A')        /* 상품창고제외 */
                               AND NOT EXISTS (SELECT 1
                                                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL SH
                                                WHERE SH.SEGMENT1 = SA.STORAGE_ID
                                                  AND SH.LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
                                                  AND SH.VALID_YN = 'Y')        /* 사외 창고 제외 LOOKUP 관리 */
                             GROUP BY SA.DIVISION_ID
                                    , SA.ORDER_NO
                                    , SA.FROM_SCM_SITE_ID
                                    , NVL(SG.SEGMENT4, SA.TO_SCM_SITE_ID)
                                    , SA.PROJECT_CODE
                                    , SA.ITEM_ID
                                    , SA.EXFACTORY_DATE
                                    , SA.TRANSPORT_MODE
                                    , SA.INCOTERMS
                                    , SA.ETA_DATE
                                    , SA.ETD_DATE
                                    , SA.FROM_SCM_SITE_ID
                                    , SA.TO_SCM_SITE_ID) XA
                         , (/* FP BOM 1Level Child Qty */
                            SELECT SA.DIVISION_ID
                                 , SA.MODEL_ID
                                 , SA.CHILD_QTY
                              FROM SCM_MODEL_COMP_TEMP_SN SA
                                 , SCM_ITEM_M_SN SB
                                 , SCM_ITEM_CLASS_M_SN SC
                             WHERE SA.CHILD_COMPANY_ID = SB.COMPANY_ID
                               AND SA.CHILD_DIVISION_ID = SB.DIVISION_ID
                               AND SA.CHILD_SITE_ID = SB.SITE_ID
                               AND SA.CHILD_ITEM_ID = SB.ITEM_ID
                               AND SB.ITEM_CLASS = SC.CLASS_ID
                               AND SC.USE_FLAG = 'Y'
                               AND SA.DIVISION_ID = P_DIVISION_ID
                               AND SA.ALT_PRIORITY = 'Y'
                               AND NVL(SB.ITEM_TYPE, 'H') IN ('P', 'Q', 'H')
                               AND SB.FLOW_ID LIKE 'P%'
                               AND (SA.CHILD_ITEM_ID LIKE 'EH%' OR SA.CHILD_ITEM_ID LIKE 'EM%' OR SA.CHILD_ITEM_ID LIKE 'EP%')) XB
                     WHERE XB.DIVISION_ID(+) = XA.DIVISION_ID
                       AND XB.MODEL_ID(+) = XA.ITEM_ID
                    UNION ALL
                    SELECT XA.DIVISION_ID AS DIVISION_ID
                         , 'P' AS TYPE
                         , XA.ERP_SO_NO AS ERP_SO_NO
                         , XA.CONFIRM_ID AS CONFIRM_ID
                         , NULL AS PROJECT_CODE
                         , XA.ITEM_ID AS ITEM_ID
                         , XA.FROM_SITE AS FROM_SITE
                         , XA.TO_SITE AS TO_SITE
                         , XA.END_CUSTOMER AS END_CUSTOMER
                         , XA.QTY AS QTY
                         , NULL AS CHILD_QTY
                         , XA.YYYYMMDD AS YYYYMMDD
                         , XA.TRANSPORT_MODE AS TRANSPORT_MODE
                         , XA.INCOTERMS AS INCOTERMS
                         , XA.ETD_DATE AS ETD_DATE
                         , XA.ETA_DATE AS ETA_DATE
                         , NULL AS SHIP_TYPE
                      FROM (/* SSP출하계획 ( confirm된 계획) - Current Version */
                            SELECT SA.DIVISION_ID AS DIVISION_ID
                                 , SA.ERP_SO_NO AS ERP_SO_NO
                                 , SA.CONFIRM_ID AS CONFIRM_ID
                                 , SA.ITEM_ID AS ITEM_ID
                                 , SA.FROM_SITE AS FROM_SITE
                                 , SA.TO_SITE AS TO_SITE
                                 , CASE WHEN SA.DIVISION_ID = '4O' THEN NVL(SD.PROJECT_CODE, '-')
                                        ELSE NVL(SE.END_CUSTOMER, '-')
                                   END AS END_CUSTOMER
                                 , SA.QTY AS QTY
                                 , SA.YYYYMMDD AS YYYYMMDD
                                 , SA.TRANSPORT_MODE AS TRANSPORT_MODE
                                 , SA.INCOTERMS AS INCOTERMS
                                 , SA.ETD_DATE AS ETD_DATE
                                 , SA.ETA_DATE AS ETA_DATE
                              FROM SSP_ANL_SHIP_CONFIRM SA
                                 , SCM_MST_SITE SB
                                 , SCM_MST_ITEM_SN SC
                                 , SCM_MST_SITE_ITEM SD
                                 , SCM_MST_SITE SE
                             WHERE SA.FROM_SITE = SB.SCM_SITE_ID
                               AND SA.DIVISION_ID = SB.DIVISION_ID
                               AND SB.SITE_TYPE = 'PLANT'
                               AND SA.ITEM_ID = SC.ITEM_ID
                               AND SA.DIVISION_ID = SC.DIVISION_ID
                               AND SB.COMPANY_ID = SC.COMPANY_ID
                               AND SC.ITEM_TYPE NOT IN ('Q', 'R')
                               AND SD.DIVISION_ID(+) = SA.DIVISION_ID
                               AND SD.ITEM_ID(+) = SA.ITEM_ID
                               AND SD.SCM_SITE_ID(+) = SA.TO_SITE
                               AND SD.PROJECT_CODE(+) = SA.PROJECT_CODE
                               AND SE.DIVISION_ID(+) = SA.DIVISION_ID
                               AND SE.SCM_SITE_ID(+) = SA.TO_SITE
                               AND SA.CHANGE_TYPE = 'C'
                               AND SA.QTY > 0
                               AND P_REAL_FLAG = 'Y'
                               AND (V_ITEM_SMALL_YN = 'N'   /* AJS 20261008 Model/Nickname : 바깥 Model 조건을 실적 원장 단계에서 먼저 적용(결과 동일) — 후보가 적을 때 */
                                OR SA.ITEM_ID MEMBER OF V_ITEM_TAB)   /* AJS 20261008 Model/Nickname */
                               AND (V_ITEM_BIG_YN = 'N'   /* AJS 20261008 Model/Nickname : 후보가 많을 때 */
                                OR SA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                    FROM TABLE(V_ITEM_BIG_TAB)))   /* AJS 20261008 Model/Nickname */
                               /* 2020.09.15 KIMYONGHO   PLAN_SSP 조회시 AND 조건 일부 변경 */
                               /* ERP 출하 구간과 SSP 출하계획일 구간 미스매치로 일부 데이터 누락될수있음. */
                               /* AND   YYYYMMDD BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd */
                            UNION ALL
                            /* SSP출하계획 ( confirm된 계획) - OLD Version */
                            SELECT SA.DIVISION_ID AS DIVISION_ID
                                 , SA.ERP_SO_NO AS ERP_SO_NO
                                 , SA.CONFIRM_ID AS CONFIRM_ID
                                 , SA.ITEM_ID AS ITEM_ID
                                 , SA.FROM_SITE AS FROM_SITE
                                 , SA.TO_SITE AS TO_SITE
                                 , CASE WHEN SA.DIVISION_ID = '4O' THEN NVL(SD.PROJECT_CODE, '-')
                                        ELSE NVL(SE.END_CUSTOMER, '-')
                                   END AS END_CUSTOMER
                                 , SA.SHIPMENT_CONFIRM_QTY AS QTY
                                 , SA.YYYYMMDD AS YYYYMMDD
                                 , SA.TRANSPORT_MODE AS TRANSPORT_MODE
                                 , SA.INCOTERMS AS INCOTERMS
                                 , SA.ETD AS ETD_DATE
                                 , SA.ETA AS ETA_DATE
                              FROM SSP_ANL_SHIP_PLAN_ALL SA
                                 , SCM_MST_ITEM_SN SB
                                 , SCM_MST_SITE SC
                                 , SCM_MST_SITE_ITEM SD
                                 , SCM_MST_SITE SE
                             WHERE SA.ITEM_ID = SB.ITEM_ID
                               AND SA.DIVISION_ID = SB.DIVISION_ID
                               AND SA.COMPANY_ID = SB.COMPANY_ID
                               AND SB.ITEM_TYPE NOT IN ('Q', 'R')
                               AND SA.DIVISION_ID = SC.DIVISION_ID
                               AND SA.FROM_SITE = SC.SCM_SITE_ID
                               AND SC.SITE_TYPE = 'PLANT'
                               AND SA.DIVISION_ID = P_DIVISION_ID
                               AND SC.OPERATION_GROUP <> 'E'
                               AND SD.DIVISION_ID(+) = SA.DIVISION_ID
                               AND SD.ITEM_ID(+) = SA.ITEM_ID
                               AND SD.SCM_SITE_ID(+) = SA.TO_SITE
                               AND SD.PROJECT_CODE(+) = SA.PROJECT_CODE
                               AND SE.DIVISION_ID(+) = SA.DIVISION_ID
                               AND SE.SCM_SITE_ID(+) = SA.TO_SITE
                               AND SA.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                               AND SA.SHIPMENT_STATUS = 'C'
                               AND SA.SHIPMENT_CONFIRM_QTY > 0
                               AND (V_ITEM_SMALL_YN = 'N'   /* AJS 20261008 Model/Nickname : 바깥 Model 조건을 실적 원장 단계에서 먼저 적용(결과 동일) — 후보가 적을 때 */
                                OR SA.ITEM_ID MEMBER OF V_ITEM_TAB)   /* AJS 20261008 Model/Nickname */
                               AND (V_ITEM_BIG_YN = 'N'   /* AJS 20261008 Model/Nickname : 후보가 많을 때 */
                                OR SA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                    FROM TABLE(V_ITEM_BIG_TAB)))   /* AJS 20261008 Model/Nickname */
                               AND P_REAL_FLAG = 'N') XA
                     WHERE XA.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                    UNION ALL
                    /* OWMS 실적 */
                    SELECT XA.DIVISION_ID AS DIVISION_ID
                         , 'O' AS TYPE
                         , NULL AS ERP_SO_NO
                         , NULL AS CONFIRM_ID
                         , NULL AS PROJECT_CODE
                         , XA.ITEM_ID AS ITEM_ID
                         , XA.FROM_SITE AS FROM_SITE
                         , XA.TO_SITE AS TO_SITE
                         , NULL AS END_CUSTOMER
                         , XA.QTY AS QTY
                         , NULL AS CHILD_QTY
                         , XA.YYYYMMDD AS YYYYMMDD
                         , NULL AS TRANSPORT_MODE
                         , NULL AS INCOTERMS
                         , NULL AS ETD_DATE
                         , NULL AS ETA_DATE
                         , XA.SHIP_TYPE AS SHIP_TYPE
                      FROM (/* owms 출하실적 */
                            SELECT SA.DIVISION_ID AS DIVISION_ID
                                 , SA.ITEM_ID AS ITEM_ID
                                 , SA.FROM_SITE AS FROM_SITE
                                 , CASE WHEN SA.TO_SITE = '-' THEN SA.CUSTOMER_CODE ELSE SA.TO_SITE END AS TO_SITE
                                 , SUM(SA.LOT_QTY) AS QTY
                                 , SA.PLANT_ISSUE_DATE AS YYYYMMDD
                                 , SA.SHIP_TYPE AS SHIP_TYPE
                              FROM SSP_DNM_SHIP_RESULT_OWMS SA
                             WHERE SA.PLANT_ISSUE_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                               AND (V_ITEM_SMALL_YN = 'N'   /* AJS 20261008 Model/Nickname : 바깥 Model 조건을 실적 원장 단계에서 먼저 적용(결과 동일) — 후보가 적을 때 */
                                OR SA.ITEM_ID MEMBER OF V_ITEM_TAB)   /* AJS 20261008 Model/Nickname */
                               AND (V_ITEM_BIG_YN = 'N'   /* AJS 20261008 Model/Nickname : 후보가 많을 때 */
                                OR SA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                    FROM TABLE(V_ITEM_BIG_TAB)))   /* AJS 20261008 Model/Nickname */
                             GROUP BY SA.DIVISION_ID
                                    , SA.ITEM_ID
                                    , SA.FROM_SITE
                                    , CASE WHEN SA.TO_SITE = '-' THEN SA.CUSTOMER_CODE ELSE SA.TO_SITE END
                                    , SA.PLANT_ISSUE_DATE
                                    , SA.SHIP_TYPE) XA
                    UNION ALL
                    /* OWMS 반품실적 */
                    SELECT XA.DIVISION_ID AS DIVISION_ID
                         , 'R' AS TYPE
                         , NULL AS ERP_SO_NO
                         , NULL AS CONFIRM_ID
                         , NULL AS PROJECT_CODE
                         , XA.ITEM_ID AS ITEM_ID
                         , XA.FROM_SITE AS FROM_SITE
                         , XA.TO_SITE AS TO_SITE
                         , NULL AS END_CUSTOMER
                         , XA.QTY AS QTY
                         , NULL AS CHILD_QTY
                         , XA.YYYYMMDD AS YYYYMMDD
                         , NULL AS TRANSPORT_MODE
                         , NULL AS INCOTERMS
                         , NULL AS ETD_DATE
                         , NULL AS ETA_DATE
                         , XA.SHIP_TYPE AS SHIP_TYPE
                      FROM (/* owms 출하 반품 */
                            SELECT SA.DIVISION_ID AS DIVISION_ID
                                 , SA.ITEM_ID AS ITEM_ID
                                 , SA.FROM_SITE AS FROM_SITE
                                 , '*' AS TO_SITE
                                 , SUM(SA.RECIEPT_QTY) AS QTY
                                 , SA.RECIEPT_DATE AS YYYYMMDD
                                 , NULL AS SHIP_TYPE
                              FROM SSP_DNM_SHIP_RETURN_OWMS SA
                             WHERE SA.RECIEPT_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                               AND (V_ITEM_SMALL_YN = 'N'   /* AJS 20261008 Model/Nickname : 바깥 Model 조건을 실적 원장 단계에서 먼저 적용(결과 동일) — 후보가 적을 때 */
                                OR SA.ITEM_ID MEMBER OF V_ITEM_TAB)   /* AJS 20261008 Model/Nickname */
                               AND (V_ITEM_BIG_YN = 'N'   /* AJS 20261008 Model/Nickname : 후보가 많을 때 */
                                OR SA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                    FROM TABLE(V_ITEM_BIG_TAB)))   /* AJS 20261008 Model/Nickname */
                             GROUP BY SA.DIVISION_ID
                                    , SA.ITEM_ID
                                    , SA.FROM_SITE
                                    , SA.RECIEPT_DATE) XA) IA
                 , SCM_MST_SITE B
                 , SCM_ADM_LOOKUP_MASTER_DETAIL C
                 , SSP_MST_MODEL_USER D
             WHERE B.DIVISION_ID = IA.DIVISION_ID
               AND B.SCM_SITE_ID = IA.FROM_SITE
               AND B.OPERATION_GROUP <> 'E'
               AND C.LOOKUP_TYPE = 'SSP_SHIPMENT_RESULT_TYPE'                   /* LOOKUP에 등록된 공정만 */
               AND C.SEGMENT1 = IA.TYPE
               AND C.VALID_YN = 'Y'
               AND D.DIVISION_ID(+) = IA.DIVISION_ID
               AND D.FROM_SITE(+) = IA.FROM_SITE
               AND D.ITEM_ID(+) = IA.ITEM_ID
               AND D.VALID_YN(+) = 'Y'
               AND IA.DIVISION_ID = P_DIVISION_ID
               AND (TRIM(P_COMPANY_ID) IS NULL
                OR B.COMPANY_ID = P_COMPANY_ID)
               AND (TRIM(P_FROM_SITE) IS NULL
                OR IA.FROM_SITE IN (SELECT COLUMN_VALUE
                                      FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
               AND (TRIM(P_ITEM_ID) IS NULL
                OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--              OR IA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                /* OR IA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                OR IA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                  FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
               AND (TRIM(P_TYPE) IS NULL
                OR IA.TYPE IN (SELECT COLUMN_VALUE
                                 FROM TABLE(STRING_SPLIT(P_TYPE, ','))))
               /* 체크박스 체크 여부 조회 시작(@p_nonChk = 'Y' : 체크박스 선택 안한 상태) */
               AND (P_NONCHK = 'Y'
                OR D.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                   FROM DUAL
                                  UNION
                                 SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN XA.USER_ID ELSE 'X' END
                                   FROM SSP_MST_DELEGATE XA
                                  WHERE XA.VALID_YN = 'Y'
                                    AND XA.DELEGATEE_ID = P_USER_ID
                                  GROUP BY XA.USER_ID)
                OR D.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                OR D.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
               /* 체크박스 체크 여부 조회 끝 */
             ORDER BY IA.DIVISION_ID, IA.FROM_SITE, IA.YYYYMMDD, IA.ITEM_ID, IA.TO_SITE, C.DISPLAY_SEQ, IA.CONFIRM_ID;

    END P_SSP0021_GET_SHIPMENT_RESULT;

    PROCEDURE P_SSP0021_GET_SHIPMENT_PLAN
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_FROM_YYYYMMDD         IN  VARCHAR2
       ,P_TO_YYYYMMDD           IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,P_REAL_FLAG             IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_GET_SHIPMENT_PLAN
 * Description  : 자동차 Shipment Plan
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/08/30   mcThej         Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 * 2019/10/14   mcThej         Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT - ERP_QTY (ssp->scp), 속도 수정
 * 2019/10/15   juhlee         Pack 생산 창고 추가 CMA_BMA . 2019.10.15 (requested by 김광희)
 * 2019/10/15   mcThej         MES 추가
 * 2019/10/17   juhlee         Pack 생산 창고 추가 CMA_BMA BOH수량에 추가  (requested by 김광희)
 * 2019/10/28   mcThej         BOH = BOH + MES_TOTAL - (MES_OQC_NG + MES_QMS/MES_HOLD)
 * 2020/01/21   juhlee         [C20200121-000352]  ESS Packer출하 적용
                                - [C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V)
                                - [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외)
                                - [C20200121-000352]-3 : Production Plan Measure에 Paker생산계획 추가(SCP_ANL_PRODUCTION_PLAN 의 PROD_PLAN_AMEND measure)
 * 2020/02/13   KIMYONGHO      CONTAINER Measure 수식 변경 , MAIN SHEET 조회 시 TO_SITE 구별 할수 없어 SUM -> MAX 로 변경
 * 2020/03/17   juhlee         BOH 수량에 CMA_BMA 제외 (requested by 김광희)
 * 2021/06/01   SSP Pjt.       AS ERP 재고 적용
 * 2021/06/14   SSP Pjt.       화면속도개선(SCM_DNM_STOCK_V -> SSP_DNM_STOCK_C)
 * 2022/02/16   SSP Pjt.       SSP_DNM_MES_STOCK_81_82 -> SSP_DNM_GMES_STOCK_81_82
 * 2022.04.23   SSP Pjt.       C20220419-000607 / SSP~oWMS 사외창고 재고 I/F개선 요청
 * 2023/09/01   jilee          반제품->제품 코드 변환 작업
 * 2024/02/19   jilee          SSP - NEW FP Ship Avaliable 신규 I/F 반영
 * 2024/05/10   hsbang         확정구간 조회 일수(CONFIRM_DAY)를 펑션 FN_GET_ANL_SHIP_FROZEN_DAY_CNT] 에서 가져오도록 반영
 * 2024/10/01   KHJ            NERP_SSP
 * 2026/07/13   강주용         [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정
 * 2026/08/13   강주용         [E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.06   AJS          조회 속도 개선 - 입고예정(PROD_PLAN) 도착일 함수를 인자 조합마다 1회 호출(결과 동일)
 * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
 * 2026.10.08   AJS          Model/Nickname 후속 : 후보 목록 비교 MEMBER OF → IN(TABLE) · Model 'ALL' 은 조건 없음
 */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
        V_FROM_YYYYMMDD         VARCHAR2(8);
        V_TO_YYYYMMDD           VARCHAR2(8);
        V_BOH_YYYYMMDD          VARCHAR2(8);
        V_STOCK_YYYYMMDD        VARCHAR2(8);
        V_BOH_DATE              DATE;
        V_STOCK_DATE            DATE;
        V_CNT_USR_MEASURE       NUMBER := 0;
        V_APP_TYPE              VARCHAR2(8) := 'SSP';
        V_QRY_SUM               CLOB;
        V_EXEC                  CLOB;
        /* FP 자동생성 대상 계산용 */
        V_TMP_WH_STOCK          NUMBER;
        V_TMP_SP_QTY            NUMBER;
        V_TMP_FP_QTY            NUMBER;
        V_TMP_CFM_QTY           NUMBER;
        V_FROZEN_YYYYMMDD       VARCHAR2(8);
    BEGIN

        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치하는 품목을 먼저 고른다
           대상 품목 = 해당 사업부 품목 원장(코드 · 닉네임) + 입력값 그대로(기존 정확일치 유지) */
        IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT A.ITEM_ID
                      FROM SCM_MST_ITEM_SN A
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) B
                     WHERE B.COLUMN_VALUE IS NOT NULL
                       AND A.DIVISION_ID = P_DIVISION_ID
                       AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%'
                            OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%')
                    UNION
                    SELECT COLUMN_VALUE
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))
                     WHERE COLUMN_VALUE IS NOT NULL) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        V_FROM_YYYYMMDD := TO_CHAR(TO_DATE(SUBSTR(REPLACE(P_FROM_YYYYMMDD, '-', ''), 1, 8), 'YYYYMMDD'), 'YYYYMMDD');
        V_TO_YYYYMMDD := TO_CHAR(TO_DATE(SUBSTR(REPLACE(P_TO_YYYYMMDD, '-', ''), 1, 8), 'YYYYMMDD'), 'YYYYMMDD');
        V_BOH_YYYYMMDD := TO_CHAR(TO_DATE(SUBSTR(REPLACE(P_FROM_YYYYMMDD, '-', ''), 1, 8), 'YYYYMMDD') - 1, 'YYYYMMDD');    /* FROM -1일 */
        V_STOCK_YYYYMMDD := TO_CHAR(TO_DATE(SUBSTR(REPLACE(P_FROM_YYYYMMDD, '-', ''), 1, 8), 'YYYYMMDD') - 3, 'YYYYMMDD');  /* FROM -3일 */

        /* 재고 테이블의 CUTOFF_DATE 는 날짜 형이라 값 쪽을 날짜로 맞춘다(칸에는 함수 미사용) */
        V_BOH_DATE := TO_DATE(V_BOH_YYYYMMDD, 'YYYYMMDD');
        V_STOCK_DATE := TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD');

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID = P_USER_ID;

        /********************************************************************************
        * 임시테이블만들기
        ********************************************************************************/
        DELETE FROM GT_0021_BOH_STORAGE;
        DELETE FROM GT_0021_BOH;
        DELETE FROM GT_0021_ROWDATA;
        DELETE FROM GT_0021_RESULT;
        DELETE FROM GT_0021_PIVOT;
        DELETE FROM GT_0021_PIVOT_OLD;
        DELETE FROM GT_0021_TITLESET;

        INSERT INTO GT_0021_TITLESET
        (
            COLUMN_NAME
        )
        SELECT COLUMN_NAME
          FROM SCM_MST_TITLESET_USER
         WHERE PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID = P_USER_ID;

        /********************************************************************************/

        /*--//////////////////////////////////////////////////////////////////////////////--*/
        /*--//1. BOH																	//--*/
        /*--//////////////////////////////////////////////////////////////////////////////--*/
        INSERT INTO GT_0021_BOH_STORAGE
        (
            DIVISION_ID
          , FROM_SITE
          , ITEM_ID
          , YYYYMMDD
          , BOH_TYPE
          , BOH_QTY
          , SEQ
        )
        SELECT IA.DIVISION_ID
             , IA.FROM_SITE
             , NVL(C.APPLIED_MODEL, IA.ITEM_ID) AS ITEM_ID
             , IA.YYYYMMDD
             , IA.BOH_TYPE AS BOH_TYPE
             , SUM(IA.BOH_QTY) AS BOH_QTY
             , IA.SEQ
          FROM (/* MES 기준 BOH : 5S */
                SELECT XA.DIVISION_ID
                     , XA.FROM_SITE
                     , XA.ITEM_ID
                     , XA.BOH_TYPE
                     , XA.YYYYMMDD
                     , SUM(XA.BOH_QTY) AS BOH_QTY
                     , XA.SEQ
                  FROM (SELECT SA.DIVISION_ID
                             , SA.FROM_SITE
                             , SA.ITEM_ID
                             , 'BOH' AS BOH_TYPE
                             , SA.YYYYMMDD
                             , NVL(SUM(SA.TOTAL) - (SUM(SA.OQC_NG) + SUM(SA.QMS_MES_HOLD)), 0) AS BOH_QTY
                             , 5 AS SEQ
                          FROM (SELECT DIVISION_ID
                                     , FROM_SITE
                                     , ITEM_ID
                                     , V_BOH_YYYYMMDD AS YYYYMMDD
                                     , CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT = 'N' THEN SUM(NVL(LOT_QTY, 0)) ELSE 0 END AS OQC_NG
                                     , CASE WHEN AVAILABLE_YN = 'N' AND (QMS_HOLD_YN = 'Y' OR MES_HOLD_YN = 'Y') THEN SUM(NVL(LOT_QTY, 0)) ELSE 0 END AS QMS_MES_HOLD
                                     , SUM(NVL(LOT_QTY, 0)) AS TOTAL
                                  FROM SSP_DNM_GMES_STOCK_81_82
                                 WHERE DIVISION_ID = P_DIVISION_ID
                                   AND COMPANY_ID = P_COMPANY_ID
                                   AND YYYYMMDD = P_PLAN_START_YYYYMMDD
                                   AND (TRIM(P_FROM_SITE) IS NULL
                                    OR FROM_SITE IN (SELECT COLUMN_VALUE
                                                       FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                                   AND (TRIM(P_ITEM_ID) IS NULL
                                    OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                                  OR ITEM_ID IN (SELECT COLUMN_VALUE
--                                                   FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                                    /* OR ITEM_ID MEMBER OF V_ITEM_TAB) */
                                    OR ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                   FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                                 GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, AVAILABLE_YN, OQC_INSP_RESULT, MES_HOLD_YN, QMS_HOLD_YN) SA
                         GROUP BY SA.DIVISION_ID, SA.FROM_SITE, SA.ITEM_ID, SA.YYYYMMDD
                        UNION ALL
                        SELECT SA.DIVISION_ID
                             , SA.FROM_SITE
                             , SA.ITEM_ID
                             , 'BOH' AS BOH_TYPE
                             , SA.CUTOFF_DATE AS YYYYMMDD
                             , SUM(SA.AVAILABLE_QTY) AS BOH_QTY
                             , 5 AS SEQ                                         /* MEASURE 위치와 동일하게 */
                          FROM SSP_ANL_OWMS_STOCK_C2 SA
                             , SCM_ADM_LOOKUP_MASTER_DETAIL SB
                         WHERE SB.LOOKUP_TYPE = 'OWMS_STOCK_STATUS'             /* C20220419-000607 */
                           AND SB.VALID_YN = 'Y'
                           AND SB.ATTRIBUTE1 = 'Y'
                           AND SB.SEGMENT1 = SA.STOCK_STATUS
                           AND SA.DIVISION_ID = P_DIVISION_ID
                           AND SA.COMPANY_ID = P_COMPANY_ID
                           AND SA.CUTOFF_DATE = V_BOH_YYYYMMDD
                           AND (TRIM(P_FROM_SITE) IS NULL
                            OR SA.FROM_SITE IN (SELECT COLUMN_VALUE
                                                  FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                           AND (TRIM(P_ITEM_ID) IS NULL
                            OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                          OR SA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                              FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                            /* OR SA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                            OR SA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                              FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                         GROUP BY SA.DIVISION_ID, SA.FROM_SITE, SA.ITEM_ID, SA.CUTOFF_DATE) XA
                 GROUP BY XA.DIVISION_ID, XA.FROM_SITE, XA.ITEM_ID, XA.BOH_TYPE, XA.YYYYMMDD, XA.SEQ
                UNION ALL
                /* ERP 재고 : 6S */
                SELECT XA.DIVISION_ID AS DIVISION_ID
                     , XA.SCM_SITE_ID AS FROM_SITE
                     , XA.ITEM_ID AS ITEM_ID
                     , 'ERP' AS BOH_TYPE
                     , TO_CHAR(XA.CUTOFF_DATE, 'YYYYMMDD') AS YYYYMMDD
                     , XA.SCM_QTY AS BOH_QTY
                     , 6 AS SEQ                                                 /* MEASURE 위치와 동일하게 */
                  FROM (SELECT SA.DIVISION_ID
                             , SA.COMPANY_ID
                             , SA.SCM_SITE_ID
                             , SA.ITEM_ID
                             , SA.SSP_QTY
                             , SA.SCM_QTY
                             , SA.CUTOFF_DATE
                             , SA.SITE_ID
                             , SA.STORAGE_ID
                             , SA.PLANT_ID
                             , SA.OPERATION_ID
                             , SA.STOCK_TYPE
                          FROM SSP_DNM_STOCK_C SA                               /* SCM_DNM_STOCK_V */
                         WHERE SA.DIVISION_ID = P_DIVISION_ID
                           AND SA.COMPANY_ID = P_COMPANY_ID
                           AND SA.CUTOFF_DATE > V_STOCK_DATE                    /* 현재일 - 3 */
                           AND SA.CUTOFF_DATE = V_BOH_DATE
                           AND (TRIM(P_FROM_SITE) IS NULL
                            OR SA.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                    FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                           AND (TRIM(P_ITEM_ID) IS NULL
                            OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                          OR SA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                              FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))) XA
                            /* OR SA.ITEM_ID MEMBER OF V_ITEM_TAB)) XA */
                            OR SA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                              FROM TABLE(V_ITEM_TAB)))) XA   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                     , (SELECT SA.DIVISION_ID
                             , SA.STORAGE_ID
                             , SA.SCM_SITE_ID
                             , SA.LOCATION_CODE
                             , SA.PLANT_ID
                             , SB.COMPANY_ID
                             , SA.VALID_YN
                          FROM SSP_MST_LOCATION_V SA
                             , SCM_MST_SITE SB
                         WHERE SA.DIVISION_ID = SB.DIVISION_ID
                           AND SA.SCM_SITE_ID = SB.SCM_SITE_ID
                           AND SA.PLANT_ID = SB.PLANT_ID
                           AND SB.DIVISION_ID = P_DIVISION_ID
                           AND SB.COMPANY_ID = P_COMPANY_ID
                           AND SB.VALID_YN = 'Y'
                           AND SB.SITE_TYPE = 'PLANT'
                           AND SA.VALID_YN = 'Y'
                           AND SA.DIVISION_ID = P_DIVISION_ID
                           AND SB.COMPANY_ID = P_COMPANY_ID
                           AND SA.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING', 'CMA_BMA')
                           AND (TRIM(P_FROM_SITE) IS NULL
                            OR SA.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                    FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                         GROUP BY SA.DIVISION_ID, SA.STORAGE_ID, SA.SCM_SITE_ID, SA.LOCATION_CODE, SA.PLANT_ID, SB.COMPANY_ID, SA.VALID_YN
                        UNION ALL
                        SELECT DISTINCT SA.SEGMENT1 AS DIVISION_ID
                             , SA.SEGMENT4 AS STORAGE_ID
                             , SA.SEGMENT2 AS SCM_SITE_ID
                             , 'AS' AS LOCATION_CODE
                             , SA.SEGMENT3 AS PLANT_ID
                             , SB.COMPANY_ID
                             , SA.VALID_YN
                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                             , SCM_MST_SITE SB
                         WHERE SA.SEGMENT1 = SB.DIVISION_ID
                           AND SA.SEGMENT2 = SB.SCM_SITE_ID
                           AND SA.SEGMENT3 = SB.PLANT_ID
                           AND SA.LOOKUP_TYPE = 'SSP_AS_DIV_SLOC'
                           AND SA.VALID_YN = 'Y'
                           AND SB.DIVISION_ID = P_DIVISION_ID
                           AND SB.COMPANY_ID = P_COMPANY_ID
                           AND SB.VALID_YN = 'Y'
                           AND SB.SITE_TYPE = 'PLANT'
                           AND SA.SEGMENT1 = P_DIVISION_ID
                           AND SB.COMPANY_ID = P_COMPANY_ID
                           AND (TRIM(P_FROM_SITE) IS NULL
                            OR SA.SEGMENT2 IN (SELECT COLUMN_VALUE
                                                 FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))) XB
                 WHERE XA.DIVISION_ID = XB.DIVISION_ID
                   AND XA.STORAGE_ID = XB.STORAGE_ID
                   AND XA.PLANT_ID = XB.PLANT_ID
                   AND XA.COMPANY_ID = XB.COMPANY_ID
                   AND XA.SCM_SITE_ID = XB.SCM_SITE_ID
                   AND XB.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING', 'CMA_BMA', 'AS')
                   AND XA.STOCK_TYPE = 'INVENTORY'
                   AND (TRIM(P_FROM_SITE) IS NULL
                    OR XA.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                            FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                   AND (TRIM(P_ITEM_ID) IS NULL
                    OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                  OR XA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                    /* OR XA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                    OR XA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                      FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                UNION ALL
                /* oWMS 재고 : 7S */
                SELECT XA.DIVISION_ID
                     , XA.FROM_SITE
                     , XA.ITEM_ID
                     , 'oWMS' AS BOH_TYPE
                     , XA.CUTOFF_DATE AS YYYYMMDD
                     , SUM(XA.STOCK_QTY) AS BOH_QTY
                     , 7 AS SEQ                                                 /* MEASURE 위치와 동일하게 */
                  FROM SSP_ANL_OWMS_STOCK_C2 XA
                     , SCM_ADM_LOOKUP_MASTER_DETAIL XB
                 WHERE XB.LOOKUP_TYPE = 'OWMS_STOCK_STATUS'                     /* C20220419-000607 */
                   AND XB.VALID_YN = 'Y'
                   AND XB.ATTRIBUTE1 = 'Y'
                   AND XB.SEGMENT1 = XA.STOCK_STATUS
                   AND XA.DIVISION_ID = P_DIVISION_ID
                   AND XA.COMPANY_ID = P_COMPANY_ID
                   AND XA.CUTOFF_DATE = V_BOH_YYYYMMDD
                   AND (TRIM(P_FROM_SITE) IS NULL
                    OR XA.FROM_SITE IN (SELECT COLUMN_VALUE
                                          FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                   AND (TRIM(P_ITEM_ID) IS NULL
                    OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                  OR XA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                    /* OR XA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                    OR XA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                      FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                 GROUP BY XA.DIVISION_ID, XA.FROM_SITE, XA.ITEM_ID, XA.CUTOFF_DATE
                UNION ALL
                /* MES 재고 : 8S */
                SELECT XA.DIVISION_ID
                     , XA.FROM_SITE
                     , XA.ITEM_ID
                     , 'MES' AS BOH_TYPE
                     , XA.YYYYMMDD
                     , NVL(SUM(XA.TOTAL) - (SUM(XA.OQC_NG) + SUM(XA.QMS_MES_HOLD)), 0) AS BOH_QTY
                     , 8 AS SEQ
                  FROM (SELECT DIVISION_ID
                             , FROM_SITE
                             , ITEM_ID
                             , V_BOH_YYYYMMDD AS YYYYMMDD
                             , CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT = 'N' THEN SUM(NVL(LOT_QTY, 0)) ELSE 0 END AS OQC_NG
                             , CASE WHEN AVAILABLE_YN = 'N' AND (QMS_HOLD_YN = 'Y' OR MES_HOLD_YN = 'Y') THEN SUM(NVL(LOT_QTY, 0)) ELSE 0 END AS QMS_MES_HOLD
                             , SUM(NVL(LOT_QTY, 0)) AS TOTAL
                          FROM SSP_DNM_GMES_STOCK_81_82
                         WHERE DIVISION_ID = P_DIVISION_ID
                           AND COMPANY_ID = P_COMPANY_ID
                           AND YYYYMMDD = P_PLAN_START_YYYYMMDD
                           AND (TRIM(P_FROM_SITE) IS NULL
                            OR FROM_SITE IN (SELECT COLUMN_VALUE
                                               FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                           AND (TRIM(P_ITEM_ID) IS NULL
                            OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                          OR ITEM_ID IN (SELECT COLUMN_VALUE
--                                           FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                            /* OR ITEM_ID MEMBER OF V_ITEM_TAB) */
                            OR ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                           FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                         GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, AVAILABLE_YN, OQC_INSP_RESULT, MES_HOLD_YN, QMS_HOLD_YN) XA
                 GROUP BY XA.DIVISION_ID, XA.FROM_SITE, XA.ITEM_ID, XA.YYYYMMDD
                UNION ALL
                /* ESS PACKER 재고 - BOH MEASURE */
                SELECT XA.DIVISION_ID AS DIVISION_ID
                     , XA.SCM_SITE_ID AS FROM_SITE
                     , XA.ITEM_ID AS ITEM_ID
                     , 'BOH' AS BOH_TYPE
                     , TO_CHAR(XA.CUTOFF_DATE, 'YYYYMMDD') AS YYYYMMDD
                     , NVL(XA.SSP_QTY, 0) AS BOH_QTY
                     , 5 AS SEQ                                                 /* MEASURE 위치와 동일하게 */
                  FROM SSP_DNM_ESS_PACKER_STOCK_V XA
                 WHERE XA.DIVISION_ID = P_DIVISION_ID
                   AND XA.COMPANY_ID = P_COMPANY_ID
                   AND XA.CUTOFF_DATE > V_STOCK_DATE                            /* 현재일 - 3 */
                   AND XA.CUTOFF_DATE = V_BOH_DATE
                   AND (TRIM(P_FROM_SITE) IS NULL
                    OR XA.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                            FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                   AND (TRIM(P_ITEM_ID) IS NULL
                    OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                  OR XA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                    /* OR XA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                    OR XA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                      FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                UNION ALL
                /* ESS PACKER 재고 - ERP MEASURE */
                SELECT XA.DIVISION_ID AS DIVISION_ID
                     , XA.SCM_SITE_ID AS FROM_SITE
                     , XA.ITEM_ID AS ITEM_ID
                     , 'ERP' AS BOH_TYPE
                     , TO_CHAR(XA.CUTOFF_DATE, 'YYYYMMDD') AS YYYYMMDD
                     , NVL(XA.SSP_QTY, 0) AS BOH_QTY
                     , 6 AS SEQ                                                 /* MEASURE 위치와 동일하게 */
                  FROM SSP_DNM_ESS_PACKER_STOCK_V XA
                 WHERE XA.DIVISION_ID = P_DIVISION_ID
                   AND XA.COMPANY_ID = P_COMPANY_ID
                   AND XA.CUTOFF_DATE > V_STOCK_DATE                            /* 현재일 - 3 */
                   AND XA.CUTOFF_DATE = V_BOH_DATE
                   AND (TRIM(P_FROM_SITE) IS NULL
                    OR XA.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                            FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                   AND (TRIM(P_ITEM_ID) IS NULL
                    OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                  OR XA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))) IA
                    /* OR XA.ITEM_ID MEMBER OF V_ITEM_TAB)) IA */
                    OR XA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                      FROM TABLE(V_ITEM_TAB)))) IA   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
             , SCM_MST_SITE B
             , SCM_MST_ITEM_SN C
         WHERE B.DIVISION_ID = IA.DIVISION_ID
           AND B.SCM_SITE_ID = IA.FROM_SITE
           AND C.DIVISION_ID(+) = IA.DIVISION_ID
           AND C.COMPANY_ID(+) = P_COMPANY_ID
           AND C.SITE_ID(+) = B.SITE_ID
           AND C.ITEM_ID(+) = IA.ITEM_ID
           AND C.ITEM_CLASS(+) IN ('ES1901', 'ES2001', 'ES2002', 'ES2003', 'ES2004')
         GROUP BY IA.DIVISION_ID, IA.FROM_SITE, C.APPLIED_MODEL, IA.ITEM_ID, IA.YYYYMMDD, IA.BOH_TYPE, IA.SEQ;

        INSERT INTO GT_0021_BOH
        (
            DIVISION_ID
          , FROM_SITE
          , ITEM_ID
          , YYYYMMDD
          , BOH_TYPE
          , BOH_QTY
          , SEQ
        )
        SELECT DIVISION_ID
             , FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , BOH_TYPE AS BOH_TYPE
             , SUM(BOH_QTY) AS BOH_QTY
             , SEQ
          FROM GT_0021_BOH_STORAGE
         GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, BOH_TYPE, SEQ;
        /*--//END BOH : 5S//--*/

        IF P_REAL_FLAG = 'Y' THEN

            INSERT INTO GT_0021_ROWDATA
            (
                DIVISION_ID
              , ITEM_ID
              , FROM_SITE
              , MEASURE
              , SEQ
              , YYYYMMDD
              , QTY
              , CONFIRM_DAY
            )
            SELECT IA.DIVISION_ID
                 , NVL(C.APPLIED_MODEL, IA.ITEM_ID) AS ITEM_ID
                 , IA.FROM_SITE
                 , IA.MEASURE
                 , IA.SEQ
                 , IA.YYYYMMDD
                 , SUM(IA.QTY) AS QTY
                 /* 확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16 */
                 , CASE WHEN FN_GET_ANL_SHIP_FROZEN_DAY_CNT(V_APP_TYPE, IA.DIVISION_ID, IA.FROM_SITE, V_FROM_YYYYMMDD) - 1 > 0
                             THEN FN_GET_ANL_SHIP_FROZEN_DAY_CNT(V_APP_TYPE, IA.DIVISION_ID, IA.FROM_SITE, V_FROM_YYYYMMDD) - 1
                        ELSE 0
                   END AS CONFIRM_DAY
              FROM (/* SHIP_REQ : 1S */
                    SELECT XA.DIVISION_ID AS DIVISION_ID
                         , XA.ITEM_ID AS ITEM_ID
                         , XA.PLANT_SITE_ID AS FROM_SITE
                         , 'SHIP_REQ' AS MEASURE
                         , XA.YYYYMMDD AS YYYYMMDD
                         , XA.QTY AS QTY
                         , 1 AS SEQ
                      FROM DM_PLN_SHIPMENT_REQ XA
                         , SCM_MST_SITE XB
                     WHERE XA.DIVISION_ID = P_DIVISION_ID
                       AND XA.PLANT_SITE_ID = XB.SCM_SITE_ID
                       AND XB.COMPANY_ID = P_COMPANY_ID
                       AND XB.SITE_TYPE = 'PLANT'
                       AND XB.VALID_YN = 'Y'
                       AND XA.MEASURE = 'SHIP_REQ'                              /* 확정 후 수정할 것 */
                       AND XA.YYYYMMDD >= V_FROM_YYYYMMDD
                       AND XA.YYYYMMDD <= V_TO_YYYYMMDD
                       AND XA.QTY > 0
                       AND (TRIM(P_FROM_SITE) IS NULL
                        OR XA.PLANT_SITE_ID IN (SELECT COLUMN_VALUE
                                                  FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                       AND (TRIM(P_ITEM_ID) IS NULL
                        OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                      OR XA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                          FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                        /* OR XA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                        OR XA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                          FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                       AND NOT EXISTS (SELECT 1
                                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                        WHERE SA.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
                                          AND SA.VALID_YN = 'Y'
                                          AND SA.SEGMENT1 = XA.DIVISION_ID
                                          AND SA.SEGMENT2 = XA.PLANT_SITE_ID
                                          AND SA.SEGMENT4 = XA.ITEM_ID)
                    UNION ALL
                    /* SHIP_PLAN : 2S */
                    SELECT XA.DIVISION_ID AS DIVISION_ID
                         , XA.ITEM_ID AS ITEM_ID
                         , XA.FROM_SITE AS FROM_SITE
                         , XA.MEASURE AS MEASURE
                         , XA.YYYYMMDD AS YYYYMMDD
                         , NVL(SUM(XA.QTY), 0) AS QTY
                         , XA.SEQ AS SEQ
                      FROM (SELECT SA.DIVISION_ID
                                 , SA.ITEM_ID
                                 , SA.FROM_SITE
                                 , 'SHIP_PLAN' AS MEASURE
                                 , SA.YYYYMMDD
                                 , SA.QTY
                                 , 2 AS SEQ
                              FROM SSP_ANL_SHIP_CONFIRM SA
                             WHERE SA.CHANGE_TYPE = 'C'
                               AND SA.BIZ_TYPE <> 'E'
                               AND SA.QTY > 0
                               AND SA.DIVISION_ID = P_DIVISION_ID
                               AND SA.FROM_SITE_COMPANY_ID = P_COMPANY_ID
                               AND SA.YYYYMMDD >= V_FROM_YYYYMMDD
                               AND SA.YYYYMMDD <= V_TO_YYYYMMDD
                               AND (TRIM(P_FROM_SITE) IS NULL
                                OR SA.FROM_SITE IN (SELECT COLUMN_VALUE
                                                      FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                               AND (TRIM(P_ITEM_ID) IS NULL
                                OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                              OR SA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                                /* OR SA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                                OR SA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                  FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                            UNION ALL
                            SELECT SA.DIVISION_ID
                                 , SA.ITEM_ID
                                 , SA.FROM_SITE
                                 , SA.MEASURE
                                 , SA.YYYYMMDD
                                 , SA.QTY
                                 , SA.SEQ
                              FROM (SELECT SB.DIVISION_ID AS DIVISION_ID
                                         , SB.ITEM_ID AS ITEM_ID
                                         , SB.PLANT_SITE_ID AS FROM_SITE
                                         , 'SHIP_PLAN' AS MEASURE
                                         , SB.YYYYMMDD AS YYYYMMDD
                                         , SB.QTY AS QTY
                                         , 2 AS SEQ
                                         /* 확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16 */
                                         , CASE WHEN NVL(SC.SHIP_FROZEN, 0) > 0
                                                     THEN TO_CHAR(TO_DATE(P_FROM_YYYYMMDD, 'YYYYMMDD') + FN_GET_ANL_SHIP_FROZEN_DAY_CNT(V_APP_TYPE, SC.DIVISION_ID, SC.SCM_SITE_ID, P_FROM_YYYYMMDD), 'YYYYMMDD')
                                                ELSE P_FROM_YYYYMMDD
                                           END AS FROZEN_YYYYMMDD               /* Ship Frozen구간 다음일자 */
                                      FROM DM_PLN_SHIPMENT_REQ SB
                                         , SCM_MST_SITE SC
                                     WHERE SC.DIVISION_ID = P_DIVISION_ID
                                       AND SB.PLANT_SITE_ID = SC.SCM_SITE_ID
                                       AND SC.COMPANY_ID = P_COMPANY_ID
                                       AND SC.SITE_TYPE = 'PLANT'
                                       AND SC.VALID_YN = 'Y'
                                       AND SB.DIVISION_ID = P_DIVISION_ID       /* 변수 */
                                       AND SB.MEASURE = 'SHIP_REQ'              /* 확정 후 수정할 것 */
                                       AND SB.YYYYMMDD >= V_FROM_YYYYMMDD
                                       AND SB.YYYYMMDD <= V_TO_YYYYMMDD
                                       AND SB.QTY > 0
                                       AND (TRIM(P_FROM_SITE) IS NULL
                                        OR SB.PLANT_SITE_ID IN (SELECT COLUMN_VALUE
                                                                  FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                                       AND (TRIM(P_ITEM_ID) IS NULL
                                        OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                                      OR SB.ITEM_ID IN (SELECT COLUMN_VALUE
--                                                          FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                                        /* OR SB.ITEM_ID MEMBER OF V_ITEM_TAB) */
                                        OR SB.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                          FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                                       AND NOT EXISTS (SELECT 1
                                                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL SD
                                                        WHERE SD.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
                                                          AND SD.VALID_YN = 'Y'
                                                          AND SD.SEGMENT1 = SB.DIVISION_ID
                                                          AND SD.SEGMENT2 = SB.PLANT_SITE_ID
                                                          AND SD.SEGMENT4 = SB.ITEM_ID)) SA
                             WHERE SA.YYYYMMDD >= SA.FROZEN_YYYYMMDD) XA
                     GROUP BY XA.DIVISION_ID, XA.ITEM_ID, XA.FROM_SITE, XA.MEASURE, XA.YYYYMMDD, XA.SEQ
                    UNION ALL
                    /* PROD_PLAN : 7S (FP 생산계획) */
                    SELECT XA.DIVISION_ID
                         , XA.ITEM_ID
                         , XA.SCM_SITE_ID AS FROM_SITE
                         , 'PROD_PLAN' AS MEASURE
                         , XA.PLAN_DATE AS YYYYMMDD
                         , XA.PLAN_QTY AS QTY
                         , 7 AS SEQ
                      FROM SSP_DNM_FP_PLAN_FROZEN XA                            /* SCM_DNM_PLAN_FROZEN_V */
                     WHERE XA.OPERATION_ID IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000', 'PL500')
                       AND XA.PLAN_QTY > 0
                       AND XA.DIVISION_ID = P_DIVISION_ID
                       AND XA.COMPANY_ID = P_COMPANY_ID
                       AND XA.PLAN_DATE >= V_FROM_YYYYMMDD
                       AND XA.PLAN_DATE <= V_TO_YYYYMMDD
                       AND XA.SITE_ID IN (SELECT DISTINCT SA.SITE_ID
                                            FROM SCM_MST_SITE SA
                                           WHERE SA.DIVISION_ID = P_DIVISION_ID
                                             AND SA.COMPANY_ID = P_COMPANY_ID
                                             AND SA.SITE_TYPE = 'PLANT'
                                             AND SA.VALID_YN = 'Y')
                       AND (TRIM(P_FROM_SITE) IS NULL
                        OR XA.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                       AND (TRIM(P_ITEM_ID) IS NULL
                        OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                      OR XA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                          FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                        /* OR XA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                        OR XA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                          FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                    UNION ALL
                    /* PROD_PLAN : 7S (ESS Packer 생산계획) */
                    SELECT XA.DIVISION_ID
                         , XA.ITEM_ID
                         , XA.SCM_SITE_ID AS FROM_SITE
                         , 'PROD_PLAN' AS MEASURE
                         , XA.YYYYMMDD AS YYYYMMDD
                         , XA.QTY AS QTY
                         , 7 AS SEQ
                      FROM SCP_ANL_PRODUCTION_PLAN XA
                         , (SELECT SA.DIVISION_ID
                                 , SA.PLAN_START_YYYYMMDD
                                 , SA.PLAN_TYPE
                                 , SA.SEQ
                              FROM (SELECT SB.DIVISION_ID
                                         , SB.PLAN_START_YYYYMMDD
                                         , SB.PLAN_TYPE
                                         , SB.PLAN_SEQ AS SEQ
                                      FROM SCP_PLAN_VERSION_V SB
                                     WHERE SB.DIVISION_ID = '82'                /* ESS(82)만 적용 */
                                       AND SB.PLAN_CYCLE = 'WEEKLY'
                                       AND SB.PLAN_TYPE NOT IN ('TE', 'TM')
                                     ORDER BY SB.PLAN_START_YYYYMMDD DESC, SB.PLAN_TYPE_ORDER DESC, SB.PLAN_SEQ DESC) SA
                             WHERE ROWNUM = 1) XB
                         , SCM_MST_SITE XC
                     WHERE XB.DIVISION_ID = XA.DIVISION_ID
                       AND XB.PLAN_START_YYYYMMDD = XA.PLAN_START_YYYYMMDD
                       AND XB.PLAN_TYPE = XA.PLAN_TYPE
                       AND XB.SEQ = XA.SEQ
                       AND XC.DIVISION_ID = XA.DIVISION_ID
                       AND XC.SCM_SITE_ID = XA.SCM_SITE_ID
                       AND XC.SITE_TYPE = 'PLANT'
                       AND XC.OSP_YN = 'Y'
                       AND XC.VALID_YN = 'Y'
                       AND XA.DIVISION_ID = '82'                                /* ESS(82)만 적용 */
                       AND XC.COMPANY_ID = P_COMPANY_ID
                       AND XA.MEASURE = 'PROD_PLAN_AMEND'
                       AND XA.QTY > 0
                       AND XA.YYYYMMDD >= V_FROM_YYYYMMDD
                       AND XA.YYYYMMDD <= V_TO_YYYYMMDD
                       AND (TRIM(P_FROM_SITE) IS NULL
                        OR XA.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                       AND (TRIM(P_ITEM_ID) IS NULL
                        OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                      OR XA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                          FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                        /* OR XA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                        OR XA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                          FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                       AND NOT EXISTS (SELECT 1
                                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                        WHERE SA.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
                                          AND SA.VALID_YN = 'Y'
                                          AND SA.SEGMENT1 = XA.DIVISION_ID
                                          AND SA.SEGMENT2 = XA.SCM_SITE_ID
                                          AND SA.SEGMENT4 = XA.ITEM_ID)
                    UNION ALL
                    /* PROD_PLAN : 7S (창고 입고예정) */
                    -- 2026.10.06 AJS 입고예정 도착일 함수를 인자 조합마다 1회 호출 (START)
--                    SELECT XA.DIVISION_ID
--                         , XA.ITEM_ID
--                         , XA.FROM_SITE
--                         , XA.MEASURE
--                         , XA.YYYYMMDD
--                         , XA.QTY
--                         , XA.SEQ
--                      FROM (SELECT SA.DIVISION_ID AS DIVISION_ID
--                                 , SA.ITEM_ID AS ITEM_ID
--                                 , SA.SCM_SITE_ID AS FROM_SITE
--                                 , 'PROD_PLAN' AS MEASURE
--                                 , FN_GET_SSP_ETA_DATE(SA.DIVISION_ID, SA.BOD_ID, SA.YYYYMMDD) AS YYYYMMDD
--                                 , SA.QTY AS QTY
--                                 , 7 AS SEQ
--                              FROM DM_PLN_SHIPMENT_REQ SA
--                                 , SCM_MST_SITE SB
--                             WHERE SA.DIVISION_ID = SB.DIVISION_ID
--                               AND SA.SCM_SITE_ID = SB.SCM_SITE_ID
--                               AND SB.OPERATION_GROUP = 'W'
--                               AND SB.SITE_TYPE = 'PLANT'
--                               AND SB.VALID_YN = 'Y'
--                               AND SA.DIVISION_ID IN (SELECT TOKEN
--                                                        FROM TABLE(UF_FX_STRING_SPLIT(P_DIVISION_ID, ',')))
--                               AND SB.COMPANY_ID = P_COMPANY_ID
--                               AND SA.QTY > 0
--                               AND (TRIM(P_FROM_SITE) IS NULL
--                                OR SA.SCM_SITE_ID IN (SELECT COLUMN_VALUE
--                                                        FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
--                               AND (TRIM(P_ITEM_ID) IS NULL
--                                OR SA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                                    FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))) XA
--                     WHERE XA.YYYYMMDD >= V_FROM_YYYYMMDD
--                       AND XA.YYYYMMDD < V_TO_YYYYMMDD
                    /* 확정 이후 입고예정(창고 PROD_PLAN) : 출하일 -> 도착일 함수가 행마다 2 번(>= · <) 불려
                       한 번 조회에 17 만 블록을 읽었다(82 HQ00). 함수 인자(사업부 · BOD · 출하일) 조합마다 1 번만 부르도록
                       인자 목록(SC, 중복 제거) -> 함수값(XB) 을 먼저 만들고 원 행(XA)에 붙인다.
                       - XB 는 XA 와 같은 조건으로 만든 인자 목록이므로 XA 의 모든 행이 XB 와 한 행씩 이어진다
                       - BOD 는 빈 값도 같은 값으로 잇는다(DECODE) - 원래 함수 호출과 같은 결과
                       - 함수값 조건(>= 시작일 · < 종료일)은 원래와 같다 */
                    SELECT XA.DIVISION_ID
                         , XA.ITEM_ID
                         , XA.FROM_SITE
                         , XA.MEASURE
                         , XB.ETA_YYYYMMDD AS YYYYMMDD
                         , XA.QTY
                         , XA.SEQ
                      FROM (SELECT SA.DIVISION_ID AS DIVISION_ID
                                 , SA.ITEM_ID AS ITEM_ID
                                 , SA.SCM_SITE_ID AS FROM_SITE
                                 , 'PROD_PLAN' AS MEASURE
                                 , SA.BOD_ID
                                 , SA.YYYYMMDD AS SHIP_YYYYMMDD
                                 , SA.QTY AS QTY
                                 , 7 AS SEQ
                              FROM DM_PLN_SHIPMENT_REQ SA
                                 , SCM_MST_SITE SB
                             WHERE SA.DIVISION_ID = SB.DIVISION_ID
                               AND SA.SCM_SITE_ID = SB.SCM_SITE_ID
                               AND SB.OPERATION_GROUP = 'W'
                               AND SB.SITE_TYPE = 'PLANT'
                               AND SB.VALID_YN = 'Y'
                               AND SA.DIVISION_ID IN (SELECT TOKEN
                                                        FROM TABLE(UF_FX_STRING_SPLIT(P_DIVISION_ID, ',')))
                               AND SB.COMPANY_ID = P_COMPANY_ID
                               AND SA.QTY > 0
                               AND (TRIM(P_FROM_SITE) IS NULL
                                OR SA.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                        FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                               AND (TRIM(P_ITEM_ID) IS NULL
                                OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                              OR SA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))) XA
                                /* OR SA.ITEM_ID MEMBER OF V_ITEM_TAB)) XA */
                                OR SA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                  FROM TABLE(V_ITEM_TAB)))) XA   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                         , (SELECT /*+ NO_MERGE */
                                   SC.DIVISION_ID
                                 , SC.BOD_ID
                                 , SC.YYYYMMDD
                                 , MAX(FN_GET_SSP_ETA_DATE(SC.DIVISION_ID, SC.BOD_ID, SC.YYYYMMDD)) AS ETA_YYYYMMDD
                              FROM (SELECT /*+ NO_MERGE */
                                           DISTINCT
                                           SA.DIVISION_ID
                                         , SA.BOD_ID
                                         , SA.YYYYMMDD
                                      FROM DM_PLN_SHIPMENT_REQ SA
                                         , SCM_MST_SITE SB
                                     WHERE SA.DIVISION_ID = SB.DIVISION_ID
                                       AND SA.SCM_SITE_ID = SB.SCM_SITE_ID
                                       AND SB.OPERATION_GROUP = 'W'
                                       AND SB.SITE_TYPE = 'PLANT'
                                       AND SB.VALID_YN = 'Y'
                                       AND SA.DIVISION_ID IN (SELECT TOKEN
                                                                FROM TABLE(UF_FX_STRING_SPLIT(P_DIVISION_ID, ',')))
                                       AND SB.COMPANY_ID = P_COMPANY_ID
                                       AND SA.QTY > 0
                                       AND (TRIM(P_FROM_SITE) IS NULL
                                        OR SA.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                                FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                                       AND (TRIM(P_ITEM_ID) IS NULL
                                        OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                                      OR SA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                                          FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))) SC
                                        /* OR SA.ITEM_ID MEMBER OF V_ITEM_TAB)) SC */
                                        OR SA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                          FROM TABLE(V_ITEM_TAB)))) SC   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                             GROUP BY SC.DIVISION_ID
                                    , SC.BOD_ID
                                    , SC.YYYYMMDD) XB
                     WHERE XB.DIVISION_ID = XA.DIVISION_ID
                       AND XB.YYYYMMDD = XA.SHIP_YYYYMMDD
                       AND DECODE(XB.BOD_ID, XA.BOD_ID, 1, 0) = 1
                       AND XB.ETA_YYYYMMDD >= V_FROM_YYYYMMDD
                       AND XB.ETA_YYYYMMDD < V_TO_YYYYMMDD
                    -- 2026.10.06 AJS 입고예정 도착일 함수를 인자 조합마다 1회 호출 (END)
                       AND NOT EXISTS (SELECT 1
                                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                        WHERE SA.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
                                          AND SA.VALID_YN = 'Y'
                                          AND SA.SEGMENT1 = XA.DIVISION_ID
                                          AND SA.SEGMENT2 = XA.FROM_SITE
                                          AND SA.SEGMENT4 = XA.ITEM_ID)
                    UNION ALL
                    /* SHIP_AVAL : 3S */
                    SELECT XA.DIVISION_ID
                         , XA.MODEL_ID AS ITEM_ID
                         , XA.FROM_SITE_ID AS FROM_SITE
                         , 'SHIP_AVAL' AS MEASURE
                         , XA.PLAN_DATE AS YYYYMMDD
                         , XA.OUT_QTY AS QTY
                         , 3 AS SEQ
                      FROM SSP_DNM_FP_AMEND_SHIPAVAL XA
                     WHERE XA.OUT_QTY >= 0
                       AND XA.DIVISION_ID = P_DIVISION_ID
                       AND XA.COMPANY_ID = P_COMPANY_ID
                       AND XA.PLAN_DATE >= V_FROM_YYYYMMDD
                       AND XA.PLAN_DATE <= V_TO_YYYYMMDD
                       AND XA.SITE_ID IN (SELECT DISTINCT SA.SITE_ID
                                            FROM SCM_MST_SITE SA
                                           WHERE SA.DIVISION_ID = P_DIVISION_ID
                                             AND SA.COMPANY_ID = P_COMPANY_ID
                                             AND SA.SITE_TYPE = 'PLANT'
                                             AND SA.VALID_YN = 'Y')
                       AND (TRIM(P_FROM_SITE) IS NULL
                        OR XA.FROM_SITE_ID IN (SELECT COLUMN_VALUE
                                                 FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                       AND (TRIM(P_ITEM_ID) IS NULL
                        OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                      OR XA.MODEL_ID IN (SELECT COLUMN_VALUE
--                                           FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))) IA
                        /* OR XA.MODEL_ID MEMBER OF V_ITEM_TAB)) IA */
                        OR XA.MODEL_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                           FROM TABLE(V_ITEM_TAB)))) IA   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
             , SCM_MST_SITE B
             , SCM_MST_ITEM_SN C
         WHERE B.DIVISION_ID = P_DIVISION_ID
           AND B.COMPANY_ID = P_COMPANY_ID
           AND IA.FROM_SITE = B.SCM_SITE_ID
           AND B.SITE_TYPE = 'PLANT'
           AND B.VALID_YN = 'Y'
           AND B.COMPANY_ID = C.COMPANY_ID
           AND IA.DIVISION_ID = C.DIVISION_ID
           AND B.SITE_ID = C.SITE_ID
           AND IA.ITEM_ID = C.ITEM_ID
           AND C.ITEM_TYPE IN ('P', 'H')
         GROUP BY IA.DIVISION_ID, IA.FROM_SITE, C.APPLIED_MODEL, IA.ITEM_ID, IA.YYYYMMDD, IA.MEASURE, IA.SEQ, B.SHIP_FROZEN;

            /*--//2. MEASURE x 날짜 전개//--*/
            INSERT INTO GT_0021_RESULT
            (
                DIVISION_ID
              , FROM_SITE
              , ITEM_ID
              , MEASURE
              , SEQ
              , CONFIRM_DAY
              , YYYYMMDD
              , QTY
            )
            SELECT IA.DIVISION_ID
                 , IA.FROM_SITE
                 , IA.ITEM_ID
                 , IA.MEASURE
                 , IA.SEQ
                 , IA.CONFIRM_DAY
                 , IA.YYYYMMDD
                 , NVL(B.QTY, 0) AS QTY
              FROM (SELECT XA.DIVISION_ID
                         , XA.FROM_SITE
                         , XA.ITEM_ID
                         , XA.CONFIRM_DAY
                         , XB.COLUMN_NAME AS MEASURE
                         , XB.SORT_ORDER_NO AS SEQ
                         , XC.YYYYMMDD
                      FROM GT_0021_ROWDATA XA
                         , SCM_MST_SHEET_MEASURE XB
                         , (SELECT SA.BASIS_YYYYMMDD AS YYYYMMDD
                                 , SA.ISO_WEEK
                              FROM SCM_SYS_CALENDAR_M SA
                             WHERE SA.BASIS_YYYYMMDD >= V_FROM_YYYYMMDD
                               AND SA.BASIS_YYYYMMDD <= V_TO_YYYYMMDD) XC
                     WHERE XB.PROGRAM_ID(+) = P_PROGRAM_ID
                       AND XB.SHEET_NAME(+) = P_SHEET_NAME
                       AND XC.YYYYMMDD(+) >= V_FROM_YYYYMMDD
                       AND XC.YYYYMMDD(+) <= V_TO_YYYYMMDD
                     GROUP BY XA.DIVISION_ID, XA.FROM_SITE, XA.ITEM_ID, XB.COLUMN_NAME, XB.COLUMN_LABEL_NAME, XB.SORT_ORDER_NO, XC.YYYYMMDD, XA.CONFIRM_DAY) IA
                 , GT_0021_ROWDATA B
                 , GT_0021_BOH C
             WHERE IA.DIVISION_ID = B.DIVISION_ID(+)
               AND IA.FROM_SITE = B.FROM_SITE(+)
               AND IA.ITEM_ID = B.ITEM_ID(+)
               AND IA.MEASURE = B.MEASURE(+)
               AND IA.YYYYMMDD = B.YYYYMMDD(+)
               AND IA.DIVISION_ID = C.DIVISION_ID(+)
               AND IA.FROM_SITE = C.FROM_SITE(+)
               AND IA.ITEM_ID = C.ITEM_ID(+)
               AND IA.SEQ = C.SEQ(+)
               AND IA.MEASURE IN ('SHIP_REQ', 'SHIP_PLAN', 'PROD_PLAN', 'SHIP_AVAL');   /* jilee */

            /*--//3. INTN_MOVEMENT(5S) · CONTAINER(6S)//--*/
            INSERT INTO GT_0021_RESULT
            (
                DIVISION_ID
              , FROM_SITE
              , ITEM_ID
              , MEASURE
              , SEQ
              , CONFIRM_DAY
              , YYYYMMDD
              , QTY
              , LOT_YN
            )
            SELECT IA.DIVISION_ID
                 , IA.FROM_SITE
                 , IA.ITEM_ID
                 , IA.MEASURE
                 , IA.SEQ
                 , IA.CONFIRM_DAY
                 , IA.YYYYMMDD
                 , IA.QTY
                 , IA.LOT_YN
              FROM (SELECT XA.DIVISION_ID
                         , XA.FROM_SITE
                         , XA.ITEM_ID
                         , 'INTN_MOVEMENT' AS MEASURE
                         , 5 AS SEQ
                         , XA.CONFIRM_DAY
                         , XA.YYYYMMDD
                         , SUM(NVL(XB.QTY, 0)) AS QTY
                         , NULL AS LOT_YN
                      FROM GT_0021_RESULT XA
                         , (SELECT SA.DIVISION_ID
                                 , SB.SCM_SITE_ID AS FROM_SITE
                                 , SA.ITEM_ID
                                 , TO_CHAR(SA.PLAN_DATE, 'YYYYMMDD') AS YYYYMMDD
                                 , NVL(SA.QTY, 0) AS QTY
                              FROM SCM_DNM_CELL_INHOUSE_PLAN_SN SA
                                 , SCM_MST_SITE SB
                             WHERE SA.DIVISION_ID = SB.DIVISION_ID
                               AND SA.PLANT_ID = SB.PLANT_ID
                               AND SB.COMPANY_ID = P_COMPANY_ID
                               AND SB.SITE_TYPE = 'PLANT'
                               AND SB.VALID_YN = 'Y'
                               AND SA.DIVISION_ID = P_DIVISION_ID
                               AND SA.COMPANY_ID = P_COMPANY_ID
                               AND SA.CATEGORY = 'MOVING'
                               AND SA.PLAN_DATE >= TO_DATE(SUBSTR(REPLACE(P_FROM_YYYYMMDD, '-', ''), 1, 8), 'YYYYMMDD')
                               AND SA.PLAN_DATE <= TO_DATE(SUBSTR(REPLACE(P_TO_YYYYMMDD, '-', ''), 1, 8), 'YYYYMMDD')
                               AND (TRIM(P_FROM_SITE) IS NULL
                                OR SB.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                        FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                               AND (TRIM(P_ITEM_ID) IS NULL
                                OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                              OR SA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                                /* OR SA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                                OR SA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                  FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                               AND SA.QTY > 0) XB
                     WHERE XA.DIVISION_ID = XB.DIVISION_ID(+)
                       AND XA.FROM_SITE = XB.FROM_SITE(+)
                       AND XA.ITEM_ID = XB.ITEM_ID(+)
                       AND XA.YYYYMMDD = XB.YYYYMMDD(+)
                       AND XA.MEASURE = 'SHIP_PLAN'
                     GROUP BY XA.DIVISION_ID, XA.FROM_SITE, XA.ITEM_ID, XA.YYYYMMDD, XA.MEASURE, XA.SEQ, XA.CONFIRM_DAY
                    UNION ALL
                    SELECT XA.DIVISION_ID
                         , XA.FROM_SITE
                         , XA.ITEM_ID
                         , 'CONTAINER' AS MEASURE
                         , 6 AS SEQ
                         , XA.CONFIRM_DAY
                         , XA.YYYYMMDD
                         , CASE WHEN NVL(MAX(XB.LOT_SIZE), 0) = 0 THEN 0
                                ELSE CEIL(MAX(NVL(XA.QTY, 0)) / NVL(MAX(XB.LOT_SIZE), 0))
                           END AS QTY
                         , CASE WHEN XB.LOT_SIZE IS NULL THEN 'N' ELSE 'Y' END AS LOT_YN
                      FROM GT_0021_RESULT XA
                         /* 외부조인 조건에 서브쿼리를 두면 바깥 행까지 사라지므로 운송수단 판정을 인라인 뷰 안으로 옮긴다 */
                         , (SELECT SA.DIVISION_ID
                                 , SA.ITEM_ID
                                 , SA.FROM_SITE
                                 , SA.LOT_SIZE
                              FROM SCP_MST_SHIPMENT_LOT_SIZE SA
                             WHERE SA.DIVISION_ID = P_DIVISION_ID
                               AND SA.VALID_YN = 'Y'
                               AND SA.TRANSPORT_MODE = (CASE WHEN SA.FROM_SITE IN (SELECT COLUMN_VALUE
                                                                                     FROM TABLE(FN_LIST_LOOKUP_VALUE('SSP0021_GET_SHIPMENT_PLAN', 'G382_Transport')))
                                                                  THEN 'TRK'
                                                             ELSE 'SEA'
                                                        END)) XB
                     WHERE XB.ITEM_ID(+) = XA.ITEM_ID
                       AND XB.FROM_SITE(+) = XA.FROM_SITE
                       AND XA.MEASURE = 'SHIP_PLAN'
                     GROUP BY XA.DIVISION_ID, XA.FROM_SITE, XA.ITEM_ID, XA.YYYYMMDD, XA.CONFIRM_DAY, XB.LOT_SIZE) IA;

            /*--//4. WH_STOCK : 8S//--*/
            INSERT INTO GT_0021_RESULT
            (
                DIVISION_ID
              , FROM_SITE
              , ITEM_ID
              , MEASURE
              , SEQ
              , CONFIRM_DAY
              , YYYYMMDD
              , QTY
            )
            SELECT IA.DIVISION_ID
                 , IA.FROM_SITE
                 , IA.ITEM_ID
                 , 'WH_STOCK' AS MEASURE
                 , 8 AS SEQ
                 , IA.CONFIRM_DAY
                 , IA.YYYYMMDD
                 , (SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'SHIP_PLAN' THEN -1 * NVL(SA.QTY, 0)
                                        WHEN SA.MEASURE = 'INTN_MOVEMENT' THEN -1 * NVL(SA.QTY, 0)
                                        WHEN SA.MEASURE = 'PROD_PLAN' THEN NVL(SA.QTY, 0)
                                        ELSE 0.0
                                   END), 0)
                      FROM GT_0021_RESULT SA
                     WHERE SA.DIVISION_ID = IA.DIVISION_ID
                       AND SA.FROM_SITE = IA.FROM_SITE
                       AND SA.ITEM_ID = IA.ITEM_ID
                       AND SA.MEASURE IN ('SHIP_PLAN', 'PROD_PLAN', 'INTN_MOVEMENT')
                       AND SA.YYYYMMDD < IA.YYYYMMDD)
                   + NVL(B.BOH_QTY, 0) AS QTY
              FROM (SELECT DIVISION_ID
                         , FROM_SITE
                         , ITEM_ID
                         , YYYYMMDD
                         , CONFIRM_DAY
                      FROM GT_0021_RESULT
                     GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, CONFIRM_DAY) IA
                 , (SELECT SA.DIVISION_ID
                         , SA.FROM_SITE
                         , SA.ITEM_ID
                         , TO_CHAR(TO_DATE(SA.YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD') AS YYYYMMDD
                         , SA.BOH_QTY AS BOH_QTY
                      FROM GT_0021_BOH SA
                     WHERE SA.BOH_TYPE = 'BOH'
                       AND SA.YYYYMMDD = V_BOH_YYYYMMDD) B
             WHERE IA.DIVISION_ID = B.DIVISION_ID(+)
               AND IA.FROM_SITE = B.FROM_SITE(+)
               AND IA.ITEM_ID = B.ITEM_ID(+)
               AND NOT EXISTS (SELECT 1
                                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                WHERE SA.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
                                  AND SA.VALID_YN = 'Y'
                                  AND SA.SEGMENT1 = IA.DIVISION_ID
                                  AND SA.SEGMENT2 = IA.FROM_SITE
                                  AND SA.SEGMENT4 = IA.ITEM_ID);

            /*--//5. BALANCE : 9S//--*/
            INSERT INTO GT_0021_RESULT
            (
                DIVISION_ID
              , FROM_SITE
              , ITEM_ID
              , MEASURE
              , SEQ
              , CONFIRM_DAY
              , YYYYMMDD
              , QTY
            )
            SELECT DIVISION_ID
                 , FROM_SITE
                 , ITEM_ID
                 , 'BALANCE' AS MEASURE
                 , 9 AS SEQ
                 , CONFIRM_DAY
                 , YYYYMMDD
                 , NVL(SUM(CASE WHEN MEASURE = 'SHIP_PLAN' THEN -1 * NVL(QTY, 0)
                                WHEN MEASURE = 'WH_STOCK' THEN NVL(QTY, 0)
                                ELSE 0
                           END), 0) AS QTY
              FROM GT_0021_RESULT A
             WHERE MEASURE IN ('SHIP_PLAN', 'WH_STOCK')
               AND NOT EXISTS (SELECT 1
                                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                WHERE SA.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
                                  AND SA.VALID_YN = 'Y'
                                  AND SA.SEGMENT1 = A.DIVISION_ID
                                  AND SA.SEGMENT2 = A.FROM_SITE
                                  AND SA.SEGMENT4 = A.ITEM_ID)
             GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, CONFIRM_DAY;

            /*--//6. SHIP_AVAL_GAP : 4S//--*/
            INSERT INTO GT_0021_RESULT
            (
                DIVISION_ID
              , FROM_SITE
              , ITEM_ID
              , MEASURE
              , SEQ
              , CONFIRM_DAY
              , YYYYMMDD
              , QTY
            )
            SELECT IA.DIVISION_ID
                 , IA.FROM_SITE
                 , IA.ITEM_ID
                 , 'SHIP_AVAL_GAP' AS MEASURE
                 , 4 AS SEQ
                 , IA.CONFIRM_DAY
                 , IA.YYYYMMDD
                 , (SELECT NVL(SUM(CASE WHEN SA.MEASURE = 'SHIP_PLAN' THEN -1 * NVL(SA.QTY, 0)
                                        WHEN SA.MEASURE = 'SHIP_AVAL' THEN NVL(SA.QTY, 0)
                                        ELSE 0.0
                                   END), 0)
                      FROM GT_0021_RESULT SA
                     WHERE SA.DIVISION_ID = IA.DIVISION_ID
                       AND SA.FROM_SITE = IA.FROM_SITE
                       AND SA.ITEM_ID = IA.ITEM_ID
                       AND SA.MEASURE IN ('SHIP_PLAN', 'SHIP_AVAL')
                       AND SA.YYYYMMDD <= IA.YYYYMMDD) AS QTY
              FROM (SELECT DIVISION_ID
                         , FROM_SITE
                         , ITEM_ID
                         , YYYYMMDD
                         , CONFIRM_DAY
                      FROM GT_0021_RESULT
                     GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, CONFIRM_DAY) IA
             WHERE NOT EXISTS (SELECT 1
                                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                WHERE SA.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
                                  AND SA.VALID_YN = 'Y'
                                  AND SA.SEGMENT1 = IA.DIVISION_ID
                                  AND SA.SEGMENT2 = IA.FROM_SITE
                                  AND SA.SEGMENT4 = IA.ITEM_ID);

            /*--//7. FP 자동생성 대상 계산 [E20260629-000020]//--*/
            FOR R IN (SELECT SP.DIVISION_ID
                           , SP.FROM_SITE
                           , SP.ITEM_ID
                           , SP.YYYYMMDD
                           , NVL(SP.QTY, 0) AS CF_QTY                           /* CONFIRM QTY */
                           , NVL(PP.QTY, 0) AS PP_QTY                           /* PRDN PLAN QTY */
                           , NVL(MV.QTY, 0) AS MV_QTY                           /* INTN_MOVEMENT QTY */
                           , NVL(L.LOT_SIZE, 0) AS LOT_SIZE
                           , T.ATTRIBUTE1 AS RATE
                           , SP.CONFIRM_DAY
                        FROM GT_0021_RESULT SP                                  /* CONFIRM */
                           , GT_0021_RESULT PP                                  /* PROD PLAN */
                           , GT_0021_RESULT MV                                  /* INTN_MOVEMENT */
                           , SCM_ADM_LOOKUP_MASTER_DETAIL T                     /* FP 자동생성 대상 */
                           , SCP_MST_BOD_N_V B
                           , SCP_MST_SHIPMENT_LOT_SIZE L
                       WHERE SP.DIVISION_ID = PP.DIVISION_ID(+)
                         AND SP.ITEM_ID = PP.ITEM_ID(+)
                         AND SP.FROM_SITE = PP.FROM_SITE(+)
                         AND SP.YYYYMMDD = PP.YYYYMMDD(+)
                         AND PP.MEASURE(+) = 'PROD_PLAN'
                         AND SP.DIVISION_ID = MV.DIVISION_ID(+)
                         AND SP.ITEM_ID = MV.ITEM_ID(+)
                         AND SP.FROM_SITE = MV.FROM_SITE(+)
                         AND SP.YYYYMMDD = MV.YYYYMMDD(+)
                         /* 원문은 이 조건이 PP 를 가리킨다 — 형태 보존 */
                         AND PP.MEASURE(+) = 'INTN_MOVEMENT'
                         AND T.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
                         AND T.VALID_YN = 'Y'
                         AND T.SEGMENT1 = SP.DIVISION_ID
                         AND T.SEGMENT2 = SP.FROM_SITE
                         AND T.SEGMENT4 = SP.ITEM_ID
                         AND B.DIVISION_ID(+) = T.SEGMENT1                      /* DIVISION_ID */
                         AND B.BOD_ID(+) = T.SEGMENT5                           /* BOD_ID */
                         AND L.DIVISION_ID(+) = SP.DIVISION_ID
                         AND L.FROM_SITE(+) = SP.FROM_SITE
                         AND L.TO_SITE(+) = T.SEGMENT3                          /* TO_SITE */
                         AND L.ITEM_ID(+) = SP.ITEM_ID
                         AND L.TRANSPORT_MODE(+) = B.TRANSPORT_MODE
                         AND L.VALID_YN(+) = 'Y'
                         AND SP.MEASURE = 'SHIP_PLAN'
                       ORDER BY SP.DIVISION_ID
                              , SP.FROM_SITE
                              , SP.ITEM_ID
                              , SP.YYYYMMDD) LOOP

                V_TMP_CFM_QTY := 0;
                V_TMP_WH_STOCK := 0;
                V_TMP_SP_QTY := 0;
                V_TMP_FP_QTY := 0;

                IF V_FROM_YYYYMMDD = R.YYYYMMDD THEN

                    BEGIN
                        SELECT NVL(BOH_QTY, 0)
                          INTO V_TMP_WH_STOCK
                          FROM GT_0021_BOH
                         WHERE BOH_TYPE = 'BOH'
                           AND YYYYMMDD = V_BOH_YYYYMMDD
                           AND DIVISION_ID = R.DIVISION_ID
                           AND FROM_SITE = R.FROM_SITE
                           AND ITEM_ID = R.ITEM_ID;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            V_TMP_WH_STOCK := 0;                                /* 원문도 대상이 없으면 0 을 유지한다 */
                    END;

                ELSE

                    SELECT NVL(SUM(C.QTY), 0)
                      INTO V_TMP_WH_STOCK
                      FROM GT_0021_RESULT C
                     WHERE C.DIVISION_ID = R.DIVISION_ID
                       AND C.YYYYMMDD = TO_CHAR(TO_DATE(R.YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD')
                       AND C.ITEM_ID = R.ITEM_ID
                       AND C.FROM_SITE = R.FROM_SITE
                       AND C.MEASURE = 'WH_STOCK';

                END IF;

                V_FROZEN_YYYYMMDD := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + FN_GET_ANL_SHIP_FROZEN_DAY_CNT(V_APP_TYPE, R.DIVISION_ID, R.FROM_SITE, P_PLAN_START_YYYYMMDD) - 1, 'YYYYMMDD');

                /* 원문의 CONVERT(INT, x) 는 절삭이므로 TRUNC 로 옮긴다 */
                V_TMP_SP_QTY := CASE WHEN V_FROZEN_YYYYMMDD >= R.YYYYMMDD THEN (CASE WHEN R.CF_QTY <> 0 THEN R.CF_QTY ELSE 0 END)   /* 컴펌 */
                                     WHEN NVL(R.LOT_SIZE, 0) = 0 THEN TRUNC(V_TMP_WH_STOCK + (R.PP_QTY * ((100 - R.RATE) / 100.0)))  /* LOT SIZE가 없는경우 전부 계획으로 잡는다. */
                                     WHEN TRUNC((V_TMP_WH_STOCK + (R.PP_QTY * ((100 - R.RATE) / 100.0))) / R.LOT_SIZE) * R.LOT_SIZE < R.LOT_SIZE THEN 0   /* LOT SIZE보다 작은경우 */
                                     ELSE TRUNC((V_TMP_WH_STOCK + (R.PP_QTY * ((100 - R.RATE) / 100.0))) / R.LOT_SIZE) * R.LOT_SIZE
                                END;
                V_TMP_FP_QTY := NVL(R.PP_QTY, 0);
                V_TMP_CFM_QTY := CASE WHEN NVL(R.CF_QTY, 0) <> 0 THEN R.CF_QTY ELSE 0 END;  /* 컴펌 수량 */

                UPDATE GT_0021_RESULT C
                   SET C.QTY = V_TMP_SP_QTY
                 WHERE C.DIVISION_ID = R.DIVISION_ID
                   AND C.ITEM_ID = R.ITEM_ID
                   AND C.FROM_SITE = R.FROM_SITE
                   AND C.YYYYMMDD = R.YYYYMMDD
                   AND C.MEASURE = 'SHIP_PLAN';

                /* 원문의 MERGE — 온라인 SQL 에서는 쓰지 않으므로 UPDATE 후 없으면 INSERT 로 나눈다 */
                UPDATE GT_0021_RESULT C
                   SET C.QTY = C.QTY - V_TMP_CFM_QTY
                 WHERE C.DIVISION_ID = R.DIVISION_ID
                   AND C.ITEM_ID = R.ITEM_ID
                   AND C.FROM_SITE = R.FROM_SITE
                   AND C.MEASURE = 'WH_STOCK'
                   AND C.YYYYMMDD = R.YYYYMMDD;

                IF SQL%ROWCOUNT = 0 THEN

                    INSERT INTO GT_0021_RESULT
                    (
                        DIVISION_ID
                      , ITEM_ID
                      , FROM_SITE
                      , MEASURE
                      , YYYYMMDD
                      , SEQ
                      , QTY
                      , CONFIRM_DAY
                    )
                    VALUES
                    (
                        R.DIVISION_ID
                      , R.ITEM_ID
                      , R.FROM_SITE
                      , 'WH_STOCK'
                      , R.YYYYMMDD
                      , 8
                      , V_TMP_WH_STOCK + V_TMP_FP_QTY - (CASE WHEN V_TMP_CFM_QTY <> 0 THEN V_TMP_CFM_QTY ELSE V_TMP_SP_QTY END) - R.MV_QTY
                      , R.CONFIRM_DAY
                    );

                END IF;

            END LOOP;

            INSERT INTO GT_0021_PIVOT
            (
                DIVISION_ID
              , FROM_SITE
              , ITEM_ID
              , MEASURE
              , SEQ
              , CONFIRM_DAY
              , YYYYMMDD
              , YYYYMM
              , ISO_WEEK
              , QTY
              , LOT_YN
            )
            SELECT A.DIVISION_ID
                 , A.FROM_SITE
                 , A.ITEM_ID
                 , A.MEASURE
                 , A.SEQ
                 , A.CONFIRM_DAY
                 , 'D_' || A.YYYYMMDD AS YYYYMMDD
                 , B.BASIS_YYYYMM AS YYYYMM
                 , SUBSTR(B.BASIS_YYYYMM, -4) || B.ISO_WEEK AS ISO_WEEK
                 , A.QTY
                 , A.LOT_YN
              FROM GT_0021_RESULT A
                 , SCM_SYS_CALENDAR_M B
             WHERE A.YYYYMMDD = B.BASIS_YYYYMMDD;

            /*PIVOIT처리*******************************************************************************/
            /* PIVOIT 대상 날짜문자열 생성 */
            V_QRY_SUM := '';

            FOR R IN (SELECT IA.YYYYMMDD
                        FROM (SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS YYYYMMDD
                                   , A.BASIS_START_DATE || '21' AS SORT_ORDER_NO
                                FROM SCM_SYS_CALENDAR_M A
                               WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                               GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                              UNION ALL
                              SELECT 'M_' || A.BASIS_YYYYMM AS YYYYMMDD
                                   , MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
                                FROM SCM_SYS_CALENDAR_M A
                               WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                               GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                              UNION ALL
                              SELECT 'D_' || A.BASIS_YYYYMMDD AS YYYYMMDD
                                   , A.BASIS_YYYYMMDD || '31' AS SORT_ORDER_NO
                                FROM SCM_SYS_CALENDAR_M A
                               WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                               GROUP BY A.BASIS_YYYYMMDD) IA
                       ORDER BY IA.SORT_ORDER_NO) LOOP

                IF INSTR(R.YYYYMMDD, 'M_') = 1 THEN
                    V_QRY_SUM := V_QRY_SUM || ', SUM(CASE WHEN A.YYYYMM = ''' || SUBSTR(R.YYYYMMDD, -6) || ''' THEN CAST(NVL(A.QTY, 0) AS NUMBER(20, 10)) END) AS ' || R.YYYYMMDD || CHR(10);
                ELSIF INSTR(R.YYYYMMDD, 'W_') = 1 THEN
                    V_QRY_SUM := V_QRY_SUM || ', SUM(CASE WHEN A.ISO_WEEK = ''' || SUBSTR(R.YYYYMMDD, -6) || ''' THEN CAST(NVL(A.QTY, 0) AS NUMBER(20, 10)) END) AS ' || R.YYYYMMDD || CHR(10);
                ELSIF INSTR(R.YYYYMMDD, 'D_') = 1 THEN
                    V_QRY_SUM := V_QRY_SUM || ', SUM(CASE WHEN A.YYYYMMDD = ''' || R.YYYYMMDD || ''' THEN CAST(NVL(A.QTY, 0) AS NUMBER(20, 10)) END) AS ' || R.YYYYMMDD || CHR(10);
                END IF;

            END LOOP;
            /*--//END PIVOT//--*/

            /*--//8. RESULT //--*/
            /* 측정값 칸은 화면 설정에 따라 개수가 달라져 정적 SQL 로 쓸 수 없다(피벗 전용 동적 SQL) */
            V_EXEC := 'SELECT A.DIVISION_ID' || CHR(10)
                   || ', A.FROM_SITE' || CHR(10)
                   || ', NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), ''-'') AS FROM_SITE_DESCRIPTION' || CHR(10)
                   || ', A.ITEM_ID' || CHR(10)
                   || ', (SELECT NVL(SA.NICK_NAME, ''-'') FROM SCM_MST_ITEM_SN SA WHERE SA.ITEM_ID = A.ITEM_ID AND ROWNUM = 1) AS NICK_NAME' || CHR(10)
                   || ', CASE WHEN B.BOH_TYPE IS NULL THEN' || CHR(10)
                   || '       CASE A.SEQ WHEN 5 THEN ''BOH''' || CHR(10)
                   || '                  WHEN 6 THEN ''ERP''' || CHR(10)
                   || '                  WHEN 7 THEN ''oWMS''' || CHR(10)
                   || '                  WHEN 8 THEN ''MES''' || CHR(10)
                   || '       ELSE NULL END' || CHR(10)
                   || '  ELSE B.BOH_TYPE END AS BOH_TYPE' || CHR(10)
                   || ', CASE WHEN (A.SEQ = 1 OR A.SEQ = 2 OR A.SEQ = 3 OR A.SEQ = 4 OR A.SEQ = 9) THEN NULL' || CHR(10)
                   || '  ELSE NVL(B.BOH_QTY, 0) END AS BOH_QTY' || CHR(10)
                   || ', CASE A.MEASURE WHEN ''SHIP_REQ'' THEN ''S''' || CHR(10)
                   || '                 WHEN ''SHIP_PLAN'' THEN ''S''' || CHR(10)
                   || '                 WHEN ''SHIP_AVAL'' THEN ''S''' || CHR(10)
                   || '                 WHEN ''SHIP_AVAL_GAP'' THEN ''S''' || CHR(10)
                   || '                 WHEN ''INTN_MOVEMENT'' THEN ''S''' || CHR(10)
                   || '                 WHEN ''CONTAINER'' THEN ''S''' || CHR(10)
                   || '                 WHEN ''PROD_PLAN'' THEN ''P''' || CHR(10)
                   || '                 WHEN ''WH_STOCK'' THEN ''I''' || CHR(10)
                   || '                 WHEN ''BALANCE'' THEN ''I'' END AS PSI' || CHR(10)
                   || ', A.MEASURE' || CHR(10)
                   || ', C.COLUMN_LABEL_NAME AS MEASURE_NAME' || CHR(10)
                   || ', A.SEQ' || CHR(10)
                   || ', TO_CHAR(TO_DATE(:B_FROM_YYYYMMDD1, ''YYYYMMDD'') + NVL(A.CONFIRM_DAY, 0), ''YYYYMMDD'') AS CONFIRM_DAY' || CHR(10)
                   || ', C.ATTRIBUTE3 AS BACK_COLOR' || CHR(10)
                   || ', A.LOT_YN' || CHR(10)
                   || V_QRY_SUM
                   || '  FROM GT_0021_PIVOT A' || CHR(10)
                   || '     , GT_0021_BOH B' || CHR(10)
                   || '     , SCM_MST_SHEET_MEASURE C' || CHR(10)
                   || '     , SCM_MST_TITLESET_USER D' || CHR(10)
                   || ' WHERE A.DIVISION_ID = B.DIVISION_ID(+)' || CHR(10)
                   || '   AND A.FROM_SITE = B.FROM_SITE(+)' || CHR(10)
                   || '   AND A.ITEM_ID = B.ITEM_ID(+)' || CHR(10)
                   || '   AND A.SEQ = B.SEQ(+)' || CHR(10)
                   || '   AND A.MEASURE = C.COLUMN_NAME' || CHR(10)
                   || '   AND C.PROGRAM_ID = :B_PROGRAM_ID1' || CHR(10)
                   || '   AND C.SHEET_NAME = :B_SHEET_NAME1' || CHR(10)
                   || '   AND D.PROGRAM_ID(+) = C.PROGRAM_ID' || CHR(10)
                   || '   AND D.SHEET_NAME(+) = C.SHEET_NAME' || CHR(10)
                   || '   AND D.COLUMN_NAME(+) = C.COLUMN_NAME' || CHR(10)
                   || '   AND D.USER_ID(+) = :B_USER_ID1' || CHR(10)
                   || '   AND C.VALID_YN = ''Y''' || CHR(10)
                   || '   AND (:B_CNT1 = 0' || CHR(10)
                   || '    OR EXISTS (SELECT 1' || CHR(10)
                   || '                 FROM GT_0021_TITLESET SA' || CHR(10)
                   || '                WHERE SA.COLUMN_NAME = C.COLUMN_NAME))' || CHR(10)
                   || '   AND ((:B_CNT2 = 0 AND C.DEFAULT_FLAG = ''Y'')' || CHR(10)
                   || '    OR (:B_CNT3 <> 0))' || CHR(10)
                   || ' GROUP BY A.DIVISION_ID, A.FROM_SITE, A.ITEM_ID, B.BOH_TYPE, B.BOH_QTY, A.MEASURE, C.COLUMN_LABEL_NAME, A.SEQ, A.CONFIRM_DAY, C.ATTRIBUTE3, A.LOT_YN' || CHR(10)
                   || ' ORDER BY A.DIVISION_ID, A.FROM_SITE, A.ITEM_ID, A.SEQ, A.MEASURE';

            OPEN O_RC1 FOR V_EXEC USING P_FROM_YYYYMMDD, P_PROGRAM_ID, P_SHEET_NAME, P_USER_ID, V_CNT_USR_MEASURE, V_CNT_USR_MEASURE, V_CNT_USR_MEASURE;
            /*--//END RESULT//--*/

        ELSE

            /*PIVOIT처리*******************************************************************************/
            /* PIVOIT 대상 날짜문자열 생성 */
            V_QRY_SUM := '';

            FOR R IN (SELECT IA.YYYYMMDD
                        FROM (SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS YYYYMMDD
                                   , A.BASIS_START_DATE || '21' AS SORT_ORDER_NO
                                FROM SCM_SYS_CALENDAR_M A
                               WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                               GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                              UNION ALL
                              SELECT 'M_' || A.BASIS_YYYYMM AS YYYYMMDD
                                   , MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
                                FROM SCM_SYS_CALENDAR_M A
                               WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                               GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                              UNION ALL
                              SELECT 'D_' || A.BASIS_YYYYMMDD AS YYYYMMDD
                                   , A.BASIS_YYYYMMDD || '31' AS SORT_ORDER_NO
                                FROM SCM_SYS_CALENDAR_M A
                               WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                               GROUP BY A.BASIS_YYYYMMDD) IA
                       ORDER BY IA.SORT_ORDER_NO) LOOP

                IF INSTR(R.YYYYMMDD, 'M_') = 1 THEN
                    V_QRY_SUM := V_QRY_SUM || ', SUM(CASE WHEN A.YYYYMM = ''' || SUBSTR(R.YYYYMMDD, -6) || ''' THEN A.QTY END) AS ' || R.YYYYMMDD || CHR(10);
                ELSIF INSTR(R.YYYYMMDD, 'W_') = 1 THEN
                    V_QRY_SUM := V_QRY_SUM || ', SUM(CASE WHEN A.ISO_WEEK = ''' || SUBSTR(R.YYYYMMDD, -6) || ''' THEN A.QTY END) AS ' || R.YYYYMMDD || CHR(10);
                ELSIF INSTR(R.YYYYMMDD, 'D_') = 1 THEN
                    V_QRY_SUM := V_QRY_SUM || ', SUM(CASE WHEN A.YYYYMMDD = ''' || R.YYYYMMDD || ''' THEN A.QTY END) AS ' || R.YYYYMMDD || CHR(10);
                END IF;

            END LOOP;
            /*--//END PIVOT//--*/

            INSERT INTO GT_0021_PIVOT_OLD
            (
                DIVISION_ID
              , FROM_SITE
              , ITEM_ID
              , MEASURE
              , YYYYMMDD
              , YYYYMM
              , ISO_WEEK
              , QTY
              , LOT_YN
            )
            SELECT IA.DIVISION_ID
                 , IA.FROM_SITE
                 , IA.ITEM_ID
                 , IA.MEASURE
                 , IA.YYYYMMDD
                 , IA.YYYYMM
                 , IA.ISO_WEEK
                 , NVL(IA.QTY, 0) AS QTY
                 , IA.LOT_YN
              FROM (SELECT XA.DIVISION_ID
                         , XA.FROM_SITE
                         , NVL(XD.APPLIED_MODEL, XA.ITEM_ID) AS ITEM_ID
                         , XA.MEASURE
                         , SUM(CAST(XA.QTY AS NUMBER(10))) AS QTY
                         , NULL AS LOT_YN
                         , 'D_' || XA.YYYYMMDD AS YYYYMMDD
                         , XB.BASIS_YYYYMM AS YYYYMM
                         , SUBSTR(XB.BASIS_YYYYMM, -4) || XB.ISO_WEEK AS ISO_WEEK
                      FROM SSP_ANL_SHIP_PLAN_C XA
                         , SCM_SYS_CALENDAR_M XB
                         , SCM_MST_SITE XC
                         , SCM_MST_ITEM_SN XD
                     WHERE XA.YYYYMMDD = XB.BASIS_YYYYMMDD
                       /* 2020-03-23 modify by KIMYONGHO 과거 PLAN 조회 시 필요없음 */
                       AND XC.DIVISION_ID = XA.DIVISION_ID
                       AND XC.SCM_SITE_ID = XA.FROM_SITE
                       AND XD.DIVISION_ID(+) = XA.DIVISION_ID
                       AND XD.COMPANY_ID(+) = P_COMPANY_ID
                       AND XD.SITE_ID(+) = XC.SITE_ID
                       AND XD.ITEM_ID(+) = XA.ITEM_ID
                       AND XD.ITEM_CLASS(+) IN ('ES1901', 'ES2001', 'ES2002', 'ES2003', 'ES2004')
                       AND XA.DIVISION_ID = P_DIVISION_ID
                       AND XA.COMPANY_ID = P_COMPANY_ID
                       AND XA.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                       AND XA.YYYYMMDD >= SUBSTR(REPLACE(P_FROM_YYYYMMDD, '-', ''), 1, 8)
                       AND XA.YYYYMMDD <= SUBSTR(REPLACE(P_TO_YYYYMMDD, '-', ''), 1, 8)
                       AND (TRIM(P_FROM_SITE) IS NULL
                        OR XA.FROM_SITE IN (SELECT COLUMN_VALUE
                                              FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                       AND (TRIM(P_ITEM_ID) IS NULL
                        OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                      OR XA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                          FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                        /* OR XA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                        OR XA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                          FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                     GROUP BY XA.DIVISION_ID, XA.FROM_SITE, XD.APPLIED_MODEL, XA.ITEM_ID, XA.MEASURE, XA.YYYYMMDD, XB.BASIS_YYYYMM, XB.ISO_WEEK
                    UNION ALL
                    SELECT XA.DIVISION_ID
                         , XA.FROM_SITE_ID AS FROM_SITE
                         , XA.MODEL_ID AS ITEM_ID
                         , 'SHIP_AVAL' AS MEASURE
                         , XA.OUT_QTY AS QTY
                         , NULL AS LOT_YN
                         , 'D_' || XA.PLAN_DATE AS YYYYMMDD
                         , XB.BASIS_YYYYMM AS YYYYMM
                         , SUBSTR(XB.BASIS_YYYYMM, -4) || XB.ISO_WEEK AS ISO_WEEK
                      FROM SSP_DNM_FP_AMEND_SHIPAVAL XA
                         , SCM_SYS_CALENDAR_M XB
                     WHERE XA.PLAN_DATE = XB.BASIS_YYYYMMDD
                       AND XA.OUT_QTY >= 0
                       AND XA.DIVISION_ID = P_DIVISION_ID
                       AND XA.COMPANY_ID = P_COMPANY_ID
                       AND XA.PLAN_DATE >= V_FROM_YYYYMMDD
                       AND XA.PLAN_DATE <= V_TO_YYYYMMDD
                       AND XA.SITE_ID IN (SELECT DISTINCT SA.SITE_ID
                                            FROM SCM_MST_SITE SA
                                           WHERE SA.DIVISION_ID = P_DIVISION_ID
                                             AND SA.COMPANY_ID = P_COMPANY_ID
                                             AND SA.SITE_TYPE = 'PLANT'
                                             AND SA.VALID_YN = 'Y')
                       AND (TRIM(P_FROM_SITE) IS NULL
                        OR XA.FROM_SITE_ID IN (SELECT COLUMN_VALUE
                                                 FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                       AND (TRIM(P_ITEM_ID) IS NULL
                        OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                      OR XA.MODEL_ID IN (SELECT COLUMN_VALUE
--                                           FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))) IA;
                        /* OR XA.MODEL_ID MEMBER OF V_ITEM_TAB)) IA; */
                        OR XA.MODEL_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                           FROM TABLE(V_ITEM_TAB)))) IA;   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */

            /*--//RESULT (과거 PLAN)//--*/
            V_EXEC := 'SELECT A.DIVISION_ID' || CHR(10)
                   || ', A.FROM_SITE' || CHR(10)
                   || ', NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), ''-'') AS FROM_SITE_DESCRIPTION' || CHR(10)
                   || ', (SELECT NVL(SA.NICK_NAME, ''-'') FROM SCM_MST_ITEM_SN SA WHERE SA.ITEM_ID = A.ITEM_ID AND ROWNUM = 1) AS NICK_NAME' || CHR(10)
                   || ', A.ITEM_ID' || CHR(10)
                   || ', CASE WHEN C.BOH_TYPE IS NULL THEN' || CHR(10)
                   || '       CASE B.SORT_ORDER_NO WHEN 5 THEN ''BOH''' || CHR(10)
                   || '                            WHEN 6 THEN ''ERP''' || CHR(10)
                   || '                            WHEN 7 THEN ''oWMS''' || CHR(10)
                   || '                            WHEN 8 THEN ''MES''' || CHR(10)
                   || '       ELSE NULL END' || CHR(10)
                   || '  ELSE C.BOH_TYPE END AS BOH_TYPE' || CHR(10)
                   || ', CASE WHEN (B.SORT_ORDER_NO = 1 OR B.SORT_ORDER_NO = 2 OR B.SORT_ORDER_NO = 3 OR B.SORT_ORDER_NO = 4 OR B.SORT_ORDER_NO = 9) THEN NULL' || CHR(10)
                   || '  ELSE NVL(C.BOH_QTY, 0) END AS BOH_QTY' || CHR(10)
                   || ', CASE A.MEASURE WHEN ''SHIP_REQ'' THEN ''S''' || CHR(10)
                   || '                 WHEN ''SHIP_PLAN'' THEN ''S''' || CHR(10)
                   || '                 WHEN ''SHIP_AVAL'' THEN ''S''' || CHR(10)
                   || '                 WHEN ''INTN_MOVEMENT'' THEN ''S''' || CHR(10)
                   || '                 WHEN ''CONTAINER'' THEN ''S''' || CHR(10)
                   || '                 WHEN ''PROD_PLAN'' THEN ''P''' || CHR(10)
                   || '                 WHEN ''WH_STOCK'' THEN ''I''' || CHR(10)
                   || '                 WHEN ''BALANCE'' THEN ''I'' END AS PSI' || CHR(10)
                   || ', A.MEASURE' || CHR(10)
                   || ', B.COLUMN_LABEL_NAME AS MEASURE_NAME' || CHR(10)
                   || ', B.SORT_ORDER_NO' || CHR(10)
                   || ', TO_CHAR(TO_DATE(:B_FROM_YYYYMMDD1, ''YYYYMMDD'') + FN_GET_ANL_SHIP_FROZEN_DAY_CNT(:B_APP_TYPE1, A.DIVISION_ID, A.FROM_SITE, :B_FROM_YYYYMMDD2) - 1, ''YYYYMMDD'') AS CONFIRM_DAY' || CHR(10)
                   || ', B.ATTRIBUTE3 AS BACK_COLOR' || CHR(10)
                   || ', A.LOT_YN' || CHR(10)
                   || V_QRY_SUM
                   || '  FROM GT_0021_PIVOT_OLD A' || CHR(10)
                   || '     , SCM_MST_SHEET_MEASURE B' || CHR(10)
                   || '     , GT_0021_BOH C' || CHR(10)
                   || '     , SCM_MST_SITE D' || CHR(10)
                   || '     , SCM_MST_TITLESET_USER E' || CHR(10)
                   || ' WHERE A.MEASURE = B.COLUMN_NAME' || CHR(10)
                   || '   AND B.PROGRAM_ID = :B_PROGRAM_ID1' || CHR(10)
                   || '   AND B.SHEET_NAME = :B_SHEET_NAME1' || CHR(10)
                   || '   AND A.DIVISION_ID = C.DIVISION_ID(+)' || CHR(10)
                   || '   AND A.FROM_SITE = C.FROM_SITE(+)' || CHR(10)
                   || '   AND A.ITEM_ID = C.ITEM_ID(+)' || CHR(10)
                   || '   AND B.SORT_ORDER_NO = C.SEQ(+)' || CHR(10)
                   || '   AND A.DIVISION_ID = :B_DIVISION_ID1' || CHR(10)
                   || '   AND D.COMPANY_ID = :B_COMPANY_ID1' || CHR(10)
                   || '   AND A.FROM_SITE = D.SCM_SITE_ID' || CHR(10)
                   || '   AND D.SITE_TYPE = ''PLANT''' || CHR(10)
                   || '   AND D.VALID_YN = ''Y''' || CHR(10)
                   || '   AND E.PROGRAM_ID(+) = B.PROGRAM_ID' || CHR(10)
                   || '   AND E.SHEET_NAME(+) = B.SHEET_NAME' || CHR(10)
                   || '   AND E.COLUMN_NAME(+) = B.COLUMN_NAME' || CHR(10)
                   || '   AND E.USER_ID(+) = :B_USER_ID1' || CHR(10)
                   || '   AND B.VALID_YN = ''Y''' || CHR(10)
                   || '   AND (:B_CNT1 = 0' || CHR(10)
                   || '    OR EXISTS (SELECT 1' || CHR(10)
                   || '                 FROM GT_0021_TITLESET SA' || CHR(10)
                   || '                WHERE SA.COLUMN_NAME = B.COLUMN_NAME))' || CHR(10)
                   || '   AND ((:B_CNT2 = 0 AND B.DEFAULT_FLAG = ''Y'')' || CHR(10)
                   || '    OR (:B_CNT3 <> 0))' || CHR(10);

/*            IF TRIM(P_ITEM_ID) IS NOT NULL THEN */
            IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN   /* AJS 20261008 Model/Nickname */
--              V_EXEC := V_EXEC || '   AND A.ITEM_ID = :B_ITEM_ID1' || CHR(10);   --  2026.10.07 AJS
/*                V_EXEC := V_EXEC || '   AND A.ITEM_ID MEMBER OF :B_ITEM_TAB1' || CHR(10);   --  2026.10.07 AJS */
                V_EXEC := V_EXEC || '   AND A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(:B_ITEM_TAB1))' || CHR(10);   /* AJS 20261008 Model/Nickname */
            END IF;

            V_EXEC := V_EXEC
                   || ' GROUP BY A.DIVISION_ID, A.FROM_SITE, A.ITEM_ID, A.MEASURE, B.COLUMN_LABEL_NAME, B.SORT_ORDER_NO, C.BOH_TYPE, C.BOH_QTY, D.SHIP_FROZEN, B.ATTRIBUTE3, A.LOT_YN' || CHR(10)
                   || ' ORDER BY A.DIVISION_ID, A.FROM_SITE, A.ITEM_ID, B.SORT_ORDER_NO';

/*            IF TRIM(P_ITEM_ID) IS NOT NULL THEN */
            IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN   /* AJS 20261008 Model/Nickname */
--              OPEN O_RC1 FOR V_EXEC USING P_FROM_YYYYMMDD, V_APP_TYPE, P_FROM_YYYYMMDD, P_PROGRAM_ID, P_SHEET_NAME, P_DIVISION_ID, P_COMPANY_ID, P_USER_ID, V_CNT_USR_MEASURE, V_CNT_USR_MEASURE, V_CNT_USR_MEASURE, P_ITEM_ID;   --  2026.10.07 AJS
                OPEN O_RC1 FOR V_EXEC USING P_FROM_YYYYMMDD, V_APP_TYPE, P_FROM_YYYYMMDD, P_PROGRAM_ID, P_SHEET_NAME, P_DIVISION_ID, P_COMPANY_ID, P_USER_ID, V_CNT_USR_MEASURE, V_CNT_USR_MEASURE, V_CNT_USR_MEASURE, V_ITEM_TAB;   --  2026.10.07 AJS
            ELSE
                OPEN O_RC1 FOR V_EXEC USING P_FROM_YYYYMMDD, V_APP_TYPE, P_FROM_YYYYMMDD, P_PROGRAM_ID, P_SHEET_NAME, P_DIVISION_ID, P_COMPANY_ID, P_USER_ID, V_CNT_USR_MEASURE, V_CNT_USR_MEASURE, V_CNT_USR_MEASURE;
            END IF;

        END IF;

    END P_SSP0021_GET_SHIPMENT_PLAN;
    PROCEDURE P_SSP0021_GET_SHIPMENT_PLAN_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_REQUESTOR             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_FROM_YYYYMMDD         IN  VARCHAR2
       ,P_TO_YYYYMMDD           IN  VARCHAR2
       ,P_DBL_FLAG              IN  VARCHAR2
       ,P_REAL_FLAG             IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_GET_SHIPMENT_PLAN_DETAIL
 * Description  : 자동차 Shipment Plan
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/09/06   mcThej			Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 * 2019/11/14   ayj				CHANGE_REASON_CODE, CHANGE_REASON_DETAIL SELECT 값 수정
 * 2019/12/17	KIMYONGHO		[C20191216-000311] Expected Shipping Date 컬럼 추가
 * 2020/01/21   juhlee          [C20200121-000352]  ESS Packer출하 적용
 * 2020/02/10   KIMYONGHO       Shipmnet Status 조회 시 공통코드 타입으로 조회
 * 2020/03/12   KIMYONGHO       [C20200226-000471] Shipment Detail 탭 Project code 표시
 * 2020/03/26   KIMYONGHO       [C20200326-000217] Shipment Detail 탭 Team, Project Name 표시
 * 2021/02/04   KIMYONGHO	    ETA_DATE 조회 시 항차를 고려한 LT 적용(FN_GET_SSP_ETA_DATE)
 * 2021/10/18   KIMYONGHO	    [C20211001-000241][SCM PI팀] Shipment Plan (Auto ESS) 기능 개선 의건
 * 2022/12/19   jilee    	    오창 출하 물류 R&R 관련 F.Destination 정보 활용 방안 (요청자:임화영)
 * 2024/05/10   hsbang          확정구간 조회 일수(CONFIRM_DAY)를 FN_GET_ANL_SHIP_FROZEN_DAY_CNT 에서 조회
 * 2024.06.12   hsbang		파라미터 @p_product_level1 추가
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.06   AJS          조회 속도 개선 - 마케팅 담당자 이름 함수 결과를 같은 담당자끼리 재사용(결과 동일)
 * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
 * 2026.10.08   AJS          Model/Nickname 후속 : 후보 목록 비교 MEMBER OF → IN(TABLE) · Model 'ALL' 은 조건 없음 · 더블클릭(P_DBL_FLAG=Y) 상세는 입력 코드 정확일치
 */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
        V_APP_TYPE          VARCHAR2(8) := 'SSP';
        V_DBL_FROM          VARCHAR2(8);
        V_DBL_TO            VARCHAR2(8);
    BEGIN

        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치하는 품목을 먼저 고른다
           대상 품목 = 해당 사업부 품목 원장(코드 · 닉네임) + 입력값 그대로(기존 정확일치 유지) */
/*        IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN */
        IF P_DBL_FLAG = 'Y' THEN   /* AJS 20261008 Model/Nickname : 더블클릭 상세는 넘겨받은 행의 코드만(정확일치) */
            SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
              BULK COLLECT INTO V_ITEM_TAB   /* AJS 20261008 Model/Nickname */
              FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))   /* AJS 20261008 Model/Nickname */
             WHERE COLUMN_VALUE IS NOT NULL;   /* AJS 20261008 Model/Nickname */
        ELSIF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN   /* AJS 20261008 Model/Nickname */
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT A.ITEM_ID
                      FROM SCM_MST_ITEM_SN A
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) B
                     WHERE B.COLUMN_VALUE IS NOT NULL
                       AND A.DIVISION_ID = P_DIVISION_ID
                       AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%'
                            OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(B.COLUMN_VALUE) || '%')
                    UNION
                    SELECT COLUMN_VALUE
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))
                     WHERE COLUMN_VALUE IS NOT NULL) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* 더블클릭이면 단일 일자, 아니면 기간 */
        IF P_DBL_FLAG = 'Y' THEN
            V_DBL_FROM := P_FROM_YYYYMMDD;
            V_DBL_TO := P_FROM_YYYYMMDD;
        ELSE
            V_DBL_FROM := P_FROM_YYYYMMDD;
            V_DBL_TO := P_TO_YYYYMMDD;
        END IF;

        IF P_REAL_FLAG = 'Y' THEN

            OPEN O_RC1 FOR
                SELECT A.DIVISION_ID
                     , A.ERP_SO_NO
                     , A.SHIPMENT_STATUS
                     , A.ITEM_ID
                     , FN_GET_ITEM_NICKNAME((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.ITEM_ID) AS NICK_NAME
                     , A.FROM_SITE
                     , A.TO_SITE
                     , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_DESCRIPTION
                     , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.TO_SITE), '-') AS TO_SITE_DESCRIPTION
                     , NVL(A.PROJECT_CODE, '-') AS PROJECT_CODE
                     , NVL(FN_GET_PROJECT_NAME(A.DIVISION_ID, A.PROJECT_CODE), '-') AS PROJECT_NAME
                     , NVL(CASE WHEN A.DIVISION_ID = '40' THEN CASE WHEN A.PROJECT_CODE IS NOT NULL AND A.PROJECT_CODE <> '-' THEN A.PROJECT_CODE ELSE E.PROJECT_CODE END
                                WHEN A.DIVISION_ID = 'EE' AND A.ORIGIN_TO_DIVISION_ID = '40' THEN E.PROJECT_CODE
                                ELSE D.END_CUSTOMER
                           END, NVL(L.END_CUSTOMER, '-')) AS END_CUSTOMER
--                     , CASE WHEN K.OWNER IS NOT NULL THEN TO_CHAR(FN_GET_SSP_MKT_OWNER_NAME(K.OWNER, ',', P_LANGUAGE))  --  2026.10.06 AJS
                     , CASE WHEN K.OWNER IS NOT NULL THEN TO_CHAR((SELECT FN_GET_SSP_MKT_OWNER_NAME(K.OWNER, ',', P_LANGUAGE) FROM DUAL))  --  2026.10.06 AJS
--                            ELSE TO_CHAR(FN_GET_SSP_MKT_OWNER_NAME(L.OWNER, ',', P_LANGUAGE))  --  2026.10.06 AJS
                            ELSE TO_CHAR((SELECT FN_GET_SSP_MKT_OWNER_NAME(L.OWNER, ',', P_LANGUAGE) FROM DUAL))  --  2026.10.06 AJS
                       END AS MTK_OWNER
                     /* 2026.09.30 AJS 수정 (START) */
--                     , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN I.USERNAME ELSE I.USERNAME_E END) IS NULL THEN NULL
--                            ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN I.USERNAME ELSE I.USERNAME_E END) || '(' || A.REQUESTOR || ')'
                     , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN I.USER_NM ELSE I.USER_ENG_NM END) IS NULL THEN NULL
                            ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN I.USER_NM ELSE I.USER_ENG_NM END) || '(' || A.REQUESTOR || ')'
                     /* 2026.09.30 AJS 수정 (END) */
                       END AS REQUESTOR
                     , CAST(A.QTY AS NUMBER(10)) AS SHIPMENT_CONFIRM_QTY
                     , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') AS SHIPMENT_DATE
                     , B.TRANSPORT_MODE
                     , A.REMARKS2
                     , A.REMARKS
                     , '-' AS CHANGE_REASON_CODE
                     , NULL AS CHANGE_REASON_DETAIL
                     , A.REMARKS3
                     , FN_GET_SITE_CUSTOMER_INFO((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.TO_SITE, 'SOLDTO_DESCRIPTION') AS SOLDTO_DESCRIPTION
                     , FN_GET_SITE_CUSTOMER_INFO((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.TO_SITE, 'SHIPTO_DESCRIPTION') AS SHIPTO_DESCRIPTION
                     /* 20201223 incoterms 변경 작업 modify KIMYONGHO */
                     , B.SSP_INCOTERMS AS INCOTERMS
                     , B.LT_TOTAL AS LT_DAY
                     , TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETD
                     , TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETA
                     , CASE WHEN B.TRANSPORT_MODE = 'TRK' THEN '-'
                            ELSE TO_CHAR(TO_DATE(FN_GET_SSP_EXPECTED_SHIP_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD), 'YYYYMMDD'), 'YYYY-MM-DD')
                       END AS EXPECTED_SHIPPING_DATE
                     , A.FCST_TYPE
                     /* 2026.09.30 AJS 수정 (START) */
--                     , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN C.USERNAME ELSE C.USERNAME_E END) IS NULL THEN NULL
--                            ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN C.USERNAME ELSE C.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                     , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN C.USER_NM ELSE C.USER_ENG_NM END) IS NULL THEN NULL
                            ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN C.USER_NM ELSE C.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                     /* 2026.09.30 AJS 수정 (END) */
                       END AS UPDATED_BY
                     /* 2026.09.30 AJS 수정 (START) */
--                     , CASE WHEN C.USERNAME IS NOT NULL THEN A.LAST_UPDATE_DATE ELSE NULL END AS UPDATED_DATE
                     , CASE WHEN C.USER_NM IS NOT NULL THEN A.LAST_UPDATE_DATE ELSE NULL END AS UPDATED_DATE
                     /* 2026.09.30 AJS 수정 (END) */
                     , F.CHANGE_REQ_NO
                     /* 2026.09.30 AJS 수정 (START) */
--                     , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN H.USERNAME ELSE H.USERNAME_E END) IS NULL THEN NULL
--                            ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN H.USERNAME ELSE H.USERNAME_E END) || '(' || G.USER_ID || ')'
                     , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN H.USER_NM ELSE H.USER_ENG_NM END) IS NULL THEN NULL
                            ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN H.USER_NM ELSE H.USER_ENG_NM END) || '(' || G.USER_ID || ')'
                     /* 2026.09.30 AJS 수정 (END) */
                       END AS MODEL_USER
                     , A.CONFIRM_ID
                     , B.LT_TOTAL AS NEW_LT_DAY
                     , B.TRANSPORT_MODE AS NEW_TRANSPORT_MODE
                     , A.ERP_STATUS
                     , A.CHANGE_TYPE
                     , A.NEW_ROUTE_ID
                     , A.NEW_BOD_ID
                     , A.NEW_INCOTERMS
                     , A.NEW_D_COUNTRY
                     , A.NEW_D_PORT_CODE
                     , A.NEW_A_COUNTRY
                     , A.NEW_A_PORT_CODE
                     , A.NEW_CUSTOMER_LT
                     , A.NEW_TO_COUNTRY
                     , A.NEW_TO_CITY
                     , A.NEW_ETA
                     , A.NEW_ETD
                     , A.NEW_SHIPMENT_DATE
                     , A.EDIT_REMARKS
                     , A.EDIT_MAIN
                     , A.CHECK_NEED_YN
                     , A.ELECTRODE_YN
                     , A.ELECTRODE_TYPE
                     /* 20211117	SMS	수정 */
                     , NVL(E.DEPT_NAME_KO, NVL(L.DEPT_NAME_KO, '-')) AS TEAM
                     , A.ATTRIBUTE10
                     /* 221219 jilee 오창 출하 물류 R&R 관련 F.Destination 정보 활용 방안 (요청자:임화영) */
                     , B.A_COUNTRY
                     , B.A_PORT_CODE
                     , J.A_PORT_NAME
                     , P.COUNTRY_NAME
                     , Q.CITY_NAME
                     , O.SHIPTO_REGION_NAME
                     , O.SHIPTO_CITY_NAME
                  FROM (SELECT XA.DIVISION_ID
                             , XA.ERP_SO_NO
                             , XA.SHIPMENT_STATUS AS SHIPMENT_STATUS
                             , XA.ITEM_ID
                             , XA.ORIGIN_FROM_DIVISION_ID
                             , XA.ORIGIN_TO_DIVISION_ID
                             , XA.FROM_SITE
                             , XA.TO_SITE
                             , XA.PROJECT_CODE
                             , XA.REQUESTOR
                             , XA.QTY
                             , XA.YYYYMMDD
                             , XA.BOD_ID
                             , XA.REMARKS2
                             , XA.REMARKS
                             , XA.CHANGE_REQ_NO
                             , XA.REMARKS3
                             , XA.ETD_DATE
                             , XA.ETA_DATE
                             , XA.LAST_UPDATED_BY
                             , XA.LAST_UPDATE_DATE
                             , XA.CONFIRM_ID
                             , XA.FCST_TYPE
                             , XA.ERP_STATUS
                             , XA.CHANGE_TYPE
                             , TO_CHAR(XA.ROUTE_ID) AS NEW_ROUTE_ID
                             , XA.BOD_ID AS NEW_BOD_ID
                             , XA.INCOTERMS AS NEW_INCOTERMS
                             , XA.D_COUNTRY AS NEW_D_COUNTRY
                             , XA.D_PORT_CODE AS NEW_D_PORT_CODE
                             , XA.A_COUNTRY AS NEW_A_COUNTRY
                             , XA.A_PORT_CODE AS NEW_A_PORT_CODE
                             , TO_CHAR(XA.CUSTOMER_LT) AS NEW_CUSTOMER_LT
                             , XA.TO_COUNTRY AS NEW_TO_COUNTRY
                             , XA.TO_CITY AS NEW_TO_CITY
                             , TO_CHAR(TO_DATE(XA.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETA
                             , TO_CHAR(TO_DATE(XA.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETD
                             , TO_CHAR(TO_DATE(XA.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_SHIPMENT_DATE
                             , 'N' AS EDIT_REMARKS
                             , 'N' AS EDIT_MAIN
                             , NVL(XA.CHECK_NEED_YN, 'N') AS CHECK_NEED_YN
                             , XA.ELECTRODE_YN
                             , XA.ELECTRODE_TYPE
                             , XA.ATTRIBUTE10
                          FROM SSP_ANL_SHIP_CONFIRM XA
                             , SCM_MST_ITEM_SN XB
                         WHERE XA.ITEM_ID = XB.ITEM_ID
                           AND XA.DIVISION_ID = XB.DIVISION_ID
                           AND XA.FROM_SITE_COMPANY_ID = XB.COMPANY_ID
                           AND XB.ITEM_TYPE NOT IN ('Q', 'R')
                           AND XA.CHANGE_TYPE = 'C'
                           AND XA.DIVISION_ID = P_DIVISION_ID
                           AND XA.FROM_SITE_COMPANY_ID = P_COMPANY_ID
                           AND XA.BIZ_TYPE <> 'E'
                           AND XA.YYYYMMDD >= V_DBL_FROM
                           AND XA.YYYYMMDD <= V_DBL_TO
                           AND (TRIM(P_ITEM_ID) IS NULL
                            OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                          OR XA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                              FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                            /* OR XA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                            OR XA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                              FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                           AND (TRIM(P_FROM_SITE) IS NULL
                            OR XA.FROM_SITE IN (SELECT COLUMN_VALUE
                                                  FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                           /* 원문은 조회조건 값을 그대로 IN 절에 넣어 값으로 찾지 못한다 — 값 비교로 바로잡음 */
                           AND (P_DBL_FLAG = 'Y'
                            OR TRIM(P_REQUESTOR) IS NULL
                            /* 2026.09.30 AJS 수정 (START) */
--                            OR XA.REQUESTOR IN (SELECT DISTINCT SA.USERID
--                                                  FROM TB_FX_USER SA
--                                                 WHERE SA.USERNAME IN (SELECT COLUMN_VALUE
                            OR XA.REQUESTOR IN (SELECT DISTINCT SA.USER_ID
                                                  FROM SCM_ADM_USER_M SA
                                                 WHERE SA.USER_NM IN (SELECT COLUMN_VALUE
                            /* 2026.09.30 AJS 수정 (END) */
                                                                         FROM TABLE(STRING_SPLIT(P_REQUESTOR, ',')))
                                                    /* 2026.09.30 AJS 수정 (START) */
--                                                    OR SA.USERID IN (SELECT COLUMN_VALUE
                                                    OR SA.USER_ID IN (SELECT COLUMN_VALUE
                                                    /* 2026.09.30 AJS 수정 (END) */
                                                                       FROM TABLE(STRING_SPLIT(P_REQUESTOR, ',')))))
                        UNION ALL
                        SELECT XA.DIVISION_ID
                             , XA.ERP_SO_NO
                             , XA.SHIPMENT_STATUS
                             , XA.ITEM_ID
                             , XA.ORIGIN_FROM_DIVISION_ID
                             , XA.ORIGIN_TO_DIVISION_ID
                             , XA.FROM_SITE
                             , XA.TO_SITE
                             , XA.PROJECT_CODE
                             , XA.REQUESTOR
                             , XA.QTY
                             , XA.YYYYMMDD
                             , XA.BOD_ID
                             , XA.REMARKS2
                             , XA.REMARKS
                             , XA.CHANGE_REQ_NO
                             , XA.REMARKS3
                             , XA.ETD_DATE
                             , XA.ETA_DATE
                             , XA.LAST_UPDATED_BY
                             , XA.LAST_UPDATE_DATE
                             , XA.CONFIRM_ID
                             , XA.FCST_TYPE
                             , '-' AS ERP_STATUS
                             , '-' AS CHANGE_TYPE
                             , '-' AS NEW_ROUTE_ID
                             , '-' AS NEW_BOD_ID
                             , '-' AS NEW_INCOTERMS
                             , '-' AS NEW_D_COUNTRY
                             , '-' AS NEW_D_PORT_CODE
                             , '-' AS NEW_A_COUNTRY
                             , '-' AS NEW_A_PORT_CODE
                             , '-' AS NEW_CUSTOMER_LT
                             , '-' AS NEW_TO_COUNTRY
                             , '-' AS NEW_TO_CITY
                             , '-' AS NEW_ETA
                             , '-' AS NEW_ETD
                             , '-' AS NEW_SHIPMENT_DATE
                             , '-' AS EDIT_REMARKS
                             , '-' AS EDIT_MAIN
                             , '-' AS CHECK_NEED_YN
                             , '-' AS ELECTRODE_YN
                             , '-' AS ELECTRODE_TYPE
                             , '-' AS ATTRIBUTE10
                          FROM (SELECT SA.DIVISION_ID
                                     , '-' AS ERP_SO_NO
                                     , 'P' AS SHIPMENT_STATUS
                                     , SA.ITEM_ID
                                     , SA.DIVISION_ID AS ORIGIN_FROM_DIVISION_ID
                                     , SA.DIVISION_ID AS ORIGIN_TO_DIVISION_ID
                                     , SA.PLANT_SITE_ID AS FROM_SITE
                                     , SA.SCM_SITE_ID AS TO_SITE
                                     , SA.PROJECT_CODE
                                     , '-' AS REQUESTOR
                                     , SA.QTY
                                     , SA.YYYYMMDD
                                     , SA.BOD_ID
                                     , '-' AS REMARKS2
                                     , '-' AS REMARKS
                                     , '-' AS CHANGE_REQ_NO
                                     , '-' AS REMARKS3
                                     , SA.YYYYMMDD AS ETD_DATE
                                     /* 2021/02/04 KIMYONGHO ETA_DATE 조회 시 항차를 고려한 LT 적용 FN_GET_SSP_ETA_DATE */
                                     , FN_GET_SSP_ETA_DATE(SA.DIVISION_ID, SA.BOD_ID, SA.YYYYMMDD) AS ETA_DATE
                                     , SA.LAST_UPDATED_BY
                                     , SA.LAST_UPDATE_DATE
                                     , '-' AS CONFIRM_ID
                                     , SA.FCST_TYPE
                                     , CASE WHEN NVL(SC.SHIP_FROZEN, 0) > 0
                                            THEN TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + FN_GET_ANL_SHIP_FROZEN_DAY_CNT(V_APP_TYPE, SC.DIVISION_ID, SC.SCM_SITE_ID, P_PLAN_START_YYYYMMDD), 'YYYYMMDD')
                                            ELSE P_PLAN_START_YYYYMMDD
                                       END AS FROZEN_YYYYMMDD
                                  FROM DM_PLN_SHIPMENT_REQ SA
                                     , SCP_MST_BOD_N_V SB
                                     , SCM_MST_SITE SC
                                 WHERE SA.DIVISION_ID = SB.DIVISION_ID
                                   AND SA.BOD_ID = SB.BOD_ID
                                   AND SA.DIVISION_ID = SC.DIVISION_ID
                                   AND SA.PLANT_SITE_ID = SC.SCM_SITE_ID
                                   AND SC.SITE_TYPE = 'PLANT'
                                   /* [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외) */
                                   /* AND tt2.osp_yn = 'N' */
                                   AND SC.VALID_YN = 'Y'
                                   AND SA.DIVISION_ID = P_DIVISION_ID
                                   AND SC.COMPANY_ID = P_COMPANY_ID
                                   AND SA.YYYYMMDD >= V_DBL_FROM
                                   AND SA.YYYYMMDD <= V_DBL_TO
                                   AND (TRIM(P_ITEM_ID) IS NULL
                                    OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                                  OR SA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                                    /* OR SA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                                    OR SA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                      FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                                   AND (TRIM(P_FROM_SITE) IS NULL
                                    OR SA.PLANT_SITE_ID IN (SELECT COLUMN_VALUE
                                                              FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))) XA
                         WHERE XA.YYYYMMDD >= XA.FROZEN_YYYYMMDD) A
                     , SCP_MST_BOD_N_V B
                     /* 2026.09.30 AJS 수정 (START) */
--                     , TB_FX_USER C
                     , SCM_ADM_USER_M C
                     /* 2026.09.30 AJS 수정 (END) */
                     , SCM_MST_SITE D
                     , (SELECT SA.DIVISION_ID
                             , SA.PROJECT_CODE
                             , SA.SCM_SITE_ID
                             , SA.ITEM_ID
                             , SA.DEPT_NAME_KO
                          FROM (SELECT XA.DIVISION_ID
                                     , XA.PROJECT_CODE
                                     , XA.SCM_SITE_ID
                                     , XA.ITEM_ID
                                     , XC.DEPT_NAME_KO
                                     , ROW_NUMBER() OVER (PARTITION BY XA.DIVISION_ID, XA.SCM_SITE_ID, XA.ITEM_ID ORDER BY XA.PROJECT_CODE) AS NUM
                                  FROM SCM_MST_SITE_ITEM XA
                                     /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
--                                     , SCM_MST_SITE XB
                                     , SCM_MST_SSO_DEPT_INFO XC
--                                 WHERE XB.SCM_SITE_ID(+) = XA.SCM_SITE_ID
--                                   AND XB.DEPT_ID = XC.DEPT_ID(+)) SA
                                 WHERE XA.DEPT_ID = XC.DEPT_ID(+)) SA
                                     /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
                         WHERE SA.NUM = 1) E
                     , (SELECT SA.CONFIRM_ID
                             , SA.CHANGE_REQ_NO
                          FROM (SELECT XA.CONFIRM_ID
                                     , XA.CHANGE_REQ_NO
                                     , ROW_NUMBER() OVER (PARTITION BY XA.CONFIRM_ID ORDER BY XA.CHANGE_REQ_NO DESC) AS NUM
                                  FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE XA
                                 WHERE XA.VALID_YN = 'Y') SA
                         WHERE SA.NUM = 1) F
                     , SSP_MST_MODEL_USER G
                     /* 2026.09.30 AJS 수정 (START) */
--                     , TB_FX_USER H
--                     , TB_FX_USER I
                     , SCM_ADM_USER_M H
                     , SCM_ADM_USER_M I
                     /* 2026.09.30 AJS 수정 (END) */
                     , SCP_MST_DISTRIBUTION_ROUTE J
                     , SCM_MST_SITE_ITEM K
                     , (SELECT IB.PLANT_ID
                             , IB.DIVISION_ID
                             , IB.PROJECT_CODE
                             , IB.SCM_SITE_ID
                             , IB.ITEM_ID
                             , SB.DEPT_ID
                             , NVL(SC.DEPT_NAME_KO, '-') AS DEPT_NAME_KO
                             , IB.OWNER AS OWNER
                             , IB.END_CUSTOMER
                             , IB.TO_SITE_DESCRIPTION
                          FROM (SELECT SA.SEGMENT2 AS PLANT_ID
                                     , SB.DIVISION_ID
                                     , SB.PROJECT_CODE
                                     , SB.SCM_SITE_ID
                                     , SB.ITEM_ID
                                     , SB.OWNER
                                     , NVL(SC.END_CUSTOMER, '-') AS END_CUSTOMER
                                     , NVL(FN_GET_SCM_SITE_DESCRIPTION(SA.SEGMENT3, SA.SEGMENT2), '-') AS TO_SITE_DESCRIPTION
                                     , TRIM(REGEXP_SUBSTR(SB.OWNER, '[^,]+', 1, 1)) AS FIRST_OWNER
                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                     , SCM_MST_SITE_ITEM SB
                                     , SCM_MST_SITE SC
                                 WHERE SA.LOOKUP_TYPE = 'AS_SITE_PLANT'
                                   AND SA.SEGMENT1 = SB.SCM_SITE_ID
                                   AND SB.DIVISION_ID = SC.DIVISION_ID(+)
                                   AND SB.SCM_SITE_ID = SC.SCM_SITE_ID(+)) IB
                             , SCM_MST_SSO_USER_INFO SB
                             , SCM_MST_SSO_DEPT_INFO SC
                         WHERE IB.FIRST_OWNER = SB.USER_ID(+)
                           AND SB.DEPT_ID = SC.DEPT_ID(+)) L
                     , SSP_ANL_SHIP_CONFIRM_CHG_REQ M
                     , SCM_MST_CUSTOMER O
                     , SCM_MST_COUNTRY P
                     , SCM_MST_CITY Q
                     , SCM_MST_SITE_CUSTOMER R
                 WHERE (CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END) = B.DIVISION_ID
                   AND A.BOD_ID = B.BOD_ID
                   /* 2026.09.30 AJS 수정 (START) */
--                   AND A.LAST_UPDATED_BY = C.USERID(+)
--                   AND C.USEYN(+) = 'Y'
                   AND A.LAST_UPDATED_BY = C.USER_ID(+)
                   AND C.USE_YN(+) = 'Y'
                   /* 2026.09.30 AJS 수정 (END) */
                   AND D.SCM_SITE_ID = A.TO_SITE
                   /* NERP 적용시 GERP COMPANY_ID에 해당하는 것은 제외 필요함 */
                   AND D.VALID_YN = 'Y'
                   AND D.DIVISION_ID = A.DIVISION_ID
                   AND E.DIVISION_ID(+) = (CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END)
                   AND E.SCM_SITE_ID(+) = A.TO_SITE
                   AND E.ITEM_ID(+) = A.ITEM_ID
                   AND F.CONFIRM_ID(+) = A.CONFIRM_ID
                   AND G.DIVISION_ID(+) = A.ORIGIN_FROM_DIVISION_ID
                   AND G.FROM_SITE(+) = A.FROM_SITE
                   AND G.ITEM_ID(+) = A.ITEM_ID
                   AND G.VALID_YN(+) = 'Y'
                   /* 2026.09.30 AJS 수정 (START) */
--                   AND G.USER_ID = H.USERID(+)
--                   AND H.USEYN(+) = 'Y'
--                   AND A.REQUESTOR = I.USERID(+)
--                   AND I.USEYN(+) = 'Y'
                   AND G.USER_ID = H.USER_ID(+)
                   AND H.USE_YN(+) = 'Y'
                   AND A.REQUESTOR = I.USER_ID(+)
                   AND I.USE_YN(+) = 'Y'
                   /* 2026.09.30 AJS 수정 (END) */
                   AND J.ROUTE_ID(+) = B.ROUTE_ID
                   AND K.DIVISION_ID(+) = (CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END)
                   AND K.SCM_SITE_ID(+) = A.TO_SITE
                   AND K.ITEM_ID(+) = A.ITEM_ID
                   AND K.PROJECT_CODE(+) = A.PROJECT_CODE
                   /* 20211117	SMS	추가 */
                   AND A.DIVISION_ID = L.DIVISION_ID(+)
                   AND A.PROJECT_CODE = L.PROJECT_CODE(+)
                   AND A.TO_SITE = L.PLANT_ID(+)
                   AND A.ITEM_ID = L.ITEM_ID(+)
                   AND F.CHANGE_REQ_NO = M.CHANGE_REQ_NO(+)
                   /* 221219 jilee 오창 출하 물류 R&R 관련 F.Destination 정보 활용 방안 (요청자:임화영) */
                   AND D.DIVISION_ID = R.DIVISION_ID(+)
                   AND D.SCM_SITE_ID = R.SCM_SITE_ID(+)
                   AND R.REP_YN(+) = 'Y'
                   AND R.VALID_YN(+) = 'Y'
                   AND R.DIVISION_ID = O.DIVISION_ID(+)
                   AND R.SOLDTO_CODE = O.SOLDTO_CODE(+)
                   AND R.SHIPTO_CODE = O.SHIPTO_CODE(+)
                   AND D.COUNTRY = P.COUNTRY(+)
                   AND D.COUNTRY = Q.COUNTRY(+)
                   AND D.CITY = Q.CITY(+)
                   AND A.SHIPMENT_STATUS IS NOT NULL
                   AND A.QTY > 0
                 ORDER BY A.DIVISION_ID, A.SHIPMENT_STATUS, A.YYYYMMDD, A.ITEM_ID, A.ERP_SO_NO DESC, A.FROM_SITE, A.TO_SITE, A.PROJECT_CODE, A.FCST_TYPE;

        ELSE

            OPEN O_RC1 FOR
                SELECT IA.*
                  FROM (SELECT A.DIVISION_ID
                             , A.ERP_SO_NO
                             , A.SHIPMENT_STATUS
                             , A.PROJECT_CODE
                             , A.PROJECT_NAME
                             , A.FCST_TYPE
                             , A.ITEM_ID
                             , A.NICK_NAME
                             , A.SHIPMENT_DATE
                             , A.SHIPMENT_CONFIRM_QTY
                             , A.REMARKS
                             , A.REMARKS2
                             , A.REMARKS3
                             , A.FROM_SITE
                             , A.FROM_SITE_DESCRIPTION
                             , A.TO_SITE
                             , A.TO_SITE_DESCRIPTION
                             , A.TO_SITE_SOLDTO_CODE
                             , A.TO_SITE_SHIPTO_CODE
                             , A.SOLDTO_DESCRIPTION
                             , A.SHIPTO_DESCRIPTION
                             , A.BOD_ID
                             , A.INCOTERMS
                             , A.TRANSPORT_MODE
                             , A.LT_DAY
                             , A.ETD
                             , A.ETA
                             , A.EXPECTED_SHIPPING_DATE
                             , A.CONFIRM_ID
                             , A.UPDATED_BY
                             , A.UPDATED_DATE
                             , '-' AS ERP_STATUS
                             , '-' AS CHANGE_TYPE
                             , '-' AS NEW_ROUTE_ID
                             , '-' AS NEW_BOD_ID
                             , '-' AS NEW_INCOTERMS
                             , '-' AS NEW_D_COUNTRY
                             , '-' AS NEW_D_PORT_CODE
                             , '-' AS NEW_A_COUNTRY
                             , '-' AS NEW_A_PORT_CODE
                             , '-' AS NEW_CUSTOMER_LT
                             , '-' AS NEW_TO_COUNTRY
                             , '-' AS NEW_TO_CITY
                             , '-' AS NEW_ETA
                             , '-' AS NEW_ETD
                             , '-' AS NEW_LT_DAY
                             , '-' AS NEW_TRANSPORT_MODE
                             , '-' AS NEW_SHIPMENT_DATE
                             , '-' AS EDIT_REMARKS
                             , '-' AS EDIT_MAIN
                             , '-' AS CHECK_NEED_YN
                             /* 20211118	SMS	수정 */
                             , CASE WHEN A.END_CUSTOMER IS NOT NULL AND A.END_CUSTOMER <> '-' THEN A.END_CUSTOMER ELSE NVL(B.END_CUSTOMER, '-') END AS END_CUSTOMER
                             , '-' AS ELECTRODE_YN
                             , '-' AS ELECTRODE_TYPE
                             , '-' AS ORIGIN_FROM_DIVISION_ID
                             , '-' AS ORIGIN_TO_DIVISION_ID
                             , A.CHANGE_REQ_NO AS CHANGE_REQ_NO
                             , A.MODEL_USER AS MODEL_USER
                             /* 20211118	SMS	수정 */
                             , CASE WHEN A.MTK_OWNER IS NOT NULL AND A.MTK_OWNER <> '-' THEN A.MTK_OWNER
--                                    ELSE TO_CHAR(FN_GET_SSP_MKT_OWNER_NAME(B.OWNER, ',', P_LANGUAGE))  --  2026.10.06 AJS
                                    ELSE TO_CHAR((SELECT FN_GET_SSP_MKT_OWNER_NAME(B.OWNER, ',', P_LANGUAGE) FROM DUAL))  --  2026.10.06 AJS
                               END AS MTK_OWNER
                             , A.REQUESTOR AS REQUESTOR
                             , '-' AS CHANGE_REASON_CODE
                             , '-' AS CHANGE_REASON_DETAIL
                             /* 221219 jilee 오창 출하 물류 R&R 관련 F.Destination 정보 활용 방안 (요청자:임화영) */
                             , F.A_COUNTRY
                             , F.A_PORT_CODE
                             , G.A_PORT_NAME
                             , H.COUNTRY_NAME
                             , I.CITY_NAME
                             , J.SHIPTO_REGION_NAME
                             , J.SHIPTO_CITY_NAME
                          FROM (SELECT XA.DIVISION_ID
                                     , XA.ERP_SO_NO
                                     , XA.SHIPMENT_STATUS
                                     , XA.ITEM_ID
                                     , XA.NICK_NAME
                                     , XA.ORIGIN_FROM_DIVISION_ID
                                     , XA.ORIGIN_TO_DIVISION_ID
                                     , XA.FROM_SITE
                                     , XA.FROM_SITE_DESCRIPTION
                                     , XA.TO_SITE
                                     , XA.TO_SITE_DESCRIPTION
                                     , XA.PROJECT_CODE
                                     , XA.PROJECT_NAME
                                     , XA.REQUESTOR
                                     , XA.SHIPMENT_CONFIRM_QTY
                                     , TO_CHAR(TO_DATE(XA.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') AS SHIPMENT_DATE
                                     , XA.BOD_ID
                                     , XA.INCOTERMS
                                     , XA.TRANSPORT_MODE
                                     , XA.TO_SITE_SOLDTO_CODE
                                     , XA.TO_SITE_SHIPTO_CODE
                                     , XA.SOLDTO_DESCRIPTION
                                     , XA.SHIPTO_DESCRIPTION
                                     , XA.REMARKS2
                                     , XA.REMARKS
                                     , XA.CHANGE_REQ_NO
                                     , XA.REMARKS3
                                     , TO_CHAR(TO_DATE(XA.ETD, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETD
                                     , TO_CHAR(TO_DATE(XA.ETA, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETA
                                     , XA.EXPECTED_SHIPPING_DATE
                                     , XA.LT_DAY AS LT_DAY
                                     , XA.UPDATED_BY AS UPDATED_BY
                                     , XA.UPDATED_DATE AS UPDATED_DATE
                                     , XA.CONFIRM_ID AS CONFIRM_ID
                                     , XA.FCST_TYPE
                                     , XA.END_CUSTOMER
                                     , XA.MTK_OWNER
                                     , XA.MODEL_USER
                                  FROM SSP_ANL_SHIP_PLAN_ALL XA
                                     , SCM_MST_ITEM_SN XB
                                     , SSP_MST_MODEL_USER XC
                                 WHERE XA.ITEM_ID = XB.ITEM_ID
                                   AND XA.DIVISION_ID = XB.DIVISION_ID
                                   AND XA.COMPANY_ID = XB.COMPANY_ID
                                   AND XB.ITEM_TYPE NOT IN ('Q', 'R')
                                   AND XC.DIVISION_ID(+) = XA.ORIGIN_FROM_DIVISION_ID
                                   AND XC.FROM_SITE(+) = XA.FROM_SITE
                                   AND XC.ITEM_ID(+) = XA.ITEM_ID
                                   AND XC.VALID_YN(+) = 'Y'
                                   AND XA.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                                   AND XA.DIVISION_ID = P_DIVISION_ID
                                   AND XA.COMPANY_ID = P_COMPANY_ID
                                   AND XA.SHIPMENT_CONFIRM_QTY > 0
                                   AND XA.OPERATION_GROUP <> 'E'
                                   AND XA.YYYYMMDD >= V_DBL_FROM
                                   AND XA.YYYYMMDD <= V_DBL_TO
                                   AND (TRIM(P_ITEM_ID) IS NULL
                                    OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                                  OR XA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
                                    /* OR XA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                                    OR XA.ITEM_ID IN (SELECT COLUMN_VALUE   /* AJS 20261008 Model/Nickname */
                                                      FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                                   AND (TRIM(P_FROM_SITE) IS NULL
                                    OR XA.FROM_SITE IN (SELECT COLUMN_VALUE
                                                          FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                                   /* 원문은 조회조건 값을 그대로 IN 절에 넣어 값으로 찾지 못한다 — 값 비교로 바로잡음 */
                                   AND (P_DBL_FLAG = 'Y'
                                    OR TRIM(P_REQUESTOR) IS NULL
                                    /* 2026.09.30 AJS 수정 (START) */
--                                    OR XA.REQUESTOR IN (SELECT DISTINCT SA.USERID
--                                                          FROM TB_FX_USER SA
--                                                         WHERE SA.USERNAME IN (SELECT COLUMN_VALUE
                                    OR XA.REQUESTOR IN (SELECT DISTINCT SA.USER_ID
                                                          FROM SCM_ADM_USER_M SA
                                                         WHERE SA.USER_NM IN (SELECT COLUMN_VALUE
                                    /* 2026.09.30 AJS 수정 (END) */
                                                                                 FROM TABLE(STRING_SPLIT(P_REQUESTOR, ',')))
                                                            /* 2026.09.30 AJS 수정 (START) */
--                                                            OR SA.USERID IN (SELECT COLUMN_VALUE
                                                            OR SA.USER_ID IN (SELECT COLUMN_VALUE
                                                            /* 2026.09.30 AJS 수정 (END) */
                                                                               FROM TABLE(STRING_SPLIT(P_REQUESTOR, ',')))))) A
                             , (SELECT IB.PLANT_ID
                                     , IB.DIVISION_ID
                                     , IB.PROJECT_CODE
                                     , IB.SCM_SITE_ID
                                     , IB.ITEM_ID
                                     , NVL(SC.DEPT_NAME_KO, '-') AS DEPT_NAME_KO
                                     , IB.OWNER AS OWNER
                                     , IB.END_CUSTOMER
                                     , IB.TO_SITE_DESCRIPTION
                                  FROM (SELECT SA.SEGMENT2 AS PLANT_ID
                                             , SB.DIVISION_ID
                                             , SB.PROJECT_CODE
                                             , SB.SCM_SITE_ID
                                             , SB.ITEM_ID
                                             , SB.OWNER
                                             , NVL(SC.END_CUSTOMER, '-') AS END_CUSTOMER
                                             , NVL(FN_GET_SCM_SITE_DESCRIPTION(SA.SEGMENT3, SA.SEGMENT2), '-') AS TO_SITE_DESCRIPTION
                                             , TRIM(REGEXP_SUBSTR(SB.OWNER, '[^,]+', 1, 1)) AS FIRST_OWNER
                                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                             , SCM_MST_SITE_ITEM SB
                                             , SCM_MST_SITE SC
                                         WHERE SA.LOOKUP_TYPE = 'AS_SITE_PLANT'
                                           AND SA.SEGMENT1 = SB.SCM_SITE_ID
                                           AND SB.DIVISION_ID = SC.DIVISION_ID(+)
                                           AND SB.SCM_SITE_ID = SC.SCM_SITE_ID(+)) IB
                                     , SCM_MST_SSO_USER_INFO SB
                                     , SCM_MST_SSO_DEPT_INFO SC
                                 WHERE IB.FIRST_OWNER = SB.USER_ID(+)
                                   AND SB.DEPT_ID = SC.DEPT_ID(+)) B
                             , SCM_MST_SITE E
                             , SCP_MST_BOD_N_V F
                             , SCP_MST_DISTRIBUTION_ROUTE G
                             , SCM_MST_COUNTRY H
                             , SCM_MST_CITY I
                             , SCM_MST_CUSTOMER J
                             , SCM_MST_SITE_CUSTOMER K
                         WHERE A.DIVISION_ID = B.DIVISION_ID(+)
                           AND A.PROJECT_CODE = B.PROJECT_CODE(+)
                           AND A.TO_SITE_DESCRIPTION = B.TO_SITE_DESCRIPTION(+)
                           AND A.ITEM_ID = B.ITEM_ID(+)
                           /* 221219 jilee 오창 출하 물류 R&R 관련 F.Destination 정보 활용 방안 (요청자:임화영) */
                           AND E.DIVISION_ID(+) = A.DIVISION_ID
                           AND E.SCM_SITE_ID(+) = A.TO_SITE
                           AND E.VALID_YN(+) = 'Y'
                           AND (CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END) = F.DIVISION_ID(+)
                           AND A.BOD_ID = F.BOD_ID(+)
                           AND G.ROUTE_ID(+) = F.ROUTE_ID
                           AND E.DIVISION_ID = K.DIVISION_ID(+)
                           AND E.SCM_SITE_ID = K.SCM_SITE_ID(+)
                           AND K.REP_YN(+) = 'Y'
                           AND K.VALID_YN(+) = 'Y'
                           AND K.DIVISION_ID = J.DIVISION_ID(+)
                           AND K.SOLDTO_CODE = J.SOLDTO_CODE(+)
                           AND K.SHIPTO_CODE = J.SHIPTO_CODE(+)
                           AND E.COUNTRY = H.COUNTRY(+)
                           AND E.COUNTRY = I.COUNTRY(+)
                           AND E.CITY = I.CITY(+)) IA
                 ORDER BY IA.DIVISION_ID, IA.SHIPMENT_STATUS, IA.SHIPMENT_DATE, IA.ITEM_ID, IA.ERP_SO_NO DESC, IA.FROM_SITE, IA.TO_SITE, IA.PROJECT_CODE, IA.FCST_TYPE;

        END IF;

    END P_SSP0021_GET_SHIPMENT_PLAN_DETAIL;
    PROCEDURE P_SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING
    (
        P_CHANGE_REQUEST_NO     IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING
 * Description  : Shipment Plan Change 작성중 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/10   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
        V_LAST_UPDATE_DATE  DATE;
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME      VARCHAR2(150) := 'PKG_SSP0021.P_SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING';
        V_LOG_TYPE          VARCHAR2(30);                                       /* START/END/ERROR/... */
        N_LOG_COUNT         NUMBER := 0;
        V_LOG_MESSAGE       VARCHAR2(1000);
        V_DESCRIPTION       VARCHAR2(500);
        D_EVENT_DATE        DATE;
        V_ERR_MSG           VARCHAR2(4000);
        V_ERR_CODE          NUMBER;
    BEGIN

        V_LAST_UPDATE_DATE := SYSDATE;

        /* 시작 LOG */
        V_LOG_TYPE := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE := V_LAST_UPDATE_DATE;                                     /* [dbo].[FN_MULTY_TIME](@p_time_zone); */
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
           SET VALID_YN = 'N'
             , LAST_UPDATED_BY = P_USER_ID
             , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO;

        UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
           SET VALID_YN = 'N'
             , LAST_UPDATED_BY = P_USER_ID
             , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO;

        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR
            SELECT 'S' AS RESULT_CODE
              FROM DUAL;

        OPEN O_RC2 FOR
            SELECT NULL AS ERROR_MESSAGE
              FROM DUAL
             WHERE 1 = 2;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_MSG := SQLERRM;
            V_ERR_CODE := SQLCODE;

            INSERT INTO SCM_SYS_LOG_BATCH
            (
                PROGRAM_NAME
              , LOG_TYPE
              , LOG_COUNT
              , LOG_MESSAGE
              , DESCRIPTION
              , EVENT_DATE
              , CREATION_DATE
              , CREATED_BY
              , LAST_UPDATE_DATE
              , LAST_UPDATED_BY
            )
            VALUES
            (
                V_PROGRAM_NAME
              , 'ERROR'
              , NULL
              , V_ERR_MSG
              , NULL
              , SYSDATE
              , SYSDATE
              , V_PROGRAM_NAME
              , SYSDATE
              , V_PROGRAM_NAME
            );

            /* error코드, errror 메시지 반환 */
            OPEN O_RC1 FOR
                SELECT 'F' AS RESULT_CODE
                  FROM DUAL;

            OPEN O_RC2 FOR
                SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MSG AS ERROR_MESSAGE
                  FROM DUAL;

    END P_SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING;

    PROCEDURE P_SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING
    (
        P_ACTIVE_FLAG               IN  VARCHAR2
       ,P_DIVISION_ID               IN  VARCHAR2
       ,P_CONFIRM_ID                IN  VARCHAR2
       ,P_SHIPMENT_QTY              IN  VARCHAR2
       ,P_SHIPMENT_DATE             IN  VARCHAR2
       ,P_FROM_SITE                 IN  VARCHAR2
       ,P_NEW_BOD_ID                IN  VARCHAR2
       ,P_NEW_ROUTE_ID              IN  VARCHAR2
       ,P_NEW_ETD_DATE              IN  VARCHAR2
       ,P_NEW_ETA_DATE              IN  VARCHAR2
       ,P_NEW_INCOTERMS             IN  VARCHAR2
       ,P_NEW_TRANSPORT_MODE        IN  VARCHAR2
       ,P_NEW_D_CONTRY              IN  VARCHAR2
       ,P_NEW_D_PORT_CODE           IN  VARCHAR2
       ,P_NEW_A_COUNTRY             IN  VARCHAR2
       ,P_NEW_A_PORT_CODE           IN  VARCHAR2
       ,P_NEW_CUSTOMER_LT           IN  VARCHAR2
       ,P_NEW_TO_COUNTRY            IN  VARCHAR2
       ,P_NEW_TO_CITY               IN  VARCHAR2
       ,P_EDIT_MAIN                 IN  VARCHAR2
       ,P_EDIT_REMARK               IN  VARCHAR2
       ,P_USER_ID                   IN  VARCHAR2
       ,P_USER_DEPT_ID              IN  VARCHAR2
       ,P_ELECTRODE_YN              IN  VARCHAR2
       ,P_ELECTRODE_TYPE            IN  VARCHAR2
       ,P_ORIGIN_FROM_DIVISION_ID   IN  VARCHAR2
       ,P_ORIGION_TO_DIVISION_ID    IN  VARCHAR2
       ,P_REMARKS                   IN  VARCHAR2
       ,P_REMARKS2                  IN  VARCHAR2
       ,P_REMARKS3                  IN  VARCHAR2
       ,P_CHANGE_REASON_CODE        IN  VARCHAR2
       ,P_CHANGE_REASON_DETAIL      IN  VARCHAR2
       ,P_TITLE                     IN  VARCHAR2
       ,P_PROGRAM_ID                IN  VARCHAR2
       ,O_RC1                       OUT SYS_REFCURSOR
       ,O_RC2                       OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING
 * Description  : Shipment Plan Change 작성중 저장
 * 호출			: SSP0021
 * 관련 Table	: SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
 * 관련 프로시저 : PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(XIF_ERP_SHIP_PLAN_CONFIRM_S_SN - ERP 관련 Table)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/10   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2019/04/03	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  REMARKS, REMARKS 컬럼 추가
 * 2019/04/30	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  REQUESTOR 컬럼 변경
 * 2019/05/07	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  REMARKS3 컬럼 추가
 * 2019/05/15	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  CHAGE_REASON_CODE, CHAGE_REASON_DETAIL PARAM추가
 * 2019/05/28	mcTheJ			[PJ20189106] 전지.GSCM 고도화 이행  CHANGE_TITLE 수정
 * 2019/05/29	mcTheJ			[PJ20189106] 전지.GSCM 고도화 이행  CHANGE_REASON 추가로 인한 CS코드에서 반복 호출(단. SONo의 경우 통으로 Parameter 넘김)
 * 2019/09/04	AYJ				etd:shipdate, eta:etd+lt_day로 셋팅
 * 2019/10/29	ayj				FCST_ETA_DATE, ETA_DATE 저장 값 수정(출발일 기준 항차를 고려한 ETA_DATE 계산)
 * 2020-02-26   KIMYONGHO           [C20200224-000318]출하변경사유 코드 변경   R01 - > T07
 * 2021/09/02   KIMYONGHO      SCP_MST_BOD_v -> SCP_MST_BOD_N_V 변경
 * 2021/10/18   KIMYONGHO	   [C20211001-000241][SCM PI팀] Shipment Plan (Auto ESS) 기능 개선 의건
 * 2024/05/08   jilee          PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH  'C' 변경요청
 * 2024/05/22	hsbang			SSP_ANL_SHIP_CONFIRM_CHG_REQ_de A.ATTRIBUTE2(status_detail) 입력
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
        V_MAX_REQ_NO                VARCHAR2(40);
        V_ACTIVE_FLAG               VARCHAR2(4000);
        V_DIVISION_ID               VARCHAR2(4000);
        V_CONFIRM_ID                VARCHAR2(4000);
        V_SHIPMENT_QTY              VARCHAR2(4000);
        V_SHIPMENT_DATE             VARCHAR2(4000);
        V_FROM_SITE                 VARCHAR2(4000);
        V_TO_SITE                   VARCHAR2(4000);
        V_ITEM_ID                   VARCHAR2(4000);
        V_NEW_BOD_ID                VARCHAR2(4000);
        V_NEW_ETD_DATE              VARCHAR2(4000);
        V_NEW_ETA_DATE              VARCHAR2(4000);
        V_NEW_ROUTE_ID              VARCHAR2(4000);
        V_NEW_INCOTERMS             VARCHAR2(4000);
        V_NEW_TRANSPORT_MODE        VARCHAR2(4000);
        V_NEW_D_CONTRY              VARCHAR2(4000);
        V_NEW_D_PORT_CODE           VARCHAR2(4000);
        V_NEW_A_COUNTRY             VARCHAR2(4000);
        V_NEW_A_PORT_CODE           VARCHAR2(4000);
        V_NEW_CUSTOMER_LT           VARCHAR2(4000);
        V_NEW_TO_COUNTRY            VARCHAR2(4000);
        V_NEW_TO_CITY               VARCHAR2(4000);
        V_EDIT_MAIN                 VARCHAR2(4000);
        V_EDIT_REMARK               VARCHAR2(4000);
        V_CREATE_DATE               DATE;
        V_CHK                       NUMBER := 0;
        V_TITLE                     VARCHAR2(4000);
        V_ELECTRODE_YN              VARCHAR2(4000);
        V_ELECTRODE_TYPE            VARCHAR2(4000);
        V_ORIGIN_FROM_DIVISION_ID   VARCHAR2(4000);
        V_ORIGION_TO_DIVISION_ID    VARCHAR2(4000);
        V_REMARKS                   VARCHAR2(4000);
        V_REMARKS2                  VARCHAR2(4000);
        V_REMARKS3                  VARCHAR2(4000);
        V_CHANGE_REASON_CODE        VARCHAR2(4000);
        V_CHANGE_REASON_DETAIL      VARCHAR2(4000);
        V_DIVISION_ID_TEMP          VARCHAR2(4000);
        V_NEW_BOD_ID_TEMP           VARCHAR2(4000);
        V_FROM_SITE_TEMP            VARCHAR2(4000);
        V_TO_SITE_TEMP              VARCHAR2(4000);
        V_NEW_INCOTERMS_TEMP        VARCHAR2(4000);
        V_NEW_TRANSPORT_MODE_TEMP   VARCHAR2(4000);
        V_NEW_ROUTE_ID_TEMP         VARCHAR2(4000);
        V_NEW_D_CONTRY_TEMP         VARCHAR2(4000);
        V_NEW_D_PORT_CODE_TEMP      VARCHAR2(4000);
        V_NEW_A_COUNTRY_TEMP        VARCHAR2(4000);
        V_NEW_A_PORT_CODE_TEMP      VARCHAR2(4000);
        V_NEW_CUSTOMER_LT_TEMP      VARCHAR2(4000);
        V_NEW_TO_COUNTRY_TEMP       VARCHAR2(4000);
        V_NEW_TO_CITY_TEMP          VARCHAR2(4000);
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME              VARCHAR2(150) := P_PROGRAM_ID || '-' || P_TITLE;
        V_LOG_TYPE                  VARCHAR2(30);                               /* START/END/ERROR/... */
        N_LOG_COUNT                 NUMBER := 0;
        V_LOG_MESSAGE               VARCHAR2(1000);
        V_DESCRIPTION               VARCHAR2(500);
        D_EVENT_DATE                DATE;
        V_DELIMITER                 VARCHAR2(1) := '^';
        V_MAX_LOOP_CNT              NUMBER := 0;
        V_MST_LOOP_CNT              NUMBER := 0;
        V_ERR_MSG                   VARCHAR2(4000);
        V_ERR_CODE                  NUMBER;
    BEGIN

        V_CREATE_DATE := SYSDATE;

        /* 시작 LOG */
        V_LOG_TYPE := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 로그 저장이 확정을 동반하므로 되돌림 지점은 그 뒤에 잡는다 */
        SAVEPOINT SP_SAVE_DRAFT;

        V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);

        WHILE LENGTH(RTRIM(P_ACTIVE_FLAG)) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_ACTIVE_FLAG := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG, V_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID := SCM_ARR_SPL_VAL(P_DIVISION_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_CONFIRM_ID := SCM_ARR_SPL_VAL(P_CONFIRM_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPMENT_QTY := SCM_ARR_SPL_VAL(P_SHIPMENT_QTY, V_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPMENT_DATE := SCM_ARR_SPL_VAL(P_SHIPMENT_DATE, V_DELIMITER, V_MST_LOOP_CNT);
            V_FROM_SITE := SCM_ARR_SPL_VAL(P_FROM_SITE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_BOD_ID := SCM_ARR_SPL_VAL(P_NEW_BOD_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_TITLE := 'Change on ' || SCM_ARR_SPL_VAL(P_TITLE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ETD_DATE := SCM_ARR_SPL_VAL(P_NEW_ETD_DATE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ETA_DATE := SCM_ARR_SPL_VAL(P_NEW_ETA_DATE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ROUTE_ID := SCM_ARR_SPL_VAL(P_NEW_ROUTE_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_INCOTERMS := SCM_ARR_SPL_VAL(P_NEW_INCOTERMS, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TRANSPORT_MODE := SCM_ARR_SPL_VAL(P_NEW_TRANSPORT_MODE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_D_CONTRY := SCM_ARR_SPL_VAL(P_NEW_D_CONTRY, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_D_PORT_CODE := SCM_ARR_SPL_VAL(P_NEW_D_PORT_CODE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_A_COUNTRY := SCM_ARR_SPL_VAL(P_NEW_A_COUNTRY, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_A_PORT_CODE := SCM_ARR_SPL_VAL(P_NEW_A_PORT_CODE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_CUSTOMER_LT := SCM_ARR_SPL_VAL(P_NEW_CUSTOMER_LT, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TO_COUNTRY := SCM_ARR_SPL_VAL(P_NEW_TO_COUNTRY, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TO_CITY := SCM_ARR_SPL_VAL(P_NEW_TO_CITY, V_DELIMITER, V_MST_LOOP_CNT);
            V_EDIT_MAIN := SCM_ARR_SPL_VAL(P_EDIT_MAIN, V_DELIMITER, V_MST_LOOP_CNT);
            V_EDIT_REMARK := SCM_ARR_SPL_VAL(P_EDIT_REMARK, V_DELIMITER, V_MST_LOOP_CNT);
            V_ELECTRODE_YN := SCM_ARR_SPL_VAL(P_ELECTRODE_YN, V_DELIMITER, V_MST_LOOP_CNT);
            V_ELECTRODE_TYPE := SCM_ARR_SPL_VAL(P_ELECTRODE_TYPE, V_DELIMITER, V_MST_LOOP_CNT);
            V_ORIGIN_FROM_DIVISION_ID := SCM_ARR_SPL_VAL(P_ORIGIN_FROM_DIVISION_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_ORIGION_TO_DIVISION_ID := SCM_ARR_SPL_VAL(P_ORIGION_TO_DIVISION_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS := SCM_ARR_SPL_VAL(P_REMARKS, V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS2 := SCM_ARR_SPL_VAL(P_REMARKS2, V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS3 := SCM_ARR_SPL_VAL(P_REMARKS3, V_DELIMITER, V_MST_LOOP_CNT);
            V_CHANGE_REASON_CODE := SCM_ARR_SPL_VAL(P_CHANGE_REASON_CODE, V_DELIMITER, V_MST_LOOP_CNT);
            V_CHANGE_REASON_DETAIL := SCM_ARR_SPL_VAL(P_CHANGE_REASON_DETAIL, V_DELIMITER, V_MST_LOOP_CNT);

            IF V_CHANGE_REASON_CODE IS NULL THEN
                V_CHANGE_REASON_CODE := 'T07';
            END IF;

            IF V_CHANGE_REASON_DETAIL IS NULL THEN
                V_CHANGE_REASON_DETAIL := NULL;
            END IF;

            BEGIN
                SELECT TO_SITE
                     , ITEM_ID
                  INTO V_TO_SITE
                     , V_ITEM_ID
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE CONFIRM_ID = V_CONFIRM_ID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_TO_SITE := NULL;
                    V_ITEM_ID := NULL;
            END;

            /* 원문 TOP 1 + ORDER BY PRIORITY 는 첫 행만 받는다 */
            BEGIN
                SELECT DIVISION_ID
                     , BOD_ID
                     , FROM_SITE
                     , TO_SITE
                     , SSP_INCOTERMS
                     , TRANSPORT_MODE
                     , ROUTE_ID
                     , D_COUNTRY
                     , D_PORT_CODE
                     , A_COUNTRY
                     , A_PORT_CODE
                     , LT_TOTAL
                     , TO_COUNTRY
                     , TO_CITY
                  INTO V_DIVISION_ID_TEMP
                     , V_NEW_BOD_ID_TEMP
                     , V_FROM_SITE_TEMP
                     , V_TO_SITE_TEMP
                     , V_NEW_INCOTERMS_TEMP
                     , V_NEW_TRANSPORT_MODE_TEMP
                     , V_NEW_ROUTE_ID_TEMP
                     , V_NEW_D_CONTRY_TEMP
                     , V_NEW_D_PORT_CODE_TEMP
                     , V_NEW_A_COUNTRY_TEMP
                     , V_NEW_A_PORT_CODE_TEMP
                     , V_NEW_CUSTOMER_LT_TEMP
                     , V_NEW_TO_COUNTRY_TEMP
                     , V_NEW_TO_CITY_TEMP
                  FROM (SELECT IA.DIVISION_ID
                             , IA.BOD_ID
                             , IA.FROM_SITE
                             , IA.TO_SITE
                             , IA.SSP_INCOTERMS
                             , IA.TRANSPORT_MODE
                             , IA.ROUTE_ID
                             , IA.D_COUNTRY
                             , IA.D_PORT_CODE
                             , IA.A_COUNTRY
                             , IA.A_PORT_CODE
                             , IA.LT_TOTAL
                             , IA.TO_COUNTRY
                             , IA.TO_CITY
                          FROM (SELECT DISTINCT A.DIVISION_ID
                                     , A.BOD_ID
                                     , A.FROM_SITE
                                     , A.TO_SITE
                                     , A.SSP_INCOTERMS
                                     , A.TRANSPORT_MODE
                                     , A.ROUTE_ID
                                     , A.D_COUNTRY
                                     , A.D_PORT_CODE
                                     , A.A_COUNTRY
                                     , A.A_PORT_CODE
                                     , A.LT_TOTAL
                                     , A.LT_TOTAL_ORIGIN
                                     , A.TO_COUNTRY
                                     , A.TO_CITY
                                     , A.PRIORITY
                                     , A.BOD_VALID_YN
                                  FROM SCP_MST_BOD_N_V A
                                 WHERE A.DIVISION_ID = V_DIVISION_ID
                                   AND A.FROM_SITE = V_FROM_SITE
                                   AND A.TO_SITE = V_TO_SITE
                                   AND A.TRANSPORT_MODE = V_NEW_TRANSPORT_MODE
                                   AND A.SSP_INCOTERMS = V_NEW_INCOTERMS
                                   AND A.BOD_VALID_YN = 'Y'
                                   AND A.FROM_YYYYMMDD <= V_SHIPMENT_DATE
                                   AND A.TO_YYYYMMDD >= V_SHIPMENT_DATE) IA
                             , (SELECT DISTINCT DIVISION_ID
                                     , ITEM_ID
                                     , BOD_ID
                                  FROM SCP_MST_BOD_ITEM
                                 WHERE DIVISION_ID = V_DIVISION_ID
                                   AND ITEM_ID = V_ITEM_ID) XA
                         WHERE IA.DIVISION_ID = XA.DIVISION_ID
                           AND IA.BOD_ID = XA.BOD_ID
                           AND IA.DIVISION_ID = V_DIVISION_ID
                           AND IA.FROM_SITE = V_FROM_SITE
                           AND IA.TO_SITE = V_TO_SITE
                           AND IA.TRANSPORT_MODE = V_NEW_TRANSPORT_MODE
                           AND IA.SSP_INCOTERMS = V_NEW_INCOTERMS
                           AND IA.BOD_VALID_YN = 'Y'
                         ORDER BY IA.PRIORITY)
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;                                                       /* 원문도 대상이 없으면 앞 값을 그대로 둔다 */
            END;

            /* 기준정보(BOD) 필수값 검사 — 하나라도 비면 저장하지 않고 'X' 반환 */
            IF ((V_DIVISION_ID_TEMP IS NULL)
                OR (V_NEW_BOD_ID_TEMP IS NULL)
                OR (V_FROM_SITE_TEMP IS NULL)
                OR (V_TO_SITE_TEMP IS NULL)
                OR (V_NEW_INCOTERMS_TEMP IS NULL)
                OR (V_NEW_TRANSPORT_MODE_TEMP IS NULL)
                OR (V_NEW_ROUTE_ID_TEMP IS NULL)
                OR (V_NEW_D_CONTRY_TEMP IS NULL)
                OR (V_NEW_D_PORT_CODE_TEMP IS NULL)
                OR (V_NEW_A_COUNTRY_TEMP IS NULL)
                OR (V_NEW_A_PORT_CODE_TEMP IS NULL)
                OR (V_NEW_CUSTOMER_LT_TEMP IS NULL)
                OR (V_NEW_TO_COUNTRY_TEMP IS NULL)
                OR (V_NEW_TO_CITY_TEMP IS NULL)
               ) THEN

                /* 결과 커서를 RETURN 앞에서 연다 */
                OPEN O_RC1 FOR
                    SELECT 'X' AS RESULT_CODE
                         , NULL AS REQUEST_NO
                      FROM DUAL;

                OPEN O_RC2 FOR
                    SELECT NULL AS ERROR_MESSAGE
                      FROM DUAL
                     WHERE 1 = 2;

                V_LOG_TYPE := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := '';
                D_EVENT_DATE := SYSDATE;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

                RETURN;

            END IF;

            IF V_EDIT_MAIN = 'Y' THEN

                IF V_CHK = 0 THEN

                    SELECT 'R' || TO_CHAR(V_CREATE_DATE, 'YYYYMMDD') || SUBSTR('000000' || TO_CHAR(SEQ1_SSP_ANL_SHIP_CHG_REQ_NO.NEXTVAL), -6)
                      INTO V_MAX_REQ_NO
                      FROM DUAL;

                    INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ
                    (
                        CHANGE_REQ_NO
                      , CHANGE_TYPE
                      , CHANGE_REQ_STATUS
                      , DIVISION_ID
                      , FROM_SITE
                      , REQUEST_TITLE
                      , REQUEST_USER
                      , REQUEST_DEPT
                      , REQUEST_TIME
                      , APPROVAL_USER
                      , APPROVAL_DEPT
                      , APPROVAL_TIME
                      , CHANGE_REASON_CODE
                      , CHANGE_REASON_DETAIL
                      , REJECT_REASON
                      , VALID_YN
                      , CREATED_BY
                      , CREATION_DATE
                      , LAST_UPDATED_BY
                      , LAST_UPDATE_DATE
                      , ELECTRODE_YN
                      , ELECTRODE_TYPE
                      , ORIGIN_FROM_DIVISION_ID
                      , ORIGIN_TO_DIVISION_ID
                    )
                    VALUES
                    (
                        V_MAX_REQ_NO
                      , 'A'
                      , 'A'
                      , V_DIVISION_ID
                      , V_FROM_SITE
                      , V_TITLE
                      , P_USER_ID
                      , P_USER_DEPT_ID
                      , V_CREATE_DATE
                      , P_USER_ID
                      , P_USER_DEPT_ID
                      , V_CREATE_DATE
                      , V_CHANGE_REASON_CODE
                      , V_CHANGE_REASON_DETAIL
                      , NULL
                      , 'Y'
                      , P_USER_ID
                      , V_CREATE_DATE
                      , P_USER_ID
                      , V_CREATE_DATE
                      , V_ELECTRODE_YN
                      , V_ELECTRODE_TYPE
                      , V_ORIGIN_FROM_DIVISION_ID
                      , V_ORIGION_TO_DIVISION_ID
                    );

                    /* Request_No값 각기(단일) 생성 */
                    V_CHK := 1;

                END IF;

                IF V_SHIPMENT_QTY IS NULL THEN
                    V_SHIPMENT_QTY := NULL;
                END IF;

                IF V_SHIPMENT_DATE IS NULL THEN
                    V_SHIPMENT_DATE := '';
                END IF;

                V_NEW_ETD_DATE := REPLACE(SUBSTR(V_NEW_ETD_DATE, 1, 10), '-', '');
                /* SET @v_new_eta_date = REPLACE(SUBSTRING(@v_new_eta_date,1,10),'-','') */
                V_SHIPMENT_DATE := REPLACE(SUBSTR(V_SHIPMENT_DATE, 1, 10), '-', '');

                /* 2019.09.04 etd:shipdate, eta:etd+lt_day로 셋팅 */
                IF V_SHIPMENT_DATE IS NOT NULL AND LENGTH(V_SHIPMENT_DATE) = 8
                   AND V_NEW_CUSTOMER_LT IS NOT NULL AND LENGTH(V_NEW_CUSTOMER_LT) > 0 THEN
                    V_NEW_ETD_DATE := V_SHIPMENT_DATE;
                END IF;

                /* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산 — 원문은 묶음 파라미터를 그대로 넘긴다 */
                V_NEW_ETA_DATE := FN_GET_SSP_ETA_DATE(P_DIVISION_ID, V_NEW_BOD_ID_TEMP, V_SHIPMENT_DATE);

                INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                (
                    CHANGE_REQ_NO
                  , CONFIRM_ID
                  , NEW_YN
                  , DIVISION_ID
                  , ITEM_ID
                  , FROM_SITE
                  , TO_SITE
                  , YYYYMMDD
                  , QTY
                  , BOD_ID
                  , ROUTE_ID
                  , BIZ_TYPE
                  , PROJECT_CODE
                  , FCST_TYPE
                  , FCST_ETD_DATE
                  , FCST_ETA_DATE
                  , ETD_DATE
                  , ETA_DATE
                  , INCOTERMS
                  , TRANSPORT_MODE
                  , D_COUNTRY
                  , D_PORT_CODE
                  , A_COUNTRY
                  , A_PORT_CODE
                  , CUSTOMER_LT
                  , TO_COUNTRY
                  , TO_CITY
                  , NEW_YYYYMMDD
                  , NEW_QTY
                  , NEW_BOD_ID
                  , NEW_ROUTE_ID
                  , NEW_ETD_DATE
                  , NEW_ETA_DATE
                  , NEW_INCOTERMS
                  , NEW_TRANSPORT_MODE
                  , NEW_D_COUNTRY
                  , NEW_D_PORT_CODE
                  , NEW_A_COUNTRY
                  , NEW_A_PORT_CODE
                  , NEW_CUSTOMER_LT
                  , NEW_TO_COUNTRY
                  , NEW_TO_CITY
                  , FROM_SITE_TYPE
                  , FROM_SITE_PLANT_ID
                  , FROM_SITE_VENDOR_ID
                  , FROM_SITE_SOLDTO_CODE
                  , FROM_SITE_SHIPTO_CODE
                  , FROM_SITE_COMPANY_ID
                  , TO_SITE_TYPE
                  , TO_SITE_PLANT_ID
                  , TO_SITE_VENDOR_ID
                  , TO_SITE_SOLDTO_CODE
                  , TO_SITE_SHIPTO_CODE
                  , TO_SITE_COMPANY_ID
                  , ERP_SO_NO
                  , ERP_SO_ITEM_NO
                  , ERP_DO_NO
                  , ERP_STATUS
                  , VALID_YN
                  , ATTRIBUTE1
                  , ATTRIBUTE2
                  , CREATED_BY
                  , CREATION_DATE
                  , LAST_UPDATED_BY
                  , LAST_UPDATE_DATE
                  , ELECTRODE_YN
                  , ELECTRODE_TYPE
                  , ORIGIN_FROM_DIVISION_ID
                  , ORIGIN_TO_DIVISION_ID
                  , REMARKS
                  , REMARKS2
                  , REMARKS3
                  , REQUESTOR
                )
                SELECT V_MAX_REQ_NO                                             AS CHANGE_REQ_NO
                     , CONFIRM_ID
                     , 'N'                                                      AS NEW_YN
                     , DIVISION_ID
                     , ITEM_ID
                     , FROM_SITE
                     , TO_SITE
                     , YYYYMMDD
                     , QTY
                     , BOD_ID
                     , ROUTE_ID
                     , BIZ_TYPE
                     , PROJECT_CODE
                     , FCST_TYPE
                     , FCST_ETD_DATE
                     , FCST_ETA_DATE
                     , ETD_DATE
                     , ETA_DATE
                     , INCOTERMS
                     , TRANSPORT_MODE
                     , D_COUNTRY
                     , D_PORT_CODE
                     , A_COUNTRY
                     , A_PORT_CODE
                     , CUSTOMER_LT
                     , TO_COUNTRY
                     , TO_CITY
                     , V_SHIPMENT_DATE                                          AS NEW_YYYYMMDD
                     , TO_NUMBER(V_SHIPMENT_QTY)                                AS NEW_QTY
                     , V_NEW_BOD_ID_TEMP                                        AS NEW_BOD_ID
                     , TO_NUMBER(V_NEW_ROUTE_ID_TEMP)                           AS NEW_ROUTE_ID
                     , V_NEW_ETD_DATE                                           AS NEW_ETD_DATE
                     , V_NEW_ETA_DATE                                           AS NEW_ETA_DATE
                     , V_NEW_INCOTERMS_TEMP                                     AS NEW_INCOTERMS
                     , V_NEW_TRANSPORT_MODE_TEMP                                AS NEW_TRANSPORT_MODE
                     , V_NEW_D_CONTRY_TEMP                                      AS NEW_D_COUNTRY
                     , V_NEW_D_PORT_CODE_TEMP                                   AS NEW_D_PORT_CODE
                     , V_NEW_A_COUNTRY_TEMP                                     AS NEW_A_COUNTRY
                     , V_NEW_A_PORT_CODE_TEMP                                   AS NEW_A_PORT_CODE
                     , TO_NUMBER(V_NEW_CUSTOMER_LT_TEMP)                        AS NEW_CUSTOMER_LT
                     , V_NEW_TO_COUNTRY_TEMP                                    AS NEW_TO_COUNTRY
                     , V_NEW_TO_CITY                                            AS NEW_TO_CITY   /* 원문도 기준정보 값이 아니라 화면 입력값을 넣는다 */
                     , FROM_SITE_TYPE
                     , FROM_SITE_PLANT_ID
                     , FROM_SITE_VENDOR_ID
                     , FROM_SITE_SOLDTO_CODE
                     , FROM_SITE_SHIPTO_CODE
                     , FROM_SITE_COMPANY_ID
                     , TO_SITE_TYPE
                     , TO_SITE_PLANT_ID
                     , TO_SITE_VENDOR_ID
                     , TO_SITE_SOLDTO_CODE
                     , TO_SITE_SHIPTO_CODE
                     , TO_SITE_COMPANY_ID
                     , ERP_SO_NO
                     , ERP_SO_ITEM_NO
                     , ERP_DO_NO
                     , ERP_STATUS
                     , 'Y'
                     , 'N'
                     , 'A'
                     , P_USER_ID                                                AS CREATED_BY
                     , V_CREATE_DATE
                     , P_USER_ID                                                AS LAST_UPDATED_BY
                     , V_CREATE_DATE                                            /* [dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE */
                     , ELECTRODE_YN
                     , ELECTRODE_TYPE
                     , ORIGIN_FROM_DIVISION_ID
                     , ORIGIN_TO_DIVISION_ID
                     , V_REMARKS
                     , V_REMARKS2
                     , V_REMARKS3
                     , REQUESTOR
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE CONFIRM_ID = V_CONFIRM_ID;

            END IF;                                                             /* @v_edit_main = 'Y'	End */

        END LOOP;                                                               /* While					End */

        /* ERP전송 Table(XIF_ERP_SHIP_PLAN_CONFIRM_S_SN) Insert */
        /* 출하확정변경시 ERP 전송 이터 테이블 저장 C: 변경요청 */
        PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH('C', V_MAX_REQ_NO);

        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR
            SELECT 'S' AS RESULT_CODE
                 , V_MAX_REQ_NO AS REQUEST_NO
              FROM DUAL;

        OPEN O_RC2 FOR
            SELECT NULL AS ERROR_MESSAGE
              FROM DUAL
             WHERE 1 = 2;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_MSG := SQLERRM;
            V_ERR_CODE := SQLCODE;

            BEGIN
                ROLLBACK TO SP_SAVE_DRAFT;
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;                                                       /* 되돌림 지점을 잡기 전에 난 오류 */
            END;

            INSERT INTO SCM_SYS_LOG_BATCH
            (
                PROGRAM_NAME
              , LOG_TYPE
              , LOG_COUNT
              , LOG_MESSAGE
              , DESCRIPTION
              , EVENT_DATE
              , CREATION_DATE
              , CREATED_BY
              , LAST_UPDATE_DATE
              , LAST_UPDATED_BY
            )
            VALUES
            (
                V_PROGRAM_NAME
              , 'ERROR'
              , NULL
              , V_ERR_MSG
              , NULL
              , SYSDATE
              , SYSDATE
              , V_PROGRAM_NAME
              , SYSDATE
              , V_PROGRAM_NAME
            );

            /* error코드, errror 메시지 반환 */
            OPEN O_RC1 FOR
                SELECT 'F' AS RESULT_CODE
                     , NULL AS REQUEST_NO
                  FROM DUAL;

            OPEN O_RC2 FOR
                SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MSG AS ERROR_MESSAGE
                  FROM DUAL;

    END P_SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING;

    PROCEDURE P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM
    (
        P_ACTIVE_FLAG               IN  VARCHAR2
       ,P_DIVISION_ID               IN  VARCHAR2
       ,P_CONFIRM_ID                IN  VARCHAR2
       ,P_SHIPMENT_QTY              IN  VARCHAR2
       ,P_SHIPMENT_DATE             IN  VARCHAR2
       ,P_NEW_BOD_ID                IN  VARCHAR2
       ,P_NEW_ROUTE_ID              IN  VARCHAR2
       ,P_NEW_ETD_DATE              IN  VARCHAR2
       ,P_NEW_ETA_DATE              IN  VARCHAR2
       ,P_NEW_INCOTERMS             IN  VARCHAR2
       ,P_NEW_TRANSPORT_MODE        IN  VARCHAR2
       ,P_NEW_D_CONTRY              IN  VARCHAR2
       ,P_NEW_D_PORT_CODE           IN  VARCHAR2
       ,P_NEW_A_COUNTRY             IN  VARCHAR2
       ,P_NEW_A_PORT_CODE           IN  VARCHAR2
       ,P_NEW_CUSTOMER_LT           IN  VARCHAR2
       ,P_NEW_TO_COUNTRY            IN  VARCHAR2
       ,P_NEW_TO_CITY               IN  VARCHAR2
       ,P_REMARKS                   IN  VARCHAR2
       ,P_REMARKS2                  IN  VARCHAR2
       ,P_REMARKS3                  IN  VARCHAR2
       ,P_USER_ID                   IN  VARCHAR2
       ,P_CHECK_NEED_YN             IN  VARCHAR2
       ,P_EDIT_MAIN                 IN  VARCHAR2
       ,O_RC1                       OUT SYS_REFCURSOR
       ,O_RC2                       OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM
 * Description  : Shipment Request Confirm 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/10   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/11/16   hwyoon         변경등록 후 메일 전송
 * 2019/03/14   AYJ            [PJ20189106] 전지.GSCM 고도화 이행  REMARKS2 컬럼 추가
 * 2019/04/30   AYJ            [PJ20189106] 전지.GSCM 고도화 이행  REQUESTOR 컬럼 제거
 * 2019/05/07   AYJ            [PJ20189106] 전지.GSCM 고도화 이행  REMARKS3 컬럼 추가
 * 2019/05/30   mcTheJ         [PJ20189106] 전지.GSCM 고도화 이행  CHANGE_REASON 추가로 인한 메일 SEND 수정
 * 2019/10/02   ayj            PLAN TB 미사용으로 인한 주석
 * 2019/10/29   ayj            FCST_ETA_DATE, ETA_DATE 저장 값 수정(출발일 기준 항차를 고려한 ETA_DATE 계산)
 * 2019/11/26   KIMYONGHO      메일 전송 변경 JOB.SCM_SSP_ADJUST_MAIL_SEND_BATCH -> PR_SSP_MAIL_SEND_ADJUST_MST
 * 2020/06/23   khj79          ETD_DATE, FCST_ETD_DATE 를 YYYYMMDD 와 같은 날짜로 변경 되도록 수정
 * 2021/01/07   KIMYONGHO      [C20201223-000448] MKT FCST - SSP Sync
 * 2021/01/12   KIMYONGHO      [C20201223-000448] MKT FCST - SSP Sync 운영이관 검증 단계에서 처리 지연 현상으로 END LOG 이후 호출로 조정함.
 * 2021/01/12   KIMYONGHO      SCS I/F 추가
 * 2021/09/02   KIMYONGHO      SCP_MST_BOD_v -> SCP_MST_BOD_N_V 변경
 * 2021/10/18   KIMYONGHO      [C20211001-000241][SCM PI팀] Shipment Plan (Auto ESS) 기능 개선 의건
 * 2024/02/23   jilee          폴란드 WA 법인 변경건 전체 내역 송부
 * 2024/06/10   jilee          Plan 하단 신규 건 Change Req 정보 입력
 * 2024/10/01   KHJ            NERP_SSP
 * 2025/08/18   chkim.68       [E20250821-001308] -- to_company_id를 from_site에 따라 to_company_id가 다르게 적용되는 예외를 적용 (scm_site_company_exception)
                                FN_GET_SSP_SITE_INFO -> [FN_GET_SSP_SITE_INFO_EXCEPTION]
                                   SSP_SITE_INFO를 이용하여 scm_site_company를 획득하도록 공통화
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
        V_ACTIVE_FLAG               VARCHAR2(4000);
        V_DIVISION_ID               VARCHAR2(4000);
        V_CONFIRM_ID                VARCHAR2(4000);
        V_SHIPMENT_QTY              VARCHAR2(4000);
        V_SHIPMENT_DATE             VARCHAR2(4000);
        V_NEW_BOD_ID                VARCHAR2(4000);
        V_NEW_ETD_DATE              VARCHAR2(4000);
        V_NEW_ETA_DATE              VARCHAR2(4000);
        V_NEW_ROUTE_ID              VARCHAR2(4000);
        V_NEW_INCOTERMS             VARCHAR2(4000);
        V_NEW_TRANSPORT_MODE        VARCHAR2(4000);
        V_NEW_D_CONTRY              VARCHAR2(4000);
        V_NEW_D_PORT_CODE           VARCHAR2(4000);
        V_NEW_A_COUNTRY             VARCHAR2(4000);
        V_NEW_A_PORT_CODE           VARCHAR2(4000);
        V_NEW_CUSTOMER_LT           VARCHAR2(4000);
        V_NEW_TO_COUNTRY            VARCHAR2(4000);
        V_NEW_TO_CITY               VARCHAR2(4000);
        V_CREATE_DATE               DATE;
        V_BEFORE_QTY                NUMBER;
        V_QTY                       NUMBER;
        V_REMARKS                   VARCHAR2(4000);
        V_REMARKS2                  VARCHAR2(4000);
        V_REMARKS3                  VARCHAR2(4000);
        V_CHECK_NEED_YN             VARCHAR2(4000);
        V_PLAN_START_YYYYMMDD       VARCHAR2(4000);
        V_SEQ                       VARCHAR2(4000);
        V_EDIT_MAIN                 VARCHAR2(4000);
        V_CHANGE_REQ_NO             VARCHAR2(4000);
        V_DIVISION_ID_TEMP          VARCHAR2(4000);
        V_NEW_BOD_ID_TEMP           VARCHAR2(4000);
        V_FROM_SITE_TEMP            VARCHAR2(4000);
        V_TO_SITE_TEMP              VARCHAR2(4000);
        V_ITEM_ID_TEMP              VARCHAR2(4000);
        V_NEW_INCOTERMS_TEMP        VARCHAR2(4000);
        V_NEW_TRANSPORT_MODE_TEMP   VARCHAR2(4000);
        V_NEW_ROUTE_ID_TEMP         VARCHAR2(4000);
        V_NEW_D_CONTRY_TEMP         VARCHAR2(4000);
        V_NEW_D_PORT_CODE_TEMP      VARCHAR2(4000);
        V_NEW_A_COUNTRY_TEMP        VARCHAR2(4000);
        V_NEW_A_PORT_CODE_TEMP      VARCHAR2(4000);
        V_NEW_CUSTOMER_LT_TEMP      VARCHAR2(4000);
        V_NEW_TO_COUNTRY_TEMP       VARCHAR2(4000);
        V_NEW_TO_CITY_TEMP          VARCHAR2(4000);
        V_NEW_CONFIRM_ID            VARCHAR2(4000);
        V_INFSEQNO                  VARCHAR2(14);
        V_LAST_CONFIRM_DATE         VARCHAR2(8);
        V_CHK_REQ                   NUMBER := 0;
        V_MAX_REQ_NO                VARCHAR2(40);
        V_USER_DEPT_ID              VARCHAR2(50);
        V_ELECTRODE_YN              VARCHAR2(4000);
        V_ELECTRODE_TYPE            VARCHAR2(4000);
        V_ORIGIN_FROM_DIVISION_ID   VARCHAR2(4000);
        V_ORIGION_TO_DIVISION_ID    VARCHAR2(4000);
        V_GRP_CHANGE_REQ            VARCHAR2(20);
        V_MAIL_FLAG                 NUMBER := 0;
        V_MAIL_CHK                  NUMBER := 0;
        V_TMP_FN_TIME_ZONE          VARCHAR2(8);
        V_TMP_SEQ_CONFIRM           VARCHAR2(20);
        V_WA_COMPANY_ID             VARCHAR2(100);
        V_CFM_COMPANY_ID            VARCHAR2(100);
        V_DELIMITER                 VARCHAR2(1) := '^';
        V_MAX_LOOP_CNT              NUMBER := 0;
        V_MST_LOOP_CNT              NUMBER := 0;
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME              VARCHAR2(150) := 'PKG_SSP0021.P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM';
        V_LOG_TYPE                  VARCHAR2(30);                               /* START/END/ERROR/... */
        N_LOG_COUNT                 NUMBER := 0;
        V_LOG_MESSAGE               VARCHAR2(1000);
        V_DESCRIPTION               VARCHAR2(500);
        D_EVENT_DATE                DATE;
        V_ERR_MSG                   VARCHAR2(4000);
        V_ERR_CODE                  NUMBER;
    BEGIN

        V_CREATE_DATE := SYSDATE;
        V_GRP_CHANGE_REQ := 'G' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');

        /* 시작 LOG */
        V_LOG_TYPE := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 로그 프로시저가 자체 COMMIT 을 하므로 되돌림 지점은 그 뒤에 잡는다 */
        SAVEPOINT SP_SAVE_CONFIRM;

        V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);

        WHILE V_MST_LOOP_CNT < V_MAX_LOOP_CNT LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            V_ACTIVE_FLAG := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG, V_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID := SCM_ARR_SPL_VAL(P_DIVISION_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_CONFIRM_ID := SCM_ARR_SPL_VAL(P_CONFIRM_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPMENT_QTY := SCM_ARR_SPL_VAL(P_SHIPMENT_QTY, V_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPMENT_DATE := SCM_ARR_SPL_VAL(P_SHIPMENT_DATE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_BOD_ID := SCM_ARR_SPL_VAL(P_NEW_BOD_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ETD_DATE := SCM_ARR_SPL_VAL(P_NEW_ETD_DATE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ETA_DATE := SCM_ARR_SPL_VAL(P_NEW_ETA_DATE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ROUTE_ID := SCM_ARR_SPL_VAL(P_NEW_ROUTE_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_INCOTERMS := SCM_ARR_SPL_VAL(P_NEW_INCOTERMS, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TRANSPORT_MODE := SCM_ARR_SPL_VAL(P_NEW_TRANSPORT_MODE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_D_CONTRY := SCM_ARR_SPL_VAL(P_NEW_D_CONTRY, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_D_PORT_CODE := SCM_ARR_SPL_VAL(P_NEW_D_PORT_CODE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_A_COUNTRY := SCM_ARR_SPL_VAL(P_NEW_A_COUNTRY, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_A_PORT_CODE := SCM_ARR_SPL_VAL(P_NEW_A_PORT_CODE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_CUSTOMER_LT := SCM_ARR_SPL_VAL(P_NEW_CUSTOMER_LT, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TO_COUNTRY := SCM_ARR_SPL_VAL(P_NEW_TO_COUNTRY, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TO_CITY := SCM_ARR_SPL_VAL(P_NEW_TO_CITY, V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS := SCM_ARR_SPL_VAL(P_REMARKS, V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS2 := SCM_ARR_SPL_VAL(P_REMARKS2, V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS3 := SCM_ARR_SPL_VAL(P_REMARKS3, V_DELIMITER, V_MST_LOOP_CNT);
            V_CHECK_NEED_YN := SCM_ARR_SPL_VAL(P_CHECK_NEED_YN, V_DELIMITER, V_MST_LOOP_CNT);
            V_EDIT_MAIN := SCM_ARR_SPL_VAL(P_EDIT_MAIN, V_DELIMITER, V_MST_LOOP_CNT);

            BEGIN
                SELECT FROM_SITE
                     , TO_SITE
                     , ITEM_ID
                  INTO V_FROM_SITE_TEMP
                     , V_TO_SITE_TEMP
                     , V_ITEM_ID_TEMP
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE CONFIRM_ID = V_CONFIRM_ID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;                                                       /* 원문도 대상이 없으면 앞 값을 그대로 둔다 */
            END;

            BEGIN
                SELECT DIVISION_ID
                     , BOD_ID
                     , FROM_SITE
                     , TO_SITE
                     , SSP_INCOTERMS
                     , TRANSPORT_MODE
                     , ROUTE_ID
                     , D_COUNTRY
                     , D_PORT_CODE
                     , A_COUNTRY
                     , A_PORT_CODE
                     , LT_TOTAL
                     , TO_COUNTRY
                     , TO_CITY
                  INTO V_DIVISION_ID_TEMP
                     , V_NEW_BOD_ID_TEMP
                     , V_FROM_SITE_TEMP
                     , V_TO_SITE_TEMP
                     , V_NEW_INCOTERMS_TEMP
                     , V_NEW_TRANSPORT_MODE_TEMP
                     , V_NEW_ROUTE_ID_TEMP
                     , V_NEW_D_CONTRY_TEMP
                     , V_NEW_D_PORT_CODE_TEMP
                     , V_NEW_A_COUNTRY_TEMP
                     , V_NEW_A_PORT_CODE_TEMP
                     , V_NEW_CUSTOMER_LT_TEMP
                     , V_NEW_TO_COUNTRY_TEMP
                     , V_NEW_TO_CITY_TEMP
                  FROM (SELECT IA.DIVISION_ID
                             , IA.BOD_ID
                             , IA.FROM_SITE
                             , IA.TO_SITE
                             , IA.SSP_INCOTERMS
                             , IA.TRANSPORT_MODE
                             , IA.ROUTE_ID
                             , IA.D_COUNTRY
                             , IA.D_PORT_CODE
                             , IA.A_COUNTRY
                             , IA.A_PORT_CODE
                             , IA.LT_TOTAL
                             , IA.TO_COUNTRY
                             , IA.TO_CITY
                          FROM (SELECT DISTINCT A.DIVISION_ID
                                     , A.BOD_ID
                                     , A.FROM_SITE
                                     , A.TO_SITE
                                     , A.SSP_INCOTERMS
                                     , A.TRANSPORT_MODE
                                     , A.ROUTE_ID
                                     , A.D_COUNTRY
                                     , A.D_PORT_CODE
                                     , A.A_COUNTRY
                                     , A.A_PORT_CODE
                                     , A.LT_TOTAL
                                     , A.LT_TOTAL_ORIGIN
                                     , A.TO_COUNTRY
                                     , A.TO_CITY
                                     , A.PRIORITY
                                     , A.BOD_VALID_YN
                                  FROM SCP_MST_BOD_N_V A
                                 WHERE A.DIVISION_ID = V_DIVISION_ID
                                   AND A.FROM_SITE = V_FROM_SITE_TEMP
                                   AND A.TO_SITE = V_TO_SITE_TEMP
                                   AND A.TRANSPORT_MODE = V_NEW_TRANSPORT_MODE
                                   AND A.SSP_INCOTERMS = V_NEW_INCOTERMS
                                   AND A.BOD_VALID_YN = 'Y'
                                   AND A.FROM_YYYYMMDD <= V_SHIPMENT_DATE
                                   AND A.TO_YYYYMMDD >= V_SHIPMENT_DATE) IA
                             , (SELECT DISTINCT DIVISION_ID
                                     , ITEM_ID
                                     , BOD_ID
                                  FROM SCP_MST_BOD_ITEM
                                 WHERE DIVISION_ID = V_DIVISION_ID
                                   AND ITEM_ID = V_ITEM_ID_TEMP) XA
                         WHERE IA.DIVISION_ID = XA.DIVISION_ID
                           AND IA.BOD_ID = XA.BOD_ID
                           AND IA.DIVISION_ID = V_DIVISION_ID
                           AND IA.FROM_SITE = V_FROM_SITE_TEMP
                           AND IA.TO_SITE = V_TO_SITE_TEMP
                           AND IA.TRANSPORT_MODE = V_NEW_TRANSPORT_MODE
                           AND IA.SSP_INCOTERMS = V_NEW_INCOTERMS
                           AND IA.BOD_VALID_YN = 'Y'
                         ORDER BY IA.PRIORITY)
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;                                                       /* 원문도 대상이 없으면 앞 값을 그대로 둔다 */
            END;

            /* 기준정보(BOD) 필수값 검사 — 하나라도 비면 저장하지 않고 'X' 반환 */
            IF ((V_DIVISION_ID_TEMP IS NULL)
                OR (V_NEW_BOD_ID_TEMP IS NULL)
                OR (V_FROM_SITE_TEMP IS NULL)
                OR (V_TO_SITE_TEMP IS NULL)
                OR (V_NEW_INCOTERMS_TEMP IS NULL)
                OR (V_NEW_TRANSPORT_MODE_TEMP IS NULL)
                OR (V_NEW_ROUTE_ID_TEMP IS NULL)
                OR (V_NEW_D_CONTRY_TEMP IS NULL)
                OR (V_NEW_D_PORT_CODE_TEMP IS NULL)
                OR (V_NEW_A_COUNTRY_TEMP IS NULL)
                OR (V_NEW_A_PORT_CODE_TEMP IS NULL)
                OR (V_NEW_CUSTOMER_LT_TEMP IS NULL)
                OR (V_NEW_TO_COUNTRY_TEMP IS NULL)
                OR (V_NEW_TO_CITY_TEMP IS NULL)
               ) THEN

                /* 결과 커서를 RETURN 앞에서 연다 */
                OPEN O_RC1 FOR
                    SELECT 'X' AS RESULT_CODE
                         , NULL AS RESULT_CNT
                         , NULL AS CHANGE_REQ_NO
                      FROM DUAL;

                OPEN O_RC2 FOR
                    SELECT NULL AS ERR_MESSAGE
                      FROM DUAL
                     WHERE 1 = 2;

                V_LOG_TYPE := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := '';
                D_EVENT_DATE := SYSDATE;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

                RETURN;

            END IF;

            /*--//기존 확정 건 수정//--*/
            IF V_ACTIVE_FLAG <> 'I' THEN

                V_QTY := 0;
                V_BEFORE_QTY := 0;

                BEGIN
                    SELECT QTY
                         , BEFORE_QTY
                      INTO V_QTY
                         , V_BEFORE_QTY
                      FROM SSP_ANL_SHIP_CONFIRM
                     WHERE CONFIRM_ID = V_CONFIRM_ID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;

                IF V_QTY <> TO_NUMBER(V_SHIPMENT_QTY) THEN
                    V_BEFORE_QTY := V_QTY;
                END IF;

                IF V_SHIPMENT_QTY IS NULL THEN
                    V_SHIPMENT_QTY := NULL;
                END IF;

                IF V_SHIPMENT_DATE IS NULL THEN
                    V_SHIPMENT_DATE := '';
                END IF;

                V_NEW_ETD_DATE := REPLACE(SUBSTR(V_NEW_ETD_DATE, 1, 10), '-', '');
                V_SHIPMENT_DATE := REPLACE(SUBSTR(V_SHIPMENT_DATE, 1, 10), '-', '');

                /* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산 */
                V_NEW_ETA_DATE := FN_GET_SSP_ETA_DATE(V_DIVISION_ID, V_NEW_BOD_ID_TEMP, V_SHIPMENT_DATE);

                IF V_EDIT_MAIN = 'Y' THEN
                    V_CHECK_NEED_YN := 'Y';
                END IF;

                /* 2020.06.23 ETD_DATE, FCST_ETD_DATE 를 YYYYMMDD 와 같은 날짜로 변경 되도록 수정 */
                UPDATE SSP_ANL_SHIP_CONFIRM
                   SET YYYYMMDD = V_SHIPMENT_DATE
                     , QTY = TO_NUMBER(V_SHIPMENT_QTY)
                     , BEFORE_QTY = V_BEFORE_QTY
                     , BOD_ID = V_NEW_BOD_ID_TEMP
                     , ROUTE_ID = V_NEW_ROUTE_ID_TEMP
                     , INCOTERMS = V_NEW_INCOTERMS_TEMP
                     , D_COUNTRY = V_NEW_D_CONTRY_TEMP
                     , D_PORT_CODE = V_NEW_D_PORT_CODE_TEMP
                     , A_COUNTRY = V_NEW_A_COUNTRY_TEMP
                     , A_PORT_CODE = V_NEW_A_PORT_CODE_TEMP
                     , TO_COUNTRY = V_NEW_TO_COUNTRY_TEMP
                     , TO_CITY = V_NEW_TO_CITY_TEMP
                     , TRANSPORT_MODE = V_NEW_TRANSPORT_MODE_TEMP
                     , ETD_DATE = V_SHIPMENT_DATE                               /* V_NEW_ETD_DATE */
                     , ETA_DATE = V_NEW_ETA_DATE
                     , FCST_ETD_DATE = V_SHIPMENT_DATE                          /* V_NEW_ETD_DATE */
                     , FCST_ETA_DATE = V_NEW_ETA_DATE
                     , CUSTOMER_LT = TO_NUMBER(V_NEW_CUSTOMER_LT_TEMP)
                     , REMARKS = V_REMARKS
                     , REMARKS2 = V_REMARKS2
                     , REMARKS3 = V_REMARKS3
                     , CHECK_NEED_YN = V_CHECK_NEED_YN
                     , LAST_UPDATED_BY = P_USER_ID
                     , LAST_UPDATE_DATE = V_CREATE_DATE
                 WHERE CONFIRM_ID = V_CONFIRM_ID;

                IF V_EDIT_MAIN = 'Y' THEN

                    BEGIN
                        SELECT CHANGE_REQ_NO
                          INTO V_CHANGE_REQ_NO
                          FROM (SELECT A.CHANGE_REQ_NO
                                  FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE A
                                 WHERE A.CONFIRM_ID = V_CONFIRM_ID
                                   AND A.VALID_YN = 'Y'
                                 ORDER BY A.LAST_UPDATE_DATE DESC)
                         WHERE ROWNUM = 1;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;

                END IF;

                IF LENGTH(RTRIM(V_CHANGE_REQ_NO)) > 0 THEN

                    PR_SSP_ANL_SHIP_CONFIRM_HIST(V_CHANGE_REQ_NO, P_USER_ID, '');

                    IF V_DIVISION_ID = '82' THEN
                        PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS('B', V_CHANGE_REQ_NO);
                    END IF;

                    SELECT COUNT(*)
                      INTO V_MAIL_CHK
                      FROM SSP_MST_SEND_MAIL_REQ
                     WHERE CHANGE_REQ_NO = V_CHANGE_REQ_NO;

                    IF V_MAIL_CHK = 0 THEN

                        INSERT INTO SSP_MST_SEND_MAIL_REQ
                        (
                            CHANGE_REQ_NO
                          , TRANSFER_FLAG
                          , GRP_CHANGE_REQ
                        )
                        VALUES
                        (
                            V_CHANGE_REQ_NO
                          , 'N'
                          , V_GRP_CHANGE_REQ
                        );

                        V_MAIL_FLAG := 1;

                    END IF;

                END IF;

            END IF;

            IF V_MAIL_FLAG = 1 THEN
                PR_SSP_MAIL_SEND_ADJUST_MST(V_GRP_CHANGE_REQ);
            END IF;

            /* 2020-07-24 KIMYONGHO 신규생성 기능 추가 */
            IF V_ACTIVE_FLAG = 'I' THEN

                SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') || SUBSTR('000000' || TO_CHAR(SEQ1_XIF_ERP_IFSEQNO.NEXTVAL), -6)
                  INTO V_INFSEQNO
                  FROM DUAL;

                V_LAST_CONFIRM_DATE := TO_CHAR(SYSDATE + 9, 'YYYYMMDD');

                V_DESCRIPTION := '';
                D_EVENT_DATE := SYSDATE;                                        /* FN_MULTY_TIME(P_TIME_ZONE) */
                PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

                V_TMP_FN_TIME_ZONE := TO_CHAR(FN_MULTY_TIME(NULL), 'YYYYMMDD');
                V_TMP_SEQ_CONFIRM := TO_CHAR(SEQ1_SSP_ANL_SHIP_CONFIRM_ID.NEXTVAL);
                V_NEW_CONFIRM_ID := 'C' || V_TMP_FN_TIME_ZONE || SUBSTR('000000' || V_TMP_SEQ_CONFIRM, -6);

                SELECT MAX(PLAN_START_YYYYMMDD)
                     , MAX(PLAN_SEQ)
                  INTO V_PLAN_START_YYYYMMDD
                     , V_SEQ
                  FROM SSP_PLAN_VERSION_V
                 WHERE PLAN_TYPE = 'SP'
                   AND DIVISION_ID = V_DIVISION_ID
                   AND CONFIRM_FLAG = 'Y'
                   AND PLAN_START_YYYYMMDD = (SELECT MAX(SA.PLAN_START_YYYYMMDD)
                                                FROM SSP_PLAN_VERSION_V SA
                                               WHERE SA.DIVISION_ID = V_DIVISION_ID
                                                 AND SA.PLAN_TYPE = 'SP'
                                                 AND SA.CONFIRM_FLAG = 'Y');

                IF V_PLAN_START_YYYYMMDD IS NULL THEN
                    V_PLAN_START_YYYYMMDD := TO_CHAR(SYSDATE, 'YYYYMMDD');
                    V_SEQ := 1;
                END IF;

                V_QTY := 0;
                V_BEFORE_QTY := 0;

                BEGIN
                    SELECT QTY
                         , BEFORE_QTY
                      INTO V_QTY
                         , V_BEFORE_QTY
                      FROM SSP_ANL_SHIP_CONFIRM
                     WHERE CONFIRM_ID = V_CONFIRM_ID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;

                IF V_QTY <> TO_NUMBER(V_SHIPMENT_QTY) * 1 THEN
                    V_BEFORE_QTY := V_QTY;
                END IF;

                IF V_SHIPMENT_QTY IS NULL THEN
                    V_SHIPMENT_QTY := NULL;
                END IF;

                IF V_SHIPMENT_DATE IS NULL THEN
                    V_SHIPMENT_DATE := '';
                END IF;

                V_NEW_ETD_DATE := REPLACE(SUBSTR(V_NEW_ETD_DATE, 1, 10), '-', '');
                V_SHIPMENT_DATE := REPLACE(SUBSTR(V_SHIPMENT_DATE, 1, 10), '-', '');

                /* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산 */
                V_NEW_ETA_DATE := FN_GET_SSP_ETA_DATE(V_DIVISION_ID, V_NEW_BOD_ID_TEMP, V_SHIPMENT_DATE);

                IF V_EDIT_MAIN = 'Y' THEN
                    V_CHECK_NEED_YN := 'Y';
                END IF;

                INSERT INTO SSP_ANL_SHIP_CONFIRM
                (
                    CONFIRM_ID
                  , SHIPMENT_STATUS
                  , DIVISION_ID
                  , PLAN_START_YYYYMMDD
                  , PLAN_TYPE
                  , SEQ
                  , ITEM_ID
                  , FROM_SITE
                  , TO_SITE
                  , YYYYMMDD
                  , PLANNED_QTY
                  , QTY
                  , BOD_ID
                  , ROUTE_ID
                  , BIZ_TYPE
                  , PROJECT_CODE
                  , FCST_TYPE
                  , FCST_ETD_DATE
                  , FCST_ETA_DATE
                  , ETD_DATE
                  , ETA_DATE
                  , INCOTERMS
                  , TRANSPORT_MODE
                  , D_COUNTRY
                  , D_PORT_CODE
                  , A_COUNTRY
                  , A_PORT_CODE
                  , CUSTOMER_LT
                  , TO_COUNTRY
                  , TO_CITY
                  , FROM_SITE_TYPE
                  , FROM_SITE_PLANT_ID
                  , FROM_SITE_VENDOR_ID
                  , FROM_SITE_SOLDTO_CODE
                  , FROM_SITE_SHIPTO_CODE
                  , FROM_SITE_COMPANY_ID
                  , TO_SITE_TYPE
                  , TO_SITE_PLANT_ID
                  , TO_SITE_VENDOR_ID
                  , TO_SITE_SOLDTO_CODE
                  , TO_SITE_SHIPTO_CODE
                  , TO_SITE_COMPANY_ID
                  , CHANGE_TYPE
                  , CREATED_BY
                  , CREATION_DATE
                  , LAST_UPDATED_BY
                  , LAST_UPDATE_DATE
                  , ELECTRODE_YN
                  , ORIGIN_FROM_DIVISION_ID
                  , ORIGIN_TO_DIVISION_ID
                  , REQUESTOR
                  , BEFORE_QTY
                  , CHECK_NEED_YN
                  , PACKAGE_TYPE_CODE
                  , FACTORY_ID
                  , ELECTRODE_TYPE
                  , PACKAGE_QTY
                  , DOM_EXP
                  , REMARKS
                  , REMARKS2
                  , REMARKS3
                  , ATTRIBUTE10
                )
                SELECT V_NEW_CONFIRM_ID
                     , 'C'
                     , A.DIVISION_ID
                     , V_PLAN_START_YYYYMMDD
                     , 'SP'
                     , V_SEQ
                     , A.ITEM_ID
                     , A.FROM_SITE
                     , A.TO_SITE
                     , V_SHIPMENT_DATE
                     , 0
                     , TO_NUMBER(V_SHIPMENT_QTY) * 1
                     , V_NEW_BOD_ID_TEMP
                     , V_NEW_ROUTE_ID_TEMP
                     , A.BIZ_TYPE
                     , A.PROJECT_CODE
                     , A.FCST_TYPE
                     , V_SHIPMENT_DATE
                     , V_NEW_ETA_DATE
                     , V_SHIPMENT_DATE
                     , V_NEW_ETA_DATE
                     , V_NEW_INCOTERMS_TEMP
                     , V_NEW_TRANSPORT_MODE_TEMP
                     , V_NEW_D_CONTRY_TEMP
                     , V_NEW_D_PORT_CODE_TEMP
                     , V_NEW_A_COUNTRY_TEMP
                     , V_NEW_A_PORT_CODE_TEMP
                     , TO_NUMBER(V_NEW_CUSTOMER_LT_TEMP)
                     , V_NEW_TO_COUNTRY_TEMP
                     , V_NEW_TO_CITY_TEMP
                     , A.FROM_SITE_TYPE
                     , A.FROM_SITE_PLANT_ID
                     , A.FROM_SITE_VENDOR_ID
                     , A.FROM_SITE_SOLDTO_CODE
                     , A.FROM_SITE_SHIPTO_CODE
                     , A.FROM_SITE_COMPANY_ID
                     /* [E20250821-001308] -- TO_COMPANY_ID를 FROM_SITE에 따라 다르게 적용하는 예외를 적용 */
                     , FN_GET_SSP_SITE_INFO_EXCEPTION(V_DIVISION_ID, A.FROM_SITE, A.TO_SITE, 'SITE_TYPE')
                     , A.TO_SITE_PLANT_ID
                     , A.TO_SITE_VENDOR_ID
                     , A.TO_SITE_SOLDTO_CODE
                     , A.TO_SITE_SHIPTO_CODE
                     /* [E20250821-001308] -- TO_COMPANY_ID를 FROM_SITE에 따라 다르게 적용하는 예외를 적용 */
                     , FN_GET_SSP_SITE_INFO_EXCEPTION(V_DIVISION_ID, A.FROM_SITE, A.TO_SITE, 'COMPANY_ID')
                     , 'C'
                     , P_USER_ID
                     , V_CREATE_DATE
                     , P_USER_ID
                     , V_CREATE_DATE
                     , A.ELECTRODE_YN
                     , A.ORIGIN_FROM_DIVISION_ID
                     , A.ORIGIN_TO_DIVISION_ID
                     , P_USER_ID
                     , 0
                     , 'Y'
                     , A.PACKAGE_TYPE_CODE
                     , A.FACTORY_ID
                     , A.ELECTRODE_TYPE
                     , CEIL(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(TO_NUMBER(V_SHIPMENT_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.BOX_PER_CUT, 1)
                                 WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(TO_NUMBER(V_SHIPMENT_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELCRATE_PER_CUT, 1)
                                 WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(TO_NUMBER(V_SHIPMENT_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELRACK_PER_CUT, 1)
                            ELSE NULL END)
                     , A.DOM_EXP
                     , V_REMARKS
                     , V_REMARKS2
                     , V_REMARKS3
                     , NULL
                  FROM SSP_ANL_SHIP_CONFIRM A
                     , SSP_MST_SITE_ITEM_EE_V B
                 WHERE A.DIVISION_ID = (CASE WHEN A.BIZ_TYPE = 'E' THEN B.DIVISION_ID(+) ELSE B.ASSY_DIVISION_ID(+) END)
                   AND A.FROM_SITE = (CASE WHEN A.BIZ_TYPE = 'E' THEN B.SCM_SITE_ID(+) ELSE B.ASSY_SCM_SITE_ID(+) END)
                   AND A.ITEM_ID = B.ITEM_ID(+)
                   AND A.CONFIRM_ID = V_CONFIRM_ID;

                INSERT INTO SSP_ANL_SHIP_CONFIRM_H
                (
                    HISTORY_SEQ
                  , CONFIRM_ID
                  , CHANGE_TYPE
                  , SHIPMENT_STATUS
                  , DIVISION_ID
                  , PLAN_START_YYYYMMDD
                  , PLAN_TYPE
                  , SEQ
                  , ITEM_ID
                  , FROM_SITE
                  , TO_SITE
                  , YYYYMMDD
                  , PLANNED_QTY
                  , QTY
                  , BOD_ID
                  , ROUTE_ID
                  , BIZ_TYPE
                  , PROJECT_CODE
                  , FCST_TYPE
                  , FCST_ETD_DATE
                  , FCST_ETA_DATE
                  , ETD_DATE
                  , ETA_DATE
                  , INCOTERMS
                  , TRANSPORT_MODE
                  , D_COUNTRY
                  , D_PORT_CODE
                  , A_COUNTRY
                  , A_PORT_CODE
                  , CUSTOMER_LT
                  , TO_COUNTRY
                  , TO_CITY
                  , FROM_SITE_TYPE
                  , FROM_SITE_PLANT_ID
                  , FROM_SITE_VENDOR_ID
                  , FROM_SITE_SOLDTO_CODE
                  , FROM_SITE_SHIPTO_CODE
                  , FROM_SITE_COMPANY_ID
                  , TO_SITE_TYPE
                  , TO_SITE_PLANT_ID
                  , TO_SITE_VENDOR_ID
                  , TO_SITE_SOLDTO_CODE
                  , TO_SITE_SHIPTO_CODE
                  , TO_SITE_COMPANY_ID
                  , CHANGE_REQ_NO
                  , ERP_SO_NO
                  , ERP_SO_ITEM_NO
                  , ERP_DO_NO
                  , ERP_STATUS
                  , CREATED_BY
                  , CREATION_DATE
                  , LAST_UPDATED_BY
                  , LAST_UPDATE_DATE
                  , HISTORY_CREATION_DATE
                  , ELECTRODE_YN
                  , ELECTRODE_TYPE
                  , ORIGIN_FROM_DIVISION_ID
                  , ORIGIN_TO_DIVISION_ID
                  , BEFORE_QTY
                  , REMARKS
                  , CHECK_NEED_YN
                )
                SELECT SEQ1_SSP_ANL_SHIP_CONFIRM_H.NEXTVAL                      /* HISTORY_SEQ */
                     , CONFIRM_ID
                     , CHANGE_TYPE
                     , SHIPMENT_STATUS
                     , DIVISION_ID
                     , PLAN_START_YYYYMMDD
                     , PLAN_TYPE
                     , SEQ
                     , ITEM_ID
                     , FROM_SITE
                     , TO_SITE
                     , YYYYMMDD
                     , PLANNED_QTY
                     , QTY
                     , BOD_ID
                     , ROUTE_ID
                     , BIZ_TYPE
                     , PROJECT_CODE
                     , FCST_TYPE
                     , FCST_ETD_DATE
                     , FCST_ETA_DATE
                     , ETD_DATE
                     , ETA_DATE
                     , INCOTERMS
                     , TRANSPORT_MODE
                     , D_COUNTRY
                     , D_PORT_CODE
                     , A_COUNTRY
                     , A_PORT_CODE
                     , CUSTOMER_LT
                     , TO_COUNTRY
                     , TO_CITY
                     , FROM_SITE_TYPE
                     , FROM_SITE_PLANT_ID
                     , FROM_SITE_VENDOR_ID
                     , FROM_SITE_SOLDTO_CODE
                     , FROM_SITE_SHIPTO_CODE
                     , FROM_SITE_COMPANY_ID
                     , TO_SITE_TYPE
                     , TO_SITE_PLANT_ID
                     , TO_SITE_VENDOR_ID
                     , TO_SITE_SOLDTO_CODE
                     , TO_SITE_SHIPTO_CODE
                     , TO_SITE_COMPANY_ID
                     , NULL                                                     /* CHANGE_REQ_NO */
                     , NULL                                                     /* ERP_SO_NO */
                     , NULL                                                     /* ERP_SO_ITEM_NO */
                     , NULL                                                     /* ERP_DO_NO */
                     , NULL                                                     /* ERP_STATUS */
                     , P_USER_ID                                                /* CREATED_BY */
                     , V_CREATE_DATE                                            /* CREATION_DATE */
                     , P_USER_ID                                                /* LAST_UPDATED_BY */
                     , V_CREATE_DATE                                            /* LAST_UPDATE_DATE */
                     , V_CREATE_DATE                                            /* HISTORY_CREATION_DATE */
                     , ELECTRODE_YN
                     , ELECTRODE_TYPE
                     , ORIGIN_FROM_DIVISION_ID
                     , ORIGIN_TO_DIVISION_ID
                     , BEFORE_QTY
                     , REMARKS
                     , CHECK_NEED_YN
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE CONFIRM_ID = V_NEW_CONFIRM_ID;

                INSERT INTO XIF_ERP_SHIP_PLAN_CONFIRM_S_SN
                (
                    IFSEQNO
                  , CONFIRM_ID
                  , SHIPMENT_STATUS
                  , LAST_CONFIRM_DATE
                  , VERSION_TYPE
                  , SALES_COMPANY_ID
                  , DIVISION_ID
                  , ITEM_ID
                  , FROM_SITE
                  , TO_SITE
                  , YYYYMMDD
                  , QTY
                  , BOD_ID
                  , ROUTE_ID
                  , OPERATION_GROUP
                  , BIZ_TYPE
                  , PROJECT_CODE
                  , FCST_TYPE
                  , FCST_ETD_DATE
                  , FCST_ETA_DATE
                  , ETD_DATE
                  , ETA_DATE
                  , INCOTERMS
                  , INCOTERMS2
                  , TRANSPORT_MODE
                  , D_COUNTRY
                  , D_PORT_CODE
                  , A_COUNTRY
                  , A_PORT_CODE
                  , CUSTOMER_LT
                  , TO_COUNTRY
                  , TO_CITY
                  , FROM_SITE_TYPE
                  , FROM_SITE_PLANT_ID
                  , FROM_SITE_VENDOR_ID
                  , FROM_SITE_SOLDTO_CODE
                  , FROM_SITE_SHIPTO_CODE
                  , FROM_SITE_COMPANY_ID
                  , TO_SITE_TYPE
                  , TO_SITE_PLANT_ID
                  , TO_SITE_VENDOR_ID
                  , TO_SITE_SOLDTO_CODE
                  , TO_SITE_SHIPTO_CODE
                  , TO_SITE_COMPANY_ID
                  , BUILDING
                  , REMARK
                  , CUSTOMER_REQ
                  , CHANGE_CODE
                  , CHANGE_CODE_NAME
                  , REQUESTOR
                  , TRANSFER_FLAG
                  , TRANSFER_DATE
                  , CREATED_BY
                  , CREATION_DATE
                  , LAST_UPDATED_BY
                  , LAST_UPDATE_DATE
                  , ATTRIBUTE1
                  , ATTRIBUTE2
                  , ATTRIBUTE3
                  , ATTRIBUTE4
                  , ATTRIBUTE5
                  , ATTRIBUTE6
                  , ATTRIBUTE7
                  , ATTRIBUTE8
                  , ATTRIBUTE9
                  , ATTRIBUTE10
                  /*----------------------------------------------------------------------------------------
                      2020.06.30 : KBK
                      I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                  ------------------------------------------------------------------------------------------*/
                  , PACKAGE_TYPE
                  , FACTORY_ID
                  , PACKAGE_QTY
                  , DOM_EXP
                  , ERP_ATTR1
                  , ERP_ATTR2
                  , ERP_ATTR3
                  , ERP_ATTR4
                  , ERP_ATTR5
                )
                SELECT IA.IFSEQNO
                     , IA.CONFIRM_ID
                     , IA.SHIPMENT_STATUS
                     , IA.LAST_CONFIRM_DATE
                     , IA.VERSION_TYPE
                     , NVL(C.NEW_VALUE1, IA.SALES_COMPANY_ID) AS SALES_COMPANY_ID
                     , IA.DIVISION_ID
                     , IA.ITEM_ID
                     , NVL(D.NEW_VALUE1, IA.FROM_SITE) AS FROM_SITE
                     , NVL(E.NEW_VALUE1, IA.TO_SITE) AS TO_SITE
                     , IA.YYYYMMDD
                     , IA.QTY
                     , IA.BOD_ID
                     , IA.ROUTE_ID
                     , IA.OPERATION_GROUP
                     , IA.BIZ_TYPE
                     , IA.PROJECT_CODE
                     , IA.FCST_TYPE
                     , IA.FCST_ETD_DATE
                     , IA.FCST_ETA_DATE
                     , IA.ETD_DATE
                     , IA.ETA_DATE
                     , IA.INCOTERMS
                     , IA.INCOTERMS2
                     , IA.TRANSPORT_MODE
                     , IA.D_COUNTRY
                     , IA.D_PORT_CODE
                     , IA.A_COUNTRY
                     , IA.A_PORT_CODE
                     , IA.CUSTOMER_LT
                     , IA.TO_COUNTRY
                     , IA.TO_CITY
                     , IA.FROM_SITE_TYPE
                     , NVL(F.NEW_VALUE1, IA.FROM_SITE_PLANT_ID) AS FROM_SITE_PLANT_ID
                     , NVL(G.NEW_VALUE1, IA.FROM_SITE_VENDOR_ID) AS FROM_SITE_VENDOR_ID
                     , NVL(H.NEW_VALUE1, IA.FROM_SITE_SOLDTO_CODE) AS FROM_SITE_SOLDTO_CODE
                     , NVL(I.NEW_VALUE1, IA.FROM_SITE_SHIPTO_CODE) AS FROM_SITE_SHIPTO_CODE
                     , NVL(J.NEW_VALUE1, IA.FROM_SITE_COMPANY_ID) AS FROM_SITE_COMPANY_ID
                     , IA.TO_SITE_TYPE
                     , NVL(K.NEW_VALUE1, IA.TO_SITE_PLANT_ID) AS TO_SITE_PLANT_ID
                     , NVL(L.NEW_VALUE1, IA.TO_SITE_VENDOR_ID) AS TO_SITE_VENDOR_ID
                     , NVL(M.NEW_VALUE1, IA.TO_SITE_SOLDTO_CODE) AS TO_SITE_SOLDTO_CODE
                     , NVL(N.NEW_VALUE1, IA.TO_SITE_SHIPTO_CODE) AS TO_SITE_SHIPTO_CODE
                     , NVL(O.NEW_VALUE1, IA.TO_SITE_COMPANY_ID) AS TO_SITE_COMPANY_ID
                     , IA.BUILDING
                     , IA.REMARK
                     , IA.CUSTOMER_REQ
                     , IA.CHANGE_CODE
                     , IA.CHANGE_CODE_NAME
                     , IA.REQUESTOR
                     , IA.TRANSFER_FLAG
                     , IA.TRANSFER_DATE
                     , IA.CREATED_BY
                     , IA.CREATION_DATE
                     , IA.LAST_UPDATED_BY
                     , IA.LAST_UPDATE_DATE
                     , IA.ATTRIBUTE1
                     , IA.ATTRIBUTE2
                     , IA.ATTRIBUTE3
                     , IA.ATTRIBUTE4
                     , IA.ATTRIBUTE5
                     , IA.ATTRIBUTE6
                     , IA.ATTRIBUTE7
                     , IA.ATTRIBUTE8
                     , IA.ATTRIBUTE9
                     , IA.ATTRIBUTE10
                     /*----------------------------------------------------------------------------------------
                         2020.06.30 : KBK
                         I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                     ------------------------------------------------------------------------------------------*/
                     , IA.PACKAGE_TYPE_CODE
                     , IA.FACTORY_ID
                     , IA.PACKAGE_QTY
                     , IA.DOM_EXP
                     , NULL AS ERP_ATTR1
                     , NULL AS ERP_ATTR2
                     , NULL AS ERP_ATTR3
                     , IA.TO_SITE_PLANT_ID AS ERP_ATTR4                         /* NERP에서 원본 정보 참고용 (2025-04-23) */
                     , NULL AS ERP_ATTR5
                  FROM (SELECT XA.IFSEQNO
                             , XA.CONFIRM_ID
                             , XA.SHIPMENT_STATUS
                             , XA.LAST_CONFIRM_DATE
                             , XA.VERSION_TYPE
                             , XA.SALES_COMPANY_ID
                             , XB.ATTRIBUTE3 AS DIVISION_ID
                             , XA.ITEM_ID
                             , XA.FROM_SITE
                             , XA.TO_SITE
                             , XA.YYYYMMDD
                             , XA.QTY
                             , XA.BOD_ID
                             , XA.ROUTE_ID
                             , XA.OPERATION_GROUP
                             , XA.BIZ_TYPE
                             , XA.PROJECT_CODE
                             , XA.FCST_TYPE
                             , XA.FCST_ETD_DATE
                             , XA.FCST_ETA_DATE
                             , XA.ETD_DATE
                             , XA.ETA_DATE
                             , XA.INCOTERMS
                             , XA.INCOTERMS2
                             , XA.TRANSPORT_MODE
                             , XA.D_COUNTRY
                             , XA.D_PORT_CODE
                             , XA.A_COUNTRY
                             , XA.A_PORT_CODE
                             , XA.CUSTOMER_LT
                             , XA.TO_COUNTRY
                             , XA.TO_CITY
                             , XA.FROM_SITE_TYPE
                             , XA.FROM_SITE_PLANT_ID
                             , XA.FROM_SITE_VENDOR_ID
                             , XA.FROM_SITE_SOLDTO_CODE
                             , XA.FROM_SITE_SHIPTO_CODE
                             , XA.FROM_SITE_COMPANY_ID
                             , XA.TO_SITE_TYPE
                             , XA.TO_SITE_PLANT_ID
                             , XA.TO_SITE_VENDOR_ID
                             , XA.TO_SITE_SOLDTO_CODE
                             , XA.TO_SITE_SHIPTO_CODE
                             , XA.TO_SITE_COMPANY_ID
                             , XA.BUILDING
                             , XA.REMARK
                             , XA.CUSTOMER_REQ
                             , XA.CHANGE_CODE
                             , XA.CHANGE_CODE_NAME
                             , XA.REQUESTOR
                             , XA.TRANSFER_FLAG
                             , XA.TRANSFER_DATE
                             , XA.CREATED_BY
                             , XA.CREATION_DATE
                             , XA.LAST_UPDATED_BY
                             , XA.LAST_UPDATE_DATE
                             , XA.ATTRIBUTE1
                             , XA.ATTRIBUTE2
                             , XA.ATTRIBUTE3
                             , XA.ATTRIBUTE4
                             , XA.ATTRIBUTE5
                             , XA.ATTRIBUTE6
                             , XA.ATTRIBUTE7
                             , XA.ATTRIBUTE8
                             , XA.ATTRIBUTE9
                             , XA.ATTRIBUTE10
                             /*----------------------------------------------------------------------------------------
                                 2020.06.30 : KBK
                                 I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                             ------------------------------------------------------------------------------------------*/
                             , XC.PACKAGE_TYPE_CODE
                             , XC.FACTORY_ID
                             , CEIL(CASE WHEN XC.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(XA.QTY * NVL(XC.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(XC.BOX_PER_CUT, 1)
                                         WHEN XC.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(XA.QTY * NVL(XC.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(XC.STEELCRATE_PER_CUT, 1)
                                         WHEN XC.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(XA.QTY * NVL(XC.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(XC.STEELRACK_PER_CUT, 1)
                                    ELSE NVL(XA.QTY, 0) END) AS PACKAGE_QTY
                             , XC.DOM_EXP_TYPE AS DOM_EXP
                          FROM (SELECT V_INFSEQNO AS IFSEQNO                    /* IFSEQNO */
                                     , SA.CONFIRM_ID
                                     , 'A' AS SHIPMENT_STATUS                   /* I_PLGB  A: 확정 */
                                     , V_LAST_CONFIRM_DATE AS LAST_CONFIRM_DATE /* I_DATE  확정구간 마지막 일자 */
                                     , 'B' AS VERSION_TYPE                      /* B:NEW/A:OLD */
                                     , NVL(SC.ATTRIBUTE2, SB.ATTRIBUTE2) AS SALES_COMPANY_ID
                                     , CASE WHEN SA.DIVISION_ID = 'EE' THEN SA.ORIGIN_FROM_DIVISION_ID ELSE SA.DIVISION_ID END AS DIVISION_ID
                                     , SA.ITEM_ID AS ITEM_ID
                                     , SA.FROM_SITE
                                     , SA.TO_SITE
                                     , SA.YYYYMMDD
                                     , SA.QTY
                                     , SA.BOD_ID
                                     , SA.ROUTE_ID
                                     , SA.BIZ_TYPE AS OPERATION_GROUP
                                     , SA.BIZ_TYPE
                                     , CASE WHEN SA.PROJECT_CODE IS NULL OR SA.PROJECT_CODE = '-' THEN 'TBD' ELSE SA.PROJECT_CODE END AS PROJECT_CODE
                                     , SA.FCST_TYPE
                                     , SA.FCST_ETD_DATE
                                     , SA.FCST_ETA_DATE
                                     , SA.ETD_DATE
                                     , SA.ETA_DATE
                                     , SA.INCOTERMS AS INCOTERMS
                                     , NULL AS INCOTERMS2
                                     , SA.TRANSPORT_MODE
                                     , SA.D_COUNTRY
                                     , SA.D_PORT_CODE
                                     , SA.A_COUNTRY
                                     , SA.A_PORT_CODE
                                     , SA.CUSTOMER_LT
                                     , SA.TO_COUNTRY
                                     , SA.TO_CITY
                                     , SA.FROM_SITE_TYPE
                                     , SA.FROM_SITE_PLANT_ID
                                     , SA.FROM_SITE_VENDOR_ID
                                     , SA.FROM_SITE_SOLDTO_CODE
                                     , SA.FROM_SITE_SHIPTO_CODE
                                     , SA.FROM_SITE_COMPANY_ID
                                     , SA.TO_SITE_TYPE
                                     , SA.TO_SITE_PLANT_ID
                                     , SA.TO_SITE_VENDOR_ID
                                     , SA.TO_SITE_SOLDTO_CODE
                                     , SA.TO_SITE_SHIPTO_CODE
                                     , SA.TO_SITE_COMPANY_ID
                                     , NULL AS BUILDING
                                     , NULL AS REMARK
                                     , NULL AS CUSTOMER_REQ
                                     , NULL AS CHANGE_CODE
                                     , NULL AS CHANGE_CODE_NAME
                                     , SA.REQUESTOR AS REQUESTOR
                                     , 'N' AS TRANSFER_FLAG
                                     , SYSDATE AS TRANSFER_DATE
                                     , SA.LAST_UPDATED_BY AS CREATED_BY
                                     , SYSDATE AS CREATION_DATE
                                     , SA.LAST_UPDATED_BY AS LAST_UPDATED_BY
                                     , SYSDATE AS LAST_UPDATE_DATE
                                     , NULL AS ATTRIBUTE1
                                     , NULL AS ATTRIBUTE2
                                     , NULL AS ATTRIBUTE3
                                     , NULL AS ATTRIBUTE4
                                     , NULL AS ATTRIBUTE5
                                     , NULL AS ATTRIBUTE6
                                     , NULL AS ATTRIBUTE7
                                     , NULL AS ATTRIBUTE8
                                     , NULL AS ATTRIBUTE9
                                     , SA.ELECTRODE_YN AS ATTRIBUTE10
                                  FROM SSP_ANL_SHIP_CONFIRM SA
                                     , SCM_ADM_LOOKUP_MASTER_DETAIL SB
                                     , SCM_ADM_LOOKUP_MASTER_DETAIL SC
                                 WHERE SB.LOOKUP_TYPE(+) = 'CELL_SHIP_FROM_TO'
                                   AND SB.VALID_YN(+) = 'Y'
                                   AND SB.SEGMENT1(+) = SA.FROM_SITE_COMPANY_ID
                                   AND SB.SEGMENT3(+) = SA.FROM_SITE
                                   AND SB.SEGMENT4(+) = SA.TO_SITE_COMPANY_ID
                                   AND SB.SEGMENT5(+) = SA.TO_SITE
                                   AND SC.LOOKUP_TYPE(+) = 'ELECTRODE_SHIP_FROM_TO'
                                   AND SC.VALID_YN(+) = 'Y'
                                   AND SC.SEGMENT1(+) = SA.FROM_SITE_COMPANY_ID
                                   AND SC.SEGMENT3(+) = SA.FROM_SITE
                                   AND SC.SEGMENT4(+) = SA.TO_SITE_COMPANY_ID
                                   AND SC.ATTRIBUTE1(+) = SA.TO_SITE
                                   AND SA.CONFIRM_ID = V_NEW_CONFIRM_ID
                                   AND NVL(SA.QTY, 0) <> 0) XA                  /* 0은IF 제외 */
                             , SCM_MST_DIVISION XB
                             , SSP_MST_SITE_ITEM_EE_V XC
                         WHERE XA.DIVISION_ID = XB.DIVISION_ID
                           AND XA.DIVISION_ID = (CASE WHEN XA.BIZ_TYPE = 'E' THEN XC.DIVISION_ID(+) ELSE XC.ASSY_DIVISION_ID(+) END)
                           AND XA.FROM_SITE = (CASE WHEN XA.BIZ_TYPE = 'E' THEN XC.SCM_SITE_ID(+) ELSE XC.ASSY_SCM_SITE_ID(+) END)
                           AND XA.ITEM_ID = XC.ITEM_ID(+)) IA
                     , NERP_CONV_MASTER C
                     , NERP_CONV_MASTER D
                     , NERP_CONV_MASTER E
                     , NERP_CONV_MASTER F
                     , NERP_CONV_MASTER G
                     , NERP_CONV_MASTER H
                     , NERP_CONV_MASTER I
                     , NERP_CONV_MASTER J
                     , NERP_CONV_MASTER K
                     , NERP_CONV_MASTER L
                     , NERP_CONV_MASTER M
                     , NERP_CONV_MASTER N
                     , NERP_CONV_MASTER O
                 WHERE C.CODETYPE(+) = 'COMPANY_ID'
                   AND IA.SALES_COMPANY_ID = C.OLD_VALUE1(+)
                   AND D.CODETYPE(+) = 'SCP_SITE_ID'
                   AND IA.FROM_SITE = D.OLD_VALUE1(+)
                   AND E.CODETYPE(+) = 'SCP_SITE_ID'
                   AND IA.TO_SITE = E.OLD_VALUE1(+)
                   AND F.CODETYPE(+) = 'PLANT_ID'
                   AND IA.FROM_SITE_PLANT_ID = F.OLD_VALUE1(+)
                   AND G.CODETYPE(+) = 'VENDOR_ID'
                   AND IA.FROM_SITE_VENDOR_ID = G.OLD_VALUE1(+)
                   AND H.CODETYPE(+) = 'END_CUSTOMER_ID'
                   AND IA.FROM_SITE_SOLDTO_CODE = H.OLD_VALUE1(+)
                   AND I.CODETYPE(+) = 'END_CUSTOMER_ID'
                   AND IA.FROM_SITE_SHIPTO_CODE = I.OLD_VALUE1(+)
                   AND J.CODETYPE(+) = 'COMPANY_ID'
                   AND IA.FROM_SITE_COMPANY_ID = J.OLD_VALUE1(+)
                   AND K.CODETYPE(+) = 'PLANT_ID'
                   AND IA.TO_SITE_PLANT_ID = K.OLD_VALUE1(+)
                   AND L.CODETYPE(+) = 'VENDOR_ID'
                   AND IA.TO_SITE_VENDOR_ID = L.OLD_VALUE1(+)
                   AND M.CODETYPE(+) = 'END_CUSTOMER_ID'
                   AND IA.TO_SITE_SOLDTO_CODE = M.OLD_VALUE1(+)
                   AND N.CODETYPE(+) = 'END_CUSTOMER_ID'
                   AND IA.TO_SITE_SHIPTO_CODE = N.OLD_VALUE1(+)
                   AND O.CODETYPE(+) = 'COMPANY_ID'
                   AND IA.TO_SITE_COMPANY_ID = O.OLD_VALUE1(+);

                PR_DM_SSP_CONFIRM_SYNC(P_DIVISION_ID, V_NEW_CONFIRM_ID);

                IF V_CHK_REQ = 0 THEN

                    SELECT 'R' || TO_CHAR(V_CREATE_DATE, 'YYYYMMDD') || SUBSTR('000000' || TO_CHAR(SEQ1_SSP_ANL_SHIP_CHG_REQ_NO.NEXTVAL), -6)
                      INTO V_MAX_REQ_NO
                      FROM DUAL;

                    BEGIN
                        SELECT DEPT_ID
                          INTO V_USER_DEPT_ID
                          /* 2026.09.30 AJS 수정 (START) */
--                          FROM TB_FX_USER
--                         WHERE USERID = P_USER_ID;
                          FROM SCM_ADM_USER_M
                         WHERE USER_ID = P_USER_ID;
                          /* 2026.09.30 AJS 수정 (END) */
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;

                    BEGIN
                        SELECT ELECTRODE_YN
                             , ELECTRODE_TYPE
                             , ORIGIN_FROM_DIVISION_ID
                             , ORIGIN_TO_DIVISION_ID
                          INTO V_ELECTRODE_YN
                             , V_ELECTRODE_TYPE
                             , V_ORIGIN_FROM_DIVISION_ID
                             , V_ORIGION_TO_DIVISION_ID
                          FROM SSP_ANL_SHIP_CONFIRM
                         WHERE CONFIRM_ID = V_NEW_CONFIRM_ID;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;

                    INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ
                    (
                        CHANGE_REQ_NO
                      , CHANGE_TYPE
                      , CHANGE_REQ_STATUS
                      , DIVISION_ID
                      , FROM_SITE
                      , REQUEST_TITLE
                      , REQUEST_USER
                      , REQUEST_DEPT
                      , REQUEST_TIME
                      , APPROVAL_USER
                      , APPROVAL_DEPT
                      , APPROVAL_TIME
                      , CHANGE_REASON_CODE
                      , CHANGE_REASON_DETAIL
                      , REJECT_REASON
                      , VALID_YN
                      , CREATED_BY
                      , CREATION_DATE
                      , LAST_UPDATED_BY
                      , LAST_UPDATE_DATE
                      , ELECTRODE_YN
                      , ELECTRODE_TYPE
                      , ORIGIN_FROM_DIVISION_ID
                      , ORIGIN_TO_DIVISION_ID
                    )
                    VALUES
                    (
                        V_MAX_REQ_NO
                      , 'A'
                      , 'A'
                      , V_DIVISION_ID
                      , V_FROM_SITE_TEMP
                      , NULL
                      , P_USER_ID
                      , V_USER_DEPT_ID
                      , V_CREATE_DATE
                      , P_USER_ID
                      , V_USER_DEPT_ID
                      , V_CREATE_DATE
                      , NULL
                      , NULL
                      , NULL
                      , 'Y'
                      , P_USER_ID
                      , V_CREATE_DATE
                      , P_USER_ID
                      , V_CREATE_DATE
                      , V_ELECTRODE_YN
                      , V_ELECTRODE_TYPE
                      , V_ORIGIN_FROM_DIVISION_ID
                      , V_ORIGION_TO_DIVISION_ID
                    );

                    INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                    (
                        CHANGE_REQ_NO
                      , CONFIRM_ID
                      , NEW_YN
                      , DIVISION_ID
                      , ITEM_ID
                      , FROM_SITE
                      , TO_SITE
                      , YYYYMMDD
                      , QTY
                      , BOD_ID
                      , ROUTE_ID
                      , BIZ_TYPE
                      , PROJECT_CODE
                      , FCST_TYPE
                      , FCST_ETD_DATE
                      , FCST_ETA_DATE
                      , ETD_DATE
                      , ETA_DATE
                      , INCOTERMS
                      , TRANSPORT_MODE
                      , D_COUNTRY
                      , D_PORT_CODE
                      , A_COUNTRY
                      , A_PORT_CODE
                      , CUSTOMER_LT
                      , TO_COUNTRY
                      , TO_CITY
                      , NEW_YYYYMMDD
                      , NEW_QTY
                      , NEW_BOD_ID
                      , NEW_ROUTE_ID
                      , NEW_ETD_DATE
                      , NEW_ETA_DATE
                      , NEW_INCOTERMS
                      , NEW_TRANSPORT_MODE
                      , NEW_D_COUNTRY
                      , NEW_D_PORT_CODE
                      , NEW_A_COUNTRY
                      , NEW_A_PORT_CODE
                      , NEW_CUSTOMER_LT
                      , NEW_TO_COUNTRY
                      , NEW_TO_CITY
                      , FROM_SITE_TYPE
                      , FROM_SITE_PLANT_ID
                      , FROM_SITE_VENDOR_ID
                      , FROM_SITE_SOLDTO_CODE
                      , FROM_SITE_SHIPTO_CODE
                      , FROM_SITE_COMPANY_ID
                      , TO_SITE_TYPE
                      , TO_SITE_PLANT_ID
                      , TO_SITE_VENDOR_ID
                      , TO_SITE_SOLDTO_CODE
                      , TO_SITE_SHIPTO_CODE
                      , TO_SITE_COMPANY_ID
                      , ERP_SO_NO
                      , ERP_SO_ITEM_NO
                      , ERP_DO_NO
                      , ERP_STATUS
                      , VALID_YN
                      , ATTRIBUTE1
                      , CREATED_BY
                      , CREATION_DATE
                      , LAST_UPDATED_BY
                      , LAST_UPDATE_DATE
                      , ELECTRODE_YN
                      , ELECTRODE_TYPE
                      , ORIGIN_FROM_DIVISION_ID
                      , ORIGIN_TO_DIVISION_ID
                      , REMARKS
                      , REMARKS2
                      , REMARKS3
                      , REQUESTOR
                      , ATTRIBUTE2
                    )
                    SELECT V_MAX_REQ_NO AS CHANGE_REQ_NO
                         , CONFIRM_ID
                         , 'Y' AS NEW_YN
                         , DIVISION_ID
                         , ITEM_ID
                         , FROM_SITE
                         , TO_SITE
                         , YYYYMMDD
                         , QTY
                         , BOD_ID
                         , ROUTE_ID
                         , BIZ_TYPE
                         , PROJECT_CODE
                         , FCST_TYPE
                         , FCST_ETD_DATE
                         , FCST_ETA_DATE
                         , ETD_DATE
                         , ETA_DATE
                         , INCOTERMS
                         , TRANSPORT_MODE
                         , D_COUNTRY
                         , D_PORT_CODE
                         , A_COUNTRY
                         , A_PORT_CODE
                         , CUSTOMER_LT
                         , TO_COUNTRY
                         , TO_CITY
                         , V_SHIPMENT_DATE AS NEW_YYYYMMDD
                         , TO_NUMBER(V_SHIPMENT_QTY) AS NEW_QTY
                         , V_NEW_BOD_ID_TEMP AS NEW_BOD_ID
                         , V_NEW_ROUTE_ID_TEMP AS NEW_ROUTE_ID
                         , V_NEW_ETD_DATE AS NEW_ETD_DATE
                         , V_NEW_ETA_DATE AS NEW_ETA_DATE
                         , V_NEW_INCOTERMS AS NEW_INCOTERMS
                         , V_NEW_TRANSPORT_MODE AS NEW_TRANSPORT_MODE
                         , V_NEW_D_CONTRY AS NEW_D_COUNTRY
                         , V_NEW_D_PORT_CODE_TEMP AS NEW_D_PORT_CODE
                         , V_NEW_A_COUNTRY_TEMP AS NEW_A_COUNTRY
                         , V_NEW_A_PORT_CODE_TEMP AS NEW_A_PORT_CODE
                         , TO_NUMBER(V_NEW_CUSTOMER_LT_TEMP) AS NEW_CUSTOMER_LT
                         , V_NEW_TO_COUNTRY_TEMP AS NEW_TO_COUNTRY
                         , V_NEW_TO_CITY_TEMP AS NEW_TO_CITY
                         , FROM_SITE_TYPE
                         , FROM_SITE_PLANT_ID
                         , FROM_SITE_VENDOR_ID
                         , FROM_SITE_SOLDTO_CODE
                         , FROM_SITE_SHIPTO_CODE
                         , FROM_SITE_COMPANY_ID
                         , TO_SITE_TYPE
                         , TO_SITE_PLANT_ID
                         , TO_SITE_VENDOR_ID
                         , TO_SITE_SOLDTO_CODE
                         , TO_SITE_SHIPTO_CODE
                         , TO_SITE_COMPANY_ID
                         , ERP_SO_NO
                         , ERP_SO_ITEM_NO
                         , ERP_DO_NO
                         , ERP_STATUS
                         , 'Y'
                         , 'N'
                         , P_USER_ID AS CREATED_BY
                         , V_CREATE_DATE
                         , P_USER_ID AS LAST_UPDATED_BY
                         , V_CREATE_DATE
                         , ELECTRODE_YN
                         , ELECTRODE_TYPE
                         , ORIGIN_FROM_DIVISION_ID
                         , ORIGIN_TO_DIVISION_ID
                         , V_REMARKS
                         , V_REMARKS2
                         , V_REMARKS3
                         , REQUESTOR
                         , 'A'
                      FROM SSP_ANL_SHIP_CONFIRM
                     WHERE CONFIRM_ID = V_NEW_CONFIRM_ID;

                END IF;

            END IF;                                                             /* V_ACTIVE_FLAG = 'I' END */

        END LOOP;                                                               /* end of while loop */

        IF LENGTH(RTRIM(V_CONFIRM_ID)) > 0 THEN

            BEGIN
                SELECT SEGMENT1                                                 /* company id */
                  INTO V_WA_COMPANY_ID
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE = 'SSP_PLN_FP_SHIP_TARGET_WA'
                   AND VALID_YN = 'Y';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_WA_COMPANY_ID := NULL;
            END;

            BEGIN
                SELECT FROM_SITE_COMPANY_ID
                  INTO V_CFM_COMPANY_ID
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE CONFIRM_ID = V_CONFIRM_ID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_CFM_COMPANY_ID := NULL;
            END;

            IF V_WA_COMPANY_ID = V_CFM_COMPANY_ID THEN
                PR_SSP_PLN_FP_SHIP_TARGET_WA;
            END IF;

        END IF;

        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR
            SELECT 'S' AS RESULT_CODE
                 , V_MAX_LOOP_CNT AS RESULT_CNT
                 , NVL(V_CHANGE_REQ_NO, '') AS CHANGE_REQ_NO
              FROM DUAL;

        OPEN O_RC2 FOR
            SELECT NULL AS ERR_MESSAGE
              FROM DUAL
             WHERE 1 = 2;

        PR_DM_SSP_CONFIRM_SYNC(P_DIVISION_ID, P_CONFIRM_ID);

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_MSG := SQLERRM;
            V_ERR_CODE := SQLCODE;

            BEGIN
                ROLLBACK TO SP_SAVE_CONFIRM;
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;                                                       /* 되돌림 지점을 잡기 전에 난 오류 */
            END;

            INSERT INTO SCM_SYS_LOG_BATCH
            (
                PROGRAM_NAME
              , LOG_TYPE
              , LOG_COUNT
              , LOG_MESSAGE
              , DESCRIPTION
              , EVENT_DATE
              , CREATION_DATE
              , CREATED_BY
              , LAST_UPDATE_DATE
              , LAST_UPDATED_BY
            )
            VALUES
            (
                V_PROGRAM_NAME
              , 'ERROR'
              , NULL
              , V_ERR_MSG
              , NULL
              , SYSDATE
              , SYSDATE
              , V_PROGRAM_NAME
              , SYSDATE
              , V_PROGRAM_NAME
            );

            /* error코드, errror 메시지 반환 */
            OPEN O_RC1 FOR
                SELECT 'F' AS RESULT_CODE
                     , NULL AS RESULT_CNT
                     , NULL AS CHANGE_REQ_NO
                  FROM DUAL;

            OPEN O_RC2 FOR
                SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MSG AS ERR_MESSAGE
                  FROM DUAL;

    END P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM;

END PKG_SSP0021;
/
SHOW ERRORS PACKAGE BODY PKG_SSP0021
